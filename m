Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E74065C7B8
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 20:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbjACTuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 14:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbjACTuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 14:50:03 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B0C13FA0
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 11:49:57 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-482d3bf0266so195278877b3.3
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 11:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jDIlvgpkH8iNlqq7l2184WeZDOwRlpuQV03cFER0U7w=;
        b=aTOJgoJy8rySUAkoIrvXhFtGQYvn2sTF5/jcit5bwFsGNIoBSLgup3v6qSrpBRHauM
         /s2W8ykqO5uFbndv1m3PWj3CY9Sk0OiSUCtujS3cQy0SKi6X0whsdkiSa1Mlu4pHQi9t
         gD5FQVHkij3l49o2c6pK7uQd0EnWZqKksH/56++BeKTQ3jV4wnr7WkmyxGNAp3G4Z4WQ
         ZhEpCU6gZkOUGJJWHm/T6ZxykJEVnR8jSKYMnh7urVdnlWcEy94t2uJvfucyUrsu+m00
         SFXq8M6EG9XmnVU5ApQcKb4GZIElm8O6Gr4tFPL0+dVD5BKa3ybwuevjTrSAvVU7V2E+
         iNyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jDIlvgpkH8iNlqq7l2184WeZDOwRlpuQV03cFER0U7w=;
        b=3MPBzTARbNvWtJ8Bfk+1VZ4gAbnJF0Q1LMBhdvQ3irbzhjMfu+BXFJtyHS0mjqpADL
         EvcXfT4YV/6c7D/IXGQge2oEheBHo8GukEaQEh7JLWCobmkPblkIna9qOLs6hNSCsyAj
         ZsgpCJrFmLxLs8ikNpEmfOMvFsl8alGq/5fWZng5FgbtyXkS4xBWDuKhmGpg5OfKpK7n
         1IzprrsSt1MDKfrzMC7blwC08vgvd5cK2dHHr4Fz4mx1BcKba0McoZSnGn39MupqVyKC
         WbROEGsqAMni8BAxuNrlfYdMcFELq39T2V3cxyCcr+dhady85uiyuci/37vFlgRetISt
         SqbA==
X-Gm-Message-State: AFqh2koh2z5QovUzC8H52SMemn6l/rhCTMur9URDESYUAvpY6Bxbtn1r
        LXMDmYVaqUyrQVXsVGMrD9OA8CIH703pQQ==
X-Google-Smtp-Source: AMrXdXs94OhfYslkzD4CrXv2Mg2dC+rwFPWdjEmy72Ik6eroOQ37CgxOVr2BWvGwbhkolun6DdMx8ZPqP8rw+Q==
X-Received: from shacharr-cloud.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:4338])
 (user=shacharr job=sendgmr) by 2002:a25:664d:0:b0:7aa:110b:ea86 with SMTP id
 z13-20020a25664d000000b007aa110bea86mr433342ybm.248.1672775396448; Tue, 03
 Jan 2023 11:49:56 -0800 (PST)
Date:   Tue,  3 Jan 2023 19:49:48 +0000
In-Reply-To: <20230103104338.4371e012.alex.williamson@redhat.com>
Mime-Version: 1.0
References: <20230103104338.4371e012.alex.williamson@redhat.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230103194948.1806373-1-shacharr@google.com>
Subject: [PATCH v2] Convert backwards goto with a while loop
From:   Shachar Raindel <shacharr@google.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shachar Raindel <shacharr@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function vaddr_get_pfns used a goto retry structure to implement
retrying.  This is a gray area in the coding style guide (which is
only explicitly recommending goto for handling function exits).
Convert the code to a while loop, making it explicit that the
following block only runs when the pin attempt failed.

Signed-off-by: Shachar Raindel <shacharr@google.com>
---

Changelog:

v1 -> v2: Refine commit message, fix minor code style issue

 drivers/vfio/vfio_iommu_type1.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..6335eabe1b7c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -570,27 +570,28 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 		}
 
 		*pfn = page_to_pfn(pages[0]);
-		goto done;
-	}
+	} else {
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
+	}
 	mmap_read_unlock(mm);
 	return ret;
 }
-- 
2.39.0.314.g84b9a713c41-goog

