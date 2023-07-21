Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E2675D599
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjGUUVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjGUUUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:20:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16953A80
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d00a63fcdefso1716467276.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970781; x=1690575581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vAOLLgTu+0QNT9Om4NpxWB91aAPEeSvRzwHwJVAa2Xs=;
        b=imhgBKzxrXtouuf5PfcKL7zBn0uz33+q5k8Z0nIhm6BNxLjvMukg2vArkkk5NgTFDM
         NCaOxaOau0vLfoyQRsInuw+KAa7AslkSTBn6yul+5eiPK0IjOxtTfZI+5BUlLIVKvaaf
         zctolS0OU9qe/eA0SfoB4J52oxFAqZ+fh+FLtJaIaIPFFG750jsFlZ2Mc9quoQp2Unyu
         4inyMQQxkm2n98I2kfK3YCgsPjNs4UlB9VWVghYk87tTe4jdkygy4sS2+Mqd1axuaOKZ
         Y80wBoNxrdfW0VnTAvlYpjVOt8tpfiwmBahTWl8/tfevz/dYYviEbtSr/R7buC1VS27v
         nuqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970781; x=1690575581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAOLLgTu+0QNT9Om4NpxWB91aAPEeSvRzwHwJVAa2Xs=;
        b=Od93Pb3pkhNlAuEXo/0ahg5YF33O5M0/lVESHaeojIWXHt+NacxcXdqOrfFZMAXJ3j
         2t95HJVyJ2m8aut1vMXxJCGNXnYhnSOhQmw9oyJmuUFYl6u8IIZSyYXdUZlA37z/lfRG
         Pfmuy4NcaGSJAFw6Ae6FUbN+TSgwKcHKtvmkI00ESTa/rTU6/wWWXcvnKxgY9X+x4Ioi
         B10GKw/tPbF8WcbgAZGHB95qU0zKIpnvP76YjEdHVyhg8GtZPrWANtx3FO/BnbSG8Igz
         tf2G2J63sL7blWlX2+rkhaG8I08CoGXybU9pU9vQ5Y/TMd09cNWgkBUTcPpA5Juz+lI0
         Uf/g==
X-Gm-Message-State: ABy/qLa+wFmcq4BW2o+PNm7pV7NGJDgcYhhBwutw/bH8Og86xFViMZwW
        y3kMXWUnbPxkQyxIbru+ecxRRzcQ+3s=
X-Google-Smtp-Source: APBJJlFg1G379oAP55UGHQ0zEE/xeGlSUtowvWP1iIaOgGSS++UyKOVvNLNpz7tVyRlxXJ14xmaMnRFherI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:81cf:0:b0:c5d:dac2:cb2a with SMTP id
 n15-20020a2581cf000000b00c5ddac2cb2amr18050ybm.13.1689970781205; Fri, 21 Jul
 2023 13:19:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:58 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-19-seanjc@google.com>
Subject: [PATCH v4 18/19] KVM: SVM: Use "standard" stgi() helper when
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 8d1b3c801629..4785d780cce3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -588,17 +588,10 @@ static inline void kvm_cpu_svm_disable(void)
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
2.41.0.487.g6d72f3e995-goog

