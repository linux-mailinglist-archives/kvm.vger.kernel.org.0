Return-Path: <kvm+bounces-35001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F24A08A89
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 468F87A471B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05FC208965;
	Fri, 10 Jan 2025 08:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KSJ+h6YE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7938C206F35
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736498368; cv=none; b=FIdIKwL5aI+U3Ny0uQuedxF2jYZy94zXLzJjV+CSs1bxiYPkv2EoQ2E5GoHCZ2YnOOSVq1Te91bW8ase7WiZcV0FAjBSooQ/nDYxX0UWL6HzZmHE1L0MtuhNvtzRwll4hLuhnUaTvpcDX91jbP/sXSFEVizSoMLvOfRWlkGPg/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736498368; c=relaxed/simple;
	bh=iJsV4mrkuXUAlTF79pi0keywbZpwBmWfcU2SNaEDdkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XOhykChjyhiVT8uH6hEHFqj11bHLe6RUDwEDYDLkr6zGXx3TxKQ5O8dz7QUMjct9B04NUTwsEyY5ox2Z05rbnY8u4uZa8XuSsJLPpD872cvX6qHzea52kHAm9tzQo+ohzhL7j8ABc933yaedCjV4Z8RDy7UYbUbOp5yiStej+ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KSJ+h6YE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736498365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CXoL+WQHSf+XTBr1CBk1hX3xSrp4GoYvIVG/Iw0rQu8=;
	b=KSJ+h6YEUU3Cq6jsmws5ap7RDmBv50VtXc3/2vbaer5oA1cyjZ00AV9TCNOFtEtzLqYL6U
	VgfbN7Bu5zoz5sG3+FCI6dqL97K3gV1CSmUTxBhtqE4wMln6v7IN45lzNUKbyr4asPnLA4
	FFKhe5GHNthmjrBh7KHASbb54m35PFg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-2XqdgrV0P0KI6RkEoPPtYQ-1; Fri, 10 Jan 2025 03:39:24 -0500
X-MC-Unique: 2XqdgrV0P0KI6RkEoPPtYQ-1
X-Mimecast-MFC-AGG-ID: 2XqdgrV0P0KI6RkEoPPtYQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43621907030so14203665e9.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:39:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736498363; x=1737103163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CXoL+WQHSf+XTBr1CBk1hX3xSrp4GoYvIVG/Iw0rQu8=;
        b=Ou8FMe357yrmR+9EUk5Yro19mqSlXz+ygrsMxix4c425kK2TKtfPa2ragiPitzmGX2
         XGCwLmu9KFAP5SSdKpIBI/JOCLKJ6IROV11cy6BGwM2vOyYW228JWVr/1XsJSqYBKkJQ
         0GVj0b9enaTJgwE2iLpx01yS39COOMKOjre/sjSKRD9mOjywzVOzRvQc2WVlhSrqNWXR
         t+vE633+fzrH3QwiwF1N76dGmA3BA0TrONUlFvst/JFpi+iVYzw2clxMxCN/8ThnQo0y
         1LCasOAfI7Jq/F4UWBX1ioMGS5Nua6/FD38HDYSGlViIhD48aC6wgO9gJqNgp/6Qlckt
         Kc5A==
X-Forwarded-Encrypted: i=1; AJvYcCVOnYJCKwBPFLEaafVRcr2Gt3Js29iVlkN9/PnTOtonNHlsqOkqhdWhwPSed0OJJ6pdvM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJG5+tg39xSlTOUUdvoZr8h7tO9jfKtykHuaSb7d6L0KYzPcnQ
	flGD6rdhAot0P81FHeSo1sSZREmIIcATnGoWRxKvNJlPpBEgDUVG26W3Z5unSqsyCTEDjzNyQHy
	dCR+zc8KvY/0j48GGLzro4+hqQpL8LS+ThDTpUZ1o2fOUrJhq4g==
X-Gm-Gg: ASbGncvNubvxF1IK0mkaAJPfmoA0uBQYa4v9iSIo3Pf/dK6tERDp96vWH3+jqqU46v8
	NKZdit2/vd7uzsEYZyiUNzfIXL/EVLf0S1UnTYQhcpB9fDVsxhWgixZpK+6uTvkU5Oot8caKeOM
	CoGOnSj6X8Fz5AcQaA3Y0g7x7Uo0CsGmXwe62dz059cq4xoaqSjxJ0a9VZ+i5+1nbN0Qbi7sYHA
	jsmOVbOqR/N+bdsFh2XcrEBR/krQ81kdceEF4mp4SVbym9qJ3q9gYeZsg==
