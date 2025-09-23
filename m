Return-Path: <kvm+bounces-58557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 540B1B9693D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4963E18A5710
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C772741AB;
	Tue, 23 Sep 2025 15:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LNQAL46S"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010057.outbound.protection.outlook.com [52.101.56.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A41270EBB;
	Tue, 23 Sep 2025 15:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641229; cv=fail; b=rmw6jMmpT7j1MDA866/4CTptdIcxY/V5reMb3HgzHFNTxsWqbUFtIqTGKg1A+0Uki3tvPk8vS3y5BOO3H7rnSeLQwEd9gDTbCxESQfNlG9L2BhqTkqVXmOVHBEwV/T99D0iMEL3TXKG5kLHqNetJ+up4VwU2F44Jgzfo0Lua4ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641229; c=relaxed/simple;
	bh=Zk53K5ZK1qhAgS586wKZVhylksBn8apTHKyilcrFsGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JGoC4AbT5wthBbpMJ1qpnCYCs6Cns08zRBcvGu6RFhOLEWdAWshqXHj/mAWoYC/t6XuFZ5NTOiHqPuHbk7sl6fX1/Zd4UP9iAwU1LfSXbmoS0p5vuPW+ho9UZb65u540y5uQHraaX9LwOXgO/aXyjvNZt/B9PTWEgtRuGcvzkkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LNQAL46S; arc=fail smtp.client-ip=52.101.56.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VLa//Q1JEd4OtJPP364lsUnaEnr0xVVRQOn72E41ZhdDtkO3RlSIq8ZcycgDCrueYw0+q6LGBJz/EAvzMcF9E6mc10cd4sL0FHf9rJ5BuLphUpgjOP2b46NSXIzRDtoUqM2EhSsmYgPWmYfrEIIiYEf8RC450mFr0zmEI2stPJGc6iNb1syY7TNY2H0SlfKxWpT4sTQf4Io2kArCmkU4AP00z90Ogs78hbbpH6a1/68J2KMil0SKKdqzi/P8AapBKa7Ka+Ig1Sdht4c1jWLDxoGfoPq9iFpN9AkksCmzpks6PQTLENu4/F5IvjYH3zM8IYlUGpyOsF54TRxLhkLcLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zk53K5ZK1qhAgS586wKZVhylksBn8apTHKyilcrFsGQ=;
 b=sR3W+yufXtzKQVTUECInn+dEsS9BkiPHC9ZuW177qWrnxpn/pdBZEep35tKCQmhXyeR6R3/Jx1Ki/QukW3b9/NzKORdQ4YCFIYUre/Ilf4W9CYJ6VwH4Nd5O9k4AzTD+55r0cnl3LsyhZ+boQUq9pyPmb+gas1xQDKtRoEiptUpuBnwMmksBoUTQIcGnzL4G1vfq5EQ7Ry9eKiOLex1iluoJwI3CSTS3jNM8Yqm1altqGud5eZ2FTxxD6F03pt969xPVWLe8XXf0bVPNIGnZ3w0H1+c8ZSJLzfLXXLIyFSw+RMo3jGQRfVzJ42TZQdhyrF5NnWfJkr4MoT60WtyiyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zk53K5ZK1qhAgS586wKZVhylksBn8apTHKyilcrFsGQ=;
 b=LNQAL46SELDTIbG4slx3JOz+eTYi5T+ys9uki4qaBXoEGo4tJHbzV5bouUFnxzOHNzR05vQRpNeEYhss3RE4djjKU1XcJzqw+Vxzqeiqe91yadhcM95W1oVi1GFRxXagO1j7tM57EvR3zf4OQUhQnbhzUE0tXbRLncJqJ0DYowcOnIT1d1wc/eAw2K71WtgU1HOWaoTKWiJ2NCJw+GRtnamTTKAvw8zf/4VpW/hViCq2RUymuBNboMgaYTbPE4ygsPqvxlZ3v7qJTOHKeS2FrNuvkUp2LMd2thE7nh7zP1RqaperwYnaSarudu/nDX71Q1mRe47s/T5+XF0QHIEwag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CH2PR12MB4103.namprd12.prod.outlook.com (2603:10b6:610:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 15:27:05 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 15:27:04 +0000
Date: Tue, 23 Sep 2025 12:27:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
	atish.patra@linux.dev, alex.williamson@redhat.com,
	paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250923152702.GB2608121@nvidia.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
 <20250922235651.GG1391379@nvidia.com>
 <87ecrx4guz.ffs@tglx>
 <20250923140646.GM1391379@nvidia.com>
 <20250923-b85e3309c54eaff1cdfddcf9@orel>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923-b85e3309c54eaff1cdfddcf9@orel>
X-ClientProxiedBy: SA1P222CA0141.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::8) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CH2PR12MB4103:EE_
X-MS-Office365-Filtering-Correlation-Id: b2b7cbcb-cd61-4e2e-6a4b-08ddfab5a673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qjmZFF6sWSW3R2sTENZubG0r/N3OgdWvP5sT3Hz3NqoEqXbn6aPBj/cex8Mm?=
 =?us-ascii?Q?9EUnpqVysbpmkCEKswtaQCrJxVEorZeWoYC0J/y4cg215b1TSDKOL7+Wbdf0?=
 =?us-ascii?Q?yqv8uq5Xhv0n72BpFH6A6JAMqymZCKSvosGOVKklBdUeO+AqXgwSBt0hFcCO?=
 =?us-ascii?Q?YIFwW5JL0YOh6SGbwk0BhJTFrkgpSUKD2o2aI8qQbRzDCCH0xTgY/brsYaQo?=
 =?us-ascii?Q?svIt570aWjx+Zw5wijOugikThquqNtKGNe/ottSLA7I8GYv2DUfZs/pNVVF1?=
 =?us-ascii?Q?BvOoXwkFAZX+F750/ZMNDO0mnzprzMPcPAnLc6LpRl3tdI9c7Qs9uu+w/Z0w?=
 =?us-ascii?Q?vXSSV0MmlRqEwsUro8Xamf8YeEMArs+ddKzKTFJm0Z2ndMqZtDvESwizILi5?=
 =?us-ascii?Q?Aw5xuZ/UloEuKx9EJ++hbkvCNJBVYlrFaj7B207oBu1oqsEFFyKzxha2lTrX?=
 =?us-ascii?Q?Bhwoq+u1NcNIX6Pojvia9r2i5Wpppz1CClWDLYXevPHP7Au78IxraIgilms6?=
 =?us-ascii?Q?zEwCVfdGeYUsS/LQSiuCbWdd7DxSX3pCB6weheN8CDkL4jG6C9JyHjyQhk7H?=
 =?us-ascii?Q?7skaashEwQZojycqExqbJcxaC2VmLHMOcMAc+OrV8rr/MUYu93oOMQhyChK4?=
 =?us-ascii?Q?JzTQuTIa6CG+J74tw35S69YV4QT6cmWfcw2jO8VEOHkA03cX4cPSDVeAZ4fm?=
 =?us-ascii?Q?51aOiUt3kZMJaSTD5pjPI3Eoh+Q01M8dkMhRVzsJ+dFV97xB6/9uz2bEN9qr?=
 =?us-ascii?Q?Ct8k3yBrdELivXPvfn0wtZOHMhK2ttCEWOXogMtG95NDg1w36FOfQ/PltFXH?=
 =?us-ascii?Q?94x6mPMJiA9wQp32ryNCOuiwWQbVPSx0+b3/IGmbAkj79BRV7oS1z3+XSVKO?=
 =?us-ascii?Q?n0oHrnriwaMJ/o75xedswOrd6ZrlJ2dzHASVHqBFJmTdhkrgmPRiNCMmgHKy?=
 =?us-ascii?Q?8PmGBTJh1CKX2nh8K9QlVuQvG78D8jhewJJiqSD3gVViOUtvmoWKk8bokavt?=
 =?us-ascii?Q?Xd8ZKl4KHn6KAWUn9V8FrAp7P+vX0ixnhGCeKvzGl2e6FodV6wr3UmenKXcY?=
 =?us-ascii?Q?68nYLI4fKqA8e6BqN0PXMXjlPDBDiia06EhFr2ef5DzCmNeyhzukpLPEof7z?=
 =?us-ascii?Q?fctyzLpjqUtc/6Qq9X6uBP9M3FO0HdNwM5/HSyhgNC/QQJ5h4JULBT9SDdg/?=
 =?us-ascii?Q?F5FG9cPTnlf0eYc93GMr9WuIZ659b5EnhVB02xjAQu7/ipRhthYmg7/5jCSO?=
 =?us-ascii?Q?DZqcfKyODVkunF/aiD2hjQmOZ/ATO6ABXtp/MfPsj5i3lzRoDZF7Bt9q6Gl+?=
 =?us-ascii?Q?vL1VQOAh3zrbVPhLVhd7VxpKAe0UgpX6arwB8xvz6NOV4oOjOUgNHhF06Cnm?=
 =?us-ascii?Q?zzM9McjbAGyuUWVh0T9rYdtQrfUJag9PJhOgNO1IJhNghW/UH7cqguxFj1W0?=
 =?us-ascii?Q?MWMnSydbixU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5emuhQ5OoLAXpXP/wVImi5Tp2gOCSgStPjOTgx7dEWz4xAQ12868f3aSYaJh?=
 =?us-ascii?Q?t1zFLV7sRawHe72tEKKn0KcJJWyta/rf9iWJVnk21tOk7cff6m6g55XoxTEn?=
 =?us-ascii?Q?PmuSI90u/8XShXrVaxoIkDIzwEsThThAl9LsXRkp8W60iEPR807Sga10tOeJ?=
 =?us-ascii?Q?Pk2SpIy66Aps5ZevHBr7ZGoP2TE6/7vAMhu57oK2eUOMdMhlPvnGJcTnEfAX?=
 =?us-ascii?Q?MyzO+SDnq5WE5TETog9i9oTIdkz+WNGuueM9UAZ0HQfOVzW6qiO4lpMNticF?=
 =?us-ascii?Q?NQ7quQ8Bbcx+p8/8VHmSKFUR6pV2DiJnlgjOzUWUmyHjF/PuIDAJcfuiSaIj?=
 =?us-ascii?Q?bIbdhuKlvGTSAkaUGMEVznOE+cN+xTx19O+81WqO/ztARfSGOdyXWuCOAyAb?=
 =?us-ascii?Q?IC6+S5qerZqKRgIlDB7R7WzTiM34cuYdju0Y5sOO7/mH4zlQgeViuS6Uoq0x?=
 =?us-ascii?Q?L9iiDG0kqC4VrJNtCfBuC7YV5PZxYIWHm0eEbiB9a4nwX+TJODZ7GY90Cias?=
 =?us-ascii?Q?xTenDZKrhXASjbtZ7bW188xQ7a0FYFeJA51ceZh6O+otmW42vQowM9xNDrEb?=
 =?us-ascii?Q?PY1j4WeOudfkyL4oQgr7KcBovMkSKf3uUOxYLSv0hY+JvWOr67OEBUq2X2kk?=
 =?us-ascii?Q?kGu1KpBr5yuPnfZTIzrZfSOnRAMNg5akTxqya8Of6WEOrpVf/Q8gPiUrN0vj?=
 =?us-ascii?Q?ChkuFrTdetZ84UvYYW0K2sMu4MacwBDHi2ixeh/uFRFBZdNa8q2/ufYXX+kU?=
 =?us-ascii?Q?LuYRksNrNgRYi6WjPdFTaQ5k+DgIDbnUhSeZSfCMMVPh34koi4bB5CBfrL+y?=
 =?us-ascii?Q?wS6c+Z9pzyl5v+h1KS0daXKhfC3AOx/CHvC+JACVWXojN/2pKCjz2tCq8y86?=
 =?us-ascii?Q?pmOdVtgAOIIajgIpwDkbzVFx/XU+Xh+nrMXb4II2MegSEs4lQuqQ41cZkJkB?=
 =?us-ascii?Q?9ndgaozHgruqJ3BykUezygS9OnY3LxGJxJFA+LyOsZrnt/eKzl6FNDVvddiF?=
 =?us-ascii?Q?kTa8e/WKEuwLQGOoakjwDP12bG9C820zUIKUkq66VwF5zrTLy9dZ8f16HvxA?=
 =?us-ascii?Q?JlSFfaSlCtDysVJDgIjqN4mSeIqCnnFClC1/aFfk7gxU8awtrbL+h8fYCjak?=
 =?us-ascii?Q?R/M0gBUYKMfIx/hLYLLeQvJj7Xv8YHTEaLfNagkHhxq6CqT/UAWIRy3udBIO?=
 =?us-ascii?Q?2qZ3N/KUIhJHtDKm581VwllbhEuPDgetGE6Zxi8CMaifOTzvDxD2+u6evtn4?=
 =?us-ascii?Q?eW8X3kLOWQ8m1qb4A7eyhqbmiMy3TWYjNf8CqcyazzPiimZPdbU9m6hSiB4r?=
 =?us-ascii?Q?bTmjge4OWZd1K3y69bO/Sb96yAkSAzzZJLXp/paRh4oyEF4vOO89d6xFCQ4A?=
 =?us-ascii?Q?CZIGvB871yolwGf1SCM4Gx0cEQVQZjCyZuvH7oROzIswGAScfFSM8S4UeCdk?=
 =?us-ascii?Q?QGHrtaJvFAjH7wgq0azJSrRtfRn9XYvWc32oR572ZTciSqRq/43gnWCGZXWc?=
 =?us-ascii?Q?gvDOesaN8FhwxAchnfsZ+JrOdjGfA6DZGB5GQre0m0CD/0/8KEiUbbMK1K89?=
 =?us-ascii?Q?d1vsBh4QmUdlqCZbY0RbZMjAQNibAQb+78DRD9gd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b7cbcb-cd61-4e2e-6a4b-08ddfab5a673
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 15:27:04.7424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6RbYHx0PvLQGZdPoASSFC9ii7h7Bb52YQJAgS1evupNAHKZaEaId39lbC5+EYNY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4103

