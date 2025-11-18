Return-Path: <kvm+bounces-63444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E789C66E02
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C8BF9356D5B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86922FD7A4;
	Tue, 18 Nov 2025 01:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FAqaaPI6"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011010.outbound.protection.outlook.com [52.101.52.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9F52D3A6A;
	Tue, 18 Nov 2025 01:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763430159; cv=fail; b=OB0jdaMqakv2XdcRb6C6JLaQGFRWpVWK1mZOXDe3uQQvOhCCN+jkwjsb1Mm24vbYeA3ItLqbeWzcSdQFQcqFau36D99EVoh6E+8XR5HT8z0hKLehVx22iHE12wRXFVXSDCKCh06p8Di9gzcXrF/Zdc963It3EHGuGFq4k2FBp/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763430159; c=relaxed/simple;
	bh=4Rk8kNbU8XpFKV/vP/ZSb9cYhmN7SjEZW1S9nBDZsqY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkE1zm/tBep4n7a/4P1rNKZxBNoYiWku+8091tOCyAhTwILE3k4N7849uCqFOPWC7e8m9qQsz03hULA/kZYiIyw6b6ao+et2LOxV9sYs+GRmGBOhJjZ3HBdWGt36/pcd3z2Q1LI6fkjiy9uSgzqqHez6JpxUxDutWl4CjrnZ/ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FAqaaPI6; arc=fail smtp.client-ip=52.101.52.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hL+k7joOx9Yks6EJ/+95t36xQb/RNZ3IIgbw9Nibz4h2egLtAjpHeFA9a10XXuRqlxlAhmxbuX93mtCdgsgUwCZGnR+YwwvJfeiLRBx8sHSsN12Dhb3DhF4zfJ6wZFK4L3RW5pHCXDS9JEUkAL9LgvhELuYZ25w8FwwUS0TD/mc16qsi4w1J+wFDLo9ilXW6JQyX2xNHgjUqrx+AMjDzQhsW49IqDkQl/1kVtyXKnVZXxdQnWiquSG/BT3UvzrK5e6morBFAcgG7hXOpnq3WuA4slI53dgzGlPccaK9DtZibbObpLczq80GwAUQ4C5ys9j1BRBT/4fCgr9PKOXmyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JB8mAPyqV3cTWmWabAAn2V/tzOhGv+2AqWKcJ1GVgD0=;
 b=K2UZxCj8yQSKARKc2tk3xZAqUPMMjLKPK8nfYjDSnvKU5zfnaQeTmzBW6Pris0DM8v1Mr6cEB8H6cQm1oUBDHE4tpmAIO4IM97nkwKMFh1z2/5Al/YRzVUzM+RVwMFY7feHxYU6iyutBobkD+JbftF3m0XLNzUawnsX4szyixWPAsXfy/6gLDw7+QbfBu/eab83HL0K1QA5Z+xbG1BzZCVqGs/fMiJduZy4m8DzmV825Y6Of2+zCJ5rbZEJUWXTW7rM/t6j8tCkjhPxbD3nxzW0k3hWVwZlD6kGvaLXKMi5GST9OWz81MDhr10a/rQi3qMZv4I+c2klT3alpk4oX+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JB8mAPyqV3cTWmWabAAn2V/tzOhGv+2AqWKcJ1GVgD0=;
 b=FAqaaPI6ZM9EGgn65CQhKBe4wI6k/i6AGcTlqWE4vyoXlePskibVZMlFz5Q4TpbzAfidlvicJYcDI6W7wZz1ab2MIQxx75I2uySrruODL6eWMSu/xz+u57HfCw8X2KhDrhc1fcx5DN4vtsHCxdpCDxDlgLJXm/hAMzvvt3pItHWB/yxxlp6QWzqfc3R3MmpUbkkvnNzl02sK2MSA9FnZt7Nta4ZajBC2kO1N4LKaVk2bdTruYH+NbP21+SVW4vPjX8GX14dhLmtmPteZEQvcABNvyqkaDQARu7KRYnm218vWhH8QuwO6NAPhslyg/goii0ToBGlHCd5V/Op41ZOboQ==
