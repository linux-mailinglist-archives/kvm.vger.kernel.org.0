Return-Path: <kvm+bounces-1186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1627E5563
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A21142816D5
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB7A15EB9;
	Wed,  8 Nov 2023 11:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="nA0FG8vJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED74515E9A;
	Wed,  8 Nov 2023 11:25:04 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263092129;
	Wed,  8 Nov 2023 03:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442704; x=1730978704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9NaCDvWcyp7wzwlWclmY5VS38Gp2lSjf1eIBJksVZ5k=;
  b=nA0FG8vJfSi2WACdQiag3d6n2OWgLcDgkjIzcczrIZkcIrfAbaaSbyuJ
   K9teBRcCsqnDxZjbKve2Z2vQ543MpxE0AYPO32gZ37uVKjYDrsfz1Hm8w
   XG9BVKeVGNQcr0UKUCKgZgn4UWL2k3RNFLbikgTac6NLhyu4K7SRXfNHc
   k=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="42020831"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:25:02 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id 566FB80832;
	Wed,  8 Nov 2023 11:24:59 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:35325]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.247:2525] with esmtp (Farcaster)
 id 7ff9fbc7-238e-442c-8b96-7408438601b8; Wed, 8 Nov 2023 11:24:57 +0000 (UTC)
X-Farcaster-Flow-ID: 7ff9fbc7-238e-442c-8b96-7408438601b8
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:57 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:52 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 32/33] KVM: x86: hyper-v: Implement HVCALL_TRANSLATE_VIRTUAL_ADDRESS
Date: Wed, 8 Nov 2023 11:18:05 +0000
Message-ID: <20231108111806.92604-33-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Introduce HVCALL_TRANSLATE_VIRTUAL_ADDRESS, the hypercall receives a
GVA, generally from a less privileged VTL, and returns the GPA backing
it. The GVA -> GPA conversion is done by walking the target VTL's vCPU
MMU.

NOTE: The hypercall implementation is incomplete and only shared for
completion. Additionally we'd like to move the VTL aware parts to
user-space.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c             | 98 +++++++++++++++++++++++++++++++
 arch/x86/kvm/trace.h              | 23 ++++++++
 include/asm-generic/hyperv-tlfs.h | 28 +++++++++
 3 files changed, 149 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 983bf8af5f64..1cb53cd0708f 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2540,6 +2540,7 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
 	case HVCALL_GET_VP_REGISTERS:
 	case HVCALL_SET_VP_REGISTERS:
 	case HVCALL_MODIFY_VTL_PROTECTION_MASK:
+	case HVCALL_TRANSLATE_VIRTUAL_ADDRESS:
 		return true;
 	}
 
@@ -2556,6 +2557,96 @@ static void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)
 	kvm_fpu_put();
 }
 
+static bool kvm_hv_xlate_va_validate_input(struct kvm_vcpu* vcpu,
+					   struct hv_xlate_va_input *in,
+					   u8 *vtl, u8 *flags)
+{
+	union hv_input_vtl in_vtl;
+
+	if (in->partition_id != HV_PARTITION_ID_SELF)
+		return false;
+
+	if (in->vp_index != HV_VP_INDEX_SELF &&
+	    in->vp_index != kvm_hv_get_vpindex(vcpu))
+		return false;
+
+	in_vtl.as_uint8 = in->control_flags >> 56;
+	*flags = in->control_flags & HV_XLATE_GVA_FLAGS_MASK;
+	if (*flags > (HV_XLATE_GVA_VAL_READ |
+		      HV_XLATE_GVA_VAL_WRITE |
+		      HV_XLATE_GVA_VAL_EXECUTE))
+		pr_info_ratelimited("Translate VA control flags unsupported and will be ignored: 0x%llx\n",
+				    in->control_flags);
+
+	*vtl = in_vtl.use_target_vtl ? in_vtl.target_vtl :
+					     kvm_hv_get_active_vtl(vcpu);
+	if (*vtl > kvm_hv_get_active_vtl(vcpu))
+		return false;
+
+	return true;
+}
+
+static u64 kvm_hv_xlate_va_walk(struct kvm_vcpu* vcpu, u64 gva, u8 flags)
+{
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
+	u32 access = 0;
+
+	if (flags & HV_XLATE_GVA_VAL_WRITE)
+		access |= PFERR_WRITE_MASK;
+	if (flags & HV_XLATE_GVA_VAL_EXECUTE)
+		access |= PFERR_FETCH_MASK;
+
+	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, mmu, gva, access, NULL);
+}
+
+static u64 kvm_hv_translate_virtual_address(struct kvm_vcpu* vcpu,
+					    struct kvm_hv_hcall *hc)
+{
+	struct hv_xlate_va_output output = {};
+	struct hv_xlate_va_input input;
+	struct kvm_vcpu *target_vcpu;
+	u8 flags, target_vtl;
+
+	if (hc->fast) {
+		input.partition_id = hc->ingpa;
+		input.vp_index = hc->outgpa & 0xFFFFFFFF;
+		input.control_flags = sse128_lo(hc->xmm[0]);
+		input.gva = sse128_hi(hc->xmm[0]);
+	} else {
+		if (kvm_read_guest(vcpu->kvm, hc->ingpa, &input, sizeof(input)))
+			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+	}
+
+	trace_kvm_hv_translate_virtual_address(input.partition_id,
+					       input.vp_index,
+					       input.control_flags, input.gva);
+
+	if (!kvm_hv_xlate_va_validate_input(vcpu, &input, &target_vtl, &flags))
+		return HV_STATUS_INVALID_HYPERCALL_INPUT;
+
+	target_vcpu = kvm_hv_get_vtl_vcpu(vcpu, target_vtl);
+	output.gpa = kvm_hv_xlate_va_walk(target_vcpu, input.gva << PAGE_SHIFT,
+					  flags);
+	if (output.gpa == INVALID_GPA) {
+		output.result_code = HV_XLATE_GVA_UNMAPPED;
+	} else {
+		output.gpa >>= PAGE_SHIFT;
+		output.result_code = HV_XLATE_GVA_SUCCESS;
+		output.cache_type = HV_CACHE_TYPE_X64_WB;
+	}
+
+	if (hc->fast) {
+		memcpy(&hc->xmm[1], &output, sizeof(output));
+		hc->xmm_dirty = true;
+	} else {
+		if (kvm_write_guest(vcpu->kvm, hc->outgpa, &output,
+				    sizeof(output)))
+			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+	}
+
+	return HV_STATUS_SUCCESS;
+}
+
 static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 {
 	if (!hv_vcpu->enforce_cpuid)
@@ -2766,6 +2857,13 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	case HVCALL_VTL_CALL:
 	case HVCALL_VTL_RETURN:
 		goto hypercall_userspace_exit;
+	case HVCALL_TRANSLATE_VIRTUAL_ADDRESS:
+		if (unlikely(hc.rep_cnt)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		ret = kvm_hv_translate_virtual_address(vcpu, &hc);
+		break;
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
 		break;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index ab8839c47bc7..6b908671a0cc 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1372,6 +1372,29 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
 		  __entry->vcpu_id, __entry->timer_index)
 );
 
