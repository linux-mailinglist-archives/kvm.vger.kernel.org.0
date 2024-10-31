Return-Path: <kvm+bounces-30123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71BB29B70FE
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9514D1C21159
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E772175BF;
	Thu, 31 Oct 2024 00:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gXdYqBAG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E4146BA;
	Thu, 31 Oct 2024 00:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334069; cv=fail; b=bxD+6balVo4NRJtKgGvsG4wlGGStuBbcrRF4cPjvEQWrrwSRTW5Bn6knW+dZ5f6GlfCw0tG8Vom7iHuEyKs/G57aN/yrTxMjNInRjjSSnTKfYbH9lJroUGOTyFR11zh/cBUNCiPXAKEkuJ7dZZWR85FHJVR4zKbRVw55JwRawbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334069; c=relaxed/simple;
	bh=c9rUn9wHOird3avTaszgaofVIUPGI4QopkEgof8dJ9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iai7xWpodQd5e/09jrIUNE7HmKa0mEkJ2hzxmrhnBUsUh98/JQOSZa7XyQEiCRoPWkopNpI2LYzpGZoLZ1z3cSZ97JKZIYb1RdFVUuoXOHgvqsOotNlnVD0zPybTxvx+xodqmp4b80DtBJoVN8pWwWqDOZ0O9YG8/frxuN24R0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gXdYqBAG; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1Hbe6TXotNCj/FAWEMlNTb/w6bExFqqbYaf2g0Z3z18eF4vF1d3zuiv53rwmo+ViutaGPi3mJGJ65qi1daUWoz4Z0yyv2Nt1rtD0H6hmfDf3WjNhsjxe6/OJIR+aCSfGWxtG3bIx9Mo7MnqX8fbemhCM5CUnqh5tF6eC3CPoMrRyhZvXRZNhcCsMbeAQ7fRexarOodENFcv/kr2/DH8QJzrDlc9ESt/K74jVzMeVms1qGwnHCYe2AqSePpDGqTTaKKlpp1fQzB6PKuI3a1B35k+OziJ0DxcJyfnX4Cl4Ea9MKgTng97Fa0pvkAt4aWRoRpYrCajvqy7djRyX6+vDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNtyqIko+P2oFzpHTnwF3/c8cslqKoObVtLZgcQmtN8=;
 b=tHGuzNVSf0V8Pmqp1kQtoh2LbTtVsSKLsavBJDu37aiAt5DAyH2cUb+tc1TbqtyZrX7hw6JhwOyzST7HsB4uJxdXXBZ9nLylJjbf1ArNOpocWeTdN+PKBdLTafflO7uMU33rWmCHsuPCgRem4huJFj9PsfvP+Qd3y//VHIyKYwM3QAFmedIrevviuzGUW/p39Rm2G/t7COlHnoa+SaE5nOLEUJaOsoN2+catMRj5PRr5lCQKraABjyEySvObsZv8ZhH3fj1vkq8YaVMoTV4c+OEMGAxOKiE6aBc6z/xnKFOWUhUmMIF/+MmWe4t6CPvEKAO/56BRwW6Hv/uTuKrPTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNtyqIko+P2oFzpHTnwF3/c8cslqKoObVtLZgcQmtN8=;
 b=gXdYqBAGDw9WWkD5eNFI+pb159+pXkQ81IgkhS479GEl2Vb28hDwbSU8cKme4bkxwDsNJdn3jMHe/Rodl5LT2PwFRp7xC7JNajKchPIY+AC1G0OWMCm5yTZ1x2zES8roJ61053GEVoL097YJrJIZSQ7P6hetKYNjoMlM8q6QK8hOBYgg8NMm5PhnhyXLSOb1DqJEN5cUMIsGIuwvgEOjvGuLg/E4/0UxjCurxa7n8C2bZ9bm/WLOGrmZ5u6N7W42homNAk8CdJZhnw3T3pQhVM8cHy7as4cekFRlTufIurwGtHT8zMyICXhOFQvPr6GxgTCZtQoYL25dtxGvfu9rKA==
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
Subject: [PATCH v4 01/12] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Date: Wed, 30 Oct 2024 21:20:45 -0300
Message-ID: <1-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b64a886-e9f3-453c-3a23-08dcf941e3cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YhtaZP7xQbm1ytJaUc6C7RD+k/mITEzyK+v3PrLU7Wh33e4l10VbSUK/v+jy?=
 =?us-ascii?Q?mMHk64pCu15FIq+ax/IsDFnD+DpV5vqW9niJJW92O0PFE8DihkQKok6GrkHJ?=
 =?us-ascii?Q?zxinpipjJQnVu33WBq6szhzaI48aWClMMvZq12hcYvsESycyOvuzTC+A2Wwn?=
 =?us-ascii?Q?EefU21UM3J+gLqVqq3YxB7tvubof77noZCqUo7PcAiIGojI89TU+74E+2OCz?=
 =?us-ascii?Q?oynsWalgti4WcR//p/4irFtsGPTThbej7dJ5qq+PU9Y1f6+hd/W6O+MLXyiq?=
 =?us-ascii?Q?yHGraATJSac7P2dH6g8Ze2wyCvwbFtQ9KhSwCRuj0GsiSq/qjC0LTfKnjs1k?=
 =?us-ascii?Q?0zTSAoUiBX4d7aX56eXt2fDpGNmEnMKbVByMPGuOxXg2rELMlYb5fbRbAJqz?=
 =?us-ascii?Q?cSHhm5NPWaCH2JSJ4iP/VLQonK/n1tQe5rL/nEd469Dr685Vcr7Hk3dWTq2R?=
 =?us-ascii?Q?sZo9diMudEM4UdFByEozRBYw43U9UyKrECZVN/xOAKBJvbr19pESEEIMGne6?=
 =?us-ascii?Q?G9Do+FdqN8yC0h9QLVJ43t/IwPD4Orzv92ghnEuwMeA3ch9r3Om1P1YKfQpl?=
 =?us-ascii?Q?PJE6LSmapiikWJ1doqC2LLVXaPoZ5yjlkeiI6U407au4mwrgx6EWXh7V9UN0?=
 =?us-ascii?Q?ITn4563Kq5lXBgOLK5+yRyeirDtLAzBzp1ULeKB81yIBG2OMJmAniRYG5b+o?=
 =?us-ascii?Q?OaHke8EQkubUXk+ZOuca3HNW3aDxliafkOL7ZM43C4JVu9H4/wrI50KhKbpo?=
 =?us-ascii?Q?jgugcRYEAh/c6y4EiujycbNvHezi9kQyTO+xNyv8N0dshnVf5Cf65pp6Ghxt?=
 =?us-ascii?Q?4KS6wGVlV5kjaAQh2OwRArDd+yKkwuPx3Cu+I2v1dvwyxXZelhtrhTTrHx+i?=
 =?us-ascii?Q?4om6+xzEPrkPsyNHjgxEXCee2hOzbyG7TxO5V4FfhPJ0Sh/PAtnBvCmLY1fF?=
 =?us-ascii?Q?BvIaVx8+vDBk+3y7HdhUn7DR7pSEFhxazukW/2Y8xHagRgAUgJwRQBUJsqHH?=
 =?us-ascii?Q?he9/JBDBX6EWrbmYVTKsTycIR6bep2F/23BvMAUT/7HpZzOdbDi4zZnrO7bd?=
 =?us-ascii?Q?3k7Nchua7Ng4ii3Qv21O28tpq9qvLHYvKhBhEsSLys9LqPNAFPzcDhBqRpav?=
 =?us-ascii?Q?fgEH5sVpMeZ8pYGQnbr2fCHvWWFToZnzuU0gGZ4W59dIlHwcnNPe+s1AA5D2?=
 =?us-ascii?Q?GMh8ZrrB1TbQMA28y4llAzT7pqRv3HkINocy23OkKmXPcHd/x+WaKBiEdSjV?=
 =?us-ascii?Q?VaU0WfeRNb4eud6muC+VyB5XKEu7+9Ohe13OoDQod4+9nnZHDH+jy8kCQkjH?=
 =?us-ascii?Q?9m652gyaWfmghrXDqvkieQ3hRZzuVJUFpdyxliv6T+GkCCdvk+0hzEd0n0HC?=
 =?us-ascii?Q?8MbwJlQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eUGO90KGPX5GpGohPv+DBxDsjvhyRQ9Wemnm2vdAtALNjat8ngtGu29tr+6/?=
 =?us-ascii?Q?vUmiZH8x7HWExKVlArNGVumfp9JUIIZHUtnTkmprOqNitpk2lAF77CbGvAti?=
 =?us-ascii?Q?YouAZjSwGRXFR1u8+z7W/YAwnqrPY/lZnaP2vm1vJl/TLU5kViuNg2m7fedX?=
 =?us-ascii?Q?9ZcZFy510PODiSMFaTqnTjlDngyGRXWY8Me69YrbQSna+7KGJhJeKus58XCJ?=
 =?us-ascii?Q?jTrtHnjMuEpoB4cceUJzzvEsdRaGllmF3RVF7Aeyw9DdhhXyLeL1Am0qddvk?=
 =?us-ascii?Q?vWu0XgvTmP0d4EKemwi7oueY9CB9OPp+ZrqdWSaykQgHr4B35kWzjw3H1kAj?=
 =?us-ascii?Q?9FqxVoSDvOSiiZwt6LieZkFUZ98PCQf4xbDiNJHQWKQxzgRB95nA3zDsqT30?=
 =?us-ascii?Q?s1QRfVniU73GV5Qn8LcdfXQB+RHDrRl0G9vpeAZm+4naDfIciZrBuiMVbKae?=
 =?us-ascii?Q?X3Ro5SAhi6sM5n5UPb34WycuBlH0bpIjc3S6J1d3Wa/NsD44tNES6mia7dV1?=
 =?us-ascii?Q?IfeuxqxeiGzuiiQ7shucBSRlb9PLVgYK7VaI718VKDkB48w5swxmO4FPLW5O?=
 =?us-ascii?Q?9KIAMqSOPBSjN6Sq7+JJ0UlMga9eEtcP/N3f3AJiT9GhvWMawyuUYq4AqSH7?=
 =?us-ascii?Q?QZk8JtT3qJhzs+R7easvKwIWm2jVXIcHO78yEjs22kgvjub4ojV+Sk6AcIYV?=
 =?us-ascii?Q?OmOlKRt/lyX7cQErbuH0n7+5+mPptYghXS0/HOcdarltVtHx+N2GneasgS9A?=
 =?us-ascii?Q?pLcM5fETYjHgPG179oMBv+T5FM44ti5e4z1A82XsiRZB1NcTTb+Mh16T0i1Q?=
 =?us-ascii?Q?bKV2kevx5ZIo0ZaA8FkaVOOSv6sZzA+Df9xcirNKsvYdt8VnNzfNIpz+olrV?=
 =?us-ascii?Q?KHMu1OCZetXHXYbDBB1pQj0fQ+PRsKmX+sOT4YFfgYz/fB3VVh0UXLhyIDAW?=
 =?us-ascii?Q?BW8dr3F5O3H3PZLwuEErm3Xr6rsXpNlID8/TCxCSX1u5+GjI3/lYo6fgrWZb?=
 =?us-ascii?Q?AOfDc14eOCldqS7aE/YZEP+kzims0WrMr42U4o+YK6qIbpatrefI9wJ/+llF?=
 =?us-ascii?Q?0q0Lj2T2xip5FYKhf7kSHhDyfdOA7kQNODy8bJAEIYD88cPmSMlZYGAJw8bD?=
 =?us-ascii?Q?QExGaF+gjXya+yRXKrInmEEeZDfjlvE98uJe6bZkGtrSXRt2Vqmsi7LUrHXX?=
 =?us-ascii?Q?6NfxxqpUpEhIPoinUKY1ymWkvs0tllpYI8qZ9G3IRUyy+r5M4nGiBhmDdWG4?=
 =?us-ascii?Q?E5KWmYsFXccma/zBgicBdLCfcpmofE2HkvirBHsw6/VK5hYrIj+a6g98sTSx?=
 =?us-ascii?Q?R3/4iL1wF2T3tPu3hN/CL9aS7glOAPSiFH0clclY6VWiDM4V6qWDwXni54iP?=
 =?us-ascii?Q?MgRdtABJjIkKtVOhXzgu59x6exyvXc63sAfOgfpXzDXeMfgp4JSL5bRNB8UM?=
 =?us-ascii?Q?YSsiOu0z8LkkyCisCw5ftmx+b1guuag44GOfJ8jNIPY2hW0bN1VYlPhmKRe8?=
 =?us-ascii?Q?3c1goUeqJ/b9xDr1nF6VUa9yZ30vxJoGwWgnfJ2DY1S21ikKIoZKC02iJvFY?=
 =?us-ascii?Q?sp6jZSoov1eiCEalPnw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b64a886-e9f3-453c-3a23-08dcf941e3cf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:57.2018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MMQbd1JTcPAmfs1XwMvTxcAPN/k3omlNgAAYWSonIuBqVoCjPoc0F57GRZXPct01
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

