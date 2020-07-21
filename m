Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EDB228A92
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbgGUVQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:11 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37846 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731314AbgGUVQK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:10 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 25492305D61B;
        Wed, 22 Jul 2020 00:09:26 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E5C5B304FA13;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 46/84] KVM: introspection: add KVMI_VM_READ_PHYSICAL/KVMI_VM_WRITE_PHYSICAL
Date:   Wed, 22 Jul 2020 00:08:44 +0300
Message-Id: <20200721210922.7646-47-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 Documentation/virt/kvm/kvmi.rst               |  68 +++++++
 include/uapi/linux/kvmi.h                     |  17 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 170 ++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 108 +++++++++++
 virt/kvm/introspection/kvmi_int.h             |   7 +
 virt/kvm/introspection/kvmi_msg.c             |  44 +++++
 6 files changed, 414 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 4ec0046b4138..be5a92e20173 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -375,6 +375,74 @@ the following events::
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
index f9e2cb8a2c5e..9b2428963994 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -22,6 +22,8 @@ enum {
 	KVMI_VM_CHECK_EVENT    = 3,
 	KVMI_VM_GET_INFO       = 4,
 	KVMI_VM_CONTROL_EVENTS = 5,
+	KVMI_VM_READ_PHYSICAL  = 6,
+	KVMI_VM_WRITE_PHYSICAL = 7,
 
 	KVMI_NUM_MESSAGES
 };
