Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D37788034
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436959AbfHIQe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:34:56 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53774 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726516AbfHIQe4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:34:56 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A06B1301AB49;
        Fri,  9 Aug 2019 19:00:54 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 5C80F305B7A3;
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
Subject: [RFC PATCH v6 08/92] kvm: introspection: add KVMI_CHECK_COMMAND and KVMI_CHECK_EVENT
Date:   Fri,  9 Aug 2019 18:59:23 +0300
Message-Id: <20190809160047.8319-9-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These commands can be used by the introspection tool to check what
introspection commands and events are supported (by KVMi) and allowed
(by userspace/QEMU).

The introspection tool will get one of the following error codes:
  * -KVM_EOPNOTSUPP (unsupported command/event)
  * -KVM_PERM (disallowed command/event)
  * -KVM_EINVAL (the padding space, used for future extensions,
                 is not zero)
  * 0 (the command/event is supported and allowed)

These commands can be seen as an alternative method to KVMI_GET_VERSION
in checking if the introspection supports a specific command/event.

As with the KVMI_GET_VERSION command, these commands can never be
disallowed by userspace/QEMU.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 60 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvmi.h          | 12 ++++++
 virt/kvm/kvmi.c                    |  8 +++-
 virt/kvm/kvmi_msg.c                | 38 +++++++++++++++++++
 4 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 82de474d512b..61cf69aa5d07 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -302,3 +302,63 @@ While the command reply is disabled:
 * the reply status is ignored for any unsupported/unknown or disallowed
   commands (and ``struct kvmi_error_code`` will be sent with -KVM_EOPNOTSUPP
   or -KVM_PERM).
+
+3. KVMI_CHECK_COMMAND
+---------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_check_command {
+		__u16 id;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Checks if the command specified by ``id`` is allowed.
+
+This command is always allowed.
+
+:Errors:
+
+* -KVM_PERM - the command specified by ``id`` is disallowed
+* -KVM_EINVAL - padding is not zero
+
+4. KVMI_CHECK_EVENT
+-------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_check_event {
+		__u16 id;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Checks if the event specified by ``id`` is allowed.
+
+This command is always allowed.
+
+:Errors:
+
+* -KVM_PERM - the event specified by ``id`` is disallowed
+* -KVM_EINVAL - padding is not zero
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index a1ab39c5b8e0..7390303371c9 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -90,4 +90,16 @@ struct kvmi_control_cmd_response {
 	__u32 padding2;
 };
 
+struct kvmi_check_command {
+	__u16 id;
+	__u16 padding1;
+	__u32 padding2;
+};
+
+struct kvmi_check_event {
+	__u16 id;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index d5b6af21564e..dc1bb8326763 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -69,6 +69,8 @@ static bool alloc_kvmi(struct kvm *kvm, const struct kvm_introspection *qemu)
 		return false;
 
 	set_bit(KVMI_GET_VERSION, ikvm->cmd_allow_mask);
+	set_bit(KVMI_CHECK_COMMAND, ikvm->cmd_allow_mask);
+	set_bit(KVMI_CHECK_EVENT, ikvm->cmd_allow_mask);
 
 	memcpy(&ikvm->uuid, &qemu->uuid, sizeof(ikvm->uuid));
 
@@ -295,10 +297,14 @@ int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
 	if (!allow) {
 		DECLARE_BITMAP(always_allowed, KVMI_NUM_COMMANDS);
 
-		if (id == KVMI_GET_VERSION)
+		if (id == KVMI_GET_VERSION
+				|| id == KVMI_CHECK_COMMAND
+				|| id == KVMI_CHECK_EVENT)
 			return -EPERM;
 
 		set_bit(KVMI_GET_VERSION, always_allowed);
+		set_bit(KVMI_CHECK_COMMAND, always_allowed);
+		set_bit(KVMI_CHECK_EVENT, always_allowed);
 
 		bitmap_andnot(requested, requested, always_allowed,
 			      KVMI_NUM_COMMANDS);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 2237a6ed25f6..e24996611e3a 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -9,6 +9,8 @@
 #include "kvmi_int.h"
 
 static const char *const msg_IDs[] = {
+	[KVMI_CHECK_COMMAND]         = "KVMI_CHECK_COMMAND",
+	[KVMI_CHECK_EVENT]           = "KVMI_CHECK_EVENT",
 	[KVMI_CONTROL_CMD_RESPONSE]  = "KVMI_CONTROL_CMD_RESPONSE",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 };
@@ -177,6 +179,40 @@ static bool is_command_allowed(struct kvmi *ikvm, int id)
 	return test_bit(id, ikvm->cmd_allow_mask);
 }
 
+static int handle_check_command(struct kvmi *ikvm,
+				const struct kvmi_msg_hdr *msg,
+				const void *_req)
+{
+	const struct kvmi_check_command *req = _req;
+	int ec = 0;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!is_command_allowed(ikvm, req->id))
+		ec = -KVM_EPERM;
+
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, NULL, 0);
+}
+
+static bool is_event_allowed(struct kvmi *ikvm, int id)
+{
+	return test_bit(id, ikvm->event_allow_mask);
+}
+
+static int handle_check_event(struct kvmi *ikvm,
+			      const struct kvmi_msg_hdr *msg, const void *_req)
+{
+	const struct kvmi_check_event *req = _req;
+	int ec = 0;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!is_event_allowed(ikvm, req->id))
+		ec = -KVM_EPERM;
+
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, NULL, 0);
+}
+
 static int handle_control_cmd_response(struct kvmi *ikvm,
 					const struct kvmi_msg_hdr *msg,
 					const void *_req)
@@ -207,6 +243,8 @@ static int handle_control_cmd_response(struct kvmi *ikvm,
  */
 static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 			    const void *) = {
+	[KVMI_CHECK_COMMAND]         = handle_check_command,
+	[KVMI_CHECK_EVENT]           = handle_check_event,
 	[KVMI_CONTROL_CMD_RESPONSE]  = handle_control_cmd_response,
 	[KVMI_GET_VERSION]           = handle_get_version,
 };
