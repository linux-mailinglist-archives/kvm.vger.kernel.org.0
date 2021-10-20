Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E714350E9
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhJTRIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:08:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27426 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhJTRIB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:08:01 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KG9imZ020887;
        Wed, 20 Oct 2021 17:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=7MVfDOJf48lh/nVB9sTzNmLSijpls7fymQkKVQLIXLA=;
 b=PxBoBCJl7FT7rk5ek76NROPUJ7Gp4ZsgfuPsBtcS28Th7feYgNwTDDzIAKUtmZ0ifOxx
 KoJeq1r7bk5o7MjSmd8ShbWOdg5U2X0GZ+gkF+myRBffa2za9hJ4/NdaKOMps44iH5b/
 UYEO8gE/oMupwj+MyFY7vtBrm0EFGjLoi60Ux6zff1EYJfLlWxR4O9LX563UQ/bThA1m
 aXBypsY/H97skJJIINeNZ2E64NqjVOdcpZFn5Zu0UKHODNu8r4m9DeJZP4Pxz9SXMQ7k
 Rk6OCa5dyTTgkOZH4cdmg9HNkdIjOvNZQIY3sMWJ3WyV2kuhOh+M8zWi8oiNPyS3ELk9 hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9sfmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KH5ZCS005957;
        Wed, 20 Oct 2021 17:05:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3bqkv0cqwj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+QbHP28I+1ATAosDj+ArqtXm4+exmsJOe5MpIzqTfJlqQMhefYM+nE9jCTU/LLxqkA2nkPudBmNpYTib7fSFdCS/iTQUR1q3gAZ3H+1e5ow+lBleOIv2srK5DxqDBZxoouzr6vGxuijPjUgH/1VIEcbnwg1eqiVnbIbt9NeFBqZ6VD93dpshgaHlfTBe8U9f23okOP7pep+nZZacyR6k/BTVvl5CjD1YcM/77ULNobH1LLuepALXC/FJKLDFYttDVEyyr0FxRqXAwK6QQ/hKmsA4rnfdLYPPx1IF45zs32wJkN+jSQ3raogRaBAksXIEXaOkfxJmhMB1VFB7PVk1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7MVfDOJf48lh/nVB9sTzNmLSijpls7fymQkKVQLIXLA=;
 b=VWgr17qZxUREyGW35ojD70q2i1MDQWvjQLOTPap3Mu4JReFxtIXFJz/KALWSRSz2XLCMLDLlDzJeWmdZQo118BTXEZiefjDg02/hG4hwWSUZ3yiNDRcJIkZWPTEDkJVIKAHINdFBlgIhkqPVkxLkl8bSPf+g/yv2zf61IcNH28lmvFpOSYq8jVPPFnFRJaxeElzqQE3HbZlBLgLJ6u6IQtAQbXeiGc5zJgE81IH094OCPzgaDtGt1l87kh78KtMExTUtlz5wbnpSqrD1VrCSB7P/xeE8XegNpzNP3drGEFhZvR9ss51tLyUjbRCkq2vPhRVVnq3+w+3LDTDl7ngnXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MVfDOJf48lh/nVB9sTzNmLSijpls7fymQkKVQLIXLA=;
 b=gCFJFSxVZ4rCdZOxOHLyLkKiC41mi4MiU8vjctPWviH3qySGCc7n8XhpsmV/cIKnjZiaRseU56votcXQyGUWrHGCNu7xuNK8mkOuRcW2b5RGYhSEpVBRu7085r7Ds7rJOKRBNM2BfwQIfUv5H27l/P+RE6AU6loAy8uxPzulffs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:29 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:29 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 06/14] sparse: add address_space __incoherent
