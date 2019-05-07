Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826FC16B1D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfEGTSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:55702 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbfEGTSK (ORCPT <rfc822;kvm@vger.kernel.org>);
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
Subject: [PATCH 11/13] KVM: VMX: Drop hv_timer_armed from 'struct loaded_vmcs'
Date:   Tue,  7 May 2019 12:18:03 -0700
Message-Id: <20190507191805.9932-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... now that it is fully redundant with the pin controls shadow.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 1 -
 arch/x86/kvm/vmx/vmcs.h   | 1 -
 arch/x86/kvm/vmx/vmx.c    | 8 ++------
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4b5be38cfc86..6ecdcfc67245 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1988,7 +1988,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	exec_control |= vmcs12->pin_based_vm_exec_control;
 	/* Preemption timer setting is computed directly in vmx_vcpu_run.  */
 	exec_control &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
-	vmx->loaded_vmcs->hv_timer_armed = false;
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
 	if (nested_cpu_has_posted_intr(vmcs12)) {
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index c09ae69155a8..52657d747668 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -61,7 +61,6 @@ struct loaded_vmcs {
 	int cpu;
 	bool launched;
 	bool nmi_known_unmasked;
-	bool hv_timer_armed;
 	/* Support for vnmi-less CPUs */
 	int soft_vnmi_blocked;
 	ktime_t entry_time;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eaa74c1e9a02..70e9109b6481 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6320,9 +6320,7 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
 {
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
-	if (!vmx->loaded_vmcs->hv_timer_armed)
-		pin_controls_setbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
-	vmx->loaded_vmcs->hv_timer_armed = true;
+	pin_controls_setbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 }
 
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
@@ -6349,9 +6347,7 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	if (vmx->loaded_vmcs->hv_timer_armed)
-		pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
-	vmx->loaded_vmcs->hv_timer_armed = false;
+	pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 }
 
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
-- 
2.21.0

