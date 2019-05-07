Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007C81676C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfEGQGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:42094 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfEGQGs (ORCPT <rfc822;kvm@vger.kernel.org>);
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
Subject: [PATCH 13/15] KVM: nVMX: Update vmcs02 GUEST_IA32_DEBUGCTL only when vmcs12 is dirty
Date:   Tue,  7 May 2019 09:06:38 -0700
Message-Id: <20190507160640.4812-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMWRITEs to GUEST_IA32_DEBUGCTL from L1 are always intercepted, and
unlike GUEST_DR7 there is no funky logic for determining the value.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2e9f8169d40a..58717dfe82c9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2194,6 +2194,11 @@ static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write64(GUEST_PDPTR2, vmcs12->guest_pdptr2);
 			vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 		}
+
+		if (vmx->nested.nested_run_pending &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
+			vmcs_write64(GUEST_IA32_DEBUGCTL,
+					vmcs12->guest_ia32_debugctl);
 	}
 
 	if (nested_cpu_has_xsaves(vmcs12))
@@ -2270,7 +2275,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (vmx->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
 	} else {
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.vmcs01_debugctl);
-- 
2.21.0