+TRACE_EVENT(kvm_hv_translate_virtual_address,
+	TP_PROTO(u64 partition_id, u32 vp_index, u64 control_flags, u64 gva),
+	TP_ARGS(partition_id, vp_index, control_flags, gva),
+
+	TP_STRUCT__entry(
+		__field(u64, partition_id)
+		__field(u32, vp_index)
+		__field(u64, control_flags)
+		__field(u64, gva)
+	),
+
+	TP_fast_assign(
+		__entry->partition_id = partition_id;
+		__entry->vp_index = vp_index;
+		__entry->control_flags = control_flags;
+		__entry->gva = gva;
+	),
+
+	TP_printk("partition id 0x%llx, vp index 0x%x, control flags 0x%llx, gva 0x%llx",
+		  __entry->partition_id, __entry->vp_index,
+		  __entry->control_flags, __entry->gva)
+);
+
 TRACE_EVENT(kvm_apicv_inhibit_changed,
 	    TP_PROTO(int reason, bool set, unsigned long inhibits),
 	    TP_ARGS(reason, set, inhibits),
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index a8b5c8a84bbc..24f983222c96 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -163,6 +163,7 @@ union hv_reference_tsc_msr {
 #define HVCALL_CREATE_VP			0x004e
 #define HVCALL_GET_VP_REGISTERS			0x0050
 #define HVCALL_SET_VP_REGISTERS			0x0051
+#define HVCALL_TRANSLATE_VIRTUAL_ADDRESS	0x0052
 #define HVCALL_POST_MESSAGE			0x005c
 #define HVCALL_SIGNAL_EVENT			0x005d
 #define HVCALL_POST_DEBUG_DATA			0x0069
@@ -842,4 +843,31 @@ union hv_register_vsm_code_page_offsets {
 		u64 reserved:40;
 	} __packed;
 };
+
+#define HV_XLATE_GVA_SUCCESS 0
+#define HV_XLATE_GVA_UNMAPPED 1
+#define HV_XLATE_GPA_UNMAPPED 4
+#define HV_CACHE_TYPE_X64_WB 6
+
+#define HV_XLATE_GVA_VAL_READ 1
+#define HV_XLATE_GVA_VAL_WRITE 2
+#define HV_XLATE_GVA_VAL_EXECUTE 4
+#define HV_XLATE_GVA_FLAGS_MASK 0x3F
+
+struct hv_xlate_va_input {
+	u64 partition_id;
+	u32 vp_index;
+	u32 reserved;
+	u64 control_flags;
+	u64 gva;
+};
+
+struct hv_xlate_va_output {
+	u32 result_code;
+	u32 cache_type:8;
+	u32 overlay_page:1;
+	u32 reserved:23;
+	u64 gpa;
+};
+
 #endif
-- 
2.40.1


