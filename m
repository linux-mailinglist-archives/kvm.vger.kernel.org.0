Return-Path: <kvm+bounces-44884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42342AA485A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 12:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B5C31C061DB
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A63C248F69;
	Wed, 30 Apr 2025 10:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="LdSsqH6P"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615DA21ADAB;
	Wed, 30 Apr 2025 10:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746008951; cv=none; b=Dk/gQvG6G6RsE9LFcWq2J9WC+nv9j9Oca+OGv+kkh0ZbI+xzUULyH/G1o/Z9leGGvHwQXdKh247/0zxZ8heunEMLUKfps8TAqPaaWJiM/PGXJTG4Nn399jSywlmvMtn1xLFy9nMYjr2Q8nsswhLdma6wHPb4Zff9cdYIyE7Dvtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746008951; c=relaxed/simple;
	bh=pM465M1gUSTXgy6ApQoIj3s3S8XdAFXFLP63XZjXkIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YXjpt/aROIDc6GxNaeWyPXS1jU18XLqN2nUL890S3727LClgFhLJKAkh8uyrlhc5yDgZ6qfrxGQcGIWfSLv4mzljfDRAl+Sw36V/QOMLeQ9f4hYb9uHtNr8MMAmsYA+VUtibN4IvqBZinsg9LgcDzFzIKXl9Y3m38GEGdI1KEV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=LdSsqH6P; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA4gV-006P72-D9; Wed, 30 Apr 2025 12:28:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=a3Vdz3L4ux7x7a4EC16mwI0DPhJL1mCNStK+TchLXCQ=; b=LdSsqH6PQV5lBPEFpd380a9iBv
	3wUCeW0lZoKH7+NmJsST7dEpjZraxwXsKWx+OKKyLEhG7gYhu0OMSCUzTZsFhjydyHUfBrMjEdxno
	m5YGYSIbO2o78XXRLJ4NoAEBuHCCSd1c8nhV6qGKi/iWc+14ernge0M9TnNNB0qMqLt8oyUSl0fsO
	pVDcFvpy47kfbdQ56mx+yKnQLw51Yg0AqBVPlOyJi49ubNLwD9ca5AgClNAS4HGdW4rSANbSwStZS
	3jRGuj0lAO4l0ndqZ7S/61F7LDZC3/JMrSjCoNoWmWQMQWILPR0PWo46SX1CiMjxsitiP7ughARaO
	TBSA0dyA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA4gU-0004EV-Ae; Wed, 30 Apr 2025 12:28:58 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA4gM-000mo7-DV; Wed, 30 Apr 2025 12:28:50 +0200
Message-ID: <23bcd402-86f9-4c05-bb83-360c8e4438fc@rbox.co>
Date: Wed, 30 Apr 2025 12:28:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 1/4] vsock/virtio: Linger on unsent data
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
 <20250430-vsock-linger-v3-1-ddbe73b53457@rbox.co>
 <x3kkxnrqujqjkrtptr2qdd3227ncof2vb7jbrcg3aibvwjfqxa@hbinpxjuk3qe>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <x3kkxnrqujqjkrtptr2qdd3227ncof2vb7jbrcg3aibvwjfqxa@hbinpxjuk3qe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/30/25 11:26, Stefano Garzarella wrote:
> On Wed, Apr 30, 2025 at 11:10:27AM +0200, Michal Luczaj wrote:
>> Currently vsock's lingering effectively boils down to waiting (or timing
>> out) until packets are consumed or dropped by the peer; be it by receiving
>> the data, closing or shutting down the connection.
>>
>> To align with the semantics described in the SO_LINGER section of man
>> socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>> of a lingering close(): instead of waiting for all data to be handled,
>> block until data is considered sent from the vsock's transport point of
>> view. That is until worker picks the packets for processing and decrements
>> virtio_vsock_sock::bytes_unsent down to 0.
>>
>> Note that (some interpretation of) lingering was always limited to
>> transports that called virtio_transport_wait_close() on transport release.
>> This does not change, i.e. under Hyper-V and VMCI no lingering would be
>> observed.
>>
>> The implementation does not adhere strictly to man page's interpretation of
>> SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>>
>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 8 ++++++--
>> 1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 7f7de6d8809655fe522749fbbc9025df71f071bd..49c6617b467195ba385cc3db86caa4321b422d7a 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1196,12 +1196,16 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
>> {
>> 	if (timeout) {
>> 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>> +		ssize_t (*unsent)(struct vsock_sock *vsk);
>> +		struct vsock_sock *vsk = vsock_sk(sk);
>> +
>> +		unsent = vsk->transport->unsent_bytes;
> 
> Just use `virtio_transport_unsent_bytes`, we don't need to be generic on 
> transport here.

All right.

Thanks


