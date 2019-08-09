Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B8A87F26
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437036AbfHIQO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:14:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52804 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407417AbfHIQO5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:14:57 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E2678305D34A;
        Fri,  9 Aug 2019 19:01:19 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7F899305B7A3;
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
Subject: [RFC PATCH v6 49/92] kvm: introspection: add KVMI_PAUSE_VCPU and KVMI_EVENT_PAUSE_VCPU
Date:   Fri,  9 Aug 2019 19:00:04 +0300
Message-Id: <20190809160047.8319-50-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the only vCPU command handled by the receiving worker.
It increments a pause request counter and kicks the vCPU.

This event is send by the vCPU thread, but has a low priority. It
will be sent after any other vCPU introspection event and when no vCPU
introspection command is queued.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 68 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm_para.h      |  1 +
 include/uapi/linux/kvmi.h          |  7 +++
 virt/kvm/kvmi.c                    | 65 ++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h                |  4 ++
 virt/kvm/kvmi_msg.c                | 61 +++++++++++++++++++++++++++
 6 files changed, 206 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index eef32107837a..558d3eb6007f 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -820,6 +820,48 @@ one page (offset + size <= PAGE_SIZE).
 
 * -KVM_EINVAL - the specified gpa is invalid
 
+16. KVMI_PAUSE_VCPU
+-------------------
+
+:Architecture: all
+:Versions: >= 1
+:Parameters:
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_pause_vcpu {
+		__u8 wait;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 padding3;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Kicks the vCPU from guest.
+
+If `wait` is 1, the command will wait for vCPU to acknowledge the IPI.
+
+The vCPU will handle the pending commands/events and send the
+*KVMI_EVENT_PAUSE_VCPU* event (one for every successful *KVMI_PAUSE_VCPU*
+command) before returning to guest.
+
+Please note that new vCPUs might by created at any time.
+The introspection tool should use *KVMI_CONTROL_VM_EVENTS* to enable the
+*KVMI_EVENT_CREATE_VCPU* event in order to stop these new vCPUs as well
+(by delaying the event reply).
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY  - the selected vCPU has too many queued *KVMI_EVENT_PAUSE_VCPU* events
+* -KVM_EPERM  - the *KVMI_EVENT_PAUSE_VCPU* event is disallowed (see *KVMI_CONTROL_EVENTS*)
+		and the introspection tool expects a reply.
 Events
 ======
 
@@ -992,3 +1034,29 @@ The *RETRY* action is used by the introspector to retry the execution of
 the current instruction. Either using single-step (if ``singlestep`` is
 not zero) or return to guest (if the introspector changed the instruction
 pointer or the page restrictions).
+
+4. KVMI_EVENT_PAUSE_VCPU
+------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+
+This event is sent in response to a *KVMI_PAUSE_VCPU* command and
+cannot be disabled via *KVMI_CONTROL_EVENTS*.
+
+This event has a low priority. It will be sent after any other vCPU
+introspection event and when no vCPU introspection command is queued.
+
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 54c0e20f5b64..07e3f2662b36 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -18,6 +18,7 @@
 #define KVM_EPERM		EPERM
 #define KVM_EOPNOTSUPP		95
 #define KVM_EAGAIN		11
+#define KVM_EBUSY		EBUSY
 #define KVM_ENOMEM		ENOMEM
 
 #define KVM_HC_VAPIC_POLL_IRQ		1
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index be3f066f314e..ca9c6b6aeed5 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -177,6 +177,13 @@ struct kvmi_get_vcpu_info_reply {
 	__u64 tsc_speed;
 };
 
+struct kvmi_pause_vcpu {
+	__u8 wait;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 padding3;
+};
+
 struct kvmi_control_events {
 	__u16 event_id;
 	__u8 enable;
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index a84eb150e116..85de2da3eb7b 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -11,6 +11,8 @@
 #include <linux/kthread.h>
 #include <linux/bitmap.h>
 
+#define MAX_PAUSE_REQUESTS 1001
+
 static struct kmem_cache *msg_cache;
 static struct kmem_cache *radix_cache;
 static struct kmem_cache *job_cache;
@@ -1090,6 +1092,39 @@ static bool kvmi_create_vcpu_event(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static bool __kvmi_pause_vcpu_event(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+	bool ret = false;
+
+	action = kvmi_msg_send_pause_vcpu(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ret = true;
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "PAUSE");
+	}
+
+	return ret;
+}
+
+static bool kvmi_pause_vcpu_event(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return true;
+
+	ret = __kvmi_pause_vcpu_event(vcpu);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
 void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
@@ -1154,6 +1189,7 @@ int kvmi_run_jobs_and_wait(struct kvm_vcpu *vcpu)
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 {
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
 	struct kvmi *ikvm;
 
 	ikvm = kvmi_get(vcpu->kvm);
@@ -1165,6 +1201,12 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 
 		if (err)
 			break;
+
+		if (!atomic_read(&ivcpu->pause_requests))
+			break;
+
+		atomic_dec(&ivcpu->pause_requests);
+		kvmi_pause_vcpu_event(vcpu);
 	}
 
 	kvmi_put(vcpu->kvm);
@@ -1351,10 +1393,33 @@ int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
 	return 0;
 }
 
+int kvmi_cmd_pause_vcpu(struct kvm_vcpu *vcpu, bool wait)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	unsigned int req = KVM_REQ_INTROSPECTION;
+
+	if (atomic_read(&ivcpu->pause_requests) > MAX_PAUSE_REQUESTS)
+		return -KVM_EBUSY;
+
+	atomic_inc(&ivcpu->pause_requests);
+	kvm_make_request(req, vcpu);
+	if (wait)
+		kvm_vcpu_kick_and_wait(vcpu);
+	else
+		kvm_vcpu_kick(vcpu);
+
+	return 0;
+}
+
 static void kvmi_job_abort(struct kvm_vcpu *vcpu, void *ctx)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
 
+	/*
+	 * The thread that might increment this atomic is stopped
+	 * and this thread is the only one that could decrement it.
+	 */
+	atomic_set(&ivcpu->pause_requests, 0);
 	ivcpu->reply_waiting = false;
 }
 
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 7bdff70d4309..cb3b0ce87bc1 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -100,6 +100,8 @@ struct kvmi_vcpu {
 	bool rep_complete;
 	bool effective_rep_complete;
 
+	atomic_t pause_requests;
+
 	bool reply_waiting;
 	struct kvmi_vcpu_reply reply;
 
@@ -164,6 +166,7 @@ u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access,
 		     bool *singlestep, bool *rep_complete,
 		     u64 *ctx_addr, u8 *ctx, u32 *ctx_size);
 u32 kvmi_msg_send_create_vcpu(struct kvm_vcpu *vcpu);
