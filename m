Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819684C62DB
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 07:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiB1GTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 01:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiB1GTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 01:19:08 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2054.outbound.protection.outlook.com [40.107.101.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624871CB0F
        for <kvm@vger.kernel.org>; Sun, 27 Feb 2022 22:18:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKMTKXPdBzy9UTS3pDkT0JXrYbrRDYblASSPYu5/u5DRP3HLSTyA2WqVvzXKZva+4YEXnoLa1Yl5tXFmWGuqUq7KcLvI7niyhAm+FzawEqdVCcFaX2b8QGXZwRO28KJHZ/xlP6fC9H+Us5BIiR91UgIhqAc1ZAQLSLYm56QP4AWIMFZawjBsVNJ5Jo+FHzNtNjMySafeP9rDV2WtFhkJlwOUSpfPmQ7uNG4WG7aH+EvFFxhlKJZqLhJFm5Ym69OzfnTHhRttkYXVm86eBZsOqQC+GNqX7sEUciaYXmdsY47ZIYzXz/J2gUohj+arZL7tRnFFy5hA+9rc1c1QUTQgkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaCmWdZJHQq6cExhy1xZ7JxevnVtY6F0HPJtOoxPMXo=;
 b=ZgAKRI9V7KS99OabF4TUgaRGsvrUmAcIJYWO74TmiCrM8t/v0Nxq1Ui1UEGmUaUJ1ZSjIZFxdNH+MXcZzwT/adblQ6bep+q/KEKxJkW4CyZGcRU19I1sSZlkmHOMeEvH5HHOw3Uk/DTTYwwNk8X4Gm3mYq4kJd4ySEzryuY5zXJonftqkE8hKhIKJLeyeBESFIscHYmcgyJDB4GLklprtQKaaxvJtYenL455iCPNQArvGMUd+DNtt849LQOCuItfF99bRMsyr1I/OK40yQVeNXaQBJgoAK42u2mNVZO5Y28SWwMtCDJhIr/ezmMDWhsG9YK/CjMJMPXVGK+reaE9WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaCmWdZJHQq6cExhy1xZ7JxevnVtY6F0HPJtOoxPMXo=;
 b=hbu+/MQR+GFiSBQ5B6d+hKZNg+0QGulv8WMyswdCVmvMh6U582H1F+zF9deZKx/9Q17pV2CBXlnrerYyyQklDPlcjtKpqGmLroKbFF1Bd4awWEtOGHZBrwnHYlKPnCZZxAB8gNbeGmEYdvJQDkunuFoaEAquy5ZV+/04JnQztqk=
Received: from BN6PR13CA0012.namprd13.prod.outlook.com (2603:10b6:404:10a::22)
 by BL0PR12MB2386.namprd12.prod.outlook.com (2603:10b6:207:47::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 06:18:22 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::4e) by BN6PR13CA0012.outlook.office365.com
 (2603:10b6:404:10a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Mon, 28 Feb 2022 06:18:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Mon, 28 Feb 2022 06:18:21 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 28 Feb
 2022 00:18:19 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH 1/3] x86: nSVM: Move common functionality of the main() to helper run_svm_tests
Date:   Mon, 28 Feb 2022 06:17:35 +0000
Message-ID: <20220228061737.22233-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220228061737.22233-1-manali.shukla@amd.com>
References: <20220228061737.22233-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3acacc27-b57c-4051-fb86-08d9fa821ede
X-MS-TrafficTypeDiagnostic: BL0PR12MB2386:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB238692A6ACB5D052DF53C2EDFD019@BL0PR12MB2386.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9Li5W9FoABJYETDy5cQmptb4F0jM1/xfFoPt4JF3sgBjC8Q+dfnQJh2LSLEvfbx0cheC+KQTCUInAgPcqWfKjbjRNiSHBa356L0ZyeB7A2NlFlt8a+svZAYW1y34Z1YDMaDtelqAs4ANhyu/0EyUYrE+CFObApLCpCmcPAYvbUJ2s2ZdB92M7pG2uLpTK5yVBwgVfDl3M340JwKtRC9g33c4Efza6cSpKOCbvx0J9yvt+HiR7hC2I1gBagFMYO6ZDY9Y7R0Mym0W14DnQjjzsXdeJVN6m77ew1WSLMLSP/hh7UbcffcmIfF9WzapvNLFEv0vXgDKNlzK2mp8podGdzfE6skbGYhDO7IMS6MsAIoyc6TQNtnFxpYJ9v0AztPWHV26adhCRy3uZ5HYY0AAXSAxxZfdfmhZnRjzb9cPrLutuk+7+09LuLiXiZ+7p1OnBhX/yEwg91ZE15VffGmnQKuSbDvxJTA9Oa7xfG3dFAGh3hmXSpnxDb6M6WyiqNJRkLFmzsZxt5AVE+akZjMq0iqmth5TGOj9qWqkoKoIbjeB3iQ9oLLjuJWSmZgWyMxk/qdFr4K5MJIR+QL06cVVaz7biJgEEimXz/Nnmq9wVnQwu+7KW1Oesq0cgJfquZyqDeGV0x3iVwOsuVAAV6oa1lUB+3ck7WS8xRFDYPZjN0HNqEuLegalHrEfanHxGO+O+/wX3zgBjoOBY9AJp9giw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(336012)(426003)(1076003)(356005)(26005)(186003)(70586007)(47076005)(36756003)(8936002)(54906003)(110136005)(2616005)(16526019)(81166007)(508600001)(44832011)(5660300002)(83380400001)(7696005)(6666004)(86362001)(316002)(82310400004)(70206006)(4326008)(8676002)(40460700003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 06:18:21.9633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3acacc27-b57c-4051-fb86-08d9fa821ede
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2386
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

