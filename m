Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359666431B1
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiLETPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiLETOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:46 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB8E1F613
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:45 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id s21-20020a63ff55000000b00477f5ae7320so10578142pgk.18
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YNXp1fC48PMbkNKvZ9u3nS25vfXhcxlsNmFrH/TjEAc=;
        b=Ldjnnt5k0S3tI388TNrJ9wBbQyqCOQXkSA7IVnbDkW3POmqQmKJbe934jYDJ/SyVYb
         JWC4fnTa798I46kDTq5jRIkHqc8TY1GyLUWkjVPc6ru3x6SHihxVVnNpCZMiQVph7KkP
         ExGitr9ZkLdgc/elHflHzf97qljrV50u4eODNHRWB+iV8psB+Vost2rsE7JcL+gfU6H7
         umVkcxHAX1avFHhrKjqBj4i3u9OVbMO1N8u7NNb/qTRzo1n3N3wH1n45+jc/sa1j9jo5
         WWOjXWF8qSvHFgSbzADYZoPh5kCVvxRKlR13gjV/6Z4vuhmcjmmW0YsS1uwSD3TOV3J1
         zelQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YNXp1fC48PMbkNKvZ9u3nS25vfXhcxlsNmFrH/TjEAc=;
        b=Xa9eegOan++tdj3riwF4y80OxbIY98WIqJtQW56JtAdcR9Du+AQW/l0ziTxY5eHK5r
         kORY0/9L7nOo5QPHliD19EotTqPRbNXyC0JgKLHnHIK3ULnYY5R76Dy536MwaFABZFzZ
         bdbNs52t6zK2XnNRCDuSDPXypVeKzClkjNMj8klpGjGJZIcURROIC+/WpngBIRSc9qdA
         xZAXNbO8IOjAXMleY80OPugjOIjMzVLsYk+UbYdRKfaF7dXrP5WwDuKd6VucxELuBJ22
         hOUaGPSBbYME+tXAjhJyPCpKu0AS+rwSe7PqcBkwua9lLIzYcSDrw/eDdTYgnMx+MkMs
         /sdQ==
X-Gm-Message-State: ANoB5pkx8GASlEBozNY+LB8Gr8b8ykGPa7B7ncKBjZvb5bvxIPTMI4pJ
        LjCJGVHoMVtSW71M3kf83FV1kznP6TDh
X-Google-Smtp-Source: AA0mqf6BcchfMj7AcxSFl7eS9ovlsA6TcY4PIpXk48S58tMndTLtrovMr5gU0VJCUwvm6xjrUKe4ZZmtdsuQ
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:e8c3:b0:186:5de2:e17e with SMTP id
 v3-20020a170902e8c300b001865de2e17emr69638947plg.35.1670267684695; Mon, 05
 Dec 2022 11:14:44 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:20 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-4-vipinsh@google.com>
Subject: [Patch v3 03/13] KVM: x86: Hyper-V invariant TSC control
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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
2.39.0.rc0.267.gcb52ba06e7-goog

