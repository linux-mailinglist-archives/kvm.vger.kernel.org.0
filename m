Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936CA542365
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443972AbiFHBBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835827AbiFGX5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:57:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82C8020A
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 16:24:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u22-20020a170902a61600b0016363cdfe84so10088817plq.10
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 16:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SL65DdBq082IKvdmcNTmMQtCoV8atoipRLA1QMgRDIc=;
        b=Dj89HPCFl8s3IAThqpjWyxys+XUKp7TTdAWJsEz4I987pFdxNw5CFgbDeuD0i1FDaq
         xY4XEFNbOx4im9y1Dx7FsWJIQP7VreOF9N71bVt4JaT9b26DUmf6X68S3eMss4Rs0Hwd
         Ghs9IJkbkv1vcxUEoBUfTrJbLAZKZXsmGC8KHZgip9ImxxNHSc9NfY1V9Is6xjgMZAEk
         aOL3yAPdc1HOCbZ5qFuMVphSNqUln+9s3FNJliXgsgfxBWrokE1vNPA2B9NwEFhNx/yb
         H5rlqym9EmwowpfN/8Ov8F+tC3rL+Dk9BhwB6wqKQym4UUpfnNsq26Kr2wSQbVZkrZXA
         qH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SL65DdBq082IKvdmcNTmMQtCoV8atoipRLA1QMgRDIc=;
        b=kBOdZyBHc12L+K8i308htcRQx5Sn+rvE2IE43wgvcMHN6W7o1ah5KAiLVMgJOUyCuf
         h7HDtsqmMWBdKd9f3OU1EZRycBJsvESzL8JrdDPSrokeS95l9Nv/2L7xd+F3m+Zjyc0P
         Ah7MKVWGdUtdeBX1ijoUkV8zmUOHMSAWaW8pPLfmCKI57cRmIfzOonCytGY+8oR/n8Ok
         kybRfV9lG8CQyWgbaxKUonLZwo/z/6Vqi+l0su+s6YsOsnLf87GG84Ae0NeFlsU37mcV
         2wNvmwMQppIEgwl4dxIONj7qs6F9RrHqUtIxNTfv5s6tyqd806iUE5wrv8Kzcjf+w2rF
         1rRg==
X-Gm-Message-State: AOAM532bIx4p/+C34G9arbnqUkgppkXDYxG4qp/gh0q8rGGnZIqQwpz4
        BvUwki+ZnyC64tAJx9KCKS6TUc+TJV0=
X-Google-Smtp-Source: ABdhPJyJoSTHjbaAWG6DhtVEUtxc8q7IYnUfh/+5jT8gom9jK+kagnI+KY0TsYGbyyKE1RfOYwT2L/gpxBI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b193:b0:158:c040:5cf8 with SMTP id
 s19-20020a170902b19300b00158c0405cf8mr31421223plr.146.1654644241565; Tue, 07
 Jun 2022 16:24:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 23:23:53 +0000
In-Reply-To: <20220607232353.3375324-1-seanjc@google.com>
Message-Id: <20220607232353.3375324-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220607232353.3375324-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 3/3] KVM: selftests: Verify userspace can stuff
 IA32_FEATURE_CONTROL at will
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify the KVM allows userspace to set all supported bits in the
IA32_FEATURE_CONTROL MSR irrespective of the current guest CPUID, and
that all unsupported bits are rejected.

Throw the testcase into vmx_msrs_test even though it's not technically a
VMX MSR; it's close enough, and the most frequently feature controlled by
the MSR is VMX.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  2 +
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 47 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 716e72bc9163..dd6197c7eb1d 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -101,6 +101,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_XMM2		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 26)
 #define	X86_FEATURE_FSGSBASE		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 0)
 #define	X86_FEATURE_TSC_ADJUST		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 1)
+#define	X86_FEATURE_SGX			KVM_X86_CPU_FEATURE(0x7, 0, EBX, 2)
 #define	X86_FEATURE_HLE			KVM_X86_CPU_FEATURE(0x7, 0, EBX, 4)
 #define	X86_FEATURE_SMEP	        KVM_X86_CPU_FEATURE(0x7, 0, EBX, 7)
 #define	X86_FEATURE_INVPCID		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 10)
