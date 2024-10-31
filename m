Return-Path: <kvm+bounces-30131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D04D9B710F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA6801C21053
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8317F460;
	Thu, 31 Oct 2024 00:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SSPXxiV6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452151E529;
	Thu, 31 Oct 2024 00:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334079; cv=fail; b=u5kO0L9hc1sZd+ewVpL/gZvUPKIef08by0vCzd6R8XNxT5LYkkI2s3gsd5wMSxiSWNTuy5RWFeyJFWGOzPZ/Gx/Q0I4KuRK9kk2CMR96fsBakdKiwCr4L36eEzxLF8XL8eL6lpemxIg/ozatsp7Xs34lmBBGmgtfhNLQpGqC4hY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334079; c=relaxed/simple;
	bh=XbmTQGc/vRrnv2LnuJTfbzi0Jc/6Zlwu6/Fi9LlHVQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pfDzMkkqYi6Kverm5OOBPswoTTi9DWsU6qR7UzKI2FsGC06KszEXgYN07aRkam2ukTjLAASH1kJ0/V/AzLqELpEuCJhAe7fYr/p56kwixnWiBcrRV5tOFjvuvtM7N8lbbR9IAAC1DCRG/TJI2BReqy7MUYOLdBtjkZxPEiUN9lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SSPXxiV6; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfDgxpzyXscoCjTfqUAY5Qh0g//2HRnbRn1Ng11cfbHMlZqkYMOquwkZ3381z32mHfLYbX6nu/0eECkdL6UPP/A6wYunbUKaIFgI78BF6XqgrD00hlU7wQbmpGKf+LTfCdaDwu0i4wOxx7F/Ge6/fR2xlAiTCM64DREYUHuXnwmcfdBXaHaqJzMhISjOAsp54dUAFFf7C5iEyyLpmxOA8b3CVMXroFJq618WjNmaO6pmthZtiSCBHK+TWwdSKf8Awwd8Uo+PkH1Kjox1OUR0V68jqCY+RSDmkY4nwOWekhszSGmYTWXl2CwZu3SdtzdAheCNRcU7U2S13ZhNt5KIWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0kPj9alz1TkUTtL/HKwIFXP+lK1g0IeLk93PjIXvAI=;
 b=FwJ4J1tVeML0/KL3jfUuS/BKknnc6d1QFMT13iqgYB3R0Hrj3cfQUPbmv3u344FAroYFdWLtqAuwnPK5NIySeGy4SZUcNPNflU/m8lr1yYFdW5LUTA/HOzs4DkAyzpnh83ou76y9nm3eZ7enbJavOBzkrrzUTAvtCvcCc5CJANhnPv9I4837QL0Ld5bNO/EHtYspcaI7jck/x/Nv8oPBL3b3OnRAC58UuzwGVRbq9fmi5NZAfLRIihbgC67j6nusSEvjUj6U3YPynxqT2lu90a/uzPES1vjiqb9NT8Utipk5b544pWZtZ5U7jfJVSJC+Eqgalw5DVsq8my6OCrehiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0kPj9alz1TkUTtL/HKwIFXP+lK1g0IeLk93PjIXvAI=;
 b=SSPXxiV6fG+q7Z/VZ8cc0fk0k+M/LgGYchpeURTZAflxHMulYpWqQTwNGSJPtm0cAJXpMyq0MhMJUb03cPGLGpRxDSe9DyBJytOyW/deU6z8nKLGHbs6C+N0eEpHUA3LlEqO4axdsvQn7wFoDNdmb5OHNi/bFG8SQjuSdz7R61vqMg59L91tQ/kMH57J20X6jHZb3PXnRhdZyk2oZn9JS9MP8nwuNQY/c3NJCBAU1YzIrVHEYUyZ5q6xxPRxmzQr/zyD1DqJXK26Tqg9YhupGEkUOLI0+r5ZYciw+3PVINfpuFWqxjk6/2tTyGRO7FYZr8P55ox116WGgVWWhIFdHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:21:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:21:00 +0000
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
Subject: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
Date: Wed, 30 Oct 2024 21:20:49 -0300
Message-ID: <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:207:3d::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 93893976-43ed-43f2-dae0-08dcf941e467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rRI4/J3WzA4SSB85ISgXm9GqLya6htJFJu268Qcs8ogJRTBIytzmtnXZdMMR?=
 =?us-ascii?Q?onNuR9oq4iJVjEXtukg7LuufW3z5pg3lD36VqganKY0IvLiHN9KclwnHjgT2?=
 =?us-ascii?Q?isBNxj+MNqizOTFTx4tRLhXxEe7xKLG3H19/Rp1vfRjWNQ9RSVEK1yU8DALr?=
 =?us-ascii?Q?UatDdsxqGTMSGBroQvK9z8gqPqhKrx7LjPlGSLmYujGjf2ddeZy3hnYTzJJN?=
 =?us-ascii?Q?tLJUZIsqJ0DOqYnNsJ1O9CZaG6yo37jl7T7S9xolLJ60OPmaMZ+RTUMOtOxB?=
 =?us-ascii?Q?zRHQ8gbXVmgjbw2oCODlp4rNmHw/7CPFrLDlTIPMAM/UA9ulTvOXNGnfwktX?=
 =?us-ascii?Q?5zdPSoN84plVJ4dGPEhrYIW/3kKYV5IyxXHxBJwILosbkM4H52u+4Dvwp63q?=
 =?us-ascii?Q?xm4HHNsUFMMewjt3X0N/joCPTMQLknOMR3kh1qx2MJ111PhYhCiLBLuLULJX?=
 =?us-ascii?Q?scRjqXt7DjQWhHYbR5cw0eIjnNe5gaYdqGQn/Jo1RT15vB6NXh3l+M3TOs49?=
 =?us-ascii?Q?DFDTy5hNSFT5c7w117R2Ptd95CXwvXYVOw2WTl0jKYlh8oxaYgnm298x9AAO?=
 =?us-ascii?Q?Bzm2m1ZWrJRehCJLFBTAGRP6IvbywcTtiUJ38uwvsyLGiLJhBibNSdWg4fMf?=
 =?us-ascii?Q?iwW7etw4wU9tOK+9AjHpuqKnhWkwskiLmrgG3dauARzsmi+NXV5xri+KIROH?=
 =?us-ascii?Q?R+l9jMhb/dWYYJ1d+WZkhOx7SxuwxYgA5umZ3nPgK33Gte2dWaRoNoTE+FUy?=
 =?us-ascii?Q?eBrCzU37tJ9XFRe8NoFJs94FQHiv0gff0+bz3JS/gvYLk0DCVQN4Q8JOmm2c?=
 =?us-ascii?Q?n7SD5cYAadtegr81EyWRznZncKqyGy7B5zuq0H0L5dzNKRlpMu0vKwMNXE57?=
 =?us-ascii?Q?WCuApjPyXErYEs56bZHoGp/PV05NNbpOlP3MxGkIPyrNvlf8wsXT4YTTZFk8?=
 =?us-ascii?Q?nEOkDX/RiO6tkcaYC9AhDLDyN9hCR2gFp6k/t4iGog4wkbprJJ9MBuzrUrBM?=
 =?us-ascii?Q?4giVOIBigZH5nmP/q5IyJnEUoORHjkKvtCtWV/cSk9cZD0KPGIVqUKPQhb6s?=
 =?us-ascii?Q?ZEYM3hTO1Vurnl/6KS1WjWHNcuQn6V//dNLpg7ILVbrhkYxUUMG8+iFLlzKa?=
 =?us-ascii?Q?zDE7IU0+An6pvgZVWDyd1KVYlR0YrwTvEAnhncyqUZo/FC8PNeKe6s7vbLJK?=
 =?us-ascii?Q?Uun4IKdYvI7IWOoqAgfEp8DsiocKz0xwllJH15RNE2MSLcgcsLozsa76gbXn?=
 =?us-ascii?Q?wGHiEg7MHmIlIlIVGsVxe4rVv9rCiiwMn2ZWPOkKv4uEPLugpEirpdgDO69y?=
 =?us-ascii?Q?UhLzrV6sARJOJIE4SjVlGFGHjosk3Mh+/5Dw+ndhbtpgqz9ObymtCm6gz3zt?=
 =?us-ascii?Q?gzE6U/c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aJwqKDxLE7tl6bIgPRXD+3wGvwjq1NQST2TIAST4kevnvZA8E1CQgAWJK+nA?=
 =?us-ascii?Q?2CGrpf/QbZIcdI30HtHlN2thsMo41SGbzU1XHTM95Ijn3g4u2c/on57eaSEK?=
 =?us-ascii?Q?B6S3IOM+g5EbZWYslXxv3N0zwxavcnHWhctUXthQOPu6tGCWRBVlS6GkOX44?=
 =?us-ascii?Q?Klvp5adg+mm18Z9u8rw0LnHYj+m51zRzAJDRptqHTc4uy61a0xprzxS6dIxI?=
 =?us-ascii?Q?mzBPd22SPQIChkSE5MYl/tXv+SjyFJM6VzDDVfrL/Dh7x2gg9NnLtMqQmxCZ?=
 =?us-ascii?Q?TRdrnvnGIOPOXXsf2LdVwVHoKGisTrEZr1SZQ7kcM/wHthHQ56zc1seItUmP?=
 =?us-ascii?Q?DXnVQ0E4TtYkPcYxjw+kfMcicw7CzOu+kqB9BPJ6MECxpWjoz57CMVbd8K4E?=
 =?us-ascii?Q?B6f9rsYb4bQXLwywBs+jmu1a/sMHf8IIFGmmzRmOxHoDZck/N9Z81JTo1cZe?=
 =?us-ascii?Q?Cj++BHYoIFsaKN6gZoJXtkhkr+OZQCuwGFkqX3m2tU8qBNHzatREofslT0sk?=
 =?us-ascii?Q?7d2b/CC1MEc831ceZ+RKiMI/ClOq5VHDCO+1TgX/FWrv+2/tcOlEGhBlKKWH?=
 =?us-ascii?Q?5tZ6I8uUEFYuhUWk0fMGfrD7uvtXjNhuKf0dJTAy2w0uOWsKRXc6aPUyBx8p?=
 =?us-ascii?Q?rwzJJb2Sdnlwwk+NDEmozI1yEbmriAhuqqg2prONs4KRFQQW/CD2LXwEyr8d?=
 =?us-ascii?Q?VnkQ/erGGiEooEPfrbk0B5vkkty+5mhVxg4YQVmu5ZcYgxMRMpDQG601GBGs?=
 =?us-ascii?Q?9R0na+Oa1GkxpRhQtfdipF9vbzlQZsW54f8t6WUGgyxtanxqGMaRc8o2Fu0w?=
 =?us-ascii?Q?e/9G9zmgyx1sK552Pn98fhJt1VTvPzDv10r165n9CsKjSZTx6Y4dBmhZRQkv?=
 =?us-ascii?Q?FKJ6EZUtbRDS4Q/qmn5b0o3KrciXYrnAtTuLLsfZGaUYh7shYWzWEUPUgYna?=
 =?us-ascii?Q?MmsYI2cvH4MGcTEWsHmh5pxQo9vzVN1LeRM7XLgk7ta66TbffmojOuM3hvUH?=
 =?us-ascii?Q?tuZbIfDHqXsQC3wvUntqXrfGAt8sZfSQ6F9NlTxjq3+qjMN3gIzy5xP/ezcE?=
 =?us-ascii?Q?voA2bOl2ufVM7BasGVrSyBmyAi8VzIpdeishRSM54hSvab9zsQHNQopCNME3?=
 =?us-ascii?Q?QWB6Rh/x5LYyC02TU/Nc6G5WWGDbbBPNxX6wAAxY+fQIHDglcsTlHoKItH4+?=
 =?us-ascii?Q?N9Ude96JqVZquyJLcE6uk2ZLOe96pNixoYEl+HtbmhU9baYBR/hUPDAzbk5/?=
 =?us-ascii?Q?KFPgCc3Mroft3jCfa6VNK8syBnp15Cx3qWe92NEpzAX0GJ8/xNQCrbaMsl+G?=
 =?us-ascii?Q?ohFH0tAe7IJMHgf17H7fEl3E/NPvn/Q+h+XlF4SXH+WpKiTKVoGBVSVUdRxN?=
 =?us-ascii?Q?sGomvYhSWvvU3pv5lXuAXd07i0V3Fymu4FBE+jORw43nAkx0M8/JzL4N9eLB?=
 =?us-ascii?Q?FfNUZ3frvjmKUumi4EjZXg/D1SlR8923gtDIQ5oIJPW70oX+Mlb5iohq5evr?=
 =?us-ascii?Q?HHaCoSSeLEzw46tVFDzRkn0C5/Xl4IRN1PbTLtjZnXhwN/XQeKzqHUKXt36j?=
 =?us-ascii?Q?86f53GUaNqLJ9lPBGb0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93893976-43ed-43f2-dae0-08dcf941e467
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:58.1762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdLrVgl+TIblqI4dCmJwDkBbuEvIbkYnOzJvXHmWT1DuW0gEF4gDNHHgH7gOMjvF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

