Return-Path: <kvm+bounces-53518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FA9B13135
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E50173B2F21
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40DD2248AF;
	Sun, 27 Jul 2025 18:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ufp7gH9W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC822253A0
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753641110; cv=none; b=C+eZi2nJ6NHWLk7ai/d1s50Hz5N8R48YifiMdT+NYN8wUlCo2Q8VcnxTEjwdk7abekkNzJuZn4PVumvya/HZyJGN7cRmYxZCNFtLRhNksjAMcUoTtE9ezDsb1k0n/BvnGyhT/NOy4980SEhBZaew6UJI7iHlIqJI3pu9YdJvAaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753641110; c=relaxed/simple;
	bh=AFqrWqmso4oPHcjCQGAP1frx0WxJFovRgYNCcn/J2Is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+/3k/Sk9POIlxnxMaAxXAvC3Xfwrzjqsph1MbWLA191IqF/T4S21ofL0T3MN2TOvoLH0v5GpqIiGDdmkowRMF1GTcnv/k8+bHfn7GNnY3YZ+wk/L7TA8uBd/2I0EzGZv9vO1j7lkGaoRQf8GuI0Fd5OvMpxCM7EpqsGk32rQyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ufp7gH9W; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4561b43de62so87045e9.0
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753641105; x=1754245905; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1G2zg/zY4+P2VZpG2JhlOmr/3aLP49FDSEEjkXX1tDg=;
        b=ufp7gH9WZiY2yR1QbEwPagsJleoErIecphXpzcRgRoC6QoQ69IGx/mztaBeIqFwMAC
         RGd0yLr3SZC0i9jAEJUduQJsaQ4at8y1wI8GsDiMwrmnMerA9ivIr7jm6Vxyvnc8+6Hi
         UJ7v3h9RV5HxYJhQgXZwSJl6WHqviyOWouseZU3heD+SZtzJyHlAJICQqYrbYY6BtTUo
         QpuCtY0Hf9MEbpjLV+MDdUWynl1aEEmXbSaDwrCej0xkpJV4dJBAHP+qinhVs8lJPfh3
         Q33eeU2ugv+IWOPiT4WMIG+F9KLhVkY7ceqx0z9CR7y5Ncouv8Ku1xodA5Fph4zTxY4F
         UTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753641105; x=1754245905;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1G2zg/zY4+P2VZpG2JhlOmr/3aLP49FDSEEjkXX1tDg=;
        b=ATnu+HkQgOjQCM4AwDXeb71reoN40JG/ALXR7Jq/iIApsFmNzoidZLgKLRZRFRJ9fb
         zi6vVLh/IS8ew7t0Okw5f5xVIIzgo7HcCD6xI5WtzFGAHQ8KL69d+0h7Re8ZE0fVoXoe
         5u55Rfn28/GiDuTmBZzIcsNKlZiYw8njFr7B25nTDvaJ6Go1frtkrIxWf4Y1KB3/d2J0
         UBqmR+uD4Eg0VWOamFiEbekY4PwtmznadnqypqudepgCosJQ1nbtpAzftYZ7LJJo2CNL
         YHHDRKhKkJPuQ5tayTuCp5ilCr2oLVvh7wIJNUih4Q/I6EhIuUc40yzKOE7dQynMwvJT
         JmWQ==
X-Gm-Message-State: AOJu0YzBofpJ9G+2TkACISuiOeU7dIqzo+LPg4/LxDcpjSp9UdcJsBGq
	Cc8xhL3NaPUM/4b46pFQD9hoxPQ14XwxmkR8B0I5yAeLyzJoo2ZUl7gtW+Bz43L8Bg==
