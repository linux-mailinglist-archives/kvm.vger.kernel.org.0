Return-Path: <kvm+bounces-47663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 553B2AC32C7
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 09:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12DFA3BA015
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 07:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED23119D8BC;
	Sun, 25 May 2025 07:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXhBL2ph"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B42F2DCBF7
	for <kvm@vger.kernel.org>; Sun, 25 May 2025 07:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159385; cv=none; b=ahaZ9NTGM8zEGDCvJXpGfQq9ucqy3/EvTMgAJAkvExDUMJIRYH1WnYD+rwkwxg66wTuFqlD7wkLUixCv3/RiWN98ZhA/YUgwEvLugDoyaU7iobgJwUo/GtWpQIMmEW/57BBkgc2xrlCng1hh3fmh7Maykt+oEYcxAxQqp80lZhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159385; c=relaxed/simple;
	bh=W14cNzYfThzwT99uSMQqXLGtN64yRQvsL2FB60a6lok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA/rYIkH3pj1//xLv/PWCv3FNiwZhZU4c70YA0YJWDt3OwfF+eCs8oMd8v0ctp875hJAsNKjAVJOSQoA0pNhqbogJ6nCbKoTACpyFTFm5mULaaVGoa9fJWSEytyJRkygUPzhyS6K2JKPsdA4zgU0m2G9JPyywQXEx1egASl8X0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXhBL2ph; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52216C4CEEA;
	Sun, 25 May 2025 07:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748159383;
	bh=W14cNzYfThzwT99uSMQqXLGtN64yRQvsL2FB60a6lok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXhBL2phXMSRenP++QU3i25dvvMHbIvp0WqB06Lru3Jw4VUI6JCJFpXsofTANBxdh
	 E40MuU7ZwqTtpXLYNhshxLQi4ftgjHwwp5BBghl2/7fS7IVVw7ugshvOIfvye/2EHN
	 Le5y4MvZne4Yvf67gvODxXNZ/1utPZv3bN1ICqwdU6ZRab//KJpzhnGiwJU+LB/dQa
	 HEq3oESBHHZFm7kTRdi/8Ha8P6E6nRvZh14KlBgMKOHL8HwDerGPONfneo81rBjklo
	 ov+TJ7AFFVmBto+plwpncZ4bYa2V+r279uqm7dqFRA9oYoFDNMvwnxNyToLiOF9k7A
	 aFYm3Za80FX6Q==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH kvmtool 03/10] vfio: Create new file legacy.c
Date: Sun, 25 May 2025 13:19:09 +0530
Message-ID: <20250525074917.150332-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250525074917.150332-1-aneesh.kumar@kernel.org>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move legacy vfio config methodology to legacy.c. Also add helper
vfio_map/unmap_mem_range which will be switched to function pointers in
the later patch.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Makefile           |   1 +
 include/kvm/vfio.h |  14 ++
 vfio/core.c        | 342 ++------------------------------------------
 vfio/legacy.c      | 347 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 372 insertions(+), 332 deletions(-)
 create mode 100644 vfio/legacy.c

diff --git a/Makefile b/Makefile
index 60e551fd0c2a..8b2720f73386 100644
--- a/Makefile
+++ b/Makefile
@@ -65,6 +65,7 @@ OBJS	+= pci.o
 OBJS	+= term.o
 OBJS	+= vfio/core.o
 OBJS	+= vfio/pci.o
+OBJS	+= vfio/legacy.o
 OBJS	+= virtio/blk.o
 OBJS	+= virtio/scsi.o
 OBJS	+= virtio/console.o
diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index ac7b6226239a..67a528f18d33 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -126,4 +126,18 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region);
 int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *device);
 void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev);
 
