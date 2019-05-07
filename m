Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15AB816769
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfEGQGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:42087 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbfEGQGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 12:06:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 09:06:44 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2019 09:06:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 14/15] KVM: nVMX: Don't update GUEST_BNDCFGS if it's clean in HV eVMCS
Date:   Tue,  7 May 2019 09:06:39 -0700
Message-Id: <20190507160640.4812-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

L1 is responsible for dirtying GUEST_GRP1 if it writes GUEST_BNDCFGS.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 58717dfe82c9..cfdc04fde8eb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2199,6 +2199,10 @@ static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 			vmcs_write64(GUEST_IA32_DEBUGCTL,
 					vmcs12->guest_ia32_debugctl);
+
+		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 	}
 
 	if (nested_cpu_has_xsaves(vmcs12))
@@ -2234,10 +2238,6 @@ static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
 	set_cr4_guest_host_mask(vmx);
-
-	if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
-	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
-		vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 }
 
 /*
-- 
2.21.0

