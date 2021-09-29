Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF3D41BFE6
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 09:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243348AbhI2Hai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 03:30:38 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55956 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243109AbhI2Hah (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 03:30:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uq.dtWR_1632900533;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Uq.dtWR_1632900533)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 15:28:55 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] KVM: use vma_pages() helper
Date:   Wed, 29 Sep 2021 15:28:46 +0800
Message-Id: <1632900526-119643-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vma_pages function on vma object instead of explicit computation.

Fix the following coccicheck warning:
./virt/kvm/kvm_main.c:3526:29-35: WARNING: Consider using vma_pages
helper on vma

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a..8f0e9ea 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3523,7 +3523,7 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct kvm_vcpu *vcpu = file->private_data;
-	unsigned long pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	unsigned long pages = vma_pages(vma);
 
 	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
 	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
-- 
1.8.3.1

