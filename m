Return-Path: <kvm+bounces-1159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 566197E54F3
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D0A5B210C7
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8600215EAA;
	Wed,  8 Nov 2023 11:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="M4wgJ4HB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FFE15E89;
	Wed,  8 Nov 2023 11:19:46 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CD11FCC;
	Wed,  8 Nov 2023 03:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442385; x=1730978385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wig6s7B83KYNLTquljMX0q4Ptac31Xr4L9axIrcRcNM=;
  b=M4wgJ4HB1LfCwKdtqmsclWizgthienECE/g9Em3VyZhPBSLDHlnUTXEH
   hk31EPxUkZA9JSu4lpki0afzSqaXpiVA03u0zmsxVj4TG2XTcKoky/wP9
   FFJ2SW5xAi6oB9Lhwu2MDYkkJWye8QUQHOyU0bP7vbKNipDI8Q0sV2TBs
   U=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="366812182"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:19:43 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id CBF6E40DAE;
	Wed,  8 Nov 2023 11:19:41 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:55579]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.187:2525] with esmtp (Farcaster)
 id a8c00b42-a893-40dc-869b-f1f46fa9119f; Wed, 8 Nov 2023 11:19:40 +0000 (UTC)
X-Farcaster-Flow-ID: a8c00b42-a893-40dc-869b-f1f46fa9119f
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:37 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:33 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 06/33] KVM: x86: hyper-v: Introduce VTL awareness to Hyper-V's PV-IPIs
Date: Wed, 8 Nov 2023 11:17:39 +0000
Message-ID: <20231108111806.92604-7-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D033UWC002.ant.amazon.com (10.13.139.196) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

HVCALL_SEND_IPI and HVCALL_SEND_IPI_EX allow targeting specific a
specific VTL. Honour the requests.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c             | 24 +++++++++++++++++-------
 arch/x86/kvm/trace.h              | 20 ++++++++++++--------
 include/asm-generic/hyperv-tlfs.h |  6 ++++--
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index d4b1b53ea63d..2cf430f6ddd8 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2230,7 +2230,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 }
 
 static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
-				    u64 *sparse_banks, u64 valid_bank_mask)
+				    u64 *sparse_banks, u64 valid_bank_mask, int vtl)
 {
 	struct kvm_lapic_irq irq = {
 		.delivery_mode = APIC_DM_FIXED,
@@ -2245,6 +2245,9 @@ static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
 					    valid_bank_mask, sparse_banks))
 			continue;
 
+		if (kvm_hv_get_active_vtl(vcpu) != vtl)
+			continue;
+
 		/* We fail only when APIC is disabled */
 		kvm_apic_set_irq(vcpu, &irq, NULL);
 	}
@@ -2257,13 +2260,19 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
+	union hv_input_vtl *in_vtl;
 	u64 valid_bank_mask;
 	u32 vector;
 	bool all_cpus;
