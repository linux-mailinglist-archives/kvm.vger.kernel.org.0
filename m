Return-Path: <kvm+bounces-64093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D2303C7833F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 10:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 3A2C42E860
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB54B3446BE;
	Fri, 21 Nov 2025 09:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="f1bHzaih"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78D7340D9A;
	Fri, 21 Nov 2025 09:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763717031; cv=none; b=dYrMB+favU394DEhNT/gzNQmYCu2gGbNwuvkAlFVQVirr5dhOD0s6jF9BA/O9AMW1D/yWhvcTPKexy++c/bXHS1zPUhl6u5js3PCtwKqVAGOM0N6MU0BnrV+09R34g6D592BbuhZCDYGq7F+YwyY13Qia9pnI0PEW7ew4tg/97k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763717031; c=relaxed/simple;
	bh=T2uoRWbj0QhI8qAghyLUriNGpBSSAuUmWZzhlTUoOZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tok/cUghO5NchHNCe77dPhbvlprPK3qWZQwZBFtNeaPuov64v5KlkxGix4d80cznW8a71gBB9PKJsCNYwVdovZrq9MwwDIIF+tXR4WdUyFD4ahJqa6Jeab8z8eq71QDGYMtMxCI332RrtFSJ47covR1mMte/Rizoq4ksN/1+z1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=f1bHzaih; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=n1RyWCUsn72WKSR+hGZHtF4YexqtsbwPSzKJPZVGysQ=;
	b=f1bHzaihPFXqDW0ZWy/NF/xvGgyJk82oz6GT9DcGKbTP1ZCVSk/0YNfMA+Mr9eF07sxe+zCR/
	FHRvhIUH3A/Upb9oXvBv0OpZ0gT58jnGeWWh3fSVj19tC56Kmg+W5imEsfgAeLjU6dFO8xjCPl+
	v48A8oi1cV8JHUj9BClD56Y=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dCV9Q5nqYznTvd;
	Fri, 21 Nov 2025 17:22:18 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 34BCB1A016C;
	Fri, 21 Nov 2025 17:23:45 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 21 Nov
 2025 17:23:44 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zhengtian10@huawei.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
Subject: [PATCH v2 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF events
Date: Fri, 21 Nov 2025 17:23:41 +0800
Message-ID: <20251121092342.3393318-5-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251121092342.3393318-1-zhengtian10@huawei.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)

From: eillon <yezhenyu2@huawei.com>

Implement the HDBSS enable/disable functionality using the
KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl.

Userspace (e.g., QEMU) can enable HDBSS by invoking the ioctl
at the start of live migration, configuring the buffer size.
The feature is disabled by invoking the ioctl again with size
set to 0 once migration completes.

Add support for updating the dirty bitmap based on the HDBSS
buffer. Similar to the x86 PML implementation, KVM flushes the
buffer on all VM-Exits, so running vCPUs only need to be kicked
to force a VM-Exit.

Signed-off-by: eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  10 +++
 arch/arm64/include/asm/kvm_mmu.h  |  17 +++++
 arch/arm64/kvm/arm.c              | 107 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c      |  45 +++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c   |   1 +
 arch/arm64/kvm/mmu.c              |  10 +++
 arch/arm64/kvm/reset.c            |   3 +
 include/linux/kvm_host.h          |   1 +
 8 files changed, 194 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d962932f0e5f..408e4c2b3d1a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -87,6 +87,7 @@ int __init kvm_arm_init_sve(void);
 u32 __attribute_const__ kvm_target_cpu(void);
 void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);

 struct kvm_hyp_memcache {
 	phys_addr_t head;
@@ -793,6 +794,12 @@ struct vcpu_reset_state {
 	bool		reset;
 };

+struct vcpu_hdbss_state {
+	phys_addr_t base_phys;
+	u32 size;
+	u32 next_index;
+};
+
 struct vncr_tlb;

 struct kvm_vcpu_arch {
@@ -897,6 +904,9 @@ struct kvm_vcpu_arch {

 	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
 	struct vncr_tlb	*vncr_tlb;
+
+	/* HDBSS registers info */
+	struct vcpu_hdbss_state hdbss;
 };

 /*
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4069f2ce642..6ace1080aed5 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -331,6 +331,23 @@ static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }

+static __always_inline void __load_hdbss(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 br_el2, prod_el2;
+
+	if (!kvm->enable_hdbss)
+		return;
+
+	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
+	prod_el2 = vcpu->arch.hdbss.next_index;
+
+	write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
+	write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
+
+	isb();
+}
+
 static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
 {
 	return container_of(mmu->arch, struct kvm, arch);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..64f65e3c2a89 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -79,6 +79,92 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }

+void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
+{
+	struct page *hdbss_pg = NULL;
+
+	hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
+	if (hdbss_pg)
+		__free_pages(hdbss_pg, vcpu->arch.hdbss.size);
+
+	vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
+		.base_phys = 0,
+		.size = 0,
+		.next_index = 0,
+	};
+}
+
+static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
+				    struct kvm_enable_cap *cap)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+	struct page *hdbss_pg = NULL;
+	int size = cap->args[0];
+	int ret = 0;
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
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
+			if (!hdbss_pg) {
+				kvm_err("Alloc HDBSS buffer failed!\n");
+				ret = -ENOMEM;
+				goto error_alloc;
+			}
+
+			vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
+				.base_phys = page_to_phys(hdbss_pg),
+				.size = size,
+				.next_index = 0,
+			};
+		}
+
+		kvm->enable_hdbss = true;
+		kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS;
+
+		/*
+		 * We should kick vcpus out of guest mode here to load new
+		 * vtcr value to vtcr_el2 register when re-enter guest mode.
+		 */
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			kvm_vcpu_kick(vcpu);
+	} else if (kvm->enable_hdbss) {
+		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS);
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			/* Kick vcpus to flush hdbss buffer. */
+			kvm_vcpu_kick(vcpu);
+
+			kvm_arm_vcpu_free_hdbss(vcpu);
+		}
+
+		kvm->enable_hdbss = false;
+	}
+
+	return ret;
+
+error_alloc:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!vcpu->arch.hdbss.base_phys && !vcpu->arch.hdbss.size)
+			continue;
+
+		kvm_arm_vcpu_free_hdbss(vcpu);
+	}
+
+	return ret;
+}
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
@@ -132,6 +218,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
+		mutex_lock(&kvm->lock);
+		r = kvm_cap_arm_enable_hdbss(kvm, cap);
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		break;
 	}
