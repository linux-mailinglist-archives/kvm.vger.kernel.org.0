Return-Path: <kvm+bounces-51120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB754AEEA4B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF6183E1C4E
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 138552ECD00;
	Mon, 30 Jun 2025 22:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mw64tpjI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18ED2EAD1B;
	Mon, 30 Jun 2025 22:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322534; cv=fail; b=AqiEEHSdeEz8z2dlxl9c6oOLbpD253fODEBNUFjkKbtFV/p5stXLWuMx+Dx/7TDA42aiP3un1RjJ/XogXT5I/4Ie4ytAfZ334Lqd/LFHWKTTlySI9Zg40D3NQMopgVb6unPXm5623amTl9IfrTrdkggAsrVMasO6+860u1A1kVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322534; c=relaxed/simple;
	bh=4ygJHXQg0XbjK5j7V5A+6bwphmysvob2m0X+qC4F7lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=spWWYg2kKL8tsGBX7IuoLZuJ2JRtW9w6CNlqgxLTWRFrWYR/QtgUgQcrAYgyrCK0s1gDVHYKAsPlinFnJXs9aI5BYOYBcKJVq7BmXiLCzRC/iKvgGLW1oJBVunMRKBv59ZKf0eoRUttgyVzbmSlw7H2dgeC5/3pOqr0n8Zj0mVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mw64tpjI; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YOFkEpAJa55mFNcp8RoxfJvoxxZq1QK+o1VsNc5ZmmJt8Jo2VuC1k2bfe+hiDmaPiJPiJaq1spzWZ5hUGjQklzA/NuN/rj65N0pT+fufy7m+ayvwYrRnIBcap6QMD8mdOaqtSRor6lmxd/oquuY35S4DWgA4K5Sc2/4odIIZwIre+1blMT9Tfb2vD5nmRdERxAMHtc9KKEL58BgGM9Z0sRD7bHDJ3XgHybSbWs57Ig8yQycl8NXIAOhZQpADWXwoHVdnwSeOkZIQ0XtJ514om+Ftupzo0wBo1oWYGPcT8hZG/SWjg4IwxBoph0oujgGU3VhAFzZSn1P3KYICW+FnYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vYSAGaimvwdNhh1kRupF8EDQrfkZL1mmtUYgOCViY8=;
 b=rqswk3sOlK0nIJFiudmg85BV46bA53Nuo1VDjab4sFs7307xEpGrzZpT5gwLrCfPsI1J5ONiXvnmZ7vbIs+R+LCSxpIfVZF2w9hHzCx2Fcmj9UcRZW9ElGN4Gq/eFhoxX7fXxmkPUUB9U1TRwUL0nJ5+ufQI4LfDOLUEvAWaiJM+zZVY+Zj27BxZ3fwJDOJnqlNEVD8T5Ga9gfQyiO3/7w9KKNj/IBby0EQmqBTphH02nVfHW03IdY2E/l2HX6hTiuR7wnY+mNjLkAH0PexmGDN/hEdKbS1NgXlkyt+ehlWF7BpYcAj2GqXXN5VY0q+BflDJ0uODOEu0EVe4b56EbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vYSAGaimvwdNhh1kRupF8EDQrfkZL1mmtUYgOCViY8=;
 b=mw64tpjIxNlFzvPh6ijnHisJ2/SHh40LLp8fcoQHtcCEYCrnJ7A01Wy0Po6nuui8G/MndhtAzOrUPN46o2MTz2GRi8WVQUT+yIZn1hJNGIruleH7Z9CAukxR/cSqqUD/Y4lw/t7QXkm+RI8oxe+0O5fZIxS4dFrnbtd0787JQ56Rsbxk3Kp3IYlMFnf807tDIKIvN5/t9wBanE9SpoRPPt887476dQZiw230L3IpmatkX9tSJcvQvIUdV1figWbBwsrM7kN7BTsPPug1aRVVWrLFfTlE/yBWXPIwMsjWQ8Tg4IEcZqoaYLHkOkwqp/f8tB6muQzb7EG01woIBm4duQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH 04/11] iommu: Organize iommu_group by member size
