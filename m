Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E461DE753
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgEVMyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbgEVMwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70265C08C5C1
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:20 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id v16so12502523ljc.8
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S+L43kzTWeV0qBo7/UXpF9mjurVSaJfxkFKdWz5la+8=;
        b=L10nCGuhKTvFcjopSTmqmu6TMttbOmfpAsWfm6aIGQA6P1R+wcUVFl1kMoxkQpr/Vr
         T/32LdrA4xVd1SJpudUw2/5zyKsaH51gEL9zXs3gJgSY64iKwW1DR1GtYwt9Ezmenij8
         o4Nw4HaR4ZIi4zQiZSCGz6Z9BihS+pe9Qheuty0ulaJQdRS4WRQ0ugsPAd+HEbCZF071
         0VRoI+63GAoIyKDgw3bpM/jwHrWXUmOjrKz+ZyFRAHOyDdMKsJeD93A6kb8lkAofAtAk
         iQ7AN9JCC8C7qxEFkUS5MqJNkL2O8GLBye8FWmv0Oz3rpZKZ8Ok5N43GLlyqj+zfnLlN
         P/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+L43kzTWeV0qBo7/UXpF9mjurVSaJfxkFKdWz5la+8=;
        b=eSnXsOdB97gpknAe2YvN7ex7/qAHkCQR7urIQtepo2KooNe0M/yfObiIGb3T0vGAk4
         Muzx0PldvfYR11WN9KMN5hDQSRQgKMo0sNmxSOXLo+gUj8xTJm8CY8FSTB6TlarcOA1U
         xvzL7MbTJ//Ylwo9OiJCfQOv+25BG6gBAVHgxIA9cWFoDl/2zBshfOOcqxtfOf8Wyuht
         i7L3VHB4B4vP0UH4ShL8v1uIo/6mJZ6HoQkyB2QffWVce1Glq1oHf0hy8Nng8E1VldUi
         qwtU21HwDNKvkW9Vrejb8d+/OiSU6IhYlGwEKVGiwX8MjadAQEkeGDZab97AjmyU2pm5
         Rlwg==
X-Gm-Message-State: AOAM531hPvlv5rwJpb+2wrZ2NeWlrdB1u2DocFz6oNkZ2gbzcXORO1tT
        f54ZBe5VBCs+PTLQp4ISmXsuyw==
X-Google-Smtp-Source: ABdhPJwBRkFSJRPO5VTttkswQA1+IQChU9KFl1wv2ylCjjjm9j08u45iNHd4WuA3Qe/3uKHyAKklAg==
X-Received: by 2002:a2e:9bc3:: with SMTP id w3mr7882222ljj.170.1590151938848;
        Fri, 22 May 2020 05:52:18 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id j133sm2404003lfd.58.2020.05.22.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:17 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id A96B110204C; Fri, 22 May 2020 15:52:19 +0300 (+03)
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
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 02/16] x86/kvm: Introduce KVM memory protection feature
Date:   Fri, 22 May 2020 15:52:00 +0300
Message-Id: <20200522125214.31348-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide basic helpers, KVM_FEATURE and a hypercall.

Host side doesn't provide the feature yet, so it is a dead code for now.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/kvm_para.h      |  5 +++++
 arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
 arch/x86/kernel/kvm.c                | 16 ++++++++++++++++
 include/uapi/linux/kvm_para.h        |  3 ++-
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..3ce84fc07144 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -10,11 +10,16 @@ extern void kvmclock_init(void);
 
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
index 2a8e0b6b9805..c3b499acc98f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -28,9 +28,10 @@
 #define KVM_FEATURE_PV_UNHALT		7
 #define KVM_FEATURE_PV_TLB_FLUSH	9
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
-#define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_PV_SEND_IPI		11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_MEM_PROTECTED	14
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..bda761ca0d26 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -35,6 +35,13 @@
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
 
+static bool mem_protected;
+
+bool kvm_mem_protected(void)
+{
+	return mem_protected;
+}
+
 static int kvmapf = 1;
 
 static int __init parse_no_kvmapf(char *arg)
@@ -727,6 +734,15 @@ static void __init kvm_init_platform(void)
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
+		mem_protected = true;
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

