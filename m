Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E0D16B19
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfEGTSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:55701 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfEGTSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:09 -0400
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
Subject: [PATCH 01/13] KVM: nVMX: Use adjusted pin controls for vmcs02
Date:   Tue,  7 May 2019 12:17:53 -0700
Message-Id: <20190507191805.9932-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM provides a module parameter to allow disabling virtual NMI support
to simplify testing (hardware *without* virtual NMI support is virtually
non-existent, pun intended).  When preparing vmcs02, use the accessor
for pin controls to ensure that the module param is respected for nested
guests.

Opportunistically swap the order of applying L0's and L1's pin controls
to better align with other controls and to prepare for a future patche
that will ignore L1's, but not L0's, preemption timer flag.

Fixes: d02fcf50779ec ("kvm: vmx: Allow disabling virtual NMI support")
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 ++---
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 1 +
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 04b40a98f60b..2a98d92f955b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1986,10 +1986,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	/*
 	 * PIN CONTROLS
 	 */
-	exec_control = vmcs12->pin_based_vm_exec_control;
-
+	exec_control = vmx_pin_based_exec_ctrl(vmx);
+	exec_control |= vmcs12->pin_based_vm_exec_control;
 	/* Preemption timer setting is computed directly in vmx_vcpu_run.  */
-	exec_control |= vmcs_config.pin_based_exec_ctrl;
 	exec_control &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
 	vmx->loaded_vmcs->hv_timer_armed = false;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 60306f19105d..08f36881473f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3798,7 +3798,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 }
 
-static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
+u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 {
 	u32 pin_based_exec_ctrl = vmcs_config.pin_based_exec_ctrl;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 63d37ccce3dc..181acd906c75 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -467,6 +467,7 @@ static inline u32 vmx_vmexit_ctrl(void)
 }
 
 u32 vmx_exec_control(struct vcpu_vmx *vmx);
+u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx);
 
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
-- 
2.21.0

