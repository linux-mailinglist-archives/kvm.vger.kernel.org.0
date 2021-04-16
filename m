Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233CC36242E
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343893AbhDPPmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:63662 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235631AbhDPPmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:01 -0400
IronPort-SDR: tpURSZqO87L9f1BQdEPWLLuhrpIecJPnyhaj8uchmjHy4U1KJUqpY0HnqZQfAFrkBb8CiyoL/W
 tVrV0ntgNRgA==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="174550436"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="174550436"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:36 -0700
IronPort-SDR: ZXxLiKI5NW+Jmqq7rMd7tPVDoK6IYF3qIiPH2QvjaxnQsltHLq7YI2g8gn1spdzGD9lsUe7Bxa
 BjCz3ty+CJIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="453378436"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 16 Apr 2021 08:41:32 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id D58D2147; Fri, 16 Apr 2021 18:41:49 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 02/13] x86/kvm: Introduce KVM memory protection feature
Date:   Fri, 16 Apr 2021 18:40:55 +0300
Message-Id: <20210416154106.23721-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide basic helpers, KVM_FEATURE, CPUID flag and a hypercall.

Host side doesn't provide the feature yet, so it is a dead code for now.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h   |  1 +
 arch/x86/include/asm/kvm_para.h      |  5 +++++
 arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
 arch/x86/kernel/kvm.c                | 17 +++++++++++++++++
 include/uapi/linux/kvm_para.h        |  3 ++-
 5 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 84b887825f12..d8f3d2619913 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -238,6 +238,7 @@
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
 #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
+#define X86_FEATURE_KVM_MEM_PROTECTED	( 8*32+22) /* "" KVM memory protection extension */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 338119852512..74aea18f3130 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -11,11 +11,16 @@ extern void kvmclock_init(void);
 
 #ifdef CONFIG_KVM_GUEST
 bool kvm_check_and_clear_guest_paused(void);
+bool kvm_mem_protected(void);
 #else
 static inline bool kvm_check_and_clear_guest_paused(void)
 {
 	return false;
 }
+static inline bool kvm_mem_protected(void)
+{
+	return false;
+}
 #endif /* CONFIG_KVM_GUEST */
 
 #define KVM_HYPERCALL \
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..8d32c41861c9 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -28,11 +28,12 @@
 #define KVM_FEATURE_PV_UNHALT		7
 #define KVM_FEATURE_PV_TLB_FLUSH	9
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
-#define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_PV_SEND_IPI		11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_MEM_PROTECTED	16
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01ca3b4..aed6034fcac1 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,13 @@
 #include <asm/ptrace.h>
 #include <asm/svm.h>
 
+static bool mem_protected;
+
+bool kvm_mem_protected(void)
+{
+	return mem_protected;
+}
+
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
 static int kvmapf = 1;
@@ -749,6 +756,16 @@ static void __init kvm_init_platform(void)
 {
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
+
+	if (kvm_para_has_feature(KVM_FEATURE_MEM_PROTECTED)) {
+		if (kvm_hypercall0(KVM_HC_ENABLE_MEM_PROTECTED)) {
+			panic("Failed to enable KVM memory protection");
+		}
+
+		pr_info("KVM memory protection enabled\n");
+		mem_protected = true;
+		setup_force_cpu_cap(X86_FEATURE_KVM_MEM_PROTECTED);
+	}
 }
 
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b86609849b9..1a216f32e572 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -27,8 +27,9 @@
 #define KVM_HC_MIPS_EXIT_VM		7
 #define KVM_HC_MIPS_CONSOLE_OUTPUT	8
 #define KVM_HC_CLOCK_PAIRING		9
-#define KVM_HC_SEND_IPI		10
+#define KVM_HC_SEND_IPI			10
 #define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_ENABLE_MEM_PROTECTED	12
 
 /*
  * hypercalls use architecture specific
-- 
2.26.3