From: Nicolin Chen <nicolinc@nvidia.com>

For virtualization cases the IDR/IIDR/AIDR values of the actual SMMU
instance need to be available to the VMM so it can construct an
appropriate vSMMUv3 that reflects the correct HW capabilities.

For userspace page tables these values are required to constrain the valid
values within the CD table and the IOPTEs.

The kernel does not sanitize these values. If building a VMM then
userspace is required to only forward bits into a VM that it knows it can
implement. Some bits will also require a VMM to detect if appropriate
kernel support is available such as for ATS and BTM.

Start a new file and kconfig for the advanced iommufd support. This lets
it be compiled out for kernels that are not intended to support
virtualization, and allows distros to leave it disabled until they are
shipping a matching qemu too.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Kconfig                         |  9 +++++
 drivers/iommu/arm/arm-smmu-v3/Makefile        |  1 +
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 31 ++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++++
 include/uapi/linux/iommufd.h                  | 35 +++++++++++++++++++
 6 files changed, 86 insertions(+)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index b3aa1f5d53218b..0c9bceb1653d5f 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -415,6 +415,15 @@ config ARM_SMMU_V3_SVA
 	  Say Y here if your system supports SVA extensions such as PCIe PASID
 	  and PRI.
 
+config ARM_SMMU_V3_IOMMUFD
+	bool "Enable IOMMUFD features for ARM SMMUv3 (EXPERIMENTAL)"
+	depends on IOMMUFD
+	help
+	  Support for IOMMUFD features intended to support virtual machines
+	  with accelerated virtual IOMMUs.
+
+	  Say Y here if you are doing development and testing on this feature.
+
 config ARM_SMMU_V3_KUNIT_TEST
 	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index dc98c88b48c827..493a659cc66bb2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-y := arm-smmu-v3.o
+arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
new file mode 100644
index 00000000000000..3d2671031c9bb5
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+
+#include <uapi/linux/iommufd.h>
+
+#include "arm-smmu-v3.h"
+
+void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct iommu_hw_info_arm_smmuv3 *info;
+	u32 __iomem *base_idr;
+	unsigned int i;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	base_idr = master->smmu->base + ARM_SMMU_IDR0;
+	for (i = 0; i <= 5; i++)
+		info->idr[i] = readl_relaxed(base_idr + i);
+	info->iidr = readl_relaxed(master->smmu->base + ARM_SMMU_IIDR);
+	info->aidr = readl_relaxed(master->smmu->base + ARM_SMMU_AIDR);
+
+	*length = sizeof(*info);
+	*type = IOMMU_HW_INFO_TYPE_ARM_SMMUV3;
+
+	return info;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 38725810c14eeb..996774d461aea2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3506,6 +3506,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
+	.hw_info		= arm_smmu_hw_info,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.domain_alloc_user	= arm_smmu_domain_alloc_user,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 06e3d88932df12..66261fd5bfb2d2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -81,6 +81,8 @@ struct arm_smmu_device;
 #define IIDR_REVISION			GENMASK(15, 12)
 #define IIDR_IMPLEMENTER		GENMASK(11, 0)
 
