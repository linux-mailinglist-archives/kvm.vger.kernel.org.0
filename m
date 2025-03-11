Return-Path: <kvm+bounces-40720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA12A5B7B8
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC0981895BE0
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A65B221D87;
	Tue, 11 Mar 2025 04:03:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1DA1EB184;
	Tue, 11 Mar 2025 04:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741665827; cv=none; b=DQIsIRVuCTnF4WBnzV+4StQq/BgVrMoO/cTYiLIAdVslcslAG5oA5/Q4esDIdE0wVF4fHYIal8m4Q1Dxutl7JdzWiw4CwVZ8NWya0ZWCqc7Hg9+4wqeUWRIom/XGQHo5gzkruytpY1l2GbQBbp25M5RdWrYDZLzVzX44bd+Lp5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741665827; c=relaxed/simple;
	bh=Lx8rVbG+c3mJpvZpfSYYDm25AVJWBrGYoa0uXRnDYNw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BOliGeDpOefVAkN6+6SPsQk0EAmJ0LR8+M1DOTjyKLirrgBhRQ7clTVtAyOdtYMyhTG4vykDO/hQVVeNfKCeFFCVvKkx6Hb8jnhMaAMPK5KlqiZldmO+LSVU88+hkEFExZ7t24/uYXplaa9gwtHftQFDTRgfcNiEtnsX0DwS8uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZBg7h0sg7zqVXC;
	Tue, 11 Mar 2025 12:02:08 +0800 (CST)
Received: from kwepemj500003.china.huawei.com (unknown [7.202.194.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D7351800CD;
	Tue, 11 Mar 2025 12:03:37 +0800 (CST)
Received: from DESKTOP-KKJBAGG.huawei.com (10.174.178.32) by
 kwepemj500003.china.huawei.com (7.202.194.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Mar 2025 12:03:36 +0800
From: Zhenyu Ye <yezhenyu2@huawei.com>
To: <maz@kernel.org>, <yuzenghui@huawei.com>, <will@kernel.org>,
	<oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <joey.gouly@arm.com>
CC: <linux-kernel@vger.kernel.org>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <wangzhou1@hisilicon.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v1 3/5] arm64/kvm: using ioctl to enable/disable the HDBSS feature
Date: Tue, 11 Mar 2025 12:03:19 +0800
Message-ID: <20250311040321.1460-4-yezhenyu2@huawei.com>
X-Mailer: git-send-email 2.22.0.windows.1
In-Reply-To: <20250311040321.1460-1-yezhenyu2@huawei.com>
References: <20250311040321.1460-1-yezhenyu2@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemj500003.china.huawei.com (7.202.194.33)

From: eillon <yezhenyu2@huawei.com>

In ARM64, the buffer size corresponding to the HDBSS feature is
configurable. Therefore, we cannot enable the HDBSS feature during
KVM initialization, but we should enable it when triggering a
live migration, where the buffer size can be configured by the user.

The KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl is added to enable/disable
this feature. Users (such as qemu) can invoke the ioctl to enable
HDBSS at the beginning of the migration and disable the feature by
invoking the ioctl again at the end of the migration with size set to 0.

Signed-off-by: eillon <yezhenyu2@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h | 12 +++++
 arch/arm64/include/asm/kvm_host.h   |  6 +++
 arch/arm64/include/asm/kvm_mmu.h    | 12 +++++
 arch/arm64/include/asm/sysreg.h     | 12 +++++
 arch/arm64/kvm/arm.c                | 70 +++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c     |  1 +
 arch/arm64/kvm/mmu.c                |  3 ++
 arch/arm64/kvm/reset.c              |  7 +++
 include/linux/kvm_host.h            |  1 +
 include/uapi/linux/kvm.h            |  1 +
 tools/include/uapi/linux/kvm.h      |  1 +
 11 files changed, 126 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e0e4478f5fb5..c76d51506562 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -743,6 +743,18 @@ static __always_inline bool system_supports_fpsimd(void)
 	return alternative_has_cap_likely(ARM64_HAS_FPSIMD);
 }
 
+static inline bool system_supports_hdbss(void)
+{
+	u64 mmfr1;
+	u32 val;
+
+	mmfr1 =	read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	val = cpuid_feature_extract_unsigned_field(mmfr1,
+						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
+
+	return val == ID_AA64MMFR1_EL1_HAFDBS_HDBSS;
+}
+
 static inline bool system_uses_hw_pan(void)
 {
 	return alternative_has_cap_unlikely(ARM64_HAS_PAN);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d919557af5e5..bd73ee92b12c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -787,6 +787,12 @@ struct kvm_vcpu_arch {
 
 	/* Per-vcpu CCSIDR override or NULL */
 	u32 *ccsidr;
+
+	/* HDBSS registers info */
+	struct {
+		u64 br_el2;
+		u64 prod_el2;
+	} hdbss;
 };
 
 /*
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b98ac6aa631f..ed5b68c2085e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -330,6 +330,18 @@ static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
+static __always_inline void __load_hdbss(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->kvm->enable_hdbss)
+		return;
+
+	write_sysreg_s(vcpu->arch.hdbss.br_el2, SYS_HDBSSBR_EL2);
+	write_sysreg_s(vcpu->arch.hdbss.prod_el2, SYS_HDBSSPROD_EL2);
+
+	dsb(sy);
+	isb();
+}
+
 static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
 {
 	return container_of(mmu->arch, struct kvm, arch);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b727772c06fb..3040eac74f8c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1105,6 +1105,18 @@
 #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
 					       GCS_CAP_VALID_TOKEN)
 
+/*
+ * Definitions for the HDBSS feature
+ */
+#define HDBSS_MAX_SIZE		HDBSSBR_EL2_SZ_2MB
+
+#define HDBSSBR_EL2(baddr, sz)	(((baddr) & GENMASK(55, 12 + sz)) | \
+				 ((sz) << HDBSSBR_EL2_SZ_SHIFT))
+#define HDBSSBR_BADDR(br)	((br) & GENMASK(55, (12 + HDBSSBR_SZ(br))))
+#define HDBSSBR_SZ(br)		(((br) & HDBSSBR_EL2_SZ_MASK) >> HDBSSBR_EL2_SZ_SHIFT)
+
+#define HDBSSPROD_IDX(prod)	(((prod) & HDBSSPROD_EL2_INDEX_MASK) >> HDBSSPROD_EL2_INDEX_SHIFT)
+
 #define ARM64_FEATURE_FIELD_BITS	4
 
 /* Defined for compatibility only, do not add new users. */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0160b4924351..825cfef3b1c2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -80,6 +80,70 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
+static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
+				    struct kvm_enable_cap *cap)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+	struct page *hdbss_pg;
+	int size = cap->args[0];
+
+	if (!system_supports_hdbss()) {
+		kvm_err("This system does not support HDBSS!\n");
+		return -EINVAL;
+	}
+
+	if (size < 0 || size > HDBSS_MAX_SIZE) {
+		kvm_err("Invalid HDBSS buffer size: %d!\n", size);
+		return -EINVAL;
+	}
+
+	/* Enable the HDBSS feature if size > 0, otherwise disable it. */
+	if (size) {
+		kvm->enable_hdbss = true;
+		kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			hdbss_pg = alloc_pages(GFP_KERNEL, size);
+			if (!hdbss_pg) {
+				kvm_err("Alloc HDBSS buffer failed!\n");
+				return -EINVAL;
+			}
+
+			vcpu->arch.hdbss.br_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), size);
+			vcpu->arch.hdbss.prod_el2 = 0;
+
+			/*
+			 * We should kick vcpus out of guest mode here to
+			 * load new vtcr value to vtcr_el2 register when
+			 * re-enter guest mode.
+			 */
+			kvm_vcpu_kick(vcpu);
+		}
+
+		kvm_info("Enable HDBSS success, HDBSS buffer size: %d\n", size);
+	} else if (kvm->enable_hdbss) {
+		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS);
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			/* Kick vcpus to flush hdbss buffer. */
+			kvm_vcpu_kick(vcpu);
+
+			hdbss_pg = phys_to_page(HDBSSBR_BADDR(vcpu->arch.hdbss.br_el2));
+			if (hdbss_pg)
+				__free_pages(hdbss_pg, HDBSSBR_SZ(vcpu->arch.hdbss.br_el2));
+
+			vcpu->arch.hdbss.br_el2 = 0;
+			vcpu->arch.hdbss.prod_el2 = 0;
+		}
+
+		kvm->enable_hdbss = false;
+		kvm_info("Disable HDBSS success\n");
+	}
+
+	return 0;
+}
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
@@ -125,6 +189,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
+		r = kvm_cap_arm_enable_hdbss(kvm, cap);
+		break;
 	default:
 		break;
 	}
