Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AF587EFF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437048AbfHIQJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:09:57 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52684 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437001AbfHIQJ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:09:56 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C03DD301AB36;
        Fri,  9 Aug 2019 19:00:53 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 82DC0305B7A0;
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
Subject: [RFC PATCH v6 05/92] kvm: introspection: add KVMI_GET_VERSION
Date:   Fri,  9 Aug 2019 18:59:20 +0300
Message-Id: <20190809160047.8319-6-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command should be used by the introspection tool to identify the
commands/events supported by the KVMi subsystem and, most important,
what messages must be used for event replies. The kernel side will accept
smaller or bigger command messages, but it can be more strict with bigger
event reply messages.

The command is always allowed and any attempt from userspace to disallow it
through KVM_INTROSPECTION_COMMAND will get -EPERM (unless userspace choose
to disable all commands, using id=-1, in which case KVMI_GET_VERSION is
quietly allowed, without an error).

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 28 ++++++++++++++++++++++++++++
 include/uapi/linux/kvmi.h          |  5 +++++
 virt/kvm/kvmi.c                    | 14 ++++++++++++++
 virt/kvm/kvmi_msg.c                | 13 +++++++++++++
 4 files changed, 60 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 1d4a1dcd7d2f..0f296e3c4244 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -224,3 +224,31 @@ device-specific memory (DMA, emulated MMIO, reserved by a passthrough
 device etc.). It is up to the user to determine, using the guest operating
 system data structures, the areas that are safe to access (code, stack, heap
 etc.).
+
+Commands
+--------
+
+The following C structures are meant to be used directly when communicating
+over the wire. The peer that detects any size mismatch should simply close
+the connection and report the error.
+
+1. KVMI_GET_VERSION
+-------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters: none
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_get_version_reply {
+		__u32 version;
+		__u32 padding;
+	};
+
+Returns the introspection API version.
+
+This command is always allowed and successful (if the introspection is
+built in kernel).
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 6c7600ed4564..9574ba0b9565 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -78,4 +78,9 @@ struct kvmi_error_code {
 	__u32 padding;
 };
 
+struct kvmi_get_version_reply {
+	__u32 version;
+	__u32 padding;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index afa31748d7f4..d5b6af21564e 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -68,6 +68,8 @@ static bool alloc_kvmi(struct kvm *kvm, const struct kvm_introspection *qemu)
 	if (!ikvm)
 		return false;
 
+	set_bit(KVMI_GET_VERSION, ikvm->cmd_allow_mask);
+
 	memcpy(&ikvm->uuid, &qemu->uuid, sizeof(ikvm->uuid));
 
 	ikvm->kvm = kvm;
@@ -290,6 +292,18 @@ int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
 	bitmap_from_u64(known, KVMI_KNOWN_COMMANDS);
 	bitmap_and(requested, requested, known, KVMI_NUM_COMMANDS);
 
+	if (!allow) {
+		DECLARE_BITMAP(always_allowed, KVMI_NUM_COMMANDS);
+
+		if (id == KVMI_GET_VERSION)
+			return -EPERM;
+
+		set_bit(KVMI_GET_VERSION, always_allowed);
+
+		bitmap_andnot(requested, requested, always_allowed,
+			      KVMI_NUM_COMMANDS);
+	}
+
 	return kvmi_ioctl_feature(kvm, allow, requested,
 				  offsetof(struct kvmi, cmd_allow_mask),
 				  KVMI_NUM_COMMANDS);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index af6bc47dc031..6fe04de29f7e 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -9,6 +9,7 @@
 #include "kvmi_int.h"
 
 static const char *const msg_IDs[] = {
+	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 };
 
 static bool is_known_message(u16 id)
@@ -129,6 +130,17 @@ static int kvmi_msg_vm_reply(struct kvmi *ikvm,
 	return kvmi_msg_reply(ikvm, msg, err, rpl, rpl_size);
 }
 
+static int handle_get_version(struct kvmi *ikvm,
+			      const struct kvmi_msg_hdr *msg, const void *req)
+{
+	struct kvmi_get_version_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	rpl.version = KVMI_VERSION;
+
+	return kvmi_msg_vm_reply(ikvm, msg, 0, &rpl, sizeof(rpl));
+}
+
 static bool is_command_allowed(struct kvmi *ikvm, int id)
 {
 	return test_bit(id, ikvm->cmd_allow_mask);
@@ -139,6 +151,7 @@ static bool is_command_allowed(struct kvmi *ikvm, int id)
  */
 static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 			    const void *) = {
+	[KVMI_GET_VERSION]           = handle_get_version,
 };
 
 static bool is_vm_message(u16 id)