This control causes the ARM SMMU drivers to choose a stage 2
implementation for the IO pagetable (vs the stage 1 usual default),
however this choice has no significant visible impact to the VFIO
user. Further qemu never implemented this and no other userspace user is
known.

The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
SMMU translation services to the guest operating system" however the rest
of the API to set the guest table pointer for the stage 1 and manage
invalidation was never completed, or at least never upstreamed, rendering
this part useless dead code.

Upstream has now settled on iommufd as the uAPI for controlling nested
translation. Choosing the stage 2 implementation should be done by through
the IOMMU_HWPT_ALLOC_NEST_PARENT flag during domain allocation.

Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
enable_nesting iommu_domain_op.

Just in-case there is some userspace using this continue to treat
requesting it as a NOP, but do not advertise support any more.

Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
 drivers/iommu/iommu.c                       | 10 ----------
 drivers/iommu/iommufd/vfio_compat.c         |  7 +------
 drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
 include/linux/iommu.h                       |  3 ---
 include/uapi/linux/vfio.h                   |  2 +-
 7 files changed, 3 insertions(+), 63 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 737c5b88235510..acf250aeb18b27 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3378,21 +3378,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_of_xlate(struct device *dev,
 			     const struct of_phandle_args *args)
 {
@@ -3514,7 +3499,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.free			= arm_smmu_domain_free_paging,
 	}
 };
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 8321962b37148b..12b173eec4540d 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1558,21 +1558,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks)
 {
@@ -1656,7 +1641,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.set_pgtable_quirks	= arm_smmu_set_pgtable_quirks,
 		.free			= arm_smmu_domain_free,
 	}
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 83c8e617a2c588..dbd70d5a4702cc 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2723,16 +2723,6 @@ static int __init iommu_init(void)
 }
 core_initcall(iommu_init);
 
