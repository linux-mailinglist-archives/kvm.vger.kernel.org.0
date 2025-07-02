Return-Path: <kvm+bounces-51238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CDFBAF07AF
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E35F9424139
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 01:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C5A136348;
	Wed,  2 Jul 2025 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MuvTK9j8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012B272624;
	Wed,  2 Jul 2025 01:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751418254; cv=fail; b=nqOd2HDG+ITqQwdI8Fpictfg3brPQgdOfDnktqzIPEDka47xMkQTuu7CeOnjyo/BkOXTSYo/yhiSVzbsijeIYgtliW2cZv8Ddig7JoLDyPWlQzglgoT1ubkmLr78QDAze3B+SUDL0yLwIBjZWsUSHI9OvPqjcfazLhiChQnBGyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751418254; c=relaxed/simple;
	bh=8Ir9xzigaqT8JkqzwYP3nIXGEkPRi3a2WHUPLgdZPWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PIUwrxQ6Q2tGPq/sahR+vbd1UxM5yMXEAynNBvDjUZ8j3a5neuv8i2iHZnXjbvR4SItOX91dKizsMC7fKMQ1uv/4xVOtFzDzGxyATMaEn9h8wWAbrn7NiWysIXsXObV3CStLb4SucnkQf256dDFWpbzujQnU3UAHdP69MRcoKyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MuvTK9j8; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oGoAHbmkbvoKxnn5DObybhboUfWChqeqEkMu23zPVGMwdp9lipSJa3/BbiGCDRHb3w2c7ZXbEaWuGCHgmsTMedEpPb37GwkEgKI1Yt2FJjPA6tIQUnp3XYDGcx1JHUk/cY560XpdIWiMtSVebNbvwYXb/O4DLeNlBTKw/W3w82PI39ag3TMUKWiVVwDSLwFz+s2AbZTlK2OSmoCtkhnipS73HMjBMZe25DWDu3gAn1A/iVxRMjYRW+MYlrrPDzjxUVLT4G8A1mCPjQ0jVAgwRCcqhjjX8qViET5KHRUhJnY0wnWYHlMWDfzO2HiWEVPvU5eMFXcs4wNI3aUq6+i/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RWp/qgNXlm56dNIVwl6/8wyCb99ddQ0xsv5DrrSrqQ=;
 b=tg+Kqv0QWTFAv1fARcXQDNc4TrhfWP4VX6jmytqioIADiGxi73M5j6zxU1a24sJv5bqTeYT+KzZvcFKtpS8l0uOeej2jc9K5xvucjuWAnRhwqzm/wa42pTDtgFYPBQjomhaQgc100qRJvC3HZn0oh9igD/a0TC8AF+rwQhxfSgPw04gjejMgv0eTa7MxpPA7uZ20RHkxVEbFbxR747v4V6v3OgLvcQsD+git4ITEcd52voMDSwKMdDbDsMMceAGc9r7gO8T5BLdkOzol+2v6SVM82WASfk8D0pf0TvCcq+65ylrP/BHWxaOO0vgyw51PDiwaF+pHKocaLA8+w4yzbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RWp/qgNXlm56dNIVwl6/8wyCb99ddQ0xsv5DrrSrqQ=;
 b=MuvTK9j8bNgntoQoToVqb4aHNLYvyEh0YyITNfKHhrOqHB44i9UI92GxAmSJSOCtcmF0NhAp4IJcANN2o9gXTMEb+pCa8NElfr7fyoL0uj0mjkYTRvtDLfjqLBcd+L/mVNd8O1QLIsuTJeYg8G/QtNdKBuLjCK9YNZJ2HdLq6zyqKR/VhlNy9jjwAXH3GrxDtq/WLP6KY6UiSrijjhLDCGSInE7ZS4V19qGUoRf/A/HF5Uw7eQuC3Nb3dPgloiZA2OK9yk6BRDa2FVuGHyp9luJG4VE/8cINCfvdyX3ARqQ1DeIsM3poZLmtd9fXiQhX0p1OBgEhEm2pBlK2xrvwvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7533.namprd12.prod.outlook.com (2603:10b6:8:132::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.24; Wed, 2 Jul
 2025 01:04:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 01:04:09 +0000
Date: Tue, 1 Jul 2025 22:04:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250702010407.GB1051729@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701132905.67d29191.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:208:32f::30) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: af6a7d77-72b9-40e9-105c-08ddb904598f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kokj5Q6HsmnQ8fwEWkI9UX8hzaf5vbp2h8hSReePsDChhj5T7yFxGuG74m9c?=
 =?us-ascii?Q?Jse/htUPbSILqbFaKGdMQNRQYUyvZBu81WtF2g/atOm7RrvXDknBdFFHGZ7P?=
 =?us-ascii?Q?ZTP9m8/GOqVmWuuzwwajq1FnpxQSRNXBOmy4DdxWEa69Mp8DIl8CTMj4p2AP?=
 =?us-ascii?Q?lz8uSA/jmtJ+sEAj6Q4XYNNMZNGU4JhJjqdfOIa7/P1hsVd5P2JmMaGvATVI?=
 =?us-ascii?Q?qOF1i9FaYa1AP3yzul/vwS6iG6UsudFtaCm/E/bzfAMDChstIGDj027lnP7p?=
 =?us-ascii?Q?a2rSbvkYHyRdLnNv0ZG9PmtumjVRbCbxPGpVwUjMBXgADNQtT2GPI/fx+4Gq?=
 =?us-ascii?Q?RjxNvEaMaC8wEj27YGJtahUBe4UH+hdOEH1nqbxP2MrE4fyiLU0yA7ZYLAoX?=
 =?us-ascii?Q?RuWwUJ0kWPzBzrPL3u5C81btocb8vA32WkJ0htn2lbWQn29KXdr1WepCptII?=
 =?us-ascii?Q?TyNiS2W0GKP8MTz/uN/j+/5JOtnZ0gibs9o1Ffyqz87DFhkQymxZAkOUA05h?=
 =?us-ascii?Q?tsplTtunR8kZl2jpaZpM57rrSbEqVjmnDfV9UZNAK8flm1/AnEf1RpkfCaGU?=
 =?us-ascii?Q?MpshXxWrQl2bprXSvmHcR7+rEOf8OO4z481zm6iP5L8MCjPmDMNx+pMYagyy?=
 =?us-ascii?Q?RSJ1Q4VFinsDa+aj6ipyOZXKqhP3hMCpIbRGMJ/6l7zDF6JSX8mYYoggikM4?=
 =?us-ascii?Q?yhN8raoMD6Fr6C65EFaekXJpxtbchv8TfUvE8j6do9CRYV26/iNNkj0laa5E?=
 =?us-ascii?Q?AfWPKYd1/0mkU8S3XvsaLxJ3s7x33DSAgJillmW8bX9/uAjP7JFAza8nYeD5?=
 =?us-ascii?Q?QIy6xqRS1rAvuD18sUXnzjrPHSsbFpwPoEZR5fuMbjNsOsw/QSIKsfG4pSpB?=
 =?us-ascii?Q?v61AfzfRCZX8mkzQv05alnNjDplCCx4mrDZgB5AvutnQMutiDpU68YE/w9ka?=
 =?us-ascii?Q?FDeCzkkP3U3CYMw22V1UmUlumkcy0T7UICh2fLYYmTso54cd3KBfKap0jk0U?=
 =?us-ascii?Q?N0KPlrKlPLe4XneknjjkIqE7ovejM3PLfeXs6UJs+jZKQP506ZbQc1E9JwBy?=
 =?us-ascii?Q?ykIROYmUFQA0jmw0PE7FcBATAckJgQecEeViRorZP9CliWG2kyOWUZqa2vmA?=
 =?us-ascii?Q?70WJskj8l3eK0Arh82zuixEt2qLwVAVvp+U2eU2vopusaKBjHvJ02OUNWRX2?=
 =?us-ascii?Q?sCv+bb2vDuuaLe7jM84SnlaGbwQZIUC3T2DdaxLMLT1v2dkfCFosHNfSOZqi?=
 =?us-ascii?Q?7i5rP2P+OZDYXKPPzatX1CSZeJwnPJFHe6CHG5jhgdzftBzqIezqJtSEB9fF?=
 =?us-ascii?Q?Wq6XnmVMpp2bxm8lo+pCHHsk8CGb+QGnNCdPZNYTHjABA3H0CgKXYfDFygEp?=
 =?us-ascii?Q?7GF9ee/ezRSuUyrlPFpzXguIlsdGlFay5nGQCAE8eHSXmjJaE6Lp736VEo4v?=
 =?us-ascii?Q?8LtWnmf0wrk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tHW9SZebnU6fzdjDvNopoPrOQE+esJsQfcDOtGiIIskAoxhETuZ3FCF9/AQj?=
 =?us-ascii?Q?d7iO0/Tc3geJIcUIRczgGx17MhOMAJYxOg4BY+SBwC/EzY3s9fHw1Jwk5GPg?=
 =?us-ascii?Q?9mV3AwWuKmIC+2TaivtF0mShHLdBoWVD5Eq4Uh+kyAfEr7EwQS8jwnBVFKW3?=
 =?us-ascii?Q?uINx31zdDpCp/cBZqalokS3Ma9XclrBkJi0VB/eMfPLsXkR0sWU2to8fejfZ?=
 =?us-ascii?Q?uyNDm84aEk+ElGo2x7h+BPFi9mdsI1l11znOii6AIgNfz2zZM7CD4Yx84iuw?=
 =?us-ascii?Q?J61Q0CDhrA8uSLw0UakyPKrN5IgCoF0Hv/BjAD7GojkDG0x5T96W/zNqXpek?=
 =?us-ascii?Q?UjPd1aaRDfkE8OF9x7T3rge/bbsVy4A51W8NoGsmNveGBBp45JFUbghm9FJM?=
 =?us-ascii?Q?Dsdr58kVnQF68wm9TIltjC4yVWqEonKf5B4wc4vzLwfR4LAY4X3KjDNrUXIo?=
 =?us-ascii?Q?+O0999i6XJi4hPJsvNL3IeTmyJ6FMPbO9zH6lHm8MWopYhp0K1AoYPepYjPo?=
 =?us-ascii?Q?jD9kUKIAk2LMgq3blcotVcPKYAAKPeyRa3iD7/HpDuJDTbkFsojRqFd/o0KG?=
 =?us-ascii?Q?70m79KpdIUS3C+YJ0zpIpYHElwcEXfmlmfj8IG2d5dagaQaJKF1ckjuiJgUp?=
 =?us-ascii?Q?CkPJmJBL8lyV4VS1oX2J05/acJ0RTfcyMMvnpU+PW0V3B58upZNc7+b9/TSq?=
 =?us-ascii?Q?zeQMWvEU4Lh9LRgWWn9RhdQm2DGNTKx8imp93gwNkCx1KtZNjhA790EoKrYa?=
 =?us-ascii?Q?WSMRJC7dPgZdoF1bMAxdafYNsl4I8BOJVULwEHs3pC278ecA3hRWOUWhKTUG?=
 =?us-ascii?Q?b+71dxiiiJHKmJYoR/piKSV/c8e3WQOtZDaOGSEZCHp6yoSMiwScng8O9w2D?=
 =?us-ascii?Q?WTEs/JJoLLw27uqKpJvqREr3sdSXyn2mtVWwhNdZH2z5gE7EBanTADnRHac/?=
 =?us-ascii?Q?krfnjhx0YhXem54wL6eQzYUaWfOq6GsUcb+zFp4I8BDLgEuJRpKU/asp+tSv?=
 =?us-ascii?Q?85uw6qVphZiVWEKFn9fIJ7bF43VUC5HA2FoGESAA68zzlLPr5Vxxm4r3NDnl?=
 =?us-ascii?Q?kLtosV+Gk92EhruJl1fFWLkiQ0WhZIf6AA41XdQUwKijJm0qFD3ZoOUjmiNo?=
 =?us-ascii?Q?LXpidsghcLglJ04QqbnO0UpFzvqveOD8wtebpnLHMKUdUkR8E/LF1TffbOkv?=
 =?us-ascii?Q?BLEazlWZ0h9JfvzzT9/d03Ky0Vs7mp4pieKeAwB/+0c/Z33cMNagp4X9mT6h?=
 =?us-ascii?Q?7v4W0I6fXkWzLDeApT0CA6ftmawVckY/IGXWncOklfZWBqkEcVxm+EVsI/40?=
 =?us-ascii?Q?HkZMe47bwBPmsT/ZxEBrmBdYs85ffxVvxHSVP3DwEuDxMwpPQihCh4XAb4UH?=
 =?us-ascii?Q?VZvmSa+yPN7x1DGTq30mtcZBCfZJx3LFYsUA8RqNaz25fFVr3YRWpRhd142y?=
 =?us-ascii?Q?cDB2wpeJ4gWo4DL+S1E1MWx1rYWlrvMOTtGoxMbQz/gABHHldvSdmOcr+h3N?=
 =?us-ascii?Q?N7bNcjGcEFdVA1QqQIUJY8B9WmaLQ5r5YppzXsOozzRF8EtAHhH2M98XJUq6?=
 =?us-ascii?Q?wIL5k1Q1eDyHrIOPBb+wUgpv+Ups0s/yRi2yuz0o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af6a7d77-72b9-40e9-105c-08ddb904598f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 01:04:09.3483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cp/SK+heTHAn09f+GjPBDtjPRKEIzUqnj6TCy5fMQ5NvhwTHLHsoPxrMVFoyuDUd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7533

