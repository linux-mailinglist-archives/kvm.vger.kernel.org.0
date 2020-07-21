Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEDC228AF8
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbgGUVSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:34 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37792 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731192AbgGUVP6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:15:58 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 081C6305D678;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D5504304FA14;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 40/84] KVM: introspection: add the read/dispatch message function
Date:   Wed, 22 Jul 2020 00:08:38 +0300
Message-Id: <20200721210922.7646-41-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Based on the common header (struct kvmi_msg_hdr), the receiving thread
will read/validate all messages, execute the VM introspection commands
(eg. KVMI_VM_GET_INFO) and dispatch the vCPU introspection commands
(eg. KVMI_VCPU_GET_REGISTERS) to the vCPU threads.

The vCPU threads will reply to vCPU introspection commands without
the help of the receiving thread. Same for sending vCPU events, but
the vCPU thread will wait for the receiving thread to get the event
reply. Meanwhile, it will execute any queued vCPU introspection command.

The receiving thread will end when the socket is closed or on the first
API error (eg. wrong message size).

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  86 ++++++++++
 include/uapi/linux/kvmi.h                     |  21 +++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 100 ++++++++++++
 virt/kvm/introspection/kvmi.c                 |  42 ++++-
 virt/kvm/introspection/kvmi_int.h             |   5 +
 virt/kvm/introspection/kvmi_msg.c             | 149 +++++++++++++++++-
 6 files changed, 401 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 3a1b6c655de7..f3d16971ba2b 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -65,6 +65,85 @@ been used on that guest (if requested). Obviously, whether the guest can
 really continue normal execution depends on whether the introspection
 tool has made any modifications that require an active KVMI channel.
 
+All messages (commands or events) have a common header::
+
+	struct kvmi_msg_hdr {
+		__u16 id;
+		__u16 size;
+		__u32 seq;
+	};
+
+The replies have the same header, with the sequence number (``seq``)
+and message id (``id``) matching the command/event.
+
+After ``kvmi_msg_hdr``, ``id`` specific data of ``size`` bytes will
+follow.
+
+The message header and its data must be sent with one ``sendmsg()`` call
+to the socket. This simplifies the receiver loop and avoids
+the reconstruction of messages on the other side.
+
+The wire protocol uses the host native byte-order. The introspection tool
+must check this during the handshake and do the necessary conversion.
+
+A command reply begins with::
+
+	struct kvmi_error_code {
+		__s32 err;
+		__u32 padding;
+	}
+
+followed by the command specific data if the error code ``err`` is zero.
+
+The error code -KVM_ENOSYS is returned for unsupported commands.
+
+The error code -KVM_EPERM is returned for disallowed commands (see **Hooking**).
+
+The error code is related to the message processing, including unsupported
+commands. For all the other errors (incomplete messages, wrong sequence
+numbers, socket errors etc.) the socket will be closed. The device
+manager should reconnect.
+
+While all commands will have a reply as soon as possible, the replies
+to events will probably be delayed until a set of (new) commands will
+complete::
+
+   Host kernel               Introspection tool
+   -----------               ------------------
+   event 1 ->
+                             <- command 1
+   command 1 reply ->
+                             <- command 2
+   command 2 reply ->
+                             <- event 1 reply
+
+If both ends send a message at the same time::
+
+   Host kernel               Tool
+   -----------               ----
+   event X ->                <- command X
+
+the host kernel will reply to 'command X', regardless of the receive time
+(before or after the 'event X' was sent).
+
+As it can be seen below, the wire protocol specifies occasional padding. This
+is to permit working with the data by directly using C structures or to round
+the structure size to a multiple of 8 bytes (64bit) to improve the copy
+operations that happen during ``recvmsg()`` or ``sendmsg()``. The members
+should have the native alignment of the host. All padding must be
+initialized with zero otherwise the respective command will fail with
+-KVM_EINVAL.
+
+To describe the commands/events, we reuse some conventions from api.txt:
+
+  - Architectures: which instruction set architectures provide this command/event
+
+  - Versions: which versions provide this command/event
+
+  - Parameters: incoming message data
+
+  - Returns: outgoing/reply message data
+
 Handshake
 ---------
 
