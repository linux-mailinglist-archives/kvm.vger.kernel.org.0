Return-Path: <kvm+bounces-1184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D55B7E555C
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B12301C20D24
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BFB182CA;
	Wed,  8 Nov 2023 11:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="fxtmLd6L"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A24182A3;
	Wed,  8 Nov 2023 11:24:52 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66241FF3;
	Wed,  8 Nov 2023 03:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442693; x=1730978693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5PF4/rNtaEl02NErsVfK5XTs+FbISN0CKbNnl5QOpHE=;
  b=fxtmLd6LCgEgxifWlx4X+luOWu83oDDvV+HeLZN+iSlz/iVZizDQHiC3
   TDLOyCfLK1yyvDhGqktCP8G3daYWMXMlJgLiO2FByVu21L8uLcF+N9qwn
   8sS1HpyoArvRIl35XeT5zU79HC0eP1NYcSdv7oJTMOI6k2rEWtc2lW+uZ
   4=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="366813194"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:24:50 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id 111B540E63;
	Wed,  8 Nov 2023 11:24:49 +0000 (UTC)
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:18294]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.187:2525] with esmtp (Farcaster)
 id 804134a2-3f2d-4fb3-a228-3f0ad905b402; Wed, 8 Nov 2023 11:24:47 +0000 (UTC)
X-Farcaster-Flow-ID: 804134a2-3f2d-4fb3-a228-3f0ad905b402
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:47 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:42 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 30/33] KVM: x86: hyper-v: Introduce KVM_REQ_HV_INJECT_INTERCEPT request
Date: Wed, 8 Nov 2023 11:18:03 +0000
Message-ID: <20231108111806.92604-31-nsaenz@amazon.com>
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

Introduce a new request type, KVM_REQ_HV_INJECT_INTERCEPT which allows
injecting out-of-band Hyper-V secure intercepts. For now only memory
access intercepts are supported. These are triggered when access a GPA
protected by a higher VTL. The memory intercept metadata is filled based
on the GPA provided through struct kvm_vcpu_hv_intercept_info, and
injected into the guest through SynIC message.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  10 +++
 arch/x86/kvm/hyperv.c           | 114 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h           |   2 +
 arch/x86/kvm/x86.c              |   3 +
 4 files changed, 129 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a854776d91e..39671e075555 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -113,6 +113,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HV_INJECT_INTERCEPT	KVM_ARCH_REQ(33)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -639,6 +640,13 @@ struct kvm_vcpu_hv_tlb_flush_fifo {
 	DECLARE_KFIFO(entries, u64, KVM_HV_TLB_FLUSH_FIFO_SIZE);
 };
 
