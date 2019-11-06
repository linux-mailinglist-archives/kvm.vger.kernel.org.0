Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A5F1081
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 08:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731460AbfKFHm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 02:42:57 -0500
Received: from mga06.intel.com ([134.134.136.31]:15141 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731447AbfKFHm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 02:42:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 23:42:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="232770761"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 05 Nov 2019 23:42:53 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 8/9] mmu: spp: Handle SPP protected pages when VM memory changes
Date:   Wed,  6 Nov 2019 15:45:03 +0800
Message-Id: <20191106074504.14858-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191106074504.14858-1-weijiang.yang@intel.com>
References: <20191106074504.14858-1-weijiang.yang@intel.com>
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
index 9c5be402a0b2..7e9959a4a12b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1828,6 +1828,24 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
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
+				i = kvm_spp_get_permission(kvm, &spp_info);
+				if (i == 1 &&
+				    spp_info.access_map[0] != FULL_SPP_ACCESS)
+					new_spte |= PT_SPP_MASK;
+			}
+
 			new_spte = mark_spte_for_access_track(new_spte);
 
 			mmu_spte_clear_track_bits(sptep);
@@ -2677,6 +2695,10 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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

