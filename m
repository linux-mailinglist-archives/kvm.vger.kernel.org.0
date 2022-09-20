Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591DB5BF118
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiITXbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiITXbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:31:41 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B835B6CD38
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:40 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a33-20020a630b61000000b00429d91cc649so2442795pgl.8
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=eDQhk0TUzS8gABrZyzO6jP9wbkUSKRsfywOJ1wwDdEA=;
        b=MhL2fiHhjRRJdJQeolFFDjGCBCjU5Icnq07HSKUApe1o+vJEuBqSCyOieoYCaP368V
         7joOK0RZTSZLGcyaD9pNXyNvuYq/1pzxl59Xb8ACZHav63d3CCIcfY0ADOuMVUJrmIsq
         4Tzs058ItmTmfo8vD5p3CgaMvPbgvw1qyJt0/fmggnFMBupeDoR/JX2veJojcsVtj5rP
         /Od0TDVGTYthl1lOC5/89a3M+2SIAdzVjiHam7KKPjYmzXkueqCBsV9CvmZ6zAqgtnZ6
         DRUvUzmWC9m/f+rwMpzDQVMu2v2q4EoROrV2n2ZR166h8NZDxQZgCbV0QJgTiIpZy/sv
         YXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=eDQhk0TUzS8gABrZyzO6jP9wbkUSKRsfywOJ1wwDdEA=;
        b=CFzMHwsPgybXe6txu4Kej3sSoxwx+vgiduBImO5EZqQt1PLKSk82P2j0tZ9Ak9OJdL
         oc6VZVUhvQgtCldMO4TTJnIUGygroA5JI+b7iTkixugDOUbEvu2WsxYzymViuj5Nju7l
         Kz5qObpNiVbtvJVjKnj3Lv4fIMSqeDZjD3R3rYvp5GQ/CFpEB3hqrAgOxzsDkgzRfbgE
         uuPIOC6JMlEN/rNg+uRqNbkomJkmszTRpC5eFYUItlwRlEgB55xz1q0tXlbtDStumcNe
         xVhH7sgnNzhGSFNfRS5Ris1g3w4DRHM8/KVzDRqLbJbV9BzzuQLdbdC2OW4tS+wAsIuV
         ZYmg==
X-Gm-Message-State: ACrzQf3Xl7/Iv377hae2KF9vwd7bB0eAS4PTNxyt9/kXJPAkL4jSq0xi
        vv/kv54gX0MmmMguXAaiNZOwM9Gi3es=
X-Google-Smtp-Source: AMsMyM4/ynt6lHO2zPsFgN/ZxGyjMWt9zmYzgfrZZ9jov3LaSY+FMZrs+2ef1RfVGsT9kH08iQL21YDc5bQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:90ce:0:b0:547:1cf9:40e6 with SMTP id
 k14-20020aa790ce000000b005471cf940e6mr26018655pfk.11.1663716700319; Tue, 20
 Sep 2022 16:31:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:08 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-3-seanjc@google.com>
Subject: [PATCH v3 02/28] KVM: x86: Purge "highest ISR" cache when updating
 APICv state
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
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8004c4d0a8e5..adac6ca9b7dc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2424,6 +2424,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		 */
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
+	apic->highest_isr_cache = -1;
 }
 EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 
@@ -2480,7 +2481,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 
@@ -2767,7 +2767,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	__start_apic_timer(apic, APIC_TMCCT);
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
-- 
2.37.3.968.ga6b4b080e4-goog

