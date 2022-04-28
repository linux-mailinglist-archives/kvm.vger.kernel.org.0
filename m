Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DB7512C64
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244826AbiD1HNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238564AbiD1HN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:13:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9164C6162B
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:10:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+iZ2K4z4WbJSwklcZ8jpnGdFsz1RuG5ZrqY8/x6hLVoZZZP+6VHBnAffzG6/nKJ4xBhnQAdVK+ZrXKw5K0gmxGDfeDR5J+2obSVYAdd3c3sCoVKaHpvb9nnJtD8JIhAvybCrcuwrBX8un2mnBCEh0QBUzArUTnTHaGe0iRZb4b6PipwT3cSQtDEjOmUisedCWSfaZ22NoaO0D81ozXx4gE2FMR5noVuAinVobuqV71X7bA+Xar9BHDRtVjUrkDRSixnZvkHo1gPI61yWDZ+Q7tvZu0VvYtj1WZm5Adc6OVrkws/I9ps3LbYvj012H03QighWZaqYgqtPGnqsvc7fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQoMxsKRWvk2zoRApzSmN+kwdM16YC7UU2Rv6UIx/Sk=;
 b=VvyQ1SJyYW32WxL/TGaXWt7UMdJ3gBLkCdOARO/vPjd1Tc60prb7hmjXDCW//yQdXbbdOx6sbEtCcpMa39IiEX0Q6WYppVxxUiSMvfNPbrEpP0/MvDzchpEo3+Mfgc/sPVGN4YBvg1tXG6pWXFz1+vQIDA+AYNuUZWhDQRak9qnc8D6oGw75yP/hFmQneWWd/SKOJnJo8hdWH7CHNFwpFKZAv085x3dqNFam+O6ZXdtpaZAE1R50tL+YRtO2j5bFGCFk3SOUion7k7057Rr0/bmbKMsA8aJP5OmD4TjiS99mmDbfwj3aMR3fweM5zpa6n2QIUYpZXQfkkA6PqWxa6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQoMxsKRWvk2zoRApzSmN+kwdM16YC7UU2Rv6UIx/Sk=;
 b=1eksz4bE2ssQhGr6ntIBu5rUKvHZzjvyOyglxc2RBkGEJi/ILoeR2KrCUV+GkdYEs3YZmZp70S7tTZEX8VnSaAQ81r7t/i0J0Spcx9vxGJnRI5Q05U6zb3T9wTAHkehtYl89vrGjEjzVqaxBxxV4Py7V7tjCJ6sGQW5rzYzfL7M=
Received: from DM6PR06CA0087.namprd06.prod.outlook.com (2603:10b6:5:336::20)
 by DM6PR12MB3547.namprd12.prod.outlook.com (2603:10b6:5:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 07:10:12 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::b7) by DM6PR06CA0087.outlook.office365.com
 (2603:10b6:5:336::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Thu, 28 Apr 2022 07:10:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 07:10:12 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Apr
 2022 02:10:10 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v4 1/8] x86: nSVM: Move common functionality of the main() to helper run_svm_tests
Date:   Thu, 28 Apr 2022 07:08:44 +0000
Message-ID: <20220428070851.21985-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428070851.21985-1-manali.shukla@amd.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d811a58-7a8e-4027-6b33-08da28e62328
X-MS-TrafficTypeDiagnostic: DM6PR12MB3547:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3547D5BA61FA4194FE1399D0FDFD9@DM6PR12MB3547.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgGjU23Uni/DADXFz97JxSgfd34cCIlOhzCTRPAkG1EsKnphHeVMv95LEjDKkEpTYl6GFGXbguGjFO9U+i3kfUIjpX0/+y4HAmew2/2wVlz2G6bWWmMYWanAav8mtByt9AC82BYuuoJImZajUFL1E/2BuvB21pN9xrcz5OguJPCCtixDFwbCc2Mkz2iKaGjvyOJUVaD3MMwWA9L12iXdclD7bq18y6ou+i1hsdlXvrtviAbd9xVLk+/L9SlU19y2ublSTYoFs0eGtnWDQ4tJZEV8a650OSBIGDZs8zal0mNbP75A2XH+epWpfnZUiwOpHS/dq5MnX1hnXMODhIP3EAqXPIuHsS2M57aMeXp6a/vatht1nrIiVQveUkWcvZ05IpNMWB0QNo3v7PAY1tfWOwMkBkhTQtFbfs427VqUuAmmX0bOpb8C+1ysLXMy1cBOY0VS+DGySpLDPgE5UIbrClbZgNpRuBGMTeQuAMZUaiK+fj9nUayD2up2dekqFUZO1wKj9m/auVjSgyfo6XvctNueIZ59zSlQ+g9sZGuSWzxAsP4+uS+djSsguDxk6V0cnx8xr7zc/kufH/m4Lim1mORB8bCipRQAZNBulOSHwdBxFwj6RY9Y+jygRzuMnfPHDYnVb82d+wzhLACIpzHqDA/t0uf0zdIlCvfYGQKfUeN/SL1IlKy/a/UL4IECCkytXK1xkeeBwbw4Co2eEtp8wg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70206006)(426003)(47076005)(8936002)(4326008)(70586007)(8676002)(44832011)(508600001)(83380400001)(2616005)(356005)(86362001)(7696005)(40460700003)(2906002)(26005)(5660300002)(82310400005)(81166007)(6666004)(1076003)(186003)(16526019)(336012)(36860700001)(36756003)(316002)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:10:12.2693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d811a58-7a8e-4027-6b33-08da28e62328
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3547
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index f6896f0..299383c 100644
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
 		printf("SVM not availble\n");
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

