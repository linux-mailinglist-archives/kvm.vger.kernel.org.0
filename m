Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6637B46F828
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 01:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhLJAwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 19:52:22 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1614 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234960AbhLJAwS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 19:52:18 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0gn94025228;
        Fri, 10 Dec 2021 00:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=h8yzYBx/BwyPSNTIg/ZXA0xkU1CTLOq6yCxv5zKVayU=;
 b=vahjjrnzGsKShp6edPGk+Ksj7LFMTZ/lsP+oN6v97HUvAHr+7OW6HuuQRr2RtuBi/yIP
 tZ+rz2+CG8Y79ns1zUVco08CTaqNCyaIfY1CffpfRHqorvDnv0P1fatdubGKvaO8NrEr
 jA8973PyGQTdDXWMhrWRryPWJjzWV2G0pQr/xJgt8YKtuqpiQuxAEOeKAThZNp5emVd3
 XOd/CbAdJRb94HkslPUn/HA/99lrlaqO1YckjODIWMJrvmZBWGRdDLkXx6QEdnpjWEF8
 7kbdxDqxDNTQs3UpoIMBrq2B28IxBC2ZTH5La8MB+l/I2a5e2o4bMYk0j4OJUQDOzdsV 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctua7mh58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 00:48:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0knhJ186438;
        Fri, 10 Dec 2021 00:48:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3cr1stefw3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 00:48:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFQpJcvccq1RCF3gDQ2d8kJyBRAaLOKo05KTc6tWy71Qq/YcrPCsffqXDdFIJilaHsr+1SuajL0CvO6dRzDvciKk5GRW+HIBaD/Z0CiBgOwR0kXa7hQ7uzPv4y5iUj3qLg+dSTe/6rNZkcYAEf31LWQY8SexnFHeNFOImGhdSkNLZJ2fibk6H8sPy7qNCkOWuEyRfjXpFiCZAT7esqRXlS5x05MK19auVbFzXtLYlrgAlEZxwQM30hdvFSxFDaT3Adt2Ka+c5jTRaekJo+wW+EHr4OXBHdJAOVji1/wc06UKw46OOZWkGHLnqWTh7+TvUIuq6bOxqMsulDuB8TUfTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8yzYBx/BwyPSNTIg/ZXA0xkU1CTLOq6yCxv5zKVayU=;
 b=mvEJyA9czRpu7KeGmLqhYhke7ULHfK3zZiIe4udpU6ZGHg7QTjc2c/zSsbuNg3Z19TSyCMdQ6/ns/VF9VrZ233p4K/LvWcVSGUqdVDN3t0UgR8T7ZTiybfXF3yXl8Qi/8vO12gkdFgWt0qdBwXTHsxTQsTLK/tp0n2sW8ThPmcgyhMfoFJ8M/+KTAa3FZfninOEjyVNp+ZXz4RZzSp1uUvlnheuYZVL1XWuMEOzPm7V2mjipFbQgurjjrTGOt3HymvXTjDrrEGRLknrP4Hs7Lh81ze8eyuQnFp0Fr3Z9zqo+S53mVvYw5IXgcnl9wweBZNYRgbzrd4hY12gRTadxbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8yzYBx/BwyPSNTIg/ZXA0xkU1CTLOq6yCxv5zKVayU=;
 b=WwtLdRzCrA7HMnWGyALhTGEjMVFZGkqJHUwkCjJr3veRKt8hWinIBPUsUzCZcK1j+2HGsoHHoc4e0e6TF/SGDWFGPScLWJZL/zcsIJydnqA/IGkX7BogpP+SioKkK24d1XOhX/sfBxNU1dfhLVnlFCmglDmFIWU73T4ujfnIlhg=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2942.namprd10.prod.outlook.com (2603:10b6:805:d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 00:48:37 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::b94c:321d:7ba9:7909]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::b94c:321d:7ba9:7909%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 00:48:37 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 3/3 v2] nSVM: Use VCPU's implemented physical bit width to genereate MBZ mask for CR3
