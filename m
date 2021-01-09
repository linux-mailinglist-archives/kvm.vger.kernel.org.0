Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F35A2EFC6A
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbhAIAs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbhAIAs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:48:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B5CC0613D6
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:47:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h75so17120033ybg.18
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Yn6K+Al6keU4qwvbVZAct8COFyc60/5tuafg8uWsv9s=;
        b=bbeQTlQl3egG62Ts6ELH5KNNB1jDgXjcJJ90vMoAdtAKoeEiqM2CZMAQB5H6m9v8Vu
         5m9u58NKIAKLJSRavQpaV8lEz5bYnHTlqyXzGbHJvzD508hT9ojxxTZqEFOSLGaBNy+r
         QQBpoZY6+8wxikOg3TfgNPg97eayvDZchKJHk0okuKRdxJjdQRVaq3PnCIpGSk77mFHg
         IaPE51sBvZKJFGwCt6IUs3chaUWzkpILtYdB9fEx3eVTtxIHVfcLZzcw/gUxtggklfgv
         3X6oWAK31B4kFg9gihTEFgIJUBwWrbvBrOsJfASBMJ4izzb4iVmB3/zVCxzvJ2gjHE4D
         pxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Yn6K+Al6keU4qwvbVZAct8COFyc60/5tuafg8uWsv9s=;
        b=ZTKx1sdRJmFz7DgGV78f8CK5HvTBwJr/QZFQ3u95hFVWhWVI8C7nfeX8UsOHTllu9X
         t+a4PjODKqrKBzcBxQmN8shfhZFZw1uHG9qCS8jraEOAeqawluLQA/r3Oy7w7ZcfwQB2
         lqXCTM4To2LmJfxhH//r06I+l8uVxSdTxROdaYqPOC9+IJUyDhwGvYxEE/3Q2nAzy8o3
         ROyaHlsPh4qT1eHsyaGydpYK5Uk/VznNENYwoUR8vT8lTILWEqAmHBnzbNCwPawQOeR1
         U15Do7O0+6c1ypwmlQSu0hXbaFqlidvgxg+6GrpBdHow4t1f9Hork4cGAqly7pxfY82A
         jLSg==
X-Gm-Message-State: AOAM530qh+MIkLX5wHk4J+QLG/vjRJ/W45kLL2CKjLu7Gk/nPi8hYIxc
        Qt7P8IlcBijHnxWTQHHIQp7p5naOS7Q=
X-Google-Smtp-Source: ABdhPJw8Ab/qkwt78ZZE2NGcdQ0yQpXhvA6LzJuzAUzND8QoHjON60IqsbbpXsOwcij2k7Iq2cO93ORPWng=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a5b:b49:: with SMTP id b9mr8648623ybr.310.1610153262395;
 Fri, 08 Jan 2021 16:47:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:04 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 03/13] KVM: SVM: Move SEV module params/variables to sev.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unconditionally invoke sev_hardware_setup() when configuring SVM and
handle clearing the module params/variable 'sev' and 'sev_es' in
sev_hardware_setup().  This allows making said variables static within
sev.c and reduces the odds of a collision with guest code, e.g. the guest
side of things has already laid claim to 'sev_enabled'.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 11 +++++++++++
 arch/x86/kvm/svm/svm.c | 15 +--------------
 arch/x86/kvm/svm/svm.h |  2 --
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0eeb6e1b803d..8ba93b8fa435 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -27,6 +27,14 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
+/* enable/disable SEV support */
+static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+module_param(sev, int, 0444);
+
+/* enable/disable SEV-ES support */
+static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+module_param(sev_es, int, 0444);
+
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1249,6 +1257,9 @@ void __init sev_hardware_setup(void)
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
+	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
+		goto out;
+
 	/* Does the CPU support SEV? */
 	if (!boot_cpu_has(X86_FEATURE_SEV))
 		goto out;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ccf52c5531fb..f89f702b2a58 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -189,14 +189,6 @@ module_param(vls, int, 0444);
 static int vgif = true;
 module_param(vgif, int, 0444);
 
-/* enable/disable SEV support */
-int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
-module_param(sev, int, 0444);
-
-/* enable/disable SEV-ES support */
-int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
-module_param(sev_es, int, 0444);
-
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -976,12 +968,7 @@ static __init int svm_hardware_setup(void)
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
 	}
 
-	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
-		sev_hardware_setup();
-	} else {
-		sev = false;
-		sev_es = false;
-	}
+	sev_hardware_setup();
 
 	svm_adjust_mmio_mask();
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0fe874ae5498..8e169835f52a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -408,8 +408,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
-extern int sev;
-extern int sev_es;
 extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

