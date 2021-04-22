Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1F7367731
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhDVCM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbhDVCMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C2CC061348
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u3-20020a2509430000b02904e7f1a30cffso18183437ybm.8
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Cy2Z9StAFaCNNYaNTHLegOTVABQ53S5igs8EWDLg6pk=;
        b=IXguRzzVn9daPNKJlaXl9w0jTiRuxgv1WJWWwygmTJEJMxqmp4w5Xz3KGZoQ13ysVg
         PuwGjus8egsQr9wKsGEoCcjuONqkskRV4953lQq/tFh3UH/j6P/tvYBw3JFBtyE0x39Z
         jkW5gs35v0vTHkq3pyxf4mkZXAgAKShL+mbYDm1eMzFRaYRWoLhscvY3iCh7rpwjZCKD
         /QzSYI1Dhex3UPofI5gUhAqseuo2/900mqukuheP68OINGluM8JCUxabzosldjkOA+Zc
         RAVZB+r2uJ8bu+8BJwZsTKFkxLowOVHxmi0LQXnCDFZvDu0fy8965+F3Nn1+ECPLIMuF
         oqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Cy2Z9StAFaCNNYaNTHLegOTVABQ53S5igs8EWDLg6pk=;
        b=uEkIcNmEDKch7mDo1H+d2uSw3ty+o80qJmIXNVNJX4ysIKApq8Uf0S2PQPrplBK0Zc
         BoKHtuCKiIgOyushS60P5gzJkbQ+MYuzRVJ9vBilaedTJX1x6mVrImc5dX9oxpeduEas
         8KZaodMDwqfwnyQ1sllzKoilJqHJLgHw/9dTWpyhr9/WTlftkwUUoheN6z433X6/6dzK
         niZ0yxGi4kMC5LA5bnVo3bpysoqp4WRAAlzTDFQ7VVcLQHvdfAN0q55aWvrMorMPoHea
         uYahpGrE6O6ME0pzdJziuKgKBP1nAqW5BX9KIlMAQfxdBFmzKoDldAO/r8ovP55JB/Mh
         +uAg==
X-Gm-Message-State: AOAM532MSxcjL/mfCYOF3Bw+godxJHJBjImNTa0YbLnUErG7+FtXA/aR
        v+EEjLA4AD1v2wb2v2W+ulBwkva3bTQ=
X-Google-Smtp-Source: ABdhPJz0ISdf1ulAOT2Gusp2f/urMVPQ+VYrgVutNeaPJRqtEp65I+u7rLYDt36EBfstqBEk9lFfimxhuMM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:b78c:: with SMTP id n12mr1415301ybh.291.1619057503778;
 Wed, 21 Apr 2021 19:11:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:17 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 07/15] KVM: SVM: Append "_enabled" to module-scoped
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
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e54eff6dfbbe..9b6adc493cc8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -29,12 +29,12 @@
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
@@ -1452,7 +1452,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!svm_sev_enabled() || !sev)
+	if (!svm_sev_enabled() || !sev_enabled)
 		return -ENOTTY;
 
 	if (!argp)
@@ -1471,7 +1471,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 
 	switch (sev_cmd.id) {
 	case KVM_SEV_ES_INIT:
-		if (!sev_es) {
+		if (!sev_es_enabled) {
 			r = -ENOTTY;
 			goto out;
 		}
@@ -1766,9 +1766,9 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_set_cpu_caps(void)
 {
-	if (!sev)
+	if (!sev_enabled)
 		kvm_cpu_cap_clear(X86_FEATURE_SEV);
-	if (!sev_es)
+	if (!sev_es_enabled)
 		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
 }
 
@@ -1778,7 +1778,7 @@ void __init sev_hardware_setup(void)
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
-	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev || !npt_enabled)
+	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled || !npt_enabled)
 		goto out;
 
 	/* Does the CPU support SEV? */
@@ -1817,7 +1817,7 @@ void __init sev_hardware_setup(void)
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
-	if (!sev_es)
+	if (!sev_es_enabled)
 		goto out;
 
 	/* Does the CPU support SEV-ES? */
@@ -1832,8 +1832,8 @@ void __init sev_hardware_setup(void)
 	sev_es_supported = true;
 
 out:
-	sev = sev_supported;
-	sev_es = sev_es_supported;
+	sev_enabled = sev_supported;
+	sev_es_enabled = sev_es_supported;
 }
 
 void sev_hardware_teardown(void)
-- 
2.31.1.498.g6c1eba8ee3d-goog

