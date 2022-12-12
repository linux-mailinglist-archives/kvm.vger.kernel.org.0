Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF9864A744
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiLLShu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbiLLSh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:29 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6E612AB0
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:28 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id b6-20020aa78706000000b00579e3853125so393011pfo.6
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c4GsplhDVVuDm96aIVasf7I+dZTTQwFLxMeir4YeUTw=;
        b=nvK+NEwrR0oFi1GiBr6s3Bf5XpoNZxTqiviEVfMmvrIG9KcO0OFUURnIGjGa9z9Mm7
         Ch8ZOvOuuQdkGy0l/JhaP0XYycnbERZ4AuPWMbUDHbLKGEKC6/JuWFQU0W+2Ckgwa0V5
         m6Pbi/nw0IeAVfDQYUDZd8CKDPUmSDNer96v6kxqCwDajtwe5AO9b0TBIXM2/F+VIK0X
         3QLvKvJJXGG1e2TBk83I+vlIgRs/AO+mujcpvkDMkxY904aTkgIb0G0HRS40yX8lSXfV
         WlNIkrLuoysH1RulHusuaPBnWRavuoWwC3HkLW6e0KIBeNgAdPHodWL4ISKKFF56M7+E
         LNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c4GsplhDVVuDm96aIVasf7I+dZTTQwFLxMeir4YeUTw=;
        b=jJc0ChH5DzkWQTPOARtsD6XMlNXE8ue0PkUOedXrIChIElLvuDlnHln06RsyDPwpHW
         ABXzdWENU37wi8XVnPJZ+LW8y7LcOulQhQThGE/U0sICdkRnrur8cM8Hn90OEHbOA4vC
         6tXTdCSedkIgNIUGO77JyOPYDp0JlZs986rkCHf3pCMnfxO1VcZIqMSkS2DyEoEZco9I
         gjEkuObGIDG7oDngZnTlJU6uJ1bAvXypy48NcborgAxZjF2G+ahdT7CJIINpA2j3dEwi
         Bwg8e617jolai650LgmGvR3hP//68Lgn2be8J50X5nK5fu68PDtVV3ThrxuWO/S88Ozl
         PMuQ==
X-Gm-Message-State: ANoB5pk/8COCzjKAa9I1GKJRzeV1UNcJc4i2BMwnE2Cv1PluS2vPsEOP
        /GJWvCsafQpPN/a1A+iCtPOv75Tq/tlK
X-Google-Smtp-Source: AA0mqf4MqEdGkaV61s2SrRlkG3ktEaC7ORhDWBZBcH2d82H3qfjl9oWfb2jNAhlKmBA4LhpDsJMTdStX4rh9
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:1141:b0:578:3528:b4d with SMTP id
 b1-20020a056a00114100b0057835280b4dmr464780pfm.80.1670870247910; Mon, 12 Dec
 2022 10:37:27 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:10 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-4-vipinsh@google.com>
