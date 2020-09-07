Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B55926027F
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIGR1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:27:47 -0400
Received: from 8bytes.org ([81.169.241.247]:43658 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbgIGNTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:19:37 -0400
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id C630B3AAA;
        Mon,  7 Sep 2020 15:17:17 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v7 67/72] x86/smpboot: Load TSS and getcpu GDT entry before loading IDT
Date:   Mon,  7 Sep 2020 15:16:08 +0200
Message-Id: <20200907131613.12703-68-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907131613.12703-1-joro@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The IDT on 64bit contains vectors which use paranoid_entry() and/or IST
stacks. To make these vectors work the TSS and the getcpu GDT entry need
to be set up before the IDT is loaded.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/cpu/common.c     | 23 +++++++++++++++++++++++
 arch/x86/kernel/smpboot.c        |  2 +-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d8a82e650810..5ac507586769 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -696,6 +696,7 @@ extern void load_direct_gdt(int);
 extern void load_fixmap_gdt(int);
 extern void load_percpu_segment(int);
 extern void cpu_init(void);
+extern void cpu_init_exception_handling(void);
 extern void cr4_init(void);
 
 static inline unsigned long get_debugctlmsr(void)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1d65365363a1..a9527c0c38fb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1854,6 +1854,29 @@ static inline void tss_setup_io_bitmap(struct tss_struct *tss)
 #endif
 }
 
+/*
+ * Setup everything needed to handle exceptions from the IDT, including the IST
+ * exceptions which use paranoid_entry()
+ */
+void cpu_init_exception_handling(void)
+{
+	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
+	int cpu = raw_smp_processor_id();
+
+	/* paranoid_entry() gets the CPU number from the GDT */
+	setup_getcpu(cpu);
+
+	/* IST vectors need TSS to be set up. */
+	tss_setup_ist(tss);
+	tss_setup_io_bitmap(tss);
+	set_tss_desc(cpu, &get_cpu_entry_area(cpu)->tss.x86_tss);
+
+	load_TR_desc();
+
+	/* Finally load the IDT */
+	load_current_idt();
+}
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f5ef689dd62a..de776b2e6046 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -227,7 +227,7 @@ static void notrace start_secondary(void *unused)
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
-	load_current_idt();
+	cpu_init_exception_handling();
 	cpu_init();
 	x86_cpuinit.early_percpu_clock_init();
 	preempt_disable();
-- 
2.28.0

