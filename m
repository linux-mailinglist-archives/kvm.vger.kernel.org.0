Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC081377EC
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbfFFPaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:30:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:53979 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfFFPaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:30:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:30:06 -0700
X-ExtLoop1: 1
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2019 08:30:05 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 9/9] KVM: MMU: Handle host memory remapping and reclaim
Date:   Thu,  6 Jun 2019 23:28:12 +0800
Message-Id: <20190606152812.13141-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190606152812.13141-1-weijiang.yang@intel.com>
References: <20190606152812.13141-1-weijiang.yang@intel.com>
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
 arch/x86/kvm/mmu.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8ca6e2d89a40..8a55b9572723 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1926,6 +1926,24 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			new_spte &= ~PT_WRITABLE_MASK;
 			new_spte &= ~SPTE_HOST_WRITEABLE;
 
+			/*
+			 * if it's EPT leaf entry and the physical page is
+			 * SPP protected, then re-enable SPP protection for
+			 * the page.
+			 */
+			if (kvm->arch.spp_active &&
+			    level == PT_PAGE_TABLE_LEVEL) {
+				struct kvm_subpage spp_info = {0};
+				int i;
+
+				spp_info.base_gfn = gfn;
+				spp_info.npages = 1;
+				i = kvm_mmu_get_subpages(kvm, &spp_info, true);
+				if (i == 1 &&
+				    spp_info.access_map[0] != FULL_SPP_ACCESS)
+					new_spte |= PT_SPP_MASK;
+			}
+
 			new_spte = mark_spte_for_access_track(new_spte);
 
 			mmu_spte_clear_track_bits(sptep);
@@ -2809,6 +2827,10 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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

