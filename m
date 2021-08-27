Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF623F91BE
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 03:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244243AbhH0BAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 21:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244133AbhH0A7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:37 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCADC061146
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:58:01 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id et12-20020a056214176c00b0037279a2ce4cso1610819qvb.13
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2c1oAfv2K1kK887vDwje5mKOKCy671YkzEKzr6O0AXU=;
        b=dPpwJxjFAEvKqBeQTsJ+sGnKoHCUDoZpaVXefCBRLWJYEAXtYCk1jNkAx1AH1WF/eG
         KIy8x+/4sLPr4zdnDE2egBaEDODhNuwDeZz/fiGkGQbMwDhPfxlGMgiZv4nxwzKTONNP
         w48weamcMEaBWOvZvU5f0I92nygzL+xaBLQUBWTiwbOYY93Mwf2WxDnJ3W/MWHuZSFBN
         ySHOeq9MvFBM04dVoDNrkz77+gPtaH+dN9os6JcQtf1EK0v/gyWblqEXuz9BFALfpRnH
         6isQHkETZn28aDBmE0AV+m14demqlHfQTlvzBRY5XUHPrqkELuVFpgUnkCWViVAkwntu
         hboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2c1oAfv2K1kK887vDwje5mKOKCy671YkzEKzr6O0AXU=;
        b=YRZPgodpY0LEOsfAn9hFyRjuMfl1rT4Q6eHwAIS1YJtDj5yc3ZdKa6qPD41WAOiuUk
         MjARSrpZiMTXkhx/nP3ZYdhFmYDG2XVdnNgCtePBjk4HLgKr/rAI4jQKTEXFzxAss0mU
         PJCONHY2ZwCuzkrGGkxlR9QSNjT1zH5WQHv2p9KrMAR1pQam1/au4eoH8yQgiyzFl0fh
         QwvdsIymMwD0+J9H2mY5a/Q6xXlyF9ApGxikVkudsQDqyAouJB6Yak2pIMTH5GRRMuBq
         qRt9HhDuNGFJ25PQFxrwISwrOLLxEVzddM628wXT3OHUJ2DCRPPwuBHZqYjkxBnIBqhN
         WY9g==
X-Gm-Message-State: AOAM530C3k6f/Z0+1OcDHwPVrqMjmt4dWiLsKyOuokDsip5A9l+bGApp
        vOws1ISt95BKus7+udvHyZQ8/Kh8aj4=
X-Google-Smtp-Source: ABdhPJyRfoK4Sj+uUxToLmh3g94becc3It6jH8S/y/rUNMio/2OXitmqg6SKQMU8b0uN77qihKZhErMmOqs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a0c:aa55:: with SMTP id e21mr7179445qvb.41.1630025880952;
 Thu, 26 Aug 2021 17:58:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 Aug 2021 17:57:17 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 14/15] perf: Disallow bulk unregistering of guest callbacks
 and do cleanup
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the helper that allows bulk unregistering of the per-CPU callbacks
now that KVM, the only entity that actually unregisters callbacks, uses
the per-CPU helpers.  Bulk unregistering is inherently unsafe as there
are no protections against nullifying a pointer for a CPU that is using
said pointer in a PMI handler.

Opportunistically tweak names to better reflect reality.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/xen/pmu.c         |  2 +-
 include/linux/kvm_host.h   |  2 +-
 include/linux/perf_event.h |  9 +++------
 kernel/events/core.c       | 31 +++++++++++--------------------
 virt/kvm/kvm_main.c        |  2 +-
 5 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index e13b0b49fcdf..57834de043c3 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -548,7 +548,7 @@ void xen_pmu_init(int cpu)
 	per_cpu(xenpmu_shared, cpu).flags = 0;
 
 	if (cpu == 0) {
-		perf_register_guest_info_callbacks(&xen_guest_cbs);
+		perf_register_guest_info_callbacks_all_cpus(&xen_guest_cbs);
 		xen_pmu_arch_init();
 	}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0db9af0b628c..d68a49d5fc53 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1171,7 +1171,7 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
 void kvm_register_perf_callbacks(void);
 static inline void kvm_unregister_perf_callbacks(void)
 {
-	__perf_unregister_guest_info_callbacks();
+	perf_unregister_guest_info_callbacks();
 }
 #endif
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7a367bf1b78d..db701409a62f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1238,10 +1238,9 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
 
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
 DECLARE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
-extern void __perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
-extern void __perf_unregister_guest_info_callbacks(void);
-extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
+extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(void);
+extern void perf_register_guest_info_callbacks_all_cpus(struct perf_guest_info_callbacks *cbs);
 #endif /* CONFIG_HAVE_GUEST_PERF_EVENTS */
 
 extern void perf_event_exec(void);
@@ -1486,9 +1485,7 @@ static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
-static inline void perf_register_guest_info_callbacks
-(struct perf_guest_info_callbacks *callbacks)				{ }
-static inline void perf_unregister_guest_info_callbacks(void)		{ }
+extern void perf_register_guest_info_callbacks_all_cpus(struct perf_guest_info_callbacks *cbs);
 #endif
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2f28d9d8dc94..f1964096c4c2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6485,35 +6485,26 @@ static void perf_pending_event(struct irq_work *entry)
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
 DEFINE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
 
-void __perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
-{
-	__this_cpu_write(perf_guest_cbs, cbs);
-}
-EXPORT_SYMBOL_GPL(__perf_register_guest_info_callbacks);
-
-void __perf_unregister_guest_info_callbacks(void)
-{
-	__this_cpu_write(perf_guest_cbs, NULL);
-}
-EXPORT_SYMBOL_GPL(__perf_unregister_guest_info_callbacks);
-
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		per_cpu(perf_guest_cbs, cpu) = cbs;
+	__this_cpu_write(perf_guest_cbs, cbs);
 }
 EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
 
 void perf_unregister_guest_info_callbacks(void)
 {
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		per_cpu(perf_guest_cbs, cpu) = NULL;
+	__this_cpu_write(perf_guest_cbs, NULL);
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
+
+void perf_register_guest_info_callbacks_all_cpus(struct perf_guest_info_callbacks *cbs)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(perf_guest_cbs, cpu) = cbs;
+}
+EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks_all_cpus);
 #endif
 
 static void
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e0b1c9386926..1bcc3eab510b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5502,7 +5502,7 @@ EXPORT_SYMBOL_GPL(kvm_set_intel_pt_intr_handler);
 
 void kvm_register_perf_callbacks(void)
 {
-	__perf_register_guest_info_callbacks(&kvm_guest_cbs);
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 }
 EXPORT_SYMBOL_GPL(kvm_register_perf_callbacks);
 #endif
-- 
2.33.0.259.gc128427fd7-goog

