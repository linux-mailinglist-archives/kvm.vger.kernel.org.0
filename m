Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95AA36DFB6
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 21:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbhD1TjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 15:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241841AbhD1Ti6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 15:38:58 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E22C06138D
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:38:08 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id p2-20020ad452e20000b0290177fba4b9d5so28934526qvu.6
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Xmnri5WQ2+orpUoy8Yah+jBeLizzxPOC9TaH0yNsUEw=;
        b=oUpZGl/Vd2qkyf4SEL16T8TOpKEn5WhjXx4VgQpa0lSAh9RnrVFX6/2Imp5MadfmY5
         1+VzIv5fC88MCSeyRjIc3T1M6SS80CR4qys0B6+MC5eN/YViCPyMVix1ipyDoh7zdOmu
         Vlz11OlwUpHnSBi5+7GZOOuBr259U6xnle8I/FXd43fuYu4zx+4RnttJHuhowMMMovMV
         +CH0346wj3qt9NQolRPCggW8BNYhgge1e8Cj4Gp7xS3KV1iZmbOQGYJVjWmYjnModCvc
         XpDbwO+U9EjhNfN3LadxEY92OYMKdG2BAZR/V//v94Ui5DdMLjRzwn8cBtY1VhPbhsOl
         4mrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Xmnri5WQ2+orpUoy8Yah+jBeLizzxPOC9TaH0yNsUEw=;
        b=SDXiwp4vHeDGwLmTA/I50PSLkzcl/8pCOnIzkjEQHT35Sej7J/3hF1VIpfUGoONELj
         3bMgTQ3AWr7MNxdmpWDRY4FbWeFjjc9Xguy8mjBs7XOEgKoqtdkRPPliDgbQWueBOkhM
         pJHzQYM5TY4+Xvhsw856qAtnk7EH4J2I4PaUb38aSrEwGk31bph5eWMvI/NrFayvow5P
         vF7CR0ZaejlNXOKnCsaficJKxslJX3yIv3CBRQiK2D263utMRNhowKCGnrFM9v9QctOh
         E1Z2JRhUmLURxZ2BjW/gZxVWaCWZfYbV15Ehtgzl3mBIrIddEmeGDSwK8613ZJRLpV9b
         LI7A==
X-Gm-Message-State: AOAM530PYurTL1XwnFiidYsrr0tWd1c+zmCZUNc5TBVhqWbely55IbtW
        4lgR6ivp0l+Dlm6k93XHELiqPrSP9baAGA==
X-Google-Smtp-Source: ABdhPJyHfYEnIMTt5sC77fB90YETDOON4FUQfvWdf6od6TH9hQ03ldd2gzkcG2ATyN/FvIqgivRA84an1WMgIw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:258d:: with SMTP id
 fq13mr9099903qvb.50.1619638687593; Wed, 28 Apr 2021 12:38:07 -0700 (PDT)
Date:   Wed, 28 Apr 2021 12:37:53 -0700
In-Reply-To: <20210428193756.2110517-1-ricarkol@google.com>
Message-Id: <20210428193756.2110517-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210428193756.2110517-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 3/6] x86/cpu: Expose CPUID regs, leaf and index definitions
 to tools
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move cpuid_regs, cpuid_regs_idx, and cpuid_leafs out of their
'#ifdef __KERNEL__' guards so that KVM selftests can reuse the
definitions in future patches.  Move cpuid_regs and cpuid_regs_idx from
processor.h to cpufeature.h to avoid blasting processor.h with several
'#ifdefs'.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/x86/events/intel/pt.c        |  1 +
 arch/x86/include/asm/cpufeature.h | 23 ++++++++++++++++++-----
 arch/x86/include/asm/processor.h  | 11 -----------
 arch/x86/kernel/cpu/scattered.c   |  2 +-
 arch/x86/kernel/cpuid.c           |  2 +-
 5 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index e94af4a54d0d..882b1478556e 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -21,6 +21,7 @@
 #include <asm/io.h>
 #include <asm/intel_pt.h>
 #include <asm/intel-family.h>
+#include <asm/cpufeature.h>
 
 #include "../perf_event.h"
 #include "pt.h"
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1728d4ce5730..22458ab5aac4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -2,12 +2,19 @@
 #ifndef _ASM_X86_CPUFEATURE_H
 #define _ASM_X86_CPUFEATURE_H
 
-#include <asm/processor.h>
+#include <linux/types.h>
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#ifndef __ASSEMBLY__
+struct cpuid_regs {
+	u32 eax, ebx, ecx, edx;
+};
 
-#include <asm/asm.h>
-#include <linux/bitops.h>
+enum cpuid_regs_idx {
+	CPUID_EAX = 0,
+	CPUID_EBX,
+	CPUID_ECX,
+	CPUID_EDX,
+};
 
 enum cpuid_leafs
 {
@@ -32,6 +39,11 @@ enum cpuid_leafs
 	CPUID_7_EDX,
 	CPUID_8000_001F_EAX,
 };
+#ifdef __KERNEL__
+
+#include <asm/processor.h>
+#include <asm/asm.h>
+#include <linux/bitops.h>
 
 #ifdef CONFIG_X86_FEATURE_NAMES
 extern const char * const x86_cap_flags[NCAPINTS*32];
@@ -240,5 +252,6 @@ static __always_inline bool _static_cpu_has(u16 bit)
 #define CPU_FEATURE_TYPEVAL		boot_cpu_data.x86_vendor, boot_cpu_data.x86, \
 					boot_cpu_data.x86_model
 
-#endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
+#endif /* defined(__KERNEL__) */
+#endif /* !defined(__ASSEMBLY__) */
 #endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f1b9ed5efaa9..1d355d2a6e4e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -142,17 +142,6 @@ struct cpuinfo_x86 {
 	unsigned		initialized : 1;
 } __randomize_layout;
 
-struct cpuid_regs {
-	u32 eax, ebx, ecx, edx;
-};
-
-enum cpuid_regs_idx {
-	CPUID_EAX = 0,
-	CPUID_EBX,
-	CPUID_ECX,
-	CPUID_EDX,
-};
-
 #define X86_VENDOR_INTEL	0
 #define X86_VENDOR_CYRIX	1
 #define X86_VENDOR_AMD		2
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 21d1f062895a..bcbcda1e329b 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -6,7 +6,7 @@
 
 #include <asm/memtype.h>
 #include <asm/apic.h>
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 
 #include "cpu.h"
 
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 6f7b8cc1bc9f..23e67220445b 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -37,7 +37,7 @@
 #include <linux/gfp.h>
 #include <linux/completion.h>
 
-#include <asm/processor.h>
+#include <asm/cpufeature.h>
 #include <asm/msr.h>
 
 static struct class *cpuid_class;
-- 
2.31.1.498.g6c1eba8ee3d-goog