@@ -99,6 +178,13 @@ In the end, the device manager will pass the file handle (plus the allowed
 commands/events) to KVM. It will detect when the socket is shutdown
 and it will reinitiate the handshake.
 
+Once the file handle reaches KVM, the introspection tool should
+use the *KVMI_GET_VERSION* command to get the API version and/or the
+*KVMI_VM_CHECK_COMMAND* and *KVMI_VM_CHECK_EVENT* commands to see which
+commands/events are allowed for this guest. The error code -KVM_EPERM
+will be returned if the introspection tool uses a command or enables an
+event which is disallowed.
+
 Unhooking
 ---------
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index d7b18ffef4fa..9bfff484fd6f 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -18,4 +18,25 @@ enum {
 	KVMI_NUM_EVENTS
 };
 
+struct kvmi_msg_hdr {
+	__u16 id;
+	__u16 size;
+	__u32 seq;
+};
+
+/*
+ * The kernel side will close the socket if kvmi_msg_hdr.size
+ * is bigger than KVMI_MSG_SIZE.
+ * This limit is used to accommodate the biggest known message,
+ * the commands to read/write a 4K page from/to guest memory.
+ */
+enum {
+	KVMI_MSG_SIZE = (4096 * 2 - sizeof(struct kvmi_msg_hdr))
+};
+
+struct kvmi_error_code {
+	__s32 err;
+	__u32 padding;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 09b8989317d7..9c591e0d9c8a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -15,6 +15,7 @@
 #include "processor.h"
 #include "../lib/kvm_util_internal.h"
 
+#include "linux/kvm_para.h"
 #include "linux/kvmi.h"
 
 #define VCPU_ID         5
@@ -116,10 +117,109 @@ static void unhook_introspection(struct kvm_vm *vm)
 		errno, strerror(errno));
 }
 
+static void receive_data(void *dest, size_t size)
+{
+	ssize_t r;
+
+	r = recv(Userspace_socket, dest, size, MSG_WAITALL);
+	TEST_ASSERT(r == size,
+		"recv() failed, expected %zd, result %zd, errno %d (%s)\n",
+		size, r, errno, strerror(errno));
+}
+
+static int receive_cmd_reply(struct kvmi_msg_hdr *req, void *rpl,
+			     size_t rpl_size)
+{
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_error_code ec;
+
+	receive_data(&hdr, sizeof(hdr));
+
+	TEST_ASSERT(hdr.seq == req->seq,
+		"Unexpected messages sequence 0x%x, expected 0x%x\n",
+		hdr.seq, req->seq);
+
+	TEST_ASSERT(hdr.size >= sizeof(ec),
+		"Invalid message size %d, expected %zd bytes (at least)\n",
+		hdr.size, sizeof(ec));
+
+	receive_data(&ec, sizeof(ec));
+
+	if (ec.err) {
+		TEST_ASSERT(hdr.size == sizeof(ec),
+			"Invalid command reply on error\n");
+	} else {
+		TEST_ASSERT(hdr.size == sizeof(ec) + rpl_size,
+			"Invalid command reply\n");
+
+		if (rpl && rpl_size)
+			receive_data(rpl, rpl_size);
+	}
+
+	return ec.err;
+}
+
+static unsigned int new_seq(void)
+{
+	static unsigned int seq;
+
+	return seq++;
+}
+
+static void send_message(int msg_id, struct kvmi_msg_hdr *hdr, size_t size)
+{
+	ssize_t r;
+
+	hdr->id = msg_id;
+	hdr->seq = new_seq();
+	hdr->size = size - sizeof(*hdr);
+
+	r = send(Userspace_socket, hdr, size, 0);
+	TEST_ASSERT(r == size,
+		"send() failed, sending %zd, result %zd, errno %d (%s)\n",
+		size, r, errno, strerror(errno));
+}
+
+static const char *kvm_strerror(int error)
+{
+	switch (error) {
+	case KVM_ENOSYS:
+		return "Invalid system call number";
+	case KVM_EOPNOTSUPP:
+		return "Operation not supported on transport endpoint";
+	case KVM_EAGAIN:
+		return "Try again";
+	default:
+		return strerror(error);
+	}
+}
+
+static int do_command(int cmd_id, struct kvmi_msg_hdr *req,
+		      size_t req_size, void *rpl, size_t rpl_size)
+{
+	send_message(cmd_id, req, req_size);
+	return receive_cmd_reply(req, rpl, rpl_size);
+}
+
+static void test_cmd_invalid(void)
+{
+	int invalid_msg_id = 0xffff;
+	struct kvmi_msg_hdr req;
+	int r;
+
+	r = do_command(invalid_msg_id, &req, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == -KVM_ENOSYS,
+		"Invalid command didn't failed with KVM_ENOSYS, error %d (%s)\n",
+		-r, kvm_strerror(-r));
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
 	hook_introspection(vm);
+
+	test_cmd_invalid();
+
 	unhook_introspection(vm);
 }
 
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index b1ea39f35481..547d3388ff8a 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -9,10 +9,49 @@
 #include "kvmi_int.h"
 
 #define KVMI_NUM_COMMANDS KVMI_NUM_MESSAGES
