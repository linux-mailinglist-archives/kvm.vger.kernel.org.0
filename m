Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E011155DBB
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBGSSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:18:08 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40628 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727579AbgBGSQu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:50 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5D82A305D344;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 485443052075;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 38/78] KVM: introspection: add permission access ioctls
Date:   Fri,  7 Feb 2020 20:15:56 +0200
Message-Id: <20200207181636.1065-39-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_INTROSPECTION_COMMAND and KVM_INTROSPECTION_EVENTS ioctls should be
used by userspace to allow access for specific (or all) introspection
commands and events.

By default, all the introspection events and almost all the introspection
commands are disallowed. Some commands are always allowed, those querying
the introspection capabilities.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.txt                | 50 ++++++++++
 include/linux/kvmi_host.h                     |  7 ++
 include/uapi/linux/kvm.h                      |  8 ++
 include/uapi/linux/kvmi.h                     |  8 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 28 ++++++
 virt/kvm/introspection/kvmi.c                 | 92 +++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  4 +
 virt/kvm/kvm_main.c                           |  6 ++
 8 files changed, 203 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 540d9015d726..c1da0a67d7af 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4210,6 +4210,56 @@ Returns: 0 on success, a negative value on error
 This ioctl is used to free all introspection structures
 related to this VM.
 
+4.124 KVM_INTROSPECTION_COMMAND
+
+Capability: KVM_CAP_INTROSPECTION
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_introspection_feature (in)
+Returns: 0 on success, a negative value on error
+Errors:
+  EINVAL: the command is unknown
+  EPERM:  the command can't be disallowed (e.g. KVMI_GET_VERSION)
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
+(e.g. KVMI_GET_VERSION)
+
+4.125 KVM_INTROSPECTION_EVENT
+
+Capability: KVM_CAP_INTROSPECTION
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_introspection_feature (in)
+Returns: 0 on success, a negative value on error
+Errors:
+  EINVAL: the event is unknown
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
 5. The kvm_run structure
 ------------------------
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index c8b9c87ecff2..4e77a0227c08 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -8,6 +8,8 @@ struct kvm;
 
 #include <asm/kvmi_host.h>
 
