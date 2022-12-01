Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3560363FC07
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiLAX2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiLAX2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:28:19 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D86CE429
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:24 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso2938936pjb.6
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V7jdLGRYb4fYAe8gIednP3AKBH7dhOuHWBQtK2IRaKg=;
        b=KrMJ/BgpveA+ly1uPiZ5pmidqkhZDKpo9w6VWcD7XE8wIMwUuj1AJO76QyHhE2cKtS
         fXybiajbUEedKZgAFffo2ZyWwqwKal5Dnjj7p8KuOscMWR6HqsJPbrVng9W73l8xn/JC
         ZL9LolusjV6VhRGkyJCW+JVCE84j6ZEov6ayjdEu0Vrl9FkK9P2cBQJpoT5E6Gg6gCj+
         2GofqL0ci/dwuU7kkQjlqIrBEMIdnnA7PYjgGDlItNlYmOKBYD6mX0OvSsazv2Tk+KWk
         uedUB3yAu9UsKRydgGMByIJR44IN6hPSNidlDqpGjlWz4XY4+r4ez9xqiCX/DBRay83y
         IIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V7jdLGRYb4fYAe8gIednP3AKBH7dhOuHWBQtK2IRaKg=;
        b=ZtDgkjxdZLmHS1XypUVdAcNC/th0YMXFUFcirxTiv+BNZ7UInRsBdeH4LVg24cDOMn
         COp4MSb7T+kvC9a3zhCoU9JJc3g9reG6W4lyWGRS/piIFkWnHubYOIfp2fC9q1BCxmVE
         /fqi3Nlzlw+G4uIN+h9xs+jMx/RmBQl31v8Wmm5DuPaCJckPCMvhEHecv1XNxPYul3If
         LF9oXSFdR6/iEaj8ce9S2/Rm5jSRXuOsSYEKZM/QnMSWG7uIPapoHUM0rwr6w60c6h1x
         Wo/WUJxc45xBg+GLdcrjgdnCXRci0Pv9FTbtpqn5AFKR5/JlJEZSr2A4YpuicmoSIXun
         91XQ==
X-Gm-Message-State: ANoB5pnudhGZdcU3LQe4nCtRut58F++CEfQ8eMFsX1PNs+TIXXelba+y
        If/XGToPj0IjyBm/E9PhUp0EqM//960=
X-Google-Smtp-Source: AA0mqf5OFUH4655YN7eGM/9Hpu4YrVFA8Z2vIAGHjTZvYAFUwFrrMer4WU/8uTn6DvxYUwdjKm0nDRy8wCw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9ec2:0:b0:575:d302:7443 with SMTP id
 r2-20020aa79ec2000000b00575d3027443mr10995163pfq.76.1669937244071; Thu, 01
 Dec 2022 15:27:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:52 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-14-seanjc@google.com>
Subject: [PATCH 13/16] x86/virt: KVM: Open code cpu_has_svm() into kvm_is_svm_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold the guts of cpu_has_svm() into kvm_is_svm_supported(), its sole
remaining user.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 28 ----------------------------
 arch/x86/kvm/svm/svm.c         | 11 ++++++++---
 2 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index eddc0eeb836f..683d20411335 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -22,35 +22,7 @@
 /*
  * SVM functions:
  */
-
-/** Check if the CPU has SVM support
- *
- * You can use the 'msg' arg to get a message describing the problem,
- * if the function returns zero. Simply pass NULL if you are not interested
- * on the messages; gcc should take care of not generating code for
- * the messages on this case.
- */
-static inline int cpu_has_svm(const char **msg)
-{
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
-	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON) {
-		if (msg)
-			*msg = "not amd or hygon";
-		return 0;
-	}
-
-	if (!boot_cpu_has(X86_FEATURE_SVM)) {
-		if (msg)
-			*msg = "svm not available";
-		return 0;
-	}
-	return 1;
-}
-
-
 /** Disable SVM on the current CPU
- *
- * You should call this only if cpu_has_svm() returned true.
  */
 static inline void cpu_svm_disable(void)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d56d5fe42262..ba281651dee4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -523,11 +523,16 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 static bool kvm_is_svm_supported(void)
 {
 	int cpu = raw_smp_processor_id();
-	const char *msg;
 	u64 vm_cr;
 
-	if (!cpu_has_svm(&msg)) {
-		pr_err("SVM not supported by CPU %d, %s\n", cpu, msg);
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON) {
+		pr_err("CPU %d isn't AMD or Hygon\n", cpu);
+		return false;
+	}
+
+	if (!boot_cpu_has(X86_FEATURE_SVM)) {
+		pr_err("SVM not supported by CPU %d\n", cpu);
 		return false;
 	}
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

