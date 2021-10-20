Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6A24350EC
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhJTRIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:08:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59552 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230454AbhJTRID (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:08:03 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KGAxUD000812;
        Wed, 20 Oct 2021 17:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iS/PD7yaCgxwaupfk8G1bmsZ4Kpoq3CKh+7q4k94Cxk=;
 b=CZQOCIsBA9TIkwQpBWllsIL0dvifV8S2SDcN77JuwLY3ACZJ8nn3Hz328lQkS3yQnC1K
 QRokzA9iZOPedzUP/7I0ustSsxXLSsdrMuxIpwF+4YFu0z/J/TqiaqfWH3pOomMcjROL
 XMYwfN6ag1Lk1oS32fFYqonbLZ2D4El1x8Pbhx3zElXEfzdwjZ/rxOwxGpGBmGW+/zHR
 dN2CgqPw7cx1BJc/vzo/oBYHcKgC3eiR5PTENAjx3xpKyw2fhZm64YeaLNOXEm8qNSqq
 AvQdJxUoI4Jcwqc4egKoby93ipaEnpteoiSjgp5uMHcXBYUxNwk4g+QlnB8hqoAxwOr5 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4scdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KH5ZCW005957;
        Wed, 20 Oct 2021 17:05:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3bqkv0cqwj-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:05:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4QDRlvOASwf7MQEbPRIQUX/iWHcndZqTGgrX2jyQHutIdClm4ZLLQXR1HNHRjxBsmb6YcXlYsxq2z18vENj/nnK9S5fb7a6iy/6dQ9VTaoehWf8ezIx84h/qRjLDeE0RLaFSDEiF4Zaw9LMbMp7Y08qTdXjR/6G7NB+1pssE+Ex2oNLnQ7bBQF+3tCC5ehFf7TOzLGgUrqqhmwnHGdImIcb11QdKhQJMC8KQkQaHhLecA9eFVvsRk4ADMVCdLoCGTCQBY/ifzzB9eArdfcj0nrritoNfk6E9c9pEbm66C7aR+DwdzurkS+iwNAvpRSIpcfNeGD/5P1XV4DIgerT0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iS/PD7yaCgxwaupfk8G1bmsZ4Kpoq3CKh+7q4k94Cxk=;
 b=h5fMvpZxWnUurSY+BAcAGY/uE2uXvEwd7ioy/yM0nn0ItNz5nKlu1mubMWVDvWNWReJkUP0XEiqHN7228Swkl2RCeZQIRZ40vguyHBW3qRwbgRsmJLCrNo1bFV1NCpMg9Whj+UAa8tx0ziFrt+sLjGzv0BXROkqAn3rEmatOeyRqDgWuhMLwwxndHnjtZyRVZcHmWmMrvFCZhRNdg2NwiDPwSTG4nfIj7DdsRhifHcLN/6l2g1ed6chscgzV/jb91htKNsbBG3HfYSf0F7hf6zbL8TUH+FR9dseclhYaSnMOXv5HjyUJU9QhTaCbRYOgfqehpJk85VmvYc2P8Fu0Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iS/PD7yaCgxwaupfk8G1bmsZ4Kpoq3CKh+7q4k94Cxk=;
 b=t9C52Mdw3sWVOwNlt0ikWkX4q6kUriPa8eQRu9gDenT33jKaQyy5IA1hay86WoHM/AfAIaNdwwfz2u9DsH/vn74dVlK+rnHl+V/gjzJ09TiELgxqvw9QD7EabFrzDWOV/jrpovup7hh8TH3/RfqGrAUJDEgWJzzLXPQ/WDEDBAw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:05:37 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:05:37 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 09/14] x86/clear_page: add arch_clear_page_uncached_threshold()
