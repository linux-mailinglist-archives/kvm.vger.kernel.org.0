Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D954687F94
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437015AbfHIQUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:03 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53324 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437114AbfHIQUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 99999305D340;
        Fri,  9 Aug 2019 19:01:04 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3DF27305B7AB;
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
Subject: [RFC PATCH v6 32/92] kvm: introspection: add KVMI_GET_PAGE_ACCESS
Date:   Fri,  9 Aug 2019 18:59:47 +0300
Message-Id: <20190809160047.8319-33-alazar@bitdefender.com>
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

Returns the spte access bits (rwx) for an array of guest physical
addresses.

It does this by checking the radix tree in which only the spte bits
"enforced" by the introspection tool are saved. This information should
already be known by the tool. Not to mention that the KVMI_EVENT_PF
events are sent only for EPT violation caused by these restrictions.
So, we might drop this command.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 54 ++++++++++++++++++++++++++++++
 arch/x86/kvm/kvmi.c                | 41 +++++++++++++++++++++++
 include/uapi/linux/kvmi.h          | 11 ++++++
 virt/kvm/kvmi.c                    |  9 +++++
 virt/kvm/kvmi_int.h                |  6 ++++
 virt/kvm/kvmi_msg.c                | 17 ++++++++++
 6 files changed, 138 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 0fc51b57b1e8..c27fea73ccfb 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -509,6 +509,60 @@ by the *KVMI_CONTROL_VM_EVENTS* command.
 * -KVM_EPERM - the access is restricted by the host
 * -KVM_EOPNOTSUPP - one the events can't be intercepted in the current setup
 
+9. KVMI_GET_PAGE_ACCESS
+-----------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_get_page_access {
+		__u16 view;
+		__u16 count;
+		__u32 padding;
+		__u64 gpa[0];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_get_page_access_reply {
+		__u8 access[0];
+	};
+
+Returns the spte access bits (rwx) for an array of ``count`` guest
+physical addresses.
+
+The valid access bits for *KVMI_GET_PAGE_ACCESS* and *KVMI_SET_PAGE_ACCESS*
+are::
+
+	KVMI_PAGE_ACCESS_R
+	KVMI_PAGE_ACCESS_W
+	KVMI_PAGE_ACCESS_X
+
+By default, for any guest physical address, the returned access mode will
+be 'rwx' (all the above bits). If the introspection tool must prevent
+the code execution from a guest page, for example, it should use the
+KVMI_SET_PAGE_ACCESS command to set the 'rw' bits for any guest physical
+addresses contained in that page. Of course, in order to receive
+page fault events when these violations take place, the KVMI_CONTROL_EVENTS
+command must be used to enable this type of event (KVMI_EVENT_PF).
+
+On Intel hardware with multiple EPT views, the ``view`` argument selects the
+EPT view (0 is primary). On all other hardware it must be zero.
+
+:Errors:
+
+* -KVM_EINVAL - the selected SPT view is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EOPNOTSUPP - a SPT view was selected but the hardware doesn't support it
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - not enough memory to allocate the reply
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 121819f9c487..59cf33127b4b 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -183,3 +183,44 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 		}
 	}
 }
+
+int kvmi_arch_cmd_get_page_access(struct kvmi *ikvm,
+				  const struct kvmi_msg_hdr *msg,
+				  const struct kvmi_get_page_access *req,
+				  struct kvmi_get_page_access_reply **dest,
+				  size_t *dest_size)
+{
+	struct kvmi_get_page_access_reply *rpl = NULL;
+	size_t rpl_size = 0;
+	size_t k, n = req->count;
+	int ec = 0;
+
+	if (req->padding)
+		return -KVM_EINVAL;
+
+	if (msg->size < sizeof(*req) + req->count * sizeof(req->gpa[0]))
+		return -KVM_EINVAL;
+
+	if (req->view != 0)	/* TODO */
+		return -KVM_EOPNOTSUPP;
+
+	rpl_size = sizeof(*rpl) + sizeof(rpl->access[0]) * n;
+	rpl = kvmi_msg_alloc_check(rpl_size);
+	if (!rpl)
+		return -KVM_ENOMEM;
+
+	for (k = 0; k < n && ec == 0; k++)
+		ec = kvmi_cmd_get_page_access(ikvm, req->gpa[k],
+					      &rpl->access[k]);
+
+	if (ec) {
+		kvmi_msg_free(rpl);
+		return ec;
+	}
+
+	*dest = rpl;
+	*dest_size = rpl_size;
+
+	return 0;
+}
+
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 40a5c304c26f..047436a0bdc0 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -116,6 +116,17 @@ struct kvmi_get_guest_info_reply {
 	__u32 padding[3];
 };
 
