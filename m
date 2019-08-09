Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070F387F50
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437191AbfHIQPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:46 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52974 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437121AbfHIQPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2D87B305D34C;
        Fri,  9 Aug 2019 19:01:21 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 921BA305B7A4;
        Fri,  9 Aug 2019 19:01:20 +0300 (EEST)
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
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>
Subject: [RFC PATCH v6 51/92] kvm: introspection: add KVMI_SET_REGISTERS
Date:   Fri,  9 Aug 2019 19:00:06 +0300
Message-Id: <20190809160047.8319-52-alazar@bitdefender.com>
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

This command is allowed only during a vCPU event (an event has been sent
and the vCPU is waiting for the reply). The registers will be set only
when the reply has been received.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 28 +++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 | 33 ++++++++++++++++++++++++++++++
 include/linux/kvm_host.h           |  1 +
 virt/kvm/kvmi.c                    | 25 ++++++++++++++++++++++
 virt/kvm/kvmi_int.h                |  5 +++++
 virt/kvm/kvmi_msg.c                | 16 +++++++++++++++
 6 files changed, 108 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index edf81e03ca3c..b6722d071ab7 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -905,6 +905,34 @@ registers, the special registers and the requested set of MSRs.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - not enough memory to allocate the reply
 
+18. KVMI_SET_REGISTERS
+----------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvm_regs;
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Sets the general purpose registers for the given vCPU. The changes become
+visible to other threads accessing the KVM vCPU structure after the event
+currently being handled is replied to.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef29ef7617bf..62d15bbb2332 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8431,6 +8431,39 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
+/*
+ * Similar to __set_regs() but it does not reset the exceptions
+ */
+void kvm_arch_vcpu_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	vcpu->arch.emulate_regs_need_sync_from_vcpu = true;
+	vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
+
+	kvm_register_write(vcpu, VCPU_REGS_RAX, regs->rax);
+	kvm_register_write(vcpu, VCPU_REGS_RBX, regs->rbx);
+	kvm_register_write(vcpu, VCPU_REGS_RCX, regs->rcx);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, regs->rdx);
+	kvm_register_write(vcpu, VCPU_REGS_RSI, regs->rsi);
+	kvm_register_write(vcpu, VCPU_REGS_RDI, regs->rdi);
+	kvm_register_write(vcpu, VCPU_REGS_RSP, regs->rsp);
+	kvm_register_write(vcpu, VCPU_REGS_RBP, regs->rbp);
+#ifdef CONFIG_X86_64
+	kvm_register_write(vcpu, VCPU_REGS_R8, regs->r8);
+	kvm_register_write(vcpu, VCPU_REGS_R9, regs->r9);
+	kvm_register_write(vcpu, VCPU_REGS_R10, regs->r10);
+	kvm_register_write(vcpu, VCPU_REGS_R11, regs->r11);
+	kvm_register_write(vcpu, VCPU_REGS_R12, regs->r12);
+	kvm_register_write(vcpu, VCPU_REGS_R13, regs->r13);
+	kvm_register_write(vcpu, VCPU_REGS_R14, regs->r14);
+	kvm_register_write(vcpu, VCPU_REGS_R15, regs->r15);
+#endif
+
+	kvm_rip_write(vcpu, regs->rip);
+	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
+
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+}
+
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 {
 	struct kvm_segment cs;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 09bc06747642..c8eb1a4d997f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -791,6 +791,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 void kvm_arch_vcpu_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+void kvm_arch_vcpu_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs);
 void kvm_arch_vcpu_get_sregs(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 85de2da3eb7b..a20891d3a2ce 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -1212,6 +1212,31 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 	kvmi_put(vcpu->kvm);
 }
 
+void kvmi_post_reply(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+	if (ivcpu->have_delayed_regs) {
+		kvm_arch_vcpu_set_regs(vcpu, &ivcpu->delayed_regs);
+		ivcpu->have_delayed_regs = false;
+	}
+}
+
+int kvmi_cmd_set_registers(struct kvm_vcpu *vcpu, const struct kvm_regs *regs)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+	if (ivcpu->reply_waiting) {
+		/* defer set registers until we get the reply */
+		memcpy(&ivcpu->delayed_regs, regs, sizeof(ivcpu->delayed_regs));
+		ivcpu->have_delayed_regs = true;
+	} else {
+		kvmi_err(IKVM(vcpu->kvm), "Dropped KVMI_SET_REGISTERS\n");
+	}
+
+	return 0;
+}
+
 int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index b547809d13ae..7bc3dd1f2298 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -105,6 +105,9 @@ struct kvmi_vcpu {
 	bool reply_waiting;
 	struct kvmi_vcpu_reply reply;
 
+	bool have_delayed_regs;
+	struct kvm_regs delayed_regs;
+
 	DECLARE_BITMAP(ev_mask, KVMI_NUM_EVENTS);
 
 	struct list_head job_list;
@@ -173,6 +176,7 @@ int kvmi_msg_send_unhook(struct kvmi *ikvm);
 void *kvmi_msg_alloc(void);
 void *kvmi_msg_alloc_check(size_t size);
 void kvmi_msg_free(void *addr);
+int kvmi_cmd_set_registers(struct kvm_vcpu *vcpu, const struct kvm_regs *regs);
 int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access);
 int kvmi_cmd_set_page_access(struct kvmi *ikvm, u64 gpa, u8 access);
 int kvmi_cmd_get_page_write_bitmap(struct kvmi *ikvm, u64 gpa, u32 *bitmap);
@@ -190,6 +194,7 @@ int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
 			       bool enable);
 int kvmi_cmd_pause_vcpu(struct kvm_vcpu *vcpu, bool wait);
 int kvmi_run_jobs_and_wait(struct kvm_vcpu *vcpu);
+void kvmi_post_reply(struct kvm_vcpu *vcpu);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 9ae0622ff09e..355cec70a28d 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -39,6 +39,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_READ_PHYSICAL]         = "KVMI_READ_PHYSICAL",
 	[KVMI_SET_PAGE_ACCESS]       = "KVMI_SET_PAGE_ACCESS",
 	[KVMI_SET_PAGE_WRITE_BITMAP] = "KVMI_SET_PAGE_WRITE_BITMAP",
+	[KVMI_SET_REGISTERS]         = "KVMI_SET_REGISTERS",
 	[KVMI_WRITE_PHYSICAL]        = "KVMI_WRITE_PHYSICAL",
 };
 
@@ -605,6 +606,19 @@ static int handle_get_registers(struct kvm_vcpu *vcpu,
 	return err;
 }
 
+static int handle_set_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const void *_req,
+				vcpu_reply_fct reply_cb)
+{
+	const struct kvm_regs *regs = _req;
+	int err;
+
+	err = kvmi_cmd_set_registers(vcpu, regs);
+
+	return reply_cb(vcpu, msg, err, NULL, 0);
+}
+
 static int handle_control_events(struct kvm_vcpu *vcpu,
 				 const struct kvmi_msg_hdr *msg,
 				 const void *_req,
@@ -640,6 +654,7 @@ static int(*const msg_vcpu[])(struct kvm_vcpu *,
 	[KVMI_EVENT_REPLY]      = handle_event_reply,
 	[KVMI_GET_REGISTERS]    = handle_get_registers,
 	[KVMI_GET_VCPU_INFO]    = handle_get_vcpu_info,
+	[KVMI_SET_REGISTERS]    = handle_set_registers,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *_ctx)
@@ -937,6 +952,7 @@ int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 	if (err)
 		goto out;
 
+	kvmi_post_reply(vcpu);
 	*action = ivcpu->reply.action;
 
 out:
