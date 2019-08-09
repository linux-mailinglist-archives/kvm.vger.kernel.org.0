Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E64D87FA0
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437279AbfHIQUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:19 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53316 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407435AbfHIQUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DF35E305D341;
        Fri,  9 Aug 2019 19:01:04 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 96C2F305B7A1;
        Fri,  9 Aug 2019 19:01:04 +0300 (EEST)
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
Subject: [RFC PATCH v6 33/92] kvm: introspection: add KVMI_SET_PAGE_ACCESS
Date:   Fri,  9 Aug 2019 18:59:48 +0300
Message-Id: <20190809160047.8319-34-alazar@bitdefender.com>
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

This command sets the spte access bits (rwx) for an array of guest
physical addresses (through the page track subsystem).

These pages, with the requested access bits, are also kept in a radix
tree in order to filter out the #PF events which are of no interest to
the introspection tool.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 54 ++++++++++++++++++++++++++
 arch/x86/kvm/kvmi.c                | 36 ++++++++++++++++++
 include/uapi/linux/kvmi.h          | 15 ++++++++
 virt/kvm/kvmi.c                    | 61 ++++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h                |  4 ++
 virt/kvm/kvmi_msg.c                | 13 +++++++
 6 files changed, 183 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index c27fea73ccfb..b64a030507cf 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -563,6 +563,60 @@ EPT view (0 is primary). On all other hardware it must be zero.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - not enough memory to allocate the reply
 
+10. KVMI_SET_PAGE_ACCESS
+------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_set_page_access {
+		__u16 view;
+		__u16 count;
+		__u32 padding;
+		struct kvmi_page_access_entry entries[0];
+	};
+
+where::
+
+	struct kvmi_page_access_entry {
+		__u64 gpa;
+		__u8 access;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 padding3;
+	};
+
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Sets the spte access bits (rwx) for an array of ``count`` guest physical
+addresses.
+
+The command will fail with -KVM_EINVAL if any of the specified combination
+of access bits is not supported.
+
+The command will make the changes in order and it will stop on the first
+error. The introspection tool should handle the rollback.
+
+In order to 'forget' an address, all the access bits ('rwx') must be set.
+
+:Errors:
+
+* -KVM_EINVAL - the specified access bits combination is invalid
+* -KVM_EINVAL - the selected SPT view is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EINVAL - the message size is invalid
+* -KVM_EOPNOTSUPP - a SPT view was selected but the hardware doesn't support it
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - not enough memory to add the page tracking structures
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 59cf33127b4b..3238ef176ad6 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -224,3 +224,39 @@ int kvmi_arch_cmd_get_page_access(struct kvmi *ikvm,
 	return 0;
 }
 
+int kvmi_arch_cmd_set_page_access(struct kvmi *ikvm,
+				  const struct kvmi_msg_hdr *msg,
+				  const struct kvmi_set_page_access *req)
+{
+	const struct kvmi_page_access_entry *entry = req->entries;
+	const struct kvmi_page_access_entry *end = req->entries + req->count;
+	u8 unknown_bits = ~(KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W
+			    | KVMI_PAGE_ACCESS_X);
+	int ec = 0;
+
+	if (req->padding)
+		return -KVM_EINVAL;
+
+	if (msg->size < sizeof(*req) + (end - entry) * sizeof(*entry))
+		return -KVM_EINVAL;
+
+	if (req->view != 0)	/* TODO */
+		return -KVM_EOPNOTSUPP;
+
+	for (; entry < end; entry++) {
+		if ((entry->access & unknown_bits) || entry->padding1
+				|| entry->padding2 || entry->padding3)
+			ec = -KVM_EINVAL;
+		else
+			ec = kvmi_cmd_set_page_access(ikvm, entry->gpa,
+						      entry->access);
+		if (ec)
+			kvmi_warn(ikvm, "%s: %llx %x padding %x,%x,%x",
+				  __func__, entry->gpa, entry->access,
+				  entry->padding1, entry->padding2,
+				  entry->padding3);
+	}
+
+	return ec;
+}
+
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 047436a0bdc0..2ddbb1fea807 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -127,6 +127,21 @@ struct kvmi_get_page_access_reply {
 	__u8 access[0];
 };
 
