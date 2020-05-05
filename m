Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD96C1C5148
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 10:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgEEIvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 04:51:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29109 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbgEEIvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 04:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588668697;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mYcKaiDdx5xyxyLMrz7cwsZz18pzP6X4gEIbfANKmVE=;
        b=e5+wwUj5YNTHSPqe0FtRzXyut7D7OZ8yqblBq/vRZKw8hgCyG+N4M05SHTMRn5/UOVNt3u
        zx9RMWWJ+m2fUg333tiJ4iJOnETT5vmQQ/Yt4CQyMsQAUjWEWCYfZ+PVnFl+YiTt0Ec/+k
        sRW0NWB4mnHF6PqGruwGuLB5F68b4TI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-BRKyBttyOQW3sCgSzBHjIg-1; Tue, 05 May 2020 04:51:33 -0400
X-MC-Unique: BRKyBttyOQW3sCgSzBHjIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B22591899521;
        Tue,  5 May 2020 08:51:31 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-132.bne.redhat.com [10.64.54.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32CA164421;
        Tue,  5 May 2020 08:51:26 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-5-vkuznets@redhat.com>
 <bdd3fba1-72d6-9096-e63d-a89f2990a26d@redhat.com>
 <87y2q6dcfm.fsf@vitty.brq.redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <f7e76889-a8fc-a348-90c2-2c27f3706585@redhat.com>
Date:   Tue, 5 May 2020 18:51:23 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87y2q6dcfm.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 5/5/20 6:16 PM, Vitaly Kuznetsov wrote:
>> On 4/29/20 7:36 PM, Vitaly Kuznetsov wrote:
>>> If two page ready notifications happen back to back the second one is not
>>> delivered and the only mechanism we currently have is
>>> kvm_check_async_pf_completion() check in vcpu_run() loop. The check will
>>> only be performed with the next vmexit when it happens and in some cases
>>> it may take a while. With interrupt based page ready notification delivery
>>> the situation is even worse: unlike exceptions, interrupts are not handled
>>> immediately so we must check if the slot is empty. This is slow and
>>> unnecessary. Introduce dedicated MSR_KVM_ASYNC_PF_ACK MSR to communicate
>>> the fact that the slot is free and host should check its notification
>>> queue. Mandate using it for interrupt based type 2 APF event delivery.
>>>
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>>    Documentation/virt/kvm/msr.rst       | 16 +++++++++++++++-
>>>    arch/x86/include/uapi/asm/kvm_para.h |  1 +
>>>    arch/x86/kvm/x86.c                   |  9 ++++++++-
>>>    3 files changed, 24 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
>>> index 7433e55f7184..18db3448db06 100644
>>> --- a/Documentation/virt/kvm/msr.rst
>>> +++ b/Documentation/virt/kvm/msr.rst
>>> @@ -219,6 +219,11 @@ data:
>>>    	If during pagefault APF reason is 0 it means that this is regular
>>>    	page fault.
>>>    
>>> +	For interrupt based delivery, guest has to write '1' to
>>> +	MSR_KVM_ASYNC_PF_ACK every time it clears reason in the shared
>>> +	'struct kvm_vcpu_pv_apf_data', this forces KVM to re-scan its
>>> +	queue and deliver next pending notification.
>>> +
>>>    	During delivery of type 1 APF cr2 contains a token that will
>>>    	be used to notify a guest when missing page becomes
>>>    	available. When page becomes available type 2 APF is sent with
>>> @@ -340,4 +345,13 @@ data:
>>>    
>>>    	To switch to interrupt based delivery of type 2 APF events guests
>>>    	are supposed to enable asynchronous page faults and set bit 3 in
>>> -	MSR_KVM_ASYNC_PF_EN first.
>>> +
>>> +MSR_KVM_ASYNC_PF_ACK:
>>> +	0x4b564d07
>>> +
>>> +data:
>>> +	Asynchronous page fault acknowledgment. When the guest is done
>>> +	processing type 2 APF event and 'reason' field in 'struct
>>> +	kvm_vcpu_pv_apf_data' is cleared it is supposed to write '1' to
>>> +	Bit 0 of the MSR, this caused the host to re-scan its queue and
>>> +	check if there are more notifications pending.
>>
>> I'm not sure if I understood the usage of MSR_KVM_ASYNC_PF_ACK
>> completely. It seems it's used to trapped to host, to have chance
>> to check/deliver pending page ready events. If there is no pending
>> events, no work will be finished in the trap. If it's true, it might
>> be good idea to trap conditionally, meaning writing to ASYNC_PF_ACK
>> if there are really pending events?
> 
> How does the guest know if host has any pending events or not?
> 

One way would be through struct kvm_vcpu_pv_apf_data, which is visible
to host and guest. In the host, the workers that have completed their
work (GUP) are queued into vcpu->async_pf.done. So we need a bit in
struct kvm_vcpu_pv_apf_data, written by host while read by guest to
see if there pending work. I even don't think the writer/reader need
to be synchronized.

> The problem we're trying to address with ACK msr is the following:
> imagine host has two 'page ready' notifications back to back. It puts
> token for the first on in the slot and raises an IRQ but how do we know
> when the slot becomes free so we can inject the second one? Currently,
> we have kvm_check_async_pf_completion() check in vcpu_run() loop but
> this doesn't guarantee timely delivery of the event, we just hope that
> there's going to be a vmexit 'some time soon' and we'll piggy back onto
> that. Normally this works but in some special cases it may take really
> long before a vmexit happens. Also, we're penalizing each vmexit with an
> unneeded check. ACK msr is intended to solve these issues.
> 

Thanks for the explanation. I think vmexit frequency is somewhat proportional
to the workload, meaning more vmexit would be observed if the VM has more
workload. The async page fault is part of the workload. I agree it makes sense
to proactively poke the pending events ('page ready'), but it would be reasonable
to do so conditionally, to avoid overhead. However, I'm not sure how much overhead
it would have on x86 :)

Thanks,
Gavin

