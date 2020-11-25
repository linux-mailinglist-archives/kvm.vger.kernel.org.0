Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFB52C3C8B
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgKYJmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:05 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57134 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728304AbgKYJmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:02 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 23713305D460;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id EA19F3072785;
        Wed, 25 Nov 2020 11:35:48 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 39/81] KVM: introspection: add KVM_INTROSPECTION_PREUNHOOK
Date:   Wed, 25 Nov 2020 11:35:18 +0200
Message-Id: <20201125093600.2766-40-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In certain situations (when the guest has to be paused, suspended,
migrated, etc.), the device manager will use this new ioctl in order to
trigger the KVMI_VM_EVENT_UNHOOK event. If the event is sent successfully
(the VM has an active introspection channel), the device manager should
delay the action (pause/suspend/...) to give the introspection tool the
chance to remove its hooks (eg. breakpoints) while the guest is still
running. Once a timeout is reached or the introspection tool has closed
the socket, the device manager should resume the action.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.rst    | 28 ++++++++++++++++++++++++++++
 Documentation/virt/kvm/kvmi.rst   |  7 ++++---
 include/linux/kvmi_host.h         |  1 +
 include/uapi/linux/kvm.h          |  2 ++
 virt/kvm/introspection/kvmi.c     | 30 ++++++++++++++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h |  1 +
 virt/kvm/introspection/kvmi_msg.c |  5 +++++
 virt/kvm/kvm_main.c               |  5 +++++
 8 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f3698413ddab..e6544d94e040 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4946,6 +4946,34 @@ the event is disallowed.
 Unless set to -1 (meaning all events), id must be a event ID
 (e.g. KVMI_VM_EVENT_UNHOOK, KVMI_VCPU_EVENT_CR, etc.)
 
+4.131 KVM_INTROSPECTION_PREUNHOOK
+---------------------------------
+
+:Capability: KVM_CAP_INTROSPECTION
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: none
+:Returns: 0 on success, a negative value on error
+
+Errors:
+
+  ======     ============================================================
+  EFAULT     the VM is not introspected yet (use KVM_INTROSPECTION_HOOK)
+  ENOENT     the socket (passed with KVM_INTROSPECTION_HOOK) had an error
+  ENOENT     the introspection tool didn't subscribed
+             to this type of introspection event (unhook)
+  ======     ============================================================
+
+This ioctl is used to inform that the current VM is
+paused/suspended/migrated/etc.
+
+KVM should send an 'unhook' introspection event to the introspection tool.
+
+If this ioctl is successful, the userspace should give the
+introspection tool a chance to unhook the VM and then it should use
+KVM_INTROSPECTION_UNHOOK to make sure all the introspection structures
+are freed.
+
 5. The kvm_run structure
 ========================
 
diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 6f8583d4aeb2..33490bc9d1c1 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -183,9 +183,10 @@ becomes necessary to remove them before the guest is suspended, moved
 (migrated) or a snapshot with memory is created.
 
 The actions are normally performed by the device manager. In the case
-of QEMU, it will use another ioctl to notify the introspection tool and
-wait for a limited amount of time (a few seconds) for a confirmation that
-is OK to proceed (the introspection tool will close the connection).
+of QEMU, it will use the *KVM_INTROSPECTION_PREUNHOOK* ioctl to trigger
+the *KVMI_VM_EVENT_UNHOOK* event and wait for a limited amount of time (a
+few seconds) for a confirmation that is OK to proceed. The introspection
+tool will close the connection to signal this.
 
 Live migrations
 ---------------
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index a5ede07686b9..81eac9f53a3f 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -32,6 +32,7 @@ int kvmi_ioctl_command(struct kvm *kvm,
 		       const struct kvm_introspection_feature *feat);
 int kvmi_ioctl_event(struct kvm *kvm,
 		     const struct kvm_introspection_feature *feat);
+int kvmi_ioctl_preunhook(struct kvm *kvm);
 
 #else
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c69140893f68..a29fbdf93b84 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1661,6 +1661,8 @@ struct kvm_introspection_feature {
 #define KVM_INTROSPECTION_COMMAND _IOW(KVMIO, 0xca, struct kvm_introspection_feature)
 #define KVM_INTROSPECTION_EVENT   _IOW(KVMIO, 0xcb, struct kvm_introspection_feature)
 
+#define KVM_INTROSPECTION_PREUNHOOK  _IO(KVMIO, 0xcc)
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 9125e6c92ded..72dd41915048 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -383,3 +383,33 @@ int kvmi_ioctl_command(struct kvm *kvm,
 	mutex_unlock(&kvm->kvmi_lock);
 	return err;
 }
+
+static bool kvmi_unhook_event(struct kvm_introspection *kvmi)
+{
+	int err;
+
+	err = kvmi_msg_send_unhook(kvmi);
+
+	return !err;
+}
+
+int kvmi_ioctl_preunhook(struct kvm *kvm)
+{
+	struct kvm_introspection *kvmi;
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
+	if (!kvmi_unhook_event(kvmi))
+		err = -ENOENT;
+
+out:
+	mutex_unlock(&kvm->kvmi_lock);
+	return err;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 1e1d1fad4035..ef4850e8bfae 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -18,6 +18,7 @@ bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
+int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index f0f5058403dd..513681290305 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -260,3 +260,8 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi)
 out:
 	return err == 0;
 }
+
+int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
+{
+	return -1;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c7ea1a61c50e..f30d1bd9495a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4053,6 +4053,11 @@ static long kvm_vm_ioctl(struct file *filp,
 			r = kvmi_ioctl_command(kvm, &feat);
 		break;
 	}
+	case KVM_INTROSPECTION_PREUNHOOK:
+		r = -EPERM;
+		if (enable_introspection)
+			r = kvmi_ioctl_preunhook(kvm);
+		break;
 #endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
