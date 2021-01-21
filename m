Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA572FE597
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 09:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbhAUIwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 03:52:44 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:43527 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728179AbhAUIt0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 03:49:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UMPTpeq_1611218908;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMPTpeq_1611218908)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Jan 2021 16:48:32 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] KVM: vmx: Assign boolean values to a bool variable
Date:   Thu, 21 Jan 2021 16:48:26 +0800
Message-Id: <1611218906-71903-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following coccicheck warnings:

./arch/x86/kvm/vmx/vmx.c:6798:1-27: WARNING: Assignment of 0/1
to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2af05d3..8d51135 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -743,7 +743,7 @@ static void __loaded_vmcs_clear(void *arg)
 	smp_wmb();
 
 	loaded_vmcs->cpu = -1;
-	loaded_vmcs->launched = 0;
+	loaded_vmcs->launched = false;
 }
 
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
@@ -2621,7 +2621,7 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	loaded_vmcs->shadow_vmcs = NULL;
 	loaded_vmcs->hv_timer_soft_disabled = false;
 	loaded_vmcs->cpu = -1;
-	loaded_vmcs->launched = 0;
+	loaded_vmcs->launched = false;
 
 	if (cpu_has_vmx_msr_bitmap()) {
 		loaded_vmcs->msr_bitmap = (unsigned long *)
@@ -4211,7 +4211,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
 	if (!enable_ept) {
 		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
-		enable_unrestricted_guest = 0;
+		enable_unrestricted_guest = false;
 	}
 	if (!enable_unrestricted_guest)
 		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
@@ -6762,7 +6762,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_host_xsave_state(vcpu);
 
-	vmx->nested.nested_run_pending = 0;
+	vmx->nested.nested_run_pending = false;
 	vmx->idt_vectoring_info = 0;
 
 	if (unlikely(vmx->fail)) {
@@ -6779,7 +6779,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return EXIT_FASTPATH_NONE;
 
-	vmx->loaded_vmcs->launched = 1;
+	vmx->loaded_vmcs->launched = true;
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	vmx_recover_nmi_blocking(vmx);
@@ -7740,25 +7740,25 @@ static __init int hardware_setup(void)
 
 	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
 	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
-		enable_vpid = 0;
+		enable_vpid = false;
 
 	if (!cpu_has_vmx_ept() ||
 	    !cpu_has_vmx_ept_4levels() ||
 	    !cpu_has_vmx_ept_mt_wb() ||
 	    !cpu_has_vmx_invept_global())
-		enable_ept = 0;
+		enable_ept = false;
 
 	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
-		enable_ept_ad_bits = 0;
+		enable_ept_ad_bits = false;
 
 	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
-		enable_unrestricted_guest = 0;
+		enable_unrestricted_guest = false;
 
 	if (!cpu_has_vmx_flexpriority())
-		flexpriority_enabled = 0;
+		flexpriority_enabled = false;
 
 	if (!cpu_has_virtual_nmis())
-		enable_vnmi = 0;
+		enable_vnmi = false;
 
 	/*
 	 * set_apic_access_page_addr() is used to reload apic access
@@ -7789,7 +7789,7 @@ static __init int hardware_setup(void)
 	}
 
 	if (!cpu_has_vmx_apicv()) {
-		enable_apicv = 0;
+		enable_apicv = false;
 		vmx_x86_ops.sync_pir_to_irr = NULL;
 	}
 
@@ -7819,7 +7819,7 @@ static __init int hardware_setup(void)
 	 * and EPT A/D bit features are enabled -- PML depends on them to work.
 	 */
 	if (!enable_ept || !enable_ept_ad_bits || !cpu_has_vmx_pml())
-		enable_pml = 0;
+		enable_pml = false;
 
 	if (!enable_pml) {
 		vmx_x86_ops.slot_enable_log_dirty = NULL;
-- 
1.8.3.1

