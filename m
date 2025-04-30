Return-Path: <kvm+bounces-44880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B1AAA4733
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:32:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22369984AEF
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9154235066;
	Wed, 30 Apr 2025 09:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZA6RleX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781B9171D2
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746005330; cv=none; b=QSsuMvDyNjAom9PKQd1ohBmcX4e7Ima5+ZveiJsgAzbx/Xh7v2Nv1G6LcINoq9RPK24AS3DpNZm3t1Sbijeypnhxf1HJF3G3dCuFhPLyIq1zmwH4+a+YvHdedtZWq893FzsrRGLe+gabnSN292/BJUUhODjUwdyYLVWLe6rqdfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746005330; c=relaxed/simple;
	bh=CfCKT7csdC6kxz8qRaiEnDt65u+ulhVQn+dGe+7KfZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qt9CcHVamo1Be8bVKmWmv7yFtHK9O33/M2cZ2iBKOCtGB8TXqQOIFIUyUcM/IHR3+2S8FZ4oeMJlxeip0p3Hz7Vlr9Pr2yf86sas1Lfngk4LXDf4i37d7BapqdcIWZI5Qps1W1fJmwgHZKuIt5MNI+Uw6FvARJheflRe1WtcQA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RZA6RleX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746005327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+iRdHR/016I7PiLqqexsMYXzIsBDeKqTco6kET+eEo=;
	b=RZA6RleXVEeYxyBhIzWVMiecOcCWqq+Uj/Ht6AlKFc4DqypiMMFy4zz0WLqyA2sIIG8O88
	Kp2DckXGS5YW/5F4cTGlkCSbSMrBoTQVfa//v8cLd3Eo+SiqJPWisOdoi3efCUMotOzEUz
	MRgvvkbOZ8bU1xgb8M+4oGZP9lMO+mI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-LoTVx69CPf2N8PZ-IGkBLQ-1; Wed, 30 Apr 2025 05:28:45 -0400
X-MC-Unique: LoTVx69CPf2N8PZ-IGkBLQ-1
X-Mimecast-MFC-AGG-ID: LoTVx69CPf2N8PZ-IGkBLQ_1746005325
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ac3e0c1336dso537154866b.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 02:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746005325; x=1746610125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+iRdHR/016I7PiLqqexsMYXzIsBDeKqTco6kET+eEo=;
        b=J/9WXcXlRDCnpxDkoBs0mHXtPiBa3XbkkjweYLETaV2gLJnXhyCNhIFzwxBZvQ18+m
         G+xTROsj8pbq9lO+P7o28GC3i7I32ZxY7+OZj3aLC4tyblTZYfm1Wmet6jTAqBZrHsz2
         y+7/ZlHXU7UYufC1qc3xdibCsvyTMO31xEVAbbn654iCcHyJ5fXGmLwZHxZJt7B1/phy
         o4kbUUbaciHflicRis9dlMmSFL/GrwPagekRwadfWEgns13/GDGqVMAYG6knxggc1k6v
         DCpbBXUlF4JVUjZyENHnjAunsHet4CFvLNcT/NiibRFEhzBTo9PDQF0BohhiR877Q1cT
         mSig==
X-Forwarded-Encrypted: i=1; AJvYcCX5+2x8JsNJEUSukZV00l2473hVWMhh2mSUyqcd6sGEhYWC4c+T3jviQmyHISo2q9a0ips=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyJbZ0Oo6bXfo+LKimkGP6+Ht1DES7S6+bfa9IEWfZCHbiGTQP
	U8rOUPp+d8+jy8RsBhOCXhOvSe3vgAYWiGLKQJQ6sJWiULJfQ4Qv9R5MM4p9Fjf/g7FQEQmbhwr
	3j4Kh5SdZhAX7cM9kQnGDzBpSMyCwDU22KWVLr2axRiFpTjBHsg==
X-Gm-Gg: ASbGncs3o51cL5Rm86dmpmn7GcDTkZj2rmICzgutvhEJV7AGwia9Flhb9ohWf1YV7wv
	ndHvacAvP7wx7le2pI9kjuddM3s/KE7Pl1s2S6oIBpez3WplxGp8SiJCdtY9jamiTaddrgSkzSE
	5xu5/RA7fH8IwOIlSN8Leihj66oN+Yvgs5UGSDI01MqxQ78yIeUpXdmGGSasLU5FYOitdkNKHY1
	bnigvmlaH38Xoz05UNr450QumTud1/rxy3GEzJkB3SnROSuet/FV5e+YWMK7nPKcbTUwti+/Uk1
	8soZ8rBAbI0XwXiq5w==
X-Received: by 2002:a05:6402:3490:b0:5f7:eaf1:acd1 with SMTP id 4fb4d7f45d1cf-5f8aef99451mr1459104a12.10.1746005324740;
        Wed, 30 Apr 2025 02:28:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE81eWc8aL2LbvtLmC3j27kWn9yssNrgLAfG68UpEapDAHpJ7zaXyuHj+dnHphj20qrinwPqA==
X-Received: by 2002:a05:6402:3490:b0:5f7:eaf1:acd1 with SMTP id 4fb4d7f45d1cf-5f8aef99451mr1459078a12.10.1746005324176;
        Wed, 30 Apr 2025 02:28:44 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.220.254])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7e7e47be3sm5249067a12.30.2025.04.30.02.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 02:28:43 -0700 (PDT)
Date: Wed, 30 Apr 2025 11:28:26 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] vsock/virtio: Reduce indentation in
 virtio_transport_wait_close()
Message-ID: <dlk4swnprv52exa3xs5omo76ir7e3x5u7bwlkkuecmrrn2cznm@smxggyqjhgke>
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
 <20250430-vsock-linger-v3-2-ddbe73b53457@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250430-vsock-linger-v3-2-ddbe73b53457@rbox.co>

On Wed, Apr 30, 2025 at 11:10:28AM +0200, Michal Luczaj wrote:
>Flatten the function. Remove the nested block by inverting the condition:
>return early on !timeout.

IIUC we are removing this function in the next commit, so we can skip 
this patch IMO. I suggested this change, if we didn't move the code in 
the core.

Thanks,
Stefano

>
>No functional change intended.
>
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/virtio_transport_common.c | 26 +++++++++++++-------------
> 1 file changed, 13 insertions(+), 13 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 49c6617b467195ba385cc3db86caa4321b422d7a..4425802c5d718f65aaea425ea35886ad64e2fe6e 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1194,23 +1194,23 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
>
> static void virtio_transport_wait_close(struct sock *sk, long timeout)
> {
>-	if (timeout) {
>-		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>-		ssize_t (*unsent)(struct vsock_sock *vsk);
>-		struct vsock_sock *vsk = vsock_sk(sk);
>+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>+	ssize_t (*unsent)(struct vsock_sock *vsk);
>+	struct vsock_sock *vsk = vsock_sk(sk);
>
>-		unsent = vsk->transport->unsent_bytes;
>+	if (!timeout)
>+		return;
>
>-		add_wait_queue(sk_sleep(sk), &wait);
>+	unsent = vsk->transport->unsent_bytes;
>
>-		do {
>-			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0,
>-					  &wait))
>-				break;
>-		} while (!signal_pending(current) && timeout);
>+	add_wait_queue(sk_sleep(sk), &wait);
>
>-		remove_wait_queue(sk_sleep(sk), &wait);
>-	}
>+	do {
>+		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>+			break;
>+	} while (!signal_pending(current) && timeout);
>+
>+	remove_wait_queue(sk_sleep(sk), &wait);
> }
>
> static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
>
>-- 
>2.49.0
>


