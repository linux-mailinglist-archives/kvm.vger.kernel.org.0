Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC0E485D87
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343961AbiAFAsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:48:38 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30232 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343995AbiAFAsF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:05 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4Y5e023582;
        Thu, 6 Jan 2022 00:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=jgvLjAHm5Vf49VWwJ3j4Je5hXaayeoK3l5mdD4qALeU=;
 b=UjaC5j9ljknDWL/TMLFPOfo3VNJhZ0j/JSINiyt67xZZpC8ljXeepCdxh8xxNRFlldJI
 sVzuVqPEGMMVePKiWGvHXIPCfn6XXahXXCOF+0vuqR2aLVoROP1bmx3k1JSNsD8Q2j5u
 6RBNkL4z7BKmWsmS+roe9+ORasZ7xvzNXghYoje3rjVMru9WdXUD57SbFEehcYgvQ7R3
 IYeGbI2g67+T3RDX2W4n/iUoh+YxymBG7xeDyZirlmUkT8DPJwo25G6e9kDsUlC2xCy6
 rqk6PbfpKxK32gCb+wb+/otMAp3VpdKU7EWtzIx9DX6jI2kV0PGPSi3reKrlZuejxHqX ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpeg425-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VnHj086820;
        Thu, 6 Jan 2022 00:47:35 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by userp3030.oracle.com with ESMTP id 3ddmqbvt0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OX4S1UUlqm4BWn4iYqkD4MjmaCGFkzmOM+8iSSbwP4Qi9YZHp2E5qWsjNcUpZfK4eeVj+woVeacgk8FjCNsfCVvxBcUbuYN66qG9nOX+ris5Env28XXeXjci7j90xQl6QlWuNkg4uKzpdSvXb7dAxT7AvRw1Y6xdyfuXxas0UjlsGwLBavjqkh1BvIq6NVKNz78UYR/LZwlLfUgT0YcJHujCskUYV90yZuIQqF6U10jhdtpZXpGZY4S33DE1EcZ+urzwJigXGKk+ft74Cdl4hFslRCW9yjEiJvCGBjIvQO3CRs3ylm1JhaJ0pf4eFPSRnRsWRM56oc12xGttOci07g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgvLjAHm5Vf49VWwJ3j4Je5hXaayeoK3l5mdD4qALeU=;
 b=jrMl/Ce4RZ6zmvMXFtvFjhNcY1qDu6v3Y5PVAc5wgDr5ZofgTqBxIxv51up7FGVZRUEZC44PPWnelHqYFW7HXrC7YXHxZhnAcmH0OwwjQjH5+y1yNzk6Gbsaik0utsCC9FwIMlnMmxvOiV5jrPmPg6Jp9txJn2Ha8LsVhwuTReOPNF7xqr/UvgXrvMeYqnPsACcSiYyhNPpU6AU5SR8dM7e1l04d9tlJSUvwMc7XKO/vNXOt5h0dELITcP5sfoGImZnl7RzOOUqFaPuRmyus40EewDs0UfG6C6icP56PbOT9F829DZMi/dQI+UU6I1yX9B3promdet0oFaHFH60iMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgvLjAHm5Vf49VWwJ3j4Je5hXaayeoK3l5mdD4qALeU=;
 b=Ny2NzjosMYfFBVpdP0xR+SqIDFMpNLfbxJctbewM87Se3eHnyVJoZA0Q9ZeyXTWEbmrZFIMW9zz64kh0Pc0SvQQUEpuWEJ0kURI+Sn4anS6+iqTr8oDospxMqZdrQeF5EuxU/fUU95tbz7kWgXbQAb6BidIbF3l4Dr0y7c+NT1o=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:32 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:32 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 07/16] vfio/type1: Parallelize vfio_pin_map_dma()
