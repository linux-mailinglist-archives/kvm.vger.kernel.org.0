Return-Path: <kvm+bounces-69525-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNJqK3wne2nXBgIAu9opvQ
	(envelope-from <kvm+bounces-69525-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:25:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 248B1AE19B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0D817301D321
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 09:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BF337F8D6;
	Thu, 29 Jan 2026 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="m2iynpLn"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150372773FF;
	Thu, 29 Jan 2026 09:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769678706; cv=none; b=QVHYDC1ND7iCagyaRwWPXtsTdNY50DgXE8Gt9jD1PqHpoOEY3cCnmDpWW5Q5mcy8eLT4+PGoeIB/ph0M9/gDapkwrWSPkVo+KvIMYIRolGUolBDx5mD6PpzNCF+zqf9t01aX4kzWZkFHwHMGLN7cHAqJnO4oe6GOwaUidZv3um0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769678706; c=relaxed/simple;
	bh=7cso+XqOXr7rwVEygZj+zCS81n5bRpw21wBzmmAGPGE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t16f9Y3RamKk1LDtbIxfMTwNjvmMUfNCw6zhDbenwkYBeMw02plDBSVyG9qL3+pm0mto/vFZGr/ovQ2QHlAxNeED2kyhebALGp7unLiocC1FzIiCWUnh3Ip8ksaqOUNBHGdhZdYapPV9O4oHtLd6PkhwIubehXc0FNlIiXEA43g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=m2iynpLn; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.38] ([129.217.186.38])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 60T9OoX5005990
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 10:24:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1769678691;
	bh=7cso+XqOXr7rwVEygZj+zCS81n5bRpw21wBzmmAGPGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m2iynpLndCyvsPNI8KO8eRCyY2t07JWmyRWdo5WVnXviy4fsnNQH6/kI+BiDXokuh
	 smq6umJTs6F7u014gKbBBaq5zOupG5R2tOoTJkOr9XTBMDqWUNQbg+klZ3U0UD/CNy
	 3bivEanF7eFAal7caLgE0hIHMXyGJNCIMPWjuEXo=
