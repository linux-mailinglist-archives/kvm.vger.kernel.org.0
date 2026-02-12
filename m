Return-Path: <kvm+bounces-70899-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sNbMHwUbjWmkzAAAu9opvQ
	(envelope-from <kvm+bounces-70899-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 01:12:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA7F128728
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 01:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0BCAD3025C49
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 00:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6808DF50F;
	Thu, 12 Feb 2026 00:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="hNSo4xez"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CDD4A21;
	Thu, 12 Feb 2026 00:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770855166; cv=none; b=XZQGGg9ODxpS0g/MlAFIbIMpTx/czLIsFufGe95kvaJJLbPIJ0cNoOyqI3srGhnof4hw6Tyz40ca4SdwDmJvCklI4UKQcMrf4jYdhqrj6WrovzV2SlswfcpLBJgDcf87R5FGAh5s0fHKDOMyNGqCaOMly6QBmaT+t0H5PJ4uZAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770855166; c=relaxed/simple;
	bh=PSokEurgupwuMyRdMXzVRYxvFrD8cbgBjwugoUjvwsc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YreKwMcTQlzLM7Eg1/asfVJdNWs+Xfs6yqKTabMIrqs+yqBDNbyENMB0AgGRU6cqJyzLXz3ekmOIVl9RSREvsuQn4L+NsvF+8yEWd1MkVQ4+CYFg38CM8UsF6kLNJwCsO2qHy8gRFoec8hMEYUiivqgfrQ9rJ+eiHgRwqklXjkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=hNSo4xez; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.70.77] (pd95c968e.dip0.t-ipconnect.de [217.92.150.142])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 61C0CRj1009646
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 01:12:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1770855150;
	bh=PSokEurgupwuMyRdMXzVRYxvFrD8cbgBjwugoUjvwsc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=hNSo4xezibGAYalnWrBHqjm5FD6k7vYuSdeMCll1dtRWc6D868Bc7f2HVFcc2xOhm
	 INadQnB49Zygz7jdBxd0W4MUAJ9aVGm3Kp8VLYatO8XjzeO+ObHhX7IFnJEnIc3HjU
	 01KiHSDixtd89dH6G7gi7KinHhROVYjViBaRpfDM=
Message-ID: <60157111-219d-4fb3-a01a-6df9a83eae7e@tu-dortmund.de>
Date: Thu, 12 Feb 2026 01:12:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper with
 netdev queue wakeup
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <CACGkMEsJKeEsH=G8H5RzMNHY4g3HNdciMDMhciShawh-9Xb9hg@mail.gmail.com>
 <bc1078e5-65fc-4de6-8475-517f626d8d96@tu-dortmund.de>
 <3a1d6232-efe4-4e79-a196-44794fdc0f33@tu-dortmund.de>
 <CACGkMEv71kn91FPAUrxJg=YB3+B0MRTgOidMPHjK7Qq0WEhGtw@mail.gmail.com>
 <260f48cd-caa1-4684-a235-8e1192722b3a@tu-dortmund.de>
 <CACGkMEsVMz+vS3KxykYBGXvyt3MZcstnYWUiYJZhLSMoHC5Smw@mail.gmail.com>
 <ba17ba38-9f61-4a10-b375-d0da805e6b73@tu-dortmund.de>
 <CACGkMEtnLw2b8iDysQzRbXxTj2xbgzKqEZUbhmZz9tXPLTE6Sw@mail.gmail.com>
 <0ebc00ba-35e7-4570-a44f-b0ae634f2316@tu-dortmund.de>
 <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
 <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
 <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
 <CACGkMEte=LwvkxPh-tesJHLVYQV1YZF4is1Yamokhkzaf5GOWw@mail.gmail.com>
 <205aa139-975d-4092-aa04-a2c570ae43a6@tu-dortmund.de>
