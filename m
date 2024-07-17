Return-Path: <kvm+bounces-21772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 549BE933A54
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 11:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 779271C2123B
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 09:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F4617E900;
	Wed, 17 Jul 2024 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3yCzcP+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF0C17E8E7
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 09:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721209823; cv=none; b=NqVbhi5wGOEzbFjwAAmQN5hJrcTkPRuZHdinD+/QAIway8AlrMWms8++Fc+8baHOGKFIngx8CmL8k75MeipI2EKbxrraQ9yOylatXVSnQCeyz/utVaGK1vrYox3p5UHYP3qIG6loTMteAES8Riyzg9P5WTXr1bh/W9/lQWoWcl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721209823; c=relaxed/simple;
	bh=1GWDLi+rpH5kf8UEfpUbvHAag3ZG04JK6FiCae7FEdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RoT1ZcDhDk7AEiILBcT5l2wwAtUEk3AYmSAyJw9U5lGA9LUqB0+ipzLkSazZSvKJWyh/WeHk8vp3Mgm8bmq3S46MWNZjohYt4KTiAWLnaSwI5B7hc0S3vjVw03pMXPL5mZ4OgzjHRQ4A8jwWfns2j16Nz6XRl2CmchCqzltA87U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J3yCzcP+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721209820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o5c0R7RDnqopCcCZP1eZaSuKmjpWay3dHbgxoGXMIDE=;
	b=J3yCzcP+9Qcla6nU/PYnJ/d2eSrU7ObArsONX/iKvDAQhZPzpXGhYnNICzND3Lp0HoiDwr
	3lmB6jxlDHjtXVVYhN02HS3rTzRa4izok4wYyEWwIaUR8MkuM2LaDzyb8gCSOir5CKW/We
	kVMd54IV8ng+Ahff4UTwiPlfWLWr+UU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-ofoFApfjOx6A-5pUCJX1rw-1; Wed, 17 Jul 2024 05:50:19 -0400
X-MC-Unique: ofoFApfjOx6A-5pUCJX1rw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3679ab94cdbso4128321f8f.3
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 02:50:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721209818; x=1721814618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5c0R7RDnqopCcCZP1eZaSuKmjpWay3dHbgxoGXMIDE=;
        b=FxkLzFnbDXG0aL9xh4m5zrFPOQo/U9V98G7Cponm/wBcViuPWT4RYDYtoiR0vK1KO4
         ksdojbvVbzGxBnCx3hCCbwpjIyYoJ9arLJ2k0Rb7V0KGZS0NzC47U6vesPukXQUsPVrb
         RzS9JobLQ2VAYncKUvmHSpBEPuuG2FUrfZ4EOj6RDoKjKYwtvCdQ6BIY5ZewebRnSSYK
         Ey97xSwtaMAb+Wu/TlcreQURvHPaxcTh6nfIylTrPzbg3EXKDeiFCAnIF/LHL4Eroth9
         xQc3LouCwG5Lihde+RueNfXv7zfIg1wTepJKgDyGEQYoeJTuDcYyg1iyAjjvsoKueUfv
         SqIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUCaEeUs22Lb1kn6Q5c1qz4kOIPxd9qO3HHl7I5+NDpB9ruXP79KyRldqXlAyNgDo+M87sqXGiCbyk2XS2drjS8BOg
X-Gm-Message-State: AOJu0YwBpLr8hybSN7YQ8E4idjjeaR3JbACLQMtWxbNFqTgqAPD7eC8z
	yt9Spwp82jjFGnqNscN2gMq0hM/nysc5Mxl9mnX90vsIOHIkhRctIjllNivjjatnwvEOtcA5ljZ
	e3O2QtAkM0pcUAIdeniPddQtvautStG0cbrm2ChJKgAQ5YxcbXQ==
X-Received: by 2002:a5d:5385:0:b0:362:7c2e:e9f7 with SMTP id ffacd0b85a97d-3683165b58cmr950844f8f.32.1721209818155;
        Wed, 17 Jul 2024 02:50:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnZDMUmEl0a9ZjZlUyXEG0/8IGoPV7z2kmIum/zE5asvvqWw8BO8/MquAo8rD6ksuXJmeMVQ==
