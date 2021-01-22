Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4783B300EE4
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 22:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbhAVVZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 16:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbhAVUX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:23:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DA2C061353
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:07 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k33so6580517ybj.14
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MltbaRObml30irkHPhgSbtFeSOXawRLwmxqzNuTe6aI=;
        b=pSdITsON5EyzA+MhtZPLM/gGWiDf0fqN/GPANsauf5py/l7Fr0W7OhMbjm8ewT2z6r
         6r1z3WduX2GIAYhSsHmNq2hQ2k2dMHm/vzkrHJC6/zaXYyX9u2QKLiZap/neklDxhOLG
         IjJgQ2iQWF58k3TvxfIppW9C90fWBSBChWChtHXK1599zECbt9ycEQVowkjR/0qusD1Z
         UJVK2GT6Rr43F2loo01Er78y1oZfKdO/QY4dBvx33U5/hClLLwfrJr7aKuLThtOXqZ+k
         erGdJCr4WpoKSVXIwBq2hEmXlCnMpJzAaUWKc1C0hPRA7EOis+SPnZfg50CgCXEOWA/Y
         DTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MltbaRObml30irkHPhgSbtFeSOXawRLwmxqzNuTe6aI=;
        b=cujuveQDTD5QYK3Wi9urT4IlFKrtrI9/bSFdhuRRVvE4iw/AWFkBzG5pDNPJsLDteo
         qnUhrZY8b6g3W3VngBR4tReceUNAimvHNn0ordHG2Nv1Tl/ehoUmw+oiuXsjQn9hn6uN
         4tHjocRTVbUYMRg8nBkYjdb5jdJwaRNPJBJsnXfuAuWEnE8Ax4VU01aphiOPVCmpo/Sz
         1P/HKGDD7kEhDFtqkzROYofIFkZ8xZqUHgniWtlY01cO7jV3WjYDx1VcmDTDL6Spg5eY
         rxBIKghL4dhJ+ZG5szH2k1hBQpSHyui0e2czaGZ8nV9cIkl70/UMEU/N/SgBwWvlLZFh
         ADbA==
X-Gm-Message-State: AOAM530Fb1cVEGDljQeRYVpdewQodwAqBlyUaez+NPkyHfqxld51N9eq
        /uPP5u/31G9fuqYgqcIQKzJylTgmqkc=
X-Google-Smtp-Source: ABdhPJzcUotv0kIBRELBwBqOKSLnsQCJK+jxA2yJR6PV7MH2GMa5Ss6u3XDPtIHzhCnxD7pFAXbrJMCY3g8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:1182:: with SMTP id 124mr8566063ybr.154.1611346926401;
 Fri, 22 Jan 2021 12:22:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:21:37 -0800
In-Reply-To: <20210122202144.2756381-1-seanjc@google.com>
Message-Id: <20210122202144.2756381-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210122202144.2756381-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 06/13] KVM: SVM: Condition sev_enabled and sev_es_enabled
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
index ef2ae734b6bc..2b8ebe2f1caf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -27,6 +27,7 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
+#ifdef CONFIG_KVM_AMD_SEV
 /* enable/disable SEV support */
 static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -34,6 +35,10 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+#else
+#define sev_enabled false
+#define sev_es_enabled false
+#endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
@@ -1253,11 +1258,12 @@ void sev_vm_destroy(struct kvm *kvm)
 
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
@@ -1312,6 +1318,7 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+#endif
 }
 
 void sev_hardware_teardown(void)
-- 
2.30.0.280.ga3ce27912f-goog

