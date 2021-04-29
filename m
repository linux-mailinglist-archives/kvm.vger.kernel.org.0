Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0F036E3F6
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 06:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237239AbhD2ENX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 00:13:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:59903 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233053AbhD2ENX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 00:13:23 -0400
IronPort-SDR: E7qnCvHrzfKsfoVVNVjl9Pa09FL98WwfkRrp+p8oXISMB3kTBscycSWn6BAgyOHdn58d2EnTgD
 1zh91BHKGeyg==
X-IronPort-AV: E=McAfee;i="6200,9189,9968"; a="217641754"
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="217641754"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 21:12:37 -0700
IronPort-SDR: R6JlBqBXNxjXKXkVDgj2NAGbgnKw9sqHCl5eOC3IxqEqi/5e3F1fPQbMHjU876lRlfXkQn1g+y
 z01Dr+f563Cg==
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="393727468"
Received: from savora-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.50.252])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 21:12:35 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: x86/mmu: Avoid unnecessary page table allocation in kvm_tdp_mmu_map()
Date:   Thu, 29 Apr 2021 16:12:26 +1200
Message-Id: <20210429041226.50279-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_tdp_mmu_map(), while iterating TDP MMU page table entries, it is
possible SPTE has already been frozen by another thread but the frozen
is not done yet, for instance, when another thread is still in middle of
zapping large page.  In this case, the !is_shadow_present_pte() check
for old SPTE in tdp_mmu_for_each_pte() may hit true, and in this case
allocating new page table is unnecessary since tdp_mmu_set_spte_atomic()
later will return false and page table will need to be freed.  Add
is_removed_spte() check before allocating new page table to avoid this.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 83cbdbe5de5a..84ee1a76a79d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1009,6 +1009,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
+			/*
+			 * If SPTE has been forzen by another thread, just
+			 * give up and retry, avoiding unnecessary page table
+			 * allocation and free.
+			 */
+			if (is_removed_spte(iter.old_spte))
+				break;
+
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
 			child_pt = sp->spt;
 
-- 
2.30.2

