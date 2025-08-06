Return-Path: <kvm+bounces-54150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB75B1CCD6
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:00:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1EF57ABDFE
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 19:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66DF2D1900;
	Wed,  6 Aug 2025 19:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tbvXitN7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43F42C324E
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510266; cv=none; b=ajXgFG+wDE7J32cuOQMSVkIhny3FdkBGsSeLcOpu02WRRVi2XXX9NXfOyEcSASZtIwd1oapzTRRbcKNKQLAnXsCcGEGjSxyiPgLq8RPfdsrhjdm6hIBh2M2Uzq86S3Zh+j+YAtufuyYETpbMKK6eZnY69I+de7C9gM5QtFf/D8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510266; c=relaxed/simple;
	bh=x4daQrL7sPxb+dEOZVPTgJRHntO3qzWRLtRzDqkfDc8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y6Z7Oaxx3m0S7FK1A6yeAAe01/ZB6g5r072tiVC0uw/JALOWwNu8Lmhr6a5za6ohkz8+rNTl9M2QxRLcTz5RiJyiyYRLEgInQyjqAW2+zwcw3mfO2mQbtG76oct0GmrBzObn3s0dKNQF5v9rm8btSV22xPQ+YsoPCc2SqencgaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tbvXitN7; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74b29ee4f8bso275032b3a.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510263; x=1755115063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Uj/oFQFNyss4LK4I6PYkReCFuQkjKCIa3E/WRuXwHJ0=;
        b=tbvXitN7QUfznltnTOID5SDg3+IBAKVh0RRf/MvRbDSZj6Td3VGdQZNJ4E0axKvuRs
         nenWJNo+3RVUTxak1a2kdjODcYoeZ9KRHZcTLJUuxa0OT5UZM5UN/8vuZ/4uBJi6itBw
         naH9ewvyWFwx49PCPFlMzcCKVFzejaJedXJQeFjXtRSP/6i0x9qQeYNgE3g6aJuS2KYg
         DurTw9D10lseCzotAXKpeXiYucG7+RuLpmC3VsXQ06bG9LZm4+j2erroVFcowfYfMN+6
         +U0Lz/B2Qcbzr44FrZ66IsRwiL2u27HTXtok6AFLhHoBKDDcQ5LP2TYFnDtc9YL5b+Yw
         zsOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510263; x=1755115063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uj/oFQFNyss4LK4I6PYkReCFuQkjKCIa3E/WRuXwHJ0=;
        b=ESXfiIySviR+HFzQurK25xLJzncpNFGzgv0c2A4czXJ4l3aU8Psg6oH7eb2K8Wa4s2
         Y8U6fyAfkvUfimsi9CPUk3EYSGRi6tUlxjdJKShwUSGLriePcvlO17roLmERTMZ8eVwm
         /XZWRIPzNk1xXInhDl/qr1DB7X1Np+yckR2wL5pI+hampAtTL+Nkpo8Up1oo6Ubj/OPs
         ZankiJsV3R27Mg0PFEKjH1uLwaVK8XH3YQLrwDzQhHTWGKXE+x7r2L1gmO/vkf0RCT/t
         fNRVvoIqwB/iWoQrJJOGQxQ/Xh0MZbegQWV5oPDi19nVUlMkQ86iE1HfBsYkBdPW7hZe
         aJQg==
X-Forwarded-Encrypted: i=1; AJvYcCVOW5oMtulcUzvtxGaZYee3emybvmB+qHjf7uhPvkW7ROuqfQ+n5v7b8Yeix9lHoFO6ceo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyosIkY7cUaQ1M1n4BrhxEgMERERPo/8U1WnRZ/abaa/dy9QIGU
	Kf6zvFRvR+cn8NGyU6Vkh9kpmWoiYERaVZRaOaKGbCAlxyUhA2n+xEloXPOmRO20e0yDpcHCJQ6
	TIZN9uw==
