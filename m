Return-Path: <kvm+bounces-27329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C12983F8D
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 09:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D103DB2227D
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 07:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08188148FF7;
	Tue, 24 Sep 2024 07:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9EzWIuc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6CF45026
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 07:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727163830; cv=none; b=r/VSmmo4b+GRe/jC9I8CT45JSpaVhmeBBzgEqc2cfNlY2oz75uk9wg+vJvW64DGsykGmlYMixYlROSUlyPAOGJuGPViBxXD35MHwJ3FcYHp0ZLR57ZHwTB3lJKG/foEdXWFDyVUinQd1vt2aThRaf/aEbBlKyknhkJyKIBKwsJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727163830; c=relaxed/simple;
	bh=UU7qX41uAkDBCUy0XnOT3NeX1cw7axD/xz6j6BHgRsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rdpC2faslS2GTd05VnsVTa6o4m1amHk1eupnB8av71JfM4pNoII7zcc4yWdopVucVQ1uUyVJRH8tjElXtSp433MfjPXevH0oJrkVvBPqYQN0VT82n1CcnT5O539HVMJ5nBqFidaPo1NRVXzipQe8MG7ThwCYT/atKDrxA9ZeRcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9EzWIuc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727163827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sd/bnnzJzJdkv8ZbLlpvLffK8I346cwr0/QVzzvREsY=;
	b=a9EzWIuc4DZaRjwy1DVe5iNBfrufeO6ng/fabfg2hITpNmDvAEL/wRJKPubRoWdRTzl/f8
	AzlMEnUKInK8BzPPLmOhfVUUFShZt0Mi1zcTYkr2sEHadkH3ITc6Dgj/Pr1ah33+isqlpK
	as2PpkIJGTlNKaIa6gCj1luOUKQ9rG0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382--cN28OsAPf62hWs2seSPbw-1; Tue, 24 Sep 2024 03:43:46 -0400
X-MC-Unique: -cN28OsAPf62hWs2seSPbw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2d9a2b8af50so5782797a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 00:43:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727163825; x=1727768625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sd/bnnzJzJdkv8ZbLlpvLffK8I346cwr0/QVzzvREsY=;
        b=KTQomSPtAcoPNsDbu9t7GFp8v4RWWJL/6x+P9j9uPsOy15++kyNDFU9kvsH/Sp8ACk
         zS1p3uOGbdFIfrDCxTMx2U9XTcojKoyBIcUnE3me9GG3s81OchuB5G5+QjXCaxoAxBcm
         Q/FUBvn6yGey75tyA6jrIa6vaFKk2gBfrnSZNlP1n0iXHnqqwgLCjBTP5QA/Sd/Fv9CW
         /5Qa5T96vNPMNACxXzvCwlqNA7FEyBPbCmsNxQH0MWZ6bWvLZFBvpJIWM+vcFpHpriW5
         /j0rjivjLVgw6aRSUX20Pwf0XxCjtdgaYwTW0+Glx6E1erp41xBGcC7N9eCWwX/9fp68
         4WBw==
X-Forwarded-Encrypted: i=1; AJvYcCWfAkDsXtwaAJrxbwGRX7Jp/JrrqtpzNbSsKirXcW6dalzadGUpQXjYu1chwJjWstbCz3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YygADihkDo+4w8pE4J5Up/gwt3iRgn3GXmx+d8SWGKPWXcNS/K3
	DMKzfeQ0Q+FlbdiP3zw8Gd7HMVvoYPr299WIDpw4XdfZ7ypZlMqaU3kNqXoV8+ujB8GXwlribuu
	bf1eyxNSs/F72baUIbAd4DzcjdF65w5IIS6UqE8HBwfk82YupgUA0yT04SxpXMxByAV0VutJrh3
	102t744heMhL0CQmHVmrBP+CBm
X-Received: by 2002:a17:90a:da87:b0:2d8:f99d:48d2 with SMTP id 98e67ed59e1d1-2dd7f70f6famr15958896a91.29.1727163825042;
        Tue, 24 Sep 2024 00:43:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0+gIzMz2GXzofDVPp+N0+RslIpcesvc1C39NkG39H0QZ2cMLZOB/b9ilj4g/GDXxjLMrNJcgAcNohePyiDT4=
X-Received: by 2002:a17:90a:da87:b0:2d8:f99d:48d2 with SMTP id
 98e67ed59e1d1-2dd7f70f6famr15958879a91.29.1727163824594; Tue, 24 Sep 2024
 00:43:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240920140530.775307-1-schalla@marvell.com> <20240920140530.775307-3-schalla@marvell.com>
