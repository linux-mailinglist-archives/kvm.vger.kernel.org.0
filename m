Return-Path: <kvm+bounces-62911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 13ECDC53C65
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DB531346319
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540A7347BD4;
	Wed, 12 Nov 2025 17:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rhcjydBh"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012000.outbound.protection.outlook.com [52.101.43.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AAC329369;
	Wed, 12 Nov 2025 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969460; cv=fail; b=Ji0+4A+okl/v34UsdXzu3WCQgElIdCvVNubtruGC3uSVlEf1dVUQ1Rg+3NOV64wPJgjEZ7uZq1h51zLowICDjxHyCKSGtJiwoO37511GE0o/khocmwxGj/arfK+5q0Z7LN/L/DYKXh7/lT4ZnbJvh97rh5sjDFLIuNTC/QLUAFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969460; c=relaxed/simple;
	bh=7HfzBxqn+LyPH0jkCeUq3hXhovkcQOT2vd6b7ZP6RwE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHgB7nw+2aC0yqaWFryEGFmA+VfuV7nguAkafvFcYwg0oDSXHU57tHnFVdVFLdXTryRLb9iL62JF44N/Aw9mf2hg4SW1rCaILlc/UngWD1bFaaUJezgHIm0Jf9L4QgA+iTMqqhstxjLRAGTc5I/NA4PYVr9If4Yd2QiwG7vA/NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rhcjydBh; arc=fail smtp.client-ip=52.101.43.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ryyPYEQKLFO9AeAOJhYWkwaZ6k1LrGYR/H1R+TsGH8jzFAatOhG4NzrEHA999Sk56Az97RQf/9/YVfa992g6Ssa2q8AtHv4J20fIp2Wv2JT9YlZs1MQjvHNjY4saJnEiWYOxFwfqFFGWurcTiX/B/p3VjIZnzp9nsYs95GX+9OzkhqoYGLOB6b/bRATx279WwY6QphvVmvGohF/gBZRj8GkygpR+oPzi0s8He7VD0QGr2CpZ8+REJBgoooFgg1fJFodFyWu5FWiw3tDRnV10euQ8HO3CAdUKcv8GdIzEEoUjRFTId/lRvBeXN2QeXeWbAGhwHietglplE6NCxjuriQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwBGoEJYAAR0roKzE+H9MOLs7m9F4M8ABC7zzTWRgaA=;
 b=SSkK+TFBnawxOjviY0UlMYL7Vszca7Khx1lQe07KNwr70oxSwcy9D5D5JA1Wx+Cr4ytYh2m5oztOTW895Vn5790TdJxjDpJkOnGZnVDM/i/gqmF7qiF5x49wD9hRpm1WjH2aq3r5djFiwUKyanYjg7TAu4it+unue+pT+3XTkJ2uiFrxb3jVhWvHQ2WWIX3DFAKKCwq28A8EN5SxgT+yTKodEgiLJB8cKOksX7F0+fofm5OozXcL1g4oprfzTnGxMgT9o3mjoL5xo+lKBGI2FsXQmctxcYaYYkwPufWFCeRb43BAYEbvXOVtW/RKCMBNaxUHXsagsaubTKZFlOuprg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwBGoEJYAAR0roKzE+H9MOLs7m9F4M8ABC7zzTWRgaA=;
 b=rhcjydBhltX4Z6LSfGtX+ToIGNcplh8eSXO4qpmK6fydRpDljLuax5jNvPdDriQ6b5TeJuL4C5+O9ZlgwVNQRYzcJQrFTeOFMtoLPUOV6wzjzOvIWd7PW3C2tVztvJIAZvb9uyS3PuFHMR6886el/tOnDRCIUyg9wOWWnQ8K5gzyuG36hzzrNqXuwXTDUbgh2gqjSW3WD0gmXO5e1EYNT2PW6SzEjXOqPxPLcIBxZPuz08Pbjppta1XoiB14ub0x2IrxQ8qa8y+bjgU9W1wJJI4q6op/+mkWuUbn7tqUa+e6KYDB5TNCz+w9/w9T2GtePMqcGBuTpCI4GQA0k+VXdw==
