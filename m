Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC621658715
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 22:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiL1VdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 16:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiL1VdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 16:33:06 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1E7140C8
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 13:33:02 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id i4-20020a05620a248400b006febc1651bbso11743419qkn.4
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 13:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IL2YbOoN7yPmIShOQbEFF8vOUsSkAn/M3lJ9txKjS40=;
        b=DQd928Kdr25J4ElaX6WZIg0y5aPMxnpaZIJg7IPsyFdp7Z3sU095SY0P4pr93F+joX
         xUOk7tHxITprNKxjOzKUe37tbXK/nCU27n9rSpuQq1RpZsLqxdkYR8J3rkdvDie+cd+y
         ICbF0Bb4zALDvouCsj8CQka5kHUqA+uGamn/b8vdYyT2UPKCSqXq3xcLHVYsCFJ49nfE
         DEiCH87vUImae/stFU5wBLHDK0H2wgLqT9wzF1M2QF/ObcdX/Z82QE3LEsX8T45STvmL
         D1V14FdeAMzvVu4ud311bpNBF3CP3ub9xaQlueCFvMG89KPT/0ILIL398AEZfuEQs4Zg
         I1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IL2YbOoN7yPmIShOQbEFF8vOUsSkAn/M3lJ9txKjS40=;
        b=otI9CYQ/Q7Ja6kv8IN1A8CG3et6VmveReaGX9W8Dz/dpbj5j20ycntuOlCUIRuJskv
         1USZyalfSlOJ2AV8qYj0qZqKcmYbaID+6F/0a5ajw4Z/+w9GRvnfQB+frGIXe44awkqP
         8lWfSxKwv2shVtVpvT499S1RwaXy3ije8ytny/nlx718Q2l4zEGgC135lPfGCcpmDNwC
         fqcwS2WHE9+XgYgviY5eQYMvLkPiC862jy9bQuefnaAsO8NL4BbbLlcK/zL91lVrvXPY
         TCtc+7ewnmQRBcK6N1ckQGiwpXxsIuycgMMJmSAKd5q4J42lGHFJ00I3B/NUxZUsmLoY
         gp8Q==
X-Gm-Message-State: AFqh2kpn+DXhgjkTdTCXEwFibeFXcggwmKa+YHZce1bWDzcwqgnSLpxv
        b/BqLBj7VgIIYtb7usz5dfCroeic1AoXHQ==
X-Google-Smtp-Source: AMrXdXuT3YZ7pyxLMjotm+dwHDwO4EFMSgwCmbIC0SCzzCpxPS24vC4Udc+/ecWzG0atJluAdQBMxnC4sffFuA==
X-Received: from shacharr-cloud.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:4338])
 (user=shacharr job=sendgmr) by 2002:a0c:e991:0:b0:530:eae2:9240 with SMTP id
 z17-20020a0ce991000000b00530eae29240mr750777qvn.106.1672263181304; Wed, 28
 Dec 2022 13:33:01 -0800 (PST)
Date:   Wed, 28 Dec 2022 21:32:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221228213212.628636-1-shacharr@google.com>
Subject: [PATCH] Convert backwards goto into a while loop
From:   Shachar Raindel <shacharr@google.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shachar Raindel <shacharr@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function vaddr_get_pfns used a goto retry structure to implement
retrying.  This is discouraged by the coding style guide (which is
only recommending goto for handling function exits). Convert the code
to a while loop, making it explicit that the follow block only runs
when the pin attempt failed.

Signed-off-by: Shachar Raindel <shacharr@google.com>
---
 drivers/vfio/vfio_iommu_type1.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..7f38d7fc3f62 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -570,27 +570,28 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 		}
 
 		*pfn = page_to_pfn(pages[0]);
-		goto done;
-	}
+	} else
+		do {
+
+			/* This is not a normal page, lookup PFN for P2P DMA */
+			vaddr = untagged_addr(vaddr);
 
-	vaddr = untagged_addr(vaddr);
+			vma = vma_lookup(mm, vaddr);
 
-retry:
-	vma = vma_lookup(mm, vaddr);
+			if (!vma || !(vma->vm_flags & VM_PFNMAP))
+				break;
 
-	if (vma && vma->vm_flags & VM_PFNMAP) {
-		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
-		if (ret == -EAGAIN)
-			goto retry;
+			ret = follow_fault_pfn(vma, mm, vaddr, pfn,
+					       prot & IOMMU_WRITE);
+			if (ret)
+				continue; /* Retry for EAGAIN, otherwise bail */
 
-		if (!ret) {
 			if (is_invalid_reserved_pfn(*pfn))
 				ret = 1;
 			else
 				ret = -EFAULT;
-		}
-	}
-done:
+		} while (ret == -EAGAIN);
+
 	mmap_read_unlock(mm);
 	return ret;
 }
-- 
2.39.0.314.g84b9a713c41-goog

