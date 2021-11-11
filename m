Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566A944CFB3
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 03:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbhKKCLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 21:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbhKKCKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 21:10:45 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED2EC06122B
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 18:07:54 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso2075217pjb.2
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 18:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Qts44yZaW6qsc605OlT7Zz8eai+zBrqGoLbFoG4wiuw=;
        b=Zfi8DY3ovwoiH8lfWrxLb/W+rRSaGWbn2rFa446dfUQXHgUbfdUKYMOyW1lpuH1MR+
         xW8LXXYpKTlc7ug96G/Ee8ToPnPuFjZ6+ZvcCvMBWtEmqhdQ3/vNbJyBdjGJwYQJnBZp
         eg5ocwliNalXx19wDw7gg6hx7kfIvpSxscV8PzvnOb5EfIXw0M0nS4wd8cy4vSyQ7D8r
         47B+6iKMQq7yLKce9j9o6wFmrE8KChMVlSCYvT0NoUscJKcLP0B0byJ9BhCQP5AmwJDt
         Xn99jo+MhAsbr7g8NKvRMpjQUhyAw5fqNt4uJCKa9oaEyT74/pPuTXuqJFQjVL14748I
         xNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Qts44yZaW6qsc605OlT7Zz8eai+zBrqGoLbFoG4wiuw=;
        b=kk8tg6lwpLUf+n4/3/P3KjqXoCiaoGoRn9mios7CrG7KD9KTwwXltQMRn5Czi1+EN9
         UhHpgJY6O5MK35dzURG46ROsdFv/he1G+LchYXa6/KZ7UwmvxxEXJCOcmwa14cBmpn3f
         K28FRwo8atKu22SjdTzclC+u8P8fjGlnvWnr8NGp2proiooVaufLSjRmUrK4z75Vv9oz
         vTKsFefkumWiSegkW97pT7s3SloiSaYJ7Plzv60tWw+hk8Gc9zgUJcWm0mb0d3dYmMwp
         7eND5luAQpg4U0TSnb/a7iC4HftzuMAicD9MrE3PB5N9KXp5Hr+ymaIVcR7O3cqvJp2n
         1Ryg==
X-Gm-Message-State: AOAM532s/SRrkUzg7wOmPs2rJew6qHeIzCt8xwac4YE2jQ0FWMpeUE1v
        0+Uc1U/i+Q6Puk693mWO1KnukGLjolc=
X-Google-Smtp-Source: ABdhPJzzaoFWeNToP2f/V/MLS8kOItNfusQJva0ujL0AlnvrfyJ7uCasThKDANgj3halkP9yaN2IQPCiXvk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8544:b0:142:66e7:afbb with SMTP id
 d4-20020a170902854400b0014266e7afbbmr3818315plo.62.1636596474245; Wed, 10 Nov
 2021 18:07:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Nov 2021 02:07:29 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 08/17] perf: Force architectures to opt-in to guest callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
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
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce GUEST_PERF_EVENTS and require architectures to select it to
allow registering and using guest callbacks in perf.  This will hopefully
make it more difficult for new architectures to add useless "support" for
guest callbacks, e.g. via copy+paste.

Stubbing out the helpers has the happy bonus of avoiding a load of
perf_guest_cbs when GUEST_PERF_EVENTS=n on arm64/x86.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/Kconfig     | 1 +
 arch/x86/kvm/Kconfig       | 1 +
 arch/x86/xen/Kconfig       | 1 +
 include/linux/perf_event.h | 6 ++++++
 init/Kconfig               | 4 ++++
 kernel/events/core.c       | 2 ++
 6 files changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8ffcbe29395e..e9761d84f982 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ menuconfig KVM
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
+	select GUEST_PERF_EVENTS if PERF_EVENTS
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 619186138176..47bdbe705a76 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -36,6 +36,7 @@ config KVM
 	select KVM_MMIO
 	select SCHED_INFO
 	select PERF_EVENTS
+	select GUEST_PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_NO_POLL
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 6bcd3d8ca6ac..85246dd9faa1 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -23,6 +23,7 @@ config XEN_PV
 	select PARAVIRT_XXL
 	select XEN_HAVE_PVMMU
 	select XEN_HAVE_VPMU
+	select GUEST_PERF_EVENTS
 	help
 	  Support running as a Xen PV guest.
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 346d5aff5804..ea47ef616ee0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1242,6 +1242,7 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
 				 enum perf_bpf_event_type type,
 				 u16 flags);
 
+#ifdef CONFIG_GUEST_PERF_EVENTS
 extern struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
 {
@@ -1280,6 +1281,11 @@ static inline unsigned int perf_guest_handle_intel_pt_intr(void)
 }
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
+#else
+static inline unsigned int perf_guest_state(void)		 { return 0; }
+static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
+static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
+#endif /* CONFIG_GUEST_PERF_EVENTS */
 
 extern void perf_event_exec(void);
 extern void perf_event_comm(struct task_struct *tsk, bool exec);
diff --git a/init/Kconfig b/init/Kconfig
index 21b1f4870c80..6bc5c56d669b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1799,6 +1799,10 @@ config HAVE_PERF_EVENTS
 	help
 	  See tools/perf/design.txt for details.
 
+config GUEST_PERF_EVENTS
+	bool
+	depends on HAVE_PERF_EVENTS
+
 config PERF_USE_VMALLOC
 	bool
 	help
diff --git a/kernel/events/core.c b/kernel/events/core.c
index eb6b9cfd0054..1c8d341ecc77 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6521,6 +6521,7 @@ static void perf_pending_event(struct irq_work *entry)
 		perf_swevent_put_recursion_context(rctx);
 }
 
+#ifdef CONFIG_GUEST_PERF_EVENTS
 struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
@@ -6541,6 +6542,7 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
+#endif
 
 static void
 perf_output_sample_regs(struct perf_output_handle *handle,
-- 
2.34.0.rc0.344.g81b53c2807-goog

