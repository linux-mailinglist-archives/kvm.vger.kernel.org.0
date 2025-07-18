Return-Path: <kvm+bounces-52930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6A1B0AB0A
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 22:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4F1F1C24A8C
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 20:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB6F21ABDB;
	Fri, 18 Jul 2025 20:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E5t66NPh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F74911712;
	Fri, 18 Jul 2025 20:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752869999; cv=fail; b=L0a2djt7J2yhdwZ3q6Jv8Ss5bJ3U8CGv7DxKZxq1pI5RuUdxtFxuVjVOqRsK86929MBqjrRe4/WbvKQDIh90NoZO1lu8/tKxRE9Fp0g+QZAJr6TM5tblsGi4gAAQUfUzXOKHBguAx7RczsHPnvbkA4LOjMWXgT0nrXZpy+CHwuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752869999; c=relaxed/simple;
	bh=kRWmPCg6HmtXF8nAd8Hqqao3DWH2oiU64RskqISv/kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cJZVCbDiY0kfXGKH607K3lhaNRXrpUcsMIdF4e9w4rRNReqIt/OTDros7fe+eJaaWE1cUSXVk9xKcztYwcm73idsRxi4e8+2bUtiolXNA8Vv/G4p3eBRQCX7NfIVrtM+NOGdVg+725wrDAVwlCFxazCWYZKE/NhvSUw0v01bJLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E5t66NPh; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=plUmNMVFJgGHe3YusMNGXHNAuKGlZ5I4peJFPBfHWo3Vcw4raGpPzX7Yg1ONsMaS96ho4TSPsi9XMBPnPkuNEDyNORqxXMUpbMlDF2iaffQ3DlzY9oqXD/7EFYaCyzbqcWw3S+bMgWxUJcYeJ83VOIUe2jL9/KMq9DM6c4MAWHWpnXVH1ktW6/CkwXtuZ0y56e1HHfj8ZeE4DxduKPMH6qzjdlpnj86qEEkI10F7Q9HJUhTXZ/uDn2RhII660tMfWUehjgWOdvAYcaK/+1cumd53wcAIu4K3Rp8q4KltiGH0j9jA/q/PCTuaeXJU8ZnLDa7VBfP79GwJHYdYjhuxCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPEt0vVe+gnmD7Iv/vOf2OZX25Yj8OX/vvQNudW9QTQ=;
 b=PVGoEC/mTIS84aLrmV1luRPz8IlKXkK+gR78FWds/WrMI0PboI1+qv66erhXHu1qlamaDAczMayu7q9v2jNZ7qPlGwf+p5OkD6L+K2tn2KspIaZZZ9EMpE61fbSgmsIQiQcWarPxIgNzvpU4DiB1NRaR61BAr0CjMga8Ea1tiGcdVlH4adxAjm8AD2gH3UL7HzcY5XtC2e6mCtexihXcR9xC1fU5zrNZOgrHa0xC1/SaVcOXwy6eqzOdDuKiLNcSB6jti10kRecrYRpQfbeHTyXJ6VToHQI3E19nryGRkcdCxbDT+tOabkakZXXqt4PhLi++thCn1F/fkArheSSINQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPEt0vVe+gnmD7Iv/vOf2OZX25Yj8OX/vvQNudW9QTQ=;
 b=E5t66NPhvLSKB09AKBOF1Tma9CaCe7xeOioFjq9w4NkXXrdVSki81bA/AtaW3+34shTdt2J36K2nLpz4MuHJlDcH+k+FRGc3SBRzMFsq3U4Rs+G9crOYw+fiJKsma9L34pi2aArlhblExrwXde0QE5HIByT9hczonLs25astli+lv89C+CkduvqJYePFWOFU9hlEfsKSQD8W5+aWqjzYa8lmxHP2A6zJxg5wj2wKn58QHtVrk+JyhEN2Kzpor199Gq9dMXOU5Sktro6YNTTRWCa54enxbd319ehr4btWjpSpCj5b8Ta79N3TEg35qDHmc/GKu/EibN3Vgv+L6UtXLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7467.namprd12.prod.outlook.com (2603:10b6:303:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Fri, 18 Jul
 2025 20:19:55 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Fri, 18 Jul 2025
 20:19:55 +0000
Date: Fri, 18 Jul 2025 17:19:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 03/16] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250718201953.GI2250220@nvidia.com>
References: <3-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <5b1f12e0-9113-41c4-accb-d8ab755cc7d7@redhat.com>
 <20250718180947.GB2394663@nvidia.com>
 <1b47ede0-bd64-46b4-a24f-4b01bbdd9710@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b47ede0-bd64-46b4-a24f-4b01bbdd9710@redhat.com>
