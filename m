Return-Path: <kvm+bounces-52795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0523DB095AD
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 22:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B8D6586176
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 20:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA57225402;
	Thu, 17 Jul 2025 20:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hZI8TKR3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181511E0E14;
	Thu, 17 Jul 2025 20:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752784069; cv=fail; b=diWuniOrXe7eBU5MZo8pPGi/1wwmUYIMNbJcyXpACjRmh0IWqIM6yKfuWl7kWb1HXhCL6I9PSptRu9rXCcJKrJJtj31m8VG0jA8swj88W+jiOSmAez/21HvOorg8TVV1LpCmRZ0Sd4NaMqhlIEXg1gOxV0eaUBdx4gvquzUnPPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752784069; c=relaxed/simple;
	bh=cOX8P3MvGMknP4/F2/Zwv0vp+3Y8JK4BUObzav0w4zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YSxN8dSDcBP8oYSlAPbT/arF+k3Q2Fpt3c6LqdVwWHw3zLyDBcgIDTnhnU2i9X//t4UVn8EoHXUQHNAzH9yGKwjx18q8X4BJ/LKlvcBFZs1qimXyImPOEBtBoFKeHMgH34uSFHR0RrOCJAgwHBFsdmJEzze9L/cAQmeHrx/0Gbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hZI8TKR3; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VBgiEKxquy2kyRBC2941g8MJdS2euZqYHFRcX5w5NlTSIQosUHNmdsWihTnlSHZFat6svRg6gmSTM8bRVTpatrLtf86/v1jxHb5hgwS5FJtATMkQ93dEMI9jD7WTIoIqH+psHNadNuYtSqPANGbUMJmv38BEVjw91NS0MnPnin5WQvVFjBu9K+5gg2uCNvbPQFbVhAsgk8s6XCTxU6ZSXLbkta7MtJuAnu5AYRBEIle3CHvHoSvNu1s/bSBYYTuYzuA9+ILH+wHz20rTVhhmXxw45jQhtdMpcFeZaVTaeHhbl6pbGH/vjxR6KuYQV+iiZGdRfvWHFXElvPUvCzctLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A31TViRsZTCFZ8nI8UfhfPjYp//bd2az+xPtTfydqFY=;
 b=KLEUb032gA1BMMK6eBsQEsbqayI6STYB4ohDm4LGGKpZC+6rNDC98GCCPl8ymIa1alrc/MZc00EfoEGioAfT/673dfV6+TLxUrk9nDRVgoLDMvkUJ3zCrZBqCL99xEWtU9kRH9+RGvSlhc5ffIye0wuIxGGQ2KUQy+MvqluRgdQFaXzMEAmkQGOBSf1tSpJw+B0F0ecNBfoiEulO9XrsZ1a15WspykNs6vDAB7tyY1UhDCIHVH8nUZOHAtwsAnzYccfEqrO3pLHnJmYV1qZD3KfKUZvJ9cRgYDZOxqiwpg4lHLqCzMfzW33d50S/M1vPSa88Hxup/6PS4Qo/MFZCrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A31TViRsZTCFZ8nI8UfhfPjYp//bd2az+xPtTfydqFY=;
 b=hZI8TKR3QjtgsKogRHzO4mH5phuMVE06p8UTM26OxoHwhs2oNByDpMyh1DY653Nd1PMSH4/2gEUBOh7fXEMpfexgJ5daXh3iK9R0vQpSyjVxD5+iD1HwW4964S1Aa5knhbBj3IVy4nJJlbJbXnC5+onzB2WvwsRxJn0kd+IiHf3IGj4s0L8I9sJ+w2ySjgRbbM8nlUw/xj28bb/4vNbR5qQj3IGvvXirAjfZYYrBr3LKarfu3DzKC8oCZ5XTvVbLfhzjviQLUMOxvSBLlQypKdxDnpY9zOP4HwY08VOt80bd95BbE0Lc92eda349iNf3H0E+wAifHhNQ4QntHBRsUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS5PPF6BCF148B6.namprd12.prod.outlook.com (2603:10b6:f:fc00::652) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Thu, 17 Jul
 2025 20:27:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Thu, 17 Jul 2025
 20:27:45 +0000
