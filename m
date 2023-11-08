Return-Path: <kvm+bounces-1156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 984DF7E54E3
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6A29B21049
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7AA171C6;
	Wed,  8 Nov 2023 11:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="H13rTqvg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A1171A0;
	Wed,  8 Nov 2023 11:19:09 +0000 (UTC)
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAB41729;
	Wed,  8 Nov 2023 03:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442349; x=1730978349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yuGMTR3q9ZG4fjpyArVTAZq+f+G14drPZZ43vxh56XA=;
  b=H13rTqvgCM+7YyMNXgDOxbs3kVLjOhs1p0gn6psav2wPbvMurt4ONC7a
   9JBZiA6VsFjY47es/uCk7SuO/5d+3CQCPgGlFszUvbcsbj6VkgFMEBUxB
   J7GhMMBld7elvG/ql3A5P47afHnD/sqb0oaWnnVmRPyfZvpahETo7rJri
   8=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="164958711"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:19:02 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id 6B97681C1A;
	Wed,  8 Nov 2023 11:19:00 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:26732]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.247:2525] with esmtp (Farcaster)
 id 051368ee-dbbf-415b-be33-7d8aaa805a15; Wed, 8 Nov 2023 11:18:59 +0000 (UTC)
X-Farcaster-Flow-ID: 051368ee-dbbf-415b-be33-7d8aaa805a15
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:59 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:54 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 03/33] KVM: x86: hyper-v: Introduce XMM output support
Date: Wed, 8 Nov 2023 11:17:36 +0000
Message-ID: <20231108111806.92604-4-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Prepare infrastructure to be able to return data through the XMM
registers when Hyper-V hypercalls are issues in fast mode. The XMM
registers are exposed to user-space through KVM_EXIT_HYPERV_HCALL and
restored on successful hypercall completion.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/include/asm/hyperv-tlfs.h |  2 +-
 arch/x86/kvm/hyperv.c              | 33 +++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h           |  6 ++++++
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 2ff26f53cd62..af594aa65307 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -49,7 +49,7 @@
 /* Support for physical CPU dynamic partitioning events is available*/
 #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	BIT(3)
 /*
- * Support for passing hypercall input parameter block via XMM
+ * Support for passing hypercall input and output parameter block via XMM
  * registers is available
  */
 #define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		BIT(4)
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 238afd7335e4..e1bc861ab3b0 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1815,6 +1815,7 @@ struct kvm_hv_hcall {
 	u16 rep_idx;
 	bool fast;
 	bool rep;
+	bool xmm_dirty;
 	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
 
 	/*
@@ -2346,9 +2347,33 @@ static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
 	return ret;
 }
 
+static void kvm_hv_write_xmm(struct kvm_hyperv_xmm_reg *xmm)
+{
+	int reg;
+
+	kvm_fpu_get();
+	for (reg = 0; reg < HV_HYPERCALL_MAX_XMM_REGISTERS; reg++) {
+		const sse128_t data = sse128(xmm[reg].low, xmm[reg].high);
+		_kvm_write_sse_reg(reg, &data);
+	}
+	kvm_fpu_put();
+}
+
+static bool kvm_hv_is_xmm_output_hcall(u16 code)
+{
+	return false;
+}
+
 static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 {
-	return kvm_hv_hypercall_complete(vcpu, vcpu->run->hyperv.u.hcall.result);
+	bool fast = !!(vcpu->run->hyperv.u.hcall.input & HV_HYPERCALL_FAST_BIT);
+	u16 code = vcpu->run->hyperv.u.hcall.input & 0xffff;
+	u64 result = vcpu->run->hyperv.u.hcall.result;
+
+	if (kvm_hv_is_xmm_output_hcall(code) && hv_result_success(result) && fast)
+		kvm_hv_write_xmm(vcpu->run->hyperv.u.hcall.xmm);
+
+	return kvm_hv_hypercall_complete(vcpu, result);
 }
 
 static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
@@ -2623,6 +2648,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		break;
 	}
 
+	if ((ret & HV_HYPERCALL_RESULT_MASK) == HV_STATUS_SUCCESS && hc.xmm_dirty)
+		kvm_hv_write_xmm((struct kvm_hyperv_xmm_reg*)hc.xmm);
+
 hypercall_complete:
 	return kvm_hv_hypercall_complete(vcpu, ret);
 
@@ -2632,6 +2660,8 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	vcpu->run->hyperv.u.hcall.input = hc.param;
 	vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
 	vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
+	if (hc.fast)
+		memcpy(vcpu->run->hyperv.u.hcall.xmm, hc.xmm, sizeof(hc.xmm));
 	vcpu->arch.complete_userspace_io = kvm_hv_hypercall_complete_userspace;
 	return 0;
 }
@@ -2780,6 +2810,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
 
 			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
+			ent->edx |= HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE;
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d7a01766bf21..5ce06a1eee2b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -192,6 +192,11 @@ struct kvm_s390_cmma_log {
 	__u64 values;
 };
 
+struct kvm_hyperv_xmm_reg {
+	__u64 low;
+	__u64 high;
+};
+
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
@@ -210,6 +215,7 @@ struct kvm_hyperv_exit {
 			__u64 input;
 			__u64 result;
 			__u64 params[2];
+			struct kvm_hyperv_xmm_reg xmm[6];
 		} hcall;
 		struct {
 			__u32 msr;
-- 
2.40.1