@@ -114,6 +115,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_PKU			KVM_X86_CPU_FEATURE(0x7, 0, ECX, 3)
 #define	X86_FEATURE_LA57		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 16)
 #define	X86_FEATURE_RDPID		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 22)
+#define	X86_FEATURE_SGX_LC		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 30)
 #define	X86_FEATURE_SHSTK		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 7)
 #define	X86_FEATURE_IBT			KVM_X86_CPU_FEATURE(0x7, 0, EDX, 20)
 #define	X86_FEATURE_AMX_TILE		KVM_X86_CPU_FEATURE(0x7, 0, EDX, 24)
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
index 99d9614999c9..4a3d5a39d990 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
@@ -267,6 +267,52 @@ static void vmx_save_restore_msrs_test(struct kvm_vcpu *vcpu)
 	vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_VMFUNC, -1ull);
 }
 
+static void __ia32_feature_control_msr_test(struct kvm_vcpu *vcpu,
+					    uint64_t msr_bit,
+					    struct kvm_x86_cpu_feature feature)
+{
+	uint64_t val;
+
+	vcpu_clear_cpuid_feature(vcpu, feature);
+
+	val = vcpu_get_msr(vcpu, MSR_IA32_FEAT_CTL);
+	vcpu_set_msr(vcpu, MSR_IA32_FEAT_CTL, val | msr_bit | FEAT_CTL_LOCKED);
+	vcpu_set_msr(vcpu, MSR_IA32_FEAT_CTL, (val & ~msr_bit) | FEAT_CTL_LOCKED);
+	vcpu_set_msr(vcpu, MSR_IA32_FEAT_CTL, val | msr_bit | FEAT_CTL_LOCKED);
+	vcpu_set_msr(vcpu, MSR_IA32_FEAT_CTL, (val & ~msr_bit) | FEAT_CTL_LOCKED);
+	vcpu_set_msr(vcpu, MSR_IA32_FEAT_CTL, val);
+
+	if (!kvm_cpu_has(feature))
+		return;
+
+	vcpu_set_cpuid_feature(vcpu, feature);
+}
+
+static void ia32_feature_control_msr_test(struct kvm_vcpu *vcpu)
+{
+	uint64_t supported_bits = FEAT_CTL_LOCKED |
+				  FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
+				  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX |
+				  FEAT_CTL_SGX_LC_ENABLED |
+				  FEAT_CTL_SGX_ENABLED |
+				  FEAT_CTL_LMCE_ENABLED;
+	int bit, r;
+
+	__ia32_feature_control_msr_test(vcpu, FEAT_CTL_VMX_ENABLED_INSIDE_SMX, X86_FEATURE_SMX);
+	__ia32_feature_control_msr_test(vcpu, FEAT_CTL_VMX_ENABLED_INSIDE_SMX, X86_FEATURE_VMX);
+	__ia32_feature_control_msr_test(vcpu, FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX, X86_FEATURE_VMX);
+	__ia32_feature_control_msr_test(vcpu, FEAT_CTL_SGX_LC_ENABLED, X86_FEATURE_SGX_LC);
+	__ia32_feature_control_msr_test(vcpu, FEAT_CTL_SGX_LC_ENABLED, X86_FEATURE_SGX);
+	__ia32_feature_control_msr_test(vcpu, FEAT_CTL_SGX_ENABLED, X86_FEATURE_SGX);
+	__ia32_feature_control_msr_test(vcpu, FEAT_CTL_LMCE_ENABLED, X86_FEATURE_MCE);
+
+	for_each_clear_bit(bit, &supported_bits, 64) {
+		r = _vcpu_set_msr(vcpu, MSR_IA32_FEAT_CTL, BIT(bit));
+		TEST_ASSERT(r == 0,
+			    "Setting reserved bit %d in IA32_FEATURE_CONTROL should fail", bit);
+	}
+}
+
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -282,6 +328,7 @@ int main(void)
 	load_and_clear_bndcfgs_test(vm, vcpu);
 	cr4_reserved_bits_test(vm, vcpu);
 	vmx_save_restore_msrs_test(vcpu);
+	ia32_feature_control_msr_test(vcpu);
 
 	kvm_vm_free(vm);
 }
-- 
2.36.1.255.ge46751e96f-goog

