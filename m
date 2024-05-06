Return-Path: <kvm+bounces-16760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B883B8BD4B2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 20:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D546B1C2217E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A251591FC;
	Mon,  6 May 2024 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A3mnZ5BR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F6158A07;
	Mon,  6 May 2024 18:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715020587; cv=none; b=ag64HB9vuS4VhJfNf1PMHhHu62AUB7kf12Y32SMs5ZPwHGpVW91lVtfBVV3o2v36Aea9YcYSn4o3v7DfIktomOwWnfyyLkQPsvwhGU6Md7icEpdAFxBY9B3a3ZOyUgYi2Vzoi3A3pECDYbt4sPVWFIQOeROfPVJyIssiPeT20fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715020587; c=relaxed/simple;
	bh=aLUvoztgCdvkMpFl2d8hvMMLL/FRvtTxcIQ0ugO2uR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1hVGuQURVvgoGbr1fnQgr1RbEuygmJj/Apsg0YrpRFnZYmjEfFMOLgEeAYHPciU2sF3nMAF20yot7jBqQ7KdCncIkGDA5PQEcVtqYD7oJXq+QQTb/fKOk35QYLZq0tgU80q/OJEZAlUNDxyf1bsI/TWHKWQDQLxfgHruIyf/So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A3mnZ5BR; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715020586; x=1746556586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aLUvoztgCdvkMpFl2d8hvMMLL/FRvtTxcIQ0ugO2uR0=;
  b=A3mnZ5BR9t+euNKNg3m/4zoaG4ib99wTupD95Q9pIilKemsrPkoTC0Ry
   SzGwWNm+qlDHAk+v5muhob3BBpxMc5BZKuHs6rAk5zusXt2H12O7o0Jpa
   /+N1dnGwkw7VnINdzVrHeQifq9oxVDQNVvOfBxF9ZDW/JzbtH5jjaXkvx
   Mb2V0WLndDnJUAQA5B6uP8Yna6YaOP8znbQWFFA8exrNsP8CmYNJa0hHT
   vQUTHmT/ChZXB9x0M11YEwdrztc89Li6uscEQx/FYQxOyxSkQaA0aov6+
   /8FNF6zZZIYxh9yRKCv5IJBKGJxELFkwIOhQh+l4df9Lo+VoiQjkbDIkK
   g==;
X-CSE-ConnectionGUID: q0GeNK5uTUiya47dv8Qv8g==
X-CSE-MsgGUID: NqGuVTysTP2/nlG9As3eoQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21455746"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="21455746"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 11:36:10 -0700
X-CSE-ConnectionGUID: q31vWtKTRXWl5KWf7MUbEQ==
X-CSE-MsgGUID: l5L7qQaYRMK3Vm8yqeCU2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="28237809"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 11:36:10 -0700
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
	rick.p.edgecombe@intel.com,
	yuan.yao@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V6 2/4] KVM: x86: Make nsec per APIC bus cycle a VM variable
Date: Mon,  6 May 2024 11:35:56 -0700
Message-Id: <51b8612bf2942d06b8d879aaede17b35b2d1814c.1715017765.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1715017765.git.reinette.chatre@intel.com>
References: <cover.1715017765.git.reinette.chatre@intel.com>
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
[reinette: rework changelog]
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes v6:
- Add Xiaoyao Li's Reviewed-by tag.

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
---
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
index b389129d59a9..bc3c63e58488 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12623,6 +12623,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
+	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
 
-- 
2.34.1


