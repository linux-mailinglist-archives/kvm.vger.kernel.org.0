Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42A6369CCB
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 00:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244151AbhDWWfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 18:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243971AbhDWWe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 18:34:58 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA04C06138F
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:34:18 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id r18-20020a0ccc120000b02901a21aadacfcso17216371qvk.5
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Y4iQrQo2idMgVCLJBfNHPP4hN3euA9dQLTSysYHWP4Y=;
        b=u/a/AbF09+lGetelvU92prkShzTVv3APvauUzU956nfa+0+6lC4U5suIAU5bgFYXEM
         KbDW/g+5V/p/ebb/2jhFK3GsYTZ5AxDCWFewCpokthHMFuUIrKXVjSG48oLrhZkxidJQ
         QGUAEnQ3q8Jcca464P1xQha5rZYuzyas7cfoasxpRtcsZOS1mn9R1qs/nnJVmraYbYr8
         gAWD0TaDldQTz32RTwNMhlu+cmn+KSx5L/5TJKBv4mOlKlJJQwCCOjtBqlC0BFpX8tsh
         tEaPUZThjGvuFrP3IgyNO4GKAxQV+y21z1OiYG+V7y9Ix4+Y3Lw072glAekk8c1EtylQ
         Rh7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Y4iQrQo2idMgVCLJBfNHPP4hN3euA9dQLTSysYHWP4Y=;
        b=FkVOPPIsWhHu+cW8hVXtFFpiAQivODJ49JLDfc/C50GJsIBAtRmEQKNsMCluIbi+s1
         nGAxdijLqDHGndP2vHKSfrkpVNjnHFbt2F4Yeigxi5PzjiScv7UhUym7DHeEdeB8CrWU
         rE7plrmvyZeu+9Zswi7bc4YUhp9YzdIb+gmVitnFbNKP4C4w4vNVMJ/wB2tDdi60Rprz
         LGq7hhQTxiHEu3y/yLsCOCdRlB2fH4THG2mgBzi39s+ZbjMclEHC9a5BIvqr4DTFjOfh
         27ouMhKMf8siFMvJjRMQisKV6kQ2UGHhpSSntOfEEp2nL8X3uMz8aNYZ8+kcXtO0+uox
         qj8Q==
X-Gm-Message-State: AOAM5316OR877JGLCIwbdOTnjuqQfLyzpIC2IBZJbs/3kXoMZb/M85Jt
        oD+kS/kNL57dvzpUdY7hFl/TUO2vdSc=
X-Google-Smtp-Source: ABdhPJzVAroajCHy4YUpNDMgWCWiKlnY4/j28TO9Vt+DDZjrM4uWoNix7Xz+IJZX5a4TUJRfLH4CZQuXF4s=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a05:6214:176a:: with SMTP id
 et10mr6640697qvb.23.1619217257247; Fri, 23 Apr 2021 15:34:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 15:34:03 -0700
In-Reply-To: <20210423223404.3860547-1-seanjc@google.com>
Message-Id: <20210423223404.3860547-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210423223404.3860547-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v3 3/4] KVM: x86: Tie Intel and AMD behavior for MSR_TSC_AUX
 to guest CPU model
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Squish the Intel and AMD emulation of MSR_TSC_AUX together and tie it to
the guest CPU model instead of the host CPU behavior.  While not strictly
necessary to avoid guest breakage, emulating cross-vendor "architecture"
will provide consistent behavior for the guest, e.g. WRMSR fault behavior
won't change if the vCPU is migrated to a host with divergent behavior.

Note, this also adds a kvm_cpu_has() check on RDTSCP for VMX.  For all
practical purposes, the extra check is a nop as VMX's use of user return
MSRs indirectly performs the same check by checking the result of WRMSR.
Technically RDTSCP support can exist in bare metal but not in the VMCS,
but no known Intel CPUs behave this way.  In practice, the only scenario
where adding the kvm_cpu_has() check isn't a nop is nested virtualization
scenario where L0 hides the VMCS control from L1 (KVM in this case), and
the L1 userspace VMM has decided to advertise RDTSCP _against_ the
recommendations of KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 22 +---------------------
 arch/x86/kvm/vmx/vmx.c | 13 -------------
 arch/x86/kvm/x86.c     | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 71d704f8d569..4c7604fca009 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2672,11 +2672,6 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
 	case MSR_TSC_AUX:
-		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
-			return 1;
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
-			return 1;
 		msr_info->data = svm->tsc_aux;
 		break;
 	/*
@@ -2892,13 +2887,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
 	case MSR_TSC_AUX:
-		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
-			return 1;
-
-		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
-			return 1;
-
 		/*
 		 * This is rare, so we update the MSR here instead of using
 		 * direct_access_msrs.  Doing that would require a rdmsr in
@@ -2906,15 +2894,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 */
 		wrmsrl(MSR_TSC_AUX, svm->tsc_aux);
 
-		/*
-		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
-		 * incomplete and conflicting architectural behavior.  Current
-		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
-		 * reserved and always read as zeros.  Emulate AMD CPU behavior
-		 * to avoid explosions if the vCPU is migrated from an AMD host
-		 * to an Intel host.
-		 */
-		svm->tsc_aux = (u32)data;
+		svm->tsc_aux = data;
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!boot_cpu_has(X86_FEATURE_LBRV)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6501d66167b8..d3fce53d89ac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1992,11 +1992,6 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
-	case MSR_TSC_AUX:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
-			return 1;
-		goto find_uret_msr;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
@@ -2312,14 +2307,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
-	case MSR_TSC_AUX:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
-			return 1;
-		/* Check reserved bit, higher 32 bits should be zero */
-		if ((data >> 32) != 0)
-			return 1;
-		goto find_uret_msr;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f0d0b6e043ae..95da9b1cabdb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1610,6 +1610,29 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * invokes 64-bit SYSENTER.
 		 */
 		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
+		break;
+	case MSR_TSC_AUX:
+		if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
+			return 1;
+
+		if (!host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
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
@@ -1646,6 +1669,17 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
 		return KVM_MSR_RET_FILTERED;
 
+	switch (index) {
+	case MSR_TSC_AUX:
+		if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
+			return 1;
+
+		if (!host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+			return 1;
+		break;
+	}
+
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

