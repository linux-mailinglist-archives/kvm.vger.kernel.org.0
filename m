Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE195FD77B
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 11:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJMJ7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 05:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJMJ7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 05:59:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB6953031
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 02:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665655145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=om/xlkv4jY5k1v3Vt+/YOq5x2JrthAam0GE9GcTBAYA=;
        b=K462ul8ay7DsbrzUbK0kMj0/HcAUEYXSZj/dZbUoLjtMhh1hp9HT8lYxpqRXxLMTokcrE1
        ZIQehbk6bM8KeM4jH/dXKc8ETufU8Q3fnZbqSUS9D9nEQeK6gOSQVfgbIz/WZ237AQ2ax2
        zf7zEzA9CAuxwWnMwXvhlTzZuVF6g44=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-bOWECJZGNWaVRSvfMXsKTg-1; Thu, 13 Oct 2022 05:59:01 -0400
X-MC-Unique: bOWECJZGNWaVRSvfMXsKTg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E51A7381458A;
        Thu, 13 Oct 2022 09:59:00 +0000 (UTC)
Received: from ovpn-194-196.brq.redhat.com (ovpn-194-196.brq.redhat.com [10.40.194.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7180D4A9254;
        Thu, 13 Oct 2022 09:58:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/7] KVM: x86: Hyper-V invariant TSC control
Date:   Thu, 13 Oct 2022 11:58:45 +0200
Message-Id: <20221013095849.705943-4-vkuznets@redhat.com>
In-Reply-To: <20221013095849.705943-1-vkuznets@redhat.com>
References: <20221013095849.705943-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  3 +++
 arch/x86/kvm/hyperv.c           | 19 +++++++++++++++++++
 arch/x86/kvm/hyperv.h           | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  4 +++-
 5 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7551b6f9c31c..6eb74c5ba3ae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1029,6 +1029,7 @@ struct kvm_hv {
 	u64 hv_reenlightenment_control;
 	u64 hv_tsc_emulation_control;
 	u64 hv_tsc_emulation_status;
+	u64 hv_invtsc_control;
 
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9f0be73002cd..dd4673217ae4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1466,6 +1466,9 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
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
index 0adf4a437e85..058b42bdebc4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -989,6 +989,7 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		r = true;
@@ -1273,6 +1274,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_ACCESS_REENLIGHTENMENT;
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
+		return hv_vcpu->cpuid_cache.features_eax &
+			HV_ACCESS_TSC_INVARIANT;
 	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
 	case HV_X64_MSR_CRASH_CTL:
 		return hv_vcpu->cpuid_cache.features_edx &
@@ -1400,6 +1404,17 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
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
@@ -1575,6 +1590,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		data = hv->hv_tsc_emulation_status;
 		break;
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
+		data = hv->hv_invtsc_control;
+		break;
 	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		return syndbg_get_msr(vcpu, msr, pdata, host);
@@ -2491,6 +2509,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
 			ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
 			ent->eax |= HV_ACCESS_REENLIGHTENMENT;
+			ent->eax |= HV_ACCESS_TSC_INVARIANT;
 
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 1030b1b50552..dd4a7a411e9e 100644
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
index 4bd5f8a751de..8496db561c13 100644
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
@@ -3808,6 +3808,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 		return kvm_hv_set_msr_common(vcpu, msr, data,
 					     msr_info->host_initiated);
 	case MSR_IA32_BBL_CR_CTL3:
@@ -4178,6 +4179,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_CONTROL:
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 		return kvm_hv_get_msr_common(vcpu,
 					     msr_info->index, &msr_info->data,
 					     msr_info->host_initiated);
-- 
2.37.3

