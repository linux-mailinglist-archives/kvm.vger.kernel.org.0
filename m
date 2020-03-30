Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F26C197935
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgC3KWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:22:16 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43774 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729178AbgC3KTx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:53 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0054F307503D;
        Mon, 30 Mar 2020 13:12:55 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DC092305B7A2;
        Mon, 30 Mar 2020 13:12:54 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 40/81] KVM: introspection: add permission access ioctls
Date:   Mon, 30 Mar 2020 13:12:27 +0300
Message-Id: <20200330101308.21702-41-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_INTROSPECTION_COMMAND and KVM_INTROSPECTION_EVENTS ioctls
are used by userspace to allow access for specific (or all)
introspection commands and events.

By default, all events and almost all commands are disallowed.
Some commands, those querying the introspection capabilities,
are always allowed.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.rst                |  72 +++++++++++++
 include/linux/kvmi_host.h                     |   7 ++
 include/uapi/linux/kvm.h                      |   8 ++
 include/uapi/linux/kvmi.h                     |   8 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  28 +++++
 virt/kvm/introspection/kvmi.c                 | 101 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |   6 ++
 7 files changed, 230 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3ff42e5e6d63..4d81a2f2f8f7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4699,6 +4699,78 @@ the KVM_CHECK_EXTENSION ioctl() at run-time.
 This ioctl is used to free all introspection structures
 related to this VM.
 
+Errors:
+
+  ======     ================================
+  EFAULT     the introspection is not enabled
+  ======     ================================
+
+4.127 KVM_INTROSPECTION_COMMAND
+-------------------------------
+
+:Capability: KVM_CAP_INTROSPECTION
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_introspection_feature (in)
+:Returns: 0 on success, a negative value on error
+
+Errors:
+
+  ======     =======================================================
+  EFAULT     the introspection is not enabled
+  EINVAL     the command is unknown
+  EPERM      the command can't be disallowed (e.g. KVMI_GET_VERSION)
+  ======     =======================================================
+
+This ioctl is used to allow or disallow introspection commands
+for the current VM. By default, almost all commands are disallowed
+except for those used to query the API.
+
+::
+
+  struct kvm_introspection_feature {
+	__u32 allow;
+	__s32 id;
+  };
+
+If allow is 1, the command specified by id is allowed. If allow is 0,
+the command is disallowed.
+
+Unless set to -1 (meaning all commands), id must be a command ID
+(e.g. KVMI_GET_VERSION)
+
+4.128 KVM_INTROSPECTION_EVENT
+-----------------------------
+
+:Capability: KVM_CAP_INTROSPECTION
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_introspection_feature (in)
+:Returns: 0 on success, a negative value on error
+
+Errors:
+
+  ======     ====================
+  EFAULT     the introspection is not enabled
+  EINVAL     the event is unknown
+  ======     ====================
+
+This ioctl is used to allow or disallow introspection events
+for the current VM. By default, all events are disallowed.
+
+::
+
+  struct kvm_introspection_feature {
+	__u32 allow;
+	__s32 id;
+  };
+
+If allow is 1, the event specified by id is allowed. If allow is 0,
+the event is disallowed.
+
+Unless set to -1 (meaning all event), id must be a event ID
+(e.g. KVMI_EVENT_UNHOOK, KVMI_EVENT_CR, etc.)
+
 5. The kvm_run structure
 ========================
 
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
index 6d1076ed93a7..dd4ab88f0012 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1568,6 +1568,14 @@ struct kvm_introspection_hook {
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
index 100f05c518aa..d1d02e067393 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -33,15 +33,43 @@ void setup_socket(void)
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
index ecebb00b4245..95b08a40d814 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -184,3 +184,104 @@ void kvmi_destroy_vm(struct kvm *kvm)
 {
 	kvmi_unhook(kvm);
 }
+
+static int kvmi_ioctl_get_feature(void __user *argp, bool *allow, int *id,
+				  unsigned int nbits)
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
+	if (feat.id > 0 && feat.id >= nbits)
+		return -EINVAL;
+
+	*allow = feat.allow == 1;
+	*id = feat.id;
+
+	return 0;
+}
+
+static void kvmi_control_allowed_events(struct kvm_introspection *kvmi,
+					int id, bool allow)
+{
+	int all_events = -1;
+
+	if (allow) {
+		if (id == all_events)
+			bitmap_fill(kvmi->event_allow_mask, KVMI_NUM_EVENTS);
+		else
+			set_bit(id, kvmi->event_allow_mask);
+	} else {
+		if (id == all_events)
+			bitmap_zero(kvmi->event_allow_mask, KVMI_NUM_EVENTS);
+		else
+			clear_bit(id, kvmi->event_allow_mask);
+	}
+}
+
+int kvmi_ioctl_event(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_introspection *kvmi;
+	int err, id;
+	bool allow;
+
+	err = kvmi_ioctl_get_feature(argp, &allow, &id, KVMI_NUM_EVENTS);
+	if (err)
+		return err;
+
+	mutex_lock(&kvm->kvmi_lock);
+
+	kvmi = KVMI(kvm);
+	if (kvmi)
+		kvmi_control_allowed_events(kvmi, id, allow);
+	else
+		err = -EFAULT;
+
+	mutex_unlock(&kvm->kvmi_lock);
+	return err;
+}
+
+static void kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
+					  int id, bool allow)
+{
+	int all_commands = -1;
+
+	if (allow) {
+		if (id == all_commands)
+			bitmap_fill(kvmi->cmd_allow_mask, KVMI_NUM_COMMANDS);
+		else
+			set_bit(id, kvmi->cmd_allow_mask);
+	} else {
+		if (id == all_commands)
+			bitmap_zero(kvmi->cmd_allow_mask, KVMI_NUM_COMMANDS);
+		else
+			clear_bit(id, kvmi->cmd_allow_mask);
+	}
+}
+
+int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_introspection *kvmi;
+	int err, id;
+	bool allow;
+
+	err = kvmi_ioctl_get_feature(argp, &allow, &id, KVMI_NUM_COMMANDS);
+	if (err)
+		return err;
+
+	mutex_lock(&kvm->kvmi_lock);
+
+	kvmi = KVMI(kvm);
+	if (kvmi)
+		kvmi_control_allowed_commands(kvmi, id, allow);
+	else
+		err = -EFAULT;
+
+	mutex_unlock(&kvm->kvmi_lock);
+	return err;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 82634be560e6..4ca8625575bb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3590,6 +3590,12 @@ static long kvm_vm_ioctl(struct file *filp,
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
