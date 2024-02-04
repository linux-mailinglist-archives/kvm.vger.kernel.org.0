Return-Path: <kvm+bounces-7942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8282848B69
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 07:13:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08CDA1C216E4
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 06:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5314749C;
	Sun,  4 Feb 2024 06:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="raAk0hg7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E065B7460;
	Sun,  4 Feb 2024 06:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707027218; cv=fail; b=Dd6c1u9rnQlwibBhpw0Aq0AyEbPIXocJTfWdRAy5KtR/xu9oWkJ7KBNtmfZ6/7DlvpnAZMy7iViJ712G1uIf/sOvH4VZ+zKv57PJKXlPcCABTvmzEp2PA+UHX7rHO1o1lrmZSdXtBlQcZE30In2MbGy8OwsuKb9YazQ0QdA7COM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707027218; c=relaxed/simple;
	bh=ByZ8BP3v21BouqKjmZGNflfo+TK9zRKs+uXVcVUZLJU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h94kQxqRbaE9XBWAKrZ1/UVVpOG7fgD5GPJj5CEcu5/j2t4QMmxH9zku4tq4DpP1FOM8qbjvgGlzjtNhrGc8sW5X8dD0ni6OTe3TK9+BE69wxcerl7LbjNZHBpwdiwnGlfmRhyRL1jKmOQLoeOrUufKW9RcoAa65KOfiqwuOVrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=raAk0hg7; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuzuPRo7gMOaCKKKCBtCu1RZE/XfZ3SgtB1IU32pxwVWo655xF0UJM6iZzOrtVC+3/Pk+iWAKuKAhWzg5BOfAZsg+Jc3l99Y51l1+RC8KiSqCFhBo0IATB6VbmfGZQIB4DHtgU0JhCl5mVFQX7OgZ2PBzxtQo5Zsrpoggv+nWNPnzQdN+wHkXTiSb6y6Cg5k+gRFaaftHmrhLcpSDWgz1kMYZcZaEQbAZoclcNeaxYyTyZeEzGboTpuyqiM0LtNTI+GRxOSN+Z0VyPMFcn420f1I4dNJQAzMVqLZzF8IvZYqimi/1nbZiKgHEPrRMFEMitL7/hD2z6D/LnIhC6T6lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tOcQ3n89PK94DuMrj0kqWbgPixgTgPyrzVZuNor2Qtw=;
 b=N+Dn+3BTRMnsnoYdqdV9SM/be693Rr/yMr0ZXYcic0J49ojTH2WwmdamuiO3s7gqEcwOmRG4cxh0c3N+uTXGzBvBzYk3gmjw8e7otoK1kKz2acKZ6PaxZKQocuFSfvQQmnn2ijzX/liDewYiKnSHjx6tJJe2HH++NZMieSFYficsC44S9u6PJfxQUosFPkUHpgU98yEJ0OokMCcQgvfYkZMkgQBcgVWXq1GhNCpXs08PSj4LoZDqVs//RuBAcOGrN53XAjVVYQMz6cO/s4APR5WBGAx36BAbil6w+9TXrBQ6tx3vBAPcjF+MpTtTxdHcGKOhkmh8i1wAfJuh0CEc9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOcQ3n89PK94DuMrj0kqWbgPixgTgPyrzVZuNor2Qtw=;
 b=raAk0hg72TzqIPOHBVAv2bzWgfBixWbAfiu8t07PmumDRUXYA46Nxx84e6y4D8H/JZmyh72gldcD7osMiszCUFT4EKwn4297SNSE9kKqBGzxTws+8LljsEXd/T+DITJ/PInQ6+xwn6lJZnyr7AT77VMbO81SB9nIuaCWwOmYVnU=
