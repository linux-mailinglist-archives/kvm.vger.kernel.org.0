Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402A95A72C4
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiHaAiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiHaAhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:37:13 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ED8AA3F5
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:03 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a17-20020a17090abe1100b001fda49516e2so5515954pjs.2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=+YMlCYc3ExFhBvYYADHjoE7ZsXqjL3nmZXjZ12ZiBNw=;
        b=sLNACwIJjMr1ibfCQ93pmBhaT79sm158HWrLH3PRFrFvzygtTWVigpI2OlQRDw5QXN
         MO8uT4BKABOGwX5vGOO7BzoHeg9gQfVjB3OJ1uvfMPL3H4SKJPw1b6yW3Fh5jY1WUgVf
         BrLOzeUWMB7f5TGHjJZ6bOwp0ev/MiX7H841oomE+B8NatX77H99VbBLNTEJ+krbs6iT
         ANxXOacClU8ppUO6qCOnpsLDNgn1dcFvH2ePriX7+itvU0eiNcK/u8eirQmOr+DsGvJm
         1SLH0/D83wpAQSE6opsCLSpuRK967tzQZ+PYFLK7IUA/T1Qopj9L1BBFJIQy0UqmLW2A
         ovIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=+YMlCYc3ExFhBvYYADHjoE7ZsXqjL3nmZXjZ12ZiBNw=;
        b=SEkPiMtfT3sZ0uQQ+ANcu3oNAMW+IagPI0oCQ3xQpkB9Pz07jGJToQeqQIuXjkDUUQ
         Wv23nI5Yw9hd1U6g1yx73l3PgWLKQxbb7MU55i38LXF/PgvJIjU0e9Yjyje/XpREbvGc
         MpQRiCMsIbcAl6/je0bTgCVs7f7i+KXfLshkBt08AZXaza35/cEKvxjKlzpr4a4o2DRy
         K/dHjtVqqIoIAG2bF4iEdpDRgNVdwXcSGlyrsQYFLKCfFY1U9PbIz+a3kFAookK59wRK
         DgsbWnvu06X7/CGz0aAnY+x7sqb88w0PTDJhga6c+VHRXWytvwI8gULWdpA1I6a1ARw6
         qWnQ==
X-Gm-Message-State: ACgBeo39XWBdZXf/cf1uaEa6nOaYxI9Vv26sK5EIlb010yuilIEneuq1
        ilsTvCpmem3b6woN5l0Z+xZ/E3FW+28=
X-Google-Smtp-Source: AA6agR6TMGjcK254MJkJTONU/65Ct6ilW9/zfFyM5frT68x5QoUsxITnrV6TghN0fRA891jz32a/NaI1yxQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9242:0:b0:536:f215:4f4f with SMTP id
 2-20020aa79242000000b00536f2154f4fmr23764791pfp.45.1661906127770; Tue, 30 Aug
 2022 17:35:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:58 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-12-seanjc@google.com>
Subject: [PATCH 11/19] KVM: SVM: Add helper to perform final AVIC "kick" of
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
---
 arch/x86/kvm/svm/avic.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3959d4766911..2095ece70712 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -329,6 +329,16 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
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
@@ -427,11 +437,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
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
 
@@ -455,13 +461,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
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
2.37.2.672.g94769d06f0-goog

