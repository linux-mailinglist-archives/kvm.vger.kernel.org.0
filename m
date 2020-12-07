Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF602D1B0B
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgLGUsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:12 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42562 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbgLGUsL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:11 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DA2BA305D462;
        Mon,  7 Dec 2020 22:46:17 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B5DF13072785;
        Mon,  7 Dec 2020 22:46:17 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 35/81] KVM: introspection: add the read/dispatch message function
Date:   Mon,  7 Dec 2020 22:45:36 +0200
Message-Id: <20201207204622.15258-36-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
 Documentation/virt/kvm/kvmi.rst               |  75 ++++++++
 include/uapi/linux/kvmi.h                     |  11 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 100 +++++++++++
 virt/kvm/introspection/kvmi.c                 |  43 ++++-
 virt/kvm/introspection/kvmi_int.h             |  10 ++
 virt/kvm/introspection/kvmi_msg.c             | 161 +++++++++++++++++-
 6 files changed, 398 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 59cc33a39f9f..ae6bbf37aef3 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -65,6 +65,74 @@ been used on that guest (if requested). Obviously, whether the guest can
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
+Other error codes can be returned during message handling, but for
+some errors (incomplete messages, wrong sequence numbers, socket errors
+etc.) the socket will be closed. The device manager should reconnect.
+
+When a vCPU thread sends an introspection event, it will wait (and handle
+any related introspection command) until it gets the event reply::
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
+As it can be seen below, the wire protocol specifies occasional padding. This
+is to permit working with the data by directly using C structures or to round
+the structure size to a multiple of 8 bytes (64bit) to improve the copy
+operations that happen during ``recvmsg()`` or ``sendmsg()``. The members
+should have the native alignment of the host. All padding must be
+initialized with zero otherwise the respective command will fail with
+-KVM_EINVAL.
+
+To describe the commands/events, we reuse some conventions from api.rst:
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
 
@@ -99,6 +167,13 @@ In the end, the device manager will pass the file descriptor (plus
 the allowed commands/events) to KVM. It will detect when the socket is
 shutdown and it will reinitiate the handshake.
 
+Once the file descriptor reaches KVM, the introspection tool should
+use the *KVMI_GET_VERSION* command to get the API version and/or the
+*KVMI_VM_CHECK_COMMAND* and *KVMI_VM_CHECK_EVENT* commands to see which
+commands/events are allowed for this guest. The error code -KVM_EPERM
+will be returned if the introspection tool uses a command or tries to
+enable an event which is disallowed.
+
 Unhooking
 ---------
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 85f8622ddf95..2b37eee82c52 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -32,4 +32,15 @@ enum {
 	KVMI_NEXT_VCPU_EVENT
 };
 
+struct kvmi_msg_hdr {
+	__u16 id;
+	__u16 size;
+	__u32 seq;
+};
+
+struct kvmi_error_code {
+	__s32 err;
+	__u32 padding;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index ac8f658999f8..95bd0a60eb47 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -15,6 +15,7 @@
 #include "processor.h"
 #include "../lib/kvm_util_internal.h"
 
+#include "linux/kvm_para.h"
 #include "linux/kvmi.h"
 
 #define VCPU_ID 1
@@ -110,10 +111,109 @@ static void unhook_introspection(struct kvm_vm *vm)
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
index 954d1420db71..31f2b3e1bc43 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -13,9 +13,49 @@
 #define KVMI_NUM_EVENTS   __cmp((int)KVMI_NEXT_VM_EVENT, \
 				(int)KVMI_NEXT_VCPU_EVENT, >)
 
+#define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MAX_MSG_SIZE)
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
+
 int kvmi_init(void)
 {
-	return 0;
+	return kvmi_cache_create();
 }
 
 int kvmi_version(void)
@@ -25,6 +65,7 @@ int kvmi_version(void)
 
 void kvmi_uninit(void)
 {
+	kvmi_cache_destroy();
 }
 
 static void kvmi_free(struct kvm *kvm)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index c89875bd2bac..206aaf93f8ba 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -7,6 +7,11 @@
 #include <uapi/linux/kvmi.h>
 
 #define KVMI(kvm) ((kvm)->kvmi)
+/*
+ * This limit is used to accommodate the largest known fixed-length
+ * message.
+ */
+#define KVMI_MAX_MSG_SIZE (4096 * 2 - sizeof(struct kvmi_msg_hdr))
 
 /* kvmi_msg.c */
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
@@ -14,4 +19,9 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
 
+/* kvmi.c */
+void *kvmi_msg_alloc(void);
+void kvmi_msg_free(void *addr);
+bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
+
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 3ae52c61f861..38a5a4a84d5d 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -8,6 +8,10 @@
 #include <linux/net.h>
 #include "kvmi_int.h"
 
+typedef int (*kvmi_vm_msg_fct)(struct kvm_introspection *kvmi,
+			       const struct kvmi_msg_hdr *msg,
+			       const void *req);
+
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd)
 {
 	struct socket *sock;
@@ -33,7 +37,162 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi)
 	kernel_sock_shutdown(kvmi->sock, SHUT_RDWR);
 }
 
+static int handle_sock_rc(int rc, size_t size)
+{
+	if (unlikely(rc < 0))
+		return rc;
+	if (unlikely(rc != size))
+		return -EPIPE;
+	return 0;
+}
+
+static int kvmi_sock_read(struct kvm_introspection *kvmi, void *buf,
+			  size_t size)
+{
+	struct kvec vec = { .iov_base = buf, .iov_len = size, };
+	struct msghdr m = { };
+	int rc;
+
+	rc = kernel_recvmsg(kvmi->sock, &m, &vec, 1, size, MSG_WAITALL);
+
+	return handle_sock_rc(rc, size);
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
+	return handle_sock_rc(rc, size);
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
+static kvmi_vm_msg_fct const msg_vm[] = {
+};
+
+static kvmi_vm_msg_fct get_vm_msg_handler(u16 id)
+{
+	return id < ARRAY_SIZE(msg_vm) ? msg_vm[id] : NULL;
+}
+
+static bool is_vm_message(u16 id)
+{
+	bool is_vm_msg_id = (id & 1) == 0;
+
+	return is_vm_msg_id && !!get_vm_msg_handler(id);
+}
+
+static bool is_vm_command(u16 id)
+{
+	return is_vm_message(id);
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
+		if (msg->size > KVMI_MAX_MSG_SIZE)
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
+	kvmi_vm_msg_fct fct = get_vm_msg_handler(msg->id);
+
+	return fct(kvmi, msg, msg + 1);
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
+	if (!kvmi_is_command_allowed(kvmi, msg->id))
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