Received: from SN1PR12CA0087.namprd12.prod.outlook.com (2603:10b6:802:21::22)
 by SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.13; Sun, 4 Feb
 2024 06:13:33 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:802:21:cafe::86) by SN1PR12CA0087.outlook.office365.com
 (2603:10b6:802:21::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.31 via Frontend
 Transport; Sun, 4 Feb 2024 06:13:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7249.19 via Frontend Transport; Sun, 4 Feb 2024 06:13:33 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sun, 4 Feb
 2024 00:13:32 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Sat, 3 Feb
 2024 22:13:32 -0800
Received: from emily-Z10PA-U8-Series.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.34
 via Frontend Transport; Sun, 4 Feb 2024 00:13:30 -0600
From: Emily Deng <Emily.Deng@amd.com>
To: <amd-gfx@lists.freedesktop.org>, <bhelgaas@google.com>,
	<alex.williamson@redhat.com>, <linux-pci@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: Emily Deng <Emily.Deng@amd.com>
Subject: [PATCH] PCI: Add vf reset notification for pf
Date: Sun, 4 Feb 2024 14:12:57 +0800
Message-ID: <20240204061257.1408243-1-Emily.Deng@amd.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|SA1PR12MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: 893b5e49-c479-42d9-a45e-08dc25486a4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8DvhlD1tDLYzGOkHKPLmmpbNlI42K7oDJx4RyOEHbpRDkQlM1BJ4vtCK8rKrAVPl1ma73hXk3as9bq6JWEfCf4n8Ms3yKq2e82bsyPKQu0mUVng/7JKGykB4A/e9OfWXDBxCoTQx3G7F9AC0wAqdZS/KoygNFnTVdJN/Ub8FMLUEk9+jzqWtBFqtxON03NeSMRJ30mozRGeEqpoyab4hMzb2UV+jcrOvXwbmDd7DKI/D1hjE+UrQahR5260PiO6y7xV+M8Esw4VjeTNlBkqsm5PtSsrJag8Y5mARpGeunrPhWfyh13zHdyUs5uOkJM1LaoKQXT00AZ/V1oWRS+93qBq4qgMPEh86E2ZigFJ7DhbGl02xzL49MCviFVscC4Nrcabxyv1rnsr8eJqiUiY0LX0Qxie8eHxv/CJfc5NV3mQThADy3+aj2EU25eUmCLpqcI5wNa+hccpidoTymcRT1xWve7sl1aAOPHALNd5VzXbN/Sn99VkC1ijuAjDsiblYQO+W4Iw9kOfMwTW3Qv1oRq+oO7ffChw68YqvHvcRo4WkObZ5KYwKfDzrUM6zjKuHlP96mjBFVmofY/q7RKn0R/gJs8KWheMb9bcV5WlvnmuOCtWAp5PwpR7bhP1hyqeDJaco9ta9Tio2nQiVBymRUuIBEsrseQK7wzciAvSJYqrIBd6bmlqTYdVk/7pY/V/0WKI4Ucy49JsuxuFCdFQAriC1TethpeuN+3QN8rHKL1i8IRZ2npwWJC8a4s2sWUkmtfzZ9JiNi33PfHv88yAskw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(82310400011)(1800799012)(186009)(64100799003)(451199024)(46966006)(40470700004)(36840700001)(40460700003)(40480700001)(2906002)(15650500001)(478600001)(5660300002)(8936002)(83380400001)(110136005)(47076005)(70586007)(36756003)(7696005)(316002)(4326008)(8676002)(6666004)(70206006)(426003)(336012)(41300700001)(1076003)(356005)(86362001)(82740400003)(2616005)(26005)(36860700001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2024 06:13:33.0398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 893b5e49-c479-42d9-a45e-08dc25486a4e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7199

When a vf has been reset, the pf wants to get notification to remove the vf
out of schedule.

Solution:
Add the callback function in pci_driver sriov_vf_reset_notification. When
vf reset happens, then call this callback function.

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
---
 drivers/pci/pci.c   | 8 ++++++++
 include/linux/pci.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 60230da957e0..aca937b05531 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4780,6 +4780,14 @@ EXPORT_SYMBOL_GPL(pcie_flr);
  */
 int pcie_reset_flr(struct pci_dev *dev, bool probe)
 {
+	struct pci_dev *pf_dev;
+
+	if (dev->is_virtfn) {
+		pf_dev = dev->physfn;
+		if (pf_dev->driver->sriov_vf_reset_notification)
+			pf_dev->driver->sriov_vf_reset_notification(pf_dev, dev);
+	}
+
 	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
 		return -ENOTTY;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c69a2cc1f412..4fa31d9b0aa7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -926,6 +926,7 @@ struct pci_driver {
 	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
 	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
 	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
+	void  (*sriov_vf_reset_notification)(struct pci_dev *pf, struct pci_dev *vf);
 	const struct pci_error_handlers *err_handler;
 	const struct attribute_group **groups;
 	const struct attribute_group **dev_groups;
-- 
2.36.1


