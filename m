Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6515BF147
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiITXds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiITXcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCDD78BE2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ev16-20020a17090aead000b00202cf672e74so2324557pjb.2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=5PPiHmOlyBinhsVtkg4FLSXk3S2F6RJIaf8EEfXCkkQ=;
        b=jUuxCAKHOyyYp3PG4HHDfuIcy4xUpMFWycUNM2JeRtue3zQlBTNhkNr8Gd7U2FTM0N
         zWbfderN7vCQ68VH2UOwVB5cnT3PtAkYifqa2ZVh+JepTi/UGrCvLhN/q/gBs3FVOnsb
         WUEdb7sod9Ypmx9HX9ymuKeE24+uymIphp12PfPUVgpPc47XAECyPbtXy5MRF8Vs7xY4
         BOUtuHewNgayEOV+wP5fje3Tmqw7q9b2FpWKxTEIv9SMpfU9zMA4k0LAjvDL8/cPYeKC
         /8rn52bZexvIms5fpXQOFcVSFVvMPmBZwe84VN9w9EXUkgT7nGH8R2Sh3LXScDXSbPLi
         9slg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=5PPiHmOlyBinhsVtkg4FLSXk3S2F6RJIaf8EEfXCkkQ=;
        b=g3vYxRK+I6f3ddrDsXPRlICzgBbbnK1Hv1rhjpkqRdJkx42UFXTQL887AAs0ygbbrg
         VRQiERcb+1QAN6U2QSCmSd6se5JqHbFiFVvZjSUzIWhdtZ/pcbKdais10Ewchg7dYZJm
         oVsccK3l+coum7h8bQ0wjdNkaBPCWPNvafcZxyrWeHMQ79IKKKdXz5yMy8GwG1593yoJ
         tfXQecFeu6Hkkqy28vEGe22ZZS4l6DdZcwPuwKtvOdNTFh8YoM5VMd+HNYGMAQbtD4TE
         RooUdVSy9E1OMpkvzFC2NyZh0RbvCHyJ0PEtD99SjBTul1v0eVjttQ1mE4s8Y9aPaCF0
         ZEaw==
X-Gm-Message-State: ACrzQf05k+f57HUf8DDAuufKyPVxPczjHdLnraymgSvN2fZqJxhBDQif
        qAFwlPZsTIGDv+2k0t73F7K2yZBvUUo=
X-Google-Smtp-Source: AMsMyM4xBVaTeZv3hBwTLr49+Dfwlb5OEp1MqWuMfp24/e4oTNBNZyUdM7jvieIgly5g/xSVZvrP32vQVh8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1181:b0:203:ae0e:6a21 with SMTP id
 gk1-20020a17090b118100b00203ae0e6a21mr405253pjb.0.1663716735563; Tue, 20 Sep
 2022 16:32:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:29 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-24-seanjc@google.com>
Subject: [PATCH v3 23/28] KVM: SVM: Always update local APIC on writes to
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
2.37.3.968.ga6b4b080e4-goog

