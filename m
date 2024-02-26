Return-Path: <kvm+bounces-9719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E26B5866D5A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B394284884
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DB67D40A;
	Mon, 26 Feb 2024 08:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HUKOBSah"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D077B3C1;
	Mon, 26 Feb 2024 08:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936135; cv=none; b=GsyUde9YgMOPKgJktt9P/u7PVb5Xi5cIjE6/KsP1BZbQUg3NThn7A4cF8cubvSTyjAGxB9fi5FdBe+N4fQ6ZFdotAIEofF4+v/dALQkjwB6RDBNtR+QNT1g3kxTjhY9TLrG/3QCNwt0a/yLB0DKj1VYaY92lAgnKaz14XOuynqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936135; c=relaxed/simple;
	bh=FqA+upqL9gNfeYquYyLlBFbOWxO4m0XoA2LYxuCR4eo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IXfRbh+H9TxCq0XoGjfhvPepRkMZFnFnFwQ6Mor7t1e8KA5egp0Ms6A3wXQ7nCUzEabPZLK/T8QSrZQL3T6hFK0XeESwrlrZS7ZwJZfmRhArE1QtDem79wQ+NeB87SfOcEnTRZA77g7/BVljG4B2XIgpQG5wDoKBYk1ejpatgk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HUKOBSah; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936133; x=1740472133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FqA+upqL9gNfeYquYyLlBFbOWxO4m0XoA2LYxuCR4eo=;
  b=HUKOBSah5zVQnYT0mHsayrpjfq0+7qsL9OGKwICQ8ZqvBBJUmPiEb2We
   n7KF7ygZST883g0W5Nq0mSamLAujMxpr4xjQAPq4EUWdwFLJz3dcG4cmk
   MW3dxJynsSF5EgHU+l8UW8tpwL5y8JghSV0tnf/6yq8EwRjtEKhXygnE5
   V1ybjZpCWLyTK8g0asOJo0dxNIu316TuDQpT6iHPqjFDIXM1piymMjKlO
   6ZirS/hB77d3jOcPOMwgzrvPVTNku/X/CXrwOdiG730i3HnHyysulWS1K
   6b6R55waq3as+PUPOpR6P7DwG9v/iyTiNCZyy7p2mrKuMWysSbYn6jfQA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069571"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069571"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272658"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:52 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 094/130] KVM: TDX: Implement methods to inject NMI
Date: Mon, 26 Feb 2024 00:26:36 -0800
Message-Id: <a7ce6023eb8dd824e61023a95475629bd7ae2278.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX vcpu control structure defines one bit for pending NMI for VMM to
inject NMI by setting the bit without knowing TDX vcpu NMI states.  Because
the vcpu state is protected, VMM can't know about NMI states of TDX vcpu.
The TDX module handles actual injection and NMI states transition.

Add methods for NMI and treat NMI can be injected always.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c    | 64 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     |  6 ++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ee6c04959d4c..6d6d443a2bbd 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -306,6 +306,60 @@ static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vmx_flush_tlb_guest(vcpu);
 }
 
+static void vt_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_inject_nmi(vcpu);
+		return;
+	}
+
+	vmx_inject_nmi(vcpu);
+}
+
+static int vt_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	/*
+	 * The TDX module manages NMI windows and NMI reinjection, and hides NMI
+	 * blocking, all KVM can do is throw an NMI over the wall.
+	 */
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_nmi_allowed(vcpu, for_injection);
+}
+
+static bool vt_get_nmi_mask(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Assume NMIs are always unmasked.  KVM could query PEND_NMI and treat
+	 * NMIs as masked if a previous NMI is still pending, but SEAMCALLs are
+	 * expensive and the end result is unchanged as the only relevant usage
+	 * of get_nmi_mask() is to limit the number of pending NMIs, i.e. it
+	 * only changes whether KVM or the TDX module drops an NMI.
+	 */
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return vmx_get_nmi_mask(vcpu);
+}
+
+static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_nmi_mask(vcpu, masked);
+}
+
+static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
+{
+	/* Refer the comment in vt_get_nmi_mask(). */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_enable_nmi_window(vcpu);
+}
+
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			int pgd_level)
 {
@@ -515,14 +569,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.inject_irq = vt_inject_irq,
-	.inject_nmi = vmx_inject_nmi,
+	.inject_nmi = vt_inject_nmi,
 	.inject_exception = vmx_inject_exception,
 	.cancel_injection = vt_cancel_injection,
 	.interrupt_allowed = vt_interrupt_allowed,
-	.nmi_allowed = vmx_nmi_allowed,
-	.get_nmi_mask = vmx_get_nmi_mask,
-	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = vmx_enable_nmi_window,
+	.nmi_allowed = vt_nmi_allowed,
+	.get_nmi_mask = vt_get_nmi_mask,
+	.set_nmi_mask = vt_set_nmi_mask,
+	.enable_nmi_window = vt_enable_nmi_window,
 	.enable_irq_window = vt_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1dfa9b503e0d..be21dca47992 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -874,6 +874,12 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
+void tdx_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.nmi_injections;
+	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	WARN_ON_ONCE(root_hpa & ~PAGE_MASK);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 12a212e71827..539f3f9686fe 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -159,6 +159,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
+void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -202,6 +203,7 @@ static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
+static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1


