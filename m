Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC49229CBA
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgGVQCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:22 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37956 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728771AbgGVQBg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:36 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2CC8C305D7F1;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 1B65F3072799;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 08/34] KVM: x86: add .set_ept_view()
Date:   Wed, 22 Jul 2020 19:00:55 +0300
Message-Id: <20200722160121.9601-9-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marian Rotariu <marian.c.rotariu@gmail.com>

The introspection tool uses this function to check the hardware support
for EPT switching, which can be used either to singlestep vCPUs
on a unprotected EPT view.

Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 35 ++++++++++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1035308940fe..300f7fc43987 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1309,6 +1309,7 @@ struct kvm_x86_ops {
 	bool (*get_vmfunc_status)(void);
 	bool (*get_eptp_switching_status)(void);
 	u16 (*get_ept_view)(struct kvm_vcpu *vcpu);
+	int (*set_ept_view)(struct kvm_vcpu *vcpu, u16 view);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2024ef4d9a74..0d39487ce5c6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4373,6 +4373,28 @@ static int vmx_alloc_eptp_list_page(struct vcpu_vmx *vmx)
 	return 0;
 }
 
+static int vmx_set_ept_view(struct kvm_vcpu *vcpu, u16 view)
+{
+	if (view >= KVM_MAX_EPT_VIEWS)
+		return -EINVAL;
+
+	if (to_vmx(vcpu)->eptp_list_pg) {
+		int r;
+
+		to_vmx(vcpu)->view = view;
+
+		/*
+		 * Reload mmu and make sure vmx_load_mmu_pgd() is called so that
+		 * VMCS::EPT_POINTER is updated accordingly
+		 */
+		kvm_mmu_unload(vcpu);
+		r = kvm_mmu_reload(vcpu);
+		WARN_ON_ONCE(r);
+	}
+
+	return 0;
+}
+
 #define VMX_XSS_EXIT_BITMAP 0
 
 /*
@@ -4463,9 +4485,15 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
 
-	if (vmx->eptp_list_pg)
+	if (vmx->eptp_list_pg) {
+		u64 vm_function_control;
+
 		vmcs_write64(EPTP_LIST_ADDRESS,
 				page_to_phys(vmx->eptp_list_pg));
+		vm_function_control = vmcs_read64(VM_FUNCTION_CONTROL);
+		vm_function_control |= VMX_VMFUNC_EPTP_SWITCHING;
+		vmcs_write64(VM_FUNCTION_CONTROL, vm_function_control);
+	}
 
 	if (vmx_pt_mode_is_host_guest()) {
 		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
@@ -5965,6 +5993,10 @@ static void dump_eptp_list(void)
 
 	eptp_list = phys_to_virt(eptp_list_phys);
 
+	pr_err("VMFunctionControl=%08x VMFunctionControlHigh=%08x\n",
+	       vmcs_read32(VM_FUNCTION_CONTROL),
+	       vmcs_read32(VM_FUNCTION_CONTROL_HIGH));
+
 	pr_err("*** EPTP Switching ***\n");
 	pr_err("EPTP List Address: %p (phys %p)\n",
 		eptp_list, (void *)eptp_list_phys);
@@ -8251,6 +8283,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_vmfunc_status = vmx_get_vmfunc_status,
 	.get_eptp_switching_status = vmx_get_eptp_switching_status,
 	.get_ept_view = vmx_get_ept_view,
+	.set_ept_view = vmx_set_ept_view,
 };
 
 static __init int hardware_setup(void)
