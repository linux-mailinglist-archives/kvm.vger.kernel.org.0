Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728A25BF21F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiIUAdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiIUAdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:33:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06828796A9
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:33:00 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q188-20020a632ac5000000b004393cb3da9cso2518635pgq.3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=qOL17Oc8lfNiT6vI1N2DgBeo2oQr9pvN4OAUhg4HlfA=;
        b=ARUifQn8X722qfUwF91vggFYXNpMmdld6jHGucJn9mYIHgePg3e3ltjHazRJ7WJQIY
         w+6+dDv/mxautN/CuWkRVIzUB4MM0mFVqAUofjmwyaRB9E3nNhDZAx6ZDYK3UkIvlcW3
         K9NzDWtr9CpQ/CIsHl9VDcl9eNecHkOQ3A4eAV1FpyXScQBTQQwiNPVxGPrxUtBQTP6V
         AEpBQWZgYOtijs1937kE9A8HMcoOQ+ZcnStpwMSDNJZXDvCTzuIS4CNbetfFaKrPYBbF
         SNyUEVo0ACy2TKSphVy9cWwOnuMGoqVKl4ZpNYYdwpjQNgZOx/k9BLzDCMUkycF0nN5P
         tZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=qOL17Oc8lfNiT6vI1N2DgBeo2oQr9pvN4OAUhg4HlfA=;
        b=zOn0WrJnjNGEDXWLnlJWnN7cY+s/JvkBGmh4QrnA5+1CsAMhP+pD0RDCCyQHGgvusq
         YQqbgev5ldeSOwaoBqYYJpcGawjWdIKULaBPnCP/Ye2Qbd9OzJyLMlsvYoOPXWBEM2Kj
         PaRksNDukIGSSubpDCS88lZHYQVKbPyDYbVUEsMgJSL6A04xo+YWE3VViQJ/k4uoDVsx
         TiGqaUbQbxRyGWY0eHCxFvbBlRAwVCFS2GAiLHarsvD/Wen7TAIIThHTCXdHj70OkWI4
         k2NsjGK9vO7FF/OzqhW54OArus2DW9nlXhuNvq5WvJI1hPdJ+8eu3zOKApJR/uQP8Wix
         sDEg==
X-Gm-Message-State: ACrzQf3VKwswM43BbkAGjdf2iMsTt2015n6l2dL3t2S2GF25LAuNohbz
        OlJfdRByXk1ALEJ8ey+dlcRcAUz9Tv8=
X-Google-Smtp-Source: AMsMyM6CB910qkp43a3cP5VNkh9ZvqTlylmwVUImF03qdsZIEcBH6bFWk0KDb4437+crJl7uEogrf6c2DIk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:26d4:b0:178:8de:fb5f with SMTP id
 jg20-20020a17090326d400b0017808defb5fmr2230591plb.45.1663720379233; Tue, 20
 Sep 2022 17:32:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:56 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-8-seanjc@google.com>
Subject: [PATCH v4 07/12] KVM: nVMX: Make an event request if INIT or SIPI is
 pending on VM-Enter
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

Evaluate interrupts, i.e. set KVM_REQ_EVENT, if INIT or SIPI is pending
when emulating nested VM-Enter.  INIT is blocked while the CPU is in VMX
root mode, but not in VMX non-root, i.e. becomes unblocked on VM-Enter.
This bug has been masked by KVM calling ->check_nested_events() in the
core run loop, but that hack will be fixed in the near future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3a080051a4ec..5922531f6c52 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3377,6 +3377,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
+	if (!evaluate_pending_interrupts)
+		evaluate_pending_interrupts |= kvm_apic_has_pending_init_or_sipi(vcpu);
 
 	if (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
@@ -3457,18 +3459,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	}
 
 	/*
-	 * If L1 had a pending IRQ/NMI until it executed
-	 * VMLAUNCH/VMRESUME which wasn't delivered because it was
-	 * disallowed (e.g. interrupts disabled), L0 needs to
-	 * evaluate if this pending event should cause an exit from L2
-	 * to L1 or delivered directly to L2 (e.g. In case L1 don't
-	 * intercept EXTERNAL_INTERRUPT).
-	 *
-	 * Usually this would be handled by the processor noticing an
-	 * IRQ/NMI window request, or checking RVI during evaluation of
-	 * pending virtual interrupts.  However, this setting was done
-	 * on VMCS01 and now VMCS02 is active instead. Thus, we force L0
-	 * to perform pending event evaluation by requesting a KVM_REQ_EVENT.
+	 * Re-evaluate pending events if L1 had a pending IRQ/NMI/INIT/SIPI
+	 * when it executed VMLAUNCH/VMRESUME, as entering non-root mode can
+	 * effectively unblock various events, e.g. INIT/SIPI cause VM-Exit
+	 * unconditionally.
 	 */
 	if (unlikely(evaluate_pending_interrupts))
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-- 
2.37.3.968.ga6b4b080e4-goog