@@ -393,6 +460,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
 		r = BIT(0);
 		break;
+	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
+		r = system_supports_hdbss();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 647737d6e8d0..6b633a219e4d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -256,6 +256,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 	__vcpu_load_switch_sysregs(vcpu);
 	__vcpu_load_activate_traps(vcpu);
 	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
+	__load_hdbss(vcpu);
 }
 
 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..9c11e2292b1e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1703,6 +1703,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
+	if (kvm->enable_hdbss && logging_active)
+		prot |= KVM_PGTABLE_PROT_DBM;
+
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 803e11b0dc8f..4e518f9a3df0 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -153,12 +153,19 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	void *sve_state = vcpu->arch.sve_state;
+	struct page *hdbss_pg;
 
 	kvm_unshare_hyp(vcpu, vcpu + 1);
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
 	kfree(vcpu->arch.ccsidr);
+
+	if (vcpu->arch.hdbss.br_el2) {
+		hdbss_pg = phys_to_page(HDBSSBR_BADDR(vcpu->arch.hdbss.br_el2));
+		if (hdbss_pg)
+			__free_pages(hdbss_pg, HDBSSBR_SZ(vcpu->arch.hdbss.br_el2));
+	}
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f34f4cfaa513..aae37141c4a6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -862,6 +862,7 @@ struct kvm {
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+	bool enable_hdbss;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b9..748891902426 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -929,6 +929,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_HW_DIRTY_STATE_TRACK 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 502ea63b5d2e..27d58b751e77 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -933,6 +933,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_HW_DIRTY_STATE_TRACK 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.39.3


