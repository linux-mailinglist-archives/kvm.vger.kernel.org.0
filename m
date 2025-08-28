Return-Path: <kvm+bounces-56191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA38B3ACDC
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:44:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13A45567A6A
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6402C2364;
	Thu, 28 Aug 2025 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vd6zOPx/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775962BEC34
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 21:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756417469; cv=none; b=g9yk6hzcgbRAl9fn0eOKa/A7lVveZpsQx8JggInt9wCjxg4PW2CHe96VuCAmLRaSinfaej+KVNdQXOdAqO7t5vgvPNaWwCxBTLLCrz4EuYk/I9CjaX8eLGb/y7DI/Bvf70Gg+HMMZ5AMX/zlLUcep3jqGhBgNQW+BM8QWBL/7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756417469; c=relaxed/simple;
	bh=GqvJqfvJWhpmyKfjufJhWpQg+eSKv4bD/PdpwBPkw4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDCRTHGC/AZ8VTmsc7oJiDTXD52kOutkmGqf7koOr2iF7I8nthoEbAhG2uVmNFgL4bgR+4jvhuKDsol5chcg8HHgt1HA90uu2A1GlQ+NIlM9zC5ocD4Wa2h43bSOt9lDkJXhb53re7aTmWXIRkduoEqe5MdEAMhvIFjpNA2odfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vd6zOPx/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756417466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2RACveh/So+FTKv8PaqNTUy1Q8R/Mr9cJX1WRHPYTfo=;
	b=Vd6zOPx/rlwE3GSy0+GLCj0hR+m3qy7ReZuQcxDjWykPQEvW+HJ7YIgMIeAJhbUd6wt0Vi
	mkyheYrYfRWOLbb3Dz3fQuAJeRgDXLNXXVUwYWMVHKjI886BemeyIaqL5ERr1F8KG3QN3C
	xLYt6BG0eLVNpWrGsa/w6rUYc5gMc5M=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-LM6-C8wPNHW7B1kNz-UADg-1; Thu, 28 Aug 2025 17:44:24 -0400
X-MC-Unique: LM6-C8wPNHW7B1kNz-UADg-1
X-Mimecast-MFC-AGG-ID: LM6-C8wPNHW7B1kNz-UADg_1756417463
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ebd3ca6902so3763695ab.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 14:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756417463; x=1757022263;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2RACveh/So+FTKv8PaqNTUy1Q8R/Mr9cJX1WRHPYTfo=;
        b=mFOpI8YBaKSepYAMB82hYAKioCyWE9fKpU+sSsVESDSgCiR1EPWlbOnI6/jU2+4NUc
         PXYtJ2kPZ04LKXCQ8re4R51RxdV9kbJj7xqcgDO4v7QJ1/TxfRtIaQisPC2MFppe8Psu
         G1g7AnyGFnvX9OCpl18sB23boQNlVnBOEY1qNnNDPBhQbua+vN9oZruWElaGBvSQLAFu
         d/EKZEiiaJJBBJDX9t2puPBBBdcGItHTXu+GrzT9xxA8b7RcHzCtw9MdQ8TsAZOA3gPB
         NI0tK4eEgGnP8E5VLsADPmoaJ+4TTSdx/k9diNI8DK5vI6q/2GYMZJx8Ywy6nARuoKuC
         tFfw==
X-Forwarded-Encrypted: i=1; AJvYcCXvAyyTDanSG+3CIWAOvdwhWHlgjZAAa6vR7FdE+yEb7pJiP1Y/gbxw+0MCBeh6yaWHHTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YykmGlBvk1vbq2dmCKOLGML67F5wGzl2kHBY2F2m2fzkyAZXxgn
	AqsdPtZcb0ELdrETw9j2D7U7Z7DUu4k0Ofs0XKgMFwPR0Grs6wbsyoMhk84LqO7Jv560viCg7nu
	BCaUg6QiYXLvub3GUZ7mVZ+MHGBPzoU8AVDuyGP9Bg5WyI8cWw3nqJQ==
X-Gm-Gg: ASbGncsgfBdLxgCiGdNwFFtUr/o75SU6b9wah9zkh5jkf7eGcO20IWL5CEMsVBVpgM7
	AHRFh6jPJ3qW0aTMees3saGsmnnw/yAo9bAWOWBtIcYbE2fbf4z90bavLilZvvZtNXEaoj6R6zx
	UMa+bVUnB5cNTetbmszanD3SjwPkDjuGqwdsy6NzDbafb6om2rB8QQQsSibWm6QgEV22zk2USAl
	JPvBbfjR84ij5mN+C2HOitGQJ0c9q0JBeECKFzhTN8fhQ8JHfVvYcYEQsuSGm5QD1TKScHF55gz
	A25d6XlgK74NSTLAhNL9dV40Cq1026AMUYB+YsFI390=
