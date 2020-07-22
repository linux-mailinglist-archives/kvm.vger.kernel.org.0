Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869F4229CAE
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgGVQBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:40 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37948 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729015AbgGVQBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9928D305D76A;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8E9A4305FFA6;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 19/34] KVM: introspection: clean non-default EPTs on unhook
Date:   Wed, 22 Jul 2020 19:01:06 +0300
Message-Id: <20200722160121.9601-20-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

When a guest is unhooked, the VM is brought to default state and uses
default EPT view. Delete all shadow pages that belong to non-default EPT
views in order to free unused shadow pages. They are not used because
the guest cannot VMFUNC to any EPT view.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/kvmi.c             | 23 ++++++++++++++++++++++-
 virt/kvm/introspection/kvmi.c   |  3 +++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 519b8210b8ef..086b6e2a2314 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1026,6 +1026,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	refcount_t kvmi_refcount;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 52885b9e5b6e..27fd732cff29 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -640,6 +640,25 @@ static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 	kvmi_arch_disable_msrw_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.high);
 }
 
+void kvmi_arch_restore_ept_view(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u16 view, default_view = 0;
+	bool visible = false;
+
+	if (kvm_get_ept_view(vcpu) != default_view)
+		kvmi_arch_cmd_set_ept_view(vcpu, default_view);
+
+	for (view = 0; view < KVM_MAX_EPT_VIEWS; view++)
+		kvmi_arch_cmd_control_ept_view(vcpu, view, visible);
+
+	if (refcount_dec_and_test(&kvm->arch.kvmi_refcount)) {
+		u16 zap_mask = ~(1 << default_view);
+
+		kvm_mmu_zap_all(vcpu->kvm, zap_mask);
+	}
+}
+
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_interception *arch_vcpui = vcpu->arch.kvmi;
@@ -647,8 +666,10 @@ bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
 	if (!arch_vcpui || !arch_vcpui->cleanup)
 		return false;
 
-	if (arch_vcpui->restore_interception)
+	if (arch_vcpui->restore_interception) {
 		kvmi_arch_restore_interception(vcpu);
+		kvmi_arch_restore_ept_view(vcpu);
+	}
 
 	return true;
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 44b0092e304f..f3bdef3c54e6 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -288,6 +288,9 @@ static void free_kvmi(struct kvm *kvm)
 
 	kvmi_clear_mem_access(kvm);
 
+	refcount_set(&kvm->arch.kvmi_refcount,
+			atomic_read(&kvm->online_vcpus));
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		free_vcpui(vcpu, restore_interception);
 
