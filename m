Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D165B485D82
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343985AbiAFAsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:48:21 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31546 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343957AbiAFAsA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:00 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4jdC031970;
        Thu, 6 Jan 2022 00:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Q/6bDBTgCx+bOXRkG/YRDrBG3uA87fmnjSGMlx+MiHQ=;
 b=Q7tnx4alkn/Z7w47+JnBJAWsQHv3jqDVXch4dygL1t0YgKsd/nXidYAoxbaaySXlN1/+
 Vxvp0kKGDRF5BzzhnBvRideW3SgU91JUz2uTqYJaETk8AcLmnpVZF7Lh+NuHlwcMgF3b
 8l0gyHfhBHJgNDcLtz3ptgpgko3t3f2sbynN7kKSfxWl00xRGTUdN7tVoghsgUohAO5S
 GPosTxOAq3CGvz5QB3jZKwsHm99chvfJrSoz0BhYbd7Oj1avtDfAoPKCZhkvlECENjib
 JK3mC+NsB1iJUZFo38qwZ4t2BCPU7b5cMCT64i1oC/XTnEzfXRQYQoCE0HkKD0lNuTL5 dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpjr3w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VgDL076303;
        Thu, 6 Jan 2022 00:47:31 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by aserp3020.oracle.com with ESMTP id 3ddmqa3d87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkNuM7MoNkUTOdn2ZmZGWfY5bpYf+qbyFo+ci1/qm1oCEDU4VkysLc68DzDj5T6qfTcLxDhH0EiDrhL8giie+cuzQBtVVFN7xjn9QFYJVsq7MVhpVXOxNqz/xDKUo+penV5EeqkCFd+uafoRy5HoBs2jVjBEPVc/4nVzTY/fdPdh5iCR4Iz3DC1rsaUfMBTZWXd4BKxyqv1a4pV7ZGYRwFCzXHCvIkt0VDm43eimXpxWx4Q7UOCvJq2OGjT0S+9XJc/5JHqzGxsumP68KrGR4XK5xlw3v9rLWfG9by5FqdwYQQ11entjmc9f3MwBBCPLV5EgTvVp2eFAq/yV2jB4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/6bDBTgCx+bOXRkG/YRDrBG3uA87fmnjSGMlx+MiHQ=;
 b=kQWfoAKltKYJNQJev7HZ6ojlHVOw2rtxSDGMHtpZOGFm+Rtt2ToCUGIVimka0fDvN7VBKZdv+MgZ7yQKB9ZEy41ja+l4eC39Nl05bch9LUCrwC+qCg0TrTsWsfhZ7E3usMzr7bmr+slwDKfhyu8M6nFBxGUbTjVmyMYpIMDymmZYlNw2aJmnR17jaTWgevsfuqJXuBAK8TSPp13fKW10joCF2gg73GqH+Oxl2ebiDMLM/IW6QyBnvtHNZv3NxQkNP8xwbKChanuMbw0x+ruQJe09ciPT08lY0pmEh5uYKBjnmFENhePgUtSMCZjLbCZh2QWuCbD3MgiD1y/SHnUCuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/6bDBTgCx+bOXRkG/YRDrBG3uA87fmnjSGMlx+MiHQ=;
 b=UFgHr0Xnw6obdyx9+omdx/qkgB0akl6+MLScnLnIsUCOGJXd3e5qHaUeG2MD8Fgx+DPtWrqkMlB0GxbzQkBL7YgeoZU4AksDdFYw7iJ3tVP2jR/rv9IMdMP88nJo9I9MV9yRcxjS1tSrv1i+JXNBPvYaWSmGH4fNnCxuKvNv7uA=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:29 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:29 +0000
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
Subject: [RFC 06/16] vfio/type1: Refactor dma map removal
Date:   Wed,  5 Jan 2022 19:46:46 -0500
Message-Id: <20220106004656.126790-7-daniel.m.jordan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 88432e5f-372b-4cfd-3064-08d9d0ae1e0b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB44225E314266FC820E01B213D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1tI8xlG/Uhy6zrHk3l4ZiBmX/jgyBNrMogOs2N9NsOrU0oUAeDzcargpACrAP2tR41gFYOnZ+jKTzVLjqFRApnkde9gWVhCb/LIAQ1Vp0ta+M8FWKnur1JFn484kXLdQR4cbWAGJKW/w/pjRjZJx6GAaJjupDDOiyJkeeMAM5pUEfH1TnYcWikvcMAPSAqy3cV3CfD2QCKqCmeWx3wGkVxmFVbgB7qWSmC2eytnNq9Gv7TIxZVy7q19KiBy6EWYIAFywu8Bi3hpvbPTwqWlJxAnJplXVxo57djTEp2mvri48Si3quVdl2HbSgnNZKtelHNp5Fple50JMp+y8FeMPFYtm7U91J2JEeLcmOox8GkPlu46f9ftxjcCL6nkz+EacUg+np0LzL9JaYW7xq+mz2j095/4oYPbvHd8llREXqzxKeS2viVgHVJMVQ2KSRXJoCoMMS+yEShmEW4tyEf2xf26BE4ukbqtOxFMEfha8u9mUyGkaH3SdTHmR0k+q5wtHUcSe/NR2W1j7V9GYMpt8Jfra/KjMcrwP3//dFK0ncE8untQqm42hbqJHokas8T+Ek0p8EJTTQVucsh11LWEicQOwzHjjwvXXDEUX/eslAbhk0ouyGJFgz9M6UpUxBTpes6c+F3NO42Omx06ZRsSIUGPT156bDNEhWqucOIL2F9/qjI04lNtfzzfBZUNipF01gBBB7U+V7yIPiHknz5ollrUJOPpjtb5ZtQUnX6LIDk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EtRnG/KAmJmcrxE5G44vh3dkhKyqCAgggGyODj5vLBwzrm7oD1kIM7fRe9+P?=
 =?us-ascii?Q?095W2uasDKo7STE0MFeTlsaMMzlNMXyFwF6OGpIjuLEWU+62OKXzlnVYsKhh?=
 =?us-ascii?Q?kdmaLq2tdqBDUTiRr24HizXonuEwBoMT6neuTFwj4ByV+SwZnfWthZyAS4XV?=
 =?us-ascii?Q?RL6hf6hcot1v4ZESA2as8225xyXvbx7NwYf8pKJav/FwGTP8RZLo6Z+I1jVf?=
 =?us-ascii?Q?172HWNDfYzX8azE9PJbUD5iNxmXEJyywZDiM/UG3pSrsjEc6wepdNzfJpSpb?=
 =?us-ascii?Q?8bfH9js4zViAspLViWVIt4/4JFeRJHEexwqQEWQPuneTVRdGvgRM3XexbfJD?=
 =?us-ascii?Q?QAyE3BSMT2cYNcXnXkNtIdle7fkfhj/gmrrhrrsLw9tq3y80CUMfd23uoppI?=
 =?us-ascii?Q?HfsnhZZ5CFRsUAFGp851b77izxEh2wFJOakxr+biQ8ea4P4gTOjDadRMjeTV?=
 =?us-ascii?Q?2+NSQsDnS0uKYWHaINIy+Sfkrh/Gpwx5jPmnCwK0/Qn1HlK0lojZ3dGIQGVn?=
 =?us-ascii?Q?M1dLxS7hD0mpYa2+pvKFW8PnyVe8mTUr+7QUnCF+msn1vHyMkSw7Yqj9/rfj?=
 =?us-ascii?Q?kDCjmfo5pYWwcAhyp9JI0CwbHPWj+nEzqqpGJM9Uy0PaHQB8OnCbYRzqZpRK?=
 =?us-ascii?Q?VEOVr+Ts+/ZqQHEEutIL5Xb4U10RfmtlmWy7rZOP+fGDjbCaRL1cFQQnAURx?=
 =?us-ascii?Q?Zi+5qBHhO3gNdJihuCr+V6znNCm0Nv8Wkmlz7n7YFfA59sp4QwzN9KDwmt0N?=
 =?us-ascii?Q?bYg/0yajri4bltNCBihDbDWYPl72Nhjwmg6g8WF1k2EShNycsIBq1W2JzjnP?=
 =?us-ascii?Q?Fba/NHLGdCqB/7KLmFBTE2P/upGREgM8djinYGVBAFWN8BYo625wJiSZasfL?=
 =?us-ascii?Q?TrCQC/kGrkeV1SoieDfR0RmgIcKgUGqyMPAaCQTfxYaLr+ddfwwGrSecBeDM?=
 =?us-ascii?Q?Dk4BmPm9xpE+LtM/tfbtavwg3B4l4byhKvb8IcjmLQIwif1Ha61AUgyvpjvW?=
 =?us-ascii?Q?G60aVEvsFOZK3fy2lgv6E0Qn756yiCl7PA+/06TfRie3UFPmUHYCOF5bB+t8?=
 =?us-ascii?Q?lSy6Ga0SrVztLmTDcTg6Wi6orPC4JaV/OPleQUyZy0hLXDwQnTnGkgLDXlmc?=
 =?us-ascii?Q?qJh3fP+sJ1ziVCJh9Clg1XW5izlQn1GX/F6KY/1nPaZw/bkjMQr8k7C3xRr7?=
 =?us-ascii?Q?Jt0fGnac9i2M63nCUACEUIKRe8aY9BgC6DU7v/WkG57TOv7fAM8BLHeVGE3O?=
 =?us-ascii?Q?dWFw4HzdBu8mQxJrtOXjfahT4MRyl6lQUji+h6TaXkOo3OUBuqNu9McHhFaS?=
 =?us-ascii?Q?Ss6iZsV3Dwo/y5Fx1BZlH1vBl25DqPidM+Oihcy+y3i/hdFpyZnKjvL8f10q?=
 =?us-ascii?Q?gxG/RJCUH1szDjcHqDKgjI7tCdx2TD15aplp4CilmnPEbOMEP3cfwojVY1Yp?=
 =?us-ascii?Q?4sVbNVmG/X/+6FZ8z+NmMQ1qa45IE6Kh4B0BmoOCzstBEF84AaxlgNP0QsYA?=
 =?us-ascii?Q?SZsX5Ej28pJCUQeAZsZDOYVCyJoIF/DIuWVozpUVkEIXdA0U+IcvqHVxGDsK?=
 =?us-ascii?Q?3MTDaEHAG5vpyJPmwaCOIZYmp465Ty1A2B7UjTbb1GGzJqYY8N9qcaDVvgKj?=
 =?us-ascii?Q?/DX+WdAc1I//HboYxK3/vT4SakToiM71BVwtktgwtqiN+XL79A5OO8YIrGqs?=
 =?us-ascii?Q?X4Y/87kiLVOg1SX8Lc0TMufiACs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88432e5f-372b-4cfd-3064-08d9d0ae1e0b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:29.8125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMguZG52AxPDZi/wEB3uMm9ScURkaKA7S8dsm0hRKpqpjsZ3IN6QLz9BMYqu05UO4T68XvpJyfE3A3s3UATsTCFDpbwO6gx3XnNOosGjTkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=957 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: wbmakN5Gn_W7bdHHFuLBwxxd7FCG4684