+int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
+int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size);
+
+struct kvm_mem_bank;
+int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data);
+int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data);
+int vfio_configure_reserved_regions(struct kvm *kvm, struct vfio_group *group);
+int legacy_vfio__init(struct kvm *kvm);
+int legacy_vfio__exit(struct kvm *kvm);
+
+extern int kvm_vfio_device;
+extern struct list_head vfio_groups;
+extern struct vfio_device *vfio_devices;
+
 #endif /* KVM__VFIO_H */
diff --git a/vfio/core.c b/vfio/core.c
index 424dc4ed3aef..2af30df3b2b9 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -4,14 +4,11 @@
 
 #include <linux/list.h>
 
-#define VFIO_DEV_DIR		"/dev/vfio"
-#define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
 #define IOMMU_GROUP_DIR		"/sys/kernel/iommu_groups"
 
-static int vfio_container;
-static int kvm_vfio_device;
-static LIST_HEAD(vfio_groups);
-static struct vfio_device *vfio_devices;
+int kvm_vfio_device;
+LIST_HEAD(vfio_groups);
+struct vfio_device *vfio_devices;
 
 static int vfio_device_pci_parser(const struct option *opt, char *arg,
 				  struct vfio_device_params *dev)
@@ -282,124 +279,17 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
 	}
 }
 
-static int legacy_vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
+int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
 {
-	int ret;
-	struct vfio_group *group = vdev->group;
-
-	vdev->fd = ioctl(group->fd, VFIO_GROUP_GET_DEVICE_FD,
-			 vdev->params->name);
-	if (vdev->fd < 0) {
-		vfio_dev_warn(vdev, "failed to get fd");
-
-		/* The device might be a bridge without an fd */
-		return 0;
-	}
-
-	vdev->info.argsz = sizeof(vdev->info);
-	if (ioctl(vdev->fd, VFIO_DEVICE_GET_INFO, &vdev->info)) {
-		ret = -errno;
-		vfio_dev_err(vdev, "failed to get info");
-		goto err_close_device;
-	}
-
-	if (vdev->info.flags & VFIO_DEVICE_FLAGS_RESET &&
-	    ioctl(vdev->fd, VFIO_DEVICE_RESET) < 0)
-		vfio_dev_warn(vdev, "failed to reset device");
-
-	vdev->regions = calloc(vdev->info.num_regions, sizeof(*vdev->regions));
-	if (!vdev->regions) {
-		ret = -ENOMEM;
-		goto err_close_device;
-	}
-
-	/* Now for the bus-specific initialization... */
-	switch (vdev->params->type) {
-	case VFIO_DEVICE_PCI:
-		BUG_ON(!(vdev->info.flags & VFIO_DEVICE_FLAGS_PCI));
-		ret = vfio_pci_setup_device(kvm, vdev);
-		break;
-	default:
-		BUG_ON(1);
-		ret = -EINVAL;
-	}
-
-	if (ret)
-		goto err_free_regions;
-
-	vfio_dev_info(vdev, "assigned to device number 0x%x in group %lu",
-		      vdev->dev_hdr.dev_num, group->id);
-
-	return 0;
-
-err_free_regions:
-	free(vdev->regions);
-err_close_device:
-	close(vdev->fd);
-
-	return ret;
-}
-
-static int legacy_vfio_configure_devices(struct kvm *kvm)
-{
-	int i, ret;
-
-	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
-		ret = legacy_vfio_configure_device(kvm, &vfio_devices[i]);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
+	return vfio_map_mem_range(kvm, (u64)bank->host_addr, bank->guest_phys_addr, bank->size);
 }
 
