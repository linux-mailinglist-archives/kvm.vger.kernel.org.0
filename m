Return-Path: <kvm+bounces-39979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 979D7A4D372
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A23DD189124E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023711F8BCB;
	Tue,  4 Mar 2025 06:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fooj4UgU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709F01F8721
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068436; cv=none; b=FeXLGRjmdZmX1kCK+4VeEgpV91eDCCvayoY8ypH+xVts36KMQckdIwD8UBhu+cjFiNDTHo8ueJcGMbSRsYnQWKCEREmgQ6Kbufmbw4UzDbyzwmn/mLIPyKIBH78UpwpSGADN5skRs7ZKGT8o1yR6MYHTpT4j/7WFMORicpqASYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068436; c=relaxed/simple;
	bh=m1oV6A6jmzXtuBPtlbOzuMlmehi5cumjFSdhvmIKqZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZS7hMJZF2T+uCyQ0HqHuOIsJlMlQHxltNiK1D1jsStJGaW6/V9PJyw+Z5vmLe9TxbN6znpW4eA3ylYoEl8fskfNZu4tNRIGLmfn2U1wqIntRF7NjeUdcaiLDoCdd6h8D8rTu66AhJj5lodIubsLfUk8pyBCQsvtLXEPK8t0eNbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fooj4UgU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N8zlhzIk2Ew+0AUJnNIrS4P9CDOPNvwYzdU95mzy8LM=;
	b=Fooj4UgUMzBtTjtURWV8fJWkbfiqh/IomH6vHmFueZMPq+wlmUTs69THIF+cFyMKBIb5on
	XjwRvfiEUjhQQoG2p20LJ0ruXqDbOHl25HjPfe9CibsOuNMcxoBbJvtEL55ncoMQjKj6oZ
	qMm2t0GX/dwbYkVjPeHK156DltUhCp0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-MvKnY1xRN_KIftMZ6vCSGQ-1; Tue,
 04 Mar 2025 01:06:55 -0500
X-MC-Unique: MvKnY1xRN_KIftMZ6vCSGQ-1
X-Mimecast-MFC-AGG-ID: MvKnY1xRN_KIftMZ6vCSGQ_1741068414
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA8061944D01;
	Tue,  4 Mar 2025 06:06:53 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC98019560A3;
	Tue,  4 Mar 2025 06:06:52 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	seanjc@google.com,
	yan.y.zhao@intel.com,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 4/6] KVM: x86: Introduce Intel specific quirk KVM_X86_QUIRK_IGNORE_GUEST_PAT
Date: Tue,  4 Mar 2025 01:06:45 -0500
Message-ID: <20250304060647.2903469-5-pbonzini@redhat.com>
In-Reply-To: <20250304060647.2903469-1-pbonzini@redhat.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Yan Zhao <yan.y.zhao@intel.com>

Introduce an Intel specific quirk KVM_X86_QUIRK_IGNORE_GUEST_PAT to have
KVM ignore guest PAT when this quirk is enabled.

On AMD platforms, KVM always honors guest PAT.  On Intel however there are
two issues.  First, KVM *cannot* honor guest PAT if CPU feature self-snoop
is not supported. Second, UC access on certain Intel platforms can be very
slow[1] and honoring guest PAT on those platforms may break some old
guests that accidentally specify video RAM as UC. Those old guests may
never expect the slowness since KVM always forces WB previously. See [2].

So, introduce a quirk that KVM can enable by default on all Intel platforms
to avoid breaking old unmodifiable guests. Newer userspace can disable this
quirk if it wishes KVM to honor guest PAT; disabling the quirk will fail
if self-snoop is not supported, i.e. if KVM cannot obey the wish.

The quirk is a no-op on AMD and also if any assigned devices have
non-coherent DMA.  This is not an issue, as KVM_X86_QUIRK_CD_NW_CLEARED is
another example of a quirk that is sometimes automatically disabled.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Link: https://lore.kernel.org/all/Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com # [1]
Link: https://lore.kernel.org/all/87jzfutmfc.fsf@redhat.com # [2]
Message-ID: <20250224070946.31482-1-yan.y.zhao@intel.com>
[Use supported_quirks/inapplicable_quirks to support both AMD and
 no-self-snoop cases, as well as to remove the shadow_memtype_mask check
 from kvm_mmu_may_ignore_guest_pat(). - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst  | 22 ++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  6 +++--
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 10 ++++----
 arch/x86/kvm/vmx/vmx.c          | 41 +++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c              |  2 +-
 7 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2d75edc9db4f..452439b605af 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8157,6 +8157,28 @@ KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
                                     and 0x489), as KVM does now allow them to
                                     be set by userspace (KVM sets them based on
                                     guest CPUID, for safety purposes).
