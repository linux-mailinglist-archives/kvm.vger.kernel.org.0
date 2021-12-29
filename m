Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B524F481047
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 07:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbhL2GXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 01:23:16 -0500
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:39393
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238916AbhL2GXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 01:23:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUT4Aboid9iNq3yGxaEduuCYjCax2mt/ANrG/K1UhLy5jVqc4PfgWPGt6eAr1JKdI3bpEtDx2u9RqsRTTdGBy42n1xjQtdK29HNdBs6UWY1CnItzekcvGqT+WPGX87/7mp2LekJ5e+QqU0S2V5jn3PVC+SNdvMD6cRlxfHKIB5oIPl5e/XTziU7IrvxoF+/eyZODS9Wdtu17KLwq2Hqzfb8eyF8Jg80Ww0dX9vGNwEH6CpvPZ7iGwCC4YO9WQpiLeofpfXR81c1JceE4i9IU14PZhXXSLap5q+n6QAFrRw2vsRmVKnLGXWD1d6mP44KMIdcz/xBuua210DZu0l2LOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmbRg1/gawEgFeJ5aLFeD0hpPmf0OwBIMxMx0n9gJ+g=;
 b=dd4qxPHivPk2n9jVy/87Bj2cMtX7QB8kQqsJ8o8Ugrh1XVe9/z8qrUyOZqxwXIUadB0nnuMPMDnMjv9DAaMUk/iMFRZpgyOS4LVvsEx0C8/7wGrjGE0siCfiNpgI2H7Q7n7OXFFJcNsHh1pRQCkWDOaisFUzjEDLqlncdUvkT1LJbwpFDkMColzJ2Jj+QXrWgmWkKUq8mGL3KULG9TkrmWZR2vxEBEI4oWUYB9m+AVL8oN7ErD9QwxPNXKbcgt/lDalDvohcyiwL2v2gvh5dgGh4tit6hp9AtpBebE+IudUykc8fgo48f5RWnHLd997rCwjCrOGYqhm8e0HFT31rVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmbRg1/gawEgFeJ5aLFeD0hpPmf0OwBIMxMx0n9gJ+g=;
 b=AMMuE2K+vkgkP76FbkFMsBc55Cj9a9PNzbKh2BAxoiW4sfyliIJaISvMwpc6vVnWmC031hfmXayKdyoxLy/ovApmPwbjo2SHkntUkO/lq+ndIxwF3h4BhXrXtj8qJWUGiw7ucUQDOCIinofgrVAXgJyYBRPPQa7e2336lw/LSeM=
Received: from DM5PR19CA0006.namprd19.prod.outlook.com (2603:10b6:3:151::16)
 by MN2PR12MB2911.namprd12.prod.outlook.com (2603:10b6:208:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 06:23:12 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:151:cafe::79) by DM5PR19CA0006.outlook.office365.com
 (2603:10b6:3:151::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Wed, 29 Dec 2021 06:23:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Wed, 29 Dec 2021 06:23:12 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 29 Dec
 2021 00:23:11 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 3/3] x86: nSVM: Check #OF exception handling in L2