+#define ARM_SMMU_AIDR			0x1C
+
 #define ARM_SMMU_CR0			0x20
 #define CR0_ATSCHK			(1 << 4)
 #define CR0_CMDQEN			(1 << 3)
@@ -956,4 +958,11 @@ tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
 	return ERR_PTR(-ENODEV);
 }
 #endif /* CONFIG_TEGRA241_CMDQV */
+
+#if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
+void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
+#else
+#define arm_smmu_hw_info NULL
+#endif /* CONFIG_ARM_SMMU_V3_IOMMUFD */
+
 #endif /* _ARM_SMMU_V3_H */
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index e266dfa6a38d9d..b227ac16333fe1 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -488,15 +488,50 @@ struct iommu_hw_info_vtd {
 	__aligned_u64 ecap_reg;
 };
 
+/**
+ * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
+ *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
+ *
+ * @flags: Must be set to 0
+ * @__reserved: Must be 0
+ * @idr: Implemented features for ARM SMMU Non-secure programming interface
+ * @iidr: Information about the implementation and implementer of ARM SMMU,
+ *        and architecture version supported
+ * @aidr: ARM SMMU architecture version
+ *
+ * For the details of @idr, @iidr and @aidr, please refer to the chapters
+ * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
+ *
+ * User space should read the underlying ARM SMMUv3 hardware information for
+ * the list of supported features.
+ *
+ * Note that these values reflect the raw HW capability, without any insight if
+ * any required kernel driver support is present. Bits may be set indicating the
+ * HW has functionality that is lacking kernel software support, such as BTM. If
+ * a VMM is using this information to construct emulated copies of these
+ * registers it should only forward bits that it knows it can support.
+ *
+ * In future, presence of required kernel support will be indicated in flags.
+ */
+struct iommu_hw_info_arm_smmuv3 {
+	__u32 flags;
+	__u32 __reserved;
+	__u32 idr[6];
+	__u32 iidr;
+	__u32 aidr;
+};
+
 /**
  * enum iommu_hw_info_type - IOMMU Hardware Info Types
  * @IOMMU_HW_INFO_TYPE_NONE: Used by the drivers that do not report hardware
  *                           info
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
+ * @IOMMU_HW_INFO_TYPE_ARM_SMMUV3: ARM SMMUv3 iommu info type
  */
 enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_NONE = 0,
 	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
+	IOMMU_HW_INFO_TYPE_ARM_SMMUV3 = 2,
 };
 
 /**
-- 
2.43.0


