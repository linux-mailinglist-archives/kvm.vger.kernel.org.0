Return-Path: <kvm+bounces-71478-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UEzyFtB4nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71478-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:57:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B078F1792CE
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1EB630BFAB1
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4826830B521;
	Mon, 23 Feb 2026 15:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WaQBtVPA"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010015.outbound.protection.outlook.com [52.101.85.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014F82F1FE3;
	Mon, 23 Feb 2026 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862140; cv=fail; b=W4gwITO/qackabxZBWFgxX9YbuG+EwV7nH+pfFbm/UboSoxdydbj8y2roquLT8x9pq9WQJjBaDZmsVzUPKv8DPASIs2Mw3gDR/lQ0l/nC3iE8JvYf5UKaw6q2qWRKzqpIErmtZbnAKmiu9aNotrWdZYyhueRBPHgrVmyhOKG4CE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862140; c=relaxed/simple;
	bh=ph5fq6sR/n1flyACgmeAbMWikJGXQTVUDDTEoJUoOAc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PU5Ncs/G6UUjg9Chc2qE6mWK6ec/qSZeZ5yaTYbJNMON4ZRhYI0TlZRCbu/mqXmal7Dab/u4VV4cazH0ts7QEuY/jtHH/darq5AskkX8kpoEIwQ7yAdu66H30tEv74pmpP/vmex+pjadbXNJ8Nrudj6YXZQuau4zuJNfMTg7VfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WaQBtVPA; arc=fail smtp.client-ip=52.101.85.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQ/dBssRASf3hY8My0pKfQP+kt0vEgEGy6fyv/IrZN/J5DrvdMOzo+WEzXQjIWWf2rjE6vxyoLRzZ6MoeJSTcvlL2cw67dd9AJX/uS36nZS1QwaeLnopqybXzlldnlo05TrIvgoaBnJnezCpWAVXnE3tr3M7AO8HyCOBAxSf0j4nakPVJc2pxnBY/8kUIgLCpADhPcoNKk7bknb+DPDZWLzjGYPnoi0VhQwA/tSAOKEAo17q6WXkU1CYGUV5+iYKP1ig7AShzVbVeSXq/UFcVWXM4u0ZBrMHVkYWFbBq3h7gTCqo25J+RzE1vyirOn1cOrISuxIrVrRx7P1Bm3kdRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9iPhUybabJYrtNLgQR6RxIiA+CT14TDEPTttbpKRYcg=;
 b=wrQkwmII29iP7umpCUGqwBBPS7U565SexDy8a0jLALskvxVaBEpe4trEyufEo7ftWGvEWpHIA0DxXjQO5ho3Zl8XBMq0PRRQC626muo8ILMxJxM/ChiReelpew2kfLz7VmcAd4/mfe37a5Pa3oyQ5Zh5y5H0ezpYgvExWAZB6abZ5yUn52bF7yYM5R5J3AL/YB+YaZE25lJT7v25bmUtYXRGs/DRlWML+RUg1RkhD5YZBlCYUih7SnHHm4caF5zvpcOWWN1E6BaBr9mVhvOuYtYDY912v6cRZAvVB5TAHVBQa0TY6Q1xNpcJi8iSz6UfL+jP99/0vxFduJ/mGnVpEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iPhUybabJYrtNLgQR6RxIiA+CT14TDEPTttbpKRYcg=;
 b=WaQBtVPAUkTSkaHbg1uRuAn0ZiqxThb3zpoQl83sKjKtBBg4qipjBdjDtkC5+Q1+5MPST8CbysTkctl4hUFBXZe+IEqeKiK/3Pc9QMmlwvDHLPqRIX/msKEdoZQP+GgbNsFNE9vSaJ+omksRUUf+FyNVPNucQYFOfKOVrHU1JNo+HC78eZ6/XhYyZdH0ohJsVdeoeU5ZmjxTgUb6GX4KyEBMwjw0Bi6c2KTy7fDzOHnYOvWBJGOQAEh3o1pNbSSHf2JwSEJviguVQbeMZBOWqeLcsFdw4HFGI/aUUoMZk2woH+HZQh3nKyuVYpweHOMeej0mW0HG45tasg+/YYUoHA==
Received: from DM6PR14CA0050.namprd14.prod.outlook.com (2603:10b6:5:18f::27)
 by CH0PR12MB8578.namprd12.prod.outlook.com (2603:10b6:610:18e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:33 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::6b) by DM6PR14CA0050.outlook.office365.com
 (2603:10b6:5:18f::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:33 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:16 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:16 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 04/15] vfio/nvgrace-gpu: Introduce functions to fetch and save EGM info
