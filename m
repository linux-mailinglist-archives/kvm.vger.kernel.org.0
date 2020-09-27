Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07187279FBC
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 10:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgI0IpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Sep 2020 04:45:14 -0400
Received: from mx58.baidu.com ([61.135.168.58]:52547 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727369AbgI0IpO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 27 Sep 2020 04:45:14 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id AD22711C0039;
        Sun, 27 Sep 2020 16:44:57 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     lirongqing@baidu.com, kvm@vger.kernel.org, x86@kernel.org,
        sean.j.christopherson@intel.com
Subject: [PATCH][v3] KVM: x86/mmu: fix counting of rmap entries in pte_list_add
Date:   Sun, 27 Sep 2020 16:44:57 +0800
Message-Id: <1601196297-24104-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix an off-by-one style bug in pte_list_add() where it failed to
account the last full set of SPTEs, i.e. when desc->sptes is full
and desc->more is NULL.

Merge the two "PTE_LIST_EXT-1" checks as part of the fix to avoid
an extra comparison.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
v2: Sean suggest to merge the two "PTE_LIST_EXT-1" checks
v3: Sean suggest to rewrite commit header

 arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5d0207e7189..c4068be6bb3f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1273,12 +1273,14 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 	} else {
 		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-		while (desc->sptes[PTE_LIST_EXT-1] && desc->more) {
-			desc = desc->more;
+		while (desc->sptes[PTE_LIST_EXT-1]) {
 			count += PTE_LIST_EXT;
-		}
-		if (desc->sptes[PTE_LIST_EXT-1]) {
-			desc->more = mmu_alloc_pte_list_desc(vcpu);
+
+			if (!desc->more) {
+				desc->more = mmu_alloc_pte_list_desc(vcpu);
+				desc = desc->more;
+				break;
+			}
 			desc = desc->more;
 		}
 		for (i = 0; desc->sptes[i]; ++i)
-- 
2.16.2

