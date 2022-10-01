Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4EF5F17B6
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 02:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiJAA70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 20:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiJAA7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 20:59:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486A01AF910
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 189-20020a2516c6000000b006bbbcc3dd9bso5208385ybw.15
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=9HZnxxV4Lu47qHeGw+m4H8xJT/iB8E+mQuPsqkTLvZo=;
        b=EgHb1LRJAwUhJDvw+Tu8ye1lUjtrA6UHF9kIPSVNUM46EliRJePeMD8MaXA/YtgT5P
         RHpNWWsXhSZcnyX/BpAJkXdiqIBiUBj5Z9l4PQ2H8GUfHlM1YGTqG4Dm3cCZkcCwM2CH
         ELe5C0tQtConxuuviisk/6Xq+NMUMnDlZhVvEm7USg2qbd3XI5LJnAnWoN31foRIL1gd
         75uYfoPofiVnFwLTi36WSQPAid3GAkreU3c7wXDabIFyUzG7sEQN84lgZyme+akaDcLH
         pPu350uwcQ09MuIUAIuzS7+V1QUnMQDq82h+Y3zELbFso/K8oFiLliQB/9XBoWDcaKUj
         0bOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=9HZnxxV4Lu47qHeGw+m4H8xJT/iB8E+mQuPsqkTLvZo=;
        b=gBt82ZnBMy0E0KhBxutHrL5M+MNeUI2zGhH4DrJiB2J41nIKJxWQG4DjQwD7WlGelN
         itsL4rJKFsF/SqLgdlOTUKnBkkpcXNdv17LUQ+7T/Rkeu+F9qtLLoZzJKzPEhv3MoUhG
         NAkHqImRhxAShb6qE7FF408aIDX0k/kOCNJzMP94zStY4XbxmQcQO+d9onteBP90XiAc
         QBpJtqsHQswojgo6DMG+FS3FY68RxU/ZssiojdfMYFFi468oThui29tu5yFTLojK0D8O
         k/pGGzr54s0b76r/VHQKJw4/pe5UOaJIRyV3RhybxpPyNGkFhjiFNN34QYZcQH3hkeRu
         nQsQ==
X-Gm-Message-State: ACrzQf3AfnMaquwaNCEdBRISNi6bYgiTpsHgy1/e4/oBY61PQzBE7sVf
        XJGuKVrD9u1g3Di7McvhBdW5geSZk1I=
X-Google-Smtp-Source: AMsMyM7C4X+TbFDK1lDbVLfRp8A7a9Ir40+eWROdzkElSMejLkU7QhIylcQz7HLdzJpVQgTReCmvOfgqnro=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a007:0:b0:6a9:3b58:31f with SMTP id
 x7-20020a25a007000000b006a93b58031fmr10317698ybh.44.1664585961604; Fri, 30
 Sep 2022 17:59:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:45 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-3-seanjc@google.com>
Subject: [PATCH v4 02/32] KVM: x86: Purge "highest ISR" cache when updating
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
index 05d079fc2c66..5de1c7aa1ce9 100644
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
2.38.0.rc1.362.ged0d419d3c-goog

