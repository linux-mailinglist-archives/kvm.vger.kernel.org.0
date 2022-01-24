Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C87497725
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 03:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiAXCFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 21:05:02 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45646 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232200AbiAXCFC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 23 Jan 2022 21:05:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V2cEg0T_1642989898;
Received: from localhost(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0V2cEg0T_1642989898)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 Jan 2022 10:04:58 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH] KVM: remove async parameter of hva_to_pfn_remapped()
Date:   Mon, 24 Jan 2022 10:04:56 +0800
Message-Id: <20220124020456.156386-1-xianting.tian@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The async parameter of hva_to_pfn_remapped() is not used, so remove it.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9a20f2299..876315093 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2463,9 +2463,8 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
 }
 
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
-			       unsigned long addr, bool *async,
-			       bool write_fault, bool *writable,
-			       kvm_pfn_t *p_pfn)
+			       unsigned long addr, bool write_fault,
+			       bool *writable, kvm_pfn_t *p_pfn)
 {
 	kvm_pfn_t pfn;
 	pte_t *ptep;
@@ -2575,7 +2574,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (vma == NULL)
 		pfn = KVM_PFN_ERR_FAULT;
 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
-		r = hva_to_pfn_remapped(vma, addr, async, write_fault, writable, &pfn);
+		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
 		if (r == -EAGAIN)
 			goto retry;
 		if (r < 0)
-- 
2.17.1

