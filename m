Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275F046B068
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 03:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbhLGCGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 21:06:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55888 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229784AbhLGCGg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 21:06:36 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5TFm004022;
        Tue, 7 Dec 2021 02:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=sWO0y+CSldeLSc4TCR/mjQxAsWeZjuyxqQMNAdv/KZU=;
 b=YCbpsqP/fKMC0xm6nZEwPvjSpUHj+Far7ullUCPZl5n1VnhTo7S3gezZW3ddvFZqWWt1
 qsCY3WfJSEUWEMUv31cUdo6RqU+LZxaNA1ctfkX7UtYY/5gfN0zzn1Dum6OjGkmNoz8S
 sb6s4IE5lbwuiAYHRo8CYKuCLTWR9Mt9PLjMKAvUFK92wWDn9TJLllabCZG9NXECLbUx
 ZhQf7ZXl+AySSJVDAUXDO5MzXkKApeWwxqm00xbMRwgDhnVBfE09slk7LwOAMlekLRnq
 7UMJFUK8Uqo03VqY75zLTsjfo08Hc4c57GiIDPccfpXo70n/VNWH8TTAC+XI1iM/jt5Q 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cscwcc618-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:03:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B7228Iu035250;
        Tue, 7 Dec 2021 02:03:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 3cr0548n4b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:03:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lv3x79Ya7YQVd3fo+1YJyz0onhRwUyuyxye8+9RQ8NKbAtDyPzV5Nv1KTl2CMQfk98ESJRxPgVARy7ASEX9R3usZV5ZkNTyXv/8LJpCxVMVprJqAxWk8oke+wctHQ3YaDvGCm4MgLhivaFYB2Y2YhUNSvky63/lNpzYcETSqXw1VQddl6FfSTZDqOae5i7lDNBuXtY2YiEp8xF4yQORhFErtf1klbNVecf4pKd4EGbYolYjV+Riit0hUdY76JuyA0vlPbHYcww116rNy3ANYsX4qE+lVSjnSr/Ro0+CY/Em2Ie7W1P5ePlV3EmIXWbzcudn7Lo4jjpkIO7PO91tiig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWO0y+CSldeLSc4TCR/mjQxAsWeZjuyxqQMNAdv/KZU=;
 b=B8fQ+kcQMiJ+zFMfgJlV0MdujLHcqL950sfNCwrGH+vARlUkGhVyRtrG89g+uls8z+9wksB35cgSz7bC7B5UnauLY3YfMgkq+h0nOW50gGWHfgIjaOm3I2mCLfmRdfWhoJNykJiWqCg5zn55AW+mFGBjds5QlWKG6fqZ3SKBS0jc6/gTzDZPVfIe91gy13B5c/L9/3dXrKSkrrwT6jpdgcOnFH0MXns5PSbkyN9kg8R7OkQsynxOKUfgI8bjjGnLpULOadmiGESFSCRRecjg/yup0KnKJmmpu0Mc6mFNTT9mnxddTPXSBJaVACOp13tyTBD97FN9qEAuB7QYWnMPMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWO0y+CSldeLSc4TCR/mjQxAsWeZjuyxqQMNAdv/KZU=;
 b=i7as536Qf1nS/29jJFps00ob0DJJvEj2I1mUeH41znlavjJWiIJpaVwXwXGuQwNfBd8/KEH28UMXVSsiMDmF/O7NslYaqZbzFcO1sCJd+n35dKGhbM8NO1W2H7nTbh+riwiMOnBNKJvhdAMOIs5Ohp9PbA/fqmiDHbNuPgR2vLQ=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA1PR10MB5709.namprd10.prod.outlook.com (2603:10b6:806:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 02:03:03 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::d948:18c7:56ee:afca]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::d948:18c7:56ee:afca%2]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:03:03 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/2] KVM: nSVM: Test MBZ bits in nested CR3 (nCR3)
