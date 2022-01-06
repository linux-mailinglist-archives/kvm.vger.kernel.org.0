Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B266485D81
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbiAFAsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:48:17 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31660 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343956AbiAFAsA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:00 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4jdB031970;
        Thu, 6 Jan 2022 00:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=yvrNOGTULS/Zu6HsAvJl0g41BPCHDKMfE0kEjyGc2Jo=;
 b=GzYfRr6ZsgZszLiLuc+f10Okjwb02e4gQaIAuMm1BmPDQ8mf+yb86ZgtGEyfeAImnTxm
 0Tu4Cbg+HcnO1lyQ0JkdkSWg5P270nFfVjYR2P5xHuEJElZ40Xd260cFN3GG3tjFP7Td
 OjHHbzYeuCidJsKWogIXtqi5o58uWes+qB1BjBenH6SGNKbbefQ3QWuc+eGgu+OzCsHn
 cL+OANaMjTx5+Cdv+D/Oz0RpsKveWSliuNpADDl2wKfjuVtIjsJ+139XhfXTXje4RgBJ
 pi78A4G314T392a2ctg48KXIYWroGBvUevdG7EOZ9mXX4PCJ4BCFMXuaTXMasgDOGZXf LA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpjr3w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060W859102533;
        Thu, 6 Jan 2022 00:47:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 3ddmqgu54b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V49QziCn42D7s6sqyNK/T7b06BT5LqHeR5MlfJ4wsip+nfmVdcdbpWKTztrnJ8MXChephsgVHm+xvBAjO+IOZjsJMarJBttPtj9qKBXIpmLsvblEks8md71ay+yEsFmhAn+HX1SqwN5Trh+4ra44PaCrTSGv9kJ/VEdyXEfvT6FPPJnxfbH0pYw7w93AMhpUCms3PEf71m+cnAWzXLvxqxeD7Pk9dZf14jDsNvq4LDuarZlnWtAUIq6pNS6M1d9PY0CLO936XBmFVFH4/pI7oK+ySBrdeLgPYqQOov5kmyYrmCvVnlfNTNAQAVRQGzQkpZciilxPX70f9osKKYWgHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvrNOGTULS/Zu6HsAvJl0g41BPCHDKMfE0kEjyGc2Jo=;
 b=QLxsIe0no/yNU0uimveubk2Z0f6jNrMnZNUQVlCFQFVYjS7DPDWa4H0yEjeAZWS2ZNMpfchjE+UmEC0sYLvdHQ3FU3aFIMzUQC0BWWR3B7dmS+QqYTM905PLgqMz2S15Ef5BiwHpLyAeTjDX/5Bwbmx36iugT5cGAo3TgiZnkJ5gUP2ixYGeZk7y72Ln9U1j/c5J9UFHNBjgvjFgM5Wb22y+9T3PRwrjGIe8j4ckWE7C99u25Tv/W53sH+xbJdPRVewF+cAgtVr6yJncwmlziX0dVIyoqN5QPqg7af6ZxOhhz50CeO35Fi8jJ6z8ha6+J5QX2ryIXsDQBRvt/wIriQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvrNOGTULS/Zu6HsAvJl0g41BPCHDKMfE0kEjyGc2Jo=;
 b=AYw2z21OjVrgmUiu3aqYa1Oz1DDhegeCYmwbWh04eF2Iq4bL1+q2UbLkE9IR43buPLVgeOOswaYKultGddmnxZ0AUNUdnp+QiRDAKxAcaHHZOC2Vh3i5DnKuvRqcfg97XqZgOIAvYUbMDiNXjFqKrWZCqyOJUxlF1Z/pxfVD/VM=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:27 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:27 +0000
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
Subject: [RFC 05/16] vfio/type1: Pass mm to vfio_pin_pages_remote()
Date:   Wed,  5 Jan 2022 19:46:45 -0500
Message-Id: <20220106004656.126790-6-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: fda4b5fe-8a62-4e76-e0cd-08d9d0ae1c6e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB44228E9E66343321057940B1D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7HTnmjOGojUtjvcSIi0sfJQBF5QWSs9b4xHDI99xgMlN+SwBV+8c11oX9YZhAseOj/ixEmPrGjSxrRzEux2l9GpPacrD93aycS7o5Cgn4gEC3MjBbwtimbeq5Qn4jX8W79an5mOey9c/pBCUsynxzylKk2WD63xGgUK6qqZFcKXOQtE6FmqIGNC8KlYUumLiy8kR99dSTA+CoPyAHPt5BXGNqoZZVRXC6Qjs6ze5GQG4m93P1x9ZUWVREcFUIgvJ2C31vTyksMtb31uIL1aqmkmQ1AAR6KgzaJwXtHmj1lk1avES9QHcxR0g9YWh6ycbhV4yNCdBJ8GG3V/fZQIePHRVjpVUSNHvEyHQ6m4IXArhhyIAtZb2x8ir6QgOcvPg4V1ou+YHsAzOltFqsUYjXcjQOK5NsziUm7KRRwqjUwNTIMzMRF3n0KLK2WQ2GAfYHHb4H8LQfacrg+UpT20qMD3jRdeE0+YCkL2iPH3tzYQnVxr8OQv9L9ExgLcFuYKAUBXBKwbpcLESx54kqL7DGbUcgu6kOplNYw5rCOtRTRgN4wFHPPluNRzLWVLSknIQfunh1eCrPs7hdazgx9oaAdPagykuU6pH2Dm6PyP1zASB2XBIYWxilv0hR+WPmn8pC7FQRdBRx8lX8Axa4rsGsfOhWKtNUj6KAmBjuoohjtCrUHXvSlx9UaZZxRDf9zDi9nSQ8k+DbyGFDXTzyXtHVW7eK4+pfWM+tBiVZtlolvQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3mhWo4lpVW0YWvpZezieRFeehbd/Unz4RS5sJdezirG/fuGRATmZFUOmAjyM?=
 =?us-ascii?Q?RzIVdJZBehtkeqIJzJqAXuiC9dmgQvSuUy+6ahtH+ClnSKTK34+yujaS4qdJ?=
 =?us-ascii?Q?pEz67kZkj7TdSmVBEyTX787wZJUUF5NlJpo9KiykfosIJeHpkLE8jptGTtFe?=
 =?us-ascii?Q?1pl4C5v9xfD8ePG+gqjVFCMOebP47aqT/aYC560B2N0ro2qt2PC3gUNDAXY6?=
 =?us-ascii?Q?357liyHMBrl/Ad6BqSpZ84ule4USv33GrFtdstQv48ghs0SMX1KcaULhIa9x?=
 =?us-ascii?Q?Im2RcIqWlAVYvYt9u+Igzj0mPLCA8NzTMLzfz0drdDiWwD1bANZI9hBGah5V?=
 =?us-ascii?Q?IbjdfPS3mDoelNcFLkUJ2AwlnH43lN99e0At9BFFgApVEB0kRXK44gl3cF+n?=
 =?us-ascii?Q?dk0fZKTYr72dqkxvaDCZqF83MH9om7MxVQQDW2cREtwqe6y/rqu5JU6PWQZr?=
 =?us-ascii?Q?GVb1Af1xANU49NXmnotIbUV1qSdpfV4VDd70vRIyFMyKgdB9RtU8wfVnWiy+?=
 =?us-ascii?Q?mHeIMgCRJthx72uJi8AeKnnfEPSVClnjacphQxyrGjrS2GFUJbC/87QOYAL6?=
 =?us-ascii?Q?NjAYUpWmfmyN5yKVO+hIv060qVKSpFygdIvquFhhjZGSfxIJZX972T/EFtD7?=
 =?us-ascii?Q?oy3uC03AKs4oYkZBpGXzbI7LkJVxeg5yKBc8j55kHUjS9wp8DuvuhTd6Ll18?=
 =?us-ascii?Q?XjcWWOTIRMSw/YIYI3u3Q8n1RqDisk3RMD9cKqFn3E/xnnilX6bOLtineX58?=
 =?us-ascii?Q?TF+7Poc/iUW76nTosQ+GYKrKlRokxExrpgT3RijZLC9xA7Zy8zC9Tug3SuW9?=
 =?us-ascii?Q?bpuSAWvm26lT4rhtYrpwN4B9iRqc8z4+b4aWqkDrsMeY1GYX9sDe74MF63ts?=
 =?us-ascii?Q?DMRHmT+9uhL1aJpyQfwy1yuSGL//HKlWZ7E2b+0TH/+SkezVfZYAXTtQYG7C?=
 =?us-ascii?Q?d5pqa0vZaQzANlQT6eWv1YCir3LI4gW1P0j5upX8EkWR+5UTq5T76EriE1E5?=
 =?us-ascii?Q?2Ks7Mzv2b93THmpMGwvPSbnxN+lquqOdjp1oIFQZ4xPIo499cASWMj1S4A6E?=
 =?us-ascii?Q?NRrPETPmItVQdfIZTM2piehUFETekjY/O4CgZQ0Jm8EHiKZ9jaWkpM8DYb8M?=
 =?us-ascii?Q?VkN/DjgFTzGUe6j0XUyVDoR3/0Ori+JGwhv1nqzRsFnOjDmNd9UasvVk4gur?=
 =?us-ascii?Q?uveXtIWsg54CMiVm4zx4lNb7p/vSHvgiueLQ3Hvi0gaHoELpfg8W1q/tIjDw?=
 =?us-ascii?Q?RIhqt3m2Tz9fogrq5ThzIdVYsOEzop2V7s3/VD6MVsJTh2KJsRhFBhvXp82J?=
 =?us-ascii?Q?CLe+vCp01r0YnjY9XlBuGlyj/R5mJ+CC6F0X7CLX+43QyVBCdosl8Y3dg0l3?=
 =?us-ascii?Q?JXJZcAxPmeSbs6zqLfT3x33xpjpjFnhWIm7vFQNCmJOdKuqOdDrUPI0SERXC?=
 =?us-ascii?Q?pvYISIk7U6ZnQA3tcoeAE+W9cPFdvpWiBgw6ZkhcWrVQwLmHdFuAmXx9rLxK?=
 =?us-ascii?Q?jJZd552d9URzk/GpkQOHz49wjmCMNjDnKqMjquppSRjzo5xAounVDBRhnnJv?=
 =?us-ascii?Q?ObOB8+Ou38SL1SNPyQY/UbDiFtUZZ60a73vJ7jeC4qgbO2C6AeKgLOUjvtud?=
 =?us-ascii?Q?Ac8kIZhp/lrRYsGr8YXwBNGmxRgWMYM1qJAp6fNKk7ASS4IACKjQM/FHsNi9?=
 =?us-ascii?Q?JrFa5PxGskmgk4puvCjv42RWTb4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda4b5fe-8a62-4e76-e0cd-08d9d0ae1c6e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:27.1313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrORHis9uL2uEmjdDMmE5M5Su71WBIiBw0r9z867l8NpLrt95HAKDL0qHWKyRuCfzcX2MOOE0Dvqd5aBP9LJSSL2R8mmNXf8tbWIhT2HGkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: QkNMjeKvCArgEM4gNiTaTiOvU_IyKWlI
