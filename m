Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0AB87F57
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437135AbfHIQPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:04 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52914 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437015AbfHIQPC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:02 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 545FA305D35F;
        Fri,  9 Aug 2019 19:01:39 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 026BE305B7A0;
        Fri,  9 Aug 2019 19:01:38 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>
Subject: [RFC PATCH v6 77/92] kvm: introspection: add trace functions
Date:   Fri,  9 Aug 2019 19:00:32 +0300
Message-Id: <20190809160047.8319-78-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/kvmi.c         |  63 ++++
 include/trace/events/kvmi.h | 680 ++++++++++++++++++++++++++++++++++++
 virt/kvm/kvmi.c             |  20 ++
 virt/kvm/kvmi_mem.c         |   5 +
 virt/kvm/kvmi_msg.c         |  16 +
 5 files changed, 784 insertions(+)
 create mode 100644 include/trace/events/kvmi.h

diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 5312f179af9c..171e76449271 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -9,6 +9,8 @@
 #include <asm/vmx.h>
 #include "../../../virt/kvm/kvmi_int.h"
 
+#include <trace/events/kvmi.h>
+
 static unsigned long *msr_mask(struct kvm_vcpu *vcpu, unsigned int *msr)
 {
 	switch (*msr) {
@@ -102,6 +104,9 @@ static bool __kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	if (old_msr.data == msr->data)
 		return true;
 
+	trace_kvmi_event_msr_send(vcpu->vcpu_id, msr->index, old_msr.data,
+				  msr->data);
+
 	action = kvmi_send_msr(vcpu, msr->index, old_msr.data, msr->data,
 			       &ret_value);
 	switch (action) {
@@ -113,6 +118,8 @@ static bool __kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		kvmi_handle_common_event_actions(vcpu, action, "MSR");
 	}
 
+	trace_kvmi_event_msr_recv(vcpu->vcpu_id, action, ret_value);
+
 	return ret;
 }
 
@@ -387,6 +394,8 @@ static bool __kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 	if (!test_bit(cr, IVCPU(vcpu)->cr_mask))
 		return true;
 
+	trace_kvmi_event_cr_send(vcpu->vcpu_id, cr, old_value, *new_value);
+
 	action = kvmi_send_cr(vcpu, cr, old_value, *new_value, &ret_value);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
@@ -397,6 +406,8 @@ static bool __kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		kvmi_handle_common_event_actions(vcpu, action, "CR");
 	}
 
+	trace_kvmi_event_cr_recv(vcpu->vcpu_id, action, ret_value);
+
 	return ret;
 }
 
@@ -437,6 +448,8 @@ static void __kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
 {
 	u32 action;
 
+	trace_kvmi_event_xsetbv_send(vcpu->vcpu_id);
+
 	action = kvmi_send_xsetbv(vcpu);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
@@ -444,6 +457,8 @@ static void __kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
 	default:
 		kvmi_handle_common_event_actions(vcpu, action, "XSETBV");
 	}
+
+	trace_kvmi_event_xsetbv_recv(vcpu->vcpu_id, action);
 }
 
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
@@ -460,12 +475,26 @@ void kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
 	kvmi_put(vcpu->kvm);
 }
 
+static u64 get_next_rip(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+	if (ivcpu->have_delayed_regs)
+		return ivcpu->delayed_regs.rip;
+	else
+		return kvm_rip_read(vcpu);
+}
+
 void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 {
 	u32 action;
 	u64 gpa;
+	u64 old_rip;
 
 	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
+	old_rip = kvm_rip_read(vcpu);
+
+	trace_kvmi_event_bp_send(vcpu->vcpu_id, gpa, old_rip);
 
 	action = kvmi_msg_send_bp(vcpu, gpa, insn_len);
 	switch (action) {
@@ -478,6 +507,8 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 	default:
 		kvmi_handle_common_event_actions(vcpu, action, "BP");
 	}
+
+	trace_kvmi_event_bp_recv(vcpu->vcpu_id, action, get_next_rip(vcpu));
 }
 
 #define KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT 24
@@ -504,6 +535,8 @@ void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu)
 {
 	u32 action;
 
+	trace_kvmi_event_hc_send(vcpu->vcpu_id);
+
 	action = kvmi_msg_send_hypercall(vcpu);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
@@ -511,6 +544,8 @@ void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu)
 	default:
 		kvmi_handle_common_event_actions(vcpu, action, "HYPERCALL");
 	}
+
+	trace_kvmi_event_hc_recv(vcpu->vcpu_id, action);
 }
 
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
@@ -532,6 +567,9 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	if (ivcpu->effective_rep_complete)
 		return true;
 
+	trace_kvmi_event_pf_send(vcpu->vcpu_id, gpa, gva, access,
+				 kvm_rip_read(vcpu));
+
 	action = kvmi_msg_send_pf(vcpu, gpa, gva, access, &ivcpu->ss_requested,
 				  &ivcpu->rep_complete, &ctx_addr,
 				  ivcpu->ctx_data, &ctx_size);
