Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F292043E1
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgFVWnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:43:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:27425 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731257AbgFVWnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:43:03 -0400
IronPort-SDR: BK4wVfy6VI4xy6hiq4aFkiBX2tN6zZOeoF2q0IhcFY+PhjkqXlsnD7JrL0bgwzedZL5zj8BFQX
 Vb7m2h8+MWrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303581"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303581"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:56 -0700
IronPort-SDR: yUjHnqK5JTkgowcRt++MR9EaaYSccOy3UC0ftAPH/xvR5GHLMP/c39MAb9DR0L30VDKdDcguLk
 4iJaIiK628VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634948"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] KVM: VMX: Rename vmx_uret_msr's "index" to "slot"
Date:   Mon, 22 Jun 2020 15:42:49 -0700
Message-Id: <20200622224249.29562-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index e958c911dcf8..b335296ca02d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -630,7 +630,7 @@ static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 	int i;
 
 	for (i = 0; i < vmx->nr_uret_msrs; ++i)
-		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].index] == msr)
+		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].slot] == msr)
 			return i;
 	return -1;
 }
@@ -654,7 +654,7 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	msr->data = data;
 	if (msr - vmx->guest_uret_msrs < vmx->nr_active_uret_msrs) {
 		preempt_disable();
-		ret = kvm_set_user_return_msr(msr->index, msr->data, msr->mask);
+		ret = kvm_set_user_return_msr(msr->slot, msr->data, msr->mask);
 		preempt_enable();
 		if (ret)
 			msr->data = old_msr_data;
@@ -1151,7 +1151,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (!vmx->guest_uret_msrs_loaded) {
 		vmx->guest_uret_msrs_loaded = true;
 		for (i = 0; i < vmx->nr_active_uret_msrs; ++i)
-			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].index,
+			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].slot,
 						vmx->guest_uret_msrs[i].data,
 						vmx->guest_uret_msrs[i].mask);
 
@@ -6900,7 +6900,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		if (wrmsr_safe(index, data_low, data_high) < 0)
 			continue;
 
-		vmx->guest_uret_msrs[j].index = i;
+		vmx->guest_uret_msrs[j].slot = i;
 		vmx->guest_uret_msrs[j].data = 0;
 		switch (index) {
 		case MSR_IA32_TSX_CTRL:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 338469fcd8cf..57027072e21f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -34,7 +34,7 @@ struct vmx_msrs {
 };
 
 struct vmx_uret_msr {
-	unsigned index;
+	unsigned int slot; /* The MSR's slot in kvm_user_return_msrs. */
 	u64 data;
 	u64 mask;
 };
-- 
2.26.0

