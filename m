Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C145927501F
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 06:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgIWE7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 00:59:12 -0400
Received: from mx52.baidu.com ([61.135.168.52]:25347 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726198AbgIWE7M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 00:59:12 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id 28438236C005;
        Wed, 23 Sep 2020 12:58:55 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     lirongqing@baidu.com, kvm@vger.kernel.org, x86@kernel.org,
        sean.j.christopherson@intel.com
Subject: [PATCH][v2] KVM: x86/mmu: fix counting of rmap entries in pte_list_add
Date:   Wed, 23 Sep 2020 12:58:58 +0800
Message-Id: <1600837138-21110-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

counting of rmap entries was missed when desc->sptes is full
and desc->more is NULL

and merging two PTE_LIST_EXT-1 check as one, to avoids the
extra comparison to give slightly optimization

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1: merge two check as one

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