@@ -553,6 +591,9 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 		kvmi_handle_common_event_actions(vcpu, action, "PF");
 	}
 
+	trace_kvmi_event_pf_recv(vcpu->vcpu_id, action, get_next_rip(vcpu),
+				 ctx_size, ivcpu->ss_requested, ret);
+
 	return ret;
 }
 
@@ -628,6 +669,11 @@ void kvmi_arch_trap_event(struct kvm_vcpu *vcpu)
 		err = 0;
 	}
 
+	trace_kvmi_event_trap_send(vcpu->vcpu_id, vector,
+				   IVCPU(vcpu)->exception.nr,
+				   err, IVCPU(vcpu)->exception.error_code,
+				   vcpu->arch.cr2);
+
 	action = kvmi_send_trap(vcpu, vector, type, err, vcpu->arch.cr2);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
@@ -635,6 +681,8 @@ void kvmi_arch_trap_event(struct kvm_vcpu *vcpu)
 	default:
 		kvmi_handle_common_event_actions(vcpu, action, "TRAP");
 	}
+
+	trace_kvmi_event_trap_recv(vcpu->vcpu_id, action);
 }
 
 static bool __kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
@@ -643,6 +691,8 @@ static bool __kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 	u32 action;
 	bool ret = false;
 
+	trace_kvmi_event_desc_send(vcpu->vcpu_id, descriptor, write);
+
 	action = kvmi_msg_send_descriptor(vcpu, descriptor, write);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
@@ -654,6 +704,8 @@ static bool __kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 		kvmi_handle_common_event_actions(vcpu, action, "DESC");
 	}
 
+	trace_kvmi_event_desc_recv(vcpu->vcpu_id, action);
+
 	return ret;
 }
 
@@ -718,6 +770,15 @@ int kvmi_arch_cmd_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
 				   bool error_code_valid,
 				   u32 error_code, u64 address)
 {
+	struct x86_exception e = {
+		.error_code_valid = error_code_valid,
+		.error_code = error_code,
+		.address = address,
+		.vector = vector,
+	};
+
+	trace_kvmi_cmd_inject_exception(vcpu, &e);
+
 	if (!(is_vector_valid(vector) && is_gva_valid(vcpu, address)))
 		return -KVM_EINVAL;
 
@@ -876,6 +937,8 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 			return;
 	}
 
