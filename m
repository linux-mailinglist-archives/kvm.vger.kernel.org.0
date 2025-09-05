Return-Path: <kvm+bounces-56897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C49B461B1
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:06:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6E33583B71
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E57137C0ED;
	Fri,  5 Sep 2025 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MDZYz9Uf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227EC2F1FF3;
	Fri,  5 Sep 2025 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095596; cv=fail; b=CXIFxoDnUponKRT6ROfcXuM2jsEECmFsBp+73DEWfQbdRE/iIu6KMtrkypn7QZpLXemO4rjt0tavwb7KMeprTOdbbkfi4yhqWeTSKYVRhJhYtD4CXDsb6hxgPS1BGXKv9IwLU/mnHpn8DKbLZoPkunYFxpzRf+hqEolbR8uZQM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095596; c=relaxed/simple;
	bh=7qdPiZ1aKgTX0A/RYdmZdJqhPZDPEHQK4oYcs/hQj54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hQklPZSPIi43VWvxc0/nEDJsQ/QYdjlo5ABEGzGhsj3qbsATS/SQq01IkGO0qUkNblOagwrN/bpBCsoSLm5ndhcYUMxHLTJ4vClL1ioGyC/cX4JlOVxkvU0kQO93SHhBUDnZbjTtD3fYfmw+2C8vg+k1RT6UOCOBzziGT06xNGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MDZYz9Uf; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RMu0CnlLK2D+W2iMF2rH7yfp13Pir9WLZ9RcQ/ATqSS3XAxIXZ89KND4YA9tmSaJU5hO9asxGuW45Aq7OPrBL3tMOHg4Xua2NjmoMJSJm7oRvQoDwEyMaLSBUJF+lOwqdQRl9XQwW9GtADSNKpz1i/Es8B9TNEy6qEPHkbNII1SM+uegyqFtbzTb3dacL2iYs3M4al76Aft71f8fzpkJa01I0I8n+rpdUD/0rmbStaUlbtEkpYT+pJG5dI86TKjKVH+wAdI8Hu8dpNNU/QxeDmtZW5fMfFwg7OsvI7rIl83giG6jTvUMzBtpMIGHffOldCtlmAl0smbd7/qXNufM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxyW8pOVZKqiPXph2B4KErNozxqFyM+vpzTnqp/bjFY=;
 b=BRnu6ZJZ0d3oINRn6Aax7A8uv+/tCxiMAYy1BNrTA0ql+TtmICcMpA06k02d26cfqD7CilFvzIzwjvfA2xM3buTlbfQAXYTxjegrzQmD32RN6wH7BPcSJRYKV9JaOHBZsrLg/lWDQhc7vwDpPDuhBGHT2k1a21BFW1arH7sQE8dxvpHvmV1PQjmCtjjIO88OgkLg42tRosUqmA8Qcl4B+z+zLgr7qN5A3fJyBvpGBoVLrft+dPYs1G2IgT3kaqZN2asat515jqX5w5/mQzslG5VqYBjmAFOzmGfdZlLMuiYwbZLHcHZj3aRVoOPMjA4dcH1T1PppPphEO+I6fCBR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxyW8pOVZKqiPXph2B4KErNozxqFyM+vpzTnqp/bjFY=;
 b=MDZYz9Ufdp1z3BgxjcrY/jPLPuqLZ5h+6HXpAV1B3GUPXIMnwd2e1TCzRHBUQmjN1Ch6Hdid2NZnaHHPjVxPtYrdYcRnYVJJo66V514Nu2poX6d40c7ir2+jREFhNCJSxwBhGjSWEDvdxSdMgMkZ/CtzmDpWh39+eLISNJ62hgq6kLzAh5AmQG7O1bnhRigwme5kQqYGJlfh2u4t6XCqSkdoemtu8ILZO6rYZF6gRdXIylFCzh2qrBtw8TW7OpqEUFpHd4341l1SszD/Vxu2nq5RZnoeEAeM9vduGgQs5EtM3KV3LHpTKZiyShxIeNQaTG3Du4dcmV9QpcmvHUkRgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 18:06:30 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v3 04/11] iommu: Organize iommu_group by member size
