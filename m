Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948BA87F98
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437230AbfHIQUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:09 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53340 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437174AbfHIQUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4B0F5305D3F5;
        Fri,  9 Aug 2019 19:01:04 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E40B6305B7A9;
        Fri,  9 Aug 2019 19:01:03 +0300 (EEST)
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
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 31/92] kvm: introspection: add KVMI_EVENT_PF
Date:   Fri,  9 Aug 2019 18:59:46 +0300
Message-Id: <20190809160047.8319-32-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when a #PF occurs due to a failed permission check
in the shadow page tables, for a page in which the introspection tool
has shown interest.

The introspection tool can respond to a KVMI_EVENT_PF event with custom
input for the current instruction. This input is used to trick the guest
software into believing it has read certain data, in order to hide the
content of certain memory areas (eg. hide injected code from integrity
checkers).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst |  63 ++++++++++++++++++
 arch/x86/kvm/kvmi.c                |  38 ++++++++++-
 arch/x86/kvm/x86.c                 |   7 +-
 include/linux/kvmi.h               |   4 ++
 include/uapi/linux/kvmi.h          |  18 +++++
 virt/kvm/kvmi.c                    | 103 +++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h                |  13 ++++
 virt/kvm/kvmi_msg.c                |  55 +++++++++++++++
 8 files changed, 298 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 957641802cac..0fc51b57b1e8 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -618,3 +618,66 @@ The introspection tool has a chance to unhook and close the KVMI channel
 This event is sent when a new vCPU is created and the introspection has
 been enabled for this event (see *KVMI_CONTROL_VM_EVENTS*).
 
+3. KVMI_EVENT_PF
+----------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH, RETRY
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_pf {
+		__u64 gva;
+		__u64 gpa;
+		__u8 access;
+		__u8 padding1;
+		__u16 view;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+	struct kvmi_event_pf_reply {
+		__u64 ctx_addr;
+		__u32 ctx_size;
+		__u8 singlestep;
+		__u8 rep_complete;
+		__u16 padding;
+		__u8 ctx_data[256];
+	};
+
+This event is sent when a hypervisor page fault occurs due to a failed
+permission check in the shadow page tables, the introspection has
+been enabled for this event (see *KVMI_CONTROL_EVENTS*) and the event was
+generated for a page in which the introspector has shown interest
+(ie. has previously touched it by adjusting the spte permissions).
+
+The shadow page tables can be used by the introspection tool to guarantee
+the purpose of code areas inside the guest (code, rodata, stack, heap
+etc.) Each attempt at an operation unfitting for a certain memory
+range (eg. execute code in heap) triggers a page fault and gives the
+introspection tool the chance to audit the code attempting the operation.
+
+``kvmi_event``, guest virtual address (or 0xffffffff/UNMAPPED_GVA),
+guest physical address, access flags (eg. KVMI_PAGE_ACCESS_R) and the
+EPT view are sent to the introspector.
+
+The *CONTINUE* action will continue the page fault handling via emulation
+(with custom input if ``ctx_size`` > 0). The use of custom input is
+to trick the guest software into believing it has read certain data,
+in order to hide the content of certain memory areas (eg. hide injected
+code from integrity checkers). If ``rep_complete`` is not zero, the REP
+prefixed instruction should be emulated just once (or at least no other
+*KVMI_EVENT_PF* event should be sent for the current instruction).
+
+The *RETRY* action is used by the introspector to retry the execution of
+the current instruction. Either using single-step (if ``singlestep`` is
+not zero) or return to guest (if the introspector changed the instruction
+pointer or the page restrictions).
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index d7b9201582b4..121819f9c487 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -94,7 +94,43 @@ void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev)
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access)
 {
-	return KVMI_EVENT_ACTION_CONTINUE; /* TODO */
+	struct kvmi_vcpu *ivcpu;
+	u32 ctx_size;
+	u64 ctx_addr;
+	u32 action;
+	bool singlestep_ignored;
+	bool ret = false;
+
+	if (!kvm_spt_fault(vcpu))
+		/* We are only interested in EPT/NPT violations */
+		return true;
+
+	ivcpu = IVCPU(vcpu);
+	ctx_size = sizeof(ivcpu->ctx_data);
+
+	if (ivcpu->effective_rep_complete)
+		return true;
+
+	action = kvmi_msg_send_pf(vcpu, gpa, gva, access, &singlestep_ignored,
+				  &ivcpu->rep_complete, &ctx_addr,
+				  ivcpu->ctx_data, &ctx_size);
+
+	ivcpu->ctx_size = 0;
+	ivcpu->ctx_addr = 0;
+
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ivcpu->ctx_size = ctx_size;
+		ivcpu->ctx_addr = ctx_addr;
+		ret = true;
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "PF");
+	}
+
+	return ret;
 }
 
 int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 257c4a262acd..ef6d9dd80086 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6418,6 +6418,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.l1tf_flush_l1d = true;
 
