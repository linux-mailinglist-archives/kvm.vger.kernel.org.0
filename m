Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B6664AF9A
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiLMGJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiLMGJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:09:20 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066281A809
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:19 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3cf0762f741so158334157b3.16
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+xrIAhvGbtHzogIJ3aNRRLQUShQPCNp9dtUJo01jRd4=;
        b=TGHdJLGEzqgYr9cAqGjdS3I4g33rP9ZZMIsLVLRpNw5QthQ5hNOCOIbR2FnxmU3emT
         BG0VoYoi8EQYjr9Ps/mEbzLbYgXxhMaaGFakXoyRnMg7exBdOpMv/P2grFeziK1ZZ+t8
         krjqRIC9W5rOMjaeNVgM7X/8G/PrWxPeTiBjtTYuyrTCIYBLEHrpZ1RHKvivzqBnwNRl
         Pyc9obee24XNzNAwLDVLPjAq7t+STbiLwQvNSJJf/a4VdYdDZ+nos6y2MLX9w775lzYX
         ScnLoAgHVKPv4imTnqHRhUte42MDWnoAkRUPvRfADnr8YMZIWKMm2gQb4U4AXh2rJuyo
         chfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xrIAhvGbtHzogIJ3aNRRLQUShQPCNp9dtUJo01jRd4=;
        b=dUhDy2oWoOBxcyjRuxjv1NaoQTLrYEZkIkKomcPV00Ceb8FXnsFL+oUE3nYt7Q+3/u
         0Q7e8SfUuXyltR0mp0sYFcOnrp/4GOqUZ5GZK4fwG3CG37b1RZd44M3xQAJAsqlI1x5i
         rurL4ltB65PGB6kTsh0tEkeh/NpVbRwATYmRQXpPV5ZQ8AlhG+L78pZabDQxepP6rXXf
         AYZ501bxyGyeNZINYgLnnQCIM+t+5yRYCbqh6VCFU5cBE9EPH0NWsHECoW1Xq8ifxKzj
         kdPWn++0SWhV+HYF4abpUO4IiQR7NvMWvfI/1S3y293NXXGfI+rkbUeKp9ZY+qRiF21a
         o5xw==
X-Gm-Message-State: ANoB5pm/M4a51n3FcKPZnpxinSJsmd08LztpiSGuUayLj1YPvrA8gdpn
        l3PUUPGVtiNYQ9jRH33VHAjmBcY7XMg=
X-Google-Smtp-Source: AA0mqf7eC+eRpSt2nLS+ccpNXnX4+Q2nZkSb/BXNkLxOr7fVQmesMF3CSY69wsR2dSK2ImsFWm8EkCm7V9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1683:0:b0:6f5:6a39:978e with SMTP id
 125-20020a251683000000b006f56a39978emr52138384ybw.6.1670911758316; Mon, 12
 Dec 2022 22:09:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:09:06 +0000
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213060912.654668-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213060912.654668-2-seanjc@google.com>
Subject: [PATCH 1/7] KVM: x86: Make vmx_get_exit_qual() and
 vmx_get_intr_info() noinstr-friendly
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
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

Add an extra special noinstr-friendly helper to test+mark a "register"
available and use it when caching vmcs.EXIT_QUALIFICATION and
vmcs.VM_EXIT_INTR_INFO.  Make the caching helpers __always_inline too so
that they can be used in noinstr functions.

A future fix will move VMX's handling of NMI exits into the noinstr
vmx_vcpu_enter_exit() so that the NMI is processed before any kind of
instrumentation can trigger a fault and thus IRET, i.e. so that KVM
doesn't invoke the NMI handler with NMIs enabled.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 12 ++++++++++++
 arch/x86/kvm/vmx/vmx.h        | 14 ++++++--------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index c09174f73a34..4c91f626c058 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -75,6 +75,18 @@ static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 }
 
+/*
+ * kvm_register_test_and_mark_available() is a special snowflake that uses an
+ * arch bitop directly to avoid the explicit instrumentation that comes with
+ * the generic bitops.  This allows code that cannot be instrumented (noinstr
+ * functions), e.g. the low level VM-Enter/VM-Exit paths, to cache registers.
+ */
+static __always_inline bool kvm_register_test_and_mark_available(struct kvm_vcpu *vcpu,
+								 enum kvm_reg reg)
+{
+	return arch___test_and_set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
 /*
  * The "raw" register helpers are only for cases where the full 64 bits of a
  * register are read/written irrespective of current vCPU mode.  In other words,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..bb720a2f11ab 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -669,25 +669,23 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
-static inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
+static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!kvm_register_is_available(vcpu, VCPU_EXREG_EXIT_INFO_1)) {
-		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
+	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1))
 		vmx->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-	}
+
 	return vmx->exit_qualification;
 }
 
-static inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
+static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!kvm_register_is_available(vcpu, VCPU_EXREG_EXIT_INFO_2)) {
-		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2);
+	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2))
 		vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-	}
+
 	return vmx->exit_intr_info;
 }
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