Date:   Wed, 29 Dec 2021 06:22:01 +0000
Message-ID: <20211229062201.26269-4-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211229062201.26269-1-manali.shukla@amd.com>
References: <20211229062201.26269-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05a0d543-8322-4ca3-2372-08d9ca93b0df
X-MS-TrafficTypeDiagnostic: MN2PR12MB2911:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB29111F7DEC9C853632EBBE97FD449@MN2PR12MB2911.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lY/1Wk2vuxvV8LGys611fg8Kr5rv6bSuI/IqflO1gaO70qo9sD6nR/wL9a0XrROCArqiZp+gDdfaVSDUo5uAbzjeplRV3qPtKxoJh6dRSFlAddfICY4j6Gs9l30+cSouJMEKZl9mUq1CmBJlU/M0WBpNxAG7gMwkxHHMWhtkGafA2bxaUYotPOkflseu6smMHzvG5lqD9t1e9hsyKpmzMd48e/QYmxiNx/0Ou8/hH/mTMFa4TTNRrlGA2sxTg8eRxMrRpJIV1Vltl2WDoTsXC3XnVnRH79wj48ceeewR9kDsfNcGJ67BooCNLT1YkKpWoNHzAe5mpCCeuL2fJGR/o3MTTZ0GKhVvlBcSPLuB1Idtvp7hBTMUo4hHPv/H4Rmi3DAhH/dATzntfJ6BITvAoB86dyjuyb6DRk0mXzQiIL1UQDE2JHI262aKpzAvn/9m/vkisrNwFUz1HuJxMfAvSsCyVr7gkUwFPiTVHQAgSNNvcevpx0GDH44dFZFhIuNrrrjDwTN24SLmPBLoLqtIqfZnBxb6GiKz2/jf1e3e0IEMR5h2sgz8aDk5KXl15MU0ovZfTcysr7pt+3LBM3cSvittjtguVUT8iwPxSI9BbYVDjWelG7hmsVRbqH+A0dg9QmPiiDIpYHCuWv9Bt9gwcXyRvHqiuaXvBdZtJEnYIP7QJBnThF6prDMCupqp2M8GWcpFBCzd1j1Kf8rSSzO68qnVmHJyKIqdMxnJD1gn33OgAlreD/aOs+HAR0Yl8uUbGtgClMDGnQlKK7/MqLIGvgDT/AWxIZhg5NBp9NZABXU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(336012)(2906002)(316002)(26005)(70206006)(1076003)(8936002)(86362001)(426003)(508600001)(16526019)(5660300002)(82310400004)(40460700001)(186003)(47076005)(8676002)(36756003)(6916009)(7696005)(36860700001)(70586007)(44832011)(81166007)(356005)(6666004)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 06:23:12.5115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a0d543-8322-4ca3-2372-08d9ca93b0df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2911
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add coverage for OF exception handling in L2 when only L2 OF
exception handler is registered.

OF exception generated using instrumented code and it is handled
by L2 OF exception handler.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index ed67ae1..0707786 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2962,6 +2962,53 @@ static bool vgif_check(struct svm_test *test)
     return get_test_stage(test) == 3;
 }
 
+static int of_test_counter;
+
+static void guest_test_of_handler(struct ex_regs *r)
+{
+    of_test_counter++;
+}
+
+static void svm_of_test_guest(struct svm_test *test)
+{
+    struct far_pointer32 fp = {
+        .offset = (uintptr_t)&&into,
+        .selector = KERNEL_CS32,
+    };
+    uintptr_t rsp;
+
+    asm volatile ("mov %%rsp, %0" : "=r"(rsp));
+
+    if (fp.offset != (uintptr_t)&&into) {
+        printf("Codee address too high.\n");
+        return;
+    }
+
+    if ((u32)rsp != rsp) {
+        printf("Stack address too high.\n");
+    }
+
+    asm goto("lcall *%0" : : "m" (fp) : "rax" : into);
+    return;
+into:
+
+    asm volatile (".code32;"
+            "movl $0x7fffffff, %eax;"
+            "addl %eax, %eax;"
+            "into;"
+            "lret;"
+            ".code64");
+    __builtin_unreachable();
+}
+
+static void svm_into_test(void)
+{
+    handle_exception(OF_VECTOR, guest_test_of_handler);
+    test_set_guest(svm_of_test_guest);
+    report(svm_vmrun() == SVM_EXIT_VMMCALL && of_test_counter == 1,
+        "#OF is generated in L2 exception handler0");
+}
+
 static int bp_test_counter;
 
 static void guest_test_bp_handler(struct ex_regs *r)
@@ -3148,5 +3195,6 @@ struct svm_test svm_tests[] = {
     TEST(svm_test_singlestep),
     TEST(svm_nm_test),
     TEST(svm_int3_test),
+    TEST(svm_into_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.30.2

