Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C145ABBB2
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiICAXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiICAXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:02 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5370FF63D1
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r13-20020a17090a454d00b001f04dfc6195so1709981pjm.2
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=H/HByp3PJRruswmtBIPALL6gkH9l79nKV7vcOC9XVxY=;
        b=XOeXnIfKKWrhWxYJPMhiMqXpVXJ3ObDoI8TdggVIQBpsN4K7qSeFXajmY9O2iBTx1w
         L8lWlNa1T4AhcE1QV5rKSkfbco2RA0SYCndpTR1CCAteGce251GlAlOPWA2fPHK5ogyR
         okE4b7f9Eo6DSsCJn5+UyZj3wed8oBAZDnoKGRPKNb/bETmW0pGFie/2OwPvhtME++nG
         qO61P75YrK5vzJBnTWfQoEcpCJoh2NksjeHN7m9yY3gzIuAbB05/9jv8+Uz79cOZucZj
         qzW8frIU5J/ReHS6by3eUjEGUQNxkSco1HrwZH33OE8hAtce9untgMSPH6eUq4TXhYTR
         BxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=H/HByp3PJRruswmtBIPALL6gkH9l79nKV7vcOC9XVxY=;
        b=AeIBDudiePhnt2ttE4Tuu/edF+yOuoRA0LxpcRvW8cq2gNbrW7ytrftDE900u4rpUb
         xPoNNftdB3ITG2+mprNZRcbnV/9Zg0j+iUbgJbWkPKx1Q6g9hTS1zm3OaaK7+PuMt3Hz
         JjQW4GR7jzWUz3velCSwZVQgvD02bvLYaVAnhZRjlT4itm3kxy7gABworLrz++NnaVjx
         t/AtdWRI5zt4QBsjAFn7HcNKY4NMPj3dxJJnfGrMM0nOLQ0vB99rUqzuBVXTdPWJb08a
         8lkz3eqBkjnfIlrGkMna6CjIwMcPRRtLbMgWnpyvULuRx7YwAsX7ryVWMTGy2cG88azs
         jIvQ==
X-Gm-Message-State: ACgBeo3EYNDTBDdSOyYbxb9R2Rzxirqscnpzgl0rFRRf25Qq4EuHOD1Q
        a5aJVNcrXzcMaJetYNudFHjk+GK33ZI=
X-Google-Smtp-Source: AA6agR6tsfbR4JIT0tPkHJv92x9iGIm8/9fcY4kKjNcPaJLqPI9czTbJYO3Y65Jvu7K4ZPdA3Iv08+oKkp8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2003:b0:175:24eb:62b0 with SMTP id
 s3-20020a170903200300b0017524eb62b0mr19360164pla.60.1662164580907; Fri, 02
 Sep 2022 17:23:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:32 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-2-seanjc@google.com>
Subject: [PATCH v2 01/23] KVM: x86: Purge "highest ISR" cache when updating
 APICv state
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

Purge the "highest ISR" cache when updating APICv state on a vCPU.  The
cache must not be used when APICv is active as hardware may emulate EOIs
(and other operations) without exiting to KVM.

This fixes a bug where KVM will effectively block IRQs in perpetuity due
to the "highest ISR" never getting reset if APICv is activated on a vCPU
while an IRQ is in-service.  Hardware emulates the EOI and KVM never gets
a chance to update its cache.

Fixes: b26a695a1d78 ("kvm: lapic: Introduce APICv update helper function")
Cc: stable@vger.kernel.org
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dda989a1cf0..38e9b8e5278c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2429,6 +2429,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		 */
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
+	apic->highest_isr_cache = -1;
 }
 EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 
@@ -2485,7 +2486,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 
@@ -2772,7 +2772,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	__start_apic_timer(apic, APIC_TMCCT);
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
-- 
2.37.2.789.g6183377224-goog

