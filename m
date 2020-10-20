Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07372934CF
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403867AbgJTGTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403827AbgJTGTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:08 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62CDC0613CE
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id 23so740170ljv.7
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5f0A0zc+XYCpsa7He3BwUgXnJ1JLxwIL0kcsDi74wWI=;
        b=dKpkpylJdcvW/k7YVAZv/3xjWvLxRyGiSE75YeRuwST3KCyBHHoqvOrWyqv3QgqyGX
         klYmJ4zR5jq35IKLs7FvJuFDv07diL4A9uCjwKCmWylCHJPWobBgvpQBmGNKyrYdSp06
         aU9eGqkUlLpJZcR0U71TfKa+VdavLXijNowaoU6OVS7Kv3CHiJnzSX2Gs16t5qA9uges
         ylx3CkZFuUE5zj1oXPmwUz+vLfwgidYaEag5TDL2NDGaeiXzfc1Ycfgb07TJw5Xt8a/W
         tgQr8BFj4+0cy9JygSvYvcETVdy0lCd/0nOXdDLeZfwOZVYdc8Ck2MvBjmpdxI5uSrfI
         69bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5f0A0zc+XYCpsa7He3BwUgXnJ1JLxwIL0kcsDi74wWI=;
        b=h190joXp/K+NxYvbC594Pom/Px1uNvLtYCUm92T63s4lJ6xFLnmqBRIDOcmB9I5Di6
         mSLisCp4A0QdN423GI15BPtXuEABievMtyuF69K6rKa62xUhgL392mRXfnod47nYEkxT
         JTtLacVD/sWGOjJP+A9BbZgQ3pRqvla1A35+l/umRIi9H34JnGZ4CWginUtUCi825PkB
         0NDGXdULVzXSuLbMK4aalRmEz9/ZCq+7pUlRTXY498ZCP8ozIpc+Q+eY1fmTPROkZ34Z
         54T+Zxsz4n9H6WEOdLPYPMPBWFGKwYkJsQOP5vonFAUndaCB/PX30o0Kbf2gLl8kgt62
         BB8A==
X-Gm-Message-State: AOAM531FNhl4l2VCO8vefzgcYbU392Or7+08UDKFzzIF0Rn7ocGgRqp/
        Bdm0AOsXa0UjRyWB09cqjpNN+w==
X-Google-Smtp-Source: ABdhPJy0JVVG9BEVSPa0OKvs+uLXEY7LFFLEripqdWD/w7alhdkwCKGVmyVeFSRr7ffNo5CfXVDdJw==
X-Received: by 2002:a2e:9b4d:: with SMTP id o13mr455628ljj.356.1603174746085;
        Mon, 19 Oct 2020 23:19:06 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id v11sm135766lfg.275.2020.10.19.23.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:04 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id BEC73102F61; Tue, 20 Oct 2020 09:19:01 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 02/16] x86/kvm: Introduce KVM memory protection feature
Date:   Tue, 20 Oct 2020 09:18:45 +0300
Message-Id: <20201020061859.18385-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
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
index 2901d5df4366..a72157137764 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -236,6 +236,7 @@
 #define X86_FEATURE_EPT_AD		( 8*32+17) /* Intel Extended Page Table access-dirty bit */
 #define X86_FEATURE_VMCALL		( 8*32+18) /* "" Hypervisor supports the VMCALL instruction */
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
+#define X86_FEATURE_KVM_MEM_PROTECTED	( 8*32+20) /* KVM memory protection extenstion */
 
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
index 812e9b4c1114..defbfc630a9f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -28,10 +28,11 @@
 #define KVM_FEATURE_PV_UNHALT		7
 #define KVM_FEATURE_PV_TLB_FLUSH	9
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
-#define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_PV_SEND_IPI		11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
+#define KVM_FEATURE_MEM_PROTECTED	15
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9663ba31347c..2c1f8952b92a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -37,6 +37,13 @@
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
 
+static bool mem_protected;
+
+bool kvm_mem_protected(void)
+{
+	return mem_protected;
+}
+
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
 static int kvmapf = 1;
@@ -742,6 +749,17 @@ static void __init kvm_init_platform(void)
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
 
 const __initconst struct hypervisor_x86 x86_hyper_kvm = {
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
2.26.2

