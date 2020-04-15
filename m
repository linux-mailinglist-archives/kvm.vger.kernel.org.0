Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3861AB2BC
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 22:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371313AbgDOUfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 16:35:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:20838 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371297AbgDOUe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 16:34:58 -0400
IronPort-SDR: M6R5/OYKeXGN+WzQH8EPjQ+aZgo7p2YATvbJ5zZvvvwMHWaYR4M1p0Gb7boARTCdRwztcTrlyk
 ST7xaDCLV+Cg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 13:34:57 -0700
IronPort-SDR: 6WxqyeFfB0AbcZJKdvVLxSCZzx/AXNSTa0fEiaRTR5IgViZlXt/IUvtyjBHLWEhwAZ2kEOSDWE
 LxX/JBOf7lbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="288657640"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 15 Apr 2020 13:34:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: nVMX: Invoke ept_save_pdptrs() if and only if PAE paging is enabled
Date:   Wed, 15 Apr 2020 13:34:50 -0700
Message-Id: <20200415203454.8296-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415203454.8296-1-sean.j.christopherson@intel.com>
References: <20200415203454.8296-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invoke ept_save_pdptrs() when restoring L1's host state on a "late"
VM-Fail if and only if PAE paging is enabled.  This saves a CALL in the
common case where L1 is a 64-bit host, and avoids incorrectly marking
the PDPTRs as dirty.

WARN if ept_save_pdptrs() is called with PAE disabled now that the
nested usage pre-checks is_pae_paging().  Barring a bug in KVM's MMU,
attempting to read the PDPTRs with PAE disabled is now impossible.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aca57d8da400..f9ae42209d78 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4250,7 +4250,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 * VMFail, like everything else we just need to ensure our
 	 * software model is up-to-date.
 	 */
-	if (enable_ept)
+	if (enable_ept && is_pae_paging(vcpu))
 		ept_save_pdptrs(vcpu);
 
 	kvm_mmu_reset_context(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa1b8cf7c915..7da83325ace3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2937,12 +2937,13 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	if (is_pae_paging(vcpu)) {
-		mmu->pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
-		mmu->pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
-		mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
-		mmu->pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
-	}
+	if (WARN_ON_ONCE(!is_pae_paging(vcpu)))
+		return;
+
+	mmu->pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
+	mmu->pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
+	mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
+	mmu->pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
 
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 }
-- 
2.26.0