In-Reply-To: <20240920140530.775307-3-schalla@marvell.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 24 Sep 2024 15:43:33 +0800
Message-ID: <CACGkMEuB8BikU7or6wso9ortoQfX+cCw-Q=x3o_rtdmVTqLZiQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vhost-vdpa: introduce NO-IOMMU backend feature bit
To: Srujana Challa <schalla@marvell.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, mst@redhat.com, 
	eperezma@redhat.com, ndabilpuram@marvell.com, jerinj@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2024 at 10:05=E2=80=AFPM Srujana Challa <schalla@marvell.co=
m> wrote:
>
> This patch introduces the VHOST_BACKEND_F_NOIOMMU feature flag.
> This flag allows userspace to identify if the driver can operate
> without an IOMMU, providing more flexibility in environments where
> IOMMU is not available or desired.
>
> Key changes include:
>     - Addition of the VHOST_BACKEND_F_NOIOMMU feature flag.
>     - Updates to vhost_vdpa_unlocked_ioctl to handle the NO-IOMMU
>       feature.
> The NO-IOMMU mode is enabled if:
>     - The vdpa device lacks an IOMMU domain.
>     - The system has the required RAWIO permissions.
>     - The vdpa device explicitly supports NO-IOMMU mode.
>
> This feature flag indicates to userspace that the driver can safely
> operate in NO-IOMMU mode. If the flag is absent, userspace should
> assume NO-IOMMU mode is unsupported and take appropriate actions.

This seems contradictory to what you said in patch 1

"""
When enabled, this mode provides no
device isolation, no DMA translation, no host kernel protection, and
cannot be used for device assignment to virtual machines.
"""

And I wonder what "appropriate actions" could the userspace take?
Generally, the IOMMU concept should be hidden from the userspace.

Thanks

>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  drivers/vhost/vdpa.c             | 11 ++++++++++-
>  include/uapi/linux/vhost_types.h |  2 ++
>  2 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index b3085189ea4a..de47349eceff 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -797,7 +797,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *fi=
lep,
>                                  BIT_ULL(VHOST_BACKEND_F_IOTLB_PERSIST) |
>                                  BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
>                                  BIT_ULL(VHOST_BACKEND_F_RESUME) |
> -                                BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRI=
VER_OK)))
> +                                BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRI=
VER_OK) |
> +                                BIT_ULL(VHOST_BACKEND_F_NOIOMMU)))
>                         return -EOPNOTSUPP;
>                 if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
>                      !vhost_vdpa_can_suspend(v))
> @@ -814,6 +815,12 @@ static long vhost_vdpa_unlocked_ioctl(struct file *f=
ilep,
>                 if ((features & BIT_ULL(VHOST_BACKEND_F_IOTLB_PERSIST)) &=
&
>                      !vhost_vdpa_has_persistent_map(v))
>                         return -EOPNOTSUPP;
> +               if ((features & BIT_ULL(VHOST_BACKEND_F_NOIOMMU)) &&
> +                   !v->noiommu_en)
> +                       return -EOPNOTSUPP;
> +               if (!(features & BIT_ULL(VHOST_BACKEND_F_NOIOMMU)) &&
> +                   v->noiommu_en)
> +                       return -EOPNOTSUPP;
>                 vhost_set_backend_features(&v->vdev, features);
>                 return 0;
>         }
> @@ -871,6 +878,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *fi=
lep,
>                         features |=3D BIT_ULL(VHOST_BACKEND_F_DESC_ASID);
>                 if (vhost_vdpa_has_persistent_map(v))
>                         features |=3D BIT_ULL(VHOST_BACKEND_F_IOTLB_PERSI=
ST);
> +               if (v->noiommu_en)
> +                       features |=3D BIT_ULL(VHOST_BACKEND_F_NOIOMMU);
>                 features |=3D vhost_vdpa_get_backend_features(v);
>                 if (copy_to_user(featurep, &features, sizeof(features)))
>                         r =3D -EFAULT;
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index d7656908f730..dda673c3456a 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -192,5 +192,7 @@ struct vhost_vdpa_iova_range {
>  #define VHOST_BACKEND_F_DESC_ASID    0x7
>  /* IOTLB don't flush memory mapping across device reset */
>  #define VHOST_BACKEND_F_IOTLB_PERSIST  0x8
> +/* Enables the device to operate in NO-IOMMU mode as well */
> +#define VHOST_BACKEND_F_NOIOMMU  0x9
>
>  #endif
> --
> 2.25.1
>