+struct kvmi_get_page_access {
+	__u16 view;
+	__u16 count;
+	__u32 padding;
+	__u64 gpa[0];
+};
+
+struct kvmi_get_page_access_reply {
+	__u8 access[0];
+};
+
 struct kvmi_get_vcpu_info_reply {
 	__u64 tsc_speed;
 };
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 0264115a7f4d..20505e4c4b5f 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -1072,6 +1072,15 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 	kvmi_put(vcpu->kvm);
 }
 
+int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access)
+{
+	gfn_t gfn = gpa_to_gfn(gpa);
+
+	kvmi_get_gfn_access(ikvm, gfn, access);
+
+	return 0;
+}
+
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable)
 {
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index d478d9a2e769..00dc5cf72f88 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -159,6 +159,7 @@ int kvmi_msg_send_unhook(struct kvmi *ikvm);
 void *kvmi_msg_alloc(void);
 void *kvmi_msg_alloc_check(size_t size);
 void kvmi_msg_free(void *addr);
+int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access);
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable);
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
@@ -174,6 +175,11 @@ void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action,
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
 				    struct kvmi_mem_access *m);
+int kvmi_arch_cmd_get_page_access(struct kvmi *ikvm,
+				  const struct kvmi_msg_hdr *msg,
+				  const struct kvmi_get_page_access *req,
+				  struct kvmi_get_page_access_reply **dest,
+				  size_t *dest_size);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 0642356d4e04..09ad17479abb 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -29,6 +29,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_EVENT]                 = "KVMI_EVENT",
 	[KVMI_EVENT_REPLY]           = "KVMI_EVENT_REPLY",
 	[KVMI_GET_GUEST_INFO]        = "KVMI_GET_GUEST_INFO",
+	[KVMI_GET_PAGE_ACCESS]       = "KVMI_GET_PAGE_ACCESS",
 	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 };
@@ -323,6 +324,21 @@ static int handle_control_cmd_response(struct kvmi *ikvm,
 	return err;
 }
 
+static int handle_get_page_access(struct kvmi *ikvm,
+				  const struct kvmi_msg_hdr *msg,
+				  const void *req)
+{
+	struct kvmi_get_page_access_reply *rpl = NULL;
+	size_t rpl_size = 0;
+	int err, ec;
+
+	ec = kvmi_arch_cmd_get_page_access(ikvm, msg, req, &rpl, &rpl_size);
+
+	err = kvmi_msg_vm_maybe_reply(ikvm, msg, ec, rpl, rpl_size);
+	kvmi_msg_free(rpl);
+	return err;
+}
+
 static bool invalid_vcpu_hdr(const struct kvmi_vcpu_hdr *hdr)
 {
 	return hdr->padding1 || hdr->padding2;
@@ -338,6 +354,7 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_CONTROL_CMD_RESPONSE]  = handle_control_cmd_response,
 	[KVMI_CONTROL_VM_EVENTS]     = handle_control_vm_events,
 	[KVMI_GET_GUEST_INFO]        = handle_get_guest_info,
+	[KVMI_GET_PAGE_ACCESS]       = handle_get_page_access,
 	[KVMI_GET_VERSION]           = handle_get_version,
 };
 
