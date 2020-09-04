Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E4F25DB13
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbgIDOM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:12:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44694 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730588AbgIDNpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 09:45:23 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200904133511euoutp0164563fcc7c300abedc449f32d94126ad~xmAoWy3GJ0721507215euoutp01x
        for <kvm@vger.kernel.org>; Fri,  4 Sep 2020 13:35:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200904133511euoutp0164563fcc7c300abedc449f32d94126ad~xmAoWy3GJ0721507215euoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599226511;
        bh=58WfIsMQtyJl7jKA0xKnsRe1U/pxzIhIdCQa1t7BJpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTlKnAw+fxk26VLKXWeIA0uc5DQDWeVgEKv/ZJljyw6UhyPT5IkjxwvU6gYZMqcJ6
         qM9QUnVWYEdNfs/jl7Tu8DxuJpJHp7IdKtaMsa1vbRnLYUA9p7lq9UmQ2eA+ywu6d/
         n+OgC5UwunH8UE/iPoSP/dS8K/9xRhuwvSYN47l4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200904133511eucas1p1db8cd5f80eec531ed3f17eff8e18b6c3~xmAoEqN5-0114101141eucas1p1B;
        Fri,  4 Sep 2020 13:35:11 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id C2.76.05997.F82425F5; Fri,  4
        Sep 2020 14:35:11 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200904133511eucas1p2f7241258a90f27b0aa67e62e74c48727~xmAnuPz-g1447714477eucas1p2f;
        Fri,  4 Sep 2020 13:35:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200904133511eusmtrp2fb28d0c94602321d95e9c106fbea7422~xmAnthj880977109771eusmtrp2P;
        Fri,  4 Sep 2020 13:35:11 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-7f-5f52428f5f85
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 84.B0.06017.E82425F5; Fri,  4
        Sep 2020 14:35:11 +0100 (BST)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200904133510eusmtip15068735ab97c561d115ca561029ac0cb~xmAnIuEoi2113421134eusmtip15;
        Fri,  4 Sep 2020 13:35:10 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     dri-devel@lists.freedesktop.org, iommu@lists.linux-foundation.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: [PATCH v10 28/30] samples: vfio-mdev/mbochs: fix common struct
 sg_table related issues
Date:   Fri,  4 Sep 2020 15:17:09 +0200
Message-Id: <20200904131711.12950-29-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904131711.12950-1-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7djPc7r9TkHxBg2LpCx6z51kstg4Yz2r
        xf9tE5ktrnx9z2axcvVRJosF+60t5kwttNhyei6jxZcrD5ksNj2+xmpxedccNou1R+6yWxz8
        8ITVgddjzbw1jB57vy1g8dj+7QGrx/3u40wem5fUe9z+95jZY/KN5Yweu282sHn0Nr9j8+jb
        sorR4/MmuQDuKC6blNSczLLUIn27BK6Maes3sxdcE6xY+fkSewPjPb4uRg4OCQETicNbg7oY
        uTiEBFYwSixZ2MUO4XxhlHjduhfK+cwo0bDgHxNMR+v+MIj4ckaJNZfXMcJ1rDp0Csjh5GAT
        MJToetvFBmKLCLQySpzo5QEpYha4xiTx9u87VpCEsECixL59p8FsFgFVia2H/oLZvAJ2Ejva
        X4ANkhCQl1i94QAziM0JFN864wkryCAJgUPsEm+/bmeBOMlFYtUjd4h6YYlXx7ewQ9gyEv93
        zmeCqG9mlHh4bi07hNPDKHG5aQbUBmuJO+d+sYEMYhbQlFi/Sx8i7CjxdMJTqJf5JG68FQQJ
        MwOZk7ZNZ4YI80p0tAlBVKtJzDq+Dm7twQuXmCFsD4n5/59AQ3Eio8ShP+/ZJjDKz0JYtoCR
        cRWjeGppcW56arFRXmq5XnFibnFpXrpecn7uJkZgWjr97/iXHYy7/iQdYhTgYFTi4WWwD4oX
        Yk0sK67MPcQowcGsJMLrdPZ0nBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe40UvY4UE0hNLUrNT
        UwtSi2CyTBycUg2MdZuvJnStZ8h5XjTdtCFu3WqLoEcbtpgyLnn05bUu61XmvuBw3fsfTyye
        0Kn5PHhVEL/ZlwkfmesmOEmVrvO3ikw7vOCwMjvj7elh/7S/iVtNX/Y8LNnu+qaqPWZdMwqn
        17We3V3erj5rsYFvp8SbH0vnG8f+f1cTWDU31OPvZ33xZv1U/csVSizFGYmGWsxFxYkAlWSI
        NEcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xu7r9TkHxBltXMVn0njvJZLFxxnpW
        i//bJjJbXPn6ns1i5eqjTBYL9ltbzJlaaLHl9FxGiy9XHjJZbHp8jdXi8q45bBZrj9xltzj4
        4QmrA6/HmnlrGD32flvA4rH92wNWj/vdx5k8Ni+p97j97zGzx+Qbyxk9dt9sYPPobX7H5tG3
        ZRWjx+dNcgHcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWp
        Rfp2CXoZ09ZvZi+4Jlix8vMl9gbGe3xdjBwcEgImEq37w7oYOTmEBJYySry/lwViSwjISJyc
        1sAKYQtL/LnWxdbFyAVU84lRYuLj5+wgCTYBQ4mutxAJEYFORolp3R/BEswC95gk9q7zA7GF
        BeIl/qzcDxZnEVCV2HroL9hUXgE7iR3tLxghNshLrN5wgBnE5gSKb53xhBXiIluJD3MWs0xg
        5FvAyLCKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMEq2Hfu5ZQdj17vgQ4wCHIxKPLwM9kHx
        QqyJZcWVuYcYJTiYlUR4nc6ejhPiTUmsrEotyo8vKs1JLT7EaAp01ERmKdHkfGAE55XEG5oa
        mltYGpobmxubWSiJ83YIHIwREkhPLEnNTk0tSC2C6WPi4JRqYOzk0Tqp8LQymyPoWpVVwPOP
        kZNeMQTvPW+2bK6JKfvTQqXNDW2ZZyLOib85WNdev/Xw1jd7LH5Fflz6ojTOa1b5SwerxMl1
        m3z/iE20rhHexSp9/pb+t8W2mcobnUTKEwzs/b5f5+Zjqc6fFT2r0JZd8KVzcf/dnu6tDVZX
        IjUj5B/ukT7vqcRSnJFoqMVcVJwIAH5KQUqoAgAA