Date: Fri,  5 Sep 2025 15:06:19 -0300
Message-ID: <4-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0365.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::16) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: e914563c-13f6-48ea-1bd1-08ddeca6f0aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i2Xy7HfJ+LxYqHF/tis0joKP5GJ+khouzbfpomuMI5xu2caYg0QcZque2K03?=
 =?us-ascii?Q?DNYNM+vVe1dToL+nFYl3zuEmpu5IWbEW7spjP1ubUHQDp7W6+d8YizBoad7Z?=
 =?us-ascii?Q?joAlrrXmXg7/UKKIdac9bO4C9wG7+VH8ddw1YpK4x38BkKXhWhUIggLLTzcN?=
 =?us-ascii?Q?Cs/oRBopv040yAcZUEwrRP9pj8TCfhFNecZYTD6eqDHwFuwI073usxI1lmtP?=
 =?us-ascii?Q?e0kuX+VILf/nEd088/gyrVO5Zzhl55D10VoV+9LPwWykiJCjUyDE6rZTGYEW?=
 =?us-ascii?Q?xA/ZbsqNzuyxqV25K1S+Qi9DuG+NVt4J3rLa+pYdauiJP/VCD2qW3q13BWAR?=
 =?us-ascii?Q?WyyOsA1L5EWyfg2WdnHC0iqHxpM+wTk/QJ+oXzZUxvHiec7h90fPNIa4XjLJ?=
 =?us-ascii?Q?9PUXh3Lm2qTGBm7VcVGZ7mqi0WAdP2iquOO2TYqc/BSisyRfTZnMQs6R5VaQ?=
 =?us-ascii?Q?/BYaxmYTgcD6Ppoj2VhXc4/gQ3/QhxX7crD18SmbciavrbpRaajPjL+N79Xo?=
 =?us-ascii?Q?Z4Q+lP0XAd9Fp4Eh6EPH3BS33u3xLsEmzh6y8DcOMk9IpR/r/8Fmk+xbrlD7?=
 =?us-ascii?Q?elPWlrd4sUHe9bNimt6bDYk+l4WiPe9jHFRn5yXnCNV/yVGVDd/2+SrXNAnd?=
 =?us-ascii?Q?IGOcNJtI/3/lgNsQStUpvH0ovMJZgs9mgKUU8IZGcGiGO5gtVlNQu+8AQ/tJ?=
 =?us-ascii?Q?rvX297G49O6IHGpBdaKVzfr564thHDclDhYbRbJkZx1qc/aCkcwPD7W8QpUF?=
 =?us-ascii?Q?OYYQwmYFIFIcr/tRbrbopEvcFktpbDI/MSDmui6RvxPEuQF6+oMcg3u/f43q?=
 =?us-ascii?Q?eNUjeR8/0kcJPkZwy0XhBpNyIeMyry9tkMkQ13kcjrnLdxH8soQRnTg7Nq5i?=
 =?us-ascii?Q?a6j5zLmhIrwtXrWb7w1sh11n+RFc9Rnysbd3+ggH4+yAAS5j/L/+ql5VUMmr?=
 =?us-ascii?Q?FANUE8YVE18z9pXJNMRyVnHy1ciP2TENFX/yK3jv3YuXkY4IQ9F5LQr4N8kr?=
 =?us-ascii?Q?SlPRMG/2JrF+ap9wEDWcaP2rdEqoeA2SyQjVEcbqNHx5p8VhxBSZ+CIhPBBz?=
 =?us-ascii?Q?5fg+KPCEwmb3pOMbG4F73r3raBUQVkrbz9sutY+ABMbemVAslyklhsAJHGoW?=
 =?us-ascii?Q?eZTUoIqcaen6ezkEYnvHojk8lCDhc+p+p8m15Ff+mR3MjsXuB6u6mgyWMbMr?=
 =?us-ascii?Q?whDtZPSxYDKjKNMYIBEQnhH1A+ktKvf3CpAW3stXZyvQtOFTWpMILgIywS7t?=
 =?us-ascii?Q?kCbYzYcpMt05+l5UzRLu39QqzGnEroit6kHNoMevB+440F3fNIby6uwAE7kf?=
 =?us-ascii?Q?ZIaYvwn0aWODR3cw3/fn8QBaMQ/4KCaX12MfdDU4SPZcSA9qF1zEFRK5KS35?=
 =?us-ascii?Q?LpsdAss0UQtBDMnjipsE8zC0UMUdbh3+KrIOSw15zn7vV1DJcKEYU+x6116f?=
 =?us-ascii?Q?maEdLed5VYo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1VdQP30YQdmYb3zmWbwOc7nQLA/wWgn0mNmaemZdw/GgxqoQztmVI0t9oOXd?=
 =?us-ascii?Q?KkVPLlbnlJ4sxmSnOq8lY8zdH6c5lOrlBLi0KrWotPOyuMlk+VqIKeXX+Egm?=
 =?us-ascii?Q?gnZbOY1uW7Xf0eolDAJGVi5kNLjW0zalXqV991LD9CjxygQhBX9e3yz5bFC/?=
 =?us-ascii?Q?HvfwZV95HLWMSvHULb/xvGp0lMnu66XOnk4S1sGvJ++9k2/zp0giWtRjp/jO?=
 =?us-ascii?Q?dOi4AHCm+/lKoadpN3eX329c0EO0Zbc4MkcNaKwt2fEOHSaEWt/xzxAsCXBV?=
 =?us-ascii?Q?DZ2DtGnRF7EBMhiDs9wtqhXUmMgHOr6Lout/As39ZzmMeS3KUO78id+swmzD?=
 =?us-ascii?Q?JtlAaPAI+bUSebuzJJB2yA3Wm7o+tYraGrnQPyf7wT3eG6N4MbmmbwztaZ3n?=
 =?us-ascii?Q?n5Sr/1VT9NwY5y34tXBwkOcEctEJBvrq0dhVWrcUwsDEVRBk4IGV+a1pzLTH?=
 =?us-ascii?Q?MZYPRGXvWsfz6Zdezo5fblcbGK7hDwHDyM8i6Q79yc1Z+lFoIAq17tfNRWjU?=
 =?us-ascii?Q?ivQeuSjZzdRUO7XZ7n5rcCzymJJmmnP84gDzkp1CFlafbKaJucOowbznzj1K?=
 =?us-ascii?Q?/IckM2K6h5ujqeYfb/Vo6eoAsNmLcSgCGseCajbzo+rPB+1ZBS/aKxs5fvLs?=
 =?us-ascii?Q?OzacCpfdhUCiX0F9bzW2PfMK3CxOPSvlLgxklwAFXK5jBoaWpobcjQCnikYV?=
 =?us-ascii?Q?NKl2goyDEdqbDCnfwHrgm7ZDSHcqAYdPjcFaIh5x+dqV5bRS8bVAPuZ2oBiI?=
 =?us-ascii?Q?f/UQF0eagZ6kfCEOwhO9duYK7w6hUGzSt15I3FzsClFa5yGS2waKWxqACcK6?=
 =?us-ascii?Q?shv3MpX/qxvy1GgwuXpG9CYFi4IzZ3EnAMDNfRLdaC2QKn8cvXQL7JBctc8K?=
 =?us-ascii?Q?psN3jNw/NHCsnKX7vLrQYwXrQmXGRRDr5bXxYdUeHyax0Ss85+4sKxUnijk7?=
 =?us-ascii?Q?6C5G7jlYIG9nDldwg7qn4fURahg/Pl/mH7chet+1C1icJfWZcOOTE9a6Q1HJ?=
 =?us-ascii?Q?Kzeg3eIwcnSo5eyj+wORWgpjE9+6dYh09EXga12mwuZSF+OqXL1+mgWslx+4?=
 =?us-ascii?Q?gFzW4gBkDHddAOoj8V8rqNxPM9+62qfPFsC8SGBAvjQVaARknB8UOQ8U3BvQ?=
 =?us-ascii?Q?ow9PYzCwzRhPG/Ekq3XqLqeUpSb8zzRI50GJ9EbTbs9LHXjYZ1A3LyxphV4S?=
 =?us-ascii?Q?40FA1tpFYfmPtbKBO9rQHH561jf3avhFmuMzMY5T2WkxSN4aTCzLq/APGXZA?=
 =?us-ascii?Q?9b2TRLeloWLpFrnN3nCuFNhyXK2tqgbRDKXSP7t7bpq4uUI/xQwmiT67odbX?=
 =?us-ascii?Q?fa8LrElRqNtGde2DNmXSbnpt3D8M4Z66d3OBpSUu1KAfDY7tnT9I9gtETgOV?=
 =?us-ascii?Q?KX328caPjDD8CFpeeWmWGPyTgQVxtZwhiwNzwPYNFSi/XI4wo7dmI8lzbT+V?=
 =?us-ascii?Q?771C7ux2oNxoxhXddZ8LXC9Z8DDJ34/HSTRinSinefpMKD1KVQh+zuJ1CzD0?=
 =?us-ascii?Q?z6KH8D0TlBeW6D807WBlJKDxm8A9JgMniVA4ie65EKmvym7iV2LLoxisGQlN?=
 =?us-ascii?Q?bBo4Kuh9fG/Cj0lKNmg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e914563c-13f6-48ea-1bd1-08ddeca6f0aa
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:30.4512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75LWpkk2mh2rSsHsF+5JSJS6B7HpGf1m5Ul1EEGQxo4FubnMcD2omxyHtTqJYe3P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696

To avoid some internal padding.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1874bbdc73b75e..543d6347c0e5e3 100644
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


