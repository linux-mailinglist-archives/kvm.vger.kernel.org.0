Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EF814D3C0
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgA2Xqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:46:46 -0500
Received: from mga06.intel.com ([134.134.136.31]:46688 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgA2Xqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551703"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/26] KVM: x86: Add a kvm_x86_ops hook to query virtualized MSR support
Date:   Wed, 29 Jan 2020 15:46:18 -0800
Message-Id: <20200129234640.8147-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a hook, ->has_virtualized_msr(), to allow moving vendor specific
checks into SVM/VMX and ultimately facilitate the removal of the
piecemeal ->*_supported() hooks.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 6 ++++++
 arch/x86/kvm/vmx/vmx.c          | 6 ++++++
 arch/x86/kvm/x86.c              | 2 ++
 4 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5c2ad3fa0980..8fb32c27fa44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1050,6 +1050,7 @@ struct kvm_x86_ops {
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 	bool (*cpu_has_accelerated_tpr)(void);
+	bool (*has_virtualized_msr)(u32 index);
 	bool (*has_emulated_msr)(u32 index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a7b944a3a0e2..1f9323fbad81 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5985,6 +5985,11 @@ static bool svm_cpu_has_accelerated_tpr(void)
 	return false;
 }
 
+static bool svm_has_virtualized_msr(u32 index)
+{
+	return true;
+}
+
 static bool svm_has_emulated_msr(u32 index)
 {
 	switch (index) {
@@ -7379,6 +7384,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
+	.has_virtualized_msr = svm_has_virtualized_msr,
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.vcpu_create = svm_create_vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f5bb1ad2e9fa..3f2c094434e8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6274,6 +6274,11 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
 		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
+static bool vmx_has_virtualized_msr(u32 index)
+{
+	return true;
+}
+
 static bool vmx_has_emulated_msr(u32 index)
 {
 	switch (index) {
@@ -7754,6 +7759,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
 	.cpu_has_accelerated_tpr = report_flexpriority,
+	.has_virtualized_msr = vmx_has_virtualized_msr,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_init = vmx_vm_init,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d4a5326d84e..94f90fe1c0de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5279,6 +5279,8 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		default:
+			if (!kvm_x86_ops->has_virtualized_msr(msr_index))
+				continue;
 			break;
 		}
 
-- 
2.24.1