Date: Mon, 23 Feb 2026 15:55:03 +0000
Message-ID: <20260223155514.152435-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|CH0PR12MB8578:EE_
X-MS-Office365-Filtering-Correlation-Id: 4423ffbc-884e-444b-b4f1-08de72f3fa6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bdTi9Kn5hPYH0WXMqrB/7h4zg6cOmUAPyoKUBO4ytCyY+sOFhGoocry4Ivmh?=
 =?us-ascii?Q?aFtpGgF5EUTHmeMuiGwzaliJWY4NQF6OLJfdxqZne9h4t61d3U0sYWOpv1LQ?=
 =?us-ascii?Q?OYgePeAdovSoF02S0F6iMR0yXiZBCgvSwcZb4LZle207hAErGDxbHmKSGXB2?=
 =?us-ascii?Q?A7JEumybCQvGblXdy8d1GzU5n49skYOYqO9MWCjjnHyyby1FWFD422zhw78t?=
 =?us-ascii?Q?YD1ICm3syGNSZuL5jTMhvE9d9v0ZQnPrYkmSijnf3XjWHCfBnDi/JVPzWYNi?=
 =?us-ascii?Q?qNKT1fiTaU/9Yd77q8CZng5wYL1dIsAUYfdhQuzylgX2pRMi7O9XYpJNkxKV?=
 =?us-ascii?Q?5XyfJxMVIYbb5VDNuRubw1ZcdIvr1AfHOPIzFp5LXTwUJ1QhT0fYrO/aOMRx?=
 =?us-ascii?Q?nBhC0IaGhxqGh+2AYc6l6s8E1h+xe+DrEmqvFl2v6f4ugfgKNHcEZm6Ds+lX?=
 =?us-ascii?Q?ogWAZRWbppf1K7w6GbZA3mZ9FHUeZcwArU+aLl08hbaoKBiaBUhVj+h0sH7h?=
 =?us-ascii?Q?/fS10ZiECw8sAs8S5I4jVloNfgZpkbY9IdhBY9fowg2ZbOssQzQjpa1jurht?=
 =?us-ascii?Q?keej966p5f2218E2wzdZ1Xfxm9stzIGZmAUIShOBmIpJyaaapZlsfmgFdJfo?=
 =?us-ascii?Q?1lRcNTOEAKKQvJYgM/X0M2Cl7GusRSfkQ7aY/JUIeme04fqRToRZWwB1dCkm?=
 =?us-ascii?Q?4e4+EWVCTp1bA9zVwwCoVHJ6sstD9gm8skw87AlPycY6/IfI9z25+8pW+PgQ?=
 =?us-ascii?Q?UOKjz5gYOH8rAGF28JTok0f6/VxJf2BJoUydCNxkLQtgIAdBOOx53XWoZ34S?=
 =?us-ascii?Q?R53jvZdX2l00s+LUWT88pbjq5j8An99GZh40Ylvm56srZKzNpOU63kcjw/zY?=
 =?us-ascii?Q?rArRdfZUrkXd0Ui56vyV5hoVj8wYyUE75CLg6mtAcGNqKoUbUH1OT6dLHuj9?=
 =?us-ascii?Q?D2Cs3jSLmHgGRZ30HNXsaSNfMf3mhwBffxYZKCWbBOoK6iwc46rLRhALqeJl?=
 =?us-ascii?Q?jU8qJsCn86/oZ+AovnkR8S0/q9wdoXnrLmXemxywrpP5Wbxi0qmuy1xF67zd?=
 =?us-ascii?Q?XqDWY7/Lq7+8uizoqr17kZ22QeYoG+tlPBlh69bf9HE4Y0DnporkazpBQt0V?=
 =?us-ascii?Q?+fYtkQrUofI/EhTOtiuali2DitSOIth+5bWrNagQ3J+r+nR0qo5tqrlme8ec?=
 =?us-ascii?Q?Xt3cTD65gFhMQcZCHLyoYt4vpyNsHCmc5hXJEbIeTEztUDNRjDfizm1tg23/?=
 =?us-ascii?Q?qfP1OHaFgap8T+3h1yaxlojd5TYFnUXEH89xl7z+nqzBzaXEHf2GbsRBq+uG?=
 =?us-ascii?Q?jfxTG3fUw31H/Yw4L3qPEisQbAFag84OtWXt0R6CY8EDGMkqg/5xNf1VTSnN?=
 =?us-ascii?Q?klmSax3uhHiy3EuWx7RA6chubdpg8v8CoNyDPviFnmTdEtVYaXNYYGCiFDK/?=
 =?us-ascii?Q?uVGR5bs9HRplkCMYURMZsXeptiZsnnLuAFtaxZD5LrwlFxBDD2Wf3gx6jx1O?=
 =?us-ascii?Q?wFpUnu4a5HFGL6rRqWJ6iR3QcIuUfaH7HDi9zFDtTELRtx5S1SRNIpvpVR2H?=
 =?us-ascii?Q?moWL3L5zdxoTFudx3bjwCV5hDEdfUP1lmPbt99N+Ge4Qv19g4vSlzbihFD/S?=
 =?us-ascii?Q?k+P8zfbxxzSoFc0E+PhSe6AYwIwk8eF1030cnDc7N5Yppak+ImZiynd7ajY6?=
 =?us-ascii?Q?MLW0iQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rUFliEwiGRUAfcrCqkFmK7mtI8shbZZOYCaC7Q6dOX4+NwC9VpnSynQyR43xhII6G4fKb9NJNV9JwUNb+OBelV6ldcIJuwO4rN/QavZFIYzJ03jTfjBp/pypVKMSId1Ozdj+E9BsG6w7ZMWoJ4JoMtgeUuk8qlQAhXdowvtQMFVIn1qZWDMVEKtK9TM2hGvq2JEBKzQ1yOA1Sesq0s9QNXa8qLVmo3efLSTmKfVJoJygizev5WcGRnUJ6v88HX3xqPfc1JtMYmraqg/sdgnzG8fb98SgIpuE7z+6OIQpVdl6cDSkcJzlyfS1ps9lxNgf3UWKEPnodLTcKPmzy78aT9vq3/xnnCV2XidB/phTWlAF+S6ys754us3zcqkplZrqV951vzAm22XPO4w7B4hDNowit/RZcV/NyIN+VPLegPrsATd52DIEqBd2/yzydTXo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:33.5688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4423ffbc-884e-444b-b4f1-08de72f3fa6a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8578
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71478-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: B078F1792CE
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu module tracks the various EGM regions on the system.
The EGM region information - Base SPA and size - are part of the ACPI
tables. This can be fetched from the DSD table using the GPU handle.

