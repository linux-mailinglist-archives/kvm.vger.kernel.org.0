Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43215ABBC7
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiICAXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiICAXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2E0F72D0
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:11 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 74-20020a62144d000000b0053b2a8e18ffso1716588pfu.7
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=QGfA0SPabQE2R3mTMEiHM9w7+nZN1T1OVaqiQ+IC3mI=;
        b=d+a+sPvbty8fX65SGwCSUPdb2VNS1zH1EpY8wQ8K2oklg4QQo3zBa8SiaCHxWnoujz
         Eex6Q9ikO5sMn4145/38ZNgrliW2qtezfapw3Aj1+HfVvQ8oBx+n/TxwDpa/GZypzuTU
         xfbvDrp5hJ+sshHLkf25qEE0/GjNE0aRAwtw7SoDyCsLphVJCRUenA2FNocoAFiAazbA
         Lleh/c6CC0pmX6rYyNu4NNIvTJOmuXwjLCS7lsWTn6OP1ro8/08GIREnjT6BOEQycOzZ
         cM32tiBDh9KI5+mpvbHZsSSuIG887H+Pg3bAHpiBSQj+RtIyH5nWKgQ1ZfNQgIV6tjQD
         c4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=QGfA0SPabQE2R3mTMEiHM9w7+nZN1T1OVaqiQ+IC3mI=;
        b=ZZCYNNXWm7HsJn5OU3Z+OQE8gyAme4PAMiFahVKJbhVh1feIIv7h8vR2mrZXwFQYfc
         F7QaI67B1Imas0n9yRxOEECvrziGKByISdNPkdrwookr84jUgAdvnDKOgxGnPKiWsimV
         YtYrolGYP4ZhD74aQa04WEPSg/V/jkcvkJW4M4Q5SuytYgFPHYKD4G0ghTiyYhO/eF/7
         GWSbx+lcVWmh6o0s50K2HRTLDA+BlfCxcegFLi4QsivmMCNjtYgfjW6JyNtY5/Y2E3Fx
         zODSU33uDB/sM+gUFbmzNA+zyM0cEqwqKJXw5e+R58csBDP7itbRp5i69XnwK+Ns9txa
         rAmw==
X-Gm-Message-State: ACgBeo2nq8/9ZRrzqDsvjGK/LhVJixAUh/Uk43hesFb8Pb24DRRG9/Y0
        t3ujl7hX7r5oJJ1jtCaUMhhJr7wfyiU=
X-Google-Smtp-Source: AA6agR7nuG06KNHuOhPwbwIB64qfgB9FAo5CZsNmGvbVnFFWEiJXhkb8QbcPke+ZCjTPA+36UOxjc6ylbt4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e558:b0:1fb:c4b7:1a24 with SMTP id
 ei24-20020a17090ae55800b001fbc4b71a24mr30859pjb.1.1662164591154; Fri, 02 Sep
 2022 17:23:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:38 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-8-seanjc@google.com>
Subject: [PATCH v2 07/23] KVM: SVM: Compute dest based on sender's x2APIC
 status for AVIC kick
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

Compute the destination from ICRH using the sender's x2APIC status, not
each (potential) target's x2APIC status.

Fixes: c514d3a348ac ("KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID")
Cc: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3022a135c060..50721c9167c4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -456,6 +456,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 				   u32 icrl, u32 icrh, u32 index)
 {
+	u32 dest = apic_x2apic_mode(source) ? icrh : GET_XAPIC_DEST_FIELD(icrh);
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
@@ -471,13 +472,6 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		u32 dest;
-
-		if (apic_x2apic_mode(vcpu->arch.apic))
-			dest = icrh;
-		else
-			dest = GET_XAPIC_DEST_FIELD(icrh);
-
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
 					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
-- 
2.37.2.789.g6183377224-goog

