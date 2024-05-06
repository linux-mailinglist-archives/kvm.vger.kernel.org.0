Return-Path: <kvm+bounces-16621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F234F8BC6D1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AD351F21AE1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03B8140399;
	Mon,  6 May 2024 05:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZIGEOlmU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9478313FD98
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973446; cv=none; b=J3hsoOlcx55ySBUfsNi9fziUZDYN+WJLuSeYGbW+B1693PKkpYUxK+8f21RYbZ9+fAfb4y1cjSmMWWpamf2+Q1OaMaVfEBPkfo9HFbSpbGOvpUWI7x/cjhZZ3F8tGgfB5QzWeiNFxE/oFDG0S2Wc3it9nMB7yAseLtlt6ifTBzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973446; c=relaxed/simple;
	bh=3eX3VyySWAw1WvA4qdIWs/df9NXPmMQcgKOCd/aJXFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YjW4AhfURkyrjmBVYFoHGwdBr1cPj8hNKdJVHW8v/8wNBPqBVjpEoqUZNKEGxK/5uyu0yAJcvWBgoDyrjIjYTWuyfByLGJ2YkOWJNRQ0Jo6Sq5KbFog69r6wNNtd7K2F+nuvscJKnQujiumhPqz5lQcOg0Dfas4UPH3hw8dKGAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZIGEOlmU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ecb7e1e3fdso11426545ad.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973444; x=1715578244; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+qVocCNRxID+ECg1hdt+QOGCg5ymWfe+UO5mPTRN4Fs=;
        b=ZIGEOlmUeSJtcsI5gps1UG+MEYBJJrk9X/dijPwlTEjiYjaFzWCVrD70CDa0bF7dbz
         BAiTR0Qvz/baCXeRSe9xmkHFYQNc+y7NM52WZ1OtyQ7QkHNUZ4GNcQF379wLPuFamsHf
         ou0Marc8zn997vKX+PTGBtaO9kC5bvr6F2xd0IguzpmBX+4y666MV79vlec66pG1dRuQ
         Jftho9dt9WiB3DsxERNpfDrMuLX3ECZ++h7S1Eu66lIVH+TECau1fln4FdhDUnLtY4U8
         P80BttAyCWt2L1SYVoCoK1pVUWGmMfEF22opu3VlA7gndbMWHHsDbMnIR07XU0EeWkq1
         tRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973444; x=1715578244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+qVocCNRxID+ECg1hdt+QOGCg5ymWfe+UO5mPTRN4Fs=;
        b=NRNRdBJu2YbhF7z2Xe/vx0P79LsuYfmBIOlnqtLQkpr0a4Rr53tbLFuLdmS0gI2hBO
         dnsvzCpjtH4NIApi6dCnpy4BCgKq3TifOmvXQ4Gb9i2zQI4jUq2bwkmEksP3FMztqZi7
         s6LlkpLBuGuNkJ41dCls1IbN5qpUCLlBdlOx9bagnC20zq0cT22qdQ9Z+2OWZ6mqtiX/
         w6OhX+w5oYRsh+FvzMED/OEkWfa0frD0dYhRS9QIoHF2CnBeR4uZn6oY5t/D0X/mW8NL
         iyV0L/cWc7q61laLFfoxDyoyiET8FW61juZJIGfRDkjWboUA0t7G44j3IPeI/HMe8bGc
         Jnug==
X-Forwarded-Encrypted: i=1; AJvYcCV/v3t24YYoN42Ef4dOOJm352Ekg/hPzMeE2g4rOFGx+6NpCIbZ24dzrn1gMZ0eBjy1V6ms3RL9xwhATbvELK5E1n5v
X-Gm-Message-State: AOJu0YzqjroHs2UpaSZNDbR1Vl5busCAK5qgZ0DUBcfKyustOcBk/zA3
	KA22V/ir6xZOYTdLpVAPIjd0IjwssVsqsn+AuGC6+zscoI2ml/E8YRX8y4KoWtq+GQF+Q7OxXPm
	AIMDBwQ==
X-Google-Smtp-Source: AGHT+IGYG2BIn2FDDVqFXZ2gEZWUBnpOLUKF5Y1uMIf3oCrg9wSpqpnpmIe2h3AzhmgqwbJA5v3mHY7Hbogv
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:902:d4c8:b0:1eb:5ef3:6695 with SMTP id
 o8-20020a170902d4c800b001eb5ef36695mr443848plg.3.1714973443729; Sun, 05 May
 2024 22:30:43 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:34 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-10-mizhang@google.com>
Subject: [PATCH v2 09/54] perf: core/x86: Register a new vector for KVM GUEST PMI
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

Create a new vector in the host IDT for kvm guest PMI handling within
passthrough PMU. In addition, add a function to allow kvm register the new
vector's handler.

