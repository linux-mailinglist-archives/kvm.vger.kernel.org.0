Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBEA10D900
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 18:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfK2RZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 12:25:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:64172 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727244AbfK2RZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 12:25:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Nov 2019 09:25:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,257,1571727600"; 
   d="scan'208";a="241109008"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 29 Nov 2019 09:25:39 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 08/10] mmu: spp: Handle SPP protected pages when VM memory changes
Date:   Sat, 30 Nov 2019 01:27:07 +0800
Message-Id: <20191129172709.11347-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191129172709.11347-1-weijiang.yang@intel.com>
References: <20191129172709.11347-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host page swapping/migration may change the translation in
EPT leaf entry, if the target page is SPP protected,
re-enable SPP protection in MMU notifier. If SPPT shadow
page is reclaimed, the level1 pages don't have rmap to clear.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2a407c74427d..410ddc234b46 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1828,6 +1828,19 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			new_spte &= ~PT_WRITABLE_MASK;
 			new_spte &= ~SPTE_HOST_WRITEABLE;
 
+			/*
+			 * if it's EPT leaf entry and the physical page is
+			 * SPP protected, then re-enable SPP protection for
+			 * the page.
+			 */
+			if (kvm->arch.spp_active &&
+			    level == PT_PAGE_TABLE_LEVEL) {
+				u32 *access = gfn_to_subpage_wp_info(slot, gfn);
+
+				if (access && *access != FULL_SPP_ACCESS)
+					new_spte |= PT_SPP_MASK;
+			}
+
 			new_spte = mark_spte_for_access_track(new_spte);
 
 			mmu_spte_clear_track_bits(sptep);
@@ -2677,6 +2690,10 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level)) {
+			/* SPPT leaf entries don't have rmaps*/
+			if (sp->role.level == PT_PAGE_TABLE_LEVEL &&
+			    is_spp_spte(sp))
+				return true;
 			drop_spte(kvm, spte);
 			if (is_large_pte(pte))
 				--kvm->stat.lpages;
-- 
2.17.2

