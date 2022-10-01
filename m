Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9885F17EC
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiJABDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiJABCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:02:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B448140F35
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y5-20020a25bb85000000b006af8f244604so5157445ybg.7
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=ImEFAENnzskoKsyXGbezKFbfsi23WTJyFD4CX9MnaEI=;
        b=oJrKz+f4QiJ3/5je4SGsdwTRQ/Y/8nnEDBVDtGzAMRDyHUe9K/4Q9DVH+kl34nMYCm
         aBgiPgsp2amkDfLoeSj6BIC0XkDKpbaOekubEXk/BjuqcCAm0hSv6Egx95GdpWkaJmFN
         +woTDE2gUbnoUPBjnUE8l8yF+a1f9EAAEVR/CLcE4dfUP3D8ndScHGZ/A7HjaQ+oFQCI
         jU+EgNy96yPE4PyuYN2oPpAVFunJqxq9HNcF2GE9EnBmHnB7xURq7IZJvcb1IJbfbOg0
         +H2F7GCQEr3fR6FPsV7wEjoEkNHPOfXQ3MLTnuLutigEF2KtqiJva2Um7RcwM5cVFDNE
         XzQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=ImEFAENnzskoKsyXGbezKFbfsi23WTJyFD4CX9MnaEI=;
        b=hJo3YzVTczchm/YwCXeqidE/c1FTTGoDw4f/H61PZcOAzEo9stfH/CXQxBYKVGPT4p
         pPb4+ZqPsMXO3zJT8qDXqlaXAlZc5czjwgxljMAJF76QhtQAp/nJ+mYmpiVbc+o99cr6
         /FskjKNQPXVbaiPI5t4B5U0vINPFvZK/3MV/7a5mi5/MQ8mIE50pA97EmGdht/vuRXwv
         kHZFVcnGDBkEb3DxgZiKvCbpC8VfrRTgPF1hxcJEbQEu0VQFnyC/WBfpIRgN5O783xf1
         eVfXj48ekSTTXL6WgUDxneNtjjDmpq4bXSRDXtW7MbDwemsWWpR4uAkbTQnaHOFfDYxu
         830Q==
X-Gm-Message-State: ACrzQf0oZ0pTjFjlRxnKr4fNjmp/XvbAVkMhG3yze2imOigpXKUoI4bp
        SoQf8Wn7mmGPWbsPQIHoJOToOy37x1Q=
X-Google-Smtp-Source: AMsMyM6CyT4fI9i6NU13ocWZj2QeuYDkU+7LQIPGX95TT5JuEWDT1ypX3azvcGs6lC8kwjsKARaXwwnxIxo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1507:b0:6af:9e7:f947 with SMTP id
 q7-20020a056902150700b006af09e7f947mr10803591ybu.649.1664586002589; Fri, 30
 Sep 2022 18:00:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:09 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-27-seanjc@google.com>
Subject: [PATCH v4 26/32] KVM: SVM: Always update local APIC on writes to
 logical dest register
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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
index 27d5abc15a91..2b640c73f447 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -573,7 +573,7 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
 
-static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
+static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 {
 	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -582,10 +582,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 
 	/* AVIC does not support LDR update for x2APIC */
 	if (apic_x2apic_mode(vcpu->arch.apic))
-		return 0;
+		return;
 
 	if (ldr == svm->ldr_reg)
-		return 0;
+		return;
 
 	avic_invalidate_logical_id_entry(vcpu);
 
@@ -594,8 +594,6 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 
 	if (!ret)
 		svm->ldr_reg = ldr;
-
-	return ret;
 }
 
 static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
@@ -617,8 +615,7 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
 
 	switch (offset) {
 	case APIC_LDR:
-		if (avic_handle_ldr_update(vcpu))
-			return 0;
+		avic_handle_ldr_update(vcpu);
 		break;
 	case APIC_DFR:
 		avic_handle_dfr_update(vcpu);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

