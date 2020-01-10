Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FB613768D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 20:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgAJTFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 14:05:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbgAJTFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 14:05:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3C56131553;
        Fri, 10 Jan 2020 19:05:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=IAxWsXZJeFUgO3RbSR4igugMzki4kDIyDXTs6F36IxU=;
 b=Xar53uV/V6ArJjBjrO2U/jRSqy+lBdT0sIOibNZPQJ0sSIRTE8E/vkVf/k3ISNfMnM03
 nzzlelBFvEF6mqCIDAy4qHKZvpKvvpUirI6tepOp9Z5VnjB570p2hLfGK6f0TGncDgAE
 vVps6a1rWKDMOLKafYwhtbYk4LBk/keEpMxkrfmUdnHsk1dnONEY1Pc5ZXBs+P+xkhGB
 RAzOnve4U8GM3iIInJXABFDYiDTVJfTd0zqbk7QkW0C5hTOSqP3zcJghsbOD1r/kV9P9
 TXBV56IioMWKsWEgf0TQA7/gzYhXcSG2tLmJ6dGIx3RJfy5ENgg0Gn9R7dy9UDt+6Z+j 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xaj4um8hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:05:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ482S069233;
        Fri, 10 Jan 2020 19:05:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xevfec03t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:05:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00AJ5JPx021552;
        Fri, 10 Jan 2020 19:05:19 GMT
Received: from paddy.uk.oracle.com (/10.175.192.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 11:05:19 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-nvdimm@lists.01.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 08/10] dax/pmem: Add device-dax support for PFN_MODE_NONE
Date:   Fri, 10 Jan 2020 19:03:11 +0000
Message-Id: <20200110190313.17144-9-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200110190313.17144-1-joao.m.martins@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allowing dax pmem driver to work without struct pages means
that user will request to not create any PFN metadata by writing
seed's device mode to PFN_MODE_NONE.

When the underlying nd_pfn->mode is PFN_MODE_NONE, most dax_pmem
initialization steps can be skipped because we won't have/need a
pfn superblock for the pagemap/struct-pages. We only allocate
an opaque zeroed object with the chosen align requested, and
finally add PFN_SPECIAL to the region pfn_flags.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/pmem/core.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/pmem/core.c b/drivers/dax/pmem/core.c
index 2bedf8414fff..67f5604a8291 100644
--- a/drivers/dax/pmem/core.c
+++ b/drivers/dax/pmem/core.c
@@ -17,15 +17,38 @@ struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
 	struct nd_namespace_io *nsio;
 	struct dax_region *dax_region;
 	struct dev_pagemap pgmap = { };
+	struct dev_pagemap *devmap = NULL;
 	struct nd_namespace_common *ndns;
 	struct nd_dax *nd_dax = to_nd_dax(dev);
 	struct nd_pfn *nd_pfn = &nd_dax->nd_pfn;
 	struct nd_region *nd_region = to_nd_region(dev->parent);
+	unsigned long long pfn_flags = PFN_DEV;
 
 	ndns = nvdimm_namespace_common_probe(dev);
 	if (IS_ERR(ndns))
 		return ERR_CAST(ndns);
 
+	rc = sscanf(dev_name(&ndns->dev), "namespace%d.%d", &region_id, &id);
+	if (rc != 2)
+		return ERR_PTR(-EINVAL);
+
+	if (is_nd_dax(&nd_pfn->dev) && nd_pfn->mode == PFN_MODE_NONE) {
+		/* allocate a dummy super block */
+		pfn_sb = devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb),
+				      GFP_KERNEL);
+		if (!pfn_sb)
+			return ERR_PTR(-ENOMEM);
+
+		memset(pfn_sb, 0, sizeof(*pfn_sb));
+		pfn_sb->align = nd_pfn->align;
+		nd_pfn->pfn_sb = pfn_sb;
+		pfn_flags |= PFN_SPECIAL;
+
+		nsio = to_nd_namespace_io(&ndns->dev);
+		memcpy(&res, &nsio->res, sizeof(res));
+		goto no_pfn_sb;
+	}
+
 	/* parse the 'pfn' info block via ->rw_bytes */
 	rc = devm_namespace_enable(dev, ndns, nd_info_block_reserve());
 	if (rc)
@@ -45,20 +68,21 @@ struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
 		return ERR_PTR(-EBUSY);
 	}
 
-	rc = sscanf(dev_name(&ndns->dev), "namespace%d.%d", &region_id, &id);
-	if (rc != 2)
-		return ERR_PTR(-EINVAL);
-
 	/* adjust the dax_region resource to the start of data */
 	memcpy(&res, &pgmap.res, sizeof(res));
 	res.start += offset;
+	devmap = &pgmap;
+	pfn_flags |= PFN_MAP;
+
+no_pfn_sb:
 	dax_region = alloc_dax_region(dev, region_id, &res,
 			nd_region->target_node, le32_to_cpu(pfn_sb->align),
-			PFN_DEV|PFN_MAP);
+			pfn_flags);
 	if (!dax_region)
 		return ERR_PTR(-ENOMEM);
 
-	dev_dax = __devm_create_dev_dax(dax_region, id, &pgmap, subsys);
+
+	dev_dax = __devm_create_dev_dax(dax_region, id, devmap, subsys);
 
 	/* child dev_dax instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);
-- 
2.17.1

