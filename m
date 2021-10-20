Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEA04350EE
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhJTRIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:08:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36700 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230433AbhJTRIF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:08:05 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KGGQE4029728;
        Wed, 20 Oct 2021 17:05:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=opO+uA39Vb8tJJkf17Zn2DODkGVpF0CQbrukoeLiPwQ=;
 b=Giff2CnZ7DxRTh6eDUNho7xF1U3US9iSh1ZChNk8q6d3t9XZwRPOayyT8KyIQL+EEuKZ
 +U3RalRNYd1DuBXfglVvv2AOGb05DqXD8FSO9AjAdAH58s9menChiUdNiwoamNfbuwN2
 tiNVAtTTyYpBl+n11WaV3lpieeizLJPs9LbqyfW2tIy470P/zUi10f2STCqMMxsMIj8w
 REtatpeElZcffYMZK27BX6FPrv1L+zSHwHQHMnQWy+HUQ7AzfpVmQ+PUswUd7QNWOILH
 aZOQypVLc9yUwJ1R6xAXyrCaNw8mvLvCu2iIVtluZvj+f5XJvQ3fVxEwizQdSijZU4hv jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj1b8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KH5ZCX005957;
        Wed, 20 Oct 2021 17:05:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3bqkv0cqwj-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FK4aSQlwmDVU7eQFui3sbmOkOol2hZKXA5IeYh1YBniWoy0z7b6ZxMyE9eFYERkaFDCqm0v5xxf5p5EmDSyi6+mkpaOG6+3suI98wGAxHFsCqmBV1HW3QSwjl6B76k8Z8NgfFeAb8rfymg96kUQqtYwL3swUOSEKCsZFf+vt+IV0piMqNa6KGJQGgADoh45byossRiiYZj+wMrQwhKZRdSkFrggvAqdZQfqBJQi9QE1vKXRQVaUJBi9Uyb8fPBx5/1nnc+LD076TyGSUFT6EYcxLpQBJDA3n/2Bzrwvh0Fn6Fv0CthxE5I+JYvcaHEpTsftXqB+sUJ1APMWiGvVRlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opO+uA39Vb8tJJkf17Zn2DODkGVpF0CQbrukoeLiPwQ=;
 b=RL3dnTc5BLJlz2mT/BalsQvhTgVlT7tjGA26Nuc9jHM3pcWnj1xOiwM5Ism5qCm6OUynBJFGIpjZamJBEo+3X6egpFLLd5jY3F49mmnZE5JlMppanLkPVFumoS92iiefPlugoe0NkLGuDj0RD4mtKBpiro0vW2GFsu/uAtBVIofzzOE+y/31a0m3f0o7tQYN1grDFfdqyEAfoHj+JddNC0koKP5ObbcaaOSHR+M8mz8VKwt0btBtZ4lt5T0FtEhISqcckG4Y/01lO2JHNOeOq/tfFoojPb5I9HlXhFZhsKCK5lUHGzjOTAY0kaGYgoSAJnT4tVpruAbc26/zZlOS/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opO+uA39Vb8tJJkf17Zn2DODkGVpF0CQbrukoeLiPwQ=;
 b=e9KagKjB2ri5MwgBaEfIZgBpk7jCcljJ7tw6OKef+X2xtONX/CL+I1LmMfrDVZRKU+ImMRUlOKFrSfHDWPadurDgTrWHe9n0BLI8LSvwoYZuYVnmDGxA98ssXfeti7yiwOe0VPrQIFhwteZRCfJ6JrC6i7lNyhiaB0TiQr8LgS4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:39 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:39 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 10/14] clear_huge_page: use uncached path
