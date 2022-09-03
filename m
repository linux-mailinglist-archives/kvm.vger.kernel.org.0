Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424D25ABBA8
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiICAYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiICAXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:39 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34042109523
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:30 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y21-20020a056a001c9500b0053817f57e8dso1722121pfw.6
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=FKxxPsJ5vR3fIywfmzwGgyolr5i3fnsaWf12rApRz8g=;
        b=UXaApoi52dJO+xyTKxC2+2kg/UewN03QjIy0Nd0nJst0xu5IAzECG7a1aK2lsqi67I
         qpECMyZxVre85JIU9pG3CirR125Baq1NfyEw4FlwiAN1L1bPZaZDmaJGj3jGonnXwxyn
         p3KeAf2NeBH5tMBEbK4yD9DHpywWkfxBbrSbeAisDgRjgN54EgbraREJQYyI8bzdbt/e
         QTIGTw+jkNYv+Ze3ETmbB9LLj7+369lqqWSU/aEHf6UoB1XlXcpZvu03o7kUUIjKb/vT
         UIgmfZQY0s1tpARNcMc+NeJtMAAG7VsMM/3+C/BDQJ2xcCvo2q1rO2lRgpbIrHzmUNWY
         cMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=FKxxPsJ5vR3fIywfmzwGgyolr5i3fnsaWf12rApRz8g=;
        b=5gE1wushh75hgLh2EL4JXX59UY5OF3CH1xiKr1zS6D5qk5d91BPMZp/fJBkzT+wovb
         Wzo7INBE3qvUFUq4/nuAtAiI/rienXwlBTJzAw+yAN1/UTzQIJt65uDx78NRyo/6pfqF
         M77yaozRh0KfQOATkzvNC0efyUanrMXNDft25uCXovF1o75315oMQF1jNb6+OdFsFbIf
         g67VuFuCUrC7Gdz7niH4MNJ+7FSVC/eSuPbNO53jM5QBuwZ+eNBDh83j5+cEUr54eDkY
         uhu3rQaHug4y2yn+3TWKZ43tJmHHChuNYdKDJRFnMXZhJk2gJXvvpca9czVFCzgyIqJL
         Okug==
X-Gm-Message-State: ACgBeo0p4ni2S6XRu2skHS4MIttP1S56jWDwtw/l3PyNTDUCL1h2dLdT
        pkVYPuf6NuvXW0fXScBrvnZVT1sbCVg=
X-Google-Smtp-Source: AA6agR4ArxeF5HbQAJ9kNwzOn0+zznSMHqk4d/8x42sxkQ3MBzsRpKGyRlzolWqzHHEoP0EgMVzveQSO2gg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e558:b0:1fb:c4b7:1a24 with SMTP id
 ei24-20020a17090ae55800b001fbc4b71a24mr30906pjb.1.1662164609500; Fri, 02 Sep
 2022 17:23:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:49 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-19-seanjc@google.com>
Subject: [PATCH v2 18/23] KVM: SVM: Always update local APIC on writes to
 logical dest register
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the vCPU's local (virtual) APIC on LDR writes even if the write
"fails".  The APIC needs to recalc the optimized logical map even if the
LDR is invalid or zero, e.g. if the guest clears its LDR, the optimized
map will be left as is and the vCPU will receive interrupts using its
old LDR.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index efb0632d7457..456f24378961 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -600,7 +600,7 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
 
-static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
+static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 {
 	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -609,10 +609,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 
 	/* AVIC does not support LDR update for x2APIC */
 	if (apic_x2apic_mode(vcpu->arch.apic))
-		return 0;
+		return;
 
 	if (ldr == svm->ldr_reg)
-		return 0;
+		return;
 
 	avic_invalidate_logical_id_entry(vcpu);
 
@@ -621,8 +621,6 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 
 	if (!ret)
 		svm->ldr_reg = ldr;
-
-	return ret;
 }
 
 static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
@@ -644,8 +642,7 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
 
 	switch (offset) {
 	case APIC_LDR:
-		if (avic_handle_ldr_update(vcpu))
-			return 0;
+		avic_handle_ldr_update(vcpu);
 		break;
 	case APIC_DFR:
 		avic_handle_dfr_update(vcpu);
-- 
2.37.2.789.g6183377224-goog

