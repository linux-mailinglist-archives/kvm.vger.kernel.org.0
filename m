Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230302C3CC1
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgKYJm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:58 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57138 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727630AbgKYJl6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:58 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C2264305D464;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A080C3072785;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 43/81] KVM: introspection: add vCPU related data
Date:   Wed, 25 Nov 2020 11:35:22 +0200
Message-Id: <20201125093600.2766-44-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 38c398262913..360a57dd9019 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -2,6 +2,9 @@
 #ifndef _ASM_X86_KVMI_HOST_H
 #define _ASM_X86_KVMI_HOST_H
 
+struct kvm_vcpu_arch_introspection {
+};
+
 struct kvm_arch_introspection {
 };
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 51e6a4d7e5c9..60347c3a0e95 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -321,6 +321,7 @@ struct kvm_vcpu {
 	bool ready;
 	struct kvm_vcpu_arch arch;
 	struct kvm_dirty_ring dirty_ring;
+	struct kvm_vcpu_introspection *kvmi;
 };
 
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index a59307dac6bf..9b0008c66321 100644
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
@@ -45,6 +50,7 @@ static inline int kvmi_init(void) { return 0; }
 static inline void kvmi_uninit(void) { }
 static inline void kvmi_create_vm(struct kvm *kvm) { }
 static inline void kvmi_destroy_vm(struct kvm *kvm) { }
+static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 2bff4707cc57..358dc6c2a969 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -118,8 +118,41 @@ void kvmi_uninit(void)
 	kvmi_cache_destroy();
 }
 
+static bool kvmi_alloc_vcpui(struct kvm_vcpu *vcpu)
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
+static int kvmi_create_vcpui(struct kvm_vcpu *vcpu)
+{
+	if (!kvmi_alloc_vcpui(vcpu))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void kvmi_free_vcpui(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->kvmi);
+	vcpu->kvmi = NULL;
+}
+
 static void kvmi_free(struct kvm *kvm)
 {
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvmi_free_vcpui(vcpu);
+
 	bitmap_free(kvm->kvmi->cmd_allow_mask);
 	bitmap_free(kvm->kvmi->event_allow_mask);
 	bitmap_free(kvm->kvmi->vm_event_enable_mask);
@@ -128,10 +161,19 @@ static void kvmi_free(struct kvm *kvm)
 	kvm->kvmi = NULL;
 }
 
+void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	mutex_lock(&vcpu->kvm->kvmi_lock);
+	kvmi_free_vcpui(vcpu);
+	mutex_unlock(&vcpu->kvm->kvmi_lock);
+}
+
 static struct kvm_introspection *
 kvmi_alloc(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 {
 	struct kvm_introspection *kvmi;
+	struct kvm_vcpu *vcpu;
+	int i;
 
 	kvmi = kzalloc(sizeof(*kvmi), GFP_KERNEL);
 	if (!kvmi)
@@ -157,6 +199,15 @@ kvmi_alloc(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	atomic_set(&kvmi->ev_seq, 0);
 
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		int err = kvmi_create_vcpui(vcpu);
+
+		if (err) {
+			kvmi_free(kvm);
+			return NULL;
+		}
+	}
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f30d1bd9495a..55017a3f6283 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -418,6 +418,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvmi_vcpu_uninit(vcpu);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
 
@@ -3250,6 +3251,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
+	kvmi_vcpu_uninit(vcpu);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
 arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
