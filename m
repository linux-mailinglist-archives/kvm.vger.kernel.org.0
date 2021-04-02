Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60832352D65
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbhDBP1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhDBP1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:27:01 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79937C061793
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 08:27:00 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id v15so8064720lfq.5
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XV0Rr4q4z3pF6mu76yp48SNzLyhgb7peTnE0lBez02o=;
        b=EodbBshMCTRvKidcqtpUFzszeT8suAvHyZt41AkxUb25cC6X8OxPA4C8/OE6qI0Wjz
         tGJ7L/D4+6zUo57hATMXVzY4G4BtZTZtr3m9+BU5jCKirdrDSrgW2CSPuPh2020wSAna
         ggycoLovCsjjRgBc62sTAV+iYgDECMJIgU+ouZmYqeFDjU/XRt4Bejb4ue4PKz0GNzSW
         WIqrXtJa76zzFYufZBZYLnTt3DIhL/J42GpK3YM2KKeTpitbGRHQHMU8soEKWqBo5gnd
         e+XjG4bFYId8r3XpyapntpWDDeSM73zLUToBPPYtskMgWgutXsNbQFPPKzehRVJ/j51u
         wc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XV0Rr4q4z3pF6mu76yp48SNzLyhgb7peTnE0lBez02o=;
        b=Jr6s5sWE6Mh6CI83AAyyGLuyVcqbqqUN89CgL0seW7tjIaULX1lnMMGMjuUHcoXOiH
         i0MZwmbMsenyjBpEqEb3EWoVQ+9dfcyJ7E1x9ZiOpJBEqNHYDYzkLW2LWWEnP7xw+Nqx
         94hG+lHvLmCCl3feVeE+/G+INTAbZGx011Sj/d9sbBA1OaeAOVyO+1qaS89JJoisJR62
         PS+PlAtruxpV3kPqPt3OfSNQAAykTOlEcjhENiihKdPVJZQpRqoZRQ4Fs+CCErljzY9B
         yzeIlkk29eG/t3732/wbPLBPjaFGdtxmzHH5bAJ3zlqJea7ypSmT1Ept14ZdU14cj86z
         WzBw==
X-Gm-Message-State: AOAM531rbZ1oxh7cgnpfgdq5TAB6e+CAtk/kgf/qVRJognNF968g9uda
        j6cwWGD3CLku7c0tjISQoAClxw==
X-Google-Smtp-Source: ABdhPJwwhltQnBLsjblMC1m6HNOlB5i9WDQyil9E+Sy2m1NJ/ThtwWraH/J1f/w7kSgdubujWpX0Fw==
X-Received: by 2002:a05:6512:118d:: with SMTP id g13mr9157808lfr.36.1617377218932;
        Fri, 02 Apr 2021 08:26:58 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id d18sm957906ljo.51.2021.04.02.08.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:26:57 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 2D218102672; Fri,  2 Apr 2021 18:26:59 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv1 2/7] x86/kvm: Introduce KVM memory protection feature
Date:   Fri,  2 Apr 2021 18:26:40 +0300
Message-Id: <20210402152645.26680-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
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
 arch/x86/kernel/kvm.c                | 18 ++++++++++++++++++
 include/uapi/linux/kvm_para.h        |  3 ++-
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 84b887825f12..5b6f23e6edc4 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -238,6 +238,7 @@
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
 #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
+#define X86_FEATURE_KVM_MEM_PROTECTED	( 8*32+22) /* KVM memory protection extenstion */
 
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
index 5e78e01ca3b4..e6989e1b74eb 100644
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
@@ -749,6 +756,17 @@ static void __init kvm_init_platform(void)
 {
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
+
+	if (kvm_para_has_feature(KVM_FEATURE_MEM_PROTECTED)) {
+		if (kvm_hypercall0(KVM_HC_ENABLE_MEM_PROTECTED)) {
+			pr_err("Failed to enable KVM memory protection\n");
+			return;
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