Date:   Wed,  5 Jan 2022 19:46:47 -0500
Message-Id: <20220106004656.126790-8-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96f4a87a-0f54-4be6-11b5-08d9d0ae1fa5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422B31F0B1D69221B9D8F3AD94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xyb22aRtPdtNbPj2ZMrZtWJJeLQYnoBEV9B4/HHuF5Grt4IEUUXJ7/+mY88a43SmyiOtwCf2LGETqPnkDJ17FL9XE1qXpR4HInHB5btNu/58BzMnsZI4EIrKB16DQk4G0js+XPuvKBKTamaKbAuIXGm3qC1RYXlhnr9MS9EbL8RuMsAKjNkaQR8+rmECGYnc8OweeV0CT1jjaMJL0FY2njqx9ojqacSoYknu3NSFzkd2/hPM25rLmDfVdxgI4GOTj7CavrX8cVx3nmbg9pXvQS+sX70uER/BV4v4PXvoKUo/1VxdB+jXEWOATFmoaJEwfKV01fUDN6+AGp2mP4Ct3AHI7Kd+x7RSoQ6oxAsOvFLLWvGIRnwROSx2i3hSO7hyZ8Z6ktrfySVF58QGSLukDeR3Muro20t9YRcQ0EPiE6KSdeCtA+NIIBMD/1gw7QDVbiZWOLh11+DOmvFki5S9bbZ9YReWWQvFBx6KEtbyMr0ghWc5vNyNb6/xlfXR61M/tRKuYFubxo3HqarHx2KYiNmQ34JeAbTazI6i3aifg3g1H0C2Z0sVu2T1u22KwwgTEoCw2K9rrcEZv/aXX69q10Ail/qtHQDxOISkHY88FeuFq8ry8yuoQXTAsY7Syxvh0a3Piuh0A7MuabyKAL9KhIMVSUrzklCmwL7MThIxTi10hvnuVBfRogjrPzRadfDSNKExrwY1dJXmRNoUJrccCCFeXTgA6oxtZaMCQZEurGAQ8HX7FSFSo+ysQcdeiLysfKC83OEj/CcdP+1LUIhsqHqIUYTb6HQqH8yZEpSyhPcnQOoVxWBB9pPQmK4VjJVK/TPtC7p12Wwu/w/hIX8uionKoOa5iNguEvB74LXGzGs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(966005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CKbaYQ7AfqK9amf10QGa34yhVeeJAJf06YoeVozsaVVhVgUnJJmF7vQ7UpwL?=
 =?us-ascii?Q?ApoQIRgMIcVasqNv8YTIHlIZni0tvILQMCT947MC9W79IT5xwkDXSx7ycgj9?=
 =?us-ascii?Q?fXrlohx9OZz3lPHeo0EVAzJ4uI2oycqqtEGbAj0Apr8JiiZ9QezVUjAhGl8S?=
 =?us-ascii?Q?gfCmZy0WlGa0S9/rNlF3QhUKmhA+u4OBWEG2P1a/FqVdabrTXyRR1DHga4Kr?=
 =?us-ascii?Q?jdHei2/Ersw3WSG0RSe2EcDTSbkIFBBvnhWmoeewRh6dC2/pZAQ1ErwgLc6X?=
 =?us-ascii?Q?EbWQOX2faH3HUeIGV45yQSo9f30lC1pIj5uNEyfurWUqJojIJBU07w55rHRL?=
 =?us-ascii?Q?86+BTSEr/xuZXuM0KAYgMCMN9FAg1Z8ip5fXkxExGhnAEsDjbsWexd0wzbuh?=
 =?us-ascii?Q?8u3P578Z1KoHCLnDzpRXkomlrwmjRDs9kk75CS5NWbWAhxik6MJMF0sFayQc?=
 =?us-ascii?Q?0tFrOkaDWV82Qb8QvalxyBat9znVtgtUlcca4pPhOzP8h0FslFvaku2ycStF?=
 =?us-ascii?Q?f/DmoKqV7KRXnlEQDV5GYdohq4Sq5lLtuOmIt9IQUriw8n3q2EUHr1hrJWp1?=
 =?us-ascii?Q?PBIX6RJFEtV/HT2052hbKe9dpG23f/gQc2DYbwXQuSXLtILIX3Za8z3k2fgc?=
 =?us-ascii?Q?qNeMERtHhOGtAoLGc5xwEdwCcCyJlGqxkR+GcENQwe++DoaYhq5XQXUCNSG2?=
 =?us-ascii?Q?HC3d3Z+VJ61pkm7EP/gmD1EKLYhFayoDyYJJe0+o35fcGLV+41orLp45twF5?=
 =?us-ascii?Q?tjFo1rQJrbVVX8IbA8RFY7zNh1f1YJBq7Pi4lUZYUjEkQRYiH3WyxOnDtQAk?=
 =?us-ascii?Q?7y5wwbRc5CtjbLiFHFVkdn2BR/hUcuxXUUcjKvN1R5RUIXbF7Ql2qbdNTtx6?=
 =?us-ascii?Q?XdqvfBiybiDNp3/Ya2WdsaCa9X5KmOAxAesAsczGrqnSpvt2iJq9SY8u+u04?=
 =?us-ascii?Q?Ewjb2ixT4dfVmA0TJXr96UHWzy5sA++kwMG6+fYq0ABUDWimA27AamBLh7kn?=
 =?us-ascii?Q?tvz23sz1fZibxBFq0y60wor+L8vQLHl0SMbxQgCHsO+keLqrYW193VF2RGbb?=
 =?us-ascii?Q?aiOdEaae4jjSX1Yhb3ln6YVRXv1cLFRvMb/AerzTbrCI2qXtWA1P1zuFOT3L?=
 =?us-ascii?Q?O+XcoMFtj8CXMMfn7LI3Ihq0fTUh9yy2S+SHIwlQlIadLYQJihPRa0oDUY4N?=
 =?us-ascii?Q?T7xcIA6Rs6oOifxAXSe/lc60hQSQb7+xyIhbUWPKr3SU/KsFR+DNkhUiu5/F?=
 =?us-ascii?Q?9NzLOGljqubQup93pSW+zF7pWKkLYYtSrsoo57CRUV9j7lwABKVTuKoP/UI+?=
 =?us-ascii?Q?j+eFuJdjza0ra+0J9o9v1Ydq63J9sK7FTn2ABI7U8iOCxnkubXH4ORVre1ug?=
 =?us-ascii?Q?bx1ND4JSi3xGfrFUbWTLlXYXtwuV8NH2w+xLeYa1oIeS4P/xWITf87zwcWPo?=
 =?us-ascii?Q?ma/pGXhK2W82zMJ34nQlp284e0NR5oSHt4z6YZ81RjTxsnpqJIggjUtt3UYO?=
 =?us-ascii?Q?Cq/WAKk6UBJPlaVzYcWw1dA5K8R2NqRWyHeFhrMzlyiYjYQL/W18SYB9vPtd?=
 =?us-ascii?Q?3KNo46bDXFvqEA9jDjy0rZzlvf4fzdyaJcn2utANuaEGU9kpDsra925ygYJ8?=
 =?us-ascii?Q?fHXMkne18OyznfHHX96U5eXKrNNm6J6Mj4/WlpwhcWKtLkO4ZQMBQd6pJ9FC?=
 =?us-ascii?Q?uCMHWtXd+YcUojpMVTLzE2jzCW4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f4a87a-0f54-4be6-11b5-08d9d0ae1fa5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:32.5047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNUFs71oEf47YNhgi7HdQFenO8q0YZ9O50YHOxGmaUoBi6kHqHSIWsHDfdft8CqgNWBqlcznbj9JIYkval2Dln4DyUzVdYup3fVDTmvWIlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=533 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: 5OSWCM1iSYsusk1kUE07XgTMUM3C8LaZ
X-Proofpoint-GUID: 5OSWCM1iSYsusk1kUE07XgTMUM3C8LaZ
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VFIO_IOMMU_MAP_DMA ioctl uses a single CPU to pin all pages in the
given range to facilitate DMA to/from the passed-through device.  The
pages may not have been faulted in and cleared, in which case the wall
time for this can be truly horrendous, but even if this was already done
(e.g. qemu prealloc), pinning pages for the largest guests still takes
significant time, even with recent optimizations to hugetlb gup[1] and
ioctl(VFIO_IOMMU_MAP_DMA) itself[2].

Parallelize with padata for faster guest initialization times.  Numbers
come later on.

[1] https://lore.kernel.org/linux-mm/20210128182632.24562-1-joao.m.martins@oracle.com
[2] https://lore.kernel.org/lkml/20210219161305.36522-1-daniel.m.jordan@oracle.com/

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Suggested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/vfio/Kconfig            |  1 +
 drivers/vfio/vfio_iommu_type1.c | 95 +++++++++++++++++++++++++++------
 2 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 67d0bf4efa16..39c7efb7b1b1 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -2,6 +2,7 @@
 config VFIO_IOMMU_TYPE1
 	tristate
 	depends on VFIO
+	select PADATA
 	default n
 
 config VFIO_IOMMU_SPAPR_TCE
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 8440e7e2c36d..faee849f1cce 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -40,6 +40,7 @@
 #include <linux/notifier.h>
 #include <linux/dma-iommu.h>
 #include <linux/irqdomain.h>
+#include <linux/padata.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -1488,24 +1489,44 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 	return ret;
 }
 
