Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C88C372EAF
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhEDRTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhEDRSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:18:55 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F448C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:18:00 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d16-20020ac811900000b02901bbebf64663so4019459qtj.14
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BGCQSILYAU01VvgA8TaO/AwM6Dcj3M5kpkKiJ9GwIVo=;
        b=VoB1ZQZUQTZDbAWIb7z6YLsP1EcMmTZaJ21TOhoo/VBB8DHbA/WYo7YmRUtOh+XWCL
         JHH+uUsd40UADuqDaFksTVfYQXRNeuI4xpnKVKdCjrsCWjSuUczwY6PkZMyaLmFMJt4p
         r9AXFSCo3QBnt2KcWe/W6aHmzAKDQl/I3vDLGVJT/HxrAwj5sgyIP2ptWLQWgXHQGU3E
         IZX8NGOJp4EBjwcMDGh964qDz/CTANPH1FckHRPrhLRkchsqqXBoWKAhbisk7iqXuUFC
         NtGAe0bVUIP024/Lo487nX7s+aMm0dtH3OVvl7VW6NKxgP/fNmzSOLn+VYLYU1ZxX+Cf
         fVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BGCQSILYAU01VvgA8TaO/AwM6Dcj3M5kpkKiJ9GwIVo=;
        b=ScDrpHTKDtgULD0O1TlfFVOSJ8rkflITNwa4mzBZkjc1jBY+OZQ9SNd3MBJYHFibty
         8pMThdQxricLw7Sxj9cOpZGDGwu9gwdxWzexHmPVTR4v2QjWR5/S6WbWdPzUnZ2zw5dT
         QRDgCKO0Fo1GXn2R5BtiLAi+ODqq95M/PmSoKVUeip7jnn18vc1vGwwzxCualRtNdh7t
         m5JMNUHA3lfH2DsHykdk8wDC5eXH/U+PmTSPZ9CdEcnF18b3wl/JkV6VFCBDbaYlffvi
         3BGjYIVXStmKnfXgIwDUbTLZhBNxFrAK7Rv/z8FB614uHUV7PIwjN1FAZiQTHROpXgeS
         91yg==
X-Gm-Message-State: AOAM5300q28XuH9ub7AmdsjHQ0s5u2gpcFcwoKoThsL2WVIFbYmcrFDh
        /Scgho00ar9G3zI5LzxZvLihwUgVNxM=
X-Google-Smtp-Source: ABdhPJzYd4vDWCMOY7/UC0i1nOs93WMze7d08OhFnwiOaXeQ9VuyOuNTqKK6zWp1RgoaybpJN7R/mxKxMS4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:ad4:5fc6:: with SMTP id jq6mr5885999qvb.43.1620148679153;
 Tue, 04 May 2021 10:17:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:26 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 07/15] KVM: x86: Add support for RDPID without RDTSCP
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

Allow userspace to enable RDPID for a guest without also enabling RDTSCP.
Aside from checking for RDPID support in the obvious flows, VMX also needs
to set ENABLE_RDTSCP=1 when RDPID is exposed.

For the record, there is no known scenario where enabling RDPID without
RDTSCP is desirable.  But, both AMD and Intel architectures allow for the
condition, i.e. this is purely to make KVM more architecturally accurate.

Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
Cc: stable@vger.kernel.org
Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  6 ++++--
 arch/x86/kvm/vmx/vmx.c | 27 +++++++++++++++++++++++----
 arch/x86/kvm/x86.c     |  3 ++-
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b3153d40cc4d..231b9650d864 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2669,7 +2669,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (tsc_aux_uret_slot < 0)
 			return 1;
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -2891,7 +2892,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			return 1;
 
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 
 		/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 990ee339a05f..42e4bbaa299a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1788,7 +1788,8 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	if (update_transition_efer(vmx))
 		vmx_setup_uret_msr(vmx, MSR_EFER);
 
-	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
+	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)  ||
+	    guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID))
 		vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
 
 	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL);
@@ -1994,7 +1995,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		goto find_uret_msr;
 	case MSR_IA32_DEBUGCTLMSR:
@@ -2314,7 +2316,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		/* Check reserved bit, higher 32 bits should be zero */
 		if ((data >> 32) != 0)
@@ -4368,7 +4371,23 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 						  xsaves_enabled, false);
 	}
 
-	vmx_adjust_sec_exec_feature(vmx, &exec_control, rdtscp, RDTSCP);
+	/*
+	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
+	 * feature is exposed to the guest.  This creates a virtualization hole
+	 * if both are supported in hardware but only one is exposed to the
+	 * guest, but letting the guest execute RDTSCP or RDPID when either one
+	 * is advertised is preferable to emulating the advertised instruction
+	 * in KVM on #UD, and obviously better than incorrectly injecting #UD.
+	 */
+	if (cpu_has_vmx_rdtscp()) {
+		bool rdpid_or_rdtscp_enabled =
+			guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
+			guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+
+		vmx_adjust_secondary_exec_control(vmx, &exec_control,
+						  SECONDARY_EXEC_ENABLE_RDTSCP,
+						  rdpid_or_rdtscp_enabled, false);
+	}
 	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
 
 	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e304447be42d..b4516d303413 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5978,7 +5978,8 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_TSC_AUX:
-			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
+			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP) &&
+			    !kvm_cpu_cap_has(X86_FEATURE_RDPID))
 				continue;
 			break;
 		case MSR_IA32_UMWAIT_CONTROL:
-- 
2.31.1.527.g47e6f16901-goog