X-Received: by 2002:a92:c26c:0:b0:3f1:de48:36ad with SMTP id e9e14a558f8ab-3f1de48389amr15264695ab.4.1756417463546;
        Thu, 28 Aug 2025 14:44:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEg3wgzbv9HEvAwkExjx2PJxCJ2VJntEJpNjUpTyBRq2NcFk03fhpFQ0yUR1SdojwXP+MApaA==
X-Received: by 2002:a92:c26c:0:b0:3f1:de48:36ad with SMTP id e9e14a558f8ab-3f1de48389amr15264645ab.4.1756417463113;
        Thu, 28 Aug 2025 14:44:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f2a1c704ccsm763975ab.42.2025.08.28.14.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 14:44:22 -0700 (PDT)
Date: Thu, 28 Aug 2025 15:44:19 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, ldv@strace.io, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: show the name of IOMMU driver in
 /proc/$pid/fdinfo
Message-ID: <20250828154419.5f4b15ff.alex.williamson@redhat.com>
In-Reply-To: <20250828202100.3661180-1-yamato@redhat.com>
References: <20250828202100.3661180-1-yamato@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

[Cc kvm@vger.kernel.org]

On Fri, 29 Aug 2025 05:21:00 +0900
Masatake YAMATO <yamato@redhat.com> wrote:

> The ops of VFIO overlap:
> 
>   (include/uapi/linux/vfio.h)
>   #define VFIO_DEVICE_GET_PCI_HOT_RESET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
>   ...
>   #define VFIO_MIG_GET_PRECOPY_INFO _IO(VFIO_TYPE, VFIO_BASE + 21)
>   ...
>   #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
>   #define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
>   #define VFIO_EEH_PE_OP			_IO(VFIO_TYPE, VFIO_BASE + 21)
>   #define VFIO_IOMMU_SPAPR_REGISTER_MEMORY	_IO(VFIO_TYPE, VFIO_BASE + 17)
>   ...
>   #define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 20)
> 
> These overlapping makes strace decoding the ops and their arguments hard.
> See also https://lists.strace.io/pipermail/strace-devel/2021-May/010561.html
> 
> This change adds "vfio-iommu-driver" field to /proc/$pid/fdinfo/$fd
> where $fd opens /dev/vfio/vfio. The value of the field helps strace
> decode the ops arguments.
> 
> The prototype version of strace based on this change works fine:
> - https://lists.strace.io/pipermail/strace-devel/2021-August/010660.html
> - https://lists.strace.io/pipermail/strace-devel/2021-August/010660.html

Duplicate links.

We really only have type1 and spapr, and they're mutually exclusive per
architecture.  POWER is spapr and everything else is type1.  We're also
moving to using IOMMUFD and consider the vfio container to be somewhat
legacy, so we're not getting any new IOMMU backends for container mode.
The spapr support is also barely hanging on by a shoestring.

Is there current interest (ie. since 2021) for these changes?  It
doesn't appear that even the RFC these changes were based on,
differentiating by file type, is in the current strace code base.
 
> Cc: Dmitry V. Levin <ldv@strace.io>
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---
>  drivers/vfio/container.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
> index d53d08f16973..03677fda49de 100644
> --- a/drivers/vfio/container.c
> +++ b/drivers/vfio/container.c
> @@ -11,6 +11,7 @@
>  #include <linux/iommu.h>
>  #include <linux/miscdevice.h>
>  #include <linux/vfio.h>
> +#include <linux/seq_file.h>
>  #include <uapi/linux/vfio.h>
>  
>  #include "vfio.h"
> @@ -384,12 +385,22 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
>  	return 0;
>  }

#ifdef CONFIG_PROC_FS

> +static void vfio_fops_show_fdinfo(struct seq_file *m, struct file *filep)
> +{
> +	struct vfio_container *container = filep->private_data;
> +	struct vfio_iommu_driver *driver = container->iommu_driver;
> +
> +	if (driver && driver->ops->name)
> +		seq_printf(m, "vfio-iommu-driver:\t%s\n", driver->ops->name);
> +}

#endif

> +
>  static const struct file_operations vfio_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= vfio_fops_open,
>  	.release	= vfio_fops_release,
>  	.unlocked_ioctl	= vfio_fops_unl_ioctl,
>  	.compat_ioctl	= compat_ptr_ioctl,

#ifdef CONFIG_PROC_FS

> +	.show_fdinfo    = vfio_fops_show_fdinfo,

#endif

>  };
>  
>  struct vfio_container *vfio_container_from_file(struct file *file)

proc.rst should also be updated.  See [1] for a recent addition fdinfo.
Thanks,

Alex

[1]https://lore.kernel.org/r/20250804-show-fdinfo-v4-1-96b14c5691b3@fb.com


