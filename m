Return-Path: <kvm+bounces-31080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3C89C0151
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86D2A1F22674
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4179A1E3DCC;
	Thu,  7 Nov 2024 09:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6GivDoO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673621E1337
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972430; cv=none; b=OaD9uBqb5BxIdaqijnJ1VrUu8vXdkSlYZfC40uY5KypJgz8C+KQZAhwRxRN/OOJ3D+HUqkGSDTCD3xydoMRatyqY8XCno4ZTHX043YB9wE8z1BCNFy29l4/DUL37crvquNV7taO4AG8ZOySvMVVDfcElTZU/a8P6lrve670sIOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972430; c=relaxed/simple;
	bh=PlhPg0AXueM7Kc/Ewa5xRVc0/YVdTi7Iob1yKtIV/5Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1arqpKyZsSrW5Y9pqMdFSV/hhdWcm6iXKbAft8RwWZwuTaIcpCfogQ+LgaHDabVgXMkmqV9As61a++XIow/OkSIPVvZsBkRw7iSfsdEAQm1+a/Tx3XfoVE0K8/IPhp1M6g+cdMbNrkEnSv03KiqIvZOgPMXHTsgsXNXsWqfO7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6GivDoO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730972426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rDtPe5czZ1kQK4ehAzlJ6MVx6O1Rdl4rUXY/t+F2VLw=;
	b=h6GivDoOz+YpDqaHR0JCoEE5HUpw/eatv/nBEMuwNZUxv/uOHjhLOZ5+j1Ba4V5yNcdYRi
	+UfizzAMUOYBcOiLQ/cL9vi+ePhxg9Qej3SeO9Adg+nmwC9XRJWyk3p/hnyw+FQhdl/W+5
	zFQr4nxKgA22KgPWjPQFgaIarx+8lBs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-31-EyieT2sVNsySQmUuh-qIpQ-1; Thu,
 07 Nov 2024 04:40:22 -0500
X-MC-Unique: EyieT2sVNsySQmUuh-qIpQ-1
X-Mimecast-MFC-AGG-ID: EyieT2sVNsySQmUuh-qIpQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1F9A1978CA7;
	Thu,  7 Nov 2024 09:40:18 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.192.86])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7EE211956054;
	Thu,  7 Nov 2024 09:40:15 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	broonie@kernel.org,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	joey.gouly@arm.com,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	pbonzini@redhat.com
Subject: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
Date: Thu,  7 Nov 2024 10:38:49 +0100
Message-ID: <20241107094000.70705-3-eric.auger@redhat.com>
In-Reply-To: <20241107094000.70705-1-eric.auger@redhat.com>
References: <20241107094000.70705-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
KVM ioctls will fail and cause test failure. This now happens
with an aarch64 vgic test where the kvm_vm_free() fails. Let's
add a new kvm_vm_dead_free() helper that does all the deallocation
besides the KVM_SET_USER_MEMORY_REGION2 ioctl.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 25 ++++++++++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 90424bfe33bd..8be893b2c6a2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -437,6 +437,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
 void kvm_vm_free(struct kvm_vm *vmp);
+void kvm_vm_dead_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
 void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a2b7df5f1d39..befbbe989d73 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -712,7 +712,8 @@ void kvm_vm_release(struct kvm_vm *vmp)
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
-				   struct userspace_mem_region *region)
+				   struct userspace_mem_region *region,
+				   bool dead)
 {
 	int ret;
 
@@ -720,8 +721,10 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	rb_erase(&region->hva_node, &vm->regions.hva_tree);
 	hash_del(&region->slot_node);
 
-	region->region.memory_size = 0;
-	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+	if (!dead) {
+		region->region.memory_size = 0;
+		vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+	}
 
 	sparsebit_free(&region->unused_phy_pages);
 	sparsebit_free(&region->protected_phy_pages);
@@ -742,7 +745,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 /*
  * Destroys and frees the VM pointed to by vmp.
  */
-void kvm_vm_free(struct kvm_vm *vmp)
+static void __kvm_vm_free(struct kvm_vm *vmp, bool dead)
 {
 	int ctr;
 	struct hlist_node *node;
@@ -759,7 +762,7 @@ void kvm_vm_free(struct kvm_vm *vmp)
 
 	/* Free userspace_mem_regions. */
 	hash_for_each_safe(vmp->regions.slot_hash, ctr, node, region, slot_node)
-		__vm_mem_region_delete(vmp, region);
+		__vm_mem_region_delete(vmp, region, dead);
 
 	/* Free sparsebit arrays. */
 	sparsebit_free(&vmp->vpages_valid);
@@ -771,6 +774,16 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	free(vmp);
 }
 
+void kvm_vm_free(struct kvm_vm *vmp)
+{
+	__kvm_vm_free(vmp, false);
+}
+
+void kvm_vm_dead_free(struct kvm_vm *vmp)
+{
+	__kvm_vm_free(vmp, true);
+}
+
 int kvm_memfd_alloc(size_t size, bool hugepages)
 {
 	int memfd_flags = MFD_CLOEXEC;
@@ -1197,7 +1210,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
  */
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
 {
-	__vm_mem_region_delete(vm, memslot2region(vm, slot));
+	__vm_mem_region_delete(vm, memslot2region(vm, slot), false);
 }
 
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
-- 
2.41.0