Date: Thu, 17 Jul 2025 17:27:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250717202744.GA2250220@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
X-ClientProxiedBy: MN2PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:208:d4::36) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS5PPF6BCF148B6:EE_
X-MS-Office365-Filtering-Correlation-Id: cb96606b-538a-4673-3ba8-08ddc57063a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G7ZJG87rVECLFh3OHZckECYcuMQ/R5qiQaETJijyIbwTpDhRAZBTdXX14WpH?=
 =?us-ascii?Q?82WeaSJZlzwnpNcNdltOWJUqr2yoes9ABm5tTTv1FP9jmWDbwKyPHcNQd27b?=
 =?us-ascii?Q?wU/sZyBYoKpgkAVpRuHcUOv2IG/OZM6ge4wq3Jnf4wo+XJb49MaHGd+w3nkS?=
 =?us-ascii?Q?Q1vnh2zVHsUF+fpWJ3WlcHvkIXVXVUtwVKwS2HyDazx0TOo1kYegANMpMzb5?=
 =?us-ascii?Q?m3zdY3OVsiJutxVFCm7aeue5rzZzuW/yn1tv2E97MYpS/C1J7PI4A8Vs6LE0?=
 =?us-ascii?Q?x1bEmkrYFIv8IPXvDFf6SEW3g+PTExjqTxZSEDcvbKQLAh+j65SjPOUuoAWm?=
 =?us-ascii?Q?5MtO78oX/47Y8Qy0CdjDwqhYI9wApgupSE7KE/x8l+NH7bVmnvl6wvoKe8e3?=
 =?us-ascii?Q?a8OfyUJxproxnKKE0lbR3BfL92VmWKYvugV/iMUudl6dvgYmrwnWPwk+TqWt?=
 =?us-ascii?Q?ruELwwYn/CIEbN3bziD9EVYktZvn9fRc0wt5QpfQwr8VJ6Kz2uojyU02X3pr?=
 =?us-ascii?Q?YVfbS24NJkFUhWwk4OUIzaYAwNUk0TjIuiU/v8Of66YlvJm39DkmUUnMxz1b?=
 =?us-ascii?Q?4o1xTX+d1GMpP88jCaVcVdGT3wzruUXyyirILj0KIou8pzZr/SsDIeLHXo2k?=
 =?us-ascii?Q?ywPwQpypXyy4XYvfGcqlTB+LLoHm/slcJ5Aqz8KzjY3sENzgEj9+z3vYIhiI?=
 =?us-ascii?Q?1zYkj+DFuo9DVT+C6jMF/cqGd1pG/xmC0oDQVJMtob/dALaWcOvq0sgXy3Xd?=
 =?us-ascii?Q?L1pXpqHOJvCSBgXkwU5etRL9U7xW65G3hBfFlbPp0W2EP+etdUL9qSt6BQjx?=
 =?us-ascii?Q?gu7TnuuYt1rapiNmXQognMFBKBIbPRPWwdDiMkg7mMm63FzG5mclTTOhbN9S?=
 =?us-ascii?Q?OrT5k6wxAQWXkGe+og1K0QQBQRANZkBmX65exOuyFw4rEsV9aTgLgLMzeglr?=
 =?us-ascii?Q?8rZ1k4DRztwYygsUAq3ecAyLvBH9hOZv149KMtqMzgvXL9xhJKWbMNBoukt4?=
 =?us-ascii?Q?avBJobkKbs3G4iZ43SnSkhX/KchseR9ccaUa7Zu9ieEJm8e3K8xMLQ/u+lSj?=
 =?us-ascii?Q?wctcadGdKp2Hkwc0pMH8ADZfgfWXfJUFAiOa1i/KkaaA7wIYEmYd4uoQf7eb?=
 =?us-ascii?Q?OOmo3oyxyi3TSj2v8SY0SCpz2Fj2rwFZ3cRtaHpOdoBmdSpdRjplkLaznISa?=
 =?us-ascii?Q?8Y1smOGUcj8gJweyAsNrQUbmu+ZJALKzzU1g2z3D6Cz/L0sFg/TexfkCFE/R?=
 =?us-ascii?Q?mi9AXVI20yEE7pVqHSD9lQ0KqFRt6KhXqT8xBXmK7Js1vXaUVrE4uxU3f+lH?=
 =?us-ascii?Q?e7/NfMX9C884JI4jJ4o9wiWW/2JhCiS97K3OFq59iiFgaDJo8Oi2sTxhVu54?=
 =?us-ascii?Q?0plLYEQTEGuKOxy8tUxSkjME70V4oBrn7K/FIVZPHhNDzQ9o3dOy5unvfg2S?=
 =?us-ascii?Q?OO7R5N/CrUk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8C98Kf2KKUmFYfCyg9HT8zm7QviP+WnSa9bIlJAi3CR7ZrkeE+lM4WvY56u1?=
 =?us-ascii?Q?eGZDbPQeMHGopWYlx+y5vuyVES9umLr9SvwOPlgN7f8jgRIYDXrlapjCG0yw?=
 =?us-ascii?Q?8f/6gR2CGr0L10KHMQeqPOxhfyxQe9/xrVH6pKstg+wBk2FyMU1GwMX8QIjB?=
 =?us-ascii?Q?QnWyz/JL2BCSHck6O4/EIsSHU03TFC4lCplr1zU5/8pP95A+F49n6jAkT7zj?=
 =?us-ascii?Q?F69S6ALBwy6huy7Wn2tBlokm6QxBUJLmdc1LiaSAe/7MCB2bI4g6R/NVc/Qu?=
 =?us-ascii?Q?bvWHN204iNbQaaIYtYFfTP3mZgx/YCFBTQR533m4juofyKszgURc5N02ymHW?=
 =?us-ascii?Q?1ZdEU1iggrLjtB0vCsxf0zFq7IWg/wCIfMTw8idUjVP8Hj2EQjK58iBUjoBo?=
 =?us-ascii?Q?T2O7pl+GLUubbfeuxZPsW58aTVpk21gpaM1EeRV7A0/SChs4eBcQZLGpKM9c?=
 =?us-ascii?Q?IRb/3vXPl4CFg8OrshES9spHhLrOGZbESp+qZSIphcQfWS2yJGTgfoK8s8zx?=
 =?us-ascii?Q?MkCtyFwdK8Y8QMLPjeCYIgSnBU3M0a9ABwI2F/d+vOiKZK4s/oLIDpJ5cEiI?=
 =?us-ascii?Q?o8DuiRW6Rflhz+4FwJM8CDFh3bnSGV0I2P/plWTrp2groboHF/U5OVwCBmxG?=
 =?us-ascii?Q?kHE6jb6Y6ReIDt4QY6/EYsDTsR+CXIqYW9LJpXcxyOJqHDB5p6iXthKJzfpb?=
 =?us-ascii?Q?c+qEyhi7tL0EcJivpt4YwrZSXPNzJdshZnf+hbYcueOHx2lEcHZaJey9h6Q8?=
 =?us-ascii?Q?LPrP4P2vSBdxkpFEtvRMFpRd9HqR/aBl4LrTv/nRVBTR417Fjeth0YnlTxfT?=
 =?us-ascii?Q?hM1J4gCeW+rr+Dh6yPoLtN/zOQUI7qoicc6b1c2aJt5zdjBLf9aFCIpkBNsM?=
 =?us-ascii?Q?Cn6DFF8/houqRo+wfYESsxSTrphSm/3tN8CEP82CNmG91dbt8SDR6hmscE4W?=
 =?us-ascii?Q?B2Cxy7YYr+MGuqpbRiwuuu7pLvq36fHuProm8C+0kT7nIlDAklHfwAX/9nZY?=
 =?us-ascii?Q?YlWNMzZM05+U6gbk/eItLLgy899juQ7hmVp66tGY+dxRyGl2MQXPve/oUAiz?=
 =?us-ascii?Q?KnRWjw3+UlaQHxsd/9AGGDETZArJvDD/d0WvIvfv6ViTyVqZ5Xa2Cnc4m9QV?=
 =?us-ascii?Q?oKLwQ2PEWOIk2g0JuLb+9FOgwDXab+dz3C2UCcSjI7zGCqklznw2/tl6JmFV?=
 =?us-ascii?Q?0/J3R5PzIPKZYjpgkSHHA8cspC9+4ZHS00S37bZpzMmyP5N/GkE3Mo0E1SB3?=
 =?us-ascii?Q?yrl7AR0yRNRt6R5dwaAuqk/L1cPIOF9DJg/XGi+HPWSVxM2AdYDeykUOlLBG?=
 =?us-ascii?Q?mnX4m3lU4C58di1/YQa+peTicrqQS79v8INsJoxDia7xF71UHVVRGOOWr5mD?=
 =?us-ascii?Q?SYycdmyKSzj7mOwO0c6ihLfe6ZN5B7BnBnQvY8TRBK1Vr4fpOMn1PCdDo96t?=
 =?us-ascii?Q?o7bWvOfHFNl+n2YKabLm51g2AMy1tJLeWx/1X/J45ysRd9h7nAZ+MOcuH0cG?=
 =?us-ascii?Q?9zTZ3KU5bp8LBMhKbUTZyNylOk0KqN1jOlrESvvCzj7iJ3p7jRMYVrxC6Vqw?=
 =?us-ascii?Q?tTPJhOb/bwZ4W4CZANVCph/eCfXpHRZ/iIDYdvto?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb96606b-538a-4673-3ba8-08ddc57063a2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 20:27:45.7858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jlHjdw7BEkDERhKvXuBkjODr93XPWKk8lSwAkLhDARNbPO1AMN+rc1d5Qj4bT5Jc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF6BCF148B6

