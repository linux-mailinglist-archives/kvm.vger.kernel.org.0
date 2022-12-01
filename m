Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2710763FC0E
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiLAX3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiLAX2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:28:50 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB176FACF
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:45 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id y6-20020a17090322c600b00189892baa53so4023757plg.6
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e1NugFnVCB110oXGMzrxJ93wD+BGdk2//9yqV+Q+IFc=;
        b=AMe6PZQjL+GG9iGCzR8Y1kDAWFNDPhfhQ+A1ONMZtd40MzMjOdxdVkLPy+o4zaOX0k
         EapYcGzlaA1WBqr4QlwRfZ/UOs5nydC4Z1Q/Gf0DfQdR3+VxXzQfOWCYeJSuLnkwtnNB
         L7Vajcoe+gve+aTRDGu6MsW0HaBmVK74RQOdCPb2q3azcTPtng2zprtO4MceWEGmlla3
         f3hiYd9MJ2N+xVUOXVq+DxA3f9DleU3IbHw/BTopzy8ZL9QIuIC8mpHHUKu8syJvajlJ
         alNgTMKhLluW+5etzrvrxstnTPTvrN0Wrp8jdMFi222FhOv00hZ6Xw+CcRQjc1UzjctI
         O/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1NugFnVCB110oXGMzrxJ93wD+BGdk2//9yqV+Q+IFc=;
        b=5XXjeCMYvRyxjNTUt0DhuuFM4BvWX+TpJ01n9vr4g85Kw3WiVAYCSFq4NKc+w3UArw
         3B7O7fclqnB7LWq5F0jwH2MFBSsfiWYIbdu8mPTshHJOYGIcxeZ563WjeRCuVo63RXLK
         gVoi3yIdDPXSjdg1niMY+zQ0PkJVz17rjVi4/YMg3xepT8i9A4NbcyLbN/c7Wp84I+fY
         hAsmUOqchXcLYtw+kANBJaMO6pxoV7QZzXeDTz8aG6JvashK19cprTy3i9L6U4cDNkDv
         nIz69JzjlWzKmudRT++LtePHt4gAwuUsuGczxD9gMeiJSKFBCY0D1wH6xna42sbeXBQJ
         UCAA==
X-Gm-Message-State: ANoB5pkepEdbfxJ/wmCKY6MluoeJf+vwPRlcwYpnUAUqVBQsTu2ixW0p
        FAC0AyIasop8R76yYm4H8PkVmeCoMps=
X-Google-Smtp-Source: AA0mqf5ZwcIe+YY0pzfxIbAo3lP4N19HMp0HJsnVajNzyxLAxNKYPCVLQTfGvi94v6IjIRWdxVfh94oDZbo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6904:b0:188:fd9b:479d with SMTP id
 j4-20020a170902690400b00188fd9b479dmr53509373plk.93.1669937248948; Thu, 01
 Dec 2022 15:27:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:55 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-17-seanjc@google.com>
Subject: [PATCH 16/16] KVM: SVM: Use "standard" stgi() helper when disabling SVM
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

Now that kvm_rebooting is guaranteed to be true prior to disabling SVM
in an emergency, use the existing stgi() helper instead of open coding
STGI.  In effect, eat faults on STGI if and only if kvm_rebooting==true.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 08ed4679903a..72899a61f708 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -579,13 +579,9 @@ static inline void kvm_cpu_svm_disable(void)
 	if (efer & EFER_SVME) {
 		/*
 		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
-		 * NMI aren't blocked.  Eat faults on STGI, as it #UDs if SVM
-		 * isn't enabled and SVM can be disabled by an NMI callback.
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
2.39.0.rc0.267.gcb52ba06e7-goog

