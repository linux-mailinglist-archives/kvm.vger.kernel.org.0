Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101885BF231
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiIUAdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiIUAdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:33:13 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FB4792F5
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:33:03 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pf10-20020a17090b1d8a00b002037c2aad2bso6046671pjb.0
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=+nmtDj/EH/uK0SyJnyCY1A9LxFaUnx5384By8rF2AcA=;
        b=rpWC/VKjogxaSKricNAD/sRggDf2m+ppcZ99cC4f6M2lXn9866lNJfALVMtFhxatIn
         qQLLRO1BUtEoQdRvY1yCuXD/CtkIEdb3+zCRL0TNiOdne1CQBhI/BizUOruqlzoGL1ru
         VCaVy6ynkLdl8Y2SlQn7F72+sRnXKS9nW+9M+WtquUBaCslXgLIbNwAo/KbGQ39Ut11+
         iX38zqjv00zbeQfFOy8nLz7/nmQA6SCthL08Bvu2Mg/I39d68rA1efgAA/OI3nSBX2ld
         cXZNYtWAos3dWx8qB/6lW1KWT1k2gQ6b3mCS+VL9cYwYuehjdDCD0p4cY7hCsI3NeNJV
         wlPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=+nmtDj/EH/uK0SyJnyCY1A9LxFaUnx5384By8rF2AcA=;
        b=N4DEToz8CFRkXy5r6e8TtY0YCifEiRKlMcpspe2PVnlhEPxQ9ofwpI5p4bX+nR2llk
         04LqM5/YwPM+y2/0ATQy/tZc8qn/jkuiCBTgXXqXMzwhPRtcOX//l7SBXPJ+jhwWF+E0
         oTOVuVFMIa2vv/99T12+uaAnXx18ZPtsAmMZMz6xAngcENBqerIHlpGDjsS1mrEEkW0D
         sRopakUmdEWQDTNRbAYYcObubWl32tHrOFts8GwlHOvlaZCkjdhRJ8eJTx867xgxKGow
         ybLy6zFimQ/d2q4erDxNmyMz3emeHAmppNL+NVQwnTNWbOKw/wSyVAmGn3kmkaaUARsR
         LF3g==
X-Gm-Message-State: ACrzQf1BUvbRXztwjD0CgpQK216GLWLFCopkpq3DOb7HUGCguDAAqQX5
        E3lLlxQgh8K8fSJx2XWT9Qi4x7Mnz4c=
X-Google-Smtp-Source: AMsMyM6zSXdEm/sdOmQ6ucVPu4StzA9LzXizITrmOCaLxtYOZuSorePqxSyOnSzLlOuDLemc+6OfhU9oA1I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a43:b0:202:7706:73d7 with SMTP id
 lb3-20020a17090b4a4300b00202770673d7mr6477790pjb.137.1663720382986; Tue, 20
 Sep 2022 17:33:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:58 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-10-seanjc@google.com>
Subject: [PATCH v4 09/12] KVM: x86: Don't snapshot pending INIT/SIPI prior to
 checking nested events
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

Don't snapshot pending INIT/SIPI events prior to checking nested events,
architecturally there's nothing wrong with KVM processing (dropping) a
SIPI that is received immediately after synthesizing a VM-Exit.  Taking
and consuming the snapshot makes the flow way more subtle than it needs
to be, e.g. nVMX consumes/clears events that trigger VM-Exit (INIT/SIPI),
and so at first glance it appears that KVM is double-dipping on pending
INITs and SIPIs.  But that's not the case because INIT is blocked
unconditionally in VMX root mode the CPU cannot be in wait-for_SIPI after
VM-Exit, i.e. the paths that truly consume the snapshot are unreachable
if apic->pending_events is modified by kvm_check_nested_events().

nSVM is a similar story as GIF is cleared by the CPU on VM-Exit; INIT is
blocked regardless of whether or not it was pending prior to VM-Exit.

Drop the snapshot logic so that a future fix doesn't create weirdness
when kvm_vcpu_running()'s call to kvm_check_nested_events() is moved to
vcpu_block().  In that case, kvm_check_nested_events() will be called
immediately before kvm_apic_accept_events(), which raises the obvious
question of why that change doesn't break the snapshot logic.

Note, there is a subtle functional change.  Previously, KVM would clear
pending SIPIs if and only SIPI was pending prior to VM-Exit, whereas now
KVM clears pending SIPI unconditionally if INIT+SIPI are blocked.  The
latter is architecturally allowed, as SIPI is ignored if the CPU is not
in wait-for-SIPI mode (arguably, KVM should be even more aggressive in
dropping SIPIs).  It is software's responsibility to ensure the SIPI is
delivered, i.e. software shouldn't be firing INIT-SIPI at a CPU until
it knows with 100% certaining that the target CPU isn't in VMX root mode.

Furthermore, the existing code is extra weird as SIPIs that arrive after
VM-Exit _are_ dropped if there also happened to be a pending SIPI before
VM-Exit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2bd90effc653..d7639d126e6c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3025,17 +3025,8 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u8 sipi_vector;
 	int r;
-	unsigned long pe;
 
-	if (!lapic_in_kernel(vcpu))
-		return 0;
-
-	/*
-	 * Read pending events before calling the check_events
-	 * callback.
-	 */
-	pe = smp_load_acquire(&apic->pending_events);
-	if (!pe)
+	if (!kvm_apic_has_pending_init_or_sipi(vcpu))
 		return 0;
 
 	if (is_guest_mode(vcpu)) {
@@ -3043,38 +3034,31 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		if (r < 0)
 			return r == -EBUSY ? 0 : r;
 		/*
-		 * If an event has happened and caused a vmexit,
-		 * we know INITs are latched and therefore
-		 * we will not incorrectly deliver an APIC
-		 * event instead of a vmexit.
+		 * Continue processing INIT/SIPI even if a nested VM-Exit
+		 * occurred, e.g. pending SIPIs should be dropped if INIT+SIPI
+		 * are blocked as a result of transitioning to VMX root mode.
 		 */
 	}
 
 	/*
-	 * INITs are blocked while CPU is in specific states
-	 * (SMM, VMX root mode, SVM with GIF=0).
-	 * Because a CPU cannot be in these states immediately
-	 * after it has processed an INIT signal (and thus in
-	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
-	 * and leave the INIT pending.
+	 * INITs are blocked while CPU is in specific states (SMM, VMX root
+	 * mode, SVM with GIF=0), while SIPIs are dropped if the CPU isn't in
+	 * wait-for-SIPI (WFS).
 	 */
 	if (!kvm_apic_init_sipi_allowed(vcpu)) {
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
-		if (test_bit(KVM_APIC_SIPI, &pe))
-			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
+		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
 		return 0;
 	}
 
-	if (test_bit(KVM_APIC_INIT, &pe)) {
-		clear_bit(KVM_APIC_INIT, &apic->pending_events);
+	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		kvm_vcpu_reset(vcpu, true);
 		if (kvm_vcpu_is_bsp(apic->vcpu))
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		else
 			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
 	}
-	if (test_bit(KVM_APIC_SIPI, &pe)) {
-		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
+	if (test_and_clear_bit(KVM_APIC_SIPI, &apic->pending_events)) {
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			/* evaluate pending_events before reading the vector */
 			smp_rmb();
-- 
2.37.3.968.ga6b4b080e4-goog

