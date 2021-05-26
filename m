Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103303910C8
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 08:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhEZGkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 02:40:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:40358 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230007AbhEZGkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 02:40:14 -0400
IronPort-SDR: Je+gkYmLU4KXyteWi/4KKwJ2AxbN1A+37PRATa2xzd2Oq8Kk/cx/ByDsgTxV0qUxRp30ECZ2hv
 7gGK1nxRmmhw==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="189513058"
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="189513058"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 23:38:40 -0700
IronPort-SDR: k7OCLjSf/s4sFvSyLsZpYZ64x5gvSIMMWwLnHjwpAoYE/2qytgf/YD1Gpk9sAoJ6bxfNutlhEU
 rKJMQes8HuzQ==
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="414336179"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.22])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 23:38:37 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Cc:     Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH] KVM: X86: Use kvm_get_linear_rip() in single-step and #DB/#BP interception
Date:   Wed, 26 May 2021 14:38:28 +0800
Message-Id: <20210526063828.1173-1-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

The kvm_get_linear_rip() handles x86/long mode cases well and has
better readability, __kvm_set_rflags() also use the paired
fucntion kvm_is_linear_rip() to check the vcpu->arch.singlestep_rip
set in kvm_arch_vcpu_ioctl_set_guest_debug(), so change the
"CS.BASE + RIP" code in kvm_arch_vcpu_ioctl_set_guest_debug() and
handle_exception_nmi() to this one.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..0db05cfbe434 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4843,7 +4843,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 intr_info, ex_no, error_code;
-	unsigned long cr2, rip, dr6;
+	unsigned long cr2, dr6;
 	u32 vect_info;
 
 	vect_info = vmx->idt_vectoring_info;
@@ -4933,8 +4933,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		vmx->vcpu.arch.event_exit_inst_len =
 			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
-		rip = kvm_rip_read(vcpu);
-		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
+		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = ex_no;
 		break;
 	case AC_VECTOR:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..5cac5d883710 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10115,8 +10115,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	kvm_update_dr7(vcpu);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		vcpu->arch.singlestep_rip = kvm_rip_read(vcpu) +
-			get_segment_base(vcpu, VCPU_SREG_CS);
+		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
 
 	/*
 	 * Trigger an rflags update that will inject or remove the trace
-- 
2.17.1

