Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF034E5E2A
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 06:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347608AbiCXFdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 01:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347683AbiCXFdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 01:33:52 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E7895489
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 22:32:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gw+p+Jh5V9ht/CGQ3D+D9QrRy5FBUto9zPRruH80fneXiMYodeJalyPezW8nlap6gQ/X4WnPvgR63Gknc2Qmrk/BCMnGfLErlFdukMfrLi8S5WRLHkJrwCx0y5MUSwYQ7U/8QrLG/4J2yaEDw0mqDWyndAmMLXOzUd8lALBQukLyAOJDVqUDCM09G+8SQ5O2pJSRTKEn82qkjHTMeZFQYBYqDvZkqkW5w9SdbYrYe8dxhkOZgN9EOIUVHcQOjdDqBsMGbUyywhtWnbn693x/kUciuBXhMMAXD8sIITlHJnOaevmDXTFo47hVZwKxPEJMyHsPwL6BVpkB/vYDzhHe9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zz8SnjWcHBOJjum7s8hIY2z4hKBwmysXEdBaGF2IT5I=;
 b=LxYOmWB9BTTQVienrNz/Ezg+N5sTq92BzbJ5frQk0xYkFSXj7bHi4RE5B3H/EeejNi6DJvUAFxgkIj/h8DZJ7Rd1a79dguB7KVbUd+qwqCdKXZVCHmGmz38161w6HElQE68BY2jOv6QndzYCTOQE4xHmMJuGkMhhVLe3b4sPAgDpacqBMB43cLEIX5xvWE32qsIDWJwtujTCa7ziA6ZIfopGmHcMeH+O77R0uZmCxAgAu473xqC+LOhQM8JTPLJXJJUfFsS//3JrRLE5CtiefQSV4L+gmYzhQ9artWu0BmgYVEBFBBWO2tmPNWhc01kvKGGHspFzX1begD78VvnASg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zz8SnjWcHBOJjum7s8hIY2z4hKBwmysXEdBaGF2IT5I=;
 b=q4HMoFGB+ZJ7HXP1aZAGFSAOXc995hifET11vAHGH0t1rmlcmw7qTZ15ITBTsee4k0taN7bKgBIS3zMTSD4NayDxnfmTiyaPVgBcCx9bV1YJpmWeLHmnd+8gurKUavJagll4sWXuE4kc0Xf/H7BSX7KbyuFsuhzkY5yfoJbNfuI=
Received: from BN9PR03CA0884.namprd03.prod.outlook.com (2603:10b6:408:13c::19)
 by DM6PR12MB2970.namprd12.prod.outlook.com (2603:10b6:5:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 24 Mar
 2022 05:32:19 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::85) by BN9PR03CA0884.outlook.office365.com
 (2603:10b6:408:13c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16 via Frontend
 Transport; Thu, 24 Mar 2022 05:32:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5102.17 via Frontend Transport; Thu, 24 Mar 2022 05:32:18 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 24 Mar
 2022 00:32:16 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v2 3/4] x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
Date:   Thu, 24 Mar 2022 05:30:45 +0000
Message-ID: <20220324053046.200556-4-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 650f4c31-f334-40d9-9aac-08da0d57a9bb
X-MS-TrafficTypeDiagnostic: DM6PR12MB2970:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2970F3F15E8FC5E97B9BAD24FD199@DM6PR12MB2970.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5DMeGt2uvPAqfZ/CQGZ7bKT0GL3LvfNYItLL8+4ZGvYirZnOT6dV1FeGex+GIGKIpWb22KIJx2ZOqdXLe9oNMHYwAy8n9BtfrPhBvrYG9A4XyuB1Lvlb1n9KpruIoSM1ZWB9/fHkoVPBFFhfY4SflbXNIyS7ess5zkp1VWP8hAfBj+exjSXSvhPi1PG7aOhi85NG+7A2G6cneswKRrsJKyXNQMIn0eMOAI3xixaGbuk0nkw/4V43oDhi7iG5rhtsVW8njQTWFGyzXv+SLmnzeeVQ356T4QU5YFJKN7rc7XI1KS+ripmPhi/kiNrHDqgUGmX8VlIGUVHnDvK3TLoPqi1vBOikc/cTwbdjaYGVa7mrCIUEjLyZqSBPG7YkYkNFaor7k8cKZoGEh9ug8XqZkIcMjLtzC3vLoy46uMzhYv5z+hIDZ3QPMIknXoD6YTNkq8dbqxGox/7Ffir6n7F/myFG+2vkWWh70uKx8HzUWryLq33Zm6w662Q307dCpIucz22qSjSfQgOxn1fy/VXA0SZaQUZ54swUly5jwesFIbkPqUulCrmEiE2PBKWNJgGgiUnpu/G0KDQs60mBkFL4230jzWG+9edFPtFhgnNk6d2kzMpbUiYIhiq2Xr+PIoqCiys7D304SIYAM94pKI5C91haU5UB+bdBuGFqpvxpyDkCfbKiW0aYpk3Kkzpq1fdowhxGJDX4jBxShvKGOb5iA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(40460700003)(508600001)(1076003)(82310400004)(70206006)(81166007)(356005)(2616005)(186003)(70586007)(26005)(4326008)(16526019)(110136005)(8936002)(6666004)(316002)(8676002)(36860700001)(83380400001)(2906002)(7696005)(47076005)(44832011)(86362001)(5660300002)(36756003)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 05:32:18.6525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 650f4c31-f334-40d9-9aac-08da0d57a9bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2970
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 41980d9..fce466e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,7 +10,6 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
-#include "vmalloc.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -2736,9 +2735,7 @@ static void svm_nm_test(void)
 
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