X-Gm-Gg: ASbGncuYROFv4idyTAKImR8rpCv0MlCmNIlE0igRN6cgfchjH2z/qP/xy2kiVGHNL3B
	QGnX3qlQGuznWIYzNtK4uSYWF9oOO40TFv+w3cN3FBvoL7cbvIH0TPtXrfDMU2UYmdki0FgNJ+z
	R8r/1SdvyEfJzbpuguXnl692NOcVrTNUDL2wBNbqh/bxncH6NSa3qmMm0porBu+QkwtT8Ph2OpN
	0Ry+5pQVIEE2yiauJzTTil3dDUfxldEziSx20fRS6+S0RT7C9pqpFY6NcPHl8ccwTorlrEGld36
	P1ft9t8/Q/tHvPfUt2zaPIJBI8TZpgsG7LaGNfF+f4zx7Z6NVInFqZUETtAEsgU8kIyvEIrIzM+
	vPcgOJ78VPVFmeRmZ1eZ9JP2XDprPBbpeNgWf9gn1yApDTIZojsxMPGjVJg==
X-Google-Smtp-Source: AGHT+IHToqpeswPiYbQzxyYCqZd7/Vu7C59AZj+t9/EWCLUL4PD+xP3BdErPpFJHJWmjNCeoH5oBGA==
X-Received: by 2002:a05:600c:5289:b0:455:fb2e:95e9 with SMTP id 5b1f17b1804b1-4587c1f7c41mr2875205e9.6.1753641104816;
        Sun, 27 Jul 2025 11:31:44 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4dbdsm130335845e9.25.2025.07.27.11.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:31:44 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:31:40 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 07/10] vfio/iommufd: Add basic iommufd support
Message-ID: <aIZwjA-wOPDPD9Co@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-7-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250525074917.150332-7-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:13PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This use a stage1 translate stage2 bypass iommu config.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  Makefile                 |   1 +
>  builtin-run.c            |   1 +
>  include/kvm/kvm-config.h |   1 +
>  include/kvm/vfio.h       |   2 +
>  vfio/core.c              |   5 +
>  vfio/iommufd.c           | 368 +++++++++++++++++++++++++++++++++++++++
>  6 files changed, 378 insertions(+)
>  create mode 100644 vfio/iommufd.c
> 
> diff --git a/Makefile b/Makefile
> index 8b2720f73386..740b95c7c3c3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -64,6 +64,7 @@ OBJS	+= mmio.o
>  OBJS	+= pci.o
>  OBJS	+= term.o
>  OBJS	+= vfio/core.o
> +OBJS	+= vfio/iommufd.o
>  OBJS	+= vfio/pci.o
>  OBJS	+= vfio/legacy.o
>  OBJS	+= virtio/blk.o
> diff --git a/builtin-run.c b/builtin-run.c
> index 81f255f911b3..39198f9bc0d6 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -262,6 +262,7 @@ static int loglevel_parser(const struct option *opt, const char *arg, int unset)
>  	OPT_CALLBACK('\0', "vfio-pci", NULL, "[domain:]bus:dev.fn",	\
>  		     "Assign a PCI device to the virtual machine",	\
>  		     vfio_device_parser, kvm),				\
> +	OPT_BOOLEAN('\0', "iommufd", &(cfg)->iommufd, "Use iommufd interface"),	\
>  									\
>  	OPT_GROUP("Debug options:"),					\
>  	OPT_CALLBACK_NOOPT('\0', "debug", kvm, NULL,			\
> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> index 592b035785c9..632eaf84b7eb 100644
> --- a/include/kvm/kvm-config.h
> +++ b/include/kvm/kvm-config.h
> @@ -65,6 +65,7 @@ struct kvm_config {
>  	bool ioport_debug;
>  	bool mmio_debug;
>  	int virtio_transport;
> +	bool iommufd;
>  };
>  
>  #endif
> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
> index fed692b0f265..37a2b5ac3dad 100644
> --- a/include/kvm/vfio.h
> +++ b/include/kvm/vfio.h
> @@ -128,6 +128,8 @@ void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev);
>  
>  extern int (*dma_map_mem_range)(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
>  extern int (*dma_unmap_mem_range)(struct kvm *kvm, __u64 iova, __u64 size);
> +int iommufd__init(struct kvm *kvm);
> +int iommufd__exit(struct kvm *kvm);
>  
>  struct kvm_mem_bank;
>  int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data);
> diff --git a/vfio/core.c b/vfio/core.c
> index 32a8e0fe67c0..0b1796c54ffd 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -373,6 +373,8 @@ static int vfio__init(struct kvm *kvm)
>  	}
>  	kvm_vfio_device = device.fd;
>  
> +	if (kvm->cfg.iommufd)
> +		return iommufd__init(kvm);
>  	return legacy_vfio__init(kvm);
>  }
>  dev_base_init(vfio__init);
> @@ -393,6 +395,9 @@ static int vfio__exit(struct kvm *kvm)
>  
>  	free(kvm->cfg.vfio_devices);
>  
> +	if (kvm->cfg.iommufd)
> +		return iommufd__exit(kvm);
> +
>  	return legacy_vfio__exit(kvm);
>  }
>  dev_base_exit(vfio__exit);
> diff --git a/vfio/iommufd.c b/vfio/iommufd.c
> new file mode 100644
> index 000000000000..3728a06cb318
> --- /dev/null
> +++ b/vfio/iommufd.c
> @@ -0,0 +1,368 @@
> +#include <sys/types.h>
> +#include <dirent.h>
> +
> +#include "kvm/kvm.h"
> +#include <linux/iommufd.h>
> +#include <linux/list.h>
> +
> +#define VFIO_DEV_DIR		"/dev/vfio"
This is duplicate with the legacy file, so maybe move it to the header?

