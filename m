Return-Path: <kvm+bounces-31681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 12FB89C65AA
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:03:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5383EB44F4D
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8740021A705;
	Tue, 12 Nov 2024 22:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BmNpDOD/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095631FEFD9;
	Tue, 12 Nov 2024 22:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449656; cv=fail; b=FCMI0yh/XReYHMd9VyDjdaoVc1S20aedXIuWxoBGQJxutMCwMr9dIMqZoyAzdgcNgu7NMLYCdZFGg6DFEOUQRJjpGGzJhkLTkvvitl+edybYlQRRaW971ML4Q6iuFl+WELlM3IGLoT6LLppcKkKAAq35WKnWHCi2bNMtE4nltcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449656; c=relaxed/simple;
	bh=LLjMyn6vjBVzBU2o2UTNaXVYWw0uIDjxOxLHSJsMorw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KN+crYbcboJC56muMer8NsfkAoKhQFHEdCVM37B9WM4YlSmUF17B1GSRF40rCwMkC8H8MLzcwS7eDXs/IEZE//sxt8mt56MCrds7K2qn1MaNOqjrG/qu4+JMFXn26L4TYmq3ucwJX7To/Yd1hLKLTxEmHnhwnoo+LM5OWrXBNpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BmNpDOD/; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dkGc6g0V+s/5Vix8GKFtZxCYkvZr87mY/rxGnChFElq9NognnSzq+5ENZ0GjcQWMP+GU2HGgQ6wawsTTvctUA0+WluVCC1/znnXN5zdcIaBO2c1YsLUVGkyb6jMlmHvfpmJdProf7bZS37MQ9xIwZoB1cQb4Vvy56Y6GpBVwBVBK209si/zWc1BDfD60xfZG0qilFztvBjjq1TJwvWjEQ2PRbLm6wJixRsgIgz+u11KGnwIsWg7ybjUN/D2sOCvZCkevmRkczMTWCe5Rs8yjy/hcFzmYklaICJSkcsipOKAnX0ztjpwMmVmjFHlb0H2jZ3E5o7TabmFzUUiNXI+Q7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGOqxr3X5DZMVr/7FpvB8qWTi7UFMc+//XQDMNPPAr8=;
 b=TNODGrV4lHb7xjQiBIHi8JbHsZvI56kLXF/+Wk5NNToVUwRI5dMdCZ5CXYIsYlX6mR88DCyi/qD+Uv4S2zjFYpZj2vIXTNUawX0hDWqHLXYjluQlfiQnTQb5Jiupx3mhqXyn1WtWwcp94q9yO+81cwpCiqMHGRPSB0L2bK6u1hTC4ebmPTmrEfHyAUApoli/H83jWFQh5xpw+wwcmcuSN9fv5MZ+sAah9qzBSWFXnGS/bxlFDysOmNCqxwfGUrLicBHNuDUyNHBAUlHKqoCDE44Nqe+RHd2oqFPJBE4miRWgCplF1/ZBApmIBayxuwREc5tnnO6MJ1fPNn0yCD2TrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGOqxr3X5DZMVr/7FpvB8qWTi7UFMc+//XQDMNPPAr8=;
 b=BmNpDOD/e31L6XgnlufVhS+uWf4NOVyWeNUkuJ+cN729h9LgHs69GueHhreGO9ENulgDC57mseAgxOJACwjB1evNk8Stk6JWHEJQEMgvUAQ8+QXYa63yccpH8CU7bmwmb/U+VXtPWIagNH0jznW/Xb5OWNVm9xa7K+DjIn4LPIs4u/9Y0AnQ33Y6gnLKHU8Ny2f3UsMq3jsdlf+dzciDc8WB7Vv3Gjq/dWPVPxdX8t/4XQQewuxRxSlGZ+7k+XuR5urhNonZfesBbyKKUbwQCNjf+0dCWcScSuMKTBQaRUhqhwbXIVGoZLWLcQAZbbXY8fstb4O+f8JoCsbQedJuhA==
