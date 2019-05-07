Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC50F16772
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfEGQG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:42085 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbfEGQGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 12:06:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 09:06:44 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2019 09:06:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 08/15] KVM: nVMX: Don't speculatively write virtual-APIC page address
Date:   Tue,  7 May 2019 09:06:33 -0700
Message-Id: <20190507160640.4812-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VIRTUAL_APIC_PAGE_ADDR in vmcs02 is guaranteed to be updated before
it is consumed by hardware, either in nested_vmx_enter_non_root_mode()
or via the KVM_REQ_GET_VMCS12_PAGES callback.  Avoid an extra VMWRITE
and only stuff a bad value into vmcs02 when mapping vmcs12's address
fails.  This also eliminates the need for extra comments to connect the
dots between prepare_vmcs02_early() and nested_get_vmcs12_pages().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 99164d054922..32d233dee067 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2038,20 +2038,13 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	exec_control &= ~CPU_BASED_TPR_SHADOW;
 	exec_control |= vmcs12->cpu_based_vm_exec_control;
 
-	/*
-	 * Write an illegal value to VIRTUAL_APIC_PAGE_ADDR. Later, if
-	 * nested_get_vmcs12_pages can't fix it up, the illegal value
-	 * will result in a VM entry failure.
-	 */
-	if (exec_control & CPU_BASED_TPR_SHADOW) {
-		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, -1ull);
+	if (exec_control & CPU_BASED_TPR_SHADOW)
 		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
-	} else {
 #ifdef CONFIG_X86_64
+	else
 		exec_control |= CPU_BASED_CR8_LOAD_EXITING |
 				CPU_BASED_CR8_STORE_EXITING;
 #endif
-	}
 
 	/*
 	 * A vmexit (to either L1 hypervisor or L0 userspace) is always needed
@@ -2869,10 +2862,6 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
 		map = &vmx->nested.virtual_apic_map;
 
-		/*
-		 * If translation failed, VM entry will fail because
-		 * prepare_vmcs02 set VIRTUAL_APIC_PAGE_ADDR to -1ull.
-		 */
 		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->virtual_apic_page_addr), map)) {
 			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, pfn_to_hpa(map->pfn));
 		} else if (nested_cpu_has(vmcs12, CPU_BASED_CR8_LOAD_EXITING) &&
@@ -2888,6 +2877,12 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			 */
 			vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
 					CPU_BASED_TPR_SHADOW);
+		} else {
+			/*
+			 * Write an illegal value to VIRTUAL_APIC_PAGE_ADDR to
+			 * force VM-Entry to fail.
+			 */
+			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, -1ull);
 		}
 	}
 
-- 
2.21.0

