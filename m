Return-Path: <kvm+bounces-47665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C53AC32C9
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 09:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75C181897967
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 07:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A2C19D07A;
	Sun, 25 May 2025 07:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfRWddez"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E78F136E37
	for <kvm@vger.kernel.org>; Sun, 25 May 2025 07:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159390; cv=none; b=P6hgmxK5n26TopTwakDXtZmNv88Y0uxeE8EKifor6tLCNl7wVzLKsdqaGMUyfyUc3LStQ7mh/AGFB1baiftgfMBPJMEyf2E/ABx9fCRZ9NIvn3DOrawzx6T2nD+wi3ZvCTdCBXVWejZPZ1AABM8PE4DgbVy3e+FHc00I/GX/T0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159390; c=relaxed/simple;
	bh=rnvmDnPIE8KeorPgwrIXfxZZSAmxndzFkxli8RxsYvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBFC8XijS6/Af+Bajlnmod5QeoOGgJRmAXgRmAE85t9xkiMJRkPfajjRcgtScWwXPYGMa6/KtpPo/Eq/q6JbfFroRg2kRuAGScCrINlPrVIBsT/mk2c4LdQHR2ZPm2/3Mc1LfO9QikAnMQp6iHH8k64Y9spVzcVAMvZzmXBr7Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfRWddez; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A538C4CEEA;
	Sun, 25 May 2025 07:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748159389;
	bh=rnvmDnPIE8KeorPgwrIXfxZZSAmxndzFkxli8RxsYvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfRWddezbyEA/lzd2lENolXy5a5IWAmFhCDEpRSgQeZXmcTvinIwmdO1uRUVvjehI
	 mTZUtA6NHQw9Ny4m+vkp+d8HQ3cNl5QLxeVTRpKwyQBLIX9wKU/+Zs2rby0gj+fKeP
	 mHkcgrsvVi9lpc1r6pI63nwa8F8SjLcT+g8PwlOHJteYhz4gbUJOiCTyr2ZKIhx50J
	 yxezw1gFe5cQBZMqVZgkq/I5/VRKzW8B1GwhfeZJic4K+BWYlb4xEk42FfXDg5KSbY
	 QEYFCrkVHTgC6Y+MePB/PmrwWvAy5XfLSvxdoDIzKkylsT1RJXIKtzeIxsRdwdNi6K
	 ELzlGHI6kvE6g==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH kvmtool 05/10] vfio: Add dma map/unmap handlers
Date: Sun, 25 May 2025 13:19:11 +0530
Message-ID: <20250525074917.150332-5-aneesh.kumar@kernel.org>
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

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/kvm/vfio.h | 4 ++--
 vfio/core.c        | 7 +++++--
 vfio/legacy.c      | 7 +++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 67a528f18d33..fed692b0f265 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -126,8 +126,8 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region);
 int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *device);
 void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev);
 
-int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
-int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size);
+extern int (*dma_map_mem_range)(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
+extern int (*dma_unmap_mem_range)(struct kvm *kvm, __u64 iova, __u64 size);
 
 struct kvm_mem_bank;
 int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data);
diff --git a/vfio/core.c b/vfio/core.c
index 2af30df3b2b9..32a8e0fe67c0 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -10,6 +10,9 @@ int kvm_vfio_device;
 LIST_HEAD(vfio_groups);
 struct vfio_device *vfio_devices;
 
+int (*dma_map_mem_range)(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
+int (*dma_unmap_mem_range)(struct kvm *kvm, __u64 iova, __u64 size);
+
 static int vfio_device_pci_parser(const struct option *opt, char *arg,
 				  struct vfio_device_params *dev)
 {
@@ -281,12 +284,12 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
 
 int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
 {
-	return vfio_map_mem_range(kvm, (u64)bank->host_addr, bank->guest_phys_addr, bank->size);
+	return dma_map_mem_range(kvm, (u64)bank->host_addr, bank->guest_phys_addr, bank->size);
 }
 
 int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
 {
-	return vfio_unmap_mem_range(kvm, bank->guest_phys_addr, bank->size);
+	return dma_unmap_mem_range(kvm, bank->guest_phys_addr, bank->size);
 }
 
 int vfio_configure_reserved_regions(struct kvm *kvm, struct vfio_group *group)
diff --git a/vfio/legacy.c b/vfio/legacy.c
index 92d6d0bd5c80..5b35d6ebff69 100644
--- a/vfio/legacy.c
+++ b/vfio/legacy.c
@@ -89,7 +89,7 @@ static int vfio_get_iommu_type(void)
 	return -ENODEV;
 }
 
-int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
+static int legacy_vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
 {
 	int ret = 0;
 	struct vfio_iommu_type1_dma_map dma_map = {
@@ -110,7 +110,7 @@ int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
 	return ret;
 }
 
-int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size)
+static int legacy_vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size)
 {
 	struct vfio_iommu_type1_dma_unmap dma_unmap = {
 		.argsz = sizeof(dma_unmap),
@@ -325,6 +325,9 @@ int legacy_vfio__init(struct kvm *kvm)
 {
 	int ret;
 
+	dma_map_mem_range = legacy_vfio_map_mem_range;
+	dma_unmap_mem_range = legacy_vfio_unmap_mem_range;
+
 	ret = legacy_vfio_container_init(kvm);
 	if (ret)
 		return ret;
-- 
2.43.0


