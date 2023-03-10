Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8684B6B5311
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjCJVob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjCJVnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:43:53 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A86460A2
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:43:12 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y35-20020a056a00182300b005e8e2c6afe2so3478021pfa.12
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rC7W/TqT22prVrI7aB30rmCsROsWsHiXQzcC62nOUVE=;
        b=iECHnkG467xDPY1Eiyle7PL8wxFL51+1TZWXikdwu7gxUwWYDClHEPwSxUkrC7y1tw
         JsHpy7ESprLNxI1z6el5lumWkookOk26kZFLngxJOpaoXmYFvIUxmO2Z3YMTSTMqIQeX
         mor/+/cf7/r9Ji4q/wqCG2D6rgx2ygg/NGxGn8p+oLZu6E/OQoFCYoLc8DF+RsFDIizT
         7SxysKD8Pm2rYQPzLc+XO2OPfqtbAnh+e1RapTgRfkDj0w9c4Akii85ZVOc45tG/Dtyf
         7HlzdUFeWE6mVhVKR+epAv0h0Jd8KoihYHJAQ0DRhTYD2jz8Zsh3eE7UZxFE6t6qr3W6
         0whQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rC7W/TqT22prVrI7aB30rmCsROsWsHiXQzcC62nOUVE=;
        b=y21zk5HAIKCH2f57bKBkc+pT8OTLgPRYnn3LD677SQDCCcWJAP4jt/xVzv86JDf47B
         6mCEJpCgZ98MaMor0SpDVUAOoKhExhw6W1r7q0+c06fVhorV8P4bswm5iClmZgDFYZC7
         2KHHCdc8lF87iQehQ/5g534oXUiQ1FRh5fO0CiZ9RHNRVjx02Cb+EwNmyDHLHh29oA6o
         RBWKW1dzwKUWwwGwTO31yk0cptCTRQ1bJfBaahi/R+rbVFXC695bgoFx1K75zavU3a7G
         YTHBpVoX92c4SrnvLZdzGb2YbKP4wc9wcaQXR1xXnlTgRoGVEA56kz1LVW3/FZVssXG0
         nhUA==
X-Gm-Message-State: AO0yUKX4lbDjlPdZ3pYDNexW+rJKczurwzNtRkhEjpkac2jWkNkt3my6
        Pb9T+zJvsZzbqQwum5h3T9MSGcXYLxw=
X-Google-Smtp-Source: AK7set9MXr54PyId/iEJ6qzekrq7PViK712vFCJ51bVIADH7ggHNqsxUecek57lRHmxQmmWizk4QlIW9CJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:efce:b0:19b:5233:51d8 with SMTP id
 ja14-20020a170902efce00b0019b523351d8mr10727175plb.13.1678484582474; Fri, 10
 Mar 2023 13:43:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:27 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-14-seanjc@google.com>
Subject: [PATCH v2 13/18] x86/virt: KVM: Open code cpu_has_svm() into kvm_is_svm_supported()
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
index be50c414efe4..632575e257d8 100644
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
index 541dd978a94b..2934f185960d 100644
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
2.40.0.rc1.284.g88254d51c5-goog

