Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F6F2EED9A
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 07:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbhAHGxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 01:53:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:45896 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbhAHGxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 01:53:19 -0500
IronPort-SDR: eD0y6m+PyFw7KsD58Pw4OVHz4S7W0LdEtAAWtn6gCOP8VzZwUKacdc+tuiQKIpSZCA4yy7qYNZ
 ssDIcJYhwrNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="164628720"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="164628720"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 22:52:38 -0800
IronPort-SDR: zvSu4V5fGjuBrBfBDcQ30oIdU1+8yclJAT5uhasRwTxfc0JjDgJyH6wth1Zym6DJrYEXgAMDl8
 3j3Mzw7T7fDQ==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="570660437"
Received: from chenyi-pc.sh.intel.com ([10.239.159.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 22:52:37 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v5 2/4] KVM: X86: Reset the vcpu->run->flags at the beginning of vcpu_run
Date:   Fri,  8 Jan 2021 14:55:28 +0800
Message-Id: <20210108065530.2135-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210108065530.2135-1-chenyi.qiang@intel.com>
References: <20210108065530.2135-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reset the vcpu->run->flags at the beginning of kvm_arch_vcpu_ioctl_run.
It can avoid every thunk of code that needs to set the flag clear it,
which increases the odds of missing a case and ending up with a flag in
an undefined state.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..ded2149497ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8189,12 +8189,14 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 	kvm_run->if_flag = !vcpu->arch.guest_state_protected
 		&& (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
 
-	kvm_run->flags = is_smm(vcpu) ? KVM_RUN_X86_SMM : 0;
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
 	kvm_run->ready_for_interrupt_injection =
 		pic_in_kernel(vcpu->kvm) ||
 		kvm_vcpu_ready_for_interrupt_injection(vcpu);
+
+	if (is_smm(vcpu))
+		kvm_run->flags |= KVM_RUN_X86_SMM;
 }
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu)
@@ -9305,6 +9307,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
+	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);
 
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
-- 
2.17.1