X-Received: by 2002:a5d:5385:0:b0:362:7c2e:e9f7 with SMTP id ffacd0b85a97d-3683165b58cmr950822f8f.32.1721209817548;
        Wed, 17 Jul 2024 02:50:17 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f6:360d:da73:bbf7:ba86:37fb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dafb939sm11239854f8f.89.2024.07.17.02.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 02:50:16 -0700 (PDT)
Date: Wed, 17 Jul 2024 05:50:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Srujana Challa <schalla@marvell.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
	jasowang@redhat.com, vattunuru@marvell.com, sthotton@marvell.com,
	ndabilpuram@marvell.com, jerinj@marvell.com
Subject: Re: [PATCH] vdpa: Add support for no-IOMMU mode
Message-ID: <20240717054547-mutt-send-email-mst@kernel.org>
References: <20240530101823.1210161-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530101823.1210161-1-schalla@marvell.com>

On Thu, May 30, 2024 at 03:48:23PM +0530, Srujana Challa wrote:
> This commit introduces support for an UNSAFE, no-IOMMU mode in the
> vhost-vdpa driver. When enabled, this mode provides no device isolation,
> no DMA translation, no host kernel protection, and cannot be used for
> device assignment to virtual machines. It requires RAWIO permissions
> and will taint the kernel.
> This mode requires enabling the "enable_vhost_vdpa_unsafe_noiommu_mode"
> option on the vhost-vdpa driver. This mode would be useful to get
> better performance on specifice low end machines and can be leveraged
> by embedded platforms where applications run in controlled environment.
> 
> Signed-off-by: Srujana Challa <schalla@marvell.com>

Thought hard about that.
I think given vfio supports this, we can do that too, and
the extension is small.

However, it looks like setting this parameter will automatically
change the behaviour for existing userspace when IOMMU_DOMAIN_IDENTITY
is set.

I suggest a new domain type for use just for this purpose.  This way if
host has an iommu, then the same kernel can run both VMs with
isolation and unsafe embedded apps without.

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
> +		   vhost_vdpa_noiommu, bool, 0644);
> +MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
> +
>  struct vhost_vdpa_as {
>  	struct hlist_node hash_link;
>  	struct vhost_iotlb iotlb;
> @@ -60,6 +65,7 @@ struct vhost_vdpa {
>  	struct vdpa_iova_range range;
>  	u32 batch_asid;
>  	bool suspended;
> +	bool noiommu_en;
>  };
>  
>  static DEFINE_IDA(vhost_vdpa_ida);
> @@ -887,6 +893,10 @@ static void vhost_vdpa_general_unmap(struct vhost_vdpa *v,
>  {
>  	struct vdpa_device *vdpa = v->vdpa;
>  	const struct vdpa_config_ops *ops = vdpa->config;
> +
> +	if (v->noiommu_en)
> +		return;
> +
>  	if (ops->dma_map) {
>  		ops->dma_unmap(vdpa, asid, map->start, map->size);
>  	} else if (ops->set_map == NULL) {
> @@ -980,6 +990,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>  	if (r)
>  		return r;
>  
> +	if (v->noiommu_en)
> +		goto skip_map;
> +
>  	if (ops->dma_map) {
>  		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
>  	} else if (ops->set_map) {
> @@ -995,6 +1008,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>  		return r;
>  	}
>  
> +skip_map:
>  	if (!vdpa->use_va)
>  		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
>  
> @@ -1298,6 +1312,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>  	struct vdpa_device *vdpa = v->vdpa;
>  	const struct vdpa_config_ops *ops = vdpa->config;
>  	struct device *dma_dev = vdpa_get_dma_dev(vdpa);
> +	struct iommu_domain *domain;
>  	const struct bus_type *bus;
>  	int ret;
>  
> @@ -1305,6 +1320,14 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>  	if (ops->set_map || ops->dma_map)
>  		return 0;
>  
> +	domain = iommu_get_domain_for_dev(dma_dev);
> +	if ((!domain || domain->type == IOMMU_DOMAIN_IDENTITY) &&
> +	    vhost_vdpa_noiommu && capable(CAP_SYS_RAWIO)) {

So if userspace does not have CAP_SYS_RAWIO instead of failing
with a permission error the functionality changes silently?
That's confusing, I think.


> +		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +		dev_warn(&v->dev, "Adding kernel taint for noiommu on device\n");
> +		v->noiommu_en = true;
> +		return 0;
> +	}
>  	bus = dma_dev->bus;
>  	if (!bus)
>  		return -EFAULT;
> -- 
> 2.25.1