Subject: [Patch v4 03/13] KVM: x86: Hyper-V invariant TSC control
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Normally, genuine Hyper-V doesn't expose architectural invariant TSC
(CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of the
PV MSR is set, invariant TSC bit starts to show up in CPUID. When the
feature is exposed to Hyper-V guests, reenlightenment becomes unneeded.

Add the feature to KVM. Keep CPUID output intact when the feature
wasn't exposed to L1 and implement the required logic for hiding
invariant TSC when the feature was exposed and invariant TSC control
MSR wasn't written to. Copy genuine Hyper-V behavior and forbid to
disable the feature once it was enabled.

For the reference, for linux guests, support for the feature was added
in commit dce7cd62754b ("x86/hyperv: Allow guests to enable InvariantTSC").

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  3 +++
 arch/x86/kvm/hyperv.c           | 19 +++++++++++++++++++
 arch/x86/kvm/hyperv.h           | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  4 +++-
 5 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 283cbb83d6ae..c6252390163b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1088,6 +1088,7 @@ struct kvm_hv {
 	u64 hv_reenlightenment_control;
 	u64 hv_tsc_emulation_control;
 	u64 hv_tsc_emulation_status;
+	u64 hv_invtsc_control;
 
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 42913695fedd..612fda6e646d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1484,6 +1484,9 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
 			    (data & TSX_CTRL_CPUID_CLEAR))
 				*ebx &= ~(F(RTM) | F(HLE));
+		} else if (function == 0x80000007) {
+			if (kvm_hv_invtsc_suppressed(vcpu))
+				*edx &= ~SF(CONSTANT_TSC);
 		}
 	} else {
 		*eax = *ebx = *ecx = *edx = 0;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2c7f2a26421e..283b6d179dbe 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -999,6 +999,7 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		r = true;
@@ -1283,6 +1284,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_ACCESS_REENLIGHTENMENT;
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
+		return hv_vcpu->cpuid_cache.features_eax &
+			HV_ACCESS_TSC_INVARIANT;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 	case HV_X64_MSR_CRASH_CTL:
 		return hv_vcpu->cpuid_cache.features_edx &
@@ -1410,6 +1414,17 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		if (!host)
 			return 1;
 		break;
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
+		/* Only bit 0 is supported */
+		if (data & ~HV_EXPOSE_INVARIANT_TSC)
+			return 1;
+
+		/* The feature can't be disabled from the guest */
+		if (!host && hv->hv_invtsc_control && !data)
+			return 1;
+
+		hv->hv_invtsc_control = data;
+		break;
 	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		return syndbg_set_msr(vcpu, msr, data, host);
@@ -1585,6 +1600,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		data = hv->hv_tsc_emulation_status;
 		break;
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
+		data = hv->hv_invtsc_control;
+		break;
 	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		return syndbg_get_msr(vcpu, msr, pdata, host);
@@ -2724,6 +2742,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
 			ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
 			ent->eax |= HV_ACCESS_REENLIGHTENMENT;
+			ent->eax |= HV_ACCESS_TSC_INVARIANT;
 
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 9f96414a31c5..f83b8db72b11 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -136,6 +136,33 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
 			     HV_SYNIC_STIMER_COUNT);
 }
 
+/*
+ * With HV_ACCESS_TSC_INVARIANT feature, invariant TSC (CPUID.80000007H:EDX[8])
+ * is only observed after HV_X64_MSR_TSC_INVARIANT_CONTROL was written to.
+ */
+static inline bool kvm_hv_invtsc_suppressed(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	/*
+	 * If Hyper-V's invariant TSC control is not exposed to the guest,
+	 * the invariant TSC CPUID flag is not suppressed, Windows guests were
+	 * observed to be able to handle it correctly. Going forward, VMMs are
+	 * encouraged to enable Hyper-V's invariant TSC control when invariant
+	 * TSC CPUID flag is set to make KVM's behavior match genuine Hyper-V.
+	 */
+	if (!hv_vcpu ||
+	    !(hv_vcpu->cpuid_cache.features_eax & HV_ACCESS_TSC_INVARIANT))
+		return false;
+
+	/*
+	 * If Hyper-V's invariant TSC control is exposed to the guest, KVM is
+	 * responsible for suppressing the invariant TSC CPUID flag if the
+	 * Hyper-V control is not enabled.
+	 */
+	return !(to_kvm_hv(vcpu->kvm)->hv_invtsc_control & HV_EXPOSE_INVARIANT_TSC);
+}
+
 void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
 
 void kvm_hv_setup_tsc_page(struct kvm *kvm,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7f850dfb4086..4b12cd54daf0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1485,7 +1485,7 @@ static const u32 emulated_msrs_all[] = {
 	HV_X64_MSR_STIMER0_CONFIG,
 	HV_X64_MSR_VP_ASSIST_PAGE,
 	HV_X64_MSR_REENLIGHTENMENT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
-	HV_X64_MSR_TSC_EMULATION_STATUS,
+	HV_X64_MSR_TSC_EMULATION_STATUS, HV_X64_MSR_TSC_INVARIANT_CONTROL,
 	HV_X64_MSR_SYNDBG_OPTIONS,
 	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
 	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
@@ -3815,6 +3815,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 		return kvm_hv_set_msr_common(vcpu, msr, data,
 					     msr_info->host_initiated);
 	case MSR_IA32_BBL_CR_CTL3:
@@ -4185,6 +4186,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 		return kvm_hv_get_msr_common(vcpu,
 					     msr_info->index, &msr_info->data,
 					     msr_info->host_initiated);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

