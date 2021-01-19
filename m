Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710382FBEC5
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392335AbhASSRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:17:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48172 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392435AbhASSQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIADtp130019;
        Tue, 19 Jan 2021 18:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Az26+IhA8alHEt8Pia652W9Kndzz80+hExfFvnUJE6I=;
 b=BVWBoJsf1LZsKDCOKZRnPzMbugfOfrHtRrz4rVAR3EBvD9rOnNlf1QwZn0U+KX9Sdu/y
 bPEKRYOfNXz6aF4HVBBjQh9zgN4TRs7eH2jzWSu02cfWfGT1XTC3eqfZe6AudX0LhfGb
 aC/zpBu6HUWRbG9u2JGRTohxMJmJ/Xvim42fk7OR33P12CIHLBqwsS7wFFnKt6/rCLBz
 HAPI5xFHGr3wYcqyeYeHpJ121SJGO+fg1zrolyPzTD9Ls4SlT2DTAiKHksnmkMqTkPkl
 DQ5Sdc2y+EJVywHjXnBwvsVaIKItCNk0p1Ewn31hxlooxXtkJrxK+3VUdb/WIumhQ9Uu Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 363xyhsrrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAZkr063660;
        Tue, 19 Jan 2021 18:16:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3649qppmkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JIG07T027576;
        Tue, 19 Jan 2021 18:16:00 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:16:00 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 2/9] vfio/type1: find first dma
Date:   Tue, 19 Jan 2021 09:48:22 -0800
Message-Id: <1611078509-181959-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a variant of vfio_find_dma that returns the entry with the lowest iova
in the search range.  This is needed later for visiting all entries without
requiring one to delete each visited entry as in vfio_dma_do_unmap.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5fbf0c1..a2c2b96 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -173,6 +173,29 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 	return NULL;
 }
 
+static struct vfio_dma *vfio_find_dma_first(struct vfio_iommu *iommu,
+					    dma_addr_t start, size_t size)
+{
+	struct vfio_dma *res = NULL;
+	struct rb_node *node = iommu->dma_list.rb_node;
+
+	while (node) {
+		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
+
+		if (start < dma->iova + dma->size) {
+			res = dma;
+			if (start >= dma->iova)
+				break;
+			node = node->rb_left;
+		} else {
+			node = node->rb_right;
+		}
+	}
+	if (res && size && res->iova >= start + size)
+		res = NULL;
+	return res;
+}
+
 static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 {
 	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
-- 
1.8.3.1