+struct kvmi_page_access_entry {
+	__u64 gpa;
+	__u8 access;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 padding3;
+};
+
+struct kvmi_set_page_access {
+	__u16 view;
+	__u16 count;
+	__u32 padding;
+	struct kvmi_page_access_entry entries[0];
+};
+
 struct kvmi_get_vcpu_info_reply {
 	__u64 tsc_speed;
 };
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 20505e4c4b5f..4a9a4430a460 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -73,6 +73,57 @@ static int kvmi_get_gfn_access(struct kvmi *ikvm, const gfn_t gfn,
 	return m ? 0 : -1;
 }
 
+static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
+{
+	struct kvmi_mem_access *m;
+	struct kvmi_mem_access *__m;
+	struct kvmi *ikvm = IKVM(kvm);
+	int err = 0;
+	int idx;
+
+	m = kmem_cache_zalloc(radix_cache, GFP_KERNEL);
+	if (!m)
+		return -KVM_ENOMEM;
+
+	m->gfn = gfn;
+	m->access = access;
+
+	if (radix_tree_preload(GFP_KERNEL)) {
+		err = -KVM_ENOMEM;
+		goto exit;
+	}
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	write_lock(&ikvm->access_tree_lock);
+
+	__m = __kvmi_get_gfn_access(ikvm, gfn);
+	if (__m) {
+		__m->access = access;
+		kvmi_arch_update_page_tracking(kvm, NULL, __m);
+		if (access == full_access) {
+			radix_tree_delete(&ikvm->access_tree, gfn);
+			kmem_cache_free(radix_cache, __m);
+		}
+	} else {
+		radix_tree_insert(&ikvm->access_tree, gfn, m);
+		kvmi_arch_update_page_tracking(kvm, NULL, m);
+		m = NULL;
+	}
+
+	write_unlock(&ikvm->access_tree_lock);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	radix_tree_preload_end();
+
+exit:
+	if (m)
+		kmem_cache_free(radix_cache, m);
+
+	return err;
+}
+
 static bool kvmi_restricted_access(struct kvmi *ikvm, gpa_t gpa, u8 access)
 {
 	u8 allowed_access;
@@ -1081,6 +1132,16 @@ int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access)
 	return 0;
 }
 
+int kvmi_cmd_set_page_access(struct kvmi *ikvm, u64 gpa, u8 access)
+{
+	gfn_t gfn = gpa_to_gfn(gpa);
+	u8 ignored_access;
+
+	kvmi_get_gfn_access(ikvm, gfn, &ignored_access);
+
+	return kvmi_set_gfn_access(ikvm->kvm, gfn, access);
+}
+
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable)
 {
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 00dc5cf72f88..c54be93349b7 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -160,6 +160,7 @@ void *kvmi_msg_alloc(void);
 void *kvmi_msg_alloc_check(size_t size);
 void kvmi_msg_free(void *addr);
 int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access);
+int kvmi_cmd_set_page_access(struct kvmi *ikvm, u64 gpa, u8 access);
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable);
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
@@ -180,6 +181,9 @@ int kvmi_arch_cmd_get_page_access(struct kvmi *ikvm,
 				  const struct kvmi_get_page_access *req,
 				  struct kvmi_get_page_access_reply **dest,
 				  size_t *dest_size);
+int kvmi_arch_cmd_set_page_access(struct kvmi *ikvm,
+				  const struct kvmi_msg_hdr *msg,
+				  const struct kvmi_set_page_access *req);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 09ad17479abb..c150e7bdd440 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -32,6 +32,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_GET_PAGE_ACCESS]       = "KVMI_GET_PAGE_ACCESS",
 	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
+	[KVMI_SET_PAGE_ACCESS]       = "KVMI_SET_PAGE_ACCESS",
 };
 
 static bool is_known_message(u16 id)
@@ -339,6 +340,17 @@ static int handle_get_page_access(struct kvmi *ikvm,
 	return err;
 }
 
+static int handle_set_page_access(struct kvmi *ikvm,
+				  const struct kvmi_msg_hdr *msg,
+				  const void *req)
+{
+	int ec;
+
+	ec = kvmi_arch_cmd_set_page_access(ikvm, msg, req);
+
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, NULL, 0);
+}
+
 static bool invalid_vcpu_hdr(const struct kvmi_vcpu_hdr *hdr)
 {
 	return hdr->padding1 || hdr->padding2;
@@ -356,6 +368,7 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_GET_GUEST_INFO]        = handle_get_guest_info,
 	[KVMI_GET_PAGE_ACCESS]       = handle_get_page_access,
 	[KVMI_GET_VERSION]           = handle_get_version,
+	[KVMI_SET_PAGE_ACCESS]       = handle_set_page_access,
 };
 
 static int handle_event_reply(struct kvm_vcpu *vcpu,
