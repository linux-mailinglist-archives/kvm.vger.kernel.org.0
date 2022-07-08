Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B5456C38C
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbiGHVVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 17:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240466AbiGHVVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 17:21:22 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7A83121F
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 14:21:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31c8a5d51adso151847b3.14
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 14:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BncZ+nQY2fXKcGj97BWocHuOMgLnRAIrtoobxQvs+yg=;
        b=CWeilK91Y66KvfDXv80VI1osstHUx7mu0s9JCS9R8rcDcQWS2d6uBrXLe9YHxAl7Cq
         o9TM7VGgNMHiTQYhpsQEJwhCeyD8AefacE6+tKMSRWdTPA/SFuS6WV3nfkecQddJ3UWq
         SsYFRGnUllJcqhTN2lIRFTRHcxOOarrveOZ7476oJF9BPyipsNJNzfVDF6oetllNluez
         Ax00g1m4aTcv7m7elKPKEcLm6y66I0W/gsdePiYiOstKmoatljFIZoDT/OTPwDdmWlT/
         JqsxIsUFCetoSRsIYXdjGDEpKDlrJrZiqAuN9CqPSo5kJw/C/winwNHczgt1dvr9ub3S
         NZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BncZ+nQY2fXKcGj97BWocHuOMgLnRAIrtoobxQvs+yg=;
        b=sm1hgvJEyruyz2gAxB0ykf0QOxAgjd1QHuFob7mU/RqKjSNwP/ZvgoYWZIrBLgSAJn
         0eRqeQmSjbyywZgFx2dJ+oQBMxk3iQQzLd+mx1VxI4VdGj9sSlDmM4fBK05JGHAqvzbx
         xe2UjEWUSVjPQ+tPqALmHFduv5CvI5ClIK+A7Nbyeo2iymcDWApEMvEjTKpG7uMaWdP7
         BtnCH9h00HnUeHk3Ul4wTSk/BlRUd3zRizI18+FewKryCQ8YUF3iyZE+nNwpKD0DCE/q
         P+V9D5J9EkGwXmvWRTyoy8+56z47XD1fGvI2kRa2v5zhoclATdjA0MHkup77pbCJAHju
         fFZg==
X-Gm-Message-State: AJIora+2GPE/75KFrcxPfuXqaAgAYezV+D61QLlGqjVlP1c6b87KQ9HW
        u5g0g9BEYiCeFxnnHGGIzby/3jE=
X-Google-Smtp-Source: AGRyM1vx7nO49BRSoJ6ckQ8LmFvqQhFRH6xNwGFXgnVWrZVBFW74MN7oiNIzcxG/XrQ842Yj8o1bmgs=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:ff27:d65:6bb8:b084])
 (user=pcc job=sendgmr) by 2002:a25:ccca:0:b0:66e:c109:a884 with SMTP id
 l193-20020a25ccca000000b0066ec109a884mr6026929ybf.161.1657315281268; Fri, 08
 Jul 2022 14:21:21 -0700 (PDT)
Date:   Fri,  8 Jul 2022 14:21:06 -0700
In-Reply-To: <20220708212106.325260-1-pcc@google.com>
Message-Id: <20220708212106.325260-4-pcc@google.com>
Mime-Version: 1.0
References: <20220708212106.325260-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2 3/3] KVM: arm64: allow MTE in protected VMs if the tag
 storage is known
From:   Peter Collingbourne <pcc@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because the host may corrupt a protected guest's tag storage unless
protected by stage 2 page tables, we can't expose MTE to protected guests
if the location of the tag storage is not known.

Therefore, only allow protected VM guests to use MTE if the location of
the tag storage is described in the device tree, and only after disowning
any physical memory accessible tag storage regions.

To avoid exposing MTE tags from the host to protected VMs, sanitize
tags before donating pages.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  6 +++++
 arch/arm64/include/asm/kvm_pkvm.h |  4 +++-
 arch/arm64/kernel/image-vars.h    |  3 +++
 arch/arm64/kvm/arm.c              | 37 ++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  8 ++++---
 arch/arm64/kvm/mmu.c              |  4 +++-
 6 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e54e76afccc0..35cba0408eca 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1037,6 +1037,12 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
 #define kvm_arm_vcpu_sve_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_SVE_FINALIZED)
 
+DECLARE_STATIC_KEY_FALSE(pkvm_mte_supported);
+
+#define kvm_supports_mte(kvm)                                                  \
+	(system_supports_mte() &&                                              \
+	 (!kvm_vm_is_protected(kvm) ||                                         \
+	  static_branch_unlikely(&pkvm_mte_supported)))
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
 	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index cd56438a34be..ef5d4870c043 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -73,10 +73,12 @@ void kvm_shadow_destroy(struct kvm *kvm);
  * Allow for protected VMs:
  * - Branch Target Identification
  * - Speculative Store Bypassing
+ * - Memory Tagging Extension
  */
 #define PVM_ID_AA64PFR1_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR1_BT) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) \
