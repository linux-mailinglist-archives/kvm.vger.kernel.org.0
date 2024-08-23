Return-Path: <kvm+bounces-24916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8E995CDFB
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FCBA1C2401C
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024851865E9;
	Fri, 23 Aug 2024 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W5kh+B2d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B9114AD3E;
	Fri, 23 Aug 2024 13:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419969; cv=fail; b=mg0OrFj9zaLIbgdh7k32owCAacaDEx6dp1i9w3ZX+OgT6PeTbEeDbv+xhFP98h04wNCrfPh+MTI4+zCytK7yhABCqsmTgKV4rLubjJtqrJT2pUQmBwf+N/yPT53YnQLoBeZAAoCfo2iLnuWcsPB4gymraLbnb+72bpJuDMLgdPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419969; c=relaxed/simple;
	bh=h5jilxNxjUAvzQbKHGFl3/s8zPKF8EiUiGDGU+FHZ78=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poVTdKCv4t81zYcp8u9slx2vLIEaKeLPg5NShuOZjgR7nitzdtoSWHaG0vznjZyurTnB2nIEzd/M/XWopc+0uVwZhtq/bxi8XS/RRlH2b4x2av4xuqrcQtxMmT4BDeQnJ5t67kynNE8G/rUOREzDPwaCqKvDYci9jFYkgnXmvbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W5kh+B2d; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbK44Q6NT9ute07V3GVsO01SBxkVZUjCzTviS6nA9CnWqGSL6GXmRZEZoLKmvH1sim/2lmYHdLqF5q/90xc4ZvzYIAgNDecH65868CI9uhInZkBAKBC6aE6CBwQOP844QelVm8hKALBri7JQnPDP4B4Acv8r9cfH4IgpmpUEnIZzooeaCyXrBQkhFzJzK1dt0iSRk06q0p24FSXmSkoaR5VzLKwVvdteIxRdZ1PySSnXM7wHmI2o4ZvxAK0ghdZjpb99Ohb4UngQ4v09QWPA8BwMTQDxitbZSlUyqBd1kUIaEQHvLssd+cxKtARN+oNLrRN5/Bi1GKC3wM8oY9kdRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FkuS+lYQMWLo5cUJPD7DM9GRRZt9XppWRCnA3f6CP0=;
 b=yj66peh7u7hAPYJio6lMSPz5XwSqc2g7895nT854hzoxmZzlFbuFnqQwIXSLT9cUUdXlVvB/tC2rYWFvV5LC4a1BvRAnozEEhjYwnngx6VqiAmD7iNJBem6UHzN6b+dCHEh39CxfXac5DaOO4LQdk1bDZrR1WxTX1o5zD+IV23EnhQi+80e0+DNrssc8tvYSP3ki4OdHTc0C/nAf4oL0a8MmhObXeY3f3PW0NE2LzRpc9h5XLzZU0a8V4CsP69pWutMAa4BVUi9O72M5HHlkM0VjMYe1PICMh2HFOimVM93Tw+dwDQnbqJsHAM47ww4iQsfkPGKgw2Q0ZNWkZFBnww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FkuS+lYQMWLo5cUJPD7DM9GRRZt9XppWRCnA3f6CP0=;
 b=W5kh+B2dQAzSavHFHZRQwqmdV1xDNWr/ACpdtroKUz4GJWZhR16/dBDzMUY/kkRCDDOa19gdRfNSbJ19D1BAOBO6vVRKLD+qQgCfyaFHa1YsPSqEHueZ8VWhNGBSn+A4z49BO9chIlrwod8jQAkLYkPAcOg/YIuBEOMrVjrLVTA=
Received: from PH7P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::9)
 by CH3PR12MB8878.namprd12.prod.outlook.com (2603:10b6:610:17e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Fri, 23 Aug
 2024 13:32:39 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:510:326:cafe::f8) by PH7P220CA0017.outlook.office365.com
 (2603:10b6:510:326::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:32:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:32:38 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:32:33 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 18/21] RFC: pci: Add BUS_NOTIFY_PCI_BUS_MASTER event