On Tue, Sep 23, 2025 at 10:12:42AM -0500, Andrew Jones wrote:
> be able to reach be reachable by managing the IOMMU MSI table. This gives
> us some level of isolation, but there is still the possibility a device
> may raise an interrupt it should not be able to when its irqs are affined
> to the same CPU as another device's

Yes, exactly, this is the problem with basic VFIO support as there is
no general idea of a virtualization context..

> and the malicious/broken device uses the wrong MSI data.

And to be clear it is not a malicious/broken device at issue here. In
PCI MSI is simple a DMA to a magic address. *ANY* device can be
commanded by system software to generate *ANY* address/data on PCIe.

So any VFIO user can effectively generate any MSI it wants. It isn't a
matter of device brokeness.

> near isolated enough. However, for the virt case, Addr is set to guest
> interrupt files (something like virtual IMSICs) which means there will be
> no other host device or other guest device irqs sharing those Addrs.
> Interrupts for devices assigned to guests are truly isolated (not within
> the guest, but we need nested support to fully isolate within the guest
> anyway).

At least this is something, and I do think this is enough security to
be a useful solution. However, Linux has no existing support for the
idea of a VFIO device that only has access to "guest" interrupt HW.

Presumably this is direct injection only now?

I'm not even sure I could give you a sketch what that would look like,
it involves co-operation between so many orthogonal layers it is hard
to imagine :\

kvm provides the virt context, iommufd controls the MSI aperture, irq
remapping controls the remap table, vfio sets interrupts..

VFIO needs to say 'irq layer only establish an interrupt on this KVM'
as some enforced mode ?

Jason

