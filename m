Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807DB1676B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfEGQGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:42085 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbfEGQGp (ORCPT <rfc822;kvm@vger.kernel.org>);
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
Subject: [PATCH 04/15] KVM: nVMX: Write ENCLS-exiting bitmap once per vmcs02
Date:   Tue,  7 May 2019 09:06:29 -0700
Message-Id: <20190507160640.4812-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM doesn't yet support SGX virtualization, i.e. writes a constant value
to ENCLS_EXITING_BITMAP so that it can intercept ENCLS and inject a #UD.

Fixes: 0b665d3040281 ("KVM: vmx: Inject #UD for SGX ENCLS instruction in guest")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9c31e82fb7c5..094d139579fb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1948,6 +1948,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	if (enable_pml)
 		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
 
+	if (cpu_has_vmx_encls_vmexit())
+		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
+
 	/*
 	 * Set the MSR load/store lists to match L0's settings.  Only the
 	 * addresses are constant (for vmcs02), the counts can change based
@@ -2070,9 +2073,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (exec_control & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)
 			vmcs_write64(APIC_ACCESS_ADDR, -1ull);
 
-		if (exec_control & SECONDARY_EXEC_ENCLS_EXITING)
-			vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
-
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
 	}
 
-- 
2.21.0

