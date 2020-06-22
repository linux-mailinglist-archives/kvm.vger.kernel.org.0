Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA272043E8
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgFVWnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:43:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:27426 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731253AbgFVWnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:43:03 -0400
IronPort-SDR: Oa+ueFLW84wxFleKAjZD1s98UNCorBROw/tXAvsthQJoamNEhd8IDEzREIbp2oEMrjX+NkrzNm
 V1Y3L420CKNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303579"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303579"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:56 -0700
IronPort-SDR: 8FKNo0ARdxWg/XLV+akSa+b+mTj3mHGCb4vr3xHaKPfR6kaZmfvZtnIyT2/4/XL23ou7NMG/Az
 tZ4G8WGCW/3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634945"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] KVM: VMX: Rename "vmx_msr_index" to "vmx_uret_msrs_list"
Date:   Mon, 22 Jun 2020 15:42:48 -0700
Message-Id: <20200622224249.29562-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 178315b2758b..e958c911dcf8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -449,9 +449,9 @@ static unsigned long host_idt_base;
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
@@ -630,7 +630,7 @@ static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 	int i;
 
 	for (i = 0; i < vmx->nr_uret_msrs; ++i)
-		if (vmx_msr_index[vmx->guest_uret_msrs[i].index] == msr)
+		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].index] == msr)
 			return i;
 	return -1;
 }
@@ -6888,10 +6888,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
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
 
@@ -7997,8 +7997,8 @@ static __init int hardware_setup(void)
 	store_idt(&dt);
 	host_idt_base = dt.address;
 
-	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
-		kvm_define_user_return_msr(i, vmx_msr_index[i]);
+	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i)
+		kvm_define_user_return_msr(i, vmx_uret_msrs_list[i]);
 
 	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
 		return -EIO;
-- 
2.26.0