+struct kvm_vcpu_hv_intercept_info {
+	struct kvm_vcpu *vcpu;
+	int type;
+	u64 gpa;
+	u8 access;
+};
+
 /* Hyper-V per vcpu emulation context */
 struct kvm_vcpu_hv {
 	struct kvm_vcpu *vcpu;
@@ -673,6 +681,8 @@ struct kvm_vcpu_hv {
 		u64 vm_id;
 		u32 vp_id;
 	} nested;
+
+	struct kvm_vcpu_hv_intercept_info intercept_info;
 };
 
 struct kvm_hypervisor_cpuid {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index eb6a4848e306..38ee3abdef9c 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2789,6 +2789,120 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void store_kvm_segment(const struct kvm_segment *kvmseg,
+			      struct hv_x64_segment_register *reg)
+{
+	reg->base = kvmseg->base;
+	reg->limit = kvmseg->limit;
+	reg->selector = kvmseg->selector;
+	reg->segment_type = kvmseg->type;
+	reg->present = kvmseg->present;
+	reg->descriptor_privilege_level = kvmseg->dpl;
+	reg->_default = kvmseg->db;
+	reg->non_system_segment = kvmseg->s;
+	reg->_long = kvmseg->l;
+	reg->granularity = kvmseg->g;
+	reg->available = kvmseg->avl;
+}
+
+static void deliver_gpa_intercept(struct kvm_vcpu *target_vcpu,
+				  struct kvm_vcpu *intercepted_vcpu, u64 gpa,
+				  u64 gva, u8 access_type_mask)
+{
+	ulong cr0;
+	struct hv_message msg = { 0 };
+	struct hv_memory_intercept_message *intercept = (struct hv_memory_intercept_message *)msg.u.payload;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(target_vcpu);
+	struct x86_exception e;
+	struct kvm_segment kvmseg;
+
+	msg.header.message_type = HVMSG_GPA_INTERCEPT;
+	msg.header.payload_size = sizeof(*intercept);
+
+	intercept->header.vp_index = to_hv_vcpu(intercepted_vcpu)->vp_index;
+	intercept->header.instruction_length = intercepted_vcpu->arch.exit_instruction_len;
+	intercept->header.access_type_mask = access_type_mask;
+	kvm_x86_ops.get_segment(intercepted_vcpu, &kvmseg, VCPU_SREG_CS);
+	store_kvm_segment(&kvmseg, &intercept->header.cs);
+
+	cr0 = kvm_read_cr0(intercepted_vcpu);
+	intercept->header.exec_state.cr0_pe = (cr0 & X86_CR0_PE);
+	intercept->header.exec_state.cr0_am = (cr0 & X86_CR0_AM);
+	intercept->header.exec_state.cpl = kvm_x86_ops.get_cpl(intercepted_vcpu);
+	intercept->header.exec_state.efer_lma = is_long_mode(intercepted_vcpu);
+	intercept->header.exec_state.debug_active = 0;
+	intercept->header.exec_state.interruption_pending = 0;
+	intercept->header.rip = kvm_rip_read(intercepted_vcpu);
+	intercept->header.rflags = kvm_get_rflags(intercepted_vcpu);
+
+	/*
+	 * For exec violations we don't have a way to decode an instruction that issued a fetch
+	 * to a non-X page because CPU points RIP and GPA to the fetch destination in the faulted page.
+	 * Instruction length though is the length of the fetch source.
+	 * Seems like Hyper-V is aware of that and is not trying to access those fields.
+	 */
+	if (access_type_mask == HV_INTERCEPT_ACCESS_EXECUTE) {
+		intercept->instruction_byte_count = 0;
+	} else {
+		intercept->instruction_byte_count = intercepted_vcpu->arch.exit_instruction_len;
+		if (intercept->instruction_byte_count > sizeof(intercept->instruction_bytes))
+			intercept->instruction_byte_count = sizeof(intercept->instruction_bytes);
+		if (kvm_read_guest_virt(intercepted_vcpu,
+					kvm_rip_read(intercepted_vcpu),
+					intercept->instruction_bytes,
+					intercept->instruction_byte_count, &e))
+			goto inject_ud;
+	}
+
+	intercept->memory_access_info.gva_valid = (gva != 0);
+	intercept->gva = gva;
+	intercept->gpa = gpa;
+	intercept->cache_type = HV_X64_CACHE_TYPE_WRITEBACK;
+	kvm_x86_ops.get_segment(intercepted_vcpu, &kvmseg, VCPU_SREG_DS);
+	store_kvm_segment(&kvmseg, &intercept->ds);
+	kvm_x86_ops.get_segment(intercepted_vcpu, &kvmseg, VCPU_SREG_SS);
+	store_kvm_segment(&kvmseg, &intercept->ss);
+	intercept->rax = kvm_rax_read(intercepted_vcpu);
+	intercept->rcx = kvm_rcx_read(intercepted_vcpu);
+	intercept->rdx = kvm_rdx_read(intercepted_vcpu);
+	intercept->rbx = kvm_rbx_read(intercepted_vcpu);
+	intercept->rsp = kvm_rsp_read(intercepted_vcpu);
+	intercept->rbp = kvm_rbp_read(intercepted_vcpu);
+	intercept->rsi = kvm_rsi_read(intercepted_vcpu);
+	intercept->rdi = kvm_rdi_read(intercepted_vcpu);
+	intercept->r8 = kvm_r8_read(intercepted_vcpu);
+	intercept->r9 = kvm_r9_read(intercepted_vcpu);
+	intercept->r10 = kvm_r10_read(intercepted_vcpu);
+	intercept->r11 = kvm_r11_read(intercepted_vcpu);
+	intercept->r12 = kvm_r12_read(intercepted_vcpu);
+	intercept->r13 = kvm_r13_read(intercepted_vcpu);
+	intercept->r14 = kvm_r14_read(intercepted_vcpu);
+	intercept->r15 = kvm_r15_read(intercepted_vcpu);
+
+	if (synic_deliver_msg(&hv_vcpu->synic, 0, &msg, true))
+		goto inject_ud;
+
+	return;
+
+inject_ud:
+	kvm_queue_exception(target_vcpu, UD_VECTOR);
+}
+
+void kvm_hv_deliver_intercept(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_intercept_info *info = &to_hv_vcpu(vcpu)->intercept_info;
+
+	switch (info->type) {
+	case HVMSG_GPA_INTERCEPT:
+		deliver_gpa_intercept(vcpu, info->vcpu, info->gpa, 0,
+				      info->access);
+		break;
+	default:
+		pr_warn("Unknown exception\n");
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_hv_deliver_intercept);
+
 void kvm_hv_init_vm(struct kvm *kvm)
 {
 	struct kvm_hv *hv = to_kvm_hv(kvm);
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index ae781b4d4669..8efc4916e0cb 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -273,4 +273,6 @@ int kvm_hv_vtl_dev_register(void);
 void kvm_hv_vtl_dev_unregister(void);
 int kvm_hv_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
+void kvm_hv_deliver_intercept(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82d3b86d9c93..f2581eec39a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10707,6 +10707,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_HV_INJECT_INTERCEPT, vcpu))
+			kvm_hv_deliver_intercept(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
-- 
2.40.1


