Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DA787F90
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437159AbfHIQT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:19:59 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53316 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437000AbfHIQT6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:58 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 64B15305D3D1;
        Fri,  9 Aug 2019 19:00:55 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E3EF1305B7A3;
        Fri,  9 Aug 2019 19:00:54 +0300 (EEST)
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
Subject: [RFC PATCH v6 10/92] kvm: introspection: add KVMI_CONTROL_VM_EVENTS
Date:   Fri,  9 Aug 2019 18:59:25 +0300
Message-Id: <20190809160047.8319-11-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No introspection event (neither VM event, nor vCPU event) will be sent
to the introspection tool unless enabled/requested.

This command enables/disables VM events. For now, these events are:

  * KVMI_EVENT_UNHOOK
  * KVMI_EVENT_CREATE_VCPU

The first event is initiated by userspace/QEMU in order to give the
introspection tool a chance to remove its hooks in the event of
pause/suspend/migrate.

The second event is actually a vCPU event, added to cover the case when
the introspection tool has paused all vCPUs and userspace hotplugs (and
starts) another one. The event is controlled by this command because its
status (enabled/disabled) is kept in the VM related structures (as opposed
to vCPU related structures). I didn't had a better idea. Not to mention
that, the vCPU events are controlled with commands like "enable/disable
event X for vCPU Y" and Y is _unknown_ for X=KVMI_EVENT_CREATE_VCPU.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 39 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvmi.h          |  7 ++++++
 virt/kvm/kvmi.c                    | 11 +++++++++
 virt/kvm/kvmi_int.h                |  3 +++
 virt/kvm/kvmi_msg.c                | 23 ++++++++++++++++++
 5 files changed, 83 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 2fbe7c28e4f1..a660def20b23 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -380,3 +380,42 @@ This command is always allowed.
 	};
 
 Returns the number of online vCPUs.
+
+6. KVMI_CONTROL_VM_EVENTS
+-------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_control_vm_events {
+		__u16 event_id;
+		__u8 enable;
+		__u8 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Enables/disables VM introspection events. This command can be used with
+the following events::
+
+	KVMI_EVENT_CREATE_VCPU
+	KVMI_EVENT_UNHOOK
+
+When an event is enabled, the introspection tool is notified and,
+in almost all cases, it must reply with: continue, retry, crash, etc.
+(see **Events** below).
+
+:Errors:
+
+* -KVM_EINVAL - the event ID is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EPERM - the access is restricted by the host
+
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 367c8ec28f75..ff35faabb7ed 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -107,4 +107,11 @@ struct kvmi_get_guest_info_reply {
 	__u32 padding[3];
 };
 
+struct kvmi_control_vm_events {
+	__u16 event_id;
+	__u8 enable;
+	__u8 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index dc1bb8326763..961e6cc13fb6 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -338,6 +338,17 @@ void kvmi_destroy_vm(struct kvm *kvm)
 	wait_for_completion_killable(&kvm->kvmi_completed);
 }
 
+int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
+			       bool enable)
+{
+	if (enable)
+		set_bit(event_id, ikvm->vm_ev_mask);
+	else
+		clear_bit(event_id, ikvm->vm_ev_mask);
+
+	return 0;
+}
+
 int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset)
 {
 	struct kvmi *ikvm;
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 157f765fb34d..84ba43bd9a9d 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -85,6 +85,7 @@ struct kvmi {
 
 	DECLARE_BITMAP(cmd_allow_mask, KVMI_NUM_COMMANDS);
 	DECLARE_BITMAP(event_allow_mask, KVMI_NUM_EVENTS);
+	DECLARE_BITMAP(vm_ev_mask, KVMI_NUM_EVENTS);
 
 	bool cmd_reply_disabled;
 };
@@ -99,5 +100,7 @@ bool kvmi_msg_process(struct kvmi *ikvm);
 void *kvmi_msg_alloc(void);
 void *kvmi_msg_alloc_check(size_t size);
 void kvmi_msg_free(void *addr);
+int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
+			       bool enable);
 
 #endif
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index cf8a120b0eae..a55c9e35be36 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -12,6 +12,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_CHECK_COMMAND]         = "KVMI_CHECK_COMMAND",
 	[KVMI_CHECK_EVENT]           = "KVMI_CHECK_EVENT",
 	[KVMI_CONTROL_CMD_RESPONSE]  = "KVMI_CONTROL_CMD_RESPONSE",
+	[KVMI_CONTROL_VM_EVENTS]     = "KVMI_CONTROL_VM_EVENTS",
 	[KVMI_GET_GUEST_INFO]        = "KVMI_GET_GUEST_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 };
@@ -226,6 +227,27 @@ static int handle_get_guest_info(struct kvmi *ikvm,
 	return kvmi_msg_vm_maybe_reply(ikvm, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_control_vm_events(struct kvmi *ikvm,
+				    const struct kvmi_msg_hdr *msg,
+				    const void *_req)
+{
+	const unsigned long known_events = KVMI_KNOWN_VM_EVENTS;
+	const struct kvmi_control_vm_events *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!test_bit(req->event_id, &known_events))
+		ec = -KVM_EINVAL;
+	else if (!is_event_allowed(ikvm, req->event_id))
+		ec = -KVM_EPERM;
+	else
+		ec = kvmi_cmd_control_vm_events(ikvm, req->event_id,
+						req->enable);
+
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, NULL, 0);
+}
+
 static int handle_control_cmd_response(struct kvmi *ikvm,
 					const struct kvmi_msg_hdr *msg,
 					const void *_req)
@@ -259,6 +281,7 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_CHECK_COMMAND]         = handle_check_command,
 	[KVMI_CHECK_EVENT]           = handle_check_event,
 	[KVMI_CONTROL_CMD_RESPONSE]  = handle_control_cmd_response,
+	[KVMI_CONTROL_VM_EVENTS]     = handle_control_vm_events,
 	[KVMI_GET_GUEST_INFO]        = handle_get_guest_info,
 	[KVMI_GET_VERSION]           = handle_get_version,
 };