@@ -82,6 +84,21 @@ struct kvmi_vm_control_events {
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
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index bb2daaca0291..97dec49d52b7 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -8,6 +8,7 @@
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <time.h>
 
 #include "test_util.h"
 
@@ -24,6 +25,13 @@ static int socket_pair[2];
 #define Kvm_socket       socket_pair[0]
 #define Userspace_socket socket_pair[1]
 
+static vm_vaddr_t test_gva;
+static void *test_hva;
+static vm_paddr_t test_gpa;
+
+static uint8_t test_write_pattern;
+static int page_size;
+
 void setup_socket(void)
 {
 	int r;
@@ -434,8 +442,154 @@ static void test_cmd_vm_control_events(struct kvm_vm *vm)
 	allow_event(vm, id);
 }
 
+static void cmd_vm_write_page(__u64 gpa, __u64 size, void *p, __u16 padding,
+			      int expected_err)
+{
+	struct kvmi_vm_write_physical *cmd;
+	struct kvmi_msg_hdr *req;
+	size_t req_size;
+	int r;
+
+	req_size = sizeof(*req) + sizeof(*cmd) + size;
+
+	req = calloc(1, req_size);
+	TEST_ASSERT(req, "Insufficient Memory\n");
+
+	cmd = (struct kvmi_vm_write_physical *)(req + 1);
+	cmd->gpa = gpa;
+	cmd->size = size;
+	cmd->padding1 = padding;
+	cmd->padding2 = padding;
+
+	memcpy(cmd + 1, p, size);
+
+	r = do_command(KVMI_VM_WRITE_PHYSICAL, req, req_size, NULL, 0);
+
+	free(req);
+
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VM_WRITE_PHYSICAL failed, gpa 0x%llx, error %d (%s), expected error %d\n",
+		gpa, -r, kvm_strerror(-r), expected_err);
+}
+
+static void write_guest_page(__u64 gpa, void *p)
+{
+	cmd_vm_write_page(gpa, page_size, p, 0, 0);
+}
+
+static void write_with_invalid_arguments(__u64 gpa, __u64 size, void *p)
+{
+	cmd_vm_write_page(gpa, size, p, 0, -KVM_EINVAL);
+}
+
+static void write_with_invalid_padding(__u64 gpa, void *p)
+{
+	__u16 padding = 1;
+
+	cmd_vm_write_page(gpa, page_size, p, padding, -KVM_EINVAL);
+}
+
+static void write_invalid_guest_page(struct kvm_vm *vm, void *p)
+{
+	__u64 gpa = vm->max_gfn << vm->page_shift;
+	__u64 size = 1;
+
+	cmd_vm_write_page(gpa, size, p, 0, -KVM_ENOENT);
+}
+
+static void cmd_vm_read_page(__u64 gpa, __u64 size, void *p, __u16 padding,
+			     int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_read_physical cmd;
+	} req = { };
+	int r;
+
+	req.cmd.gpa = gpa;
+	req.cmd.size = size;
+	req.cmd.padding1 = padding;
+	req.cmd.padding2 = padding;
+
+	r = do_command(KVMI_VM_READ_PHYSICAL, &req.hdr, sizeof(req), p, size);
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VM_READ_PHYSICAL failed, gpa 0x%llx, error %d (%s), expected error %d\n",
+		gpa, -r, kvm_strerror(-r), expected_err);
+}
+
+static void read_guest_page(__u64 gpa, void *p)
+{
+	cmd_vm_read_page(gpa, page_size, p, 0, 0);
+}
+
+static void read_with_invalid_arguments(__u64 gpa, __u64 size, void *p)
+{
+	cmd_vm_read_page(gpa, size, p, 0, -KVM_EINVAL);
+}
+
+static void read_with_invalid_padding(__u64 gpa, void *p)
+{
+	__u16 padding = 1;
+
+	cmd_vm_read_page(gpa, page_size, p, padding, -KVM_EINVAL);
+}
+
+static void read_invalid_guest_page(struct kvm_vm *vm)
+{
+	__u64 gpa = vm->max_gfn << vm->page_shift;
+	__u64 size = 1;
+
+	cmd_vm_read_page(gpa, size, NULL, 0, -KVM_ENOENT);
+}
+
+static void new_test_write_pattern(struct kvm_vm *vm)
+{
+	uint8_t n;
+
+	do {
+		n = random();
+	} while (n == 0 || n == test_write_pattern);
+
+	test_write_pattern = n;
+	sync_global_to_guest(vm, test_write_pattern);
+}
+
+static void test_memory_access(struct kvm_vm *vm)
+{
+	void *pw, *pr;
+
+	new_test_write_pattern(vm);
+
+	pw = malloc(page_size);
+	TEST_ASSERT(pw, "Insufficient Memory\n");
+
+	memset(pw, test_write_pattern, page_size);
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
+	read_with_invalid_padding(test_gpa, pr);
+	write_with_invalid_arguments(test_gpa, 0, pw);
+	write_with_invalid_padding(test_gpa, pw);
+	write_invalid_guest_page(vm, pw);
+
+	free(pw);
+	free(pr);
+
+	read_invalid_guest_page(vm);
+}
 static void test_introspection(struct kvm_vm *vm)
 {
+	srandom(time(0));
 	setup_socket();
 	hook_introspection(vm);
 
@@ -446,10 +600,23 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_get_info();
 	test_event_unhook(vm);
 	test_cmd_vm_control_events(vm);
+	test_memory_access(vm);
 
 	unhook_introspection(vm);
 }
 
+static void setup_test_pages(struct kvm_vm *vm)
+{
+	test_gva = vm_vaddr_alloc(vm, page_size, KVM_UTIL_MIN_VADDR, 0, 0);
+
+	sync_global_to_guest(vm, test_gva);
+
+	test_hva = addr_gva2hva(vm, test_gva);
+	memset(test_hva, 0, page_size);
+
+	test_gpa = addr_gva2gpa(vm, test_gva);
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -462,6 +629,9 @@ int main(int argc, char *argv[])
 	vm = vm_create_default(VCPU_ID, 0, NULL);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
+	page_size = getpagesize();
+	setup_test_pages(vm);
+
 	test_introspection(vm);
 
 	kvm_vm_free(vm);
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 5af6ea041035..354dea276347 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2017-2020 Bitdefender S.R.L.
  *
  */
+#include <linux/mmu_context.h>
 #include <linux/kthread.h>
 #include "kvmi_int.h"
 
@@ -445,3 +446,110 @@ int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 
 	return 0;
 }
