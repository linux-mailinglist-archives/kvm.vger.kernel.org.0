Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A2923B967
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 13:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgHDLOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 07:14:37 -0400
Received: from foss.arm.com ([217.140.110.172]:42754 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbgHDLMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 07:12:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BEAC30E;
        Tue,  4 Aug 2020 04:12:36 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4024F3F6CF;
        Tue,  4 Aug 2020 04:12:35 -0700 (PDT)
Subject: Re: [PATCH kvmtool] virtio: Fix ordering of
 virt_queue__should_signal()
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     kvm@vger.kernel.org, milon@wq.cz, julien.thierry.kdev@gmail.com,
        will@kernel.org, andre.przywara@arm.com,
        Anvay Virkar <anvay.virkar@arm.com>
References: <20200731101427.16284-1-alexandru.elisei@arm.com>
 <20200731133050.GB2486217@myrica>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4adb4400-40b0-4fe0-e4ee-fe278db42841@arm.com>
Date:   Tue, 4 Aug 2020 12:13:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731133050.GB2486217@myrica>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jean,

Thank you for taking the time to review the patch.

On 7/31/20 2:30 PM, Jean-Philippe Brucker wrote:
> On Fri, Jul 31, 2020 at 11:14:27AM +0100, Alexandru Elisei wrote:
>> The guest programs used_event in the avail queue to let the host know when
>                                  nit: "avail ring"...
>
>> it wants a notification from the device. The host notifies the guest when
>> the used queue vring index passes used_event.
> ... and "used ring" are more consistent with the virtio spec.

Will fix.

>
>> The virtio-blk guest driver, in the notification callback, sets used_event
>> to the value of the current used queue vring index, which means it will get
>> a notification after the next buffer is consumed by the host. It is
>> possible for the guest to submit a job, and then go into uninterruptible
>> sleep waiting for the notification (for example, via submit_bio_wait()).
>>
>> On the host side, the virtio-blk device increments the used queue vring
>> index, then compares it to used_event to decide if a notification should be
>> sent.
>>
>> A memory barrier between writing the new index value and reading used_event
>> is needed to make sure we read the latest used_event value.  kvmtool uses a
>> write memory barrier, which on arm64 translates into DMB ISHST. The
>> instruction orders memory writes that have been executed in program order
>> before the barrier relative to writes that have been executed in program
>> order after the barrier.
> Not sure this sentence is necessary.
>
>> The barrier doesn't apply to reads, which means it
>> is not enough to prevent reading a stale value for used_event. This can
>> lead to the host not sending the notification, and the guest thread remains
>> stuck indefinitely waiting for IO to complete.
> It might be helpful to detail what the guest does, to identify which
> barrier this pairs with on the guest side. I had a hard time convincing
> myself that this is the right fix, but I think I got there in the end.
>
> Kvmtool currently does:
>
> 	// virt_queue__used_idx_advance()
> 		vring.used.idx = idx
> 		wmb()
> 	// virtio_queue__should_signal()
> 	if (vring.used_event is between old and new idx)
> 		notify()
>
> When simplifying Linux virtblk_done() I get:
>
> 	while (last_used != vring.used.idx) {
> 		...
> 		vring.used_event = ++last_used
> 		mb() // virtio_store_mb() in virtqueue_get_buf_ctx_split()
> 		...
> 		// unnecessary write+mb, here for completeness
> 		vring.used_event = last_used
> 		mb() // virtqueue_poll()
> 	}
>
> (1) Kvmtool:
>     writes vring.used.idx = 2
>     wmb()
>     reads vring.used_event = 1
>     notifies the guest.
>
> (2) Linux:
>     (reads vring.used.idx = 2)
>     writes vring.used_event = 2
>     mb()
>     reads vring.used.idx = 2
>     returns from virtblk_done()
>
> (3) Kvmtool:
>     writes vring.used.idx = 3
>     wmb()
>     reads vring.used_event = 1
>     doesn't notify, stalls the guest.
>
> By replacing the wmb() with a full barrier we get the correct store buffer
> pattern (SB+fencembonceonces.litmus).

Yes, sb+fencemboneonces.litmus pattern is what kvmtool should implement, and the
pattern that is triggering the stall is when both threads read the initial values,
which should be forbidden. I'll update the commit message with a better
description of what is going on.

>
>> Using a memory barrier for reads and writes matches what the guest driver
>> does when deciding to kick the host: after updating the avail queue vring
>> index via virtio_queue_rq() -> virtblk_add_req() -> .. ->
> Probably worth noting you're referring to Linux here.
>
>> virtqueue_add_split(), it uses a read/write memory barrier before reading
>                                 or "full" memory barrier?

I was using the Arm ARM terminology, which doesn't have a "full memory barrier",
but instead uses either a full system memory barrier (SY) wrt to the shareability
domain or a read/write memory barrier wrt to access type. I'll use the Linux
terminology, I suppose that makes more sense for everyone.

>
>> avail_event from the used queue in virtio_commit_rqs() -> .. ->
>> virtqueue_kick_prepare_split().
>>
>> Also move the barrier in virt_queue__should_signal(), because the barrier
>> is needed for notifications to work correctly, and it makes more sense to
>> have it in the function that determines if the host should notify the
>> guest.
>>
>> Reported-by: Anvay Virkar <anvay.virkar@arm.com>
>> Suggested-by: Anvay Virkar <anvay.virkar@arm.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Regardless of the nits above, I believe this patch is correct
>
> Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

I'll try to write a better commit message, thank you for the review and suggestions.

Thanks,
Alex
>
>> ---
>> This was observed by Anvay, where kvmtool reads the previous value of
>> used_event and the notification is not sent.
>>
>> I *think* this also fixes the VM hang reported in [1], where several
>> processes in the guest were stuck in uninterruptible sleep. I am not
>> familiar with the block layer, but my theory is that the threads were stuck
>> in wait_for_completion_io(), from blk_execute_rq() executing a flush
>> request. It would be great if Milan could give this patch a spin and see if
>> the problem goes away. Don't know how reproducible it is though.
>>
>> [1] https://www.spinics.net/lists/kvm/msg204543.html
>>
>>  virtio/core.c | 15 ++++++++-------
>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/virtio/core.c b/virtio/core.c
>> index f5b3c07fc100..90a661d12e14 100644
>> --- a/virtio/core.c
>> +++ b/virtio/core.c
>> @@ -33,13 +33,6 @@ void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
>>  	wmb();
>>  	idx += jump;
>>  	queue->vring.used->idx = virtio_host_to_guest_u16(queue, idx);
>> -
>> -	/*
>> -	 * Use wmb to assure used idx has been increased before we signal the guest.
>> -	 * Without a wmb here the guest may ignore the queue since it won't see
>> -	 * an updated idx.
>> -	 */
>> -	wmb();
>>  }
>>  
>>  struct vring_used_elem *
>> @@ -194,6 +187,14 @@ bool virtio_queue__should_signal(struct virt_queue *vq)
>>  {
>>  	u16 old_idx, new_idx, event_idx;
>>  
>> +	/*
>> +	 * Use mb to assure used idx has been increased before we signal the
>> +	 * guest, and we don't read a stale value for used_event. Without a mb
>> +	 * here we might not send a notification that we need to send, or the
>> +	 * guest may ignore the queue since it won't see an updated idx.
>> +	 */
>> +	mb();
>> +
>>  	if (!vq->use_event_idx) {
>>  		/*
>>  		 * When VIRTIO_RING_F_EVENT_IDX isn't negotiated, interrupt the
>> -- 
>> 2.28.0
>>
