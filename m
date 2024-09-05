Return-Path: <kvm+bounces-25937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC65E96D7D0
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E73D1F2431E
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAA019992A;
	Thu,  5 Sep 2024 12:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gzafz6k2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDB219149E;
	Thu,  5 Sep 2024 12:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725537744; cv=fail; b=kfECezVuy8/BL7vadPr5kbrhsjnq8gOz1B+4ffrwUbusB5b3hKQAUULOdAMOcbCXTLCrTo6RwQpidF3Q0WDmEUgCbXD7TmwBexFpde+ucHpO/kA2T7GbPyE+4f38G2gEwSN+u/1/k5HP6/cl6fDzinz15TcvKk7nLH6fAX3ta/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725537744; c=relaxed/simple;
	bh=DHVEViRINfVryG6ZjDWVCGi/nOOYm+fRyKIRoLYrap4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LjStKPWYBjSEBRAM6HX42yhKFK7TuF2VdEqTrQd2pYFkN4vq3LP3lNVOZixKwTxu0LAgyC+HwX74t5FTo2om9dZbJJx7l1k2q/my/ssVzfNvSCS4up0T0Ecw8qg2TQ/nwRfYFf3WoffAuN9Dh4dc8obSlWruVyw1KbUj1MGFggs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gzafz6k2; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wW5R1gBIrmhnjNqbBr2AK6pyIqj5NU42YOGZ2WAo45gXSUkXhsPTyKJweOh3tRpgdslcyZaxP36X1Y+xeufN+u0/juM3jXrSyipcCsqcDeGonIf9IEiIVJPsnjKYBfaXSVW3RdF8V/Ug4OFseW5BUUVF7XWevJnoWMwPRy1S1XXyNmQty8S3C334s1G14c179I5tBkh928hrtq8iB2lfYUbuTpz4FRs3eRwC6qISxHGfhmc9CxBBqxEKdoEArlEgfbbJvyxlqouuslP9WzM5bIlB2YQmKZDZXsV2tj7t0Qyc2rRgkqWVWaKgbNCZ+pL38W8BxFKDpyMCMsf+LprXug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XcqfT0FjoH7fCfOhe0fmT2WfApTIy9XF3C1MwQkI+0c=;
 b=jh9xCuIXRLez5JBhLwkZc8Df4kxGZ/4WbZKcfL682LSvDqONgS0wRExqbjbwyo5xy3h6c8rKWJJtgw3F2+XHDKMQfeS9aiqrm0sC60BZnD//2HBk4pJGRTmFQBKVYM/voM8bLnMo2CgOh8mTaDij+wdqZUxqYl6LHmJJ50l0uQou+dH4v77khlY9qfaJZhYr7lXjB7y+cBSVakGbF1he17GbNga4YOlNiww3WmLdj8q5mO8rku2zKcYE8uLX7TAPBe0Uvj/AalHQ8lmlrBPPL3uGFlG66hn8JYjl9SSh5QcJYa8DP6hr5DJtM/x/p27a4XyC8uTej358azKM7NWRPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcqfT0FjoH7fCfOhe0fmT2WfApTIy9XF3C1MwQkI+0c=;
 b=Gzafz6k2LOiUWbYJmWehlIzvSEsE6hvmgGyQD5S/zfysUgXjzz/ULmNuSd0DdL4cs5gdPMlwcyzP4X2wocmxsscPEhBYViOZJzpqdOeCr3qdjsR0dvq5ytGMD4RbHBaQbnL2De9ul6g1sTVwQ9Hxji8jDDTBSNAeEI2ECxRfNEXoPU9VBHdWQ3JFEO2QsCc97Om22aJiYpcyheVkCNgdiIzVnux/nEdjXqfp8/93gTxJFoK8L0ceBJT/cyKBQ+cf3wgvKfG3FG4RosN7QVrMZD30o6gAc3ZkS9nXuvfPC5ASyr6ZOjZfzJAgEU7J0pYKHvYBVbuyXBqcJDfUbemzZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 5 Sep
 2024 12:02:19 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 12:02:18 +0000
Date: Thu, 5 Sep 2024 09:02:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
	"david@redhat.com" <david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240905120217.GC1358970@nvidia.com>
