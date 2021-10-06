Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A60424509
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239625AbhJFRo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:44:27 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53634 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238578AbhJFRmr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:47 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id F3828305D364;
        Wed,  6 Oct 2021 20:31:16 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D9D97300F712;
        Wed,  6 Oct 2021 20:31:16 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 55/77] KVM: introspection: add cleanup support for vCPUs
Date:   Wed,  6 Oct 2021 20:30:51 +0300
Message-Id: <20211006173113.26445-56-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
index 1970c21c2270..f1e9adc24025 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -919,6 +919,9 @@ struct kvm_vcpu_arch {
 
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
index e4358bc3f09a..6a7fc8059f23 100644
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
index 304bae43cb78..f73f49fc381c 100644
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
 static int kvmi_hook(struct kvm *kvm,
 		     const struct kvm_introspection_hook *hook)
 {
@@ -418,7 +437,7 @@ static int kvmi_hook(struct kvm *kvm,
 
 	mutex_lock(&kvm->kvmi_lock);
 
-	if (kvm->kvmi) {
+	if (!ready_to_hook(kvm)) {
 		err = -EEXIST;
 		goto out;
 	}
@@ -815,7 +834,7 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 
 	kvmi = kvmi_get(vcpu->kvm);
 	if (!kvmi)
-		return;
+		goto out;
 
 	for (;;) {
 		kvmi_run_jobs(vcpu);
@@ -827,6 +846,13 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
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
