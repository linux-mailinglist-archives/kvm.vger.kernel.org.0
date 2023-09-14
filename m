Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE0379FAB0
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbjINFU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbjINFUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:20:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20AB2134;
        Wed, 13 Sep 2023 22:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668767; x=1726204767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=24bZxrNwN6mEn31ObZA79OqggozStalI8dlLgDZYX38=;
  b=FcOJKbkI2JxS0MuL1xkMWMFKkzmaXpJh5Wek5BaOChLRVlSUpttnyDgi
   0tLtQpYumIvj6+c7Qhgyp2LbTF882dvvjtPRwSzdnLUL+ezPgZafXcFdh
   u1H8ElVmng/Q1PbApNxPfuemnCb8SMyvToe162WSDC2SfEgLhcmddK9pD
   K/bSt0uZ8KsHINHNIkLjldk8U82VDFx603cVgpO9C4Yooc5vdDXtav3h7
   gSvSplb6Gax+HPYSoY7VcjpimXBNTV/uCoBJ8vvPtUJnsS/o1iVOvH3r2
   +qRz0+htpsWhTy+Dng91D2svXNSfM3QWhhBQZZJxoJCPYU7b+zA/tje9r
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661561"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661561"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488853"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488853"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:48 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
Subject: [PATCH v10 38/38] x86/fred: Invoke FRED initialization code to enable FRED
Date:   Wed, 13 Sep 2023 21:48:05 -0700
Message-Id: <20230914044805.301390-39-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Let cpu_init_exception_handling() call cpu_init_fred_exceptions() to
initialize FRED. However if FRED is unavailable or disabled, it falls
back to set up TSS IST and initialize IDT.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Move this patch after all required changes are in place (Thomas
  Gleixner).
---
 arch/x86/kernel/cpu/common.c | 17 ++++++++++++-----
 arch/x86/kernel/irqinit.c    |  7 ++++++-
 arch/x86/kernel/traps.c      |  5 ++++-
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4cb36e241c9a..e230d3f4c556 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -61,6 +61,7 @@
 #include <asm/microcode.h>
 #include <asm/intel-family.h>
 #include <asm/cpu_device_id.h>
+#include <asm/fred.h>
 #include <asm/uv/uv.h>
 #include <asm/set_memory.h>
 #include <asm/traps.h>
@@ -2128,7 +2129,10 @@ void syscall_init(void)
 	/* The default user and kernel segments */
 	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
 
-	idt_syscall_init();
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		fred_syscall_init();
+	else
+		idt_syscall_init();
 }
 
 #else	/* CONFIG_X86_64 */
@@ -2244,8 +2248,9 @@ void cpu_init_exception_handling(void)
 	/* paranoid_entry() gets the CPU number from the GDT */
 	setup_getcpu(cpu);
 
-	/* IST vectors need TSS to be set up. */
-	tss_setup_ist(tss);
+	/* For IDT mode, IST vectors need to be set in TSS. */
+	if (!cpu_feature_enabled(X86_FEATURE_FRED))
+		tss_setup_ist(tss);
 	tss_setup_io_bitmap(tss);
 	set_tss_desc(cpu, &get_cpu_entry_area(cpu)->tss.x86_tss);
 
@@ -2254,8 +2259,10 @@ void cpu_init_exception_handling(void)
 	/* GHCB needs to be setup to handle #VC. */
 	setup_ghcb();
 
-	/* Finally load the IDT */
-	load_current_idt();
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		cpu_init_fred_exceptions();
+	else
+		load_current_idt();
 }
 
 /*
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index c683666876f1..f79c5edc0b89 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -28,6 +28,7 @@
 #include <asm/setup.h>
 #include <asm/i8259.h>
 #include <asm/traps.h>
+#include <asm/fred.h>
 #include <asm/prom.h>
 
 /*
@@ -96,7 +97,11 @@ void __init native_init_IRQ(void)
 	/* Execute any quirks before the call gates are initialised: */
 	x86_init.irqs.pre_vector_init();
 
-	idt_setup_apic_and_irq_gates();
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		fred_complete_exception_setup();
+	else
+		idt_setup_apic_and_irq_gates();
+
 	lapic_assign_system_vectors();
 
 	if (!acpi_ioapic && !of_ioapic && nr_legacy_irqs()) {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 848c85208a57..0ee78a30e14a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1411,7 +1411,10 @@ void __init trap_init(void)
 
 	/* Initialize TSS before setting up traps so ISTs work */
 	cpu_init_exception_handling();
+
 	/* Setup traps as cpu_init() might #GP */
-	idt_setup_traps();
+	if (!cpu_feature_enabled(X86_FEATURE_FRED))
+		idt_setup_traps();
+
 	cpu_init();
 }
-- 
2.34.1

