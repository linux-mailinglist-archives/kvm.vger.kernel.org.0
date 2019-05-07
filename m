Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AE6166E9
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfEGPgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:36:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:51040 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfEGPgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:36:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 08:36:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2019 08:36:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 4/7] KVM: nVMX: Lift sync_vmcs12() out of prepare_vmcs12()
Date:   Tue,  7 May 2019 08:36:26 -0700
Message-Id: <20190507153629.3681-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507153629.3681-1-sean.j.christopherson@intel.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... to make it more obvious that sync_vmcs12() is invoked on all nested
VM-Exits, e.g. hiding sync_vmcs12() in prepare_vmcs12() makes it appear
that guest state is NOT propagated to vmcs12 for a normal VM-Exit.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4528c8ff3c9c..0eee7894b453 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3497,11 +3497,7 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			   u32 exit_reason, u32 exit_intr_info,
 			   unsigned long exit_qualification)
 {
-	/* update guest state fields: */
-	sync_vmcs12(vcpu, vmcs12);
-
 	/* update exit information fields: */
-
 	vmcs12->vm_exit_reason = exit_reason;
 	vmcs12->exit_qualification = exit_qualification;
 	vmcs12->vm_exit_intr_info = exit_intr_info;
@@ -3862,9 +3858,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
 
 	if (likely(!vmx->fail)) {
-		if (exit_reason == -1)
-			sync_vmcs12(vcpu, vmcs12);
-		else
+		sync_vmcs12(vcpu, vmcs12);
+
+		if (exit_reason != -1)
 			prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
 				       exit_qualification);
 
-- 
2.21.0

