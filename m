Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B68E275F69
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWSEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:04:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:16539 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgIWSEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:14 -0400
IronPort-SDR: ivt3Fjr6RpmPtzKRXpEHIHhNFnUrWBmgvsXjJf9L8k22flsZQPrJ1/kRA5Xkyem2phMSkQkvCW
 bGEFWPWX+SbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148637129"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148637129"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:12 -0700
IronPort-SDR: QeNt49dA6LelnziM824p2fSvx9L47AkR0wcDogx1+G0450Rk8itC2WfKUbILiVCnGUHjc24/4s
 ynB+wBFL4nyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670273"
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
Subject: [PATCH v2 05/15] KVM: VMX: Rename vcpu_vmx's "nmsrs" to "nr_uret_msrs"
Date:   Wed, 23 Sep 2020 11:03:59 -0700
Message-Id: <20200923180409.32255-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename vcpu_vmx.nsmrs to vcpu_vmx.nr_uret_msrs to explicitly associate
it with the guest_uret_msrs array.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 arch/x86/kvm/vmx/vmx.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0a8f43161966..6048d0e35d11 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -627,7 +627,7 @@ static inline int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
-	for (i = 0; i < vmx->nmsrs; ++i)
+	for (i = 0; i < vmx->nr_uret_msrs; ++i)
 		if (vmx_msr_index[vmx->guest_uret_msrs[i].index] == msr)
 			return i;
 	return -1;
@@ -6855,7 +6855,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
 		u32 index = vmx_msr_index[i];
 		u32 data_low, data_high;
-		int j = vmx->nmsrs;
+		int j = vmx->nr_uret_msrs;
 
 		if (rdmsr_safe(index, &data_low, &data_high) < 0)
 			continue;
@@ -6877,7 +6877,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			vmx->guest_uret_msrs[j].mask = -1ull;
 			break;
 		}
-		++vmx->nmsrs;
+		++vmx->nr_uret_msrs;
 	}
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 757cb35a6895..e9cd01868389 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -219,7 +219,7 @@ struct vcpu_vmx {
 	ulong                 rflags;
 
 	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
-	int                   nmsrs;
+	int                   nr_uret_msrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_ready;
 #ifdef CONFIG_X86_64
-- 
2.28.0

