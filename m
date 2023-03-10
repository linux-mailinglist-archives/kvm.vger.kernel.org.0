Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDF26B531B
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjCJVpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjCJVoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:44:24 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EEEDDB25
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:43:31 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t185-20020a635fc2000000b00502e332493fso1610837pgb.12
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qBcz2mERBbm0KpMlPQ5X2eESMX5T/tz8It36IggkYIA=;
        b=UEkYJ+O3FYHxietZ/9hAIbIUniSp/D7b6gTZnFmpwt1cBGPLj+kXoryW0lD96tZQgz
         m8Yb/jQogzJSm2E+TseAdhxD3HjqaK22W/PC3jPBvSM74PPG7Vrc41OG5fJ58gZ4z6bK
         db1+jL5vBqa1CEAzNSijqkX1/bUAYY4RpYhsOIcS0W5cZDBXijQ6rl5Pm8byrieIRV/w
         nYjv0LL2gp6muNmL2ltR/9l4nY8VjbYslT24BRnOLbdcY6oaGb6rs+SymF/oAV8IV5Xi
         BVjIxtnCgQRlbXdnUYaBEfaeuHopSMyHbuorSLBPuiA632srVjIZa83WsFi+DWNhkhsp
         03KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qBcz2mERBbm0KpMlPQ5X2eESMX5T/tz8It36IggkYIA=;
        b=tOuzF/c4TJwJeQrFeFPg6dVQSXDB0MwKJij5A1QX2Q+n2LX2MHqGRzvRpJDjzYQWNc
         u0A7CW1unTCV6HGCejEC/P+YX/h8RlsRRqR91ZOoMVKjnkDvqEj6fn6FTCb3mjOSBa9z
         djQYnY/kSqP9wqw8Pfds3hhY4Pegg5Key5ppn2Y1XWbEAWeyfIVoNqUi+krBwo7qul1/
         SGXYyChGeVe32qcO0wx/nAVw2ZiS603PRxZE5C6gdkr3rPIY0WX8NX/P/UEZQk2Gu9Um
         aVZDRXmOOLcm8m8TbfY7Ir2W/WY/38ybk22fMoKMJWOX8wK9yMcOavQZ6lsCIE1+fvPX
         Rs8w==
X-Gm-Message-State: AO0yUKWsweAQd/HmauBLk8njgKKCf8Jhb5RKXc298ElwAln6CT03cMAq
        xpl8jU911JaBQ2edQH96ly/xo8BhS1o=
X-Google-Smtp-Source: AK7set99rQjpzhzapgfZC3z6++DVf/2R+5TOo/ec+XGtB24rFm4fPaqwftwUKzx431/pcoUU0CJQJimX08M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:dbc5:0:b0:5df:9809:621f with SMTP id
 f188-20020a62dbc5000000b005df9809621fmr11079354pfg.0.1678484592298; Fri, 10
 Mar 2023 13:43:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:32 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-19-seanjc@google.com>
Subject: [PATCH v2 18/18] KVM: SVM: Use "standard" stgi() helper when
 disabling SVM
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

Now that kvm_rebooting is guaranteed to be true prior to disabling SVM
in an emergency, use the existing stgi() helper instead of open coding
STGI.  In effect, eat faults on STGI if and only if kvm_rebooting==true.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 30f7840151be..420b35770f0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -591,17 +591,10 @@ static inline void kvm_cpu_svm_disable(void)
 	rdmsrl(MSR_EFER, efer);
 	if (efer & EFER_SVME) {
 		/*
-		 * Force GIF=1 prior to disabling SVM to ensure INIT and NMI
-		 * aren't blocked, e.g. if a fatal error occurred between CLGI
-		 * and STGI.  Note, STGI may #UD if SVM is disabled from NMI
-		 * context between reading EFER and executing STGI.  In that
-		 * case, GIF must already be set, otherwise the NMI would have
-		 * been blocked, so just eat the fault.
+		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
+		 * NMI aren't blocked.
 		 */
-		asm_volatile_goto("1: stgi\n\t"
-				  _ASM_EXTABLE(1b, %l[fault])
-				  ::: "memory" : fault);
-fault:
+		stgi();
 		wrmsrl(MSR_EFER, efer & ~EFER_SVME);
 	}
 }
-- 
2.40.0.rc1.284.g88254d51c5-goog