+	trace_kvmi_set_gfn_access(m->gfn, m->access, m->write_bitmap, slot->id);
+
 	for (i = 0; i < ARRAY_SIZE(track_modes); i++) {
 		unsigned int allow_bit = track_modes[i].allow_bit;
 		enum kvm_page_track_mode mode = track_modes[i].track_mode;
diff --git a/include/trace/events/kvmi.h b/include/trace/events/kvmi.h
new file mode 100644
index 000000000000..442189437fe7
--- /dev/null
+++ b/include/trace/events/kvmi.h
@@ -0,0 +1,680 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvmi
+
+#if !defined(_TRACE_KVMI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVMI_H
+
+#include <linux/tracepoint.h>
+
+#ifndef __TRACE_KVMI_STRUCTURES
+#define __TRACE_KVMI_STRUCTURES
+
+#undef EN
+#define EN(x) { x, #x }
+
+static const struct trace_print_flags kvmi_msg_id_symbol[] = {
+	EN(KVMI_GET_VERSION),
+	EN(KVMI_CHECK_COMMAND),
+	EN(KVMI_CHECK_EVENT),
+	EN(KVMI_GET_GUEST_INFO),
+	EN(KVMI_GET_VCPU_INFO),
+	EN(KVMI_GET_REGISTERS),
+	EN(KVMI_SET_REGISTERS),
+	EN(KVMI_GET_PAGE_ACCESS),
+	EN(KVMI_SET_PAGE_ACCESS),
+	EN(KVMI_GET_PAGE_WRITE_BITMAP),
+	EN(KVMI_SET_PAGE_WRITE_BITMAP),
+	EN(KVMI_INJECT_EXCEPTION),
+	EN(KVMI_READ_PHYSICAL),
+	EN(KVMI_WRITE_PHYSICAL),
+	EN(KVMI_GET_MAP_TOKEN),
+	EN(KVMI_CONTROL_EVENTS),
+	EN(KVMI_CONTROL_CR),
+	EN(KVMI_CONTROL_MSR),
+	EN(KVMI_EVENT),
+	EN(KVMI_EVENT_REPLY),
+	EN(KVMI_GET_CPUID),
+	EN(KVMI_GET_XSAVE),
+	EN(KVMI_PAUSE_VCPU),
+	EN(KVMI_CONTROL_VM_EVENTS),
+	EN(KVMI_GET_MTRR_TYPE),
+	EN(KVMI_CONTROL_SPP),
+	EN(KVMI_CONTROL_CMD_RESPONSE),
+	{-1, NULL}
+};
+
+static const struct trace_print_flags kvmi_descriptor_symbol[] = {
+	EN(KVMI_DESC_IDTR),
+	EN(KVMI_DESC_GDTR),
+	EN(KVMI_DESC_LDTR),
+	EN(KVMI_DESC_TR),
+	{-1, NULL}
+};
+
+static const struct trace_print_flags kvmi_event_symbol[] = {
+	EN(KVMI_EVENT_UNHOOK),
+	EN(KVMI_EVENT_CR),
+	EN(KVMI_EVENT_MSR),
+	EN(KVMI_EVENT_XSETBV),
+	EN(KVMI_EVENT_BREAKPOINT),
+	EN(KVMI_EVENT_HYPERCALL),
+	EN(KVMI_EVENT_PF),
+	EN(KVMI_EVENT_TRAP),
+	EN(KVMI_EVENT_DESCRIPTOR),
+	EN(KVMI_EVENT_CREATE_VCPU),
+	EN(KVMI_EVENT_PAUSE_VCPU),
+	EN(KVMI_EVENT_SINGLESTEP),
+	{ -1, NULL }
+};
+
+static const struct trace_print_flags kvmi_action_symbol[] = {
+	{KVMI_EVENT_ACTION_CONTINUE, "continue"},
+	{KVMI_EVENT_ACTION_RETRY, "retry"},
+	{KVMI_EVENT_ACTION_CRASH, "crash"},
+	{-1, NULL}
+};
+
+#endif /* __TRACE_KVMI_STRUCTURES */
+
+TRACE_EVENT(
+	kvmi_vm_command,
+	TP_PROTO(__u16 id, __u32 seq),
+	TP_ARGS(id, seq),
+	TP_STRUCT__entry(
+		__field(__u16, id)
+		__field(__u32, seq)
+	),
+	TP_fast_assign(
+		__entry->id = id;
+		__entry->seq = seq;
+	),
+	TP_printk("%s seq %d",
+		  trace_print_symbols_seq(p, __entry->id, kvmi_msg_id_symbol),
+		  __entry->seq)
+);
+
+TRACE_EVENT(
+	kvmi_vm_reply,
+	TP_PROTO(__u16 id, __u32 seq, __s32 err),
+	TP_ARGS(id, seq, err),
+	TP_STRUCT__entry(
+		__field(__u16, id)
+		__field(__u32, seq)
+		__field(__s32, err)
+	),
+	TP_fast_assign(
+		__entry->id = id;
+		__entry->seq = seq;
+		__entry->err = err;
+	),
+	TP_printk("%s seq %d err %d",
+		  trace_print_symbols_seq(p, __entry->id, kvmi_msg_id_symbol),
+		  __entry->seq,
+		  __entry->err)
+);
+
+TRACE_EVENT(
+	kvmi_vcpu_command,
+	TP_PROTO(__u16 vcpu, __u16 id, __u32 seq),
+	TP_ARGS(vcpu, id, seq),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u16, id)
+		__field(__u32, seq)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->id = id;
+		__entry->seq = seq;
+	),
+	TP_printk("vcpu %d %s seq %d",
+		  __entry->vcpu,
+		  trace_print_symbols_seq(p, __entry->id, kvmi_msg_id_symbol),
+		  __entry->seq)
+);
+
+TRACE_EVENT(
+	kvmi_vcpu_reply,
+	TP_PROTO(__u16 vcpu, __u16 id, __u32 seq, __s32 err),
+	TP_ARGS(vcpu, id, seq, err),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u16, id)
+		__field(__u32, seq)
+		__field(__s32, err)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->id = id;
+		__entry->seq = seq;
+		__entry->err = err;
+	),
+	TP_printk("vcpu %d %s seq %d err %d",
+		  __entry->vcpu,
+		  trace_print_symbols_seq(p, __entry->id, kvmi_msg_id_symbol),
+		  __entry->seq,
+		  __entry->err)
+);
+
+TRACE_EVENT(
+	kvmi_event,
+	TP_PROTO(__u16 vcpu, __u32 id, __u32 seq),
+	TP_ARGS(vcpu, id, seq),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, id)
+		__field(__u32, seq)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->id = id;
+		__entry->seq = seq;
+	),
+	TP_printk("vcpu %d %s seq %d",
+		__entry->vcpu,
+		trace_print_symbols_seq(p, __entry->id, kvmi_event_symbol),
+		__entry->seq)
+);
+
+TRACE_EVENT(
+	kvmi_event_reply,
+	TP_PROTO(__u32 id, __u32 seq),
+	TP_ARGS(id, seq),
+	TP_STRUCT__entry(
+		__field(__u32, id)
+		__field(__u32, seq)
+	),
+	TP_fast_assign(
+		__entry->id = id;
+		__entry->seq = seq;
+	),
+	TP_printk("%s seq %d",
+		trace_print_symbols_seq(p, __entry->id, kvmi_event_symbol),
+		__entry->seq)
+);
+
+#define KVMI_ACCESS_PRINTK() ({						\
+	const char *saved_ptr = trace_seq_buffer_ptr(p);		\
+	static const char * const access_str[] = {			\
+		"---", "r--", "-w-", "rw-", "--x", "r-x", "-wx", "rwx"	\
+	};								\
+	trace_seq_printf(p, "%s", access_str[__entry->access & 7]);	\
+	saved_ptr;							\
+})
+
+TRACE_EVENT(
+	kvmi_set_gfn_access,
+	TP_PROTO(__u64 gfn, __u8 access, __u32 bitmap, __u16 slot),
+	TP_ARGS(gfn, access, bitmap, slot),
+	TP_STRUCT__entry(
+		__field(__u64, gfn)
+		__field(__u8, access)
+		__field(__u32, bitmap)
+		__field(__u16, slot)
+	),
+	TP_fast_assign(
+		__entry->gfn = gfn;
+		__entry->access = access;
+		__entry->bitmap = bitmap;
+		__entry->slot = slot;
+	),
+	TP_printk("gfn %llx %s write bitmap %x slot %d",
+		  __entry->gfn, KVMI_ACCESS_PRINTK(),
+		  __entry->bitmap, __entry->slot)
+);
+
+DECLARE_EVENT_CLASS(
+	kvmi_event_send_template,
+	TP_PROTO(__u16 vcpu),
+	TP_ARGS(vcpu),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+	),
+	TP_printk("vcpu %d",
+		  __entry->vcpu
+	)
+);
+DECLARE_EVENT_CLASS(
+	kvmi_event_recv_template,
+	TP_PROTO(__u16 vcpu, __u32 action),
+	TP_ARGS(vcpu, action),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, action)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->action = action;
+	),
+	TP_printk("vcpu %d %s",
+		  __entry->vcpu,
+		  trace_print_symbols_seq(p, __entry->action,
+					  kvmi_action_symbol)
+	)
+);
+
+TRACE_EVENT(
+	kvmi_event_cr_send,
+	TP_PROTO(__u16 vcpu, __u32 cr, __u64 old_value, __u64 new_value),
+	TP_ARGS(vcpu, cr, old_value, new_value),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, cr)
+		__field(__u64, old_value)
+		__field(__u64, new_value)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->cr = cr;
+		__entry->old_value = old_value;
+		__entry->new_value = new_value;
+	),
+	TP_printk("vcpu %d cr %x old_value %llx new_value %llx",
+		  __entry->vcpu,
+		  __entry->cr,
+		  __entry->old_value,
+		  __entry->new_value
+	)
+);
+TRACE_EVENT(
+	kvmi_event_cr_recv,
+	TP_PROTO(__u16 vcpu, __u32 action, __u64 new_value),
+	TP_ARGS(vcpu, action, new_value),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, action)
+		__field(__u64, new_value)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->action = action;
+		__entry->new_value = new_value;
+	),
+	TP_printk("vcpu %d %s new_value %llx",
+		  __entry->vcpu,
+		  trace_print_symbols_seq(p, __entry->action,
+					  kvmi_action_symbol),
+		  __entry->new_value
+	)
+);
+
+TRACE_EVENT(
+	kvmi_event_msr_send,
+	TP_PROTO(__u16 vcpu, __u32 msr, __u64 old_value, __u64 new_value),
+	TP_ARGS(vcpu, msr, old_value, new_value),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, msr)
+		__field(__u64, old_value)
+		__field(__u64, new_value)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->msr = msr;
+		__entry->old_value = old_value;
+		__entry->new_value = new_value;
+	),
+	TP_printk("vcpu %d msr %x old_value %llx new_value %llx",
+		  __entry->vcpu,
+		  __entry->msr,
+		  __entry->old_value,
+		  __entry->new_value
+	)
+);
+TRACE_EVENT(
+	kvmi_event_msr_recv,
+	TP_PROTO(__u16 vcpu, __u32 action, __u64 new_value),
+	TP_ARGS(vcpu, action, new_value),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, action)
+		__field(__u64, new_value)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->action = action;
+		__entry->new_value = new_value;
+	),
+	TP_printk("vcpu %d %s new_value %llx",
+		  __entry->vcpu,
+		  trace_print_symbols_seq(p, __entry->action,
+					  kvmi_action_symbol),
+		  __entry->new_value
+	)
+);
+
+DEFINE_EVENT(kvmi_event_send_template, kvmi_event_xsetbv_send,
+	TP_PROTO(__u16 vcpu),
+	TP_ARGS(vcpu)
+);
+DEFINE_EVENT(kvmi_event_recv_template, kvmi_event_xsetbv_recv,
+	TP_PROTO(__u16 vcpu, __u32 action),
+	TP_ARGS(vcpu, action)
+);
+
+TRACE_EVENT(
+	kvmi_event_bp_send,
+	TP_PROTO(__u16 vcpu, __u64 gpa, __u64 old_rip),
+	TP_ARGS(vcpu, gpa, old_rip),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u64, gpa)
+		__field(__u64, old_rip)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->gpa = gpa;
+		__entry->old_rip = old_rip;
+	),
+	TP_printk("vcpu %d gpa %llx rip %llx",
+		  __entry->vcpu,
+		  __entry->gpa,
+		  __entry->old_rip
+	)
+);
+TRACE_EVENT(
+	kvmi_event_bp_recv,
+	TP_PROTO(__u16 vcpu, __u32 action, __u64 new_rip),
+	TP_ARGS(vcpu, action, new_rip),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, action)
+		__field(__u64, new_rip)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->action = action;
+		__entry->new_rip = new_rip;
+	),
+	TP_printk("vcpu %d %s rip %llx",
+		  __entry->vcpu,
+		  trace_print_symbols_seq(p, __entry->action,
+					  kvmi_action_symbol),
+		  __entry->new_rip
+	)
+);
+
+DEFINE_EVENT(kvmi_event_send_template, kvmi_event_hc_send,
+	TP_PROTO(__u16 vcpu),
+	TP_ARGS(vcpu)
+);
+DEFINE_EVENT(kvmi_event_recv_template, kvmi_event_hc_recv,
+	TP_PROTO(__u16 vcpu, __u32 action),
+	TP_ARGS(vcpu, action)
+);
+
+TRACE_EVENT(
+	kvmi_event_pf_send,
+	TP_PROTO(__u16 vcpu, __u64 gpa, __u64 gva, __u8 access, __u64 rip),
+	TP_ARGS(vcpu, gpa, gva, access, rip),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u64, gpa)
+		__field(__u64, gva)
+		__field(__u8, access)
+		__field(__u64, rip)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->gpa = gpa;
+		__entry->gva = gva;
+		__entry->access = access;
+		__entry->rip = rip;
+	),
+	TP_printk("vcpu %d gpa %llx %s gva %llx rip %llx",
+		  __entry->vcpu,
+		  __entry->gpa,
+		  KVMI_ACCESS_PRINTK(),
+		  __entry->gva,
+		  __entry->rip
+	)
+);
+TRACE_EVENT(
+	kvmi_event_pf_recv,
+	TP_PROTO(__u16 vcpu, __u32 action, __u64 next_rip, size_t custom_data,
+		 bool singlestep, bool ret),
+	TP_ARGS(vcpu, action, next_rip, custom_data, singlestep, ret),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, action)
+		__field(__u64, next_rip)
+		__field(size_t, custom_data)
+		__field(bool, singlestep)
+		__field(bool, ret)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->action = action;
+		__entry->next_rip = next_rip;
+		__entry->custom_data = custom_data;
+		__entry->singlestep = singlestep;
+		__entry->ret = ret;
+	),
+	TP_printk("vcpu %d %s rip %llx custom %zu %s",
+		  __entry->vcpu,
+		  trace_print_symbols_seq(p, __entry->action,
+					  kvmi_action_symbol),
+		  __entry->next_rip, __entry->custom_data,
+		  (__entry->singlestep ? (__entry->ret ? "singlestep failed" :
+							 "singlestep running")
+					: "")
+	)
+);
+
+TRACE_EVENT(
+	kvmi_event_trap_send,
+	TP_PROTO(__u16 vcpu, __u32 vector, __u8 nr, __u32 err, __u16 error_code,
+		 __u64 cr2),
+	TP_ARGS(vcpu, vector, nr, err, error_code, cr2),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u32, vector)
+		__field(__u8, nr)
+		__field(__u32, err)
+		__field(__u16, error_code)
+		__field(__u64, cr2)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->vector = vector;
+		__entry->nr = nr;
+		__entry->err = err;
+		__entry->error_code = error_code;
+		__entry->cr2 = cr2;
+	),
+	TP_printk("vcpu %d vector %x/%x err %x/%x address %llx",
+		  __entry->vcpu,
+		  __entry->vector, __entry->nr,
+		  __entry->err, __entry->error_code,
+		  __entry->cr2
+	)
+);
+DEFINE_EVENT(kvmi_event_recv_template, kvmi_event_trap_recv,
+	TP_PROTO(__u16 vcpu, __u32 action),
+	TP_ARGS(vcpu, action)
+);
+
+TRACE_EVENT(
+	kvmi_event_desc_send,
+	TP_PROTO(__u16 vcpu, __u8 descriptor, __u8 write),
+	TP_ARGS(vcpu, descriptor, write),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+		__field(__u8, descriptor)
+		__field(__u8, write)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->descriptor = descriptor;
+		__entry->write = write;
+	),
+	TP_printk("vcpu %d %s %s",
+		  __entry->vcpu,
+		  __entry->write ? "write" : "read",
+		  trace_print_symbols_seq(p, __entry->descriptor,
+					  kvmi_descriptor_symbol)
+	)
+);
+DEFINE_EVENT(kvmi_event_recv_template, kvmi_event_desc_recv,
+	TP_PROTO(__u16 vcpu, __u32 action),
+	TP_ARGS(vcpu, action)
+);
+
+DEFINE_EVENT(kvmi_event_send_template, kvmi_event_create_vcpu_send,
+	TP_PROTO(__u16 vcpu),
+	TP_ARGS(vcpu)
+);
+DEFINE_EVENT(kvmi_event_recv_template, kvmi_event_create_vcpu_recv,
+	TP_PROTO(__u16 vcpu, __u32 action),
+	TP_ARGS(vcpu, action)
+);
+
+DEFINE_EVENT(kvmi_event_send_template, kvmi_event_pause_vcpu_send,
+	TP_PROTO(__u16 vcpu),
+	TP_ARGS(vcpu)
+);
+DEFINE_EVENT(kvmi_event_recv_template, kvmi_event_pause_vcpu_recv,
+	TP_PROTO(__u16 vcpu, __u32 action),
+	TP_ARGS(vcpu, action)
+);
+
+DEFINE_EVENT(kvmi_event_send_template, kvmi_event_singlestep_send,
+	TP_PROTO(__u16 vcpu),
+	TP_ARGS(vcpu)
+);
+DEFINE_EVENT(kvmi_event_recv_template, kvmi_event_singlestep_recv,
+	TP_PROTO(__u16 vcpu, __u32 action),
+	TP_ARGS(vcpu, action)
+);
+
+TRACE_EVENT(
+	kvmi_run_singlestep,
+	TP_PROTO(struct kvm_vcpu *vcpu, __u64 gpa, __u8 access, __u8 level,
+		 size_t custom_data),
+	TP_ARGS(vcpu, gpa, access, level, custom_data),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu_id)
+		__field(__u64, gpa)
+		__field(__u8, access)
+		__field(size_t, len)
+		__array(__u8, insn, 15)
+		__field(__u8, level)
+		__field(size_t, custom_data)
+	),
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->gpa = gpa;
+		__entry->access = access;
+		__entry->len = min_t(size_t, 15,
+				     vcpu->arch.emulate_ctxt.fetch.ptr
+				     - vcpu->arch.emulate_ctxt.fetch.data);
+		memcpy(__entry->insn, vcpu->arch.emulate_ctxt.fetch.data, 15);
+		__entry->level = level;
+		__entry->custom_data = custom_data;
+	),
+	TP_printk("vcpu %d gpa %llx %s insn %s level %x custom %zu",
+		  __entry->vcpu_id,
+		  __entry->gpa,
+		  KVMI_ACCESS_PRINTK(),
+		  __print_hex(__entry->insn, __entry->len),
+		  __entry->level,
+		  __entry->custom_data
+	)
+);
+
+TRACE_EVENT(
+	kvmi_stop_singlestep,
+	TP_PROTO(__u16 vcpu),
+	TP_ARGS(vcpu),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu)
+	),
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+	),
+	TP_printk("vcpu %d", __entry->vcpu
+	)
+);
+
+TRACE_EVENT(
+	kvmi_mem_map,
+	TP_PROTO(struct kvm *kvm, gpa_t req_gpa, gpa_t map_gpa),
+	TP_ARGS(kvm, req_gpa, map_gpa),
+	TP_STRUCT__entry(
+		__field_struct(uuid_t, uuid)
+		__field(gpa_t, req_gpa)
+		__field(gpa_t, map_gpa)
+	),
+	TP_fast_assign(
+		struct kvmi *ikvm = kvmi_get(kvm);
+
+		if (ikvm) {
+			memcpy(&__entry->uuid, &ikvm->uuid, sizeof(uuid_t));
+			kvmi_put(kvm);
+		} else
+			memset(&__entry->uuid, 0, sizeof(uuid_t));
+		__entry->req_gpa = req_gpa;
+		__entry->map_gpa = map_gpa;
+	),
+	TP_printk("vm %pU req_gpa %llx map_gpa %llx",
+		&__entry->uuid,
+		__entry->req_gpa,
+		__entry->map_gpa
+	)
+);
+
+TRACE_EVENT(
+	kvmi_mem_unmap,
+	TP_PROTO(gpa_t map_gpa),
+	TP_ARGS(map_gpa),
+	TP_STRUCT__entry(
+		__field(gpa_t, map_gpa)
+	),
+	TP_fast_assign(
+		__entry->map_gpa = map_gpa;
+	),
+	TP_printk("map_gpa %llx",
+		__entry->map_gpa
+	)
+);
+
+#define EXS(x) { x##_VECTOR, "#" #x }
+
+#define kvm_trace_sym_exc						\
+	EXS(DE), EXS(DB), EXS(BP), EXS(OF), EXS(BR), EXS(UD), EXS(NM),	\
+	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF),		\
+	EXS(MF), EXS(AC), EXS(MC)
+
+TRACE_EVENT(
+	kvmi_cmd_inject_exception,
+	TP_PROTO(struct kvm_vcpu *vcpu, struct x86_exception *fault),
+	TP_ARGS(vcpu, fault),
+	TP_STRUCT__entry(
+		__field(__u16, vcpu_id)
+		__field(__u8, vector)
+		__field(__u64, address)
+		__field(__u16, error_code)
+		__field(bool, error_code_valid)
+	),
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->vector = fault->vector;
+		__entry->address = fault->address;
+		__entry->error_code = fault->error_code;
+		__entry->error_code_valid = fault->error_code_valid;
+	),
+	TP_printk("vcpu %d %s address %llx error %x",
+		  __entry->vcpu_id,
+		  __print_symbolic(__entry->vector, kvm_trace_sym_exc),
+		  __entry->vector == PF_VECTOR ? __entry->address : 0,
+		  __entry->error_code_valid ? __entry->error_code : 0
+	)
+);
+
+#endif /* _TRACE_KVMI_H */
+
+#include <trace/define_trace.h>
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 157f3a401d64..ce28ca8c8d77 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -12,6 +12,9 @@
 #include <linux/bitmap.h>
 #include <linux/remote_mapping.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/kvmi.h>