Date:   Wed, 20 Oct 2021 10:02:57 -0700
Message-Id: <20211020170305.376118-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:303:b7::35) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MW4PR03CA0120.namprd03.prod.outlook.com (2603:10b6:303:b7::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:05:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7442540b-69e7-425b-bc8b-08d993ebd185
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB45774DCD59E131C074C1FE88CEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QDWZWWypyLpjUHTuC6zfe2Dg/aw5T4hC/6/uCwmSXlSRu0kUMO5AfS4QmlFW?=
 =?us-ascii?Q?Ou672Ejigcr+v2EaGnqpIOHPGMhd0Nug5yrFcTVx3BF+EkZ8e/Hi0X0IALE3?=
 =?us-ascii?Q?4cLdW15/b8X+jFi6gexR9eO9miAcdLHKLAAr1oBZ1KQ6KR12h+g9zl7SNBF4?=
 =?us-ascii?Q?2QLlXqOZLAiFWTYVrVUI7B7oG4bJdsgfs853nJ+6C/NXk4UCt0ujUBzT/9jW?=
 =?us-ascii?Q?M6ZYxcqV6yr/lG18lzAn+Not5MVYbtbdXEP24c9XoMM2nZ/5HH+s4A45ugVT?=
 =?us-ascii?Q?4ak9g1syTNXEvVJaB3HPUW9zQhJOLAHU54z9KBY1WCdDxNG9S96xBMJrMY8G?=
 =?us-ascii?Q?wFSgjFQKn4ndVCTHKVLDitYECEg8bd0eZ82RaevCHkt5iDfyPdioO6lGetSM?=
 =?us-ascii?Q?7Wl6L37nnqhTkvcZygcH4L6CNIV/bC0t1D7jfbjhkXtY/jJbZFyRREAye5DU?=
 =?us-ascii?Q?7DX3BbwRPB+cib77JX3rdg5z0yBXweyDBXPO8snsqh5Ut2eevv2nu07rXcb3?=
 =?us-ascii?Q?hPhNrONu2ZrafTNEZI3bOrDZwT/JAT05D97ECQZd6ChuvHAwlidJ2VAfic13?=
 =?us-ascii?Q?bxJKhRYCXMn9TSAIw24JrCLSNUj/xDyPShgB0jB6OdY7cFTNSar4zS22nSOx?=
 =?us-ascii?Q?sBjo0bHbZCl8T2KNh3gfAuNx2cWyQt1U2WiupsD5nCbo7mesMStGsWfXdUjh?=
 =?us-ascii?Q?FaLxFBkl2qhcUqAQRzOo/PXWbiQuRf6eiYvBDo/TD+c/OqOm5BsKCgA+Nlal?=
 =?us-ascii?Q?8c97q2A3impPd4FGuVKlt4CUQOAAhSkVZw8raC4Z0Jtc9mkpPQ1ppa7XHlC/?=
 =?us-ascii?Q?LhZXUY3038+hilNN9UeUrJw+Fb6031HAF/HwEhi5nNl7cCyWJC4Z2QcuicrP?=
 =?us-ascii?Q?iMc7pYu7mwkym2kUGVIJBQZVqSJoGfVlaDb8h8j7mWKLFtldAlVrf0KFAvlW?=
 =?us-ascii?Q?dYwBadoEaA7LyFqQ+9JOrk1CL6Ob2z4Qv7vd6UEX2NwoaBobLNzU0qp8ft8f?=
 =?us-ascii?Q?kWGEhVQLenSORVbBH1qkmI5mEFD6++yTvdHKkqudNmeL3aU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(83380400001)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/5iAyIFWbbqDAhfS4fbMuThVx1T9Uh8yZIp57sCO8D+m90Ej6o41m2IFFaUk?=
 =?us-ascii?Q?Vxo39wRjUuOkPcXutdZ8CVDR0pgqqCVCrHqMNCNxCpukW1I90k9xlJ0u5/Ze?=
 =?us-ascii?Q?jZTUbzuRKCAOboh9gWK0uwmqbazmVcuFKxeOmiZLOX/MvxtgCX+ys/JktrX+?=
 =?us-ascii?Q?aiSdjlmm0QiLtxayOEr0U75F7UMiyav+Sp/ZlaWmz9cdQZU9NrqL0+8jDtaD?=
 =?us-ascii?Q?vZkWNCrKbHk7g/isH0cfOO7piOlqIJLKxgamLef5AxjeXFWnpbdXJtbkxn/T?=
 =?us-ascii?Q?AtbaIwM3jGa/ATtwlvEqIGBDBCz0HfvgoLNXIas1373rEHR0l43umVnudlBV?=
 =?us-ascii?Q?nDa2CNRE5rJzmZVDKKtE3XjmP0Rn3FoEBTw7V+QabWLGW+momYlY83SgxwI3?=
 =?us-ascii?Q?wdyf9ff4cZMGDWZQEaDmRNbYybsCCLNMWeg3Lx37y6cBHRH2Kp+ZumxxB/lY?=
 =?us-ascii?Q?H0cO8bCEE+pw+WGRueq4DXcst/Hl/Xg22iemMIDUWZUFVcROo4nJbZlIdkQR?=
 =?us-ascii?Q?vPhbKVco0kC1Nm2Wqx3lqQ+Rjsl6CtohO54NOjhkwBJcvgr4bPke5lgcQRmR?=
 =?us-ascii?Q?4YUIB3MXNtdeixzIcq/ghAWIr4pNCFa4pYH8r0Nc/psZNXhAO3GlFrkgpYcj?=
 =?us-ascii?Q?WoshpbHja1OYEuphXvq64nKB0po3z0AkV1yKjn+o+8LlPvnLLF98EiQ14850?=
 =?us-ascii?Q?wmGCU3ctXSKFvs24oaKqysb0hyOsFgCXBjvVX9GN7kfWTL8pcJRsZiqNE4xq?=
 =?us-ascii?Q?8vsoN03N0FQtRBXkuZX9dpZqciycDu2/lkji/w1OXhGhg70+8LsdDyK0mc1T?=
 =?us-ascii?Q?TlX54Aa+uURWjDToALY7Y0M6f+gfDQwGEsTYUSIcZz00SGxon+Zk6xkXc9hz?=
 =?us-ascii?Q?f9kH7hB1mTIv2YPr/YdpXemmwlq0CRWYYhv5MTpf6ELdY1iPrpqI8Zqb9VNB?=
 =?us-ascii?Q?7myL9jFxc9eWDx7ANphb8jLj6DEWILky93DbW44hQAlKAH1tMoh54QgdLCvL?=
 =?us-ascii?Q?kLc0WMg25T6w6N+rfHAmujkh/tT/7sE5TX/RP02rZA2YKoHHi2/iVLe5C2ys?=
 =?us-ascii?Q?+xJW6eQ6jLnJQrxTHjWeWNmjlvxg4gcZtcjDzVMHGjxLHgDoL8l70T95J6Gi?=
 =?us-ascii?Q?tWTo2+Gr6bvxl/GV1+M24JnSjHpLg6RmOS2e2w5O39+mQBv5dkTapjKKyczO?=
 =?us-ascii?Q?6bDirPmrbJlLMU7tz4lH4iwiHLgp9t/pNrgstrqRqtcISNS9Jb5qL1qD7eHT?=
 =?us-ascii?Q?h0vigIu2CD12QlFkBPqbUKJINuDJ/Awr3P9x0slX1rPpG+6JiJ6/BkYNYi02?=
 =?us-ascii?Q?P7kSfY6VW7PkRUiJFnNvxV0Hzy/JdbewAkodqFp39KdG3I5XZ3zUpmUuYxgu?=
 =?us-ascii?Q?KuNxv519pVC9BJTq1csT1kVfBg5meafrUmEK5t2/IoAYTR2JwTTzP1Waz00G?=
 =?us-ascii?Q?j3h15FSPQcbj5M0B8x1C5vpA+QCiqBAI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7442540b-69e7-425b-bc8b-08d993ebd185
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:29.3497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=844 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200096
X-Proofpoint-ORIG-GUID: 2woYBbyNvY7uPvLC3DrovoBbnzJyio02
X-Proofpoint-GUID: 2woYBbyNvY7uPvLC3DrovoBbnzJyio02
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some CPU architectures provide store instructions that are weakly
ordered with respect to other instructions that operate on the memory
hierarchy.
Add sparse address_space __incoherent to denote pointers used to
operate over these regions.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/compiler_types.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index b6ff83a714ca..f7f68d7bc494 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -11,6 +11,7 @@
 # define __iomem	__attribute__((noderef, address_space(__iomem)))
 # define __percpu	__attribute__((noderef, address_space(__percpu)))
 # define __rcu		__attribute__((noderef, address_space(__rcu)))
+# define __incoherent __attribute__((noderef, address_space(__incoherent)))
 static inline void __chk_user_ptr(const volatile void __user *ptr) { }
 static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 /* context/locking */
@@ -37,6 +38,7 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 # define __iomem
 # define __percpu
 # define __rcu
+# define __incoherent
 # define __chk_user_ptr(x)	(void)0
 # define __chk_io_ptr(x)	(void)0
 /* context/locking */
-- 
2.29.2