X-Proofpoint-GUID: wbmakN5Gn_W7bdHHFuLBwxxd7FCG4684
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do these small refactors to prepare for multithreaded page pinning:

 * pass @iova and @end args to vfio_unmap_unpin()
 * set iommu_mapped outside of vfio_unmap_unpin()
 * split part of vfio_remove_dma() off into vfio_remove_dma_finish()

They all facilitate padata's undo callback, which needs to undo only the
parts of the job that each helper completed successfully.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 26bb2d9b698b..8440e7e2c36d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1078,16 +1078,16 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
 }
 
 static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
+			     dma_addr_t iova, dma_addr_t end,
 			     bool do_accounting)
 {
-	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
 	struct vfio_domain *domain, *d;
 	LIST_HEAD(unmapped_region_list);
 	struct iommu_iotlb_gather iotlb_gather;
 	int unmapped_region_cnt = 0;
 	long unlocked = 0;
 
-	if (!dma->size)
+	if (iova == end)
 		return 0;
 
 	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
@@ -1104,7 +1104,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 				      struct vfio_domain, next);
 
 	list_for_each_entry_continue(d, &iommu->domain_list, next) {
-		iommu_unmap(d->domain, dma->iova, dma->size);
+		iommu_unmap(d->domain, iova, end - iova);
 		cond_resched();
 	}
 
