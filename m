Return-Path: <kvm+bounces-65771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A860ACB61E8
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:59:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A10E930596B6
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 13:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC3A2C11F1;
	Thu, 11 Dec 2025 13:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gxw+pJV+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y3SO+bf3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C2C2836A4
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 13:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765461428; cv=none; b=IKmrR1gqwFl6KgGq+hPHXIAH42Kkkg4pgoeaxa43MTZksT9Z77HlDzwQBwYu4oURD5gPmSjvcriOUujLjnF/ALB89sEHj5tph/xo9bNuNlShppX1xxhmwkrBxoV+ze7qlFDemywa2mJheO/gjGafSmFASNIqhFJjSSRcqb1dSc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765461428; c=relaxed/simple;
	bh=+MVABDurZoU3qR9+rsjOF4huwV5cza451zquYpBwYAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBs6KMIw5WV9x3l6APyilrQ6P7B9fXPReThrSdMLj5vu0KdyCR1J7LjbVjHDNEvEQshFp5dJazH3BXhUohwvrHK7qZ26oL+6/HFm5K9BGDwltPeUl6RpzKdnv4H862jHQpDBxB/lxOi8O0cmy+OVaaQqH3utt4iL47XSqUfj6+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gxw+pJV+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y3SO+bf3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765461424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rsvyJctSZ+XWD9ctkjkuUDFq51ROW0DhwfkxivMg8ec=;
	b=Gxw+pJV+5wNQeN0C6cAySyWgPgUhNLbO4DPgV8GaFEhc8YhaeUsqh2saQSJiAT968ig7WX
	AQ2fedDIp1819j5KuQu0tAHRtNcJJ7viTTiSqwj6XjfnutM5/TEaLeSF2aMbazI6xGYV45
	LfTaE30JB2Ig2Ehn/zua9d+GJ+7wH8k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-MeBAQD1NOEe5F5DX9oE_7w-1; Thu, 11 Dec 2025 08:57:03 -0500
X-MC-Unique: MeBAQD1NOEe5F5DX9oE_7w-1
X-Mimecast-MFC-AGG-ID: MeBAQD1NOEe5F5DX9oE_7w_1765461422
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b3ed2c3e3so105576f8f.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765461421; x=1766066221; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rsvyJctSZ+XWD9ctkjkuUDFq51ROW0DhwfkxivMg8ec=;
        b=Y3SO+bf3YSWIeyGLdUNjVF6WmPZvkvcJZ43OJXXdd5Sd/BImvemjutUR/peR3Ps0ro
         4Fq1Je3Z+/hjUFMciyB9svBf3py1J9coHmdmg185ddp6q7PiZxD96Y7KP0iC6qmj3eiB
         0ccPn9dSmpyrFt9upGt2rWWg3uS+fqutVqCceZkuKHRfF0xxNFgXI7WVSuHvbt+IBraK
         8DSbsrKpJzUE/3xI9uvZscgmCoE2Goy6E7BEY9zQmYS1SND+zNcvhO4MzF22ZcBQtU2b
         7Fg5zvgede36C9kkUWCIINgfIyyW+hvb+3BT6Iy5rAlzmhYt3Zcl655hz9GbGt8ZnIwu
         veNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765461421; x=1766066221;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rsvyJctSZ+XWD9ctkjkuUDFq51ROW0DhwfkxivMg8ec=;
        b=djMRxw6kiEFyclZBEj1LB/Dv6GQashRS9ra9/sE5ZLtNU9viJKlXBnRBKXBURK5+lA
         JII1AK8dFTekPSlhhq1FXQEtsmlAv6dqxu7lrBnwwwewefc2CdF1X3wj72+2b+6Ve2Bo
         iu8PGZYP0Kb0BOb5G/gPjRjmrRcv2y8VtmD9Dr06jg9sk1QSfBhDfkxHVlJnO34V5I03
         vbx3eC2oG+pG203IsBtpJ7Wil0Gi5Dkvadmi+yiLhCDK/KhYpsOLLYomh7ca9Aphn4OL
         OZModmtlR9UCm5ujzBlkKV738EKgi3mzWgyy6mH5kwLON/LPXFujkvV7cE4hVwbb8bZk
         xR+w==
