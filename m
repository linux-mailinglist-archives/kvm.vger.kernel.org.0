Return-Path: <kvm+bounces-66134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A6D2CC71DF
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:36:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E892730B1171
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0BD834F278;
	Wed, 17 Dec 2025 10:13:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6ADF34EF1F;
	Wed, 17 Dec 2025 10:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966420; cv=none; b=s1bPNPA1l7CImMCiBK47TSbckYQtsCPtKh0/JsbCqwjR0ZAJ362il8tIHxI2Fj/s2oPeHkuoaDDBneInPxMNHzVBOazwh8ps2w28ipYNbJgr/HNsRzxaBssTOReznkvixMLLKCUWpm13uxGj28QK5pF6HZ7TUv8FxhACwNg6Wns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966420; c=relaxed/simple;
	bh=Y3Ve09EmIEbTl0WK46VhkKH5ggBZA0QuBsGLPFIb2I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNAWZ4mOwJjbbmAVmceJKm+2SSczYD9dYa5wXD22Bf5PQ1IrgdJ0H27u9x2lwuGZCZoo49Zm3fzaUgRC9CrgDcNAt4+ey6aErX1hqqekjmna3ISgzb6XTtlu0vgwzZjr4cMs5XeZeS3hvMqvOmoWBqPgH3S5D0+bmaYNpdXdI9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EDAA1517;
	Wed, 17 Dec 2025 02:13:31 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFB1D3F73B;
	Wed, 17 Dec 2025 02:13:33 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v12 23/46] arm64: RMI: Add a VMID allocator for realms
Date: Wed, 17 Dec 2025 10:11:00 +0000
Message-ID: <20251217101125.91098-24-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM v1.0 spec requires that the host manage the VMIDs of realm
guests. Add a basic allocator and assign a unique VMID to the guest when
creating the realm descriptor.

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v12.
NOTE: RMM v2.0 will remove the requirement for the host to manage VMIDs
---
 arch/arm64/kvm/rmi.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 18edc7eeb5fa..ede6c250bcfb 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -600,6 +600,42 @@ static int realm_create_rd(struct kvm *kvm)
 	return r;
 }
 
+/* Protects access to rmi_vmid_bitmap */
+static DEFINE_SPINLOCK(rmi_vmid_lock);
+static unsigned long *rmi_vmid_bitmap;
+
+static int rmi_vmid_init(void)
+{
+	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
+
+	rmi_vmid_bitmap = bitmap_zalloc(vmid_count, GFP_KERNEL);
+	if (!rmi_vmid_bitmap) {
+		kvm_err("%s: Couldn't allocate rmi vmid bitmap\n", __func__);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int rmi_vmid_reserve(void)
+{
+	int ret;
+	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
+
+	spin_lock(&rmi_vmid_lock);
+	ret = bitmap_find_free_region(rmi_vmid_bitmap, vmid_count, 0);
+	spin_unlock(&rmi_vmid_lock);
+
+	return ret;
+}
+
+static void rmi_vmid_release(unsigned int vmid)
+{
+	spin_lock(&rmi_vmid_lock);
+	bitmap_release_region(rmi_vmid_bitmap, vmid, 0);
+	spin_unlock(&rmi_vmid_lock);
+}
+
 static int realm_unmap_private_page(struct realm *realm,
 				    unsigned long ipa,
 				    unsigned long *next_addr)
@@ -903,6 +939,7 @@ static int realm_init_ipa_state(struct kvm *kvm,
 
 static int realm_ensure_created(struct kvm *kvm)
 {
+	struct realm *realm = &kvm->arch.realm;
 	int ret;
 
 	switch (kvm_realm_state(kvm)) {
@@ -916,7 +953,13 @@ static int realm_ensure_created(struct kvm *kvm)
 		return -EBUSY;
 	}
 
+	ret = rmi_vmid_reserve();
+	if (ret < 0)
+		return ret;
+	realm->vmid = ret;
 	ret = realm_create_rd(kvm);
+	if (ret)
+		rmi_vmid_release(realm->vmid);
 	return ret;
 }
 
@@ -1307,6 +1350,8 @@ void kvm_destroy_realm(struct kvm *kvm)
 		realm->rd = NULL;
 	}
 
+	rmi_vmid_release(realm->vmid);
+
 	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
 		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
 
@@ -1342,5 +1387,8 @@ void kvm_init_rmi(void)
 	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
 		return;
 
+	if (rmi_vmid_init())
+		return;
+
 	/* Future patch will enable static branch kvm_rmi_is_available */
 }
-- 
2.43.0


