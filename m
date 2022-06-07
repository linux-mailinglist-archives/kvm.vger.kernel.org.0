Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673875422AF
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386938AbiFHA7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 20:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376377AbiFGXi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:38:56 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1391400796
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:42 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id g3-20020a170902868300b00163cd75c014so10004148plo.14
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Y4MZ3Sym9w/pI1xJDthLYzwUgTFZC459iHyqI3Vsa9Y=;
        b=WEOEPyV3UHc47hAJUKfpAzZ48ZUzFYmQHB0fWCeJcFiChg8dzGz4HlnKycnt7EstWP
         qWt5lhkRyxo5y7pF+NPGwBCH8eWH8A1F6RtDttq17muu/nVoMccq2tahltetZmaPl8bE
         tnfnQomRLxMsMC9CK2foUlEbbxNe++WpIbzhy93MOifVYMKUnU9nvfhOPf0Y+TuNGGBi
         COrc/o+V12V4juRHqx0A7lT/+abgtAlMWx3pILFyG2/jtuV1WCSiHZygxHTB2YfdE3Fl
         cDqoPn5lvDD8jYxSyrEEmI/KBv//22VG+PkZOCw8M9KOUa6Xq7MRzFbbWI3BEXSq+917
         5nog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Y4MZ3Sym9w/pI1xJDthLYzwUgTFZC459iHyqI3Vsa9Y=;
        b=FVXIN0TtZeUyk0cigiADzWm/UI2MnTuwPNhUJvWAMHqADJz0Qv+zE6OtAFyoBZznRN
         1T14WQup4M/kxq1oFxmV7+IbvEUDbwAeOuiXzcA8C51TFTcK6MhgIB00ZNU5Pc0z5HdR
         3aVGGblL7SfTUTsvmevbpJ16aqi43zozad5PL5QfJmXIS0w6blh6ctbviWUwYaJbS/yO
         8r4raA/l1WWtquIEFbcTQhuarFkA9JvAih/RRvmvHaJosHg/9puY0xo816KrdixGXv3e
         VAFR4Cq8gWZwlcAEC0deyLRvfOSXZZ4bKTa/UUItvupf23iBJHmNWZd4URCfonicV8M7
         95iA==
X-Gm-Message-State: AOAM531hQ8S475A+xLL6kbsxRpYoEYJYkqNMmj8tUypZTXtBMNX5jnL+
        AmLLHrlQE+zdyjz4SoSs1W8naNoVizw=
X-Google-Smtp-Source: ABdhPJwEt7iBU7YM9aCf297nNnfk6Mo5q0/MsDJTnsQDWr/qDTwCDRdN2IJkkUsNOIbDYF3MHiU5HwHgsTo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a10:b0:51b:fbe1:cedb with SMTP id
 p16-20020a056a000a1000b0051bfbe1cedbmr18012140pfh.68.1654637802174; Tue, 07
 Jun 2022 14:36:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:36:03 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 14/15] KVM: selftests: Extend VMX MSRs test to cover
 CR4_FIXED1 (and its quirks)
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

Extend the VMX MSRs test to verify that KVM adheres to its established
quirky ABI for CR4_FIXED1 when VMX MSRS quirk is enabled, and that KV
doesn't touch CR4_FIXED1 when the quirk is disabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  7 ++
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 65 +++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 51cab9b080f7..716e72bc9163 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -87,9 +87,16 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_XSAVE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 26)
 #define	X86_FEATURE_OSXSAVE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 27)
 #define	X86_FEATURE_RDRAND		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 30)
+#define	X86_FEATURE_VME			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 1)
+#define	X86_FEATURE_DE			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 2)
+#define	X86_FEATURE_PSE			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 3)
+#define	X86_FEATURE_TSC			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 4)
+#define	X86_FEATURE_PAE			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 6)
 #define	X86_FEATURE_MCE			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 7)
 #define	X86_FEATURE_APIC		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 9)
