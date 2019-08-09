Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C9787F2F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437173AbfHIQPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:08 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52908 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437095AbfHIQPD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 97291305D34B;
        Fri,  9 Aug 2019 19:01:20 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DC9B0305B7A0;
        Fri,  9 Aug 2019 19:01:19 +0300 (EEST)
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 50/92] kvm: introspection: add KVMI_GET_REGISTERS
Date:   Fri,  9 Aug 2019 19:00:05 +0300
Message-Id: <20190809160047.8319-51-alazar@bitdefender.com>
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

This command is used to get kvm_regs and kvm_sregs structures,
plus the list of struct kvm_msrs.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 43 ++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h   | 15 ++++++
 arch/x86/kvm/kvmi.c                | 78 ++++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h                |  5 ++
 virt/kvm/kvmi_msg.c                | 17 +++++++
 5 files changed, 158 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 558d3eb6007f..edf81e03ca3c 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -862,6 +862,49 @@ The introspection tool should use *KVMI_CONTROL_VM_EVENTS* to enable the
 * -KVM_EBUSY  - the selected vCPU has too many queued *KVMI_EVENT_PAUSE_VCPU* events
 * -KVM_EPERM  - the *KVMI_EVENT_PAUSE_VCPU* event is disallowed (see *KVMI_CONTROL_EVENTS*)
 		and the introspection tool expects a reply.
+
+17. KVMI_GET_REGISTERS
+----------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_get_registers {
+		__u16 nmsrs;
+		__u16 padding1;
+		__u32 padding2;
+		__u32 msrs_idx[0];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_get_registers_reply {
+		__u32 mode;
+		__u32 padding;
+		struct kvm_regs regs;
+		struct kvm_sregs sregs;
+		struct kvm_msrs msrs;
+	};
+
+For the given vCPU and the ``nmsrs`` sized array of MSRs registers,
+returns the current vCPU mode (in bytes: 2, 4 or 8), the general purpose
+registers, the special registers and the requested set of MSRs.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - one of the indicated MSR-s is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - not enough memory to allocate the reply
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 551f9ed1ed9c..98fb27e1273c 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -26,4 +26,19 @@ struct kvmi_event_arch {
 	} msrs;
 };
 
