Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF1E576879
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiGOUoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiGOUoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:44:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B1A8AEDF
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o8-20020a17090ab88800b001ef81869167so5776150pjr.2
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nsIb8iFtTFoJsIx12YO1Ne5ohqcLWZEZtrpg0fSurk8=;
        b=TqtDZ0/YZTBQAYgTO1Ot6ZtWp92pSm4JDHP2MJXuWIm5RkQUNlgGqQo/rGyBF/rhmv
         HAGlQxRyJ0oo4qgkVP8chYN+2edmtW2n6oJZ0F4NJ/RNgVH8IvhM+TJgSwsCj/Y/SxNg
         1dMjNqqyh/1zrB0hYpAzgfEhYmsGazNBK1h11iRj6P7JC/IXftAWnj7PqZFpmbWI+cs5
         NyqlYWfRygCudARXnb/Oifp0PHRNNUJNQfeKD+FpQwIo0h2Gv2A6iAWDQgYWT9pdcoLk
         yJ8DkigwRqJNHE3/IYDspgqj2PCVr07a6FrzEwujshVZxXaVtteESZvhzdEoE6aCRFx4
         ZlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nsIb8iFtTFoJsIx12YO1Ne5ohqcLWZEZtrpg0fSurk8=;
        b=FG7gwg/Y8U14e2/85I5QVmSktf4+/CV/Nc7/lhTIjpr4CCkch8Y//104691DcvE+XZ
         i2rcQdyqkTv+k18n5CUBMjFEEBpIJt57LAMTW3MBkhUYBG7/gxeqepu7HuUfxKr77NIp
         hfSuzpqvreMUKk5xO8ZcFzo/vKT705LTYhTx5O5RUb+KxLkzQzf8ndBFuqi/sz3Ubl13
         WyQ5y2oTw4h40ap5krG13UCWX1p7GpDyXgSzs8F2bRVAOQSX+O9PXxK0sXLvqt9v4HWV
         PeQcjymYa2wqjK57rIvwkDAbovRqqIgq7fDJau34Arb5dyupLWWpeZCESHX5yoMyVIvi
         +bug==
X-Gm-Message-State: AJIora8LTCnYV3iBkfmsV0+dzI/NOv6oh2z0YQ/fTg9bUDzRB2j5PEk7
        Sv4Z2ztLVs877Gm4MwAGBMictjfIv0M=
X-Google-Smtp-Source: AGRyM1uO6TqRAz4/bhi+cTABFmBFTD7jgIt25wkmPtS2lGcirB0a3/OxRxNwpFXA3uNWBaF9NKDYBWKh9os=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ba94:b0:16b:fa16:15ed with SMTP id
 k20-20020a170902ba9400b0016bfa1615edmr15717032pls.8.1657917789369; Fri, 15
 Jul 2022 13:43:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:23 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 21/24] KVM: VMX: Update MTF and ICEBP comments to document
 KVM's subtle behavior
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Document the oddities of ICEBP interception (trap-like #DB is intercepted
as a fault-like exception), and how using VMX's inner "skip" helper
deliberately bypasses the pending MTF and single-step #DB logic.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5302b046110f..de6fcfa0ef02 100644
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
@@ -5084,8 +5088,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
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
2.37.0.170.g444d1eabd0-goog