+#define	X86_FEATURE_PGE			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 13)
 #define	X86_FEATURE_CLFLUSH		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 19)
+#define	X86_FEATURE_FXSR		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 24)
 #define	X86_FEATURE_XMM			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 25)
 #define	X86_FEATURE_XMM2		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 26)
 #define	X86_FEATURE_FSGSBASE		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 0)
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
index 9be2c2e3acf1..c0c4252a6a03 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
@@ -143,6 +143,70 @@ static void load_and_clear_bndcfgs_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu
 	test_vmx_ctrls(vm, vcpu, VM_ENTRY_LOAD_BNDCFGS, VM_EXIT_CLEAR_BNDCFGS);
 }
 
+static void cr4_reserved_bit_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				  uint64_t cr4_bit,
+				  struct kvm_x86_cpu_feature feature)
+{
+	uint64_t val;
+	int r;
+
+	if (!kvm_cpu_has(feature))
+		return;
+
+	vcpu_set_cpuid_feature(vcpu, feature);
+	val = vcpu_get_msr(vcpu, MSR_IA32_VMX_CR4_FIXED1);
+	TEST_ASSERT(val & cr4_bit,
+		    "KVM should set CR4 bit when quirk and feature are enabled");
+
+	vcpu_clear_cpuid_feature(vcpu, feature);
+	val = vcpu_get_msr(vcpu, MSR_IA32_VMX_CR4_FIXED1);
+	TEST_ASSERT(!(val & cr4_bit),
+		    "KVM should clear CR4 bit when quirk and feature are enabled");
+
+	r = _vcpu_set_msr(vcpu, MSR_IA32_VMX_CR4_FIXED1, val);
+	TEST_ASSERT(r == 0, "Writing CR4_FIXED1 should fail when quirk is enabled");
+
+	vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_TWEAK_VMX_MSRS);
+
+	val &= ~cr4_bit;
+	vcpu_set_msr(vcpu, MSR_IA32_VMX_CR4_FIXED1, val);
+
+	vcpu_set_cpuid_feature(vcpu, feature);
+	TEST_ASSERT(!(val & cr4_bit),
+		    "KVM shouldn't set CR4 bit when quirk is disabled");
+
+	val |= cr4_bit;
+	vcpu_clear_cpuid_feature(vcpu, feature);
+	TEST_ASSERT(val & cr4_bit,
+		    "KVM shouldn't clear CR4 bit when quirk is disabled");
+
+	vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, 0);
+}
+
+static void cr4_reserved_bits_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_VME,        X86_FEATURE_VME);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_PVI,        X86_FEATURE_VME);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_TSD,        X86_FEATURE_TSC);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_DE,         X86_FEATURE_DE);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_PSE,        X86_FEATURE_PSE);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_PAE,        X86_FEATURE_PAE);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_MCE,        X86_FEATURE_MCE);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_PGE,        X86_FEATURE_PGE);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_OSFXSR,     X86_FEATURE_FXSR);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_OSXMMEXCPT, X86_FEATURE_XMM);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_VMXE,       X86_FEATURE_VMX);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_SMXE,       X86_FEATURE_SMX);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_PCIDE,      X86_FEATURE_PCID);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_OSXSAVE,    X86_FEATURE_XSAVE);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_FSGSBASE,   X86_FEATURE_FSGSBASE);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_SMEP,       X86_FEATURE_SMEP);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_SMAP,       X86_FEATURE_SMAP);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_PKE,        X86_FEATURE_PKU);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_UMIP,       X86_FEATURE_UMIP);
+	cr4_reserved_bit_test(vm, vcpu, X86_CR4_LA57,       X86_FEATURE_LA57);
+}
+
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -156,6 +220,7 @@ int main(void)
 
 	load_perf_global_ctrl_test(vm, vcpu);
 	load_and_clear_bndcfgs_test(vm, vcpu);
+	cr4_reserved_bits_test(vm, vcpu);
 
 	kvm_vm_free(vm);
 }
-- 
2.36.1.255.ge46751e96f-goog