On Tue, Jul 01, 2025 at 01:29:05PM -0600, Alex Williamson wrote:
> On Mon, 30 Jun 2025 19:28:33 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index d265de874b14b6..f4584ffacbc03d 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -65,8 +65,16 @@ struct iommu_group {
> >  	struct list_head entry;
> >  	unsigned int owner_cnt;
> >  	void *owner;
> > +
> > +	/* Used by the device_group() callbacks */
> > +	u32 bus_data;
> >  };
> >  
> > +/*
> > + * Everything downstream of this group should share it.
> > + */
> > +#define BUS_DATA_PCI_UNISOLATED BIT(0)
> 
> NON_ISOLATED for consistency w/ enum from the previous patch?

Yes

> > -	/* No shared group found, allocate new */
> > -	return iommu_group_alloc();
> > +	switch (pci_bus_isolated(pdev->bus)) {
> > +	case PCIE_ISOLATED:
> > +		/* Check multi-function groups and same-bus devfn aliases */
> > +		group = pci_get_alias_group(pdev);
> > +		if (group)
> > +			return group;
> > +
> > +		/* No shared group found, allocate new */
> > +		return iommu_group_alloc();
> 
> I'm not following how we'd handle a multi-function root port w/o
> consistent ACS isolation here.  How/where does the resulting group get
> the UNISOLATED flag set?

Still wobbly on the root port/root bus.. So the answer is probably
that it doesn't.

What does a multi-function root port with different ACS flags even
mean and how should we treat it? I had in mind that the first root
port is the TA and immediately goes the IOMMU.

If you can explain a bit more about how you see the root ports working
I can try to make an implementation.

AFAICT the spec sort of says 'implementation defined' for ACS on root
ports??

Thanks,
Jason