This is the preparation work to support passthrough PMU to handle kvm guest
PMIs without interference from PMI handler of the host PMU.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/hardirq.h           |  1 +
 arch/x86/include/asm/idtentry.h          |  1 +
 arch/x86/include/asm/irq.h               |  1 +
 arch/x86/include/asm/irq_vectors.h       |  5 +++-
 arch/x86/kernel/idt.c                    |  1 +
 arch/x86/kernel/irq.c                    | 29 ++++++++++++++++++++++++
 tools/arch/x86/include/asm/irq_vectors.h |  3 ++-
 7 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index fbc7722b87d1..250e6db1cb5f 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -19,6 +19,7 @@ typedef struct {
 	unsigned int kvm_posted_intr_ipis;
 	unsigned int kvm_posted_intr_wakeup_ipis;
 	unsigned int kvm_posted_intr_nested_ipis;
+	unsigned int kvm_guest_pmis;
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 749c7411d2f1..4090aea47b76 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -745,6 +745,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
+DECLARE_IDTENTRY_SYSVEC(KVM_GUEST_PMI_VECTOR,	        sysvec_kvm_guest_pmi_handler);
 #else
 # define fred_sysvec_kvm_posted_intr_ipi		NULL
 # define fred_sysvec_kvm_posted_intr_wakeup_ipi		NULL
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 194dfff84cb1..2483f6ef5d4e 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -31,6 +31,7 @@ extern void fixup_irqs(void);
 
 #if IS_ENABLED(CONFIG_KVM)
 extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
+void kvm_set_guest_pmi_handler(void (*handler)(void));
 #endif
 
 extern void (*x86_platform_ipi_callback)(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index d18bfb238f66..e5f741bb1557 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -77,7 +77,10 @@
  */
 #define IRQ_WORK_VECTOR			0xf6
 
-/* 0xf5 - unused, was UV_BAU_MESSAGE */
+#if IS_ENABLED(CONFIG_KVM)
+#define KVM_GUEST_PMI_VECTOR		0xf5
+#endif
+
 #define DEFERRED_ERROR_VECTOR		0xf4
 
 /* Vector on which hypervisor callbacks will be delivered */
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index fc37c8d83daf..c62368a3ba04 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -157,6 +157,7 @@ static const __initconst struct idt_data apic_idts[] = {
 	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
 	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
 	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
+	INTG(KVM_GUEST_PMI_VECTOR,		asm_sysvec_kvm_guest_pmi_handler),
 # endif
 # ifdef CONFIG_IRQ_WORK
 	INTG(IRQ_WORK_VECTOR,			asm_sysvec_irq_work),
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 35fde0107901..22c10e5c50af 100644
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
+			   irq_stats(j)->kvm_guest_pmis);
+	seq_puts(p, " KVM GUEST PMI\n");
+
 #endif
 	return 0;
 }
@@ -293,6 +300,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
 #if IS_ENABLED(CONFIG_KVM)
 static void dummy_handler(void) {}
 static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
+static void (*kvm_guest_pmi_handler)(void) = dummy_handler;
 
 void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
 {
@@ -305,6 +313,17 @@ void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
 }
 EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
 
+void kvm_set_guest_pmi_handler(void (*handler)(void))
+{
+	if (handler) {
+		kvm_guest_pmi_handler = handler;
+	} else {
+		kvm_guest_pmi_handler = dummy_handler;
+		synchronize_rcu();
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_set_guest_pmi_handler);
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
+ * Handler for KVM_GUEST_PMI_VECTOR.
+ */
+DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_guest_pmi_handler)
+{
+	apic_eoi();
+	inc_irq_stat(kvm_guest_pmis);
+	kvm_guest_pmi_handler();
+}
 #endif
 
 
diff --git a/tools/arch/x86/include/asm/irq_vectors.h b/tools/arch/x86/include/asm/irq_vectors.h
index 3f73ac3ed3a0..6df2a986805d 100644
--- a/tools/arch/x86/include/asm/irq_vectors.h
+++ b/tools/arch/x86/include/asm/irq_vectors.h
@@ -83,8 +83,9 @@
 /* Vector on which hypervisor callbacks will be delivered */
 #define HYPERVISOR_CALLBACK_VECTOR	0xf3
 
-/* Vector for KVM to deliver posted interrupt IPI */
 #if IS_ENABLED(CONFIG_KVM)
+#define KVM_GUEST_PMI_VECTOR		0xf5
+/* Vector for KVM to deliver posted interrupt IPI */
 #define POSTED_INTR_VECTOR		0xf2
 #define POSTED_INTR_WAKEUP_VECTOR	0xf1
 #define POSTED_INTR_NESTED_VECTOR	0xf0
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