+#define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
+
+static struct kmem_cache *msg_cache;
+
+void *kvmi_msg_alloc(void)
+{
+	return kmem_cache_zalloc(msg_cache, GFP_KERNEL);
+}
+
+void kvmi_msg_free(void *addr)
+{
+	if (addr)
+		kmem_cache_free(msg_cache, addr);
+}
+
+static void kvmi_cache_destroy(void)
+{
+	kmem_cache_destroy(msg_cache);
+	msg_cache = NULL;
+}
+
+static int kvmi_cache_create(void)
+{
+	msg_cache = kmem_cache_create("kvmi_msg", KVMI_MSG_SIZE_ALLOC,
+				      4096, SLAB_ACCOUNT, NULL);
+
+	if (!msg_cache) {
+		kvmi_cache_destroy();
+
+		return -1;
+	}
+
+	return 0;
+}
+
+bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id)
+{
+	return id < KVMI_NUM_COMMANDS && test_bit(id, kvmi->cmd_allow_mask);
+}
 
 int kvmi_init(void)
 {
-	return 0;
+	return kvmi_cache_create();
 }
 
 int kvmi_version(void)
@@ -22,6 +61,7 @@ int kvmi_version(void)
 
 void kvmi_uninit(void)
 {
+	kvmi_cache_destroy();
 }
 
 static void free_kvmi(struct kvm *kvm)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index f0a8d653d79b..5e4eabeefc5b 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -26,4 +26,9 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
 
+/* kvmi.c */
+void *kvmi_msg_alloc(void);
+void kvmi_msg_free(void *addr);
+bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
+
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 3ae52c61f861..4e7b55ec7071 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -33,7 +33,154 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi)
 	kernel_sock_shutdown(kvmi->sock, SHUT_RDWR);
 }
 