References: <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <BN9PR11MB527657276D8F5EF06745B7208C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527657276D8F5EF06745B7208C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN9PR03CA0440.namprd03.prod.outlook.com
 (2603:10b6:408:113::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|LV3PR12MB9356:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6bd2c0-ad3a-4cfa-e986-08dccda2974b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UHh+qMnCUT7DxMxYAwGVf/OmpY3oxPpy5aZJ1tn4Y0lj4Sa7qjCjFXxFBvWV?=
 =?us-ascii?Q?w1DpUKQzmnPPfUbKTa29ve5gDbsz1xPnk6pj/kVdcgVwSsQMszZgIZce86sv?=
 =?us-ascii?Q?mBrvYEhYYJYwN7qBGQ4mCQNPhGPZ4G94hTptaUlBJQDU3qlbjwJoERSPJpuU?=
 =?us-ascii?Q?Kc14y7e5S/MQgJ3vLTChs9ZvIbXpH8JQL8ubqZrsHJV1KjH++yMlzk4m9fsH?=
 =?us-ascii?Q?cTEBiqGTS1P+RL3wmP4qUPmBh1K+i+CgyaoHj7fK32FF2mWs6F/j365s2Enz?=
 =?us-ascii?Q?yNBKPjP7J0SAmxOoAivyJ6Lf/8pnL8IwiuYqC4vT9HIa9hM6eXtA3sgbfE3c?=
 =?us-ascii?Q?FvwyF85YkhaqBVtVdMu/Bu2PK7u4zf1GXNmNIj5A7GD0SiEWn7cGNYCBtN0B?=
 =?us-ascii?Q?8ojejcl95tWnuj/eHfUT3wprrTwe+gG0Wm9P0dbOrY0bjih4NJaphkOsCnlw?=
 =?us-ascii?Q?zDHTsqgj/NAeS7S0S9x/6Od7rV1aU1tehUcy1EuUBbTdPnNZK6Itnz+i8XcA?=
 =?us-ascii?Q?9XgERCF2l19/uY0MwPHoBxBfH+yggzjpuviissxHroHzKisovGNr6UA+xVwh?=
 =?us-ascii?Q?jGccmVjs7s4Ozmk9Iw8DArFX2xnNmbZgr5Lw5iNh3PjWj9c5NW11nzIQ12qH?=
 =?us-ascii?Q?NH+aJB/DldEgGP7NfRqowph50bQWgLLX+/kbGDPrciq3/DshZdfJgE/yi2eH?=
 =?us-ascii?Q?sckMdS/b240gnpsl3YSds8z4kE7nY2USxmZEoXETD7n7UO/lTbS4DfTi1wsM?=
 =?us-ascii?Q?3ALXGsKeOoXVCG6eJUke4ff5ibrkrIwjv5SIm9l9/ok0z0Me+3JMI9ETgWA9?=
 =?us-ascii?Q?nxbrQhxShNADPOY5PxtPxfqirmP37Us5D65V/PgHjCto2Jz3qi6IxEwwVI84?=
 =?us-ascii?Q?z4M3vd9oxWdUkjbW+wVzFp1+ebLiW2abRh8HdR1D1LJxwvBnrC8EsqY6gYd2?=
 =?us-ascii?Q?9ZiMp/Zd11t8JGMw1msIQ2nFD38ZfaOtLqL6pTdhuBBv3UO6S/jEyRrgpbgX?=
 =?us-ascii?Q?F092pufGhd42qikXJQiWX+23x9w8gUs9rUoxwM0PTdhpwulHmmWHDr+WKKcc?=
 =?us-ascii?Q?rRu1YeLB2c0hoqP4OLQL4cO41mhlQGsWJ7Z5BpQNBlGalWDUBTvT/iRsTwou?=
 =?us-ascii?Q?UcSc51ervIBSV6khX5QnYrrdRkoywpf0JIyFaIIdxPGQVxiDS8km79oLrmmc?=
 =?us-ascii?Q?hD7rOQ6Z9upvBGyTOEzBpuhOjaysfiLg1TbPYdrnQ+wrr5WX6B7ns+56F1PS?=
 =?us-ascii?Q?MgalRlpHepxqg94NXEj27ZfwWBG3xviLNT4FSADYEdzRL6E2cmPAyixzi2xg?=
 =?us-ascii?Q?c1AGv6I0jrQU7H/Ljf9B6eNsP026CciqZgN095B3JHHqkA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q2qKNDXRDtPXY1sWcSIwDXt/IZkaa4Pxe0Cm2PUoyO8tyxC1qrqQYZP2+uoG?=
 =?us-ascii?Q?C8X0vK3qLcJZ++pZPGDNeEiQdNaL1GgEfKUQUlkc8CEEkxqJVp7u+VTXKn1m?=
 =?us-ascii?Q?pvn/sE/Ze1pMquG2ztXynkfsxCDrysmuCTAfCfWDaqzIdIH4L3aFsJ2awNM/?=
 =?us-ascii?Q?mcWN+6njTjqy4xMv83uqzA7SEOjTHGKxSn+BFxzCSzrv+cq2jBwZhRoiG0h4?=
 =?us-ascii?Q?ZVYsUe0F/vPHNGofei4OxTkNJcyebyxQbeGdDX2Kwz1dJmBFE1Kiox6hU04m?=
 =?us-ascii?Q?LudrtvTgebHIaJrFkoV6ew/+k6kVAHqPUGjuXXPOrMEK/vuUpi6imfH5x3r2?=
 =?us-ascii?Q?BXPCo/UCHnwmgv+l/2gZYwb7QqGd1J14S/bF5SjgE/ePszkzOwelQJ5SfLTb?=
 =?us-ascii?Q?KigJRu3TVzHN/5Rgs572id+oqrgs7cFId0nwENjKpYZFV5FiUMxr/VuM6XiM?=
 =?us-ascii?Q?pjqjmoR4oWoY/8cJID88eo3Y5N1nSgaytVB4e9Sj5yCLiuzH717HFkWl4pXW?=
 =?us-ascii?Q?D2LS213MVniqjNYamqwTjmUKtCPeE+4bSk9xhyVrJbN2fSzEHNvmDZYpivxj?=
 =?us-ascii?Q?wMID9x//sj7AhWMEKoa+XYOHIh5g7qTh+LbdJVIBbQrBpZAIpp0+F7lJCHAM?=
 =?us-ascii?Q?hZxT+J1ViXMHYdyo6g9gfEpCJmonFV3lUIPYVSXhWZlpA1rlfKfmhbg4iE3B?=
 =?us-ascii?Q?2+a+Vh6+zY/uFJEBQsScoPc6uFx8X+KNRc6/WS4ZnbyohkpYFK59sioOm8GV?=
 =?us-ascii?Q?veonMMsaglZtG3pLR78exX8ciA/kAR/zQa77xvlrcEOLjANZfJXyZ/VipgRH?=
 =?us-ascii?Q?a1vuaGjDVViwd5A2vx3Yf9mQEd+KWUa/aB0jheEDwK/6ywkDT87gyn+MSc6z?=
 =?us-ascii?Q?Hz9IccSc/LvzttdKhGRkSDFX1BhdiKpET+tVfV9w5cZElBE2+728X1T2rm+9?=
 =?us-ascii?Q?dtbryA/EKlf/pSKrUkGN+GRKibdKfit0PYza/Id2bUZBFvk34aH6SbhP1KwT?=
 =?us-ascii?Q?bopCNDMopzS4s7HYgkaSe/RVf7uNtLISYh+Nf5CQv4rvQJc91sQFuAO0etlj?=
 =?us-ascii?Q?Lg1X5c6gFlQtTVo8T4l7kWsJi6xoAKLEaWN1tMXPUmO/tjW8y4niLJVrzYC4?=
 =?us-ascii?Q?NjxModIs8PNO/H15mW/U8fN3Bl3/pB1YK1/9rcKNokjLHpdBQgASGh34GmPq?=
 =?us-ascii?Q?m31SeVFM0ht9AsFdDDb2CooyacezuXs3GDMrI/Kd3v3YyZvLth2xLbbUPrHI?=
 =?us-ascii?Q?MGuTvcTOmHaqX1yHzzqG/vi5zu7KbPTISluJNrIQ2pq7P/ipOLp2CIlteH26?=
 =?us-ascii?Q?jQNZ9GoenRpTxYwTjL2x0XccK90hP4skigf3qVsCj/TtcMpR8CkEIhcMpKc4?=
 =?us-ascii?Q?+UVBnNWjqCQJ/kHAmsLji+dZNZtOvbKVDOjTqcnIVSElGfTF5eHFvWebmF+g?=
 =?us-ascii?Q?seerTNChNjbebfO9qaH8P4m1LybUmgSZdbpJCp2b+8tjCPyVIu5OyOwFEjpd?=
 =?us-ascii?Q?6DENxb1JT66ENLoYKaIzBD4kRWlo95jh5A81jLRGE6MpZE8QKbE6y+Tf1C5h?=
 =?us-ascii?Q?9UbIuhMTxq+P6v+1j5OK/0RNQfOrFGnqvprCfiE7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6bd2c0-ad3a-4cfa-e986-08dccda2974b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 12:02:18.8268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNn3BCYQRvqMWzdMlmnuEqRpKe/a7r93MdL9204SubZr6amYsf6rawafljs2+v2K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9356

On Thu, Sep 05, 2024 at 08:29:16AM +0000, Tian, Kevin wrote:

> Could you elaborate why the new uAPI is for making vPCI "bind capable"
> instead of doing the actual binding to KVM? 

I don't see why you'd do any of this in KVM, I mean you could, but you
also don't have to and KVM people don't really know about all the VFIO
parts anyhow.

It is like a bunch of our other viommu stuff, KVM has to share some of
the HW and interfaces with the iommu driver. In this case it would be
the secure VM context and the handles to talk to the trusted world

Jason

