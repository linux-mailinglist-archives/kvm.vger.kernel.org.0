Return-Path: <kvm+bounces-15703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD5518AF5AC
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42C641F271AF
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995C013E3F7;
	Tue, 23 Apr 2024 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n8ujE6d5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF5142E7D;
	Tue, 23 Apr 2024 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893816; cv=none; b=nE03XE9ocdOg8zHVQe1xphnQH6fwTYTnUWiLvfCSykvOKUh6fq9z8jphSEKfd7EuGD0s4rW1HBoqy36hRtwWDDoLb+1wbB8xXzzdLNVhQc4S+B8MWQUjez0pmEwX7CoXFTCzXKL8EMzIZG7cs8gPSOZm4hNALo2t2Sf46pyjbSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893816; c=relaxed/simple;
	bh=8aOmsF2QEa+yVkbUTXwr34C7ETg0/rA12XbsJoYGrX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FHrX9f2Kh2iSI9ly1gY9SOlxJAs7SaXOHZkkQf8DkRyO2ltJkUKCeYHGDKFcH9IMCmwircEvjIsmg7Dg2VCC462A8FT513GdDByipGrWWZKA+96I5QBIfdGBnY1K3MHKKkKvgeZlTMP7o6Y0Srjkhk0P/z9oPeh1bNDiGmluBrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n8ujE6d5; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893815; x=1745429815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8aOmsF2QEa+yVkbUTXwr34C7ETg0/rA12XbsJoYGrX4=;
  b=n8ujE6d5enfKukOUIFgx3ONqEfd4OYxKYiqsFV036Lp+FpR+ymIXNtEs
   TlcxF6w7wcEhhRUslkzE04zrhkNg/Uok8KUqD0ytlPehWFyP0zo1IqfSE
   fLFnBhRolv+0wmAqgjgks1CMGhsE3i5UCWblyYeVNNyiTgPjJqhXZIVce
   vFT7lPnrA59twMivBuFQOBOSVdrNIiab3+vnKL6jPuKkLryWQcMW0DqHz
   RUbyorQ3QWNKf+HOUJJKlKwhfNMLZ/rR2iTd2yvJJDXG+OriuoWunoLb7
   +40+34fw2txK/PnhfM20kj/fbQZLHk3OL4AOw6P+MRQ/1KPOkZyEwC966
   Q==;
X-CSE-ConnectionGUID: 4tKSlbOpTYOiDTMLvp0Trg==
X-CSE-MsgGUID: 0p8/TpvPRW6MOfV7akpppw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712444"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712444"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:45 -0700
X-CSE-ConnectionGUID: QdRLr/HcTASS69sW3ms7tw==
X-CSE-MsgGUID: GUkBPlNmQdmnj9BUxwx6TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097441"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:44 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	jim.harris@samsung.com,
	a.manzanares@samsung.com,
	"Bjorn Helgaas" <helgaas@kernel.org>,
	guang.zeng@intel.com,
	robert.hoo.linux@gmail.com,
	oliver.sang@intel.com,
	acme@kernel.org,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3  08/12] x86/irq: Install posted MSI notification handler
Date: Tue, 23 Apr 2024 10:41:10 -0700
Message-Id: <20240423174114.526704-9-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All MSI vectors are multiplexed into a single notification vector when
posted MSI is enabled. It is the responsibility of the notification
vector handler to demultiplex MSI vectors. In this handler, for each
pending bit, MSI vector handlers are dispatched without IDT delivery.

For example, the interrupt flow will change as follows:
(3 MSIs of different vectors arrive in a a high frequency burst)

BEFORE:
interrupt(MSI)
    irq_enter()
    handler() /* EOI */
    irq_exit()
        process_softirq()
interrupt(MSI)
    irq_enter()
    handler() /* EOI */
    irq_exit()
        process_softirq()
interrupt(MSI)
    irq_enter()
    handler() /* EOI */
    irq_exit()
        process_softirq()

AFTER:
interrupt /* Posted MSI notification vector */
    irq_enter()
	atomic_xchg(PIR)
	handler()
	handler()
	handler()
	pi_clear_on()
    apic_eoi()
    irq_exit()
        process_softirq()

Except for the leading MSI, CPU notifications are skipped/coalesced.

For MSIs arrive at a low frequency, the demultiplexing loop does not
wait for more interrupts to coalesce. Therefore, there's no additional
latency other than the processing time.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v3:
   - Add support for FRED
   - Fix double eoi if a vector is invalid (Kevin)
