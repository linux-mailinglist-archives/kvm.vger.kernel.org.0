Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C264AFD3
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiLMGXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiLMGXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:23:17 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882481DF36
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:23:15 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id q93-20020a17090a1b6600b0021311ab9082so1344486pjq.7
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aMfkf9JaTWq5ygn/doKop4uBuUwmfEjATXtS7I7e5VQ=;
        b=s97a/Lk7hPNNVD2nMqMABrZAVCXthbLWAJGKp3IKXCJGZTGLf9R9WB7GIys4E8E/n8
         P194pOmFHiAi4gP/eJ0dbaE1uxWT+iV8Cu5zfSAt8U/EO1iawGvOMIpDMXgJS5qHOWeC
         LpzANdeH5zLAXcYs8B3pbPsXvdnPmHPUR8zuvtDcfzOsd3VxgKSeGMANPnTRrXe7gmLI
         D5ofevcfrbl/IMha46u4fBvw/BzB36U/cJjzsBfqfqr+JsAdz0/vgmBwGa/h+n9yip66
         Gd1oXGa8On1HuWaAf1AnhRSbbsZ4TBES61UZolz4IdV1LrgMdWEHIyXqYyRtpbakFvn8
         C5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aMfkf9JaTWq5ygn/doKop4uBuUwmfEjATXtS7I7e5VQ=;
        b=YAoNK6lepsIRMOXlxgSwR06fKgBTI4ry0rpuSIPAzUlhCePRFDNp/qZjly3vd0TH2E
         6A1fQotC7oTzu5t1R7vEtN5T3aUCq3dunmf31TMqS7fJmprNLVtL3/UVCGSl8Dwn69+o
         ZeYdFC17ieidXh4L9Dmq7YZN/VS0frESN88Xobh40/hak5vSBx+3VxJWkfxaPyjIrpj7
         52r1ZS9Vm5Ot8f7aUAErbnad5CDJHs2JcS84jxjN9s/jpjkpIN0+YVJvGc74NUSnj7+6
         AGCvEoCkjp8MBt06vQEebZh23MRvIXEUC+OrVyfSRvk1dn+3AWiV5PIg1wsTNo1iCvlD
         mJnQ==
X-Gm-Message-State: ANoB5pk3HgqCIUcFlBT65EzDQBKjaywkLq2bpo/DTHXid71psmcA+J/k
        Ueo7iifg2dDQzjKn+oiIJ9kLVJZ25p0=
X-Google-Smtp-Source: AA0mqf4IJQiCVZKVHCPLq56LgmwhLS/V6P8b8GFlqJnHT4KfNVClh34AfU1ebEQaItg/Dufxn85a6JwOpK0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9ecb:0:b0:576:fa16:80e0 with SMTP id
 r11-20020aa79ecb000000b00576fa1680e0mr18843852pfq.64.1670912595091; Mon, 12
 Dec 2022 22:23:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:23:06 +0000
In-Reply-To: <20221213062306.667649-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213062306.667649-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213062306.667649-5-seanjc@google.com>
Subject: [PATCH v2 4/4] KVM: selftests: Test KVM's handling of VMX's sec exec
 MSR on KVM_SET_CPUID
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Verify that KVM does, and does not, modify the allowed set of VMX's
secondary execution controls during KVM_SET_CPUID.  Historically, KVM has
modified select bits in response to guest CPUID changes to try and force
a consistent CPU model.  KVM's meddling causes problems if userspace
invokes KVM_SET_CPUID after explicitly setting the MSR, as KVM may end up
overriding a legal userspace config.

Newer, fixed KVM versions maintain the historical meddling for backwards
compatibility, but only if userspace has never set the MSR for the vCPU.
I.e. KVM transfers ownership to userspace on the first write.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/include/x86_64/vmx.h        |  4 +-
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 92 +++++++++++++++++++
 3 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b1a31de7108a..9314a06f56d3 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -109,6 +109,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_INVPCID		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 10)
 #define	X86_FEATURE_RTM			KVM_X86_CPU_FEATURE(0x7, 0, EBX, 11)
 #define	X86_FEATURE_MPX			KVM_X86_CPU_FEATURE(0x7, 0, EBX, 14)
+#define X86_FEATURE_RDSEED		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 18)
 #define	X86_FEATURE_SMAP		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 20)
 #define	X86_FEATURE_PCOMMIT		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 22)
 #define	X86_FEATURE_CLFLUSHOPT		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 23)
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 5f0c0a29c556..b66661ba28c8 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -61,8 +61,8 @@
 #define SECONDARY_EXEC_SHADOW_VMCS		0x00004000
 #define SECONDARY_EXEC_RDSEED_EXITING		0x00010000
 #define SECONDARY_EXEC_ENABLE_PML		0x00020000
