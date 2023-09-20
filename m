Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADC77A860E
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 16:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbjITODI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 10:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbjITODA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 10:03:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01110E5;
        Wed, 20 Sep 2023 07:02:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJxSk/iNQedNw6Mnfnxngnu1fVVk08fMh0Z47BfOGaFe7l3z7hHR14najhxKA7TPW+SOozua0O197QoQOq13Jj7EyxHbNT34bfY1LLeHDk14GKm08SaVI9FBc05BLDxrIr4AOm0aUcv99OghxZ063fEXZxuXlJavBOjMmqk1YqlkKi98bc9y6jBMIuSnbm59JIybqbrNq6USURhaU6vR7Y1ZRxG2CqfWc43yB/vr+YU1xgHPpWsNKnsMlF4Mpz168GAkmtAuGOjcNrd17F7RAiE97kkNxbo240qea9Yi9wS/MYx7H5DQWPgm/xGTVlAvwGAJY+WPVYKywr4Skl3ydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJPM6GxvrfU+SOFbh35kBojQcnerwuMNxRwCXwIw0ng=;
 b=mA9b60YLDiBRJerT+uMDDDxjsdQDYCZ31dUIdknam8od/h6aVRyD0ctCnru5w69M1jStKJh4/2q+kmKkDpJqoRqgjdNO5UWKwWm746XT/V6kebSQSKqMsE2Q7/UYKy5M3XKFEnFQwnmL9tNnYp6o27XQ6YCO1Cq5HUo04QnlUScdpoGTlnIU3DjpZEahvdN4lgrgd+cDoiH+spclcHMdd1LwM1SUznf8paD09ERnkqLpDjHvM06PkNhxuc5kIQLoHgrhLG83kLULe9nRXrXDAAllNYzUxnm2EAItShrs/MvK5orMuSi+N4Yd+hfB6WMjzPKN0HoY/RL+wYjDk6Eb4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJPM6GxvrfU+SOFbh35kBojQcnerwuMNxRwCXwIw0ng=;
 b=HPeXu5OptSu9mRJh0Gx3xjOL8bKgLmskWJm2uMbc31NDJa7mtIOhSslc8WvXtP5vvC++pB5YCVuQcWuvQQBYKcETd97WITMrAgy/pV04p/Ow76Z4SKDNp0U8yUrU8UeLe9Hh8umGlW5P++iOclV6PYzsZTX4VopMA9zcxUR+7SRZbqFcpddjvQHQB80rpTyKtfchyn81DRRZ63vCHpzPA4TIs05LkiU20ODzBOM9aTkMV5X1SnIBB754EBLejvP7/QrJnXlTQTL3NhWHWwapWlaUctCFZgwXBc4uRQswDiKo7AFFJQDOyJs5ky5knnOsoYKf11qcvzO4wACoW/QuWw==
Received: from DM6PR06CA0038.namprd06.prod.outlook.com (2603:10b6:5:54::15) by
 MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 20 Sep
 2023 14:02:47 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::d1) by DM6PR06CA0038.outlook.office365.com
 (2603:10b6:5:54::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.30 via Frontend
 Transport; Wed, 20 Sep 2023 14:02:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Wed, 20 Sep 2023 14:02:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:36 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:36 -0700
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 20 Sep 2023 07:02:30 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <akpm@linux-foundation.org>,
        <tony.luck@intel.com>, <bp@alien8.de>, <naoya.horiguchi@nec.com>,
        <linmiaohe@huawei.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <anuaggarwal@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v1 3/4] mm: Change ghes code to allow poison of non-struct pfn
Date:   Wed, 20 Sep 2023 19:32:09 +0530
Message-ID: <20230920140210.12663-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230920140210.12663-1-ankita@nvidia.com>
References: <20230920140210.12663-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|MN2PR12MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: 34cbfda9-142b-4468-32a1-08dbb9e24536
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d0Jy4EnczyibCEUGgEINwvZfy91ADTU5AL9s0fYez1GCX+vuYydmwPJ3dW/b3LlSfI8dnreXrYIBlv7Kow/e4O2XfhGLnzDwNh10YzuNtWrx12bt/jcSYPn+jkcPOPQ2ohfaN4hBoYvoYlmkS1uvIpX+IRi2uVU6FjYw8tIiX9xh8ftELazBGMr4IH1wMjHI/ZNZIYjl8zyqdjEwbz8//6M1LyE1QhGRaes7OtMgr1b66Ff8pRjy2WmiEu+jlNahJoLi6AHaP1KV5lGgDH86k0hZ2y95KtZdPnPg+aPHIZJiOTKG2s96jrbNOsZ5++rPWrsQpDNiPEcQtvwuUub5RzuHKMZZM5dpM9uMKBF0GmVWJ7LXQzhUMHo2ZjsnKjL2Q7vQ0pZ0vfgHwZ7BEEwMPSDXURA6oysWjhxNqMZFOHjbb01hN/dzp0EtTWsJON2ndXVPw3zCC3qGgYP8jeuXEDCxlddmvvYJB/DVgt/qxdLYL+EOEo/eyJCNum/EGtBS9X9yQmobn9a425ADhBfLxE1OWUMG9m0RhBQyQGq1SwbWiZwPFNZGsCULHHC1nA6cBldzjHetQ7pePZ26v3f51fUAMQzIw4/P2zgoQOM06M1n++xdKpQidRxEFZLymItNmI6sEpIEZ6BN/RfAg0xnnIR/Lka4fwZhtPTDn6hKpk/rR2sNBX7FipuNS6tXO3XvTXwnVuA6OseZau8iCEjOhlcbn9Fu3dyLXvYVbPylYl3w24ektRy+WaP7L2pNRQ8S
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(82310400011)(1800799009)(186009)(451199024)(36840700001)(40470700004)(46966006)(40460700003)(7696005)(6666004)(83380400001)(82740400003)(7636003)(356005)(86362001)(47076005)(36860700001)(36756003)(2616005)(336012)(1076003)(40480700001)(26005)(110136005)(316002)(70586007)(70206006)(54906003)(7416002)(41300700001)(2876002)(2906002)(5660300002)(4326008)(8676002)(426003)(8936002)(478600001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 14:02:47.6421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34cbfda9-142b-4468-32a1-08dbb9e24536
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

The GHES code allows calling of memory_failure() on the PFNs that pass the
pfn_valid() check. This contract is broken for the remapped PFNs which
fails the check and ghes_do_memory_failure() returns without triggering
memory_failure().

Update code to allow memory_failure() call on PFNs failing pfn_valid().

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/acpi/apei/ghes.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index ef59d6ea16da..6ad1e4cbc968 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -457,20 +457,10 @@ static void ghes_kick_task_work(struct callback_head *head)
 
 static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 {
-	unsigned long pfn;
-
 	if (!IS_ENABLED(CONFIG_ACPI_APEI_MEMORY_FAILURE))
 		return false;
 
-	pfn = PHYS_PFN(physical_addr);
-	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
-		pr_warn_ratelimited(FW_WARN GHES_PFX
-		"Invalid address in generic error data: %#llx\n",
-		physical_addr);
-		return false;
-	}
-
-	memory_failure_queue(pfn, flags);
+	memory_failure_queue(PHYS_PFN(physical_addr), flags);
 	return true;
 }
 
-- 
2.17.1

