Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEAA54BE1E
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245450AbiFNXF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiFNXF4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:05:56 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AABF52B0D
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:05:55 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2dc7bdd666fso37729327b3.7
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Q0TMDImt0VZIwoPHETcXPRYJP1DNJYILBSqC8/vVqok=;
        b=ta6l7+kTFeFE/qN7zdZPFqpwGtgLYrdwSjJiqgmRnVFGTXIyVpPzxGcSXf253gMO7n
         4fSoAa8H20nrv07KWry3VP/e9oSBkHFnbT3PyD8Z7VNdux8gstqBWuLrOhnUnvJLNDf4
         61M1JwCnBvS49Zj2Vy/t/B/uc/DAu/c0ODC/nVk//TseedPRU8rhEf5GAjBhfHYs0Psk
         1MalQWgrLMaeXWGvM4PWLU8rABpXuZM0O1zOm/X6vNIhE7zrwIwzYL6t9txu+lJJR9x+
         Ne2s/UebFJLUGrDjnbKniKsBmu6o0CtqRkijJvUQCMcBjtrIpkpNyaejSBC261h7X0WZ
         GLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Q0TMDImt0VZIwoPHETcXPRYJP1DNJYILBSqC8/vVqok=;
        b=UqspkIZiuk4fmQv6F1gHR3VLkEOCsD5VEJbeotBsHEXmZHdEIq+l7LYmvNYpABgdGH
         spsQaCmzVpiKIlBbJAS7Zjw4q8cy/TAwF5TN1i2dkUUcjOWlic/ZJjf3SvMGbqfpx598
         7AhHQdRpTtFejq82DtAV0WSEL6UrRNGzNaLWWXtzschr00CbU6XvotsEOgk17eCe1yFF
         PNxOoNKUEmlsaB+mUhP2/tX2tjAP23a3vU06VVH2hhNO/bprPqfuDAUlOBUlzhwcYEM7
         2RW79ktzfrPC3blx3KLDHtQO+6pQB/HmQgAvYAwxP1ClqBG3JtN4QKXYswdXLimSZj43
         Wkgw==
X-Gm-Message-State: AJIora/Iqmw37jfYAC5evZvE5CmjX+SrJ7ddTyYyCMz30Uo1B+Yc6dKU
        hC/NQ6bHwFdvX9f03OBvSGfx4YPaqLs=
X-Google-Smtp-Source: AGRyM1t82T1S2GRktx74IasIBtL1fM8tTA7F1HMXvd4jCUMFFB76wqNkMJJXE1FLGKmcV6+LqgVfC7FVpi4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:10cf:0:b0:313:aa13:ed0a with SMTP id
 198-20020a8110cf000000b00313aa13ed0amr8678346ywq.40.1655247954233; Tue, 14
 Jun 2022 16:05:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:05:45 +0000
In-Reply-To: <20220614230548.3852141-1-seanjc@google.com>
Message-Id: <20220614230548.3852141-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220614230548.3852141-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 2/5] KVM: x86: Drop @vcpu parameter from kvm_x86_ops.hwapic_isr_update()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Drop the unused @vcpu parameter from hwapic_isr_update().  AMD/AVIC is
unlikely to implement the helper, and VMX/APICv doesn't need the vCPU as
it operates on the current VMCS.  The result is somewhat odd, but allows
for a decent amount of (future) cleanup in the APIC code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/lapic.c            | 8 ++++----
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e98b2876380..16acc54d49a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1517,7 +1517,7 @@ struct kvm_x86_ops {
 	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
-	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
+	void (*hwapic_isr_update)(int isr);
 	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a413a1d8df4c..cc0da5671eb9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -556,7 +556,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	 * just set SVI.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, vec);
+		static_call_cond(kvm_x86_hwapic_isr_update)(vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -604,7 +604,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2457,7 +2457,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (vcpu->arch.apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, -1);
-		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, -1);
+		static_call_cond(kvm_x86_hwapic_isr_update)(-1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -2737,7 +2737,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	if (vcpu->arch.apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
-		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e14e4c40007..42f8924a90f4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6556,7 +6556,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	put_page(page);
 }
 
-static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+static void vmx_hwapic_isr_update(int max_isr)
 {
 	u16 status;
 	u8 old;
-- 
2.36.1.476.g0c4daa206d-goog