+
 #define MAX_PAUSE_REQUESTS 1001
 
 static struct kmem_cache *msg_cache;
@@ -1284,6 +1287,8 @@ static void __kvmi_singlestep_event(struct kvm_vcpu *vcpu)
 {
 	u32 action;
 
+	trace_kvmi_event_singlestep_send(vcpu->vcpu_id);
+
 	action = kvmi_send_singlestep(vcpu);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
@@ -1291,6 +1296,8 @@ static void __kvmi_singlestep_event(struct kvm_vcpu *vcpu)
 	default:
 		kvmi_handle_common_event_actions(vcpu, action, "SINGLESTEP");
 	}
+
+	trace_kvmi_event_singlestep_recv(vcpu->vcpu_id, action);
 }
 
 static void kvmi_singlestep_event(struct kvm_vcpu *vcpu)
@@ -1311,6 +1318,8 @@ static bool __kvmi_create_vcpu_event(struct kvm_vcpu *vcpu)
 	u32 action;
 	bool ret = false;
 
+	trace_kvmi_event_create_vcpu_send(vcpu->vcpu_id);
+
 	action = kvmi_msg_send_create_vcpu(vcpu);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
@@ -1320,6 +1329,8 @@ static bool __kvmi_create_vcpu_event(struct kvm_vcpu *vcpu)
 		kvmi_handle_common_event_actions(vcpu, action, "CREATE");
 	}
 
