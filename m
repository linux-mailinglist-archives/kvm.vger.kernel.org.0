Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D84AA274
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243601AbiBDVmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244015AbiBDVmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:15 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C808AC06173D
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:14 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 188-20020a6219c5000000b004ce24bef61fso3560817pfz.9
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KKjH3zCPswTf0hjqacVy5YOkSkhUl6n6cultlDnB9r4=;
        b=k/aPC/mMPGHNoH20HSjvFsILeFwxVaf8/1oUATZ3gMaugfTDdwj3wM6vgZYIU4nQ3n
         z6bQxP45Mht4VAdettIJ9wpRGDG+RK8Iz2oi2cDaIn1dve93CYueFS85YPJDVlm7axWt
         S6tW7iL1CnE5gQhMKqG1P2itMRzc1GUcn6ze532LTZLNzyyCbqsnVguGtPc4Bn51JnSJ
         n4ALN/1fKeUEx0+rL+857zT90+n1A6KUxB7eT/gOidhwqGJMKJ6ERPHmNt+WuXCqVwwe
         E1J9Tw5Y5jciyjHrZaSljauRntjnYivDlYEAYd/LEYYGf6Kg/du0tG97F/s3umrm4JsG
         RpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KKjH3zCPswTf0hjqacVy5YOkSkhUl6n6cultlDnB9r4=;
        b=JJYJh7hv7zqtfT9taG4wu8mb2zTbysfqbrvlibSKW36Up/FwkL4qEaMwj1XoyT/8Rm
         wSeSUVxljvwk4bLPz3vqbQKQjHBmfz5mMZ5S9FJIXKMwMu2kA38RlPT+4DvGLUywbGIX
         QOb9hjJmOrkuDL7B0tFpB3qiCU6nYe+kSGyNlobJ3YHqmSe0fMkhqzXmxlMMASoC7Odf
         XSxG3onaevRh6r3d6Gty4G7S9W+IirB/m77FWky5HpWYXVRfSawTLIPEaQD+dxfbUGfg
         UutHukmPac782Sg/XGlMHxmBnTzbwNHagKNyHaclrRwVbjkFrilikPtKNAqEUH2rlHZv
         k7tQ==
X-Gm-Message-State: AOAM5304GP2CQALgCEBhH+AERKL2xmssYluS4lumrDGw545stByzECZR
        rLg2p72LIbZOgh13gXIh5hlm4IbKrR0=
X-Google-Smtp-Source: ABdhPJyO/YpOUBTWRsnzCsX1L05Kf7rSUUypro5AemY+0lFROqlrme/xEPWu2TDUq3jPILLG9FO3nC2v0QU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b495:: with SMTP id
 y21mr5238714plr.82.1644010934301; Fri, 04 Feb 2022 13:42:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:41:58 +0000
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Message-Id: <20220204214205.3306634-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220204214205.3306634-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 04/11] KVM: SVM: Use common kvm_apic_write_nodecode() for AVIC
 write traps
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the common kvm_apic_write_nodecode() to handle AVIC/APIC-write traps
instead of open coding the same exact code.  This will allow making the
low level lapic helpers inaccessible outside of lapic.c code.

Opportunistically clean up the params to eliminate a bunch of svm=>vcpu
reflection.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ecc81c48c0ca..462ab073db38 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -476,10 +476,9 @@ static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
 	svm->dfr_reg = dfr;
 }
 
-static int avic_unaccel_trap_write(struct vcpu_svm *svm)
+static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = svm->vcpu.arch.apic;
-	u32 offset = svm->vmcb->control.exit_info_1 &
+	u32 offset = to_svm(vcpu)->vmcb->control.exit_info_1 &
 				AVIC_UNACCEL_ACCESS_OFFSET_MASK;
 
 	switch (offset) {
@@ -488,18 +487,17 @@ static int avic_unaccel_trap_write(struct vcpu_svm *svm)
 			return 0;
 		break;
 	case APIC_LDR:
-		if (avic_handle_ldr_update(&svm->vcpu))
+		if (avic_handle_ldr_update(vcpu))
 			return 0;
 		break;
 	case APIC_DFR:
-		avic_handle_dfr_update(&svm->vcpu);
+		avic_handle_dfr_update(vcpu);
 		break;
 	default:
 		break;
 	}
 
-	kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
-
+	kvm_apic_write_nodecode(vcpu, offset);
 	return 1;
 }
 
@@ -549,7 +547,7 @@ int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu)
 	if (trap) {
 		/* Handling Trap */
 		WARN_ONCE(!write, "svm: Handling trap read.\n");
-		ret = avic_unaccel_trap_write(svm);
+		ret = avic_unaccel_trap_write(vcpu);
 	} else {
 		/* Handling Fault */
 		ret = kvm_emulate_instruction(vcpu, 0);
-- 
2.35.0.263.gb82422642f-goog

