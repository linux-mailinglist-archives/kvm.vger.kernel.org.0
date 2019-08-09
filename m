Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA1E87F3F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437162AbfHIQPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:30 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52914 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437159AbfHIQPK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:10 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4C2C2305D347;
        Fri,  9 Aug 2019 19:01:17 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 6E75F305B7A3;
        Fri,  9 Aug 2019 19:01:16 +0300 (EEST)
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
Subject: [RFC PATCH v6 46/92] kvm: introspection: add KVMI_SET_PAGE_WRITE_BITMAP
Date:   Fri,  9 Aug 2019 19:00:01 +0300
Message-Id: <20190809160047.8319-47-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command sets the subpage protection (SPP) write bitmap for an array
of guest physical addresses of 4KB bytes.

Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 66 ++++++++++++++++++++++++++++++
 arch/x86/kvm/kvmi.c                | 30 ++++++++++++++
 include/uapi/linux/kvmi.h          | 13 ++++++
 virt/kvm/kvmi.c                    | 37 +++++++++++++++++
 virt/kvm/kvmi_int.h                |  4 ++
 virt/kvm/kvmi_msg.c                | 13 ++++++
 6 files changed, 163 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 2ffb92b0fa71..69557c63ff94 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -694,6 +694,72 @@ EPT view (0 is primary). On all other hardware it must be zero.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - not enough memory to allocate the reply
 
+13. KVMI_SET_PAGE_WRITE_BITMAP
+------------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_set_page_write_bitmap {
+		__u16 view;
+		__u16 count;
+		__u32 padding;
+		struct kvmi_page_write_bitmap_entry entries[0];
+	};
+
+where::
+
+	struct kvmi_page_write_bitmap_entry {
+		__u64 gpa;
+		__u32 bitmap;
+		__u32 padding;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Sets the subpage protection (SPP) write bitmap for an array of ``count``
+guest physical addresses of 4KB bytes.
+
+The command will make the changes starting with the first entry and
+it will stop on the first error. The introspection tool should handle
+the rollback.
+
+While the *KVMI_SET_PAGE_ACCESS* command can be used to write-protect a
+4KB page, this command can write-protect 128-bytes subpages inside of a
+4KB page by setting the corresponding bit to 1 (write allowed) or to 0
+(write disallowed). For example, to allow write access to the A and B
+subpages only, the bitmap must be set to::
+
+	BIT(A) | BIT(B)
+
+A and B must be a number between 0 (first subpage) and 31 (last subpage).
+
+Using this command to set all bits to 1 (allow write access for
+all subpages) will allow write access to the whole 4KB page (like a
+*KVMI_SET_PAGE_ACCESS* command with the *KVMI_PAGE_ACCESS_W* flag set)
+and vice versa.
+
+Using this command to set any bit to 0 will write-protect the whole 4KB
+page (like a *KVMI_SET_PAGE_ACCESS* command with the *KVMI_PAGE_ACCESS_W*
+flag cleared) and allow write access only for subpages with the
+corresponding bit set to 1.
+
+:Errors:
+
+* -KVM_EINVAL - the selected SPT view is invalid
+* -KVM_EOPNOTSUPP - a SPT view was selected but the hardware doesn't support it
+* -KVM_EOPNOTSUPP - the hardware doesn't support SPP or hasn't been enabled
+* -KVM_EINVAL - the write access is already allowed for the whole 4KB page
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - not enough memory to add the page tracking structures
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 356ec79936b3..fa290fbf1f75 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -304,6 +304,36 @@ int kvmi_arch_cmd_set_page_access(struct kvmi *ikvm,
 	return ec;
 }
 
+int kvmi_arch_cmd_set_page_write_bitmap(struct kvmi *ikvm,
+					const struct kvmi_msg_hdr *msg,
+					const struct kvmi_set_page_write_bitmap
+					*req)
+{
+	u16 k, n = req->count;
+	int ec = 0;
+
+	if (req->padding)
+		return -KVM_EINVAL;
+
+	if (msg->size < sizeof(*req) + req->count * sizeof(req->entries[0]))
+		return -KVM_EINVAL;
+
+	if (!kvmi_spp_enabled(ikvm))
+		return -KVM_EOPNOTSUPP;
+
+	if (req->view != 0)	/* TODO */
+		return -KVM_EOPNOTSUPP;
+
+	for (k = 0; k < n && ec == 0; k++) {
+		u64 gpa = req->entries[k].gpa;
+		u32 bitmap = req->entries[k].bitmap;
+
+		ec = kvmi_cmd_set_page_write_bitmap(ikvm, gpa, bitmap);
+	}
+
+	return ec;
+}
+
 int kvmi_arch_cmd_control_spp(struct kvmi *ikvm)
 {
 	return kvm_arch_init_spp(ikvm->kvm);
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 19a6a50df96b..0b3139c52a30 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -160,6 +160,19 @@ struct kvmi_get_page_write_bitmap_reply {
 	__u32 bitmap[0];
 };
 
+struct kvmi_page_write_bitmap_entry {
+	__u64 gpa;
+	__u32 bitmap;
+	__u32 padding;
+};
+
+struct kvmi_set_page_write_bitmap {
+	__u16 view;
+	__u16 count;
+	__u32 padding;
+	struct kvmi_page_write_bitmap_entry entries[0];
+};
+
 struct kvmi_get_vcpu_info_reply {
 	__u64 tsc_speed;
 };
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 22e233ca474c..d2bebef98d8d 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -99,6 +99,24 @@ static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access,
 	m->access = access;
 	m->write_bitmap = write_bitmap;
 
+	/*
+	 * Only try to set SPP bitmap when the page is writable.
+	 * Be careful, kvm_mmu_set_subpages() will enable page write-protection
+	 * by default when set SPP bitmap. If bitmap contains all 1s, it'll
+	 * make the page writable by default too.
+	 */
+	if (!(access & KVMI_PAGE_ACCESS_W) && kvmi_spp_enabled(ikvm)) {
+		struct kvm_subpage spp_info;
+
+		spp_info.base_gfn = gfn;
+		spp_info.npages = 1;
+		spp_info.access_map[0] = write_bitmap;
+
+		err = kvm_arch_set_subpages(kvm, &spp_info);
+		if (err)
+			goto exit;
+	}
+
 	if (radix_tree_preload(GFP_KERNEL)) {
 		err = -KVM_ENOMEM;
 		goto exit;
@@ -1183,6 +1201,25 @@ int kvmi_cmd_set_page_access(struct kvmi *ikvm, u64 gpa, u8 access)
 	return kvmi_set_gfn_access(ikvm->kvm, gfn, access, write_bitmap);
 }
 
+int kvmi_cmd_set_page_write_bitmap(struct kvmi *ikvm, u64 gpa,
+				   u32 write_bitmap)
+{
+	bool write_allowed_for_all;
+	gfn_t gfn = gpa_to_gfn(gpa);
+	u32 ignored_write_bitmap;
+	u8 access;
+
+	kvmi_get_gfn_access(ikvm, gfn, &access, &ignored_write_bitmap);
+
+	write_allowed_for_all = (write_bitmap == (u32)((1ULL << 32) - 1));
+	if (write_allowed_for_all)
+		access |= KVMI_PAGE_ACCESS_W;
+	else
+		access &= ~KVMI_PAGE_ACCESS_W;
+
+	return kvmi_set_gfn_access(ikvm->kvm, gfn, access, write_bitmap);
+}
+
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable)
 {
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 7243c57be27a..18c00dae0f2f 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -173,6 +173,7 @@ void kvmi_msg_free(void *addr);
 int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access);
 int kvmi_cmd_set_page_access(struct kvmi *ikvm, u64 gpa, u8 access);
 int kvmi_cmd_get_page_write_bitmap(struct kvmi *ikvm, u64 gpa, u32 *bitmap);
+int kvmi_cmd_set_page_write_bitmap(struct kvmi *ikvm, u64 gpa, u32 bitmap);
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable);
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
@@ -202,6 +203,9 @@ int kvmi_arch_cmd_get_page_write_bitmap(struct kvmi *ikvm,
 					const struct kvmi_get_page_write_bitmap *req,
 					struct kvmi_get_page_write_bitmap_reply **dest,
 					size_t *dest_size);
