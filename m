Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96159523D
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 07:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiHPFyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 01:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiHPFxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 01:53:53 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4183076
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:29 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31f3959ba41so79219227b3.2
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=ZJS0tbmGYAfYT3DCAVjNZ8U5TGUCgBRd96hfOlG3874=;
        b=oq0otXyTRC5dSymoYUkHzsUCka7UFl4ktCR5JWnOhEKaylkGbOsLgrWXXqZ+nui3GM
         pPEYW6VqFCW/DUd+wPm8JqgMJ5RBoHvSV9cE+5OSOpgku94BfXLWyAQ3T7HCpF/ajA3H
         4Jh2FytDDCshHEN3rQLCaJUJQG6SItnv0yfru1YgbH8bywXYBEDAZlyRN4FgtQot9kK4
         pe7qfpzGMPBAQmKNpJdvhRwHxxvjPJ07xxzpzMij7g08V/z72iMQEfkW1qcXh6DvgY99
         NvC6QBokKjljT/jei/Jx1zjGKqD05OL0m+NCMP81DPTBmLHIxlb+5BhqNHcRIrtucQSa
         n48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ZJS0tbmGYAfYT3DCAVjNZ8U5TGUCgBRd96hfOlG3874=;
        b=WcCiNRPV/nClE0B/ROnNplm5n1nP9gFol9ej0lmNbsQs/7A7yIR3aBk0gqpFW89CdK
         jnVNyVgKWgzcqKGpvYk+dYIbVUJcRY2DVDZC2llo/honpMIzRh4gM2wKfRmJPYn6bipt
         tcDTqLy7A4wNaQnLnH8Euxvu+9GzYJJqAX/Dn5M5iJw576j/EEU8EDBxZkcV8U9VxhOo
         2HFsqhWb2ki+fz+ecp9U3dUL87Bfe8/Ysw2+L/tT2pHltY9gAhEEplQNzdvYeLsDY2BP
         7az6751xffuoHMhbnJpAv49HViiPHTgRfTU4gDdUsDMo/pFO46J/EuL1yyJcWGlIiICT
         S5xw==
X-Gm-Message-State: ACgBeo0v0RtDxd2IpNz2H4OO33nH3+gNw5UppDU2q4ZINNGeuRwkh21Y
        DW8/pFrxzt2yc6s2HftGxued4lAVy4KErA==
X-Google-Smtp-Source: AA6agR4WB20E3rHDe/f/HqpLsp8KVEVyTklWfw3GfmDTmer9e7n/WqldbqVVrkqg5WcxLBcEAzlR9CoHicUhHg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:6dc7:0:b0:328:3070:3dad with SMTP id
 i190-20020a816dc7000000b0032830703dadmr14369526ywc.247.1660604488669; Mon, 15
 Aug 2022 16:01:28 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:08 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 7/9] KVM: x86/mmu: Handle "error PFNs" in kvm_faultin_pfn()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Handle "error PFNs" directly in kvm_faultin_pfn() rather than relying on
the caller to invoke handle_abnormal_pfn() after kvm_faultin_pfn().
Opportunistically rename kvm_handle_bad_page() to kvm_handle_error_pfn()
to make it more consistent with e.g. is_error_pfn().

The reason for this change is to reduce the number of things being
handled in handle_abnormal_pfn(), which is currently a grab bag for edge
conditions (the other of which being updating the vCPU MMIO cache).

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6613ae387e1b..36960ea0d4ef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3134,7 +3134,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
 }
 
-static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 {
 	/*
 	 * Do not cache the mmio info caused by writing the readonly gfn
@@ -3155,10 +3155,6 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			       unsigned int access)
 {
-	/* The pfn is invalid, report the error! */
-	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
-
 	if (unlikely(!fault->slot)) {
 		gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
@@ -4144,7 +4140,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
-			return RET_PF_CONTINUE;
+			goto out;
 		}
 		/*
 		 * If the APIC access page exists but is disabled, go directly
@@ -4162,7 +4158,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
 	if (!async)
-		return RET_PF_CONTINUE; /* *pfn has correct page already */
+		goto out; /* *pfn has correct page already */
 
 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
@@ -4178,6 +4174,11 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
+
+out:
+	if (unlikely(is_error_pfn(fault->pfn)))
+		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
+
 	return RET_PF_CONTINUE;
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

