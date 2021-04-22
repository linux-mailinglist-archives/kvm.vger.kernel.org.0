Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC59E367698
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244303AbhDVA5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243387AbhDVA5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 20:57:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C16BC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:56:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id cu23-20020a17090afa97b0290152471ab665so957758pjb.8
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F1YIESlA0/i8trOgg7KpVXZp0asbzYmi0IVBmNPCtJs=;
        b=OD6htb2yTD0u/MM9HZBQBUu4BFLRXbmrrUmNnx8Kb6ffq8IFdnhAP8Lq8zgQ9ovBxD
         MozMJVlC0WxIZ8BP97ezSTTiZi7dVCh+9M7MbTqq0BqdIhl7ge+yXTDdpKBcazFDeqzS
         iS7YuUWGEOPNkFaLbKhiZFE85iBouNRmk2LSg86p4yQx3i6g5fFDoN6eyuk5G5pMtCzz
         96+D2aI8ku1/Edq7WLpW/dnq+/s/IyRgNudREvgbtZB8FUx+CTjCMOazAQzJmHGT6PAV
         0pifOH0bbAWkdwGFkvA7ivNY9eG1UjeyWIbFE1chaLPGCNxSz5UmIKPlyO/s0Y7LmlSO
         wV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F1YIESlA0/i8trOgg7KpVXZp0asbzYmi0IVBmNPCtJs=;
        b=R8UKrp4plwEno8DejbLIkd77d9tA5ZO1Kvx8n2eemluSL+0YtAGPYXoGGT1btlzHnM
         PLQfOkhia3ySFLj3FXsdDwDQIJSYjSM8TsrOV4Cx0OLw3y4ubo2JdHIC83J73QWGQxAN
         iaffYuGCKMEzyjY3/jZ5QBMqtStgavcnB4HbEp5n8iogIn8ktI9Pf69yCm2fngwYErmY
         NS4vl+1f5qj4QKl1L7s1Hyg6sqZpLqU/L3q6/9DdS93cvoGkEmaHfxWwbOQ6Q9usXVAC
         oGYq2rD6+jDSKb7v0MMvT26AKfQAjNuyMJUdl0Fzjv1PUnOFHjWvA9p685dHC2M3alpN
         gUhA==
X-Gm-Message-State: AOAM5326Pk9YG0198JNKn0XXfCwMCicSXQh6ch/W5BKxmyPD41O6WbIA
        2+aD1f/vNljfWPvNZ/IbElNoFQhhAZuvBQ==
X-Google-Smtp-Source: ABdhPJxzUU0cXov3Pd8egAv3XvAhn3YUjZSNNf0UyLo9cXG0zTY1+EiUw8ypuAwO6dsv0jSMhuxRauafY5pmGQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:fc10:: with SMTP id
 j16mr862526pgi.152.1619053003433; Wed, 21 Apr 2021 17:56:43 -0700 (PDT)
Date:   Wed, 21 Apr 2021 17:56:24 -0700
In-Reply-To: <20210422005626.564163-1-ricarkol@google.com>
Message-Id: <20210422005626.564163-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210422005626.564163-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH 3/5] tools headers x86: Copy cpuid helpers from the kernel
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

Copy arch/x86/include/asm/acpufeature.h and arch/x86/kvm/reverse_cpuid.h
from the kernel so that KVM selftests can use them in the next commits.
Also update the tools copy of arch/x86/include/asm/acpufeatures.h.

cpufeature.h is copied into tools/arch/x86/include like most other
headers.  reverse_cpuid.h is a special case as it's copied into the KVM
selftests include location: tools/testing/selftests/kvm/include/x86_64/.
These should be kept in sync, ideally with the help of some script like
check-headers.sh used by tools/perf/.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/arch/x86/include/asm/cpufeature.h       | 257 ++++++++++++++++++
 tools/arch/x86/include/asm/cpufeatures.h      |   3 +
 .../kvm/include/x86_64/reverse_cpuid.h        | 185 +++++++++++++
 3 files changed, 445 insertions(+)
 create mode 100644 tools/arch/x86/include/asm/cpufeature.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/reverse_cpuid.h

