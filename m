Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38654275F55
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgIWSEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:04:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:39927 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgIWSEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:34 -0400
IronPort-SDR: tYl8cTGgLEnImr5YawWd/WXI3IlEVseEfSwFAi0fkENbZ9U+3bcNLG+BIQRTzdU39xptNFEsYi
 ZlCt1SSzwHSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="245808975"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245808975"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:13 -0700
IronPort-SDR: AJXo4vYtrHlrOudj8GEG+jRGipD6V+1/HMF2ch1JIKMI1NJkDV4U/z2JPg5FPYrxpCQ1wuBEWe
 DAduaFp3RpUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670311"
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
Subject: [PATCH v2 15/15] KVM: VMX: Rename vmx_uret_msr's "index" to "slot"
Date:   Wed, 23 Sep 2020 11:04:09 -0700
Message-Id: <20200923180409.32255-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "index" to "slot" in struct vmx_uret_msr to align with the
terminology used by common x86's kvm_user_return_msrs, and to avoid
conflating "MSR's ECX index" with "MSR's index into an array".

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 arch/x86/kvm/vmx/vmx.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 82dde6f77524..d05b8b194b1e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -628,7 +628,7 @@ static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 	int i;
 
 	for (i = 0; i < vmx->nr_uret_msrs; ++i)
-		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].index] == msr)
+		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].slot] == msr)
 			return i;
 	return -1;
 }
@@ -652,7 +652,7 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	msr->data = data;
 	if (msr - vmx->guest_uret_msrs < vmx->nr_active_uret_msrs) {
 		preempt_disable();
-		ret = kvm_set_user_return_msr(msr->index, msr->data, msr->mask);
+		ret = kvm_set_user_return_msr(msr->slot, msr->data, msr->mask);
 		preempt_enable();
 		if (ret)
 			msr->data = old_msr_data;
@@ -1149,7 +1149,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (!vmx->guest_uret_msrs_loaded) {
 		vmx->guest_uret_msrs_loaded = true;
 		for (i = 0; i < vmx->nr_active_uret_msrs; ++i)
-			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].index,
+			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].slot,
 						vmx->guest_uret_msrs[i].data,
 						vmx->guest_uret_msrs[i].mask);
 
@@ -6859,7 +6859,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		if (wrmsr_safe(index, data_low, data_high) < 0)
 			continue;
 
-		vmx->guest_uret_msrs[j].index = i;
+		vmx->guest_uret_msrs[j].slot = i;
 		vmx->guest_uret_msrs[j].data = 0;
 		switch (index) {
 		case MSR_IA32_TSX_CTRL:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 05c81fcd184e..7b7f7f38c362 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -35,7 +35,7 @@ struct vmx_msrs {
 };
 
 struct vmx_uret_msr {
-	unsigned index;
+	unsigned int slot; /* The MSR's slot in kvm_user_return_msrs. */
 	u64 data;
 	u64 mask;
 };
-- 
2.28.0