> +#define VFIO_DEV_NODE		VFIO_DEV_DIR "/devices/"
> +#define IOMMU_DEV		"/dev/iommu"
> +
> +static int iommu_fd;
> +static int ioas_id;
> +
> +static int __iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
> +{
> +	int ret;
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
> +	vfio_dev_info(vdev, "assigned to device number 0x%x ",
> +		      vdev->dev_hdr.dev_num) ;
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
> +static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
> +{
> +	int ret;
> +	DIR *dir = NULL;
> +	struct dirent *dir_ent;
> +	bool found_dev = false;
> +	char pci_dev_path[PATH_MAX];
> +	char vfio_dev_path[PATH_MAX];
> +	struct iommu_hwpt_alloc alloc_hwpt;
> +	struct vfio_device_bind_iommufd bind;
> +	struct vfio_device_attach_iommufd_pt attach_data;
> +
> +	ret = snprintf(pci_dev_path, PATH_MAX, "%s/vfio-dev/", vdev->sysfs_path);
> +	if (ret < 0 || ret == PATH_MAX)
> +		return -EINVAL;
> +
> +	dir = opendir(pci_dev_path);
> +	if (!dir)
> +		return -EINVAL;
> +
> +	while ((dir_ent = readdir(dir))) {
> +		if (!strncmp(dir_ent->d_name, "vfio", 4)) {
> +			ret = snprintf(vfio_dev_path, PATH_MAX, VFIO_DEV_NODE "%s", dir_ent->d_name);
> +			if (ret < 0 || ret == PATH_MAX) {
> +				ret = -EINVAL;
> +				goto err_close_dir;
> +			}
> +			found_dev = true;
> +			break;
> +		}
> +	}
> +	if (!found_dev) {
> +		ret = -ENODEV;
> +		goto err_close_dir;
> +	}

At this point we already found the device, as in error there is "err_close_dir"
so there is no need for the extra flag.

> +
> +	vdev->fd = open(vfio_dev_path, O_RDWR);
> +	if (vdev->fd == -1) {
> +		ret = errno;
> +		pr_err("Failed to open %s", vfio_dev_path);
> +		goto err_close_dir;
> +	}
> +
> +	struct kvm_device_attr attr = {
> +		.group = KVM_DEV_VFIO_FILE,
> +		.attr = KVM_DEV_VFIO_FILE_ADD,
> +		.addr = (__u64)&vdev->fd,
> +	};
> +
> +	if (ioctl(kvm_vfio_device, KVM_SET_DEVICE_ATTR, &attr)) {
> +		ret = -errno;
> +		pr_err("Failed KVM_SET_DEVICE_ATTR for KVM_DEV_VFIO_FILE");
> +		goto err_close_device;
> +	}
> +
> +	bind.argsz = sizeof(bind);
> +	bind.flags = 0;
> +	bind.iommufd = iommu_fd;
> +
> +	/* now bind the iommufd */
> +	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to get info");
> +		goto err_close_device;
> +	}
> +
> +	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
> +	alloc_hwpt.flags = 0;
> +	alloc_hwpt.dev_id = bind.out_devid;
> +	alloc_hwpt.pt_id = ioas_id;
> +	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
> +	alloc_hwpt.data_len = 0;
> +	alloc_hwpt.data_uptr = 0;
> +
> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
> +		ret = -errno;
> +		pr_err("Failed to allocate HWPT");
> +		goto err_close_device;
> +	}
> +
> +	attach_data.argsz = sizeof(attach_data);
> +	attach_data.flags = 0;
> +	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
> +
> +	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to attach to IOAS ");

