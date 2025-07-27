Return-Path: <kvm+bounces-53514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D19BB13125
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7450F18976F3
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593DE223DE9;
	Sun, 27 Jul 2025 18:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FT3lk9e1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F957080D
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753640605; cv=none; b=KbjvEqawUxz4dSV7rqdfpsdTTgyjQ8XFT+esAScXjMytAL6+20XOiTlN3jurKHjjhJGtuw4EFlIo/vO4Vmf2iR25rJEpgRu2KYtQdpPI1ZxIqw/vSbpWDs3j48g6+qbTEUyTV6DbOgSLjfVgOSEqeAhyv7iug+QUI/e7gLkDeLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753640605; c=relaxed/simple;
	bh=KmI1OqbuJ1DhKjAttPADO1qLkoT1Bs2mi5oC/RH+014=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hy537aqWzl6lOEdRtlZDr/1kDAIP3qCXv9IwGbqV+6+ymSG7MOMo4ia+zsGSPWpXarQLKCufVvHk4yPYEBR2gprNODOJVeldmVtqF6TO6oDPEoFK4lvvTFZAacAFX4JfvWa0hpngZMMZmqxN5ylaWhutEmXllCZ8Q9ZP5ucWrWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FT3lk9e1; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-456007cfcd7so76455e9.1
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753640601; x=1754245401; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d6LtokqA+PMgyfs1MyKl2XsWjINPB+ZHYHI78s7hQrc=;
        b=FT3lk9e1NNkwtHriC/hSJU19xH/mmh68z6v/wZZH8cOfDHl78WUIhu7ovPGnAt6zF6
         UufLIlt8Z3m5DiMjZsqqAiyJ99suRkPT9XDXtTQA+LqBzy/MMjLXEZeSYT/CKoLJEF4s
         IgbCmm+zNOxCdG7Swx0evOZ/VqFGPh2cxThHsw5zthGgeDfSmU4JJbB7nDdvzQmoJfnm
         odYz141xQE1B/uQCsY3HGaliAPSTcUUZZX4krmEj8pXP3GJpsoFfGndIazGL2bYdftWl
         6Z5u4ibvajj0ZfVhQsqybLonmcGjr07Y28iGej/GfSZ3JtpjNyn07A7RlAPgrKOK1ATC
         6ewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753640601; x=1754245401;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d6LtokqA+PMgyfs1MyKl2XsWjINPB+ZHYHI78s7hQrc=;
        b=LJk0gVs55Jj178Rnk2w3OnJtfpZSuOmNazD/OEOXlIU1rl6e8yA/niQz9QnxVAJBQp
         JGl9vCi9XO4Mvxix8uFCsHW9KPb971WFMOfuH8kmxNEy85xNFst0x4ZgWdSJmVIEdASs
         0I5myU3Odi0SKdckSFjeUZwSowJG7jmzovqRWy8kfIsK+/EehWFoyAuUeQrdD+0ZsRan
         EfU79Ti8JjPBJPNEDymIgoiOY98ssdqoblelLUFuH1zbfa86BtXZNTkZqfB5SSsadTk9
         WqFJa1kHlI3u2cGYsFhdHH4gWrOd05UHU6b4juE6LFKZA1nUkEK70AjmPY4DPIYl817m
         eaSw==
X-Gm-Message-State: AOJu0YwaSgUp3AaX+zbR4SZzw9N8ucGRgppRBwDFntJSVRWTyOpOttHG
	ynOaoZ6hOb0oyq0S8dJr9ZYO3c1wBIoYPWyFV5RhCorhkwQAWsEdZSNj4fHj80VpbA4K66sZroR
	65CbEtg==