X-Google-Smtp-Source: AGHT+IGQB+bLhnxiIawVNn7HfRXPwF1XDhXBfLBplnIbWM9gXArdsZ1WUOqr9MNOZqSoFpP4ppFPeoHjojo=
X-Received: from pfhh8.prod.google.com ([2002:a05:6a00:2308:b0:76b:c5af:cd3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2293:b0:76b:d363:4a3f
 with SMTP id d2e1a72fcca58-76c2af6ace2mr5675237b3a.3.1754510263031; Wed, 06
 Aug 2025 12:57:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:30 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-9-seanjc@google.com>
Subject: [PATCH v5 08/44] perf: core/x86: Register a new vector for handling
 mediated guest PMIs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Wire up system vector 0xf5 for handling PMIs (i.e. interrupts delivered
through the LVTPC) while running KVM guests with a mediated PMU.  Perf
currently delivers all PMIs as NMIs, e.g. so that events that trigger while
IRQs are disabled aren't delayed and generate useless records, but due to
the multiplexing of NMIs throughout the system, correctly identifying NMIs
for a mediated PMU is practically infeasible.

To (greatly) simplify identifying guest mediated PMU PMIs, perf will
switch the CPU's LVTPC between PERF_GUEST_MEDIATED_PMI_VECTOR and NMI when
guest PMU context is loaded/put.  I.e. PMIs that are generated by the CPU
while the guest is active will be identified purely based on the IRQ
vector.

Route the vector through perf, e.g. as opposed to letting KVM attach a
handler directly a la posted interrupt notification vectors, as perf owns
the LVTPC and thus is the rightful owner of PERF_GUEST_MEDIATED_PMI_VECTOR.
Functionally, having KVM directly own the vector would be fine (both KVM
and perf will be completely aware of when a mediated PMU is active), but
would lead to an undesirable split in ownership: perf would be responsible
for installing the vector, but not handling the resulting IRQs.

Add a new perf_guest_info_callbacks hook (and static call) to allow KVM to
register its handler with perf when running guests with mediated PMUs.

Note, because KVM always runs guests with host IRQs enabled, there is no
danger of a PMI being delayed from the guest's perspective due to using a
regular IRQ instead of an NMI.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/entry/entry_fred.c                   |  1 +
 arch/x86/include/asm/hardirq.h                |  3 +++
 arch/x86/include/asm/idtentry.h               |  6 ++++++
 arch/x86/include/asm/irq_vectors.h            |  4 +++-
 arch/x86/kernel/idt.c                         |  3 +++
 arch/x86/kernel/irq.c                         | 19 +++++++++++++++++++
 include/linux/perf_event.h                    |  8 ++++++++
 kernel/events/core.c                          |  9 +++++++--
 .../beauty/arch/x86/include/asm/irq_vectors.h |  3 ++-
 virt/kvm/kvm_main.c                           |  3 +++
 10 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index f004a4dc74c2..d80861a4cd00 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -114,6 +114,7 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
 
 	SYSVEC(IRQ_WORK_VECTOR,			irq_work),
 
+	SYSVEC(PERF_GUEST_MEDIATED_PMI_VECTOR,	perf_guest_mediated_pmi_handler),
 	SYSVEC(POSTED_INTR_VECTOR,		kvm_posted_intr_ipi),
 	SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	kvm_posted_intr_wakeup_ipi),
 	SYSVEC(POSTED_INTR_NESTED_VECTOR,	kvm_posted_intr_nested_ipi),
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index f00c09ffe6a9..f221d001e4ed 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -18,6 +18,9 @@ typedef struct {
 	unsigned int kvm_posted_intr_ipis;
 	unsigned int kvm_posted_intr_wakeup_ipis;
 	unsigned int kvm_posted_intr_nested_ipis;
+#endif
+#ifdef CONFIG_GUEST_PERF_EVENTS
+	unsigned int perf_guest_mediated_pmis;
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index a4ec27c67988..5109c24b3c1c 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -751,6 +751,12 @@ DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested
 # define fred_sysvec_kvm_posted_intr_nested_ipi		NULL
 #endif
 
+# ifdef CONFIG_GUEST_PERF_EVENTS
+DECLARE_IDTENTRY_SYSVEC(PERF_GUEST_MEDIATED_PMI_VECTOR,	sysvec_perf_guest_mediated_pmi_handler);
+#else
+# define fred_sysvec_perf_guest_mediated_pmi_handler	NULL
+#endif
+
 # ifdef CONFIG_X86_POSTED_MSI
 DECLARE_IDTENTRY_SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	sysvec_posted_msi_notification);
 #else
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 47051871b436..85253fc8e384 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -77,7 +77,9 @@
  */
 #define IRQ_WORK_VECTOR			0xf6
 
-/* 0xf5 - unused, was UV_BAU_MESSAGE */
+/* IRQ vector for PMIs when running a guest with a mediated PMU. */
+#define PERF_GUEST_MEDIATED_PMI_VECTOR	0xf5
+
 #define DEFERRED_ERROR_VECTOR		0xf4
 
 /* Vector on which hypervisor callbacks will be delivered */
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index f445bec516a0..260456588756 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -158,6 +158,9 @@ static const __initconst struct idt_data apic_idts[] = {
 	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
 	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
 # endif
+#ifdef CONFIG_GUEST_PERF_EVENTS
+	INTG(PERF_GUEST_MEDIATED_PMI_VECTOR,	asm_sysvec_perf_guest_mediated_pmi_handler),
+#endif
 # ifdef CONFIG_IRQ_WORK
 	INTG(IRQ_WORK_VECTOR,			asm_sysvec_irq_work),
 # endif
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 9ed29ff10e59..70ab066aa4cb 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -191,6 +191,13 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
 	seq_puts(p, "  Posted-interrupt wakeup event\n");
 #endif
+#ifdef CONFIG_GUEST_PERF_EVENTS
+	seq_printf(p, "%*s: ", prec, "VPMI");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ",
+			   irq_stats(j)->perf_guest_mediated_pmis);
+	seq_puts(p, " Perf Guest Mediated PMI\n");
+#endif
 #ifdef CONFIG_X86_POSTED_MSI
 	seq_printf(p, "%*s: ", prec, "PMN");
 	for_each_online_cpu(j)
@@ -315,6 +322,18 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
 }
 #endif
 