+
+static unsigned long gfn_to_hva_safe(struct kvm *kvm, gfn_t gfn)
+{
+	unsigned long hva;
+	int srcu_idx;
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	hva = gfn_to_hva(kvm, gfn);
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	return hva;
+}
+
+static long
+get_user_pages_remote_unlocked(struct mm_struct *mm, unsigned long start,
+				unsigned long nr_pages, unsigned int gup_flags,
+				struct page **pages)
+{
+	struct vm_area_struct **vmas = NULL;
+	struct task_struct *tsk = NULL;
+	int locked = 1;
+	long r;
+
+	mmap_read_lock(mm);
+	r = get_user_pages_remote(tsk, mm, start, nr_pages, gup_flags,
+				  pages, vmas, &locked);
+	if (locked)
+		mmap_read_unlock(mm);
+
+	return r;
+}
+
+static void *get_page_ptr(struct kvm *kvm, gpa_t gpa, struct page **page,
+			  bool write)
+{
+	unsigned int flags = write ? FOLL_WRITE : 0;
+	unsigned long hva;
+
+	*page = NULL;
+
+	hva = gfn_to_hva_safe(kvm, gpa_to_gfn(gpa));
+
+	if (kvm_is_error_hva(hva))
+		return NULL;
+
+	if (get_user_pages_remote_unlocked(kvm->mm, hva, 1, flags, page) != 1)
+		return NULL;
+
+	return write ? kmap_atomic(*page) : kmap(*page);
+}
+
+static void put_page_ptr(void *ptr, struct page *page, bool write)
+{
+	if (ptr) {
+		if (write)
+			kunmap_atomic(ptr);
+		else
+			kunmap(ptr);
+	}
+	if (page)
+		put_page(page);
+}
+
+int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
+			   int (*send)(struct kvm_introspection *,
+					const struct kvmi_msg_hdr *,
+					int err, const void *buf, size_t),
+			   const struct kvmi_msg_hdr *ctx)
+{
+	void *ptr_page = NULL, *ptr;
+	struct page *page = NULL;
+	size_t ptr_size;
+	int err, ec;
+
+	ptr_page = get_page_ptr(kvm, gpa, &page, false);
+	if (ptr_page) {
+		ptr = ptr_page + (gpa & ~PAGE_MASK);
+		ptr_size = size;
+		ec = 0;
+	} else {
+		ptr = NULL;
+		ptr_size = 0;
+		ec = -KVM_ENOENT;
+	}
+
+	err = send(KVMI(kvm), ctx, ec, ptr, ptr_size);
+
+	put_page_ptr(ptr_page, page, false);
+	return err;
+}
+
+int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
+			    const void *buf)
+{
+	struct page *page;
+	void *ptr;
+
+	ptr = get_page_ptr(kvm, gpa, &page, true);
+	if (!ptr)
+		return -KVM_ENOENT;
+
+	memcpy(ptr + (gpa & ~PAGE_MASK), buf, size);
+
+	put_page_ptr(ptr, page, true);
+
+	return 0;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 7c503b8ca043..40e8647a6fd4 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -35,5 +35,12 @@ bool kvmi_is_known_event(u8 id);
 bool kvmi_is_known_vm_event(u8 id);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
+int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
+			   int (*send)(struct kvm_introspection *,
+					const struct kvmi_msg_hdr*,
+					int err, const void *buf, size_t),
+			   const struct kvmi_msg_hdr *ctx);
+int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
+			    const void *buf);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index a148ed1e767c..de9e38e8e24b 100644
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
+	if (invalid_page_access(req->gpa, req->size)
+			|| req->padding1 || req->padding2)
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
@@ -192,6 +234,8 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_VM_CHECK_EVENT]    = handle_vm_check_event,
 	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
 	[KVMI_VM_GET_INFO]       = handle_vm_get_info,
+	[KVMI_VM_READ_PHYSICAL]  = handle_vm_read_physical,
+	[KVMI_VM_WRITE_PHYSICAL] = handle_vm_write_physical,
 };
 
 static bool is_vm_command(u16 id)
