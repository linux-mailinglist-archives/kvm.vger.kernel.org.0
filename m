Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5D650A640
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355269AbiDUQyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352895AbiDUQym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:54:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1D7496BD
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:51:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b73-20020a25cb4c000000b0064505a59a7aso4869875ybg.5
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IFP8dHfODAcQGiAaeMaPY6n82yRD8VX6rTDaKDuDzEA=;
        b=p9OLIeRHd/WWFguaSWOzgqSENN+cWNzfUAd9HPgNGe3r/rzFn62/OoDwtSjkoNL78A
         ec1FiOJ67UPu04RxzQolGEkLPyXnpyCe0vnOnI7vpmfGAz09rvlHWedd6NhgaBBa3ssq
         KMyBweJ4oUBbuHgwRW3neg+L0xQWZuOpCkrUoB0cb41CA+1R1sLYp/G5QQjrmZ2e4wwp
         qMBf/Phy4x24C8GsmqaEXK4LsAp3ye7Euya2qnbzoJQF43MAgst27zwKyxVA/i8uJ6fc
         lhlyS4n20g10s9/31Wru17Ho4nZC3jhQSQNLh4gVscY3ySdyqWwdFXkOcGwmj+nJdXuh
         GDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IFP8dHfODAcQGiAaeMaPY6n82yRD8VX6rTDaKDuDzEA=;
        b=APO27P9R9wHevmU1u5THYXQGsXnq0Q4I4RCKXmOySsTecWeBmf++MD+81uOQ8zSpw3
         pQtZuJBgtcMcGMmEhnjIXszLTVtthG5YIG4AGjJYQ9oJa1AlMPQgLgQKDPSOJQ1t3EW3
         JF2lzYaxay3Um6rMHbV1Kt9Cr9QK4YRC7p+Tfi2Yr7wCJLpRrnlIlwTszuMkoMz2oArq
         8Q/MO7DUt3Xk7IMXoVJKkcHRazBOkwquLzQhEqe8CjAKRcJMoXHImUSDKpY57MNN9u56
         7hcCPDjFvMEkrdvENrfUHSfwDgQpSrrj+o2k9IAgIQE7pxxZ9Py4uy5dwi+V3lnnS5gI
         314A==
X-Gm-Message-State: AOAM5320BAn0HAkcVJeEq2iOLiZYUv8+2cTX4CV1sTQvJvuBIhp9Mg7g
        4cMMgaB23FxgtZPp9QZBMPG74ue0
X-Google-Smtp-Source: ABdhPJyCWHZngFS/hK6FPiBgDeCIeK3wTfM3o5WOxaOCHNI3yjxGeiEtBjueumJuylGxnBtGQXTymqBx
X-Received: from posk.svl.corp.google.com ([2620:15c:2cd:202:af90:3136:42b1:c8e2])
 (user=posk job=sendgmr) by 2002:a05:6902:10c2:b0:645:2c6e:b43b with SMTP id
 w2-20020a05690210c200b006452c6eb43bmr662985ybu.358.1650559910996; Thu, 21 Apr
 2022 09:51:50 -0700 (PDT)
Date:   Thu, 21 Apr 2022 09:51:37 -0700
Message-Id: <20220421165137.306101-1-posk@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH] KVM: x86: add HC_VMM_CUSTOM hypercall
From:   Peter Oskolkov <posk@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Peter Oskolkov <posk@posk.io>,
        Peter Oskolkov <posk@google.com>
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

Allow kvm-based VMMs to request KVM to pass a custom vmcall
from the guest to the VMM in the host.

Quite often, operating systems research projects and/or specialized
paravirtualized workloads would benefit from a extra-low-overhead,
extra-low-latency guest-host communication channel.

With cloud-hypervisor modified to handle the new hypercall (simply
return the sum of the received arguments), the following function in
guest _userspace_ completes, on average, in 2.5 microseconds (walltime)
on a relatively modern Intel Xeon processor:

	uint64_t hypercall_custom_vmm(uint64_t a0, uint64_t a1,
					uint64_t a2, uint64_t a3)
	{
		uint64_t ret;

		asm(
			"movq   $13, %%rax \n\t"  // hypercall nr.
			"movq %[a0], %%rbx \n\t"  // a0
			"movq %[a1], %%rcx \n\t"  // a1
			"movq %[a2], %%rdx \n\t"  // a2
			"movq %[a3], %%rsi \n\t"  // a3
			"vmcall            \n\t"
			"movq %%rax, %[ret] \n\t" // ret
			: [ret] "=r"(ret)
			: [a0] "r"(a0), [a1] "r"(a1), [a2] "r"(a2), [a3] "r"(a3)
			: "rax", "rbx", "rcx", "rdx", "rsi"
		);

		return ret;
	}

Signed-off-by: Peter Oskolkov <posk@google.com>
---
 arch/x86/kvm/x86.c            | 28 ++++++++++++++++++++++++++--
 include/uapi/linux/kvm_para.h |  1 +
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..343971128da7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -108,7 +108,8 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
-#define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
+#define KVM_EXIT_HYPERCALL_VALID_MASK  ((1 << KVM_HC_MAP_GPA_RANGE) | \
+					(1 << KVM_HC_VMM_CUSTOM))
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
 
@@ -9207,10 +9208,16 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
+static int kvm_allow_hypercall_from_userspace(int nr)
+{
+	return nr == KVM_HC_VMM_CUSTOM;
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
+	int cpl;
 
 	if (kvm_xen_hypercall_enabled(vcpu->kvm))
 		return kvm_xen_hypercall(vcpu);
@@ -9235,7 +9242,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
+	cpl = static_call(kvm_x86_get_cpl)(vcpu);
+	if (cpl != 0 && !kvm_allow_hypercall_from_userspace(nr)) {
 		ret = -KVM_EPERM;
 		goto out;
 	}
@@ -9294,6 +9302,22 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
 		return 0;
 	}
+	case KVM_HC_VMM_CUSTOM:
+		ret = -KVM_ENOSYS;
+		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_VMM_CUSTOM)))
+			break;
+
+		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
+		vcpu->run->hypercall.nr       = KVM_HC_VMM_CUSTOM;
+		vcpu->run->hypercall.args[0]  = a0;
+		vcpu->run->hypercall.args[1]  = a1;
+		vcpu->run->hypercall.args[2]  = a2;
+		vcpu->run->hypercall.args[3]  = a3;
+		vcpu->run->hypercall.args[4]  = 0;
+		vcpu->run->hypercall.args[5]  = cpl;
+		vcpu->run->hypercall.longmode = op_64_bit;
+		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
+		return 0;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 960c7e93d1a9..8caab28c9025 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_MAP_GPA_RANGE		12
+#define KVM_HC_VMM_CUSTOM		13
 
 /*
  * hypercalls use architecture specific

base-commit: 150866cd0ec871c765181d145aa0912628289c8a
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

