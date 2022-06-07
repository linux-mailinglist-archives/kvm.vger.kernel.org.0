Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D3542586
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381937AbiFHA7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 20:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379560AbiFGXi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:38:57 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80A34007A8
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:44 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x128-20020a628686000000b0051bbf64668cso8755989pfd.23
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+20MfJ0vMHfzAJ9JVz3Ilf+oLJVPek78HYKPnn8c9cI=;
        b=GzaZwmfFP8vFYNZLORNpuD7awBp8Rety7blOC/GnKJeayC/QNhz/rVrqEoqPDIDJQ5
         Gr2bc9ghv6mUfiehiQpYB4cc9jcB+245qLe/uhRNEj1b40aCflSfQLnp3cG/pT12Y7k5
         LT+HWvQvuJ8ap7Rr7vj5EUwiqKVuwtVjnwTYDIk9bkqqLHVHrTHR8nlGRm5VMZDpzpNh
         7gllhD9j1UHaO3sB0xDYg0SJ+sZ4zTLEYK4X7Iecwa7qUSwAS8l4lCizJH3kXyeZD1mZ
         yhy7k8BbqWJ3eYRrbHvT+s0gvTS3IGbIp1nwvb6PoywDwjLY/9Mgncb0EHEgtDIAqlsP
         JAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+20MfJ0vMHfzAJ9JVz3Ilf+oLJVPek78HYKPnn8c9cI=;
        b=J5JMPxFkW9Iv4YB73IJ/x10ZopcJPvEmBUSer2gy9E3Uslt1d1E2gOYhZlqtSP33ZQ
         LO05oz6s25DaeDKL4poEVFLuzcqIK5k6LZt0wiR30pIPR5GmOn9do6+SpIOf0N3sxSte
         FbuSJC9oz4mfQwchWo1P7qLa3hs3zPqDOPg8NgNvAR9m2B9QWgIBne/HwvMu57odOs13
         Eo1EYqIQLsJkKbffKkemGV5d0+XOWzTKwGprGRxKjCVPFGSXW5hWCMPb/3UFAIQW4nA6
         S87kJHGEaXwFRC5bBLF1JBMCfW5iwu9Fwbfn7H4AVbG8Johom4lmB3h26lyseW75Vqz4
         fHQw==
X-Gm-Message-State: AOAM530K78QrZCSlV9j9MVTMsffuaSNw4tlvF/f+pH5g4SefQn3RzIcm
        J8Vet+e5ig2e/RuXTIiRNPYfV94nuOU=
X-Google-Smtp-Source: ABdhPJy8nvbk5N1f7eP43igaN6g5k1eob5EoUhjXROY9e4dJsbpdsRU4dDRkNiIQIOlD9np8KBtmGdLZlhc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1788:b0:51b:f462:b16 with SMTP id
 s8-20020a056a00178800b0051bf4620b16mr19566862pfg.42.1654637804006; Tue, 07
 Jun 2022 14:36:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:36:04 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 15/15] KVM: selftests: Verify VMX MSRs can be restored to
 KVM-supported values
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

Verify that KVM allows toggling VMX MSR bits to be "more" restrictive,
and also allows restoring each MSR to KVM's original, less restrictive
value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
index c0c4252a6a03..99d9614999c9 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
@@ -8,6 +8,7 @@
  * that KVM will set owned bits where appropriate, and will not if
  * KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS is disabled.
  */
+#include <linux/bitmap.h>
 
 #include "kvm_util.h"
 #include "vmx.h"
@@ -207,6 +208,65 @@ static void cr4_reserved_bits_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	cr4_reserved_bit_test(vm, vcpu, X86_CR4_LA57,       X86_FEATURE_LA57);
 }
 
+static void vmx_fixed1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
+				  uint64_t mask)
+{
+	uint64_t val = vcpu_get_msr(vcpu, msr_index);
+	uint64_t bit;
+
+	mask &= val;
+
+	for_each_set_bit(bit, &mask, 64) {
+		vcpu_set_msr(vcpu, msr_index, val & ~BIT_ULL(bit));
+		vcpu_set_msr(vcpu, msr_index, val);
+	}
+}
+
+static void vmx_fixed0_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
+				uint64_t mask)
+{
+	uint64_t val = vcpu_get_msr(vcpu, msr_index);
+	uint64_t bit;
+
+	mask = ~mask | val;
+
+	for_each_clear_bit(bit, &mask, 64) {
+		vcpu_set_msr(vcpu, msr_index, val | BIT_ULL(bit));
+		vcpu_set_msr(vcpu, msr_index, val);
+	}
+}
+
+static void vmx_fixed0and1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index)
+{
+	vmx_fixed0_msr_test(vcpu, msr_index, GENMASK_ULL(31, 0));
+	vmx_fixed1_msr_test(vcpu, msr_index, GENMASK_ULL(63, 32));
+}
+
+static void vmx_save_restore_msrs_test(struct kvm_vcpu *vcpu)
+{
+	vcpu_set_msr(vcpu, MSR_IA32_VMX_VMCS_ENUM, 0);
+	vcpu_set_msr(vcpu, MSR_IA32_VMX_VMCS_ENUM, -1ull);
+
+	vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_BASIC,
+			    BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55));
+
+	vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_BASIC,
+			    BIT_ULL(5) | GENMASK_ULL(8, 6) | BIT_ULL(14) |
+			    BIT_ULL(15) | BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30));
+
+	vmx_fixed0_msr_test(vcpu, MSR_IA32_VMX_CR0_FIXED0, -1ull);
+	vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_CR0_FIXED1, -1ull);
+	vmx_fixed0_msr_test(vcpu, MSR_IA32_VMX_CR4_FIXED0, -1ull);
+	vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_CR4_FIXED1, -1ull);
+	vmx_fixed0and1_msr_test(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2);
+	vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_EPT_VPID_CAP, -1ull);
+	vmx_fixed0and1_msr_test(vcpu, MSR_IA32_VMX_TRUE_PINBASED_CTLS);
+	vmx_fixed0and1_msr_test(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+	vmx_fixed0and1_msr_test(vcpu, MSR_IA32_VMX_TRUE_EXIT_CTLS);
+	vmx_fixed0and1_msr_test(vcpu, MSR_IA32_VMX_TRUE_ENTRY_CTLS);
+	vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_VMFUNC, -1ull);
+}
+
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -221,6 +281,7 @@ int main(void)
 	load_perf_global_ctrl_test(vm, vcpu);
 	load_and_clear_bndcfgs_test(vm, vcpu);
 	cr4_reserved_bits_test(vm, vcpu);
+	vmx_save_restore_msrs_test(vcpu);
 
 	kvm_vm_free(vm);
 }
-- 
2.36.1.255.ge46751e96f-goog