Date:   Mon,  6 Dec 2021 20:08:00 -0500
Message-Id: <20211207010801.79955-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211207010801.79955-1-krish.sadhukhan@oracle.com>
References: <20211207010801.79955-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::37) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR07CA0024.namprd07.prod.outlook.com (2603:10b6:a02:bc::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 02:03:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e73757a0-0f41-4e90-60a3-08d9b925b3a8
X-MS-TrafficTypeDiagnostic: SA1PR10MB5709:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB5709D11EC7EB9A093DEC1C97816E9@SA1PR10MB5709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57AxPRG+F5Si8rdbq8lE4O1D9ciHkg1Y1O8QNMYZX0lNunZ6zrzAa5N48vj06v72Xw4GHGI9BkGSNH+oYOuJpoOxOGXdy3IhqCv7IsR5m7eJP5eE37MFadAGXZORa/SUo2u5qXF72sXm5fj8il8/zfp5u5HLJcsWLwqZWMad5A3jJ62faqX2uTMaQbM1H1bqUBJIpnKqQKBr64F5feTWd5kx0uiABtvrJuV3Nns2PpDlgPlyCJDAg8rVw2ZmnMgb47+IvEA3Orwb3YpmaVPuoHDZipTp3jQxp45L4RSCWPrnRzvA4P87NSEeGXq3/ArvDkGPMaIYsPxyjwuc2I8hO6PfHjMCqWFSdclm5RA9p751mZokd75kbYXrJTGqhE7cMX2Lsnhw+h4xrlr6Ep78vTKfbSoZG1lnbDZ/uG7WFB1+jJ9Jb7+6o2yXOIdN3yPPG+UJegKg5KtgyTcM5sq4QwbxarFk/I2we0jHcxd717acd+EpVozbugl/dxqmNC+wk4DY0JaaQ2cPg15FWEZmnSxDMtEfcRjDwAQJQcvZIG5X6gTt9CGRmkaY+XYn3xdZ04i9YmKyNhn0F/DO0HySPJea1GgzLWDmfK9KLnv8P1Ix6W9XvTd2Fvcx5ed7zt62nlWWAKJ98pVkrxJWCHxSW+wSeqyj4j8pyHNsjGqtv/cwgRo01bsJgGCXct8jGtfUVJUDayOXouhkTOi7xCtWWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(8936002)(5660300002)(86362001)(66556008)(186003)(4326008)(6486002)(8676002)(38100700002)(1076003)(38350700002)(26005)(508600001)(66946007)(316002)(52116002)(2906002)(6916009)(7696005)(83380400001)(44832011)(2616005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YJMhPzMyH6ImOjXjF+pdD9EvtCr18S/v2O39R9RvRJ2x2emVnhTNq9Ne/Hoz?=
 =?us-ascii?Q?XuYEZHb9cwfYMOuiEGjowKiJW9MkMqhAZjT3daeJVcADPtTiOTWYriiS118q?=
 =?us-ascii?Q?EDVxc/01NZChhPnHbVlW0OOVQmJUx7ptrCqaw8dZjkkKUxVimxSHeXwu49eK?=
 =?us-ascii?Q?N3gcXXGQHefdnFjJVgMwoQ4cwMM8+TCDFSt3wZBU/Im9KR48yJCyU/95I7tS?=
 =?us-ascii?Q?IRJ+sy7jGllzFvP8lKzuz1SDsfWeqychaSh/DLQTvJUz1YA76BVNUNXIzF+k?=
 =?us-ascii?Q?0H65NsuJ9Q8ovxRTq20cWXjIv3WUUoC/KCliHKgoYVOPDEk6+MtJAZMUodfx?=
 =?us-ascii?Q?MA0b9wBphg3B8dWGK92vI0ZYvFllIH6nuaDfaPq6hgoLDMlayEKm544s1hmO?=
 =?us-ascii?Q?IAhs76aQjhlWxQD8g9//aOsHfBVN+S/q6BY7OgfPR7ZFwOx35uVspmHVS0OK?=
 =?us-ascii?Q?l6hWsFkuqqEH8DjIPu18tNS+R5zmt1dVngonZjnUH2qRffDgk9JGigGilB36?=
 =?us-ascii?Q?gnmx28x3h7SHOY6wev4xVCcwoCNZ3DK6NSRgIhaeL7HSnsKzlzIRTD9Q0oZQ?=
 =?us-ascii?Q?0b5P0mcsKOZlPyEhp/g+iqUGr9Z1ZZCHd5Blz/6JrK+INGOHxeJZCq0RU7xt?=
 =?us-ascii?Q?PPFGVfwjS5O4hY2hMi55eOKt7riLJ1wErXKf1ycz2WZ5/Aw1leuI5vYqzLvH?=
 =?us-ascii?Q?y6LUmEYCpXOKD0Dy/joZgov1t22jY1pb1zt+CAF0+AZY7qKrJ0Jq0Rmb1aid?=
 =?us-ascii?Q?PRtsTd0QOXlh4D6mGRGt05tcUIVSMBoaeVWjWb2ZJucjXias7UfNC/rDOLFR?=
 =?us-ascii?Q?pDYdvW3v4V6nwIhYpSP2yJbdnw/yEoJz0tG4d5tILx/RLG0/4O+ZyExWx8xg?=
 =?us-ascii?Q?41m+WB97JOG15c1tT9W1nkoQ7KA5mhncQWegISs43tHiRG0QNdR/eoGr40ZL?=
 =?us-ascii?Q?8xTSJGLsybXaEpQC99dZZxWO8N/LMRFRlyUe2BPkGzPaTBMWwtI8w6yiGaG0?=
 =?us-ascii?Q?Ro3K/3Z6G6uP6cILUyy+EE2DNsmDm6XBSyK3nbPZvuQGMQlYz9gftyoK9pcp?=
 =?us-ascii?Q?vZfX01r7/hsVcSecWH81YcyLeO0ZCt1iuKyCYTNe/lMx7UuJQjL5nPiMHn5J?=
 =?us-ascii?Q?9hfXk7PZBONzFY3NHiw+Cv9qaTWP8DMNUVSmMxtn9eEmFQ9Ak+2oaJRPVzb8?=
 =?us-ascii?Q?1yLXv0x0dwz9nKi4lMtl0fiDks6XZ4CUbPNVHLtqVObRX4O4ZHwPSea+0fVa?=
 =?us-ascii?Q?j0gNQla8gk3OzcWZJJdqzK/xppfAv0PhCUgSLlbGkrAzhOH4Fb9/IMJ6WD5E?=
 =?us-ascii?Q?PvvEKH020c+EODGFKzOgpeXmbO93c79jTf1KJ70SSYTqgPcgBXLZ6X6+8IOw?=
 =?us-ascii?Q?V8OO6p0ybdS91w1n7x6Q39FrACXmWWVHMnC8mW4JDAdBpgBd2JM1ePiCHs64?=
 =?us-ascii?Q?NHW30gj7KZuJBrwm/vDeYttJY3SPJJP0t5AAg0xpO4vUZWVgBXD5g/b208tA?=
 =?us-ascii?Q?tgPoKZcfoaSqwKpnglGTGDuV49WJm+m9YU1eGPGdd8rrM+q2rOmatUMXcT6h?=
 =?us-ascii?Q?B30SxZdMVUmPQ8O+mZ5lrNC9SMKYe0gBmnkZ5J8K6PJSRb3TP10XnChwvvNM?=
 =?us-ascii?Q?0C0N2IgC8M+jqYPYS74X512O424d9Wu5vFdArf7wZdKCkdwNL5LTHhzPz9rf?=
 =?us-ascii?Q?h8EtYg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e73757a0-0f41-4e90-60a3-08d9b925b3a8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:03:03.0889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdmR3XEp0yv74Un5yFFNPZrs9ZLxTDIo7xEGzppLmfyVGsGX8TPH3Y/9Ax6Y7WZRC4jozU0/eLthh9Nsrjn431WPzMIZhmu6mzDC8SDDTAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5709
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070012
X-Proofpoint-ORIG-GUID: oEgxnvOh1NsV-rBjZnD9EbdaMPQwg_lQ
X-Proofpoint-GUID: oEgxnvOh1NsV-rBjZnD9EbdaMPQwg_lQ
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2, the
following guest state is illegal:

	"Any MBZ bit of nCR3 is set"

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/svm.h | 3 +++
 arch/x86/kvm/svm/nested.c  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index b00dbc5fac2b..a769e3343b07 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -216,9 +216,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
 
+#define SVM_CR3_LONG_MBZ_MASK   0xfff0000000000000U
+
 #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_NESTED_CR3_MBZ_MASK        SVM_CR3_LONG_MBZ_MASK
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 510b833cbd39..dad479eebae0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -247,7 +247,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(control->asid == 0))
 		return false;
 
-	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
+	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
+	    (!npt_enabled || control->nested_cr3 & SVM_CR3_LONG_MBZ_MASK)))
 		return false;
 
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
-- 
2.27.0