Date:   Thu,  9 Dec 2021 18:53:34 -0500
Message-Id: <20211209235334.85166-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211209235334.85166-1-krish.sadhukhan@oracle.com>
References: <20211209235334.85166-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0801CA0010.namprd08.prod.outlook.com
 (2603:10b6:803:29::20) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN4PR0801CA0010.namprd08.prod.outlook.com (2603:10b6:803:29::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 10 Dec 2021 00:48:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17b42760-454a-457d-d770-08d9bb76cd59
X-MS-TrafficTypeDiagnostic: SN6PR10MB2942:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB29424C30334D2D3A6EA037E181719@SN6PR10MB2942.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 14hvIDIlpAe9gJfAbJerIvKu64Q7q8+v5BrTRs3+q4bWTu8OfVFgOPbVngXN1AjqpsgPtgg1c4WGHO3stHLde5DqpYRA/K3evfOhzimhllfZZhjVrt0KIoa0bfkswQH6vGqxmBDjdh/LiuCWGwWM/QLr/IsEN1SDCQjMaYM5AdkeFh4T3mLnC8IAsnYi+0qS0Y2KkFcLQSZLtnODm8l4IdoZBezK6AFXPqm+tmOdIyhRYtzrVWAn0Y2UHVMefvpFL9G/DfC6iXTJFqZ8cYWLk2vMnOW2sRlHAKhXZXOnxSl8k0mNc/2dOWG2vUvWGxtihaR0JH/yZZ0uKPWL3Jn45lD91iFNSTwH5c0vn2uBil94+qUv0tl8H4V3EhTAEXnP+25cMcY8n8Hdc60JAALANzwXrOea1VVNtHpIzz0Z9NSSmOfpt0boDHy3pqcMG357566q8S12tCV5B345VwaUp075v60v2b327JS1T5HsoVcXtTeI4/KmdN9QdyHsfTStD0/FBG08Yturmx1XmNB9GN8YpqWD9R1R2nSi5hVw+K1iyi6z82e5fx8Uk8V7b1p3Uz6RNJcL6fVHuhl5PxWM7xAcVFegQfGDEMtRQVbaKM5smv3Kiqy2FeDN9rZhGzuL6hIf2fP4QS8fA1KEFp9ibNclcqaqgXIubH9410efg14AP6VsJ5YoTuWU6JVC6GG1U9d26pFX5RzJxqZBBiT45Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(8936002)(66946007)(2616005)(508600001)(8676002)(1076003)(83380400001)(36756003)(7696005)(44832011)(52116002)(5660300002)(956004)(6916009)(38350700002)(186003)(38100700002)(2906002)(316002)(66476007)(86362001)(6486002)(66556008)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S3+u7MnQ1Y0hnKsN+sbF2MEzAqg2oxMXF1za5HR0E2JORppZ7DdFTN1DLcdo?=
 =?us-ascii?Q?TZLLvv0ycoUL+y2F4mPaTpFMUCjyFVP4FgwxEJmVMj0rrNuG7Iqc6whWZ5qS?=
 =?us-ascii?Q?KYjCr+oAIHOhFtIY6csZW4+QblheCIdEZNw+Zxzwd2xGlfM3Yj2rt6KtE5hg?=
 =?us-ascii?Q?VLo9oZF0U6tg2y9HtLoCl6YuZ7WmSniaAa5jQWZnXl5Uewe2NcIml3A1D9/7?=
 =?us-ascii?Q?bfGqzn3IV1TH3zfI1SuKFb2aMiC4dLTLDzLenILpU2IPSOgykLBx3qKDr4nC?=
 =?us-ascii?Q?vNDfwK7bqml1DTloTpg+uRHa/i1ymu16FwAmIJD5/KIZu+kCuzYhMdA38Kie?=
 =?us-ascii?Q?fKBXkItQX6xvXVvRLrDq5BH795T+6FYzr8CTHqGhwaSeUvNUXi+LfNYusOXj?=
 =?us-ascii?Q?u4d1kYKlzx9/T2CxLpqOq0UTgCt35GyP1UwJ2bimdIlOIcsK891dObjZlWCa?=
 =?us-ascii?Q?EdY0OX2lplRSzMsCWxGcl6NeQYQdsAiHpck/gEH+qSoYvw633P44pUILKezO?=
 =?us-ascii?Q?OraU703k8nFBWy8WXf/HeOqXJeKDwZYAP3rNPdR326zKQZMP8LTT9eC3JKgB?=
 =?us-ascii?Q?xKWydBHeT2Tm2G9S/5qmoi97TOZX4+540wWQ3MyKW7Q00/5Q07Y7P1rky+u9?=
 =?us-ascii?Q?qDmK3HAzFKaWB/yPvDu0r/8avXVeG6gARKEeRhGRx7QgW8af64ocW6xz7EPI?=
 =?us-ascii?Q?CShiVmD6r6IRQkYCrXLz1vLivhBkPZ/Zz//qmCe2++0rELKMJy8GQkj+tLk2?=
 =?us-ascii?Q?Tau/0GJkdnzM+c90ds9DtRP3kXZ5A3tPjP5wfV86ur2oln4Egp/1GLT4j+pA?=
 =?us-ascii?Q?pz3K4VjiLzXU5F5Xu8R7KZMm+sUvdpBRNFsEYmyrVXBygveC197h1eeuN/Dh?=
 =?us-ascii?Q?hS7yLag8W5f591MS3augRgiUAC1UoRJEETfyZNesiMbaRKYnV7G9HcTve1MN?=
 =?us-ascii?Q?L/x3D7jmtfsCyc5zHdO0qVNuKya6ew1xLziZL/An0cK3bUq4zjxf3uOu/w6N?=
 =?us-ascii?Q?680Cx4p71FiPAKy9uttVhdQxhuRxGlAH+ujm2trFTU15msYBGpKD38W5fOUZ?=
 =?us-ascii?Q?MVGGS+dpRYfFSLq8pI4lX1geJwWiQFr7jhyxdexAvKCtfBybzWavsNk6HwzI?=
 =?us-ascii?Q?OwJd+oZ8KoFiF4wNhVJ4lwPl8Pm53isPBdxRt57JRWD7CtGVOM2J2BJ3gYja?=
 =?us-ascii?Q?GxWtW2V2tDY24vIZaNyC2UEJjG1wv1eS2bVDi2t3Mc2VOZUaDTia6G97g2O+?=
 =?us-ascii?Q?D4/d2RvwzekNpPWO/eRdBLwoVGC+FFSlh7pfnK+4kTRFZAO47Lb0+HHJLZNN?=
 =?us-ascii?Q?IUTtovsdyqiYyiBFtsaa7lnsyC4M2y8Uul2EThKkazLoVizVWQE7KX1taHy8?=
 =?us-ascii?Q?7702vwQfolvKrp363nKEjee1zs77nwwUNzwmq4nFVhqu8aPVykMyRGgx+3Ak?=
 =?us-ascii?Q?+pzu/6O3IQkBG1JWq1cheijHVz4hBLJ7G7TTC2RIjdTFxJOVKH8DZ5FTUqCN?=
 =?us-ascii?Q?Edprmg/bCA90y1gebFPoyIwzhx/wsdz43UBe3o1NDM5OQQ5g7XqvoQ3vIVub?=
 =?us-ascii?Q?FqeYjrrAdr3z1JeoDyiu3jGUKBb5hQCcSt1a6mPYQCQjUnFDQLVvHQCROtm7?=
 =?us-ascii?Q?MMNesupJTMMYSrmaIfodVLxvDHManBknKc7DERWyLMfrcYgYB1ijbappRGTE?=
 =?us-ascii?Q?DL4w/w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b42760-454a-457d-d770-08d9bb76cd59
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 00:48:37.6950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mxRzLf69meQbO47YZLqMvPdZuBZqTEE7QFPk7a8VDvyR1/zmXiKJ1yn0yOOZZiZMIobapLY2r8DRAquD7yP/N3Pd4T9oEHSJf1r1PrDuLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2942
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112100002
X-Proofpoint-ORIG-GUID: ZbUKKr7ZPIkZhFsSAYeifAEuqthGEanr
X-Proofpoint-GUID: ZbUKKr7ZPIkZhFsSAYeifAEuqthGEanr
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "System-Control Registers" in APM vol 2,

    "All CR3 bits are writable, except for unimplemented physical
    address bits, which must be cleared to 0."

Therefore, generate the MBZ mask for CR3 base on the the VCPU's implemented
physical bit width, instead of using a fixed MBZ mask.

Signed-off-by: Krish Sadhukhan <krish.sadhkhan@oracle.com>
---
 x86/svm.h       | 1 -
 x86/svm_tests.c | 7 ++++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index f74b13a..cdab44a 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -349,7 +349,6 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
 #define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
-#define	SVM_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define	SVM_CR3_LONG_RESERVED_MASK		0x0000000000000fe7U
 #define SVM_CR3_PAE_LEGACY_RESERVED_MASK	0x0000000000000007U
 #define	SVM_CR4_LEGACY_RESERVED_MASK		0xff08e000U
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 4897a21..8a3f2e9 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2317,11 +2317,12 @@ static void test_cr3(void)
 	 *   [63:52] - long mode
 	 */
 	u64 cr3_saved = vmcb->save.cr3;
+	u64 cr3_mbz_mask = GENMASK_ULL(63, cpuid_maxphyaddr());
 
-	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
-	    SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR, "");
+	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved, cr3_mbz_mask,
+	    SVM_EXIT_ERR, "");
 
-	vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
+	vmcb->save.cr3 = cr3_saved & ~cr3_mbz_mask;
 	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
 	    vmcb->save.cr3);
 
-- 
2.27.0