+	u8 vtl;
+
+	/* VTL is at the same offset on both IPI types */
+	in_vtl = &send_ipi.in_vtl;
+	vtl = in_vtl->use_target_vtl ? in_vtl->target_vtl : kvm_hv_get_active_vtl(vcpu);
 
 	if (hc->code == HVCALL_SEND_IPI) {
 		if (!hc->fast) {
-			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
+			if (unlikely(kvm_vcpu_read_guest(vcpu, hc->ingpa, &send_ipi,
 						    sizeof(send_ipi))))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
 			sparse_banks[0] = send_ipi.cpu_mask;
@@ -2278,10 +2287,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		all_cpus = false;
 		valid_bank_mask = BIT_ULL(0);
 
-		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
+		trace_kvm_hv_send_ipi(vector, sparse_banks[0], vtl);
 	} else {
 		if (!hc->fast) {
-			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
+			if (unlikely(kvm_vcpu_read_guest(vcpu, hc->ingpa, &send_ipi_ex,
 						    sizeof(send_ipi_ex))))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
 		} else {
@@ -2292,7 +2301,8 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 
 		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
 					 send_ipi_ex.vp_set.format,
-					 send_ipi_ex.vp_set.valid_bank_mask);
+					 send_ipi_ex.vp_set.valid_bank_mask,
+					 vtl);
 
 		vector = send_ipi_ex.vector;
 		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
@@ -2322,9 +2332,9 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
 	if (all_cpus)
-		kvm_hv_send_ipi_to_many(kvm, vector, NULL, 0);
+		kvm_hv_send_ipi_to_many(kvm, vector, NULL, 0, vtl);
 	else
-		kvm_hv_send_ipi_to_many(kvm, vector, sparse_banks, valid_bank_mask);
+		kvm_hv_send_ipi_to_many(kvm, vector, sparse_banks, valid_bank_mask, vtl);
 
 ret_success:
 	return HV_STATUS_SUCCESS;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813e..ab8839c47bc7 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1606,42 +1606,46 @@ TRACE_EVENT(kvm_hv_flush_tlb_ex,
  * Tracepoints for kvm_hv_send_ipi.
  */
 TRACE_EVENT(kvm_hv_send_ipi,
-	TP_PROTO(u32 vector, u64 processor_mask),
-	TP_ARGS(vector, processor_mask),
+	TP_PROTO(u32 vector, u64 processor_mask, u8 vtl),
+	TP_ARGS(vector, processor_mask, vtl),
 
 	TP_STRUCT__entry(
 		__field(u32, vector)
 		__field(u64, processor_mask)
+		__field(u8, vtl)
 	),
 
 	TP_fast_assign(
 		__entry->vector = vector;
 		__entry->processor_mask = processor_mask;
+		__entry->vtl = vtl;
 	),
 
-	TP_printk("vector %x processor_mask 0x%llx",
-		  __entry->vector, __entry->processor_mask)
+	TP_printk("vector %x processor_mask 0x%llx vtl %d",
+		  __entry->vector, __entry->processor_mask, __entry->vtl)
 );
 
 TRACE_EVENT(kvm_hv_send_ipi_ex,
-	TP_PROTO(u32 vector, u64 format, u64 valid_bank_mask),
-	TP_ARGS(vector, format, valid_bank_mask),
+	TP_PROTO(u32 vector, u64 format, u64 valid_bank_mask, u8 vtl),
+	TP_ARGS(vector, format, valid_bank_mask, vtl),
 
 	TP_STRUCT__entry(
 		__field(u32, vector)
 		__field(u64, format)
 		__field(u64, valid_bank_mask)
+		__field(u8, vtl)
 	),
 
 	TP_fast_assign(
 		__entry->vector = vector;
 		__entry->format = format;
 		__entry->valid_bank_mask = valid_bank_mask;
+		__entry->vtl = vtl;
 	),
 
-	TP_printk("vector %x format %llx valid_bank_mask 0x%llx",
+	TP_printk("vector %x format %llx valid_bank_mask 0x%llx vtl %d",
 		  __entry->vector, __entry->format,
-		  __entry->valid_bank_mask)
+		  __entry->valid_bank_mask, __entry->vtl)
 );
 
 TRACE_EVENT(kvm_pv_tlb_flush,
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 0e7643c1ef01..40d7dc793c03 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -424,14 +424,16 @@ struct hv_vpset {
 /* HvCallSendSyntheticClusterIpi hypercall */
 struct hv_send_ipi {
 	u32 vector;
-	u32 reserved;
+	union hv_input_vtl in_vtl;
+	u8 reserved[3];
 	u64 cpu_mask;
 } __packed;
 
 /* HvCallSendSyntheticClusterIpiEx hypercall */
 struct hv_send_ipi_ex {
 	u32 vector;
-	u32 reserved;
+	union hv_input_vtl in_vtl;
+	u8 reserved[3];
 	struct hv_vpset vp_set;
 } __packed;
 
-- 
2.40.1


