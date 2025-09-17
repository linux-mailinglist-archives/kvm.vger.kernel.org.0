Return-Path: <kvm+bounces-57934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B50B81EE9
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC4AE189C406
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0804030B539;
	Wed, 17 Sep 2025 21:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QfGI0FR0"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D0F30147D
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144073; cv=none; b=PPy7vouenMej3VHBr4re6ylFSsieM8LB4C8yH24sknZlsJMY2I+y1YVgOnczfZ0IzXhWzXvYgUI3CCZjiyt6dGDaas0XKeyLJrCRUlT+7LhEE+aHGmXD3TuqewwqKzvBRXznYr5S8B8OaqxjR9LI3BLRlxOh5S9rVMLZsvvDEkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144073; c=relaxed/simple;
	bh=0mXiSySomtrpDg/5r48heAKR/PGyVvY8o7fZWx5akeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DX+R8W+CtKB3HVefUP2XYQ/oyvywGfGSr1J6DZP1bNrcAyhbh1jfgHZBJcB+RiT8kunKdIo+GayaPFjw2Aspx1t10rZ+nY7atVebaMnNNe4gN1e42nDgifyYPutoGap7VNmvBze9ueGfngJGR7kDWVAprnvTIESrn3shqtJ2afM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QfGI0FR0; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4bAVQ7xzTmIVtjM3UYB4HE6Zzx4t7mj/lid4gyv+JD0=;
	b=QfGI0FR0Cl7Pke36kXSYjJP4XZb3avjny91cjvn+WPnNX2Bo0R/2fCpmtMYNI/P3MJPA+q
	0jTqJHsUTTGeDq69IqN+TFu8VBGKLJZwDwZOBmhHuSj4sfLZsITnI/ObEdNIo1U72xGupa
	hdY8rgwTG2NEZ8v/JIJ8CsDeFDJB1qs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 04/13] KVM: arm64: selftests: Add unsanitised helpers for VGICv3 creation
Date: Wed, 17 Sep 2025 14:20:34 -0700
Message-ID: <20250917212044.294760-5-oliver.upton@linux.dev>
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

vgic_v3_setup() has a good bit of sanity checking internally to ensure
that vCPUs have actually been created and match the dimensioning of the
vgic itself. Spin off an unsanitised setup and initialization helper so
vgic initialization can be wired in around a 'default' VM's vCPU
creation.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/arm64/vgic.h        |  2 +
 tools/testing/selftests/kvm/lib/arm64/vgic.c  | 50 ++++++++++++-------
 2 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/arm64/vgic.h b/tools/testing/selftests/kvm/include/arm64/vgic.h
index b858fa8195b4..688beccc9436 100644
--- a/tools/testing/selftests/kvm/include/arm64/vgic.h
+++ b/tools/testing/selftests/kvm/include/arm64/vgic.h
@@ -17,6 +17,8 @@
 	index)
 
 bool kvm_supports_vgic_v3(void);
+int __vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs);
+void __vgic_v3_init(int fd);
 int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs);
 
 #define VGIC_MAX_RESERVED	1023
diff --git a/tools/testing/selftests/kvm/lib/arm64/vgic.c b/tools/testing/selftests/kvm/lib/arm64/vgic.c
index 661744c6532e..d0f7bd0984b8 100644
--- a/tools/testing/selftests/kvm/lib/arm64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/arm64/vgic.c
@@ -41,24 +41,11 @@ bool kvm_supports_vgic_v3(void)
  * redistributor regions of the guest. Since it depends on the number of
  * vCPUs for the VM, it must be called after all the vCPUs have been created.
  */
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
+int __vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
 {
 	int gic_fd;
 	uint64_t attr;
-	struct list_head *iter;
-	unsigned int nr_gic_pages, nr_vcpus_created = 0;
-
-	TEST_ASSERT(nr_vcpus, "Number of vCPUs cannot be empty");
-
-	/*
-	 * Make sure that the caller is infact calling this
-	 * function after all the vCPUs are added.
-	 */
-	list_for_each(iter, &vm->vcpus)
-		nr_vcpus_created++;
-	TEST_ASSERT(nr_vcpus == nr_vcpus_created,
-			"Number of vCPUs requested (%u) doesn't match with the ones created for the VM (%u)",
-			nr_vcpus, nr_vcpus_created);
+	unsigned int nr_gic_pages;
 
 	/* Distributor setup */
 	gic_fd = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3);
@@ -81,10 +68,39 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
 						KVM_VGIC_V3_REDIST_SIZE * nr_vcpus);
 	virt_map(vm, GICR_BASE_GPA, GICR_BASE_GPA, nr_gic_pages);
 
-	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+	return gic_fd;
+}
+
+void __vgic_v3_init(int fd)
+{
+	kvm_device_attr_set(fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+}
 
-	return gic_fd;
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
+{
+	unsigned int nr_vcpus_created = 0;
+	struct list_head *iter;
+	int fd;
+
+	TEST_ASSERT(nr_vcpus, "Number of vCPUs cannot be empty");
+
+	/*
+	 * Make sure that the caller is infact calling this
+	 * function after all the vCPUs are added.
+	 */
+	list_for_each(iter, &vm->vcpus)
+		nr_vcpus_created++;
+	TEST_ASSERT(nr_vcpus == nr_vcpus_created,
+		    "Number of vCPUs requested (%u) doesn't match with the ones created for the VM (%u)",
+		    nr_vcpus, nr_vcpus_created);
+
+	fd = __vgic_v3_setup(vm, nr_vcpus, nr_irqs);
+	if (fd < 0)
+		return fd;
+
+	__vgic_v3_init(fd);
+	return fd;
 }
 
 /* should only work for level sensitive interrupts */
-- 
2.47.3