+u32 kvmi_msg_send_pause_vcpu(struct kvm_vcpu *vcpu);
 int kvmi_msg_send_unhook(struct kvmi *ikvm);
 
 /* kvmi.c */
@@ -185,6 +188,7 @@ int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable);
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
 			       bool enable);
+int kvmi_cmd_pause_vcpu(struct kvm_vcpu *vcpu, bool wait);
 int kvmi_run_jobs_and_wait(struct kvm_vcpu *vcpu);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 9c20a9cfda42..a4446eed354d 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -34,6 +34,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_GET_PAGE_WRITE_BITMAP] = "KVMI_GET_PAGE_WRITE_BITMAP",
 	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
+	[KVMI_PAUSE_VCPU]            = "KVMI_PAUSE_VCPU",
 	[KVMI_READ_PHYSICAL]         = "KVMI_READ_PHYSICAL",
 	[KVMI_SET_PAGE_ACCESS]       = "KVMI_SET_PAGE_ACCESS",
 	[KVMI_SET_PAGE_WRITE_BITMAP] = "KVMI_SET_PAGE_WRITE_BITMAP",
@@ -457,6 +458,53 @@ static bool invalid_vcpu_hdr(const struct kvmi_vcpu_hdr *hdr)
 	return hdr->padding1 || hdr->padding2;
 }
 
+/*
+ * We handle this vCPU command on the receiving thread to make it easier
+ * for userspace to implement a 'pause VM' command. Usually, this is done
+ * by sending one 'pause vCPU' command for every vCPU. By handling the
+ * command here, the userspace can:
+ *    - optimize, by not requesting a reply for the first N-1 vCPU's
+ *    - consider the VM stopped once it receives the reply
+ *      for the last 'pause vCPU' command
+ */
+static int handle_pause_vcpu(struct kvmi *ikvm,
+			     const struct kvmi_msg_hdr *msg,
+			     const void *_req)
+{
+	const struct kvmi_pause_vcpu *req = _req;
+	const struct kvmi_vcpu_hdr *cmd;
+	struct kvm_vcpu *vcpu = NULL;
+	int err;
+
+	if (req->padding1 || req->padding2 || req->padding3) {
+		err = -KVM_EINVAL;
+		goto reply;
+	}
+
+	cmd = (const struct kvmi_vcpu_hdr *) (msg + 1);
+
+	if (invalid_vcpu_hdr(cmd)) {
+		err = -KVM_EINVAL;
+		goto reply;
+	}
+
+	if (!is_event_allowed(ikvm, KVMI_EVENT_PAUSE_VCPU)) {
+		err = -KVM_EPERM;
+
+		if (ikvm->cmd_reply_disabled)
+			return kvmi_msg_vm_reply(ikvm, msg, err, NULL, 0);
+
+		goto reply;
+	}
+
+	err = kvmi_get_vcpu(ikvm, cmd->vcpu, &vcpu);
+	if (!err)
+		err = kvmi_cmd_pause_vcpu(vcpu, req->wait == 1);
+
+reply:
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, err, NULL, 0);
+}
+
 /*
  * These commands are executed on the receiving thread/worker.
  */
@@ -471,6 +519,7 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_GET_PAGE_ACCESS]       = handle_get_page_access,
 	[KVMI_GET_PAGE_WRITE_BITMAP] = handle_get_page_write_bitmap,
 	[KVMI_GET_VERSION]           = handle_get_version,
+	[KVMI_PAUSE_VCPU]            = handle_pause_vcpu,
 	[KVMI_READ_PHYSICAL]         = handle_read_physical,
 	[KVMI_SET_PAGE_ACCESS]       = handle_set_page_access,
 	[KVMI_SET_PAGE_WRITE_BITMAP] = handle_set_page_write_bitmap,
@@ -966,3 +1015,15 @@ u32 kvmi_msg_send_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return action;
 }
+
+u32 kvmi_msg_send_pause_vcpu(struct kvm_vcpu *vcpu)
+{
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_PAUSE_VCPU, NULL, 0,
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
