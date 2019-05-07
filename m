Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0209016B1C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfEGTSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:55701 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfEGTSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 12:18:06 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2019 12:18:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 12/13] KVM: nVMX: Don't mark vmcs12 as dirty when L1 writes pin controls
Date:   Tue,  7 May 2019 12:18:04 -0700
Message-Id: <20190507191805.9932-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pin controls doesn't affect dirty logic, e.g. the preemption timer value
is loaded from vmcs12 even if vmcs12 is "clean", i.e. there is no need
to mark vmcs12 dirty when L1 writes pin controls.

KVM currently toggles the VMX_PREEMPTION_TIMER control flag when it
disables or enables the timer.  The VMWRITE to toggle the flag can be
responsible for a large percentage of vmcs12 dirtying when running KVM
as L1 (depending on the behavior of L2).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6ecdcfc67245..652022a77b64 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4508,8 +4508,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			/*
 			 * The fields that can be updated by L1 without a vmexit are
 			 * always updated in the vmcs02, the others go down the slow
-			 * path of prepare_vmcs02.
+			 * path of prepare_vmcs02.  Pin controls is an exception as
+			 * writing pin controls doesn't affect KVM's dirty logic and
+			 * the VMX_PREEMPTION_TIMER flag may be toggled frequently,
+			 * but not frequently enough to justify shadowing.
 			 */
+		case PIN_BASED_VM_EXEC_CONTROL:
 			break;
 		default:
 			vmx->nested.dirty_vmcs12 = true;
-- 
2.21.0

