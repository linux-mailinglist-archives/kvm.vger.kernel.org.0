Return-Path: <kvm+bounces-67579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EEF8D0B376
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 17:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA86D31108D4
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 16:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDDE22B5A3;
	Fri,  9 Jan 2026 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cKiAbeLy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dd7pirNN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2EE2222C0
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 16:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975513; cv=none; b=ccLIcAx2eiCI9rsmA50lQArReDAdAS3xAve6rBOmcm5nWGgj31H4a44zlreq0eAd1ngVrkYgsHU+/TRK1F5GWWZ5BhrzluGNVOXllvVIaUkMt1Oywvvr9UqBvNEFEgi/6pbE/Fe66H+airCut/c4Eeto+aql+F//SW0d18Y1+IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975513; c=relaxed/simple;
	bh=a1/DesK3SdmsYTBBaArmoKyDaDj/3FIZv0uZ3aW3q6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnUB6oSGO50pLI3M5O6GagqoSF0sp7G/ewBQOayEUkwTYBNlw30oNlV/ZhPgc9qFc6ABzYV0g2datmUa/Lmo1QrpRtCtJPE8hOlM0+om0eY7+vf8aPeAJxKepCEGX8JDXjAE3wTdY9/l3SZkJh0zqOO346Dwna47/Pt5QuoDqz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cKiAbeLy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dd7pirNN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767975510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/krVGPsvJddi7hg5z9iCRy/aoNIgxBgy+h5yAK6W1kg=;
	b=cKiAbeLyx1v+pyYLplqORQGMeAGJNFSLGROg77KxFMO6OExlwKL+wVxk+A44NxURO+OnaD
	G9Nv767X6VOHr7Dk79V9DHGeGg8yndM3HFCoVokb3PvEDdH84u46ygfRFm8aWabYuzf/SS
	9BDdpAZsi3NDbloAm9DWgzrz7X44NDI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-u55isgb3No29RWQ1GQzEsQ-1; Fri, 09 Jan 2026 11:18:29 -0500
X-MC-Unique: u55isgb3No29RWQ1GQzEsQ-1
X-Mimecast-MFC-AGG-ID: u55isgb3No29RWQ1GQzEsQ_1767975508
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b79ff60ed8eso329484566b.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 08:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767975508; x=1768580308; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/krVGPsvJddi7hg5z9iCRy/aoNIgxBgy+h5yAK6W1kg=;
        b=Dd7pirNNdfNA9usNhQzvyK262repY0KT12gqpaLcAlITZwDwQslvtRheuKP8T0pYt0
         2lcxMiRg3r2c1quh9hFsgQF3McmBq0VAnCLBYUnR92+QulvQ0OQL3Y7c3F0HZogjfRA0
         AXvvBTyNX/zaFN7A1LLfETA3KaBMRqvhWXTmWG8f5tCrb+Ka7bY7MSNsRWy/ggQ/1Odu
         G2KL6fq1B3I2/3UzKggCNwBs2uw1xFMSCdD7Gi6cf4VDdPu1HUJWax+0GJLOEhEj4XfP
         B0EyeNFje6mM9a0V811PgZC3PnauDeCuKb8qewUL1JAETr4kyo15EDeIsAlolbWVqaAA
         oXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767975508; x=1768580308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/krVGPsvJddi7hg5z9iCRy/aoNIgxBgy+h5yAK6W1kg=;
        b=EiJ+dJo817iPeV5mmhYvbPrkx1KyrLdQqmHxXcNu3O8zpS01MzhUzFw4JDsyAw25Ps
         Acz0weWIsTRpF8Y3r0pRx4Ow7vERh+e76v9ZWL0dMWdhW0ujM8A1YmyMMFzJR6sFrv9i
         IUo8kj6SCi6O8mOGaxYkulvCMW8M3egCE7YaQd6GliU/x2eJW220aYKf3mPYXeS7gVHL
         5Yg/GgvqxSQfs+ov1t+4XR0sM2j6phyN0zs0p38483NrkkWu5HOOFpDpK4w6SBfaLVfW
         5Vj3LeS2sXuTk21VhayP4VE5RwLtV06xPV0IXaZBib8FEnuvEO6WcjQgAM6+pWiSk3Aj
         BDKw==
