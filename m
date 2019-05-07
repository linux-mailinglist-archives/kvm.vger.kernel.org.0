Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D42716775
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfEGQHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:07:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:42087 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbfEGQGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 12:06:45 -0400
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
Subject: [PATCH 05/15] KVM: nVMX: Don't rewrite GUEST_PML_INDEX during nested VM-Entry
Date:   Tue,  7 May 2019 09:06:30 -0700
Message-Id: <20190507160640.4812-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulation of GUEST_PML_INDEX for a nested VMM is a bit weird.  Because
L0 flushes the PML on every VM-Exit, the value in vmcs02 at the time of
VM-Enter is a constant -1, regardless of what L1 thinks/wants.

Fixes: 09abe32002665 ("KVM: nVMX: split pieces of prepare_vmcs02() to prepare_vmcs02_early()")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 094d139579fb..a30d53823b2e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1945,8 +1945,16 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_msr_bitmap())
 		vmcs_write64(MSR_BITMAP, __pa(vmx->nested.vmcs02.msr_bitmap));
 
-	if (enable_pml)
+	/*
+	 * Conceptually we want to copy the PML address and index from vmcs01
+	 * here, and then back to vmcs01 on nested vmexit.  But since we always
+	 * flush the log on each vmexit and never change the PML address (once
+	 * set), both fields are effectively constant in vmcs02.
+	 */
+	if (enable_pml) {
 		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
+		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
+	}
 
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
@@ -2106,16 +2114,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		exec_control |= VM_EXIT_LOAD_IA32_EFER;
 	vm_exit_controls_init(vmx, exec_control);
 
-	/*
-	 * Conceptually we want to copy the PML address and index from
-	 * vmcs01 here, and then back to vmcs01 on nested vmexit. But,
-	 * since we always flush the log on each vmexit and never change
-	 * the PML address (once set), this happens to be equivalent to
-	 * simply resetting the index in vmcs02.
-	 */
-	if (enable_pml)
-		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
-
 	/*
 	 * Interrupt/Exception Fields
 	 */
-- 
2.21.0

