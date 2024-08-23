Return-Path: <kvm+bounces-24899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83DB595CDC0
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B2BC281214
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC26F186E3F;
	Fri, 23 Aug 2024 13:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UFaw+ndn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DA9186614;
	Fri, 23 Aug 2024 13:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419678; cv=fail; b=faPOZUsmmQE76cbm8eCSTULDISrH6p5XD9nrgrCOrwfzAiB3GUB4CRKA5Gztr/aTOisZfH91BvD/8+5e5qPEfd23h0B/LDAKSLHjqYIbQyWlWl6n14GJQgb+z3rvUjOj4UQxW1DsyAhnD80zo7Ubf3O1mKXQRL1QEyI7ZIrWOvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419678; c=relaxed/simple;
	bh=uBnDgM8215WmATGMshEwRfo66WmXlagZkuONWY37IoY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9cyqWl37i4beHEvSgu42WfUeIgK7ft/lbhvzqwirEK2QgVeebBbdQdJa8M+RCkVTSjPwoxpccO53zs9vtcpiePnjtHMVONesVttXiWybv5TdlTsoIBtAnT3Iu9SQ6G+G/xNOf/aKaacy+J1k9RFmduDy1NMbWN7mmjDjnznMLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UFaw+ndn; arc=fail smtp.client-ip=40.107.243.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wWyxdrhe+kYZbDLtazCS1GnIcEHbIOgsKaWZqgy0ndE+GfDEPK2aOqCmKbU2dkMXgmOcMsX5JFivzbmDGxtpQHw5oCN5X5+am6GGFBNihozRRQbHrphGU6qtJl/0uMsZRdnXTnBKM/8UtJIZd/actwJzmshWXT5H8RrjBY1XHYQsUnY0pfKvrkdXzUvl8UoCcNOwq6B7qmbw9bhd3p5F/2D3NQGSHqUBcdmBYcBzKB+3cVsZCHj6DQYRU30g8AkKeEC2UIozuSeeHRjal/W6uvCXOMTpCq14cqLkY2sh3YR2VFDAZVz2TjhzZTxQ/iMgy1hMEKfWUYJv5Anh3ENTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/U83MAo6qu+gFvOyK1ForNSdQEjcMEug6mSTsWwnhw=;
 b=D/4zDhtfkL5K1FIYtCV9+Kn0Td6vx5hU4riXEUosBXoQOTv4ThuZAx43xvLEtYwExRHSbgH/gQSF5gtT3L3jlClLlXMQ5eDcIxx+gYGNISnBvIr4wnc40KK4UxaivkZO1psz8stscDg8C7lzZwmN/vWm59KginbdE+pxyhyfAk3nYjQyKnfjPwOj9NFfJ996Um2KsNgeh2dOQ+M8lVeo0RyxVXhTuG41TSuOLZg/MsSLnCONkEFH2fVazhj/0Tk2x5TOT7J/UPx53GLEfGcKOlTYYEKI36IHe4JLZnyrJIb6yzuI+jpZDO31na7UhAF+ZzXiosoLvyMbdDYTgi2MZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/U83MAo6qu+gFvOyK1ForNSdQEjcMEug6mSTsWwnhw=;
 b=UFaw+ndnRZ9yicgsY195/OalIKhJ5Np+6DyTx0GLhoJPpE7mldwmjFSycg9Ujjd+H//ulQHZD7iA2QSEUsqO1PX83EaZ+E/qXhreyFx9gjAZaO7uqu765vZKoEH4Wm4GrfafqEesVQW7gJspV0FIQCPs7dhSCCoeXu6Lp9Xo8Pg=
