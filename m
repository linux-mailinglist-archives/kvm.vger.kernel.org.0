Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1AF4AE3D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbfFRWwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:52:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:48878 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbfFRWvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009358"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:11 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 06/17] x86/split_lock: Enumerate split lock detection by MSR_IA32_CORE_CAP
Date:   Tue, 18 Jun 2019 15:41:08 -0700
Message-Id: <1560897679-228028-7-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bits in MSR_IA32_CORE_CAP enumerate a few features that are not
enumerated through CPUID. Currently bit 5 is defined to enumerate
feature of split lock detection. All other bits are reserved now.

When bit 5 is 1, the feature is supported and feature bit
X86_FEATURE_SPLIT_LOCK_DETECT is set. Otherwise, the feature is not
available.

The MSR_IA32_CORE_CAP itself is enumerated by
CPUID.(EAX=0x7,ECX=0):EDX[30].

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h         |  5 ++
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/common.c       |  2 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 79 +++++++++++++++---------------
 arch/x86/kernel/cpu/intel.c        | 22 +++++++++
 5 files changed, 70 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index adc6cc86b062..4e03f53fc079 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -40,4 +40,9 @@ int mwait_usable(const struct cpuinfo_x86 *);
 unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
+#ifdef CONFIG_CPU_SUP_INTEL
+void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
+#else
+static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
+#endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c6e888688a13..5e3759b7c5b7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -221,6 +221,7 @@
 #define X86_FEATURE_ZEN			( 7*32+28) /* "" CPU is AMD family 0x17 (Zen) */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
+#define X86_FEATURE_SPLIT_LOCK_DETECT	( 7*32+31) /* #AC for split lock */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ed2b81b437e0..9aa91140024f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1119,6 +1119,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 	cpu_set_bug_bits(c);
 
+	cpu_set_core_cap_bits(c);
+
 	fpu__init_system(c);
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 2c0bd38a44ab..3d633f67fbd7 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -20,45 +20,46 @@ struct cpuid_dep {
  * but it's difficult to tell that to the init reference checker.
  */
 static const struct cpuid_dep cpuid_deps[] = {
-	{ X86_FEATURE_XSAVEOPT,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_XSAVEC,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_XSAVES,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_AVX,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_PKU,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_MPX,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_XGETBV1,		X86_FEATURE_XSAVE     },
-	{ X86_FEATURE_FXSR_OPT,		X86_FEATURE_FXSR      },
-	{ X86_FEATURE_XMM,		X86_FEATURE_FXSR      },
-	{ X86_FEATURE_XMM2,		X86_FEATURE_XMM       },
-	{ X86_FEATURE_XMM3,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_XMM4_1,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_XMM4_2,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_XMM3,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_PCLMULQDQ,	X86_FEATURE_XMM2      },
-	{ X86_FEATURE_SSSE3,		X86_FEATURE_XMM2,     },
-	{ X86_FEATURE_F16C,		X86_FEATURE_XMM2,     },
-	{ X86_FEATURE_AES,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_SHA_NI,		X86_FEATURE_XMM2      },
-	{ X86_FEATURE_FMA,		X86_FEATURE_AVX       },
-	{ X86_FEATURE_AVX2,		X86_FEATURE_AVX,      },
-	{ X86_FEATURE_AVX512F,		X86_FEATURE_AVX,      },
-	{ X86_FEATURE_AVX512IFMA,	X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512PF,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512ER,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512CD,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512DQ,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512BW,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512VL,		X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512VBMI,	X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512_VBMI2,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_GFNI,		X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_VAES,		X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_VPCLMULQDQ,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_AVX512_VNNI,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_AVX512_BITALG,	X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_AVX512_4VNNIW,	X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512_4FMAPS,	X86_FEATURE_AVX512F   },
-	{ X86_FEATURE_AVX512_VPOPCNTDQ, X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_XSAVEOPT,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_XSAVEC,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_XSAVES,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_AVX,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_PKU,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_MPX,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_XGETBV1,			X86_FEATURE_XSAVE     },
+	{ X86_FEATURE_FXSR_OPT,			X86_FEATURE_FXSR      },
+	{ X86_FEATURE_XMM,			X86_FEATURE_FXSR      },
+	{ X86_FEATURE_XMM2,			X86_FEATURE_XMM       },
+	{ X86_FEATURE_XMM3,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_XMM4_1,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_XMM4_2,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_XMM3,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_PCLMULQDQ,		X86_FEATURE_XMM2      },
+	{ X86_FEATURE_SSSE3,			X86_FEATURE_XMM2,     },
+	{ X86_FEATURE_F16C,			X86_FEATURE_XMM2,     },
+	{ X86_FEATURE_AES,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_SHA_NI,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_FMA,			X86_FEATURE_AVX       },
+	{ X86_FEATURE_AVX2,			X86_FEATURE_AVX,      },
+	{ X86_FEATURE_AVX512F,			X86_FEATURE_AVX,      },
+	{ X86_FEATURE_AVX512IFMA,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512PF,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512ER,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512CD,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512DQ,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512BW,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512VL,			X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512VBMI,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512_VBMI2,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_GFNI,			X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_VAES,			X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_VPCLMULQDQ,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_AVX512_VNNI,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_AVX512_BITALG,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_AVX512_4VNNIW,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512_4FMAPS,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_AVX512_VPOPCNTDQ,		X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_SPLIT_LOCK_DETECT,	X86_FEATURE_CORE_CAPABILITY},
 	{}
 };
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index f17c1a714779..d63a4ba203e1 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -995,3 +995,25 @@ static const struct cpu_dev intel_cpu_dev = {
 };
 
 cpu_dev_register(intel_cpu_dev);
+
+static void __init split_lock_setup(void)
+{
+	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+}
+
+void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
+{
+	u64 ia32_core_cap = 0;
+
+	if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITY))
+		return;
+
+	/*
+	 * If MSR_IA32_CORE_CAP exists, enumerate features that are
+	 * reported in the MSR.
+	 */
+	rdmsrl(MSR_IA32_CORE_CAP, ia32_core_cap);
+
+	if (ia32_core_cap & MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT)
+		split_lock_setup();
+}
-- 
2.19.1