X-Forwarded-Encrypted: i=1; AJvYcCWTgRETuLJRUpCXgFgzGIBOtynG8+O/4JjkJeibArOJ/MN6wHwW0kchGze0sQXf5X/7mEs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk+f0BRL6/YLHbLNwUTK56uSF3SHjIxSAtZNW/YN4hx3zbpunU
	MGujWgRCjfG0LVHir2muSGryOHfXV/jrPyXh8Q+YbU7HTWSOK3H3Dbwbfg6xElr8I33wQkaMEXp
	wxkMPN1G3rAtXG2aBK1KOFVi+gRIWDZGpIsiGv9UkJdWpRmmB2xH3sFUxOBZ+JQ==
X-Gm-Gg: AY/fxX5UsmUAonpfTpeRkOsMtIp86T5FLcbzswxUZ0ApF2X3+W8PZNslErW76nhSanY
	JVxbviS+PIh7ZR37ass5n3w1dfMLnD6b6MWbr6r/qQV8acPJn1n3CGtNHlTIkRgWN9WDg1lYmXB
	PvDHJMHfcIsLz2tNFXGfcUPcDORxvZaiwwDF16L6dP8liL4/BIwwkDbjVB300M4sGv7OfFqfJ2x
	Skm6PziPCWeQIM/TVF7W9p+WEMxmuJguxCzyjn20sNyXIJqCpXSvAJLHeW8SNgar67XC35o2awY
	Ct6tRebQskiH2RL/fLDgk4ygZDDk4YMwn35DAd7b9eeWeucBLTc8cfhnUC79FZaaEodZFR9Mt1E
	vev0LhdZSS27T+PogFEcJfbv6RThiA60n15mZ/OC1FzNID0IVHA8TIu/y1XNfwg==
X-Received: by 2002:a05:6000:178d:b0:429:dc9a:ed35 with SMTP id ffacd0b85a97d-42fa3b0aa73mr6515893f8f.43.1765461420987;
        Thu, 11 Dec 2025 05:57:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEGc99cmBNOvRu/1E0FcEBzDpZsrjVh8bWjY+YIg6PKhABRUKZzIdeQiTlGB1SQ5wUnM9hhw==
X-Received: by 2002:a05:6000:178d:b0:429:dc9a:ed35 with SMTP id ffacd0b85a97d-42fa3b0aa73mr6515868f8f.43.1765461420506;
        Thu, 11 Dec 2025 05:57:00 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8b9b259sm5714243f8f.41.2025.12.11.05.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 05:56:58 -0800 (PST)
Date: Thu, 11 Dec 2025 14:56:53 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Melbin K Mathew <mlbnkm1@gmail.com>, stefanha@redhat.com, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	eperezma@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org
Subject: Re: [PATCH net v3] vsock/virtio: cap TX credit to local buffer size
Message-ID: <zlhixzduyindq24osaedkt2xnukmatwhugfkqmaugvor6wlcol@56jsodxn4rhi>
References: <20251211125104.375020-1-mlbnkm1@gmail.com>
 <20251211080251-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251211080251-mutt-send-email-mst@kernel.org>

