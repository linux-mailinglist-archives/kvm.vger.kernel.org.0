Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD90228ABE
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731460AbgGUVQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:38 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37846 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731366AbgGUVQQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:16 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D3231305D65A;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id BB380304FA13;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 39/84] KVM: introspection: add permission access ioctls
Date:   Wed, 22 Jul 2020 00:08:37 +0300
Message-Id: <20200721210922.7646-40-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_INTROSPECTION_COMMAND and KVM_INTROSPECTION_EVENTS ioctls are used
by the device manager to allow/disallow access to specific (or all)
introspection commands and events. The introspection tool will get the
KVM_EPERM error code on any attempt to use a disallowed command.

By default, all events and almost all commands are disallowed.
Some commands, those querying the introspection capabilities,
are always allowed.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.rst                |  66 ++++++++++
 include/linux/kvmi_host.h                     |   7 ++
 include/uapi/linux/kvm.h                      |   8 ++
 include/uapi/linux/kvmi.h                     |   8 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  48 +++++++
 virt/kvm/introspection/kvmi.c                 | 119 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  14 +++
 7 files changed, 270 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e34f20430eb1..174f13f2389d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4753,6 +4753,72 @@ Errors:
 This ioctl is used to free all introspection structures
 related to this VM.
 
+4.128 KVM_INTROSPECTION_COMMAND
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
+  ======     ===========================================================
+  EFAULT     the VM is not introspected yet (use KVM_INTROSPECTION_HOOK)
+  EINVAL     the command is unknown
+  EPERM      the command can't be disallowed (e.g. KVMI_GET_VERSION)
+  ======     ===========================================================
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
+4.129 KVM_INTROSPECTION_EVENT
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
+  ======     ===========================================================
+  EFAULT     the VM is not introspected yet (use KVM_INTROSPECTION_HOOK)
+  EINVAL     the event is unknown
+  ======     ===========================================================
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
+Unless set to -1 (meaning all events), id must be a event ID
+(e.g. KVMI_EVENT_UNHOOK, KVMI_EVENT_CR, etc.)
+
 5. The kvm_run structure
 ========================
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 55ff571db40d..7efd071e398d 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -14,6 +14,9 @@ struct kvm_introspection {
 
 	struct socket *sock;
 	struct task_struct *recv;
+
+	unsigned long *cmd_allow_mask;
+	unsigned long *event_allow_mask;
 };
 
 int kvmi_version(void);
@@ -25,6 +28,10 @@ void kvmi_destroy_vm(struct kvm *kvm);
 int kvmi_ioctl_hook(struct kvm *kvm,
 		    const struct kvm_introspection_hook *hook);
 int kvmi_ioctl_unhook(struct kvm *kvm);
+int kvmi_ioctl_command(struct kvm *kvm,
+		       const struct kvm_introspection_feature *feat);
+int kvmi_ioctl_event(struct kvm *kvm,
+		     const struct kvm_introspection_feature *feat);
 
 #else
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dd84ebdfcd6d..17df03ceb483 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1622,6 +1622,14 @@ struct kvm_introspection_hook {
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
index 08ca4701c440..09b8989317d7 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -48,14 +48,62 @@ static void do_hook_ioctl(struct kvm_vm *vm, __s32 fd, __u32 padding,
 		errno, strerror(errno), expected_err, fd, padding);
 }
 
+static void set_perm(struct kvm_vm *vm, __s32 id, __u32 allow,
+		     int expected_err, int ioctl_id,
+		     const char *ioctl_str)
+{
+	struct kvm_introspection_feature feat = {
+		.allow = allow,
+		.id = id
+	};
+	int r;
+
+	r = ioctl(vm->fd, ioctl_id, &feat);
+	TEST_ASSERT(r == 0 || errno == expected_err,
+		"%s failed, id %d, errno %d (%s), expected %d\n",
+		ioctl_str, id, errno, strerror(errno), expected_err);
+}
+
+static void set_event_perm(struct kvm_vm *vm, __s32 id, __u32 allow,
+			   int expected_err)
+{
+	set_perm(vm, id, allow, expected_err, KVM_INTROSPECTION_EVENT,
+		 "KVM_INTROSPECTION_EVENT");
+}
+
+static void allow_event(struct kvm_vm *vm, __s32 event_id)
+{
+	set_event_perm(vm, event_id, 1, 0);
+}
+
+static void set_command_perm(struct kvm_vm *vm, __s32 id, __u32 allow,
+			     int expected_err)
+{
+	set_perm(vm, id, allow, expected_err, KVM_INTROSPECTION_COMMAND,
+		 "KVM_INTROSPECTION_COMMAND");
+}
+
 static void hook_introspection(struct kvm_vm *vm)
 {
+	__u32 allow = 1, disallow = 0, allow_inval = 2;
 	__u32 padding = 1, no_padding = 0;
+	__s32 all_IDs = -1;
+
+	set_command_perm(vm, all_IDs, allow, EFAULT);
+	set_event_perm(vm, all_IDs, allow, EFAULT);
 
 	do_hook_ioctl(vm, Kvm_socket, padding, EINVAL);
 	do_hook_ioctl(vm, -1, no_padding, EINVAL);
 	do_hook_ioctl(vm, Kvm_socket, no_padding, 0);
 	do_hook_ioctl(vm, Kvm_socket, no_padding, EEXIST);
+
+	set_command_perm(vm, all_IDs, allow_inval, EINVAL);
+	set_command_perm(vm, all_IDs, disallow, 0);
+	set_command_perm(vm, all_IDs, allow, 0);
+
+	set_event_perm(vm, all_IDs, allow_inval, EINVAL);
+	set_event_perm(vm, all_IDs, disallow, 0);
+	allow_event(vm, all_IDs);
 }
 
 static void unhook_introspection(struct kvm_vm *vm)
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 5d9bc4ed5060..b1ea39f35481 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -8,6 +8,8 @@
 #include <linux/kthread.h>
 #include "kvmi_int.h"
 
