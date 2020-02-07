Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF90155DA2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgBGSRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:34 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40730 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727618AbgBGSQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:53 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CF1CD305D34F;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C0FB03011E0E;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 49/78] KVM: introspection: handle vCPU commands
Date:   Fri,  7 Feb 2020 20:16:07 +0200
Message-Id: <20200207181636.1065-50-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

Based on the common structure (kvmi_vcpu_hdr) used for all vCPU commands,
the receiving thread validates and dispatches the message to the proper
vCPU (adding the handling function to its jobs list).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst   |   8 ++
 include/uapi/linux/kvmi.h         |   6 ++
 virt/kvm/introspection/kvmi_int.h |   3 +
 virt/kvm/introspection/kvmi_msg.c | 151 +++++++++++++++++++++++++++++-
 4 files changed, 166 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 60fa50585c36..38f566b07bb5 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -232,6 +232,14 @@ The following C structures are meant to be used directly when communicating
 over the wire. The peer that detects any size mismatch should simply close
 the connection and report the error.
 
+The commands related to vCPUs start with::
+
+	struct kvmi_vcpu_hdr {
+		__u16 vcpu;
+		__u16 padding1;
+		__u32 padding2;
+	}
+
 1. KVMI_GET_VERSION
 -------------------
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 3b8590c0fc98..b2cbefdb8b29 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -89,6 +89,12 @@ struct kvmi_vm_write_physical {
 	__u8  data[0];
 };
 
+struct kvmi_vcpu_hdr {
+	__u16 vcpu;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index e0d8256162f9..e7ebb4d67dd6 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -55,6 +55,9 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 void *kvmi_msg_alloc(void);
 void *kvmi_msg_alloc_check(size_t size);
 void kvmi_msg_free(void *addr);
+int kvmi_add_job(struct kvm_vcpu *vcpu,
+		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
+		 void *ctx, void (*free_fct)(void *ctx));
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, u64 size,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 032b6b5b8000..94225153f7cc 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -8,6 +8,14 @@
 #include <linux/net.h>
 #include "kvmi_int.h"
 
+struct kvmi_vcpu_cmd_job {
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr cmd;
+	} *msg;
+	struct kvm_vcpu *vcpu;
+};
+
 static const char *const msg_IDs[] = {
 	[KVMI_GET_VERSION]       = "KVMI_GET_VERSION",
 	[KVMI_VM_CHECK_COMMAND]  = "KVMI_VM_CHECK_COMMAND",
@@ -123,6 +131,28 @@ static bool is_command_allowed(struct kvm_introspection *kvmi, int id)
 	return test_bit(id, kvmi->cmd_allow_mask);
 }
 
+static bool invalid_vcpu_hdr(const struct kvmi_vcpu_hdr *hdr)
+{
+	return hdr->padding1 || hdr->padding2;
+}
+
+static int kvmi_get_vcpu(struct kvm_introspection *kvmi, unsigned int vcpu_idx,
+			 struct kvm_vcpu **dest)
+{
+	struct kvm *kvm = kvmi->kvm;
+	struct kvm_vcpu *vcpu;
+
+	if (vcpu_idx >= atomic_read(&kvm->online_vcpus))
+		return -KVM_EINVAL;
+
+	vcpu = kvm_get_vcpu(kvm, vcpu_idx);
+	if (!vcpu)
+		return -KVM_EINVAL;
+
+	*dest = vcpu;
+	return 0;
+}
+
 static int handle_get_version(struct kvm_introspection *kvmi,
 			      const struct kvmi_msg_hdr *msg, const void *req)
 {
@@ -265,16 +295,67 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_VM_WRITE_PHYSICAL] = handle_write_physical,
 };
 
