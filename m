Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13FF18DA3D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgCTV3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:37251 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbgCTV3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:29:00 -0400
IronPort-SDR: 014SflZN0uXbgZsFcQgD5AU6+NYFF14XQtQpTuE9p+poB6ksZJRA5ealm8cEXu+YHfdkIi2Xwh
 yJcZT6x+eeQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:29:00 -0700
IronPort-SDR: PFHinYdCGOy0qd6cxU35XcxTzmJ35pmKYNQAJMh+VFUoGo1MOQCuOOOYYThFgIvbURg4QkNx4M
 AMzfm/0l15sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224526"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 34/37] KVM: nVMX: Don't flush TLB on nested VMX transition
Date:   Fri, 20 Mar 2020 14:28:30 -0700
Message-Id: <20200320212833.3507-35-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unconditionally skip the TLB flush triggered when reusing a root for a
nested transition as nested_vmx_transition_tlb_flush() ensures the TLB
is flushed when needed, regardless of whether the MMU can reuse a cached
root (or the last root).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c    | 2 +-
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 84e1e748c2b3..7b0fb7f2c24d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5038,7 +5038,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false, true);
+	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, true, true);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index db3ce8f297c2..92aab4166498 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1161,10 +1161,12 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	}
 
 	/*
-	 * See nested_vmx_transition_mmu_sync for details on skipping the MMU sync.
+	 * Unconditionally skip the TLB flush on fast CR3 switch, all TLB
+	 * flushes are handled by nested_vmx_transition_tlb_flush().  See
+	 * nested_vmx_transition_mmu_sync for details on skipping the MMU sync.
 	 */
 	if (!nested_ept)
-		kvm_mmu_new_cr3(vcpu, cr3, false,
+		kvm_mmu_new_cr3(vcpu, cr3, true,
 				!nested_vmx_transition_mmu_sync(vcpu));
 
 	vcpu->arch.cr3 = cr3;
-- 
2.24.1

