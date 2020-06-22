Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D828D20431D
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 23:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbgFVV67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 17:58:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:15498 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbgFVV6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 17:58:35 -0400
IronPort-SDR: ePFeciQaA2xDIGsoK3HieD+Y6mRhzzZE3P0VDS+fDBFFURWRtMw7YsTtlpoD3En2I27d4J4WqE
 DUHpWosKREVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142148018"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142148018"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 14:58:34 -0700
IronPort-SDR: FKf+j5Zo6JsjDepZqz0ZHyAbu8Paq34XfFt1G/wi8duQO7e30tvtpiv8+c8oshJrP0T2mvpGLw
 ifArgNmbzM8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="300987316"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jun 2020 14:58:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: x86/mmu: Drop kvm_arch_write_log_dirty() wrapper
Date:   Mon, 22 Jun 2020 14:58:30 -0700
Message-Id: <20200622215832.22090-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622215832.22090-1-sean.j.christopherson@intel.com>
References: <20200622215832.22090-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_arch_write_log_dirty() in favor of invoking .write_log_dirty()
directly from FNAME(update_accessed_dirty_bits).  "kvm_arch" is usually
used for x86 functions that are invoked from generic KVM, and implies
that there are external callers, neither of which is true.

Remove the check for a non-NULL kvm_x86_ops hook as the call is wrapped
in PTTYPE_EPT and is unconditionally set by VMX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.h             |  1 -
 arch/x86/kvm/mmu/mmu.c         | 15 ---------------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 444bb9c54548..81cafc937cfb 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -222,7 +222,6 @@ void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
-int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76817d13c86e..a25427db1bb7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1738,21 +1738,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-/**
- * kvm_arch_write_log_dirty - emulate dirty page logging
- * @vcpu: Guest mode vcpu
- *
- * Emulate arch specific page modification logging for the
- * nested hypervisor
- */
-int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa)
-{
-	if (kvm_x86_ops.write_log_dirty)
-		return kvm_x86_ops.write_log_dirty(vcpu, l2_gpa);
-
-	return 0;
-}
-
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn)
 {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index cddd40029553..60e7b2308876 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -260,7 +260,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 				!(pte & PT_GUEST_DIRTY_MASK)) {
 			trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
 #if PTTYPE == PTTYPE_EPT
-			if (kvm_arch_write_log_dirty(vcpu, addr))
+			if (kvm_x86_ops.write_log_dirty(vcpu, addr))
 				return -EINVAL;
 #endif
 			pte |= PT_GUEST_DIRTY_MASK;
-- 
2.26.0

