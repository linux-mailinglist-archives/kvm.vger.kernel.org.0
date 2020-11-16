Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9F32B4FC4
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388425AbgKPSdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:33:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:20632 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387967AbgKPS2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:02 -0500
IronPort-SDR: di7sk8XbKdhpmIzmkNq7//68U6Td0IMEP3Td53niZX9srnYPex7W7x2Jp9tId4bbiUha2utAWO
 e39RmAJyajhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410018"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410018"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:01 -0800
IronPort-SDR: 3qzqJl0UN+MA5VvL+rL7AjbQ/k+loXJpB2Uj9oqSP6mtBFw2jJwwgWs/xBrkdJb53FHZRv5Iez
 /mmzD0PYCaxQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527929"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:00 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [RFC PATCH 19/67] KVM: x86: Add flag to disallow #MC injection / KVM_X86_SETUP_MCE
Date:   Mon, 16 Nov 2020 10:26:04 -0800
Message-Id: <d017cd51d02e42e9f14065acc7ec35ce82edc8bd.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a flag to disallow MCE injection and reject KVM_X86_SETUP_MCE with
-EINVAL when set.  TDX doesn't support injecting exceptions, including
(virtual) #MCs.

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8180a1fe610..70528102d865 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -996,6 +996,7 @@ struct kvm_arch {
 
 	bool guest_state_protected;
 	bool irq_injection_disallowed;
+	bool mce_injection_disallowed;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ec66d5d53a1a..2fb0d20c5788 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4095,15 +4095,16 @@ static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
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
@@ -4113,8 +4114,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
 
 	kvm_x86_ops.setup_mce(vcpu);
-out:
-	return r;
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
-- 
2.17.1

