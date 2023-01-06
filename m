Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C9165F8BC
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbjAFBN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbjAFBNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:19 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7000D71FC2
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:18 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id g9-20020a25bdc9000000b0073727a20239so441209ybk.4
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U8maFLX/9emtR9Ry3/JNGkiRA36hfakt5AevFKMRuP8=;
        b=FDPrant3hMVGIRHqyuyr8ArImAU9GINekaycon8t2xlOdFMNVNZY2cfGp0nNw3dW54
         1YV8Mw5cRxet3a+fCY7wJLIyCFO+s+iduPSgPyfflvb4tI3HdFebsvVT/RF4xz+4pSLV
         y7TOm5efaEc8M6aB8SfVAptefpHTx7ufHNShtJqwyMyfJpJahK5EL2U96+WqZ8FMIgVA
         kq1odA7Dq6Tu960vucowHuolVI4IKR8t0nCJ5A42s5tnCxEgJYQOG66ZPcBVtw3fOblC
         DAR7OoG1RW2vUBQAGf7wezgsWKDd2kS64Z/vT8wohB9aNZGcNQqnf2tO3CsF/v7HnCxc
         BPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8maFLX/9emtR9Ry3/JNGkiRA36hfakt5AevFKMRuP8=;
        b=uLANlI6elgBtGdm638ZzpkCkrvZ8wWuupelQ97T/305/Ny2orUtLdyKlq0SjBZvhpG
         vjGkonhL5B1ggcGHaNGyd9CPGpzzM52iGbC7Cfom9Y6cFGtiMSFMFJm5EqcjDNF+mB2f
         SMldxeoO3+aZEy3nBuhFUf72lNlDqdUIOATKRlTGiCuZ18x4nbKNAsUUCjfPxjZ5CArC
         nV690MpMwFGvIdJsAf6uvA5ouyJVRwcxEfMHxh5Z128bxcaG7rQmdx1gd1kyYhVbfnbv
         Kgn6NNG0ES5P3oA5uBLLGIaoKldp+1eB9KCBiuiI2//aLeGVmYJ3EOJIi1mcwa0ZFDgP
         HPug==
X-Gm-Message-State: AFqh2kr5l348jzxL2zFzPAjo4gpMOQorovOoyv83oAVxlWjcygu7EdWX
        lvHNntETEhrmwga4/rZS98WOWXZBkeY=
X-Google-Smtp-Source: AMrXdXso30EpQBw9HhKbz+QwLBHZavS/RwMyrHm/n9ZeG7jc3GA9k1RcV7YYQFH5iQsm0LWp8nlFePh6Z1E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a087:0:b0:700:a7b4:1af9 with SMTP id
 y7-20020a25a087000000b00700a7b41af9mr3497734ybh.227.1672967597770; Thu, 05
 Jan 2023 17:13:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:35 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-3-seanjc@google.com>
Subject: [PATCH v5 02/33] KVM: x86: Purge "highest ISR" cache when updating
 APICv state
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5c0f93fc073a..33a661d82da7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2424,6 +2424,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		 */
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
+	apic->highest_isr_cache = -1;
 }
 
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -2479,7 +2480,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
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
2.39.0.314.g84b9a713c41-goog

