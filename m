Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDF85A0BFA
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 10:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiHYI4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 04:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiHYI4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 04:56:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11F4A8949;
        Thu, 25 Aug 2022 01:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661417794; x=1692953794;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xVtDh+LKAsKn8mzusCLTl5XWtgVfaTRuzuXZ6EiKo/U=;
  b=JEvzeOYSjqBvu4QQT4xekKZNQzm4Qmkt/2JP6B0wV2yXQUw0yVGmduq7
   0b7BH/kIUpy8R4NZnM0ZmoWS84wHesvVHW35+0rpaJ3QC5uM8WJPl4h4O
   z3J5R7beqKXQtkgH2/BFu7nzrurZTwSs1sAkmSvIwAGIJ9OiAdcsrpoFh
   TOKsIYMYST4vZW8yBTnACvMSBwNkF6S4besoX62h85p3c3reDWjAmWP06
   15csre5SY9VClweru025UkieIBIcU+0A64eGVuLpLQfzH3AgbQW7R3Rei
   YnvOCYbTh99E+DImw9fnvk9femivB+IQhxSYi9TfR16v/+90sBA/Y2Q1d
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="291756602"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="291756602"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 01:56:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="639505171"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 25 Aug 2022 01:56:29 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH 1/2] perf/x86/intel/pt: Introduce intel_pt_{stop,resume}()
Date:   Thu, 25 Aug 2022 16:56:24 +0800
Message-Id: <20220825085625.867763-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220825085625.867763-1-xiaoyao.li@intel.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM supports PT_MODE_HOST_GUEST mode for Intel PT that host and guest
have separate Intel PT configurations and work independently. In that
mdoe, KVM needs to context switch all the Intel PT configurations
between host and guest on VM-entry and VM-exit.

Before VM-entry, if Intel PT is enabled on host, KVM needs to disable it
first so as to context switch the PT configurations. After VM exit, KVM
needs to re-enable Intel PT for host. Currently, KVM achieves it by
manually toggle MSR_IA32_RTIT_CTL.TRACEEN bit to en/dis-able Intel PT.

However, PT PMI can be delivered after MSR_IA32_RTIT_CTL.TRACEEN bit is
cleared. PT PMI handler changes PT MSRs and re-enable PT, that leads to
1) VM-entry failure of guest 2) KVM stores stale value of PT MSRs.

To solve the problems, expose two interfaces for KVM to stop and
resume the PT tracing.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/events/intel/pt.c      | 11 ++++++++++-
 arch/x86/include/asm/intel_pt.h |  6 ++++--
 arch/x86/kernel/crash.c         |  4 ++--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 82ef87e9a897..55fc02036ff1 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1730,13 +1730,22 @@ static int pt_event_init(struct perf_event *event)
 	return 0;
 }
 
-void cpu_emergency_stop_pt(void)
+void intel_pt_stop(void)
 {
 	struct pt *pt = this_cpu_ptr(&pt_ctx);
 
 	if (pt->handle.event)
 		pt_event_stop(pt->handle.event, PERF_EF_UPDATE);
 }
+EXPORT_SYMBOL_GPL(intel_pt_stop);
+
+void intel_pt_resume(void) {
+	struct pt *pt = this_cpu_ptr(&pt_ctx);
+
+	if (pt->handle.event)
+		pt_event_start(pt->handle.event, 0);
+}
+EXPORT_SYMBOL_GPL(intel_pt_resume);
 
 int is_intel_pt_event(struct perf_event *event)
 {
diff --git a/arch/x86/include/asm/intel_pt.h b/arch/x86/include/asm/intel_pt.h
index c796e9bc98b6..fdfa4d31740c 100644
--- a/arch/x86/include/asm/intel_pt.h
+++ b/arch/x86/include/asm/intel_pt.h
@@ -27,12 +27,14 @@ enum pt_capabilities {
 };
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
-void cpu_emergency_stop_pt(void);
+void intel_pt_stop(void);
+void intel_pt_resume(void);
 extern u32 intel_pt_validate_hw_cap(enum pt_capabilities cap);
 extern u32 intel_pt_validate_cap(u32 *caps, enum pt_capabilities cap);
 extern int is_intel_pt_event(struct perf_event *event);
 #else
-static inline void cpu_emergency_stop_pt(void) {}
+static inline void intel_pt_stop(void) {}
+static inline void intel_pt_resume(void) {}
 static inline u32 intel_pt_validate_hw_cap(enum pt_capabilities cap) { return 0; }
 static inline u32 intel_pt_validate_cap(u32 *caps, enum pt_capabilities capability) { return 0; }
 static inline int is_intel_pt_event(struct perf_event *event) { return 0; }
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 9730c88530fc..2f2f72a209c0 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -93,7 +93,7 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 	/*
 	 * Disable Intel PT to stop its logging
 	 */
-	cpu_emergency_stop_pt();
+	intel_pt_stop();
 
 	disable_local_APIC();
 }
@@ -158,7 +158,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	/*
 	 * Disable Intel PT to stop its logging
 	 */
-	cpu_emergency_stop_pt();
+	intel_pt_stop();
 
 #ifdef CONFIG_X86_IO_APIC
 	/* Prevent crash_kexec() from deadlocking on ioapic_lock. */
-- 
2.27.0

