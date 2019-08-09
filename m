Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2957887F49
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436958AbfHIQPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:43 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53040 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437125AbfHIQPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7BFAD305D348;
        Fri,  9 Aug 2019 19:01:18 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3571E305B7A9;
        Fri,  9 Aug 2019 19:01:17 +0300 (EEST)
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
Subject: [RFC PATCH v6 47/92] kvm: introspection: add KVMI_READ_PHYSICAL and KVMI_WRITE_PHYSICAL
Date:   Fri,  9 Aug 2019 19:00:02 +0300
Message-Id: <20190809160047.8319-48-alazar@bitdefender.com>
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

These commands allows the introspection tool to read/write from/to the
guest memory.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst |  60 ++++++++++++++++
 include/uapi/linux/kvmi.h          |  11 +++
 virt/kvm/kvmi.c                    | 107 +++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h                |   7 ++
 virt/kvm/kvmi_msg.c                |  42 +++++++++++
 5 files changed, 227 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 69557c63ff94..eef32107837a 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -760,6 +760,66 @@ corresponding bit set to 1.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - not enough memory to add the page tracking structures
 
+14. KVMI_READ_PHYSICAL
+----------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_read_physical {
+		__u64 gpa;
+		__u64 size;
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
+* -KVM_EINVAL - the specified gpa is invalid
+
+15. KVMI_WRITE_PHYSICAL
+-----------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_write_physical {
+		__u64 gpa;
+		__u64 size;
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
+* -KVM_EINVAL - the specified gpa is invalid
+
 Events
 ======
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 0b3139c52a30..be3f066f314e 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -191,6 +191,17 @@ struct kvmi_control_vm_events {
 	__u32 padding2;
 };
 
+struct kvmi_read_physical {
+	__u64 gpa;
+	__u64 size;
+};
+
+struct kvmi_write_physical {
+	__u64 gpa;
+	__u64 size;
+	__u8  data[0];
+};
+
 struct kvmi_vcpu_hdr {
 	__u16 vcpu;
 	__u16 padding1;
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index d2bebef98d8d..a84eb150e116 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2017-2019 Bitdefender S.R.L.
  *
  */
+#include <linux/mmu_context.h>
 #include <uapi/linux/kvmi.h>
 #include "kvmi_int.h"
 #include <linux/kthread.h>
@@ -1220,6 +1221,112 @@ int kvmi_cmd_set_page_write_bitmap(struct kvmi *ikvm, u64 gpa,
 	return kvmi_set_gfn_access(ikvm->kvm, gfn, access, write_bitmap);
 }
 
+unsigned long gfn_to_hva_safe(struct kvm *kvm, gfn_t gfn)
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
+static long get_user_pages_remote_unlocked(struct mm_struct *mm,
+	unsigned long start,
+	unsigned long nr_pages,
+	unsigned int gup_flags,
+	struct page **pages)
+{
+	long ret;
+	struct task_struct *tsk = NULL;
+	struct vm_area_struct **vmas = NULL;
+	int locked = 1;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages_remote(tsk, mm, start, nr_pages, gup_flags,
+		pages, vmas, &locked);
+	if (locked)
+		up_read(&mm->mmap_sem);
+	return ret;
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
+	if (kvm_is_error_hva(hva)) {
+		kvmi_err(IKVM(kvm), "Invalid gpa %llx\n", gpa);
+		return NULL;
+	}
+
+	if (get_user_pages_remote_unlocked(kvm->mm, hva, 1, flags, page) != 1) {
+		kvmi_err(IKVM(kvm),
+			 "Failed to get the page for hva %lx gpa %llx\n",
+			 hva, gpa);
+		return NULL;
+	}
+
+	return kmap_atomic(*page);
+}
+
+static void put_page_ptr(void *ptr, struct page *page)
+{
+	if (ptr)
+		kunmap_atomic(ptr);
+	if (page)
+		put_page(page);
+}
+
+int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, u64 size, int(*send)(
+	struct kvmi *, const struct kvmi_msg_hdr *,
+	int err, const void *buf, size_t),
+	const struct kvmi_msg_hdr *ctx)
+{
+	int err, ec = 0;
+	struct page *page = NULL;
+	void *ptr_page = NULL, *ptr = NULL;
+	size_t ptr_size = 0;
+
+	ptr_page = get_page_ptr(kvm, gpa, &page, false);
+	if (!ptr_page) {
+		ec = -KVM_EINVAL;
+		goto out;
+	}
+
+	ptr = ptr_page + (gpa & ~PAGE_MASK);
+	ptr_size = size;
+
+out:
+	err = send(IKVM(kvm), ctx, ec, ptr, ptr_size);
+
+	put_page_ptr(ptr_page, page);
+	return err;
+}
+
+int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, u64 size, const void *buf)
+{
+	struct page *page;
+	void *ptr;
+
+	ptr = get_page_ptr(kvm, gpa, &page, true);
+	if (!ptr)
+		return -KVM_EINVAL;
+
+	memcpy(ptr + (gpa & ~PAGE_MASK), buf, size);
+
+	put_page_ptr(ptr, page);
+
+	return 0;
+}
+
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable)
 {
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 18c00dae0f2f..7bdff70d4309 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -174,6 +174,13 @@ int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access);
 int kvmi_cmd_set_page_access(struct kvmi *ikvm, u64 gpa, u8 access);
 int kvmi_cmd_get_page_write_bitmap(struct kvmi *ikvm, u64 gpa, u32 *bitmap);
 int kvmi_cmd_set_page_write_bitmap(struct kvmi *ikvm, u64 gpa, u32 bitmap);