+	kvmi_init_emulate(vcpu);
+
 	/*
 	 * Clear write_fault_to_shadow_pgtable here to ensure it is
 	 * never reused.
@@ -6523,9 +6525,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			writeback = false;
 		r = EMULATE_USER_EXIT;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
-	} else if (r == EMULATION_RESTART)
+	} else if (r == EMULATION_RESTART) {
+		kvmi_activate_rep_complete(vcpu);
 		goto restart;
-	else
+	} else
 		r = EMULATE_DONE;
 
 	if (writeback) {
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index ae5de1905b55..80c15b9195e4 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -17,6 +17,8 @@ int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset);
 int kvmi_vcpu_init(struct kvm_vcpu *vcpu);
 void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
+void kvmi_init_emulate(struct kvm_vcpu *vcpu);
+void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -27,6 +29,8 @@ static inline void kvmi_destroy_vm(struct kvm *kvm) { }
 static inline int kvmi_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
+static inline void kvmi_init_emulate(struct kvm_vcpu *vcpu) { }
+static inline void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 934c0610140a..40a5c304c26f 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -155,4 +155,22 @@ struct kvmi_event_reply {
 	__u32 padding2;
 };
 
+struct kvmi_event_pf {
+	__u64 gva;
+	__u64 gpa;
+	__u8 access;
+	__u8 padding1;
+	__u16 view;
+	__u32 padding2;
+};
+
+struct kvmi_event_pf_reply {
+	__u64 ctx_addr;
+	__u32 ctx_size;
+	__u8 singlestep;
+	__u8 rep_complete;
+	__u16 padding;
+	__u8 ctx_data[256];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 14963474617e..0264115a7f4d 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -387,6 +387,52 @@ static bool is_pf_of_interest(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
 	return kvmi_restricted_access(IKVM(kvm), gpa, access);
 }
 
+/*
+ * The custom input is defined by a virtual address and size, and all reads
+ * must be within this space. Reads that are completely outside should be
+ * satisfyied using guest memory. Overlapping reads are erroneous.
+ */
+static int use_custom_input(struct kvm_vcpu *vcpu, gva_t gva, u8 *new,
+			    int bytes)
+{
+	unsigned int offset;
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+	if (!ivcpu->ctx_size || !bytes)
+		return 0;
+
+	if (bytes < 0 || bytes > ivcpu->ctx_size) {
+		kvmi_warn_once(IKVM(vcpu->kvm),
+			       "invalid range: %d (max: %u)\n",
+			       bytes, ivcpu->ctx_size);
+		return 0;
+	}
+
+	if (gva + bytes <= ivcpu->ctx_addr ||
+	    gva >= ivcpu->ctx_addr + ivcpu->ctx_size)
+		return 0;
+
+	if (gva < ivcpu->ctx_addr && gva + bytes > ivcpu->ctx_addr) {
+		kvmi_warn_once(IKVM(vcpu->kvm),
+			       "read ranges overlap: 0x%lx:%d, 0x%llx:%u\n",
+			       gva, bytes, ivcpu->ctx_addr, ivcpu->ctx_size);
+		return 0;
+	}
+
+	if (gva + bytes > ivcpu->ctx_addr + ivcpu->ctx_size) {
+		kvmi_warn_once(IKVM(vcpu->kvm),
+			       "read ranges overlap: 0x%lx:%d, 0x%llx:%u\n",
+			       gva, bytes, ivcpu->ctx_addr, ivcpu->ctx_size);
+		return 0;
+	}
+
+	offset = gva - ivcpu->ctx_addr;
+
+	memcpy(new, ivcpu->ctx_data + offset, bytes);
+
+	return bytes;
+}
+
 static bool __kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	u8 *new, int bytes, struct kvm_page_track_notifier_node *node,
 	bool *data_ready)
@@ -396,9 +442,24 @@ static bool __kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	if (!is_pf_of_interest(vcpu, gpa, KVMI_PAGE_ACCESS_R))
 		return true;
 
+	if (use_custom_input(vcpu, gva, new, bytes))
+		goto out_custom;
+
 	ret = kvmi_arch_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_R);
 
+	if (ret && use_custom_input(vcpu, gva, new, bytes))
+		goto out_custom;
+
 	return ret;
+
+out_custom:
+	if (*data_ready)
+		kvmi_err(IKVM(vcpu->kvm),
+			"Override custom data from another tracker\n");
+
+	*data_ready = true;
+
+	return true;
 }
 
 static bool kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
@@ -855,6 +916,48 @@ void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action,
 	}
 }
 
