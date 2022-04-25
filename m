Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF06150DF4D
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 13:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiDYLuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 07:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbiDYLtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 07:49:09 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2069.outbound.protection.outlook.com [40.107.96.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9613A403CC
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 04:45:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtpx6YhUxrjMAEVVgHyv+cMJQ8Jnl7SiTqHouTEETwe7kzg1UoZO3cpnCsR+cw0rJBCRUg2+C1Fb2Xh2wH9wJAkbalSj3mpNf1jmpEJqhodV1voClI5tQSVlZVQdUejSG0THFqDfbjzm1iZzlen9GvvrY0fw0Xcg7PWvP04cCJoW3DF1Or7U2mrY8ntwMK2PqPlRXL0aofQipUN3Yt6c+/P1rls8OvNUtCb4rU1RVwsCkNIzGz884rohMMFy/yEgxp4aeK6+c8RW4lroCxeIU39ZsBhxgi8dyn76JhWaYZIxVfuQv2AHQoawvPz0fZO/opJMsgaGenjRJNgqHjoSgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afLz6ymCTxhBM+cMUfD7Ernu4k6QpU4c4t5M0qzpWyc=;
 b=h5M9VEsz4FmNlILbGm0dX3GwnSdCET3DTjZ3hChXCGecuPgIw6Yhgudh9rsq4/dSZLTflWTD5PVw+erh2N552vBjXg4FEOp+dStYKC6mB2xgV60YM5MWFwdvAzJewxkOnQLibdjOLyPw81+EuMwmseadrXbbqjeTQSMJ1VocWgYBEdwgYxhrGPOQoWqw4mAk2nNaoXeWPF1whcgHQS4cy+TdQeHOT54k0MGMJECwFtMeVPyNj6senSCc0ut5ACHLzKrtfI5am7bVc6cFt2Ei5ravCcCml599xe6qdXl8G4LJFyN3I6TjjCZYOFvWB40eHTT5S7kisMbkyIwtpx+VSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afLz6ymCTxhBM+cMUfD7Ernu4k6QpU4c4t5M0qzpWyc=;
 b=4/M+tK3CQ8GL9lEy5/V8CTHA+zZImk5d+3hicwUXhvqzUIaFBF0B88RFtIQ0an65M4RD0nAtSaCka5xhBkMzvmLm1GSEBeILwh7b6m5o5+RkPadFXOgvsOm8aKc9chVaxweV7h5WbI8+KCZSQU/cIhMRpouXeY/SWNgHWmZBMPc=
Received: from BN0PR04CA0204.namprd04.prod.outlook.com (2603:10b6:408:e9::29)
 by DM4PR12MB6009.namprd12.prod.outlook.com (2603:10b6:8:69::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 11:45:42 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::23) by BN0PR04CA0204.outlook.office365.com
 (2603:10b6:408:e9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Mon, 25 Apr 2022 11:45:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 11:45:41 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 06:45:40 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests RESEND PATCH v3 3/8] x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
Date:   Mon, 25 Apr 2022 11:44:12 +0000
Message-ID: <20220425114417.151540-4-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425114417.151540-1-manali.shukla@amd.com>
References: <20220425114417.151540-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9585faf9-f5fd-4ff6-d3d7-08da26b1202b
X-MS-TrafficTypeDiagnostic: DM4PR12MB6009:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB60092CB790EF454A2084C25DFDF89@DM4PR12MB6009.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NEk8TfmzL0lakyo8zA6z4iCqN6t6CgB1eaujeOdMXqQW9ac8nczPYNzRmVtK1gox2qvHKIH+Gnr6W9RUsEKsVQMGnwbTwfAzQGDCYjKBt+NXc1MAvy6PZEiFZZTBWW6WpH0+ZC5f6XwJttK7S17x9r6gKaQTfOKdm2aflbrn9whLbn1gX5IZcwAtL/gpWncQUMY9f5RWB7uO11h7bJcTbiN4CysGy6y9GrtVbXmE8dfM2w35KUKStbGJ4GwInwICJ0ER/NQW+utx7jL4Y+AxpPhp1WjFVBHSmJNleMnQaNPRJj4i8IzSHHNLP/J6jwOL+LsS8sVnWS4780Zm4Z2zrteMnVhTzubW+HvJwL01F30TLirLUC5G7cwxCaa2mJk+v7oKHwBrQmv8XhWtHpJ5kQYwnUkwU+Oqq4iQQbT1g+HMEE10eKhu47kwhpEC8jjfYWBbf+6wHWdc65FvEshcRjW6eLN0dxv1pQYkufjOK3tQ86q3xsOdaHMUJQ+/midf2teoGbPLd7EirB3Llx20fjs9vwcIe87DlZWGXaPISvXoNqSBXQcE3lW+xHaO5NVNueIbNZiImJ0p1oPO8ijulCgIxx8R5qRDSu5TsitbiZUx9HhhVMRv2L1CZDkF3VlUjxCX4RkkW7lGS9lLbwpj/UznmkS2qjAC1Si92fmUn6jvSMUdEI07fC0zXnPYJfxhv2zAncykwMM+mnvlRwg5NQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2616005)(86362001)(70586007)(70206006)(1076003)(7696005)(5660300002)(16526019)(81166007)(6666004)(83380400001)(336012)(40460700003)(426003)(47076005)(356005)(8936002)(316002)(186003)(110136005)(508600001)(82310400005)(26005)(8676002)(4326008)(44832011)(36756003)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 11:45:41.6531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9585faf9-f5fd-4ff6-d3d7-08da26b1202b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6009
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 916635a813e975600335c6c47250881b7a328971
(nSVM: Add test for NPT reserved bit and #NPF error code behavior)
clears PT_USER_MASK for all svm testcases. Any tests that requires
usermode access will fail after this commit.

Above mentioned commit did changes in main() due to which other
nSVM tests became "incompatible" with usermode

Solution to this problem would be to set PT_USER_MASK on all PTEs.
So that KUT will build other tests with PT_USER_MASK set on
all PTEs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index f0eeb1d..3b3b990 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,7 +10,6 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
-#include "vmalloc.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3297,9 +3296,7 @@ static void svm_intr_intercept_mix_smi(void)
 
 int main(int ac, char **av)
 {
-    pteval_t opt_mask = 0;
-
-    __setup_vm(&opt_mask);
+    setup_vm();
     return run_svm_tests(ac, av);
 }
 
-- 
2.30.2

