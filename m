Return-Path: <kvm+bounces-30122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA48F9B70FC
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:21:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AD04281E20
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CD08F5C;
	Thu, 31 Oct 2024 00:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nOFpYg96"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D401C27;
	Thu, 31 Oct 2024 00:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334066; cv=fail; b=JRwcQNxFWVPFdKo/CZCB1+iWZI20RlNS9aUZRZRlujVCeinQ7/4tI66fB6UGmj5E5x81p20TI8+VX2CQdxov/w0GuMf3pId3aVE4Ar7wXq+4qeU244TsSkJQtnfWuXUa0257JnZclG3i0hzevtM3lVRPtQLK3HHAxcSmWwsOtMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334066; c=relaxed/simple;
	bh=PNVo2ZG7YuJ1Xz9o2iXcfm3JT0dHM/smMiyLScWDTMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BPz9w+d3b+26EwhBAsIX4DiHuQ+VAhzAY4M8nnRaAZxsEI/ZBMIluwZSV/w1KTdK8XVNIsT7iuM0vAIHjK2T+t5TC4pxD/IcfohtXqnaPBq9ib/fkPyB9c+4lwUsFHL1VD4u7UU1Z91RfQp/9+CAxhrlgA6vuMuIaKNRSQ2W4FI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nOFpYg96; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWpH6jEde1/5dkDh41QCNjZl3gymmppiv2uZvpa22sAW75QVQpTljoLufU1KrOsJozzegUNg5cfNdogZkPKhXA+3pwye0cVeO/ei1d+yKVCjU9ZfVXbW8gNIKemcD1cvLBxmEyBLJOMo8cB+6eJg08EB88rGk5lTDYUs5wepUGQaArNhj0Zf+LXXTeAcsJslpXzRdC2ppQZ7wxy2+ykYLZ8aWyTZgrPtgsrBbBgeWBuMXqVgKlUC15foroeGEHEHnLvB06vDqIzPpKjbG2I75wHd2M32p9PV6us3WjlXUGvTceSprujPePFmyUsLjOvbIdW4FhRtz20cZe2AQIxwQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OI54v5qrXkbI3gIeCt5YvbY2nYMZEa3/rT/a29KiC/U=;
 b=o7MJ7buUz0KvCzf39FVuNxhCX20/Br9ywoZA5rlJO4HLmyJqbSIl+fWCV3GaK74qPfQnaBG4N3BwXTuRwP9mHiXuzygnQk+Yg4qfVv4eEhp6VD6/biPMmk31rk+3+ks3WgwEtv1X0haCR46DAgjCD2IQbZhDijyv3gxxSpGNJag0vZHehvep0pLwxGfjMXbDthte1It0CThhsXafh6pTMxFkyyKY23AbbA8Rh8E84STdyvEifgsfRbGLrISEDIwqW+EZlJ8QJQ077iODtHgIwN7DyFM8mexbl/y1OVFOhqRej1/zXuXLWk9AuYbmBCzVU/nmdgOGWVvp0f/CVOXiUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI54v5qrXkbI3gIeCt5YvbY2nYMZEa3/rT/a29KiC/U=;
 b=nOFpYg96sekvkx93O7p8Qsi7xcVumYEjs+5MJUPkJ0C2cvPky6lHHFq8csnk1ilHRaeABUan6pFWJgASNNwoVdA7Rv5wAEpMMV7dYoTQKOVxKBvMh/ZXSNcEhCUeZcSCvFbquUXDHMWUBOmkVMgOCGmTQlTpkbAL5wCMOFkrfDSTbwOWyJ/AxJQ6XERv5Gmxi0hpgspFpSz/ycI77dIN4jIW8oGaz/ZRwkRXT8FyFKrDuSm4amEKW81xrWgbVrksMyvqyIfgmhwndzEaWmP6AYVY9C7UKelXhrcYlRmA1El9RmvKr2RKtHK+8p7FI2lNUMK+Yydp/IlnAPE9jXOB+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:20:57 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:20:57 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 02/12] ACPICA: IORT: Update for revision E.f
