Return-Path: <kvm+bounces-7252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8B883E711
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:39:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 849C928992F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12378605C9;
	Fri, 26 Jan 2024 23:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQZILzcH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7895BAF0;
	Fri, 26 Jan 2024 23:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312250; cv=none; b=n+ky2Vm3xPMwXddbTAh1RktdzhhSZj3TtK+JokHC7qH9l5VkAlREpd3RjYKWPTHnda+jn5dwaqqMVGGxnuXcAOPL6WBJny8D4ohu3NEU8JvfcPEaklH25u6/U5SR+BiM/JC/OZPVIIb96ZNyuiNvmOeX7MtP0cTTc1JoqqWtXTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312250; c=relaxed/simple;
	bh=h4lxSMKyQxlseu4S2RwYjNDhOv7kmbRScOIMsH8Mhyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dOYfKmAEiiRKlJNpd3qwDlbo39a3Yq0uBFiB45BTZEJgochiv/hqprIrP3T4a8J5xQmh/XSa9PAxvi9we3P8oMs6WBo86tn2nufJUYHnRRuQB4x6EBErwAxC4y5qSwTtmwA0vKIEhd4A7UtOMlbY3fp08JafWK+DpwlPNKRU0wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQZILzcH; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312248; x=1737848248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h4lxSMKyQxlseu4S2RwYjNDhOv7kmbRScOIMsH8Mhyk=;
  b=SQZILzcHIc8BBqlyYbjGWRfEsRuWoimeBxIZvOtLAYAwHjAH+X/uckWn
   kCPQHW5h2Cfhifpx89GQ2y7jpIJ6vnNiBVnqeDmBjN1YvA89jqfulf0B7
   MmLKuDCpU/zWWNOZZdX1Q5l85I3QDfu89qt0XStEQh8dFFea/7e+alnrv
   EboBZeMZrt+eJsQXVkA/DbYw1HCYrobaC3IXHEJwEkBn6rs8eWC6fKJ76
   JeW7Eg5BjJy+CwTBJn71/XiGWEXfmjC6mSpu/ebXyfxgx622FTkiA94w9
   3skfK5WmBLmq6t7xmBSdSOQyoaLDdmz+qwOWP6dJvJ5X6e+yTX5BYPrqp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990739"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990739"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290739"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290739"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2024 15:37:21 -0800
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
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 09/15] x86/irq: Install posted MSI notification handler
Date: Fri, 26 Jan 2024 15:42:31 -0800
Message-Id: <20240126234237.547278-10-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
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
 arch/x86/include/asm/hardirq.h  |   3 +
 arch/x86/include/asm/idtentry.h |   3 +
 arch/x86/kernel/idt.c           |   3 +
 arch/x86/kernel/irq.c           | 112 ++++++++++++++++++++++++++++++++
 4 files changed, 121 insertions(+)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 72c6a084dba3..6c8daa7518eb 100644
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
index 13639e57e1f8..83d4de75df34 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -648,6 +648,9 @@ DECLARE_IDTENTRY_SYSVEC(ERROR_APIC_VECTOR,		sysvec_error_interrupt);
 DECLARE_IDTENTRY_SYSVEC(SPURIOUS_APIC_VECTOR,		sysvec_spurious_apic_interrupt);
 DECLARE_IDTENTRY_SYSVEC(LOCAL_TIMER_VECTOR,		sysvec_apic_timer_interrupt);
 DECLARE_IDTENTRY_SYSVEC(X86_PLATFORM_IPI_VECTOR,	sysvec_x86_platform_ipi);
+# ifdef CONFIG_X86_POSTED_MSI
+DECLARE_IDTENTRY_SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	sysvec_posted_msi_notification);
+# endif
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 660b601f1d6c..061a927367ec 100644
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
index 1a1762baf85f..54ddf148f1ed 100644
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
@@ -353,6 +360,111 @@ void intel_posted_msi_init(void)
 	pid->nv = POSTED_MSI_NOTIFICATION_VECTOR;
 	pid->ndst = this_cpu_read(x86_cpu_to_apicid);
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
+static __always_inline inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
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
+		pir_copy[i] = arch_xchg(pir, 0);
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
+	pid = this_cpu_ptr(&posted_interrupt_desc);
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
 }
 #endif /* X86_POSTED_MSI */
 
-- 
2.25.1