When the GPUs are bound to the nvgrace-gpu module, it fetches the EGM
region information from the ACPI table using the GPU's pci_dev. The
EGM regions are tracked in a list and the information per region is
maintained in the nvgrace_egm_dev.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 24 +++++++++++++++++++++++-
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++-
 drivers/vfio/pci/nvgrace-gpu/main.c    |  8 ++++++--
 include/linux/nvgrace-egm.h            |  2 ++
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
index 0bf95688a486..20291504aca8 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -17,6 +17,26 @@ int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
 					pegmpxm);
 }
 
+int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
+				   u64 *pegmlength)
+{
+	int ret;
+
+	/*
+	 * The memory information is present in the system ACPI tables as DSD
+	 * properties nvidia,egm-base-pa and nvidia,egm-size.
+	 */
+	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-size",
+				       pegmlength);
+	if (ret)
+		return ret;
+
+	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-base-pa",
+				       pegmphys);
+
+	return ret;
+}
+
 int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
 {
 	struct gpu_node *node;
@@ -54,7 +74,7 @@ static void nvgrace_gpu_release_aux_device(struct device *device)
 
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
-			      u64 egmpxm)
+			      u64 egmphys, u64 egmlength, u64 egmpxm)
 {
 	struct nvgrace_egm_dev *egm_dev;
 	int ret;
@@ -64,6 +84,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
 		goto create_err;
 
 	egm_dev->egmpxm = egmpxm;
+	egm_dev->egmphys = egmphys;
+	egm_dev->egmlength = egmlength;
 	INIT_LIST_HEAD(&egm_dev->gpus);
 
 	egm_dev->aux_dev.id = egmpxm;
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
index 1635753c9e50..2e1612445898 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
@@ -16,6 +16,8 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
 
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
-			      u64 egmphys);
+			      u64 egmphys, u64 egmlength, u64 egmpxm);
 
+int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
+				   u64 *pegmlength);
 #endif /* EGM_DEV_H */
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 3dd0c57e5789..b356e941340a 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -78,7 +78,7 @@ static struct list_head egm_dev_list;
 static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 {
 	struct nvgrace_egm_dev_entry *egm_entry = NULL;
-	u64 egmpxm;
+	u64 egmphys, egmlength, egmpxm;
 	int ret = 0;
 	bool is_new_region = false;
 
@@ -91,6 +91,10 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
 		goto exit;
 
+	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength);
+	if (ret)
+		goto exit;
+
 	list_for_each_entry(egm_entry, &egm_dev_list, list) {
 		/*
 		 * A system could have multiple GPUs associated with an
@@ -110,7 +114,7 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 
 	egm_entry->egm_dev =
 		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
-					      egmpxm);
+					      egmphys, egmlength, egmpxm);
 	if (!egm_entry->egm_dev) {
 		ret = -EINVAL;
 		goto free_egm_entry;
diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
index e42494a2b1a6..a66906753267 100644
--- a/include/linux/nvgrace-egm.h
+++ b/include/linux/nvgrace-egm.h
@@ -17,6 +17,8 @@ struct gpu_node {
 
 struct nvgrace_egm_dev {
 	struct auxiliary_device aux_dev;
+	phys_addr_t egmphys;
+	size_t egmlength;
 	u64 egmpxm;
 	struct list_head gpus;
 };
-- 
2.34.1


