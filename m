Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE60372EAC
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhEDRS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbhEDRSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:18:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2B4C061763
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:17:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j63-20020a25d2420000b02904d9818b80e8so8157430ybg.14
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=x+NCaDzYaJB+NMadtQ9JUPGNk0j6WFjhbI1X+ndrCYA=;
        b=GYxeu56pESpHnymBBR37hcoL+erzIi1Cs2Fcie4S/JXxyz05HzWd8tfYRy2rUHxVD6
         eJtObUcSxC1FczqzDMUZNwHyfxJ21cyb6kmOP30GXeH7chJrTDIyg1/pQ8A4ErT237jt
         2e2nygFpJqozYZiDrgVQKjorHBF3s7zyrtYOS40HX12yiEZsf7gbjcIrrnB8RRb2Sb/1
         IreqbcFdIOSmU8aPz9ZhCeTCCRo0nmbb1RMCNevhOVOLeKFsE+rMuzbbGGOlpMIq7REm
         Vdn5utrZ4eXb4F5kpCx95zET+f3Sbv23kgnex9h7n5Y4dcZuPqjKfCZY9I6OvmHqqdb1
         /eGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=x+NCaDzYaJB+NMadtQ9JUPGNk0j6WFjhbI1X+ndrCYA=;
        b=k5XFKFU/ZTrrbMah7PCkiVaLxbTVF5WIAsC2pssuFhilTv4KYcKF6tmrOxlp9o3QCR
         DOS9llTncOM+rVo9URHS1J6hp0kYyjeebnmDLt6yePAAS1n8k0Uk3aR3SDVUi3nXDKuO
         CerPfSrW/1saF0xQtQf/DdWNLLDGmPbmMzhiWfeUT7wn3dLvUOXb57SAMZy4H46/nBjq
         XDvp4lhhhGur0WsEblRKubu0g/vQ4RAVJI37dwpxbgtXCPytR6mLkkNdFv3Lv1nEQfmd
         XlG6ha/sbhT+WEcUBxks1cN4KOmTAeF0REdzXtiKV6hAu3M/o1nFWfs32xeUW4X0TRNs
         fvug==
X-Gm-Message-State: AOAM5320uBrgXvw2yrb8xGjvUY4WFAJC0WCb7QX/rNJnahJDYL0i8a/v
        C10kUIsnSPN9spdfDgMbpAIAAup6bhY=
X-Google-Smtp-Source: ABdhPJx6D43kn5MV0I4+HM7Y77hYMTE0j8mAoTlwNGlkhP8mTP6+0FnyQn2hkMtruWcNfQViYps2vJMB3uo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:3103:: with SMTP id x3mr34207809ybx.8.1620148676838;
 Tue, 04 May 2021 10:17:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:25 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 06/15] KVM: SVM: Probe and load MSR_TSC_AUX regardless of
 RDTSCP support in host
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

Probe MSR_TSC_AUX whether or not RDTSCP is supported in the host, and
if probing succeeds, load the guest's MSR_TSC_AUX into hardware prior to
VMRUN.  Because SVM doesn't support interception of RDPID, RDPID cannot
be disallowed in the guest (without resorting to binary translation).
Leaving the host's MSR_TSC_AUX in hardware would leak the host's value to
the guest if RDTSCP is not supported.

Note, there is also a kernel bug that prevents leaking the host's value.
The host kernel initializes MSR_TSC_AUX if and only if RDTSCP is
supported, even though the vDSO usage consumes MSR_TSC_AUX via RDPID.
I.e. if RDTSCP is not supported, there is no host value to leak.  But,
if/when the host kernel bug is fixed, KVM would start leaking MSR_TSC_AUX
in the case where hardware supports RDPID but RDTSCP is unavailable for
whatever reason.

Probing MSR_TSC_AUX will also allow consolidating the probe and define
logic in common x86, and will make it simpler to condition the existence
of MSR_TSX_AUX (from the guest's perspective) on RDTSCP *or* RDPID.

Fixes: AMD CPUs
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f2b184270c0..b3153d40cc4d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -212,7 +212,7 @@ DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
  * RDTSCP and RDPID are not used in the kernel, specifically to allow KVM to
  * defer the restoration of TSC_AUX until the CPU returns to userspace.
  */
-#define TSC_AUX_URET_SLOT	0
+static int tsc_aux_uret_slot __read_mostly = -1;
 
 static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
@@ -959,8 +959,10 @@ static __init int svm_hardware_setup(void)
 		kvm_tsc_scaling_ratio_frac_bits = 32;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_RDTSCP))
-		kvm_define_user_return_msr(TSC_AUX_URET_SLOT, MSR_TSC_AUX);
+	if (!kvm_probe_user_return_msr(MSR_TSC_AUX)) {
+		tsc_aux_uret_slot = 0;
+		kvm_define_user_return_msr(tsc_aux_uret_slot, MSR_TSC_AUX);
+	}
 
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
@@ -1454,8 +1456,8 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (static_cpu_has(X86_FEATURE_RDTSCP))
-		kvm_set_user_return_msr(TSC_AUX_URET_SLOT, svm->tsc_aux, -1ull);
+	if (likely(tsc_aux_uret_slot >= 0))
+		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
 	svm->guest_state_loaded = true;
 }
@@ -2664,7 +2666,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
 	case MSR_TSC_AUX:
-		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
+		if (tsc_aux_uret_slot < 0)
 			return 1;
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2885,7 +2887,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
 	case MSR_TSC_AUX:
-		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
+		if (tsc_aux_uret_slot < 0)
 			return 1;
 
 		if (!msr->host_initiated &&
@@ -2908,7 +2910,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * guest via direct_access_msrs, and switch it via user return.
 		 */
 		preempt_disable();
-		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
+		r = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
 		preempt_enable();
 		if (r)
 			return 1;
-- 
2.31.1.527.g47e6f16901-goog

