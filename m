Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0595BF21A
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiIUAcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiIUAcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:32:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C716E8BF
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:49 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id z9-20020a17090a468900b00202fdb32ba1so2069217pjf.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=v7YHpsXihO1IGC0K/PKlA8GEkrI37lPnwhd36LF7pVk=;
        b=T4Pq1vwhu58JKk9S6MS0EL1IJhE9KPvx6f3kP5213oRycLCnCPGalTsox3aAjnkBY+
         bvrARzyrfMnXa376luKHrUSUC3r41vDBz/363U0/GCT1m+sgrmqVasY3fcU9OUU8ZnQr
         fGLzK1tbOFeQ4wKJzJP+i1caYDQsEDEbwf5IEBhf8mxzB0P/PeEP0jzwrUt5tUlgn1vs
         khV0dI6DS92WUbMb+SK3UCu6WG61MT61dVs3It8NhZZ7b/6/vq2QNm9LhdsajCmXKYhu
         RM5VBfvag1jIjc/ktzcq5owOd+kKUM+xzeu/Nh4l3/G9+HsymuEMfqdrfo6zFFuJfavG
         EM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=v7YHpsXihO1IGC0K/PKlA8GEkrI37lPnwhd36LF7pVk=;
        b=gTeMnIboTmDoN++rh0oJl0CcCIZBkmKkk/7xwhNX48V/8CXF7rg06ZZjoHoBNYfF4/
         +sBGcrq/BFijhGqCXLRs6hA1gCxLVdXjxVzzUeazMXS6+NhOtnCUwdU7UENnaf5AlIee
         75UWiRfLE8E7AznpLItgWc+oNyqx0jIYa+fNP9MxW1h8uo9sI20Kc0FnuvnDjvMtrVt3
         CB0WoXO1X7JYZEi4ZnlqY2ac6qVHaV99TEMdVJIJm2R7vCz7ft2FMyVlIz9zNEEpLjNr
         Bzs/0t4Ph26JNiDtIy2tzc4tb7/QylEe29SawGqDZ9HgI/SNCx8slIgQ0dHNaFp8ggeb
         Ef0g==
X-Gm-Message-State: ACrzQf0KkrzCa5nI3MFzHekFCHtVc2wJ+n63jSAcvU4Dxxnd4JQa7OoV
        4gwPV9vxeG5BIiQFcUkoAUaXif6uur0=
X-Google-Smtp-Source: AMsMyM7sgUnowEJxKriF2nS2mMYPc53K7RWElo5y1ug5fX5KhtVWX0U//x1MzIKxCHK8PGNETQVSyl6SEZ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f644:b0:172:b074:d1f5 with SMTP id
 m4-20020a170902f64400b00172b074d1f5mr2177656plg.29.1663720369344; Tue, 20 Sep
 2022 17:32:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:50 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-2-seanjc@google.com>
Subject: [PATCH v4 01/12] KVM: x86: make vendor code check for all nested events
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Interrupts, NMIs etc. sent while in guest mode are already handled
properly by the *_interrupt_allowed callbacks, but other events can
cause a vCPU to be runnable that are specific to guest mode.

In the case of VMX there are two, the preemption timer and the
monitor trap.  The VMX preemption timer is already special cased via
the hv_timer_pending callback, but the purpose of the callback can be
easily extended to MTF or in fact any other event that can occur only
in guest mode.

Rename the callback and add an MTF check; kvm_arch_vcpu_runnable()
now can return true if an MTF is pending, without relying on
kvm_vcpu_running()'s call to kvm_check_nested_events().  Until that call
is removed, however, the patch introduces no functional change.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/nested.c       | 8 +++++++-
 arch/x86/kvm/x86.c              | 8 ++++----
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ee940c4c0f64..c03590d1c5e1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1649,7 +1649,7 @@ struct kvm_x86_nested_ops {
 	bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
 				    u32 error_code);
 	int (*check_events)(struct kvm_vcpu *vcpu);
-	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
+	bool (*has_events)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
 			 struct kvm_nested_state __user *user_kvm_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4da0558943ce..85318d803f4f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3929,6 +3929,12 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
+static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
+{
+	return nested_vmx_preemption_timer_pending(vcpu) ||
+	       to_vmx(vcpu)->nested.mtf_pending;
+}
+
 /*
  * Per the Intel SDM's table "Priority Among Concurrent Events", with minor
  * edits to fill in missing examples, e.g. #DB due to split-lock accesses,
@@ -6971,7 +6977,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.leave_nested = vmx_leave_nested,
 	.is_exception_vmexit = nested_vmx_is_exception_vmexit,
 	.check_events = vmx_check_nested_events,
-	.hv_timer_pending = nested_vmx_preemption_timer_pending,
+	.has_events = vmx_has_nested_events,
 	.triple_fault = nested_vmx_triple_fault,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5b8328cb6c14..e1a25e46dbf7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9966,8 +9966,8 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 	}
 
 	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		*req_immediate_exit = true;
 
 	WARN_ON(kvm_is_exception_pending(vcpu));
@@ -12792,8 +12792,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 		return true;
 
 	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		return true;
 
 	if (kvm_xen_has_pending_events(vcpu))
-- 
2.37.3.968.ga6b4b080e4-goog