diff --git a/tools/arch/x86/include/asm/cpufeature.h b/tools/arch/x86/include/asm/cpufeature.h
new file mode 100644
index 000000000000..22458ab5aac4
--- /dev/null
+++ b/tools/arch/x86/include/asm/cpufeature.h
@@ -0,0 +1,257 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_CPUFEATURE_H
+#define _ASM_X86_CPUFEATURE_H
+
+#include <linux/types.h>
+
+#ifndef __ASSEMBLY__
+struct cpuid_regs {
+	u32 eax, ebx, ecx, edx;
+};
+
+enum cpuid_regs_idx {
+	CPUID_EAX = 0,
+	CPUID_EBX,
+	CPUID_ECX,
+	CPUID_EDX,
+};
+
+enum cpuid_leafs
+{
+	CPUID_1_EDX		= 0,
+	CPUID_8000_0001_EDX,
+	CPUID_8086_0001_EDX,
+	CPUID_LNX_1,
+	CPUID_1_ECX,
+	CPUID_C000_0001_EDX,
+	CPUID_8000_0001_ECX,
+	CPUID_LNX_2,
+	CPUID_LNX_3,
+	CPUID_7_0_EBX,
+	CPUID_D_1_EAX,
+	CPUID_LNX_4,
+	CPUID_7_1_EAX,
+	CPUID_8000_0008_EBX,
+	CPUID_6_EAX,
+	CPUID_8000_000A_EDX,
+	CPUID_7_ECX,
+	CPUID_8000_0007_EBX,
+	CPUID_7_EDX,
+	CPUID_8000_001F_EAX,
+};
+#ifdef __KERNEL__
+
+#include <asm/processor.h>
+#include <asm/asm.h>
+#include <linux/bitops.h>
+
+#ifdef CONFIG_X86_FEATURE_NAMES
+extern const char * const x86_cap_flags[NCAPINTS*32];
+extern const char * const x86_power_flags[32];
+#define X86_CAP_FMT "%s"
+#define x86_cap_flag(flag) x86_cap_flags[flag]
+#else
+#define X86_CAP_FMT "%d:%d"
+#define x86_cap_flag(flag) ((flag) >> 5), ((flag) & 31)
+#endif
+
+/*
+ * In order to save room, we index into this array by doing
+ * X86_BUG_<name> - NCAPINTS*32.
+ */
+extern const char * const x86_bug_flags[NBUGINTS*32];
+
+#define test_cpu_cap(c, bit)						\
+	 test_bit(bit, (unsigned long *)((c)->x86_capability))
+
+/*
+ * There are 32 bits/features in each mask word.  The high bits
+ * (selected with (bit>>5) give us the word number and the low 5
+ * bits give us the bit/feature number inside the word.
+ * (1UL<<((bit)&31) gives us a mask for the feature_bit so we can
+ * see if it is set in the mask word.
+ */
+#define CHECK_BIT_IN_MASK_WORD(maskname, word, bit)	\
+	(((bit)>>5)==(word) && (1UL<<((bit)&31) & maskname##word ))
+
+/*
+ * {REQUIRED,DISABLED}_MASK_CHECK below may seem duplicated with the
+ * following BUILD_BUG_ON_ZERO() check but when NCAPINTS gets changed, all
+ * header macros which use NCAPINTS need to be changed. The duplicated macro
+ * use causes the compiler to issue errors for all headers so that all usage
+ * sites can be corrected.
+ */
+#define REQUIRED_MASK_BIT_SET(feature_bit)		\
+	 ( CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  0, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  1, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  2, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  3, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  4, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  5, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  6, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  7, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  8, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK,  9, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 10, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 11, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 12, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 13, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 14, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 15, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 16, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 19, feature_bit) ||	\
+	   REQUIRED_MASK_CHECK					  ||	\
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
+
+#define DISABLED_MASK_BIT_SET(feature_bit)				\
+	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  1, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  2, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  3, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  4, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  5, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  6, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  7, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  8, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  9, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 10, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 11, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 12, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 13, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 14, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 15, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 16, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 19, feature_bit) ||	\
+	   DISABLED_MASK_CHECK					  ||	\
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
+
+#define cpu_has(c, bit)							\
+	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
+	 test_cpu_cap(c, bit))
+
+#define this_cpu_has(bit)						\
+	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
+	 x86_this_cpu_test_bit(bit,					\
+		(unsigned long __percpu *)&cpu_info.x86_capability))
+
+/*
+ * This macro is for detection of features which need kernel
+ * infrastructure to be used.  It may *not* directly test the CPU
+ * itself.  Use the cpu_has() family if you want true runtime
+ * testing of CPU features, like in hypervisor code where you are
+ * supporting a possible guest feature where host support for it
+ * is not relevant.
+ */
+#define cpu_feature_enabled(bit)	\
+	(__builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0 : static_cpu_has(bit))
+
+#define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
+
+#define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
+
+extern void setup_clear_cpu_cap(unsigned int bit);
+extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
+
+#define setup_force_cpu_cap(bit) do { \
+	set_cpu_cap(&boot_cpu_data, bit);	\
+	set_bit(bit, (unsigned long *)cpu_caps_set);	\
+} while (0)
+
+#define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
+
+#if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
+
+/*
+ * Workaround for the sake of BPF compilation which utilizes kernel
+ * headers, but clang does not support ASM GOTO and fails the build.
+ */
+#ifndef __BPF_TRACING__
+#warning "Compiler lacks ASM_GOTO support. Add -D __BPF_TRACING__ to your compiler arguments"
+#endif
+
+#define static_cpu_has(bit)            boot_cpu_has(bit)
+
+#else
+
+/*
+ * Static testing of CPU features. Used the same as boot_cpu_has(). It
+ * statically patches the target code for additional performance. Use
+ * static_cpu_has() only in fast paths, where every cycle counts. Which
+ * means that the boot_cpu_has() variant is already fast enough for the
+ * majority of cases and you should stick to using it as it is generally
+ * only two instructions: a RIP-relative MOV and a TEST.
+ */
+static __always_inline bool _static_cpu_has(u16 bit)
+{
+	asm_volatile_goto("1: jmp 6f\n"
+		 "2:\n"
+		 ".skip -(((5f-4f) - (2b-1b)) > 0) * "
+			 "((5f-4f) - (2b-1b)),0x90\n"
+		 "3:\n"
+		 ".section .altinstructions,\"a\"\n"
+		 " .long 1b - .\n"		/* src offset */
+		 " .long 4f - .\n"		/* repl offset */
+		 " .word %P[always]\n"		/* always replace */
+		 " .byte 3b - 1b\n"		/* src len */
+		 " .byte 5f - 4f\n"		/* repl len */
+		 " .byte 3b - 2b\n"		/* pad len */
+		 ".previous\n"
+		 ".section .altinstr_replacement,\"ax\"\n"
+		 "4: jmp %l[t_no]\n"
+		 "5:\n"
+		 ".previous\n"
+		 ".section .altinstructions,\"a\"\n"
+		 " .long 1b - .\n"		/* src offset */
+		 " .long 0\n"			/* no replacement */
+		 " .word %P[feature]\n"		/* feature bit */
+		 " .byte 3b - 1b\n"		/* src len */
+		 " .byte 0\n"			/* repl len */
+		 " .byte 0\n"			/* pad len */
+		 ".previous\n"
+		 ".section .altinstr_aux,\"ax\"\n"
+		 "6:\n"
+		 " testb %[bitnum],%[cap_byte]\n"
+		 " jnz %l[t_yes]\n"
+		 " jmp %l[t_no]\n"
+		 ".previous\n"
+		 : : [feature]  "i" (bit),
+		     [always]   "i" (X86_FEATURE_ALWAYS),
+		     [bitnum]   "i" (1 << (bit & 7)),
+		     [cap_byte] "m" (((const char *)boot_cpu_data.x86_capability)[bit >> 3])
+		 : : t_yes, t_no);
+t_yes:
+	return true;
+t_no:
+	return false;
+}
+
+#define static_cpu_has(bit)					\
+(								\
+	__builtin_constant_p(boot_cpu_has(bit)) ?		\
+		boot_cpu_has(bit) :				\
+		_static_cpu_has(bit)				\
+)
+#endif
+
+#define cpu_has_bug(c, bit)		cpu_has(c, (bit))
+#define set_cpu_bug(c, bit)		set_cpu_cap(c, (bit))
+#define clear_cpu_bug(c, bit)		clear_cpu_cap(c, (bit))
+
+#define static_cpu_has_bug(bit)		static_cpu_has((bit))
+#define boot_cpu_has_bug(bit)		cpu_has_bug(&boot_cpu_data, (bit))
+#define boot_cpu_set_bug(bit)		set_cpu_cap(&boot_cpu_data, (bit))
+
+#define MAX_CPU_FEATURES		(NCAPINTS * 32)
+#define cpu_have_feature		boot_cpu_has
+
+#define CPU_FEATURE_TYPEFMT		"x86,ven%04Xfam%04Xmod%04X"
+#define CPU_FEATURE_TYPEVAL		boot_cpu_data.x86_vendor, boot_cpu_data.x86, \
+					boot_cpu_data.x86_model
+
+#endif /* defined(__KERNEL__) */
+#endif /* !defined(__ASSEMBLY__) */
+#endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index cc96e26d69f7..dddc746b5455 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -290,6 +290,8 @@
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
+#define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
+#define X86_FEATURE_SGX2		(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
@@ -336,6 +338,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
diff --git a/tools/testing/selftests/kvm/include/x86_64/reverse_cpuid.h b/tools/testing/selftests/kvm/include/x86_64/reverse_cpuid.h
new file mode 100644
index 000000000000..8e0756ddab1a
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/reverse_cpuid.h
@@ -0,0 +1,185 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef ARCH_X86_KVM_REVERSE_CPUID_H
+#define ARCH_X86_KVM_REVERSE_CPUID_H
+
+#include <uapi/asm/kvm.h>
+#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
+
+/*
+ * Hardware-defined CPUID leafs that are scattered in the kernel, but need to
+ * be directly used by KVM.  Note, these word values conflict with the kernel's
+ * "bug" caps, but KVM doesn't use those.
+ */
+enum kvm_only_cpuid_leafs {
+	CPUID_12_EAX	 = NCAPINTS,
+	NR_KVM_CPU_CAPS,
+
+	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
+};
+
+#define KVM_X86_FEATURE(w, f)		((w)*32 + (f))
+
+/* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
+#define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
+#define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
+
+struct cpuid_reg {
+	u32 function;
+	u32 index;
+	int reg;
+};
+
+static const struct cpuid_reg reverse_cpuid[] = {
+	[CPUID_1_EDX]         = {         1, 0, CPUID_EDX},
+	[CPUID_8000_0001_EDX] = {0x80000001, 0, CPUID_EDX},
+	[CPUID_8086_0001_EDX] = {0x80860001, 0, CPUID_EDX},
+	[CPUID_1_ECX]         = {         1, 0, CPUID_ECX},
+	[CPUID_C000_0001_EDX] = {0xc0000001, 0, CPUID_EDX},
+	[CPUID_8000_0001_ECX] = {0x80000001, 0, CPUID_ECX},
+	[CPUID_7_0_EBX]       = {         7, 0, CPUID_EBX},
+	[CPUID_D_1_EAX]       = {       0xd, 1, CPUID_EAX},
+	[CPUID_8000_0008_EBX] = {0x80000008, 0, CPUID_EBX},
+	[CPUID_6_EAX]         = {         6, 0, CPUID_EAX},
+	[CPUID_8000_000A_EDX] = {0x8000000a, 0, CPUID_EDX},
+	[CPUID_7_ECX]         = {         7, 0, CPUID_ECX},
+	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
+	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
+	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
+};
+
+/*
+ * Reverse CPUID and its derivatives can only be used for hardware-defined
+ * feature words, i.e. words whose bits directly correspond to a CPUID leaf.
+ * Retrieving a feature bit or masking guest CPUID from a Linux-defined word
+ * is nonsensical as the bit number/mask is an arbitrary software-defined value
+ * and can't be used by KVM to query/control guest capabilities.  And obviously
+ * the leaf being queried must have an entry in the lookup table.
+ */
+static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
+{
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_3);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
+	BUILD_BUG_ON(x86_leaf >= ARRAY_SIZE(reverse_cpuid));
+	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
+}
+
+/*
+ * Translate feature bits that are scattered in the kernel's cpufeatures word
+ * into KVM feature words that align with hardware's definitions.
+ */
+static __always_inline u32 __feature_translate(int x86_feature)
+{
+	if (x86_feature == X86_FEATURE_SGX1)
+		return KVM_X86_FEATURE_SGX1;
+	else if (x86_feature == X86_FEATURE_SGX2)
+		return KVM_X86_FEATURE_SGX2;
+
+	return x86_feature;
+}
+
+static __always_inline u32 __feature_leaf(int x86_feature)
+{
+	return __feature_translate(x86_feature) / 32;
+}
+
+/*
+ * Retrieve the bit mask from an X86_FEATURE_* definition.  Features contain
+ * the hardware defined bit number (stored in bits 4:0) and a software defined
+ * "word" (stored in bits 31:5).  The word is used to index into arrays of
+ * bit masks that hold the per-cpu feature capabilities, e.g. this_cpu_has().
+ */
+static __always_inline u32 __feature_bit(int x86_feature)
+{
+	x86_feature = __feature_translate(x86_feature);
+
+	reverse_cpuid_check(x86_feature / 32);
+	return 1 << (x86_feature & 31);
+}
+
+#define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
+
+static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_feature)
+{
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
+
+	reverse_cpuid_check(x86_leaf);
+	return reverse_cpuid[x86_leaf];
+}
+
+static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
+						  u32 reg)
+{
+	switch (reg) {
+	case CPUID_EAX:
+		return &entry->eax;
+	case CPUID_EBX:
+		return &entry->ebx;
+	case CPUID_ECX:
+		return &entry->ecx;
+	case CPUID_EDX:
+		return &entry->edx;
+	default:
+		BUILD_BUG();
+		return NULL;
+	}
+}
+
+static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
+						unsigned int x86_feature)
+{
+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
+
+	return __cpuid_entry_get_reg(entry, cpuid.reg);
+}
+
+static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
+					   unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	return *reg & __feature_bit(x86_feature);
+}
+
+static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
+					    unsigned int x86_feature)
+{
+	return cpuid_entry_get(entry, x86_feature);
+}
+
+static __always_inline void cpuid_entry_clear(struct kvm_cpuid_entry2 *entry,
+					      unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	*reg &= ~__feature_bit(x86_feature);
+}
+
+static __always_inline void cpuid_entry_set(struct kvm_cpuid_entry2 *entry,
+					    unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	*reg |= __feature_bit(x86_feature);
+}
+
+static __always_inline void cpuid_entry_change(struct kvm_cpuid_entry2 *entry,
+					       unsigned int x86_feature,
+					       bool set)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	/*
+	 * Open coded instead of using cpuid_entry_{clear,set}() to coerce the
+	 * compiler into using CMOV instead of Jcc when possible.
+	 */
+	if (set)
+		*reg |= __feature_bit(x86_feature);
+	else
+		*reg &= ~__feature_bit(x86_feature);
+}
+
+#endif /* ARCH_X86_KVM_REVERSE_CPUID_H */
-- 
2.31.1.368.gbe11c130af-goog