-static int vfio_get_iommu_type(void)
+int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
 {
-	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1v2_IOMMU))
-		return VFIO_TYPE1v2_IOMMU;
-
-	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1_IOMMU))
-		return VFIO_TYPE1_IOMMU;
-
-	return -ENODEV;
-}
-
-static int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
-{
-	int ret = 0;
-	struct vfio_iommu_type1_dma_map dma_map = {
-		.argsz	= sizeof(dma_map),
-		.flags	= VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
-		.vaddr	= (unsigned long)bank->host_addr,
-		.iova	= (u64)bank->guest_phys_addr,
-		.size	= bank->size,
-	};
-
-	/* Map the guest memory for DMA (i.e. provide isolation) */
-	if (ioctl(vfio_container, VFIO_IOMMU_MAP_DMA, &dma_map)) {
-		ret = -errno;
-		pr_err("Failed to map 0x%llx -> 0x%llx (%llu) for DMA",
-		       dma_map.iova, dma_map.vaddr, dma_map.size);
-	}
-
-	return ret;
-}
-
-static int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
-{
-	struct vfio_iommu_type1_dma_unmap dma_unmap = {
-		.argsz = sizeof(dma_unmap),
-		.size = bank->size,
-		.iova = bank->guest_phys_addr,
-	};
-
-	ioctl(vfio_container, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
-
-	return 0;
+	return vfio_unmap_mem_range(kvm, bank->guest_phys_addr, bank->size);
 }
 
-static int vfio_configure_reserved_regions(struct kvm *kvm,
-					   struct vfio_group *group)
+int vfio_configure_reserved_regions(struct kvm *kvm, struct vfio_group *group)
 {
 	FILE *file;
 	int ret = 0;
@@ -429,84 +319,6 @@ static int vfio_configure_reserved_regions(struct kvm *kvm,
 	return ret;
 }
 
-static int legacy_vfio_configure_groups(struct kvm *kvm)
-{
-	int ret;
-	struct vfio_group *group;
-
-	list_for_each_entry(group, &vfio_groups, list) {
-		ret = vfio_configure_reserved_regions(kvm, group);
-		if (ret)
-			return ret;
-
-		struct kvm_device_attr attr = {
-			.group = KVM_DEV_VFIO_FILE,
-			.attr = KVM_DEV_VFIO_FILE_ADD,
-			.addr = (__u64)&group->fd,
-		};
-
-		if (ioctl(kvm_vfio_device, KVM_SET_DEVICE_ATTR, &attr)) {
-			pr_err("Failed KVM_SET_DEVICE_ATTR for KVM_DEV_VFIO_FILE");
-			return -ENODEV;
-		}
-
-	}
-	return 0;
-}
-
-static struct vfio_group *legacy_vfio_group_create(struct kvm *kvm, unsigned long id)
-{
-	int ret;
-	struct vfio_group *group;
-	char group_node[PATH_MAX];
-	struct vfio_group_status group_status = {
-		.argsz = sizeof(group_status),
-	};
-
-	group = calloc(1, sizeof(*group));
-	if (!group)
-		return NULL;
-
-	group->id	= id;
-	group->refs	= 1;
-
-	ret = snprintf(group_node, PATH_MAX, VFIO_DEV_DIR "/%lu", id);
-	if (ret < 0 || ret == PATH_MAX)
-		return NULL;
-
-	group->fd = open(group_node, O_RDWR);
-	if (group->fd < 0) {
-		pr_err("Failed to open IOMMU group %s", group_node);
-		goto err_free_group;
-	}
-
-	if (ioctl(group->fd, VFIO_GROUP_GET_STATUS, &group_status)) {
-		pr_err("Failed to determine status of IOMMU group %lu", id);
-		goto err_close_group;
-	}
-
-	if (!(group_status.flags & VFIO_GROUP_FLAGS_VIABLE)) {
-		pr_err("IOMMU group %lu is not viable", id);
-		goto err_close_group;
-	}
-
-	if (ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &vfio_container)) {
-		pr_err("Failed to add IOMMU group %lu to VFIO container", id);
-		goto err_close_group;
-	}
-
-	list_add(&group->list, &vfio_groups);
-
-	return group;
-
-err_close_group:
-	close(group->fd);
-err_free_group:
-	free(group);
-
-	return NULL;
-}
-
 static void vfio_group_exit(struct kvm *kvm, struct vfio_group *group)
 {
 	if (--group->refs != 0)
@@ -520,78 +332,6 @@ static void vfio_group_exit(struct kvm *kvm, struct vfio_group *group)
 	free(group);
 }
 
-static struct vfio_group *
-vfio_group_get_for_dev(struct kvm *kvm, struct vfio_device *vdev)
-{
-	int dirfd;
-	ssize_t ret;
-	char *group_name;
-	unsigned long group_id;
-	char group_path[PATH_MAX];
-	struct vfio_group *group = NULL;
-
-	/* Find IOMMU group for this device */
-	dirfd = open(vdev->sysfs_path, O_DIRECTORY | O_PATH | O_RDONLY);
-	if (dirfd < 0) {
-		vfio_dev_err(vdev, "failed to open '%s'", vdev->sysfs_path);
-		return NULL;
-	}
-
-	ret = readlinkat(dirfd, "iommu_group", group_path, PATH_MAX);
-	if (ret < 0) {
-		vfio_dev_err(vdev, "no iommu_group");
-		goto out_close;
-	}
-	if (ret == PATH_MAX)
-		goto out_close;
-
-	group_path[ret] = '\0';
-
-	group_name = basename(group_path);
-	errno = 0;
-	group_id = strtoul(group_name, NULL, 10);
-	if (errno)
-		goto out_close;
-
-	list_for_each_entry(group, &vfio_groups, list) {
-		if (group->id == group_id) {
-			group->refs++;
-			return group;
-		}
-	}
-
-	group = legacy_vfio_group_create(kvm, group_id);
-
-out_close:
-	close(dirfd);
-	return group;
-}
-
-static int legacy_vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
-{
-	int ret;
-	char dev_path[PATH_MAX];
-	struct vfio_group *group;
-
-	ret = snprintf(dev_path, PATH_MAX, "/sys/bus/%s/devices/%s",
-		       vdev->params->bus, vdev->params->name);
-	if (ret < 0 || ret == PATH_MAX)
-		return -EINVAL;
-
-	vdev->sysfs_path = strndup(dev_path, PATH_MAX);
-	if (!vdev->sysfs_path)
-		return -errno;
-
-	group = vfio_group_get_for_dev(kvm, vdev);
-	if (!group) {
-		free(vdev->sysfs_path);
-		return -EINVAL;
-	}
-
-	vdev->group = group;
-
-	return 0;
-}
 
 static void vfio_device_exit(struct kvm *kvm, struct vfio_device *vdev)
 {
@@ -611,57 +351,8 @@ static void vfio_device_exit(struct kvm *kvm, struct vfio_device *vdev)
 	free(vdev->sysfs_path);
 }
 
-static int legacy_vfio_container_init(struct kvm *kvm)
-{
-	int api, i, ret, iommu_type;;
-
-	/* Create a container for our IOMMU groups */
-	vfio_container = open(VFIO_DEV_NODE, O_RDWR);
-	if (vfio_container == -1) {
-		ret = errno;
-		pr_err("Failed to open %s", VFIO_DEV_NODE);
-		return ret;
-	}
-
-	api = ioctl(vfio_container, VFIO_GET_API_VERSION);
-	if (api != VFIO_API_VERSION) {
-		pr_err("Unknown VFIO API version %d", api);
-		return -ENODEV;
-	}
-
-	iommu_type = vfio_get_iommu_type();
-	if (iommu_type < 0) {
-		pr_err("VFIO type-1 IOMMU not supported on this platform");
-		return iommu_type;
-	}
-
-	/* Create groups for our devices and add them to the container */
-	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
-		vfio_devices[i].params = &kvm->cfg.vfio_devices[i];
-
-		ret = legacy_vfio_device_init(kvm, &vfio_devices[i]);
-		if (ret)
-			return ret;
-	}
-
-	/* Finalise the container */
-	if (ioctl(vfio_container, VFIO_SET_IOMMU, iommu_type)) {
-		ret = -errno;
-		pr_err("Failed to set IOMMU type %d for VFIO container",
-		       iommu_type);
-		return ret;
-	} else {
-		pr_info("Using IOMMU type %d for VFIO container", iommu_type);
-	}
-
-	return kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, vfio_map_mem_bank,
-				      NULL);
-}
-
 static int vfio__init(struct kvm *kvm)
 {
-	int ret;
-
 	if (!kvm->cfg.num_vfio_devices)
 		return 0;
 
@@ -679,19 +370,7 @@ static int vfio__init(struct kvm *kvm)
 	}
 	kvm_vfio_device = device.fd;
 