@@ -1147,8 +1147,6 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		}
 	}
 
-	dma->iommu_mapped = false;
-
 	if (unmapped_region_cnt) {
 		unlocked += vfio_sync_unpin(dma, domain, &unmapped_region_list,
 					    &iotlb_gather);
@@ -1161,10 +1159,11 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	return unlocked;
 }
 
-static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
+static void vfio_remove_dma_finish(struct vfio_iommu *iommu,
+				   struct vfio_dma *dma)
 {
 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
-	vfio_unmap_unpin(iommu, dma, true);
+	dma->iommu_mapped = false;
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
 	vfio_dma_bitmap_free(dma);
@@ -1176,6 +1175,12 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	iommu->dma_avail++;
 }
 
+static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
+{
+	vfio_unmap_unpin(iommu, dma, dma->iova, dma->iova + dma->size, true);
+	vfio_remove_dma_finish(iommu, dma);
+}
+
 static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
@@ -2466,7 +2471,9 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 		long locked = 0, unlocked = 0;
 
 		dma = rb_entry(n, struct vfio_dma, node);
-		unlocked += vfio_unmap_unpin(iommu, dma, false);
+		unlocked += vfio_unmap_unpin(iommu, dma, dma->iova,
+					     dma->iova + dma->size, false);
+		dma->iommu_mapped = false;
 		p = rb_first(&dma->pfn_list);
 		for (; p; p = rb_next(p)) {
 			struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn,
-- 
2.34.1

