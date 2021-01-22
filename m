Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DF3300DA7
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 21:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbhAVU0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 15:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731101AbhAVUXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:23:42 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4F0C061794
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:21:59 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id d1so4408076qtp.11
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DVxhAu/UjXY5hWMeDmkVTFl5iW0qT/7YPmVJEXaHiSg=;
        b=ZiWyRwgQQPsTNO8N5PSnPu5eQG0ql29pRJuVy3Q0C7kKDGhFCO/+TQG6iSFTaXxXjx
         fUUZX7tK7+ogZkzXsq1Hpp3DSjuYwFg+IvlC4BLond2ANBD9oLoKQDgnNVJ/BswOC8M1
         x+mm/5jD58EFv0RyJ9gUUSUsVE0lu0jEKevCXKTRRLdyY7+JXnGVyjkDpbsiL+FGZgQU
         GEEAyXMt8JKLC7g96brHbYaigGyD3lSVM8HN6Sa0kOMsUvNObuMIL1GHtGVgz8nqH8+f
         Di/Y90jPGY842vnFqLC1DXPUf9dvzH6V8TSoAnFvDd8vuTkz6Uf7X6Xm0KSgdBi5I87X
         cEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DVxhAu/UjXY5hWMeDmkVTFl5iW0qT/7YPmVJEXaHiSg=;
        b=cmQQMUd0VR+ZeSJApRN3IGY68B4ju6OElSgxWNT1F/VTJiGSJTbqyt/OUtrSDb57Nz
         KK/e7JaDcqRI6aMbbO5eE30TgUPOI91v2YYBrMayv9PkTs79FjyU2QEVQnEi4z37qP6m
         ZbQzsZR0lX4TycEyVXeyjrVI46vKCH1gjesE6xv+x6fYRaGrCupA4C70V2yqsIeueG9o
         Fd2DMvpImqEEZBA+TZFbw8ZxkbLXywLshkErz8lBAmlroKgmrCQRUStJBtUEVfwG6yu8
         Y0NQHqLC7Sxm4wuqdIOlbK7G7eyVtrcCj4v41I27J6qBhSmliPZaNWy2pEtIzfLZD5D+
         +v6Q==
X-Gm-Message-State: AOAM530K6SkkvDwVFHglAgx/fAs2MginfrmdCvAyCOZLrQjc1WnNl4Gw
        1a0yJ9HztveiIR1M26f1H9YMzLngZ+U=
X-Google-Smtp-Source: ABdhPJxaBwxpO2PVbRBf95Ce2ILMQNBt6KRaW/RPOxJeX8apG7sdSe+2zruPj77KXUpL2dzsQ0yn5xSnF9s=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a0c:a99e:: with SMTP id a30mr477497qvb.38.1611346918763;
 Fri, 22 Jan 2021 12:21:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:21:34 -0800
In-Reply-To: <20210122202144.2756381-1-seanjc@google.com>
Message-Id: <20210122202144.2756381-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210122202144.2756381-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 03/13] KVM: SVM: Move SEV module params/variables to sev.c
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

Unconditionally invoke sev_hardware_setup() when configuring SVM and
handle clearing the module params/variable 'sev' and 'sev_es' in
sev_hardware_setup().  This allows making said variables static within
sev.c and reduces the odds of a collision with guest code, e.g. the guest
side of things has already laid claim to 'sev_enabled'.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 11 +++++++++++
 arch/x86/kvm/svm/svm.c | 15 +--------------
 arch/x86/kvm/svm/svm.h |  2 --
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ec742dabbd5b..4595f04310e2 100644
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
index 5bd797c7ee60..d223db3a77b0 100644
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
 
@@ -975,12 +967,7 @@ static __init int svm_hardware_setup(void)
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
2.30.0.280.ga3ce27912f-goog

