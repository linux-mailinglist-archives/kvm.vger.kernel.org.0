Return-Path: <kvm+bounces-23989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9DD9504F0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29EBE1C24018
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223E219A280;
	Tue, 13 Aug 2024 12:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f5Va38Oc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ECF1607B9;
	Tue, 13 Aug 2024 12:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723552249; cv=fail; b=mXB26zmln1Rv/LTIVAMlyGLs2QZhZgak+Gvs0x/J3uJYo9IwIFMGsBDvsk040sXRSNUgJH8raxzzewB+/62z6IYeDQWj7MuRT5n2tmth3ADx5+zCNg7yOcLc/GFTA2SGUx/cpEOBUO0t06e4sIN3pfjS5DZjEUUyopwB0kE/p7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723552249; c=relaxed/simple;
	bh=gdIF7HckhPgMq+ejh/uUF0APxzcc0PGSwCzDUPV3c3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QawRHBpxBrzOSbUQn4GZZO1PRRpJdUyCfcDPllH+sOAP+PE6PpfO1I76mP56TW4f2l9F6rx7nsusnEi17NsuExkOeOIQs0TTk4NX5n9WUwxMJYITJAo8dVx7xtpZmV59cdS805xiNxkPFNNRvjUtPPVb8DMwLOT7azyRvu1XAuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f5Va38Oc; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xFI3T/NCgerOZEktIXGeMtJQhf4HTra1GjKwfYtKADZ/DVtghuK/3KBLSs1e9UEmasyZI5eePKnWiBv6M9IbsNmniMJxAZNQ9e/6VwXNA94U9d16LypgdGHzZIE3Hx1PRnLl3B6MkDUH7WhE1Yhcek0gaDmcox4xHmo4bqPWO/Q4fVcJlBIS7W08AuomgHapC2+MqKRErIhvGfP89cVDgfj59goZCKUu4ncoBQQEaxpgYW9vC/6Nmmh2PswXm4F9fyg65T4gDk5NEguy8AYxq0A/lW049nRKSWhiuiMhhcRuGls3R1+2wM7NxZ/Y3p5eIJB7s3FtHHW+SYOMFUYSIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8MOS+Kh0ErXWnltPUv/43RNTLd6tQVmkgVqvDtVjEE=;
 b=WasuWwlkWvEOP8yiXctcwrB9p9mZRZcXX0kn7Jo6Rt3+X6lrSi73cVFl6yc6QLADviQXMCGi/6S1CN1W/bVjmcCYQwArq00IOnniga17d3VHwQG2a5wBv+AtGa0J+0pJIg3No3vqX//32jOuJKhwR0M6EZX+ARc3jw/1PcjVEq+cbFjFVz52p4Gf8a+twykcZd7VJCrK/Pt1JP2KotrP+yFVt2uEi88u4YTLOwTGdJKcJVheb65hLwOt6FY0bV9Tay51PCznEbGqrK/N00QC8Lje+TxJc29aBmK6xyjN8PTyvXg4ZqYyXqlr4FZ0RvkkumY1oYiDoisgTS/pUEUgJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8MOS+Kh0ErXWnltPUv/43RNTLd6tQVmkgVqvDtVjEE=;
 b=f5Va38OcMjIErU26jXCx/lRIvSg9TPsfUZiFN/pc+d1tfsvjA+jgyjFh4hugbWUhnMUY44eSzQKKxXF8IdJ/0jAxhC9Pxe3pHGO/mdOTeBzT7zQZLlNQQ12mwkzab4kP8EZYu5RWCqfBsnrtQueNQkrvqO+OFJDFLHAVgc+4ZkIc+5ZYZluvlyPfrcr54c7iYRpZuUSW9GElfX782wPQLyV8zXHxy0zixCDf2JMvrwVmfinibfF2Xuwt2yiyhCtHabFZh9pUV8u9zhtrsuDV4f5xPX6TO6UQhJtZeFSyaDiZs3vRgKw+0/gFes2zUi3H+2ZrxW+gN9iI2cTHGvQzBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB6560.namprd12.prod.outlook.com (2603:10b6:8:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 12:30:43 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.021; Tue, 13 Aug 2024
 12:30:43 +0000
Date: Tue, 13 Aug 2024 09:30:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
Message-ID: <20240813123041.GU8378@nvidia.com>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
 <a4760303-02cd-4c4b-bd23-eba4379b2947@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4760303-02cd-4c4b-bd23-eba4379b2947@intel.com>
X-ClientProxiedBy: MN2PR22CA0012.namprd22.prod.outlook.com
 (2603:10b6:208:238::17) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB6560:EE_
X-MS-Office365-Filtering-Correlation-Id: ec327358-bfb7-42c5-e17f-08dcbb93bfcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TtWpZiTc6tVWOLOp+KQr1Y6mV2N+Mk1GKn0L95LRz+XJ4b36Zr9crHUTeYke?=
 =?us-ascii?Q?iISxcK4zRo00g8jT3x+ZLh3VEEQWXRabi+CAIDfto8aarfCEhQB4OLltM8St?=
 =?us-ascii?Q?XjN2f2IN1b4f/beqeDfSxVbedU9t6TiBpU/2yqlWrmoq5QmjUsG2/nPQqHLR?=
 =?us-ascii?Q?2F+OblEdg+QQN/QzDRRkDedptrDlMdn9JPCkasI9O8Ria1w0KMmuqwRw2eBm?=
 =?us-ascii?Q?kshhxgrtchbG4/mW6GTk+hoFilL4zX/Csz7vgEdPN9mtoQiEI2OKMsTOPALa?=
 =?us-ascii?Q?zKcja+KVYvdaW6xD+4j6tzuy8qAgmE6SQ5VTKWQsUqFBLAX7Tt+TW1xuKqMv?=
 =?us-ascii?Q?jb9wH+9sJ38715S8wqinbG9rPdhPqmJmn//F+GrevIj7Z0F3rcqtbcWBPTEv?=
 =?us-ascii?Q?gYG/aaQ97Ebu7GWPYBVMdfjO5kD4n/2a8lzhpPnGdNYNliVjCOgs4qHUggTV?=
 =?us-ascii?Q?+0PX4UOqW98YwVBM8/VjqxnrumRJagANTMpM3h7IfvI5g79iK3fJSsmebpKW?=
 =?us-ascii?Q?49mRxLhF+YAJVGRVJalIOgawzVZpQRrj0ktkAb865I5JMBf1pqaY9sb6rrdm?=
 =?us-ascii?Q?9lT8rCwQTVHYO8PsyXCQIA98e0eY0tauIbX3fnbxnmSBNiDmirBjDFEpMgfI?=
 =?us-ascii?Q?7PSn/ycBa9IS8sNTEhD3RKxsuHU04d8d4dU9XeNbu0bDg8nLY+BJPsgYJmsb?=
 =?us-ascii?Q?FYqk3Tz24zmW3Ee1BT9BPxEbkvz5+gC9pLJ1bCkdqeJJLTd3OoYU67e3nyFs?=
 =?us-ascii?Q?WKjKdtks4vfxUtt11E9BjP2OEJDJPuQg8Z0+UUk8Wkb4TQ3OWn4z9/vtGE9g?=
 =?us-ascii?Q?mRP1l7d3uqRnG3JBWuo8V3M90m6YmreCXhy9apOqZ5YqYolgoQYr2nJG9MFq?=
 =?us-ascii?Q?+DVOauPffs0bPJGVkGrZebk6fI2lWAnzDfixzqrmhkO/JKnXj3t7QtQ/iy1v?=
 =?us-ascii?Q?+VBHmPnOxGUx4uIhQIm/z4ukLEsGDHCq7Ymbh2YJldnzWekK7lNNawabNzsD?=
 =?us-ascii?Q?cy0FOwrqLa36X1gZApYCoZO+2nWzOEsivMnYXHDXaLvis0+AbQh1kLB33Q9L?=
 =?us-ascii?Q?fy4KfIl4RyfNg8vGQsExJxupZvBxN2zkErtc2MweQ5VpgJ2dQPyjAPciOgA0?=
 =?us-ascii?Q?tkz2n44hoLa1vNegpkhbdMUKsK//qxPy5G6MCPmRHSRoz8wFQig+493TVQJZ?=
 =?us-ascii?Q?RJzFPqRia3zE9b39SWbNDC19oYMZexDgvicTsmO8w0negKH5twnjmrL5YNuG?=
 =?us-ascii?Q?XNx+EH1Lykw/GYlNpsy131w+jBNZ7bOAclQqPUWjeMyDdE24toWrMqJysbDE?=
 =?us-ascii?Q?T9mCkXCNNFni+k8Gme+lga6SucODM3X9JjiT4QMf2+TUpA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MIBHHW99mlYMEdLThTMkIz2wQyYtVVGivm7txChkPAL/QlFotJ/W6OWb6/y5?=
 =?us-ascii?Q?v77+/k9zlgilbZyhSOU3xgGDtBocdkeP548Ebz1WZgiuCCnWIz7mDb54ZDq4?=
 =?us-ascii?Q?MT/7zZwb4w4G3wOqwjA60gJywtk5bSyPB2fwvc4kKJmQ3VNvNwE4qqCWWPG5?=
 =?us-ascii?Q?FL4u5YgXjcAgRKx4yZfiiCOlqKH6dhqxPXdFqhnDpSox4Y69gtoyBJ9kL3tB?=
 =?us-ascii?Q?xHAYSztq2JHJHv//9r5awOw6rwTQO0fl+J2YUmNa+FG4V0d2+ZXsbAjC4Eri?=
 =?us-ascii?Q?+iskC9oVkXFHVyfSwLB6bmS5Rf/t1n77cN/eq4YmpvDhuqxIQ5ecPtVphv9l?=
 =?us-ascii?Q?zZ3+ZrNAQWHLgYezN/5zWdjaadv0bxsUp8ttIHWcseVDsKkRMB7OnGvlF+G7?=
 =?us-ascii?Q?t5B2PUIVMI+nfv1VGisgkkNo4OMs204Nn658hPTb9yWJLwyPv6VRb++lTg5S?=
 =?us-ascii?Q?i6WcgWpe5XMIxbQJRk7PhpyzfhPS1z+iyMkln1ebc4iAIg3nrz1ubitriux6?=
 =?us-ascii?Q?VHJfC1X0/Xnib/K6o3vsf237r8OA2UKHr6zoHMd2oEpocPp7ee6lo0NuxWgJ?=
 =?us-ascii?Q?UsUg8Ka2GcsuIkQB+90oG/aErEHZ8nhrQ9Y+B3HDNmOLF21AgOm74yuzBY0/?=
 =?us-ascii?Q?4cmmJE4HQfZEiqIWAF+aYVbTm5soESpbZP6nrqWnaBW05ppIaM31q7buIlqM?=
 =?us-ascii?Q?iPRIvjdkyxE+u1Lqj77t6YdzaB9FH5+hysXe5vhKhOrC43QMI6jqpwZsb+i2?=
 =?us-ascii?Q?yeJoOQOTZoKYzKkksfmBlnR6qUDP1F9xHVFIx7KenXm+4fnPbc8nhYFIcFDJ?=
 =?us-ascii?Q?BpT/OFFEGKJLnep6NucQ9OJ6FOmjiqtW+zn16MT7vGJAE1cJssRjze/KGV7I?=
 =?us-ascii?Q?iqvF0TRQoG4uQNjAB+W2mXaxdgEgZenXF/TFZJHRkW1nIS//nJWtgMzpCAsJ?=
 =?us-ascii?Q?ZTaat4aUt+kgH7mxOg+cB9/BurxygGA9QEFSCiZ7/SFQJYG42cvH/wKvnZe2?=
 =?us-ascii?Q?1ln8fpbcE5I1NdYYImNmnCAilPwHMGvcbV3toUPED/IniHmfM1vMWtby4rtN?=
 =?us-ascii?Q?hDiPOkuO/Qw+wFly7COodkwJiyj9Zk1+aOr6QZgRyKF/rJ0jLmsm9d0wOLs0?=
 =?us-ascii?Q?CPnm7xrN0tkVIRDJvkQxnAsAISxzoBLeIMxHWuHWspE9DhQ7+FoehjcTsL41?=
 =?us-ascii?Q?8WIsLIziqZC7NvbuhqZ7Nm0YlF5xsXaJZtnb35Q0IhKm69i+dorUU3650tbZ?=
 =?us-ascii?Q?Wrdg6AoTX7pkH0G5sFqMYnp+Cu+QBgsikoiqjIOji5WSqJFFCL9Znv4MI51S?=
 =?us-ascii?Q?vhgdYr/mEusQxpXqEXT8Fh5/8Ytb5nbAnyuqrimwzjIBrA1yYKLBW6G8yRR+?=
 =?us-ascii?Q?l0J7AsPB2YELGlhGSLR+8h9cB0x5V+VlJxFfWuILcBMHUdG59Df7UorrSJ26?=
 =?us-ascii?Q?mGws538VA0VMv25NdvO2JlAaYwqlpSEv/e1U1Nt1Nfqp1mWQnhHfbUGQGuNZ?=
 =?us-ascii?Q?gjaXL23nuB33SFFindcXAF6dMiXoaFYoDzGeJSRA+TIEMCuGpHZ9mlaSUiqJ?=
 =?us-ascii?Q?bEqjVs6fWPB9Idhui30=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec327358-bfb7-42c5-e17f-08dcbb93bfcf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 12:30:43.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQugSpiYH6XPEQy3w9w7Xvv4m67A2wcbzeMsZNn0+1UERPjxqajYjDhV64L/jqqv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6560

On Tue, Aug 13, 2024 at 11:11:01AM +0800, Yi Liu wrote:

> > The simplest solution is to have the iommu driver set the ATS STU when it
> > probes the device. This way the ATS STU is loaded immediately at boot time
> > to all PFs and there is no issue when a VF comes to use it.
> 
> This only sets STU without setting the ATS_CTRL.E bit. Is it possible that
> VF considers the PF's STU field as valid only if PF's ATS_CTRL.E bit is
> set?

That doesn't seem to be the case. Do you see something in the spec
that says so?

> > @@ -4091,6 +4091,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
> >   	dev_iommu_priv_set(dev, info);
> >   	if (pdev && pci_ats_supported(pdev)) {
> > +		pci_prepare_ats(pdev, VTD_PAGE_SHIFT);
> 
> perhaps just do it for PFs? :)

That check is inside pci_perpare_ats(), no reason to duplicate it in
all the callers.

> > +int pci_prepare_ats(struct pci_dev *dev, int ps)
> > +{
> > +	u16 ctrl;
> > +
> > +	if (!pci_ats_supported(dev))
> > +		return -EINVAL;
> > +
> > +	if (WARN_ON(dev->ats_enabled))
> > +		return -EBUSY;
> > +
> > +	if (ps < PCI_ATS_MIN_STU)
> > +		return -EINVAL;
> > +
> > +	if (dev->is_virtfn)
> > +		return 0;
> > +
> > +	dev->ats_stu = ps;
> > +	ctrl = PCI_ATS_CTRL_STU(dev->ats_stu - PCI_ATS_MIN_STU);
> > +	pci_write_config_word(dev, dev->ats_cap + PCI_ATS_CTRL, ctrl);
> 
> Is it valuable to have a flag to mark if STU is set or not? Such way can
> avoid setting STU multiple times.

We don't because we only do it for the PF due to the is_virtfn check

Jason

