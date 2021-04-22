Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A12E367697
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242619AbhDVA5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242419AbhDVA5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 20:57:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739F6C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:56:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e8-20020a2587480000b02904e5857564e2so17992114ybn.16
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nQ/zpK/kz603934NoaeU4Gk/eDpKeLkLBX1Q9YclUPA=;
        b=eP0O7z+LQB2aToODGjmklTU4/ZEqYkoE5cnDIg2lo7Q+vpJ9bR12OhCB4CdXqay1zU
         77yav77ko4Ygni13AIZ16v+K0y/18AcUBfAuRlm+kSdBvwI6G6MIqX5wJvPWr1vjpjOT
         RY8cp2nkuurYbZjYKn1mnbrj8FVF5olWJPGwy2dCCUeMAY5P/AC+h6GTyXluGrb70v6R
         x49xRasTZeVZhhIpM4E8MDgPWfehTjBizf1sIKQb41Tlqee3lYIoFIBzemfr1TeLQ35q
         4XTfr+dmAHno0tDXFgncMkcFOZrVGxqV/7CWSSPqfwqqyUFZzQgP2L4eIhcLZJxQbFBz
         8X+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nQ/zpK/kz603934NoaeU4Gk/eDpKeLkLBX1Q9YclUPA=;
        b=ZmOnid83X1brkj86tZBJTEb4TDrcv+7IR5OwVFDEIXFVJ5ii2j+Nxqn3ZjMNNeAoqe
         h6nzZPo70YZ3xs0D7aGm+et6U+dIjevL/5t990q8xydhjLQhjNHEBYYws8sD6UBQ5JzY
         KxMRcEvnGfGW59czv+7aUroN/Bp056I/2WJm0SBZUhNfUhvsYhIQk9mwCcMOuuigaDvU
         bTCdAMowLKlIn7eNGMbktBdQxp1SSyJwLAZ35gcwyrdMywPPfNbtmYs6JWlwOh1f+65c
         T2obdJVFALvL7iPMZUud8PmcFt1F2SHcEPghrhONP84TS/A02DJcf1N1EZSV7AZJ+WNx
         8nOA==
X-Gm-Message-State: AOAM5322k9+OXWnx9Jjym3uOW5tl7rsFe25Uhge5TVTNxNVlqh4WNGP6
        ee73iQUo/MLfTR1nZEMur/2XZUzppgtkZw==
X-Google-Smtp-Source: ABdhPJwRNsexrlF6Et7Tudrdqp8qhO7el0jKsQTvh4PiuQzg//HU3EEJk0WGdQkuBV0VKD9bmeLOfOp/jgfbcg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:b9c1:: with SMTP id
 y1mr979521ybj.321.1619053001722; Wed, 21 Apr 2021 17:56:41 -0700 (PDT)
Date:   Wed, 21 Apr 2021 17:56:23 -0700
In-Reply-To: <20210422005626.564163-1-ricarkol@google.com>
Message-Id: <20210422005626.564163-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210422005626.564163-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH 2/5] x86/cpu: Expose CPUID regs, leaf and index definitions to tools
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
index dc6d149bf851..bc7fa3de7ccc 100644
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
2.31.1.368.gbe11c130af-goog