@@ -420,6 +511,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = kvm_supports_cacheable_pfnmap();
 		break;

+	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
+		r = system_supports_hdbss();
+		break;
 	default:
 		r = 0;
 	}
@@ -1837,7 +1931,20 @@ long kvm_arch_vcpu_ioctl(struct file *filp,

 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	/*
+	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
+	 * before reporting dirty_bitmap to userspace.  KVM flushes the buffers
+	 * on all VM-Exits, thus we only need to kick running vCPUs to force a
+	 * VM-Exit.
+	 */
+	struct kvm_vcpu *vcpu;
+	unsigned long i;

+	if (!kvm->enable_hdbss)
+		return;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vcpu_kick(vcpu);
 }

 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index cc7d5d1709cb..9ba0ea6305ef 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -412,6 +412,49 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	return arm_exit_handlers[esr_ec];
 }

+static void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
+{
+	int idx, curr_idx;
+	u64 *hdbss_buf;
+	struct kvm *kvm = vcpu->kvm;
+	u64 br_el2;
+
+	if (!kvm->enable_hdbss)
+		return;
+
+	dsb(sy);
+	isb();
+	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
+	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
+
+	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
+	if (curr_idx == 0 || br_el2 == 0)
+		return;
+
+	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
+	if (!hdbss_buf) {
+		kvm_err("Enter flush hdbss buffer with buffer == NULL!");
+		return;
+	}
+
+	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
+	for (idx = 0; idx < curr_idx; idx++) {
+		u64 gpa;
+
+		gpa = hdbss_buf[idx];
+		if (!(gpa & HDBSS_ENTRY_VALID))
+			continue;
+
+		gpa &= HDBSS_ENTRY_IPA;
+		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
+	}
+
+	/* reset HDBSS index */
+	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
+	vcpu->arch.hdbss.next_index = 0;
+	isb();
+}
+
 /*
  * We may be single-stepping an emulated instruction. If the emulation
  * has been completed in the kernel, we can return to userspace with a
@@ -447,6 +490,8 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 {
 	struct kvm_run *run = vcpu->run;

+	kvm_flush_hdbss_buffer(vcpu);
+
 	if (ARM_SERROR_PENDING(exception_index)) {
 		/*
 		 * The SError is handled by handle_exit_early(). If the guest
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9984c492305a..3787c9c5810d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -220,6 +220,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 	__vcpu_load_switch_sysregs(vcpu);
 	__vcpu_load_activate_traps(vcpu);
 	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
+	__load_hdbss(vcpu);
 }

 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..91a2f9dbb406 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1843,6 +1843,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;

+	if (writable && kvm->enable_hdbss && logging_active)
+		prot |= KVM_PGTABLE_PROT_DBM;
+
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;

@@ -1950,6 +1953,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)

 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);

+	/*
+	 * HDBSS buffer already flushed when enter handle_trap_exceptions().
+	 * Nothing to do here.
+	 */
+	if (ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)
+		return 1;
+
 	if (esr_fsc_is_translation_fault(esr)) {
 		/* Beyond sanitised PARange (which is the IPA limit) */
 		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 959532422d3a..65e8f890f863 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -161,6 +161,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 	kfree(vcpu->arch.vncr_tlb);
 	kfree(vcpu->arch.ccsidr);
+
+	if (vcpu->arch.hdbss.base_phys || vcpu->arch.hdbss.size)
+		kvm_arm_vcpu_free_hdbss(vcpu);
 }

 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5bd76cf394fa..aa8138604b1e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -876,6 +876,7 @@ struct kvm {
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+	bool enable_hdbss;
 };

 #define kvm_err(fmt, ...) \
--
2.33.0