+/*
+ * These commands are executed on the vCPU thread. The receiving thread
+ * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
+ * and signals the vCPU to handle the command (which includes
+ * sending back the reply).
+ */
+static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
+			      const struct kvmi_msg_hdr *, const void *) = {
+};
+
+static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *ctx)
+{
+	struct kvmi_vcpu_cmd_job *job = ctx;
+	size_t id = job->msg->hdr.id;
+	int err;
+
+	job->vcpu = vcpu;
+
+	err = msg_vcpu[id](job, &job->msg->hdr, job->msg + 1);
+
+	if (err) {
+		struct kvm_introspection *kvmi = KVMI(vcpu->kvm);
+
+		kvmi_err(kvmi,
+			 "%s: cmd id: %zu (%s), err: %d\n", __func__,
+			 id, id2str(id), err);
+		kvmi_sock_shutdown(kvmi);
+	}
+}
+
+static void kvmi_free_ctx(void *_ctx)
+{
+	const struct kvmi_vcpu_cmd_job *ctx = _ctx;
+
+	kvmi_msg_free(ctx->msg);
+	kfree(ctx);
+}
+
+static int kvmi_msg_queue_to_vcpu(struct kvm_vcpu *vcpu,
+				  const struct kvmi_vcpu_cmd_job *cmd)
+{
+	return kvmi_add_job(vcpu, kvmi_job_vcpu_cmd, (void *)cmd,
+			    kvmi_free_ctx);
+}
+
 static bool is_vm_message(u16 id)
 {
 	return id < ARRAY_SIZE(msg_vm) && !!msg_vm[id];
 }
 
+static bool is_vcpu_message(u16 id)
+{
+	return id < ARRAY_SIZE(msg_vcpu) && !!msg_vcpu[id];
+}
+
 static bool is_unsupported_message(u16 id)
 {
 	bool supported;
 
-	supported = is_known_message(id) && is_vm_message(id);
+	supported = is_known_message(id) &&
+			(is_vm_message(id) || is_vcpu_message(id));
 
 	return !supported;
 }
@@ -344,12 +425,78 @@ static int kvmi_msg_dispatch_vm_cmd(struct kvm_introspection *kvmi,
 	return msg_vm[msg->id](kvmi, msg, msg + 1);
 }
 
+static bool vcpu_can_handle_commands(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
+}
+
+static int kvmi_get_vcpu_if_ready(struct kvm_introspection *kvmi,
+				  unsigned int vcpu_idx,
+				  struct kvm_vcpu **vcpu)
+{
+	int err;
+
+	err = kvmi_get_vcpu(kvmi, vcpu_idx, vcpu);
+
+	if (!err && !vcpu_can_handle_commands(*vcpu))
+		err = -KVM_EAGAIN;
+
+	return err;
+}
+
+static int kvmi_msg_dispatch_vcpu_job(struct kvm_introspection *kvmi,
+				      struct kvmi_vcpu_cmd_job *job,
+				      bool *queued)
+{
+	struct kvmi_vcpu_hdr *cmd = &job->msg->cmd;
+	struct kvmi_msg_hdr *hdr = &job->msg->hdr;
+	struct kvm_vcpu *vcpu = NULL;
+	int err;
+
+	if (invalid_vcpu_hdr(cmd))
+		return -KVM_EINVAL;
+
+	err = kvmi_get_vcpu_if_ready(kvmi, cmd->vcpu, &vcpu);
+
+	if (err)
+		return kvmi_msg_vm_reply(kvmi, hdr, err, NULL, 0);
+
+	err = kvmi_msg_queue_to_vcpu(vcpu, job);
+	if (!err)
+		*queued = true;
+	return err;
+}
+
+static int kvmi_msg_dispatch_vcpu_cmd(struct kvm_introspection *kvmi,
+				      struct kvmi_msg_hdr *msg,
+				      bool *queued)
+{
+	struct kvmi_vcpu_cmd_job *job_cmd;
+	int err;
+
+	job_cmd = kzalloc(sizeof(*job_cmd), GFP_KERNEL);
+	if (!job_cmd)
+		return -KVM_ENOMEM;
+
+	job_cmd->msg = (void *)msg;
+
+	err = kvmi_msg_dispatch_vcpu_job(kvmi, job_cmd, queued);
+
+	if (!*queued)
+		kfree(job_cmd);
+
+	return err;
+}
+
 static int kvmi_msg_dispatch(struct kvm_introspection *kvmi,
 			     struct kvmi_msg_hdr *msg, bool *queued)
 {
 	int err;
 
-	err = kvmi_msg_dispatch_vm_cmd(kvmi, msg);
+	if (is_vcpu_message(msg->id))
+		err = kvmi_msg_dispatch_vcpu_cmd(kvmi, msg, queued);
+	else
+		err = kvmi_msg_dispatch_vm_cmd(kvmi, msg);
 
 	if (err)
 		kvmi_err(kvmi, "%s: msg id: %u (%s), err: %d\n", __func__,