Content-Language: en-US
In-Reply-To: <205aa139-975d-4092-aa04-a2c570ae43a6@tu-dortmund.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[tu-dortmund.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[tu-dortmund.de:s=unimail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70899-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,redhat.com,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_PROHIBIT(0.00)[0.0.0.0:email];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[simon.schippers@tu-dortmund.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[tu-dortmund.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,pktgen_sample02_multiqueue.sh:url,pktgen_sample03_burst_single_flow.sh:url]
X-Rspamd-Queue-Id: CAA7F128728
X-Rspamd-Action: no action

On 2/8/26 19:18, Simon Schippers wrote:
> On 2/6/26 04:21, Jason Wang wrote:
>> On Fri, Feb 6, 2026 at 6:28 AM Simon Schippers
>> <simon.schippers@tu-dortmund.de> wrote:
>>>
>>> On 2/5/26 04:59, Jason Wang wrote:
>>>> On Wed, Feb 4, 2026 at 11:44 PM Simon Schippers
>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>
>>>>> On 2/3/26 04:48, Jason Wang wrote:
>>>>>> On Mon, Feb 2, 2026 at 4:19 AM Simon Schippers
>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>
>>>>>>> On 1/30/26 02:51, Jason Wang wrote:
>>>>>>>> On Thu, Jan 29, 2026 at 5:25 PM Simon Schippers
>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>
>>>>>>>>> On 1/29/26 02:14, Jason Wang wrote:
>>>>>>>>>> On Wed, Jan 28, 2026 at 3:54 PM Simon Schippers
>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>
>>>>>>>>>>> On 1/28/26 08:03, Jason Wang wrote:
>>>>>>>>>>>> On Wed, Jan 28, 2026 at 12:48 AM Simon Schippers
>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 1/23/26 10:54, Simon Schippers wrote:
>>>>>>>>>>>>>> On 1/23/26 04:05, Jason Wang wrote:
>>>>>>>>>>>>>>> On Thu, Jan 22, 2026 at 1:35 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> On Wed, Jan 21, 2026 at 5:33 PM Simon Schippers
>>>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> On 1/9/26 07:02, Jason Wang wrote:
>>>>>>>>>>>>>>>>>> On Thu, Jan 8, 2026 at 3:41 PM Simon Schippers
>>>>>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> On 1/8/26 04:38, Jason Wang wrote:
>>>>>>>>>>>>>>>>>>>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
>>>>>>>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_consume()
>>>>>>>>>>>>>>>>>>>>> and wake the corresponding netdev subqueue when consuming an entry frees
>>>>>>>>>>>>>>>>>>>>> space in the underlying ptr_ring.
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> Stopping of the netdev queue when the ptr_ring is full will be introduced
>>>>>>>>>>>>>>>>>>>>> in an upcoming commit.
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>>>>>>>>>>>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>>>>>>>>>>>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
>>>>>>>>>>>>>>>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
>>>>>>>>>>>>>>>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>>>>>>>>>>>>>>>>>>>> index 1197f245e873..2442cf7ac385 100644
>>>>>>>>>>>>>>>>>>>>> --- a/drivers/net/tap.c
>>>>>>>>>>>>>>>>>>>>> +++ b/drivers/net/tap.c
>>>>>>>>>>>>>>>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>>>>>>>>>>>>>>>>>>>>         return ret ? ret : total;
>>>>>>>>>>>>>>>>>>>>>  }
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
>>>>>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>>>>>> +       struct ptr_ring *ring = &q->ring;
>>>>>>>>>>>>>>>>>>>>> +       struct net_device *dev;
>>>>>>>>>>>>>>>>>>>>> +       void *ptr;
>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>> +       ptr = __ptr_ring_consume(ring);
>>>>>>>>>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>>>>>>>>>>>>>>>>>>> +               rcu_read_lock();
>>>>>>>>>>>>>>>>>>>>> +               dev = rcu_dereference(q->tap)->dev;
>>>>>>>>>>>>>>>>>>>>> +               netif_wake_subqueue(dev, q->queue_index);
>>>>>>>>>>>>>>>>>>>>> +               rcu_read_unlock();
>>>>>>>>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>> +       spin_unlock(&ring->consumer_lock);
>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>> +       return ptr;
>>>>>>>>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>>>>>>>>>>>>>>>>                            struct iov_iter *to,
>>>>>>>>>>>>>>>>>>>>>                            int noblock, struct sk_buff *skb)
>>>>>>>>>>>>>>>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>>>>>>>>>>>>>>>>                                         TASK_INTERRUPTIBLE);
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>                 /* Read frames from the queue */
>>>>>>>>>>>>>>>>>>>>> -               skb = ptr_ring_consume(&q->ring);
>>>>>>>>>>>>>>>>>>>>> +               skb = tap_ring_consume(q);
>>>>>>>>>>>>>>>>>>>>>                 if (skb)
>>>>>>>>>>>>>>>>>>>>>                         break;
>>>>>>>>>>>>>>>>>>>>>                 if (noblock) {
>>>>>>>>>>>>>>>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>>>>>>>>>>>>>>>>>> index 8192740357a0..7148f9a844a4 100644
>>>>>>>>>>>>>>>>>>>>> --- a/drivers/net/tun.c
>>>>>>>>>>>>>>>>>>>>> +++ b/drivers/net/tun.c
>>>>>>>>>>>>>>>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>>>>>>>>>>>>>>>>>>>         return total;
>>>>>>>>>>>>>>>>>>>>>  }
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
>>>>>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>>>>>> +       struct ptr_ring *ring = &tfile->tx_ring;
>>>>>>>>>>>>>>>>>>>>> +       struct net_device *dev;
>>>>>>>>>>>>>>>>>>>>> +       void *ptr;
>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>> +       ptr = __ptr_ring_consume(ring);
>>>>>>>>>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> I guess it's the "bug" I mentioned in the previous patch that leads to
>>>>>>>>>>>>>>>>>>>> the check of __ptr_ring_consume_created_space() here. If it's true,
>>>>>>>>>>>>>>>>>>>> another call to tweak the current API.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> +               rcu_read_lock();
>>>>>>>>>>>>>>>>>>>>> +               dev = rcu_dereference(tfile->tun)->dev;
>>>>>>>>>>>>>>>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_index);
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> This would cause the producer TX_SOFTIRQ to run on the same cpu which
>>>>>>>>>>>>>>>>>>>> I'm not sure is what we want.
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> What else would you suggest calling to wake the queue?
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> I don't have a good method in my mind, just want to point out its implications.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I have to admit I'm a bit stuck at this point, particularly with this
>>>>>>>>>>>>>>>>> aspect.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> What is the correct way to pass the producer CPU ID to the consumer?
>>>>>>>>>>>>>>>>> Would it make sense to store smp_processor_id() in the tfile inside
>>>>>>>>>>>>>>>>> tun_net_xmit(), or should it instead be stored in the skb (similar to the
>>>>>>>>>>>>>>>>> XDP bit)? In the latter case, my concern is that this information may
>>>>>>>>>>>>>>>>> already be significantly outdated by the time it is used.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Based on that, my idea would be for the consumer to wake the producer by
>>>>>>>>>>>>>>>>> invoking a new function (e.g., tun_wake_queue()) on the producer CPU via
>>>>>>>>>>>>>>>>> smp_call_function_single().
>>>>>>>>>>>>>>>>> Is this a reasonable approach?
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> I'm not sure but it would introduce costs like IPI.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> More generally, would triggering TX_SOFTIRQ on the consumer CPU be
>>>>>>>>>>>>>>>>> considered a deal-breaker for the patch set?
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> It depends on whether or not it has effects on the performance.
>>>>>>>>>>>>>>>> Especially when vhost is pinned.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I meant we can benchmark to see the impact. For example, pin vhost to
>>>>>>>>>>>>>>> a specific CPU and the try to see the impact of the TX_SOFTIRQ.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Thanks
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I ran benchmarks with vhost pinned to CPU 0 using taskset -p -c 0 ...
>>>>>>>>>>>>>> for both the stock and patched versions. The benchmarks were run with
>>>>>>>>>>>>>> the full patch series applied, since testing only patches 1-3 would not
>>>>>>>>>>>>>> be meaningful - the queue is never stopped in that case, so no
>>>>>>>>>>>>>> TX_SOFTIRQ is triggered.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Compared to the non-pinned CPU benchmarks in the cover letter,
>>>>>>>>>>>>>> performance is lower for pktgen with a single thread but higher with
>>>>>>>>>>>>>> four threads. The results show no regression for the patched version,
>>>>>>>>>>>>>> with even slight performance improvements observed:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +-------------------------+-----------+----------------+
>>>>>>>>>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
>>>>>>>>>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
>>>>>>>>>>>>>> | 100M packets            |           |                |
>>>>>>>>>>>>>> | vhost pinned to core 0  |           |                |
>>>>>>>>>>>>>> +-----------+-------------+-----------+----------------+
>>>>>>>>>>>>>> | TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
>>>>>>>>>>>>>> |  +        +-------------+-----------+----------------+
>>>>>>>>>>>>>> | vhost-net | Lost        | 1154 Kpps | 0              |
>>>>>>>>>>>>>> +-----------+-------------+-----------+----------------+
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +-------------------------+-----------+----------------+
>>>>>>>>>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
>>>>>>>>>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
>>>>>>>>>>>>>> | 100M packets            |           |                |
>>>>>>>>>>>>>> | vhost pinned to core 0  |           |                |
>>>>>>>>>>>>>> | *4 threads*             |           |                |
>>>>>>>>>>>>>> +-----------+-------------+-----------+----------------+
>>>>>>>>>>>>>> | TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
>>>>>>>>>>>>>> |  +        +-------------+-----------+----------------+
>>>>>>>>>>>>>> | vhost-net | Lost        | 1527 Kpps | 0              |
>>>>>>>>>>>>>> +-----------+-------------+-----------+----------------+
>>>>>>>>>>>>
>>>>>>>>>>>> The PPS seems to be low. I'd suggest using testpmd (rxonly) mode in
>>>>>>>>>>>> the guest or an xdp program that did XDP_DROP in the guest.
>>>>>>>>>>>
>>>>>>>>>>> I forgot to mention that these PPS values are per thread.
>>>>>>>>>>> So overall we have 71 Kpps * 4 = 284 Kpps and 79 Kpps * 4 = 326 Kpps,
>>>>>>>>>>> respectively. For packet loss, that comes out to 1154 Kpps * 4 =
>>>>>>>>>>> 4616 Kpps and 0, respectively.
>>>>>>>>>>>
>>>>>>>>>>> Sorry about that!
>>>>>>>>>>>
>>>>>>>>>>> The pktgen benchmarks with a single thread look fine, right?
>>>>>>>>>>
>>>>>>>>>> Still looks very low. E.g I just have a run of pktgen (using
>>>>>>>>>> pktgen_sample03_burst_single_flow.sh) without a XDP_DROP in the guest,
>>>>>>>>>> I can get 1Mpps.
>>>>>>>>>
>>>>>>>>> Keep in mind that I am using an older CPU (i5-6300HQ). For the
>>>>>>>>> single-threaded tests I always used pktgen_sample01_simple.sh, and for
>>>>>>>>> the multi-threaded tests I always used pktgen_sample02_multiqueue.sh.
>>>>>>>>>
>>>>>>>>> Using pktgen_sample03_burst_single_flow.sh as you did fails for me (even
>>>>>>>>> though the same parameters work fine for sample01 and sample02):
>>>>>>>>>
>>>>>>>>> samples/pktgen/pktgen_sample03_burst_single_flow.sh -i tap0 -m
>>>>>>>>> 52:54:00:12:34:56 -d 10.0.0.2 -n 100000000
>>>>>>>>> /samples/pktgen/functions.sh: line 79: echo: write error: Operation not
>>>>>>>>> supported
>>>>>>>>> ERROR: Write error(1) occurred
>>>>>>>>> cmd: "burst 32 > /proc/net/pktgen/tap0@0"
>>>>>>>>>
>>>>>>>>> ...and I do not know what I am doing wrong, even after looking at
>>>>>>>>> Documentation/networking/pktgen.rst. Every burst size except 1 fails.
>>>>>>>>> Any clues?
>>>>>>>>
>>>>>>>> Please use -b 0, and I'm Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz.
>>>>>>>
>>>>>>> I tried using "-b 0", and while it worked, there was no noticeable
>>>>>>> performance improvement.
>>>>>>>
>>>>>>>>
>>>>>>>> Another thing I can think of is to disable
>>>>>>>>
>>>>>>>> 1) mitigations in both guest and host
>>>>>>>> 2) any kernel debug features in both host and guest
>>>>>>>
>>>>>>> I also rebuilt the kernel with everything disabled under
>>>>>>> "Kernel hacking", but that didn’t make any difference either.
>>>>>>>
>>>>>>> Because of this, I ran "pktgen_sample01_simple.sh" and
>>>>>>> "pktgen_sample02_multiqueue.sh" on my AMD Ryzen 5 5600X system. The
>>>>>>> results were about 374 Kpps with TAP and 1192 Kpps with TAP+vhost_net,
>>>>>>> with very similar performance between the stock and patched kernels.
>>>>>>>
>>>>>>> Personally, I think the low performance is to blame on the hardware.
>>>>>>
>>>>>> Let's double confirm this by:
>>>>>>
>>>>>> 1) make sure pktgen is using 100% CPU
>>>>>> 2) Perf doesn't show anything strange for pktgen thread
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>
>>>>> I ran pktgen using pktgen_sample01_simple.sh and, in parallel, started a
>>>>> 100 second perf stat measurement covering all kpktgend threads.
>>>>>
>>>>> Across all configurations, a single CPU was fully utilized.
>>>>>
>>>>> Apart from that, the patched variants show a higher branch frequency and
>>>>> a slightly increased number of context switches.
>>>>>
>>>>>
>>>>> The detailed results are provided below:
>>>>>
>>>>> Processor: Ryzen 5 5600X
>>>>>
>>>>> pktgen command:
>>>>> sudo perf stat samples/pktgen/pktgen_sample01_simple.sh -i tap0 -m
>>>>> 52:54:00:12:34:56 -d 10.0.0.2 -n 10000000000
>>>>>
>>>>> perf stat command:
>>>>> sudo perf stat --timeout 100000 -p $(pgrep kpktgend | tr '\n' ,) -o X.txt
>>>>>
>>>>>
>>>>> Results:
>>>>> Stock TAP:
>>>>>             46.997      context-switches                 #    467,2 cs/sec  cs_per_second
>>>>>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>>>>>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>>>>>         100.587,69 msec task-clock                       #      1,0 CPUs  CPUs_utilized
>>>>>      8.491.586.483      branch-misses                    #     10,9 %  branch_miss_rate         (50,24%)
>>>>>     77.734.761.406      branches                         #    772,8 M/sec  branch_frequency     (66,85%)
>>>>>    382.420.291.585      cpu-cycles                       #      3,8 GHz  cycles_frequency       (66,85%)
>>>>>    377.612.185.141      instructions                     #      1,0 instructions  insn_per_cycle  (66,85%)
>>>>>     84.012.185.936      stalled-cycles-frontend          #     0,22 frontend_cycles_idle        (66,35%)
>>>>>
>>>>>      100,100414494 seconds time elapsed
>>>>>
>>>>>
>>>>> Stock TAP+vhost-net:
>>>>>             47.087      context-switches                 #    468,1 cs/sec  cs_per_second
>>>>>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>>>>>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>>>>>         100.594,09 msec task-clock                       #      1,0 CPUs  CPUs_utilized
>>>>>      8.034.703.613      branch-misses                    #     11,1 %  branch_miss_rate         (50,24%)
>>>>>     72.477.989.922      branches                         #    720,5 M/sec  branch_frequency     (66,86%)
>>>>>    382.218.276.832      cpu-cycles                       #      3,8 GHz  cycles_frequency       (66,85%)
>>>>>    349.555.577.281      instructions                     #      0,9 instructions  insn_per_cycle  (66,85%)
>>>>>     83.917.644.262      stalled-cycles-frontend          #     0,22 frontend_cycles_idle        (66,35%)
>>>>>
>>>>>      100,100520402 seconds time elapsed
>>>>>
>>>>>
>>>>> Patched TAP:
>>>>>             47.862      context-switches                 #    475,8 cs/sec  cs_per_second
>>>>>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>>>>>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>>>>>         100.589,30 msec task-clock                       #      1,0 CPUs  CPUs_utilized
>>>>>      9.337.258.794      branch-misses                    #      9,4 %  branch_miss_rate         (50,19%)
>>>>>     99.518.421.676      branches                         #    989,4 M/sec  branch_frequency     (66,85%)
>>>>>    382.508.244.894      cpu-cycles                       #      3,8 GHz  cycles_frequency       (66,85%)
>>>>>    312.582.270.975      instructions                     #      0,8 instructions  insn_per_cycle  (66,85%)
>>>>>     76.338.503.984      stalled-cycles-frontend          #     0,20 frontend_cycles_idle        (66,39%)
>>>>>
>>>>>      100,101262454 seconds time elapsed
>>>>>
>>>>>
>>>>> Patched TAP+vhost-net:
>>>>>             47.892      context-switches                 #    476,1 cs/sec  cs_per_second
>>>>>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>>>>>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>>>>>         100.581,95 msec task-clock                       #      1,0 CPUs  CPUs_utilized
>>>>>      9.083.588.313      branch-misses                    #     10,1 %  branch_miss_rate         (50,28%)
>>>>>     90.300.124.712      branches                         #    897,8 M/sec  branch_frequency     (66,85%)
>>>>>    382.374.510.376      cpu-cycles                       #      3,8 GHz  cycles_frequency       (66,85%)
>>>>>    340.089.181.199      instructions                     #      0,9 instructions  insn_per_cycle  (66,85%)
>>>>>     78.151.408.955      stalled-cycles-frontend          #     0,20 frontend_cycles_idle        (66,31%)
>>>>>
>>>>>      100,101212911 seconds time elapsed
>>>>
>>>> Thanks for sharing. I have more questions:
>>>>
>>>> 1) The number of CPU and vCPUs
>>>
>>> qemu runs with a single core. And my host system is now a Ryzen 5 5600x
>>> with 6 cores, 12 threads.
>>> This is my command for TAP+vhost-net:
>>>
>>> sudo qemu-system-x86_64 -hda debian.qcow2
>>> -netdev tap,id=mynet0,ifname=tap0,script=no,downscript=no,vhost=on
>>> -device virtio-net-pci,netdev=mynet0 -m 1024 -enable-kvm
>>>
>>> For TAP only it is the same but without vhost=on.
>>>
>>>> 2) If you pin vhost or vCPU threads
>>>
>>> Not in the previous shown benchmark. I pinned vhost in other benchmarks
>>> but since there is only minor PPS difference I omitted for the sake of
>>> simplicity.
>>>
>>>> 3) what does perf top looks like or perf top -p $pid_of_vhost
>>>
>>> The perf reports for the pid_of_vhost from pktgen_sample01_simple.sh
>>> with TAP+vhost-net (not pinned, pktgen single queue, fq_codel) are shown
>>> below. I can not see a huge difference between stock and patched.
>>>
>>> Also I included perf reports from the pktgen_pids. I find them more
>>> intersting because tun_net_xmit shows less overhead for the patched.
>>> I assume that is due to the stopped netdev queue.
>>>
>>> I have now benchmarked pretty much all possible combinations (with a
>>> script) of TAP/TAP+vhost-net, single/multi-queue pktgen, vhost
>>> pinned/not pinned, with/without -b 0, fq_codel/noqueue... All of that
>>> with perf records..
>>> I could share them if you want but I feel this is getting out of hand.
>>>
>>>
>>> Stock:
>>> sudo perf record -p "$vhost_pid"
>>> ...
>>> # Overhead  Command          Shared Object               Symbol
>>> # ........  ...............  ..........................  ..........................................
>>> #
>>>      5.97%  vhost-4874       [kernel.kallsyms]           [k] _copy_to_iter
>>>      2.68%  vhost-4874       [kernel.kallsyms]           [k] tun_do_read
>>>      2.23%  vhost-4874       [kernel.kallsyms]           [k] native_write_msr
>>>      1.93%  vhost-4874       [kernel.kallsyms]           [k] __check_object_size
>>
>> Let's disable CONFIG_HARDENED_USERCOPY and retry.
>>
>>>      1.61%  vhost-4874       [kernel.kallsyms]           [k] __slab_free.isra.0
>>>      1.56%  vhost-4874       [kernel.kallsyms]           [k] __get_user_nocheck_2
>>>      1.54%  vhost-4874       [kernel.kallsyms]           [k] iov_iter_zero
>>>      1.45%  vhost-4874       [kernel.kallsyms]           [k] kmem_cache_free
>>>      1.43%  vhost-4874       [kernel.kallsyms]           [k] tun_recvmsg
>>>      1.24%  vhost-4874       [kernel.kallsyms]           [k] sk_skb_reason_drop
>>>      1.12%  vhost-4874       [kernel.kallsyms]           [k] srso_alias_safe_ret
>>>      1.07%  vhost-4874       [kernel.kallsyms]           [k] native_read_msr
>>>      0.76%  vhost-4874       [kernel.kallsyms]           [k] simple_copy_to_iter
>>>      0.75%  vhost-4874       [kernel.kallsyms]           [k] srso_alias_return_thunk
>>>      0.69%  vhost-4874       [vhost]                     [k] 0x0000000000002e70
>>>      0.59%  vhost-4874       [kernel.kallsyms]           [k] skb_release_data
>>>      0.59%  vhost-4874       [kernel.kallsyms]           [k] __skb_datagram_iter
>>>      0.53%  vhost-4874       [vhost]                     [k] 0x0000000000002e5f
>>>      0.51%  vhost-4874       [kernel.kallsyms]           [k] slab_update_freelist.isra.0
>>>      0.46%  vhost-4874       [kernel.kallsyms]           [k] kfree_skbmem
>>>      0.44%  vhost-4874       [kernel.kallsyms]           [k] skb_copy_datagram_iter
>>>      0.43%  vhost-4874       [kernel.kallsyms]           [k] skb_free_head
>>>      0.37%  qemu-system-x86  [unknown]                   [k] 0xffffffffba898b1b
>>>      0.35%  vhost-4874       [vhost]                     [k] 0x0000000000002e6b
>>>      0.33%  vhost-4874       [vhost_net]                 [k] 0x000000000000357d
>>>      0.28%  vhost-4874       [kernel.kallsyms]           [k] __check_heap_object
>>>      0.27%  vhost-4874       [vhost_net]                 [k] 0x00000000000035f3
>>>      0.26%  vhost-4874       [vhost_net]                 [k] 0x00000000000030f6
>>>      0.26%  vhost-4874       [kernel.kallsyms]           [k] __virt_addr_valid
>>>      0.24%  vhost-4874       [kernel.kallsyms]           [k] iov_iter_advance
>>>      0.22%  vhost-4874       [kernel.kallsyms]           [k] perf_event_update_userpage
>>>      0.22%  vhost-4874       [kernel.kallsyms]           [k] check_stack_object
>>>      0.19%  qemu-system-x86  [unknown]                   [k] 0xffffffffba2a68cd
>>>      0.19%  vhost-4874       [kernel.kallsyms]           [k] dequeue_entities
>>>      0.19%  vhost-4874       [vhost_net]                 [k] 0x0000000000003237
>>>      0.18%  vhost-4874       [vhost_net]                 [k] 0x0000000000003550
>>>      0.18%  vhost-4874       [kernel.kallsyms]           [k] x86_pmu_del
>>>      0.18%  vhost-4874       [vhost_net]                 [k] 0x00000000000034a0
>>>      0.17%  vhost-4874       [kernel.kallsyms]           [k] x86_pmu_disable_all
>>>      0.16%  vhost-4874       [vhost_net]                 [k] 0x0000000000003523
>>>      0.16%  vhost-4874       [kernel.kallsyms]           [k] amd_pmu_addr_offset
>>> ...
>>>
>>>
>>> sudo perf record -p "$kpktgend_pids":
>>> ...
>>> # Overhead  Command      Shared Object      Symbol
>>> # ........  ...........  .................  ...............................................
>>> #
>>>     10.98%  kpktgend_0   [kernel.kallsyms]  [k] tun_net_xmit
>>>     10.45%  kpktgend_0   [kernel.kallsyms]  [k] memset
>>>      8.40%  kpktgend_0   [kernel.kallsyms]  [k] __alloc_skb
>>>      6.31%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_alloc_node_noprof
>>>      3.13%  kpktgend_0   [kernel.kallsyms]  [k] srso_alias_safe_ret
>>>      2.40%  kpktgend_0   [kernel.kallsyms]  [k] sk_skb_reason_drop
>>>      2.11%  kpktgend_0   [kernel.kallsyms]  [k] srso_alias_return_thunk
>>
>> This is a hint that SRSO migitaion is enabled.
>>
>> Have you disabled CPU_MITIGATIONS via either Kconfig or kernel command
>> line (mitigations = off) for both host and guest?
>>
>> Thanks
>>
> 
> Your both suggested changes really boosted the performance, especially
> for TAP.
> 
> I disabled SRSO mitigation with spec_rstack_overflow=off and went from
> "Mitigation: Safe RET" to "Vulnerable" on the host. The VM showed "Not
> affected" but I applied spec_rstack_overflow=off anyway.
> 
> Here are some new benchmarks for pktgen_sample01_simple.sh:
> (I also have other available and I can share them if you want.)
> 
> +-------------------------+-----------+----------------+
> | pktgen benchmarks to    | Stock     | Patched with   |
> | Debian VM, R5 5600X,    |           | fq_codel qdisc |
> | 100M packets            |           |                |
> | CPU not pinned          |           |                |
> +-----------+-------------+-----------+----------------+
> | TAP       | Transmitted | 1330 Kpps | 1033 Kpps      |
> |           +-------------+-----------+----------------+
> |           | Lost        | 3895 Kpps | 0              |
> +-----------+-------------+-----------+----------------+
> | TAP       | Transmitted | 1408 Kpps | 1420 Kpps      |
> |  +        +-------------+-----------+----------------+
> | vhost-net | Lost        | 3712 Kpps | 0              |
> +-----------+-------------+-----------+----------------+
> 
> I do not understand why there is a regression for TAP but not for
> TAP+vhost-net...
> 
> 
> The perf report of pktgen and perf stat for TAP & TAP+vhost-net are
> below. I also included perf reports & perf statsof vhost for
> TAP+vhost-net.
> 
> =========================================================================
> 
> TAP stock:
> perf report of pktgen:
> 
> # Overhead  Command      Shared Object      Symbol                                        
> # ........  ...........  .................  ..............................................
> #
>     22.39%  kpktgend_0   [kernel.kallsyms]  [k] memset
>     10.59%  kpktgend_0   [kernel.kallsyms]  [k] __alloc_skb
>      7.56%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_alloc_node_noprof
>      5.74%  kpktgend_0   [kernel.kallsyms]  [k] tun_net_xmit
>      4.76%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_free
>      3.23%  kpktgend_0   [kernel.kallsyms]  [k] chacha_permute
>      2.55%  kpktgend_0   [pktgen]           [k] 0x0000000000003255
>      2.49%  kpktgend_0   [pktgen]           [k] 0x000000000000324f
>      2.48%  kpktgend_0   [pktgen]           [k] 0x000000000000325d
>      2.44%  kpktgend_0   [kernel.kallsyms]  [k] get_random_u32
>      2.21%  kpktgend_0   [kernel.kallsyms]  [k] skb_put
>      1.46%  kpktgend_0   [kernel.kallsyms]  [k] sk_skb_reason_drop
>      1.36%  kpktgend_0   [kernel.kallsyms]  [k] ip_send_check
>      1.17%  kpktgend_0   [kernel.kallsyms]  [k] __local_bh_enable_ip
>      1.09%  kpktgend_0   [kernel.kallsyms]  [k] _raw_spin_lock
>      1.01%  kpktgend_0   [kernel.kallsyms]  [k] kmalloc_reserve
>      0.85%  kpktgend_0   [kernel.kallsyms]  [k] skb_release_data
>      0.83%  kpktgend_0   [kernel.kallsyms]  [k] __netdev_alloc_skb
>      0.71%  kpktgend_0   [pktgen]           [k] 0x000000000000324d
>      0.68%  kpktgend_0   [kernel.kallsyms]  [k] __rcu_read_unlock
>      0.64%  kpktgend_0   [kernel.kallsyms]  [k] skb_tx_error
>      0.59%  kpktgend_0   [kernel.kallsyms]  [k] __get_random_u32_below
>      0.58%  kpktgend_0   [kernel.kallsyms]  [k] sock_def_readable
>      0.51%  kpktgend_0   [pktgen]           [k] 0x000000000000422e
>      0.50%  kpktgend_0   [kernel.kallsyms]  [k] __rcu_read_lock
>      0.48%  kpktgend_0   [kernel.kallsyms]  [k] _get_random_bytes
>      0.46%  kpktgend_0   [pktgen]           [k] 0x0000000000004220
>      0.46%  kpktgend_0   [pktgen]           [k] 0x0000000000004229
>      0.45%  kpktgend_0   [kernel.kallsyms]  [k] skb_release_head_state
>      0.44%  kpktgend_0   [pktgen]           [k] 0x000000000000211d
> ...
> 
> 
> perf stat of pktgen:
>  Performance counter stats for process id '4740,4741,4742,4743,4744,4745,4746,4747,4748,4749,4750,4751,4752,4753,4754,4755,4756,4757,4758,4759,4760,4761,4762,4763,4764,4765,4766,4767,4768,4769,4770,4771,4772,4773,4774,4775,4776,4777,4778,4779,4780,4781,4782,4783,4784,4785,4786,4787':
> 
>             35.436      context-switches                 #    469,7 cs/sec  cs_per_second     
>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>          75.443,67 msec task-clock                       #      1,0 CPUs  CPUs_utilized       
>        548.187.113      branch-misses                    #      0,5 %  branch_miss_rate         (50,18%)
>    119.270.991.801      branches                         #   1580,9 M/sec  branch_frequency     (66,79%)
>    347.803.953.690      cpu-cycles                       #      4,6 GHz  cycles_frequency       (66,79%)
>    689.142.448.524      instructions                     #      2,0 instructions  insn_per_cycle  (66,79%)
>     11.063.715.152      stalled-cycles-frontend          #     0,03 frontend_cycles_idle        (66,43%)
> 
>       75,698467362 seconds time elapsed
> 
> 
> =========================================================================
> 
> TAP patched:
> perf report of pktgen:
> 
> # Overhead  Command      Shared Object      Symbol                                        
> # ........  ...........  .................  ..............................................
> #
>     16.18%  kpktgend_0   [pktgen]           [k] 0x0000000000003255
>     16.11%  kpktgend_0   [pktgen]           [k] 0x000000000000324f
>     16.10%  kpktgend_0   [pktgen]           [k] 0x000000000000325d
>      4.78%  kpktgend_0   [kernel.kallsyms]  [k] memset
>      4.54%  kpktgend_0   [kernel.kallsyms]  [k] __local_bh_enable_ip
>      2.62%  kpktgend_0   [pktgen]           [k] 0x000000000000324d
>      2.42%  kpktgend_0   [kernel.kallsyms]  [k] __alloc_skb
>      1.89%  kpktgend_0   [kernel.kallsyms]  [k] kthread_should_stop
>      1.77%  kpktgend_0   [kernel.kallsyms]  [k] __rcu_read_unlock
>      1.66%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_alloc_node_noprof
>      1.53%  kpktgend_0   [kernel.kallsyms]  [k] __rcu_read_lock
>      1.44%  kpktgend_0   [kernel.kallsyms]  [k] tun_net_xmit
>      1.42%  kpktgend_0   [kernel.kallsyms]  [k] __cond_resched
>      0.91%  kpktgend_0   [pktgen]           [k] 0x0000000000003877
>      0.91%  kpktgend_0   [pktgen]           [k] 0x0000000000003284
>      0.89%  kpktgend_0   [pktgen]           [k] 0x000000000000327f
>      0.75%  kpktgend_0   [kernel.kallsyms]  [k] chacha_permute
>      0.64%  kpktgend_0   [pktgen]           [k] 0x0000000000003061
>      0.61%  kpktgend_0   [kernel.kallsyms]  [k] get_random_u32
>      0.57%  kpktgend_0   [kernel.kallsyms]  [k] sock_def_readable
>      0.52%  kpktgend_0   [kernel.kallsyms]  [k] skb_put
>      0.48%  kpktgend_0   [pktgen]           [k] 0x000000000000326d
>      0.47%  kpktgend_0   [pktgen]           [k] 0x0000000000003265
>      0.47%  kpktgend_0   [pktgen]           [k] 0x0000000000003864
>      0.45%  kpktgend_0   [pktgen]           [k] 0x0000000000003008
>      0.35%  kpktgend_0   [pktgen]           [k] 0x000000000000449b
>      0.34%  kpktgend_0   [pktgen]           [k] 0x0000000000003242
>      0.32%  kpktgend_0   [pktgen]           [k] 0x00000000000030a6
>      0.32%  kpktgend_0   [pktgen]           [k] 0x000000000000308b
>      0.32%  kpktgend_0   [pktgen]           [k] 0x0000000000003869
>      0.31%  kpktgend_0   [pktgen]           [k] 0x00000000000030c2
> ...
> 
> perf stat of pktgen:
> 
>  Performance counter stats for process id '3257,3258,3259,3260,3261,3262,3263,3264,3265,3266,3267,3268,3269,3270,3271,3272,3273,3274,3275,3276,3277,3278,3279,3280,3281,3282,3283,3284,3285,3286,3287,3288,3289,3290,3291,3292,3293,3294,3295,3296,3297,3298,3299,3300,3301,3302,3303,3304':
> 
>             45.545      context-switches                 #    468,9 cs/sec  cs_per_second     
>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>          97.130,77 msec task-clock                       #      1,0 CPUs  CPUs_utilized       
>        237.212.098      branch-misses                    #      0,1 %  branch_miss_rate         (50,12%)
>    172.088.418.840      branches                         #   1771,7 M/sec  branch_frequency     (66,78%)
>    447.219.346.605      cpu-cycles                       #      4,6 GHz  cycles_frequency       (66,79%)
>    619.203.459.603      instructions                     #      1,4 instructions  insn_per_cycle  (66,79%)
>      5.821.044.711      stalled-cycles-frontend          #     0,01 frontend_cycles_idle        (66,48%)
> 
>       97,353332168 seconds time elapsed
> 
> =========================================================================
> 
> TAP+vhost-net stock:
> 
> perf report of pktgen:
> 
> # Overhead  Command      Shared Object      Symbol                                        
> # ........  ...........  .................  ..............................................
> #
>     22.25%  kpktgend_0   [kernel.kallsyms]  [k] memset
>     10.73%  kpktgend_0   [kernel.kallsyms]  [k] __alloc_skb
>      7.69%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_alloc_node_noprof
>      5.71%  kpktgend_0   [kernel.kallsyms]  [k] tun_net_xmit
>      4.66%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_free
>      3.20%  kpktgend_0   [kernel.kallsyms]  [k] chacha_permute
>      2.50%  kpktgend_0   [pktgen]           [k] 0x000000000000325d
>      2.48%  kpktgend_0   [pktgen]           [k] 0x0000000000003255
>      2.45%  kpktgend_0   [pktgen]           [k] 0x000000000000324f
>      2.41%  kpktgend_0   [kernel.kallsyms]  [k] get_random_u32
>      2.22%  kpktgend_0   [kernel.kallsyms]  [k] skb_put
>      1.44%  kpktgend_0   [kernel.kallsyms]  [k] sk_skb_reason_drop
>      1.34%  kpktgend_0   [kernel.kallsyms]  [k] ip_send_check
>      1.22%  kpktgend_0   [kernel.kallsyms]  [k] __local_bh_enable_ip
>      1.06%  kpktgend_0   [kernel.kallsyms]  [k] _raw_spin_lock
>      1.04%  kpktgend_0   [kernel.kallsyms]  [k] kmalloc_reserve
>      0.85%  kpktgend_0   [kernel.kallsyms]  [k] skb_release_data
>      0.83%  kpktgend_0   [kernel.kallsyms]  [k] __netdev_alloc_skb
>      0.72%  kpktgend_0   [pktgen]           [k] 0x000000000000324d
>      0.70%  kpktgend_0   [kernel.kallsyms]  [k] __rcu_read_unlock
>      0.62%  kpktgend_0   [kernel.kallsyms]  [k] skb_tx_error
>      0.61%  kpktgend_0   [kernel.kallsyms]  [k] __get_random_u32_below
>      0.60%  kpktgend_0   [kernel.kallsyms]  [k] sock_def_readable
>      0.52%  kpktgend_0   [kernel.kallsyms]  [k] __rcu_read_lock
>      0.47%  kpktgend_0   [kernel.kallsyms]  [k] _get_random_bytes
>      0.47%  kpktgend_0   [pktgen]           [k] 0x000000000000422e
>      0.45%  kpktgend_0   [pktgen]           [k] 0x0000000000004229
>      0.44%  kpktgend_0   [pktgen]           [k] 0x0000000000004220
>      0.43%  kpktgend_0   [kernel.kallsyms]  [k] skb_release_head_state
>      0.42%  kpktgend_0   [kernel.kallsyms]  [k] netdev_core_stats_inc
>      0.42%  kpktgend_0   [pktgen]           [k] 0x0000000000002119
> ...
> 
> perf stat of pktgen:
> 
>  Performance counter stats for process id '4740,4741,4742,4743,4744,4745,4746,4747,4748,4749,4750,4751,4752,4753,4754,4755,4756,4757,4758,4759,4760,4761,4762,4763,4764,4765,4766,4767,4768,4769,4770,4771,4772,4773,4774,4775,4776,4777,4778,4779,4780,4781,4782,4783,4784,4785,4786,4787':
> 
>             34.830      context-switches                 #    489,0 cs/sec  cs_per_second     
>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>          71.224,77 msec task-clock                       #      1,0 CPUs  CPUs_utilized       
>        506.905.400      branch-misses                    #      0,5 %  branch_miss_rate         (50,15%)
>    110.207.563.428      branches                         #   1547,3 M/sec  branch_frequency     (66,78%)
>    324.745.594.771      cpu-cycles                       #      4,6 GHz  cycles_frequency       (66,77%)
>    635.181.893.816      instructions                     #      2,0 instructions  insn_per_cycle  (66,77%)
>     10.450.586.633      stalled-cycles-frontend          #     0,03 frontend_cycles_idle        (66,46%)
> 
>       71,547831150 seconds time elapsed
> 
> 
> perf report of vhost:
> 
> # Overhead  Command          Shared Object               Symbol                                          
> # ........  ...............  ..........................  ................................................
> #
>      8.66%  vhost-14592      [kernel.kallsyms]           [k] _copy_to_iter
>      2.76%  vhost-14592      [kernel.kallsyms]           [k] native_write_msr
>      2.57%  vhost-14592      [kernel.kallsyms]           [k] __get_user_nocheck_2
>      2.03%  vhost-14592      [kernel.kallsyms]           [k] iov_iter_zero
>      1.21%  vhost-14592      [kernel.kallsyms]           [k] native_read_msr
>      0.89%  vhost-14592      [kernel.kallsyms]           [k] kmem_cache_free
>      0.85%  vhost-14592      [kernel.kallsyms]           [k] __slab_free.isra.0
>      0.84%  vhost-14592      [vhost]                     [k] 0x0000000000002e3a
>      0.83%  vhost-14592      [kernel.kallsyms]           [k] tun_do_read
>      0.74%  vhost-14592      [kernel.kallsyms]           [k] tun_recvmsg
>      0.72%  vhost-14592      [kernel.kallsyms]           [k] slab_update_freelist.isra.0
>      0.49%  vhost-14592      [vhost]                     [k] 0x0000000000002e29
>      0.45%  vhost-14592      [vhost]                     [k] 0x0000000000002e35
>      0.43%  qemu-system-x86  [unknown]                   [k] 0xffffffffb5298b1b
>      0.26%  vhost-14592      [kernel.kallsyms]           [k] __skb_datagram_iter
>      0.24%  vhost-14592      [kernel.kallsyms]           [k] skb_release_data
>      0.24%  qemu-system-x86  [unknown]                   [k] 0xffffffffb4ca68cd
>      0.24%  vhost-14592      [kernel.kallsyms]           [k] iov_iter_advance
>      0.22%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eb79c
>      0.22%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eba58
>      0.14%  vhost-14592      [kernel.kallsyms]           [k] sk_skb_reason_drop
>      0.14%  vhost-14592      [kernel.kallsyms]           [k] amd_pmu_addr_offset
>      0.13%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eba54
>      0.13%  vhost-14592      [kernel.kallsyms]           [k] skb_free_head
>      0.12%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eba50
>      0.12%  vhost-14592      [kernel.kallsyms]           [k] skb_release_head_state
>      0.10%  qemu-system-x86  [kernel.kallsyms]           [k] native_write_msr
>      0.09%  vhost-14592      [kernel.kallsyms]           [k] event_sched_out
>      0.09%  vhost-14592      [kernel.kallsyms]           [k] x86_pmu_del
>      0.09%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eb798
>      0.09%  vhost-14592      [kernel.kallsyms]           [k] put_cpu_partial
> ...
> 
> 
> perf stat of vhost:
> 
>  Performance counter stats for process id '14592':
> 
>          1.576.207      context-switches                 #  15070,7 cs/sec  cs_per_second     
>                459      cpu-migrations                   #      4,4 migrations/sec  migrations_per_second
>                  2      page-faults                      #      0,0 faults/sec  page_faults_per_second
>         104.587,77 msec task-clock                       #      1,5 CPUs  CPUs_utilized       
>        401.899.188      branch-misses                    #      0,2 %  branch_miss_rate         (49,91%)
>    174.642.296.972      branches                         #   1669,8 M/sec  branch_frequency     (66,71%)
>    453.598.103.128      cpu-cycles                       #      4,3 GHz  cycles_frequency       (66,98%)
>    957.886.719.689      instructions                     #      2,1 instructions  insn_per_cycle  (66,77%)
>     11.834.633.090      stalled-cycles-frontend          #     0,03 frontend_cycles_idle        (66,54%)
> 
>       71,561336447 seconds time elapsed
> 
> 
> =========================================================================
> 
> TAP+vhost-net patched:
> 
> perf report of pktgen:
> 
> # Overhead  Command      Shared Object      Symbol                                        
> # ........  ...........  .................  ..............................................
> #
>     16.83%  kpktgend_0   [pktgen]           [k] 0x000000000000324f
>     16.81%  kpktgend_0   [pktgen]           [k] 0x0000000000003255
>     16.74%  kpktgend_0   [pktgen]           [k] 0x000000000000325d
>      5.96%  kpktgend_0   [kernel.kallsyms]  [k] memset
>      3.87%  kpktgend_0   [kernel.kallsyms]  [k] __local_bh_enable_ip
>      2.87%  kpktgend_0   [kernel.kallsyms]  [k] __alloc_skb
>      1.77%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_alloc_node_noprof
>      1.72%  kpktgend_0   [pktgen]           [k] 0x000000000000324d
>      1.68%  kpktgend_0   [kernel.kallsyms]  [k] tun_net_xmit
>      1.63%  kpktgend_0   [kernel.kallsyms]  [k] __rcu_read_unlock
>      1.56%  kpktgend_0   [kernel.kallsyms]  [k] kthread_should_stop
>      1.41%  kpktgend_0   [kernel.kallsyms]  [k] __rcu_read_lock
>      1.19%  kpktgend_0   [kernel.kallsyms]  [k] __cond_resched
>      0.83%  kpktgend_0   [kernel.kallsyms]  [k] chacha_permute
>      0.79%  kpktgend_0   [pktgen]           [k] 0x000000000000327f
>      0.78%  kpktgend_0   [pktgen]           [k] 0x0000000000003284
>      0.77%  kpktgend_0   [pktgen]           [k] 0x0000000000003877
>      0.69%  kpktgend_0   [kernel.kallsyms]  [k] sock_def_readable
>      0.66%  kpktgend_0   [kernel.kallsyms]  [k] get_random_u32
>      0.56%  kpktgend_0   [kernel.kallsyms]  [k] skb_put
>      0.54%  kpktgend_0   [pktgen]           [k] 0x0000000000003061
>      0.41%  kpktgend_0   [pktgen]           [k] 0x0000000000003864
>      0.41%  kpktgend_0   [pktgen]           [k] 0x0000000000003265
>      0.40%  kpktgend_0   [pktgen]           [k] 0x0000000000003008
>      0.39%  kpktgend_0   [pktgen]           [k] 0x000000000000326d
>      0.37%  kpktgend_0   [kernel.kallsyms]  [k] ip_send_check
>      0.36%  kpktgend_0   [pktgen]           [k] 0x000000000000422e
>      0.32%  kpktgend_0   [pktgen]           [k] 0x0000000000004220
>      0.30%  kpktgend_0   [pktgen]           [k] 0x0000000000004229
>      0.29%  kpktgend_0   [kernel.kallsyms]  [k] kmalloc_reserve
>      0.28%  kpktgend_0   [kernel.kallsyms]  [k] _raw_spin_lock
> ...
> 
> perf stat of pktgen:
> 
>  Performance counter stats for process id '3257,3258,3259,3260,3261,3262,3263,3264,3265,3266,3267,3268,3269,3270,3271,3272,3273,3274,3275,3276,3277,3278,3279,3280,3281,3282,3283,3284,3285,3286,3287,3288,3289,3290,3291,3292,3293,3294,3295,3296,3297,3298,3299,3300,3301,3302,3303,3304':
> 
>             34.525      context-switches                 #    489,1 cs/sec  cs_per_second     
>                  0      cpu-migrations                   #      0,0 migrations/sec  migrations_per_second
>                  0      page-faults                      #      0,0 faults/sec  page_faults_per_second
>          70.593,02 msec task-clock                       #      1,0 CPUs  CPUs_utilized       
>        225.587.357      branch-misses                    #      0,2 %  branch_miss_rate         (50,15%)
>    135.486.264.836      branches                         #   1919,3 M/sec  branch_frequency     (66,77%)
>    324.131.813.682      cpu-cycles                       #      4,6 GHz  cycles_frequency       (66,77%)
>    501.960.610.999      instructions                     #      1,5 instructions  insn_per_cycle  (66,77%)
>      2.689.294.657      stalled-cycles-frontend          #     0,01 frontend_cycles_idle        (66,46%)
> 
>       70,928052784 seconds time elapsed
> 
> 
> perf report of vhost:
> 
> # Overhead  Command          Shared Object               Symbol                                          
> # ........  ...............  ..........................  ................................................
> #
>      8.95%  vhost-12220      [kernel.kallsyms]           [k] _copy_to_iter
>      4.03%  vhost-12220      [kernel.kallsyms]           [k] native_write_msr
>      2.44%  vhost-12220      [kernel.kallsyms]           [k] __get_user_nocheck_2
>      2.12%  vhost-12220      [kernel.kallsyms]           [k] iov_iter_zero
>      1.74%  vhost-12220      [kernel.kallsyms]           [k] native_read_msr
>      0.92%  vhost-12220      [kernel.kallsyms]           [k] kmem_cache_free
>      0.87%  vhost-12220      [vhost]                     [k] 0x0000000000002e3a
>      0.86%  vhost-12220      [kernel.kallsyms]           [k] __slab_free.isra.0
>      0.82%  vhost-12220      [kernel.kallsyms]           [k] tun_recvmsg
>      0.82%  vhost-12220      [kernel.kallsyms]           [k] tun_do_read
>      0.73%  vhost-12220      [kernel.kallsyms]           [k] slab_update_freelist.isra.0
>      0.51%  vhost-12220      [vhost]                     [k] 0x0000000000002e29
>      0.47%  vhost-12220      [vhost]                     [k] 0x0000000000002e35
>      0.40%  qemu-system-x86  [unknown]                   [k] 0xffffffff97e98b1b
>      0.28%  vhost-12220      [kernel.kallsyms]           [k] __skb_datagram_iter
>      0.26%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eba58
>      0.24%  vhost-12220      [kernel.kallsyms]           [k] iov_iter_advance
>      0.22%  qemu-system-x86  [unknown]                   [k] 0xffffffff978a68cd
>      0.22%  vhost-12220      [kernel.kallsyms]           [k] skb_release_data
>      0.21%  vhost-12220      [kernel.kallsyms]           [k] amd_pmu_addr_offset
>      0.19%  vhost-12220      [kernel.kallsyms]           [k] tun_ring_consume_batched
>      0.18%  vhost-12220      [kernel.kallsyms]           [k] __rcu_read_unlock
>      0.14%  vhost-12220      [kernel.kallsyms]           [k] sk_skb_reason_drop
>      0.13%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eb79c
>      0.13%  vhost-12220      [kernel.kallsyms]           [k] skb_release_head_state
>      0.13%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eba54
>      0.13%  vhost-12220      [kernel.kallsyms]           [k] psi_group_change
>      0.13%  qemu-system-x86  qemu-system-x86_64          [.] 0x00000000008eba50
>      0.11%  vhost-12220      [kernel.kallsyms]           [k] skb_free_head
>      0.10%  vhost-12220      [kernel.kallsyms]           [k] __update_load_avg_cfs_rq
>      0.10%  vhost-12220      [kernel.kallsyms]           [k] update_load_avg
> ...
> 
> 
> perf stat of vhost:
> 
>  Performance counter stats for process id '12220':
> 
>          2.841.331      context-switches                 #  26120,3 cs/sec  cs_per_second     
>              1.902      cpu-migrations                   #     17,5 migrations/sec  migrations_per_second
>                  2      page-faults                      #      0,0 faults/sec  page_faults_per_second
>         108.778,75 msec task-clock                       #      1,5 CPUs  CPUs_utilized       
>        422.032.153      branch-misses                    #      0,2 %  branch_miss_rate         (49,95%)
>    177.051.281.496      branches                         #   1627,6 M/sec  branch_frequency     (66,59%)
>    458.977.136.165      cpu-cycles                       #      4,2 GHz  cycles_frequency       (66,47%)
>    968.869.747.208      instructions                     #      2,1 instructions  insn_per_cycle  (66,70%)
>     12.748.378.886      stalled-cycles-frontend          #     0,03 frontend_cycles_idle        (66,76%)
> 
>       70,946778111 seconds time elapsed
> 

Hi, what do you think?

Thanks!

