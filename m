Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0484C62DD
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 07:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiB1GT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 01:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiB1GT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 01:19:58 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028BD220DB
        for <kvm@vger.kernel.org>; Sun, 27 Feb 2022 22:19:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XItw2ykubkeUwM79KIGuiKxDFaMxWScLc6y4B5UgAok+5gxhn59+G7SeacUPf/4gv0HsEdCnQCDh6ztfFTakeCXlv3PorWujN7TZ36IyrCkF7xiAZXm9UpZYUvhNe7xs0rZYS+DEuzbi5mHvUM0u+RNlQyd8ELpe9T905XAXP7OdALgT+dqSadTmajJNbLi9JFTzVL9ta5HG88D7XI8iXsOMlQUVPh1LH4z3iD0b6rHCzC/f+QU6kfmcmviVbKGEBuUsoO9QLrnmN9v1GiwD+fAZfubrqAuenrVgt//7SlauOKx6MaV15WUF1SeMxsC8KAc2dxtrI0w54pc6PVGTQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zz8SnjWcHBOJjum7s8hIY2z4hKBwmysXEdBaGF2IT5I=;
 b=HzFd6pCw8OStyfK8Pxb/N/F+kgLVNSpCUU827NxzNk/RkEZauB7eqQQPDKp8oKY4w5mrJuSAcklhyz0XCOlZjYOOsMvyJK7bKvcfuleLhp+qSU/bY91tVAV6q/Ip3p8cpruymYKcIrEYv85FEDtfE0nDUAJ6qMwG5VVp0OFyHDBmuZBJh9SJxSKWO5KsoJ7eduYxvP+lXdviz2k+Ey3y7DF49rvDOY1P786pUAGJ3vnUB/Y13s6TSH6Qs05emH2Q8+omSbXpIkQzZm7l0CII4UB1mfJLEE1nnX6vdRfLvTQ+D7fsC3NQUUFsaUCvWhihFPTTELblpLP/1nHy9C3BRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zz8SnjWcHBOJjum7s8hIY2z4hKBwmysXEdBaGF2IT5I=;
 b=qHwIIClV8lwSEYsEqEEo8neCzsRtvTvYZs2w3zNkjufLVkyrZWKHrJsvIqHqwCDT4GTFlcljcC7ddxesyqnnS2NrpRJ5hnOCHxzILWuPeoj0fkfPKdtLKJSeRaxUKnTtp9B1JnCWkT/330OiKPvmGMevs4TkT6KHH3XkQC/SoN4=
Received: from BN8PR16CA0011.namprd16.prod.outlook.com (2603:10b6:408:4c::24)
 by MN0PR12MB5932.namprd12.prod.outlook.com (2603:10b6:208:37f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 06:19:18 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::4) by BN8PR16CA0011.outlook.office365.com
 (2603:10b6:408:4c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25 via Frontend
 Transport; Mon, 28 Feb 2022 06:19:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Mon, 28 Feb 2022 06:19:18 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 28 Feb
 2022 00:19:15 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH 3/3] x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
Date:   Mon, 28 Feb 2022 06:17:37 +0000
Message-ID: <20220228061737.22233-4-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 29095a8a-1f9f-4e02-71cb-08d9fa824059
X-MS-TrafficTypeDiagnostic: MN0PR12MB5932:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5932CFD32CBBF212F6B56C2DFD019@MN0PR12MB5932.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0o6NFYfn1s+NfPTf3WZUARqFHhrzaw/yyC0mlDMS7IkhnJ8jesrR0LuTgeDQ2UY+qCJ+gRp/4j34xTchE5SCrQKYWrXQuI+oWNmJ0R1lz6I/KkZBKQn1tNg9x6KCRhtBkYp2SiZgWmZEwnbq45K632XSV8v+RZxeDE6OUiXw1IhVS2UCVcQhJMLakraWKE9byH2pJAZEAN/xqYe7DRMXqzoIMJm1ip8YPV6TNwtLFsMTvJfzx+A4H2Go9VpgWnr2OhtaGb0pN3a1ALoC8B07Ao+yvf/oenbr+GFRBEHoB+H05gNQ5PhsBmo9DWfHZ9ihhGr4K5nl8fXWgbfFYochYq6QK6Rqmjrt67ZNLj77riBnnyhVUQD6yUZjY2LrpWYnS8ROsL9rTEJl7qIQRi2/YzOmodQuOr1FwbrsXX5TyJuJItKY/E6bgdZ8WlEeZzhDWODkMT6owAqRLNOcRM0Ku3i2snlgrH7rs+PUiViOlXuNAjsM0uaNys/Otc3tV8jbWyR0f1QDGwFnj4XhoFd3LtT+rKvnkHoHT1coy97P46/K+NsOutuNWc13LhK1K6RrWWDAcxqI13IdYqWRqFFM31DwqxPnp7yay70hZUDhIRdBmr0LXYkkamrPp4cBw3Vaavrgpnw8wpIm4SMLRvbx7yvNsf1GYyjvpubI0iuAqBhaJUsHLc0zF+6ApWn+AceyanECcjkeZgKCn+GNRXvoHA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(86362001)(70586007)(70206006)(4326008)(8676002)(426003)(1076003)(2616005)(336012)(186003)(26005)(16526019)(36756003)(6666004)(508600001)(110136005)(54906003)(356005)(81166007)(82310400004)(316002)(7696005)(36860700001)(40460700003)(47076005)(8936002)(5660300002)(44832011)(2906002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 06:19:18.1150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29095a8a-1f9f-4e02-71cb-08d9fa824059
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5932
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

