Return-Path: <kvm+bounces-12423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2CF885E5F
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 17:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0CE4282288
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838FB13DBBD;
	Thu, 21 Mar 2024 16:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TAYctVZs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF7C13B289;
	Thu, 21 Mar 2024 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711039085; cv=none; b=JZnBxD2nYAhVXAipn7HbeDXWpbqltUAb45q4ggXL3Vsu/8Os2vBsFkWL6VS/qC9BA4+Snc3wopOt9Uq1kTGlR2pnSzAGG0OWpt/auBNLRvUBvnwybmZzzdxl2x/mxIX7hbVpfW+9/osqsN27uOSBu1x2arHo2n8I9vNk5m86644=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711039085; c=relaxed/simple;
	bh=hPRhzWBLAX0KSLPVRxVUSq+vfDY/HhSqH6GgEXF4edc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uyYy1sPEJXMKyvuwCs4W1FUy2BY/cVUbqdBh079JWuKQnhA9ayKAqW9ltFcCmEN/soZDncRHJIY1HxH8Z5kmwkPY0/j8Rh0znYCbVIUeYlbl0lZrXnUVjCGjHbuL4rVRUdAx/Ta+sk8X+UISy376XrBySbShc+g3GOMhxKE2qns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TAYctVZs; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711039083; x=1742575083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hPRhzWBLAX0KSLPVRxVUSq+vfDY/HhSqH6GgEXF4edc=;
  b=TAYctVZsEPUnEygPLVMWq60ffHSOrNJJ09dzURQ10OtaIj8V4TZe0F9J
   KQvYSgUr18Brq7XZgq0NHb5esjVU6awZalG2EnIIEC3SNbocFeUe9SsHf
   ZaL8mstVy6XLYj8k0RnAMx3i+BFRYYKwCCrN+bQ75Wj27XJopr275dFk4
   apoDRj98PbUNDALh5/tk6oncGlT5uwXeNwVVikyDa1R+JRvPLIsqItTKy
   Ptaz0TjUSqv0pQzAi//bb8E8A0XqHRELm9Ee4/VOA4cW6rdfWEDXVy4ud
   yrEINjw8B0OtgtdjKlDOsP7jmhVb6W88c7KtrxnUDHJQ0pxk7GUVPaUzp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="31477560"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="31477560"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 09:37:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="19280014"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 09:37:58 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: isaku.yamahata@intel.com,
	pbonzini@redhat.com,
	erdemaktas@google.com,
	vkuznets@redhat.com,
	seanjc@google.com,
	vannapurve@google.com,
	jmattson@google.com,
	mlevitsk@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V4 2/4] KVM: x86: Make nsec per APIC bus cycle a VM variable
Date: Thu, 21 Mar 2024 09:37:42 -0700
Message-Id: <ad986cc2eca0d37bee464e560263c0f7cd437bf7.1711035400.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1711035400.git.reinette.chatre@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce the VM variable "nanoseconds per APIC bus cycle" in
preparation to make the APIC bus frequency configurable.

The TDX architecture hard-codes the core crystal clock frequency to
25MHz and mandates exposing it via CPUID leaf 0x15. The TDX architecture
does not allow the VMM to override the value.

In addition, per Intel SDM:
    "The APIC timer frequency will be the processor’s bus clock or core
     crystal clock frequency (when TSC/core crystal clock ratio is
     enumerated in CPUID leaf 0x15) divided by the value specified in
     the divide configuration register."

The resulting 25MHz APIC bus frequency conflicts with the KVM hardcoded
APIC bus frequency of 1GHz.

Introduce the VM variable "nanoseconds per APIC bus cycle" to prepare
for allowing userspace to tell KVM to use the frequency that TDX mandates
instead of the default 1Ghz. Doing so ensures that the guest doesn't have
a conflicting view of the APIC bus frequency.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
[reinette: rework changelog]
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

Changes v4:
- Reword changelog to address comments related to "bus clock" vs
  "core crystal clock" frequency. (Xiaoyao)
- Typo in changelog ("APIC APIC" -> "APIC").
- Change logic "APIC bus cycles per nsec" -> "nanoseconds per
  APIC bus cycle".

Changes V3:
- Update commit message.
- Dropped apic_bus_frequency according to Maxim Levitsky.

Changes v2:
- No change.

 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/hyperv.c           | 3 ++-
 arch/x86/kvm/lapic.c            | 6 ++++--
 arch/x86/kvm/lapic.h            | 2 +-
 arch/x86/kvm/x86.c              | 1 +
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9e7b1a00e265..91ae7345700c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1359,6 +1359,7 @@ struct kvm_arch {
 
 	u32 default_tsc_khz;
 	bool user_set_tsc;
+	u64 apic_bus_cycle_ns;
 
 	seqcount_raw_spinlock_t pvclock_sc;
 	bool use_master_clock;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1030701db967..5c31e715d2ad 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1737,7 +1737,8 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
 		break;
 	case HV_X64_MSR_APIC_FREQUENCY:
-		data = div64_u64(1000000000ULL, APIC_BUS_CYCLE_NS);
+		data = div64_u64(1000000000ULL,
+				 vcpu->kvm->arch.apic_bus_cycle_ns);
 		break;
 	default:
 		kvm_pr_unimpl_rdmsr(vcpu, msr);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 11b9a9bdc07a..f336a0ca1190 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1547,7 +1547,8 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 		remaining = 0;
 
 	ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
-	return div64_u64(ns, (APIC_BUS_CYCLE_NS * apic->divide_count));
+	return div64_u64(ns, (apic->vcpu->kvm->arch.apic_bus_cycle_ns *
+			      apic->divide_count));
 }
 
 static void __report_tpr_access(struct kvm_lapic *apic, bool write)
@@ -1965,7 +1966,8 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 
 static inline u64 tmict_to_ns(struct kvm_lapic *apic, u32 tmict)
 {
-	return (u64)tmict * APIC_BUS_CYCLE_NS * (u64)apic->divide_count;
+	return (u64)tmict * apic->vcpu->kvm->arch.apic_bus_cycle_ns *
+		(u64)apic->divide_count;
 }
 
 static void update_target_expiration(struct kvm_lapic *apic, uint32_t old_divisor)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index a20cb006b6c8..51e09f5a7fc5 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -16,7 +16,7 @@
 #define APIC_DEST_NOSHORT		0x0
 #define APIC_DEST_MASK			0x800
 
-#define APIC_BUS_CYCLE_NS       1
+#define APIC_BUS_CYCLE_NS_DEFAULT	1
 
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 66c4381460dc..23f25799c760 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12559,6 +12559,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
+	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
 
-- 
2.34.1


