Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44055A7195
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiH3XRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiH3XRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:17:12 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305219FAAE
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:25 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c18-20020a170902d49200b001750f4fb8beso2515486plg.15
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=tQH5mj5DXx8pDOg5+wg55pqynAIGnsFRb1EgCvXniyg=;
        b=pTQWse+nJwxm+r4pe+tWC4i8rGRAYXwYceIjdjBLn6lmePyYYyXsYxZF/mj7LFUfKy
         qgF08o0eK0D4v6CFJtSEHQYwlJAopF1ycK2haq12XM3oEtZU55/whez15jVRdCJEJEpW
         70jZhhj2bUiUua9tPcnEIYrTYKVuI1+3AVpaJOr9d1Rb0KpekVFtqlVXsdKSS6/RcorK
         lXayw/8slmB185RAixROfy70CxHsiMs8p6yM3g4HR1Id2+T+WYk++nimIE5fLYPGdEN+
         3/Aec/wbh4mjGwPIuRfICITCznuXvhyZQUG0ZeFrnHek8PlidnAjVCBDE3R2yFNyyXuL
         BbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=tQH5mj5DXx8pDOg5+wg55pqynAIGnsFRb1EgCvXniyg=;
        b=wBgY9joaki6f4jk4jBthrD7cFCVKjdf//se723k1h+QrCUpGUOie4qVF7Si/JwVTmc
         /Mi48RVVuMbe2BXFoXM76kKylLfTJWU7sO99IJRFCkNy3uXMBxPyKMggm83t8zc35mFn
         0fXnlY3sdpBXbWaL7UGudoc4hCZnnYUTAZQlMDXpMjsllnxa9yJKAp7RdXkTsbSRQFZL
         Ahqb+NrRRVwW2ps56Ei/HBrnX9+cFsgzCgWdQpiH8Cy/J/LalKEHpg5Jjd6jBCFofBDL
         Pg5kAc+4Qy/iJ+NCB80V2H0TukPNp5WG96sCL2ZIUFr+n0usDh7CyrHxejLf/capZdEt
         1PQQ==
X-Gm-Message-State: ACgBeo2F4qVOYlSZKdUryyIqaaKHnMQwG6GCcvEmN+7T1kPlYLSzg96c
        KiI2BX48bFpejTlrgVa0vESooMCJxB8=
X-Google-Smtp-Source: AA6agR5SmoOabESqzgeL3XbiGJ9fl5e/kwquZZibIowi2wwuplpE/2byG8fZNALDzoNTqoiF00GnDVhNngc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b0c:b0:171:325a:364e with SMTP id
 o12-20020a1709026b0c00b00171325a364emr22929892plk.150.1661901384910; Tue, 30
 Aug 2022 16:16:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:52 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-6-seanjc@google.com>
Subject: [PATCH v5 05/27] KVM: x86: Suppress code #DBs on Intel if MOV/POP SS
 blocking is active
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Suppress code breakpoints if MOV/POP SS blocking is active and the guest
CPU is Intel, i.e. if the guest thinks it's running on an Intel CPU.
Intel CPUs inhibit code #DBs when MOV/POP SS blocking is active, whereas
AMD (and its descendents) do not.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7403221c868e..013580c355d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8542,6 +8542,23 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
+static bool kvm_is_code_breakpoint_inhibited(struct kvm_vcpu *vcpu)
+{
+	u32 shadow;
+
+	if (kvm_get_rflags(vcpu) & X86_EFLAGS_RF)
+		return true;
+
+	/*
+	 * Intel CPUs inhibit code #DBs when MOV/POP SS blocking is active,
+	 * but AMD CPUs do not.  MOV/POP SS blocking is rare, check that first
+	 * to avoid the relatively expensive CPUID lookup.
+	 */
+	shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
+	return (shadow & KVM_X86_SHADOW_INT_MOV_SS) &&
+	       guest_cpuid_is_intel(vcpu);
+}
+
 static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 					   int emulation_type, int *r)
 {
@@ -8584,7 +8601,7 @@ static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 	}
 
 	if (unlikely(vcpu->arch.dr7 & DR7_BP_EN_MASK) &&
-	    !(kvm_get_rflags(vcpu) & X86_EFLAGS_RF)) {
+	    !kvm_is_code_breakpoint_inhibited(vcpu)) {
 		unsigned long eip = kvm_get_linear_rip(vcpu);
 		u32 dr6 = kvm_vcpu_check_hw_bp(eip, 0,
 					   vcpu->arch.dr7,
-- 
2.37.2.672.g94769d06f0-goog

