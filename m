Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EF2391969
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhEZOCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:02:23 -0400
Received: from m12-17.163.com ([220.181.12.17]:45044 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232773AbhEZOCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 10:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=np1xT
        nXR7TJYHJG50CePV2iPhuGBuqYt438k6g7K+Lo=; b=PVEqI6nTcYqoSu/OAsjZD
        nljS8/BqZQon4G1xnTPgkalVzIUHYiRWdciTd5WLkVTaf5BhpVUIq/YECLH4paxR
        g2NPVIqTkb8V9wy5hbDS31+emX+zcsTBTJvh7ReCfX4TgZenjXdGh/Jw03twW5Uh
        DiTng8Kz5P7xgg2h3M1DJY=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowAAH936HVK5guP8X3g--.56229S2;
        Wed, 26 May 2021 22:00:39 +0800 (CST)
From:   =?UTF-8?q?=C2=A0Zhongjun=20Tan?= <hbut_tan@163.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tan Zhongjun <tanzhongjun@yulong.com>
Subject: [PATCH] virt/kvm/kvm_main.c: use vma_pages() helper
Date:   Wed, 26 May 2021 22:00:20 +0800
Message-Id: <20210526140020.2021-1-hbut_tan@163.com>
X-Mailer: git-send-email 2.30.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowAAH936HVK5guP8X3g--.56229S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrur1xZF15uw1rWw17uw1xKrg_yoWDGrg_Cr
        W0yw1SgrWvqr1ktryvq3ySqF97Ww1Fya1jvr15CFy5t3Wqga98Cr4DWw15AryjqrsrCayj
        g3Z8Ar1fKr9xKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnH5lUUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: xkex3sxwdqqiywtou0bp/xtbBqBmexl75ctSIfgAAse
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tan Zhongjun <tanzhongjun@yulong.com>

Use vma_pages function on vma object instead of explicit computation.
./virt/kvm/kvm_main.c:3247:29-35: WARNING: Consider using vma_pages helper on vma

Signed-off-by: Tan Zhongjun <tanzhongjun@yulong.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..1ac52cd1111d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3244,7 +3244,7 @@ static const struct vm_operations_struct kvm_vcpu_vm_ops = {
 static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct kvm_vcpu *vcpu = file->private_data;
-	unsigned long pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	unsigned long pages = vma_pages(vma);
 
 	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
 	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
-- 
2.17.1


