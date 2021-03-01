Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5716A327919
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 09:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhCAIXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 03:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhCAIXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 03:23:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C76C061756;
        Mon,  1 Mar 2021 00:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ZJ0mfKKiDbtOHzYkThItWPT9FVUPlFxXRW4kC39qdzY=; b=akuYuScZTOm/ePhqN+lw6tAh+X
        EeA0ICEb9zGHyikYeCvJg7Wvh1O70JU3poaBuBIZNXXf5truxXDrdhnwWiLpTOTCRedeSWhL6hW5A
        jfq3x1EZl+WkPvIP+iwJjd5o2+bN8PhaDW8q0GstVPsHEFKmJttf/FG5ftPnhGG+Ik6EeH/fB1fuF
        lKBIIbrYQNSEOcHppQHkklDe9a5F4ucZKtuI1x91Dho/SvWCDZtFwAkla83CbArIJ+gkouPw3nIap
        OwuaSwyXevJZowcBYIQgpNN4sU59W5uf1UpvdT9ybQTb16t1s9iJ1n8S/WEWZMKBPX0t46rRPkiFl
        eWIOnrgg==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGdpD-00FTKm-Cy; Mon, 01 Mar 2021 08:22:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] samples/vfio-mdev/mdpy: use remap_vmalloc_range
Date:   Mon,  1 Mar 2021 09:22:34 +0100
Message-Id: <20210301082235.932968-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301082235.932968-1-hch@lst.de>
References: <20210301082235.932968-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use remap_vmalloc_range instead of open coding it using
remap_vmalloc_range_partial.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 samples/vfio-mdev/mdpy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 9894693f3be178..4fc73d0916ef7d 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -417,9 +417,7 @@ static int mdpy_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
 	if ((vma->vm_flags & VM_SHARED) == 0)
 		return -EINVAL;
 
-	return remap_vmalloc_range_partial(vma, vma->vm_start,
-					   mdev_state->memblk, 0,
-					   vma->vm_end - vma->vm_start);
+	return remap_vmalloc_range(vma, mdev_state->memblk, 0);
 }
 
 static int mdpy_get_region_info(struct mdev_device *mdev,
-- 
2.29.2