Date: Mon, 30 Jun 2025 19:28:34 -0300
Message-ID: <4-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f500370-58ed-450b-d024-08ddb8257a2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jnmbYvQKfd31djgG1bZjqHkyWS0lo1qpYowrKepTRME/w9ZovNP7GXQiH8Ex?=
 =?us-ascii?Q?VR0bSONAlHenRMe3v395MYzudcL48+DcQbxre2J7Txh0Ve2b4SUlDf9Botn/?=
 =?us-ascii?Q?QWIv0gtx04dCARFClYDvCqXEZpVyg3w8y0npk4BBxEGD5OMKqoCbOmLXqpfY?=
 =?us-ascii?Q?ZE1ChgWTU+rygbzuoADJ2cnOrl3j/+HemX2nWxHOhxjoJgQ2YQbneHmkpGB9?=
 =?us-ascii?Q?BQDvh5EMRg+8E0/7dZpvgnsWwr2pN+WYEyMot7W3SWfWczXibq4PHkItCv/Z?=
 =?us-ascii?Q?pwn/rHyR8PHIwfZcn3aqJDgfsVyeyKW4xJ0RXyea7f1/qqeTEsGskYKiGbZu?=
 =?us-ascii?Q?IHo2rQr6vp+p/1UZPAhE0c8iFWPn+uXXdUNs+owi5l6U926DjIL77dc80z13?=
 =?us-ascii?Q?MSHjBRxHDDmMTg/JnofH1GutPbuCXNq+PowIJo7Ta5NoSsDOEe1tJ3Ip1P4B?=
 =?us-ascii?Q?hfXkRXYzyOqo2GzWCSMnXMj3Dkmtr9xVnzWePLqPKDfEr0zYDeynj1eC5SIL?=
 =?us-ascii?Q?/J3q3SyeArTZ/oHbPPpYU1ayjTOHQVx9+bVkn+Y/3ULW1BhZu2wvYmiH0iJJ?=
 =?us-ascii?Q?RBjR7NPQ98vEe1LbvsWym5/Rz9ifqJzUvSybypwAvJt4Q+bpA2SoWCHYTHzD?=
 =?us-ascii?Q?43/OZaX2niF8206tFyBtZgHmiTG51hq/S70Kpnctg4iAcF1R8Rjh0IJICWFh?=
 =?us-ascii?Q?L3JhAUYVLvy+JJafQt7SHMCFcDaESnbglWaiZnBvPN7NC/OSPy1egTJB5OOT?=
 =?us-ascii?Q?/TEcItM781In+DGT8ftdttp3rP4hmabRdZsL3tHSopRUxpKHQiC1cz1M4+ey?=
 =?us-ascii?Q?Nr4guI0gPvGh65DZuyHj875qD6R8Kz94D1//9vMGvQyNrzCtEMvolBy1hHdI?=
 =?us-ascii?Q?80UYCaCBqi5XXp0xnfALLHAXSHT+8027M0haAYo6FRgiEGYCneEr1BmTg3HP?=
 =?us-ascii?Q?z/epZAWnZcAU0Uf4K5CL0mrINM3AnsjuMT2oDL68ov778A79tyAf68VNos6g?=
 =?us-ascii?Q?SJgeaRyDigEF4NU7KxxIskB0LVpSfU3pW9UBE7ItVAiSkKhoePwhE2OVL5MN?=
 =?us-ascii?Q?yPIv4AeU46VG4/ntaog0LUbm1Q/68bqydcicVhcv3Kqmr7+nurcE7VztNpdU?=
 =?us-ascii?Q?as2wrlPgYMH1gZIZJex7jxiiaGat8bCpZ1n725JlmeNk+VJILeRrCI6MnavP?=
 =?us-ascii?Q?bIFY+gA4h/CopxxKLvhnM1RCnFm0B5U9gc+W+wi8VEcSweP/VLqZidpwLESG?=
 =?us-ascii?Q?FV9AIwXEgj+vjRaos/dFafWOi9hwvqUDwMcC1pVjmbXaTl3BAMMCeVmKxKU3?=
 =?us-ascii?Q?StIzXhN4Dvh+k5vFWulV3zkP83ikwPa1ZlelhRSIWllWZ1nyxBasiVPAPDx6?=
 =?us-ascii?Q?qe+MG3BSe9rlD62UgHJQLlDJeq2buc9xxHG0LNdiDoI3NyqQJVQ0nqbbV6KU?=
 =?us-ascii?Q?zuwyBvXO5VA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aaaOE7JYtXKo12F7k+9578ToghstUWUNHJV8p5ooQiGRxddhf5R19Ez2LE3m?=
 =?us-ascii?Q?0307TuZjNt7G9vhI7ks/og32n7uRztddZJKsjOJScA0kLU4MQF7zyNIZZfNu?=
 =?us-ascii?Q?o2J6YSJyzAAS1bhPpHYoPYFSivsexl8+EY9B8jelQQjYmjdyijOzXy+m+4XC?=
 =?us-ascii?Q?KxXMsyd3AwvRVXwgJUW1LKA10wla+oOI4lobMLHyrBP2mzcINL+aofhBEVDp?=
 =?us-ascii?Q?rs744NcygBKGLy2fZWCTaAnrDE9XDAdfhVnPsMwlHH5o/BFe/NNR6gOBA34x?=
 =?us-ascii?Q?i3G9p7Kihb0MPaLa+M4rDgsdQiKRhZoTyg4QxGtXZZYL5XYJgXHQxcCqh2Zf?=
 =?us-ascii?Q?34j8aAXuig1UNKpbR1oawa5fW6TIZuLbSqDiVy9FRVSQbWm2Nytk1TTDSLX3?=
 =?us-ascii?Q?J5ZJK/UBwYPTrLLb5KlrCuK32C5eweDzIECfVikF66tIB2EML0lB5emUTqH8?=
 =?us-ascii?Q?lXOwHfkRrxKeeQeG6ghl1cbnqvbp362nqkR7MMSv7wysQpJRMEaPBljKz1FD?=
 =?us-ascii?Q?iWNhAMltqjmkWXxCgR0jKx/F++WYE5s3svjGSTzE+QyMktmperQMoSnRDvI/?=
 =?us-ascii?Q?/OgHD0Fob7w6CPhEMmZV5wJm83BpS3uEg3e4iM6+j26TtRm6NBJJjQLZ3oZh?=
 =?us-ascii?Q?e8biMLJ/82vDW7SHm/mHFGQrHjGf0DhBryF9cA0owtdk4YZmuApzrnl1P2L5?=
 =?us-ascii?Q?36FnYSXaeOqt57NOI3i/9zzJjqedNS2cR9ItYsygqu2lMMK3cUN9CUssJEtq?=
 =?us-ascii?Q?0bkx0V2583U44snX1HMGkid4HR0Q/Ud7pKsaQIfKxJBNOeEvlI7MtX1fW3wA?=
 =?us-ascii?Q?So+wE/WCvYY1IpC8y5mEjJW0PyfeCR7q7qcg6y2ZnrladWhHmhohCYoprwd4?=
 =?us-ascii?Q?epdQNKMylRxsdyUEyoD6JbBo9VDNipYOUg7Jhojs5CHpVNx4/6Vok3uutaFM?=
 =?us-ascii?Q?z5iQphqifViZGvctOvZo3EBFVX0i4pLZdGH9GKhK3WrV8n9I585WDYc90MSq?=
 =?us-ascii?Q?fVpWHj4I1Uzj39WQp76wxRvI0ctTLcZPcdZrh5BRmOwN0K9CLBnoaqu4qBAj?=
 =?us-ascii?Q?6B7wftM0EhSGNwEi/dqk10zfECoeVG9CYPDpkhAt91M9li0ZAfy5urBDdGaa?=
 =?us-ascii?Q?CcTRtjkM2TBXrGamf6LQoWc+srEkSGjtVYoydM0Ahqxuec4PHxcu477UcJ38?=
 =?us-ascii?Q?F5ov5qNao1NF2HtqLWRO50Jpa5YYtGPwQB4tH3B49bqOg4PlCJ5z/t8nG2oA?=
 =?us-ascii?Q?mlu5JigHhjFGX4fD3KB//OPyCGtPQcqAoWLMe1POSxArv7MkDE7VWZQV5oSM?=
 =?us-ascii?Q?9HE06xaKbtoWeRLLu0hP8sEQVBmDF3OpBRRmnfPupCEa8qOI3r6zqbuz7u9G?=
 =?us-ascii?Q?UzhydQUMCkltBGqJPN3BM8BkqC80E1Y2457iddtfxkRb5TKmzWch7hddwZ1L?=
 =?us-ascii?Q?sw6kkhAomPA2zby0Ijx1FZcXIAN6S6S6JQyIhdAABoG6GhD0oSmMAIeEKVEZ?=
 =?us-ascii?Q?MkZCRKbIxU8rPvgpnry4MyWvqCeXIfp3tnYSYGurbAyHyEP4f2Kvlc6bGXmW?=
 =?us-ascii?Q?313S4kVohKNH/1jaLnT+37XCSG66aHIyVD/s8w5N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f500370-58ed-450b-d024-08ddb8257a2d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:46.3303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEknwn3oecSo30gs3p+p2r2Xt/PVEi6koJw4STY3D1XQi9WT3lwD5lOKx/MZWPAM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

To avoid some internal padding.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f4584ffacbc03d..f98c25514bf912 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -58,13 +58,13 @@ struct iommu_group {
 	void *iommu_data;
 	void (*iommu_data_release)(void *iommu_data);
 	char *name;
-	int id;
 	struct iommu_domain *default_domain;
 	struct iommu_domain *blocking_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
-	unsigned int owner_cnt;
 	void *owner;
+	unsigned int owner_cnt;
+	int id;
 
 	/* Used by the device_group() callbacks */
 	u32 bus_data;
-- 
2.43.0


