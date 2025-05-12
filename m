Return-Path: <kvm+bounces-46171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 142B1AB37DC
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 14:54:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16E12862F83
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 12:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEDB293B6B;
	Mon, 12 May 2025 12:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="n7bDYyPR"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6C72AE68;
	Mon, 12 May 2025 12:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747054377; cv=none; b=T2Np/elBHKSuwbsZbjTvJT305AlGaYWtprur3n5Rwxe8r94HehEmPZ6FITQPSE5jHO5ZOJU/7omB0pVPrbuCQVfMeFZ0NJDIKiYj5Ure8sfpA9E9euveSLItmNXLLvAu5/AMzU2QqiAA9z60YYikvzYQRSWGRf8dJHugTiHkp3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747054377; c=relaxed/simple;
	bh=zECTQVlS7BoMjRy+nopuy5oEj3xxBDKN5vQJhKE6xzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGTW1wmNy/7SBv1YiGiPWDl1GAW//zoL6Nx010ma13fB+6f0+RJ23I1KZLuLQt8B+YFxZ5Tph88QTCsoAAYCdAtY8OgoNnM7R6o95dZvStmM0w1Vm/xf+fnkpTVY3bQPhO7j0e9n6MoWM7fcOXBef48Q4jA5vup7Bk+IROYwsqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=n7bDYyPR; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uESBp-00C5t2-Df; Mon, 12 May 2025 14:23:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=qGVhATLfDHfKI3zxu6jJB+4o6rhgxGO4+J2Ibmk67sA=; b=n7bDYyPRLhNNg3V1RCrSWfCkzh
	2Tc6oSpJceBKv6vVofPdd1P3Y+fuHPzd2ap3wSuC0QFW6Gnb/4YWRZgk5maPmG1fJ2pWQWrW1dlL3
	k+NYZoYtsBMc365Sh7e9zsrNHvy6HGvn7ScGv4z3bE8Ko/ZL1WaVf/Q7YlM5MqggpcY/sZbsWsAEp
	0dn1UdWh3ebefOLUcclU+J8V6ck+ne59icCt5lVC63kYZKVInmjhca+68i1veSjGm7NPJcorEbt+K
	j0Or+l8ASbVL86mBkVfVbVugyVLBeNRgoh3Xiga+iaKoNLNlhEMBwS9Y3cLogDGxcGVBn2yzVVsqw
	nkB90NDw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uESBn-0000sF-KA; Mon, 12 May 2025 14:23:24 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uESBd-007iLF-FJ; Mon, 12 May 2025 14:23:13 +0200
Message-ID: <720f6986-8b32-4d00-b309-66a6f0c1ca40@rbox.co>
Date: Mon, 12 May 2025 14:23:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 3/3] vsock/test: Expand linger test to ensure
 close() does not misbehave
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
 <20250501-vsock-linger-v4-3-beabbd8a0847@rbox.co>
 <g5wemyogxthe43rkigufv7p5wrkegbdxbleujlsrk45dmbmm4l@qdynsbqfjwbk>
 <CAGxU2F59O7QK2Q7TeaP6GU9wHrDMTpcO94TKz72UQndXfgNLVA@mail.gmail.com>
 <ff959c3e-4c47-4f93-8ab8-32446bb0e0d0@rbox.co>
 <CAGxU2F77OT5_Pd6EUF1QcvPDC38e-nuhfwKmPSTau262Eey5vQ@mail.gmail.com>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <CAGxU2F77OT5_Pd6EUF1QcvPDC38e-nuhfwKmPSTau262Eey5vQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 10:26, Stefano Garzarella wrote:
> On Wed, 7 May 2025 at 00:47, Michal Luczaj <mhal@rbox.co> wrote:
>>
>> On 5/6/25 11:46, Stefano Garzarella wrote:
>>> On Tue, 6 May 2025 at 11:43, Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>>
>>>> On Thu, May 01, 2025 at 10:05:24AM +0200, Michal Luczaj wrote:
>>>>> There was an issue with SO_LINGER: instead of blocking until all queued
>>>>> messages for the socket have been successfully sent (or the linger timeout
>>>>> has been reached), close() would block until packets were handled by the
>>>>> peer.
>>>>
>>>> This is a new behaviour that only new kernels will follow, so I think
>>>> it is better to add a new test instead of extending a pre-existing test
>>>> that we described as "SOCK_STREAM SO_LINGER null-ptr-deref".
>>>>
>>>> The old test should continue to check the null-ptr-deref also for old
>>>> kernels, while the new test will check the new behaviour, so we can skip
>>>> the new test while testing an old kernel.
>>
>> Right, I'll split it.
>>
>>> I also saw that we don't have any test to verify that actually the
>>> lingering is working, should we add it since we are touching it?
>>
>> Yeah, I agree we should. Do you have any suggestion how this could be done
>> reliably?
> 
> Can we play with SO_VM_SOCKETS_BUFFER_SIZE like in credit-update tests?
> 
> One peer can set it (e.g. to 1k), accept the connection, but without
> read anything. The other peer can set the linger timeout, send more
> bytes than the buffer size set by the receiver.
> At this point the extra bytes should stay on the sender socket buffer,
> so we can do the close() and it should time out, and we can check if
> it happens.
> 
> WDYT?

Haven't we discussed this approach in [1]? I've reported that I can't make
it work. But maybe I'm misunderstanding something, please see the code below.

[1]:
https://lore.kernel.org/netdev/df2d51fd-03e7-477f-8aea-938446f47864@rbox.co/

import termios, time
from socket import *

SIOCOUTQ = termios.TIOCOUTQ
VMADDR_CID_LOCAL = 1
SZ = 1024

def set_linger(s, timeout):
	optval = (timeout << 32) | 1
	s.setsockopt(SOL_SOCKET, SO_LINGER, optval)
	assert s.getsockopt(SOL_SOCKET, SO_LINGER) == optval

def set_bufsz(s, size):
	s.setsockopt(AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE, size)
	assert s.getsockopt(AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE) == size

def check_lingering(addr):
	lis = socket(AF_VSOCK, SOCK_STREAM)
	lis.bind(addr)
	lis.listen()
	set_bufsz(lis, SZ)

	s = socket(AF_VSOCK, SOCK_STREAM)
	set_linger(s, 5)
	s.connect(lis.getsockname())

	p, _ = lis.accept()

	s.send(b'x')
	p.recv(1)

	print("sending...")
	s.send(b'x' * (SZ+1)) # blocks
	print("sent")

	print("closing...")
	ts = time.time()
	s.close()
	print("done in %ds" % (time.time() - ts))

check_lingering((VMADDR_CID_LOCAL, 1234))