Message-ID: <ba17ba38-9f61-4a10-b375-d0da805e6b73@tu-dortmund.de>
Date: Thu, 29 Jan 2026 10:24:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper with
 netdev queue wakeup
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-4-simon.schippers@tu-dortmund.de>
 <CACGkMEuSiEcyaeFeZd0=RgNpviJgNvUDq_ctjeMLT5jZTgRkwQ@mail.gmail.com>
 <1e30464c-99ae-441e-bb46-6d0485d494dc@tu-dortmund.de>
 <CACGkMEtzD3ORJuJcc8VeqwASiGeVFdQmJowsK6PYVEF_Zkcn8Q@mail.gmail.com>
 <afa40345-acbe-42b0-81d1-0a838343792d@tu-dortmund.de>
 <CACGkMEtxRoavBMTXom8Z=FM-pvu3pHbsuwCs+e450b1B=V7iWA@mail.gmail.com>
 <CACGkMEsJKeEsH=G8H5RzMNHY4g3HNdciMDMhciShawh-9Xb9hg@mail.gmail.com>
 <bc1078e5-65fc-4de6-8475-517f626d8d96@tu-dortmund.de>
 <3a1d6232-efe4-4e79-a196-44794fdc0f33@tu-dortmund.de>
 <CACGkMEv71kn91FPAUrxJg=YB3+B0MRTgOidMPHjK7Qq0WEhGtw@mail.gmail.com>
 <260f48cd-caa1-4684-a235-8e1192722b3a@tu-dortmund.de>
 <CACGkMEsVMz+vS3KxykYBGXvyt3MZcstnYWUiYJZhLSMoHC5Smw@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEsVMz+vS3KxykYBGXvyt3MZcstnYWUiYJZhLSMoHC5Smw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[tu-dortmund.de,none];
	R_DKIM_ALLOW(-0.20)[tu-dortmund.de:s=unimail];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69525-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,redhat.com,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[simon.schippers@tu-dortmund.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[tu-dortmund.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pktgen_sample03_burst_single_flow.sh:url,0.0.0.0:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 248B1AE19B
X-Rspamd-Action: no action

On 1/29/26 02:14, Jason Wang wrote:
> On Wed, Jan 28, 2026 at 3:54 PM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> On 1/28/26 08:03, Jason Wang wrote:
>>> On Wed, Jan 28, 2026 at 12:48 AM Simon Schippers
>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>
>>>> On 1/23/26 10:54, Simon Schippers wrote:
>>>>> On 1/23/26 04:05, Jason Wang wrote:
>>>>>> On Thu, Jan 22, 2026 at 1:35 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>
>>>>>>> On Wed, Jan 21, 2026 at 5:33 PM Simon Schippers
>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>
>>>>>>>> On 1/9/26 07:02, Jason Wang wrote:
>>>>>>>>> On Thu, Jan 8, 2026 at 3:41 PM Simon Schippers
>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>
>>>>>>>>>> On 1/8/26 04:38, Jason Wang wrote:
>>>>>>>>>>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_consume()
>>>>>>>>>>>> and wake the corresponding netdev subqueue when consuming an entry frees
>>>>>>>>>>>> space in the underlying ptr_ring.
>>>>>>>>>>>>
>>>>>>>>>>>> Stopping of the netdev queue when the ptr_ring is full will be introduced
>>>>>>>>>>>> in an upcoming commit.
>>>>>>>>>>>>
>>>>>>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>>>>>>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>>>>>>>>>>>> ---
>>>>>>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
>>>>>>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
>>>>>>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>>>>>>>>>>>> index 1197f245e873..2442cf7ac385 100644
>>>>>>>>>>>> --- a/drivers/net/tap.c
>>>>>>>>>>>> +++ b/drivers/net/tap.c
>>>>>>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>>>>>>>>>>>         return ret ? ret : total;
>>>>>>>>>>>>  }
>>>>>>>>>>>>
>>>>>>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
>>>>>>>>>>>> +{
>>>>>>>>>>>> +       struct ptr_ring *ring = &q->ring;
>>>>>>>>>>>> +       struct net_device *dev;
>>>>>>>>>>>> +       void *ptr;
>>>>>>>>>>>> +
>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
>>>>>>>>>>>> +
>>>>>>>>>>>> +       ptr = __ptr_ring_consume(ring);
>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>>>>>>>>>> +               rcu_read_lock();
>>>>>>>>>>>> +               dev = rcu_dereference(q->tap)->dev;
>>>>>>>>>>>> +               netif_wake_subqueue(dev, q->queue_index);
>>>>>>>>>>>> +               rcu_read_unlock();
>>>>>>>>>>>> +       }
>>>>>>>>>>>> +
>>>>>>>>>>>> +       spin_unlock(&ring->consumer_lock);
>>>>>>>>>>>> +
>>>>>>>>>>>> +       return ptr;
>>>>>>>>>>>> +}
>>>>>>>>>>>> +
>>>>>>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>>>>>>>                            struct iov_iter *to,
>>>>>>>>>>>>                            int noblock, struct sk_buff *skb)
>>>>>>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>>>>>>>>>>>>                                         TASK_INTERRUPTIBLE);
>>>>>>>>>>>>
>>>>>>>>>>>>                 /* Read frames from the queue */
>>>>>>>>>>>> -               skb = ptr_ring_consume(&q->ring);
>>>>>>>>>>>> +               skb = tap_ring_consume(q);
>>>>>>>>>>>>                 if (skb)
>>>>>>>>>>>>                         break;
>>>>>>>>>>>>                 if (noblock) {
>>>>>>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>>>>>>>>> index 8192740357a0..7148f9a844a4 100644
>>>>>>>>>>>> --- a/drivers/net/tun.c
>>>>>>>>>>>> +++ b/drivers/net/tun.c
>>>>>>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>>>>>>>>>>         return total;
>>>>>>>>>>>>  }
>>>>>>>>>>>>
>>>>>>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
>>>>>>>>>>>> +{
>>>>>>>>>>>> +       struct ptr_ring *ring = &tfile->tx_ring;
>>>>>>>>>>>> +       struct net_device *dev;
>>>>>>>>>>>> +       void *ptr;
>>>>>>>>>>>> +
>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
>>>>>>>>>>>> +
>>>>>>>>>>>> +       ptr = __ptr_ring_consume(ring);
>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>>>>>>>>>>>
>>>>>>>>>>> I guess it's the "bug" I mentioned in the previous patch that leads to
>>>>>>>>>>> the check of __ptr_ring_consume_created_space() here. If it's true,
>>>>>>>>>>> another call to tweak the current API.
>>>>>>>>>>>
>>>>>>>>>>>> +               rcu_read_lock();
>>>>>>>>>>>> +               dev = rcu_dereference(tfile->tun)->dev;
>>>>>>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_index);
>>>>>>>>>>>
>>>>>>>>>>> This would cause the producer TX_SOFTIRQ to run on the same cpu which
>>>>>>>>>>> I'm not sure is what we want.
>>>>>>>>>>
>>>>>>>>>> What else would you suggest calling to wake the queue?
>>>>>>>>>
>>>>>>>>> I don't have a good method in my mind, just want to point out its implications.
>>>>>>>>
>>>>>>>> I have to admit I'm a bit stuck at this point, particularly with this
>>>>>>>> aspect.
>>>>>>>>
>>>>>>>> What is the correct way to pass the producer CPU ID to the consumer?
>>>>>>>> Would it make sense to store smp_processor_id() in the tfile inside
>>>>>>>> tun_net_xmit(), or should it instead be stored in the skb (similar to the
>>>>>>>> XDP bit)? In the latter case, my concern is that this information may
>>>>>>>> already be significantly outdated by the time it is used.
>>>>>>>>
>>>>>>>> Based on that, my idea would be for the consumer to wake the producer by
>>>>>>>> invoking a new function (e.g., tun_wake_queue()) on the producer CPU via
>>>>>>>> smp_call_function_single().
>>>>>>>> Is this a reasonable approach?
>>>>>>>
>>>>>>> I'm not sure but it would introduce costs like IPI.
>>>>>>>
>>>>>>>>
>>>>>>>> More generally, would triggering TX_SOFTIRQ on the consumer CPU be
>>>>>>>> considered a deal-breaker for the patch set?
>>>>>>>
>>>>>>> It depends on whether or not it has effects on the performance.
>>>>>>> Especially when vhost is pinned.
>>>>>>
>>>>>> I meant we can benchmark to see the impact. For example, pin vhost to
>>>>>> a specific CPU and the try to see the impact of the TX_SOFTIRQ.
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>
>>>>> I ran benchmarks with vhost pinned to CPU 0 using taskset -p -c 0 ...
>>>>> for both the stock and patched versions. The benchmarks were run with
>>>>> the full patch series applied, since testing only patches 1-3 would not
>>>>> be meaningful - the queue is never stopped in that case, so no
>>>>> TX_SOFTIRQ is triggered.
>>>>>
>>>>> Compared to the non-pinned CPU benchmarks in the cover letter,
>>>>> performance is lower for pktgen with a single thread but higher with
>>>>> four threads. The results show no regression for the patched version,
>>>>> with even slight performance improvements observed:
>>>>>
>>>>> +-------------------------+-----------+----------------+
>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
>>>>> | 100M packets            |           |                |
>>>>> | vhost pinned to core 0  |           |                |
>>>>> +-----------+-------------+-----------+----------------+
>>>>> | TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
>>>>> |  +        +-------------+-----------+----------------+
>>>>> | vhost-net | Lost        | 1154 Kpps | 0              |
>>>>> +-----------+-------------+-----------+----------------+
>>>>>
>>>>> +-------------------------+-----------+----------------+
>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
>>>>> | 100M packets            |           |                |
>>>>> | vhost pinned to core 0  |           |                |
>>>>> | *4 threads*             |           |                |
>>>>> +-----------+-------------+-----------+----------------+
>>>>> | TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
>>>>> |  +        +-------------+-----------+----------------+
>>>>> | vhost-net | Lost        | 1527 Kpps | 0              |
>>>>> +-----------+-------------+-----------+----------------+
>>>
>>> The PPS seems to be low. I'd suggest using testpmd (rxonly) mode in
>>> the guest or an xdp program that did XDP_DROP in the guest.
>>
>> I forgot to mention that these PPS values are per thread.
>> So overall we have 71 Kpps * 4 = 284 Kpps and 79 Kpps * 4 = 326 Kpps,
>> respectively. For packet loss, that comes out to 1154 Kpps * 4 =
>> 4616 Kpps and 0, respectively.
>>
>> Sorry about that!
>>
>> The pktgen benchmarks with a single thread look fine, right?
> 
> Still looks very low. E.g I just have a run of pktgen (using
> pktgen_sample03_burst_single_flow.sh) without a XDP_DROP in the guest,
> I can get 1Mpps.

