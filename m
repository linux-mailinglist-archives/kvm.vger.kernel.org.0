Return-Path: <kvm+bounces-27949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE68199078C
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 17:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 596731F24370
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 15:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD32221BAE1;
	Fri,  4 Oct 2024 15:29:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80951C75FB;
	Fri,  4 Oct 2024 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728055750; cv=none; b=Lh8MfSemc03ngyBrksl4d2E7IFOOo8B0IN8OcePIjxcNRdVa6CMduCQJZ217nqF78MLcsC9TxjhkbhIuZKLpubmHJNChs51PnOYfdX8HBcS0Yjifz9biHbGrnBgJZKMj1mOt7GvSODB3wEjRC1PL7gnRBk4Gq4y/CIibQ0qui5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728055750; c=relaxed/simple;
	bh=W32BLUNToSygATd+7JKmX3rbEmYUmLhNbx4MGvPeJVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OZOA5jSIfD7h7RwkwtElL6zP/JXof8agH5dYdw0ygzAnLkr3YJMeDsFYqrXPdD5j19umFQArBqoTmCKddqT80QCvcdllcdpeDMwKq45gjlO4O6uJdLo4Bg+w72xQx+QKYDnrX1mRmqz+ohPrSLQcii7+M7VaGa6l6NlBXmRwkVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6D37339;
	Fri,  4 Oct 2024 08:29:37 -0700 (PDT)
Received: from e122027.cambridge.arm.com (unknown [10.1.25.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E35213F640;
	Fri,  4 Oct 2024 08:29:03 -0700 (PDT)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v5 11/43] arm64: kvm: Allow passing machine type in KVM creation
Date: Fri,  4 Oct 2024 16:27:32 +0100
Message-Id: <20241004152804.72508-12-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241004152804.72508-1-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously machine type was used purely for specifying the physical
address size of the guest. Reserve the higher bits to specify an ARM
specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
used to create a realm guest.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c     | 17 +++++++++++++++++
 arch/arm64/kvm/mmu.c     |  3 ---
 include/uapi/linux/kvm.h | 19 +++++++++++++++----
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bb7843349f5a..d16ba8d8bc44 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -208,6 +208,23 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	mutex_unlock(&kvm->lock);
 #endif
 
+	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
+		return -EINVAL;
+
+	switch (type & KVM_VM_TYPE_ARM_MASK) {
+	case KVM_VM_TYPE_ARM_NORMAL:
+		break;
+	case KVM_VM_TYPE_ARM_REALM:
+		kvm->arch.is_realm = true;
+		if (!kvm_is_realm(kvm)) {
+			/* Realm support unavailable */
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	kvm_init_nested(kvm);
 
 	ret = kvm_share_hyp(kvm, kvm + 1);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e01faf72021d..d4ef6dcf8eb7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -873,9 +873,6 @@ static int kvm_init_ipa_range(struct kvm *kvm,
 	if (kvm_is_realm(kvm))
 		ipa_limit = kvm_realm_ipa_limit();
 
-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b3884757739d..74f256eb07d2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -648,14 +648,25 @@ struct kvm_enable_cap {
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
 /*
- * On arm64, machine type can be used to request the physical
- * address size for the VM. Bits[7-0] are reserved for the guest
- * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
- * value 0 implies the default IPA size, 40bits.
+ * On arm64, machine type can be used to request both the machine type and
+ * the physical address size for the VM.
+ *
+ * Bits[11-8] are reserved for the ARM specific machine type.
+ *
+ * Bits[7-0] are reserved for the guest PA size shift (i.e, log2(PA_Size)).
+ * For backward compatibility, value 0 implies the default IPA size, 40bits.
  */
+#define KVM_VM_TYPE_ARM_SHIFT		8
+#define KVM_VM_TYPE_ARM_MASK		(0xfULL << KVM_VM_TYPE_ARM_SHIFT)
+#define KVM_VM_TYPE_ARM(_type)		\
+	(((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
+#define KVM_VM_TYPE_ARM_NORMAL		KVM_VM_TYPE_ARM(0)
+#define KVM_VM_TYPE_ARM_REALM		KVM_VM_TYPE_ARM(1)
+
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
 /*
  * ioctls for /dev/kvm fds:
  */
-- 
2.34.1