+struct kvmi_get_registers {
+	__u16 nmsrs;
+	__u16 padding1;
+	__u32 padding2;
+	__u32 msrs_idx[0];
+};
+
+struct kvmi_get_registers_reply {
+	__u32 mode;
+	__u32 padding;
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct kvm_msrs msrs;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index fa290fbf1f75..a78771b21d2f 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -7,6 +7,25 @@
 #include "x86.h"
 #include "../../../virt/kvm/kvmi_int.h"
 
+static void *alloc_get_registers_reply(const struct kvmi_msg_hdr *msg,
+				       const struct kvmi_get_registers *req,
+				       size_t *rpl_size)
+{
+	struct kvmi_get_registers_reply *rpl;
+	u16 k, n = req->nmsrs;
+
+	*rpl_size = sizeof(*rpl) + sizeof(rpl->msrs.entries[0]) * n;
+	rpl = kvmi_msg_alloc_check(*rpl_size);
+	if (rpl) {
+		rpl->msrs.nmsrs = n;
+
+		for (k = 0; k < n; k++)
+			rpl->msrs.entries[k].index = req->msrs_idx[k];
+	}
+
+	return rpl;
+}
+
 /*
  * TODO: this can be done from userspace.
  *   - all these registers are sent with struct kvmi_event_arch
@@ -38,6 +57,65 @@ static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
 	return mode;
 }
 
+static int kvmi_get_registers(struct kvm_vcpu *vcpu, u32 *mode,
+			      struct kvm_regs *regs,
+			      struct kvm_sregs *sregs,
+			      struct kvm_msrs *msrs)
+{
+	struct kvm_msr_entry *msr = msrs->entries;
+	struct kvm_msr_entry *end = msrs->entries + msrs->nmsrs;
+
+	kvm_arch_vcpu_get_regs(vcpu, regs);
+	kvm_arch_vcpu_get_sregs(vcpu, sregs);
+	*mode = kvmi_vcpu_mode(vcpu, sregs);
+
+	for (; msr < end; msr++) {
+		struct msr_data m = {
+			.index = msr->index,
+			.host_initiated = true
+		};
+		int err = kvm_get_msr(vcpu, &m);
+
+		if (err)
+			return -KVM_EINVAL;
+
+		msr->data = m.data;
+	}
+
+	return 0;
+}
+
+int kvmi_arch_cmd_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const struct kvmi_get_registers *req,
+				struct kvmi_get_registers_reply **dest,
+				size_t *dest_size)
+{
+	struct kvmi_get_registers_reply *rpl;
+	size_t rpl_size = 0;
+	int err;
+
+	if (req->padding1 || req->padding2)
+		return -KVM_EINVAL;
+
+	if (msg->size < sizeof(struct kvmi_vcpu_hdr)
+			+ sizeof(*req) + req->nmsrs * sizeof(req->msrs_idx[0]))
+		return -KVM_EINVAL;
+
+	rpl = alloc_get_registers_reply(msg, req, &rpl_size);
+	if (!rpl)
+		return -KVM_ENOMEM;
+
+	err = kvmi_get_registers(vcpu, &rpl->mode, &rpl->regs,
+				 &rpl->sregs, &rpl->msrs);
+
+	*dest = rpl;
+	*dest_size = rpl_size;
+
+	return err;
+
+}
+
 static void kvmi_get_msrs(struct kvm_vcpu *vcpu, struct kvmi_event_arch *event)
 {
 	struct msr_data msr;
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index cb3b0ce87bc1..b547809d13ae 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -200,6 +200,11 @@ void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action,
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
 				    struct kvmi_mem_access *m);
+int kvmi_arch_cmd_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const struct kvmi_get_registers *req,
+				struct kvmi_get_registers_reply **dest,
+				size_t *dest_size);
 int kvmi_arch_cmd_get_page_access(struct kvmi *ikvm,
 				  const struct kvmi_msg_hdr *msg,
 				  const struct kvmi_get_page_access *req,
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index a4446eed354d..9ae0622ff09e 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -32,6 +32,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_GET_GUEST_INFO]        = "KVMI_GET_GUEST_INFO",
 	[KVMI_GET_PAGE_ACCESS]       = "KVMI_GET_PAGE_ACCESS",
 	[KVMI_GET_PAGE_WRITE_BITMAP] = "KVMI_GET_PAGE_WRITE_BITMAP",
+	[KVMI_GET_REGISTERS]         = "KVMI_GET_REGISTERS",
 	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 	[KVMI_PAUSE_VCPU]            = "KVMI_PAUSE_VCPU",
@@ -589,6 +590,21 @@ static int handle_get_vcpu_info(struct kvm_vcpu *vcpu,
 	return reply_cb(vcpu, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const void *req, vcpu_reply_fct reply_cb)
+{
+	struct kvmi_get_registers_reply *rpl = NULL;
+	size_t rpl_size = 0;
+	int err, ec;
+
+	ec = kvmi_arch_cmd_get_registers(vcpu, msg, req, &rpl, &rpl_size);
+
+	err = reply_cb(vcpu, msg, ec, rpl, rpl_size);
+	kvmi_msg_free(rpl);
+	return err;
+}
+
 static int handle_control_events(struct kvm_vcpu *vcpu,
 				 const struct kvmi_msg_hdr *msg,
 				 const void *_req,
@@ -622,6 +638,7 @@ static int(*const msg_vcpu[])(struct kvm_vcpu *,
 			      vcpu_reply_fct) = {
 	[KVMI_CONTROL_EVENTS]   = handle_control_events,
 	[KVMI_EVENT_REPLY]      = handle_event_reply,
+	[KVMI_GET_REGISTERS]    = handle_get_registers,
 	[KVMI_GET_VCPU_INFO]    = handle_get_vcpu_info,
 };
 