X-Gm-Gg: ASbGncs2nefFFfTrC8Si2utZ6HevykZlsDvhAud4fGhpTo0Evdv8Oo922zcNSu6ZZhb
	OSepGAT5f7e/u4ENDAxNPXMwdQqExkomkO6WtWbvn4/UfHoifmGT7F3To4WsNuJpMg6CstLyWjA
	Jkdnnw9Pxs4bUczQNErqACV+cIJVVCLPYQNOw1jewet3xLfEBGFvbtdHs1Wro5InlI+/3HMPPkx
	5BaKQZFVQFxw/g4Wz5vTzirHsFwgc7P/1ji9rTz4JUDZjm1knvcDRPZku7jAPdegyHcaZmwLg4h
	Gr2UToEEtZhIw/XR9HNqKm+0KUE9RQskTwYaxsNHspwVZRwOhzQUXGESWg1geFzeXrQ1gjOAFY4
	ZdVr+D6+460M8LVCtCH0TfljoDaMimqV6oL0OCGsXZbaipuY9u4/zsqkBmg==
X-Google-Smtp-Source: AGHT+IEFqlBM+1To/hV3zIAUBaB7xA7HoBnbI60k1xP3GJK9lq0q//Ug6TbUXcDEUcpvFnq0imFZpQ==
X-Received: by 2002:a05:600c:434a:b0:453:6962:1a72 with SMTP id 5b1f17b1804b1-4587c99cddemr1456255e9.5.1753640601034;
        Sun, 27 Jul 2025 11:23:21 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054ef47sm125739795e9.8.2025.07.27.11.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:23:20 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:23:18 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 03/10] vfio: Create new file legacy.c
Message-ID: <aIZulgInZXazv8oY@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-3-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250525074917.150332-3-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:09PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Move legacy vfio config methodology to legacy.c. Also add helper
> vfio_map/unmap_mem_range which will be switched to function pointers in
> the later patch.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  Makefile           |   1 +
>  include/kvm/vfio.h |  14 ++
>  vfio/core.c        | 342 ++------------------------------------------
>  vfio/legacy.c      | 347 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 372 insertions(+), 332 deletions(-)
>  create mode 100644 vfio/legacy.c
> 
> diff --git a/Makefile b/Makefile
> index 60e551fd0c2a..8b2720f73386 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -65,6 +65,7 @@ OBJS	+= pci.o
>  OBJS	+= term.o
>  OBJS	+= vfio/core.o
>  OBJS	+= vfio/pci.o
> +OBJS	+= vfio/legacy.o
>  OBJS	+= virtio/blk.o
>  OBJS	+= virtio/scsi.o
>  OBJS	+= virtio/console.o
> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
> index ac7b6226239a..67a528f18d33 100644
> --- a/include/kvm/vfio.h
> +++ b/include/kvm/vfio.h
> @@ -126,4 +126,18 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region);
>  int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *device);
>  void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev);
>  
> +int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
> +int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size);
> +
> +struct kvm_mem_bank;
> +int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data);
> +int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data);
> +int vfio_configure_reserved_regions(struct kvm *kvm, struct vfio_group *group);
> +int legacy_vfio__init(struct kvm *kvm);
> +int legacy_vfio__exit(struct kvm *kvm);
> +
> +extern int kvm_vfio_device;
> +extern struct list_head vfio_groups;
> +extern struct vfio_device *vfio_devices;
> +
>  #endif /* KVM__VFIO_H */
> diff --git a/vfio/core.c b/vfio/core.c
> index 424dc4ed3aef..2af30df3b2b9 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -4,14 +4,11 @@
>  
>  #include <linux/list.h>
>  
> -#define VFIO_DEV_DIR		"/dev/vfio"
> -#define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
>  #define IOMMU_GROUP_DIR		"/sys/kernel/iommu_groups"
>  
> -static int vfio_container;
> -static int kvm_vfio_device;
> -static LIST_HEAD(vfio_groups);
> -static struct vfio_device *vfio_devices;
> +int kvm_vfio_device;

kvm_vfio_device shouldn’t be VFIO/IOMMUFD specific, so that leads to
duplication in both files, I suggest move it’s management to the vfio/core.c
(and don’t extern the fd) And either export a function to add devices or maybe,
better doing it once from vfio__init()

> +LIST_HEAD(vfio_groups);
“vfio_groups” seems not to be used by the core code, maybe it’s better to have a
static version in each file?
Also, as that is not really used for IOMMUFD, it seems to move group logic into
legacy file. Instead of making iommufd populating groups so the core code handle
the group exit.

