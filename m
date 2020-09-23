Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD2275F64
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgIWSFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:05:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:16537 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgIWSER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:17 -0400
IronPort-SDR: PqpDTSGhtriwCiwzW12VkpJ/kUh8Y49+ji46Tqcgouq9k/5XS1mRcmO73oraB080XH0QxfrAYa
 CHdXmUJUz3/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148637146"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148637146"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:13 -0700
IronPort-SDR: O1e0VRk/fGtkeOLXdbQ9ctzYEzBPqxZyjgIHNqNiOO7dhhANgvy0sup3gwhy3vziIRX8vwnYrs
 AodV51YPYTvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670308"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2020 11:04:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/15] KVM: VMX: Rename "vmx_msr_index" to "vmx_uret_msrs_list"
Date:   Wed, 23 Sep 2020 11:04:08 -0700
Message-Id: <20200923180409.32255-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "vmx_msr_index" to "vmx_uret_msrs_list" to associate it with the
uret MSRs array, and to avoid conflating "MSR's ECX index" with "MSR's
index into an array".  Similarly, don't use "slot" in the name as that
terminology is claimed by the common x86 "user_return_msrs" mechanism.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 363099ec661d..82dde6f77524 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -447,9 +447,9 @@ static unsigned long host_idt_base;
  * will emulate SYSCALL in legacy mode if the vendor string in guest
  * CPUID.0:{EBX,ECX,EDX} is "AuthenticAMD" or "AMDisbetter!" To
  * support this emulation, IA32_STAR must always be included in
- * vmx_msr_index[], even in i386 builds.
+ * vmx_uret_msrs_list[], even in i386 builds.
  */
-const u32 vmx_msr_index[] = {
+const u32 vmx_uret_msrs_list[] = {
 #ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
@@ -628,7 +628,7 @@ static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 	int i;
 
 	for (i = 0; i < vmx->nr_uret_msrs; ++i)
-		if (vmx_msr_index[vmx->guest_uret_msrs[i].index] == msr)
+		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].index] == msr)
 			return i;
 	return -1;
 }
@@ -6847,10 +6847,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vpid;
 	}
 
-	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != MAX_NR_USER_RETURN_MSRS);
+	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
 
-	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
-		u32 index = vmx_msr_index[i];
+	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
+		u32 index = vmx_uret_msrs_list[i];
 		u32 data_low, data_high;
 		int j = vmx->nr_uret_msrs;
 
@@ -7917,8 +7917,8 @@ static __init int hardware_setup(void)
 	store_idt(&dt);
 	host_idt_base = dt.address;
 
-	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
-		kvm_define_user_return_msr(i, vmx_msr_index[i]);
+	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i)
+		kvm_define_user_return_msr(i, vmx_uret_msrs_list[i]);
 
 	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
 		return -EIO;
-- 
2.28.0

