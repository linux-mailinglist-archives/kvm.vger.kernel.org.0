Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB72345D1FE
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346817AbhKYA2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:28:21 -0500
Received: from mga14.intel.com ([192.55.52.115]:6411 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352777AbhKYAYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649677"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649677"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:08 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042152"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:07 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [RFC PATCH v3 17/59] KVM: x86: Add flag to disallow #MC injection / KVM_X86_SETUP_MCE
Date:   Wed, 24 Nov 2021 16:20:00 -0800
Message-Id: <b7c89ebf9f2000c1f8c3d0e57bd7cf622f11f638.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a flag to disallow MCE injection and reject KVM_X86_SETUP_MCE with
-EINVAL when set.  TDX doesn't support injecting exceptions, including
(virtual) #MCs.

Co-developed-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ebc4de32bf0e..e912e1e853ef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1142,6 +1142,7 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 	bool irq_injection_disallowed;
+	bool mce_injection_disallowed;
 	/*
 	 * If exit_on_emulation_error is set, and the in-kernel instruction
 	 * emulator fails to emulate an instruction, allow userspace
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b399e64e8863..fefa4602e879 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4561,15 +4561,16 @@ static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 					u64 mcg_cap)
 {
-	int r;
 	unsigned bank_num = mcg_cap & 0xff, bank;
 
-	r = -EINVAL;
+	if (vcpu->kvm->arch.mce_injection_disallowed)
+		return -EINVAL;
+
 	if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
-		goto out;
+		return -EINVAL;
 	if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
-		goto out;
-	r = 0;
+		return -EINVAL;
+
 	vcpu->arch.mcg_cap = mcg_cap;
 	/* Init IA32_MCG_CTL to all 1s */
 	if (mcg_cap & MCG_CTL_P)
@@ -4579,8 +4580,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
 
 	static_call(kvm_x86_setup_mce)(vcpu);
-out:
-	return r;
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
-- 
2.25.1

