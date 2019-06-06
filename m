Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A67377E1
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbfFFPaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:30:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:53979 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729439AbfFFPaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:30:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:30:05 -0700
X-ExtLoop1: 1
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2019 08:30:03 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 8/9] KVM: MMU: Enable Lazy mode SPPT setup
Date:   Thu,  6 Jun 2019 23:28:11 +0800
Message-Id: <20190606152812.13141-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190606152812.13141-1-weijiang.yang@intel.com>
References: <20190606152812.13141-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If SPP subpages are set while the physical page are not
available in EPT leaf entry, the mapping is first stored
in SPP access bitmap buffer. SPPT setup is deferred to
access to the protected page, in EPT page fault handler,
the SPPT enries are set up.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/mmu.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0e016660b2b4..8ca6e2d89a40 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4304,6 +4304,26 @@ check_hugepage_cache_consistency(struct kvm_vcpu *vcpu, gfn_t gfn, int level)
 	return kvm_mtrr_check_gfn_range_consistency(vcpu, gfn, page_num);
 }
 
+static int kvm_enable_spp_protection(struct kvm *kvm, u64 gfn)
+{
+	struct kvm_subpage spp_info = {0};
+	struct kvm_memory_slot *slot;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot)
+		return -EFAULT;
+
+	spp_info.base_gfn = gfn;
+	spp_info.npages = 1;
+
+	if (kvm_mmu_get_subpages(kvm, &spp_info, true) < 0)
+		return -EFAULT;
+
+	if (spp_info.access_map[0] != FULL_SPP_ACCESS)
+		kvm_mmu_set_subpages(kvm, &spp_info, true);
+
+	return 0;
+}
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 			  bool prefault)
 {
@@ -4355,6 +4375,10 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, write, map_writable, level, gfn, pfn, prefault);
+
+	if (vcpu->kvm->arch.spp_active && level == PT_PAGE_TABLE_LEVEL)
+		kvm_enable_spp_protection(vcpu->kvm, gfn);
+
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
-- 
2.17.2