X-ClientProxiedBy: MN0P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7467:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ea56451-c442-4b06-bb13-08ddc63875d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OAxO70A7yL38jEUW4tyBaWHtniTDbRJQf+qFVjnCyVCA7Zp6Njer1BmMMMzO?=
 =?us-ascii?Q?kH9E76varaKBSgyNgfwogKt3HbWUBeAv3YwSqVUncfvYmSATz8lk+RY9Zs+4?=
 =?us-ascii?Q?WUdohFrjM3baFaqZht99+IIYR9YJE3ZKVbYeiLiXNept3lRNeFpOirgbhMKn?=
 =?us-ascii?Q?13jEdezVTeUBBDZB9N6Sby/Qv3564jTtRSGj0j+GDXaQacES/1ct0a/bFukF?=
 =?us-ascii?Q?jvM1vqGZAVTvoZiCSsRF5x3A2IN7LrrNg5s06jcEsAc0Jj7nyC3Je3e7qT/d?=
 =?us-ascii?Q?zsbolPK+XC3t2aEiCcTof24QuvYwh+smN7YnjMHa4ETGPgzl8QMsPkBhTs89?=
 =?us-ascii?Q?qqJmPUoFEv/4Ql8v1RPGKP7xEPWTZitFM2vZo63xVPtqtzGBEtS8SyYluHJr?=
 =?us-ascii?Q?WaeLj6VtbqzFRczyOBkz/kx50XJnqYiglqPP46kXj6pmY52HxoJXF+vFLhWg?=
 =?us-ascii?Q?CqQrZiugaKkV0EJSQyiIDvoxUFtipEsTV6FCu7Qscg1NrPoKHbMJRw3XhQNI?=
 =?us-ascii?Q?2kQgmjxz6D2QTa5k4xn3IoJs9Osx+GqOgFnDpZEXlQOoiB8065UdJUl3FBLL?=
 =?us-ascii?Q?2UgPAJGKZWxWZJqZ88vrIxYZt6mWD32D6HzNJiaCZvINJmy2MTOafUV3PFvf?=
 =?us-ascii?Q?u/rU5KUI+B0gKqecD7LiB1eEY5rGOGFdAAXWnRQxG3tPTo55AtgKcescF9oB?=
 =?us-ascii?Q?7ZDtBOnBqgot+7QL1g3g1RBoStZQthwmFn76v1Vuj41IhCxSRd6SFB2HY0rt?=
 =?us-ascii?Q?yUcSxUlrBqjmrOGEHuTs09z0zmOoM+x6BcYFlp/jLo6L1JCMjVX27uFjNGeG?=
 =?us-ascii?Q?y/nYlzG45z7jTgNMlEmCNb0VlkM6LcHZJrivIoToJR0sjrTuUalNWRGall+0?=
 =?us-ascii?Q?kEbxHl9GGsgl31v62igQKaz3Nf0ci1B1owYfEQYe9gbuUWv1QRrfovKRAblk?=
 =?us-ascii?Q?ualrTZN3/FNxwc3RTY3b5vohEn5/KyHhN2OVLzrVp4jHwk4DZ2BcNayw4Cxn?=
 =?us-ascii?Q?X5B27vWuYwcar6e3dTmR26pzBLzI8qx9RCTU60DVl10QvXMtvBQF9tPE+4T2?=
 =?us-ascii?Q?tpFQ8MYyQGg5sFzBHP+3DPENKRdDpdITZbsyAOasTT3AtZd2euMdG2fDe+ak?=
 =?us-ascii?Q?WFxEINUe2LupPNPemggy8sbyJnDKSMjLNlY0fY4QkxQp9CsPUVJMyXCJFVVI?=
 =?us-ascii?Q?TVu3cKpGeOPQHQIOsJsdRFUJF2nPtiM682bNKo20Xiu4OQ51l6ZTBvXyf2nH?=
 =?us-ascii?Q?3gdk+wN3M99938BPifcuTsIGnHOW6AbMrv6SWixxrVvnhe2BCqIk/9QBs5Pq?=
 =?us-ascii?Q?yThZsTBbdJrCwQRMbOC5x/QVm78vlbi9hgce0pmrsLthhwwqDYZboXT7tjj7?=
 =?us-ascii?Q?XCANIlmfz2GX4Ln5PQbaOswa3fNm4A+OHE/6/YMM4qzYUfH5O9E+JQqEJ39n?=
 =?us-ascii?Q?5yLMFJilvxw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZpetzfVBA6kZTpkIfHlCk+G7bl5kWRE+wbtCE4m8o5frpDa2C3sObfFhO7uI?=
 =?us-ascii?Q?NkaQD/6TK2k4NOxaMa21JK+SCtbPIdLa2fZcHdEmDwJUfRg/ZmX6YjnmRtHM?=
 =?us-ascii?Q?lBpAcTq9ybv7Vir1E3MAMrdfVPVtz4+vZUzvJ00Q+4TNmHwHtpOOr7zYJLJz?=
 =?us-ascii?Q?gB2W0OFQT6CzQ0pMiXiGBdTVYrlXoKGaymf1dJSvvm/nIL79KpXrJ4vTf3Ks?=
 =?us-ascii?Q?tTcrGEY2wbs5NcPSLqmB8m2xeJT9X95e3MK8r9dmb2SdZcEURtGhvhaeXcBN?=
 =?us-ascii?Q?t0Ya2TCWoKQ213eK61zzinVWhbl0C4dwLCpXER1688oGBB8cl3+1F60V2UEA?=
 =?us-ascii?Q?crQa21Qq2KHFQOZ7kd86lx8lmZAm5XiVX12T2t6y/Zr6/EfyKXu/zHs6A1LH?=
 =?us-ascii?Q?T79GMPFj6y7UnLQiyn40qmVJrI+1MKD2UwwyPvYH6mLCT+1hxPlkc9TOF7Oo?=
 =?us-ascii?Q?2jMoamtkQr1Ptzw8lY2h+8Y1Q0rbN+ucY6Ojf7ibsljQnJVNQqWtjQjQAoTu?=
 =?us-ascii?Q?XrNJSWBBb96NR2ZEW9wC23vDSwuDdv4xf1V/dOHFqSv5y2ReGV8ULe+6ckj6?=
 =?us-ascii?Q?9OOKrO1YzrdqlOjVl+UDX4IFfG3+6gyc4CP2BnjYbOdqxJ+aX+DXJnWsjx2f?=
 =?us-ascii?Q?1mZ+h+Rmm207x3UG+QG4JgEsjsDl8+O9kT12OBsmwq7RQ2QF9gL3kOqRy/f2?=
 =?us-ascii?Q?jMtZNbdWp8F3rNGcZpjptpwneELA7kMw61BLys4sjQ8MAZiH/4vVUmgcspjh?=
 =?us-ascii?Q?coTcz90qQZYZ7j4VmdHTg9BkSg7It7xzjjGynli8Sqyjmzo+nTwD32BoDVQN?=
 =?us-ascii?Q?2NeNzV5DT1yDoEUKHj30NWM9XaFl2xwDpy9hbg7SjoFahr6dCRboEU4h9Svf?=
 =?us-ascii?Q?3HylIyobvy2aNM2kZjbR1MqLxJbR43UQZxkmARZrkmGmcPKBDOhIGD20Rkym?=
 =?us-ascii?Q?HPu6470MICD833HBmXwxK0tsAEzoSCmAgjYY3RGrV8rDSU0QW13hXuBk/619?=
 =?us-ascii?Q?QZKdvFL2O26m2VWm2g6bqGtrdq5BovC9ZLpOLDgu32xq+MfotokGynG8Cv3J?=
 =?us-ascii?Q?7ZeOZbSyS2nssrOnw8UQByeRbO1vxXCFp78zZ4sa4JYN0vOMb7m4im/lYfSP?=
 =?us-ascii?Q?iWcEpEVtdQbmjiTdtcTk4nA5uopAnoKctdlLUZVKzjpVuDcrv63/JQAlOIRs?=
 =?us-ascii?Q?ifCjdYu2uipWVMFHLUCbq7+QCAeL6OB3Az9hWVMt767G12uF74Qep4riwz0F?=
 =?us-ascii?Q?49AQRauZZmKXrSPqA13MzzruhisXBvpydDEliDldTpvlt8igCFrE9Amx4qgd?=
 =?us-ascii?Q?aFmTqjjx/D0X9LGtAsiEggcRJcMa3YcbbjQZ4ZFKivIMSehN4YPPgP9EdDTV?=
 =?us-ascii?Q?GG34TkXKyIm0KLohsHQQeaQUPKkiWC18799I1BbI/xJL66UucnfFUAusF7ne?=
 =?us-ascii?Q?p1EMNGwbDQZfUIw6T0uqMa0NYqks/076fUMrho0/0vuVHZf0j+E+Znqe44G9?=
 =?us-ascii?Q?ZS1uSE4DvthFd0jgRcAbrWMkRnJs0TGM5ZBXP50clW6Uzh1PmAJL4/B/gtqV?=
 =?us-ascii?Q?oBWr/5ZNxcLeLoWYS6mx1HBweMdpw87BdPYtxFKU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea56451-c442-4b06-bb13-08ddc63875d1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 20:19:55.5254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REjuUMpciYGGO8o4aOgmhMM+WGxe3vGwsTEMLq9xwjEJTQscHlsPqz3L8UcH6JPy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7467