+	ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR1_MTE) \
 	)
 
 /*
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 2d4d6836ff47..26a9b31478aa 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -84,6 +84,9 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
 KVM_NVHE_ALIAS(arm64_const_caps_ready);
 KVM_NVHE_ALIAS(cpu_hwcap_keys);
 
+/* Kernel symbol needed for kvm_supports_mte() check. */
+KVM_NVHE_ALIAS(pkvm_mte_supported);
+
 /* Static keys which are set if a vGIC trap should be handled in hyp. */
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
 KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 91ca128e7daa..7c79a1be1e39 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -60,6 +60,7 @@ static bool vgic_present;
 
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
+DEFINE_STATIC_KEY_FALSE(pkvm_mte_supported);
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
@@ -96,9 +97,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() ||
-		    kvm_vm_is_protected(kvm) ||
-		    kvm->created_vcpus) {
+		if (!kvm_supports_mte(kvm) || kvm->created_vcpus) {
 			r = -EINVAL;
 		} else {
 			r = 0;
@@ -334,6 +333,9 @@ static int pkvm_check_extension(struct kvm *kvm, long ext, int kvm_cap)
 	case KVM_CAP_ARM_VM_IPA_SIZE:
 		r = kvm_cap;
 		break;
+	case KVM_CAP_ARM_MTE:
+		r = kvm_cap && static_branch_unlikely(&pkvm_mte_supported);
+		break;
 	case KVM_CAP_GUEST_DEBUG_HW_BPS:
 		r = min(kvm_cap, pkvm_get_max_brps());
 		break;
@@ -1954,9 +1956,36 @@ static void kvm_reserved_memory_init(void)
 		if (!of_get_property(node, "compatible", NULL) &&
 		    of_get_property(node, "no-map", NULL))
 			disown_reserved_memory(node);
+
+		if (of_device_is_compatible(node, "arm,mte-tag-storage"))
+			disown_reserved_memory(node);
 	}
 }
 
+static void kvm_mte_init(void)
+{
+	struct device_node *memory;
+
+	if (!system_supports_mte() || !acpi_disabled ||
+	    !is_protected_kvm_enabled())
+		return;
+
+	/*
+	 * It is only safe to turn on MTE for protected VMs if we can protect
+	 * the guests from host accesses to their tag storage. If every memory
+	 * region has an arm,mte-alloc property we know that all tag storage
+	 * regions exposed to physical memory, if any, are described by a
+	 * reserved-memory compatible with arm,mte-tag-storage. We can use these
+	 * descriptions to unmap these regions from the host's stage 2 page
+	 * tables (see kvm_reserved_memory_init).
+	 */
+	for_each_node_by_type(memory, "memory")
+		if (!of_get_property(memory, "arm,mte-alloc", NULL))
+			return;
+
+	static_branch_enable(&pkvm_mte_supported);
+}
+
 static int init_subsystems(void)
 {
 	int err = 0;
@@ -1999,6 +2028,8 @@ static int init_subsystems(void)
 
 	kvm_reserved_memory_init();
 
+	kvm_mte_init();
+
 out:
 	if (err || !is_protected_kvm_enabled())
 		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 80260e8e97f2..96538c984858 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -88,7 +88,7 @@ static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
 	/* Memory Tagging: Trap and Treat as Untagged if not supported. */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), feature_ids)) {
 		hcr_set |= HCR_TID5;
-		hcr_clear |= HCR_DCT | HCR_ATA;
+		hcr_clear |= HCR_ATA;
 	}
 
 	vcpu->arch.hcr_el2 |= hcr_set;
@@ -179,8 +179,8 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	 * - Feature id registers: to control features exposed to guests
 	 * - Implementation-defined features
 	 */
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS |
-			     HCR_TID3 | HCR_TACR | HCR_TIDCP | HCR_TID1;
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS | HCR_TID3 | HCR_TACR | HCR_TIDCP |
+			     HCR_TID1 | HCR_ATA;
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
 		/* route synchronous external abort exceptions to EL2 */
@@ -473,6 +473,8 @@ static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 	vm->host_kvm = kvm;
 	vm->kvm.created_vcpus = nr_vcpus;
 	vm->kvm.arch.vtcr = host_kvm.arch.vtcr;
+	if (kvm_supports_mte(kvm) && test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags))
+		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &vm->kvm.arch.flags);
 	vm->kvm.arch.pkvm.enabled = READ_ONCE(kvm->arch.pkvm.enabled);
 	vm->kvm.arch.mmu.last_vcpu_ran = last_ran;
 	vm->last_ran_size = last_ran_size;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bca90b7354b9..5e079daf2d8e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1228,8 +1228,10 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto dec_account;
 	}
 
-	write_lock(&kvm->mmu_lock);
 	pfn = page_to_pfn(page);
+	sanitise_mte_tags(kvm, pfn, PAGE_SIZE);
+
+	write_lock(&kvm->mmu_lock);
 	ret = pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT);
 	if (ret) {
 		if (ret == -EAGAIN)
-- 
2.37.0.144.g8ac04bfd2-goog

