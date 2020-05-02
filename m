Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C701C22F5
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgEBEcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:32:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:55787 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgEBEch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:37 -0400
IronPort-SDR: +sVfs6VTwv1tO/sa1wdOBk6a99rjaplP5E2gXgxE68SqPJ53Qefm17d2kWsLg9IokMH/kYpRyS
 owf/HSs3feeg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:37 -0700
IronPort-SDR: ttUEoi4qvg4UT85uXLGbzQGb6lp6qCUYm1CAP1RECZ8qXBpnHhyd32smMMI5yXsG8BOKLSA2dI
 pSW8iUL7MPPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516117"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 01 May 2020 21:32:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] KVM: nVMX: Unconditionally validate CR3 during nested transitions
Date:   Fri,  1 May 2020 21:32:26 -0700
Message-Id: <20200502043234.12481-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unconditionally check the validity of the incoming CR3 during nested
VM-Enter/VM-Exit to avoid invoking kvm_read_cr3() in the common case
where the guest isn't using PAE paging.  If vmcs.GUEST_CR3 hasn't yet
been cached (common case), kvm_read_cr3() will trigger a VMREAD.  The
VMREAD (~30 cycles) alone is likely slower than nested_cr3_valid()
(~5 cycles if vcpu->arch.maxphyaddr gets a cache hit), and the poor
exchange only gets worse when retpolines are enabled as the call to
kvm_x86_ops.cache_reg() will incur a retpoline (60+ cycles).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b57420f3dd8f..1f2f41e821f9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1120,21 +1120,20 @@ static bool nested_vmx_transition_mmu_sync(struct kvm_vcpu *vcpu)
 static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
 			       u32 *entry_failure_code)
 {
-	if (cr3 != kvm_read_cr3(vcpu) || (!nested_ept && pdptrs_changed(vcpu))) {
-		if (CC(!nested_cr3_valid(vcpu, cr3))) {
-			*entry_failure_code = ENTRY_FAIL_DEFAULT;
-			return -EINVAL;
-		}
+	if (CC(!nested_cr3_valid(vcpu, cr3))) {
+		*entry_failure_code = ENTRY_FAIL_DEFAULT;
+		return -EINVAL;
+	}
 
-		/*
-		 * If PAE paging and EPT are both on, CR3 is not used by the CPU and
-		 * must not be dereferenced.
-		 */
-		if (is_pae_paging(vcpu) && !nested_ept) {
-			if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
-				*entry_failure_code = ENTRY_FAIL_PDPTE;
-				return -EINVAL;
-			}
+	/*
+	 * If PAE paging and EPT are both on, CR3 is not used by the CPU and
+	 * must not be dereferenced.
+	 */
+	if (!nested_ept && is_pae_paging(vcpu) &&
+	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
+		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
+			*entry_failure_code = ENTRY_FAIL_PDPTE;
+			return -EINVAL;
 		}
 	}
 
-- 
2.26.0

