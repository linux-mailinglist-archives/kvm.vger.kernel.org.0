Return-Path: <kvm+bounces-18464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41EA68D589E
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAE39B23AAA
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 02:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB1178283;
	Fri, 31 May 2024 02:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Znxtn8q6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345E877F13
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 02:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717122408; cv=none; b=qx9JsI3q2QEtoyWE0genJ7bOa8aeiFhdveJ3Fj4qIFwh8JHp/OdYrnMD0EnahvPBTy14DYAz0fqvFmlu968t5sjjpxRK6HxcxaHXASL7CZ9qQ4ZnhsOhoWE0sjd+SrOBzFtFwbJNOTfqTNj/P9S5/9tFVm+FlOgFe8sZPDnK66k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717122408; c=relaxed/simple;
	bh=35WEjbgLVZS1pKIK8NnG1amUaoWURjkhYh8vVNp3wXk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aYfkKHpe3nB+IJKSSFCQ2hh2tdODpyg8W2YA9mxyLP+N+QKB/Ja2NoQGsrjSnJRMiX75wD5r0fpDlsPtenHGXUg4vL/XSuKA6dPehVjrEEJ0wl1r/ZjkKhP6U4qX5Pj/ROv/iuJhGqTJjliZii3wt56QpcMcj7MqVAw7euW/GZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Znxtn8q6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717122406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V6+r8/5ml9bFpRWeX23vbPsrO7yANdn/tKxq98VOVM4=;
	b=Znxtn8q6IyyFmbCWAMAb71kg3pNCaheuyhl0j2QtsDPYOezWylFGVYWnCJ5P4BdF1WFv+M
	/apAwThTQiuMv+Tn9SbPlhdgfmVybIhmmb3kR8HOklFvtX8j01qilzyemfBVyzLLxitsga
	8Ki11yck0RCcAgl89wNkgzzzNtXwYEU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-P6tugnIVNwO1RrN7g9bcIw-1; Thu, 30 May 2024 22:26:44 -0400
X-MC-Unique: P6tugnIVNwO1RrN7g9bcIw-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2c19469036fso1295405a91.1
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 19:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717122404; x=1717727204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V6+r8/5ml9bFpRWeX23vbPsrO7yANdn/tKxq98VOVM4=;
        b=gDpmaaoFbR+ANLst1rl+w5fGjo7w2doBg9r64UjTTcC9b18IWtk9lAyrAvLlMqOvZ+
         9Xj+frL1wT5l7XAsuBpYBHKbGyF2WjMio2Oe01UYrJS1Ku5r9CuoIB7hnefJOdGFDeHW
         vowAPCXz8t2fk7gGt4Wy1xxXnGArTDgp4nu2ehtoMrJghrOdMsayIDLZ9MVOV87vrx6l
         kRMNgbbiyZ7jaNF+e8RPQQxlsg2jk/dAAjhFc5j3SA1CnEJEKpnR5XkB1MuTKf96SFZc
         kfIS5P00hREe6oZm5fkyWWmrhK3Dplv7/J25md24TEoKZtQxB+dJHSMZWjSXEz8YZADq
         WWhg==
X-Forwarded-Encrypted: i=1; AJvYcCU4UUAS8pMZ+ptFCzn38xFYsDeFO3X0marE6y1MkJBgq7SYWwZD+3e91O3ETXpoOw+jelWRJBjagGH/ry1zXtsUbKI9
X-Gm-Message-State: AOJu0YysWBcClB3ntCiRK4SEFO0NqOOZUuvCmTAhTEGWv2L8+u6IOucR
	DgD328YKFRlXfkmEFObel1pmNyuptK/eOklxIXROG9WdrcPDC33rFgGvfWSpuTRkt7e7tU4HcyD
	+NgPo2BYuaI9WF2ssHdlFVZvVu7T+CzFY6oJ3GG9UZt1kjwpr6C2vq1nWj1zat1SRBhq18dL0l0
	kJlSXi8Lq3OPagBfFtHFdNCicI
X-Received: by 2002:a17:90a:d995:b0:2bd:f4ba:fc3 with SMTP id 98e67ed59e1d1-2c1c43ed42cmr1010985a91.7.1717122403340;
        Thu, 30 May 2024 19:26:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbfNxAZHvHY+GFiEiCc3TwtoqI7vEt/8vV86jPBkD4OaWIozGm6iBZRjVzDvMqMahmLxbB/QZlcTXmPXARnBQ=
X-Received: by 2002:a17:90a:d995:b0:2bd:f4ba:fc3 with SMTP id
 98e67ed59e1d1-2c1c43ed42cmr1010944a91.7.1717122402392; Thu, 30 May 2024
 19:26:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530101823.1210161-1-schalla@marvell.com>
