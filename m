Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF9C50D6C5
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 04:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240300AbiDYCDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 22:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240267AbiDYCCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 22:02:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B777A5C342
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 18:59:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcVgcSAGpsGAk5jrQkWQAEV12IDc+y/4y1GEByleexkzsEIGt0j7JME7kNPpqySK4zEOn+aRxsX2N3uaca29SszJMe8+qbnpQivxQYVyB4XBPznqNZIwFOH1FifutX7EoA25yVadzyvKsnpKfjc2JIfJmuTHgi/zlZCGG4aXQ5j72jozUoAH0PQt9Z7LPIypoCVYRrrP4FtGGQWWYsL1h8aDWzsw/etJFxfVKCxuvljWN5FOJs/Er3gUZaqRQTKcl/puUea84ZyHOmTo/PHqBzjFfODBciG/wA65+2dEhk8XY9kw4hHvTWfA2eJDJrOZdAPJ8yS+9DE9nGSUOXkVTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afLz6ymCTxhBM+cMUfD7Ernu4k6QpU4c4t5M0qzpWyc=;
 b=C75QrUfJgNZC156a005ZW/xbnp3OWK9ZWm+tr6msjL/a3W8qdELWyflQtvC54TKXyPkhz1RY1QiO2T6Yqv82mAhmVlm8pGxQ9VWm7K3s2bPxpWxbHmqNZ9t2qe95lHEGJFp05jYKAGMJcKeg0BYuMcr0XL+yFZjGiLYb61W8aC9nuWg3lAItVHNxQ+toDFEblKuLSZzFiPTDwvlLpEJ96qF3SkxdcMFlWFAdUi4ryNZ2mVUCTlSZHTVfp04j2zh20JecW9uAhVP7uW1eYvkNFGKhKn5bLtCr+974ILhipQ5AAy8KZIwYMTc/LFts6yAhKbvaRvvROz3lcFOzwWS1vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afLz6ymCTxhBM+cMUfD7Ernu4k6QpU4c4t5M0qzpWyc=;
 b=4uUf0TsQVmdKwob66BbOHKm0IzYHSnGBMc1cCb7lZ1paDXFheCWHKDCWAaV5s9DqLQs16v9qvhWkjOlZEXwEWxnnHe1khMn3veY2NvaamMDT3IwceEHP7RlMEc6Lfzj4cxjG/mLL8CCEUIKscBhbL1fXDeu7Y8IAlJBmSzFumqg=
Received: from BN0PR04CA0102.namprd04.prod.outlook.com (2603:10b6:408:ec::17)
 by DM5PR12MB1515.namprd12.prod.outlook.com (2603:10b6:4:6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Mon, 25 Apr 2022 01:59:22 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::bf) by BN0PR04CA0102.outlook.office365.com
 (2603:10b6:408:ec::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Mon, 25 Apr 2022 01:59:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 01:59:22 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 20:59:20 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v3 3/6] x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
Date:   Mon, 25 Apr 2022 01:58:03 +0000
Message-ID: <20220425015806.105063-4-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425015806.105063-1-manali.shukla@amd.com>
References: <20220425015806.105063-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bb487ae-9c4a-4382-fe2f-08da265f37c3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1515:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB15157ED172F6D184EAA1FDAAFDF89@DM5PR12MB1515.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVQ1/kfOrwo8I2YSTf/dCnG7rRU5mmpIltB3bZuC9bLsZxLei+PMgvL74nnU8Q0vQwUYaPTo1UrL/1lX30nNyeREpkmOAP1hcUg+EIfJ9st9sXKWANe0F8hNwnNPlqt/pl8Jw8+v4T8px6Uw1ZioMjl3vN3SWasmQ5om2e87XRZ+vw6nz34cuglovy+ZpYvGi0nE/rVAWCyFtPzt0nyfWK1l2by4TX0n0k8S3Nn8l3qOAC6O2uWT+HLWI3Aiou8NuJnU/rh3o7isRCNA+NK11aubLQ3HEE8Q4P8s8JxeXi4LVE8UZL7jNPTwRSoxeeZeZMfpGb1hyGZxH7CpBspF1XTJQ/E88ltOP/LnnHdRJS8nwA6r2BoqXPMwibnX3wDrpVNRYKBL/nxjLZ52rJDgovlKSfjJHrACDxdqu6hklpc6YlT0pD4Yia5maeFjMjWyaQV/9JvUozXVZkKXDhao11E28tT8EWTiWbWGuUvd9LegICru1aM6h4hBm+DX6LKATLrcuNlKuYjmUncQ38ZmxVKUQwQhTf795WXxvo3maufebFABdZObQ19ick7xErOHJjJwygZlI9NYSny+mT70ZsjATY+Pm86iW+JlEz28CjV90t3yOdUYFLxLIo4m8XTUV149pcMtB7hZ9QGAN86XbvsAOmXgNa7EAzIgXAFh37+zILW6RaJ+l1Lp0QjarpkZ6ekzSAewz1196eSdaf12Sg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(186003)(2616005)(83380400001)(1076003)(426003)(2906002)(7696005)(6666004)(16526019)(47076005)(336012)(316002)(86362001)(110136005)(36756003)(40460700003)(508600001)(36860700001)(82310400005)(5660300002)(81166007)(356005)(44832011)(26005)(4326008)(70586007)(8936002)(70206006)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 01:59:22.5056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb487ae-9c4a-4382-fe2f-08da265f37c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1515
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

