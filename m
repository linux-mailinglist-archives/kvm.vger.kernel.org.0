Return-Path: <kvm+bounces-31695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1A59C66BF
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 02:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBBDEB26D01
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A745729CE6;
	Wed, 13 Nov 2024 01:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r1F3DRk6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45952BA34;
	Wed, 13 Nov 2024 01:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461677; cv=fail; b=lK/0JMO+r/9AWmXDsPTyQYpG99P45/2BhF/mCTA3D8bbDSzRnuu2rhU2uV768qaCii0nbvV3KoWMuHfFyOrAByI+CwpGhXAHrIlp4fN1aACRxEPINk/bbLb7X6Ua91iSkOViAomsJYBhwgKQmoUoFpi25P5nDp6hJG5MvexVCYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461677; c=relaxed/simple;
	bh=lDJKW2ic1Oqb1E4JhA0NRA/WYpf0CknrL5thrnsVL9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OIOrDaEqgbGpXOPxqzN3c9ifT15DCYA5ePpW3nQVNFov/fplZIVgSxjAw0CGovK5VY0+rGXmucGaIWdb+ImYPOw+ZcTRSAGJWn1bPsy8Xypkai2eavOdzUMCp95CW6vvVfvpDLfdADwJdrVrxjZ5g1iHTc0z8Y75nFkupZqmgyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r1F3DRk6; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9r1HrA2qf4FuQcHym7U2gIsJ5fSzf6vltmb2lcel9PH9+ZQgK2+tDdrqUQUJ9sUIqFH8/G3rs/u+wbxyvDua0KuR84JG6n9U/HOreJhL5Z8XYbyuq2sj4e8rrfT6hXbJTb1vaUNqInaF/zEBAtZ5sIpSnw7J17BmD3nQAwa7uoHeiWftY4U5l9leGi7j8QN0jL+6wdFYas9usqMqGxHkYsigUFkF2hOBG3ZDWRk15eSv/VqM7w+uoqP+Kqryo73Z6EYXBMHkzdYHU5ngV5w5ZbBIP5TQ3BNuh+xry2eZKEeMlFxpgALb0nx0isDLSfO1Ix7OTRnvHos3kKIiP631Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/yQ3kEU22ViCw5b2PB9qMCbNDKsZ4Eaj6i6U1J36iU=;
 b=F45HRwRSba3cOS+Y8xcCDkNGGNAAkTGxDx71t05Q9SXyoK7YnSCzNvl196OL0KR/5dZeBCwyuFHyv+x+hYCin34/G/47ceoYuOTqnyFBmALFWwv/y3bIATl/s9K0//2BnHluGJBVayKDhuaABCDgSn0Gg6KCP0XU4k2WiN/vd85bgpYfyk8ADY9bfRZbMuyJqYoO6xl4L+Oq8hIydo8G0Jatc+atH6YGninTOBpGfP7mYq53+pxCoPHoUIGSFYFMCDSJMb57uUHDlVNMskxzrbFVcjKaMVhbCEUf1FOpOeBoLrGeUPgYvFEu1U0+xjxHkX3TJsGAOXCn61+1EiSM+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/yQ3kEU22ViCw5b2PB9qMCbNDKsZ4Eaj6i6U1J36iU=;
 b=r1F3DRk6hbYrrIdvCxrJOd6J5Mm7HXjSRgaKXrwkffQhKPDBrYC0/ztH4o+Xd3xPX0QyhyUf9TkeL2QISnR5r8uToCmZkExkgRWGFd08eBacncg103J5gell+yfCQ4srvc4qpRvTY6qPU+RxZhpMSluFhtteeBo847N+Tb/Sfpvn9JL5Gnd4RhRFct8IFTs5kKoDOiDRef5mAmkMmCJuJNEndRAa96dT/ZvR/qvg2tITtXQPsXVbryu2+SBX/ezgrepczSRcsf1Tu7TIQomVqLerWGFo54zoIw14zT84udGNwQrfwtzfSBanKlVaefL1SdSOq4wFTLKhpJsVRoYq8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6630.namprd12.prod.outlook.com (2603:10b6:8:d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 01:34:32 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 01:34:31 +0000
Date: Tue, 12 Nov 2024 21:34:30 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>, tglx@linutronix.de,
	alex.williamson@redhat.com
Cc: Robin Murphy <robin.murphy@arm.com>, maz@kernel.org,
	bhelgaas@google.com, leonro@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, dlemoal@kernel.org,
	kevin.tian@intel.com, smostafa@google.com,
	andriy.shevchenko@linux.intel.com, reinette.chatre@intel.com,
	eric.auger@redhat.com, ddutile@redhat.com, yebin10@huawei.com,
	brauner@kernel.org, apatel@ventanamicro.com,
	shivamurthy.shastri@linutronix.de, anna-maria@linutronix.de,
	nipun.gupta@amd.com, marek.vasut+renesas@mailbox.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address
 for each MSI vector
Message-ID: <20241113013430.GC35230@nvidia.com>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
 <ZzPOsrbkmztWZ4U/@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzPOsrbkmztWZ4U/@Asurada-Nvidia>
X-ClientProxiedBy: BN9PR03CA0720.namprd03.prod.outlook.com
 (2603:10b6:408:ef::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6630:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ce954a3-fe9f-494d-88e2-08dd0383524e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qw5MZB5kJYIdkZ6RgFKGGKeoWa/12tbNwVOUJ+7GCCmIIcAtwdpaswoddyXY?=
 =?us-ascii?Q?H+5nZ/6Hr8yathOuxwlDJqTIBUlQJu5wZ7J9ZVUAf/DD7gny0tluC80fiqiE?=
 =?us-ascii?Q?8eotCiMeKG5Qy3ZlCZlIV6puHE8CRH+JP90aGifWvSbrvRYRTwBCBGSaFTOY?=
 =?us-ascii?Q?t6PMvjVJQbWCtizgVDBHuVb8T2tnNs4vHIKzFR27Bkr+gizE3OFP7RhLN+9L?=
 =?us-ascii?Q?yudyqJ7LV8BiPT87jEqelCcWFpLWcrcAlxzdyVz6JuW3VYmt0VougZNV3jD3?=
 =?us-ascii?Q?RL4QJIkAtv10pevOjuqrw2mnMpLLRNo/wsNdWT4SIwDxdKnY9Gc3OBEVVwy8?=
 =?us-ascii?Q?a6V189A9X9WrDN7fSZz6RPun2GXD5AWorBF7Mf5lQoddhoNy866qlqdZwtoZ?=
 =?us-ascii?Q?B9Plodgq8BN6tjUaUdAis8EOg98i5tlHyyGF58c0Z34FUz6USQHUHPkPweT4?=
 =?us-ascii?Q?ITKx8mx6JMOMDZvMQDjMvW2GhWg1mx+GxE68AaG20OkIdSgiUXgYea1jByCn?=
 =?us-ascii?Q?AMtKQurEGpYIswBkZBR88WAU4ZEycfZgOC7NyH7XxkRNWeNBV/lpvVKKvkMo?=
 =?us-ascii?Q?DUTNuIeAxWCuC8Qwfer1DaB0yfj/jGZym+evYurP5TCeaBAV9VHwhYUoc4o3?=
 =?us-ascii?Q?Xd86oApmKPiO1mBWnoGezXRcW6Kf8GUV0HoSBE8Lt0dVRNG2z1QmzIwHsVsm?=
 =?us-ascii?Q?AOu6N4nU2C8oj/Z4nP1hkf+XaKsI6H3Pys1bpmS3B5Ij14ncCHov4NF95h12?=
 =?us-ascii?Q?1VH/WU7FDTP1oZ4zAJ2l7imcHBOXfD72UHdaCndb+f3LxTfixsOPiG5OTahx?=
 =?us-ascii?Q?96a4Btk0N6yqoWDJaVSxCLb22VyHI5oc/WP1FSGepbrrhjbvGM8jxFD2qvvb?=
 =?us-ascii?Q?s1sOjvDZX2VMwtbtNTHWpen2SrEYreZiaWYqyZOYJIdeDJlR6LOeLTpw6JpB?=
 =?us-ascii?Q?P9UDiY7nx2UJqSgQqM9geYzUxJkkxP82Ld8cY9OFuIQq5o648ntjWrKCh1A2?=
 =?us-ascii?Q?6TKPaUvhGS5wuo2IVzwwGhiWIRP/618VEZIVhTm6Mi5edQ0o7Tz2qNdKc4nl?=
 =?us-ascii?Q?w4w4Kvh9r8HgQGXVaNXOfuFOiWRu4z8C6xY4joDTudJhfkVberUtDjLwngR1?=
 =?us-ascii?Q?O5IdGVvKTh0wLkzl1qEFgs/eXEsteevaZGJ88hZSYC52w3s+gq/0jkkIjz6Z?=
 =?us-ascii?Q?eYj0B+AUmCvoOHeO2SSXj3MSm8SUIG48mgYyctxMXc711onObTevJPnHeaae?=
 =?us-ascii?Q?HZSuz2V5o5oieuXkHZubPNotC+gsCc73ecAY3ZK6Ht9ra3TUAGZxTeMTCdJQ?=
 =?us-ascii?Q?o/PV2JtWsrr9Hvpp4eODhGHt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YkEbN4iLbGm+Q2jwue5fGezbhbFFfr7hrXIzftRqqObdp6fueXKJMswIN99q?=
 =?us-ascii?Q?GJ2R9dqKaTnbb5rNUStiu75OdRsJ9CJAAvW2IK0zVaE8MhbqA8Gx/roQYhun?=
 =?us-ascii?Q?jjo3g1OjxnG3pOTFlWRrzkXFj8PQfrDRq3fARnG9lJAwK0WlwpqgKXl/gugz?=
 =?us-ascii?Q?V4S1uKOy0kLEI3lpkCI5eD5Cl1aOkCWyMESapJ5EihlAs72qjppvNIw9P5oz?=
 =?us-ascii?Q?srSqWY0ei8kfeT4yxcesvybABx0Ys8N2WgrHeST3Aa0VpSiC8yMjZZWKDtv/?=
 =?us-ascii?Q?KsnDRmEra84XcTnsfw09Ug3ccPuuVCu8GPrRGBIup7+EzgkNH03VGbyuEa+a?=
 =?us-ascii?Q?Hs+vKAqgavTsWVNxyD1hTOnJpxG5hshfKJqvmwvHX9MXapyJ3t4Twu3BCQJX?=
 =?us-ascii?Q?nhEOVZS10FvfSI3FQ74PcKmEfLlwdMLgtN9f8zrPo3TOkrcS6OUWX3sYOR/F?=
 =?us-ascii?Q?AFWp1yGk7fBx/5XQv2ANVSKbdESdhZ55AyE+YVN/YWFny4uolLPBq8q4ukH4?=
 =?us-ascii?Q?aHVMk+auw39R3vFkbABt4NwblC1O4sd/h8Th7j5q+uHQl3sdEt85kRv7k61C?=
 =?us-ascii?Q?rO2wC4mfRNmHe3RJ3SAh0H7zArWGgOuvnSmrF5+JvWtzSauPKF9a+hnQeQCV?=
 =?us-ascii?Q?7zkSimDHeDirke0dLnQqjnGo0K1AVAusLrtYMvtW7AJosWtt12cibB1Kbzdl?=
 =?us-ascii?Q?GsgiFNZ8oy0Yp3n8gNHv0lrLRRGwuCUkk5eV8DFB1g29ONpktzBBA9U+dq4Q?=
 =?us-ascii?Q?sAiphdQwPA5m2V/lUDmfLeNb+Ys0jMdLqO8pKBsXNNJanpR7sxqBeweNm2F+?=
 =?us-ascii?Q?MKv5pORmCQSgPNuCKcob/SksXeeSWF/UAJrQH6AVJYT/Qa6YVbZyQxrD9jp9?=
 =?us-ascii?Q?9/K7RBap+wn0VK8e79Tsb00HJW+d+NR4jD1dhYHA7Cd1Kazb5yEOINvbrh4o?=
 =?us-ascii?Q?7L9yPlC9wr4PlJIdTOxkPVt1npMP2//prfNR/+jX7A5PcqleiZ++8vRIRczu?=
 =?us-ascii?Q?yhxXGKlnrVZrTvE7jFkTAT0pP/h93Mshga23eXvqWIwINPNFSyw9IoiEA7pS?=
 =?us-ascii?Q?++wNUYhGKzsL9uRQTc3Tnd6Y4HB7d0NZXcNmhUqhJWea49RwJJECQLgjzuRG?=
 =?us-ascii?Q?hAPbiez5ej9B9wThL276+i2DAonBZKTcrKYyJpZC1rJMIgVW+o6nxD9G2MZu?=
 =?us-ascii?Q?JV4vMbhSuMjA9GxI7kJl1olyXqtcRc6HrZOrnThU5Q4rT+svlSUaM96+Hyjv?=
 =?us-ascii?Q?vq9nfTOsEYF1IDGIf4iRwdD+B4HpQawkaXHm17bbd87IwpMQUPOUA4PDbOfr?=
 =?us-ascii?Q?Eb0cPcHXQma/ni1W/f87C3T2+bGoBPDpmZCTDBuW3yoYfR2/e83f4Cvug6ej?=
 =?us-ascii?Q?xdw3pAP3CpxsB71pvdNsIc9Sf+JOddodzed+yswGBUZ/jPsLo+xjfRN9vMZa?=
 =?us-ascii?Q?mrkBK1UevgsygwoeC17DLxCa0UVFJJxQ8xLY2K0FtwHsWTlwCM79m1J0ekOb?=
 =?us-ascii?Q?PMq8jOl0RcSYuMOhwmuk6WwEDN3Zhw72qX2UyVmTBB7RSwmRMsE5VsyoZT+U?=
 =?us-ascii?Q?N5q9QBxFQYBUyNJHm0E78ma5w0ykmps2BCj9v+tl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce954a3-fe9f-494d-88e2-08dd0383524e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 01:34:31.5540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGhdQkH+79Cgk18dslTOyiNzXVd9Reeopwf43Qz/FsIcYfrecBx41yYzaURswihk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6630

On Tue, Nov 12, 2024 at 01:54:58PM -0800, Nicolin Chen wrote:
> On Mon, Nov 11, 2024 at 01:09:20PM +0000, Robin Murphy wrote:
> > On 2024-11-09 5:48 am, Nicolin Chen wrote:
> > > To solve this problem the VMM should capture the MSI IOVA allocated by the
> > > guest kernel and relay it to the GIC driver in the host kernel, to program
> > > the correct MSI IOVA. And this requires a new ioctl via VFIO.
> > 
> > Once VFIO has that information from userspace, though, do we really need
> > the whole complicated dance to push it right down into the irqchip layer
> > just so it can be passed back up again? AFAICS
> > vfio_msi_set_vector_signal() via VFIO_DEVICE_SET_IRQS already explicitly
> > rewrites MSI-X vectors, so it seems like it should be pretty
> > straightforward to override the message address in general at that
> > level, without the lower layers having to be aware at all, no?
> 
> Didn't see that clearly!! It works with a simple following override:
> --------------------------------------------------------------------
> @@ -497,6 +497,10 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>                 struct msi_msg msg;
> 
>                 get_cached_msi_msg(irq, &msg);
> +               if (vdev->msi_iovas) {
> +                       msg.address_lo = lower_32_bits(vdev->msi_iovas[vector]);
> +                       msg.address_hi = upper_32_bits(vdev->msi_iovas[vector]);
> +               }
>                 pci_write_msi_msg(irq, &msg);
>         }
>  
> --------------------------------------------------------------------
> 
> With that, I think we only need one VFIO change for this part :)

Wow, is that really OK from a layering perspective? The comment is
pretty clear on the intention that this is to resync the irq layer
view of the device with the physical HW.

Editing the msi_msg while doing that resync smells bad.

Also, this is only doing MSI-X, we should include normal MSI as
well. (it probably should have a resync too?)

I'd want Thomas/Marc/Alex to agree.. (please read the cover letter for
context)

I think there are many options here we just need to get a clearer
understanding what best fits the architecture of the interrupt
subsystem.

Jason

