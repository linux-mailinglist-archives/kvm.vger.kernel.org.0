Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D244234FC
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 02:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbhJFAbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 20:31:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13210 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230218AbhJFAbN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 20:31:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1960L6bC022634;
        Wed, 6 Oct 2021 00:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=nZT2u2NJ/pqEqYcRxwqttEGoJU6m6BH00MzqEPMRNgA=;
 b=Odw34orzyc/nsWNgt18nAy4hvqhjS7/P0uZ6/zftPi+gp9kAqUT2RRe5d0ueMUn9i8s/
 dH0LzEqKkKq2YGZwoFMNtrEWwED42TgXUjWFYhsQJgXYLOV0OEA5UACUtgndryU24omG
 +ko1YGk4Rnq78zqCj3891EMSnfnSo6e/KGF+khE7p7ouWuGczbT8TBeRd+Ldv6v/Mo5L
 gzrtJJhXbc3D+sgLag6pM1AatoFVrAZ3dQGYK2ZTwevbKymgGkls6oGKkOss85tEdsZe
 1TYZrGcbLzZMUu3JobSqHAlR5lubIk7+wQOfJ95PYAbq0BqWsfKNmA5DmTfi8TmxABnn dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg454m5et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 00:29:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1960AKeQ144842;
        Wed, 6 Oct 2021 00:29:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3bev8xjfjc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 00:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqj3sGNFEJqNuXNGFCRbQzTVR1iXCfnpXrCR/R1/Rd6Ba8GU7kQiBUmoH2kn+EBIXd7kFYe+YHGtcTb4X7TP7z2OXlRMk6yxxFWW+qAJ3EoVWAeGhLRX2ZTmjuxpptaUZDmhe74dfEJpkrLqouXOrQPXN/VPFa9IBlejkAihEhSW62sH4WKVdId7Uou/bo2yoFU8od2jfhvHShl8dp7ZcXF/+36ls7wQCWkpjAodTOJwpztSphLGKBrhytn+91v5Mqy5jlp3l3v+Pp7QTGYZskYqBP84mvpXDO4cE+d0HLJQaGWMsoQT24AoCPTwjAFLspANTldhtIdMvXFH1+eqIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZT2u2NJ/pqEqYcRxwqttEGoJU6m6BH00MzqEPMRNgA=;
 b=SNUMdvlvJf974uvHIrCM3YN0Y1WXNEeTe+yaDD8UFHqmmCkyGxF5YZEqY6jngyn4qI1lSiuHlx37pGDg64JFWHrV/UZj2KzTevk+7FPnpySfglY/9qjPBspkplRbDlp0nLTA7tbbidgEJp1NcGZjFwzKnxxQj/f91ZEBRvQwx2qyR0T0xCG531Og3Zo4C42ntNa845gd8T0wtUXTKnlM+USJD6kUPcTDjBk32YmQYE4KG0HFWw0zPho2pLn/SC1dY/yTK++3aRIJGNAe3yZWDc6c6LDStZBHtg6aa4R5UfDsU7akhDzHYCdvhifRdS2A2MqjTV6M3BAHCWHGSJkqOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZT2u2NJ/pqEqYcRxwqttEGoJU6m6BH00MzqEPMRNgA=;
 b=wYsYCmm+075gEmag0XCTXrfpm+JN/Pfhkq0z81ESlnYERZ+glUqNXOO6JACfZOoJ7HG/sFm6SR1mqL7b+rJnoNXwHL7ei8/kqG+wPx/moLJZ5FFF+w2kAX3SKcDjfXGXmxo56lgCsb/h1muQFqjW75viePt/9xsqUMxyzpIlcOc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA1PR10MB5512.namprd10.prod.outlook.com (2603:10b6:806:1e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 00:29:18 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 00:29:18 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [TEST PATCH 1/1 v2] x86: Add a test case for debugfs directory
Date:   Tue,  5 Oct 2021 19:34:55 -0400
Message-Id: <20211005233455.127354-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211005233455.127354-1-krish.sadhukhan@oracle.com>
References: <20211005233455.127354-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0007.prod.exchangelabs.com (2603:10b6:805:b6::20)
 To SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN6PR01CA0007.prod.exchangelabs.com (2603:10b6:805:b6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Wed, 6 Oct 2021 00:29:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f09865e-9aaf-4628-491d-08d98860558c
X-MS-TrafficTypeDiagnostic: SA1PR10MB5512:
X-Microsoft-Antispam-PRVS: <SA1PR10MB5512495E77D5F152E25BDC0B81B09@SA1PR10MB5512.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:216;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCtG131rfIzxh1prTCB67Vv3cekYL8zqHq1Pp6RsFVkprlhHyOtxQ5aYW2HSYldjf4xL6uY94kNoZDen7iusZh/7N0UhXWH0ZErQfX5s5CdKWR/1X0aT/mzmWgwtc1gqho24R46PRW743C96yFvQDy8bfjPhX2qEA+1Av+FVl1zYbQa/ishw+8m9L5FecxzNHyzlbnJR6uSh9lUQH/bu0LmMbAZx38zIWMc9bMDUZNgR8me/jmElbp3n6/hhXYPgyWQsGbweiRSGSKwxZ3ZGb0q0ZZistsOyiF7m+xtInVP6Fqx4t/3HmqDLbmMwWdWGNdI+4XkbnQV6sF5AWwv3TpewqLbl+kmbyhidZW2vKRikikrpeO5HSOv9Q3slWAoutOqxVy9H1vWBJHidVVPYun+3aunFJCF1j59aHuVwZlnuotCIkg1D2SljTPvF+ybenI/MicBj7Kkx8M1UDIsAsveOp0xJbpNDi10mJO97Dn0nHpiwtBN6EzlCo72R2+KhhhJoeB+ZTE0sQsblfcCjzCVSd9TyiosoAxzA818PUFPRtcs7axPKpLIIBiz6kp/DWLRgatpiPxikY99tZIizl+wDsIvcF8PE8HyGOja3w1LhPzRVmn9VvZr7St1MEuJNTNPTe8BCfU4Kaz0nhwehlkV4+07FS/v4qQh2KAJPS5psZMM8zBkaOvRfA0DO2rjE/WZVO7+uE1arWgN6OSlWWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(1076003)(66946007)(66556008)(66476007)(44832011)(83380400001)(2906002)(5660300002)(86362001)(6666004)(6486002)(2616005)(956004)(38100700002)(26005)(38350700002)(6916009)(36756003)(7696005)(4326008)(8936002)(52116002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HyDvbep91ROoMtHcEN8eSXXHAmta9Fax6Rb1JDrwelJOwdYxaKo2WtGXHJ0E?=
 =?us-ascii?Q?U0aM+bdVd2xrFCOT/K2KBJHW1ZiykkH9VFYQE8jE7n1m8xcneXIp4L4LZiBB?=
 =?us-ascii?Q?vAScIyQjQqN4tnhoJMdV6mCWDFYLVFS//N2HqSivBqUItfhhefkTdEyYvc+I?=
 =?us-ascii?Q?lo5WN9AHvL1fLMWmsSlIeSZYnWNxvqPDRMvdcPb3JhsZZqhDoo4vDlTQLnZ9?=
 =?us-ascii?Q?OSFNRndt6cPQgy/qpVvO5OXDuLhuwVkPLcv7X1HDi1CB+Iju/LIX4DMexUUF?=
 =?us-ascii?Q?v5c2vFT1h4IEaURdUF6zSYWyo8qDsiNP7qCocd1vTle32lfkF10hkWFCbxeJ?=
 =?us-ascii?Q?SO5+7aVejN2x5GQJAs7O14qolFDI7LDulgdsEsmiiYeM1zH8xLMsnMP8370p?=
 =?us-ascii?Q?XAiPwXqfq+ubI4MVqNleUoWVDAI+zCF8/eeL8X/4cjtyH+MO97GsIBFBk0fR?=
 =?us-ascii?Q?Hc2Tpk7DgK/8nFai+iUq7zqXnlJaEF1yThAnmjzjCzQugtVRgZncMz6q+gRe?=
 =?us-ascii?Q?KEjfSzOoOcbOx+E1KeBuw3DqW2daqPzXbuWsQQNy2Wxz5AM7e7Mav/lZH9Yu?=
 =?us-ascii?Q?ekVedEy1Wp4zeodO14v9gI4IIXsFDh/JikB9ADVq/Cfcwd2shLc6AxTb/KhC?=
 =?us-ascii?Q?C9IEbhEtL4FwmBInEUEQTx3g09GA73dOyaDMUJssubbpMDSSoinFyf+wIAVG?=
 =?us-ascii?Q?ULJauLcuMJppGD0cTCMg9sH96HorbN9ex1aEqSt83PTrRkSuy2awEg1kfnDb?=
 =?us-ascii?Q?HCmhEzak8ac8hbCf1iPcqsOxRYyyqzAebgON1Xij3Izbd929E6qOT/iHD0F6?=
 =?us-ascii?Q?h8eaufwJ2nS6bs3rL3bVct5UpmMKlFpkPer9GITEYRwGuw2t4JYlckeQmL8l?=
 =?us-ascii?Q?anPwzNWFvPwkjzbtcCAkQlju7ygPpcK/5VbZLmDSMGqRrXacPi08jbvo7ZH3?=
 =?us-ascii?Q?ylVR3zE3Ca0587VyxSoSYiUnR390wCEABqyEWQttdmvgZdeKZDjWSrSqUKx8?=
 =?us-ascii?Q?B25ixI2qz58o8RPF1AgUqrPjeKWf9q4xLF5RMDemURWvxMFUnBe70GqffxDq?=
 =?us-ascii?Q?yyZJNV9cb7CPJa4I1al1RTz1eMA/+ASsD3nbDNmwNpMWKV3h6r7JZp1MFIRy?=
 =?us-ascii?Q?JYvYtYCbIxaGvCBa1wEcgCz27/Sg684lF3uuS8fsSf940b23TCn8OxHBoTq2?=
 =?us-ascii?Q?ChqrovcKHNc0aniNKb+RjHzynnFGCgNNHU4uKGTfPhK0GvUdXIjgf6DY0v3W?=
 =?us-ascii?Q?lPUw9d2YrczIpxWnURqsBPFHRhNjbMlpMH5/JOpUiLxXr4hivBexbfcq6vIQ?=
 =?us-ascii?Q?f3/d9dZ59GRVyQbVhR2vyf66?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f09865e-9aaf-4628-491d-08d98860558c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 00:29:18.4370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nxi5iGM/QhH2hi2vSL52BdZLH7I/zrLnDlM2RiDYlc9Ph2WxbtOVQWaw3dLT98r6VZcjbr0vedaPhCfiJguo+oCRCyBus8yqr+aaVnPe4Y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5512
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060000
X-Proofpoint-GUID: R9aY3MwiqXH4MhmwPMEtaMvqjcrGgWbh
X-Proofpoint-ORIG-GUID: R9aY3MwiqXH4MhmwPMEtaMvqjcrGgWbh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Along with testing the binary interface for KVM statistics, it's good to
do a small sanity check of the KVM debugfs interface. So, add a test case
to the existing kvm_binary_stats_test.c to check that KVM debugfs contains
the correct directory entries for the test VMs and test VCPUs. Also,
rename the file to kvm_stats_test.c.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
---
 tools/testing/selftests/kvm/.gitignore        |  2 +-
 tools/testing/selftests/kvm/Makefile          |  6 ++--
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 ...m_binary_stats_test.c => kvm_stats_test.c} | 32 +++++++++++++++++++
 4 files changed, 38 insertions(+), 4 deletions(-)
 rename tools/testing/selftests/kvm/{kvm_binary_stats_test.c => kvm_stats_test.c} (88%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 36896d251977..4953ac735e19 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -50,4 +50,4 @@
 /memslot_perf_test
 /set_memory_region_test
 /steal_time
-/kvm_binary_stats_test
+/kvm_stats_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c103873531e0..d44fa28bc56d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -83,7 +83,7 @@ TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
-TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
+TEST_GEN_PROGS_x86_64 += kvm_stats_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
@@ -95,7 +95,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
+TEST_GEN_PROGS_aarch64 += kvm_stats_test
 
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
@@ -105,7 +105,7 @@ TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
 TEST_GEN_PROGS_s390x += kvm_page_table_test
 TEST_GEN_PROGS_s390x += set_memory_region_test
-TEST_GEN_PROGS_s390x += kvm_binary_stats_test
+TEST_GEN_PROGS_s390x += kvm_stats_test
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d79be15dd3d2..812be7b67c2d 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -59,6 +59,8 @@ void test_assert(bool exp, const char *exp_str,
 #define TEST_FAIL(fmt, ...) \
 	TEST_ASSERT(false, fmt, ##__VA_ARGS__)
 
+#define	KVM_DEBUGFS_PATH	"/sys/kernel/debug/kvm"
+
 size_t parse_size(const char *size);
 
 int64_t timespec_to_ns(struct timespec ts);
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_stats_test.c
similarity index 88%
rename from tools/testing/selftests/kvm/kvm_binary_stats_test.c
rename to tools/testing/selftests/kvm/kvm_stats_test.c
index 5906bbc08483..ce0a8387eb42 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_stats_test.c
@@ -13,6 +13,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
+#include <sys/stat.h>
 
 #include "test_util.h"
 
@@ -230,8 +231,39 @@ int main(int argc, char *argv[])
 			vcpu_stats_test(vms[i], j);
 	}
 
+	/*
+	 * Check debugfs directory for every VM and VCPU
+	 */
+	struct stat buf;
+	int len;
+	char *vm_dir_path = NULL;
+	char *vcpu_dir_path = NULL;
+
+#define	INT_MAX_LEN	10
+
+	len = strlen(KVM_DEBUGFS_PATH) + 2 * INT_MAX_LEN + 2;
+	vm_dir_path = malloc(len);
+	TEST_ASSERT(vm_dir_path, "Allocate memory for VM directory path");
+	vcpu_dir_path = malloc(len + INT_MAX_LEN + 5);
+	TEST_ASSERT(vm_dir_path, "Allocate memory for VCPU directory path");
+	for (i = 0; i < max_vm; ++i) {
+		sprintf(vm_dir_path, "%s/%d-%d", KVM_DEBUGFS_PATH, getpid(),
+			vm_get_fd(vms[i]));
+		stat(vm_dir_path, &buf);
+		TEST_ASSERT(S_ISDIR(buf.st_mode), "VM directory %s does not "
+			    "exist", vm_dir_path);
+		for (j = 0; j < max_vcpu; ++j) {
+			sprintf(vcpu_dir_path, "%s/vcpu%d", vm_dir_path, j);
+			stat(vcpu_dir_path, &buf);
+			TEST_ASSERT(S_ISDIR(buf.st_mode), "CPU directory %s "
+				    "does not exist", vcpu_dir_path);
+		}
+	}
+
 	for (i = 0; i < max_vm; ++i)
 		kvm_vm_free(vms[i]);
 	free(vms);
+	free(vm_dir_path);
+	free(vcpu_dir_path);
 	return 0;
 }
-- 
2.27.0