Date: Fri, 23 Aug 2024 23:21:32 +1000
Message-ID: <20240823132137.336874-19-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|CH3PR12MB8878:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ff882ca-f67d-43ad-11a1-08dcc3780e79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HZPBdeCAnN6XAd9P8uhXIn8PXHT3KdythKBdV4Rcl0PCK1Q4Wm4sBdCSFhoG?=
 =?us-ascii?Q?9QeRF0PRqH3+pF0D0TImnuND49ebMN5pHQa2M5mm9b+kW4pKJBO14lpG/IJc?=
 =?us-ascii?Q?xP+gsRHHcTiLecEI69JLMuogTe3q5hAaVv8Bg43C0x4sjrzEYCa93oxr6oui?=
 =?us-ascii?Q?nMB+yP1T43czcLQnQfFE5BXcvGAPCs8HrXgRF5nFF2QzBPrLldNaB/RbGDuL?=
 =?us-ascii?Q?PSDTVbv70wTXQ2WH+xBvbPeBeK1h9cyF3qiyuiL9ohCVGtxtENJ2Sp53GIOY?=
 =?us-ascii?Q?ncvakKLho2DlA1CW9E0Wu4HN167xbaasWJ52ohHGN0R2+sPOeTe3XMOn7sw3?=
 =?us-ascii?Q?jtd4xmaOoRY597aWbIhLTPhMGDreJZZrsPV/NA1z4+XpA+Q/QIoDfCkcN4Bk?=
 =?us-ascii?Q?nErtJfuwVvmdOVGxPz7+ZxC2Wd0qoYzhshEwtebNXCUX0KXcvbRcb51AX4QR?=
 =?us-ascii?Q?YxcIpJ4RavAuWlMQxPrayQzwl3Zgjx7lDxk2iIvKgk8MSPgwQRV5SxN9asnS?=
 =?us-ascii?Q?dG0mhKGb0theWPdPOPBT3yFOtwEbiIacFY60TyOQAZuRhuDcJhghWWGvt1i6?=
 =?us-ascii?Q?T3g7k8mxkGfALFCZCIfmJk+8cWCWxevGrj1NMzuI9rZWM+aVjK/6B2oBZdaE?=
 =?us-ascii?Q?dclfmKo9e/yhEZVm2oOWFn7Y9En37pjAy+NHmnhWSCSe++1dRjYoKwuSpY6j?=
 =?us-ascii?Q?FY1h+5546vGnH15Yv8EhFybGVwi2S+/XmzfHJ8sJbOuIkGBXCvPi6K/UMr1n?=
 =?us-ascii?Q?0KmzSrcYxIDvNbzJMt/ypjoAAd/5yEn7/U4WshN/vGbYu9P66Nhpq4OJdh9D?=
 =?us-ascii?Q?P9Eryq+l0wnnu2AKopYNjvt5uy+z8SWRiq8VKS+7XPdp3cDKhSrZSBAF70IU?=
 =?us-ascii?Q?UWrhA1UU6OeHu0T98cjos6hCGj4tOTINn2Mlu5AFJ095sRgeh1OsEV1Tjb7c?=
 =?us-ascii?Q?WoRFTqeQjfEDgDkNDfuyOWbBUnFt9UIN+0IPIEBlCG3Rry/PLxD/NHIofFA4?=
 =?us-ascii?Q?SHOjdAioolsMyJMQMcQrCdbKMXu/iTDp0ayumTbly1+CFfMwQS/0zX9aB+22?=
 =?us-ascii?Q?nKlycMNK+CMlr/2LUIEaQHbSERdONV111ucijfn9VNRiMnPOkO47L4xFU2FU?=
 =?us-ascii?Q?yJODKI273BPUE9+gUNRpAW/e8F9ni8gTwo2TJLMUzDltWZ1eyW/y4tS18NKx?=
 =?us-ascii?Q?de7dUeMvVZHDKFIA5cvFi3ipZRxpliZZ9bwjc6W9e/kmsGGdvS2UIyTwc2cV?=
 =?us-ascii?Q?3+cj3exMmqILvk3xbVbTfLuLPnIDH/+eKRmvQYBZyesWgH++Htw0I/W5uqJ4?=
 =?us-ascii?Q?C19m5/nLJIOefQ4UI+VPedbFCwoCsLe6gzSITB4+p+sgfVpPjhYn4BkGP8U5?=
 =?us-ascii?Q?Ts8hDscUrrKWWE9S5c+6FEr+Wr6qRMMERgpD5vHCOQbPLPzKu8WWR0ufmRkp?=
 =?us-ascii?Q?jvA9mJhM2u1M7KtB9bIZgWMfuM4E65lS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:32:38.4825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff882ca-f67d-43ad-11a1-08dcc3780e79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8878

TDISP allows secure MMIO access to a validated MMIO range.
The validation is done in the TSM and after that point changing
the device's Memory Space enable (MSE) or Bus Master enable (BME)
transitions the device into the error state.

For PCI device drivers which enable MSE, then BME, and then
start using the device, enabling BME is a logical point to perform
the MMIO range validation in the TSM.

Define new event for a bus. TSM is going to listen to it in the TVM
and do the validation for TEE ranges.

This does not switch MMIO to private by default though as this is
for the driver to decide (at least, for now).

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/device/bus.h | 3 +++
 drivers/pci/pci.c          | 3 +++
 drivers/virt/coco/tsm.c    | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index 807831d6bf0f..314349149cd3 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -269,8 +269,11 @@ enum bus_notifier_event {
 	BUS_NOTIFY_UNBIND_DRIVER,
 	BUS_NOTIFY_UNBOUND_DRIVER,
 	BUS_NOTIFY_DRIVER_NOT_BOUND,
+	BUS_NOTIFY_PCI_BUS_MASTER,
 };
 
+void bus_notify(struct device *dev, enum bus_notifier_event value);
+
 struct kset *bus_get_kset(const struct bus_type *bus);
 struct device *bus_get_dev_root(const struct bus_type *bus);
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 15c0bb86ab01..b8bb322d1659 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4271,6 +4271,9 @@ static void __pci_set_master(struct pci_dev *dev, bool enable)
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
 	}
 	dev->is_busmaster = enable;
+
+	if (enable && dev->dev.tdi_enabled)
+		bus_notify(&dev->dev, BUS_NOTIFY_PCI_BUS_MASTER);
 }
 
 /**
diff --git a/drivers/virt/coco/tsm.c b/drivers/virt/coco/tsm.c
index e90455a0267f..b16b5d33c80f 100644
--- a/drivers/virt/coco/tsm.c
+++ b/drivers/virt/coco/tsm.c
@@ -1193,6 +1193,10 @@ static int tsm_pci_bus_notifier(struct notifier_block *nb, unsigned long action,
 	case BUS_NOTIFY_DEL_DEVICE:
 		tsm_dev_freeice(data);
 		break;
+	case BUS_NOTIFY_PCI_BUS_MASTER:
+		/* Validating before the driver or after the driver just does not work so don't! */
+		tsm_tdi_validate(tsm_tdi_get(data), false, tsm.private_data);
+		break;
 	case BUS_NOTIFY_UNBOUND_DRIVER:
 		tsm_tdi_validate(tsm_tdi_get(data), true, tsm.private_data);
 		break;
-- 
2.45.2