X-CMS-MailID: 20200904133511eucas1p2f7241258a90f27b0aa67e62e74c48727
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200904133511eucas1p2f7241258a90f27b0aa67e62e74c48727
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200904133511eucas1p2f7241258a90f27b0aa67e62e74c48727
References: <20200904131711.12950-1-m.szyprowski@samsung.com>
        <CGME20200904133511eucas1p2f7241258a90f27b0aa67e62e74c48727@eucas1p2.samsung.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Documentation/DMA-API-HOWTO.txt states that the dma_map_sg() function
returns the number of the created entries in the DMA address space.
However the subsequent calls to the dma_sync_sg_for_{device,cpu}() and
dma_unmap_sg must be called with the original number of the entries
passed to the dma_map_sg().

struct sg_table is a common structure used for describing a non-contiguous
memory buffer, used commonly in the DRM and graphics subsystems. It
consists of a scatterlist with memory pages and DMA addresses (sgl entry),
as well as the number of scatterlist entries: CPU pages (orig_nents entry)
and DMA mapped pages (nents entry).

It turned out that it was a common mistake to misuse nents and orig_nents
entries, calling DMA-mapping functions with a wrong number of entries or
ignoring the number of mapped entries returned by the dma_map_sg()
function.

To avoid such issues, lets use a common dma-mapping wrappers operating
directly on the struct sg_table objects and use scatterlist page
iterators where possible. This, almost always, hides references to the
nents and orig_nents entries, making the code robust, easier to follow
and copy/paste safe.

While touching this code, also add missing call to dma_unmap_sgtable.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
---
 samples/vfio-mdev/mbochs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 3cc5e5921682..e03068917273 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -846,7 +846,7 @@ static struct sg_table *mbochs_map_dmabuf(struct dma_buf_attachment *at,
 	if (sg_alloc_table_from_pages(sg, dmabuf->pages, dmabuf->pagecount,
 				      0, dmabuf->mode.size, GFP_KERNEL) < 0)
 		goto err2;
-	if (!dma_map_sg(at->dev, sg->sgl, sg->nents, direction))
+	if (dma_map_sgtable(at->dev, sg, direction, 0))
 		goto err3;
 
 	return sg;
@@ -868,6 +868,7 @@ static void mbochs_unmap_dmabuf(struct dma_buf_attachment *at,
 
 	dev_dbg(dev, "%s: %d\n", __func__, dmabuf->id);
 
+	dma_unmap_sgtable(at->dev, sg, direction, 0);
 	sg_free_table(sg);
 	kfree(sg);
 }
-- 
2.17.1

