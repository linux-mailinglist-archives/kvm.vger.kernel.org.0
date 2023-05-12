Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F17012C0
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbjELXw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241273AbjELXvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:51:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE47E709
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:51:10 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-24e16918391so5739735a91.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935455; x=1686527455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GHUYV32ME1G34t9dLxIdgC9KAsI3wgHSef3OtvHGUi0=;
        b=uhvP9GADu6S2ysvZ4kh5xkuiPjuKVJRMq0PLpWZGHB4wN8ed+iVJWoHLk2ep7fROUS
         IJycgzlSDI8KEjSYA7mhEkmYSTSRapx9HtpLQpyiXnYjv4PIH3g1bQjbPE3jFf8lpkt5
         Gz78mLJDvk26m0aoygfQSTni1RV6EEk702oXX0lbtARIPa5i+nG1qe/9p8WYi7EXQ4ci
         sWm00cWad9ylKiwTdJF0lEvU75K1r2JFScJziAkNIJO6xRwg3MMPi7Tas8rH0Q4N5lv+
         D3uIq9/OHxMY191f2bHbcVrxhuqdvgJLL6xlE8p5uPUNNs0RStLkt4Bg59filrO+q2W+
         Hz3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935455; x=1686527455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GHUYV32ME1G34t9dLxIdgC9KAsI3wgHSef3OtvHGUi0=;
        b=fo1cjPMPBG5GHiqiHEHkRM2xK3mOzxbeKLKb38E2UpJPSf9hvGrG2hmF7Q0eiNSSL2
         0iUm7HtO9OZD/Ss3JfoVqrYLiioAENO2q7Ty5JwdYKUSy+Oot4SXIRO8QUsedz/aGcu0
         e089bc2wK6x5sHwlVW8+NaP7k9cIqvP5VtUVCTBhjG9FyGoE9jf4WwcdmLGWnsxef5ix
         vOHNztYQSYYw9XIdITp9DvULLx+NAcnDHjgn7BXUdSuoRVTCbuOEaQPcmx4MA3ruAABZ
         TSEvV3AkK4GobDK0R5t25tWFJAycfJvkIcn81hOlumgbWBOUA7LQpOvnm5pm0k4ikhGh
         Bfbg==
X-Gm-Message-State: AC+VfDzNAbyGcpVvkWrw4870GO5rgM3OdX61aQqKI/NrjeZQCsgvp/qU
        wjbyRJFUT4vxaFZVyyZu5pMXqRDy9IY=
X-Google-Smtp-Source: ACHHUZ5Q/Sy2dSoFMDVllQliE/fb5qz6zq0oSCa0U5wcU+tF+6w0q8dnUNsC+gKScE1N5jOd94K19SP9wn8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:8d1:b0:252:7118:4711 with SMTP id
 ds17-20020a17090b08d100b0025271184711mr2723466pjb.5.1683935455774; Fri, 12
 May 2023 16:50:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:22 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-15-seanjc@google.com>
Subject: [PATCH v3 14/18] KVM: SVM: Check that the current CPU supports SVM in kvm_is_svm_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check "this" CPU instead of the boot CPU when querying SVM support so that
the per-CPU checks done during hardware enabling actually function as
intended, i.e. will detect issues where SVM isn't support on all CPUs.

Disable migration for the use from svm_init() mostly so that the standard
accessors for the per-CPU data can be used without getting yelled at by
CONFIG_DEBUG_PREEMPT=y sanity checks.  Preventing the "disabled by BIOS"
error message from reporting the wrong CPU is largely a bonus, as ensuring
a stable CPU during module load is a non-goal for KVM.

Link: https://lore.kernel.org/all/ZAdxNgv0M6P63odE@google.com
Cc: Kai Huang <kai.huang@intel.com>
Cc: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b347173b4e29..cf5f3880751b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -523,18 +523,20 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 		vcpu->arch.osvw.status |= 1;
 }
 
-static bool kvm_is_svm_supported(void)
+static bool __kvm_is_svm_supported(void)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
 	u64 vm_cr;
 
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
-	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON) {
+	if (c->x86_vendor != X86_VENDOR_AMD &&
+	    c->x86_vendor != X86_VENDOR_HYGON) {
 		pr_err("CPU %d isn't AMD or Hygon\n", cpu);
 		return false;
 	}
 
-	if (!boot_cpu_has(X86_FEATURE_SVM)) {
+	if (!cpu_has(c, X86_FEATURE_SVM)) {
 		pr_err("SVM not supported by CPU %d\n", cpu);
 		return false;
 	}
@@ -553,9 +555,20 @@ static bool kvm_is_svm_supported(void)
 	return true;
 }
 
+static bool kvm_is_svm_supported(void)
+{
+	bool supported;
+
+	migrate_disable();
+	supported = __kvm_is_svm_supported();
+	migrate_enable();
+
+	return supported;
+}
+
 static int svm_check_processor_compat(void)
 {
-	if (!kvm_is_svm_supported())
+	if (!__kvm_is_svm_supported())
 		return -EIO;
 
 	return 0;
-- 
2.40.1.606.ga4b1b128d6-goog

