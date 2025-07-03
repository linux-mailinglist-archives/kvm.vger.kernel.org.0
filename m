Return-Path: <kvm+bounces-51529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2FAAF8405
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 01:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D89AD1C8542D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 23:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8B32DA74E;
	Thu,  3 Jul 2025 23:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d/D0cg59"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C537229C346;
	Thu,  3 Jul 2025 23:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751584536; cv=fail; b=O3iu4Z9HEcrhKuil/kCEj28VSyU7b1BrEZIOD61ohbFV+Y3J9H7o+xSu/7IsW8EvR+IAGRosW8H4hfooDquzsT01HlH1avTmLzW0vQRiJ0ZpEALc0RavTT6I36HgMHcEMlqbNv0czOETJN+OwcpKoCixZPf6Yse1F9g42Rn4dsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751584536; c=relaxed/simple;
	bh=ZzLRbCtzY1u47cU1sR52MV706CGarZAm9WhdcEbbJWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RFjQCSumJ+Kr10wjZ6+gcLmJaFd7MbCRN+/hiVl27qZj5PU67DBEVGYsZdOZE6OgtVUrP/zN5zhVomqVoJCetCBji50HariEBa9U46E/BUijKUkpOJzhdmAsXOzkg0lAqFU8OXQwhMSMMydgTJJaDatzAMB94NsfqZMQ/HbG9pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d/D0cg59; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTmy9JJ6CgJzdybKp7eNizm4m6l007W+DkmLBtspg4329Vu9DvV3z6Y/kKbzrX0XxbJPA6EZnlC0CG8Wzu/mA1hVUofs+i1S7q2UmcDnGurICkz9pMQJTfuP5JF4V2FpwJl6F0tvSW3IInSwds9ZpyG4Y8bI35TnhTd6KtAdCp7vOaZmhyZiAlLubPnE/+DnbT+Q63iBg/y7ZEWy7jgUHU/klYxIylobBDpvSkKxgfIdwA9L7JUfYlzb6s9J2zVcA0mkFbbYOmtmUD9q+oZskzIl5mh+6crxEi8XWLzXf2hsT9bHChvHeAomnJBPm1C+vablm5AxUNmrMYshy3orPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4WAJpLGguiATDyNYWV/iYcejUv7XgKXy3SBS2gY6OA=;
 b=Oln+WQ+oKIsphb4sYsDdGLR2D5SVVNzaofOISXRJLAXMFAYp+wuNaZe6MC6yqjqNwo8QNvvcjj+DPQoYUSPvijUb2NS4RAg6wjqzOtwujjTPGM4I5PzClbJXVgk9CDuqtLi0266kc/oAEpSxwbJGz5COMSMuc25bq9utTcUN9HudhnUMDxAFmnQHa9mTnlBtF/W1ddg4vytpPKrSYfVcz/hr2BloPLFhIxQGTFnFvGufAKsY/4C4nzBsuZTvSUf2eo9QZU+u9aS5UqJyW3rDii3guwM3IVOkTqZiVAjhGz2hfIicPaKMkQ0W8fBg2WqecQiY1A7JCJsmuf9j2+BaRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4WAJpLGguiATDyNYWV/iYcejUv7XgKXy3SBS2gY6OA=;
 b=d/D0cg593cpuPllHTBG6bufhpQx3tNFfJe2NbstiDoD5Bc8/SgA5bPLH9lqazKD7FiU7ooQf3pwD2pv+arbNRPQl7SRv4nLh7dpm56LySg7j8AIo2A63x+j0kdpQL6ubRDe2EFycwmJWbLGFhzUIWb74+7AvlMZrg32a8fhmt6iMZrFm3GWKjUaYcTggLniPpnEU7J5d/6XecIdiCSDXJTuIVJ2MeLEVtpjrHProljF1BvvM2jFbXUYbZYIO2dQOdNv3L2G3lnhdAKCwW+TvOeHBBheXESZYlppb+mxNIboD/C8YI1bCxxIp7/7sqe5RRkPL95rC+6r1ECtp0vJ99A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Thu, 3 Jul
 2025 23:15:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Thu, 3 Jul 2025
 23:15:31 +0000
