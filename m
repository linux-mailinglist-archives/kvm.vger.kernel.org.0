Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D09C30A0DC
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 05:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhBAEbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 23:31:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41565 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhBAE3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 23:29:20 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210201042802epoutp01248d2501780ad223b2e0e841c005d918~fhTuPqItM1196311963epoutp01S
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 04:28:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210201042802epoutp01248d2501780ad223b2e0e841c005d918~fhTuPqItM1196311963epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612153682;
        bh=wYGV5gWfecQFhg6xzaMF6JtUcCvRNBh8Pi1Z/2G9s0w=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Gn+9ZK6RdbrxVtxQs5SmadJA1whOY+M28nQSm2bFGSF1/YF7o5B7Tt2ytFXYMPcp2
         7ulDKqjikAc+yMZC1A3p3+6T4ULvlIaP4YWaoLK7rbrnFxc778TfTTOKcBSct+u6j7
         rXPYv9yT1JPpoNTmyh0BTyH6/tB58MDaYv7hrk8c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210201042801epcas5p3379a03a22ef539b8bbcbfa309ad6f767~fhTtnbOGb1572215722epcas5p38;
        Mon,  1 Feb 2021 04:28:01 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.40.194]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DTZgM3kzdz4x9Q9; Mon,  1 Feb
        2021 04:27:59 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.03.15682.F4387106; Mon,  1 Feb 2021 13:27:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210201042758epcas5p1a6cb788bf5eb1bf85efa66662db2edf6~fhTq-u34C3002330023epcas5p1r;
        Mon,  1 Feb 2021 04:27:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210201042758epsmtrp2eb63960f9e83c78101e1281f64552e43~fhTq_0gW-0999509995epsmtrp2j;
        Mon,  1 Feb 2021 04:27:58 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-68-6017834f8036
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.D0.08745.E4387106; Mon,  1 Feb 2021 13:27:58 +0900 (KST)
Received: from localhost.localdomain (unknown [109.105.112.123]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210201042657epsmtip1482c387050911ba311e23757f522a620~fhSxTDb1x0727807278epsmtip1b;
        Mon,  1 Feb 2021 04:26:50 +0000 (GMT)
From:   "jie6.li" <jie6.li@samsung.com>
To:     gregkh@linuxfoundation.org
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ks0204.kim@samsung.com, xing84.he@samsung.com,
        gaofei.lv@samsung.com, jie6.li@samsung.com, security.xa@samsung.com
Subject: [PATCH] uio: uio_pci_generic: don't fail probe if pdev->irq equals
 to IRQ_NOTCONNECTED
Date:   Mon,  1 Feb 2021 04:25:59 +0000
Message-Id: <1612153559-17028-1-git-send-email-jie6.li@samsung.com>
X-Mailer: git-send-email 2.6.4.windows.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsWy7bCmlq5/s3iCweVeSYtdizeyWDQvXs9m
        MXtaK7vF0T0cFnOmFlpc3jWHzeL/r1esFmcnfGC12Nvn48DpsX/uGnaP9/uusnn0bVnF6PF5
        k1wAS1SOTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
        IUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScAkOjAr3ixNzi0rx0veT8XCtDAwMj
        U6DKhJyMf18msxZ85qzoWFXWwLiCo4uRk0NCwETi35ZnzF2MXBxCArsZJW623WGBcD4xSqza
        /hUq85lRYu2UqUwwLQt7XzNBJHYxSty/vJMVwvnKKNH5/zc7SBWbgKrEj5Wn2UBsEQE5iSe3
        /zCD2MwCexklvs5wBbGFBRIllnZ9ZgGxWYDqv5zrAtvAK+AscWDDARaIbRoS6zv2g90kIbCJ
        XWJ7/2E2iISLxMNpS9khbGGJV8e3QNlSEp/f7YWqqZc48/sIO0RzB6PEzoufWCES1hIXV98A
        uogD6CJNifW79CGO45Po/f2ECSQsIcAr0dEmBFGtKDH73C6oe8QlXr57xAhhe0jc/XoKbK2Q
        QKzEog/3mCYwysxCGLqAkXEVo2RqQXFuemqxaYFhXmo5cuRsYgQnKi3PHYx3H3zQO8TIxMF4
        iFGCg1lJhPfUJLEEId6UxMqq1KL8+KLSnNTiQ4ymwHCayCwlmpwPTJV5JfGGpkZmZgaWBqbG
        FmaGSuK8OwwexAsJpCeWpGanphakFsH0MXFwSjUwLV6zV3ZX5+rn+1UOpapWsfis2qF78sMl
        9R7Gb0q/5rU5brT2Lp339cEDltJ1K6ec2rFSV0pF/M/rhmAd20MO86bzdj7bfVfiZw2HY9bN
        OA3LT0mb4gQ0Th5jjKv3SZDOqr8VnvFR1GfNnQO1nFNP3fk6dX3av+p6ERkFyV2adT7qn3ru
        MjGrr9Qt49/FtbNo75q8S+mXpDb59k6Y8OLWvEoX/quLo1Zv95nSe5dzLvc13WlXJvXsnfR2
        blSozOKvRemLPj26kfXDIszU7cXPqOmttqd8NpjbVc9jXNcyT0va4vHs+rd3Vu2d3rvx0bX/
        j69+Y5ln2l0hyhwryBc3a8U/+yt1X9b5dzXq9T4/FKfEUpyRaKjFXFScCADqHGXN3QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJTtevWTzB4Ng5E4tdizeyWDQvXs9m
        MXtaK7vF0T0cFnOmFlpc3jWHzeL/r1esFmcnfGC12Nvn48DpsX/uGnaP9/uusnn0bVnF6PF5
        k1wASxSXTUpqTmZZapG+XQJXxr8vk1kLPnNWdKwqa2BcwdHFyMkhIWAisbD3NROILSSwg1Fi
        2s4iiLi4xKFVP1ghbGGJlf+es3cxcgHVfGaU2P5iB1gDm4CqxI+Vp9lAbBEBOYknt/8wgxQx
        CxxnlHh7YDJYQlggXmJj6yswmwWo4cu5LrBmXgFniQMbDrBAbNCQWN+xn2UCI88CRoZVjJKp
        BcW56bnFhgVGeanlesWJucWleel6yfm5mxjBgaSltYNxz6oPeocYmTgYDzFKcDArifCemiSW
        IMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAPTuthbvLKr
        Ln48/XiKW6Cp0721L3+6Tpw1Je5s5HeueX4l16Tvef9UPMSdeGHlx5Cpsw9YG6qc/su1O0fg
        1b1Zk01NclUPLn1bqSnNcG7yyivlVrovxa4fKjb8x/GqxqKgN5vzZbOnqNXNjfG1dzcnxC43
        uLf27+Y3LVGnrnksfZrwskcu4vyRG72lKwOnPvexfrzB+yHf3LrLIiJh+xLNm9vXnlj1WtZl
        l+iVxnezbO4Zt+45ZOB2ZtbeAr5YG9/kTRVOd+ZGf7Co2ihgFsvSzcIcabz5avbkLJ6wGblJ
        vvba38Lerfn7amnyh4vRChMmxhvMen/E51n3ojyD1ed3bf077aKd2rlpBcvXdZr9ilZiKc5I
        NNRiLipOBADHKPW8kwIAAA==
X-CMS-MailID: 20210201042758epcas5p1a6cb788bf5eb1bf85efa66662db2edf6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210201042758epcas5p1a6cb788bf5eb1bf85efa66662db2edf6
References: <CGME20210201042758epcas5p1a6cb788bf5eb1bf85efa66662db2edf6@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jie Li <jie6.li@samsung.com>

Some devices use 255 as default value of Interrupt Line register, and this
maybe causes pdev->irq is set as IRQ_NOTCONNECTED in some scenarios. For
example, NVMe controller connects to Intel Volume Management Device (VMD).
In this situation, IRQ_NOTCONNECTED means INTx line is not connected, not
fault. If bind uio_pci_generic to these devices, uio frame will return
-ENOTCONN through request_irq.

This patch allows binding uio_pci_generic to device with dev->irq of
IRQ_NOTCONNECTED.

Signed-off-by: Jie Li <jie6.li@samsung.com>
Acked-by: Kyungsan Kim <ks0204.kim@samsung.com>
---
 drivers/uio/uio_pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index b8e44d16279f..c7d681fef198 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -92,7 +92,7 @@ static int probe(struct pci_dev *pdev,
 	gdev->info.version = DRIVER_VERSION;
 	gdev->info.release = release;
 	gdev->pdev = pdev;
-	if (pdev->irq) {
+	if (pdev->irq && (pdev->irq != IRQ_NOTCONNECTED)) {
 		gdev->info.irq = pdev->irq;
 		gdev->info.irq_flags = IRQF_SHARED;
 		gdev->info.handler = irqhandler;
-- 
2.17.1

