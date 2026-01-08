Return-Path: <kvm+bounces-67354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E53D01747
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 08:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0BEBB307DA3B
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 07:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C8835E53E;
	Thu,  8 Jan 2026 07:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="KcwMKLEx"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71062359F96;
	Thu,  8 Jan 2026 07:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767858069; cv=none; b=qgZeogd9jQ2VTtQusd0lTcBH3krIHVmCPPlUPKe4EsBbUp+i52DAvrOQ7yRf9dJqGG9vY9G5+4o/Uthse0mSiA3YF++kEt5kULwPD6mttghqqsFTFi/3GrP8JHuo5r8tL6toajDeDTjbJ/HgCtrjfIp9+2HBIO0f6oSgbJfYh1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767858069; c=relaxed/simple;
	bh=doRNw1uXKoJpLg0Ws7oSdKOfwZptMBa33NGMaNdwmBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aUa+lvOm3ay79lQBEa0Rv9Zmmalx7HufnS+DcVqPP0e6FzRy1Dnmh0qqP7E+UOsJmhaI6rpRb09dS7WUTO5nsYMscQmcbDvHLE5AzhjmSAGDy5vNNGwhGJaVxXOu3zSWekt3vE78G4azLZBaq7xuJEREmgWZwH7wN7fEtx9O6hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=KcwMKLEx; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.121] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 6087eq3O027898
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Jan 2026 08:40:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767858053;
	bh=doRNw1uXKoJpLg0Ws7oSdKOfwZptMBa33NGMaNdwmBU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KcwMKLEx4DEfB2Ic3LOZ5xzTK3Y5fOyWL+ASk4vhrWKkIZe8PUm2r6401bQANsgES
	 O6KpHp4BDieOq0bidWjwKoY+RdyslwXeLXVBEqTnskOiCH1vn9Ve+N6dzozQzVm8ZK
	 hZZyXA1oQyVY2/yhUXGaBkUlWxjJrSsX06Perei0=
Message-ID: <1e30464c-99ae-441e-bb46-6d0485d494dc@tu-dortmund.de>
Date: Thu, 8 Jan 2026 08:40:51 +0100
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
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEuSiEcyaeFeZd0=RgNpviJgNvUDq_ctjeMLT5jZTgRkwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/8/26 04:38, Jason Wang wrote:
> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_consume()
>> and wake the corresponding netdev subqueue when consuming an entry frees
>> space in the underlying ptr_ring.
>>
>> Stopping of the netdev queue when the ptr_ring is full will be introduced
>> in an upcoming commit.
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>> ---
>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
>>  2 files changed, 45 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>> index 1197f245e873..2442cf7ac385 100644
>> --- a/drivers/net/tap.c
>> +++ b/drivers/net/tap.c
>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q,
>>         return ret ? ret : total;
>>  }
>>
>> +static void *tap_ring_consume(struct tap_queue *q)
>> +{
>> +       struct ptr_ring *ring = &q->ring;
>> +       struct net_device *dev;
>> +       void *ptr;
>> +
>> +       spin_lock(&ring->consumer_lock);
>> +
>> +       ptr = __ptr_ring_consume(ring);
>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
>> +               rcu_read_lock();
>> +               dev = rcu_dereference(q->tap)->dev;
>> +               netif_wake_subqueue(dev, q->queue_index);
>> +               rcu_read_unlock();
>> +       }
>> +
>> +       spin_unlock(&ring->consumer_lock);
>> +
>> +       return ptr;
>> +}
>> +
>>  static ssize_t tap_do_read(struct tap_queue *q,
>>                            struct iov_iter *to,
>>                            int noblock, struct sk_buff *skb)
>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>>                                         TASK_INTERRUPTIBLE);
>>
>>                 /* Read frames from the queue */
>> -               skb = ptr_ring_consume(&q->ring);
>> +               skb = tap_ring_consume(q);
>>                 if (skb)
>>                         break;
>>                 if (noblock) {
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 8192740357a0..7148f9a844a4 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>         return total;
>>  }
>>
>> +static void *tun_ring_consume(struct tun_file *tfile)
>> +{
>> +       struct ptr_ring *ring = &tfile->tx_ring;
>> +       struct net_device *dev;
>> +       void *ptr;
>> +
>> +       spin_lock(&ring->consumer_lock);
>> +
>> +       ptr = __ptr_ring_consume(ring);
>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
> 
> I guess it's the "bug" I mentioned in the previous patch that leads to
> the check of __ptr_ring_consume_created_space() here. If it's true,
> another call to tweak the current API.
> 
>> +               rcu_read_lock();
>> +               dev = rcu_dereference(tfile->tun)->dev;
>> +               netif_wake_subqueue(dev, tfile->queue_index);
> 
> This would cause the producer TX_SOFTIRQ to run on the same cpu which
> I'm not sure is what we want.

What else would you suggest calling to wake the queue?

> 
>> +               rcu_read_unlock();
>> +       }
> 
> Btw, this function duplicates a lot of logic of tap_ring_consume() we
> should consider to merge the logic.

Yes, it is largely the same approach, but it would require accessing the
net_device each time.

> 
>> +
>> +       spin_unlock(&ring->consumer_lock);
>> +
>> +       return ptr;
>> +}
>> +
>>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>  {
>>         DECLARE_WAITQUEUE(wait, current);
>>         void *ptr = NULL;
>>         int error = 0;
>>
>> -       ptr = ptr_ring_consume(&tfile->tx_ring);
>> +       ptr = tun_ring_consume(tfile);
> 
> I'm not sure having a separate patch like this may help. For example,
> it will introduce performance regression.

I ran benchmarks for the whole patch set with noqueue (where the queue is
not stopped to preserve the old behavior), as described in the cover
letter, and observed no performance regression. This leads me to conclude
that there is no performance impact because of this patch when the queue
is not stopped.

> 
>>         if (ptr)
>>                 goto out;
>>         if (noblock) {
>> @@ -2131,7 +2152,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>>
>>         while (1) {
>>                 set_current_state(TASK_INTERRUPTIBLE);
>> -               ptr = ptr_ring_consume(&tfile->tx_ring);
>> +               ptr = tun_ring_consume(tfile);
>>                 if (ptr)
>>                         break;
>>                 if (signal_pending(current)) {
>> --
>> 2.43.0
>>
> 
> Thanks
> 

