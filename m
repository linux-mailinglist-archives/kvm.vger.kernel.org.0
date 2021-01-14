Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0AF2F5674
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbhANBsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbhANAjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:39:54 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD2AC0617BA
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:53 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id v1so2955335qvb.2
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8hi5Ghzd+1VrsTwQyXoSKnwtmn+Mg6zWlEamMMT6obA=;
        b=Eq1H8fN0JB+G3ZiEqZS9aXQv0LLbUFqfJ8mzQwOWkpkYI9P5GtPZZOq/4tNnnCEBmh
         gB4OeUFxH6cGxp14mEDplRZkCql3lYXQIYv4u+1cfOa3Mw9XVASyW7FzpI6EqysthIXd
         UUQ/sSiPIjW7fhYfx3ILgu+5XwfWEmaj0MMWBCZG611PT6phOvedcZ4rhTpV0K6ov9Qd
         n4pi51/TsHY2nz7s9/hR+19iOMOVp9O7GPO7ZwEzLw8X/dIDwTJwbcAeJIJgh6HLCNhx
         xWYyExMoEZaJTHsYZyayNuuXAi/4fHAITl7adS+UbrgmzuAuPWKihGkzM0Wr5uSlCaB1
         xm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8hi5Ghzd+1VrsTwQyXoSKnwtmn+Mg6zWlEamMMT6obA=;
        b=gj6LX/zcnZN/SDFiA/DpaxbETSIAS8vfFG+C96faiQjTKbEEfWt7daCoDuFGODX4DV
         cIy8H+d1NLS/hamToOTOxxP3UzkE79jKb9gBFpitWGgAx3HgW42IPTdR/XNONzlfWjgN
         22VAf/eVfuGpGEdRdvxh4l9MVLH7eqQc81/l0cSezzsT+yJOBXsL15C1m3OQ83HRnxOC
         EsYJeoiANixtVTtJzRdd6sphWEBNZVR8teuSBwp3gpZfSMo67MQ8OLC8b/7paU4t7F23
         AsxGAmaBHaGCOpKJjQQMNhTIYFiVbs3xBYAqsaSGm56uO5/vVGJptO7AdbxyL+QwdRCb
         cxNg==
X-Gm-Message-State: AOAM533M+p4igWrgRkVcP/Rde6c5Ztb5NbkdzIG7ImtIWi1P5GhfBfpH
        5VjoD/AWuIjOMZF8g6FZESNTYPAC8hE=
X-Google-Smtp-Source: ABdhPJxS6rh2CW7+DImyzzIl9MDcDr69k2UOIU/zNjlCPMX5snioRBw4oBxFDLObWsPqBbE15aAwisfiOI8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a0c:ca13:: with SMTP id c19mr4896807qvk.21.1610584672335;
 Wed, 13 Jan 2021 16:37:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:37:01 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 07/14] KVM: SVM: Append "_enabled" to module-scoped
 SEV/SEV-ES control variables
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

Rename sev and sev_es to sev_enabled and sev_es_enabled respectively to
better align with other KVM terminology, and to avoid pseudo-shadowing
when the variables are moved to sev.c in a future patch ('sev' is often
used for local struct kvm_sev_info pointers.

No functional change intended.

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8ba93b8fa435..a024edabaca5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,12 +28,12 @@
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 /* enable/disable SEV support */
-static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
-module_param(sev, int, 0444);
+static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+module_param_named(sev, sev_enabled, bool, 0444);
 
 /* enable/disable SEV-ES support */
-static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
-module_param(sev_es, int, 0444);
+static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
@@ -213,7 +213,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	if (!sev_es)
+	if (!sev_es_enabled)
 		return -ENOTTY;
 
 	to_kvm_svm(kvm)->sev_info.es_active = true;
@@ -1052,7 +1052,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!svm_sev_enabled() || !sev)
+	if (!svm_sev_enabled() || !sev_enabled)
 		return -ENOTTY;
 
 	if (!argp)
@@ -1257,7 +1257,7 @@ void __init sev_hardware_setup(void)
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
-	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
+	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled)
 		goto out;
 
 	/* Does the CPU support SEV? */
@@ -1294,7 +1294,7 @@ void __init sev_hardware_setup(void)
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
-	if (!sev_es)
+	if (!sev_es_enabled)
 		goto out;
 
 	/* Does the CPU support SEV-ES? */
@@ -1309,8 +1309,8 @@ void __init sev_hardware_setup(void)
 	sev_es_supported = true;
 
 out:
-	sev = sev_supported;
-	sev_es = sev_es_supported;
+	sev_enabled = sev_supported;
+	sev_es_enabled = sev_es_supported;
 }
 
 void sev_hardware_teardown(void)
-- 
2.30.0.284.gd98b1dd5eaa7-goog