+#define KVMI_NUM_COMMANDS KVMI_NUM_MESSAGES
+
 struct kvm_introspection {
 	struct kvm_arch_introspection arch;
 	struct kvm *kvm;
@@ -16,6 +18,9 @@ struct kvm_introspection {
 
 	struct socket *sock;
 	struct task_struct *recv;
+
+	DECLARE_BITMAP(cmd_allow_mask, KVMI_NUM_COMMANDS);
+	DECLARE_BITMAP(event_allow_mask, KVMI_NUM_EVENTS);
 };
 
 #ifdef CONFIG_KVM_INTROSPECTION
@@ -27,6 +32,8 @@ void kvmi_destroy_vm(struct kvm *kvm);
 
 int kvmi_ioctl_hook(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_unhook(struct kvm *kvm);
+int kvmi_ioctl_command(struct kvm *kvm, void __user *argp);
+int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
 
 #else
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 09132d8dd3e5..e2de987b5d8f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1563,6 +1563,14 @@ struct kvm_introspection_hook {
 #define KVM_INTROSPECTION_HOOK    _IOW(KVMIO, 0xc3, struct kvm_introspection_hook)
 #define KVM_INTROSPECTION_UNHOOK  _IO(KVMIO, 0xc4)
 
+struct kvm_introspection_feature {
+	__u32 allow;
+	__s32 id;
+};
+
+#define KVM_INTROSPECTION_COMMAND _IOW(KVMIO, 0xc5, struct kvm_introspection_feature)
+#define KVM_INTROSPECTION_EVENT   _IOW(KVMIO, 0xc6, struct kvm_introspection_feature)
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 34dda91016db..d7b18ffef4fa 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -10,4 +10,12 @@ enum {
 	KVMI_VERSION = 0x00000001
 };
 
+enum {
+	KVMI_NUM_MESSAGES
+};
+
+enum {
+	KVMI_NUM_EVENTS
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index cd8744ec6939..ea411611e296 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -31,15 +31,43 @@ void setup_socket(void)
 		errno, strerror(errno));
 }
 
+static void toggle_event_permission(struct kvm_vm *vm, __s32 id, bool allow)
+{
+	struct kvm_introspection_feature feat = {
+		.allow = allow ? 1 : 0,
+		.id = id
+	};
+	int r;
+
+	r = ioctl(vm->fd, KVM_INTROSPECTION_EVENT, &feat);
+	TEST_ASSERT(r == 0,
+		"KVM_INTROSPECTION_EVENT failed, id %d, errno %d (%s)\n",
+		id, errno, strerror(errno));
+}
+
+static void allow_event(struct kvm_vm *vm, __s32 event_id)
+{
+	toggle_event_permission(vm, event_id, true);
+}
+
 static void hook_introspection(struct kvm_vm *vm)
 {
+	__s32 all_IDs = -1;
 	struct kvm_introspection_hook hook = {.fd = Kvm_socket};
+	struct kvm_introspection_feature feat = {.allow = 1, .id = all_IDs};
 	int r;
 
 	r = ioctl(vm->fd, KVM_INTROSPECTION_HOOK, &hook);
 	TEST_ASSERT(r == 0,
 		"KVM_INTROSPECTION_HOOK failed, errno %d (%s)\n",
 		errno, strerror(errno));
+
+	r = ioctl(vm->fd, KVM_INTROSPECTION_COMMAND, &feat);
+	TEST_ASSERT(r == 0,
+		"KVM_INTROSPECTION_COMMAND failed, errno %d (%s)\n",
+		errno, strerror(errno));
+
+	allow_event(vm, all_IDs);
 }
 
 static void unhook_introspection(struct kvm_vm *vm)
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 7a009480517a..791d2536415e 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -171,3 +171,95 @@ void kvmi_destroy_vm(struct kvm *kvm)
 {
 	kvmi_unhook(kvm);
 }
+
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
+	struct kvm_introspection *kvmi;
+	unsigned long *dest;
+	int err = 0;
+
+	mutex_lock(&kvm->kvmi_lock);
+
+	kvmi = KVMI(kvm);
+	if (!kvmi) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	dest = (unsigned long *)((char *)kvmi + off_dest);
+
+	if (allow)
+		bitmap_or(dest, dest, requested, nbits);
+	else
+		bitmap_andnot(dest, dest, requested, nbits);
+
+out:
+	mutex_unlock(&kvm->kvmi_lock);
+
+	return err;
+}
+
+int kvmi_ioctl_event(struct kvm *kvm, void __user *argp)
+{
+	DECLARE_BITMAP(requested, KVMI_NUM_EVENTS);
+	DECLARE_BITMAP(known, KVMI_NUM_EVENTS);
+	size_t off_bitmap;
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
+	off_bitmap = offsetof(struct kvm_introspection, event_allow_mask);
+
+	return kvmi_ioctl_feature(kvm, allow, requested, off_bitmap,
+				  KVMI_NUM_EVENTS);
+}
+
+int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
+{
+	DECLARE_BITMAP(requested, KVMI_NUM_COMMANDS);
+	DECLARE_BITMAP(known, KVMI_NUM_COMMANDS);
+	size_t off_bitmap;
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
+	off_bitmap = offsetof(struct kvm_introspection, cmd_allow_mask);
+
+	return kvmi_ioctl_feature(kvm, allow, requested, off_bitmap,
+				  KVMI_NUM_COMMANDS);
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 01451d573788..c5cf40d03d68 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -16,6 +16,10 @@
 #define kvmi_err(kvmi, fmt, ...) \
 	kvm_info("%pU ERROR: " fmt, &kvmi->uuid, ## __VA_ARGS__)
 
+#define KVMI_KNOWN_EVENTS 0
+
+#define KVMI_KNOWN_COMMANDS 0
+
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
 
 /* kvmi_msg.c */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 77bab9ba918b..f5632a3a7fb3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3505,6 +3505,12 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_INTROSPECTION_UNHOOK:
 		r = kvmi_ioctl_unhook(kvm);
 		break;
+	case KVM_INTROSPECTION_COMMAND:
+		r = kvmi_ioctl_command(kvm, argp);
+		break;
+	case KVM_INTROSPECTION_EVENT:
+		r = kvmi_ioctl_event(kvm, argp);
+		break;
 #endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
