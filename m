Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D3755CA70
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344348AbiF1Ljk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiF1Lji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:39:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D60B873
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:39:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmemPEy1CRVunUckbZiQU2jUSKwq+gc/yn3oGp6eaznQmqkMCPqZ9NyBDwWwEUfQhVwbzhfL2znDNDjEdRn134d5DvVSV9f1H72YY0gz/kxn2+ISckKaCjOa2HbYiKrTucBPGmdmbTensSbIqp0VEe515D0pm3aw+tOiMAD/XEl8FSA0WRbEbqjnN8lZcvx17pHWGVWnZQU/dPZ9Ht3LisSACMXYiAx8RtiOCQ/5GiTzO39+/Fls+36mFYUE/OpGWSw57x1tsRn5EWnPsaxYmdfn1FZjWL3T7U1z1jjNIOx5mBMOYZPeBazn/RxhbSTueJoRJjdD8tEt9FJkGVHFLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJchslNM/Lw0iZzln1SACiguBdV7XtL7FfQRHgckVjI=;
 b=M9ymw46FrLKHHTU/vLMsLfcIi2ZVxY4ubPbyzhtLGTr5lr4jqwRie1tzTI1L6SZW6566FPsnb9yMt7nfyARvhCezgaYdlz6wd0+lXYMod7oOmrCqup4OOyU/sb1EQ4BOpqoYlWuu9FmxyVgQCZ9Vr0D3QeyAOsstDXwMExdri4/HnCMcachSclBXW7E2ea6xzVMleS2c22zxCREQQW0Uc9wjAFCi8z69dlGAoFuyQud6xusXJUOdiAXNeqHKAzDAl36pHqajG0B9EFGVXumhZf6+MTweL/I7yL8hKayqljcqnJlEXxgMgoV2wlXCPTgzDfvUKDMw1CJNdJCG34nfww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJchslNM/Lw0iZzln1SACiguBdV7XtL7FfQRHgckVjI=;
 b=31zLgPTrq23g5Ef4DBcUZR9dEb/Sz+ox3dhEf7EZfsDV4JrNAdrKDJxO17HvprSwqimud2C74iAoiQ/gOJGz14s2HCNxUuOlIULR8KU2ONEE9rXX7BoD5f6L/8aKwRLrfggtGzYADhn6cqQQjhkxiBwA7zP6FIxuAXwtwM9tzLs=
Received: from BN6PR19CA0052.namprd19.prod.outlook.com (2603:10b6:404:e3::14)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 11:39:35 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::9) by BN6PR19CA0052.outlook.office365.com
 (2603:10b6:404:e3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.21 via Frontend
 Transport; Tue, 28 Jun 2022 11:39:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 11:39:35 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 06:39:33 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v5 1/8] x86: nSVM: Move common functionality of the main() to helper run_svm_tests
Date:   Tue, 28 Jun 2022 11:38:46 +0000
Message-ID: <20220628113853.392569-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628113853.392569-1-manali.shukla@amd.com>
References: <20220628113853.392569-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fa989a8-b490-4e1f-a1b3-08da58fae05e
X-MS-TrafficTypeDiagnostic: LV2PR12MB5871:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8GBmt9bZfzIxDAsD/PydicGUVHc0jI/GId9x5A6iapmY7xC90NLqw6vfd5xW6rDPpOf7B/Z9dsx0iVdN6cKDsVcWfd+LwK6TweovZMiGLtWr1c0rCxqzGZhQEMViQenRpK+62aoKX0zqTtdLCAVWRrNfE+zXeZjaPO14eiSeQfSzYZil4zY1K210fpmZqB19RHW2NrPk8HEe3aJ3XAqW/+eL9VIclJ/69WAHO2Y9aVPKAMrf1DaMb5gbpzyMoQ9smBlaeFlXdpgWvtco7p/m+jgQYEE3D4bnpTZI9F7SCdA0e+AMv1jKpJK+VzVSor6l9Lg1HumniZk1PGp0q7wdEhVbHsbCDLW68KA/ocsc7ToULRl26FcHeusxOwOSAy2vDDz3xsQqbjt03Y5eWXp51u04w0YSr4YhssHz0RjHjuQpceQr4PKLH5dylTU9yaOf1J23s9fQ2Z/U90LTjRz5Jc8mrz5IZkcJ03WOiKf2pHGoX94bMAOLPeMH90y9Vrlf91gqpzVcM1k7lAI30mF2t3kj1RtCBFqclfeuwet7OgUCYnOuveJyrD855OLZP+aemlGZ7tnfXHY2ZGJ+SWrXR+jBVTeAFf4ff0TVAIWDq062L16wyd5IhSOf5kCDv6URymjmmBRKXT6lB0ewX+Wu9LxEeifdlfpeZPPhoUwdIbhjJpERs5gTUj3mKJv3kibK2Mu0JWKN9GEc93XSM0db2miUFiEPHbnbX5CpzXFWw8WdbwPPp9w8p6P0zdbo8v799R/rpW3Gl2meXaPoEVKUNEP/HO9j3QWbZSefjKI9ZsShYvipZIMWbZzhVXyyhtDOJF19AawYQevn6V0HFrAJWQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(39860400002)(36840700001)(46966006)(40470700004)(478600001)(426003)(70206006)(1076003)(47076005)(2616005)(336012)(40460700003)(16526019)(44832011)(82310400005)(41300700001)(186003)(6666004)(36860700001)(26005)(8936002)(8676002)(4326008)(81166007)(86362001)(82740400003)(83380400001)(7696005)(40480700001)(110136005)(2906002)(356005)(316002)(5660300002)(70586007)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:39:35.5088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa989a8-b490-4e1f-a1b3-08da58fae05e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move common functionalities of main() to run_svm_tests(), so that
nNPT tests can be moved to their own file to make other test cases run
without nNPT test cases fiddling with page table midway.

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
index 93794fd..36ba05e 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -397,17 +397,13 @@ test_wanted(const char *name, char *filters[], int filter_count)
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
 		printf("SVM not available\n");
 		return report_summary();
@@ -444,3 +440,11 @@ int main(int ac, char **av)
 
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
index e93822b..123e64f 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -403,6 +403,7 @@ struct regs {
 
 typedef void (*test_guest_func)(struct svm_test *);
 
+int run_svm_tests(int ac, char **av);
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
 u64 *npt_get_pdpe(void);
-- 
2.30.2

