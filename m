Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9C25A72B2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiHaAhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiHaAgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:36:50 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBA697D6E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:21 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id s129-20020a625e87000000b005383388a6bcso3117027pfb.2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=Loe3MlTGcMk80vSZPHjHmMjavqy1PId/3gp5j3Ud0uU=;
        b=B+TprnwR0pgPPbE76syVYpuZqhC1waR/eOXBEcoJkGVOWULQh6Z3lQadB1ByrLmS8r
         OxnmBpGiT+g6/soGVFO18dm2EY7FONP7o6ts3u1yMAVXctVTCy/rXTNEWdihDYn5dTFM
         v9LU3DTRxwQlQQqr7tKQAtF4L5HHUpbrUJr+WOdFUU6ZQaXIX9YNBZIdVhRvwRNvPWoi
         N5DGrsUfQTJGitQYuDBOotavc1C1MqjBqiwFSt0j9tUhJn6IS5lrdhCnUFmv9hd/sltO
         s4DZBu45EZx7NN4jTnSrlhJwP/DXyzPx1SWrxbjA2TZ9Q1tDp0nl5c1ZeXWaYWZxzAC/
         1GDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=Loe3MlTGcMk80vSZPHjHmMjavqy1PId/3gp5j3Ud0uU=;
        b=OUeEdgfKYn10I520tCc7vHgXTrAs3S6q/gjMjcs3AX3B/s8ZFeWCArgasbps+/zZzl
         XQOKCCC3kdsmrteIUczC8YceJTj70sgWKTRGYr2MshWXXEreY7DUiLCslEdTFLx2qA3l
         XLex+ZZf5j5yC6mtMG/JpoDF+TgiRZ044vRUeFAFM+THgMk5cra7YCFpJBdRoZVkp8Wz
         85YmyzIaAjR6qrjciwE0qiH4xRpPnusD2YQTYb7guyLiu5f0h2uO70Cr6UiZX2wO7Lun
         Yb++JcK/WlemcdxfyXEgj8MynROtujDy2FYdpKhbWz+bKZXBufdBKcpmLcAFOy+Og8ZZ
         MQBw==
X-Gm-Message-State: ACgBeo2Q14WzLgEbkKGydY2i3l/q94nAUILhieRxJb3lK+i7iuSLhXxS
        oT29urExAXQzsO8gIPyt0IJMiyXEdo8=
X-Google-Smtp-Source: AA6agR5yKeNCnlQO1qCPyK52ww70HZJLlWgT1/q2p5pwB2YtIp3VwcOzeBTGE/6CVfenoQJvr0ZqRa21OmM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c8d:b0:1f5:409b:b017 with SMTP id
 my13-20020a17090b4c8d00b001f5409bb017mr659921pjb.52.1661906110868; Tue, 30
 Aug 2022 17:35:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:48 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-2-seanjc@google.com>
Subject: [PATCH 01/19] KVM: SVM: Process ICR on AVIC IPI delivery failure due
 to invalid target
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
---
 arch/x86/kvm/svm/avic.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6919dee69f18..b1ade555e8d0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -496,14 +496,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
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
@@ -519,8 +523,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 */
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
 		break;
-	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
 		break;
-- 
2.37.2.672.g94769d06f0-goog

