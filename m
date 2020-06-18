Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F04E1FF785
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbgFRPlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 11:41:36 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54962 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731713AbgFRPkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 11:40:43 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200618154038euoutp010e1948411e76854c49c7ba236cdc4602~ZrZ4pHgIR1844818448euoutp01P
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 15:40:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200618154038euoutp010e1948411e76854c49c7ba236cdc4602~ZrZ4pHgIR1844818448euoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592494838;
        bh=i9tfBl9XK1ZIcmVNmOj760Z4Av4MmZkmEeWSykU107Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZMr6zGKccCjIXwLvtaZvINM5cvedqSKjLsMAlbFaqa/2uidxZv4eJwZw6UlCvaeF
         9YebsQk0pCSOf0hZVeGz5jyKC7bIKsyTqcxutg8SECaAxAFjSsElGDvinxdLb+wtUU
         aDzTWa6ipwlVAyqCaRl33uC2xz3NXA3enEo71oO0=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200618154037eucas1p162bd4bce5ff25284dc35a3b750373f07~ZrZ4YCBn21545815458eucas1p1m;
        Thu, 18 Jun 2020 15:40:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id FB.1F.61286.5FA8BEE5; Thu, 18
        Jun 2020 16:40:37 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200618154037eucas1p19a60af169ef9c272b9d1eecf589f6627~ZrZ4Bn1_B1545815458eucas1p1l;
        Thu, 18 Jun 2020 15:40:37 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200618154037eusmtrp2e1d1f0ddf5441e208cc3e8e1afc41c0b~ZrZ4A_iTP0370403704eusmtrp2w;
        Thu, 18 Jun 2020 15:40:37 +0000 (GMT)
X-AuditID: cbfec7f2-ef1ff7000001ef66-f2-5eeb8af57b24
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 78.FE.08375.5FA8BEE5; Thu, 18
        Jun 2020 16:40:37 +0100 (BST)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200618154036eusmtip1fb60c40ddcb27db26c518640dc3aacde~ZrZ3a9J5Z0742307423eusmtip1Y;
        Thu, 18 Jun 2020 15:40:36 +0000 (GMT)
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
Subject: [PATCH v6 33/36] samples: vfio-mdev/mbochs: fix common struct
 sg_table related issues
Date:   Thu, 18 Jun 2020 17:39:54 +0200
Message-Id: <20200618153956.29558-34-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618153956.29558-1-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSa0hTYRjuO2fn7GjOjpvgh0nGIsnAGxUeUMTMH4cKuv0oBC8zDypuuja1
        FCRTFzK1NDNNLC0E865zzktKOdQlmpcpy0umov7QoYY6sUma2yn79zzP+7zP873wESi/BXMm
        YuMTGVm8SCzEbTma/l8jHialMcy79J07lTc8gFDNJY0YdaApQKkJ0wZOVdf2IVTFJz+qrOgB
        pR58A6jtiQWEUi0aMGq8swyn6ntnuVTPzyUskEfXva0DdPdOBYdu25nH6LkcHUK3VD6mZ/YX
        UbpwsgrQH6fScTovcx2nn6lrAL2lOnXzeIitfxQjjk1mZF4BEbYxexoVV1rp8Gi6PSEdNNsr
        AUFA8iKcrwpUAluCT34AcKm8msOSbQDzVrU4S7YAVGv6MCWwsW4MVOpRdlAF4N5GNnq0krE8
        iltcOOkDlWtKK3YkFQB+ybOzmFDSgMC13+vWKAEZAfWmSivmkGfhXFkNYsE8MgAOPM/B2TpX
        WNv0GbVgm0N9UKfALEGQ1HJhxVAZwl4RDL+1oqxfAFd1ai6LXeBBRznC+jMBXBiu57IkF8Dx
        jBLAuvzg92EzbglCSXfY2OnFypfhzKtpLptvDyfXHCwyeghfaIpRVubB7Kd81u0GS3UNR7U9
        o/q/z6Hham+R9RQ+WQDgSAueD1xL/3dVAFADnJgkuSSakfvEMw895SKJPCk+2vN+gkQFDr/S
        4L5usx2Y9JFaQBJAaMcLvGsM42OiZHmKRAsggQodeUFfB8P4vChRSiojSwiXJYkZuRacJDhC
        J96F9yuhfDJalMjEMYyUkf2bIoSNczroNt+OG+1o8hGPFRnRW/5TY0OOBwvBsy6hpzPPtc0c
        w38sh6f2GnyvKN2WpVncrq6NEKwYO9mflTtuZphLuVpkZa/1xtVrL8ndFLP0db1CIvCG+Y2+
        Z5bvnNj0bfDfuFeoSDMJnlCl3rtBxm6P/fWt4rTIIUNzd6ZICJ0414UceYzI5zwqk4v+ALRX
        GcFGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xu7pfu17HGZxYLWbRe+4kk8XGGetZ
        Lf5vm8hsceXrezaLlauPMlks2G9tMWdqocWW03MZLb5cechksenxNVaLy7vmsFmsPXKX3eLg
        hyesDrwea+atYfTY+20Bi8f2bw9YPe53H2fy2Lyk3uP2v8fMHpNvLGf02H2zgc2jt/kdm0ff
        llWMHp83yQVwR+nZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJal
        FunbJehl/N62ib1giWDFrR35DYwb+boYOTkkBEwkTi65xNzFyMUhJLCUUeLC9H3MEAkZiZPT
        GlghbGGJP9e62CCKPjFKPLo3mw0kwSZgKNH1FiIhItDJKDGt+yM7SIJZ4B6TxN51fl2MHBzC
        AnEST0+BhVkEVCXuz1nFBGLzCthJnOzvZoNYIC+xesMBsMWcQPHTx1vBFgsJ2Eo8/9DGNoGR
        bwEjwypGkdTS4tz03GJDveLE3OLSvHS95PzcTYzAKNl27OfmHYyXNgYfYhTgYFTi4X0R8jpO
        iDWxrLgy9xCjBAezkgiv09nTcUK8KYmVValF+fFFpTmpxYcYTYGOmsgsJZqcD4zgvJJ4Q1ND
        cwtLQ3Njc2MzCyVx3g6BgzFCAumJJanZqakFqUUwfUwcnFINjDNCV88xOhK1dtqtd3p1c/RW
        1HUGTYi8FZc783pN96+0qub/YddXfs0JeHXlfvnWqjZ2Xo66CbeuzfAq6LoicuVD5/ZMF5+r
        ZxoKZNjVfuwxXpiTKCivzDx9JVf0tFnRDyXXfPjzNOKHRXR17fqjHuvXO2iGtN9vO1deKc4+
        4ZWu398liUarGJVYijMSDbWYi4oTAZpEzByoAgAA
X-CMS-MailID: 20200618154037eucas1p19a60af169ef9c272b9d1eecf589f6627
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200618154037eucas1p19a60af169ef9c272b9d1eecf589f6627
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200618154037eucas1p19a60af169ef9c272b9d1eecf589f6627
References: <20200618153956.29558-1-m.szyprowski@samsung.com>
        <CGME20200618154037eucas1p19a60af169ef9c272b9d1eecf589f6627@eucas1p1.samsung.com>
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