Date:   Wed, 20 Oct 2021 10:03:00 -0700
Message-Id: <20211020170305.376118-10-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211020170305.376118-1-ankur.a.arora@oracle.com>
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0131.namprd04.prod.outlook.com
 (2603:10b6:303:84::16) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by MW4PR04CA0131.namprd04.prod.outlook.com (2603:10b6:303:84::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:05:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c8a5c28-435c-4f0d-30ec-08d993ebd65c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4577:
X-Microsoft-Antispam-PRVS: <CO1PR10MB457762394BF3F40CCABB2EA4CEBE9@CO1PR10MB4577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SJGhwPiR5I5nIV6KiZArsY5xY4PeJMST5+8a/eLcETm3EHxsGdOxR0evoK3a?=
 =?us-ascii?Q?WyCff6IMWAGZKZN6E2nPi8oH5Bv20K5ZamBqOJpgF4n+zII6/nSFUxXt5sxD?=
 =?us-ascii?Q?PZibGyoBZFldO9H9qp3l/nDlcDB7OueWzcJzio9wKOarKYJV0O7xaMAkH9iG?=
 =?us-ascii?Q?ET/7yWtfW3FBmUrAswDXAmvRnsQC2dhsUlxQWo4wpVPz+nROjeX5zxe3CyC2?=
 =?us-ascii?Q?rCSwECNVmHe8lVJQRriOhs+eONGjo+wJl5n0J1zfmXmvgQ4+pjFZ/MHo6gxj?=
 =?us-ascii?Q?yput/pF0RIr81HmypNQq103KruJomyVUVfjdv4FxvQrRa27UiBeYVubz9EKS?=
 =?us-ascii?Q?7qm07ZR+n9TD5VWzWgvedX9DXMnAgu8HyrZvKlUFC0pmWyWmD3BXqw1JsTVP?=
 =?us-ascii?Q?drmPuCe7rNVsBehEpjTGHqqHg4rvOSepLdcT491XHJ3Z3COeEAs89Bk/KaKY?=
 =?us-ascii?Q?gtcnu2tr5B/EH4a29jUDvMppYBWswXbZSmttaqYZkyCWYDJC/+c7p3ZmAdT1?=
 =?us-ascii?Q?AtPNJ8RgI8Gftsid62bQU9JUInIHOSGZgKsCVfZ6RFQvuOZDwVJJuuB2vBTg?=
 =?us-ascii?Q?k2U5QxOLVfrmitP4Ixp1l6eByu26hAxkVvP5/oSYczNQ9ODo6ObklQ/0HYuI?=
 =?us-ascii?Q?Qyt0YrhVdxS/fGmVBiNUio1V8iB8MI0lHZ77IJyR90bv5QUqZKdFMcdIZNil?=
 =?us-ascii?Q?mFmFKIwFYniQue/EmJcbI3uC9qoOEz3HZn/V2AtBXKVQuQamdsd15u/nT9Wy?=
 =?us-ascii?Q?nIgaKa8ocqHRYvWvNlikCBI9LSbxvFKb1EjqbyL3fZNbqm/cWNj+Bpp1dM8Q?=
 =?us-ascii?Q?X3DZys4A+FQSvIyqiz1EH/2RwDjW7qNkHDhaZjYcYhmt4LvbJkSdKtfC5Vp1?=
 =?us-ascii?Q?KQLbYuySHIUaOflvVEbhxGgTqv7OiDMxmaJzOg+y/f5VvUakYUvjHxv2kpav?=
 =?us-ascii?Q?pondwn7hq+zlxiW0WTDnB5vqSRKmAhQ/Iy9yRyWR2oBxsHJIEjhDF5VoNd8i?=
 =?us-ascii?Q?JxHouNE30nmzt93bRzdGi8Chtw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(66946007)(66476007)(956004)(66556008)(8936002)(36756003)(6486002)(5660300002)(2616005)(4326008)(2906002)(107886003)(186003)(1076003)(26005)(6666004)(38350700002)(8676002)(38100700002)(508600001)(6496006)(316002)(52116002)(86362001)(103116003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s2abTlKSHl2p21yEZIMfcwh8VaqQqsDzvD8/XrWinEa1U+dG41W3l1+K3QDH?=
 =?us-ascii?Q?rzQ7tjp+B/I+ITa3HSmRrlbnOiNzBUbOYdwGtQBAfQqfWtPJ7QW1nvCgwRAz?=
 =?us-ascii?Q?53Y0Wst8NzKnMTkN+xzxMZAZFPNTPGnQn76qg6Qg+yfaJPZrR0oQdtQWD1Ly?=
 =?us-ascii?Q?jXmgLIeZf/K0xil9sE8/IA2jpBAVkxtiUtLBgxUwd4nOfeBOVHq9hHKnoUDY?=
 =?us-ascii?Q?lZNmSNyBHkEzBD3Q3a1MTg7VC19GajveIRFAi68DdVfo1tmpMbO8fzOl9WQa?=
 =?us-ascii?Q?Si+fknRD9BjSvt9IF08x2mFm7COOshsRlFZ4WAgErNGJRDXXPJiAwjBYl6Be?=
 =?us-ascii?Q?JyC1CD1CX1N19nsLMzL6JBf5DQgcOYlVbsyeaBL1pIb5wsQR275DKZwE1M7a?=
 =?us-ascii?Q?e+4Y9SMFGqWK+a7vDszlNhQI4zvO6y+WVcEC9MQzezaiwo7wSnIut97Sgx3q?=
 =?us-ascii?Q?DZPQcxAH+Dw8LszP0HCMoz0+3w+S8KPGhFe/d8dxYQ1J7jfVRTKUU2BE+Dgs?=
 =?us-ascii?Q?LSIWRUfED96EBel3WDDgLYa5VbSCp5TrkDB96GovmjfWloCCBIV4hFiP+es2?=
 =?us-ascii?Q?fLIgJ9ANEjNmqc7HDohQKDCKLk6Yl9eet+Yu2RNSGuLv9bK3oNrLSQDpCgDy?=
 =?us-ascii?Q?BeMxVaFttkJlVGSdmkopCg0WLexIdhzwAkEoxUi6CU+0ZCrGd/F609+GfYfE?=
 =?us-ascii?Q?NiNM65ITj7cXCdrOyf6Ghai9tkaEfaCvYWHWC9CpY+6iliEc6WYQPNLTaJJN?=
 =?us-ascii?Q?2b+alfaGhHakNrnTz7VHaNN/+dyOQXLMm3n0jUWoy32/TP8G/Aa6FV4cex4C?=
 =?us-ascii?Q?LKPC27aewz9fWWsx3qj5SsowOsFlsVzEUwkY2szie/tsz3Ma46iSNy2FGmmA?=
 =?us-ascii?Q?UdMCH1TMSB0MpbxktQ7w1LHe+0C0vLvqf59uZSJhxZVEcTm4VdFXhpdj/9HG?=
 =?us-ascii?Q?SGl+4BdjtzfKR0Eo19UCzuDx4GtFT258X87su6YdDPxojffR/hrq3n3kJ/nt?=
 =?us-ascii?Q?TyRm077GBqLPig51g1F+suFAVMgSpy1LlOIPwH4dk8JRmfetG+uIE3ieI6hX?=
 =?us-ascii?Q?1NRDq74NB4HY55bNIR9Vz/r13hlbMr8J11Hq3Z8wMHnsNpUTl51U7/AgVNDd?=
 =?us-ascii?Q?a5erBj23ZyDmkyfeNjr+vosgBOP7KqvMKZD+8Lc4c2kio77dNZCHPj68uxUu?=
 =?us-ascii?Q?vOaSySrFcPVUPz85UlelhbzhU9UyVArWE38jgGCkyRdRkHzapHKXdcKMzSau?=
 =?us-ascii?Q?huU3a4z7h9etLmoIiLMcntifx7Tz2B3adp/t9UGK/6Yf5WDlmkSNBSRqUMW9?=
 =?us-ascii?Q?cASg7TqiFZqGOji2s9i0SBWSr8ZkX5roF6AKfy79AHW6eLlpOO2bvNvlTjaP?=
 =?us-ascii?Q?csPVDUSRUSjHVq+/2h6V0pFWFP+R1s6idqVE9I6ZDZYhFnbTApM8OYmDz0hr?=
 =?us-ascii?Q?LD3YkuHtphx3qQKZSnncwD68XSNzDfkF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8a5c28-435c-4f0d-30ec-08d993ebd65c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:05:37.4740
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
X-Proofpoint-GUID: VYTbUcV5AxlHsVCwRmxL4nccxi4c5GFD
X-Proofpoint-ORIG-GUID: VYTbUcV5AxlHsVCwRmxL4nccxi4c5GFD
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add arch_clear_page_uncached_threshold() for a machine specific value
above which clear_page_uncached() would be used.

The ideal threshold value depends on the CPU model and where the
performance curves for cached and uncached stores intersect.
A safe value is LLC-size, so we use that of the boot_cpu.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/cacheinfo.h |  1 +
 arch/x86/kernel/cpu/cacheinfo.c  | 13 +++++++++++++
 arch/x86/kernel/setup.c          |  6 ++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/cacheinfo.h b/arch/x86/include/asm/cacheinfo.h
index 86b2e0dcc4bf..5c6045699e94 100644
--- a/arch/x86/include/asm/cacheinfo.h
+++ b/arch/x86/include/asm/cacheinfo.h
@@ -4,5 +4,6 @@
 
 void cacheinfo_amd_init_llc_id(struct cpuinfo_x86 *c, int cpu);
 void cacheinfo_hygon_init_llc_id(struct cpuinfo_x86 *c, int cpu);
+int cacheinfo_lookup_max_size(int cpu);
 
 #endif /* _ASM_X86_CACHEINFO_H */
diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index b5e36bd0425b..6c34fc22d9ae 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -1033,3 +1033,16 @@ int populate_cache_leaves(unsigned int cpu)
 
 	return 0;
 }
+
+int cacheinfo_lookup_max_size(int cpu)
+{
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
+	struct cacheinfo *max_leaf;
+
+	/*
+	 * Assume that cache sizes always increase with level.
+	 */
+	max_leaf = this_leaf + this_cpu_ci->num_leaves - 1;
+	return max_leaf->size;
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 40ed44ead063..1b3e2c40f832 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -49,6 +49,7 @@
 #include <asm/thermal.h>
 #include <asm/unwind.h>
 #include <asm/vsyscall.h>
+#include <asm/cacheinfo.h>
 #include <linux/vmalloc.h>
 
 /*
@@ -1250,3 +1251,8 @@ static int __init register_kernel_offset_dumper(void)
 	return 0;
 }
 __initcall(register_kernel_offset_dumper);
+
+unsigned long __init arch_clear_page_uncached_threshold(void)
+{
+	return cacheinfo_lookup_max_size(0);
+}
-- 
2.29.2