Extra space.

> +		goto err_close_device;
> +	}
> +
> +	closedir(dir);
> +	return __iommufd_configure_device(kvm, vdev);
> +
> +err_close_device:
> +	close(vdev->fd);
> +err_close_dir:
> +	closedir(dir);
> +	return ret;
> +}
> +
> +static int iommufd_configure_devices(struct kvm *kvm)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
> +		ret = iommufd_configure_device(kvm, &vfio_devices[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int iommufd_create_ioas(struct kvm *kvm)
> +{
> +	int ret;
> +	struct iommu_ioas_alloc alloc_data;
> +	iommu_fd = open(IOMMU_DEV, O_RDWR);
> +	if (iommu_fd == -1) {
> +		ret = errno;
> +		pr_err("Failed to open %s", IOMMU_DEV);
> +		return ret;
> +	}
> +
> +	alloc_data.size = sizeof(alloc_data);
> +	alloc_data.flags = 0;
> +
> +	if (ioctl(iommu_fd, IOMMU_IOAS_ALLOC, &alloc_data)) {
> +		ret = errno;

For all other ioctls, we return -errorno, except here, is there a reason
for that?

> +		pr_err("Failed to alloc IOAS ");
Also, extra space at the end, also maybe more consistent with the rest of
the code with “vfio_dev_err”.

> +		goto err_close_device;
> +	}
> +	ioas_id = alloc_data.out_ioas_id;
> +	return 0;
> +
> +err_close_device:
> +	close(iommu_fd);
> +	return ret;
> +}
> +
> +static int vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
> +{
> +	int ret, dirfd;
> +	char *group_name;
> +	unsigned long group_id;
> +	char dev_path[PATH_MAX];
> +	struct vfio_group *group = NULL;
> +
> +	ret = snprintf(dev_path, PATH_MAX, "/sys/bus/%s/devices/%s",
> +		       vdev->params->bus, vdev->params->name);
> +	if (ret < 0 || ret == PATH_MAX)
> +		return -EINVAL;
> +
> +	vdev->sysfs_path = strndup(dev_path, PATH_MAX);
> +	if (!vdev->sysfs_path)
> +		return -ENOMEM;
> +
> +	/* Find IOMMU group for this device */
> +	dirfd = open(vdev->sysfs_path, O_DIRECTORY | O_PATH | O_RDONLY);
> +	if (dirfd < 0) {
> +		vfio_dev_err(vdev, "failed to open '%s'", vdev->sysfs_path);
> +		return -errno;
> +	}
> +
> +	ret = readlinkat(dirfd, "iommu_group", dev_path, PATH_MAX);
> +	if (ret < 0) {
> +		vfio_dev_err(vdev, "no iommu_group");
> +		goto out_close;
> +	}
> +	if (ret == PATH_MAX) {
> +		ret =  -ENOMEM;
> +		goto out_close;
> +	}
> +
> +	dev_path[ret] = '\0';
> +	group_name = basename(dev_path);
> +	errno = 0;
> +	group_id = strtoul(group_name, NULL, 10);
> +	if (errno) {
> +		ret = -errno;
> +		goto out_close;
> +	}
> +
> +	list_for_each_entry(group, &vfio_groups, list) {
> +		if (group->id == group_id) {
> +			group->refs++;
> +			break;
> +		}
> +	}
> +	if (group->id != group_id) {
> +		group = calloc(1, sizeof(*group));
> +		if (!group) {
> +			ret = -ENOMEM;
> +			goto out_close;
> +		}
> +		group->id	= group_id;
> +		group->refs	= 1;
> +		/* no group fd for iommufd */
> +		group->fd	= -1;
> +		list_add(&group->list, &vfio_groups);
> +	}
> +	vdev->group = group;
> +	ret = 0;
> +

There is some duplication with “vfio_group_get_for_dev”, I wonder if we could
re-use some of this code in a helper.

> +out_close:
> +	close(dirfd);
> +	return ret;
> +}
> +
> +static int iommufd_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
> +{
> +	int ret = 0;
> +	struct iommu_ioas_map dma_map;
> +
> +	dma_map.size = sizeof(dma_map);
> +	dma_map.flags = IOMMU_IOAS_MAP_READABLE | IOMMU_IOAS_MAP_WRITEABLE |
> +			IOMMU_IOAS_MAP_FIXED_IOVA;
> +	dma_map.ioas_id = ioas_id;
> +	dma_map.__reserved = 0;
> +	dma_map.user_va = host_addr;
> +	dma_map.iova = iova;
> +	dma_map.length = size;
> +
> +	/* Map the guest memory for DMA (i.e. provide isolation) */
> +	if (ioctl(iommu_fd, IOMMU_IOAS_MAP, &dma_map)) {
> +		ret = -errno;
> +		pr_err("Failed to map 0x%llx -> 0x%llx (%u) for DMA",
> +		       dma_map.iova, dma_map.user_va, dma_map.size);
> +	}
> +
> +	return ret;
> +}
> +
> +static int iommufd_unmap_mem_range(struct kvm *kvm,  __u64 iova, __u64 size)
> +{
> +	int ret = 0;
> +	struct iommu_ioas_unmap dma_unmap;
> +
> +	dma_unmap.size = sizeof(dma_unmap);
> +	dma_unmap.ioas_id = ioas_id;
> +	dma_unmap.iova = iova;
> +	dma_unmap.length = size;
> +
> +	if (ioctl(iommu_fd, IOMMU_IOAS_UNMAP, &dma_unmap)) {
> +		ret = -errno;
> +		if (ret != -ENOENT)
> +			pr_err("Failed to unmap 0x%llx - size (%u) for DMA %d",
> +			       dma_unmap.iova, dma_unmap.size, ret);
> +	}
> +
> +	return ret;
> +}
> +
> +static int iommufd_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
> +{
> +	return iommufd_map_mem_range(kvm, (u64)bank->host_addr, bank->guest_phys_addr, bank->size);
> +}
> +
> +static int iommufd_configure_reserved_mem(struct kvm *kvm)
> +{
> +	int ret;
> +	struct vfio_group *group;
> +
> +	list_for_each_entry(group, &vfio_groups, list) {
> +		ret = vfio_configure_reserved_regions(kvm, group);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +int iommufd__init(struct kvm *kvm)
> +{
> +	int ret, i;
> +
> +	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
> +		vfio_devices[i].params = &kvm->cfg.vfio_devices[i];
> +
> +		ret = vfio_device_init(kvm, &vfio_devices[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = iommufd_create_ioas(kvm);
> +	if (ret)
> +		return ret;
> +
> +	ret = iommufd_configure_devices(kvm);
> +	if (ret)
> +		return ret;
> +

Any failure after this point will just return, although iommufd_create_ioas()
would “close(iommu_fd)” on failure.
Also, don’t we want to close “iommu_fd” at exit similar to the VFIO container?

Thanks,
Mostafa

> +	ret = iommufd_configure_reserved_mem(kvm);
> +	if (ret)
> +		return ret;
> +
> +	dma_map_mem_range = iommufd_map_mem_range;
> +	dma_unmap_mem_range = iommufd_unmap_mem_range;
> +	/* Now map the full memory */
> +	return kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, iommufd_map_mem_bank,
> +				      NULL);
> +}
> +
> +int iommufd__exit(struct kvm *kvm)
> +{
> +	return 0;
> +}
> -- 
> 2.43.0
> 

