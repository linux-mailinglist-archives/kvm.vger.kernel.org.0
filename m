Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E965BF219
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiIUAdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiIUAcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:32:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3120E792EA
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:53 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pf10-20020a17090b1d8a00b002037c2aad2bso6046432pjb.0
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=U5vFo4bt4S1YBkw7qJ/8SsXR9dI8fRaWN+LYTLGRLXc=;
        b=FGingks1cs8K3eS5eyjPLfgz2EyXv6C+mz7GjFjIsR+ztzCwCbQq/48DDu5g/uZ1Qf
         TKdHFjxeqF2i0gKdcBxhcxSwZQh25TbMTEUem6xBx1Il6mlI/R35MG7zDJLXZ+I7LRBZ
         mB01ACY29IvkNpuZxo5f8s86udAgXwT4AOfA1e8PAgFjsJzWl66pgmnkr+XqCz1Pxayf
         V7RA+S0PCVWgQtIYKdUAP6E/DVuSBq5M3Pu7Pd23qTYkXbQU93GZE0OA4qnvuhDPMOMn
         IE+AwnDKCJLEXKQ6ToCeXyPtQN6f4t7z2J4mxlNIQNjfcIA2lIcoI5cSSKDW/YvjdeCG
         Unmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=U5vFo4bt4S1YBkw7qJ/8SsXR9dI8fRaWN+LYTLGRLXc=;
        b=F5UFIuY48GZiSN2hMzEnN1qqpjVVGGavP4YaPx5axesQqSH6Hin61oglmYlseT/Ell
         X/+3mRR3vVA7GwMFUOI2biqmQ+NUMzNGgC5e0dP4O/ACkq3Ur8RFwlF7uY5H/wSxScmw
         vyZZ1hbEWyUHq3jtwQWcTM1ezGW4+yC1tiYbregdiR1XaI1aBiYnOQJKXm0As3Z0pkHB
         3TBVud6PIYV/PbuIKR69i4uuomAwU0i9CnH8YralBGhv+Ks+k9o6cgRsw2/Rf4Adjz5x
         HN0b1Tfw6Ejb9EtcPBZS5bG+EmOUVLr7PRUNwBZaKeQDw6ap/rq0joeL9p86b9WfC9ZJ
         rvEQ==
X-Gm-Message-State: ACrzQf08E4tYSJys7QJ+PR3dtLSxYiM0pcrSPJLrs/SpJmgZ13ac69WT
        BnhgxzxQtTvmRVpiBjCjvN2xQjNmWXM=
X-Google-Smtp-Source: AMsMyM7I8M2k58LdiY9Bn17s48fNmOAL5wLIHciB2Qx2fxuZBU4hSU51h5SdBz6suytGhuqo6XNaa5/wPfk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a9c6:b0:178:b2d4:f8b2 with SMTP id
 b6-20020a170902a9c600b00178b2d4f8b2mr2142306plr.79.1663720372595; Tue, 20 Sep
 2022 17:32:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:52 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-4-seanjc@google.com>
Subject: [PATCH v4 03/12] KVM: x86: Rename and expose helper to detect if
 INIT/SIPI are allowed
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

Rename and invert kvm_vcpu_latch_init() to kvm_apic_init_sipi_allowed()
so as to match the behavior of {interrupt,nmi,smi}_allowed(), and expose
the helper so that it can be used by kvm_vcpu_has_events() to determine
whether or not an INIT or SIPI is pending _and_ can be taken immediately.

Opportunistically replaced usage of the "latch" terminology with "blocked"
and/or "allowed", again to align with KVM's terminology used for all other
event types.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 arch/x86/kvm/lapic.h | 7 +++++++
 arch/x86/kvm/x86.c   | 9 +++++----
 arch/x86/kvm/x86.h   | 5 -----
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dda989a1cf0..2bd90effc653 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3051,14 +3051,14 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * INITs are latched while CPU is in specific states
+	 * INITs are blocked while CPU is in specific states
 	 * (SMM, VMX root mode, SVM with GIF=0).
 	 * Because a CPU cannot be in these states immediately
 	 * after it has processed an INIT signal (and thus in
 	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
 	 * and leave the INIT pending.
 	 */
-	if (kvm_vcpu_latch_init(vcpu)) {
+	if (!kvm_apic_init_sipi_allowed(vcpu)) {
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
 		if (test_bit(KVM_APIC_SIPI, &pe))
 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 117a46df5cc1..c3ce6b0b1ea3 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -7,6 +7,7 @@
 #include <linux/kvm_host.h>
 
 #include "hyperv.h"
+#include "kvm_cache_regs.h"
 
 #define KVM_APIC_INIT		0
 #define KVM_APIC_SIPI		1
@@ -228,6 +229,12 @@ static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
 	return lapic_in_kernel(vcpu) && vcpu->arch.apic->pending_events;
 }
 
+static inline bool kvm_apic_init_sipi_allowed(struct kvm_vcpu *vcpu)
+{
+	return !is_smm(vcpu) &&
+	       !static_call(kvm_x86_apic_init_signal_blocked)(vcpu);
+}
+
 static inline bool kvm_lowest_prio_delivery(struct kvm_lapic_irq *irq)
 {
 	return (irq->delivery_mode == APIC_DM_LOWEST ||
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e1a25e46dbf7..59be7b16b92f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11293,11 +11293,12 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		goto out;
 
 	/*
-	 * KVM_MP_STATE_INIT_RECEIVED means the processor is in
-	 * INIT state; latched init should be reported using
-	 * KVM_SET_VCPU_EVENTS, so reject it here.
+	 * Pending INITs are reported using KVM_SET_VCPU_EVENTS, disallow
+	 * forcing the guest into INIT/SIPI if those events are supposed to be
+	 * blocked.  KVM prioritizes SMI over INIT, so reject INIT/SIPI state
+	 * if an SMI is pending as well.
 	 */
-	if ((kvm_vcpu_latch_init(vcpu) || vcpu->arch.smi_pending) &&
+	if ((!kvm_apic_init_sipi_allowed(vcpu) || vcpu->arch.smi_pending) &&
 	    (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED ||
 	     mp_state->mp_state == KVM_MP_STATE_INIT_RECEIVED))
 		goto out;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a784ff90740b..829d3134c1eb 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -275,11 +275,6 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 	return !(kvm->arch.disabled_quirks & quirk);
 }
 
-static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
-{
-	return is_smm(vcpu) || static_call(kvm_x86_apic_init_signal_blocked)(vcpu);
-}
-
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 u64 get_kvmclock_ns(struct kvm *kvm);
-- 
2.37.3.968.ga6b4b080e4-goog

