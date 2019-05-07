Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E65E16766
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 18:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfEGQGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 12:06:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:42087 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfEGQGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 12:06:47 -0400
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
Subject: [PATCH 11/15] KVM: nVMX: Update vmcs12 for SYSENTER MSRs when they're written
Date:   Tue,  7 May 2019 09:06:36 -0700
Message-Id: <20190507160640.4812-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For L2, KVM always intercepts WRMSR to SYSENTER MSRs.  Update vmcs12 in
the WRMSR handler so that they don't need to be (re)read from vmcs02 on
every nested VM-Exit.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ---
 arch/x86/kvm/vmx/vmx.c    | 6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 135773679d5b..2e9c7bc3fb1f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3485,9 +3485,6 @@ static void sync_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
-	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
-	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
-	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index baa79c5a8ce7..6db16ca1b43d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1831,12 +1831,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
+		if (is_guest_mode(vcpu))
+			get_vmcs12(vcpu)->guest_sysenter_cs = data;
 		vmcs_write32(GUEST_SYSENTER_CS, data);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
+		if (is_guest_mode(vcpu))
+			get_vmcs12(vcpu)->guest_sysenter_eip = data;
 		vmcs_writel(GUEST_SYSENTER_EIP, data);
 		break;
 	case MSR_IA32_SYSENTER_ESP:
+		if (is_guest_mode(vcpu))
+			get_vmcs12(vcpu)->guest_sysenter_esp = data;
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_POWER_CTL:
-- 
2.21.0