Date:   Wed, 20 Oct 2021 10:03:01 -0700
Message-Id: <20211020170305.376118-11-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR14CA0023.namprd14.prod.outlook.com
 (2603:10b6:300:ae::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MWHPR14CA0023.namprd14.prod.outlook.com (2603:10b6:300:ae::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:05:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f40fdad1-b87c-4f9e-87e8-08d993ebd7b3
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4577FF300C918E75A2AAAEFFCEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?h1kalXAwzUZ/O18hhGHolsl79au6QfnnYdMQwd4i2gLKzQ+KL00Wsvf6wQfj?=
 =?us-ascii?Q?irigK2VdIiS+0Vi0IXq3DOYti9On4zWriuYhHazzB68w+nYZv3jgy6ppqImj?=
 =?us-ascii?Q?Jlu/KGQsVfJZ4h4BKyiuN4uJqEv17fampn4SPROC3mOtU/z365lIKgtXaCFW?=
 =?us-ascii?Q?XmPVKsgWtNsClka6LTA9W8lI6tr2zRGSbbwUo2WBoUP7x7lllXQtNQJobNkk?=
 =?us-ascii?Q?hTtvCbyZZ44qOQzKSMDpu9Ho5X3yLugcId449y59ebIhVoiDkOC1BhbfMzny?=
 =?us-ascii?Q?++hF8Neo8BMkrwUb+3Oee4tl2YRWEhh1wXbOH2b2ejyG0GCN5WERwHvr+4sC?=
 =?us-ascii?Q?piLtomsePVmSzoennbKkxBC+7GkorUmN6tXiK61+KDQ9N++hSaRzGGqRMlUM?=
 =?us-ascii?Q?/XoJkZH7JZlpQD+ho0X6PanawZJ1780R867hEXdVAywfUMY9lr7y2iFquiFl?=
 =?us-ascii?Q?Fk1BLmZK7SiMrQtE1bv6pet5+Q/Un2qz6KjptuduBNTa2ZSLbdlDfoo3bufS?=
 =?us-ascii?Q?gkbeydx6M5s508yipG9wO7u1fhif+FhyTPheO9CjgMDXvL96fgGEgjykQsm8?=
 =?us-ascii?Q?bzA8vBbaZuViAXaTBx1IACO+QJwRkDjJiLIHEecAJmoz3464Oit3z0NqBmOy?=
 =?us-ascii?Q?mVx7sBPMawoo2nG/YkZV1UqsSMnkhevF/2E3MLN88pcr/zNjlQW6DSuAyT2D?=
 =?us-ascii?Q?VQS6IVoO5hzr7cRkOJhobQjGHCTE/KGO8UOpavRpHk8qKiPcachV8XwDj6Ql?=
 =?us-ascii?Q?2uUH0vDh0uH8yJpWo0J76v39IzBu1GVS95TQnznXiOZgY9JDb9e2vMoIAUKq?=
 =?us-ascii?Q?fw8iu69ov/oI0cvltuNuydoM9bF7xQ+PJUNm4aW4/KPZeTB1/xYg+ed2HpQN?=
 =?us-ascii?Q?t5st4ksPt/5hvgY4w5nxjzFsRXIrigTdE4K3m+vYnJnfNKCkkgJzW+Gpw8/S?=
 =?us-ascii?Q?oOTPTMMZvqfaTO/CeLKpOF9JuiBiQzLbHshmFc18CIu6KM48iTG7jn68VR9v?=
 =?us-ascii?Q?2sDX5eJlRrR1Tz1COil4uq9NMimYLG3IeF4PgmFJfTqyKmE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(83380400001)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M+uCvEZ1QENtg1dwJ+HDk4Ac6P45BXzjIhPYlcmYtB3geIvf1Z5npnx1mG4O?=
 =?us-ascii?Q?/GfxTqJkQfll9DZVNXrCjo1MDkoU05/uw9JMAi6JlFrxvY0DfJ/P1W+dqzBN?=
 =?us-ascii?Q?AhtY1uk9EvnA6Kt3kHXl+I3GWtNv5f7f0DFrijnLaxJMatL+I1l8BQZyH4nx?=
 =?us-ascii?Q?D165gxoN8t58gigxmVQIxQsr3xg2xjdmQXHW0YgfykbkSr4moE+VB03nV4U2?=
 =?us-ascii?Q?rJ6jVnT8QXgfhtsBi8SGRHBGEcEn6coe0uyMOxvs6Q8EFW31r8yQ3ecqVhmS?=
 =?us-ascii?Q?FVtCWHOjSO1O0LCj1GdDkzrH4b2gYjEV3isinstPDguu00f8hSxOIjL/0/2D?=
 =?us-ascii?Q?GMdGMXniWXNkaAEHFreQz6UFnHrw55wEGTPoDCDwMFS4rz4Ix9N+mPayAtGH?=
 =?us-ascii?Q?nWllHFsmzvla7i/eI431QRZqJsazngq/y7v+YkACIkfUiuOszHkVBMnXwfgZ?=
 =?us-ascii?Q?xA9hjbE0Qjeoe8y0t88RLHJuUQhvy93TmmU89DVHAnH1/cwRiqnlcFSyVwhl?=
 =?us-ascii?Q?PtmolHX/q8cK2qVSzns6RB8uoZIJHyIbMQCZ1ZhtcM3XKCV75gooE/yAKQ8S?=
 =?us-ascii?Q?8ihXkODE4GFl+nrlWcRd2YqObVBxMdp5PmYKNQe2zqYp0mY0eCMtvFzHq402?=
 =?us-ascii?Q?80h3BocCOLZjxyCLPwYusVY9L5a+guDZ7YMKfgmgSuIwcozLvwUvBOYdqYMo?=
 =?us-ascii?Q?gaS9ATr8WTk5DktC8DLBjP9XvsACvZCxYdxOeu7lRIiEG4aqD5FE3J3hfSe0?=
 =?us-ascii?Q?DnaEN1HQTctP2O4roXtAZbGhzMQPcSpO3f/RisYKVwODJA2s7qZLHI+r9mgx?=
 =?us-ascii?Q?sPerIQ13fY1y/RAirNBtvrG9rouwNlySzjNjTUqH7Gfh6tJdQbWY+qF9O7Gh?=
 =?us-ascii?Q?UHvOrmyQDpAD39BXvJSH/5jrCgBxAYA0LGFElxptyxbWXVZkLp83MQCNaYYd?=
 =?us-ascii?Q?Wq4rVM4rJL5NULmm4TRS5wYIHaOgXP24TQme0S4J1XfwDyHZ2izNDG7/Ujaf?=
 =?us-ascii?Q?5SHP1Jp3n1HilWnJAsOR4ep/ChWzZ5HPiwjFneg9HOQ1odGiHJcSew9jB9EK?=
 =?us-ascii?Q?sfARj8yGQrxzPBv2Nf+EkwT08GAAgbsgZLpL8SviKHEYbVy4pVQHjRzDZ9xd?=
 =?us-ascii?Q?dJlBat9GrHLLCkJU2j0d2ozP0JKg6ftquSFvLe24cDZFFq8dgkuocpgd3yGA?=
 =?us-ascii?Q?p7O1SenhUZDsSm1VwrarzJyuskLM4dd541BDMoCofp3/PAAms1Vgu6zkmIRq?=
 =?us-ascii?Q?inL0BbCHf4ifut3eOqOWs+4oRoK9r4nJJ/t3lgCF//lPHI8ukADh3gbbwzyG?=
 =?us-ascii?Q?pAmF10vkIHUyn6EtoLEHAS2RpzSnq9IYEtFoXI+bRicMDaKtn5vgl4iEu1fz?=
 =?us-ascii?Q?gvNl00qljmSZPkGZjPBeh+tt8rohwu5swF16qAOcYiEZbLVuW3paitzLH/Dz?=
 =?us-ascii?Q?HD6NXvVRTwg0uk9CWtk123P2HNLGfFke?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40fdad1-b87c-4f9e-87e8-08d993ebd7b3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:39.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200096
X-Proofpoint-ORIG-GUID: tPkQ_iojXRlk1gthQRSLg3K3zJkMF_vz
X-Proofpoint-GUID: tPkQ_iojXRlk1gthQRSLg3K3zJkMF_vz
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Uncached stores are suitable for circumstances where the region written
to is not expected to be read again soon, or the region written to is
large enough that there's no expectation that we will find the data in
the cache.

Add a new helper clear_subpage_uncached(), which handles the uncached
clearing path for huge and gigantic pages.

This path is always invoked for gigantic pages, for huge pages only if
pages_per_huge_page is larger than the architectural threshold or if
the user gives an explicit hint (say for a bulk transfer.)

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/mm.h |  3 ++-
 mm/huge_memory.c   |  3 ++-
 mm/hugetlb.c       |  3 ++-
 mm/memory.c        | 46 ++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 49a97f817eb2..3e8ddec2aba2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3164,7 +3164,8 @@ enum mf_action_page_type {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr_hint,
-			    unsigned int pages_per_huge_page);
+			    unsigned int pages_per_huge_page,
+			    bool hint_uncached);
 extern void copy_user_huge_page(struct page *dst, struct page *src,
 				unsigned long addr_hint,
 				struct vm_area_struct *vma,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5e9ef0fc261e..ffd4b07285ba 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -600,6 +600,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
 	pgtable_t pgtable;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	vm_fault_t ret = 0;
+	bool uncached = false;
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
@@ -617,7 +618,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
 		goto release;
 	}
 
-	clear_huge_page(page, vmf->address, HPAGE_PMD_NR);
+	clear_huge_page(page, vmf->address, HPAGE_PMD_NR, uncached);
 	/*
 	 * The memory barrier inside __SetPageUptodate makes sure that
 	 * clear_huge_page writes become visible before the set_pmd_at()
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 95dc7b83381f..a920b1133cdb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4874,6 +4874,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
+	bool uncached = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -4928,7 +4929,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			spin_unlock(ptl);
 			goto out;
 		}
-		clear_huge_page(page, address, pages_per_huge_page(h));
+		clear_huge_page(page, address, pages_per_huge_page(h), uncached);
 		__SetPageUptodate(page);
 		new_page = true;
 
diff --git a/mm/memory.c b/mm/memory.c
index 9f6059520985..ef365948f595 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5347,6 +5347,27 @@ static inline void process_huge_page(
 	}
 }
 
+/*
+ * clear_subpage_uncached: clear the page in an uncached fashion.
+ */
+static void clear_subpage_uncached(unsigned long addr, int idx, void *arg)
+{
+	__incoherent void *kaddr;
+	struct page *page = arg;
+
+	page = page + idx;
+
+	/*
+	 * Do the kmap explicitly here since clear_user_page_uncached()
+	 * only handles __incoherent addresses.
+	 *
+	 * Caller is responsible for making the region coherent again.
+	 */
+	kaddr = (__incoherent void *)kmap_atomic(page);
+	clear_user_page_uncached(kaddr, addr + idx * PAGE_SIZE, page);
+	kunmap_atomic((__force void *)kaddr);
+}
+
 static void clear_gigantic_page(struct page *page,
 				unsigned long addr,
 				unsigned int pages_per_huge_page)
@@ -5358,7 +5379,8 @@ static void clear_gigantic_page(struct page *page,
 	for (i = 0; i < pages_per_huge_page;
 	     i++, p = mem_map_next(p, page, i)) {
 		cond_resched();
-		clear_user_highpage(p, addr + i * PAGE_SIZE);
+
+		clear_subpage_uncached(addr + i * PAGE_SIZE, 0, p);
 	}
 }
 
@@ -5369,18 +5391,34 @@ static void clear_subpage(unsigned long addr, int idx, void *arg)
 	clear_user_highpage(page + idx, addr);
 }
 