-static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
-			    size_t map_size)
+struct vfio_pin_args {
+	struct vfio_iommu *iommu;
+	struct vfio_dma *dma;
+	unsigned long limit;
+	struct mm_struct *mm;
+};
+
+static void vfio_pin_map_dma_undo(unsigned long start_vaddr,
+				  unsigned long end_vaddr, void *arg)
+{
+	struct vfio_pin_args *args = arg;
+	struct vfio_dma *dma = args->dma;
+	dma_addr_t iova = dma->iova + (start_vaddr - dma->vaddr);
+	dma_addr_t end  = dma->iova + (end_vaddr   - dma->vaddr);
+
+	vfio_unmap_unpin(args->iommu, args->dma, iova, end, true);
+}
+
+static int vfio_pin_map_dma_chunk(unsigned long start_vaddr,
+				  unsigned long end_vaddr, void *arg)
 {
-	dma_addr_t iova = dma->iova;
-	unsigned long vaddr = dma->vaddr;
+	struct vfio_pin_args *args = arg;
+	struct vfio_dma *dma = args->dma;
+	dma_addr_t iova = dma->iova + (start_vaddr - dma->vaddr);
+	unsigned long unmapped_size = end_vaddr - start_vaddr;
+	unsigned long pfn, mapped_size = 0;
 	struct vfio_batch batch;
-	size_t size = map_size;
 	long npage;
-	unsigned long pfn, limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret = 0;
 
 	vfio_batch_init(&batch);
 
-	while (size) {
+	while (unmapped_size) {
 		/* Pin a contiguous chunk of memory */
-		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
-					      size >> PAGE_SHIFT, &pfn, limit,
-					      &batch, current->mm);
+		npage = vfio_pin_pages_remote(dma, start_vaddr + mapped_size,
+					      unmapped_size >> PAGE_SHIFT,
+					      &pfn, args->limit, &batch,
+					      args->mm);
 		if (npage <= 0) {
 			WARN_ON(!npage);
 			ret = (int)npage;
@@ -1513,24 +1534,66 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		}
 
 		/* Map it! */
-		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
-				     dma->prot);
+		ret = vfio_iommu_map(args->iommu, iova + mapped_size, pfn,
+				     npage, dma->prot);
 		if (ret) {
-			vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
+			vfio_unpin_pages_remote(dma, iova + mapped_size, pfn,
 						npage, true);
 			vfio_batch_unpin(&batch, dma);
 			break;
 		}
 
-		size -= npage << PAGE_SHIFT;
-		dma->size += npage << PAGE_SHIFT;
+		unmapped_size -= npage << PAGE_SHIFT;
+		mapped_size   += npage << PAGE_SHIFT;
 	}
 
 	vfio_batch_fini(&batch);
