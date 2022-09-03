Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484AA5ABBB5
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiICAXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiICAXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:19 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC50F63DC
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:18 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z8-20020a17090abd8800b001fd5f11fca7so3854865pjr.6
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=iceCiZqUYYalhRNpv9X384KNVicva7F6it80d8wrhy8=;
        b=edqM6eTlCy2LopEzwgZ1W+ygH/qNwnjBJpOCWfbcUtowcPPJOlQY7mN8CGTLjhbA8B
         6xmeKJ4KjinMsoSBkiIVjrGctJR2bcN+JSS4WpZQmD8ddpA3zt4I12GAc06cuYbcwUTA
         qm+NIFvDq6Ufc93vzJOAGXHs0SMO0Ddtfpnf7Z1dYD/AEExEinTELFztOsAj3tPkj2d1
         QC/yLUVYSLHn+AghFa0zqWJ5+08UKuiBc0wWcX0iREvFL8Ea3nZXnpLDZHJ6KUhh6rAz
         hFGuA6/++f4ixuhH3+k8TLWJ6l6Ks+FdkILZBlGacb6NDhjwS8Z8ESwNTZFXwSq9gzd2
         TE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=iceCiZqUYYalhRNpv9X384KNVicva7F6it80d8wrhy8=;
        b=lNpPaFjrV5BwqMvR0XNd59Lz0XDPMqkuRZhJH/jRYgmuh7+cCgjnjOqqVEiTznNXi6
         HvpuXXzOPDUZ4VjEg5ES25xBcb4lE5kOcxyr5EuWL/Ma/rcMpdJBTY+CgDWWV4A9wgYq
         BCvNBDx5qhQ1l3LjNuiSPVx65rr7cMU3PxdiUMqXI31fxFreGbwLEWqbB+Owx56lIWKz
         hhNcwTN2J6YFHFT3cq9BSitAfA+4tLWH1P0SLqbVPEtaZAleWf5cbdXeDi7rOlEs/NnS
         JYwxps8MCo8Tc6/nDuHmQ3wgrCOTUBv8s7M1e+EQFgq9M5clVWUncxg6sWoVGmEt3lQ/
         Im7Q==
X-Gm-Message-State: ACgBeo0NYqgqA1/bkMoARf9+iexRiQ1iSidA/nScGWmWPZob9fbT4NXk
        UIuvleNVCZMxlGQTBHor+TewNzbTc9M=
X-Google-Smtp-Source: AA6agR7ycJmrf38F6f5piy/D0fLpR9q0jyyWVg1fTy47spj87vDBe4t10tqVp1k2Px/2XsdvgWBZlColM+s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:5ac6:0:b0:537:f0fa:4ae1 with SMTP id
 o189-20020a625ac6000000b00537f0fa4ae1mr33026877pfb.70.1662164598026; Fri, 02
 Sep 2022 17:23:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:42 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-12-seanjc@google.com>
Subject: [PATCH v2 11/23] KVM: SVM: Add helper to perform final AVIC "kick" of
 single vCPU
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

Add a helper to perform the final kick, two instances of the ICR decoding
is one too many.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b4b5f1422db7..3400046ad0b4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -344,6 +344,16 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 	put_cpu();
 }
 
+
+static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
+{
+	vcpu->arch.apic->irr_pending = true;
+	svm_complete_interrupt_delivery(vcpu,
+					icrl & APIC_MODE_MASK,
+					icrl & APIC_INT_LEVELTRIG,
+					icrl & APIC_VECTOR_MASK);
+}
+
 /*
  * A fast-path version of avic_kick_target_vcpus(), which attempts to match
  * destination APIC ID to vCPU without looping through all vCPUs.
@@ -442,11 +452,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 	if (unlikely(!target_vcpu))
 		return 0;
 
-	target_vcpu->arch.apic->irr_pending = true;
-	svm_complete_interrupt_delivery(target_vcpu,
-					icrl & APIC_MODE_MASK,
-					icrl & APIC_INT_LEVELTRIG,
-					icrl & APIC_VECTOR_MASK);
+	avic_kick_vcpu(target_vcpu, icrl);
 	return 0;
 }
 
@@ -470,13 +476,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					dest, icrl & APIC_DEST_MASK)) {
-			vcpu->arch.apic->irr_pending = true;
-			svm_complete_interrupt_delivery(vcpu,
-							icrl & APIC_MODE_MASK,
-							icrl & APIC_INT_LEVELTRIG,
-							icrl & APIC_VECTOR_MASK);
-		}
+					dest, icrl & APIC_DEST_MASK))
+			avic_kick_vcpu(vcpu, icrl);
 	}
 }
 
-- 
2.37.2.789.g6183377224-goog

