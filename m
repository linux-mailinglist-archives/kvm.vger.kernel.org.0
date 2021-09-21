Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A42412AF6
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbhIUCCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbhIUB5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:04 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED991C06B675
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:19 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id b15-20020a05622a020f00b0029e28300d94so193772429qtx.16
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YqbfZzjQ/AvQBDn1Ta/tO376jL+V+ic9nvcn2Wxl4Rg=;
        b=m9ro+zMtK9BWHdfacSbUJWo531Hv4pR/faXM+xmClXk+ok9MryvEuFd0x/d5L6e/9j
         IrjVc/PwOU0g7gQvItCHupC8zty6YMToKHi3Q9yG3sJkM82yspz5w8G84W233HRpl3JJ
         XnKOQq7ji09wv0vMWn+fmoDk8LFjLyNbSE2EVsGe+27HZoD5+MxCQNwSpHMkwvLXKyJL
         AFsDPedAmMJ4vmHRGomcFPt0Vr1VI6YEaq5hoBZ+sN3fUc5TX/bgNCypw+1z3t9grcM+
         DyHK231hyAftxptqsi12MwoZpgHryvTz7FFvfzuvB9e77pTG6A9GmsJZCWRVVbnBiUlw
         T9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YqbfZzjQ/AvQBDn1Ta/tO376jL+V+ic9nvcn2Wxl4Rg=;
        b=EPffVPu3LjxAJJmrRpenMu7pxkHz3tQ3epSKEwvqPh0wUwI3Vi8yapVp73biNB9v+J
         TDUbghFrRWvDSAHZolJjS6ScV+pjtl+0SIkZJkMqCsGwgUc2evn9k3nSatyHg6hcDsPH
         t3JOOG/51qDdBxfvs4ckpXfKnjOx2OcSQUwHHJ3lxLKIhles0XNT5jtFadN/PQtgRIW8
         5OckTMTBeeilT8/CRHHTq5X3Bl2Qa2wn4aJffujv/SdByAK6xcBYg+f3QNa62dk8N4LI
         K1CheT7yZvifJ9oUmPmXIve7TyPT74K2UJk0BaYkN2B1Nx3lVR3ABRcK5lBUP/UBgkJC
         L9JQ==
X-Gm-Message-State: AOAM530d+krFOh0tjExijfJ7QxOItFWBTFYgOuBK6Igb9FItObbG4H0E
        gwA9TPGNEX5byNkjt1Iqdwc5PkrV+DE=
X-Google-Smtp-Source: ABdhPJx6JRWuZjXtbBYQjXOmlmmGG6p6WyfxQOm9rxpa+uw/CaVsgYLx1i+MUg/Fz1wYvxZAh2JYX3vHqzM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a25:734a:: with SMTP id o71mr32934031ybc.74.1632182599124;
 Mon, 20 Sep 2021 17:03:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:02:59 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 06/10] KVM: x86: Fold fx_init() into kvm_arch_vcpu_create()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the few bits of relevant fx_init() code into kvm_arch_vcpu_create(),
dropping the superfluous check on vcpu->arch.guest_fpu that was blindly
and wrongly added by commit ed02b213098a ("KVM: SVM: Guest FPU state
save/restore not needed for SEV-ES guest").

Note, KVM currently allocates and then frees FPU state for SEV-ES guests,
rather than avoid the allocation in the first place.  While that approach
is inarguably inefficient and unnecessary, it's a cleanup for the future.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6fd3fe21863e..ec61b90d9b73 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10614,17 +10614,6 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void fx_init(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu->arch.guest_fpu)
-		return;
-
-	fpstate_init(&vcpu->arch.guest_fpu->state);
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
-			host_xcr0 | XSTATE_COMPACTION_ENABLED;
-}
-
 void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.guest_fpu) {
@@ -10703,7 +10692,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		pr_err("kvm: failed to allocate vcpu's fpu\n");
 		goto free_user_fpu;
 	}
-	fx_init(vcpu);
+	fpstate_init(&vcpu->arch.guest_fpu->state);
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
+			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
-- 
2.33.0.464.g1972c5931b-goog

