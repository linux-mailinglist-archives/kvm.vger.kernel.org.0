Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1AF2C3C86
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgKYJmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:03 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57100 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728143AbgKYJmA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:00 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9D2B1305D463;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 6E72B3072784;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 42/81] KVM: introspection: add KVMI_VM_READ_PHYSICAL/KVMI_VM_WRITE_PHYSICAL
Date:   Wed, 25 Nov 2020 11:35:21 +0200
Message-Id: <20201125093600.2766-43-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

These commands allow the introspection tool to read/write from/to
the guest memory.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  68 ++++++++++
 include/uapi/linux/kvmi.h                     |  17 +++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 124 ++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 |  98 ++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |   7 +
 virt/kvm/introspection/kvmi_msg.c             |  44 +++++++
 6 files changed, 358 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index b4ce7db32150..7812d62240c0 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -365,6 +365,74 @@ the following events::
 * -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
 
+6. KVMI_VM_READ_PHYSICAL
+------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_read_physical {
+		__u64 gpa;
+		__u16 size;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	__u8 data[0];
+
+Reads from the guest memory.
+
+Currently, the size must be non-zero and the read must be restricted to
+one page (offset + size <= PAGE_SIZE).
+
+:Errors:
+
+* -KVM_ENOENT - the guest page doesn't exists
+* -KVM_EINVAL - the specified gpa/size pair is invalid
+* -KVM_EINVAL - the padding is not zero
+
+7. KVMI_VM_WRITE_PHYSICAL
+-------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_write_physical {
+		__u64 gpa;
+		__u16 size;
+		__u16 padding1;
+		__u32 padding2;
+		__u8  data[0];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Writes into the guest memory.
+
+Currently, the size must be non-zero and the write must be restricted to
+one page (offset + size <= PAGE_SIZE).
+
+:Errors:
+
+* -KVM_ENOENT - the guest page doesn't exists
+* -KVM_EINVAL - the specified gpa/size pair is invalid
+* -KVM_EINVAL - the padding is not zero
+
 Events
 ======
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 9a10ef2cd890..048afad01be6 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -24,6 +24,8 @@ enum {
 	KVMI_VM_CHECK_EVENT    = KVMI_VM_MESSAGE_ID(3),
 	KVMI_VM_GET_INFO       = KVMI_VM_MESSAGE_ID(4),
 	KVMI_VM_CONTROL_EVENTS = KVMI_VM_MESSAGE_ID(5),
+	KVMI_VM_READ_PHYSICAL  = KVMI_VM_MESSAGE_ID(6),
+	KVMI_VM_WRITE_PHYSICAL = KVMI_VM_MESSAGE_ID(7),
 
 	KVMI_NEXT_VM_MESSAGE
 };
@@ -90,4 +92,19 @@ struct kvmi_vm_control_events {
 	__u32 padding2;
 };
 
+struct kvmi_vm_read_physical {
+	__u64 gpa;
+	__u16 size;
+	__u16 padding1;
+	__u32 padding2;
+};
+
+struct kvmi_vm_write_physical {
+	__u64 gpa;
+	__u16 size;
+	__u16 padding1;
+	__u32 padding2;
+	__u8  data[0];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 430685a3371e..b493edb534b0 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -8,6 +8,7 @@
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <time.h>
 
 #include "test_util.h"
 
@@ -24,6 +25,12 @@ static int socket_pair[2];
 #define Kvm_socket       socket_pair[0]
 #define Userspace_socket socket_pair[1]
 
+static vm_vaddr_t test_gva;
+static void *test_hva;
+static vm_paddr_t test_gpa;
+
+static int page_size;
+
 void setup_socket(void)
 {
 	int r;
@@ -420,8 +427,112 @@ static void test_cmd_vm_control_events(struct kvm_vm *vm)
 	allow_event(vm, id);
 }
 
+static void cmd_vm_write_page(__u64 gpa, __u64 size, void *p,
+			      int expected_err)
+{
+	struct kvmi_vm_write_physical *cmd;
+	struct kvmi_msg_hdr *req;
+	size_t req_size;
+
+	req_size = sizeof(*req) + sizeof(*cmd) + size;
+	req = calloc(1, req_size);
+
+	cmd = (struct kvmi_vm_write_physical *)(req + 1);
+	cmd->gpa = gpa;
+	cmd->size = size;
+
+	memcpy(cmd + 1, p, size);
+
+	test_vm_command(KVMI_VM_WRITE_PHYSICAL, req, req_size, NULL, 0,
+			expected_err);
+
+	free(req);
+}
+
+static void write_guest_page(__u64 gpa, void *p)
+{
+	cmd_vm_write_page(gpa, page_size, p, 0);
+}
+
+static void write_with_invalid_arguments(__u64 gpa, __u64 size, void *p)
+{
+	cmd_vm_write_page(gpa, size, p, -KVM_EINVAL);
+}
+
+static void write_invalid_guest_page(struct kvm_vm *vm, void *p)
+{
+	__u64 gpa = vm->max_gfn << vm->page_shift;
+	__u64 size = 1;
+
+	cmd_vm_write_page(gpa, size, p, -KVM_ENOENT);
+}
+
+static void cmd_vm_read_page(__u64 gpa, __u64 size, void *p,
+			     int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_read_physical cmd;
+	} req = { };
+
+	req.cmd.gpa = gpa;
+	req.cmd.size = size;
+
+	test_vm_command(KVMI_VM_READ_PHYSICAL, &req.hdr, sizeof(req), p, size,
+			expected_err);
+}
+
+static void read_guest_page(__u64 gpa, void *p)
+{
+	cmd_vm_read_page(gpa, page_size, p, 0);
+}
+
+static void read_with_invalid_arguments(__u64 gpa, __u64 size, void *p)
+{
+	cmd_vm_read_page(gpa, size, p, -KVM_EINVAL);
+}
+
+static void read_invalid_guest_page(struct kvm_vm *vm)
+{
+	__u64 gpa = vm->max_gfn << vm->page_shift;
+	__u64 size = 1;
+
+	cmd_vm_read_page(gpa, size, NULL, -KVM_ENOENT);
+}
+
+static void test_memory_access(struct kvm_vm *vm)
+{
+	void *pw, *pr;
+
+	pw = malloc(page_size);
+	TEST_ASSERT(pw, "Insufficient Memory\n");
+
+	memset(pw, 1, page_size);
+
+	write_guest_page(test_gpa, pw);
+	TEST_ASSERT(memcmp(pw, test_hva, page_size) == 0,
+		"Write page test failed");
+
+	pr = malloc(page_size);
+	TEST_ASSERT(pr, "Insufficient Memory\n");
+
+	read_guest_page(test_gpa, pr);
+	TEST_ASSERT(memcmp(pw, pr, page_size) == 0,
+		"Read page test failed");
+
+	read_with_invalid_arguments(test_gpa, 0, pr);
+	write_with_invalid_arguments(test_gpa, 0, pw);
+	write_invalid_guest_page(vm, pw);
+
+	free(pw);
+	free(pr);
+
+	read_invalid_guest_page(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
+	srandom(time(0));
 	setup_socket();
 	hook_introspection(vm);
 
@@ -432,10 +543,20 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_get_info();
 	test_event_unhook(vm);
 	test_cmd_vm_control_events(vm);
+	test_memory_access(vm);
 
 	unhook_introspection(vm);
 }
 
+static void setup_test_pages(struct kvm_vm *vm)
+{
+	test_gva = vm_vaddr_alloc(vm, page_size, KVM_UTIL_MIN_VADDR, 0, 0);
+	sync_global_to_guest(vm, test_gva);
+
+	test_hva = addr_gva2hva(vm, test_gva);
+	test_gpa = addr_gva2gpa(vm, test_gva);
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -448,6 +569,9 @@ int main(int argc, char *argv[])
 	vm = vm_create_default(VCPU_ID, 0, NULL);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
+	page_size = getpagesize();
+	setup_test_pages(vm);
+
 	test_introspection(vm);
 
 	kvm_vm_free(vm);
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 7a0dac2e2f84..2bff4707cc57 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -5,7 +5,9 @@
  * Copyright (C) 2017-2020 Bitdefender S.R.L.
  *
  */
+#include <linux/mmu_context.h>
 #include <linux/kthread.h>
+#include <linux/highmem.h>
 #include "kvmi_int.h"
 
 #define KVMI_NUM_COMMANDS __cmp((int)KVMI_NEXT_VM_MESSAGE, \
@@ -452,3 +454,99 @@ int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 
 	return 0;
 }
+
+static long
+get_user_pages_remote_unlocked(struct mm_struct *mm, unsigned long start,
+				unsigned long nr_pages, unsigned int gup_flags,
+				struct page **pages)
+{
+	struct vm_area_struct **vmas = NULL;
+	int locked = 1;
+	long r;
+
+	mmap_read_lock(mm);
+	r = get_user_pages_remote(mm, start, nr_pages, gup_flags,
+				  pages, vmas, &locked);
+	if (locked)
+		mmap_read_unlock(mm);
+
+	return r;
+}
+
+static void *get_page_ptr(struct kvm *kvm, gpa_t gpa, struct page **page,
+			  bool write, int *srcu_idx)
+{
+	unsigned int flags = write ? FOLL_WRITE : 0;
+	unsigned long hva;
+
+	*page = NULL;
+
+	*srcu_idx = srcu_read_lock(&kvm->srcu);
+	hva = gfn_to_hva(kvm, gpa_to_gfn(gpa));
+
+	if (kvm_is_error_hva(hva))
+		goto out_err;
+
+	if (get_user_pages_remote_unlocked(kvm->mm, hva, 1, flags, page) != 1)
+		goto out_err;
+
+	return write ? kmap_atomic(*page) : kmap(*page);
+out_err:
+	srcu_read_unlock(&kvm->srcu, *srcu_idx);
+	return NULL;
+}
+
+static void put_page_ptr(struct kvm *kvm, void *ptr, struct page *page,
+			 bool write, int srcu_idx)
+{
+	if (write)
+		kunmap_atomic(ptr);
+	else
+		kunmap(ptr);
+
+	put_page(page);
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+}
+
+int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
+			   int (*send)(struct kvm_introspection *,
+					const struct kvmi_msg_hdr *,
+					int err, const void *buf, size_t),
+			   const struct kvmi_msg_hdr *ctx)
+{
+	struct page *page;
+	void *ptr_page;
+	int srcu_idx;
+	int err;
+
+	ptr_page = get_page_ptr(kvm, gpa, &page, false, &srcu_idx);
+	if (!ptr_page) {
+		err = send(KVMI(kvm), ctx, -KVM_ENOENT, NULL, 0);
+	} else {
+		err = send(KVMI(kvm), ctx, 0,
+			   ptr_page + (gpa & ~PAGE_MASK), size);
+
+		put_page_ptr(kvm, ptr_page, page, false, srcu_idx);
+	}
+
+	return err;
+}
+
+int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
+			    const void *buf)
+{
+	int ec = -KVM_ENOENT;
+	struct page *page;
+	int srcu_idx;
+	void *ptr;
+
+	ptr = get_page_ptr(kvm, gpa, &page, true, &srcu_idx);
+	if (ptr) {
+		memcpy(ptr + (gpa & ~PAGE_MASK), buf, size);
+		put_page_ptr(kvm, ptr, page, true, srcu_idx);
+		ec = 0;
+	}
+
+	return ec;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 987513d6c1a7..b7c8730e7e6d 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -29,6 +29,13 @@ bool kvmi_is_known_event(u16 id);
 bool kvmi_is_known_vm_event(u16 id);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 			       u16 event_id, bool enable);
+int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
+			   int (*send)(struct kvm_introspection *,
+					const struct kvmi_msg_hdr*,
+					int err, const void *buf, size_t),
+			   const struct kvmi_msg_hdr *ctx);
+int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
+			    const void *buf);
 
 /* arch */
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index ffd7d95b664f..4fe385265758 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -182,6 +182,48 @@ static int handle_vm_control_events(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+static bool invalid_page_access(u64 gpa, u64 size)
+{
+	u64 off = gpa & ~PAGE_MASK;
+
+	return (size == 0 || size > PAGE_SIZE || off + size > PAGE_SIZE);
+}
+
+static int handle_vm_read_physical(struct kvm_introspection *kvmi,
+				   const struct kvmi_msg_hdr *msg,
+				   const void *_req)
+{
+	const struct kvmi_vm_read_physical *req = _req;
+
+	if (invalid_page_access(req->gpa, req->size) ||
+	    req->padding1 || req->padding2)
+		return kvmi_msg_vm_reply(kvmi, msg, -KVM_EINVAL, NULL, 0);
+
+	return kvmi_cmd_read_physical(kvmi->kvm, req->gpa, req->size,
+				      kvmi_msg_vm_reply, msg);
+}
+
+static int handle_vm_write_physical(struct kvm_introspection *kvmi,
+				    const struct kvmi_msg_hdr *msg,
+				    const void *_req)
+{
+	const struct kvmi_vm_write_physical *req = _req;
+	int ec;
+
+	if (msg->size < struct_size(req, data, req->size))
+		return -EINVAL;
+
+	if (invalid_page_access(req->gpa, req->size))
+		ec = -KVM_EINVAL;
+	else if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else
+		ec = kvmi_cmd_write_physical(kvmi->kvm, req->gpa,
+					     req->size, req->data);
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
@@ -191,6 +233,8 @@ static kvmi_vm_msg_fct const msg_vm[] = {
 	[KVMI_VM_CHECK_EVENT]    = handle_vm_check_event,
 	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
 	[KVMI_VM_GET_INFO]       = handle_vm_get_info,
+	[KVMI_VM_READ_PHYSICAL]  = handle_vm_read_physical,
+	[KVMI_VM_WRITE_PHYSICAL] = handle_vm_write_physical,
 };
 
 static kvmi_vm_msg_fct get_vm_msg_handler(u16 id)