-#define SECONDARY_EPT_VE			0x00040000
-#define SECONDARY_ENABLE_XSAV_RESTORE		0x00100000
+#define SECONDARY_EXEC_EPT_VE			0x00040000
+#define SECONDARY_EXEC_ENABLE_XSAVES		0x00100000
 #define SECONDARY_EXEC_TSC_SCALING		0x02000000
 
 #define PIN_BASED_EXT_INTR_MASK			0x00000001
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
index 90720b6205f4..d7b1a72a8912 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
@@ -12,6 +12,96 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
+static void vmx_sec_exec_assert_allowed(struct kvm_vcpu *vcpu,
+					const char *name, uint64_t ctrl)
+{
+	TEST_ASSERT(vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2) & ctrl,
+		    "Expected '%s' to be allowed in sec exec controls", name);
+}
+
+static void vmx_sec_exec_assert_denied(struct kvm_vcpu *vcpu,
+				       const char *name, uint64_t ctrl)
+{
+	TEST_ASSERT(!(vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2) & ctrl),
+		    "Expected '%s' to be denied in sec exec controls", name);
+}
+
+static void vmx_sec_exec_control_test(struct kvm_vcpu *vcpu,
+				      const char *name,
+				      struct kvm_x86_cpu_feature feature,
+				      uint64_t ctrl, bool kvm_owned)
+{
+	/* Allowed-1 settings are in the upper 32 bits. */
+	ctrl <<= 32;
+
+	if (!this_cpu_has(feature))
+		return;
+
+	if (kvm_owned) {
+		vcpu_set_cpuid_feature(vcpu, feature);
+		vmx_sec_exec_assert_allowed(vcpu, name, ctrl);
+
+		vcpu_clear_cpuid_feature(vcpu, feature);
+		vmx_sec_exec_assert_denied(vcpu, name, ctrl);
+
+		/* Make sure KVM is actually toggling the bit. */
+		vcpu_set_cpuid_feature(vcpu, feature);
+		vmx_sec_exec_assert_allowed(vcpu, name, ctrl);
+	} else {
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2,
+			     vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2) | ctrl);
+		vmx_sec_exec_assert_allowed(vcpu, name, ctrl);
+
+		vcpu_set_cpuid_feature(vcpu, feature);
+		vmx_sec_exec_assert_allowed(vcpu, name, ctrl);
+
+		vcpu_clear_cpuid_feature(vcpu, feature);
+		vmx_sec_exec_assert_allowed(vcpu, name, ctrl);
+
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2,
+			     vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2) & ~ctrl);
+		vmx_sec_exec_assert_denied(vcpu, name, ctrl);
+
+		vcpu_set_cpuid_feature(vcpu, feature);
+		vmx_sec_exec_assert_denied(vcpu, name, ctrl);
+
+		vcpu_clear_cpuid_feature(vcpu, feature);
+		vmx_sec_exec_assert_denied(vcpu, name, ctrl);
+	}
+}
+
+#define vmx_sec_exec_feature_test(vcpu, name, kvm_owned)			\
+	vmx_sec_exec_control_test(vcpu, #name, X86_FEATURE_##name,		\
+				  SECONDARY_EXEC_ENABLE_##name, kvm_owned)
+
+#define vmx_sec_exec_exiting_test(vcpu, name, kvm_owned)			\
+	vmx_sec_exec_control_test(vcpu, #name, X86_FEATURE_##name,		\
+				  SECONDARY_EXEC_##name##_EXITING, kvm_owned)
+
+static void vmx_sec_exec_controls_test(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	if (this_cpu_has(X86_FEATURE_XSAVE))
+		vcpu_set_cpuid_feature(vcpu, X86_FEATURE_XSAVE);
+
+	if (this_cpu_has(X86_FEATURE_RDPID))
+		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_RDPID);
+
+	/*
+	 * Verify that for features KVM has historically taken control of, KVM
+	 * updates PROCBASED_CTLS2 during KVM_SET_CPUID if userspace has never
+	 * set the MSR, but leaves it alone once userspace writes the MSR.
+	 */
+	for (i = 0; i < 2; i++) {
+		vmx_sec_exec_feature_test(vcpu, XSAVES, !i);
+		vmx_sec_exec_feature_test(vcpu, RDTSCP, !i);
+		vmx_sec_exec_feature_test(vcpu, INVPCID, !i);
+		vmx_sec_exec_exiting_test(vcpu, RDRAND, !i);
+		vmx_sec_exec_exiting_test(vcpu, RDSEED, !i);
+	}
+}
+
 static void vmx_fixed1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
 				  uint64_t mask)
 {
@@ -124,6 +214,8 @@ int main(void)
 	/* No need to actually do KVM_RUN, thus no guest code. */
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
+	vmx_sec_exec_controls_test(vcpu);
+
 	vmx_save_restore_msrs_test(vcpu);
 	ia32_feature_control_msr_test(vcpu);
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

