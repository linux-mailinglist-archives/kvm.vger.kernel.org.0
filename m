Return-Path: <kvm+bounces-2341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1B97F5569
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 01:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7597B2101D
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 00:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7BF1857;
	Thu, 23 Nov 2023 00:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a6c6bUiG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207881B5;
	Wed, 22 Nov 2023 16:36:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRUq60LB4Ue8BxujOvyDL471XF/U4364CxEM3sFMmrLXcDSKLwX8eCG8InE2WnPpj5e7ii77PXECdXlpQkO61JXCb4HX4OJogTXDBlNO1UZJZxaVRiN8TdweTgE83TKqp6d9WCC8mNLk7wvGovISXN8vtI0qL0v2GeI4AA9dx64tdlMFmBdr/9emKY3OqdrQBj0ipNWTLnxcPPRVOOtDf3Nxgxueu/bruVQbcTJBfWWyUjLVzGL5CU9Sb4dEc/WEfTuiSMC0pGMOvzGKoKuOy0MqddWu1+TtH5sW//sskc9/T7BbZKMud9NTuzcYk2MhOUKQTlVSlNV4g7WXG4F9hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKyHN62MM5zhnAXnGG0KI+SaesGrJGK3kKJ8ooZn3cE=;
 b=FEg2+isqcKdtKVrsfGFPbbMujjo/ebQkfTa+ZiMAfSg8veIZ+by9bKVtm+Zj5+9SP2GnSOi7nqHQiUKg6+PWFVU779L4EI9QsVr+YkCmWMspuNvva4s5FHFawd9dMQhPuii6zQvc9pBh4ukZTxlCGWbPeMumywqsXZPkSJcInm2/vD/QDqsH7mafP9D1ahp9URTMWTWox4yqCU5rH5r9bb5+aZNRw0+8OHewEx0sIwuAjL9RvGnq3LReJ//jdQ+RvQWksMKOa3GY7TZ2BEGLCOTZIXKu9J0CILnVAbZJZnfu/pRw3ho1PHsyGPUsFwqtJGKbZXgKWIfbpvqNoCExyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKyHN62MM5zhnAXnGG0KI+SaesGrJGK3kKJ8ooZn3cE=;
 b=a6c6bUiGYU9le44wHmZeTvZI6qIDQlOj+f1HtA0NnMIuiDe57ODNpmHXL4dlgZi1smKjrP2K/5D48rqKvaXcyHmIbrl+K2fLzub5DUlxlK5j75U1wUFmQg+B9z/fdLf3Oe7Ux4MRMFkdRNo3QlJfsFEiJi1ieaXbeFJP3xIrkbj610XbBNyQ2/lTnv2mgvLclfh1NjaDjYwtpzQP6pM68JrQfKyIgw7Rwvbc2xnj4szVeoOF8bELQSHm54PDGj+jK+aaFepHFZ6bRCqIv9Zb/o6DYP/4T4i4yeDd0EhpFM49ejLxObIF2kcLuVzuNMoWtt0bT8yYmaDZor6Hh2aT0A==
Received: from SN7PR04CA0192.namprd04.prod.outlook.com (2603:10b6:806:126::17)
 by MN2PR12MB4239.namprd12.prod.outlook.com (2603:10b6:208:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.19; Thu, 23 Nov
 2023 00:36:09 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:806:126:cafe::c6) by SN7PR04CA0192.outlook.office365.com
 (2603:10b6:806:126::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.20 via Frontend
 Transport; Thu, 23 Nov 2023 00:36:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.12 via Frontend Transport; Thu, 23 Nov 2023 00:36:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 22 Nov
 2023 16:35:53 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 22 Nov
 2023 16:35:53 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 22 Nov 2023 16:35:44 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<naoya.horiguchi@nec.com>, <akpm@linux-foundation.org>,
	<tony.luck@intel.com>, <bp@alien8.de>, <linmiaohe@huawei.com>,
	<rafael@kernel.org>, <lenb@kernel.org>, <james.morse@arm.com>,
	<shiju.jose@huawei.com>, <bhelgaas@google.com>, <pabeni@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <anuaggarwal@nvidia.com>, <jhubbard@nvidia.com>,
	<danw@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>
Subject: [PATCH v2 3/4] mm: Change ghes code to allow poison of non-struct pfn
Date: Thu, 23 Nov 2023 06:05:11 +0530
Message-ID: <20231123003513.24292-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231123003513.24292-1-ankita@nvidia.com>
References: <20231123003513.24292-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|MN2PR12MB4239:EE_
X-MS-Office365-Filtering-Correlation-Id: b765f315-9dc2-4d0a-7f72-08dbebbc2f8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WrtQ1grfptBOa3bptbQQXk6KBrMPNG+Y04JYbdL9ZhZ8CgSD5EN7e3Dnp1xjPN4FyZDo3/DXm2/pFX+2auUmiiMB1tKA3xXsIwmcGJB47ZEHJ32jJisBuiLktz+e4EGncSKGO2/Pr5toc430ZAXjcMOtXUX60vTYRLSOoE4GzpxyXx982//yuLTwJvx8J+38FfKzkNHYwdCBIdf38UIsu0M2sPapBINeb2tCFj3Yg1Vdkzrh4M35mdEEZ87IxWSHNT7P1gQ9m1SCIsBJqlRjtaLlT18pa46rqUcOqJcbY94XSVu7M7m+M6qx7LPitX5Oy6AvGEM1Hdd3uOjgq4Npz1+psCZegQcL7BppzAGrXb16oOJ0l7z+IOviNj7q84X3r9qu9wlSiz6YNkvsCAicR3OweZuuJOSKUGPvAitKJkWEYcK8Lt6UrK0OdVfBUSmnC2gew+HuE5zAreHfQABRrhSWWHTSmL13ykY9uTM1qLT2zqaLSWKuSDs0CxX4Xa/yAyCqlKTaRgxg/uY6wh5UuxzTfGs3xGbuliAht0wH8Z9lJDa+Lx6nVTOJs+izhQLKp7OtMSADlD7m4FMf8yR1ONlIzx68nDZ3FnA/PA4MZITzYUQaBx6D8SGSIZkS7iRK+rrUSJeP0FmoPwdqACqPAYNzNN/+iflYOmnqhGiFx/pPT8cMjVNQQMZf6OnBizitsf1gHqULYMcor7WaeP4iJhkdElH/PDQwXd6dZRAeIokJNxI05cHLwBusYrh8WBeq
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(451199024)(82310400011)(186009)(64100799003)(1800799012)(46966006)(40470700004)(36840700001)(2616005)(26005)(1076003)(336012)(478600001)(6666004)(47076005)(36860700001)(426003)(7416002)(7696005)(2906002)(2876002)(5660300002)(41300700001)(110136005)(70206006)(70586007)(8936002)(316002)(8676002)(4326008)(54906003)(40460700003)(356005)(82740400003)(7636003)(83380400001)(921008)(86362001)(36756003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2023 00:36:08.5635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b765f315-9dc2-4d0a-7f72-08dbebbc2f8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4239

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
index 63ad0541db38..0ca6ab9fccbe 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -471,20 +471,10 @@ static void ghes_kick_task_work(struct callback_head *head)
 
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


