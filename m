Return-Path: <kvm+bounces-53520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06F15B13139
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08E641892D25
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B471A223705;
	Sun, 27 Jul 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sO/kZha1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CD4145B3F
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753641328; cv=none; b=fPEC4CDjEM937nQwHdeS+ZXUSTnLiEIEkCzd4khY3EiDtYdTn+ZKILboH3vMWX/G+8E4Rs3Yfsl29R8Ww+yEgfvbDbJmkbU60dMcmYkPIdi7Bw0+N+QOrCu6o0gikgf9nr/OJwMFidY4hrMwplpWI3M3EWaHpjtqOqPIATrXn1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753641328; c=relaxed/simple;
	bh=8eWwYnDeNPAzlJ/pf/U4dMPWlq47zT58mnpRnmAOGnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ES8uwoUz3zRRaKSF5KxV07PLLF2fRMN+Me2MrgFBz6tc2glFtb7lZ//GnQgeeSBLmacCPe+jf+aFuZ6bSxg8fRsZjZpv0+KDcTePfCAPMrdxBH/rodfbLRpIIcQsrxTn7AXLHBXXwd37tnO1tkzV0guszIHL88uv2SIx8LY2LSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sO/kZha1; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4561b43de62so87135e9.0
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753641324; x=1754246124; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PDekYC0c30J3PMiyfG4Yd6w1CCh95BPodYkO+8pAt14=;
        b=sO/kZha1ztF9ib9zvman5xCYTGrwpQ2Qw/WIC1Kn7NfvnIUEuaBhxqyMRVvDtTy+RH
         cDuEk5A+zJVgnPkuYPIkAxDK5te1xGkytny0j/qg1QlbP66sMNArxnWaeyCKB5gcO/5P
         /6U+E6lyY21Y9kjwxe+THthatRvU233bRALOrub6mgNzQLNS+YHuWO2TIyp646N1WNeC
         ofHcz/aEN4WaP8nFvqGJALsHAtWhIborRLQ+f6EGc4TDV2R0EVlq/3vu9jJDWGkfvx1h
         wICb7Kun5vqV0JfLd+ShSPKqMqHGlPkGipsJ0P65zM1dA0lTehi6CJF78WHSdKnxnFnY
         Ud9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753641324; x=1754246124;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PDekYC0c30J3PMiyfG4Yd6w1CCh95BPodYkO+8pAt14=;
        b=oRZHj/WPVtfS6aEKcXytIZwtW3449ZElTrbMGktnwwffQmJsiAtQ/d1ro/IEgHm90c
         4t3L6Z1npu8T9FZzjf8qDSEQvpZrYSJVfK5M2wFFm2g8IKM8s3DqJdI/Lo5m9HPNkjaC
         xAIPLbPKL/UY+8u1KuEG+DSFI/S7zZNhD/1XnaxVUwJOO/0g4nQynzrichkP3Udct6F2
         DDdsGE13PMJrVClSSszGsBTndOXI8AwcNGJt8C36POtOsbuH3x8D1wu+s2dLlP3WNLEJ
         puQav1UGKDNDexJoBjR6/2tZ+ut3TxkrbfXwwBSQN4pg7ixvExRK7ORcU1tHJWpAJxG8
         Xx/g==
X-Gm-Message-State: AOJu0YzbHZTQxib9o4yTlPqcMm9PGxDSKg398XQqP9I2+umevJ8dcHz/
	ZPSpN0CPMFmp4SCDsZG0KjJS1+h4wZK9xLHRavfJHqG5T54Ii80Dwt4CUqO0Ttzo8w==
X-Gm-Gg: ASbGncvFqyufBNZiTV2swk2bFuBvwcw/SG8MpBwesjuqJfuKY536P09EnIjpISMb85/
	2Y+FV/rsPGN1zdkSexahNjajdE/TwENTDysFzx5FPxw3/QNeqtFgfSInz5acZIVKtwfIo8lT3+B
	gnIBvlMX4Ka8PB8AV2zFo12alq0QPoIkhUQ6XQC52UJV4XHDeJyBpUgsHnSComPw0VcgcpEzIYD
	AfDlGq8Ax98K7dSqvM5qaPwGF3p0v6nLOqS6M7jt9GKjhfnPeuIBZgZarShaskmp1qFBXgW95Qb
	gKTd9KM86TxeZ/VTgjk4qa0WiRL+7AC+wV19ljRdBvsDoa7eeO0DBux9WYomnmZgqP68zdFDsV/
	tBJe3OSoZcuYLof7EtZp6IjqVpsOOoGvMyHXMU8aLAEaCUFHbCbCQsUJlRlS/GOWWw7sQfgU=