+void kvmi_init_emulate(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+	struct kvmi_vcpu *ivcpu;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return;
+
+	ivcpu = IVCPU(vcpu);
+
+	ivcpu->rep_complete = false;
+	ivcpu->effective_rep_complete = false;
+
+	ivcpu->ctx_size = 0;
+	ivcpu->ctx_addr = 0;
+
+	kvmi_put(vcpu->kvm);
+}
+EXPORT_SYMBOL(kvmi_init_emulate);
+
+/*
+ * If the user has requested that events triggered by repetitive
+ * instructions be suppressed after the first cycle, then this
+ * function will effectively activate it. This ensures that we don't
+ * prematurely suppress potential events (second or later) triggerd
+ * by an instruction during a single pass.
+ */
+void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return;
+
+	IVCPU(vcpu)->effective_rep_complete = IVCPU(vcpu)->rep_complete;
+
+	kvmi_put(vcpu->kvm);
+}
+EXPORT_SYMBOL(kvmi_activate_rep_complete);
+
 static bool __kvmi_create_vcpu_event(struct kvm_vcpu *vcpu)
 {
 	u32 action;
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index c0044cae8089..d478d9a2e769 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -26,6 +26,8 @@
 
 #define IVCPU(vcpu) ((struct kvmi_vcpu *)((vcpu)->kvmi))
 
+#define KVMI_CTX_DATA_SIZE FIELD_SIZEOF(struct kvmi_event_pf_reply, ctx_data)
+
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
 
 #define KVMI_KNOWN_VCPU_EVENTS ( \
@@ -92,6 +94,12 @@ struct kvmi_vcpu_reply {
 };
 
 struct kvmi_vcpu {
+	u8 ctx_data[KVMI_CTX_DATA_SIZE];
+	u32 ctx_size;
+	u64 ctx_addr;
+	bool rep_complete;
+	bool effective_rep_complete;
+
 	bool reply_waiting;
 	struct kvmi_vcpu_reply reply;
 
@@ -141,6 +149,9 @@ bool kvmi_sock_get(struct kvmi *ikvm, int fd);
 void kvmi_sock_shutdown(struct kvmi *ikvm);
 void kvmi_sock_put(struct kvmi *ikvm);
 bool kvmi_msg_process(struct kvmi *ikvm);
+u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access,
+		     bool *singlestep, bool *rep_complete,
+		     u64 *ctx_addr, u8 *ctx, u32 *ctx_size);
 u32 kvmi_msg_send_create_vcpu(struct kvm_vcpu *vcpu);
 int kvmi_msg_send_unhook(struct kvmi *ikvm);
 
@@ -156,6 +167,8 @@ int kvmi_run_jobs_and_wait(struct kvm_vcpu *vcpu);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
+void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action,
+				      const char *str);
 
 /* arch */
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index a3c67af8674e..0642356d4e04 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -764,6 +764,61 @@ int kvmi_msg_send_unhook(struct kvmi *ikvm)
 	return kvmi_sock_write(ikvm, vec, n, msg_size);
 }
 
+u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access,
+		     bool *singlestep, bool *rep_complete, u64 *ctx_addr,
+		     u8 *ctx_data, u32 *ctx_size)
+{
+	u32 max_ctx_size = *ctx_size;
+	struct kvmi_event_pf e;
+	struct kvmi_event_pf_reply r;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.gpa = gpa;
+	e.gva = gva;
+	e.access = access;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_PF, &e, sizeof(e),
+			      &r, sizeof(r), &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	if (e.padding1 || e.padding2) {
+		struct kvmi *ikvm = IKVM(vcpu->kvm);
+
+		kvmi_err(ikvm, "%s: non zero padding %u,%u\n",
+			__func__, e.padding1, e.padding2);
+		kvmi_sock_shutdown(ikvm);
+		return KVMI_EVENT_ACTION_CONTINUE;
+	}
+
+	*ctx_size = 0;
+
+	if (r.ctx_size > max_ctx_size) {
+		struct kvmi *ikvm = IKVM(vcpu->kvm);
+
+		kvmi_err(ikvm, "%s: ctx_size (recv:%u max:%u)\n",
+				__func__, r.ctx_size, max_ctx_size);
+
+		kvmi_sock_shutdown(ikvm);
+
+		*singlestep = false;
+		*rep_complete = 0;
+
+		return KVMI_EVENT_ACTION_CONTINUE;
+	}
+
+	*singlestep = r.singlestep;
+	*rep_complete = r.rep_complete;
+
+	*ctx_size = min_t(u32, r.ctx_size, sizeof(r.ctx_data));
+	*ctx_addr = r.ctx_addr;
+	if (*ctx_size)
+		memcpy(ctx_data, r.ctx_data, *ctx_size);
+
+	return action;
+}
+
 u32 kvmi_msg_send_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	int err, action;