-	ret = legacy_vfio_container_init(kvm);
-	if (ret)
-		return ret;
-
-	ret = legacy_vfio_configure_groups(kvm);
-	if (ret)
-		return ret;
-
-	ret = legacy_vfio_configure_devices(kvm);
-	if (ret)
-		return ret;
-
-	return 0;
+	return legacy_vfio__init(kvm);
 }
 dev_base_init(vfio__init);
 
@@ -708,10 +387,9 @@ static int vfio__exit(struct kvm *kvm)
 	free(vfio_devices);
 
 	kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, vfio_unmap_mem_bank, NULL);
-	close(vfio_container);
 
 	free(kvm->cfg.vfio_devices);
 
-	return 0;
+	return legacy_vfio__exit(kvm);
 }
 dev_base_exit(vfio__exit);
diff --git a/vfio/legacy.c b/vfio/legacy.c
new file mode 100644
index 000000000000..92d6d0bd5c80
--- /dev/null
+++ b/vfio/legacy.c
@@ -0,0 +1,347 @@
+#include "kvm/kvm.h"
+#include "kvm/vfio.h"
+
+#include <linux/list.h>
+
+#define VFIO_DEV_DIR		"/dev/vfio"
+#define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
+static int vfio_container;
+
+static int legacy_vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+	struct vfio_group *group = vdev->group;
+
+	vdev->fd = ioctl(group->fd, VFIO_GROUP_GET_DEVICE_FD,
+			 vdev->params->name);
+	if (vdev->fd < 0) {
+		vfio_dev_warn(vdev, "failed to get fd");
+
+		/* The device might be a bridge without an fd */
+		return 0;
+	}
+
+	vdev->info.argsz = sizeof(vdev->info);
+	if (ioctl(vdev->fd, VFIO_DEVICE_GET_INFO, &vdev->info)) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to get info");
+		goto err_close_device;
+	}
+
+	if (vdev->info.flags & VFIO_DEVICE_FLAGS_RESET &&
+	    ioctl(vdev->fd, VFIO_DEVICE_RESET) < 0)
+		vfio_dev_warn(vdev, "failed to reset device");
+
+	vdev->regions = calloc(vdev->info.num_regions, sizeof(*vdev->regions));
+	if (!vdev->regions) {
+		ret = -ENOMEM;
+		goto err_close_device;
+	}
+
+	/* Now for the bus-specific initialization... */
+	switch (vdev->params->type) {
+	case VFIO_DEVICE_PCI:
+		BUG_ON(!(vdev->info.flags & VFIO_DEVICE_FLAGS_PCI));
+		ret = vfio_pci_setup_device(kvm, vdev);
+		break;
+	default:
+		BUG_ON(1);
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		goto err_free_regions;
+
+	vfio_dev_info(vdev, "assigned to device number 0x%x in group %lu",
+		      vdev->dev_hdr.dev_num, group->id);
+
+	return 0;
+
+err_free_regions:
+	free(vdev->regions);
+err_close_device:
+	close(vdev->fd);
+
+	return ret;
+}
+
+static int legacy_vfio_configure_devices(struct kvm *kvm)
+{
+	int i, ret;
+
+	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
+		ret = legacy_vfio_configure_device(kvm, &vfio_devices[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int vfio_get_iommu_type(void)
+{
+	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1v2_IOMMU))
+		return VFIO_TYPE1v2_IOMMU;
+
+	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1_IOMMU))
+		return VFIO_TYPE1_IOMMU;
+
+	return -ENODEV;
+}
+
+int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
+{
+	int ret = 0;
+	struct vfio_iommu_type1_dma_map dma_map = {
+		.argsz	= sizeof(dma_map),
+		.flags	= VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
+		.vaddr	= host_addr,
+		.iova	= iova,
+		.size	= size,
+	};
+
+	/* Map the guest memory for DMA (i.e. provide isolation) */
+	if (ioctl(vfio_container, VFIO_IOMMU_MAP_DMA, &dma_map)) {
+		ret = -errno;
+		pr_err("Failed to map 0x%llx -> 0x%llx (%llu) for DMA",
+		       dma_map.iova, dma_map.vaddr, dma_map.size);
+	}
+
+	return ret;
+}
+
+int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size)
+{
+	struct vfio_iommu_type1_dma_unmap dma_unmap = {
+		.argsz = sizeof(dma_unmap),
+		.size = size,
+		.iova = iova,
+	};
+
+	ioctl(vfio_container, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
+
+	return 0;
+}
+
+static int legacy_vfio_configure_groups(struct kvm *kvm)
+{
+	int ret;
+	struct vfio_group *group;
+
+	list_for_each_entry(group, &vfio_groups, list) {
+		ret = vfio_configure_reserved_regions(kvm, group);
+		if (ret)
+			return ret;
+
+		struct kvm_device_attr attr = {
+			.group = KVM_DEV_VFIO_FILE,
+			.attr = KVM_DEV_VFIO_FILE_ADD,
+			.addr = (__u64)&group->fd,
+		};
+
+		if (ioctl(kvm_vfio_device, KVM_SET_DEVICE_ATTR, &attr)) {
+			pr_err("Failed KVM_SET_DEVICE_ATTR for KVM_DEV_VFIO_FILE");
+			return -ENODEV;
+		}
+
+	}
+	return 0;
+}
+
+static struct vfio_group *legacy_vfio_group_create(struct kvm *kvm, unsigned long id)
+{
+	int ret;
+	struct vfio_group *group;
+	char group_node[PATH_MAX];
+	struct vfio_group_status group_status = {
+		.argsz = sizeof(group_status),
+	};
+
+	group = calloc(1, sizeof(*group));
+	if (!group)
+		return NULL;
+
+	group->id	= id;
+	group->refs	= 1;
+
+	ret = snprintf(group_node, PATH_MAX, VFIO_DEV_DIR "/%lu", id);
+	if (ret < 0 || ret == PATH_MAX)
+		return NULL;
+
+	group->fd = open(group_node, O_RDWR);
+	if (group->fd < 0) {
+		pr_err("Failed to open IOMMU group %s", group_node);
+		goto err_free_group;
+	}
+
+	if (ioctl(group->fd, VFIO_GROUP_GET_STATUS, &group_status)) {
+		pr_err("Failed to determine status of IOMMU group %lu", id);
+		goto err_close_group;
+	}
+
+	if (!(group_status.flags & VFIO_GROUP_FLAGS_VIABLE)) {
+		pr_err("IOMMU group %lu is not viable", id);
+		goto err_close_group;
+	}
+
+	if (ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &vfio_container)) {
+		pr_err("Failed to add IOMMU group %lu to VFIO container", id);
+		goto err_close_group;
+	}
+
+	list_add(&group->list, &vfio_groups);
+
+	return group;
+
+err_close_group:
+	close(group->fd);
+err_free_group:
+	free(group);
+
+	return NULL;
+}
+
+static struct vfio_group *
+vfio_group_get_for_dev(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int dirfd;
+	ssize_t ret;
+	char *group_name;
+	unsigned long group_id;
+	char group_path[PATH_MAX];
+	struct vfio_group *group = NULL;
+
+	/* Find IOMMU group for this device */
+	dirfd = open(vdev->sysfs_path, O_DIRECTORY | O_PATH | O_RDONLY);
+	if (dirfd < 0) {
+		vfio_dev_err(vdev, "failed to open '%s'", vdev->sysfs_path);
+		return NULL;
+	}
+
+	ret = readlinkat(dirfd, "iommu_group", group_path, PATH_MAX);
+	if (ret < 0) {
+		vfio_dev_err(vdev, "no iommu_group");
+		goto out_close;
+	}
+	if (ret == PATH_MAX)
+		goto out_close;
+
+	group_path[ret] = '\0';
+
+	group_name = basename(group_path);
+	errno = 0;
+	group_id = strtoul(group_name, NULL, 10);
+	if (errno)
+		goto out_close;
+
+	list_for_each_entry(group, &vfio_groups, list) {
+		if (group->id == group_id) {
+			group->refs++;
+			return group;
+		}
+	}
+
+	group = legacy_vfio_group_create(kvm, group_id);
+
+out_close:
+	close(dirfd);
+	return group;
+}
+
+static int legacy_vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+	char dev_path[PATH_MAX];
+	struct vfio_group *group;
+
+	ret = snprintf(dev_path, PATH_MAX, "/sys/bus/%s/devices/%s",
+		       vdev->params->bus, vdev->params->name);
+	if (ret < 0 || ret == PATH_MAX)
+		return -EINVAL;
+
+	vdev->sysfs_path = strndup(dev_path, PATH_MAX);
+	if (!vdev->sysfs_path)
+		return -errno;
+
+	group = vfio_group_get_for_dev(kvm, vdev);
+	if (!group) {
+		free(vdev->sysfs_path);
+		return -EINVAL;
+	}
+
+	vdev->group = group;
+
+	return 0;
+}
+
+static int legacy_vfio_container_init(struct kvm *kvm)
+{
+	int api, i, ret, iommu_type;;
+
+	/* Create a container for our IOMMU groups */
+	vfio_container = open(VFIO_DEV_NODE, O_RDWR);
+	if (vfio_container == -1) {
+		ret = errno;
+		pr_err("Failed to open %s", VFIO_DEV_NODE);
+		return ret;
+	}
+
+	api = ioctl(vfio_container, VFIO_GET_API_VERSION);
+	if (api != VFIO_API_VERSION) {
+		pr_err("Unknown VFIO API version %d", api);
+		return -ENODEV;
+	}
+
+	iommu_type = vfio_get_iommu_type();
+	if (iommu_type < 0) {
+		pr_err("VFIO type-1 IOMMU not supported on this platform");
+		return iommu_type;
+	}
+
+	/* Create groups for our devices and add them to the container */
+	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
+		vfio_devices[i].params = &kvm->cfg.vfio_devices[i];
+
+		ret = legacy_vfio_device_init(kvm, &vfio_devices[i]);
+		if (ret)
+			return ret;
+	}
+
+	/* Finalise the container */
+	if (ioctl(vfio_container, VFIO_SET_IOMMU, iommu_type)) {
+		ret = -errno;
+		pr_err("Failed to set IOMMU type %d for VFIO container",
+		       iommu_type);
+		return ret;
+	} else {
+		pr_info("Using IOMMU type %d for VFIO container", iommu_type);
+	}
+
+	return kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, vfio_map_mem_bank,
+				      NULL);
+}
+
+int legacy_vfio__init(struct kvm *kvm)
+{
+	int ret;
+
+	ret = legacy_vfio_container_init(kvm);
+	if (ret)
+		return ret;
+
+	ret = legacy_vfio_configure_groups(kvm);
+	if (ret)
+		return ret;
+
+	ret = legacy_vfio_configure_devices(kvm);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int legacy_vfio__exit(struct kvm *kvm)
+{
+	close(vfio_container);
+	return 0;
+}
-- 
2.43.0


