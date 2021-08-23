Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CD93F4BD2
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 15:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhHWNne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 09:43:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:53980 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhHWNne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 09:43:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10084"; a="197353299"
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="197353299"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 06:42:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="492703467"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 23 Aug 2021 06:42:45 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, kvm@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Artem Kashkanov <artem.kashkanov@intel.com>
Subject: [PATCH] kvm/x86: Fix PT "host mode"
Date:   Mon, 23 Aug 2021 16:42:39 +0300
Message-Id: <20210823134239.45402-1-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Regardless of the "pt_mode", the kvm driver installs its interrupt handler
for Intel PT, which always overrides the native handler, causing data loss
inside kvm guests, while we're expecting to trace them.

Fix this by only installing kvm's perf_guest_cbs if pt_mode is set to
guest tracing.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: ff9d07a0e7ce7 ("KVM: Implement perf callbacks for guest sampling")
Reported-by: Artem Kashkanov <artem.kashkanov@intel.com>
Tested-by: Artem Kashkanov <artem.kashkanov@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 arch/x86/kvm/x86.c              | 10 ++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..84a1ed067f35 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1408,6 +1408,7 @@ struct kvm_x86_init_ops {
 	int (*disabled_by_bios)(void);
 	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
+	int (*intel_pt_enabled)(void);
 
 	struct kvm_x86_ops *runtime_ops;
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..0c239aa3532a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7943,11 +7943,17 @@ static __init int hardware_setup(void)
 	return r;
 }
 
+static int vmx_intel_pt_enabled(void)
+{
+	return vmx_pt_mode_is_host_guest();
+}
+
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
+	.intel_pt_enabled = vmx_intel_pt_enabled,
 
 	.runtime_ops = &vmx_x86_ops,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..3ba0001e7388 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -268,6 +268,8 @@ static struct kmem_cache *x86_fpu_cache;
 
 static struct kmem_cache *x86_emulator_cache;
 
+static int __read_mostly intel_pt_enabled;
+
 /*
  * When called, it means the previous get/set msr reached an invalid msr.
  * Return true if we want to ignore/silent this failed msr access.
@@ -8194,7 +8196,10 @@ int kvm_arch_init(void *opaque)
 
 	kvm_timer_init();
 
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+	if (ops->intel_pt_enabled && ops->intel_pt_enabled()) {
+		perf_register_guest_info_callbacks(&kvm_guest_cbs);
+		intel_pt_enabled = 1;
+	}
 
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
@@ -8229,7 +8234,8 @@ void kvm_arch_exit(void)
 		clear_hv_tscchange_cb();
 #endif
 	kvm_lapic_exit();
-	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+	if (intel_pt_enabled)
+		perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
-- 
2.32.0

