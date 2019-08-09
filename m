Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13F687F93
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437192AbfHIQUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53314 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437153AbfHIQUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 42DA8305D3CF;
        Fri,  9 Aug 2019 19:00:53 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id EF259305B7A1;
        Fri,  9 Aug 2019 19:00:52 +0300 (EEST)
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
Subject: [RFC PATCH v6 03/92] kvm: introspection: add permission access ioctls
Date:   Fri,  9 Aug 2019 18:59:18 +0300
Message-Id: <20190809160047.8319-4-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_INTROSPECTION_COMMAND and KVM_INTROSPECTION_EVENTS should be used
by userspace/QEMU to allow access to specific (or all) introspection
commands and events.

By default, all introspection events and almost all introspection commands
are disallowed. There are a couple of commands that are always allowed
(those querying the introspection capabilities).

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/api.txt | 56 +++++++++++++++++++-
 include/uapi/linux/kvm.h          |  6 +++
 virt/kvm/kvm_main.c               |  6 +++
 virt/kvm/kvmi.c                   | 85 +++++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h               | 51 +++++++++++++++++++
 5 files changed, 203 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 28d4429f9ae9..ea3135d365c7 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3889,7 +3889,61 @@ It will fail with -EINVAL if padding is not zero.
 The KVMI version can be retrieved using the KVM_CAP_INTROSPECTION of
 the KVM_CHECK_EXTENSION ioctl() at run-time.
 
-4.997 KVM_INTROSPECTION_UNHOOK
+4.997 KVM_INTROSPECTION_COMMAND
+
+Capability: KVM_CAP_INTROSPECTION
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_introspection_feature (in)
+Returns: 0 on success, a negative value on error
+
+This ioctl is used to allow or disallow introspection commands
+for the current VM. By default, almost all commands are disallowed
+except for those used to query the API.
+
+struct kvm_introspection_feature {
+	__u32 allow;
+	__s32 id;
+};
+
+If allow is 1, the command specified by id is allowed. If allow is 0,
+the command is disallowed.
+
+Unless set to -1 (meaning all commands), id must be a command ID
+(e.g. KVMI_GET_VERSION, KVMI_GET_GUEST_INFO etc.)
+
+Errors:
+
+  -EINVAL if the command is unknown
+  -EPERM if the command can't be disallowed (e.g. KVMI_GET_VERSION)
+
+4.998 KVM_INTROSPECTION_EVENT
+
+Capability: KVM_CAP_INTROSPECTION
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_introspection_feature (in)
+Returns: 0 on success, a negative value on error
+
+This ioctl is used to allow or disallow introspection events
+for the current VM. By default, all events are disallowed.
+
+struct kvm_introspection_feature {
+	__u32 allow;
+	__s32 id;
+};
+
+If allow is 1, the event specified by id is allowed. If allow is 0,
+the event is disallowed.
+
+Unless set to -1 (meaning all event), id must be a event ID
+(e.g. KVMI_EVENT_UNHOOK, KVMI_EVENT_CR, etc.)
+
+Errors:
+
+  -EINVAL if the event is unknown
+
+4.999 KVM_INTROSPECTION_UNHOOK
 
 Capability: KVM_CAP_INTROSPECTION
 Architectures: x86
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index bae37bf37338..2ff05fd123e3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1527,9 +1527,15 @@ struct kvm_introspection {
 	__u32 padding;
 	__u8 uuid[16];
 };
+struct kvm_introspection_feature {
+	__u32 allow;
+	__s32 id;
+};
 #define KVM_INTROSPECTION_HOOK    _IOW(KVMIO, 0xff, struct kvm_introspection)
 #define KVM_INTROSPECTION_UNHOOK  _IO(KVMIO, 0xfe)
 /* write true on force-reset, false otherwise */
+#define KVM_INTROSPECTION_COMMAND _IOW(KVMIO, 0xfd, struct kvm_introspection_feature)
+#define KVM_INTROSPECTION_EVENT   _IOW(KVMIO, 0xfc, struct kvm_introspection_feature)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 09a930ac007d..8399b826f2d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3270,6 +3270,12 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_INTROSPECTION_HOOK:
 		r = kvmi_ioctl_hook(kvm, argp);
 		break;
+	case KVM_INTROSPECTION_COMMAND:
+		r = kvmi_ioctl_command(kvm, argp);
+		break;
+	case KVM_INTROSPECTION_EVENT:
+		r = kvmi_ioctl_event(kvm, argp);
+		break;
 	case KVM_INTROSPECTION_UNHOOK:
 		r = kvmi_ioctl_unhook(kvm, arg);
 		break;
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 591f6ee22135..dc64f975998f 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -169,6 +169,91 @@ int kvmi_ioctl_hook(struct kvm *kvm, void __user *argp)
 	return kvmi_hook(kvm, &i);
 }
 
