Return-Path: <kvm+bounces-7032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6697483CF91
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 23:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1126A293858
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 22:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D18511700;
	Thu, 25 Jan 2024 22:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CEyN+OJI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971F6111B5
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706222892; cv=none; b=Jurf9QkV6i213VqRAqiLC2zzv7228sFqg3EX5C9ss03I+C/VCkHvws1gEQ/lfwHxYFzVmucQ+nQt4s9M4VU65ODwbxTskgJK9C9IIuegstGrGBDPNT1MKlpF5Sb/mYU6VveXPvCRu2MMBu6fLuhSqckodD1m4qWiGhwj19tQl/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706222892; c=relaxed/simple;
	bh=Ozpy2C3AVxBhEeZpBWtDgZqOuPhFK4pg9APHglEez3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDr3C/HyWPyHWpIYIQ6s0i6D3HZOXvBOLoIWuvQBUQR+HmOkMwnLe6xK+ZG45wNtyPr/Bu7yxbgp8Dv7U804nGhMCwFNmc+/eFOw/c0BVJPLIZNI1NlDHtOU/EDXWEkd7rAqBYU0WbHirMUC+utNn1O2cqzxVoPae16JwHajqLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CEyN+OJI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706222889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FcJ0y8NFfuXCEfad7FVZRFQBMW2B2FwtGevEF8U6+E=;
	b=CEyN+OJIIigfeNCvtE+/z5SlMUbB7h5YlqWTpzC0LQDtNHDOKDkxua5zvk8Y5LSknVQ6zT
	rcUDdCS5jVpA0xzOIBL2ZOPRh7M2pTzFmkD8t4Xos2x2oAm4ODJy0jKGTpGxIVyiFhKH+O
	0ERBzOCCr1K5BkCSYzpgh8iyE3Nkn8E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-IjBgNeShNKuFJoOXdL8fzQ-1; Thu, 25 Jan 2024 17:48:07 -0500
X-MC-Unique: IjBgNeShNKuFJoOXdL8fzQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40e61491b81so5633655e9.0
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 14:48:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706222887; x=1706827687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FcJ0y8NFfuXCEfad7FVZRFQBMW2B2FwtGevEF8U6+E=;
        b=L4fzR2S4F2apqi99Cv/uczGhXpUlBB+0DfYghikun2rNRRgBJYeTHD70W3GhwLKdhD
         NpnsulIBF2yCdOYphw0Kw3BzfglEDSajlt16gBsn0+OuydxDaYaSzDsrN/wF81HyW9MB
         PeA+ZemTCUdjXRx1tGs15qHmOV8+rVUA+Afo72nMNBpMFkGD51FMWB7a4QQkf4Zk8B46
         xw+Me4GGu9iJbGxnGtJ5cYrrrgncNyz3Kxipw1L5noAXKY+yAl2Nea1I9w7pNESiifoQ
         0wiCEXF57J71PkWgLVDj2PNDteM3Ow49I9UL2vE3iAMML9nxHHkCqY1RuYgub1pwpAuS
         BaeQ==
X-Gm-Message-State: AOJu0YxxE4UbpCrsjOnGL3o/oT0SwSVKhSFQzdf9+y5IPBznvaMJcZD3
	aZLD7bJKXXdZDj6l860qCicYD/bFaiR3JNBoN9gMg9OV7GJtNKh89K7wwY2yO4syQyfcGZZZUc9
	PKWjx0Q2bzowXFXN+MCA+C+hLrXsF6GUmAoq29mW7V7bq3lFBOQ==
X-Received: by 2002:a05:600c:1f81:b0:40d:87b9:3525 with SMTP id je1-20020a05600c1f8100b0040d87b93525mr6946wmb.9.1706222886837;
        Thu, 25 Jan 2024 14:48:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1+HglQtwTt9mC00xoB9/Ny/lXRTPJrlYgGjDEq89/GGxy9yTpCyIYNf5wz8BxXp9cpJHHLg==
X-Received: by 2002:a05:600c:1f81:b0:40d:87b9:3525 with SMTP id je1-20020a05600c1f8100b0040d87b93525mr6940wmb.9.1706222886528;
        Thu, 25 Jan 2024 14:48:06 -0800 (PST)
Received: from redhat.com ([2.52.130.36])
        by smtp.gmail.com with ESMTPSA id b14-20020a05600c4e0e00b0040e559e0ba7sm3941969wmq.26.2024.01.25.14.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 14:48:05 -0800 (PST)
Date: Thu, 25 Jan 2024 17:48:02 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Feng Liu <feliu@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH] virtio: uapi: Drop __packed attribute in
 linux/virtio_pci.h:
Message-ID: <20240125174705-mutt-send-email-mst@kernel.org>
References: <20240124172345.853129-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124172345.853129-1-suzuki.poulose@arm.com>

On Wed, Jan 24, 2024 at 05:23:45PM +0000, Suzuki K Poulose wrote:
> Commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> added "__packed" structures to UAPI header linux/virtio_pci.h. This triggers
> build failures in the consumer userspace applications without proper "definition"
> of __packed (e.g., kvmtool build fails).
> 
> Moreover, the structures are already packed well, and doesn't need explicit
> packing, similar to the rest of the structures in all virtio_* headers. Remove
> the __packed attribute.
> 
> Fixes: commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")


Proper form is:

Fixes: 92792ac752aa ("virtio-pci: Introduce admin command sending function")

> Cc: Feng Liu <feliu@nvidia.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  include/uapi/linux/virtio_pci.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index ef3810dee7ef..a8208492e822 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -240,7 +240,7 @@ struct virtio_pci_cfg_cap {
>  #define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
>  #define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
>  
> -struct __packed virtio_admin_cmd_hdr {
> +struct virtio_admin_cmd_hdr {
>  	__le16 opcode;
>  	/*
>  	 * 1 - SR-IOV
> @@ -252,20 +252,20 @@ struct __packed virtio_admin_cmd_hdr {
>  	__le64 group_member_id;
>  };
>  
> -struct __packed virtio_admin_cmd_status {
> +struct virtio_admin_cmd_status {
>  	__le16 status;
>  	__le16 status_qualifier;
>  	/* Unused, reserved for future extensions. */
>  	__u8 reserved2[4];
>  };
>  
> -struct __packed virtio_admin_cmd_legacy_wr_data {
> +struct virtio_admin_cmd_legacy_wr_data {
>  	__u8 offset; /* Starting offset of the register(s) to write. */
>  	__u8 reserved[7];
>  	__u8 registers[];
>  };
>  
> -struct __packed virtio_admin_cmd_legacy_rd_data {
> +struct virtio_admin_cmd_legacy_rd_data {
>  	__u8 offset; /* Starting offset of the register(s) to read. */
>  };
>  
> @@ -275,7 +275,7 @@ struct __packed virtio_admin_cmd_legacy_rd_data {
>  
>  #define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
>  
> -struct __packed virtio_admin_cmd_notify_info_data {
> +struct virtio_admin_cmd_notify_info_data {
>  	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
>  	__u8 bar; /* BAR of the member or the owner device */
>  	__u8 padding[6];


Acked-by: Michael S. Tsirkin <mst@redhat.com>

I will queue this.

> -- 
> 2.34.1