On Thu, Dec 11, 2025 at 08:05:11AM -0500, Michael S. Tsirkin wrote:
>On Thu, Dec 11, 2025 at 01:51:04PM +0100, Melbin K Mathew wrote:
>> The virtio vsock transport currently derives its TX credit directly from
>> peer_buf_alloc, which is populated from the remote endpoint's
>> SO_VM_SOCKETS_BUFFER_SIZE value.
>>
>> On the host side, this means the amount of data we are willing to queue
>> for a given connection is scaled purely by a peer-chosen value, rather
>> than by the host's own vsock buffer configuration. A guest that
>> advertises a very large buffer and reads slowly can cause the host to
>> allocate a correspondingly large amount of sk_buff memory for that
>> connection.
>>
>> In practice, a malicious guest can:
>>
>>   - set a large AF_VSOCK buffer size (e.g. 2 GiB) with
>>     SO_VM_SOCKETS_BUFFER_MAX_SIZE / SO_VM_SOCKETS_BUFFER_SIZE, and
>>
>>   - open multiple connections to a host vsock service that sends data
>>     while the guest drains slowly.
>>
>> On an unconstrained host this can drive Slab/SUnreclaim into the tens of
>> GiB range, causing allocation failures and OOM kills in unrelated host
>> processes while the offending VM remains running.
>>
>> On non-virtio transports and compatibility:
>>
>>   - VMCI uses the AF_VSOCK buffer knobs to size its queue pairs per
>>     socket based on the local vsk->buffer_* values; the remote side
>>     can’t enlarge those queues beyond what the local endpoint
>>     configured.
>>
>>   - Hyper-V’s vsock transport uses fixed-size VMBus ring buffers and
>>     an MTU bound; there is no peer-controlled credit field comparable
>>     to peer_buf_alloc, and the remote endpoint can’t drive in-flight
>>     kernel memory above those ring sizes.
>>
>>   - The loopback path reuses virtio_transport_common.c, so it
>>     naturally follows the same semantics as the virtio transport.
>>
>> Make virtio-vsock consistent with that model by intersecting the peer’s
>> advertised receive window with the local vsock buffer size when
>> computing TX credit. We introduce a small helper and use it in
>> virtio_transport_get_credit(), virtio_transport_has_space() and
>> virtio_transport_seqpacket_enqueue(), so that:
>>
>>     effective_tx_window = min(peer_buf_alloc, buf_alloc)
>>
>> This prevents a remote endpoint from forcing us to queue more data than
>> our own configuration allows, while preserving the existing credit
>> semantics and keeping virtio-vsock compatible with the other transports.
>>
>> On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
>> 32 guest vsock connections advertising 2 GiB each and reading slowly
>> drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB and the system only
>> recovered after killing the QEMU process.
>>
>> With this patch applied, rerunning the same PoC yields:
>>
>>   Before:
>>     MemFree:        ~61.6 GiB
>>     MemAvailable:   ~62.3 GiB
>>     Slab:           ~142 MiB
>>     SUnreclaim:     ~117 MiB
>>
>>   After 32 high-credit connections:
>>     MemFree:        ~61.5 GiB
>>     MemAvailable:   ~62.3 GiB
>>     Slab:           ~178 MiB
>>     SUnreclaim:     ~152 MiB
>>
>> i.e. only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the
>> guest remains responsive.
>>
>> Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>> Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>> Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
>> ---
>>  net/vmw_vsock/virtio_transport_common.c | 27 ++++++++++++++++++++++---
>>  1 file changed, 24 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index dcc8a1d58..02eeb96dd 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -491,6 +491,25 @@ void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
>>  }
>>  EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>>
>> +/* Return the effective peer buffer size for TX credit computation.
>> + *
>> + * The peer advertises its receive buffer via peer_buf_alloc, but we
>> + * cap that to our local buf_alloc (derived from
>> + * SO_VM_SOCKETS_BUFFER_SIZE and already clamped to buffer_max_size)
>> + * so that a remote endpoint cannot force us to queue more data than
>> + * our own configuration allows.
>> + */
>> +static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
>> +{
>> +	return min(vvs->peer_buf_alloc, vvs->buf_alloc);
>> +}
>> +
>>  u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
>>  {
>>  	u32 ret;
>> @@ -499,7 +518,8 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
>>  		return 0;
>>
>>  	spin_lock_bh(&vvs->tx_lock);
>> -	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>> +	ret = virtio_transport_tx_buf_alloc(vvs) -
>> +		(vvs->tx_cnt - vvs->peer_fwd_cnt);
>>  	if (ret > credit)
>>  		ret = credit;
>>  	vvs->tx_cnt += ret;
>> @@ -831,7 +851,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>>
>>  	spin_lock_bh(&vvs->tx_lock);
>>
>> -	if (len > vvs->peer_buf_alloc) {
>> +	if (len > virtio_transport_tx_buf_alloc(vvs)) {
>>  		spin_unlock_bh(&vvs->tx_lock);
>>  		return -EMSGSIZE;
>>  	}
>> @@ -882,7 +902,8 @@ static s64 virtio_transport_has_space(struct vsock_sock *vsk)
>>  	struct virtio_vsock_sock *vvs = vsk->trans;
>>  	s64 bytes;
>>
>> -	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>> +	bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>> +		(vvs->tx_cnt - vvs->peer_fwd_cnt);
>>  	if (bytes < 0)
>>  		bytes = 0;
>>
>
>Acked-by: Michael S. Tsirkin <mst@redhat.com>
>
>
>Looking at this, why is one place casting to s64 the other is not?

Yeah, I pointed out that too in previous interactions. IMO we should fix 
virtio_transport_get_credit() since the peer can reduce `peer_buf_alloc` 
so it will overflow. Fortunately, we are limited by the credit requested 
by the caller, but we are still sending stuff when we shouldn't be.

@Melbin let me know if you will fix it, otherwise I can do that, but I'd 
like to do in a single series (multiple patches), since they depends on 
each other.

So if you prefer, I can pickup this patch and post a series with this + 
the other fix + the fix on the test I posted on the v2.

Stefano