X-Forwarded-Encrypted: i=1; AJvYcCV1NjxJ4qJ3JKWIYORKJIfjJZ6WzY8yNK+zdG/yUEI8lAQQcfGoPHI1muhcTV1HnbtzIu0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj/sNclmYYna1UvU/CNfk8/KINoYPtP+Hf8AuNRrQKjzYxduTL
	3TYlcvqE7pCjMGZM4w6bJfHt9mmCclNIF/N+jZS651a34smiWVceI3MSUUt/YpmWjiWrNFfB4Ba
	ppW6kF0/dmoIgSJX5oeY6L/uzbiQh4xEEMqGZFEnZZtirJY+0vSBXjA==
X-Gm-Gg: AY/fxX56mIgQAaEZ0Sj00fGJt20iWdX3CxHfy6ETY8yKjsEngugat+78LjpS9O1JI1k
	fp0JiR/LxzemYE7ieVtynqA/Of6KHiYUSkdKIPzoLu2nPOQFUZjzG259RosJqqJ9qDnSNkRBUtP
	hjtp7cvkurHUigkuEieO1q+TWHOcvjtHr8xCSRldBj5KdhTgu9+3z2HExM9P2ybI6uj5caoV0jC
	eo1A8pmtZtxskLOJ8DxvxGsKI/wZbsCBFwOb6Rcj2eeHBygfA1cFXwOX3v8d/Pqx8iTVWQN4Inw
	mPL05xK1eH9qGT4D+rkjY5MjKxSzLyp+NuZYo7AZRxaYkRWpvQYS+mmPPYaEQhyjnjSJB2CoPO2
	w91fA9xwN37T5zpI=
X-Received: by 2002:a17:907:1b0f:b0:b6d:9bab:a7ba with SMTP id a640c23a62f3a-b8445179d97mr1040652866b.42.1767975507961;
        Fri, 09 Jan 2026 08:18:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHr2olBdquSj4gJBneVi4T80pCx/5PM/5koZL1efVNkWaXxHFkv/Bw2psyCF7rUeZB6h9BHnw==
X-Received: by 2002:a17:907:1b0f:b0:b6d:9bab:a7ba with SMTP id a640c23a62f3a-b8445179d97mr1040648366b.42.1767975507266;
        Fri, 09 Jan 2026 08:18:27 -0800 (PST)
Received: from sgarzare-redhat ([193.207.176.59])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a51183asm1175084666b.49.2026.01.09.08.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 08:18:26 -0800 (PST)
Date: Fri, 9 Jan 2026 17:18:19 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsock/virtio: Coalesce only linear skb
Message-ID: <aWEnYm6ePitdHPQe@sgarzare-redhat>
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
 <20260108-vsock-recv-coalescence-v1-1-26f97bb9a99b@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260108-vsock-recv-coalescence-v1-1-26f97bb9a99b@rbox.co>

On Thu, Jan 08, 2026 at 10:54:54AM +0100, Michal Luczaj wrote:
>Vsock/virtio common tries to coalesce buffers in rx queue: if a linear skb
>(with a spare tail room) is followed by a small skb (length limited by
>GOOD_COPY_LEN = 128), an attempt is made to join them.
>
>Since the introduction of MSG_ZEROCOPY support, assumption that a small skb
>will always be linear is incorrect (see loopback transport). In the
>zerocopy case, data is lost and the linear skb is appended with
>uninitialized kernel memory.
>
>Ensure only linear skbs are coalesced. Note that skb_tailroom(last_skb) > 0
>guarantees last_skb is linear.
>
>Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/virtio_transport_common.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index dcc8a1d5851e..cf35eb7190cc 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1375,7 +1375,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 		 * of a new message.
> 		 */
> 		if (skb->len < skb_tailroom(last_skb) &&
>-		    !(le32_to_cpu(last_hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)) {
>+		    !(le32_to_cpu(last_hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) &&
>+		    !skb_is_nonlinear(skb)) {

Why here? I mean we can do the check even early, something like this:

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1361,7 +1361,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
          * to avoid wasting memory queueing the entire buffer with a small
          * payload.
          */
-       if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue)) {
+       if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue) &&
+           !skb_is_nonlinear(skb)) {
                 struct virtio_vsock_hdr *last_hdr;
                 struct sk_buff *last_skb;


I would also add the reason in the comment before that to make it clear.

Thanks for the fix!
Stefano

> 			memcpy(skb_put(last_skb, skb->len), skb->data, skb->len);
> 			free_pkt = true;
> 			last_hdr->flags |= hdr->flags;
>
>-- 
>2.52.0
>


