Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BF14E5E24
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 06:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347569AbiCXFdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 01:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347117AbiCXFdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 01:33:07 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2041.outbound.protection.outlook.com [40.107.100.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C389682A
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 22:31:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XM1RtFqAPB9EHKuwZyQT2bp645gzVPIw03jWUVN7QnlQ/hD+KQ2OPkmxeM/t5DUa+NUbWbZCnwtZvWga5DJIPOCy1hJNLMaQTcZrhW4UY/z8fDGqR3+kdlKTZs2PRaXos9LJu4bjl01aLQZVgx3z0ctL1MsHkBVxrq7UcwcUgpdw0ODVbey7RQCEAbYkYl99E73Q9saHNOyZTcqsWP/NlMoxtpBZKUy81acFIlwzM9AWU+tCQOXBvxpBEjNHcP24D+UN133Jizgyfov1vFXpfDF/DKGtqDnAuSmjRf1UhXmvaaHvd7IwSUfco1F0iMfjNv8YZrI+HsBBYAxwO/bHlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaCmWdZJHQq6cExhy1xZ7JxevnVtY6F0HPJtOoxPMXo=;
 b=KaEfWa3/k63+ikQnJZzDmbensVx2B1n2eL8UdelTOMqbMIMG2DNf+N24+MwSMVWDeRT+tud5ctRKaICpB+wWEa7K/LKrQVCKxFCorjhQsQvH5pR6ycZjVcRIbvbeqoE5/64ki3Ss/xilSaPZJ9fP/0xq3hvS+/cbgMzlZ3nZJHX2yfQel8uQT2B4sFiDYjDag9mrY90kRqhuqjjTjF7UdqVbweOpvyBeGMEIApJ72lipjhH3bvr5Y/Cf/JZ6yGAc5N5kIjCeFMSgQ2yVxa4kAp/I7dqFNxZ2y6eLCht/ikCrwwNGBxwiqk8T/8dnnmykiywasJjH3rlN3QmVatul3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaCmWdZJHQq6cExhy1xZ7JxevnVtY6F0HPJtOoxPMXo=;
 b=QQ6CXiqv/tsS0vkYfywRGv+bnrVkLLWQ04MF4qm2L0ZR0HR+EoxHM9y+PF8huN5RIOa8BLu9xSjIHPqyMMd6gsb7iBwN4B507AQYatDbkmxuFqkW1b0Yk4f1EqB4zYo0xKasxRnLhR8hb0yfrZrc2oyjDIgnfm8/j/N5TdNR+b0=
Received: from BN9PR03CA0390.namprd03.prod.outlook.com (2603:10b6:408:f7::35)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Thu, 24 Mar
 2022 05:31:34 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::3a) by BN9PR03CA0390.outlook.office365.com
 (2603:10b6:408:f7::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16 via Frontend
 Transport; Thu, 24 Mar 2022 05:31:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5102.17 via Frontend Transport; Thu, 24 Mar 2022 05:31:34 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 24 Mar
 2022 00:31:32 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v2 1/4] x86: nSVM: Move common functionality of the main() to helper run_svm_tests
Date:   Thu, 24 Mar 2022 05:30:43 +0000
Message-ID: <20220324053046.200556-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220324053046.200556-1-manali.shukla@amd.com>
References: <20220324053046.200556-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98f95066-4945-47b1-9f4f-08da0d578f3a
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6008D7304A6B1C0847A6681AFD199@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hx939S/u60v5vPVfcMJ9ZqWRBz5cieQK79/O0PpzubvHitkKdm9MIakprUrZWXcYkCwAQFuZxRxHD1aAKq9nfoOSy8bBup0I24UKU0pnnwpronHjJfij6GUS6qGVNBc0xI5Y2KiPPk6ILfjhkMhn6p5mABkV2z6p6fUQuMCOOj8xwU/xF0kdMh10JX+KVpqRgPr24YkfjUNaR7elkn+sexcf0jjLABnbLw+fr1vBS33LLdpeaeVN2vjY2Mr8/VP5xbUdmtbJCdjYAHlyxa0DTKK6IEKCwjs2JVc5VQe9ZofY5abrLWJEjekPKXnn1mmSAKtMoUgzbELVW3fXsGcHgwPkTYj2Vcr9nERo42PB/umOXe5Bnbw3EbXyX+yhTjTu7JeiZ/dTTwFdN6f7uv7nms6UX4CAnGGxwgY/1Jk35zNovPISQ6a7aAcZuEACS/7bWZtjl1rl8bx4O0XAWFVxVDLwk1syw90x3CxrzD8GmsnjTNUyQFhaipuTb73et8t7Wq7nO2ctBALcb0ljSlhsrw+yF7Gc6ciRkesuX7jnNzvMhdQz8k42r+HCoOv+IKltFQWAL6BLJqYO21yINzfFqGtp+ezL4cFCCoapaik/bwSVCGJNIisJCwyP3LRvndBSgoAJhCTUajur+dgYsv3CaKapkMs8nc4qPCXbHWGr2Lv1f+sLrYlgSprlRv51NgGfliHJEZLEzMEzxg0VBJAB8w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36756003)(86362001)(110136005)(356005)(2616005)(508600001)(16526019)(47076005)(316002)(186003)(82310400004)(1076003)(426003)(83380400001)(26005)(336012)(40460700003)(5660300002)(81166007)(36860700001)(4326008)(8936002)(44832011)(70206006)(70586007)(6666004)(8676002)(7696005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 05:31:34.2021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f95066-4945-47b1-9f4f-08da0d578f3a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nSVM tests are "incompatible" with usermode due to __setup_vm()
call in main function.

If __setup_vm() is replaced with setup_vm() in main function, KUT
will build the test with PT_USER_MASK set on all PTEs.

nNPT tests will be moved to their own file so that the tests
don't need to fiddle with page tables midway through.

The quick and dirty approach would be to turn the current main()
into a small helper, minus its call to __setup_vm() and call the
helper function run_svm_tests() from main() function.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c | 14 +++++++++-----
 x86/svm.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 3f94b2a..e93e780 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -406,17 +406,13 @@ test_wanted(const char *name, char *filters[], int filter_count)
         }
 }
 
-int main(int ac, char **av)
+int run_svm_tests(int ac, char **av)
 {
-	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
-	pteval_t opt_mask = 0;
 	int i = 0;
 
 	ac--;
 	av++;
 
-	__setup_vm(&opt_mask);
-
 	if (!this_cpu_has(X86_FEATURE_SVM)) {
 		printf("SVM not availble\n");
 		return report_summary();
@@ -453,3 +449,11 @@ int main(int ac, char **av)
 
 	return report_summary();
 }
+
+int main(int ac, char **av)
+{
+    pteval_t opt_mask = 0;
+
+    __setup_vm(&opt_mask);
+    return run_svm_tests(ac, av);
+}
diff --git a/x86/svm.h b/x86/svm.h
index f74b13a..9ab3aa5 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -398,6 +398,7 @@ struct regs {
 
 typedef void (*test_guest_func)(struct svm_test *);
 
+int run_svm_tests(int ac, char **av);
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
 u64 *npt_get_pdpe(void);
-- 
2.30.2