In-Reply-To: <20240530101823.1210161-1-schalla@marvell.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 31 May 2024 10:26:31 +0800
Message-ID: <CACGkMEsxPfck-Ww6CHSod5wP5xLOpS3t2B8qhTL0=PoE3koCGQ@mail.gmail.com>
Subject: Re: [PATCH] vdpa: Add support for no-IOMMU mode
To: Srujana Challa <schalla@marvell.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, mst@redhat.com, 
	vattunuru@marvell.com, sthotton@marvell.com, ndabilpuram@marvell.com, 
	jerinj@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 6:18=E2=80=AFPM Srujana Challa <schalla@marvell.com=
> wrote:
>
> This commit introduces support for an UNSAFE, no-IOMMU mode in the
> vhost-vdpa driver. When enabled, this mode provides no device isolation,
> no DMA translation, no host kernel protection, and cannot be used for
> device assignment to virtual machines. It requires RAWIO permissions
> and will taint the kernel.
> This mode requires enabling the "enable_vhost_vdpa_unsafe_noiommu_mode"
> option on the vhost-vdpa driver. This mode would be useful to get
> better performance on specifice low end machines and can be leveraged
> by embedded platforms where applications run in controlled environment.

I wonder if it's better to do it per driver:

1) we have device that use its own IOMMU, one example is the mlx5 vDPA devi=
ce
2) we have software devices which doesn't require IOMMU at all (but
still with protection)

Thanks

>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  drivers/vhost/vdpa.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index bc4a51e4638b..d071c30125aa 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -36,6 +36,11 @@ enum {
>
>  #define VHOST_VDPA_IOTLB_BUCKETS 16
>
> +bool vhost_vdpa_noiommu;
> +module_param_named(enable_vhost_vdpa_unsafe_noiommu_mode,
> +                  vhost_vdpa_noiommu, bool, 0644);
> +MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode, "Enable UNSAFE, =
no-IOMMU mode.  This mode provides no device isolation, no DMA translation,=
 no host kernel protection, cannot be used for device assignment to virtual=
 machines, requires RAWIO permissions, and will taint the kernel.  If you d=
o not know what this is for, step away. (default: false)");
> +
>  struct vhost_vdpa_as {
>         struct hlist_node hash_link;
>         struct vhost_iotlb iotlb;
> @@ -60,6 +65,7 @@ struct vhost_vdpa {
>         struct vdpa_iova_range range;
>         u32 batch_asid;
>         bool suspended;
> +       bool noiommu_en;
>  };
>
>  static DEFINE_IDA(vhost_vdpa_ida);
> @@ -887,6 +893,10 @@ static void vhost_vdpa_general_unmap(struct vhost_vd=
pa *v,
>  {
>         struct vdpa_device *vdpa =3D v->vdpa;
>         const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       if (v->noiommu_en)
> +               return;
> +
>         if (ops->dma_map) {
>                 ops->dma_unmap(vdpa, asid, map->start, map->size);
>         } else if (ops->set_map =3D=3D NULL) {
> @@ -980,6 +990,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struc=
t vhost_iotlb *iotlb,
>         if (r)
>                 return r;
>
> +       if (v->noiommu_en)
> +               goto skip_map;
> +
>         if (ops->dma_map) {
>                 r =3D ops->dma_map(vdpa, asid, iova, size, pa, perm, opaq=
ue);
>         } else if (ops->set_map) {
> @@ -995,6 +1008,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, stru=
ct vhost_iotlb *iotlb,
>                 return r;
>         }
>
> +skip_map:
>         if (!vdpa->use_va)
>                 atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
>
> @@ -1298,6 +1312,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdp=
a *v)
>         struct vdpa_device *vdpa =3D v->vdpa;
>         const struct vdpa_config_ops *ops =3D vdpa->config;
>         struct device *dma_dev =3D vdpa_get_dma_dev(vdpa);
> +       struct iommu_domain *domain;
>         const struct bus_type *bus;
>         int ret;
>
> @@ -1305,6 +1320,14 @@ static int vhost_vdpa_alloc_domain(struct vhost_vd=
pa *v)
>         if (ops->set_map || ops->dma_map)
>                 return 0;
>
> +       domain =3D iommu_get_domain_for_dev(dma_dev);
> +       if ((!domain || domain->type =3D=3D IOMMU_DOMAIN_IDENTITY) &&
> +           vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {
> +               add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +               dev_warn(&v->dev, "Adding kernel taint for noiommu on dev=
ice\n");
> +               v->noiommu_en =3D true;
> +               return 0;
> +       }
>         bus =3D dma_dev->bus;
>         if (!bus)
>                 return -EFAULT;
> --
> 2.25.1
>


