Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0161E75D591
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjGUUUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjGUUUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:20:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AD34214
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d052f58b7deso734664276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970772; x=1690575572;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uhoBWFPCBOgYgQs9Wbxf7anLd8UMxgDqXbWpH+bX2KY=;
        b=BqJBwjEk+/zhFp4v5DrxQNReQVSoNlh/Bn0hUbsO8ZiEO/etbAIosjlClY7b6ifBBy
         wi3HDJfJE+jUUceINpJHN6wSTWbqUmyfzZi1k/JQKHiIJGwA7j6u5reIne4DWb5D1UeB
         p7pcAuNqF4vndeC9wIz/8uWHcddezeQhI8tep358HE0tpXUoAcue+Ghl6YEpRZEzbO/U
         J3+qH1Zc8yvKpVjIjnIx/75G7nRlmV863pOmIuyo9J3xyzA50nbAtEa0Myyb9v3ipxpH
         kDIyKNilgiU1a4xzVdhXo9++dIWuAlATjktwg3RONaxNWlAzAQafqJVzTHbU6vE4FJ1e
         d34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970772; x=1690575572;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uhoBWFPCBOgYgQs9Wbxf7anLd8UMxgDqXbWpH+bX2KY=;
        b=M9JcTcJguxSNT1bnY/yFH4G51kw3ZGSkS4kymiC+aOVUMiDts3sWX9DRBEsclmAFoK
         iJMl+qMheDJatCYNq9VFdFvHY/r0X5gci7pxQqtb5yg1vSUeNsGbLpGWENA55o0d5qtL
         TW4Vmd49EEOJKOeHOd2z2qkTlrUGUT2yba6zbNmXsd/8VIjHT5z+2NWtGUTYPaUd98kD
         vGh8m01PnOd4vo2wgvmB+ME5jz2IF7TeQMeogk1DChamtt4tJWgm0yal2/ddpqNJFM6q
         /cOoeZxbYNJuu9fSxL+GWsKFFx2u5/TNX3snRlim9dNUPFwnstnZaKLgJiVKRisOSFmX
         Bu3Q==
X-Gm-Message-State: ABy/qLbF9ZxppjY4szGX1WrIJAsgSnBMIVOuV1trhu+RWa/tsOZC49RY
        wNa2nvqNAi4QS6ZRnPLcGBEwFzMXims=
X-Google-Smtp-Source: APBJJlG9ebou3TaLXiHu0JkY9v2NmMh1lndfe7foTeWkhO+fnKnQ3AxYQbow6FKkByZbw6dWuECajNEM6v4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:40cf:0:b0:cc7:b850:7f2 with SMTP id
 n198-20020a2540cf000000b00cc7b85007f2mr19598yba.5.1689970772756; Fri, 21 Jul
 2023 13:19:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:54 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-15-seanjc@google.com>
Subject: [PATCH v4 14/19] KVM: SVM: Check that the current CPU supports SVM in kvm_is_svm_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ff6c769aafb2..9e449167e71b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -518,18 +518,20 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
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
@@ -548,9 +550,20 @@ static bool kvm_is_svm_supported(void)
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
2.41.0.487.g6d72f3e995-goog

