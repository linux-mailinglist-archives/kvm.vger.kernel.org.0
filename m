Return-Path: <kvm+bounces-7091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E09583D65A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:31:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE48AB20D3C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74FB24A1F;
	Fri, 26 Jan 2024 08:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d/u2KDQK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFFB24A13;
	Fri, 26 Jan 2024 08:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259357; cv=none; b=AT5vE/6+uCnYDcFptXotY4A2a8rO6k6J+0sLX2agnh/2HrdokHpAxVwL2acMEZ+0gjFOjp360l8aukPBKAPuJPqEZ8nTOOt3yo9ovvUHf6BO+Wk4k3yKEzrAef/qDVRCLnIN0YOZz9Lpp5PsHkYZZrPrMNZff2kEBt6AxeMhF6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259357; c=relaxed/simple;
	bh=vQKsd3FKHlP9/WxLnOHpK3oqY7sIOL0lcUsvNFfgQE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O6o8QIShn6itGCX544Sg48vZwq4dPRf1Skd1iHXqDDf+g0Q1fdNRGKgCwqZyVYxQyHBsZE94M+hivgO/nHqrDOL1GucDKitok7s9PMPSeMpKhh0GESeC8fNhrHInDDpj7ujnIVgx1A0U9xj+v5+4JJLNIzLlt2/HLbjnixiscqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d/u2KDQK; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259356; x=1737795356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vQKsd3FKHlP9/WxLnOHpK3oqY7sIOL0lcUsvNFfgQE0=;
  b=d/u2KDQKjFo7OJ4Z0VqSxU6dvk5BTUXIM7VWK9OSERsIVL6vcFgq0ERL
   5nX5Sdn/RA0CAc0Pwke0cMPgQLZOm+WIj/iBt9pw9BdBwJtX5gnoqma0i
   aSss9gH0K1PrHQQbVP0Rxq/bXUbtDVUZtKLsq1J+Cn9KT/Sf90rkCg5oY
   F2tp3gMfQb7/NZmsg1uGzRuKFXEzCDk8pv0lB3EUhdubMVrUldIhb323L
   ec5lOF2BRClFdKnl5GjROdELmrrXKk4oFKyc4CtFId7xYn4oXG3AU8AYs
   fYbhnq1Xumbym3Wpam+j8bc1m+YzeHdTxXlE7Y81gXTOxbHz6DWvRWFK1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792085"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792085"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309830"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309830"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:49 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 04/41] perf: core/x86: Add support to register a new vector for PMI handling
Date: Fri, 26 Jan 2024 16:54:07 +0800
Message-Id: <20240126085444.324918-5-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiong Zhang <xiong.y.zhang@intel.com>

Create a new vector in the host IDT for PMI handling within a passthrough
vPMU implementation. In addition, add a function to allow the registration
of the handler and a function to switch the PMI handler.

This is the preparation work to support KVM passthrough vPMU to handle its
own PMIs without interference from PMI handler of the host PMU.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/hardirq.h           |  1 +
 arch/x86/include/asm/idtentry.h          |  1 +
 arch/x86/include/asm/irq.h               |  1 +
 arch/x86/include/asm/irq_vectors.h       |  2 +-
 arch/x86/kernel/idt.c                    |  1 +
 arch/x86/kernel/irq.c                    | 29 ++++++++++++++++++++++++
 tools/arch/x86/include/asm/irq_vectors.h |  1 +
 7 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 66837b8c67f1..c1e2c1a480bf 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -19,6 +19,7 @@ typedef struct {
 	unsigned int kvm_posted_intr_ipis;
 	unsigned int kvm_posted_intr_wakeup_ipis;
 	unsigned int kvm_posted_intr_nested_ipis;
+	unsigned int kvm_vpmu_pmis;
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 05fd175cec7d..d1b58366bc21 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -675,6 +675,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
+DECLARE_IDTENTRY_SYSVEC(KVM_VPMU_VECTOR,	        sysvec_kvm_vpmu_handler);
 #endif
 
 #if IS_ENABLED(CONFIG_HYPERV)
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 836c170d3087..ee268f42d04a 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -31,6 +31,7 @@ extern void fixup_irqs(void);
 
 #ifdef CONFIG_HAVE_KVM
 extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
+extern void kvm_set_vpmu_handler(void (*handler)(void));
 #endif
 
 extern void (*x86_platform_ipi_callback)(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 3a19904c2db6..120403572307 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -77,7 +77,7 @@
  */
 #define IRQ_WORK_VECTOR			0xf6
 
-/* 0xf5 - unused, was UV_BAU_MESSAGE */
+#define KVM_VPMU_VECTOR			0xf5
 #define DEFERRED_ERROR_VECTOR		0xf4
 
 /* Vector on which hypervisor callbacks will be delivered */
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 8857abc706e4..6944eec251f4 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -157,6 +157,7 @@ static const __initconst struct idt_data apic_idts[] = {
 	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
 	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
 	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
+	INTG(KVM_VPMU_VECTOR,		        asm_sysvec_kvm_vpmu_handler),
 # endif
 # ifdef CONFIG_IRQ_WORK
 	INTG(IRQ_WORK_VECTOR,			asm_sysvec_irq_work),
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 11761c124545..c6cffb34191b 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -181,6 +181,13 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ",
 			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
 	seq_puts(p, "  Posted-interrupt wakeup event\n");
+
+	seq_printf(p, "%*s: ", prec, "VPMU");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ",
+			   irq_stats(j)->kvm_vpmu_pmis);
+	seq_puts(p, " PT PMU PMI\n");
+
 #endif
 	return 0;
 }
@@ -293,6 +300,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
 #ifdef CONFIG_HAVE_KVM
 static void dummy_handler(void) {}
 static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
+static void (*kvm_vpmu_handler)(void) = dummy_handler;
 
 void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
 {
@@ -305,6 +313,17 @@ void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
 }
 EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
 
+void kvm_set_vpmu_handler(void (*handler)(void))
+{
+	if (handler)
+		kvm_vpmu_handler = handler;
+	else {
+		kvm_vpmu_handler = dummy_handler;
+		synchronize_rcu();
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_set_vpmu_handler);
+
 /*
  * Handler for POSTED_INTERRUPT_VECTOR.
  */
@@ -332,6 +351,16 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
 	apic_eoi();
 	inc_irq_stat(kvm_posted_intr_nested_ipis);
 }
+
+/*
+ * Handler for KVM_PT_PMU_VECTOR.
+ */
+DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_vpmu_handler)
+{
+	apic_eoi();
+	inc_irq_stat(kvm_vpmu_pmis);
+	kvm_vpmu_handler();
+}
 #endif
 
 
diff --git a/tools/arch/x86/include/asm/irq_vectors.h b/tools/arch/x86/include/asm/irq_vectors.h
index 3a19904c2db6..3773e60f1af8 100644
--- a/tools/arch/x86/include/asm/irq_vectors.h
+++ b/tools/arch/x86/include/asm/irq_vectors.h
@@ -85,6 +85,7 @@
 
 /* Vector for KVM to deliver posted interrupt IPI */
 #ifdef CONFIG_HAVE_KVM
+#define KVM_VPMU_VECTOR			0xf5
 #define POSTED_INTR_VECTOR		0xf2
 #define POSTED_INTR_WAKEUP_VECTOR	0xf1
 #define POSTED_INTR_NESTED_VECTOR	0xf0
-- 
2.34.1


