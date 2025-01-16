Return-Path: <kvm+bounces-35692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAAEEA14392
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 21:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B6763A7D91
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 20:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B2D236A64;
	Thu, 16 Jan 2025 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IS0wEwmY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6505A22FAFC
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 20:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737060203; cv=none; b=pMAmpPiUhCPLQL7w2gtvt3cMhAOxn94JKJUxKxNbJFtuYAnPSgiXGA7bCzdUv2n8euZ4zBufBgwW16yhubC+Y8qVq79shlY9E1qxoGGFLAHUs9CQujyoN84Sgd1kbxeg1Sd8i9Gnr943iy41R2+R7d0YnMYsHCXev5wvUkEX96c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737060203; c=relaxed/simple;
	bh=oNC4k+WXkPXDOxeNyqZO73fS2euQjZ6qdRkTjXEif2o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpySnc+nRW01el/udSbVXEKqpArDn35areDRMl/Oczu6GgqW0FPxnBjhUypBhZccgFQPaM1OqAayrgPtZOQ7HgEBCgz7B5IyrAJ0KGLpUDjRTr+YSG26DHNJfBf29d0ok9Zr3C0K/8a3NZ4etoC/2GPJlXtrBJbjRPsQROOa5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IS0wEwmY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737060198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bf2k/5Hr7sfK6KWzSmym1A4FVsj5pwiPCKR/ST3eyVI=;
	b=IS0wEwmYKDpeukkGAn9QS4PwLMQbS0LIIFT21g8vB6kTsBfUnbjULWujYiHZE7jsuAf0Q8
	BEj/bEr+Zc45mk89FVq2IP/QLVRYaPfwvkYf7y8ukL19RDarS9y82fvQN4RhsjSqy/ptHO
	881j/zkZtQyEQ7xtYNxTkhDQT3qfglY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-QyhzgopxMMyp6DmDfvRfHw-1; Thu, 16 Jan 2025 15:43:16 -0500
X-MC-Unique: QyhzgopxMMyp6DmDfvRfHw-1
X-Mimecast-MFC-AGG-ID: QyhzgopxMMyp6DmDfvRfHw
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-844d68dbe60so17110739f.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 12:43:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737060196; x=1737664996;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bf2k/5Hr7sfK6KWzSmym1A4FVsj5pwiPCKR/ST3eyVI=;
        b=LBc+TSnIV978sXdgxDexj3GnMAQtq8UjpXtGC6maxxHpEzbTDe+GEfhCeJkTv+FiJ4
         hy5o7xZLXSeNr+v/dp6zSP0EvpPumHZHnySH/Q9FT8GwFfJpE3FiZ2z/3ktXtqFZIr2S
         Z+or8OYREH97irFo9dbZ0niuAwr/DvGnSlkgPj8U4ASuuQDAIv8HJ6NLze0v+TDBO5uK
         t0Nr/DPbxqNtcgR0SV5KZEQCgL0LsSiTmOBJszTyMDrdnuw/W3SRdiJViIBg93mshVlX
         e9BHgytPUU0v02WxYpw7s4QoD1sgBKnu5ZWV0sSrE+8VLF+BJ9FsTo55N5PYGWjJOtXx
         DX3g==
X-Forwarded-Encrypted: i=1; AJvYcCU5vECJxapAnfsadCBEA28xdACOCDJQRhtQDYaqUUr8TQneOQMKFzFW52aoXH9MYnWITLM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym2PBSSMm5IDamMCMP+ZVJAmQm0HouZEzywV0bJf0gOlJ8S/r4
	hnHAmMnqMKdicAOU3wZJ+2qg6PP761gEitxb8MdKrKMK+nUo+Ao2gBAAEfhDw1DCTDmrLhOcjj2
	BOlViABRdZcIiaYADrb81CNBCV9HQWHJuC43yyQ4qrnrFbTM6cA==
X-Gm-Gg: ASbGncscH+TGa7aUiBPIxLUoV2M5o0dRUNyKAn2edAKF0PoienvcllQrGu89dm8rmHo
	gXm9zUr8kvYS9RgSoyEDakZck1tkUSECO1RnAjKYu9ZOGUD3RRtkbMeD9ecZQa2QkC+eWrD4tgm
	WrWNnCrJKhf3ty4wygojl462V5vZrpSGNJrJZbljZzcLFIB6KRmZc6r934pdv4bDjO+K9GdXTCL
	N/7UrceT/LdeHOaCyriZUcUlvfsCl14qpPPcs3oCTn6YnfofacpGS7cv2CJ
X-Received: by 2002:a05:6602:6d13:b0:81f:86e1:5a84 with SMTP id ca18e2360f4ac-84ce00a046cmr897989739f.2.1737060196200;
        Thu, 16 Jan 2025 12:43:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEj1r3DrCkoBXESvEDUcc/dKZxqojvUM+K8lDoNmMSrqYXYiCu58N5eBEi7VABOB5oRX9i98A==
X-Received: by 2002:a05:6602:6d13:b0:81f:86e1:5a84 with SMTP id ca18e2360f4ac-84ce00a046cmr897988539f.2.1737060195892;
        Thu, 16 Jan 2025 12:43:15 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b01edc4dsm20164139f.11.2025.01.16.12.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 12:43:15 -0800 (PST)
Date: Thu, 16 Jan 2025 15:42:59 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: kevin.tian@intel.com, jgg@nvidia.com, eric.auger@redhat.com,
 nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
 zhenzhong.duan@intel.com, willy@infradead.org, zhangfei.gao@linaro.org,
 vasant.hegde@amd.com
Subject: Re: [PATCH v6 2/5] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Message-ID: <20250116154259.5b54d66e.alex.williamson@redhat.com>
In-Reply-To: <20241219133534.16422-3-yi.l.liu@intel.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
	<20241219133534.16422-3-yi.l.liu@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Dec 2024 05:35:31 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This adds pasid_at|de]tach_ioas ops for attaching hwpt to pasid of a
> device and the helpers for it. For now, only vfio-pci supports pasid
> attach/detach.
> 
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/iommufd.c      | 50 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci.c |  2 ++
>  include/linux/vfio.h        | 11 ++++++++
>  3 files changed, 63 insertions(+)

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>