Received: from BLAPR03CA0112.namprd03.prod.outlook.com (2603:10b6:208:32a::27)
 by DM6PR12MB4139.namprd12.prod.outlook.com (2603:10b6:5:214::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 01:42:31 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:208:32a:cafe::9e) by BLAPR03CA0112.outlook.office365.com
 (2603:10b6:208:32a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.22 via Frontend Transport; Tue,
 18 Nov 2025 01:42:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 01:42:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 17:42:15 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 17:42:14 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 17 Nov 2025 17:42:13 -0800
Date: Mon, 17 Nov 2025 17:42:12 -0800
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
Subject: Re: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Message-ID: <aRvO9KWjWC5rk/Vx@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRduRi8zBHdUe4KO@Asurada-Nvidia>
 <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRt2/0rcdjcGk1Z1@Asurada-Nvidia>
 <BN9PR11MB527649AD7D251EAAFDFB753A8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527649AD7D251EAAFDFB753A8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|DM6PR12MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a778ae-a752-434a-8c63-08de2643bd50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cAPNijP1XFqcrhTWtR3zZm0RMIlzLw3UdS6j0X+VNll8NjyfNbnWif6pAb8w?=
 =?us-ascii?Q?B790CmU2I4ZrkZ/YW7grxM34d9DeFIyvKdCPZ+vvZDuVS2MMOurWOrXIFOQ0?=
 =?us-ascii?Q?zqHlLX4Q9BzdZbFSoEneFkA4CtGHfOX6QbdmsMkKj0Azag3sNURNSzNl+MBD?=
 =?us-ascii?Q?4FO36hfIL/dNTC1RflFaBHgltTrePWRmxlF40Na3hhaRW/sVf7dNcOWtMqBs?=
 =?us-ascii?Q?9+Lq8bJXx0cZK2SMn0boHpZyf8yOb9Uq/QEKfZhCE0aGWblZUJzaPgBOxOuG?=
 =?us-ascii?Q?yQMElhlNOHuicVBnkqeXL3X73bgdjaHSwdwGOCvCrlonxS8Wy4WlKxITqWMT?=
 =?us-ascii?Q?UznKg8gbg25PWGzEUSDXndcno7spQuLnK82ARMOvp65b86m54qsE+BqyvCvW?=
 =?us-ascii?Q?gzyMwIy2ovXJSwuWAAqLFPyHbH5zkkadQ2FHluTPqBs2IBiiV0uxJal7DNhm?=
 =?us-ascii?Q?hgemPkr0jxYNoinYE9CsGDvGz7urTO4M0y30WLL4/gvwS+P81AwQm6BQwICO?=
 =?us-ascii?Q?JUkJ8j84P+V7euDFdpSiOJPnPYW0JlAxLW6c5fFvavoqpe0cEbPn+xC9q5Vd?=
 =?us-ascii?Q?Xk7aVpYogEgHfaHxP+7pjf9MtoA3uYfy5gcNtIaSOouf8O0/f3Lm2XnCh1ZI?=
 =?us-ascii?Q?n8bcfvzcl9xrbKVNY627xrKMx/rtymvKx3j4B4inYGY95az37UuLdKtWdS18?=
 =?us-ascii?Q?tllvVQMvpYhP/PXuNwUft8+ZpKOCaPfhmM7bL6xxPjFMuKwX+yeGb4bM+mnq?=
 =?us-ascii?Q?36jXRyOzyfDIIWIrer0KqU6dXXA1x0iKNgTNYP/P4TBZRQf3DwbpJk6KW/7Z?=
 =?us-ascii?Q?yw/7ctI+nhEAO2JgxGMzhsSmVifURNg2A82I9Hj5XKmRoJl0yUItjsW6M9De?=
 =?us-ascii?Q?5wACayt9uVi7rLXa3AdgfIgtb6IJkIkzQbxMSxXJbPZTXWgh2I5Nhn9xoOOC?=
 =?us-ascii?Q?TMg81qz6EECVg4siq+jrVARdby7ERkalgE1YVz4UVXQGH/JArICfnlajAY2/?=
 =?us-ascii?Q?XXzL/Ybj9gvhJmCw7nt/IdszfoR/8v56yGfw4OCsriaNcs1SJIT5qhtK/Zym?=
 =?us-ascii?Q?gtZBn0Yrv5GTFG8BSX45rqaRZOKPUZ15vbeaPS5ZfuEaiHwGa1GujLn/aM3p?=
 =?us-ascii?Q?Wz6OgA32OI4OhxZjjRnt+zZWvFbJVx5t/VO8Sxct0xYnXEVENRWZnxdhNuE5?=
 =?us-ascii?Q?C/WqT7X2h+kjlVWiCfRkud09NdCc7FV4JaHDSsmvXdyjSzg5YTN8Cx0p7Zcq?=
 =?us-ascii?Q?0qBh9rKAX2ptY5ar0OZKgIjS8Q62m/M4qpXN2Z5K4Ldeoq47isTC6oVUUve/?=
 =?us-ascii?Q?lulAoCkDqbXw4KAXmLv69qNy9BI4KL+Wv6h9do8JqhPH/UHbdCRC24Z1MH54?=
 =?us-ascii?Q?7WNbnlFtxJij4YVOzU1EPbA9oko09kmT8nW9rmQbWofmenXJ8JjlMjceDd2d?=
 =?us-ascii?Q?NpGIFAmTfz4ATbqHSQdsligQDkHnVgXjGdKN6aSXfauUT8UsD25Qluck0y6X?=
 =?us-ascii?Q?eEeksS9GSuuHlVx2yTToHzthA4IRo2T+R3UX/KCxi4dEEzPiyNeNkyHmVMdT?=
 =?us-ascii?Q?ENq39wq4QJkmNmS+mMM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 01:42:31.2162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a778ae-a752-434a-8c63-08de2643bd50
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4139

On Tue, Nov 18, 2025 at 12:29:43AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Tuesday, November 18, 2025 3:27 AM
> > 
> > On Mon, Nov 17, 2025 at 04:52:05AM +0000, Tian, Kevin wrote:
> > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > > Sent: Saturday, November 15, 2025 2:01 AM
> > > >
> > > > On Fri, Nov 14, 2025 at 09:45:31AM +0000, Tian, Kevin wrote:
> > > > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > > > > Sent: Tuesday, November 11, 2025 1:13 PM
> > > > > >
> > > > > > +/*
> > > > > > + * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software
> > disables
> > > > ATS
> > > > > > before
> > > > > > + * initiating a reset. Notify the iommu driver that enabled ATS.
> > > > > > + */
> > > > > > +int pci_reset_iommu_prepare(struct pci_dev *dev)
> > > > > > +{
> > > > > > +	if (pci_ats_supported(dev))
> > > > > > +		return iommu_dev_reset_prepare(&dev->dev);
> > > > > > +	return 0;
> > > > > > +}
> > > > >
> > > > > the comment says "driver that enabled ATS", but the code checks
> > > > > whether ATS is supported.
> > > > >
> > > > > which one is desired?
> > > >
> > > > The comments says "the iommu driver that enabled ATS". It doesn't
> > > > conflict with what the PCI core checks here?
> > >
> > > actually this is sent to all IOMMU drivers. there is no check on whether
> > > a specific driver has enabled ATS in this path.
> > 
> > But the comment doesn't say "check"..
> > 
> > How about "Notify the iommu driver that enables/disables ATS"?
> > 
> > The point is that pci_enable_ats() is called in iommu drivers.
> > 
> 
> but in current way even an iommu driver which doesn't call
> pci_enable_ats() will also be notified then I didn't see the
> point of adding an attribute to "the iommu driver".

Hmm, that's a fair point.

Having looked closely, I see only AMD and ARM call that to enable
ATs. How others (e.g. Intel) enable it?

And how do you think of the followings?

/*
 * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables ATS before
 * initiating a reset. Though not all IOMMU drivers calls pci_enable_ats(), it
 * only gets invoked in IOMMU driver. And it is racy to check dev->ats_enabled
 * here, as a concurrent IOMMU attachment can enable ATS right after this line.
 *
 * Notify the IOMMU driver to stop IOMMU translations until the reset is done,
 * to ensure that the ATS function and its related invalidations are disabled.
 */

Thanks
Nicolin

