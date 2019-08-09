Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087A687F9E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437203AbfHIQUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:16 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53322 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407405AbfHIQUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DB299305D3D2;
        Fri,  9 Aug 2019 19:00:55 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 631DF305B7A0;
        Fri,  9 Aug 2019 19:00:55 +0300 (EEST)
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>
Subject: [RFC PATCH v6 11/92] kvm: introspection: add vCPU related data
Date:   Fri,  9 Aug 2019 18:59:26 +0300
Message-Id: <20190809160047.8319-12-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>

An opaque pointer is added to struct kvm_vcpu, pointing to its
coresponding introspection structure, allocated (a) when the introspection
socket is connected or (b) when the vCPU is hotpluged and deallocated
when the introspection socket is disconnected.

Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/kvm_host.h |  1 +
 include/linux/kvmi.h     |  4 +++
 virt/kvm/kvm_main.c      |  8 +++++
 virt/kvm/kvmi.c          | 73 +++++++++++++++++++++++++++++++++++++++-
 virt/kvm/kvmi_int.h      |  5 +++
 5 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 582b0187f5a4..1ec04384fad3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -275,6 +275,7 @@ struct kvm_vcpu {
 	bool preempted;
 	struct kvm_vcpu_arch arch;
 	struct dentry *debugfs_dentry;
+	void *kvmi;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index 4ca9280e4419..e8d25d7da751 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -14,6 +14,8 @@ int kvmi_ioctl_hook(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_command(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset);
+int kvmi_vcpu_init(struct kvm_vcpu *vcpu);
+void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -21,6 +23,8 @@ static inline int kvmi_init(void) { return 0; }
 static inline void kvmi_uninit(void) { }
 static inline void kvmi_create_vm(struct kvm *kvm) { }
 static inline void kvmi_destroy_vm(struct kvm *kvm) { }
+static inline int kvmi_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
+static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8399b826f2d2..94f15f393e37 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -316,6 +316,13 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	r = kvm_arch_vcpu_init(vcpu);
 	if (r < 0)
 		goto fail_free_run;
+
+	r = kvmi_vcpu_init(vcpu);
+	if (r < 0) {
+		kvm_arch_vcpu_uninit(vcpu);
+		goto fail_free_run;
+	}
+
 	return 0;
 
 fail_free_run:
@@ -333,6 +340,7 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 	 * descriptors are already gone.
 	 */
 	put_pid(rcu_dereference_protected(vcpu->pid, 1));
+	kvmi_vcpu_uninit(vcpu);
 	kvm_arch_vcpu_uninit(vcpu);
 	free_page((unsigned long)vcpu->run);
 }
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 961e6cc13fb6..860574039221 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -80,6 +80,19 @@ static bool alloc_kvmi(struct kvm *kvm, const struct kvm_introspection *qemu)
 	return true;
 }
 
+static bool alloc_ivcpu(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu;
+
+	ivcpu = kzalloc(sizeof(*ivcpu), GFP_KERNEL);
+	if (!ivcpu)
+		return false;
+
+	vcpu->kvmi = ivcpu;
+
+	return true;
+}
+
 struct kvmi * __must_check kvmi_get(struct kvm *kvm)
 {
 	if (refcount_inc_not_zero(&kvm->kvmi_ref))
@@ -90,8 +103,16 @@ struct kvmi * __must_check kvmi_get(struct kvm *kvm)
 
 static void kvmi_destroy(struct kvm *kvm)
 {
+	struct kvm_vcpu *vcpu;
+	int i;
+
 	kfree(kvm->kvmi);
 	kvm->kvmi = NULL;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		kfree(vcpu->kvmi);
+		vcpu->kvmi = NULL;
+	}
 }
 
 static void kvmi_release(struct kvm *kvm)
@@ -109,6 +130,48 @@ void kvmi_put(struct kvm *kvm)
 		kvmi_release(kvm);
 }
 
+/*
+ * VCPU hotplug - this function will likely be called before VCPU will start
+ * executing code
+ */
+int kvmi_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+	int ret = 0;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return 0;
+
+	if (!alloc_ivcpu(vcpu)) {
+		kvmi_err(ikvm, "Unable to alloc ivcpu for vcpu_id %u\n",
+			 vcpu->vcpu_id);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+out:
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+/*
+ * VCPU hotplug - this function will likely be called after VCPU will stop
+ * executing code
+ */
+void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Under certain circumstances (errors in creating the VCPU, hotplug?)
+	 * this function may be reached with the KVMI member still allocated.
+	 * This VCPU won't be reachable by the introspection engine, so no
+	 * protection is necessary when de-allocating.
+	 */
+	kfree(vcpu->kvmi);
+	vcpu->kvmi = NULL;
+}
+
 static void kvmi_end_introspection(struct kvmi *ikvm)
 {
 	struct kvm *kvm = ikvm->kvm;
@@ -142,8 +205,9 @@ static int kvmi_recv(void *arg)
 
 int kvmi_hook(struct kvm *kvm, const struct kvm_introspection *qemu)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvmi *ikvm;
-	int err = 0;
+	int i, err = 0;
 
 	/* wait for the previous introspection to finish */
 	err = wait_for_completion_killable(&kvm->kvmi_completed);
@@ -159,6 +223,13 @@ int kvmi_hook(struct kvm *kvm, const struct kvm_introspection *qemu)
 	}
 	ikvm = IKVM(kvm);
 
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!alloc_ivcpu(vcpu)) {
+			err = -ENOMEM;
+			goto err_alloc;
+		}
+	}
+
 	/* interact with other kernel components after structure allocation */
 	if (!kvmi_sock_get(ikvm, qemu->fd)) {
 		err = -EINVAL;
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 84ba43bd9a9d..8739a3435893 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -23,6 +23,8 @@
 #define kvmi_err(ikvm, fmt, ...) \
 	kvm_info("%pU ERROR: " fmt, &ikvm->uuid, ## __VA_ARGS__)
 
+#define IVCPU(vcpu) ((struct kvmi_vcpu *)((vcpu)->kvmi))
+
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
 
 #define KVMI_KNOWN_VCPU_EVENTS ( \
@@ -73,6 +75,9 @@
 
 #define KVMI_NUM_COMMANDS KVMI_NEXT_AVAILABLE_COMMAND
 
+struct kvmi_vcpu {
+};
+
 #define IKVM(kvm) ((struct kvmi *)((kvm)->kvmi))
 
 struct kvmi {
