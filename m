Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DFA5ABBAF
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiICAXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiICAXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:06 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FF5F63D7
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-34500a9b644so10748677b3.11
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=+h9hFic4xRqD7CaF5zm+8f3VON15o9C3RGA1ZshdPjA=;
        b=VIY/TbrtWcV1Mo1/S9C9/ooDUAQwCY2EVenvilCM17xY2z7HcVKyrGMq7MbCq/YsbQ
         siznHBRspCkUTfdfCM4nw9V4yV862b98T9el5+/dRkoMacsQQWSc4dYyxs/NyG4h7svs
         6GG+wdyLB837ervm9UFYX7lEgguBmymjUWPbbsaNpX2xsprzW+U1xxxcr5w7Hae68VpC
         BUXLWpmDp9yiykojL+7IrAP3Qz5N/i3VA2oAb6UnPuNxwBnx469NSbWdJB4dFUywEwMw
         OSutRD83dcIrXWQCmZzW6AOmD5ECutGwK/AtIILwdK86OQxD3Ogb7PcSOBDEXyDxj4Ev
         3hOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=+h9hFic4xRqD7CaF5zm+8f3VON15o9C3RGA1ZshdPjA=;
        b=biG40nvg2VEPAcOjrnUJxQUIx/B6r8MjUFtTDTN1jw5TybG4OKNOMfWrN47ddx+iM1
         bLivvGEVXQlIRYSirBcv6jgP2Tvw/4+UXJq6K0/rjhwZMHUKNioZOuw642am/VLnf0v3
         +adameE0/ZSs1M/6Wd83CkZTKID/k+QFR0zo8SgluP7NsvyYps1hMMWhDP/dJvMsND3B
         +zTdVIym3lbH7efCGyyb2jrBIzjj7SBYR7rjNXdRFrRg3sHRWgFq4DNEJssToNMOJLda
         Vbys8wmTwDVlHSQSvLFvUfPipe64S5NfiKKbQ3CMe/QC4sQGLcCTxS3pTUr7AQ0CEYbc
         YfpQ==
X-Gm-Message-State: ACgBeo1jHG6Wzhk+6a3oBwDXHUM/6Tw8pcBHQn8L7Sl8h/JzSIDjVhhZ
        /z9XrRDuAMQkwIoKgpFktmn7kxHnLjs=
X-Google-Smtp-Source: AA6agR4GbUtTJKepW8ZpEGn0B9VdcVEWRT2NeATuIKh3KuJSKUQoCbpifi1rJV2bbFY1fXwJN+4JEVweIgM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2416:0:b0:696:4dc5:c6cc with SMTP id
 k22-20020a252416000000b006964dc5c6ccmr25386145ybk.114.1662164584329; Fri, 02
 Sep 2022 17:23:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:34 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-4-seanjc@google.com>
Subject: [PATCH v2 03/23] KVM: SVM: Process ICR on AVIC IPI delivery failure
 due to invalid target
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulate ICR writes on AVIC IPI failures due to invalid targets using the
same logic as failures due to invalid types.  AVIC acceleration fails if
_any_ of the targets are invalid, and crucially VM-Exits before sending
IPIs to targets that _are_ valid.  In logical mode, the destination is a
bitmap, i.e. a single IPI can target multiple logical IDs.  Doing nothing
causes KVM to drop IPIs if at least one target is valid and at least one
target is invalid.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4fbef2af1efc..6a3d225eb02c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -502,14 +502,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
 
 	switch (id) {
+	case AVIC_IPI_FAILURE_INVALID_TARGET:
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
 		/*
 		 * Emulate IPIs that are not handled by AVIC hardware, which
-		 * only virtualizes Fixed, Edge-Triggered INTRs.  The exit is
-		 * a trap, e.g. ICR holds the correct value and RIP has been
-		 * advanced, KVM is responsible only for emulating the IPI.
-		 * Sadly, hardware may sometimes leave the BUSY flag set, in
-		 * which case KVM needs to emulate the ICR write as well in
+		 * only virtualizes Fixed, Edge-Triggered INTRs, and falls over
+		 * if _any_ targets are invalid, e.g. if the logical mode mask
+		 * is a superset of running vCPUs.
+		 *
+		 * The exit is a trap, e.g. ICR holds the correct value and RIP
+		 * has been advanced, KVM is responsible only for emulating the
+		 * IPI.  Sadly, hardware may sometimes leave the BUSY flag set,
+		 * in which case KVM needs to emulate the ICR write as well in
 		 * order to clear the BUSY flag.
 		 */
 		if (icrl & APIC_ICR_BUSY)
@@ -525,8 +529,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 */
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
 		break;
-	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
 		break;
-- 
2.37.2.789.g6183377224-goog