X-Google-Smtp-Source: AGHT+IGdR/yFIEARENqXM1Ap9MZ5SfGDtiLY9RRVNvZDke3O10YYz5Z00htJjhLYQSrtajpx5y7MMA==
X-Received: by 2002:a05:600c:a110:b0:453:672b:5b64 with SMTP id 5b1f17b1804b1-4587c1ab6f2mr1318985e9.2.1753641324176;
        Sun, 27 Jul 2025 11:35:24 -0700 (PDT)
Received: from google.com (232.38.195.35.bc.googleusercontent.com. [35.195.38.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b78889682bsm915959f8f.77.2025.07.27.11.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:35:23 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:35:21 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
Message-ID: <aIZxadj3-uxSwaUu@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250525074917.150332-9-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This also allocates a stage1 bypass and stage2 translate table.

So this makes IOMMUFD only working with SMMUv3?

I don’t understand what is the point of this configuration? It seems to add
extra complexity and extra hw constraints and no extra value.

Not related to this patch, do you have plans to add some of the other iommufd
features, I think things such as page faults might be useful?

Thanks,
Mostafa

> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  builtin-run.c            |   2 +
>  include/kvm/kvm-config.h |   1 +
>  vfio/core.c              |   4 +-
>  vfio/iommufd.c           | 115 ++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 119 insertions(+), 3 deletions(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index 39198f9bc0d6..bfa3e8b09f82 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -263,6 +263,8 @@ static int loglevel_parser(const struct option *opt, const char *arg, int unset)
>  		     "Assign a PCI device to the virtual machine",	\
>  		     vfio_device_parser, kvm),				\
>  	OPT_BOOLEAN('\0', "iommufd", &(cfg)->iommufd, "Use iommufd interface"),	\
> +	OPT_BOOLEAN('\0', "iommufd-vdevice", &(cfg)->iommufd_vdevice,   \
> +			"Use iommufd vdevice interface"),			\
>  									\
>  	OPT_GROUP("Debug options:"),					\
>  	OPT_CALLBACK_NOOPT('\0', "debug", kvm, NULL,			\
> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> index 632eaf84b7eb..d80be6826469 100644
> --- a/include/kvm/kvm-config.h
> +++ b/include/kvm/kvm-config.h
> @@ -66,6 +66,7 @@ struct kvm_config {
>  	bool mmio_debug;
>  	int virtio_transport;
>  	bool iommufd;
> +	bool iommufd_vdevice;
>  };
>  
>  #endif
> diff --git a/vfio/core.c b/vfio/core.c
> index 0b1796c54ffd..8dfcf3ca35c1 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -373,7 +373,7 @@ static int vfio__init(struct kvm *kvm)
>  	}
>  	kvm_vfio_device = device.fd;
>  
> -	if (kvm->cfg.iommufd)
> +	if (kvm->cfg.iommufd || kvm->cfg.iommufd_vdevice)
>  		return iommufd__init(kvm);
>  	return legacy_vfio__init(kvm);
>  }
> @@ -395,7 +395,7 @@ static int vfio__exit(struct kvm *kvm)
>  
>  	free(kvm->cfg.vfio_devices);
>  
> -	if (kvm->cfg.iommufd)
> +	if (kvm->cfg.iommufd || kvm->cfg.iommufd_vdevice)
>  		return iommufd__exit(kvm);
>  
>  	return legacy_vfio__exit(kvm);
> diff --git a/vfio/iommufd.c b/vfio/iommufd.c
> index 742550705746..39870320e4ac 100644
> --- a/vfio/iommufd.c
> +++ b/vfio/iommufd.c
> @@ -108,6 +108,116 @@ err_out:
>  	return ret;
>  }
>  
> +static int iommufd_alloc_s1bypass_hwpt(struct vfio_device *vdev)
> +{
> +	int ret;
> +	unsigned long dev_num;
> +	unsigned long guest_bdf;
> +	struct vfio_device_bind_iommufd bind;
> +	struct vfio_device_attach_iommufd_pt attach_data;
> +	struct iommu_hwpt_alloc alloc_hwpt;
> +	struct iommu_viommu_alloc alloc_viommu;
> +	struct iommu_hwpt_arm_smmuv3 bypass_ste;
> +	struct iommu_vdevice_alloc alloc_vdev;
> +
> +	bind.argsz = sizeof(bind);
> +	bind.flags = 0;
> +	bind.iommufd = iommu_fd;
> +
> +	/* now bind the iommufd */
> +	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to get info");
> +		goto err_out;
> +	}
> +
> +	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
> +	alloc_hwpt.flags = IOMMU_HWPT_ALLOC_NEST_PARENT;
> +	alloc_hwpt.dev_id = bind.out_devid;
> +	alloc_hwpt.pt_id = ioas_id;
> +	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
> +	alloc_hwpt.data_len = 0;
> +	alloc_hwpt.data_uptr = 0;
> +
> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
> +		ret = -errno;
> +		pr_err("Failed to allocate HWPT");
> +		goto err_out;
> +	}
> +
> +	attach_data.argsz = sizeof(attach_data);
> +	attach_data.flags = 0;
> +	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
> +
> +	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to attach to IOAS ");
> +		goto err_out;
> +	}
> +
> +	alloc_viommu.size = sizeof(alloc_viommu);
> +	alloc_viommu.flags = 0;
> +	alloc_viommu.type = IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
> +	alloc_viommu.dev_id = bind.out_devid;
> +	alloc_viommu.hwpt_id = alloc_hwpt.out_hwpt_id;
> +
> +	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to allocate VIOMMU %d", ret);
> +		goto err_out;
> +	}
> +#define STRTAB_STE_0_V			(1UL << 0)
> +#define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_S1_TRANS	5
> +#define STRTAB_STE_0_CFG_BYPASS		4
> +
> +	/* set up virtual ste as bypass ste */
> +	bypass_ste.ste[0] = STRTAB_STE_0_V | (STRTAB_STE_0_CFG_BYPASS << 1);
> +	bypass_ste.ste[1] = 0x0UL;
> +
> +	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
> +	alloc_hwpt.flags = 0;
> +	alloc_hwpt.dev_id = bind.out_devid;
> +	alloc_hwpt.pt_id = alloc_viommu.out_viommu_id;
> +	alloc_hwpt.data_type = IOMMU_HWPT_DATA_ARM_SMMUV3;
> +	alloc_hwpt.data_len = sizeof(bypass_ste);
> +	alloc_hwpt.data_uptr = (unsigned long)&bypass_ste;
> +
> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
> +		ret = -errno;
> +		pr_err("Failed to allocate S1 bypass HWPT %d", ret);
> +		goto err_out;
> +	}
> +
> +	alloc_vdev.size = sizeof(alloc_vdev),
> +	alloc_vdev.viommu_id = alloc_viommu.out_viommu_id;
> +	alloc_vdev.dev_id = bind.out_devid;
> +
> +	dev_num = vdev->dev_hdr.dev_num;
> +	/* kvmtool only do 0 domain, 0 bus and 0 function devices. */
> +	guest_bdf = (0ULL << 32) | (0 << 16) | dev_num << 11 | (0 << 8);
> +	alloc_vdev.virt_id = guest_bdf;
> +	if (ioctl(iommu_fd, IOMMU_VDEVICE_ALLOC, &alloc_vdev)) {
> +		ret = -errno;
> +		pr_err("Failed to allocate vdevice %d", ret);
> +		goto err_out;
> +	}
> +
> +	/* Now attach to the nested domain */
> +	attach_data.argsz = sizeof(attach_data);
> +	attach_data.flags = 0;
> +	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
> +	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to attach Nested config to IOAS %d ", ret);
> +		goto err_out;
> +	}
> +
> +	return 0;
> +err_out:
> +	return ret;
> +}
> +
>  static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
>  {
>  	int ret;
> @@ -160,7 +270,10 @@ static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
>  		goto err_close_device;
>  	}
>  
> -	ret = iommufd_alloc_s2bypass_hwpt(vdev);
> +	if (kvm->cfg.iommufd_vdevice)
> +		ret = iommufd_alloc_s1bypass_hwpt(vdev);
> +	else
> +		ret = iommufd_alloc_s2bypass_hwpt(vdev);
>  	if (ret)
>  		goto err_close_device;
>  
> -- 
> 2.43.0
> 