X-Proofpoint-GUID: QkNMjeKvCArgEM4gNiTaTiOvU_IyKWlI
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactoring for later, when padata helpers need to use the main thread's
mm.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4f7c174c7a..26bb2d9b698b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -649,10 +649,10 @@ static int vfio_wait_all_valid(struct vfio_iommu *iommu)
  */
 static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
-				  unsigned long limit, struct vfio_batch *batch)
+				  unsigned long limit, struct vfio_batch *batch,
+				  struct mm_struct *mm)
 {
 	unsigned long pfn;
-	struct mm_struct *mm = current->mm;
 	long ret, pinned = 0, lock_acct = 0;
 	bool rsvd;
 	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
@@ -1500,7 +1500,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		/* Pin a contiguous chunk of memory */
 		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
 					      size >> PAGE_SHIFT, &pfn, limit,
-					      &batch);
+					      &batch, current->mm);
 		if (npage <= 0) {
 			WARN_ON(!npage);
 			ret = (int)npage;
@@ -1763,7 +1763,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				npage = vfio_pin_pages_remote(dma, vaddr,
 							      n >> PAGE_SHIFT,
 							      &pfn, limit,
-							      &batch);
+							      &batch,
+							      current->mm);
 				if (npage <= 0) {
 					WARN_ON(!npage);
 					ret = (int)npage;
-- 
2.34.1