+int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, u64 size,
+			   int (*send)(struct kvmi *,
+					const struct kvmi_msg_hdr*,
+					int err, const void *buf, size_t),
+			   const struct kvmi_msg_hdr *ctx);
+int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, u64 size,
+			    const void *buf);
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable);
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index f9efb52d49c3..9c20a9cfda42 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -34,8 +34,10 @@ static const char *const msg_IDs[] = {
 	[KVMI_GET_PAGE_WRITE_BITMAP] = "KVMI_GET_PAGE_WRITE_BITMAP",
 	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
+	[KVMI_READ_PHYSICAL]         = "KVMI_READ_PHYSICAL",
 	[KVMI_SET_PAGE_ACCESS]       = "KVMI_SET_PAGE_ACCESS",
 	[KVMI_SET_PAGE_WRITE_BITMAP] = "KVMI_SET_PAGE_WRITE_BITMAP",
+	[KVMI_WRITE_PHYSICAL]        = "KVMI_WRITE_PHYSICAL",
 };
 
 static bool is_known_message(u16 id)
@@ -303,6 +305,44 @@ static int kvmi_get_vcpu(struct kvmi *ikvm, unsigned int vcpu_idx,
 	return 0;
 }
 
+static bool invalid_page_access(u64 gpa, u64 size)
+{
+	u64 off = gpa & ~PAGE_MASK;
+
+	return (size == 0 || size > PAGE_SIZE || off + size > PAGE_SIZE);
+}
+
+static int handle_read_physical(struct kvmi *ikvm,
+				const struct kvmi_msg_hdr *msg,
+				const void *_req)
+{
+	const struct kvmi_read_physical *req = _req;
+
+	if (invalid_page_access(req->gpa, req->size))
+		return -EINVAL;
+
+	return kvmi_cmd_read_physical(ikvm->kvm, req->gpa, req->size,
+				      kvmi_msg_vm_maybe_reply, msg);
+}
+
+static int handle_write_physical(struct kvmi *ikvm,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *_req)
+{
+	const struct kvmi_write_physical *req = _req;
+	int ec;
+
+	if (invalid_page_access(req->gpa, req->size))
+		return -EINVAL;
+
+	if (msg->size < sizeof(*req) + req->size)
+		return -EINVAL;
+
+	ec = kvmi_cmd_write_physical(ikvm->kvm, req->gpa, req->size, req->data);
+
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, NULL, 0);
+}
+
 static bool enable_spp(struct kvmi *ikvm)
 {
 	if (!ikvm->spp.initialized) {
@@ -431,8 +471,10 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_GET_PAGE_ACCESS]       = handle_get_page_access,
 	[KVMI_GET_PAGE_WRITE_BITMAP] = handle_get_page_write_bitmap,
 	[KVMI_GET_VERSION]           = handle_get_version,
+	[KVMI_READ_PHYSICAL]         = handle_read_physical,
 	[KVMI_SET_PAGE_ACCESS]       = handle_set_page_access,
 	[KVMI_SET_PAGE_WRITE_BITMAP] = handle_set_page_write_bitmap,
+	[KVMI_WRITE_PHYSICAL]        = handle_write_physical,
 };
 
 static int handle_event_reply(struct kvm_vcpu *vcpu,
