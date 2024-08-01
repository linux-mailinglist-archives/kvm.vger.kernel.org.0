Return-Path: <kvm+bounces-22845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A606944259
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EE6A1C22488
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CFB1422DE;
	Thu,  1 Aug 2024 04:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EBQvuhYE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151F614885B
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488375; cv=none; b=UmciHKPLfvL/WYJOrXLlHUHkKEMsCfVpzpDmb5LJnh8di141OeG2CGWOB2n5gnFgHKkVlLKYB4XUsOsxJ5PJ30xcHxzk3s3R8dE2hcS04mS7y41A6mZC6xWm9hwPbfje40tIyLdWbhY8A/ntcA+OPY0TEOjdrniLk31agTCBx1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488375; c=relaxed/simple;
	bh=rqzRetFhlSPkAjMKC/ToO5qCQVBnIVY/hV21gk6XRpE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JrbzKlWYC6eYdoXEDcXyz6mmEtC5qCMIH1sSAbQvUwdvL4oYgfCLhd7GeuGqkeosM2TwDuvh1zg5OXzs7Q1lzzC3bbqE2wmkcrsqlCRI8UvTPjijQ8b5V+8suw6WxU5j55TuryQ20xw5m9gV+p854JvRBJzx6SQtuDDbKRKutk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EBQvuhYE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc52d3c76eso60606935ad.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488373; x=1723093173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q8fJNbHfJJMZMWvZ8/ilEbDnuyOnCJRnwYPgtX9B8zU=;
        b=EBQvuhYEF2hLBwB9p0dZU+vCewr6r82B4c16txNDNUXdzlZEFk5TsJ8Hq0qzg4axbY
         Et3/eL+K1o1Jukuoh7GpVKeuOvPPz9c8MU8QH0X4hXSN1DO2Dg0tcpUKlw3+VZ1m9CM5
         bWBiZboaGcm+vZawyJ/77Qd1jnj3oyH/3s+Vc4QW5Wft5YyZzKDClvN2yYWmaSQhd7Ii
         URMQg+7o052WPFXJGEyVcqEkgn7msghLC1aIxnm8Z2b3YbZXPRI46uPmC2Wx/+Kt3u9f
         TSOSaZZARCwbdmwUuHoPKZzr876aPwgKvbyNT0OYJJyUoO2RXrWT4sihYpqYiawV6rXv
         SMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488373; x=1723093173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q8fJNbHfJJMZMWvZ8/ilEbDnuyOnCJRnwYPgtX9B8zU=;
        b=Z21TRmuGKwjed7GQNTTBtVuV1fQ66Xp7JsTvuUutbyBC7fC1KY7AEQQR6w9Zr0vpfu
         FlZy16GGBct1puD8kneHEP6NvVWz4dMUbiMzlmQKqzGGUcGLEX+iTl0c4Uk1R4nSIUl+
         qqsO0SCCv8IrOVOG5xsobG7zF/BmlUd3dhZ6u8baxx2OUpDNLkH9SfVP7NrVAmgqiN14
         EJjESrpVyXEe4q1+L+aI6n/5Bopn3VgVW8Ejm3U+Cr48o5qQC94Px/wp1cueeJV2zN1n
         Q9D+j01wpjLRghGX8wtcjZOLFbkI6QWELbhGetaVhTlsUBoj8b2NvfaJcX63j8nTMkzG
         vILA==
X-Forwarded-Encrypted: i=1; AJvYcCVYF4QBgfpTE1sPo/2yJY6Cniw3fertZf4N3fVCfQ0A1bk5ltvmIZNOaXoV2Zl3jR0hVS3gCyAfN9ZFmeCTMmYSHzR5
X-Gm-Message-State: AOJu0YwKQXghkMzju8s+M+gFYxf2VGwEbSTAE0uuCT1zfdZrETXSdtGn
	hfVL2dDN3gH813fzs8TmAYt0Q5oFRZwFa2+W4/MlK9d7d8NpyrsWrZ0VVEfXV4mQBy3uXHTUZGq
	HBjWOxQ==
X-Google-Smtp-Source: AGHT+IH5q/6b1ijF1gNpeziEBYhuxhp9BV0CkRuIrN05ArJLU9odNox6SNQDBwusFWLqlSvpRCQsofQEqZle
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:902:bb89:b0:1fe:d72d:13bc with SMTP id
 d9443c01a7336-1ff4ce87265mr738715ad.5.1722488373141; Wed, 31 Jul 2024
 21:59:33 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:21 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-13-mizhang@google.com>
Subject: [RFC PATCH v3 12/58] perf: core/x86: Register a new vector for KVM
 GUEST PMI
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

Create a new vector in the host IDT for kvm guest PMI handling within
mediated passthrough vPMU. In addition, guest PMI handler registration
is added into x86_set_kvm_irq_handler().

This is the preparation work to support mediated passthrough vPMU to
handle kvm guest PMIs without interference from PMI handler of the host
PMU.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/hardirq.h                |  1 +
 arch/x86/include/asm/idtentry.h               |  1 +
 arch/x86/include/asm/irq_vectors.h            |  5 ++++-
 arch/x86/kernel/idt.c                         |  1 +
 arch/x86/kernel/irq.c                         | 21 +++++++++++++++++++
 .../beauty/arch/x86/include/asm/irq_vectors.h |  5 ++++-
 6 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index c67fa6ad098a..42a396763c8d 100644
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
index d4f24499b256..7b1e3e542b1d 100644
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
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 13aea8fc3d45..ada270e6f5cb 100644
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
index f445bec516a0..0bec4c7e2308 100644
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
index 18cd418fe106..b29714e23fc4 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -183,6 +183,12 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ",
 			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
 	seq_puts(p, "  Posted-interrupt wakeup event\n");
+
+	seq_printf(p, "%*s: ", prec, "VPMU");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ",
+			   irq_stats(j)->kvm_guest_pmis);
+	seq_puts(p, " KVM GUEST PMI\n");
 #endif
 #ifdef CONFIG_X86_POSTED_MSI
 	seq_printf(p, "%*s: ", prec, "PMN");
@@ -311,6 +317,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
 #if IS_ENABLED(CONFIG_KVM)
 static void dummy_handler(void) {}
 static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
+static void (*kvm_guest_pmi_handler)(void) = dummy_handler;
 
 void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
 {
@@ -321,6 +328,10 @@ void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
 	    (handler == dummy_handler ||
 	     kvm_posted_intr_wakeup_handler == dummy_handler))
 		kvm_posted_intr_wakeup_handler = handler;
+	else if (vector == KVM_GUEST_PMI_VECTOR &&
+		 (handler == dummy_handler ||
+		  kvm_guest_pmi_handler == dummy_handler))
+		kvm_guest_pmi_handler = handler;
 	else
 		WARN_ON_ONCE(1);
 
@@ -356,6 +367,16 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
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
 
 #ifdef CONFIG_X86_POSTED_MSI
diff --git a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
index 13aea8fc3d45..670dcee46631 100644
--- a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
+++ b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
@@ -77,7 +77,10 @@
  */
 #define IRQ_WORK_VECTOR			0xf6
 
-/* 0xf5 - unused, was UV_BAU_MESSAGE */
+#if IS_ENABLED(CONFIG_KVM)
+#define KVM_GUEST_PMI_VECTOR           0xf5
+#endif
+
 #define DEFERRED_ERROR_VECTOR		0xf4
 
 /* Vector on which hypervisor callbacks will be delivered */
-- 
2.46.0.rc1.232.g9752f9e123-goog


