Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64671ABDFE
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 12:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504984AbgDPKeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 06:34:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:46619 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505096AbgDPKeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 06:34:02 -0400
IronPort-SDR: CDrhlRQysprIsZyFirOrkx3MXsSk0l3AKyFwcJB+VWntV/yDAzSVifTGoi2pZfwJKjC3hCrNt5
 zko0gkyxmeDA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 03:33:31 -0700
IronPort-SDR: uaGMqjC1D3LJTSHhxkWzZqyX/QcbfjO69rPnA6+ZfklqV8oJiikirHHkpPssHofAXpOL6lPM8f
 LVq4Ne569yow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,390,1580803200"; 
   d="scan'208";a="277947912"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.132])
  by fmsmga004.fm.intel.com with ESMTP; 16 Apr 2020 03:33:29 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH 3/3] kvm: x86: skip DRn reload if previous VM exit is DR access VM exit
Date:   Thu, 16 Apr 2020 18:15:09 +0800
Message-Id: <20200416101509.73526-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200416101509.73526-1-xiaoyao.li@intel.com>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When DR access vm exit, there is no DRn change throughout VM exit to
next VM enter. Skip the DRn reload in this case and fix the comments.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/svm/svm.c | 8 +++++---
 arch/x86/kvm/vmx/vmx.c | 8 +++++---
 arch/x86/kvm/x86.c     | 2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 66123848448d..c6883a0bf8c3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2287,9 +2287,11 @@ static int dr_interception(struct vcpu_svm *svm)
 
 	if (svm->vcpu.guest_debug == 0) {
 		/*
-		 * No more DR vmexits; force a reload of the debug registers
-		 * and reenter on this instruction.  The next vmexit will
-		 * retrieve the full state of the debug registers.
+		 * No more DR vmexits and reenter on this instruction.
+		 * The next vmexit will retrieve the full state of the debug
+		 * registers and re-enable DR vmexits.
+		 * No need to set KVM_DEBUGREG_NEED_RELOAD because no DRn change
+		 * since this DR vmexit.
 		 */
 		clr_dr_intercepts(svm);
 		svm->vcpu.arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa1b8cf7c915..22eff8503048 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4967,9 +4967,11 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
 
 		/*
-		 * No more DR vmexits; force a reload of the debug registers
-		 * and reenter on this instruction.  The next vmexit will
-		 * retrieve the full state of the debug registers.
+		 * No more DR vmexits and reenter on this instruction.
+		 * The next vmexit will retrieve the full state of the debug
+		 * registers and re-enable DR vmexits.
+		 * No need to set KVM_DEBUGREG_NEED_RELOAD because no DRn change
+		 * since this DR vmexit.
 		 */
 		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
 		return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 71264df64001..8983848cbf45 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8400,7 +8400,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_NEED_RELOAD)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
-- 
2.20.1

