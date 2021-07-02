Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72133BA5AB
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhGBWJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:50197 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233131AbhGBWH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472732"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472732"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:24 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814756"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:23 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [RFC PATCH v2 26/69] KVM: x86: Add flag to disallow #MC injection / KVM_X86_SETUP_MCE
Date:   Fri,  2 Jul 2021 15:04:32 -0700
Message-Id: <456e910585c72e5dfdff30bfea63afa874965479.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
index be329f0a7054..09e51c5e86b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1064,6 +1064,7 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 	bool irq_injection_disallowed;
+	bool mce_injection_disallowed;
 
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4070786f17d1..681fc3be2b2b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4319,15 +4319,16 @@ static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
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
@@ -4337,8 +4338,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
 
 	static_call(kvm_x86_setup_mce)(vcpu);
-out:
-	return r;
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
-- 
2.25.1