v2:
   - Delete extra inline attribute
   - Fix pir pointer in xchg (Zeng Guang)
---
 arch/x86/entry/entry_fred.c     |   2 +
 arch/x86/include/asm/hardirq.h  |   3 +
 arch/x86/include/asm/idtentry.h |   6 ++
 arch/x86/kernel/idt.c           |   3 +
 arch/x86/kernel/irq.c           | 125 +++++++++++++++++++++++++++++++-
 5 files changed, 135 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index ac120cbdaaf2..c4a22e3d4a1e 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -117,6 +117,8 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
 	SYSVEC(POSTED_INTR_VECTOR,		kvm_posted_intr_ipi),
 	SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	kvm_posted_intr_wakeup_ipi),
 	SYSVEC(POSTED_INTR_NESTED_VECTOR,	kvm_posted_intr_nested_ipi),
+
+	SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	posted_msi_notification),
 };
 
 static bool fred_setup_done __initdata;
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index e7ab594b3a7a..c67fa6ad098a 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -44,6 +44,9 @@ typedef struct {
 	unsigned int irq_hv_reenlightenment_count;
 	unsigned int hyperv_stimer0_count;
 #endif
+#ifdef CONFIG_X86_POSTED_MSI
+	unsigned int posted_msi_notification_count;
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 749c7411d2f1..d4f24499b256 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -751,6 +751,12 @@ DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested
 # define fred_sysvec_kvm_posted_intr_nested_ipi		NULL
 #endif
 
+# ifdef CONFIG_X86_POSTED_MSI
+DECLARE_IDTENTRY_SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	sysvec_posted_msi_notification);
+#else
+# define fred_sysvec_posted_msi_notification		NULL
+# endif
+
 #if IS_ENABLED(CONFIG_HYPERV)
 DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_hyperv_callback);
 DECLARE_IDTENTRY_SYSVEC(HYPERV_REENLIGHTENMENT_VECTOR,	sysvec_hyperv_reenlightenment);
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index fc37c8d83daf..f445bec516a0 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -163,6 +163,9 @@ static const __initconst struct idt_data apic_idts[] = {
 # endif
 	INTG(SPURIOUS_APIC_VECTOR,		asm_sysvec_spurious_apic_interrupt),
 	INTG(ERROR_APIC_VECTOR,			asm_sysvec_error_interrupt),
+# ifdef CONFIG_X86_POSTED_MSI
+	INTG(POSTED_MSI_NOTIFICATION_VECTOR,	asm_sysvec_posted_msi_notification),
+# endif
 #endif
 };
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d652b0481899..578e4f6a5080 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -183,6 +183,13 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ",
 			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
 	seq_puts(p, "  Posted-interrupt wakeup event\n");
+#endif
+#ifdef CONFIG_X86_POSTED_MSI
+	seq_printf(p, "%*s: ", prec, "PMN");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ",
+			   irq_stats(j)->posted_msi_notification_count);
+	seq_puts(p, "  Posted MSI notification event\n");
 #endif
 	return 0;
 }
@@ -242,16 +249,16 @@ static __always_inline void handle_irq(struct irq_desc *desc,
 		__handle_irq(desc, regs);
 }
 
-static __always_inline void call_irq_handler(int vector, struct pt_regs *regs)
+static __always_inline int call_irq_handler(int vector, struct pt_regs *regs)
 {
 	struct irq_desc *desc;
+	int ret = 0;
 
 	desc = __this_cpu_read(vector_irq[vector]);
 	if (likely(!IS_ERR_OR_NULL(desc))) {
 		handle_irq(desc, regs);
 	} else {
-		apic_eoi();
-
+		ret = -EINVAL;
 		if (desc == VECTOR_UNUSED) {
 			pr_emerg_ratelimited("%s: %d.%u No irq handler for vector\n",
 					     __func__, smp_processor_id(),
@@ -260,6 +267,8 @@ static __always_inline void call_irq_handler(int vector, struct pt_regs *regs)
 			__this_cpu_write(vector_irq[vector], VECTOR_UNUSED);
 		}
 	}
+
+	return ret;
 }
 
 /*
@@ -273,7 +282,9 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
 	/* entry code tells RCU that we're not quiescent.  Check it. */
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "IRQ failed to wake up RCU");
 