Keep in mind that I am using an older CPU (i5-6300HQ). For the
single-threaded tests I always used pktgen_sample01_simple.sh, and for
the multi-threaded tests I always used pktgen_sample02_multiqueue.sh.

Using pktgen_sample03_burst_single_flow.sh as you did fails for me (even
though the same parameters work fine for sample01 and sample02):

samples/pktgen/pktgen_sample03_burst_single_flow.sh -i tap0 -m
52:54:00:12:34:56 -d 10.0.0.2 -n 100000000
/samples/pktgen/functions.sh: line 79: echo: write error: Operation not
supported
ERROR: Write error(1) occurred
cmd: "burst 32 > /proc/net/pktgen/tap0@0"

...and I do not know what I am doing wrong, even after looking at
Documentation/networking/pktgen.rst. Every burst size except 1 fails.
Any clues?

Thanks!

> 
>>
>> I'll still look into using an XDP program that does XDP_DROP in the
>> guest.
>>
>> Thanks!
> 
> Thanks
> 
>>
>>>
>>>>>
>>>>> +------------------------+-------------+----------------+
>>>>> | iperf3 TCP benchmarks  | Stock       | Patched with   |
>>>>> | to Debian VM 120s      |             | fq_codel qdisc |
>>>>> | vhost pinned to core 0 |             |                |
>>>>> +------------------------+-------------+----------------+
>>>>> | TAP                    | 22.0 Gbit/s | 22.0 Gbit/s    |
>>>>> |  +                     |             |                |
>>>>> | vhost-net              |             |                |
>>>>> +------------------------+-------------+----------------+
>>>>>
>>>>> +---------------------------+-------------+----------------+
>>>>> | iperf3 TCP benchmarks     | Stock       | Patched with   |
>>>>> | to Debian VM 120s         |             | fq_codel qdisc |
>>>>> | vhost pinned to core 0    |             |                |
>>>>> | *4 iperf3 client threads* |             |                |
>>>>> +---------------------------+-------------+----------------+
>>>>> | TAP                       | 21.4 Gbit/s | 21.5 Gbit/s    |
>>>>> |  +                        |             |                |
>>>>> | vhost-net                 |             |                |
>>>>> +---------------------------+-------------+----------------+
>>>>
>>>> What are your thoughts on this?
>>>>
>>>> Thanks!
>>>>
>>>>
>>>
>>> Thanks
>>>
>>
> 

