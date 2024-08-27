Return-Path: <kvm+bounces-25203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6803D961944
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 23:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB473B22D75
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 21:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9211D27AC;
	Tue, 27 Aug 2024 21:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CTjdfyxe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2064.outbound.protection.outlook.com [40.107.102.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9485198E89;
	Tue, 27 Aug 2024 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724794304; cv=fail; b=K0trud0RmbZ1uYzcCQQ2A0VGGavl1Q3yjXLW0Z8ZQ2xzCGR/UvONt7pR8tcsipiX6oRGr89MKrM2ymWTe0WUdvBk/8GKerjx2jyyX0flnfHQpl8MC5lu2Ik39uigln3K2+xVT2fZoOyIhM0gWKhf58tbIf6jXKZcYlYa1b1wZvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724794304; c=relaxed/simple;
	bh=YR0BG1p2Bz1YXuta3vG0N5Gz2wjf8pv21S9iF1CvQzM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UC740k3rHUr0aMJ7i8PBnqsjpg8ddvIOIPuIuVVicWEI07+0Cxo4WtKQqSn+Z3qr//iteH8ws+8p0+7EO9lMWNH+bgMjS1UcaEJ6g4dJPawMmw84+O0YqQjtQLF5Yv/+JTYg+yw34T6qz9bx077OhU8jQH9ESGQCbwk6+bCIVDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CTjdfyxe; arc=fail smtp.client-ip=40.107.102.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBQsW10lqpxzmN0wg6cD7XYD90DzUZqt6HnQ6hRs4kB4fqu6c49Cu/ZZpVVa9xfXcBnt9RwhzJHXntHwslfiqHKDtBQPjpwNOuR1JZ+jdGVOz+6eqJzUwT7e4ObZVFE0o/tUH5aoCTfbx1LQCgDsmXa+drGtswhY04a+v33jFcweOU4saAQz5oDF5/RM1Yk3bMw9rCNkRSK2z7dTE1sTvYNyQGkEj601xelom5GZCBR2cbCWQwI2m6504Z2k9SoYhDP0tGOD7c5A1hFTipwZ+5FnptMOXCDoiFTbMQv9yNGtuzizc91zXUbtqk00kvahU0kpX82PmSHTXHAchTPmGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEDzPDTQfF3hHzWpXH3yZYmaCtHWQs1uC9TatCgB3Gk=;
 b=lQdYnkCDCi62xirdke8okA3ZoI6AIGI7/xKE+rk2BwHXeBphFOY6dP88QoWE2Hdg/fJacaXuPlfCJe5SwZi3nuZb+jyiQ0msYu0yhLTXoJJBK6aJUFGZQalPWdnazCxenNGjslp6JbpauQjqHMZCqi8/ZW0JQeUXsdD2XWZ7NJBcM1+8tfc6hUZp3vggptW/tIMFk26qyT0eWzwV5FVhE2crCjtcWOVMzeEsw20lAx+5w8yJwnS3Rq1Hxa7+1qubScA5UyeFuAHbLphZsgs9vOoZ9LDCbT6sgYVca+bIBeYL4Rq4fHkwePZ3hewCW5IOrNlKvFFC+hTgDPOKBv4poQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEDzPDTQfF3hHzWpXH3yZYmaCtHWQs1uC9TatCgB3Gk=;
 b=CTjdfyxeRodRP7TqoQb0rX8cB0IJ/f8EMxs6x4njYO5VotkI/ZjNrhMaKOT/GhhlzeU0M40gliwx+zzovUQufCKEs5KDiaR3Gw7WHUAMbS5V/WBwmTr/9kW4Bm0LkiUi9owhQxgnFNzxW21itdZNrm1QKzQ0xZACt51k0TyOhKGCKm2p43TixPXldGyk5zR2G+47nLY07zIk00urAQA5/N585L1NYlCtOd3BNPZ/7tcXh6vWsp2ZK+83AntfkmnDM2FwDcs7CB+luYSmfDCoGQzLeS7e7EIkn5bs1qTzXeUnjttpwoLqgS1oO3xC3xNMn8CPtgAO5qNQrEv2RfPuiQ==
Received: from SJ0PR03CA0167.namprd03.prod.outlook.com (2603:10b6:a03:338::22)
 by DM4PR12MB6040.namprd12.prod.outlook.com (2603:10b6:8:af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 21:31:37 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::72) by SJ0PR03CA0167.outlook.office365.com
 (2603:10b6:a03:338::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Tue, 27 Aug 2024 21:31:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 27 Aug 2024 21:31:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 14:31:18 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 14:31:17 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 27 Aug 2024 14:31:16 -0700
Date: Tue, 27 Aug 2024 14:31:14 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Message-ID: <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|DM4PR12MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f5cb918-c102-4fc0-cf1f-08dcc6dfa064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B7p4ohQzGwPgiepBi1jlgTzkc0pnT4jSKL605EkFeI7k+fwhHHS5lBdJR9Hq?=
 =?us-ascii?Q?Ud7+ZQQWJ4nVWt4UP7r69wMhy5EpEoBfYzlQ0tsvL8KdpABCi7h/7pmkCuG4?=
 =?us-ascii?Q?C9PwhEB+T3CxoqNiVoHxjGE1zs4wRuvRUf1oFzlNihrlvVg9wEFSTkY9EjYF?=
 =?us-ascii?Q?GXN0+1llBveZ3JTg7o/KLc+TC+dAA2lmfm4EU/BqPyESxvuNLDsTwmtSXvoj?=
 =?us-ascii?Q?UcVGsQEiMZojAs5jJ0DVSARVtOCWE5yziO547CTlaYnzQQr0TxA8rwWlJ6P8?=
 =?us-ascii?Q?QCJ17JCZpxuE0brjA/MX2ziBXKWvgBUTYpNlQKtuKHqaFcKtrk4bXAkorOl3?=
 =?us-ascii?Q?WB0aDZ1LC1EUwRjaLBSIYk5cNxbqtoCf5zBdRGJ59nZjLl7GSJjE7hQ9ZJwd?=
 =?us-ascii?Q?WOkFkE0J2XxbbRFUmMlG0jR5AhOYpKguO63M1tAK7Rxky7e3l+ndg2G6BzSi?=
 =?us-ascii?Q?mzqbNMDHjW66NOYX3fEj9e1lzhwHUGXek6/i+3FsGxjDuixWbr6aBQzXiZW2?=
 =?us-ascii?Q?JvAmHkSEhVqTsgcPzOblgxzRdLA1vY1+PodUyuWrO5fCblOgmZ/IVGgH8PXx?=
 =?us-ascii?Q?8XaPzXhIF3Zm0EYUeyhJ+BGH30jZ+9ktXlAQHUD1zoEf+odif7G3e8IM0/5q?=
 =?us-ascii?Q?GMEPppkBTtd6QG9CcNErd93Bv+Yo3gCd/v0wtNBg5tCtcUd6GsrzUHVfuPHN?=
 =?us-ascii?Q?nb27v8ycy3S2EpV1z37ScTPRLFvoYHMcLy9TY6tHSX+UH+s83k4Ns59fDojn?=
 =?us-ascii?Q?rftX1A5nX7mAGomRLSSw0pWzURMU+yo6IvmZ3Xipn2yhzouP4z5ERIYeu4QF?=
 =?us-ascii?Q?4Vh9TjFTI5AuDX5JnSF4jKX22gRKjHW+QKN82dYA3nsep9+uRPWfOuPCLz2a?=
 =?us-ascii?Q?DuhikwNj3wi/5DRXGWWqvjLVUwbX6x9N1Ofi9hzq2U0PxG1OFDAGbvMdFp/h?=
 =?us-ascii?Q?HoFHDdo784AtuYtCZwwyyKBXD0WMEbz12KCReQsn+do0Lo7XojZWSCS27Nvr?=
 =?us-ascii?Q?r+i10HumAw1ahXCGNcz0Hz2Izp3kZJm2KJPdt4YSHhK4vomXIl7KPX08aDlw?=
 =?us-ascii?Q?a2wr+Mw+pO8beT7m22k0BhinMN5ekdUU074Z7r8KCTaNhQ7tl79/V8FOgMnh?=
 =?us-ascii?Q?mu+rIXEhyE3+m2GyZWIDDcc0RykwN7TQjDvNykORqVgTiH7PnSus2hWAsg9R?=
 =?us-ascii?Q?+7X5HY/cg74X+lF8LMxwpGWzrsMIKCGbSGvMItDlGIPSqe3BKVq24brDxSEz?=
 =?us-ascii?Q?0lwCN8UPqGKgLNcm+KXunhQY0TRbbb6T9A+aIG0oRSlKUch2vfq05IGVaVUU?=
 =?us-ascii?Q?edAhHQTFMSGt5I36ybmkQz3MGrKscac5sVt2928ypZtKxfcsZNy7NzyLKdrL?=
 =?us-ascii?Q?JZKKJ6zYgx+lrRrzBcntqt5kMV8CekFbE/HHUriEZzBXGo8i0oehG9v2LIv9?=
 =?us-ascii?Q?wFxMbvwnrS46m8dMVuCVvEuBIpugM1Aj?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 21:31:34.9485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5cb918-c102-4fc0-cf1f-08dcc6dfa064
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6040

On Tue, Aug 27, 2024 at 12:51:30PM -0300, Jason Gunthorpe wrote:
> This brings support for the IOMMFD ioctls:
> 
>  - IOMMU_GET_HW_INFO
>  - IOMMU_HWPT_ALLOC_NEST_PARENT
>  - IOMMU_DOMAIN_NESTED
>  - ops->enforce_cache_coherency()
> 
> This is quite straightforward as the nested STE can just be built in the
> special NESTED domain op and fed through the generic update machinery.
> 
> The design allows the user provided STE fragment to control several
> aspects of the translation, including putting the STE into a "virtual
> bypass" or a aborting state. This duplicates functionality available by
> other means, but it allows trivially preserving the VMID in the STE as we
> eventually move towards the VIOMMU owning the VMID.
> 
> Nesting support requires the system to either support S2FWB or the
> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> cache and view incoherent data, currently VFIO lacks any cache flushing
> that would make this safe.
> 
> Yan has a series to add some of the needed infrastructure for VFIO cache
> flushing here:
> 
>  https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/
> 
> Which may someday allow relaxing this further.
> 
> Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
> this.
> 
> This is the first series in what will be several to complete nesting
> support. At least:
>  - IOMMU_RESV_SW_MSI related fixups
>     https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
>  - VIOMMU object support to allow ATS and CD invalidations
>     https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
>  - vCMDQ hypervisor support for direct invalidation queue assignment
>     https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
>  - KVM pinned VMID using VIOMMU for vBTM
>     https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
>  - Cross instance S2 sharing
>  - Virtual Machine Structure using VIOMMU (for vMPAM?)
>  - Fault forwarding support through IOMMUFD's fault fd for vSVA
> 
> The VIOMMU series is essential to allow the invalidations to be processed
> for the CD as well.
> 
> It is enough to allow qemu work to progress.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> 
> v2:

As mentioned above, the VIOMMU series would be required to test
the entire nesting feature, which now has a v2 rebasing on this
series. I tested it with a paring QEMU branch. Please refer to:
https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com/
Also, there is another new VIRQ series on top of the VIOMMU one
and this nesting series. And I tested it too. Please refer to:
https://lore.kernel.org/linux-iommu/cover.1724777091.git.nicolinc@nvidia.com/

With that,

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