Date: Wed, 30 Oct 2024 21:20:46 -0300
Message-ID: <2-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: c1f3c69c-1b9e-4aac-0e73-08dcf941e3d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o/Q8CCWNxUgO3TUfNYdZwV7eiSdNw8TGuz5vKTlReSbVh6x5l9FMwqHJFxCl?=
 =?us-ascii?Q?JfdnJG98BYV9LBDx7EhqamZJyqdo279UnD/MtbL8HW9Uhfl3RdN6xlcEGThF?=
 =?us-ascii?Q?zSP/kX9eWh2YLdK5qgPt8c5doaujJFQvq/oyBvaDiP96hSUuBFJsrdb5Q1bA?=
 =?us-ascii?Q?TSlSBy1VGqngAZW+PBS4g7nxJYLU8NPq/OND7Y1bhBF8NWGIBhr9cyhf8TbZ?=
 =?us-ascii?Q?wKmpG5UjOKW3BRdU6jVrholHCmYq+L9PeLH1i/niJDhNWjH0c1PN3F3F8hIc?=
 =?us-ascii?Q?a2WiFtm0DAKGXj3aTC/IzZ5u4jiBxo7W0EWWijSxmhswgVyoDVXqivKXpYwA?=
 =?us-ascii?Q?rtaOBDxA4LojDUfoWIHlkONzoGw6qBifV4Apz/vf5uHuLRZg17CbtWdexZfF?=
 =?us-ascii?Q?iS7IWGGXO6w8vAsBVJoGgJ8HFOtbVYtF6aEtrG5B5vKDSJf9zrEXMLAAx73m?=
 =?us-ascii?Q?WHWID8l79n9QPRUUVqtKTyDzQVLdHDdmvjcdia0BMRYU9Y8LcAIeG/2W/Fd9?=
 =?us-ascii?Q?r19BMdgN6CBpUA0iSWBSUEgYM2ytXeLarw/vkLoK+62zrcazQQjBQ1a7Xk+9?=
 =?us-ascii?Q?J8t7H7+xQAXs0mFIxP2Vfg/GVT2CDzbLWdBqFNcVO5+oCiOCfOCoU7AGPAkt?=
 =?us-ascii?Q?pEkNJ2QSZIuUO0jXVLcY8TMbXBR+K+vdbbxE6w/Ij4Uq3PZOJximxsZiS1Ov?=
 =?us-ascii?Q?Qx5x0WLmK8Qv5pQOwTlFcFs+KRiVctQDnfizfaM3B9Fk9O7efOrSEdmMiTEy?=
 =?us-ascii?Q?cT/jaGR2DAdGK0FR/h32wFp9BFOq72i5TT39+86soSXvwDBqYf6xme+XiPH1?=
 =?us-ascii?Q?eBNYcm5b6cl4/5fwaCizgsJhSE4iSv+LDYrBGCyOp6rQsypw12SUxThCY8lH?=
 =?us-ascii?Q?vufZQSmXcp/vGkjrh4IWnC/hIwX52vYqXtv3CRRbh1ckwdcW8HLn1o6fNIAD?=
 =?us-ascii?Q?7NAM6b9wqTRx9hiO9S/9M5peNxWNJpARYszxgWAGVbRxwbhIvvIuaDmKyjQD?=
 =?us-ascii?Q?NuS9Y6HX6i5goMKFydavRaxdJePl9BwEpRE9oXwkzbYK/ReZtxzQJ9dOf490?=
 =?us-ascii?Q?Gb9lpln5o6uT93o6kgQsOpArjINSMPdt/puISyRxxsfNL8T6cPF6mmiQ/pK4?=
 =?us-ascii?Q?EvxdPWXemuTMmIV71HgqSJvTBx2aich+oSZ6bwE1eJ378IRGlvLhRe7CdH38?=
 =?us-ascii?Q?fkrWEzd5SMN93+10CBGNeGAMCIMR/jcwEQL+Ezu7mNCaK0bW4Dh/2w/a2VWx?=
 =?us-ascii?Q?JBJndz1f/xdPDbosADfHrP+E8aPZbv6ft1i7jYnR8nGZKjaXVfXWRkA2MAgE?=
 =?us-ascii?Q?JTct1CeQiFDLuM2iU0A+Gmq2iyWL/Vn6SjCB7JDdn1YdkD9h7/Itjn7cvZq4?=
 =?us-ascii?Q?YnNEwp0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U8iGd5iQdDmWDWdoOuk27qXyWZW9CeKEjV/h48+QYke3bxU6RS1i0/ktuI+r?=
 =?us-ascii?Q?zr6BvmGHrAOeJXcUSaSRiel2FhHT9WdjrC46Bhp+zj8Y8M7o99v7YA4tUerv?=
 =?us-ascii?Q?lng96w1FKHnEOSGQ2Ay4jpwMwkp3jetRKeijPGEN1v9ucFUTZwptw0Wi9KTJ?=
 =?us-ascii?Q?hQQInOeieuYqfF3qv4y863BZBBYlBXy2tV4aSOnHcMXAH4CASJDfpVFNFo6e?=
 =?us-ascii?Q?spOe+pE86eDs6Ck+/96aF8TAS7ZCS/4k2BpVvbCFyIbSIQLRpkhO/RDv/7ov?=
 =?us-ascii?Q?qPotzRkb23ELoqH8FrY7uxD/1K5QZrSz9Tkn/cUhPjnz6zywgj6HQMM318gq?=
 =?us-ascii?Q?Z7i2uNNMuxkfyRmriSSGFER913UiGOxRLO3GCBXYyKmjGgf9tyWGTPuYZ2/V?=
 =?us-ascii?Q?tDflU05pc2jgzQhcJ/ENDqo1SusF6TmehsTec+JZUdGitJGW1oAo9m2X9g1S?=
 =?us-ascii?Q?SjHkma0UQs4Njrmlq2Zm/jpWFhHvdhWbbMdqAK1cwIpYMaSei/Tf0rpH+ybm?=
 =?us-ascii?Q?iG0CbiARZLq1bdGyXfL3nJ240IXbPhLvQ3DC4wbaI8WnP/DSeSZxZXQJrChX?=
 =?us-ascii?Q?U4jgdXaZ9vFg5luq46rKXGmo+xaGnvt2rm4IFDXuYs5VADEynvvagbhESnsq?=
 =?us-ascii?Q?MJTiq+tS6sCLfuiGXLWMneqVoDLzw+DLYOhTcanjxI74xvjShTCXZZlmr16T?=
 =?us-ascii?Q?PN6m81enxn00Wb/nzw6FunkdaxKVe34YGGOiHwxImwZv2JBvOQuIoxRecrqt?=
 =?us-ascii?Q?j0Kbka8S860kD5vLbIpwc1ClBoSjCcTPy6IrAYEvE3yN4B9CRMFH82SCnOGa?=
 =?us-ascii?Q?MwI3Ur4CIotYd5m82e/U6O89Q4YuVvmAtpjab8Mp2hOAybcMQkAVy8j7TAGj?=
 =?us-ascii?Q?w4zl2x/fmH3/szzZsmnnddyLBpT5fyOfYnDxVf62O30x/RELiVa7c0yWI7KI?=
 =?us-ascii?Q?RfZ6ISTscHDKYA1vDri5brsoCIxrKgS1O/tWXVuG7QLFrG+tQ/AuofOXTf6x?=
 =?us-ascii?Q?y2zFOhECpJVDvuiIl2kJ/DdrU6wi24H39+I7pIDI0EvjG1Usl6ZAu9uxnW0S?=
 =?us-ascii?Q?ILmopU4ZlyzX/iceH2JXYX06Jd79XRzQJKoxae5kRdLT3kf1u7OE52xJXHs6?=
 =?us-ascii?Q?Qyh7Fb6rGbqTu4J4cjDdar/98bKBO3eilASIHGZReMkXrE4WVcIs3ing6BcT?=
 =?us-ascii?Q?BQoKiHNA4vDW15XTC6YVwa3/gjuv4QEl03mMgDxWW+WVPioPTSPSUNk0YeTD?=
 =?us-ascii?Q?SPvQY5OiM9B8VD3wMtAFbNgcwGsF3CnssaeCB8Zq0UTj/rP405RZhk4VDJUg?=
 =?us-ascii?Q?UY7slP7ZrrTZ5HUoPaGF5VP4XxPsMMmFvC2QbIvrEsBVWnIUERhfdJJAFKYp?=
 =?us-ascii?Q?jqOuGdCw2RdHtjDNj12fb1o7huznpvL0TMgKwqNYPxHfMFPDDar7cLJRhrNH?=
 =?us-ascii?Q?tBhPTiigQtjEoRwXj3lmnDiSzyq23QksYPILW0NtQndJECZI9va2d7blWKcK?=
 =?us-ascii?Q?Ot+BwJWTkaOA58Zhye/Sz0IWoGPYwxXv87VmFuqlfwnYGDUcSfrf0X0YYvwX?=
 =?us-ascii?Q?pfOllJ5/rY4bxM1K4zSoJjm0qZelx1bbWSAWr4CJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f3c69c-1b9e-4aac-0e73-08dcf941e3d4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:57.1645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uORD7KN4BONbxZrrDS2VfVVzbZqqlhYg4JxC1uUCrmPU4iBsUhbTWGuJyxY/k/5j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