-int iommu_enable_nesting(struct iommu_domain *domain)
-{
-	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
-		return -EINVAL;
-	if (!domain->ops->enable_nesting)
-		return -EINVAL;
-	return domain->ops->enable_nesting(domain);
-}
-EXPORT_SYMBOL_GPL(iommu_enable_nesting);
-
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirk)
 {
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index a3ad5f0b6c59dd..514aacd6400949 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -291,12 +291,7 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_DMA_CC_IOMMU:
 		return iommufd_vfio_cc_iommu(ictx);
 
-	/*
-	 * This is obsolete, and to be removed from VFIO. It was an incomplete
-	 * idea that got merged.
-	 * https://lore.kernel.org/kvm/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/
-	 */
-	case VFIO_TYPE1_NESTING_IOMMU:
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 		return 0;
 
 	/*
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bf391b40e576fc..50ebc9593c9d70 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -72,7 +72,6 @@ struct vfio_iommu {
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
 	bool			v2;
-	bool			nesting;
 	bool			dirty_page_tracking;
 	struct list_head	emulated_iommu_groups;
 };
@@ -2195,12 +2194,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_free_domain;
 	}
 
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
-	}
-
 	ret = iommu_attach_group(domain->domain, group->iommu_group);
 	if (ret)
 		goto out_domain;
@@ -2541,9 +2534,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 		break;
-	case VFIO_TYPE1_NESTING_IOMMU:
-		iommu->nesting = true;
-		fallthrough;
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 		iommu->v2 = true;
 		break;
@@ -2638,7 +2629,6 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
-	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
 		return 1;
 	case VFIO_UPDATE_VADDR:
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 11de66237eaa19..099d8aa292c25d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -695,7 +695,6 @@ struct iommu_ops {
  * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
  *                           including no-snoop TLPs on PCIe or other platform
  *                           specific mechanisms.
- * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
  */
@@ -723,7 +722,6 @@ struct iommu_domain_ops {
 				    dma_addr_t iova);
 
 	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
-	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
 
@@ -904,7 +902,6 @@ extern void iommu_group_put(struct iommu_group *group);
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
-int iommu_enable_nesting(struct iommu_domain *domain);
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf1902f..c8dbf8219c4fcb 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -35,7 +35,7 @@
 #define VFIO_EEH			5
 
 /* Two-stage IOMMU */
-#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
+#define __VFIO_RESERVED_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
 
 #define VFIO_SPAPR_TCE_v2_IOMMU		7
 
-- 
2.43.0