On Fri, Jul 18, 2025 at 03:00:28PM -0400, Donald Dutile wrote:
> > > > +	/*
> > > > +	 * !self is only for SRIOV virtual busses which should have been
> > > > +	 * excluded above.
> > > by pci_is_root_bus() ?? -- that checks if bus->parent exists...
> > > not sure how that excludes the case of !bus->self ...
> > 
> > Should be this:
> > 
> > 	/*
> > 	 * !self is only for SRIOV virtual busses which should have been
> > 	 * excluded by pci_physfn()
> > 	 */
> > 	if (WARN_ON(!bus->self))
> > 
> my Linux tree says its this:
> static inline bool pci_is_root_bus(struct pci_bus *pbus)
> {
>         return !(pbus->parent);
> }
> 
> is there a change to pci_is_root_bus() in a -next branch?

Not that, at the start of the function there is a pci_physfn(), the
entire function never works on a VF, so bus is never a VF's bus.

> > > > +	 */
> > > > +	if (WARN_ON(!bus->self))
> > > > +		return ERR_PTR(-EINVAL);
> > > > +
> > > > +	group = iommu_group_get(&bus->self->dev);
> > > > +	if (!group) {
> > > > +		/*
> > > > +		 * If the upstream bridge needs the same group as pdev then
> > > > +		 * there is no way for it's pci_device_group() to discover it.
> > > > +		 */
> > > > +		dev_err(&pdev->dev,
> > > > +			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
> > > > +			pci_name(bus->self));
> > > > +		return ERR_PTR(-EPROBE_DEFER);
> > > > +	}
> > > > +	if (group->bus_data & BUS_DATA_PCI_NON_ISOLATED)
> > > > +		return group;
> > > > +	iommu_group_put(group);
> > > > +	return NULL;
> > > ... and w/o the function description, I don't follow:
> > > -- rtn an iommu-group if it has NON_ISOLATED property ... but rtn null if all devices below it are isolated?
> > 
> > Yes. For all these internal functions non null means we found a group
> > to join, NULL means to keep checking isolation rules.
> > 
> ah, so !group == keep looking for for non-isolated conditions.. got it.
> Could that lead to two iommu-groups being created that could/should be one larger one?

The insistence on doing things in order should prevent that from
happening. So long as the larger group is present in the upstream
direction, or within the current bus, then it can be joined up.

This doesn't work if it randomly applies to PCI devices, it is why the
above has added the "PCI device is probing out of order" detection.

Jason

