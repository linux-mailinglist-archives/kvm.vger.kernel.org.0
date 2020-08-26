Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1A252750
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 08:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHZGg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 02:36:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38043 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgHZGf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 02:35:56 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200826063546euoutp01adb9b3b28bd4ff76d48ebaac18d96acb~uve3MmoS42034920349euoutp01Y
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 06:35:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200826063546euoutp01adb9b3b28bd4ff76d48ebaac18d96acb~uve3MmoS42034920349euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598423746;
        bh=i9tfBl9XK1ZIcmVNmOj760Z4Av4MmZkmEeWSykU107Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDWa/v2UN64kd/Pdh2+Eqeqoqxov2kLfJNAWiAuYfPUDZdGsjK6rzp0jDh/Ieviln
         FTtvqfiaz8SXSMsHICUOsl47/oAzIj4oVOeTnycj3hrxaX9nk4J4vuowAU11CNovOv
         MRLIevFWqldfH/vPZ87AN+jaPiLfdmm0deNKsdu8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200826063546eucas1p248e3327a2574966e6260f8ea4243a18c~uve27uU5X0403504035eucas1p2_;
        Wed, 26 Aug 2020 06:35:46 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 59.BD.05997.2C2064F5; Wed, 26
        Aug 2020 07:35:46 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200826063546eucas1p268558dcd08ac9b43843f9f5e23da227d~uve2fzbFv0398703987eucas1p2r;
        Wed, 26 Aug 2020 06:35:46 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200826063546eusmtrp1324e39600c0b1709cb7b91c674f0a758~uve2fFvRB1167511675eusmtrp1M;
        Wed, 26 Aug 2020 06:35:46 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-ed-5f4602c23e0d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id B0.E0.06314.1C2064F5; Wed, 26
        Aug 2020 07:35:45 +0100 (BST)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200826063545eusmtip2148831d8e511c634dd22bec68983ea60~uve14XvZb0092300923eusmtip2U;
        Wed, 26 Aug 2020 06:35:45 +0000 (GMT)
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
Subject: [PATCH v9 30/32] samples: vfio-mdev/mbochs: fix common struct
 sg_table related issues
Date:   Wed, 26 Aug 2020 08:33:14 +0200
Message-Id: <20200826063316.23486-31-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826063316.23486-1-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7djP87qHmNziDT68kLXoPXeSyWLjjPWs
        Fv+3TWS2uPL1PZvFytVHmSwW7Le2mDO10GLL6bmMFl+uPGSy2PT4GqvF5V1z2CzWHrnLbnHw
        wxNWB16PNfPWMHrs/baAxWP7twesHve7jzN5bF5S73H732Nmj8k3ljN67L7ZwObR2/yOzaNv
        yypGj8+b5AK4o7hsUlJzMstSi/TtErgyfm/bxF6wRLDi1o78BsaNfF2MnBwSAiYSbe2XGbsY
        uTiEBFYwSnx/tZYFwvnCKHHnxE4WkCohgc+MEp++x8N0rO9bDdWxnFGid9d0JriOM1fmMoNU
        sQkYSnS97WIDsUUEWhklTvTygBQxC1xjknj79x1rFyMHh7BAgsSnV6kgNSwCqhLPph8C6+UV
        sJOY1/qIDWKbvMTqDQfA4pxA8ePd/VDxfewSO4/EQNguEnfetjFC2MISr45vYYewZSROT+4B
        e0dCoJlR4uG5tewQTg+jxOWmGVAd1hJ3zv1iAzmIWUBTYv0ufYiwo0T3uknMIGEJAT6JG28F
        QcLMQOakbdOhwrwSHW1CENVqErOOr4Nbe/DCJWYI20Oie+N5Nkj4TGSUeDP9IfMERvlZCMsW
        MDKuYhRPLS3OTU8tNspLLdcrTswtLs1L10vOz93ECExKp/8d/7KDcdefpEOMAhyMSjy8C9hc
        44VYE8uKK3MPMUpwMCuJ8DqdPR0nxJuSWFmVWpQfX1Sak1p8iFGag0VJnNd40ctYIYH0xJLU
        7NTUgtQimCwTB6dUA+OU74IBMS0vucr3ZHVH7+uVTr/jXntVNFgm02oxx793fImpnqG6U+9d
        nXLmWK0Cd1/XLLNPN7RVfHZLvj188cKthwerP+04vObfls4Xz0yyUwraz23gsP6T2K9V7Vjt
        vNJp3+8+s5yO9+F+rHIymgFcyzy1tIv/Fb07a1S6v2N+wExW7m2BHEosxRmJhlrMRcWJAKtM
        O5tGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xe7oHmdziDb6vtbToPXeSyWLjjPWs
        Fv+3TWS2uPL1PZvFytVHmSwW7Le2mDO10GLL6bmMFl+uPGSy2PT4GqvF5V1z2CzWHrnLbnHw
        wxNWB16PNfPWMHrs/baAxWP7twesHve7jzN5bF5S73H732Nmj8k3ljN67L7ZwObR2/yOzaNv
        yypGj8+b5AK4o/RsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstS
        i/TtEvQyfm/bxF6wRLDi1o78BsaNfF2MnBwSAiYS6/tWM3YxcnEICSxllPj5aSIrREJG4uS0
        BihbWOLPtS42iKJPjBKHf19jB0mwCRhKdL2FSIgIdDJKTOv+CJZgFrjHJLF3nR+ILSwQJ/Gi
        /ysbiM0ioCrxbPohZhCbV8BOYl7rIzaIDfISqzccAItzAsWPd/eDxYUEbCVOr53BPIGRbwEj
        wypGkdTS4tz03GJDveLE3OLSvHS95PzcTYzAONl27OfmHYyXNgYfYhTgYFTi4V3A5hovxJpY
        VlyZe4hRgoNZSYTX6ezpOCHelMTKqtSi/Pii0pzU4kOMpkBHTWSWEk3OB8ZwXkm8oamhuYWl
        obmxubGZhZI4b4fAwRghgfTEktTs1NSC1CKYPiYOTqkGRsu2U4X6kaYfvvde3DRTdfW1pKJj
        l2V3bww7cEX3+YmKl0rMtrNUezkDopax21noP7DjmaHGtro+5aG64EVHpZfTQtITnsZH2mzy
        DCqQmsTD6HZt0cTgpAtaNzdGlxSt3+reNuf2Y8MfLVczbF8tnp4c8cMk0EhskYlH7ZJPbQdC
        XHfadyrdVWIpzkg01GIuKk4EAOSPyuupAgAA
X-CMS-MailID: 20200826063546eucas1p268558dcd08ac9b43843f9f5e23da227d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200826063546eucas1p268558dcd08ac9b43843f9f5e23da227d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200826063546eucas1p268558dcd08ac9b43843f9f5e23da227d
References: <20200826063316.23486-1-m.szyprowski@samsung.com>
        <CGME20200826063546eucas1p268558dcd08ac9b43843f9f5e23da227d@eucas1p2.samsung.com>
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