Received: from CH2PR15CA0016.namprd15.prod.outlook.com (2603:10b6:610:51::26)
 by MW4PR12MB5668.namprd12.prod.outlook.com (2603:10b6:303:16b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Fri, 23 Aug
 2024 13:27:54 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:610:51:cafe::19) by CH2PR15CA0016.outlook.office365.com
 (2603:10b6:610:51::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:27:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:27:53 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:27:48 -0500
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
Subject: [RFC PATCH 02/21] pci/doe: Define protocol types and make those public
Date: Fri, 23 Aug 2024 23:21:16 +1000
Message-ID: <20240823132137.336874-3-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|MW4PR12MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a86893d-d09e-4772-458f-08dcc37764e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sdGg+ThU7A0fYLASmEWV8jvkLYI3RBz0b8mKoSsekr6wOjKS0VRGh2oqy3VJ?=
 =?us-ascii?Q?GA/kR21X/8+TR8gIaDMhMwfQ4US2Fa1lo+0P6ilDXtppek6bia+8q2y8v4xS?=
 =?us-ascii?Q?InhUajjPoMgDIwJ0GOEb1A/IutsCkGILSKjH5RXmrR8lVEI2lzt8wnHOPK47?=
 =?us-ascii?Q?XDhoS7iWsc99KudLPRM/U/TQHHLKSvWoZiUt53/Pbr1RGpadPoqSjFt/AFwv?=
 =?us-ascii?Q?BcwQkecrlo22r4pE8NklSMFLAUSNeuW6P+m02CCujG4EbYQG75mbD5xmCFhr?=
 =?us-ascii?Q?bqRcrl5Q6ZiilQKXWr1wuj2FBwAhO0dH+1OBNpdjpOAwyoO5fXL/VR0pbqEH?=
 =?us-ascii?Q?TQApLE2Z6wTrKDNc+B970h6q9fHZuCT1yTbaC22HDXhlFHnmtYSFbSyadHJs?=
 =?us-ascii?Q?jvsn2TVAmWfVBTHBiQkmhicw0pCZ14xZucvFJCmESZDtUQkVUnzFWJxOOHsO?=
 =?us-ascii?Q?ejk7WIam5J/96FI1WU2yS1KJSZPpFHP+Eevn4DNaWRjs0BNM+8na9pfQzbht?=
 =?us-ascii?Q?xUba6+VTZqyPkybmFjF5xJfRLwCSnfmfU/gJLlZ/m5mteg5tdkWw/SYsIwsE?=
 =?us-ascii?Q?zq9LrHfEq7v+Qcp1KAx4BBwrl8IPldQz+2rNTEmlx769NQWnqgnAfnJcrghj?=
 =?us-ascii?Q?ODdM1u/o3lCtcwUpPo8SYE3R0BReIEKVtJ3ZUYiipMj4Kiks5Vj5YC5Dt/Bf?=
 =?us-ascii?Q?gQY887d/vaYBAF0S3dOmQoCg7R9HyTJDE109+qTOIJNMnXIYUdJFZrnHOCI+?=
 =?us-ascii?Q?iLE5uURZxG0CHsofdEUsafjgNCwSQEUDwqDhhzmGU02uVWMSxj8a5xTebLki?=
 =?us-ascii?Q?bhnpAsNN1KC9tVdauCnEgwm/nVQem9RCC4S+uI/qBudWYFdx4PSaC2UWO3Qj?=
 =?us-ascii?Q?gM6lVS6UdZe1WkL3m8KPKznSQ0FRin1iTUidpJuQSRioOPKyRu/IczbUgpZd?=
 =?us-ascii?Q?U17sHglbH4VdS1Iqez2O+2/KdGWFSMdLNcDINrpJmai1DILeQ2B0FbwCwbVz?=
 =?us-ascii?Q?uAcNLlhoJygwPfM/R02QIMQTeLZxrHaaoOrcy9P9n+AHxhoOFMmc2CNkS5wz?=
 =?us-ascii?Q?q7u6xuOPQvv/tyzI2Xu0Eh0NKBKzt9iwEAelqeGtRhEOdE/jWschzjJapmx8?=
 =?us-ascii?Q?7wHvqT7Af//GmQrPeL+pW4SGrjy/2Z1euxYH+daMztjffKRt8f/8GVjGGfas?=
 =?us-ascii?Q?Dp7251BimBnFLEpNQrI1jBUVcpsX4mcjcsndHODPedXq98aNH9Oay4YYL4ga?=
 =?us-ascii?Q?uMzijSqTrl8Bi8xA+yAPak2Q75eyj8EdJklv5e+Htlh3ga91RuDANamGJ5RV?=
 =?us-ascii?Q?2duSreGEnZQ1XykZUjpSg+QNsOBdxT0yOrMMlyIzkKpjV5J8++9YQg/xMiWx?=
 =?us-ascii?Q?UWXiEQp9UTjmHmPduzKK7Veznt1tVkWN+eplt97Cu3BnkKwzbiivyy6fDLcz?=
 =?us-ascii?Q?qzzUyu10OghrBKwmoUdcV/wwSf1z0bGP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:27:53.9618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a86893d-d09e-4772-458f-08dcc37764e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5668

Already public pci_doe() takes a protocol type argument.
PCIe 6.0 defines three, define them in a header for use with pci_doe().

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/pci-doe.h | 4 ++++
 drivers/pci/doe.c       | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/pci-doe.h b/include/linux/pci-doe.h
index 0d3d7656c456..82e393ba5465 100644
--- a/include/linux/pci-doe.h
+++ b/include/linux/pci-doe.h
@@ -13,6 +13,10 @@
 #ifndef LINUX_PCI_DOE_H
 #define LINUX_PCI_DOE_H
 
+#define PCI_DOE_PROTOCOL_DISCOVERY		0
+#define PCI_DOE_PROTOCOL_CMA_SPDM		1
+#define PCI_DOE_PROTOCOL_SECURED_CMA_SPDM	2
+
 struct pci_doe_mb;
 
 /* Max data object length is 2^18 dwords (including 2 dwords for header) */
diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index 0f94c4ed719e..30ba91f49b81 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -22,8 +22,6 @@
 
 #include "pci.h"
 
-#define PCI_DOE_PROTOCOL_DISCOVERY 0
-
 /* Timeout of 1 second from 6.30.2 Operation, PCI Spec r6.0 */
 #define PCI_DOE_TIMEOUT HZ
 #define PCI_DOE_POLL_INTERVAL	(PCI_DOE_TIMEOUT / 128)
-- 
2.45.2


