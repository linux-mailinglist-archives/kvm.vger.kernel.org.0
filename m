Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9AB228A99
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbgGUVQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:17 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37848 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731369AbgGUVQQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:16 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D28F0305D4F5;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AA87B304FA15;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 61/84] KVM: introspection: add cleanup support for vCPUs
Date:   Wed, 22 Jul 2020 00:08:59 +0300
Message-Id: <20200721210922.7646-62-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

On unhook the introspection channel is closed. This will signal the
receiving thread to call kvmi_put() and exit. There might be vCPU threads
handling introspection commands or waiting for event replies. These will
also call kvmi_put() and re-enter in guest. Once the reference counter
reaches zero, the structures keeping the introspection data will be freed.

In order to restore the interception of CRs, MSRs, BP, descriptor-table
registers, from all vCPUs (some of which might run from userspace),
we keep the needed information in another structure (kvmi_interception)
which will be used and freed by each of them before re-entering in guest.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h   |  3 ++
 arch/x86/include/asm/kvmi_host.h  |  4 +++
 arch/x86/kvm/kvmi.c               | 49 +++++++++++++++++++++++++++++++
 virt/kvm/introspection/kvmi.c     | 32 ++++++++++++++++++--
 virt/kvm/introspection/kvmi_int.h |  5 ++++
 5 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8a119fb7c623..acfcebce51dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -840,6 +840,9 @@ struct kvm_vcpu_arch {
 
 	/* #PF translated error code from EPT/NPT exit reason */
 	u64 error_code;
+
+	/* Control the interception for KVM Introspection */
+	struct kvmi_interception *kvmi;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 05ade3a16b24..6d274f173fb5 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -4,6 +4,10 @@
 
 #include <asm/kvmi.h>
 
+struct kvmi_interception {
+	bool restore_interception;
+};
+
 struct kvm_vcpu_arch_introspection {
 };
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index f13272350bc9..ca2ce7498cfe 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -290,3 +290,52 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 		kvmi_handle_common_event_actions(vcpu->kvm, action);
 	}
 }
+
+static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
+{
+}
+
+bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_interception *arch_vcpui = vcpu->arch.kvmi;
+
+	if (!arch_vcpui)
+		return false;
+
+	if (!arch_vcpui->restore_interception)
+		return false;
+
+	kvmi_arch_restore_interception(vcpu);
+
+	return true;
+}
+
+bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_interception *arch_vcpui;
+
+	arch_vcpui = kzalloc(sizeof(*arch_vcpui), GFP_KERNEL);
+	if (!arch_vcpui)
+		return false;
+
+	return true;
+}
+
+void kvmi_arch_vcpu_free_interception(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->arch.kvmi);
+	WRITE_ONCE(vcpu->arch.kvmi, NULL);
+}
+
+bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu)
+{
+	return !!READ_ONCE(vcpu->arch.kvmi);
+}
+
+void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_interception *arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+
+	if (arch_vcpui)
+		arch_vcpui->restore_interception = true;
+}
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index a5264696c630..083dd8be9252 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -197,7 +197,7 @@ static bool alloc_vcpui(struct kvm_vcpu *vcpu)
 
 	vcpu->kvmi = vcpui;
 
-	return true;
+	return kvmi_arch_vcpu_alloc_interception(vcpu);
 }
 
 static int create_vcpui(struct kvm_vcpu *vcpu)
@@ -231,6 +231,9 @@ static void free_vcpui(struct kvm_vcpu *vcpu)
 
 	kfree(vcpui);
 	vcpu->kvmi = NULL;
+
+	kvmi_arch_request_interception_cleanup(vcpu);
+	kvmi_make_request(vcpu, false);
 }
 
 static void free_kvmi(struct kvm *kvm)
@@ -253,6 +256,7 @@ void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	mutex_lock(&vcpu->kvm->kvmi_lock);
 	free_vcpui(vcpu);
+	kvmi_arch_vcpu_free_interception(vcpu);
 	mutex_unlock(&vcpu->kvm->kvmi_lock);
 }
 
@@ -404,6 +408,21 @@ static int kvmi_recv_thread(void *arg)
 	return 0;
 }
 
+static bool ready_to_hook(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	if (kvm->kvmi)
+		return false;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		if (kvmi_arch_vcpu_introspected(vcpu))
+			return false;
+
+	return true;
+}
+
 int kvmi_hook(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 {
 	struct kvm_introspection *kvmi;
@@ -411,7 +430,7 @@ int kvmi_hook(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	mutex_lock(&kvm->kvmi_lock);
 
-	if (kvm->kvmi) {
+	if (!ready_to_hook(kvm)) {
 		err = -EEXIST;
 		goto out;
 	}
@@ -836,7 +855,7 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 
 	kvmi = kvmi_get(vcpu->kvm);
 	if (!kvmi)
-		return;
+		goto out;
 
 	for (;;) {
 		kvmi_run_jobs(vcpu);
@@ -848,6 +867,13 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 	}
 
 	kvmi_put(vcpu->kvm);
+
+out:
+	if (kvmi_arch_clean_up_interception(vcpu)) {
+		mutex_lock(&vcpu->kvm->kvmi_lock);
+		kvmi_arch_vcpu_free_interception(vcpu);
+		mutex_unlock(&vcpu->kvm->kvmi_lock);
+	}
 }
 
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 810dde913ad6..05bfde7d7f1a 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -65,6 +65,11 @@ int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 				const struct kvm_regs *regs);
 
 /* arch */
+bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu);
+void kvmi_arch_vcpu_free_interception(struct kvm_vcpu *vcpu);
+bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu);
+void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu);
+bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
