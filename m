Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06945228A7E
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731239AbgGUVQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37790 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731195AbgGUVQA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5DE79305D61C;
        Wed, 22 Jul 2020 00:09:26 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 283C4304FA14;
        Wed, 22 Jul 2020 00:09:26 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 47/84] KVM: introspection: add vCPU related data
Date:   Wed, 22 Jul 2020 00:08:45 +0300
Message-Id: <20200721210922.7646-48-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>

Add an introspection structure to all vCPUs when the VM is hooked.

Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  3 ++
 include/linux/kvm_host.h         |  1 +
 include/linux/kvmi_host.h        |  6 ++++
 virt/kvm/introspection/kvmi.c    | 51 ++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c              |  2 ++
 5 files changed, 63 insertions(+)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 747f3d779e15..05ade3a16b24 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -4,6 +4,9 @@
 
 #include <asm/kvmi.h>
 
+struct kvm_vcpu_arch_introspection {
+};
+
 struct kvm_arch_introspection {
 };
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c82c55085604..8509d8272466 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -319,6 +319,7 @@ struct kvm_vcpu {
 	bool preempted;
 	bool ready;
 	struct kvm_vcpu_arch arch;
+	struct kvm_vcpu_introspection *kvmi;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 8e142096ba47..f96a9a3cfdd4 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -6,6 +6,10 @@
 
 #include <asm/kvmi_host.h>
 
+struct kvm_vcpu_introspection {
+	struct kvm_vcpu_arch_introspection arch;
+};
+
 struct kvm_introspection {
 	struct kvm_arch_introspection arch;
 	struct kvm *kvm;
@@ -28,6 +32,7 @@ int kvmi_init(void);
 void kvmi_uninit(void);
 void kvmi_create_vm(struct kvm *kvm);
 void kvmi_destroy_vm(struct kvm *kvm);
+void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 int kvmi_ioctl_hook(struct kvm *kvm,
 		    const struct kvm_introspection_hook *hook);
@@ -44,6 +49,7 @@ static inline int kvmi_init(void) { return 0; }
 static inline void kvmi_uninit(void) { }
 static inline void kvmi_create_vm(struct kvm *kvm) { }
 static inline void kvmi_destroy_vm(struct kvm *kvm) { }
+static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 354dea276347..a51e7342f837 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -107,8 +107,41 @@ void kvmi_uninit(void)
 	kvmi_cache_destroy();
 }
 
+static bool alloc_vcpui(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui;
+
+	vcpui = kzalloc(sizeof(*vcpui), GFP_KERNEL);
+	if (!vcpui)
+		return false;
+
+	vcpu->kvmi = vcpui;
+
+	return true;
+}
+
+static int create_vcpui(struct kvm_vcpu *vcpu)
+{
+	if (!alloc_vcpui(vcpu))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void free_vcpui(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->kvmi);
+	vcpu->kvmi = NULL;
+}
+
 static void free_kvmi(struct kvm *kvm)
 {
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		free_vcpui(vcpu);
+
 	bitmap_free(kvm->kvmi->cmd_allow_mask);
 	bitmap_free(kvm->kvmi->event_allow_mask);
 	bitmap_free(kvm->kvmi->vm_event_enable_mask);
@@ -117,10 +150,19 @@ static void free_kvmi(struct kvm *kvm)
 	kvm->kvmi = NULL;
 }
 
+void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	mutex_lock(&vcpu->kvm->kvmi_lock);
+	free_vcpui(vcpu);
+	mutex_unlock(&vcpu->kvm->kvmi_lock);
+}
+
 static struct kvm_introspection *
 alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 {
 	struct kvm_introspection *kvmi;
+	struct kvm_vcpu *vcpu;
+	int i;
 
 	kvmi = kzalloc(sizeof(*kvmi), GFP_KERNEL);
 	if (!kvmi)
@@ -146,6 +188,15 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	atomic_set(&kvmi->ev_seq, 0);
 
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		int err = create_vcpui(vcpu);
+
+		if (err) {
+			free_kvmi(kvm);
+			return NULL;
+		}
+	}
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 86910e6c8d93..1f199da03aa4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -366,6 +366,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvmi_vcpu_uninit(vcpu);
 	kvm_arch_vcpu_destroy(vcpu);
 
 	/*
@@ -3137,6 +3138,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
+	kvmi_vcpu_uninit(vcpu);
 	kvm_arch_vcpu_destroy(vcpu);
 vcpu_free_run_page:
 	free_page((unsigned long)vcpu->run);
