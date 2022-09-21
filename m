Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276035BF212
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiIUAdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiIUAc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:32:56 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BC4792F6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:54 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n10-20020a170902e54a00b001782663dcaeso2709203plf.18
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=in1e99LU0Ccpw/X/GIRYkJpr4V5oHdTaxBm51ABK8Zw=;
        b=fxdaQ36wvXASTDMSCMzYP+4owRlpPpJcqJ4F20fEjNf3NkP/XvFqT6xHl6n3ymucfl
         wAkGHRzbnCmY2sRlXf6ZWxdMJOLwsB9akqzNsLJ63vLPgpDdP/+uiqDwiJPNyKPaW9d7
         W2gxRWjRcioAK5oyxgmQ+mvd8Xlfcqcs1FkpQ/Oqp1HeXyhy4RotzrvhRKtqe8D+3zPD
         +CkxhFgpHhUHVq6NWMedQTZChQMs8Bwl5AD6kmQ5xMId+9oxitQlXRTCf8+K4ilieGZt
         o5dYeYoVYv1Nk//INpmg7k40TTkb2qfPNYErptOcyucxi9O7dxpRl/MDPplYtfBX3bMF
         AtFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=in1e99LU0Ccpw/X/GIRYkJpr4V5oHdTaxBm51ABK8Zw=;
        b=DmKEAeV3jU9M6oJ8/rpCNv45+5Xl4avx+0oNJtLlS//Oo4yscwcp0hQKd5xQjTuLGp
         242xfEVEZxtyh82NWuoanr+PgL+Gy5ZW5JX+YslYlllRaLTDkt1cdwT86jRS5cpIbVx+
         9MyrvolKBSbj3OSdnwRWw+Pa29bWZdgT/ssOtty+H/E0/rsrccmalxN3W/jEEo1d+c+h
         47mtP+Rs5xBCMeTdIgOG1QrUFHzQWFHqwgyDQutXsaXk6JJ9Wi22Q4g1Iz/QH9Ad2Bty
         UJV7cLPbl2N9ywQg1gax4j5BK26Xfa+qop4gu0qKbD8ttJbG84ZpJcKxwS/Or99/b1n2
         6bfQ==
X-Gm-Message-State: ACrzQf3B5s3GyesId7Rdiy9tEdLgGBPvTMGCVpPTZTaXFDdT92ZzTm07
        gKs2rarDKeqsvSdj8ac6pmJC8aDMLgw=
X-Google-Smtp-Source: AMsMyM5mvx4Hh7HCt8EQDTkIMloT3kDTM73/Oxb6s3/QbBaMaLHOT1W35eSuZRH5DC184c70ddSZg22LA4I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cf11:b0:178:29d7:4fbd with SMTP id
 i17-20020a170902cf1100b0017829d74fbdmr2199821plg.174.1663720374306; Tue, 20
 Sep 2022 17:32:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:53 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-5-seanjc@google.com>
Subject: [PATCH v4 04/12] KVM: x86: Rename kvm_apic_has_events() to make it
 INIT/SIPI specific
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
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

Rename kvm_apic_has_events() to kvm_apic_has_pending_init_or_sipi() so
that it's more obvious that "events" really just means "INIT or SIPI".

Opportunistically clean up a weirdly worded comment that referenced
kvm_apic_has_events() instead of kvm_apic_accept_events().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.h | 2 +-
 arch/x86/kvm/x86.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index c3ce6b0b1ea3..a5ac4a5a5179 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -224,7 +224,7 @@ static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
 	return lapic_in_kernel(vcpu) && vcpu->arch.apic->apicv_active;
 }
 
-static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
+static inline bool kvm_apic_has_pending_init_or_sipi(struct kvm_vcpu *vcpu)
 {
 	return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59be7b16b92f..16a24dd28f26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11920,8 +11920,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 
 		/*
-		 * To avoid have the INIT path from kvm_apic_has_events() that be
-		 * called with loaded FPU and does not let userspace fix the state.
+		 * All paths that lead to INIT are required to load the guest's
+		 * FPU state (because most paths are buried in KVM_RUN).
 		 */
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
@@ -12765,7 +12765,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
 
-	if (kvm_apic_has_events(vcpu))
+	if (kvm_apic_has_pending_init_or_sipi(vcpu))
 		return true;
 
 	if (vcpu->arch.pv.pv_unhalted)
-- 
2.37.3.968.ga6b4b080e4-goog

