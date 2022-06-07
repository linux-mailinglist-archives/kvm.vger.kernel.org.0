Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F380054225E
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444336AbiFHBBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574452AbiFGXZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:25:44 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA28F174282
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:20 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m5-20020a17090a4d8500b001e0cfe135c7so8182607pjh.3
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WXqg88p2W+QoqW0x8irccM2qB/JUANba4v+R2Pcoblk=;
        b=kYHBUq4aXh+WUpNxwTAVniJskGH5s70WIrbs5mbLliVUPU5pTzBwiHADxfu6Lneur4
         q5sQZjf4vvflRuaczsuPRnSiBVWv43bbVBuUaxLONzgkFMlXjruI/Rn13pUb8onmC0uz
         MND83pFzT2kK1dqtAUYl5WkGNNPECOUIuqPIAlYAe9Zfgpthry2RYANmICZZSkFg4tDy
         TfqmrZiy+/qCPRluPFZzwMmk/FX3fQIv+aj13Bm2DAUKtEK35keG1eoGP5lbSzbSUsuR
         zX1UbwyEFD1EmqUTMlnx7LlVAcZBl0CHMXbK0bjYSZDUY4kH7n/jgF3BF4R6OBe9Qz6U
         3fOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WXqg88p2W+QoqW0x8irccM2qB/JUANba4v+R2Pcoblk=;
        b=W7EegT2qnnpgsYaqAfkSP9gK1W9RlmuKeRiptAAin1knnhfXNUpr4Y82l/kR7yNvqp
         5dWKLsWqwlytalU67dMecI41L/l5K3MEtodDtib8gJzr3l8fOSraL+/aTokzfk6j2E2A
         t5NUagv+w3kx9+YeS8ia4Omv6iYQ1WvYSadbm/Wrdf4JpBoAs27xitv+qjPTlVHcmaq0
         YMe33USY35ngInY9FmMXqtBv0ZZooOPGAlHZHH96J7s2z2bwHa4Fkq0FOzC5S+55XAqV
         dIC9tXJb+4nvQzWYQvM+m05H+Vc7l5aNsh0gEcyl0r//r8BP4K3Ox4A/EXVmgvcwEc6/
         52/A==
X-Gm-Message-State: AOAM530V/lJcmrBZsYmlsn46j5I/McPmY6IIbpHeaWxb1+VebGTrASC7
        uLyiYyTXtVz4b50DM/I7sLVwrKt0yvE=
X-Google-Smtp-Source: ABdhPJzoH10sKmh/w1/pRGxvESN5pblryY/rwKpo8gAUEdW6XnwIoFFqF4IA02Ebcqh3S1FH9HwfcaVJ+NA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr408946pje.0.1654637778961; Tue, 07 Jun
 2022 14:36:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:50 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 01/15] KVM: x86: Split kvm_is_valid_cr4() and export only
 the non-vendor bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

Split the common x86 parts of kvm_is_valid_cr4(), i.e. the reserved bits
checks, into a separate helper, __kvm_is_valid_cr4(), and export only the
inner helper to vendor code in order to prevent nested VMX from calling
back into vmx_is_valid_cr4() via kvm_is_valid_cr4().

On SVM, this is a nop as SVM doesn't place any additional restrictions on
CR4.

On VMX, this is also currently a nop, but only because nested VMX is
missing checks on reserved CR4 bits for nested VM-Enter.  That bug will
be fixed in a future patch, and could simply use kvm_is_valid_cr4() as-is,
but nVMX has _another_ bug where VMXON emulation doesn't enforce VMX's
restrictions on CR0/CR4.  The cleanest and most intuitive way to fix the
VMXON bug is to use nested_host_cr{0,4}_valid().  If the CR4 variant
routes through kvm_is_valid_cr4(), using nested_host_cr4_valid() won't do
the right thing for the VMXON case as vmx_is_valid_cr4() enforces VMX's
restrictions if and only if the vCPU is post-VMXON.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  3 ++-
 arch/x86/kvm/vmx/vmx.c    |  4 ++--
 arch/x86/kvm/x86.c        | 12 +++++++++---
 arch/x86/kvm/x86.h        |  2 +-
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 88da8edbe1e1..2953939d5bf4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -320,7 +320,8 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 			return false;
 	}
 
-	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
+	/* Note, SVM doesn't have any additional restrictions on CR4. */
+	if (CC(!__kvm_is_valid_cr4(vcpu, save->cr4)))
 		return false;
 
 	if (CC(!kvm_valid_efer(vcpu, save->efer)))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fd2e707faf2b..57df799ffa29 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3187,8 +3187,8 @@ static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	/*
 	 * We operate under the default treatment of SMM, so VMX cannot be
-	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
-	 * handled by kvm_is_valid_cr4().
+	 * enabled under SMM.  Note, whether or not VMXE is allowed at all,
+	 * i.e. is a reserved bit, is handled by common x86 code.
 	 */
 	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
 		return false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2db6f0373fa3..540651cd28d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1079,7 +1079,7 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
-bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & cr4_reserved_bits)
 		return false;
@@ -1087,9 +1087,15 @@ bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
 		return false;
 
-	return static_call(kvm_x86_is_valid_cr4)(vcpu, cr4);
+	return true;
+}
+EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
+
+static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return __kvm_is_valid_cr4(vcpu, cr4) &&
+	       static_call(kvm_x86_is_valid_cr4)(vcpu, cr4);
 }
-EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 501b884b8cc4..1926d2cb8e79 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -434,7 +434,7 @@ static inline void kvm_machine_check(void)
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
-- 
2.36.1.255.ge46751e96f-goog

