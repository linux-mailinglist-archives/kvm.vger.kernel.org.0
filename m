Return-Path: <kvm+bounces-63243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B466BC5EE40
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 19:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0CC25356ADB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F1E34A3AE;
	Fri, 14 Nov 2025 18:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BW7GYuWE"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010024.outbound.protection.outlook.com [52.101.56.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8F1343D8A;
	Fri, 14 Nov 2025 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144841; cv=fail; b=B9PMV9T/xKka0Z1c6YTVv3huiOxZb9Ho+G//Q/yDrH0OmLXicrHFTIXkTXyKoNKDjwtVFN5MRLmaeRrNW8gn7huEuuNHqMNafCBWyYNBos/OZbbEkkXD3wQRR2HzWFFaeBru3N2iT8wpxYIOmzIJ9Q+WoHeYl+mUyJyiVF9wYuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144841; c=relaxed/simple;
	bh=H1XJytw1gnKE8eGF0jPt9aJBxct3h5dupImCZj7r1Wg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZK0jiggBMgoXYmzFcCgsh5FwCLiqkq1GHFqT1UkIeapHnbeXdbHAKR9X1z818LvHdRZlRpVjL1zda/m8KYINndqRPaIjsTR5jft/+UnSZhT57+UhKiOV7jts1J5PRDC5rcwQONGubvYiPZ2Y2MF5Aeqhaxd+mC82U7CCw8qOlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BW7GYuWE; arc=fail smtp.client-ip=52.101.56.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VrHv2QZNPmVEYGhc3hxI8eQpkgiq5pT4h/CEIkgu/oPcyPi5F0aAd2FJcsx1ZA7h2ptM3Bq4TfVij96stuHdLBRjhBuFO/6rb6bCN7JtoyyV4VGLiHjkXpS0+L4A1dKUphtmfZMjWaZH37lHHG/ton1BIDBYgaW5l2THngyLKTJR+d5bYfHCAAXCPp4faqqsG4uydG69Gi9yJ+al1/pzYff638aGvbMhBM9QMiB7N4CZ4Ec2qSQmBpU0JiFUlQa38MD9HhD/x3yI7fPWpcMLT0LBl/mFysuRtBOklZ5YVkZjMLVjJdMtn2/zkl3F3+LB7fZ+HrcroWuvVkEv8gsWyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppuqIv4DsEDyTPz5netDrHF9wd1yn/r5ilOVoAffbdg=;
 b=KfueVNgpr1cScF0LbgrL8wmEoFvfCIt5zTeHnJZLT8IAy/Sb/wT0OMG2nDcyneicRg7qghQlYph7DlDCqG718J+S+BXq4j+xaTlDv/UVd79gYnLrV24CufYFM94d0lxHgLwN3WgqAHPkZZt0us6o0Q7Zt01OVf6g+h4d3e3bXdqI79QKdUlWGYKNcAjmYcKraCiUHV7q7LD8a1/iQ4QBCfu8IP1p0M+ya4QFyOrFJJzjjrjg5ets6MXe8pfy61kC/HehzBo4+oBN0bTnypCGZwSXJwjDrxqzdN2XXrbV374CglIKkB3zpZgJLUo+S+2ZWa+3z3YbjssXv0pMBnfHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppuqIv4DsEDyTPz5netDrHF9wd1yn/r5ilOVoAffbdg=;
 b=BW7GYuWEj8jUmTTdBRjnFJR2pzWr7SgjZ7idYv9GMLMvAi+UgTROEuKMkkTfASziGBrSjJpfqKmA91ODw/fnilYCQpzfma3H07fEstt1L8N9M3COYTEY83e6Y8uQewt4jLK6PBjYUABblyhUrpMg79iyId+J3Te2PaKA2fvzW5s9t+RYPWqA8gRxKQ0HIsn8gh8K5VAGxyeadinyRzigkBaWDPjotcvgQX/h4PcMKO9B4aP/kLk8GDejczd6ubjjVDRYdUv8/jND1IPJuM5i4YYtvUaGqmns4VsBYSXHLfwnq1h8WjryhX1HQPvGr3RnaPudJpaq9Kgi71pn2KH6Vg==
