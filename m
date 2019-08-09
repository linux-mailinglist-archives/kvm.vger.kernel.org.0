Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0930087F6C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436682AbfHIQO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:14:57 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52802 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407415AbfHIQO5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:14:57 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E97213031EB8;
        Fri,  9 Aug 2019 19:01:13 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8EE2C305B7A3;
        Fri,  9 Aug 2019 19:01:13 +0300 (EEST)
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
Subject: [RFC PATCH v6 43/92] kvm: introspection: add KVMI_CONTROL_SPP
Date:   Fri,  9 Aug 2019 18:59:58 +0300
Message-Id: <20190809160047.8319-44-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command enables/disables subpage protection (SPP) for the current VM.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 33 ++++++++++++++++++++++++++++++
 arch/x86/kvm/kvmi.c                |  4 ++++
 include/uapi/linux/kvmi.h          |  7 +++++++
 virt/kvm/kvmi_int.h                |  6 ++++++
 virt/kvm/kvmi_msg.c                | 33 ++++++++++++++++++++++++++++++
 5 files changed, 83 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index b64a030507cf..c1d12aaa8633 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -617,6 +617,39 @@ In order to 'forget' an address, all the access bits ('rwx') must be set.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - not enough memory to add the page tracking structures
 
+11. KVMI_CONTROL_SPP
+--------------------
+
+:Architectures: x86/intel
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_control_spp {
+		__u8 enable;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 padding3;
+	}
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Enables/disables subpage protection (SPP) for the current VM.
+
+If SPP is not enabled, *KVMI_GET_PAGE_WRITE_BITMAP* and
+*KVMI_SET_PAGE_WRITE_BITMAP* commands will fail.
+
+:Errors:
+
+* -KVM_EINVAL - padding is not zero
+* -KVM_EOPNOTSUPP - the hardware doesn't support SPP
+* -KVM_EOPNOTSUPP - the current implementation can't disable SPP
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 3238ef176ad6..01fd218e213c 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -260,3 +260,7 @@ int kvmi_arch_cmd_set_page_access(struct kvmi *ikvm,
 	return ec;
 }
 
+int kvmi_arch_cmd_control_spp(struct kvmi *ikvm)
+{
+	return kvm_arch_init_spp(ikvm->kvm);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 2ddbb1fea807..9f2b13718e47 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -142,6 +142,13 @@ struct kvmi_set_page_access {
 	struct kvmi_page_access_entry entries[0];
 };
 
+struct kvmi_control_spp {
+	__u8 enable;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 padding3;
+};
+
 struct kvmi_get_vcpu_info_reply {
 	__u64 tsc_speed;
 };
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index c54be93349b7..3f0c7a03b4a1 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -130,6 +130,11 @@ struct kvmi {
 	DECLARE_BITMAP(event_allow_mask, KVMI_NUM_EVENTS);
 	DECLARE_BITMAP(vm_ev_mask, KVMI_NUM_EVENTS);
 
+	struct {
+		bool initialized;
+		atomic_t enabled;
+	} spp;
+
 	bool cmd_reply_disabled;
 };
 
@@ -184,6 +189,7 @@ int kvmi_arch_cmd_get_page_access(struct kvmi *ikvm,
 int kvmi_arch_cmd_set_page_access(struct kvmi *ikvm,
 				  const struct kvmi_msg_hdr *msg,
 				  const struct kvmi_set_page_access *req);
+int kvmi_arch_cmd_control_spp(struct kvmi *ikvm);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index c150e7bdd440..e501a807c8a2 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -25,6 +25,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_CHECK_EVENT]           = "KVMI_CHECK_EVENT",
 	[KVMI_CONTROL_CMD_RESPONSE]  = "KVMI_CONTROL_CMD_RESPONSE",
 	[KVMI_CONTROL_EVENTS]        = "KVMI_CONTROL_EVENTS",
+	[KVMI_CONTROL_SPP]           = "KVMI_CONTROL_SPP",
 	[KVMI_CONTROL_VM_EVENTS]     = "KVMI_CONTROL_VM_EVENTS",
 	[KVMI_EVENT]                 = "KVMI_EVENT",
 	[KVMI_EVENT_REPLY]           = "KVMI_EVENT_REPLY",
@@ -300,6 +301,37 @@ static int kvmi_get_vcpu(struct kvmi *ikvm, unsigned int vcpu_idx,
 	return 0;
 }
 
+static bool enable_spp(struct kvmi *ikvm)
+{
+	if (!ikvm->spp.initialized) {
+		int err = kvmi_arch_cmd_control_spp(ikvm);
+
+		ikvm->spp.initialized = true;
+
+		if (!err)
+			atomic_set(&ikvm->spp.enabled, true);
+	}
+
+	return atomic_read(&ikvm->spp.enabled);
+}
+
+static int handle_control_spp(struct kvmi *ikvm,
+			      const struct kvmi_msg_hdr *msg,
+			      const void *_req)
+{
+	const struct kvmi_control_spp *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2 || req->padding3)
+		ec = -KVM_EINVAL;
+	else if (req->enable && enable_spp(ikvm))
+		ec = 0;
+	else
+		ec = -KVM_EOPNOTSUPP;
+
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, NULL, 0);
+}
+
 static int handle_control_cmd_response(struct kvmi *ikvm,
 					const struct kvmi_msg_hdr *msg,
 					const void *_req)
@@ -364,6 +396,7 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_CHECK_COMMAND]         = handle_check_command,
 	[KVMI_CHECK_EVENT]           = handle_check_event,
 	[KVMI_CONTROL_CMD_RESPONSE]  = handle_control_cmd_response,
+	[KVMI_CONTROL_SPP]           = handle_control_spp,
 	[KVMI_CONTROL_VM_EVENTS]     = handle_control_vm_events,
 	[KVMI_GET_GUEST_INFO]        = handle_get_guest_info,
 	[KVMI_GET_PAGE_ACCESS]       = handle_get_page_access,
