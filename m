Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEC5372EC5
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhEDRTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhEDRTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:19:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F584C061342
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:18:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i201-20020a25d1d20000b02904ed4c01f82bso12703545ybg.20
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=n3WdNBU3wLg2BveFZOVMyvP1egZ3CBjYg+W/tOrWu7w=;
        b=P9lOY7moXKyYkZluKXbmMMkDQlfFbAkPP2wDNkED27PIj1b4i6FFISiWtL5WAVl5nY
         6cfelvMxZHAGVOq9hsc3gCalvxujh70dTTF2l6iBQUQ7ParF5ztKn/aG/tdxpff2EnQK
         8AMY7ns0OnqE/0AkxjclOd9+OQE4MorLT20iLimXbUJJP1Gyt4+CVRimOw5jtoqWjklg
         KRWsyYxKk1/olUpTRHkmQAT67E0+wnieg288etP1YKMF+Jzu1umOBzN6MB5i5xbcqMkm
         iPMYj2u5Kl5wgZN533a0sIk+OQHiHS3nnHcM8ydPOc+hCUsw7zg2xK9F0C3ODE6bQ8cJ
         tXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=n3WdNBU3wLg2BveFZOVMyvP1egZ3CBjYg+W/tOrWu7w=;
        b=FnpwB47Fqj6UOT4NmqBHW4A4+0D12fSDwmyDOfw3jXO/6aEfzvJPGksa9ynERVOM4o
         BQgQ5V+9TlPdZT81npddxhI7dRfxb7vy0StYTPm5ysN8bT9tmHTvXUo9+w+aUe563Dtb
         iPR0GIJJcQD+2srpjMwVBJnG1yrMl2rj0NtKVRyMy0yQqqkDM/3Q9pcI09WiWDhAYke1
         azd93c7MWnC4mmDHZggM5mQgMafTULE4BWq+gcqXX5ZUrg6Flj8ZC+AvgYC/awHey/FO
         4XXZdmPt7OVdeoFWr0XkaXcNdnMPn0kXsXT63gLk4P8GnD4IUXJVDcIFYpVUdwzAb4nv
         gfpw==
X-Gm-Message-State: AOAM533+JN5gagRj995JiJIIRQrd3EXhXWrb8RwESlYgP9eaMyh4uRro
        maRqmFoUnmnO+Gy1wi3V9EkhtTrrYfQ=
X-Google-Smtp-Source: ABdhPJwyh5X6WR35hSEdU0UOSUQJq4myiesLVifDWYcIH6ej+A+EgNY0bGrDFWfx929hgZ7bgpzF1NRuIGs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:ef51:: with SMTP id w17mr35753680ybm.520.1620148695580;
 Tue, 04 May 2021 10:18:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:33 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 14/15] KVM: x86: Tie Intel and AMD behavior for MSR_TSC_AUX to
 guest CPU model
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Squish the Intel and AMD emulation of MSR_TSC_AUX together and tie it to
the guest CPU model instead of the host CPU behavior.  While not strictly
necessary to avoid guest breakage, emulating cross-vendor "architecture"
will provide consistent behavior for the guest, e.g. WRMSR fault behavior
won't change if the vCPU is migrated to a host with divergent behavior.

Note, the "new" kvm_is_supported_user_return_msr() checks do not add new
functionality on either SVM or VMX.  On SVM, the equivalent was
"tsc_aux_uret_slot < 0", and on VMX the check was buried in the
vmx_find_uret_msr() call at the find_uret_msr label.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/svm/svm.c          | 24 ----------------------
 arch/x86/kvm/vmx/vmx.c          | 15 --------------
 arch/x86/kvm/x86.c              | 36 +++++++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a4b912f7e427..00fb9efb9984 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1782,6 +1782,11 @@ int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
+static inline bool kvm_is_supported_user_return_msr(u32 msr)
+{
+	return kvm_find_user_return_msr(msr) >= 0;
+}
+
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index de921935e8de..6c7c6a303cc5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2663,12 +2663,6 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
 	case MSR_TSC_AUX:
-		if (tsc_aux_uret_slot < 0)
-			return 1;
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
-			return 1;
 		msr_info->data = svm->tsc_aux;
 		break;
 	/*
@@ -2885,24 +2879,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
 	case MSR_TSC_AUX:
-		if (tsc_aux_uret_slot < 0)
-			return 1;
-
-		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
-			return 1;
-
-		/*
-		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
-		 * incomplete and conflicting architectural behavior.  Current
-		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
-		 * reserved and always read as zeros.  Emulate AMD CPU behavior
-		 * to avoid explosions if the vCPU is migrated from an AMD host
-		 * to an Intel host.
-		 */
-		data = (u32)data;
-
 		/*
 		 * TSC_AUX is usually changed only during boot and never read
 		 * directly.  Intercept TSC_AUX instead of exposing it to the
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 26f82f302391..d85ac5876982 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1981,12 +1981,6 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
-	case MSR_TSC_AUX:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
-			return 1;
-		goto find_uret_msr;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
@@ -2302,15 +2296,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
-	case MSR_TSC_AUX:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
-			return 1;
-		/* Check reserved bit, higher 32 bits should be zero */
-		if ((data >> 32) != 0)
-			return 1;
-		goto find_uret_msr;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index adca491d3b4b..896127ea4d4f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1642,6 +1642,30 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * invokes 64-bit SYSENTER.
 		 */
 		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
+		break;
+	case MSR_TSC_AUX:
+		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
+			return 1;
+
+		if (!host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
+			return 1;
+
+		/*
+		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
+		 * incomplete and conflicting architectural behavior.  Current
+		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
+		 * reserved and always read as zeros.  Enforce Intel's reserved
+		 * bits check if and only if the guest CPU is Intel, and clear
+		 * the bits in all other cases.  This ensures cross-vendor
+		 * migration will provide consistent behavior for the guest.
+		 */
+		if (guest_cpuid_is_intel(vcpu) && (data >> 32) != 0)
+			return 1;
+
+		data = (u32)data;
+		break;
 	}
 
 	msr.data = data;
@@ -1678,6 +1702,18 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
 		return KVM_MSR_RET_FILTERED;
 
+	switch (index) {
+	case MSR_TSC_AUX:
+		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
+			return 1;
+
+		if (!host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
+			return 1;
+		break;
+	}
+
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
-- 
2.31.1.527.g47e6f16901-goog

