Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554FF5F17DB
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiJABCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiJABBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:01:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101AF9411E
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:03 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x13-20020a170902ec8d00b00177f0fa642cso4248791plg.10
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=pEkp28ZobAyyWF46XmIlZjPBuJyvs8FGaKhwOrBbQEk=;
        b=Mdu+wWgALHSMEFKw+vWqrkrvn4U5zoYpYRfOa11/vzMl04h/uwKkyzXxcwluJ+mU//
         eApu7Tl7C0cbsMFFcB8lbdCXL487eUEtvgQHTt/72lnAKGsJYVZ/kRXNIJmda5SB6MZo
         Uvuyn7okG2JagRZv4rsDs7hDjY6faZVXWl+4WQ3Wqg/I4+QO81ZxgL6uC0gxyU3XJKMn
         iREo3cDJPNE/NULSPtL0rz/J3PEia2Q7WEvApC6Zz47tvJ/aBKhtzGgLMusidl2jnIK7
         Wev8LjqGHkQTQsgJZdmu/tUdp53bv+N0VKFlNgGWBv5ztlwe2jp8XUdfZmho3LkYSFbV
         RFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=pEkp28ZobAyyWF46XmIlZjPBuJyvs8FGaKhwOrBbQEk=;
        b=ZDTOeifpeXKZop0w7Csnt/N1Qccy70NcjGTpS0oggDQHKnrDfh++6A+NtvvP3Xosi5
         zxOn+u8XNrMxfFJi3KF7bSi3gC8p0J5PCxwTQViakxnv2+3hBSL7oqU8lf1XNbfK+RE5
         7LSoLFcmy0lWSRKlupNUZG3dCC1g1nVvKf1YeT6H9P16BofxKzsPscFGlu/toaJFlN/3
         lwFVYLh39PFlalgEQ3LryXAzPipIaoGFAmwHAmMTtWHnjvOOlg/gM1ADIv0IUOjZuRcg
         EOqJUEhhgSnuGKQ58MZyrygvNo7W8vxAQ81dS5qwyGVJGMi/LOgdHJe9VFE08QZgEh1w
         yAXw==
X-Gm-Message-State: ACrzQf1PosBn5Sxb1NBfXP3lqHzhclFBVf3Xe2nl81sEdfmVpJSIlnFt
        ZtHjo7MLr6MAciy0NDcPWKor1V8h08k=
X-Google-Smtp-Source: AMsMyM5JPrH/tp8xsCZu6xZTmfecKtT8T9J8eHL9zlhY/bEBC+uhDolSA1yf7GeIEsbujjaSTsMqGsy/mEo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr517167pjt.1.1664585987422; Fri, 30 Sep
 2022 17:59:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:00 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-18-seanjc@google.com>
Subject: [PATCH v4 17/32] KVM: SVM: Add helper to perform final AVIC "kick" of
 single vCPU
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

Add a helper to perform the final kick, two instances of the ICR decoding
is one too many.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 40a1ea21074d..dd0e41d454a7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -317,6 +317,16 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
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
@@ -415,11 +425,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
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
 
@@ -443,13 +449,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
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
2.38.0.rc1.362.ged0d419d3c-goog