Date: Thu, 3 Jul 2025 20:15:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 02/11] PCI: Add pci_bus_isolation()
Message-ID: <20250703231526.GG1209783@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132859.2a6661a7.alex.williamson@redhat.com>
 <20250703153030.GA1322329@nvidia.com>
 <20250703161727.09316904.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703161727.09316904.alex.williamson@redhat.com>
X-ClientProxiedBy: SA0PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:806:6f::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ0PR12MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: beeb69fe-3b8c-4710-1114-08ddba87815e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HKjGL2ykVh1FLxK2M9vqXOeoNiJBvm8uSCnJv+pUcjKHurFKYX5GNbuDXg0x?=
 =?us-ascii?Q?LTJxI9Vhc4gH8xg8gEOBOo/aJP6O9eKCAduL77shMazBVnZnQlAFFsdIwXtp?=
 =?us-ascii?Q?hU2TXgRU3IoJTfFem/dMf1lUDf3yrVqJMrk1h1aZ7QCGNc4APyEx3hiaj+gv?=
 =?us-ascii?Q?9Xj3gDgmMHSQ2I1PWUhR0KZAmWGuxBrmJ6q7zY5GksxR5zD5r6kbqpqWqqcE?=
 =?us-ascii?Q?z3QQYVZL0hVUGrZYrgfS6GC7tlDyxgjljp91xiw5jOXIvZlxABoa4Cy1jaaf?=
 =?us-ascii?Q?81lBfcX27vO6NtQbaU0nEUgZsCTTHm+94lhYPOKXWjrzmeEOs/1AfB42hwDU?=
 =?us-ascii?Q?WfrvBLvp2qKqRm3mkZEw3/UbYK4YfEBQDZdQUhQVuLavmJuCzPlHlScajvNa?=
 =?us-ascii?Q?lcYVYMPB/tl/srlk5t1ZXZ5hR8OKUQ8cr2qfrcjmW6PlxUHbBYTkfqH7a2JK?=
 =?us-ascii?Q?58WmYZ0gkcKWzjOZy4vUF7fYinTNafLoKRugatOGTzRiscJp/sle5Op2z2Yp?=
 =?us-ascii?Q?HzWA8dPA9dBilHNdQVnikw8brLx4thoEGgmxCIGwTWXu8kOz2xeVLQ1NAkmN?=
 =?us-ascii?Q?K27uha5MOirekMxA2T4pVx1zAKe7IOxCRAJBAOzrqWtCqK2UKOM84SRdUx/r?=
 =?us-ascii?Q?Cb2PWUUKCd7KBkzZBI5f4+CphB4XIfHMb+rJdjcaU5bHrqhReLXM0qmSyoW3?=
 =?us-ascii?Q?X53P481bHuNRNLPP6rvAjfHo+UgImWHesItx+J7I2eU2hhXa9aCcKVx5UBh4?=
 =?us-ascii?Q?+YgmyCi+R5KPleNbBlWSxBQFteka4EGbIQ20ovwHDGW9beb8Z7JX8Y/XRkCI?=
 =?us-ascii?Q?iu6iNQCHMQIO3jtbrBpp3BZNrul6A59xZyhCEmEjPR71+c4t32DZ6Jm3C6jI?=
 =?us-ascii?Q?wXEsb6J1QCu0sE+bF0uJ03zm/UyL+mCDaaJh/KYlM2K0bNMnJQ6ZZK4ABnVy?=
 =?us-ascii?Q?+CUuP8yYLD1AUmCkHQbDIu4lwllrf+mODCKEsg4jA8esim/o0xWtfQsR6u5c?=
 =?us-ascii?Q?Agfq3ZlD1T5Zg4ylno1ViDyR8mNG1ttnFpBton/ir03i75JsuDJBdA53u7Hz?=
 =?us-ascii?Q?6WTyYkt4A3MfbPZhgYnV0w4VW7U2l8fcxN/6XFLRZWdAwnyfQYRJXOMMQboQ?=
 =?us-ascii?Q?A03bJTbXc4ck++NRvK7Tm43N2d6EpBisbPr89Vdn//a2wWSW8xiQb8gySh+2?=
 =?us-ascii?Q?YxpBii3I50sm9alV7v+SjCQIIXn4JsCtbY9ukbaDThf8qDAySMVizRdIqjXY?=
 =?us-ascii?Q?2mDX6OdGZ1fJ9olvYPQAT0bx/p2aAwf9XiMoIo4ON9ywshG9Bw6ohwdvqtjl?=
 =?us-ascii?Q?7e1EpeMpF3SkHjCPls45pJ4XOsPBbiJmIP21SUEPE+79jo4PhysHX0R1QqAR?=
 =?us-ascii?Q?kuhibAVwqrcugSiULTeA876LzJoCTZq0GwJHw0FSn8glc7tt90Yx+z4ntdve?=
 =?us-ascii?Q?sCTaswxeSYY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cMY1O7kjb5qOxqVcchjGez5kj60cnD7x2M3KgF3jcQCoNgpeH+IhrEfsthnX?=
 =?us-ascii?Q?CKYqf1hO1FO/CCqGWZZkmgH+1ndwp9QaqxZJnQ4mFZadruPjKKJmcZJBIk6i?=
 =?us-ascii?Q?jSupqPUB/aoZK7rsjWpTA1hUe7UxZGi3qlL8HGbP7TiJqFnxvs0KWKl2NNH3?=
 =?us-ascii?Q?pBP+Qgy00yWiYa4bvoyFqFKlkxEo/TV8eRIWznEXXaT+6EbmAZ6nc/dy/7A9?=
 =?us-ascii?Q?mmeN/JSs8rnFSGQZRJq1rMyjdeLyLGW/Fup74XG0wPNb5pbcEdAJsdTiSk2G?=
 =?us-ascii?Q?wOkgRMB4QbuQcj8Tse6qHPTjBuGrNC16Jr58qoVVEQbH5thb65s3FtSx0Sy7?=
 =?us-ascii?Q?ztXRavcJtoT/pgf1Hjg7wnOkE5XOK4qpiLc/mTVJ4c9Nk4n+d2LhbYMxnt6L?=
 =?us-ascii?Q?Dxh17T/iIndiRR+LCw3XGOg6Kr56mT/KoxePUSLNGcrZeNwJSSdjimeZi4Up?=
 =?us-ascii?Q?2/bEOzLupRE/t5kynWA0QVGJGT0uRqE1VxXvoG1+YuUB9mlrLaq3VQs76Yvv?=
 =?us-ascii?Q?QDzEanZ++WM4GsgQ2wDtQlM+2gUs1WeBw5vScyT/MIGkBIxpuFADNkVT2Vuj?=
 =?us-ascii?Q?KsF5If/++UxBEL17KQnR7G2eBHNYYN3AGrlSz7S0P7TVZm0Fx/yLjFgA4VIH?=
 =?us-ascii?Q?+OuAIxKasJb4UCpj6C0kvtvf7cdvT18hVbFpJ9H3bVsfx8y4ElgCe959ILKL?=
 =?us-ascii?Q?GXFEZaIFCIw0LBupxwwXHQSHZ6MN8llA36+B6g5RXS8opt1Kmkg7+elsjSFZ?=
 =?us-ascii?Q?6s4/Lkz6Zp9guhh6jqPXLqa+3MmjaOuy97xHwg3d71fxVCCGddMRSns34AhA?=
 =?us-ascii?Q?xC79jEEDQWtOc56Ev7kXr7wwYFMTbJlR/Cw6VkhGhuwg8NPQB9Z1Z/IfGPWJ?=
 =?us-ascii?Q?SwlZjPKPWOa8ag6leN4hx/weOTtM2OkEp3IJvqtgWojgiGnzRhDFLho83n0x?=
 =?us-ascii?Q?Rfd5Df8Nclk9011DfiUJVaS8moX76RTfooup4H2Rjl1Z44RJ6ffSiuCbDgJd?=
 =?us-ascii?Q?grOVk90CIS07KeTX+E848QsEbNqc2U/0LYPYpJnUmV3u6kISARpqzDZ0UdXO?=
 =?us-ascii?Q?VFPzTQ/g/h4Clhp1Rsr8jSbF3uWS/iBO6hfQhonviIo8C3Sf2cBeiaa9nmZB?=
 =?us-ascii?Q?40fcLJ3XwSaI3idijeueGWVplJ3YAKjyFQHTVrRXVcpBRji7AWSqsEK5WAzp?=
 =?us-ascii?Q?Z+nvz2KIHuBusNmQd5DvMC66bTNmkOk8HKoP52wady3bAz5gKKPxzq9BD35c?=
 =?us-ascii?Q?KpQV3bsThl1lGbmiVswWQPHkJdBMdMUxC1zQRLxksFwKhFavvt5l/OGCFHV8?=
 =?us-ascii?Q?KEO0LxatDgXbZHCH0N2eezzDkzXnv7NzR/gWkG/dK3O9v1BrtUCmbciixYkz?=
 =?us-ascii?Q?botaPZH9Be4vVZYBzEukhHtfLHaiKhvl99Dk1KnVleHOxs7Ke9flL63+EE/3?=
 =?us-ascii?Q?FdBA6ccY2NJzF5AR3OJqwkqoXIck8j3coI6zuXPEmehrJzirzKNzmMzdrNn4?=
 =?us-ascii?Q?nJxuqHARS0S+Z9G4fZOMDSL5Evt6my+X0b5JLqljtEbZXMo6hhxQmqEmtUe2?=
 =?us-ascii?Q?GbpBifaQw7sGU0uLm1qB2L4qVjfdaocUg3KEUCTF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beeb69fe-3b8c-4710-1114-08ddba87815e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 23:15:31.4093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLU5xCXGP8lylZ98/BBkaMAoIAnA1kgmfRhY5BTFLMRivbOJR5O4OqS21YdsWCud
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965

