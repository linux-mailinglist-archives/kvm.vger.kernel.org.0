Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168A56BD2F
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 15:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfGQNgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 09:36:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:36164 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbfGQNgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 09:36:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 06:36:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,274,1559545200"; 
   d="scan'208";a="191261892"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jul 2019 06:36:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 8/9] KVM: MMU: Enable Lazy mode SPPT setup
Date:   Wed, 17 Jul 2019 21:37:50 +0800
Message-Id: <20190717133751.12910-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190717133751.12910-1-weijiang.yang@intel.com>
References: <20190717133751.12910-1-weijiang.yang@intel.com>
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
index 419878301375..f017fe6cd67b 100644
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

