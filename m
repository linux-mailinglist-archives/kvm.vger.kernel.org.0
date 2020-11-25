Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B2B2C3C94
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgKYJmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:10 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57134 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728596AbgKYJmJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:09 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 41BE4305D3C6;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 1D2E13072784;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 58/81] KVM: introspection: add cleanup support for vCPUs
Date:   Wed, 25 Nov 2020 11:35:37 +0200
Message-Id: <20201125093600.2766-59-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

On unhook the introspection channel is closed. This will signal the
receiving thread to call kvmi_put() and exit. There might be vCPU threads
handling introspection commands or waiting for event replies. These
will also call kvmi_put() and re-enter in guest. Once the reference
counter reaches zero, the structures keeping the introspection data
(kvm_introspection and kvm_vcpu_introspection) will be freed.

In order to restore the interception of CRs, MSRs, BP, descriptor-table
registers, from all vCPUs (some of which might run from userspace),
we keep the needed information in another structure (kvmi_interception)
which will be used and freed by each of them before re-entering in guest.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h   |  3 ++
 arch/x86/include/asm/kvmi_host.h  |  4 +++
 arch/x86/kvm/kvmi.c               | 49 +++++++++++++++++++++++++++++++
 virt/kvm/introspection/kvmi.c     | 32 ++++++++++++++++++--
 virt/kvm/introspection/kvmi_int.h |  5 ++++
 5 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7d1e865193a9..d4e2fe493419 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -816,6 +816,9 @@ struct kvm_vcpu_arch {
 
 	/* #PF translated error code from EPT/NPT exit reason */
 	u64 error_code;
+
+	/* Control the interception of MSRs/CRs/BP... */
+	struct kvmi_interception *kvmi;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index cc945151cb36..b776be4bb49f 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -4,6 +4,10 @@
 
 #include <asm/kvmi.h>
 
+struct kvmi_interception {
+	bool restore_interception;
+};
+
 struct kvm_vcpu_arch_introspection {
 	struct kvm_regs delayed_regs;
 	bool have_delayed_regs;
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 0bb6f38f1213..b4a7d581f68c 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -210,3 +210,52 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 		kvmi_handle_common_event_actions(vcpu, action);
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
index 476af6dd8bf1..a0cd98839944 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -206,7 +206,7 @@ static bool kvmi_alloc_vcpui(struct kvm_vcpu *vcpu)
 
 	vcpu->kvmi = vcpui;
 
-	return true;
+	return kvmi_arch_vcpu_alloc_interception(vcpu);
 }
 
 static int kvmi_create_vcpui(struct kvm_vcpu *vcpu)
@@ -240,6 +240,9 @@ static void kvmi_free_vcpui(struct kvm_vcpu *vcpu)
 
 	kfree(vcpui);
 	vcpu->kvmi = NULL;
+
+	kvmi_arch_request_interception_cleanup(vcpu);
+	kvmi_make_request(vcpu, false);
 }
 
 static void kvmi_free(struct kvm *kvm)
@@ -262,6 +265,7 @@ void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	mutex_lock(&vcpu->kvm->kvmi_lock);
 	kvmi_free_vcpui(vcpu);
+	kvmi_arch_vcpu_free_interception(vcpu);
 	mutex_unlock(&vcpu->kvm->kvmi_lock);
 }
 
@@ -410,6 +414,21 @@ static int kvmi_recv_thread(void *arg)
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
@@ -417,7 +436,7 @@ int kvmi_hook(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	mutex_lock(&kvm->kvmi_lock);
 
-	if (kvm->kvmi) {
+	if (!ready_to_hook(kvm)) {
 		err = -EEXIST;
 		goto out;
 	}
@@ -814,7 +833,7 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 
 	kvmi = kvmi_get(vcpu->kvm);
 	if (!kvmi)
-		return;
+		goto out;
 
 	for (;;) {
 		kvmi_run_jobs(vcpu);
@@ -826,6 +845,13 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
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
index ff745e3cebaf..94de54d7ebb9 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -78,6 +78,11 @@ void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id);
 void kvmi_arch_setup_vcpu_event(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_event *ev);
+bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu);
+void kvmi_arch_vcpu_free_interception(struct kvm_vcpu *vcpu);
+bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu);
+void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu);
+bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu);
 void kvmi_arch_post_reply(struct kvm_vcpu *vcpu);
 bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu);
 void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