Received: from CH5P221CA0006.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::19)
 by CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 18:27:14 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::5a) by CH5P221CA0006.outlook.office365.com
 (2603:10b6:610:1f2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.18 via Frontend Transport; Fri,
 14 Nov 2025 18:27:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Fri, 14 Nov 2025 18:27:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 14 Nov
 2025 10:26:55 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 14 Nov
 2025 10:26:54 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 14 Nov 2025 10:26:53 -0800
Date: Fri, 14 Nov 2025 10:26:52 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "afael@kernel.org"
	<afael@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: Re: [PATCH v5 4/5] iommu: Introduce iommu_dev_reset_prepare() and
 iommu_dev_reset_done()
Message-ID: <aRd0bIFlbRgIzGKs@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB527683978D304128441125C68CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527683978D304128441125C68CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|CH2PR12MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: 075dd32c-8e58-4923-ebfc-08de23ab6f63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5SFY8QV9193IyFQB7lRyx0xcbyHO6LyZPKfTly/bhfjA8pkBjiSwLNAxzhX6?=
 =?us-ascii?Q?EASh8nYX4WUvIanQi9PMqFWftBXP+ceYG+Vt8apFL5PpAULabCbFr13bkr0F?=
 =?us-ascii?Q?5QtDmebjd9CygipfS7lCDf7KkDtZBntv6ayiduJV1aoSMVKHFlgQGBANjmOb?=
 =?us-ascii?Q?10szY2nG8ltT1RKFbJ05Ku3+Tlyi/gDGkjDcmdKcR5/FhtxXWZNvIRQd5Lav?=
 =?us-ascii?Q?htTwRoH+GUEV24cstHPeldw85qNMgXUKTZymVYd3v2cctDsa53YsZFv8x/tc?=
 =?us-ascii?Q?Ng+Mkncc3g03BbvHB3C7wiydkQBW+ooBLPSC4qt7E9M1MpfKsVb4EKmHElFd?=
 =?us-ascii?Q?y70n7L4Fd71bCZ/lejMqrVV6gZyb5N4VaUBX1K7afgMw/CV5EdgTKOp/It91?=
 =?us-ascii?Q?wXdjWfTZCdiZcW8Esw476DT+2bOAdL4QP5PAGvgxXUBazPfXCt6MTvOB2BkJ?=
 =?us-ascii?Q?+cHZmb2z3YOsmn5MjwpmhYFWZk0pEjARupOPIlhAP2BjworkFZ9qNMSJjQUi?=
 =?us-ascii?Q?EL3xP2Tft3NDpOfdb7udNV6dSZFrKwHSeVOpRZcC0RQ9gVn+ncFnVK9kPZZY?=
 =?us-ascii?Q?1GytGot+LBTDD36ERYpYA4LO74mNBq4keM0VY9OHGdtS8i8hjv4TL1Cz0fV7?=
 =?us-ascii?Q?CTpmkEt8p79lxn4QKh3uvwVsFeOYJy79IeLn28ejBynU4axw8biXgm2bK3KI?=
 =?us-ascii?Q?ZAdKzxaBy76OhkAC4B31/iulLzpI7EifzFdHX/Gv5DMvSKa7lqbfaWOK17bC?=
 =?us-ascii?Q?IP4lUYUnsUtfq8mhcTd2A5rOiKczXHZhihhOO5fTilMiZdUJWawsqYZDF6PA?=
 =?us-ascii?Q?6dKPiOUzXPHzZJqTzaobaW6ktrHfaaHAfcVPixup17vUfRjnj5++CTxC6jtm?=
 =?us-ascii?Q?8bJJU9lFZPmV77tPSMkbnoauwwCBjQ8G6TN2gkOpEbZYgXiB2666nQ2U7CLb?=
 =?us-ascii?Q?+EXu03+RX5tF60/EgfMHJUK2OhXTjQAXi/CuBQqoIYrAai0SraLMP9pM/9zl?=
 =?us-ascii?Q?RaDfpANMVqMcgNZw6VGj+NYRsmi35p0A7kxLlq50OZzKLaPl4FvIxEuJbCp/?=
 =?us-ascii?Q?x97NQlmMtNMVt+MCBO1x+zGaF+M0JzSCIoyCzSC8Ry3v8R6rYHNzeZIegMOz?=
 =?us-ascii?Q?DB2tfeNknCcYfLUBA+EuEkHqTzyEmKsfIu3i0n/kFcuqi+O2B3PeUlX+Rnej?=
 =?us-ascii?Q?unksTwCDzEB16luNiZuc1KlZitgE4CtLq76S2vtWwclCKyEcvIFTPkX9GPCC?=
 =?us-ascii?Q?qaJwIby8mU34SJnP7Azj24cFIDVPCBgLoqTDi4Uy/VHFeeMKbxpMhofgxDvA?=
 =?us-ascii?Q?77bKmTJDpdqyRnf/PtpK750dLM2GASsJaTaxJzQ3E2E+hkxDx7QZZ88LKNW5?=
 =?us-ascii?Q?KPNI5abMctYh+cvO9Fgtycvw5rWwGCk9qYHcmQUnp3fvOYlL71jUpRX/vBJg?=
 =?us-ascii?Q?DmXcTNd4J45CA1JnPEzLE8zNjG6bqgHcZJsvdRED6+5ooTo7GY6vGDU8F5Et?=
 =?us-ascii?Q?jYZTgGY5BY1pU2cX0O0mcVKuyw/Ti3Gc7GyQD50NxEwbqKkO2xZ3qJB7+XUJ?=
 =?us-ascii?Q?RNw6VFqk0vCzjguECx3ejALtHrjt8t4LAvEKyxl5?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 18:27:14.6630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 075dd32c-8e58-4923-ebfc-08de23ab6f63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117

On Fri, Nov 14, 2025 at 09:37:27AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > @@ -2195,6 +2200,12 @@ int iommu_deferred_attach(struct device *dev,
> > struct iommu_domain *domain)
> > 
> >  	guard(mutex)(&dev->iommu_group->mutex);
> > 
> > +	/*
> > +	 * This is a concurrent attach while a group device is resetting. Reject
> > +	 * it until iommu_dev_reset_done() attaches the device to group-
> > >domain.
> > +	 */
> > +	if (dev->iommu_group->resetting_domain)
> > +		return -EBUSY;
> 
> It might be worth noting that failing a deferred attach leads to failing
> the dma map operation. It's different from other explicit attaching paths,
> but there is nothing more we can do here.

OK.
	/*
	 * This is a concurrent attach while a group device is resetting. Reject
	 * it until iommu_dev_reset_done() attaches the device to group->domain.
	 *
	 * Worth noting that this may fail the dma map operation. But there is
	 * nothing more we can do here.
	 */


> > @@ -2253,6 +2264,16 @@ struct iommu_domain
> > *iommu_driver_get_domain_for_dev(struct device *dev)
> > 
> >  	lockdep_assert_held(&group->mutex);
> > 
> > +	/*
> > +	 * Driver handles the low-level __iommu_attach_device(), including
> > the
> > +	 * one invoked by iommu_dev_reset_done(), in which case the driver
> > must
> > +	 * get the resetting_domain over group->domain caching the one
> > prior to
> > +	 * iommu_dev_reset_prepare(), so that it wouldn't end up with
> > attaching
> > +	 * the device from group->domain (old) to group->domain (new).
> > +	 */
> > +	if (group->resetting_domain)
> > +		return group->resetting_domain;
> 
> It's a pretty long sentence. Let's break it.

OK.
	/*
	 * Driver handles the low-level __iommu_attach_device(), including the
	 * one invoked by iommu_dev_reset_done() that reattaches the device to
	 * the cached group->domain. In this case, the driver must get the old
	 * domain from group->resetting_domain rather than group->domain. This
	 * prevents it from reattaching the device from group->domain (old) to
	 * group->domain (new).
	 */

>> +int iommu_dev_reset_prepare(struct device *dev)
>
> If this is intended to be used by pci for now, it's clearer to have a 'pci'
> word in the name. Later when there is a demand calling it from other
> buses, discussion will catch eyes to ensure no racy of UAF etc.

Well, if we make it exclusive for PCI. Perhaps just move these two
from pci.c to iommu.c:

int pci_reset_iommu_prepare(struct pci_dev *dev);
void pci_reset_iommu_done(struct pci_dev *dev);

> > +	/*
> > +	 * Once the resetting_domain is set, any concurrent attachment to
> > this
> > +	 * iommu_group will be rejected, which would break the attach
> > routines
> > +	 * of the sibling devices in the same iommu_group. So, skip this case.
> > +	 */
> > +	if (dev_is_pci(dev)) {
> > +		struct group_device *gdev;
> > +
> > +		for_each_group_device(group, gdev) {
> > +			if (gdev->dev != dev)
> > +				return 0;
> > +		}
> > +	}
> 
> btw what'd be a real impact to reject concurrent attachment for sibling
> devices? This series already documents the impact in uAPI for the device
> under attachment, and the userspace already knows the restriction 
> of devices in the group which must be attached to a same hwpt.
> 
> Combining those knowledge I don't think there is a problem for 
> userspace to be aware of that resetting a device in a multi-dev
> group affects concurrent attachment of sibling devices...

It's following Jason's remarks:
https://lore.kernel.org/linux-iommu/20250915125357.GH1024672@nvidia.com/

Perhaps we should add that to the uAPI, given the race condition
that you mentioned below.

> > +	/* Re-attach RID domain back to group->domain */
> > +	if (group->domain != group->blocking_domain) {
> > +		WARN_ON(__iommu_attach_device(group->domain, dev,
> > +					      group->blocking_domain));
> > +	}
> 
> Even if we disallow resetting on a multi-dev group, there is still a
> corner case not taken care here.
> 
> It's possible that there is only one device in the group at prepare,
> coming with a device hotplug added to the group in the middle,
> then doing reset_done.
> 
> In this case the newly-added device will inherit the blocking domain.
> 
> Then reset_done should loop all devices in the group and re-attach
> all of them to the cached domain.

Oh, that's a good catch!

I will address all of your notes.

Thank you
Nicolin