> +struct vfio_device *vfio_devices;
>  

Similarly for “vfio_devices”, it’s only allocated/freed in core code, but never used.
But no strong opinion about that.

Thanks,
Mostafa

>  static int vfio_device_pci_parser(const struct option *opt, char *arg,
>  				  struct vfio_device_params *dev)
> @@ -282,124 +279,17 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
>  	}
>  }
>  
> -static int legacy_vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
> +int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
>  {
> -	int ret;
> -	struct vfio_group *group = vdev->group;
> -
> -	vdev->fd = ioctl(group->fd, VFIO_GROUP_GET_DEVICE_FD,
> -			 vdev->params->name);
> -	if (vdev->fd < 0) {
> -		vfio_dev_warn(vdev, "failed to get fd");
> -
> -		/* The device might be a bridge without an fd */
> -		return 0;
> -	}
> -
> -	vdev->info.argsz = sizeof(vdev->info);
> -	if (ioctl(vdev->fd, VFIO_DEVICE_GET_INFO, &vdev->info)) {
> -		ret = -errno;
> -		vfio_dev_err(vdev, "failed to get info");
> -		goto err_close_device;
> -	}
> -
> -	if (vdev->info.flags & VFIO_DEVICE_FLAGS_RESET &&
> -	    ioctl(vdev->fd, VFIO_DEVICE_RESET) < 0)
> -		vfio_dev_warn(vdev, "failed to reset device");
> -
> -	vdev->regions = calloc(vdev->info.num_regions, sizeof(*vdev->regions));
> -	if (!vdev->regions) {
> -		ret = -ENOMEM;
> -		goto err_close_device;
> -	}
> -
> -	/* Now for the bus-specific initialization... */
> -	switch (vdev->params->type) {
> -	case VFIO_DEVICE_PCI:
> -		BUG_ON(!(vdev->info.flags & VFIO_DEVICE_FLAGS_PCI));
> -		ret = vfio_pci_setup_device(kvm, vdev);
> -		break;
> -	default:
> -		BUG_ON(1);
> -		ret = -EINVAL;
> -	}
> -
> -	if (ret)
> -		goto err_free_regions;
> -
> -	vfio_dev_info(vdev, "assigned to device number 0x%x in group %lu",
> -		      vdev->dev_hdr.dev_num, group->id);
> -
> -	return 0;
> -
> -err_free_regions:
> -	free(vdev->regions);
> -err_close_device:
> -	close(vdev->fd);
> -
> -	return ret;
> -}
> -
> -static int legacy_vfio_configure_devices(struct kvm *kvm)
> -{
> -	int i, ret;
> -
> -	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
> -		ret = legacy_vfio_configure_device(kvm, &vfio_devices[i]);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	return 0;
> +	return vfio_map_mem_range(kvm, (u64)bank->host_addr, bank->guest_phys_addr, bank->size);
>  }
>  
> -static int vfio_get_iommu_type(void)
> +int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
>  {
> -	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1v2_IOMMU))
> -		return VFIO_TYPE1v2_IOMMU;
> -
> -	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1_IOMMU))
> -		return VFIO_TYPE1_IOMMU;
> -
> -	return -ENODEV;
> -}
> -
> -static int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
> -{
> -	int ret = 0;
> -	struct vfio_iommu_type1_dma_map dma_map = {
> -		.argsz	= sizeof(dma_map),
> -		.flags	= VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
> -		.vaddr	= (unsigned long)bank->host_addr,
> -		.iova	= (u64)bank->guest_phys_addr,
> -		.size	= bank->size,
> -	};
> -
> -	/* Map the guest memory for DMA (i.e. provide isolation) */
> -	if (ioctl(vfio_container, VFIO_IOMMU_MAP_DMA, &dma_map)) {
> -		ret = -errno;
> -		pr_err("Failed to map 0x%llx -> 0x%llx (%llu) for DMA",
> -		       dma_map.iova, dma_map.vaddr, dma_map.size);
> -	}
> -
> -	return ret;
> -}
> -
> -static int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
> -{
> -	struct vfio_iommu_type1_dma_unmap dma_unmap = {
> -		.argsz = sizeof(dma_unmap),
> -		.size = bank->size,
> -		.iova = bank->guest_phys_addr,
> -	};
> -
> -	ioctl(vfio_container, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
> -
> -	return 0;
> +	return vfio_unmap_mem_range(kvm, bank->guest_phys_addr, bank->size);
>  }
>  
> -static int vfio_configure_reserved_regions(struct kvm *kvm,
> -					   struct vfio_group *group)
> +int vfio_configure_reserved_regions(struct kvm *kvm, struct vfio_group *group)
>  {
>  	FILE *file;
>  	int ret = 0;
> @@ -429,84 +319,6 @@ static int vfio_configure_reserved_regions(struct kvm *kvm,
>  	return ret;
>  }
>  
> -static int legacy_vfio_configure_groups(struct kvm *kvm)
> -{
> -	int ret;
> -	struct vfio_group *group;
> -
> -	list_for_each_entry(group, &vfio_groups, list) {
> -		ret = vfio_configure_reserved_regions(kvm, group);
> -		if (ret)
> -			return ret;
> -
> -		struct kvm_device_attr attr = {
> -			.group = KVM_DEV_VFIO_FILE,
> -			.attr = KVM_DEV_VFIO_FILE_ADD,
> -			.addr = (__u64)&group->fd,
> -		};
> -
> -		if (ioctl(kvm_vfio_device, KVM_SET_DEVICE_ATTR, &attr)) {
> -			pr_err("Failed KVM_SET_DEVICE_ATTR for KVM_DEV_VFIO_FILE");
> -			return -ENODEV;
> -		}
> -
> -	}
> -	return 0;
> -}
> -
> -static struct vfio_group *legacy_vfio_group_create(struct kvm *kvm, unsigned long id)
> -{
> -	int ret;
> -	struct vfio_group *group;
> -	char group_node[PATH_MAX];
> -	struct vfio_group_status group_status = {
> -		.argsz = sizeof(group_status),
> -	};
> -
> -	group = calloc(1, sizeof(*group));
> -	if (!group)
> -		return NULL;
> -
> -	group->id	= id;
> -	group->refs	= 1;
> -
> -	ret = snprintf(group_node, PATH_MAX, VFIO_DEV_DIR "/%lu", id);
> -	if (ret < 0 || ret == PATH_MAX)
> -		return NULL;
> -
> -	group->fd = open(group_node, O_RDWR);
> -	if (group->fd < 0) {
> -		pr_err("Failed to open IOMMU group %s", group_node);
> -		goto err_free_group;
> -	}
> -
> -	if (ioctl(group->fd, VFIO_GROUP_GET_STATUS, &group_status)) {
> -		pr_err("Failed to determine status of IOMMU group %lu", id);
> -		goto err_close_group;
> -	}
> -
> -	if (!(group_status.flags & VFIO_GROUP_FLAGS_VIABLE)) {
> -		pr_err("IOMMU group %lu is not viable", id);
> -		goto err_close_group;
> -	}
> -
> -	if (ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &vfio_container)) {
> -		pr_err("Failed to add IOMMU group %lu to VFIO container", id);
> -		goto err_close_group;
> -	}
> -
> -	list_add(&group->list, &vfio_groups);
> -
> -	return group;
> -
> -err_close_group:
> -	close(group->fd);
> -err_free_group:
> -	free(group);
> -
> -	return NULL;
> -}
> -
>  static void vfio_group_exit(struct kvm *kvm, struct vfio_group *group)
>  {
>  	if (--group->refs != 0)
> @@ -520,78 +332,6 @@ static void vfio_group_exit(struct kvm *kvm, struct vfio_group *group)
>  	free(group);
>  }
>  
> -static struct vfio_group *
> -vfio_group_get_for_dev(struct kvm *kvm, struct vfio_device *vdev)
> -{
> -	int dirfd;
> -	ssize_t ret;
> -	char *group_name;
> -	unsigned long group_id;
> -	char group_path[PATH_MAX];
> -	struct vfio_group *group = NULL;
> -
> -	/* Find IOMMU group for this device */
> -	dirfd = open(vdev->sysfs_path, O_DIRECTORY | O_PATH | O_RDONLY);
> -	if (dirfd < 0) {
> -		vfio_dev_err(vdev, "failed to open '%s'", vdev->sysfs_path);
> -		return NULL;
> -	}
> -
> -	ret = readlinkat(dirfd, "iommu_group", group_path, PATH_MAX);
> -	if (ret < 0) {
> -		vfio_dev_err(vdev, "no iommu_group");
> -		goto out_close;
> -	}
> -	if (ret == PATH_MAX)
> -		goto out_close;
> -
> -	group_path[ret] = '\0';
> -
> -	group_name = basename(group_path);
> -	errno = 0;
> -	group_id = strtoul(group_name, NULL, 10);
> -	if (errno)
> -		goto out_close;
> -
> -	list_for_each_entry(group, &vfio_groups, list) {
> -		if (group->id == group_id) {
> -			group->refs++;
> -			return group;
> -		}
> -	}
> -
> -	group = legacy_vfio_group_create(kvm, group_id);
> -
> -out_close:
> -	close(dirfd);
> -	return group;
> -}
> -
> -static int legacy_vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
> -{
> -	int ret;
> -	char dev_path[PATH_MAX];
> -	struct vfio_group *group;
> -
> -	ret = snprintf(dev_path, PATH_MAX, "/sys/bus/%s/devices/%s",
> -		       vdev->params->bus, vdev->params->name);
> -	if (ret < 0 || ret == PATH_MAX)
> -		return -EINVAL;
> -
> -	vdev->sysfs_path = strndup(dev_path, PATH_MAX);
> -	if (!vdev->sysfs_path)
> -		return -errno;
> -
> -	group = vfio_group_get_for_dev(kvm, vdev);
> -	if (!group) {
> -		free(vdev->sysfs_path);
> -		return -EINVAL;
> -	}
> -
> -	vdev->group = group;
> -
> -	return 0;
> -}
>  
>  static void vfio_device_exit(struct kvm *kvm, struct vfio_device *vdev)
>  {
> @@ -611,57 +351,8 @@ static void vfio_device_exit(struct kvm *kvm, struct vfio_device *vdev)
>  	free(vdev->sysfs_path);
>  }
>  
> -static int legacy_vfio_container_init(struct kvm *kvm)
> -{
> -	int api, i, ret, iommu_type;;
> -
> -	/* Create a container for our IOMMU groups */
> -	vfio_container = open(VFIO_DEV_NODE, O_RDWR);
> -	if (vfio_container == -1) {
> -		ret = errno;
> -		pr_err("Failed to open %s", VFIO_DEV_NODE);
> -		return ret;
> -	}
> -
> -	api = ioctl(vfio_container, VFIO_GET_API_VERSION);
> -	if (api != VFIO_API_VERSION) {
> -		pr_err("Unknown VFIO API version %d", api);
> -		return -ENODEV;
> -	}
> -
> -	iommu_type = vfio_get_iommu_type();
> -	if (iommu_type < 0) {
> -		pr_err("VFIO type-1 IOMMU not supported on this platform");
> -		return iommu_type;
> -	}
> -
> -	/* Create groups for our devices and add them to the container */
> -	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
> -		vfio_devices[i].params = &kvm->cfg.vfio_devices[i];
> -
> -		ret = legacy_vfio_device_init(kvm, &vfio_devices[i]);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	/* Finalise the container */
> -	if (ioctl(vfio_container, VFIO_SET_IOMMU, iommu_type)) {
> -		ret = -errno;
> -		pr_err("Failed to set IOMMU type %d for VFIO container",
> -		       iommu_type);
> -		return ret;
> -	} else {
> -		pr_info("Using IOMMU type %d for VFIO container", iommu_type);
> -	}
> -
> -	return kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, vfio_map_mem_bank,
> -				      NULL);
> -}
> -
>  static int vfio__init(struct kvm *kvm)
>  {
> -	int ret;
> -
>  	if (!kvm->cfg.num_vfio_devices)
>  		return 0;
>  
> @@ -679,19 +370,7 @@ static int vfio__init(struct kvm *kvm)
>  	}
>  	kvm_vfio_device = device.fd;
>  
> -	ret = legacy_vfio_container_init(kvm);
> -	if (ret)
> -		return ret;
> -
> -	ret = legacy_vfio_configure_groups(kvm);
> -	if (ret)
> -		return ret;
> -
> -	ret = legacy_vfio_configure_devices(kvm);
> -	if (ret)
> -		return ret;
> -
> -	return 0;
> +	return legacy_vfio__init(kvm);
>  }
>  dev_base_init(vfio__init);
>  
> @@ -708,10 +387,9 @@ static int vfio__exit(struct kvm *kvm)
>  	free(vfio_devices);
>  
>  	kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, vfio_unmap_mem_bank, NULL);
> -	close(vfio_container);
>  
>  	free(kvm->cfg.vfio_devices);
>  
> -	return 0;
> +	return legacy_vfio__exit(kvm);
>  }
>  dev_base_exit(vfio__exit);
> diff --git a/vfio/legacy.c b/vfio/legacy.c
> new file mode 100644
> index 000000000000..92d6d0bd5c80
> --- /dev/null
> +++ b/vfio/legacy.c
> @@ -0,0 +1,347 @@
> +#include "kvm/kvm.h"
> +#include "kvm/vfio.h"
> +
> +#include <linux/list.h>
> +
> +#define VFIO_DEV_DIR		"/dev/vfio"
> +#define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
> +static int vfio_container;
> +
> +static int legacy_vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
> +{
> +	int ret;
> +	struct vfio_group *group = vdev->group;
> +
> +	vdev->fd = ioctl(group->fd, VFIO_GROUP_GET_DEVICE_FD,
> +			 vdev->params->name);
> +	if (vdev->fd < 0) {
> +		vfio_dev_warn(vdev, "failed to get fd");
> +
> +		/* The device might be a bridge without an fd */
> +		return 0;
> +	}
> +
> +	vdev->info.argsz = sizeof(vdev->info);
> +	if (ioctl(vdev->fd, VFIO_DEVICE_GET_INFO, &vdev->info)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to get info");
> +		goto err_close_device;
> +	}
> +
> +	if (vdev->info.flags & VFIO_DEVICE_FLAGS_RESET &&
> +	    ioctl(vdev->fd, VFIO_DEVICE_RESET) < 0)
> +		vfio_dev_warn(vdev, "failed to reset device");
> +
> +	vdev->regions = calloc(vdev->info.num_regions, sizeof(*vdev->regions));
> +	if (!vdev->regions) {
> +		ret = -ENOMEM;
> +		goto err_close_device;
> +	}
> +
> +	/* Now for the bus-specific initialization... */
> +	switch (vdev->params->type) {
> +	case VFIO_DEVICE_PCI:
> +		BUG_ON(!(vdev->info.flags & VFIO_DEVICE_FLAGS_PCI));
> +		ret = vfio_pci_setup_device(kvm, vdev);
> +		break;
> +	default:
> +		BUG_ON(1);
> +		ret = -EINVAL;
> +	}
> +
> +	if (ret)
> +		goto err_free_regions;
> +
> +	vfio_dev_info(vdev, "assigned to device number 0x%x in group %lu",
> +		      vdev->dev_hdr.dev_num, group->id);
> +
> +	return 0;
> +
> +err_free_regions:
> +	free(vdev->regions);
> +err_close_device:
> +	close(vdev->fd);
> +
> +	return ret;
> +}
> +
> +static int legacy_vfio_configure_devices(struct kvm *kvm)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
> +		ret = legacy_vfio_configure_device(kvm, &vfio_devices[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vfio_get_iommu_type(void)
> +{
> +	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1v2_IOMMU))
> +		return VFIO_TYPE1v2_IOMMU;
> +
> +	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1_IOMMU))
> +		return VFIO_TYPE1_IOMMU;
> +
> +	return -ENODEV;
> +}
> +
> +int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
> +{
> +	int ret = 0;
> +	struct vfio_iommu_type1_dma_map dma_map = {
> +		.argsz	= sizeof(dma_map),
> +		.flags	= VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
> +		.vaddr	= host_addr,
> +		.iova	= iova,
> +		.size	= size,
> +	};
> +
> +	/* Map the guest memory for DMA (i.e. provide isolation) */
> +	if (ioctl(vfio_container, VFIO_IOMMU_MAP_DMA, &dma_map)) {
> +		ret = -errno;
> +		pr_err("Failed to map 0x%llx -> 0x%llx (%llu) for DMA",
> +		       dma_map.iova, dma_map.vaddr, dma_map.size);
> +	}
> +
> +	return ret;
> +}
> +
> +int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size)
> +{
> +	struct vfio_iommu_type1_dma_unmap dma_unmap = {
> +		.argsz = sizeof(dma_unmap),
> +		.size = size,
> +		.iova = iova,
> +	};
> +
> +	ioctl(vfio_container, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
> +
> +	return 0;
> +}
> +
> +static int legacy_vfio_configure_groups(struct kvm *kvm)
> +{
> +	int ret;
> +	struct vfio_group *group;
> +
> +	list_for_each_entry(group, &vfio_groups, list) {
> +		ret = vfio_configure_reserved_regions(kvm, group);
> +		if (ret)
> +			return ret;
> +
> +		struct kvm_device_attr attr = {
> +			.group = KVM_DEV_VFIO_FILE,
> +			.attr = KVM_DEV_VFIO_FILE_ADD,
> +			.addr = (__u64)&group->fd,
> +		};
> +
> +		if (ioctl(kvm_vfio_device, KVM_SET_DEVICE_ATTR, &attr)) {
> +			pr_err("Failed KVM_SET_DEVICE_ATTR for KVM_DEV_VFIO_FILE");
> +			return -ENODEV;
> +		}
> +
> +	}
> +	return 0;
> +}
> +
> +static struct vfio_group *legacy_vfio_group_create(struct kvm *kvm, unsigned long id)
> +{
> +	int ret;
> +	struct vfio_group *group;
> +	char group_node[PATH_MAX];
> +	struct vfio_group_status group_status = {
> +		.argsz = sizeof(group_status),
> +	};
> +
> +	group = calloc(1, sizeof(*group));
> +	if (!group)
> +		return NULL;
> +
> +	group->id	= id;
> +	group->refs	= 1;
> +
> +	ret = snprintf(group_node, PATH_MAX, VFIO_DEV_DIR "/%lu", id);
> +	if (ret < 0 || ret == PATH_MAX)
> +		return NULL;
> +
> +	group->fd = open(group_node, O_RDWR);
> +	if (group->fd < 0) {
> +		pr_err("Failed to open IOMMU group %s", group_node);
> +		goto err_free_group;
> +	}
> +
> +	if (ioctl(group->fd, VFIO_GROUP_GET_STATUS, &group_status)) {
> +		pr_err("Failed to determine status of IOMMU group %lu", id);
> +		goto err_close_group;
> +	}
> +
> +	if (!(group_status.flags & VFIO_GROUP_FLAGS_VIABLE)) {
> +		pr_err("IOMMU group %lu is not viable", id);
> +		goto err_close_group;
> +	}
> +
> +	if (ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &vfio_container)) {
> +		pr_err("Failed to add IOMMU group %lu to VFIO container", id);
> +		goto err_close_group;
> +	}
> +
> +	list_add(&group->list, &vfio_groups);
> +
> +	return group;
> +
> +err_close_group:
> +	close(group->fd);
> +err_free_group:
> +	free(group);
> +
> +	return NULL;
> +}
> +
> +static struct vfio_group *
> +vfio_group_get_for_dev(struct kvm *kvm, struct vfio_device *vdev)
> +{
> +	int dirfd;
> +	ssize_t ret;
> +	char *group_name;
> +	unsigned long group_id;
> +	char group_path[PATH_MAX];
> +	struct vfio_group *group = NULL;
> +
> +	/* Find IOMMU group for this device */
> +	dirfd = open(vdev->sysfs_path, O_DIRECTORY | O_PATH | O_RDONLY);
> +	if (dirfd < 0) {
> +		vfio_dev_err(vdev, "failed to open '%s'", vdev->sysfs_path);
> +		return NULL;
> +	}
> +
> +	ret = readlinkat(dirfd, "iommu_group", group_path, PATH_MAX);
> +	if (ret < 0) {
> +		vfio_dev_err(vdev, "no iommu_group");
> +		goto out_close;
> +	}
> +	if (ret == PATH_MAX)
> +		goto out_close;
> +
> +	group_path[ret] = '\0';
> +
> +	group_name = basename(group_path);
> +	errno = 0;
> +	group_id = strtoul(group_name, NULL, 10);
> +	if (errno)
> +		goto out_close;
> +
> +	list_for_each_entry(group, &vfio_groups, list) {
> +		if (group->id == group_id) {
> +			group->refs++;
> +			return group;
> +		}
> +	}
> +
> +	group = legacy_vfio_group_create(kvm, group_id);
> +
> +out_close:
> +	close(dirfd);
> +	return group;
> +}
> +
> +static int legacy_vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
> +{
> +	int ret;
> +	char dev_path[PATH_MAX];
> +	struct vfio_group *group;
> +
> +	ret = snprintf(dev_path, PATH_MAX, "/sys/bus/%s/devices/%s",
> +		       vdev->params->bus, vdev->params->name);
> +	if (ret < 0 || ret == PATH_MAX)
> +		return -EINVAL;
> +
> +	vdev->sysfs_path = strndup(dev_path, PATH_MAX);
> +	if (!vdev->sysfs_path)
> +		return -errno;
> +
> +	group = vfio_group_get_for_dev(kvm, vdev);
> +	if (!group) {
> +		free(vdev->sysfs_path);
> +		return -EINVAL;
> +	}
> +
> +	vdev->group = group;
> +
> +	return 0;
> +}
> +
> +static int legacy_vfio_container_init(struct kvm *kvm)
> +{
> +	int api, i, ret, iommu_type;;
> +
> +	/* Create a container for our IOMMU groups */
> +	vfio_container = open(VFIO_DEV_NODE, O_RDWR);
> +	if (vfio_container == -1) {
> +		ret = errno;
> +		pr_err("Failed to open %s", VFIO_DEV_NODE);
> +		return ret;
> +	}
> +
> +	api = ioctl(vfio_container, VFIO_GET_API_VERSION);
> +	if (api != VFIO_API_VERSION) {
> +		pr_err("Unknown VFIO API version %d", api);
> +		return -ENODEV;
> +	}
> +
> +	iommu_type = vfio_get_iommu_type();
> +	if (iommu_type < 0) {
> +		pr_err("VFIO type-1 IOMMU not supported on this platform");
> +		return iommu_type;
> +	}
> +
> +	/* Create groups for our devices and add them to the container */
> +	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
> +		vfio_devices[i].params = &kvm->cfg.vfio_devices[i];
> +
> +		ret = legacy_vfio_device_init(kvm, &vfio_devices[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Finalise the container */
> +	if (ioctl(vfio_container, VFIO_SET_IOMMU, iommu_type)) {
> +		ret = -errno;
> +		pr_err("Failed to set IOMMU type %d for VFIO container",
> +		       iommu_type);
> +		return ret;
> +	} else {
> +		pr_info("Using IOMMU type %d for VFIO container", iommu_type);
> +	}
> +
> +	return kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, vfio_map_mem_bank,
> +				      NULL);
> +}
> +
> +int legacy_vfio__init(struct kvm *kvm)
> +{
> +	int ret;
> +
> +	ret = legacy_vfio_container_init(kvm);
> +	if (ret)
> +		return ret;
> +
> +	ret = legacy_vfio_configure_groups(kvm);
> +	if (ret)
> +		return ret;
> +
> +	ret = legacy_vfio_configure_devices(kvm);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +int legacy_vfio__exit(struct kvm *kvm)
> +{
> +	close(vfio_container);
> +	return 0;
> +}
> -- 
> 2.43.0
> 

