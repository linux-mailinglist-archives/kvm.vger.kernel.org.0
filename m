Return-Path: <kvm+bounces-44086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F03A9A424
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7299216733B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9749221D5AA;
	Thu, 24 Apr 2025 07:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EnbufuRh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9749421D3EC
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745479746; cv=none; b=BQpwBSuC0Nmnkyh6wqvUNmtor+aPBfwtTYGSJ87NK2/vV6gvsswmdVbLy4zNE0/EQ2LYVuEYkye6NRiARHylpA0JeArG3na9FaW7SASm068rEEr0QXuiBQpC7I0VCbCijWTWIHhCAExgZwVuYNOLGbocBevhOtbr7SSxGjIqD9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745479746; c=relaxed/simple;
	bh=58VbzL7WBIj/gt8GsrfhUli+bScIim9A36WA+y91mr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRBFd8b80JR2QDubf3687+ZIIchPXn+tvmunNhH7aD4F+RyvOKIvB1hsKIog6s97jOxaa48tbS+D+ka9EE8yg/JXZKtNpGxxqHSt8qDpbNBmZMUTJVzR+uGB3sKrSgiDvxjaErzJngIsG7XHU3W48TwBvXZq5mwYPGYLmvJTRjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EnbufuRh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745479743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bwzIUNmrfNNFBn2a+tyDnc0Y7kp3uVqhE1QTaSwZ2sg=;
	b=EnbufuRhVKQ3MScffgEbzj5OJeRj/jQH1Pcj1cEcnt5f59amLCb8wkYDEMJrjFfWIFtWPT
	zVwqdxm7O+ssavoo/3N1S4UqgI1nqgBbcJN2aRjoMFfVtRRMhEEuGxUWhEFk/W28Y8eyvO
	TzG/IMwoARWTWaPzzl9bp9RQI2UMs8o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-t8_Fnh-hOJ2aTu7ImTnizA-1; Thu, 24 Apr 2025 03:28:59 -0400
X-MC-Unique: t8_Fnh-hOJ2aTu7ImTnizA-1
X-Mimecast-MFC-AGG-ID: t8_Fnh-hOJ2aTu7ImTnizA_1745479739
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a064c45f03so304319f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 00:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745479738; x=1746084538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bwzIUNmrfNNFBn2a+tyDnc0Y7kp3uVqhE1QTaSwZ2sg=;
        b=LdfiAYRnsc2lPlECNKy9U0apOrMg5l6mRqiYEo4sSeQ2UvgwJFz4O3ZJspa46peaVh
         UfZivpiy1SDyF+XBJxx6A1XaXh2VZrZn+SRYJO7eLjIjZXbBYAwx1ROG2qO/xVyD3JSt
         4Vd5m1u2DtbATV04VmqT3D65A36hV/iVwc2uVCWCWePPJWRPfTwxyTgK1x7Yo/+Fr3sl
         ILiNvpP4EkRejxfkHIMSWPmVtjRJuM+NMWWz1ycxTLQyiOlrFmFLy2WW+66YfSmbXeYW
         wYQNb7jXh1RCeKk7RqcmkS6MQDvt9QyKAXn8ScLzpoSbOcvHAT8K5PEuwZkn/RTPKsQD
         eKfw==
X-Forwarded-Encrypted: i=1; AJvYcCV9Qh+hXKg23bUtZPm6trtyicUa/lmuwEUox+nqgqDavxpSInxi7z8P3tIjSLHhdMX8dNE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnnWzz64ziZU2emWg2QKb/Di6BrIdMWvi2kWD11ZVf+VERNieI
	f6NZ7mvB41M1ALdDiQlELcAz6WfD5v+0cnwv3uqVqDEzX5IAqoRJNTHAVL742pO/tJdhICRbp7o
	pnhMD+1qS0D2p6eqgFts2vCyWpJ2x4kWqGEWjvUHwZ8j/aAM0jQ==
X-Gm-Gg: ASbGncvwg5/RvcRtuIK/9CevmXk0PeOL7RaPXAr9C+upQ+00iSELad81wHLEHO3bBaB
	V68IWcKF4o/t0WAPyVSv9p+GJ0QLYUxCguI00g7pxIa8zlc32A1xPWunMx2IMfm58o6ePIFzkdN
	slEgl7rI0MvHJbPfSscnTsNVVa8oRQ/Jd1UuQ0DY1TFlZaXlWfbqE/v8YmkGRM1yvI9cFevXIsI
	WB1YLfXEAbNAIqRUz3nYzg0BSVFvh5gmspsX3hVTBExUVu9T3ajVdXcZRxscDABHqcK14CX5BEL
	93i3hWQy+GBvd/XM/g==