+static int kvmi_sock_read(struct kvm_introspection *kvmi, void *buf,
+			  size_t size)
+{
+	struct kvec vec = {
+		.iov_base = buf,
+		.iov_len = size,
+	};
+	struct msghdr m = { };
+	int rc;
+
+	rc = kernel_recvmsg(kvmi->sock, &m, &vec, 1, size, MSG_WAITALL);
+
+	if (unlikely(rc != size && rc >= 0))
+		rc = -EPIPE;
+
+	return rc >= 0 ? 0 : rc;
+}
+
+static int kvmi_sock_write(struct kvm_introspection *kvmi, struct kvec *vec,
+			   size_t n, size_t size)
+{
+	struct msghdr m = { };
+	int rc;
+
+	rc = kernel_sendmsg(kvmi->sock, &m, vec, n, size);
+
+	if (unlikely(rc != size && rc >= 0))
+		rc = -EPIPE;
+
+	return rc >= 0 ? 0 : rc;
+}
+
+static int kvmi_msg_reply(struct kvm_introspection *kvmi,
+			  const struct kvmi_msg_hdr *msg, int err,
+			  const void *rpl, size_t rpl_size)
+{
+	struct kvmi_error_code ec;
+	struct kvmi_msg_hdr h;
+	struct kvec vec[3] = {
+		{ .iov_base = &h, .iov_len = sizeof(h) },
+		{ .iov_base = &ec, .iov_len = sizeof(ec) },
+		{ .iov_base = (void *)rpl, .iov_len = rpl_size },
+	};
+	size_t size = sizeof(h) + sizeof(ec) + (err ? 0 : rpl_size);
+	size_t n = ARRAY_SIZE(vec) - (err ? 1 : 0);
+
+	memset(&h, 0, sizeof(h));
+	h.id = msg->id;
+	h.seq = msg->seq;
+	h.size = size - sizeof(h);
+
+	memset(&ec, 0, sizeof(ec));
+	ec.err = err;
+
+	return kvmi_sock_write(kvmi, vec, n, size);
+}
+
+static int kvmi_msg_vm_reply(struct kvm_introspection *kvmi,
+			     const struct kvmi_msg_hdr *msg,
+			     int err, const void *rpl,
+			     size_t rpl_size)
+{
+	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
+}
+
+/*
+ * These commands are executed by the receiving thread.
+ */
+static int(*const msg_vm[])(struct kvm_introspection *,
+			    const struct kvmi_msg_hdr *, const void *) = {
+};
+
+static bool is_vm_command(u16 id)
+{
+	return id < ARRAY_SIZE(msg_vm) && !!msg_vm[id];
+}
+
+static struct kvmi_msg_hdr *kvmi_msg_recv(struct kvm_introspection *kvmi)
+{
+	struct kvmi_msg_hdr *msg;
+	int err;
+
+	msg = kvmi_msg_alloc();
+	if (!msg)
+		goto out;
+
+	err = kvmi_sock_read(kvmi, msg, sizeof(*msg));
+	if (err)
+		goto out_err;
+
+	if (msg->size) {
+		if (msg->size > KVMI_MSG_SIZE)
+			goto out_err;
+
+		err = kvmi_sock_read(kvmi, msg + 1, msg->size);
+		if (err)
+			goto out_err;
+	}
+
+	return msg;
+
+out_err:
+	kvmi_msg_free(msg);
+out:
+	return NULL;
+}
+
+static int kvmi_msg_do_vm_cmd(struct kvm_introspection *kvmi,
+			      const struct kvmi_msg_hdr *msg)
+{
+	return msg_vm[msg->id](kvmi, msg, msg + 1);
+}
+
+static bool is_message_allowed(struct kvm_introspection *kvmi, u16 id)
+{
+	return kvmi_is_command_allowed(kvmi, id);
+}
+
+static int kvmi_msg_vm_reply_ec(struct kvm_introspection *kvmi,
+				const struct kvmi_msg_hdr *msg, int ec)
+{
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
+static int kvmi_msg_handle_vm_cmd(struct kvm_introspection *kvmi,
+				  struct kvmi_msg_hdr *msg)
+{
+	if (!is_message_allowed(kvmi, msg->id))
+		return kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_EPERM);
+
+	return kvmi_msg_do_vm_cmd(kvmi, msg);
+}
+
 bool kvmi_msg_process(struct kvm_introspection *kvmi)
 {
-	return false;
+	struct kvmi_msg_hdr *msg;
+	int err = -1;
+
+	msg = kvmi_msg_recv(kvmi);
+	if (!msg)
+		goto out;
+
+	if (is_vm_command(msg->id))
+		err = kvmi_msg_handle_vm_cmd(kvmi, msg);
+	else
+		err = kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_ENOSYS);
+
+	kvmi_msg_free(msg);
+out:
+	return err == 0;
 }