+static int kvmi_ioctl_get_feature(void __user *argp, bool *allow, int *id,
+				  unsigned long *bitmask)
+{
+	struct kvm_introspection_feature feat;
+	int all_bits = -1;
+
+	if (copy_from_user(&feat, argp, sizeof(feat)))
+		return -EFAULT;
+
+	if (feat.id < 0 && feat.id != all_bits)
+		return -EINVAL;
+
+	*allow = !!(feat.allow & 1);
+	*id = feat.id;
+	*bitmask = *id == all_bits ? -1 : BIT(feat.id);
+
+	return 0;
+}
+
+static int kvmi_ioctl_feature(struct kvm *kvm,
+			      bool allow, unsigned long *requested,
+			      size_t off_dest, unsigned int nbits)
+{
+	unsigned long *dest;
+	struct kvmi *ikvm;
+
+	if (bitmap_empty(requested, nbits))
+		return -EINVAL;
+
+	ikvm = kvmi_get(kvm);
+	if (!ikvm)
+		return -EFAULT;
+
+	dest = (unsigned long *)((char *)ikvm + off_dest);
+
+	if (allow)
+		bitmap_or(dest, dest, requested, nbits);
+	else
+		bitmap_andnot(dest, dest, requested, nbits);
+
+	kvmi_put(kvm);
+
+	return 0;
+}
+
+int kvmi_ioctl_event(struct kvm *kvm, void __user *argp)
+{
+	DECLARE_BITMAP(requested, KVMI_NUM_EVENTS);
+	DECLARE_BITMAP(known, KVMI_NUM_EVENTS);
+	bool allow;
+	int err;
+	int id;
+
+	err = kvmi_ioctl_get_feature(argp, &allow, &id, requested);
+	if (err)
+		return err;
+
+	bitmap_from_u64(known, KVMI_KNOWN_EVENTS);
+	bitmap_and(requested, requested, known, KVMI_NUM_EVENTS);
+
+	return kvmi_ioctl_feature(kvm, allow, requested,
+				  offsetof(struct kvmi, event_allow_mask),
+				  KVMI_NUM_EVENTS);
+}
+
+int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
+{
+	DECLARE_BITMAP(requested, KVMI_NUM_COMMANDS);
+	DECLARE_BITMAP(known, KVMI_NUM_COMMANDS);
+	bool allow;
+	int err;
+	int id;
+
+	err = kvmi_ioctl_get_feature(argp, &allow, &id, requested);
+	if (err)
+		return err;
+
+	bitmap_from_u64(known, KVMI_KNOWN_COMMANDS);
+	bitmap_and(requested, requested, known, KVMI_NUM_COMMANDS);
+
+	return kvmi_ioctl_feature(kvm, allow, requested,
+				  offsetof(struct kvmi, cmd_allow_mask),
+				  KVMI_NUM_COMMANDS);
+}
+
 void kvmi_create_vm(struct kvm *kvm)
 {
 	init_completion(&kvm->kvmi_completed);
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 9bc5205c8714..bd8b539e917a 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -23,6 +23,54 @@
 #define kvmi_err(ikvm, fmt, ...) \
 	kvm_info("%pU ERROR: " fmt, &ikvm->uuid, ## __VA_ARGS__)
 
+#define KVMI_KNOWN_VCPU_EVENTS ( \
+		BIT(KVMI_EVENT_CR) | \
+		BIT(KVMI_EVENT_MSR) | \
+		BIT(KVMI_EVENT_XSETBV) | \
+		BIT(KVMI_EVENT_BREAKPOINT) | \
+		BIT(KVMI_EVENT_HYPERCALL) | \
+		BIT(KVMI_EVENT_PF) | \
+		BIT(KVMI_EVENT_TRAP) | \
+		BIT(KVMI_EVENT_DESCRIPTOR) | \
+		BIT(KVMI_EVENT_PAUSE_VCPU) | \
+		BIT(KVMI_EVENT_SINGLESTEP))
+
+#define KVMI_KNOWN_VM_EVENTS ( \
+		BIT(KVMI_EVENT_CREATE_VCPU) | \
+		BIT(KVMI_EVENT_UNHOOK))
+
+#define KVMI_KNOWN_EVENTS (KVMI_KNOWN_VCPU_EVENTS | KVMI_KNOWN_VM_EVENTS)
+
+#define KVMI_KNOWN_COMMANDS ( \
+		BIT(KVMI_GET_VERSION) | \
+		BIT(KVMI_CHECK_COMMAND) | \
+		BIT(KVMI_CHECK_EVENT) | \
+		BIT(KVMI_GET_GUEST_INFO) | \
+		BIT(KVMI_PAUSE_VCPU) | \
+		BIT(KVMI_CONTROL_VM_EVENTS) | \
+		BIT(KVMI_CONTROL_EVENTS) | \
+		BIT(KVMI_CONTROL_CR) | \
+		BIT(KVMI_CONTROL_MSR) | \
+		BIT(KVMI_CONTROL_VE) | \
+		BIT(KVMI_GET_REGISTERS) | \
+		BIT(KVMI_SET_REGISTERS) | \
+		BIT(KVMI_GET_CPUID) | \
+		BIT(KVMI_GET_XSAVE) | \
+		BIT(KVMI_READ_PHYSICAL) | \
+		BIT(KVMI_WRITE_PHYSICAL) | \
+		BIT(KVMI_INJECT_EXCEPTION) | \
+		BIT(KVMI_GET_PAGE_ACCESS) | \
+		BIT(KVMI_SET_PAGE_ACCESS) | \
+		BIT(KVMI_GET_MAP_TOKEN) | \
+		BIT(KVMI_CONTROL_SPP) | \
+		BIT(KVMI_GET_PAGE_WRITE_BITMAP) | \
+		BIT(KVMI_SET_PAGE_WRITE_BITMAP) | \
+		BIT(KVMI_GET_MTRR_TYPE) | \
+		BIT(KVMI_CONTROL_CMD_RESPONSE) | \
+		BIT(KVMI_GET_VCPU_INFO))
+
+#define KVMI_NUM_COMMANDS KVMI_NEXT_AVAILABLE_COMMAND
+
 #define IKVM(kvm) ((struct kvmi *)((kvm)->kvmi))
 
 struct kvmi {
@@ -32,6 +80,9 @@ struct kvmi {
 	struct task_struct *recv;
 
 	uuid_t uuid;
+
+	DECLARE_BITMAP(cmd_allow_mask, KVMI_NUM_COMMANDS);
+	DECLARE_BITMAP(event_allow_mask, KVMI_NUM_EVENTS);
 };
 
 /* kvmi_msg.c */
