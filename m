Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15427CE7EE
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjJRTlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjJRTlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:41:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C89112
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:41:10 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7af69a4baso110050487b3.0
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697658069; x=1698262869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XDwbLiOis3SdrHxTO/Y/lxRhpLoGiD6x3/AIUgIhLVk=;
        b=225mPG4bn22vpmEQZ/lq+lcwjZcVmHd/UgrRyJJQv/nh9BGjJUbzh4ACMeF6r9ZggD
         Tim2wJUR0TlkYG+5oMCTYa9+FgGhyroQo1nuaGeFHdlJgNTmP4xzvBFCKQLlkXfXaW/h
         0R2meemQK9REEx3buTD4LUdnDReM4przJQSAX6ezEr5oxWaoKpwu2W2S+I0eFy8O9ymK
         ZM9+nbK4y0dEW4YK0QrokjdR+O1at/X62oDDoF2yGN7UWvz7VxivEiaz4Fve1p8ExpWj
         kCba5caUEh77WN8mSQ7pczcJlYmalwYmRhwrSPdMYuRlW/t3ngLDMfDT2W/FX8169bOX
         gjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697658069; x=1698262869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XDwbLiOis3SdrHxTO/Y/lxRhpLoGiD6x3/AIUgIhLVk=;
        b=cDS+B4uvAKn050SotMhlMQ0NAegBBSAeychPNLNtH3vvOAZ1WFbKX0KOJjVtBebjdx
         VngK9cdXDiB1eWnHFEXSHpKFsaiOh6clI35Hl4v8uX+DsYF4BuRLLUp/7cCCfWWoR9i3
         zFMKDWbO6bJJsC9AAQQuSciRQKOQJv5TgiK9ibn45zjD5NqEADthea4EQ6ZFrhbyc2ZR
         vsbUf2TTIjueuvRgk0CtDptQJ++TvtULZO32fVW/1W4D9WDWQ79gJFzbbyEttzvrim8d
         L5bAeMH3m5jeqS1BBXwbKJbz7P4jVm+ABwbGBVqSLNYn0oJIJ3Ns0eGXRFUPDUgXnbeS
         bQVg==
X-Gm-Message-State: AOJu0Yy6e59cpLoeQOqDpJ2DybO4fWK9CGVOl9YFrMeLjF9F1UZPLSlk
        jkSCQVJKK7lMIE/usqCedNYcbe2eGzI=
X-Google-Smtp-Source: AGHT+IEE1wVrW556Cd5uDxyOx/0Ua1tTpL0wLSYC675igkSjSvLsIaByHuL9JyEvU5bZFTNu2xBMZmFUKKA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca46:0:b0:5a2:3de0:24a9 with SMTP id
 m67-20020a0dca46000000b005a23de024a9mr6913ywd.1.1697658069288; Wed, 18 Oct
 2023 12:41:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 12:41:03 -0700
In-Reply-To: <20231018194104.1896415-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231018194104.1896415-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018194104.1896415-2-seanjc@google.com>
Subject: [PATCH 1/2] Revert "nSVM: Check for reserved encodings of TLB_CONTROL
 in nested VMCB"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Sterz <s.sterz@proxmox.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert KVM's made-up consistency check on SVM's TLB control.  The APM says
that unsupported encodings are reserved, but the APM doesn't state that
VMRUN checks for a supported encoding.  Unless something is called out
in "Canonicalization and Consistency Checks" or listed as MBZ (Must Be
Zero), AMD behavior is typically to let software shoot itself in the foot.

This reverts commit 174a921b6975ef959dd82ee9e8844067a62e3ec1.

Fixes: 174a921b6975 ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB")
Reported-by: Stefan Sterz <s.sterz@proxmox.com>
Closes: https://lkml.kernel.org/r/b9915c9c-4cf6-051a-2d91-44cc6380f455%40proxmox.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3fea8c47679e..60891b9ce25f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -247,18 +247,6 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
-static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
-{
-	/* Nested FLUSHBYASID is not supported yet.  */
-	switch(tlb_ctl) {
-		case TLB_CONTROL_DO_NOTHING:
-		case TLB_CONTROL_FLUSH_ALL_ASID:
-			return true;
-		default:
-			return false;
-	}
-}
-
 static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					 struct vmcb_ctrl_area_cached *control)
 {
@@ -278,9 +266,6 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					   IOPM_SIZE)))
 		return false;
 
-	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
-		return false;
-
 	if (CC((control->int_ctl & V_NMI_ENABLE_MASK) &&
 	       !vmcb12_is_intercept(control, INTERCEPT_NMI))) {
 		return false;
-- 
2.42.0.655.g421f12c284-goog

