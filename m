Return-Path: <kvm+bounces-7963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 320EA84943F
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EBDFB22BCF
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 07:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F45101C5;
	Mon,  5 Feb 2024 07:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a2hvI48m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4C9C148;
	Mon,  5 Feb 2024 07:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707117354; cv=fail; b=hYHkEegNp06BNonOjZq0WHQGPH3Rou8ceeQ8lX7jvwdCJuW3hHknG6hbsFcJ2HwlfMkotGwVZD8yBD2W9UP8ue6NW09qFngfU6gXn//DfqNIH/qKGZRDxDlbikxgjRqxIZJaoam0YUK0DMrc35RcpfKwlqd5Oibb339zhmmhO7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707117354; c=relaxed/simple;
	bh=3L+FOPsYwtTvOMeNpENsatgn7x0UpbGEa4ghrigY1/4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=It4aogNMzemdggDnBbPvrzh/4KbAgM5zLNbpnARdqJZ8umU4ISUkdOuWb8ZFNLqiE4fxhE+Gf2YOEk4BybFgOIvnHWavqrPEDm4L+aspyrmOX0tR6HDa83hq950u3+HJDQltsALXwccgoOiJXZZCE6ZyP/mJMtwbsqA3fU3cZ+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a2hvI48m; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZbkuPybk+Fib++wVCKQhFCXn214/uw4l3auTjktdbMjlLJa0mf5ObBwGMfSHpM11C9GXHw1dZZ2hLV8yhSY17+Ts1C/arFZ0yJukWwmacHqyXzmC++jv7YVAgHHQvq9IqnjU7DtgLYfjZ4FLpmq/FnDemKL69mZy54BAEuvDyzX1BQdXnMqFcxnCBdvVNvZfjouRg+1RjMvVDKGgOVpI3HLDI7sIChrwP9ZS5usvqLSdhbfgGOhpZ43//z3uBHRAMtV6DlKGwQXj21uGefsdB+hhDk+3I6gVMQX5Mhe9EQPGfmVDoCNX7imA6Q4QJh0w3LrGfE1htSEl4TmLsWHUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDZoyxV0PBYEGXzdw06CQ7HWzz1npsZS2UYPoIw1f/o=;
 b=Hjt/T8U0NGmqLBfSDHnjIX9dnhBf9N2GNVLqyTGUb7sey/4TSo5/JEjCRRXYSOpz7Wt7kvbNlmqhYrtY+eWKX67DGCIiGdEBrK2AY8tADDgzDUWVVJjlBX8wludrkbiCvrVenm8keMixyFyUHNqg7oVggW80NhVNuGaZOVMECHBBoZ0C+WAyfK3JtxLwuy5ZKlKfF/dCH+7O3vChIu0be3rgZZUtbfFWEFVRJPBZoScGP+VIoUQw/fTGMY+UZwX3WoN3pEhsIjxDBYY6zMSa0UtWMfc1vSs/QEj2wOjktxF5ows2HYsXkMT+8MhoXhDBHiltm4GdNRW3fBqvrdi45Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDZoyxV0PBYEGXzdw06CQ7HWzz1npsZS2UYPoIw1f/o=;
 b=a2hvI48masqBA+ZjrwS9EedJpzcqRyNJpISnGL50Dlh8G3+VtZ+OtQuHKU17b5UHE0prBHC3xz0kwE61CJcuOTq24TycFtglxGq4k0eCTv/8fBV3xnjIs9aCJKJfyIcvZz5EJRV0rYpXBW5syIRftp6+iQD+hZC6k86vuhUgLhE=