Received: from CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31)
 by CH8PR12MB9792.namprd12.prod.outlook.com (2603:10b6:610:2b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 17:44:14 +0000
Received: from CH2PEPF00000145.namprd02.prod.outlook.com
 (2603:10b6:610:4c:cafe::c0) by CH2PR10CA0021.outlook.office365.com
 (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Wed,
 12 Nov 2025 17:44:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000145.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 17:44:14 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 12 Nov
 2025 09:43:57 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 12 Nov
 2025 09:43:57 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 12 Nov 2025 09:43:56 -0800
Date: Wed, 12 Nov 2025 09:43:54 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
CC: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: Re: [PATCH v5 4/5] iommu: Introduce iommu_dev_reset_prepare() and
 iommu_dev_reset_done()
Message-ID: <aRTHWhXDrM/sh6LN@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>
 <60970315-613f-4e62-8923-e162c29d9362@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <60970315-613f-4e62-8923-e162c29d9362@linux.intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000145:EE_|CH8PR12MB9792:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b76e622-7c47-4693-bb1f-08de2213185f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bNocK+UlnlSSw0GA2kvzdSN+kevEJOtrtJEJCoMRfohizjdZfPRlZP5NnR83?=
 =?us-ascii?Q?gUocg4K1Sy4eoqB7EypU+RM7psE3Mnb1QOgR1gveb8gacNvUV6TgHuef/NIN?=
 =?us-ascii?Q?chMG5f1PPzKzbXCz7j5tOLkhyCq0haDCeulp76Jy6TPE2SOlK09HJK7Gc8om?=
 =?us-ascii?Q?ij9noOwNJv8K80nX9Uj3FsgFBd4ZDR5XlgJGJVesI9DPA/1JLAp+gVd7Ef4r?=
 =?us-ascii?Q?TOi1gtHr8pD6h8RqNW0IUHVoucvz2z5SxkkzalG7zFg0lPZV8qZ9Wu+ngkfW?=
 =?us-ascii?Q?Tr1KuW9wPFwssYiNTh43lBT+gdAkm5gHczhRwkYse8zKDQhyZYr6J1Py2yi2?=
 =?us-ascii?Q?7K9F2eEaB16NsXaMnaxQl0aZ/RUAUh/rcGw3x0QaT9z7HvArg19c8fRszVWg?=
 =?us-ascii?Q?ZVse4RPDM7Cs9zxVpMr9s4563WdewdmsD+XoJqtLTNsM6vgwGFxMwOQm8rcP?=
 =?us-ascii?Q?fNz3FPZ7Xq46zRHIeDecrhVMv9SmKqBSUAUzSUdEcbN34dZXTmfCSM7XfVle?=
 =?us-ascii?Q?BOph9CAIUHi0CWSaMc/FN70d/2hoZzOt6+D03QC7yd7wMISCMdtRD9gquLMc?=
 =?us-ascii?Q?38+gmkLByyVhgmGbG3jYKFwy/Hd3encSsm5GBZc9u7Mk6IDzsWN0DRZShJQb?=
 =?us-ascii?Q?/Zxg+i8YTh28J3nx4E5VYYB91dCmgKqJMltXRmp78p0faDeLJzk1XYEEeE55?=
 =?us-ascii?Q?kA95L+RSuiqhPs/W/3xJXn6O5HOuXkdK+WWj4/E3/sRdfYM3X+/ElR6yQKKj?=
 =?us-ascii?Q?CcV3QG07QRjIRhFBhTCr+e0n4HMOBA7U+xewSuIH7ZuJeq64zGOEHKbQmH4U?=
 =?us-ascii?Q?/dT5a2F3gsf/qBGiR7TZmRZBW3ABVX8tTCzetdBWtUx7aZs6EzPM86MqJvxp?=
 =?us-ascii?Q?bz16KtWAtv/eofhRKhR7X4s/+4fDrJ4HIyL9NOB7lQ0lxpR6bVE/buETby6M?=
 =?us-ascii?Q?CJO2RtUvXxpuV+8pAm7H95uTod4pwLN3YdFEuhvgaOqMMdYC2L1j/nFK8JTF?=
 =?us-ascii?Q?wbE3/R4x9u7e1pYhEMO8A8IqwNwxXHDAlhHJ0E6aBCxXDUdFWPLGnE1Ojqxm?=
 =?us-ascii?Q?uV3mDyTN0Pr6QkZD7qRtknpH8Tm4xpT2kER3OFc8QHACGg1bwj8+9ky/Ooet?=
 =?us-ascii?Q?TutadWUU+JnmlewoPXb+hOMLXQDsZ7od14snHsChCIMKNDy8yEgEzlzEkX2G?=
 =?us-ascii?Q?QnDoEvgl6oS/83MKCLEaexZxHo+Kkk04urQ4IEupjl/Vvg7GUNy1FFVZVouj?=
 =?us-ascii?Q?rjvI2CzDCCrC5nCz0uWLJX4UtWE7+eDYWnGE2PZH9W31Q8Rg7bFrRXbnIder?=
 =?us-ascii?Q?pvQQUJzCdACdJzqvlATIEMpYRRPyh9YJmUlFGCS9Q8GQQJ7alwh2a05Qch9L?=
 =?us-ascii?Q?SUQ/I2hbrqkJDS4mJJwf9P++1+ptNapaFlT3yJToZi4XntcoOp3syGE4pVfB?=
 =?us-ascii?Q?6Kg12sctvKYyHIChAl5Go0FCzPBjIfYLl9M0K9oY1uOWw4+EDbuEdVcVt2Dq?=
 =?us-ascii?Q?vpIup4vU0dd4HqRBOLy9L8vWzwOv9uSGZoC548ZnLvQbzw2KpgsT4ZokLfv1?=
 =?us-ascii?Q?JxVc27mRpiYw347SKro=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 17:44:14.0364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b76e622-7c47-4693-bb1f-08de2213185f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000145.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9792

On Wed, Nov 12, 2025 at 02:18:09PM +0800, Baolu Lu wrote:
> On 11/11/25 13:12, Nicolin Chen wrote:
> > +int iommu_dev_reset_prepare(struct device *dev)
> > +{
> > +	struct iommu_group *group = dev->iommu_group;
> > +	unsigned long pasid;
> > +	void *entry;
> > +	int ret = 0;
> > +
> > +	if (!dev_has_iommu(dev))
> > +		return 0;
> 
> Nit: This interface is only for PCI layer, so why not just
> 
> 	if (WARN_ON(!dev_is_pci(dev)))
> 		return -EINVAL;
> ?

The function naming was a bit generic, but we do have a specific
use case here. So, yea, let's add one.

> > +
> > +	guard(mutex)(&group->mutex);
> > +
> > +	/*
> > +	 * Once the resetting_domain is set, any concurrent attachment to this
> > +	 * iommu_group will be rejected, which would break the attach routines
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
> With above dev_is_pci() check, here it can simply be,
> 
> 	if (list_count_nodes(&group->devices) != 1)
> 		return 0;		

Will replace that.

Thanks!
Nicolin