+
+	/*
+	 * Undo the successfully completed part of this chunk now.  padata will
+	 * undo previously completed chunks internally at the end of the job.
+	 */
+	if (ret) {
+		vfio_pin_map_dma_undo(start_vaddr, start_vaddr + mapped_size,
+				      args);
+		return ret;
+	}
+
+	return 0;
+}
+
+/* Small-memory guests benefited from this relatively small value in testing. */
+#define VFIO_MIN_CHUNK		(1ul << 27)
+
+/* The sweet spot between performance and efficiency on the test machines. */
+#define VFIO_MAX_THREADS	16
+
+static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
+			    size_t map_size)
+{
+	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	int ret = 0;
+	struct vfio_pin_args args = { iommu, dma, limit, current->mm };
+	/* Stay on PMD boundary in case THP is being used. */
+	struct padata_mt_job job = {
+		.thread_fn   = vfio_pin_map_dma_chunk,
+		.fn_arg      = &args,
+		.start       = dma->vaddr,
+		.size        = map_size,
+		.align       = PMD_SIZE,
+		.min_chunk   = VFIO_MIN_CHUNK,
+		.undo_fn     = vfio_pin_map_dma_undo,
+		.max_threads = VFIO_MAX_THREADS,
+	};
+
+	ret = padata_do_multithreaded(&job);
+
 	dma->iommu_mapped = true;
 
 	if (ret)
-		vfio_remove_dma(iommu, dma);
+		vfio_remove_dma_finish(iommu, dma);
+	else
+		dma->size += map_size;
 
 	return ret;
 }
-- 
2.34.1