-void clear_huge_page(struct page *page,
-		     unsigned long addr_hint, unsigned int pages_per_huge_page)
+void clear_huge_page(struct page *page, unsigned long addr_hint,
+			unsigned int pages_per_huge_page, bool uncached)
 {
 	unsigned long addr = addr_hint &
 		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
 
 	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
 		clear_gigantic_page(page, addr, pages_per_huge_page);
+
+		/* Gigantic page clearing always uses __incoherent. */
+		clear_page_uncached_make_coherent();
 		return;
 	}
 
-	process_huge_page(addr_hint, pages_per_huge_page, clear_subpage, page);
+	/*
+	 * The uncached path is typically slower for small extents so take it
+	 * only if the user provides an explicit hint or if the extent is large
+	 * enough that there are no cache expectations.
+	 */
+	if (uncached ||
+		clear_page_prefer_uncached(pages_per_huge_page * PAGE_SIZE)) {
+		process_huge_page(addr_hint, pages_per_huge_page,
+					clear_subpage_uncached, page);
+
+		clear_page_uncached_make_coherent();
+	} else {
+		process_huge_page(addr_hint, pages_per_huge_page, clear_subpage, page);
+	}
 }
 
 static void copy_user_gigantic_page(struct page *dst, struct page *src,
-- 
2.29.2

