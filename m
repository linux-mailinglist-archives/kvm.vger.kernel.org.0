Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA46272145
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 12:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgIUKhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 06:37:00 -0400
Received: from mx59.baidu.com ([61.135.168.59]:38569 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726333AbgIUKhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 06:37:00 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 06:36:59 EDT
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 3E11A11C004B;
        Mon, 21 Sep 2020 18:29:26 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     lirongqing@baidu.com, kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] KVM: x86/mmu: fix counting of rmap entries in pte_list_add
Date:   Mon, 21 Sep 2020 18:29:26 +0800
Message-Id: <1600684166-32430-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

counting of rmap entries was missed when desc->sptes is full
and desc->more is NULL

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5d0207e7189..8ffa4e40b650 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1280,6 +1280,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		if (desc->sptes[PTE_LIST_EXT-1]) {
 			desc->more = mmu_alloc_pte_list_desc(vcpu);
 			desc = desc->more;
+			count += PTE_LIST_EXT;
 		}
 		for (i = 0; desc->sptes[i]; ++i)
 			++count;
-- 
2.16.2