From: Nicolin Chen <nicolinc@nvidia.com>

ACPICA commit c4f5c083d24df9ddd71d5782c0988408cf0fc1ab

The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memory
Access Flag field in the Memory Access Properties table, mainly for a PCI
Root Complex.

This CANWBS defines the coherency of memory accesses to be not marked IOWB
cacheable/shareable. Its value further implies the coherency impact from a
pair of mismatched memory attributes (e.g. in a nested translation case):
  0x0: Use of mismatched memory attributes for accesses made by this
       device may lead to a loss of coherency.
  0x1: Coherency of accesses made by this device to locations in
       Conventional memory are ensured as follows, even if the memory
       attributes for the accesses presented by the device or provided by
       the SMMU are different from Inner and Outer Write-back cacheable,
       Shareable.

Link: https://github.com/acpica/acpica/commit/c4f5c083
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/acpi/actbl2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index d3858eebc2553b..2e917a8f8bca82 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -453,7 +453,7 @@ struct acpi_table_ccel {
  * IORT - IO Remapping Table
  *
  * Conforms to "IO Remapping Table System Software on ARM Platforms",
- * Document number: ARM DEN 0049E.e, Sep 2022
+ * Document number: ARM DEN 0049E.f, Apr 2024
  *
  ******************************************************************************/
 
@@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
 
 #define ACPI_IORT_MF_COHERENCY          (1)
 #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
+#define ACPI_IORT_MF_CANWBS             (1<<2)
 
 /*
  * IORT node specific subtables
-- 
2.43.0