On Thu, Jul 17, 2025 at 03:25:35PM -0400, Donald Dutile wrote:
> > What does a multi-function root port with different ACS flags even
> > mean and how should we treat it? I had in mind that the first root
> > port is the TA and immediately goes the IOMMU.
> > 
> I'm looking for clarification what you are asking...
> 
> when you say 'multi-function root port', do you mean an RP that is a function
> in a MFD in an RC ?  other?  A more explicit (complex?) example be given to
> clarify?

A PCIE Root port with a downstream bus that is part of a MFD.

Maybe like this imaginary thing:

00:1f.0 ISA bridge: Intel Corporation C236 Chipset LPC/eSPI Controller (rev 31)
00:1f.2 Memory controller: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller (rev 31)
00:1f.3 Audio device: Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller (rev 31)
00:1f.4 SMBus: Intel Corporation 100 Series/C230 Series Chipset Family SMBus (rev 31)
00:1f.5 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #17 (rev f1)

> IMO, the rule of MFD in an RC applies here, and that means the per-function ACS rules
> for an MFD apply -- well, that's how I read section 6.12 (PCIe 7.0.-1.0-PUB).
> This may mean checking ACS P2P Egress Control.  Table 6-11 may help wrt Egress control bits & RPs & Fcns.

The spec says "I donno"

 Implementation of ACS in RCiEPs is permitted but not required. It is
 explicitly permitted that, within a single Root Complex, some RCiEPs
 implement ACS and some do not. It is strongly recommended that Root
 Complex implementations ensure that all accesses originating from
 RCiEPs (PFs, VFs, and SDIs) without ACS support are first subjected to
 processing by the Translation Agent (TA) in the Root Complex before

"strongly recommended" is not "required".

> If no (optional) ACS P2P Egress control, and no other ACS control, then I read/decode
> the spec to mean no p2p btwn functions is possible, b/c if it is possible, by spec,
> it must have an ACS cap to control it; ergo, no ACS cap, no p2p capability/routing.

Where did you see this? Linux has never worked this way, we have
extensive ACS quirks specifically because we've assumed no ACS cap
means P2P is possible and not controllable.

Jason