X-Received: by 2002:a5d:6483:0:b0:385:fabf:13d5 with SMTP id ffacd0b85a97d-38a8730d55cmr9428494f8f.25.1736498362847;
        Fri, 10 Jan 2025 00:39:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxWFzsARmI1wzAKHZHOe31pA0LmSwGyB/GI2e+cfrQc0ZXGW0pe8rXUAHFnRj3NAhqLwSr2g==
X-Received: by 2002:a5d:6483:0:b0:385:fabf:13d5 with SMTP id ffacd0b85a97d-38a8730d55cmr9428445f8f.25.1736498362219;
        Fri, 10 Jan 2025 00:39:22 -0800 (PST)
Received: from sgarzare-redhat ([5.77.78.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1b44sm3942825f8f.90.2025.01.10.00.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:39:21 -0800 (PST)
Date: Fri, 10 Jan 2025 09:39:16 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Wongi Lee <qwerty@theori.io>, 
	"David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>, 
	virtualization@lists.linux.dev, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Luigi Leonardi <leonardi@redhat.com>, bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Hyunwoo Kim <v4bel@theori.io>, kvm@vger.kernel.org
Subject: Re: [PATCH net 1/2] vsock/virtio: discard packets if the transport
 changes
Message-ID: <2wsi6sehglavj75jr5gugdq6oqtor7gonx5zhmetzqwvfwc5gn@e3xlsfvygfgj>
References: <20250108180617.154053-1-sgarzare@redhat.com>
 <20250108180617.154053-2-sgarzare@redhat.com>
 <2b3062e3-bdaa-4c94-a3c0-2930595b9670@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2b3062e3-bdaa-4c94-a3c0-2930595b9670@rbox.co>

On Thu, Jan 09, 2025 at 02:34:28PM +0100, Michal Luczaj wrote:
>On 1/8/25 19:06, Stefano Garzarella wrote:
>> If the socket has been de-assigned or assigned to another transport,
>> we must discard any packets received because they are not expected
>> and would cause issues when we access vsk->transport.
>>
>> A possible scenario is described by Hyunwoo Kim in the attached link,
>> where after a first connect() interrupted by a signal, and a second
>> connect() failed, we can find `vsk->transport` at NULL, leading to a
>> NULL pointer dereference.
>>
>> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>> Reported-by: Hyunwoo Kim <v4bel@theori.io>
>> Reported-by: Wongi Lee <qwerty@theori.io>
>> Closes: https://lore.kernel.org/netdev/Z2LvdTTQR7dBmPb5@v4bel-B760M-AORUS-ELITE-AX/
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  net/vmw_vsock/virtio_transport_common.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 9acc13ab3f82..51a494b69be8 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1628,8 +1628,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>>
>>  	lock_sock(sk);
>>
>> -	/* Check if sk has been closed before lock_sock */
>> -	if (sock_flag(sk, SOCK_DONE)) {
>> +	/* Check if sk has been closed or assigned to another transport before
>> +	 * lock_sock (note: listener sockets are not assigned to any transport)
>> +	 */
>> +	if (sock_flag(sk, SOCK_DONE) ||
>> +	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
>>  		(void)virtio_transport_reset_no_sock(t, skb);
>>  		release_sock(sk);
>>  		sock_put(sk);
>
>FWIW, I've tried simplifying Hyunwoo's repro to toy with some tests. Ended
>up with
>
>```
>from threading import *
>from socket import *
>from signal import *
>
>def listener(tid):
>	while True:
>		s = socket(AF_VSOCK, SOCK_SEQPACKET)
>		s.bind((1, 1234))
>		s.listen()
>		pthread_kill(tid, SIGUSR1)
>
>signal(SIGUSR1, lambda *args: None)
>Thread(target=listener, args=[get_ident()]).start()
>
>while True:
>	c = socket(AF_VSOCK, SOCK_SEQPACKET)
>	c.connect_ex((1, 1234))
>	c.connect_ex((42, 1234))
>```
>
>which gives me splats with or without this patch.

Thanks again for the repro, it worked for me, only if a G2H transport
wasn't loaeded (e.g. virtio-vsock driver).

I tested on the v2 I just sent [1], and I can't see the kernel oops
anymore, but please do test/review too.

Thanks,
Stefano

[1] https://lore.kernel.org/netdev/20250110083511.30419-1-sgarzare@redhat.com/