+#define KVMI_NUM_COMMANDS KVMI_NUM_MESSAGES
+
 int kvmi_init(void)
 {
 	return 0;
@@ -24,6 +26,9 @@ void kvmi_uninit(void)
 
 static void free_kvmi(struct kvm *kvm)
 {
+	bitmap_free(kvm->kvmi->cmd_allow_mask);
+	bitmap_free(kvm->kvmi->event_allow_mask);
+
 	kfree(kvm->kvmi);
 	kvm->kvmi = NULL;
 }
@@ -37,6 +42,15 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	if (!kvmi)
 		return NULL;
 
+	kvmi->cmd_allow_mask = bitmap_zalloc(KVMI_NUM_COMMANDS, GFP_KERNEL);
+	kvmi->event_allow_mask = bitmap_zalloc(KVMI_NUM_EVENTS, GFP_KERNEL);
+	if (!kvmi->cmd_allow_mask || !kvmi->event_allow_mask) {
+		bitmap_free(kvmi->cmd_allow_mask);
+		bitmap_free(kvmi->event_allow_mask);
+		kfree(kvmi);
+		return NULL;
+	}
+
 	BUILD_BUG_ON(sizeof(hook->uuid) != sizeof(kvmi->uuid));
 	memcpy(&kvmi->uuid, &hook->uuid, sizeof(kvmi->uuid));
 
@@ -185,3 +199,108 @@ void kvmi_destroy_vm(struct kvm *kvm)
 {
 	kvmi_unhook(kvm);
 }
+
+static int
+kvmi_ioctl_get_feature(const struct kvm_introspection_feature *feat,
+		       bool *allow, s32 *id, unsigned int nbits)
+{
+	s32 all_bits = -1;
+
+	if (feat->id < 0 && feat->id != all_bits)
+		return -EINVAL;
+
+	if (feat->id > 0 && feat->id >= nbits)
+		return -EINVAL;
+
+	if (feat->allow > 1)
+		return -EINVAL;
+
+	*allow = feat->allow == 1;
+	*id = feat->id;
+
+	return 0;
+}
+
+static void kvmi_control_allowed_events(struct kvm_introspection *kvmi,
+					s32 id, bool allow)
+{
+	s32 all_events = -1;
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
+int kvmi_ioctl_event(struct kvm *kvm,
+		     const struct kvm_introspection_feature *feat)
+{
+	struct kvm_introspection *kvmi;
+	bool allow;
+	int err;
+	s32 id;
+
+	err = kvmi_ioctl_get_feature(feat, &allow, &id, KVMI_NUM_EVENTS);
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
+					  s32 id, bool allow)
+{
+	s32 all_commands = -1;
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
+int kvmi_ioctl_command(struct kvm *kvm,
+		       const struct kvm_introspection_feature *feat)
+{
+	struct kvm_introspection *kvmi;
+	bool allow;
+	int err;
+	s32 id;
+
+	err = kvmi_ioctl_get_feature(feat, &allow, &id, KVMI_NUM_COMMANDS);
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
index 0d2da77ccb12..9aeb57e93165 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3847,6 +3847,20 @@ static long kvm_vm_ioctl(struct file *filp,
 		else
 			r = -EPERM;
 		break;
+	case KVM_INTROSPECTION_COMMAND:
+	case KVM_INTROSPECTION_EVENT:
+		r = -EPERM;
+		if (enable_introspection) {
+			struct kvm_introspection_feature feat;
+
+			if (copy_from_user(&feat, argp, sizeof(feat)))
+				r = -EFAULT;
+			else if (ioctl == KVM_INTROSPECTION_EVENT)
+				r = kvmi_ioctl_event(kvm, &feat);
+			else
+				r = kvmi_ioctl_command(kvm, &feat);
+		}
+		break;
 #endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
