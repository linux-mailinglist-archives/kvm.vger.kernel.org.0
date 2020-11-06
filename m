Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D8B2A91F5
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgKFJBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:01:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:4554 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726459AbgKFJBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 04:01:01 -0500
IronPort-SDR: M0Y7mMg9oZGZz2UbKzj6Qyk92g/zRnQ94XMJMnpVed3osMZP3UL3DftxPjcruJeL38PxXrxy8H
 XZIu2IPVoFgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="169670236"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="169670236"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:01:01 -0800
IronPort-SDR: /ezvI+VrX+Sic/7l29N9XG35pu0b5sbK4lPcM1lWQUHcTkne81FQZSC2RGFCu4u/+Y1Wsp7uW7
 254hR8OFxWVg==
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="472000334"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:00:58 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/4] KVM: X86: Reset the vcpu->run->flags at the beginning of vcpu_run
Date:   Fri,  6 Nov 2020 17:03:13 +0800
Message-Id: <20201106090315.18606-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106090315.18606-1-chenyi.qiang@intel.com>
References: <20201106090315.18606-1-chenyi.qiang@intel.com>
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
index f5ede41bf9e6..bd239cab0a1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8119,12 +8119,14 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 
 	kvm_run->if_flag = (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
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
@@ -9216,6 +9218,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
+	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);
 
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
-- 
2.17.1

