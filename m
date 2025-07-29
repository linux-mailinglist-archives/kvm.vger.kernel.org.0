Return-Path: <kvm+bounces-53621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B49CB14BBE
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B84C7A9B08
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FAB28852B;
	Tue, 29 Jul 2025 09:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cXNIE86Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A481DED5C
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753783010; cv=none; b=k8VjRfYO/MZjETGzS8UejUAjPExqIySW6bFmeRs/l7oZjhwyjvdKORAG6Tm/sHZ2QTVaP8pF9R0NXQP7TOOjow+REXs30bsFAmX2iytd3ty7l2qVO84M0kOhc7Qtgmd+D0NCA+H2RVai92rP/HAV/7Qze31hd6xPJGJ4ZwIDeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753783010; c=relaxed/simple;
	bh=zs5ODgjq88Dh/p97NrIETQcV4sqEQTVPW1IHpVCIj5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUB/UhiTitqjw/pJFetMRichonSiVSTLgGC+usmI4tGQAfVt4Ns5DWpx1dyfifCoWbzsO1uLq8z0Mu6jIX5f6pshWeewZwhxolg415OgLiCj0FOafV57vzYJfKXlp4JQyw7bct9cJDwoyN14Sw/iu6Wmz0jv2q1O8TqNjSJ4IuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cXNIE86Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753783007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v9Q72PwGeVTj3y8z/xg+PR9uIGfJgkCfjcqVd6z2uJw=;
	b=cXNIE86Zcy7SZMXeY209e6lf4p+0ZiAe5fbXpyXJNVDwgHEcKCCM9qGYKQ5Zofdgt7dREU
	IgE4pqFEoN5/+3uEZe/CMrYmWNvWIr0WC/d002sxwqk50mzhULDBny5D5Kw4r64YidCh7R
	UQVcxy4VzLvzzOMXo/5NbVaJlxOBY4w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-f4XZAQALOci_z2CO0XlEew-1; Tue, 29 Jul 2025 05:56:46 -0400
X-MC-Unique: f4XZAQALOci_z2CO0XlEew-1
X-Mimecast-MFC-AGG-ID: f4XZAQALOci_z2CO0XlEew_1753783005
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6149374a4c8so732136a12.0
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 02:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753783005; x=1754387805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v9Q72PwGeVTj3y8z/xg+PR9uIGfJgkCfjcqVd6z2uJw=;
        b=VVNT0Jl8P4Ag8dTN+ZbHLnhr67/StEjlxh2fkXWC5JNG0QpUIBeWaG6hOzxLxokhwG
         be8UR96rvZ5dlcKrtGKZMq9VQtSfxSxwNaM687jNElkPFw6JYnfnUQKLUpAZ9H8/uswI
         5PcVse2kJ+f7uMn2Y96eImiwTR82i4kWge5BnnHediGs/a80rKZWGjjZi/zOI4lJY9ef
         Ay4gIVAneUjXsZvd948YhdW0MrU1lDLfOjq9raeKyvY9WiQQhXacDQS1eAgYeiPwldaV
         q9JAhdca3CZSX8AcvXvWH/MxwD25PX6xrIAAipFC3DqrIAqLMSyjf3nd5oNY8T2n+gOC
         wdAg==
X-Forwarded-Encrypted: i=1; AJvYcCV9AXG6HLjLufMZ648bQuAHzSvihiuUBpmphsISmyoz/hkSK4APLY6MHcyfOu5ctOzeuMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyJwLICcBQ+RVT1HCc5N+EEpmz4RZfJg99jaPYoNxjUfO3RwdG
	R0uYN7HmN3BimaGJFX6nDXJpH+wW5K2NlR3G3hSYQr2xQZowVECoZCj58ur/VkqrzWX5ofKQTjG
	TXWlz2TM1WONBo0HNp9l2EErev5gZtl2HtgHnSCjvcGvjQXY1d7TRfw==
X-Gm-Gg: ASbGncuBv52DreN0/2yOn6v5LcdFlSymdqIs/NDWZgPnbYSvu7VRtocm5WnN7M+77mZ
	RvZf+T/ZAQ2vhMs9caq9jKz66QbgRPc1E14TirSTES0sdRrru3s0uF2RQ2c46c0X+Pas2GbMwzg
	BhybGDWnRBkKoEvLqOOAnQErQOtzyyCOvQs7eDene8FVkcOWksuVMTVX00ssKVLm91LfwW5yhWx
	VLnR9bxnPfVU4Vn/vf8teA6xHaDwargfpea6vzGZC/gn7KK2xmvUitTgddlQB+wu2FRIyVA735I
	RMwERnaNy38l4YF8hr2Ay5HH/kZPVcgbAyov4WClvyq87MQk5RCeGFPxWpXYCjE07+SShrxGKVd
	E5w3Jh0V//gIeKqo=
X-Received: by 2002:a17:907:3da1:b0:af2:4690:9df3 with SMTP id a640c23a62f3a-af7bfd85f30mr309160866b.14.1753783004781;
        Tue, 29 Jul 2025 02:56:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGikTxgu8BzOOJSc5KnbVu6iBWvoq2vv43KLwCvZ/Y6ueWN7/Ah83jj2TRypRMINdlKpJ2KOA==
X-Received: by 2002:a17:907:3da1:b0:af2:4690:9df3 with SMTP id a640c23a62f3a-af7bfd85f30mr309159366b.14.1753783004396;
        Tue, 29 Jul 2025 02:56:44 -0700 (PDT)
Received: from sgarzare-redhat (host-79-45-205-118.retail.telecomitalia.it. [79.45.205.118])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61500addc6asm4421025a12.53.2025.07.29.02.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 02:56:43 -0700 (PDT)
Date: Tue, 29 Jul 2025 11:56:40 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	will@kernel.org, JAEHOON KIM <jhkim@linux.ibm.com>, 
	Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] vhost: initialize vq->nheads properly
Message-ID: <6yp7ww6misiazdkeumkklrds2e7s3cmgf42lafvukhhqtopby4@ex6h5km4hq5y>
References: <20250729073916.80647-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250729073916.80647-1-jasowang@redhat.com>

On Tue, Jul 29, 2025 at 03:39:16PM +0800, Jason Wang wrote:
>Commit 7918bb2d19c9 ("vhost: basic in order support") introduces
>vq->nheads to store the number of batched used buffers per used elem
>but it forgets to initialize the vq->nheads to NULL in
>vhost_dev_init() this will cause kfree() that would try to free it
>without be allocated if SET_OWNER is not called.
>
>Reported-by: JAEHOON KIM <jhkim@linux.ibm.com>
>Reported-by: Breno Leitao <leitao@debian.org>
>Fixes: 7918bb2d19c9 ("vhost: basic in order support")
>Signed-off-by: Jason Wang <jasowang@redhat.com>
>---
> drivers/vhost/vhost.c | 1 +
> 1 file changed, 1 insertion(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>index a4873d116df1..b4dfe38c7008 100644
>--- a/drivers/vhost/vhost.c
>+++ b/drivers/vhost/vhost.c
>@@ -615,6 +615,7 @@ void vhost_dev_init(struct vhost_dev *dev,
> 		vq->log = NULL;
> 		vq->indirect = NULL;
> 		vq->heads = NULL;
>+		vq->nheads = NULL;
> 		vq->dev = dev;
> 		mutex_init(&vq->mutex);
> 		vhost_vq_reset(dev, vq);
>-- 
>2.39.5
>