Received: from MN0PR03CA0030.namprd03.prod.outlook.com (2603:10b6:208:52f::19)
 by CH3PR12MB7740.namprd12.prod.outlook.com (2603:10b6:610:145::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 22:14:09 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:208:52f:cafe::58) by MN0PR03CA0030.outlook.office365.com
 (2603:10b6:208:52f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Tue, 12 Nov 2024 22:14:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 22:14:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 14:13:51 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 14:13:51 -0800
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 12 Nov 2024 14:13:49 -0800
Date: Tue, 12 Nov 2024 14:13:48 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
CC: Robin Murphy <robin.murphy@arm.com>, <tglx@linutronix.de>,
	<bhelgaas@google.com>, <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<leonro@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<dlemoal@kernel.org>, <kevin.tian@intel.com>, <smostafa@google.com>,
	<andriy.shevchenko@linux.intel.com>, <reinette.chatre@intel.com>,
	<eric.auger@redhat.com>, <ddutile@redhat.com>, <yebin10@huawei.com>,
	<brauner@kernel.org>, <apatel@ventanamicro.com>,
	<shivamurthy.shastri@linutronix.de>, <anna-maria@linutronix.de>,
	<nipun.gupta@amd.com>, <marek.vasut+renesas@mailbox.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address
 for each MSI vector
Message-ID: <ZzPTHD2D5ATBsoGV@Asurada-Nvidia>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
 <86pln1zwlk.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86pln1zwlk.wl-maz@kernel.org>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|CH3PR12MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: ff59f650-7e53-411f-a613-08dd036754c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+lg+c5kW/VsJ+ka3YrCtIdWIrrEWC+ZigBSwOFyWMOgb2GgRi8pjjWyuMD6i?=
 =?us-ascii?Q?KGe0g51J0MKOndQd9atLhM61ercfjssQngjxWkzYPN0oaURbbmceCc1N0bIP?=
 =?us-ascii?Q?na0hoV7MvwPFT5Sn+6f0LuhKqkLCHd5Q70Th1X/vqgFWCsYK2rL0RGM3yWOD?=
 =?us-ascii?Q?nvli+xllvkkKxIN1IQ/Z8HZkoe5RSd5p8KOMliMtYhVnNSFzvdLgMXtY3L85?=
 =?us-ascii?Q?ztkRozU1Wpx67VOVUJb9QJlkcC3FRZHDtKl23JBvdUjT0+hruSig8vcf/R22?=
 =?us-ascii?Q?zvTISlJHN5GprWirCtDaC0iatS0u0PKaVtTNFUPQ13sajKGccExKhanQuEEw?=
 =?us-ascii?Q?jPan0wtM55tSfTPCIhNxTbBTgPY2audqpfFirJ1wJ0SkN5OUCJnJGk1YD8dU?=
 =?us-ascii?Q?w7romCk9co7F/x7jznrZNH7OmtV4BwgCGT8J+dEkT2ob0G88AYWJk7vlO8Q1?=
 =?us-ascii?Q?quhtkSr3kMZMAuX4d9LdvjeQQGXz0o7YP6BuSK1cMg2JrskqpCUsoVWvq2rv?=
 =?us-ascii?Q?TDrC0psuD0eRPV1qKvZybtaZfRJhw4xY5z3JmMZ50/ZDqN4OIqKPBjEqt4Ro?=
 =?us-ascii?Q?x86H4O9dwv+W3owVzKn7NgULN13pCw9n1C+okqsi9R9GFudw3J+SVQTmwjJy?=
 =?us-ascii?Q?O3uZQMKHXDRSUPC0RzQbSaAIYbEt3JKX/jThqFHvkVF+7qAUW00ACsCDMW0N?=
 =?us-ascii?Q?00VJN2GtulAmfgrEJ5vidJ7ix/WbESbhkmKfgqs3DGjFxBjhrlgWKklvLU/5?=
 =?us-ascii?Q?2SeLsVZlv7OKgii4EBkCN9P7sC/A1RGXOmUnjUOtyIFxGStn/T+Q0AIYMBzW?=
 =?us-ascii?Q?br2MIk1Q7DLI2pS26ouU/UV6G6e1NuLJjgzdtmDRLiXrvdYXKRRcoQrXd1D9?=
 =?us-ascii?Q?/b7uB0U6IXDCIiM3Mz2bNNYJodh+3zCQEZskTplz2B4VfzQa0nwGIwPCt6+a?=
 =?us-ascii?Q?81W5pdZ5ozl4h5gKYcXqRqiQJz5S4gdJWDbr9x2HZf14H3dnJXN7DRGr4Y3W?=
 =?us-ascii?Q?6igqp7yaX6K8+thio4r65UYaCkIBQwApvoyitmCepOm2DKFwlmOjAMFyf4A4?=
 =?us-ascii?Q?65BN1L+p9XhXzC7W1dEFzQwLjso26kesr7U2MZViC/Js8IjRLKnoNurQ1ExA?=
 =?us-ascii?Q?ejfBY7te8IXTxebBzMwbxTh79LYfPHcb93gxgA5nII4seQ6sSHCEfTxp2fZQ?=
 =?us-ascii?Q?pEGuQFpbF655IS+VYh6NBVoJrUI3yJQeJawCKLKePXwF/XtRe4F7wlUMaCa+?=
 =?us-ascii?Q?PQueKDROWxzCrh5EUO5Dz3Si+raeKFelxMYgGtO4zcu5GIPo4xFnPglx4KOQ?=
 =?us-ascii?Q?HrS2OFLKIPSPLY4CvazaojfcP0AYmqc/d2MgCX4Bxj2bfAD77TuojW3yWuoo?=
 =?us-ascii?Q?tsqCBTOA0EXKoZi1Tu5dqjnjzjRZJsAzOdoJUVANhkQT/kOPhQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 22:14:09.3342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff59f650-7e53-411f-a613-08dd036754c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7740

On Mon, Nov 11, 2024 at 02:14:15PM +0000, Marc Zyngier wrote:
> On Mon, 11 Nov 2024 13:09:20 +0000,
> Robin Murphy <robin.murphy@arm.com> wrote:
> > On 2024-11-09 5:48 am, Nicolin Chen wrote:
> > > To solve this problem the VMM should capture the MSI IOVA allocated by the
> > > guest kernel and relay it to the GIC driver in the host kernel, to program
> > > the correct MSI IOVA. And this requires a new ioctl via VFIO.
> >
> > Once VFIO has that information from userspace, though, do we really
> > need the whole complicated dance to push it right down into the
> > irqchip layer just so it can be passed back up again? AFAICS
> > vfio_msi_set_vector_signal() via VFIO_DEVICE_SET_IRQS already
> > explicitly rewrites MSI-X vectors, so it seems like it should be
> > pretty straightforward to override the message address in general at
> > that level, without the lower layers having to be aware at all, no?
> 
> +1.
> 
> I would like to avoid polluting each and every interrupt controller
> with usage-specific knowledge (they usually are brain-damaged enough).
> We already have an indirection into the IOMMU subsystem and it
> shouldn't be a big deal to intercept the message for all
> implementations at this level.
> 
> I also wonder how to handle the case of braindead^Wwonderful platforms
> where ITS transactions are not translated by the SMMU. Somehow, VFIO
> should be made aware of this situation.

Perhaps we should do iommu_get_domain_for_dev(&vdev->pdev->dev) and
check the returned domain->type:
 * if (domain->type & __IOMMU_DOMAIN_PAGING): 1-stage translation
 * if (domain->type == IOMMU_DOMAIN_NESTED): 2-stage translation

And for this particular topic/series, we should do something like:
	if (vdev->msi_iovas && domain->type == IOMMU_DOMAIN_NESTED) {
		msg.address_lo = lower_32_bits(vdev->msi_iovas[vector]);
		msg.address_hi = upper_32_bits(vdev->msi_iovas[vector]);
	}
?

Thanks
Nicolin

