Return-Path: <kvm+bounces-1060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6ABF7E4923
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FF322812DF
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A5136AFC;
	Tue,  7 Nov 2023 19:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lq6QegBZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ACB36AEA
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 19:23:49 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B081393;
	Tue,  7 Nov 2023 11:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699385028; x=1730921028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lA3UIdeOAMUHqDjCcfzpn8CcwxB4M2h7Jcw5xPYkhI0=;
  b=Lq6QegBZ5xP2XmGEf1M+OY5bCP5VvfhR1YTYjL4x7bmYoTJx2pC3r6Xz
   QpSmtbG34S6HmW81dfPntmQJh6dvZjwzTTn26GNEXF5imvLsrjDa57SNB
   a4TUqzjNJTmD1Tjclbns7uBwBiHyybMlhwgHhwUji2D+Y7JuEnt3GsYOS
   +JXqh4O9c4TnlXy6gckTkNSoR0QGJj79GTafYExisw5ZoN+HiEjNFLioA
   sloex8+uB9Wz1cPEL5UCCk8x7NI9oaMPXtHdUJbbW9iPw9RPttI02Q3ei
   h7pPXh9Y8CfQktWhsEq2T3hiHAD6T9O7eo27LYBS8H3io8Rce8lGI6Va5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="475831541"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="475831541"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 11:23:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10937910"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 11:23:48 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH 1/2] KVM: x86: Make the hardcoded APIC bus frequency vm variable
Date: Tue,  7 Nov 2023 11:22:33 -0800
Message-Id: <04f03fee0b197c5ec4356c4f3a3bad8bd067fede.1699383993.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699383993.git.isaku.yamahata@intel.com>
References: <cover.1699383993.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX virtualizes the advertised APIC bus frequency to be 25MHz.  The KVM
hardcodedes it to be 1GHz.  This mismatch causes the vAPIC timer to fire
earlier than the TDX guest expects.  In order to reconcile this mismatch,
make the frequency configurable for the user space VMM.  As the first step,
Replace the constants with the VM value in struct kvm.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/hyperv.c           | 2 +-
 arch/x86/kvm/lapic.c            | 6 ++++--
 arch/x86/kvm/lapic.h            | 4 ++--
 arch/x86/kvm/x86.c              | 2 ++
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7036982332e..f2b1c6b3fb11 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1334,6 +1334,8 @@ struct kvm_arch {
 
 	u32 default_tsc_khz;
 	bool user_set_tsc;
+	u64 apic_bus_cycle_ns;
+	u64 apic_bus_frequency;
 
 	seqcount_raw_spinlock_t pvclock_sc;
 	bool use_master_clock;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 238afd7335e4..995ce2c74ce0 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1687,7 +1687,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
 		break;
 	case HV_X64_MSR_APIC_FREQUENCY:
-		data = APIC_BUS_FREQUENCY;
+		data = vcpu->kvm->arch.apic_bus_frequency;
 		break;
 	default:
 		kvm_pr_unimpl_rdmsr(vcpu, msr);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 245b20973cae..73956b0ac1f1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1542,7 +1542,8 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 		remaining = 0;
 
 	ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
-	return div64_u64(ns, (APIC_BUS_CYCLE_NS * apic->divide_count));
+	return div64_u64(ns, (apic->vcpu->kvm->arch.apic_bus_cycle_ns *
+			      apic->divide_count));
 }
 
 static void __report_tpr_access(struct kvm_lapic *apic, bool write)
@@ -1960,7 +1961,8 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 
 static inline u64 tmict_to_ns(struct kvm_lapic *apic, u32 tmict)
 {
-	return (u64)tmict * APIC_BUS_CYCLE_NS * (u64)apic->divide_count;
+	return (u64)tmict * apic->vcpu->kvm->arch.apic_bus_cycle_ns *
+		(u64)apic->divide_count;
 }
 
 static void update_target_expiration(struct kvm_lapic *apic, uint32_t old_divisor)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..3a425ea2a515 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -16,8 +16,8 @@
 #define APIC_DEST_NOSHORT		0x0
 #define APIC_DEST_MASK			0x800
 
-#define APIC_BUS_CYCLE_NS       1
-#define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
+#define APIC_BUS_CYCLE_NS_DEFAULT	1
+#define APIC_BUS_FREQUENCY_DEFAULT	(1000000000ULL / APIC_BUS_CYCLE_NS_DEFAULT)
 
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..a9f4991b3e2e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12466,6 +12466,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
+	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
+	kvm->arch.apic_bus_frequency = APIC_BUS_FREQUENCY_DEFAULT;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
 
-- 
2.25.1


