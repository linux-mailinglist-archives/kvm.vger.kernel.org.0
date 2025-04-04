Return-Path: <kvm+bounces-42625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 151AFA7B88B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37191189C50E
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 08:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E085199230;
	Fri,  4 Apr 2025 08:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Tp3yRMd4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB7915C15F;
	Fri,  4 Apr 2025 08:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743753893; cv=none; b=UTz3stWyhCEFNb+RFC1s/zixTa/pMazLRo5i0Y9cdvTA+VtCt1MgUOJND/+YyMrEMe2sOOW300Ndeu/abrsT6ItEEx72jWqTHX7mn4/Mr2P4tYy2SPwOn/WOOS9oNkHUjBi4vMjyOSLoZSwNvz9BlKH8C7HD8s8Qy2e2s5RASQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743753893; c=relaxed/simple;
	bh=zgxljn3pdO7HKVjvDZCDLSoX0wHxgeY4k9s/aZAWLyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nMV1yJY+UsAkW1j2ZUnpcKcNoc6MXCI7veb6I252QeLnErgd1udkybr0VzBGFw19dyfIHN+bE13Zu4JJB1N4KGbRS9swyG3c5vcEtLj09CMMjhadw3hnU7681wj+HqnnaoniE3XP3mHf4F6Me9wKmqMDkrIiPX5fJLOdzALDwPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Tp3yRMd4; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743753889; x=1775289889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b1JqVe+LlcQEqQ5UTMrgb294HSTh8vlr/zAQ/LotKnA=;
  b=Tp3yRMd4dnMVrZxk4fsVuxx5rfcQKqHFQyOkWRqNDuzv8WufWnwM8xJw
   7xSYG83fs3eK3QCltSktJJa9pBnLNNuRMEPPNpbQ2ypoY6o7HQ20nLN8j
   XGnzHlEhyssb0MiDd0kCiRJQeNhZGgs07oL5uYJlUJUDzXWL2qNx1y3+E
   Q=;
X-IronPort-AV: E=Sophos;i="6.15,187,1739836800"; 
   d="scan'208";a="711049091"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2025 08:04:45 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:9580]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.226:2525] with esmtp (Farcaster)
 id 0ebe5713-faf2-4492-b600-33b458c6eb8b; Fri, 4 Apr 2025 08:04:44 +0000 (UTC)
X-Farcaster-Flow-ID: 0ebe5713-faf2-4492-b600-33b458c6eb8b
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 4 Apr 2025 08:04:44 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Fri, 4 Apr 2025
 08:04:40 +0000
Message-ID: <32ca5221-5b25-4bfd-acd7-9eebae8c3635@amazon.com>
Date: Fri, 4 Apr 2025 10:04:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vsock/virtio: Remove queued_replies pushback logic
To: "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>
CC: <netdev@vger.kernel.org>, Stefano Garzarella <sgarzare@redhat.com>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<kvm@vger.kernel.org>, Asias He <asias@redhat.com>, Paolo Abeni
	<pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	<edumazet@google.com>, "David S . Miller" <davem@davemloft.net>,
	<nh-open-source@amazon.com>
References: <20250401201349.23867-1-graf@amazon.com>
 <20250402161424.GA305204@fedora>
 <20250403073111-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20250403073111-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D037UWC001.ant.amazon.com (10.13.139.197) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)


On 03.04.25 14:21, Michael S. Tsirkin wrote:
> On Wed, Apr 02, 2025 at 12:14:24PM -0400, Stefan Hajnoczi wrote:
>> On Tue, Apr 01, 2025 at 08:13:49PM +0000, Alexander Graf wrote:
>>> Ever since the introduction of the virtio vsock driver, it included
>>> pushback logic that blocks it from taking any new RX packets until the
>>> TX queue backlog becomes shallower than the virtqueue size.
>>>
>>> This logic works fine when you connect a user space application on the
>>> hypervisor with a virtio-vsock target, because the guest will stop
>>> receiving data until the host pulled all outstanding data from the VM.
>>>
>>> With Nitro Enclaves however, we connect 2 VMs directly via vsock:
>>>
>>>    Parent      Enclave
>>>
>>>      RX -------- TX
>>>      TX -------- RX
>>>
>>> This means we now have 2 virtio-vsock backends that both have the pushback
>>> logic. If the parent's TX queue runs full at the same time as the
>>> Enclave's, both virtio-vsock drivers fall into the pushback path and
>>> no longer accept RX traffic. However, that RX traffic is TX traffic on
>>> the other side which blocks that driver from making any forward
>>> progress. We're now in a deadlock.
>>>
>>> To resolve this, let's remove that pushback logic altogether and rely on
>>> higher levels (like credits) to ensure we do not consume unbounded
>>> memory.
>> The reason for queued_replies is that rx packet processing may emit tx
>> packets. Therefore tx virtqueue space is required in order to process
>> the rx virtqueue.
>>
>> queued_replies puts a bound on the amount of tx packets that can be
>> queued in memory so the other side cannot consume unlimited memory. Once
>> that bound has been reached, rx processing stops until the other side
>> frees up tx virtqueue space.
>>
>> It's been a while since I looked at this problem, so I don't have a
>> solution ready. In fact, last time I thought about it I wondered if the
>> design of virtio-vsock fundamentally suffers from deadlocks.
>>
>> I don't think removing queued_replies is possible without a replacement
>> for the bounded memory and virtqueue exhaustion issue though. Credits
>> are not a solution - they are about socket buffer space, not about
>> virtqueue space, which includes control packets that are not accounted
>> by socket buffer space.
>
> Hmm.
> Actually, let's think which packets require a response.
>
> VIRTIO_VSOCK_OP_REQUEST
> VIRTIO_VSOCK_OP_SHUTDOWN
> VIRTIO_VSOCK_OP_CREDIT_REQUEST
>
>
> the response to these always reports a state of an existing socket.
> and, only one type of response is relevant for each socket.
>
> So here's my suggestion:
> stop queueing replies on the vsock device, instead,
> simply store the response on the socket, and create a list of sockets
> that have replies to be transmitted
>
>
> WDYT?


Wouldn't that create the same problem again? The socket will eventually 
push back any new data that it can take because its FIFO is full. At 
that point, the "other side" could still have a queue full of requests 
on exactly that socket that need to get processed. We can now not pull 
those packets off the virtio queue, because we can not enqueue responses.

But that means now the one queue is blocked from making forward 
progress, because we are applying back pressure. And that means 
everything can grind to a halt and we have the same deadlock this patch 
is trying to fix.

I don't see how we can possibly guarantee a lossless data channel over a 
tiny wire (single, fixed size, in order virtio ring) while also 
guaranteeing bounded memory usage. One of the constraints need to go: 
Either we are no longer lossless or we effectively allow unbounded 
memory usage.


Alex