+	trace_kvmi_event_create_vcpu_recv(vcpu->vcpu_id, action);
+
 	return ret;
 }
 
@@ -1345,6 +1356,8 @@ static bool __kvmi_pause_vcpu_event(struct kvm_vcpu *vcpu)
 	u32 action;
 	bool ret = false;
 
+	trace_kvmi_event_pause_vcpu_send(vcpu->vcpu_id);
+
 	action = kvmi_msg_send_pause_vcpu(vcpu);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
@@ -1354,6 +1367,8 @@ static bool __kvmi_pause_vcpu_event(struct kvm_vcpu *vcpu)
 		kvmi_handle_common_event_actions(vcpu, action, "PAUSE");
 	}
 
+	trace_kvmi_event_pause_vcpu_recv(vcpu->vcpu_id, action);
+
 	return ret;
 }
 
@@ -1857,6 +1872,8 @@ void kvmi_stop_ss(struct kvm_vcpu *vcpu)
 
 	ivcpu->ss_owner = false;
 
+	trace_kvmi_stop_singlestep(vcpu->vcpu_id);
+
 	kvmi_singlestep_event(vcpu);
 
 out:
@@ -1892,6 +1909,9 @@ static bool kvmi_run_ss(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
 	gfn_t gfn = gpa_to_gfn(gpa);
 	int err;
 
+	trace_kvmi_run_singlestep(vcpu, gpa, access, ikvm->ss_level,
+				  IVCPU(vcpu)->ctx_size);
+
 	kvmi_arch_start_single_step(vcpu);
 
 	err = write_custom_data(vcpu);
diff --git a/virt/kvm/kvmi_mem.c b/virt/kvm/kvmi_mem.c
index 6244add60062..a7a01646ea5c 100644
--- a/virt/kvm/kvmi_mem.c
+++ b/virt/kvm/kvmi_mem.c
@@ -23,6 +23,7 @@
 #include <linux/remote_mapping.h>
 
 #include <uapi/linux/kvmi.h>
+#include <trace/events/kvmi.h>
 
 #include "kvmi_int.h"
 
@@ -221,6 +222,8 @@ int kvmi_host_mem_map(struct kvm_vcpu *vcpu, gva_t tkn_gva,
 	}
 	req_mm = target_kvm->mm;
 
+	trace_kvmi_mem_map(target_kvm, req_gpa, map_gpa);
+
 	/* translate source addresses */
 	req_gfn = gpa_to_gfn(req_gpa);
 	req_hva = gfn_to_hva_safe(target_kvm, req_gfn);
@@ -274,6 +277,8 @@ int kvmi_host_mem_unmap(struct kvm_vcpu *vcpu, gpa_t map_gpa)
 
 	kvm_debug("kvmi: unmapping request for map_gpa %016llx\n", map_gpa);
 
+	trace_kvmi_mem_unmap(map_gpa);
+
 	/* convert GPA -> HVA */
 	map_gfn = gpa_to_gfn(map_gpa);
 	map_hva = gfn_to_hva_safe(vcpu->kvm, map_gfn);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index a5f87aafa237..bdb1e60906f9 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -8,6 +8,8 @@
 #include <linux/net.h>
 #include "kvmi_int.h"
 
+#include <trace/events/kvmi.h>
+
 typedef int (*vcpu_reply_fct)(struct kvm_vcpu *vcpu,
 			      const struct kvmi_msg_hdr *msg, int err,
 			      const void *rpl, size_t rpl_size);
@@ -165,6 +167,8 @@ static int kvmi_msg_vm_reply(struct kvmi *ikvm,
 			     const struct kvmi_msg_hdr *msg, int err,
 			     const void *rpl, size_t rpl_size)
 {
+	trace_kvmi_vm_reply(msg->id, msg->seq, err);
+
 	return kvmi_msg_reply(ikvm, msg, err, rpl, rpl_size);
 }
 
@@ -202,6 +206,8 @@ int kvmi_msg_vcpu_reply(struct kvm_vcpu *vcpu,
 			const struct kvmi_msg_hdr *msg, int err,
 			const void *rpl, size_t rpl_size)
 {
+	trace_kvmi_vcpu_reply(vcpu->vcpu_id, msg->id, msg->seq, err);
+
 	return kvmi_msg_reply(IKVM(vcpu->kvm), msg, err, rpl, rpl_size);
 }
 
@@ -559,6 +565,8 @@ static int handle_event_reply(struct kvm_vcpu *vcpu,
 	struct kvmi_vcpu_reply *expected = &ivcpu->reply;
 	size_t useful, received, common;
 
+	trace_kvmi_event_reply(reply->event, msg->seq);
+
 	if (unlikely(msg->seq != expected->seq))
 		goto out;
 
@@ -883,6 +891,8 @@ static struct kvmi_msg_hdr *kvmi_msg_recv(struct kvmi *ikvm, bool *unsupported)
 static int kvmi_msg_dispatch_vm_cmd(struct kvmi *ikvm,
 				    const struct kvmi_msg_hdr *msg)
 {
+	trace_kvmi_vm_command(msg->id, msg->seq);
+
 	return msg_vm[msg->id](ikvm, msg, msg + 1);
 }
 
@@ -895,6 +905,8 @@ static int kvmi_msg_dispatch_vcpu_job(struct kvmi *ikvm,
 	struct kvm_vcpu *vcpu = NULL;
 	int err;
 
+	trace_kvmi_vcpu_command(cmd->vcpu, hdr->id, hdr->seq);
+
 	if (invalid_vcpu_hdr(cmd))
 		return -KVM_EINVAL;
 
@@ -1051,6 +1063,8 @@ int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 	ivcpu->reply.size = rpl_size;
 	ivcpu->reply.error = -EINTR;
 
+	trace_kvmi_event(vcpu->vcpu_id, common.event, hdr.seq);
+
 	err = kvmi_sock_write(ikvm, vec, n, msg_size);
 	if (err)
 		goto out;
@@ -1091,6 +1105,8 @@ int kvmi_msg_send_unhook(struct kvmi *ikvm)
 
 	kvmi_setup_event_common(&common, KVMI_EVENT_UNHOOK, 0);
 
+	trace_kvmi_event(0, common.event, hdr.seq);
+
 	return kvmi_sock_write(ikvm, vec, n, msg_size);
 }
 