On Thu, Jul 03, 2025 at 04:17:27PM -0600, Alex Williamson wrote:
> > So I will change it to be like:
> > 
> > 	/*
> > 	 * This bus was created by pci_register_host_bridge(). There is nothing
> > 	 * upstream of this, assume it contains the TA and that the root complex
> > 	 * does not allow P2P without going through the IOMMU.
> > 	 */
> > 	if (pci_is_root_bus(bus))
> > 		return PCIE_ISOLATED;
> 
> Ok, but did we sidestep the question of whether the root bus can be
> conventional?

The root bus doesn't exist, it is the thing on the other side of the
host bridge.. So it is implementation specific and I don't think we
can make any guesses about it.

> > And now it seems we never took care with SRIOV, along with the PF
> > every SRIOV VF needs to have its ACS checked as though it was a MFD..
> 
> There's actually evidence that we did take care to make sure VFs never
> flag themselves as multifunction in order to avoid the multifunction
> ACS tests.

That's not what I mean.. The spec says:

 6.12 Access Control Services (ACS)

 ACS defines a set of control points within a PCI Express topology to
 determine whether a TLP is to be routed normally, blocked, or
 redirected. ACS is applicable to RCs, Switches, and Multi-Function
 Devices. For ACS requirements, single-Function devices that are
 SR-IOV capable must be handled as if they were Multi-Function
 Devices, since they essentially behave as Multi-Function Devices
 after their Virtual Functions (VFs) are enabled.

I read "essentially behave as Multi-Function Devices" as meaning the
VFs and PFs are all together and have possible internal loopback
similar to a MFDs.

Meaning we can have P2P between VFs and ACS is present to inhibit
that.

>  I think we'd see lots of devices suddenly unusable for one
> of their intended use cases if we grouped VFs that don't expose an ACS
> capability.  

That may be, but how should the spec be understood?

> Also VFs from multiple PFs exist on the same virtual bus,
> so I imagine if the PF supports ACS but the VF doesn't, you'd end up
> with multiple isolation domains on the same bus.  

AFAICT the virtual bus thing is a Linux-ism to handle the bus numbers
taken over by SRIOV VF RIDS going past a single bus number. I've
revised things to better handle that by processing only the physical
busses.

I wasn't thinking multiple groups because ACS is all or nothing - if
one VF/PF has ACS that permits it to P2P internally to all other
functions then the entire PF and all VFs are one group. Same logic as
MFDs.

> Thus, we've so far take the approach that "surely the hw vendor
> intended these to be used independently", and only considered the
> isolation upstream from the VFs.  Thanks,

So maybe if the ACS capability is not present we assume that it means
there is no internal loopback, otherwise the ACS must be correct?

Jason

