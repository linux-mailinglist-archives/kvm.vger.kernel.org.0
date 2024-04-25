Return-Path: <kvm+bounces-15985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CABC58B2CD2
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AE02B2ADC5
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09B817BB19;
	Thu, 25 Apr 2024 22:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i17fEzuN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ED715666C;
	Thu, 25 Apr 2024 22:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714082836; cv=none; b=QhnNObX+T7k/z+X6g6ymAksQ2OVDnqIcaZcznmzso72NOb2TeYnaO/2WzqRDPziahajcsJDRY9bL3o3TkunhEPYcD1Up4cejAXbRs4vcXqHRHIi8EakX3wuAhxkyVoksEeN4tG33EfR/gkiykBcUgmmNndK8tKE4JUC0PauOYjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714082836; c=relaxed/simple;
	bh=y9NaE8bHO9umSWYJ/4fIGZrgKTsHtPMSKPMLFGWt/hU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQ8DFZ7BlXDR6KR6GsnbNOHNaV0nV/WLFEMVG1ZqYeGnPkV9dBTlgEfQy6zZeZmF5t0id/RA9VOKXAQNkOwrnwD+rsL/rnLApZ9d/MNgtXAFTWjvLTqOhpZ0aOw9cK97Qu4nlEhjd7qt4KTLANQFNe/Mz3OUMJhXEmVohXvCG+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i17fEzuN; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714082834; x=1745618834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y9NaE8bHO9umSWYJ/4fIGZrgKTsHtPMSKPMLFGWt/hU=;
  b=i17fEzuNq/YalhwaJaTLn5LUjgHPnyDKWOY+tdAoz73Czkkr42zW6rUL
   nC2aee4rzMBaoMz3baLH8e+Qbw3KTBtEtNlXCv5Nio7GlVqoCyToglV5h
   WSjXZ1f7vkrUp5wooQmsmAeblUr4bMssWf9t9bIsOl1uq0ByiQt1ufmc1
   LNsNbmbpyVzy4G+dBPSfsGPDqjLHfmk63FionxaMyL/VFeGBdMlU8DFl6
   KmcK7mxoaUgC451sv1I0aZ3Ynd9QcvNq/2YeH62oevOlqovCDNDWtC60I
   hYoF51kKukrUSKAHRVHV5cwZkJnfOPsJmj0w4flVknpOK+8yGQOGrUiAO
   Q==;
X-CSE-ConnectionGUID: Od5IVERcRnmn7prVibtMZw==
X-CSE-MsgGUID: MsIkhe9PRuesZRypoKHGNg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="13585399"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="13585399"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 15:07:12 -0700
X-CSE-ConnectionGUID: vTmcthekRiCRdZy5hzyYNQ==
X-CSE-MsgGUID: 3OS/yAfTQMi17VSa1M0d0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25185086"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 15:07:12 -0700
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
Subject: [PATCH V5 2/4] KVM: x86: Make nsec per APIC bus cycle a VM variable
Date: Thu, 25 Apr 2024 15:07:00 -0700
Message-Id: <ae75ce37c6c38bb4efd10a0a41932984c40b24ac.1714081726.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1714081725.git.reinette.chatre@intel.com>
References: <cover.1714081725.git.reinette.chatre@intel.com>
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
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
[reinette: rework changelog]
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes v5:
- Add Rick's Reviewed-by tag.

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
index 1d13e3cd1dc5..f2735582c7e0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1358,6 +1358,7 @@ struct kvm_arch {
 
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
index cf37586f0466..3e66a0a95999 100644
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
index e9ef1fa4b90b..10e6315103f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12629,6 +12629,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
+	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
 
-- 
2.34.1