+
+KVM_X86_QUIRK_IGNORE_GUEST_PAT      By default, on Intel platforms, KVM ignores
+                                    guest PAT and forces the effective memory
+                                    type to WB in EPT.  The quirk is not available
+                                    on Intel platforms which are incapable of
+                                    safely honoring guest PAT (i.e., without CPU
+                                    self-snoop, KVM always ignores guest PAT and
+                                    forces effective memory type to WB).  It is
+                                    also ignored on AMD platforms or, on Intel,
+                                    when a VM has non-coherent DMA devices
+                                    assigned; KVM always honors guest PAT in
+                                    such case. The quirk is needed to avoid
+                                    slowdowns on certain Intel Xeon platforms
+                                    (e.g. ICX, SPR) where self-snoop feature is
+                                    supported but UC is slow enough to cause
+                                    issues with some older guests that use
+                                    UC instead of WC to map the video RAM.
+                                    Userspace can disable the quirk to honor
+                                    guest PAT if it knows that there is no such
+                                    guest software, for example if it does not
+                                    expose a bochs graphics device (which is
+                                    known to have had a buggy driver).
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a4f213d235dd..9b9dde476f3c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2418,10 +2418,12 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
 	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
 	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
-	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS)
+	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS |	\
+	 KVM_X86_QUIRK_IGNORE_GUEST_PAT)
 
 #define KVM_X86_CONDITIONAL_QUIRKS		\
-	 KVM_X86_QUIRK_CD_NW_CLEARED
+	(KVM_X86_QUIRK_CD_NW_CLEARED |		\
+	 KVM_X86_QUIRK_IGNORE_GUEST_PAT)
 
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 89cc7a18ef45..dc4d6428dd02 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -441,6 +441,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
+#define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 47e64a3c4ce3..f999c15d8d3e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -232,7 +232,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-bool kvm_mmu_may_ignore_guest_pat(void);
+bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e6eb3a262f8d..9d6294f76d19 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4663,17 +4663,19 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 }
 #endif
 
-bool kvm_mmu_may_ignore_guest_pat(void)
+bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)
 {
 	/*
 	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
 	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
 	 * honor the memtype from the guest's PAT so that guest accesses to
 	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
-	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
-	 * KVM _always_ ignores guest PAT (when EPT is enabled).
+	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA.
+	 * KVM _always_ ignores guest PAT, when EPT is enabled and when quirk
+	 * KVM_X86_QUIRK_IGNORE_GUEST_PAT is enabled or the CPU lacks the
+	 * ability to safely honor guest PAT.
 	 */
-	return shadow_memtype_mask;
+	return kvm_check_has_quirk(kvm, KVM_X86_QUIRK_IGNORE_GUEST_PAT);
 }
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 486fbdb4365c..719e79712339 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7599,6 +7599,17 @@ int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static inline bool vmx_ignore_guest_pat(struct kvm *kvm)
+{
+	/*
+	 * Non-coherent DMA devices need the guest to flush CPU properly.
+	 * In that case it is not possible to map all guest RAM as WB, so
+	 * always trust guest PAT.
+	 */
+	return !kvm_arch_has_noncoherent_dma(kvm) &&
+	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_IGNORE_GUEST_PAT);
+}
+
 u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	/*
@@ -7608,13 +7619,8 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (is_mmio)
 		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
 
-	/*
-	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
-	 * device attached.  Letting the guest control memory types on Intel
-	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
-	 * the guest to behave only as a last resort.
-	 */
-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+	/* Force WB if ignoring guest PAT */
+	if (vmx_ignore_guest_pat(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
 	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
@@ -8506,6 +8512,27 @@ __init int vmx_hardware_setup(void)
 
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 
+	/*
+	 * On Intel CPUs that lack self-snoop feature, letting the guest control
+	 * memory types may result in unexpected behavior. So always ignore guest
+	 * PAT on those CPUs and map VM as writeback, not allowing userspace to
+	 * disable the quirk.
+	 *
+	 * On certain Intel CPUs (e.g. SPR, ICX), though self-snoop feature is
+	 * supported, UC is slow enough to cause issues with some older guests (e.g.
+	 * an old version of bochs driver uses ioremap() instead of ioremap_wc() to
+	 * map the video RAM, causing wayland desktop to fail to get started
+	 * correctly). To avoid breaking those older guests that rely on KVM to force
+	 * memory type to WB, provide KVM_X86_QUIRK_IGNORE_GUEST_PAT to preserve the
+	 * safer (for performance) default behavior.
+	 *
+	 * On top of this, non-coherent DMA devices need the guest to flush CPU
+	 * caches properly.  This also requires honoring guest PAT, and is forced
+	 * independent of the quirk in vmx_ignore_guest_pat().
+	 */
+	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
+		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
+       kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 	return r;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 062c1b58b223..5b45fca3ddfa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13545,7 +13545,7 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
 	 * (or last) non-coherent device is (un)registered to so that new SPTEs
 	 * with the correct "ignore guest PAT" setting are created.
 	 */
-	if (kvm_mmu_may_ignore_guest_pat())
+	if (kvm_mmu_may_ignore_guest_pat(kvm))
 		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 
-- 
2.43.5



