Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC2F32F7AD
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhCFB7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 20:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhCFB7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:34 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42738C061760
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:34 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l3so4591438ybf.17
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vmcGmk+Vm9vhHjgz85v0IA+Ji7MKdjD0nsFKV7vXjsg=;
        b=B31csmYffTVH6zKEJ0h+k9QadOEhWoraBL922nym5drFDOMkkEKGwB0VOgTkCBOpPe
         OLLSHgWVUiAJCTJgnFYChZo/PMqCq02Gs0yyfg/16i1LMMkkFXNKUFydYrTUrTbYeww5
         6lwDZts9BPaWno/IfLe1tT3HIOmT4fcCXrrIpi39eue33UIe5vP9tw9sMO4nT1jiGcWp
         3qoIMCkVWq0pxh2EdvWuEdt8PmFwDltsbGnkHnFjL2N14UiC+f+3iFgDvo8Mm6C3B6Yt
         /AY/McFEDXTPOJ9v/fsKD2DHlYwXdkdLTTruOsUyTXx+WZf5c2jRNAgKTORmOTMDTQgM
         LUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vmcGmk+Vm9vhHjgz85v0IA+Ji7MKdjD0nsFKV7vXjsg=;
        b=HPQIPPzLBy604+4sySbHnVfEgMDduPrwbGGeANvo8NnTC+jCyA9wUvjHptH546UMwm
         zwvYzQo6jqyfzyVWyKKaEV6DI4Sje8V85cxINhsH+mu1Lys13BRxfAIrNGsZspCP9O7B
         KiMbEvoypjZEfoNaayayFiSmKXsArLO5BL1bxOP61yK/h7LVXSI6nkJS7f/pOqgwHKSt
         blI84uiDDgMs1s8fcmkbV/ilL0M7A2PDsY4OHE19Ax4+iECkSSnLJrYedplSdeGy91Id
         KiEUwwio2ToH26ycbQJrIS43VaI1mvMhI5zqfJwttW3120N3baTG9QQwwa/BfkqvH09r
         9AdA==
X-Gm-Message-State: AOAM530oJ7PaGLLVX0751sfdXrrF0oi3x1rdpCtJuX5mzOnm2LiwWKDH
        cWlh3/1dsDi5ETTSLI2vUql41EWBf1c=
X-Google-Smtp-Source: ABdhPJzviW7S6I0sWZAIN6tg2h63qb+o9JsWpM1EDtp4sQMgwTNzoxJzBPTJzJbK2HvjeII3f/9u6oMZq2Q=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a25:3250:: with SMTP id y77mr17549656yby.154.1614995973476;
 Fri, 05 Mar 2021 17:59:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:58:58 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 07/14] KVM: SVM: Condition sev_enabled and sev_es_enabled
 on CONFIG_KVM_AMD_SEV=y
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
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define sev_enabled and sev_es_enabled as 'false' and explicitly #ifdef
out all of sev_hardware_setup() if CONFIG_KVM_AMD_SEV=n.  This kills
three birds at once:

  - Makes sev_enabled and sev_es_enabled off by default if
    CONFIG_KVM_AMD_SEV=n.  Previously, they could be on by default if
    CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y, regardless of KVM SEV
    support.

  - Hides the sev and sev_es modules params when CONFIG_KVM_AMD_SEV=n.

  - Resolves a false positive -Wnonnull in __sev_recycle_asids() that is
    currently masked by the equivalent IS_ENABLED(CONFIG_KVM_AMD_SEV)
    check in svm_sev_enabled(), which will be dropped in a future patch.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d6f069271e75..4b46bcd0efc5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,6 +28,7 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
+#ifdef CONFIG_KVM_AMD_SEV
 /* enable/disable SEV support */
 static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -35,6 +36,10 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+#else
+#define sev_enabled false
+#define sev_es_enabled false
+#endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
@@ -1328,11 +1333,12 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_hardware_setup(void)
 {
+#ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
-	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled)
+	if (!sev_enabled)
 		goto out;
 
 	/* Does the CPU support SEV? */
@@ -1387,6 +1393,7 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+#endif
 }
 
 void sev_hardware_teardown(void)
-- 
2.30.1.766.gb4fecdf3b7-goog

