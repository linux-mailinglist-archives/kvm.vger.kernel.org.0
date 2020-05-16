Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185521D6115
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgEPMyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:54:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:47572 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgEPMyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:54:08 -0400
IronPort-SDR: fqiYRe+9l8FY4V0HxyEoKp1/QPa7mtL75+vcgBPXrT2xLTkUiNhy1K/bR6YwyKyGHCiYVArKfv
 MnUWsTqKinXw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:54:08 -0700
IronPort-SDR: BrDdkqfzR1/jr+xo4DrGz87+tNuJVRPEvXXxA8EXjruM0abbQEOUE49tg3ojf+P4DcMAkr7MGB
 OJVJbz4EseOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076608"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:54:06 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 08/11] mmu: spp: Re-enable SPP protection when EPT mapping changes
Date:   Sat, 16 May 2020 20:55:04 +0800
Message-Id: <20200516125507.5277-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host page swapping/migration may change the translation in
EPT leaf entry, if the target page is SPP protected,
re-enable SPP protection. When SPPT mmu-page is reclaimed,
no need to clear rmap as no memory-mapping is in SPPT L4E.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9d5a0eb3d24e..1cf25752e37c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1796,6 +1796,19 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
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
@@ -2639,6 +2652,10 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level)) {
+			/* SPPT leaf entries don't have rmaps*/
+			if (sp->role.spp && sp->role.level ==
+			    PT_PAGE_TABLE_LEVEL)
+				return true;
 			drop_spte(kvm, spte);
 			if (is_large_pte(pte))
 				--kvm->stat.lpages;
-- 
2.17.2

