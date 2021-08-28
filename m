Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622993FA271
	for <lists+kvm@lfdr.de>; Sat, 28 Aug 2021 02:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhH1AiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 20:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbhH1AiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 20:38:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473B4C0613A3
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u1-20020a25ab01000000b0059949024617so818771ybi.17
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MvwJUHJ7nL7QAZpmwIc3YN3b2GBJgXnzulug8SK2Qjw=;
        b=Rd8GZlOM7483aZ/NulymMp3S9HO5bS1npFsrbHkWVgmtUT7AYmnlfjuL+oAn/+3Dri
         +5cR2ODgibWqpXhDO8BZ5XeMEmoa6kHMNeLnQOJzh9PWAYLTkPF2NgJK5Mby7Cvmotge
         2PyjseoJ7Slvdtb6cq6mgARo7D+wvyYizSBuQjnshLNdziqxPWZnRNLzvpaZZ+ivbpGR
         1gkx3rIpMiVsfiqaiEDc1i/t4zHv55U+FFPE/qx5o8z68VoLNkaUyOM/1xRhzVqRYHrY
         re+Q8PzB8BWoikOAEufy0epFWC9x2ug/ZDxYOVgylgofjF85zivnlpT4bnrEu+QzpLoF
         hYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MvwJUHJ7nL7QAZpmwIc3YN3b2GBJgXnzulug8SK2Qjw=;
        b=i67RS3UaJN0EKQCBPuWsmBE5qqyKRl91S11A8zPDM0+iXS6avyIBIwkO4dAObHqPiQ
         Y7Tbs0LmLKdMxqfFsNWbAVLNDdhkGw/q8SmoewOr88yYBgvuLQwO/uh0bcyjlnmXfqOc
         Je7y/vuPA9lVPmqdSVtItF4WarwyYck2+1+39LLyGW6+tb8uSy/1k/n8ILKLPSIbfxec
         +spMxXLePIPpm753u9wWq4j5Ylnhd3XC918Hw2BjKzGNE8L4GocDMgx2SzUPlxonYIVJ
         silRIh3YjTScV98rb1QG0DMvuEM7ULbxkeazMyRxMqMzoNKzSK+BjsHY/FjCLOddnYLV
         8cEg==
X-Gm-Message-State: AOAM532fuQx7SeJFqky91B+XE0tCiqCClxVLVvg4cZjca4i2Dfwfdr3b
        nPLoJPpiJhLRjb7HI+jMwNpR2ihnX+c=
X-Google-Smtp-Source: ABdhPJyAd60vBQXQHXvEDagnL5C8DqU2H00FG/h0rAqZ+ilMScmE0veBYXU9kzdGqI+AZkskYlaiz8r6ASk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f66c:b851:7e79:7ed4])
 (user=seanjc job=sendgmr) by 2002:a25:9d83:: with SMTP id v3mr8323765ybp.97.1630111014478;
 Fri, 27 Aug 2021 17:36:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Aug 2021 17:35:58 -0700
In-Reply-To: <20210828003558.713983-1-seanjc@google.com>
Message-Id: <20210828003558.713983-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210828003558.713983-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v2 13/13] KVM: arm64: Drop perf.c and fold its tiny bits of
 code into arm.c / pmu.c
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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

Call KVM's (un)register perf callbacks helpers directly from arm.c, and
move the PMU bits into pmu.c and rename the related helper accordingly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ---
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/arm.c              |  6 ++++--
 arch/arm64/kvm/perf.c             | 27 ---------------------------
 arch/arm64/kvm/pmu.c              |  8 ++++++++
 include/kvm/arm_pmu.h             |  1 +
 6 files changed, 14 insertions(+), 33 deletions(-)
 delete mode 100644 arch/arm64/kvm/perf.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 73dc402ded1f..d549b58120bc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -670,9 +670,6 @@ unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu);
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
 
-void kvm_perf_init(void);
-void kvm_perf_teardown(void);
-
 #ifdef CONFIG_PERF_EVENTS
 #define __KVM_WANT_PERF_CALLBACKS
 static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 989bb5dad2c8..0bcc378b7961 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_KVM) += hyp/
 
 kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
-	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
+	 arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2b542fdc237e..48f89d80f464 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1744,7 +1744,9 @@ static int init_subsystems(void)
 	if (err)
 		goto out;
 
-	kvm_perf_init();
+	kvm_pmu_init();
+	kvm_register_perf_callbacks(NULL);
+
 	kvm_sys_reg_table_init();
 
 out:
@@ -2160,7 +2162,7 @@ int kvm_arch_init(void *opaque)
 /* NOP: Compiling as a module not supported */
 void kvm_arch_exit(void)
 {
-	kvm_perf_teardown();
+	kvm_unregister_perf_callbacks();
 }
 
 static int __init early_kvm_mode_cfg(char *arg)
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
deleted file mode 100644
index 0b902e0d5b5d..000000000000
--- a/arch/arm64/kvm/perf.c
+++ /dev/null
@@ -1,27 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Based on the x86 implementation.
- *
- * Copyright (C) 2012 ARM Ltd.
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- */
-
-#include <linux/perf_event.h>
-#include <linux/kvm_host.h>
-
-#include <asm/kvm_emulate.h>
-
-DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
-
-void kvm_perf_init(void)
-{
-	if (kvm_pmu_probe_pmuver() != 0xf && !is_protected_kvm_enabled())
-		static_branch_enable(&kvm_arm_pmu_available);
-
-	kvm_register_perf_callbacks(NULL);
-}
-
-void kvm_perf_teardown(void)
-{
-	kvm_unregister_perf_callbacks();
-}
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 03a6c1f4a09a..d98b57a17043 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -7,6 +7,14 @@
 #include <linux/perf_event.h>
 #include <asm/kvm_hyp.h>
 
+DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
+
+void kvm_pmu_init(void)
+{
+	if (kvm_pmu_probe_pmuver() != 0xf && !is_protected_kvm_enabled())
+		static_branch_enable(&kvm_arm_pmu_available);
+}
+
 /*
  * Given the perf event attributes and system type, determine
  * if we are going to need to switch counters at guest entry/exit.
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 864b9997efb2..42270676498d 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -14,6 +14,7 @@
 #define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
 
 DECLARE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
+void kvm_pmu_init(void);
 
 static __always_inline bool kvm_arm_support_pmu_v3(void)
 {
-- 
2.33.0.259.gc128427fd7-goog

