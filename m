Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D564C54BC35
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358428AbiFNUti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353181AbiFNUsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:48:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1414B5000C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id il9-20020a17090b164900b001e31dd8be25so63385pjb.3
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mb7FzKFSEgVLobIXf3OdFdCUMJfOed79vFK0Lawhe6g=;
        b=X6JBA0UtNYbgdBQp+RD6/GvBM17LkM9xHYl4iWexyTTR2aLmKJkaz8TuNjMuFuVkX2
         7zhuFQPJi5Cyc4Zzqs/NFyNQtaUddNt3YHG+37PrMWf/1/JfU67rTgzZseYs3AysvB7D
         QajCisyV3faBWYp4t07Dt2nUCFmbPnLMId2Bjx6Wx+UIkl7uB25MRVl8w+g4yjd1ll6y
         vLl7E1S3tlAapCiGmWbWAtxtcarAUTk/aOYnFZ9WXIfh7IFbkgb7FnB3p1HsXlXNnWC4
         zW80NyQY2QKlL9IYEqoX2/zvvYwT1FgbG8AlnSEJGbx96c/HdEL6zePosSB3wUe1Hq3z
         m2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mb7FzKFSEgVLobIXf3OdFdCUMJfOed79vFK0Lawhe6g=;
        b=OCp10fBqb21mq+t2ODmjle3iGdSGD6hI/68WuKNNbh4dcqxLM8TyCjGyjXpaY/1NsP
         2FFHVCkA2Zq1lXL3QOKkH8cyDoZnZaq1ulOeBBVY3Ur5tACTWOELgNdRmR/jFz1KS9ct
         UI7AzykI4PvcAZ4EnnP0kBDJ5Y/h50WOuuZiHI7U/56oapwAOnlrhmeU66PmX+Wfr89d
         t006qXixYu3ZqDPCoNpRT46Qzmt/JlBfTC58lkI+OafqC/WH2tZM1RgPHVdL/hXfxF+5
         xL0dCCXWeJ9cpUr40z/ADDwMhhgGZ+SFgW1ETUAgh8MuraOVU9rQlJaNoPorl0xVyKiF
         8VVw==
X-Gm-Message-State: AJIora/kdA53NvkpSvCRYcy1tK+NFDBrCAQ1ZcUKaGA4Ph16/EKFK8jN
        JaRldHlr2zyPvat3WKjk6SrwcEuFmWk=
X-Google-Smtp-Source: AGRyM1twJFBt9US2rObzd0Vkfn4fXCtGrzQHyXKawIkj6SUZl1ATz8pMlrEj/DxR98qcQ1UOJfC+vYCGKus=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bc85:b0:168:dadd:f86 with SMTP id
 bb5-20020a170902bc8500b00168dadd0f86mr5968393plb.93.1655239692180; Tue, 14
 Jun 2022 13:48:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:28 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-20-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 19/21] KVM: VMX: Update MTF and ICEBP comments to document
 KVM's subtle behavior
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document the oddities of ICEBP interception (trap-like #DB is intercepted
as a fault-like exception), and how using VMX's inner "skip" helper
deliberately bypasses the pending MTF and single-step #DB logic.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3591fdf7ecf9..91b8e171f232 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1578,9 +1578,13 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Per the SDM, MTF takes priority over debug-trap exceptions besides
-	 * T-bit traps. As instruction emulation is completed (i.e. at the
-	 * instruction boundary), any #DB exception pending delivery must be a
-	 * debug-trap. Record the pending MTF state to be delivered in
+	 * TSS T-bit traps and ICEBP (INT1).  KVM doesn't emulate T-bit traps
+	 * or ICEBP (in the emulator proper), and skipping of ICEBP after an
+	 * intercepted #DB deliberately avoids single-step #DB and MTF updates
+	 * as ICEBP is higher priority than both.  As instruction emulation is
+	 * completed at this point (i.e. KVM is at the instruction boundary),
+	 * any #DB exception pending delivery must be a debug-trap of lower
+	 * priority than MTF.  Record the pending MTF state to be delivered in
 	 * vmx_check_nested_events().
 	 */
 	if (nested_cpu_has_mtf(vmcs12) &&
@@ -5071,8 +5075,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			 * instruction.  ICEBP generates a trap-like #DB, but
 			 * despite its interception control being tied to #DB,
 			 * is an instruction intercept, i.e. the VM-Exit occurs
-			 * on the ICEBP itself.  Note, skipping ICEBP also
-			 * clears STI and MOVSS blocking.
+			 * on the ICEBP itself.  Use the inner "skip" helper to
+			 * avoid single-step #DB and MTF updates, as ICEBP is
+			 * higher priority.  Note, skipping ICEBP still clears
+			 * STI and MOVSS blocking.
 			 *
 			 * For all other #DBs, set vmcs.PENDING_DBG_EXCEPTIONS.BS
 			 * if single-step is enabled in RFLAGS and STI or MOVSS
-- 
2.36.1.476.g0c4daa206d-goog