Received: from BN9PR03CA0053.namprd03.prod.outlook.com (2603:10b6:408:fb::28)
 by SJ2PR12MB7992.namprd12.prod.outlook.com (2603:10b6:a03:4c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Mon, 5 Feb
 2024 07:15:49 +0000
Received: from BN2PEPF000044A7.namprd04.prod.outlook.com
 (2603:10b6:408:fb:cafe::d2) by BN9PR03CA0053.outlook.office365.com
 (2603:10b6:408:fb::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34 via Frontend
 Transport; Mon, 5 Feb 2024 07:15:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A7.mail.protection.outlook.com (10.167.243.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 07:15:49 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Mon, 5 Feb
 2024 01:15:49 -0600
Received: from emily-Z10PA-U8-Series.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.34
 via Frontend Transport; Mon, 5 Feb 2024 01:15:46 -0600
From: Emily Deng <Emily.Deng@amd.com>
To: <bhelgaas@google.com>, <alex.williamson@redhat.com>,
	<linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <Jerry.Jiang@amd.com>, <Andy.Zhang@amd.com>, <HaiJun.Chang@amd.com>,
	<Monk.Liu@amd.com>, <Horace.Chen@amd.com>, <ZhenGuo.Yin@amd.com>, Emily Deng
	<Emily.Deng@amd.com>
Subject: [PATCH 1/2] PCI: Add VF reset notification to PF's VFIO user mode driver
Date: Mon, 5 Feb 2024 15:15:37 +0800
Message-ID: <20240205071538.2665628-1-Emily.Deng@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A7:EE_|SJ2PR12MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c238bb4-fd5b-43a6-8226-08dc261a47da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AWttwe5zmuO/kJ9UV+E3LKMPN4ivsIBvEP/LfUa1PyKEJ7b05VBZfNyB9oz4jBhtZvPImVl/KMkhMvwiop9FMEpejhWFXeq8r5wJA4iazVn8Bk5/B+y5Wn+nTA33HAte6b7gBkkK0FiOX1YjIso0l/prfdr/7kAVB24UIPQ5TAzf1Ly1XVUPyc7mGASq9OU5giWGnUCwKen6KaaaJ6qekicuuMGcH5cbUS7npIMLd+kDgYBdZAYNH49Xf6eBytz4FospoBWHu+AiIWeWOxqylvIkFnkcEWhmfNvuIYHSJBZVRyjwFqiB+xgWtCob12JGyWzGUDfnkOLZeGZhvl4+Z2DG1H2J8BwB35GJZ5LoMvgIH10A/EwDm7cMcwyLxACYXwmkXVPnDjPPl4T2dvh5vbCMajpKl4IyPgrPrxhEu876VUSnf+baArWH2n06htMXmkcrEa4ZFWr5DpCrAZdMhJywYX+/1fuSECga1bmBECI8QQDad7X/rPoxW6HL/P8fU/mWjGNLKvTXmpgEPafQbKOHCgY3nHKfvv0Y9CmXxd/Cs7CBQn7J40fbER9FednlxpY24OTvRlshMGQ4kq4e7ZukPe/quHqALs/X3u3lMcAeLTQKvG26e9bQ/80ol6k0bNa75TFd3XaQ6dpimtlSylW5TOuhSEqdNdwDw1Oe/6tszsWTDsogVzQNLKjdMgkdV09VueujUR5I7hgiu8M2b7NwUfJlPEJZeTMSMEi0LFJF2u1QIDuHwvJIbj2/qs6mExVyDzrBT04Hn0lqzxBnvw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(396003)(39860400002)(230922051799003)(82310400011)(64100799003)(186009)(1800799012)(451199024)(46966006)(36840700001)(40470700004)(41300700001)(40480700001)(40460700003)(86362001)(478600001)(36756003)(426003)(336012)(1076003)(2616005)(81166007)(82740400003)(47076005)(356005)(26005)(83380400001)(2906002)(316002)(5660300002)(70206006)(54906003)(7696005)(6666004)(36860700001)(8676002)(4326008)(8936002)(70586007)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 07:15:49.5806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c238bb4-fd5b-43a6-8226-08dc261a47da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7992

VF doesn't have the ability to reset itself completely which will cause the
hardware in unstable state. So notify PF driver when the VF has been reset
to let the PF resets the VF completely, and remove the VF out of schedule.

How to implement this?
Add the reset callback function in pci_driver

Implement the callback functin in VFIO_PCI driver.

Add the VF RESET IRQ for user mode driver to let the user mode driver
know the VF has been reset.

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