+#ifdef CONFIG_GUEST_PERF_EVENTS
+/*
+ * Handler for PERF_GUEST_MEDIATED_PMI_VECTOR.
+ */
+DEFINE_IDTENTRY_SYSVEC(sysvec_perf_guest_mediated_pmi_handler)
+{
+	 apic_eoi();
+	 inc_irq_stat(perf_guest_mediated_pmis);
+	 perf_guest_handle_mediated_pmi();
+}
+#endif
+
 #if IS_ENABLED(CONFIG_KVM)
 static void dummy_handler(void) {}
 static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 42d019d70b42..0c529fbd97e6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1677,6 +1677,8 @@ struct perf_guest_info_callbacks {
 	unsigned int			(*state)(void);
 	unsigned long			(*get_ip)(void);
 	unsigned int			(*handle_intel_pt_intr)(void);
+
+	void				(*handle_mediated_pmi)(void);
 };
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
@@ -1686,6 +1688,7 @@ extern struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 DECLARE_STATIC_CALL(__perf_guest_state, *perf_guest_cbs->state);
 DECLARE_STATIC_CALL(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
 DECLARE_STATIC_CALL(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
+DECLARE_STATIC_CALL(__perf_guest_handle_mediated_pmi, *perf_guest_cbs->handle_mediated_pmi);
 
 static inline unsigned int perf_guest_state(void)
 {
@@ -1702,6 +1705,11 @@ static inline unsigned int perf_guest_handle_intel_pt_intr(void)
 	return static_call(__perf_guest_handle_intel_pt_intr)();
 }
 
+static inline void perf_guest_handle_mediated_pmi(void)
+{
+	static_call(__perf_guest_handle_mediated_pmi)();
+}
+
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 77398b1ad4c5..e1df3c3bfc0d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7607,6 +7607,7 @@ struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
 DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
 DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
+DEFINE_STATIC_CALL_RET0(__perf_guest_handle_mediated_pmi, *perf_guest_cbs->handle_mediated_pmi);
 
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
@@ -7621,6 +7622,10 @@ void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	if (cbs->handle_intel_pt_intr)
 		static_call_update(__perf_guest_handle_intel_pt_intr,
 				   cbs->handle_intel_pt_intr);
+
+	if (cbs->handle_mediated_pmi)
+		static_call_update(__perf_guest_handle_mediated_pmi,
+				   cbs->handle_mediated_pmi);
 }
 EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
 
@@ -7632,8 +7637,8 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	rcu_assign_pointer(perf_guest_cbs, NULL);
 	static_call_update(__perf_guest_state, (void *)&__static_call_return0);
 	static_call_update(__perf_guest_get_ip, (void *)&__static_call_return0);
-	static_call_update(__perf_guest_handle_intel_pt_intr,
-			   (void *)&__static_call_return0);
+	static_call_update(__perf_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
+	static_call_update(__perf_guest_handle_mediated_pmi, (void *)&__static_call_return0);
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
diff --git a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
index 47051871b436..6e1d5b955aae 100644
--- a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
+++ b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
@@ -77,7 +77,8 @@
  */
 #define IRQ_WORK_VECTOR			0xf6
 
-/* 0xf5 - unused, was UV_BAU_MESSAGE */
+#define PERF_GUEST_MEDIATED_PMI_VECTOR	0xf5
+
 #define DEFERRED_ERROR_VECTOR		0xf4
 
 /* Vector on which hypervisor callbacks will be delivered */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..ecafab2e17d9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6426,11 +6426,14 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.state			= kvm_guest_state,
 	.get_ip			= kvm_guest_get_ip,
 	.handle_intel_pt_intr	= NULL,
+	.handle_mediated_pmi	= NULL,
 };
 
 void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void))
 {
 	kvm_guest_cbs.handle_intel_pt_intr = pt_intr_handler;
+	kvm_guest_cbs.handle_mediated_pmi = NULL;
+
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 }
 void kvm_unregister_perf_callbacks(void)
-- 
2.50.1.565.gc32cd1483b-goog