-	call_irq_handler(vector, regs);
+	if (unlikely(call_irq_handler(vector, regs)))
+		apic_eoi();
+
 	set_irq_regs(old_regs);
 }
 
@@ -361,6 +372,112 @@ void intel_posted_msi_init(void)
 	destination = x2apic_enabled() ? apic_id : apic_id << 8;
 	this_cpu_write(posted_msi_pi_desc.ndst, destination);
 }
+
+/*
+ * De-multiplexing posted interrupts is on the performance path, the code
+ * below is written to optimize the cache performance based on the following
+ * considerations:
+ * 1.Posted interrupt descriptor (PID) fits in a cache line that is frequently
+ *   accessed by both CPU and IOMMU.
+ * 2.During posted MSI processing, the CPU needs to do 64-bit read and xchg
+ *   for checking and clearing posted interrupt request (PIR), a 256 bit field
+ *   within the PID.
+ * 3.On the other side, the IOMMU does atomic swaps of the entire PID cache
+ *   line when posting interrupts and setting control bits.
+ * 4.The CPU can access the cache line a magnitude faster than the IOMMU.
+ * 5.Each time the IOMMU does interrupt posting to the PIR will evict the PID
+ *   cache line. The cache line states after each operation are as follows:
+ *   CPU		IOMMU			PID Cache line state
+ *   ---------------------------------------------------------------
+ *...read64					exclusive
+ *...lock xchg64				modified
+ *...			post/atomic swap	invalid
+ *...-------------------------------------------------------------
+ *
+ * To reduce L1 data cache miss, it is important to avoid contention with
+ * IOMMU's interrupt posting/atomic swap. Therefore, a copy of PIR is used
+ * to dispatch interrupt handlers.
+ *
+ * In addition, the code is trying to keep the cache line state consistent
+ * as much as possible. e.g. when making a copy and clearing the PIR
+ * (assuming non-zero PIR bits are present in the entire PIR), it does:
+ *		read, read, read, read, xchg, xchg, xchg, xchg
+ * instead of:
+ *		read, xchg, read, xchg, read, xchg, read, xchg
+ */
+static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
+{
+	int i, vec = FIRST_EXTERNAL_VECTOR;
+	unsigned long pir_copy[4];
+	bool handled = false;
+
+	for (i = 0; i < 4; i++)
+		pir_copy[i] = pir[i];
+
+	for (i = 0; i < 4; i++) {
+		if (!pir_copy[i])
+			continue;
+
+		pir_copy[i] = arch_xchg(&pir[i], 0);
+		handled = true;
+	}
+
+	if (handled) {
+		for_each_set_bit_from(vec, pir_copy, FIRST_SYSTEM_VECTOR)
+			call_irq_handler(vec, regs);
+	}
+
+	return handled;
+}
+
+/*
+ * Performance data shows that 3 is good enough to harvest 90+% of the benefit
+ * on high IRQ rate workload.
+ */
+#define MAX_POSTED_MSI_COALESCING_LOOP 3
+
+/*
+ * For MSIs that are delivered as posted interrupts, the CPU notifications
+ * can be coalesced if the MSIs arrive in high frequency bursts.
+ */
+DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi_notification)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct pi_desc *pid;
+	int i = 0;
+
+	pid = this_cpu_ptr(&posted_msi_pi_desc);
+
+	inc_irq_stat(posted_msi_notification_count);
+	irq_enter();
+
+	/*
+	 * Max coalescing count includes the extra round of handle_pending_pir
+	 * after clearing the outstanding notification bit. Hence, at most
+	 * MAX_POSTED_MSI_COALESCING_LOOP - 1 loops are executed here.
+	 */
+	while (++i < MAX_POSTED_MSI_COALESCING_LOOP) {
+		if (!handle_pending_pir(pid->pir64, regs))
+			break;
+	}
+
+	/*
+	 * Clear outstanding notification bit to allow new IRQ notifications,
+	 * do this last to maximize the window of interrupt coalescing.
+	 */
+	pi_clear_on(pid);
+
+	/*
+	 * There could be a race of PI notification and the clearing of ON bit,
+	 * process PIR bits one last time such that handling the new interrupts
+	 * are not delayed until the next IRQ.
+	 */
+	handle_pending_pir(pid->pir64, regs);
+
+	apic_eoi();
+	irq_exit();
+	set_irq_regs(old_regs);
+}
 #endif /* X86_POSTED_MSI */
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
2.25.1