+int kvmi_arch_cmd_set_page_write_bitmap(struct kvmi *ikvm,
+					const struct kvmi_msg_hdr *msg,
+					const struct kvmi_set_page_write_bitmap *req);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index eb247ac3e037..f9efb52d49c3 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -35,6 +35,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 	[KVMI_SET_PAGE_ACCESS]       = "KVMI_SET_PAGE_ACCESS",
+	[KVMI_SET_PAGE_WRITE_BITMAP] = "KVMI_SET_PAGE_WRITE_BITMAP",
 };
 
 static bool is_known_message(u16 id)
@@ -400,6 +401,17 @@ static int handle_get_page_write_bitmap(struct kvmi *ikvm,
 	return err;
 }
 
+static int handle_set_page_write_bitmap(struct kvmi *ikvm,
+					const struct kvmi_msg_hdr *msg,
+					const void *req)
+{
+	int ec;
+
+	ec = kvmi_arch_cmd_set_page_write_bitmap(ikvm, msg, req);
+
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, NULL, 0);
+}
+
 static bool invalid_vcpu_hdr(const struct kvmi_vcpu_hdr *hdr)
 {
 	return hdr->padding1 || hdr->padding2;
@@ -420,6 +432,7 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_GET_PAGE_WRITE_BITMAP] = handle_get_page_write_bitmap,
 	[KVMI_GET_VERSION]           = handle_get_version,
 	[KVMI_SET_PAGE_ACCESS]       = handle_set_page_access,
+	[KVMI_SET_PAGE_WRITE_BITMAP] = handle_set_page_write_bitmap,
 };
 
 static int handle_event_reply(struct kvm_vcpu *vcpu,