X-Received: by 2002:a05:6000:1ac8:b0:391:952:c74a with SMTP id ffacd0b85a97d-3a06d64c740mr949969f8f.8.1745479738597;
        Thu, 24 Apr 2025 00:28:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuUa0YduITc/StEvDnDrjkIBytecQS6p/m5AkoGY//NHIa97UcP6cmwP+3zmnYPvZk3FjUWA==
X-Received: by 2002:a05:6000:1ac8:b0:391:952:c74a with SMTP id ffacd0b85a97d-3a06d64c740mr949939f8f.8.1745479738094;
        Thu, 24 Apr 2025 00:28:58 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.217.208])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d569b38sm1080863f8f.100.2025.04.24.00.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 00:28:57 -0700 (PDT)
Date: Thu, 24 Apr 2025 09:28:50 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Luigi Leonardi <leonardi@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] vsock: Linger on unsent data
Message-ID: <wnonuiluxgy6ixoioi57lwlixfgcu27kcewv4ajb3k3hihi773@nv3om2t3tsgo>
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
 <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co>
 <km2nad6hkdi3ngtho2xexyhhosh4aq37scir2hgxkcfiwes2wd@5dyliiq7cpuh>
 <k47d2h7dwn26eti2p6nv2fupuybabvbexwinvxv7jnfbn6o3ep@cqtbaqlqyfrq>
 <ee09df9b-9804-49de-b43b-99ccd4cbe742@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ee09df9b-9804-49de-b43b-99ccd4cbe742@rbox.co>

On Wed, Apr 23, 2025 at 11:06:33PM +0200, Michal Luczaj wrote:
>On 4/23/25 18:34, Stefano Garzarella wrote:
>> On Wed, Apr 23, 2025 at 05:53:12PM +0200, Luigi Leonardi wrote:
>>> Hi Michal,
>>>
>>> On Mon, Apr 21, 2025 at 11:50:41PM +0200, Michal Luczaj wrote:
>>>> Currently vsock's lingering effectively boils down to waiting (or timing
>>>> out) until packets are consumed or dropped by the peer; be it by receiving
>>>> the data, closing or shutting down the connection.
>>>>
>>>> To align with the semantics described in the SO_LINGER section of man
>>>> socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>>>> of a lingering close(): instead of waiting for all data to be handled,
>>>> block until data is considered sent from the vsock's transport point of
>>>> view. That is until worker picks the packets for processing and decrements
>>>> virtio_vsock_sock::bytes_unsent down to 0.
>>>>
>>>> Note that such lingering is limited to transports that actually implement
>>>> vsock_transport::unsent_bytes() callback. This excludes Hyper-V and VMCI,
>>>> under which no lingering would be observed.
>>>>
>>>> The implementation does not adhere strictly to man page's interpretation of
>>>> SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>>>>
>>>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>>>> ---
>>>> net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++--
>>>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>> index 7f7de6d8809655fe522749fbbc9025df71f071bd..aeb7f3794f7cfc251dde878cb44fdcc54814c89c 100644
>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>> @@ -1196,12 +1196,21 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
>>>> {
>>>> 	if (timeout) {
>>>> 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>>> +		ssize_t (*unsent)(struct vsock_sock *vsk);
>>>> +		struct vsock_sock *vsk = vsock_sk(sk);
>>>> +
>>>> +		/* Some transports (Hyper-V, VMCI) do not implement
>>>> +		 * unsent_bytes. For those, no lingering on close().
>>>> +		 */
>>>> +		unsent = vsk->transport->unsent_bytes;
>>>> +		if (!unsent)
>>>> +			return;
>>>
>>> IIUC if `unsent_bytes` is not implemented, virtio_transport_wait_close
>>> basically does nothing. My concern is that we are breaking the
>>> userspace due to a change in the behavior: Before this patch, with a
>>> vmci/hyper-v transport, this function would wait for SOCK_DONE to be
>>> set, but not anymore.
>>
>> Wait, we are in virtio_transport_common.c, why we are talking about
>> Hyper-V and VMCI?
>>
>> I asked to check `vsk->transport->unsent_bytes` in the v1, because this
>> code was part of af_vsock.c, but now we are back to virtio code, so I'm
>> confused...
>
>Might your confusion be because of similar names?

In v1 this code IIRC was in af_vsock.c, now you pushed back on virtio 
common code, so I still don't understand how 
virtio_transport_wait_close() can be called with vmci or hyper-v 
transports.

Can you provide an example?

>vsock_transport::unsent_bytes != virtio_vsock_sock::bytes_unsent
>
>I agree with Luigi, it is a breaking change for userspace depending on a
>non-standard behaviour. What's the protocol here; do it anyway, then see if
>anyone complains?
>
>As for Hyper-V and VMCI losing the "lingering", do we care? And if we do,
>take Hyper-V, is it possible to test any changes without access to
>proprietary host/hypervisor?
>

Again, how this code can be called when using vmci or hyper-v 
transports?

If we go back on v1 implementation, I can understand it, but with this 
version I really don't understand the scenario.

Stefano


