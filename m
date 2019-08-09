Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2046C87EFD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437032AbfHIQJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:09:56 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52680 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436956AbfHIQJz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:09:55 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2019 12:09:54 EDT
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0D891301AB48;
        Fri,  9 Aug 2019 19:00:54 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id BFC3E305B7A4;
        Fri,  9 Aug 2019 19:00:53 +0300 (EEST)
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
Subject: [RFC PATCH v6 06/92] kvm: introspection: add KVMI_CONTROL_CMD_RESPONSE
Date:   Fri,  9 Aug 2019 18:59:21 +0300
Message-Id: <20190809160047.8319-7-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command enables/disables the command replies. It is useful when
the introspection tool send multiple messages with one write() call and
doesn't have to wait for a reply.

IIRC, the speed improvment seen during UnixBench tests in a VM
introspected through vsock (the introspection tool was running in a
different VM) was around 5-10%.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 50 ++++++++++++++++++++++++++
 include/uapi/linux/kvmi.h          |  7 ++++
 virt/kvm/kvmi_int.h                |  2 ++
 virt/kvm/kvmi_msg.c                | 57 ++++++++++++++++++++++++++++++
 4 files changed, 116 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 0f296e3c4244..82de474d512b 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -252,3 +252,53 @@ Returns the introspection API version.
 
 This command is always allowed and successful (if the introspection is
 built in kernel).
+
+2. KVMI_CONTROL_CMD_RESPONSE
+----------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_control_cmd_response {
+		__u8 enable;
+		__u8 now;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+	struct kvmi_error_code
+
+Enables or disables the command replies. By default, all commands need
+a reply.
+
+If `now` is 1, the command reply is enabled/disabled (according to
+`enable`) starting with the current command. For example, `enable=0`
+and `now=1` means that the reply is disabled for this command too,
+while `enable=0` and `now=0` means that a reply will be send for this
+command, but not for the next ones (until enabled back with another
+*KVMI_CONTROL_CMD_RESPONSE*).
+
+This command is used by the introspection tool to disable the replies
+for commands returning an error code only (eg. *KVMI_SET_REGISTERS*)
+when an error is less likely to happen. For example, the following
+commands can be used to reply to an event with a single `write()` call:
+
+	KVMI_CONTROL_CMD_RESPONSE enable=0 now=1
+	KVMI_SET_REGISTERS vcpu=N
+	KVMI_EVENT_REPLY   vcpu=N
+	KVMI_CONTROL_CMD_RESPONSE enable=1 now=0
+
+While the command reply is disabled:
+
+* the socket will be closed on any command for which the reply should
+  contain more than just an error code (eg. *KVMI_GET_REGISTERS*)
+
+* the reply status is ignored for any unsupported/unknown or disallowed
+  commands (and ``struct kvmi_error_code`` will be sent with -KVM_EOPNOTSUPP
+  or -KVM_PERM).
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 9574ba0b9565..a1ab39c5b8e0 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -83,4 +83,11 @@ struct kvmi_get_version_reply {
 	__u32 padding;
 };
 
+struct kvmi_control_cmd_response {
+	__u8 enable;
+	__u8 now;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 76119a4b69d8..157f765fb34d 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -85,6 +85,8 @@ struct kvmi {
 
 	DECLARE_BITMAP(cmd_allow_mask, KVMI_NUM_COMMANDS);
 	DECLARE_BITMAP(event_allow_mask, KVMI_NUM_EVENTS);
+
+	bool cmd_reply_disabled;
 };
 
 /* kvmi_msg.c */
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 6fe04de29f7e..ea5c7e23669a 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -9,6 +9,7 @@
 #include "kvmi_int.h"
 
 static const char *const msg_IDs[] = {
+	[KVMI_CONTROL_CMD_RESPONSE]  = "KVMI_CONTROL_CMD_RESPONSE",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 };
 
@@ -130,6 +131,36 @@ static int kvmi_msg_vm_reply(struct kvmi *ikvm,
 	return kvmi_msg_reply(ikvm, msg, err, rpl, rpl_size);
 }
 
+static bool kvmi_validate_no_reply(struct kvmi *ikvm,
+				   const struct kvmi_msg_hdr *msg,
+				   size_t rpl_size, int err)
+{
+	if (rpl_size) {
+		kvmi_err(ikvm, "Reply disabled for command %d", msg->id);
+		return false;
+	}
+
+	if (err)
+		kvmi_warn(ikvm, "Error code %d discarded for message id %d\n",
+			  err, msg->id);
+
+	return true;
+}
+
+static int kvmi_msg_vm_maybe_reply(struct kvmi *ikvm,
+				   const struct kvmi_msg_hdr *msg,
+				   int err, const void *rpl,
+				   size_t rpl_size)
+{
+	if (ikvm->cmd_reply_disabled) {
+		if (!kvmi_validate_no_reply(ikvm, msg, rpl_size, err))
+			return -KVM_EINVAL;
+		return 0;
+	}
+
+	return kvmi_msg_vm_reply(ikvm, msg, err, rpl, rpl_size);
+}
+
 static int handle_get_version(struct kvmi *ikvm,
 			      const struct kvmi_msg_hdr *msg, const void *req)
 {
@@ -146,11 +177,37 @@ static bool is_command_allowed(struct kvmi *ikvm, int id)
 	return test_bit(id, ikvm->cmd_allow_mask);
 }
 
+static int handle_control_cmd_response(struct kvmi *ikvm,
+					const struct kvmi_msg_hdr *msg,
+					const void *_req)
+{
+	const struct kvmi_control_cmd_response *req = _req;
+	bool disabled, now;
+	int err;
+
+	if (req->padding1 || req->padding2)
+		return -KVM_EINVAL;
+
+	disabled = !req->enable;
+	now = (req->now == 1);
+
+	if (now)
+		ikvm->cmd_reply_disabled = disabled;
+
+	err = kvmi_msg_vm_maybe_reply(ikvm, msg, 0, NULL, 0);
+
+	if (!now)
+		ikvm->cmd_reply_disabled = disabled;
+
+	return err;
+}
+
 /*
  * These commands are executed on the receiving thread/worker.
  */
 static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 			    const void *) = {
+	[KVMI_CONTROL_CMD_RESPONSE]  = handle_control_cmd_response,
 	[KVMI_GET_VERSION]           = handle_get_version,
 };
 
