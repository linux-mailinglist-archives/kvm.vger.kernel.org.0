Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23361159D4
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLFX5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:57:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:55584 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfLFX5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530371"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] KVM: x86/mmu: WARN on an invalid root_hpa
Date:   Fri,  6 Dec 2019 15:57:28 -0800
Message-Id: <20191206235729.29263-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN on the existing invalid root_hpa checks in __direct_map() and
FNAME(fetch).  The "legitimate" path that invalidated root_hpa in the
middle of a page fault is long since gone, i.e. it should no longer be
impossible to invalidate in the middle of a page fault[*].

The root_hpa checks were added by two related commits

  989c6b34f6a94 ("KVM: MMU: handle invalid root_hpa at __direct_map")
  37f6a4e237303 ("KVM: x86: handle invalid root_hpa everywhere")

to fix a bug where nested_vmx_vmexit() could be called *in the middle*
of a page fault.  At the time, vmx_interrupt_allowed(), which was and
still is used by kvm_can_do_async_pf() via ->interrupt_allowed(),
directly invoked nested_vmx_vmexit() to switch from L2 to L1 to emulate
a VM-Exit on a pending interrupt.  Emulating the nested VM-Exit resulted
in root_hpa being invalidated by kvm_mmu_reset_context() without
explicitly terminating the page fault.

Now that root_hpa is checked for validity by kvm_mmu_page_fault(), WARN
on an invalid root_hpa to detect any flows that reset the MMU while
handling a page fault.  The broken vmx_interrupt_allowed() behavior has
long since been fixed and resetting the MMU during a page fault should
not be considered legal behavior.

[*] It's actually technically possible in FNAME(page_fault)() because it
    calls inject_page_fault() when the guest translation is invalid, but
    in that case the page fault handling is immediately terminated.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5e8666d25053..88fd1022731f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3387,7 +3387,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	gfn_t base_gfn = gfn;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
+	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
 	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 3b0ba2a77e28..b53bed3c901c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -637,7 +637,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	if (FNAME(gpte_changed)(vcpu, gw, top_level))
 		goto out_gpte_changed;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
+	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		goto out_gpte_changed;
 
 	for (shadow_walk_init(&it, vcpu, addr);
-- 
2.24.0

