Return-Path: <kvm+bounces-25943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B40F96D86F
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B57B4B263D0
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7BB19D091;
	Thu,  5 Sep 2024 12:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sp2r9JfV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B546C19CCF5;
	Thu,  5 Sep 2024 12:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725539022; cv=fail; b=Y+MzwYVnGq8xaP6o2mJ4vDrjcnrdRC4INizUiMTAij8ZbY4R+oqC1g0GWp02tbQJ7PuDqrBvPch2Kz95Do3jhkK7l9NzwTH0B2mL0/3jvOE9yVHYpIgLEUNog3gkWY5dfB/n+UZjlOdxGPr/Dd+rin2flUuwJE1/vCssEgEDgQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725539022; c=relaxed/simple;
	bh=Mu8pjU7MvaMKF43MtyMap2vyWuBjZefMDqNRYPqaTvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E9HMmBxim5OJBl5CK2kRwms7gRYkH7ppCLVf0vnOlTgDpM519Z8nw5spi/0RxXIeJmKarJrcxdPshIiROANeOfdCFeHrdIxabCUD8pOWwN2tE1/pOBetFuc8CjuaiA+otjM46akpXChxFJLCnybZknN5essUoLZGA3fUzjfjT7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sp2r9JfV; arc=fail smtp.client-ip=40.107.93.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LpO6Qvfh0o+l+sGAD4i6oURUrLrZya98wL2BA4tv6wZXSdfxjWKk54Bv2VUKcrCjqGOC0gNBLMpHaPUwdNzeGyYcjqQ3Ihsgzy/1xDeF/PcgNHeziGG22FDeJKVY7B2sVH1c9KxmYM7zmIkWIj+nmuTT8GcrHAnMu51W2LI1SPx4oa/ES4LS+Uph3iXRhaUCKw1bG9UkPt7YJt9miKyg1K7KnWg4EqXcR3V+4p41YHHVdXiCkLvkay09zofBrimzavn1BpRmDITCkOg7KweafI9Rci+PNVVWDA2mMr8tVZCCA60IhOkedK8J5DK7bjGjmQMdNroaZcA1/7BNpJxyww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3mabzs50IhxhGMv37TDupSSCwSo29OhcaU9ketnteA=;
 b=N+pXjd6s575V1JDbKUjnZON+raOR2Qz/kbUmTjnf0eB6OMAOeluA1AJmGgBc0XIMoCeq6Lg29X2Yn6gv35AAoJKaXGGzv1VNGfWnxyytJafbZcmEvcjsN6mv1SbZsvCUWYqGrUQ8pAYiDkhM+w7ZZBkVnSxmh8OFhUJD1/5u5GVlAxvvHmjlU8f/UJ6Arodta+ccLbEX3qzP4etAK3HxOO4cl1QKDyRf8LUf7JNpH6ecpvCC4NReru7wcyA1B2272cevzWXzePQc+rbtk2EvsMEIWY+NFM5usCT2W6mZ3Hbgu6CPxIs/dnABhm2lf4dU/FGfEY48VPSQy0qaurUIxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3mabzs50IhxhGMv37TDupSSCwSo29OhcaU9ketnteA=;
 b=Sp2r9JfVi9ipYMuayuh3osVy41dothzJzcWMmqBvxNNdDRPhwzgUcTV28hHfu8EPtmK99tAZrkrGckJxZoLauVSF6dp6yR/JqnrKlbYsmgtP5iytM0pR0Zjd49SaJYBJWb8aUu/set4Gki2kXAsSY8C3lwn+sThXrXBfclxA9z2LSYxgE8+rlyAdwiwVvdVzurKpFLjHf/IeHNlhUJnS2xMJc+IboNGHRkOg6Q0OSt/s4S7zFhjpTKNKRnQZ9/mHr8XyO2bCmBtHsAkZbvS3nW+icdm2ZMx3PIG8d51Za9nS7xVNGrsQyRrlQs8eS1guIE7+I7hWHxNoRWMkYTKcHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SJ0PR12MB6879.namprd12.prod.outlook.com (2603:10b6:a03:484::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Thu, 5 Sep
 2024 12:23:37 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 12:23:37 +0000
Date: Thu, 5 Sep 2024 09:23:36 -0300
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
Message-ID: <20240905122336.GG1358970@nvidia.com>
References: <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905120041.GB1358970@nvidia.com>
 <BN9PR11MB527612F4EF22B4B564E1DEDA8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527612F4EF22B4B564E1DEDA8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN0PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:408:ea::34) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SJ0PR12MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f76209-1231-4e95-de0b-08dccda5916d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PUSEwd9Bh+gtMfkOf3gvGVpzPvxBRxVu2ZzKT2vqeaTOMlxuHIDlcLwP88Na?=
 =?us-ascii?Q?KKh1VAJuWZWN+96LFkhypqPpXXSjXABcZchyQgXAikz/PU+3lmiEmptL6dJh?=
 =?us-ascii?Q?KLF1mKLqEQRUmRr+ti9BPMkgxJAoG9MSzwLgNYixUlmPaqgN8vEB6ILauSRF?=
 =?us-ascii?Q?eykg/Cvp4PlOGOEhy9DpD06rvlVQsor5OEJXJ/G7OkCgx+GkgZThFsQSc0cb?=
 =?us-ascii?Q?+GyYR3E9nSbj6FTsqHpgrLSkaiM+bTBb527jjB80NW9wksVorw8ZVbT+PPdL?=
 =?us-ascii?Q?M4q1xcTfkClYOfQl1CWdKQwMgVxZINjHk7gJhl3iPvdVQI6bW6RQUZDVkb6M?=
 =?us-ascii?Q?qEglFklh7o+WO3bKqrWzQtGVk0kxg8gf1wrrRGWXUit2ui6uwU9Tcd56kRVP?=
 =?us-ascii?Q?gYhRPW/j2MxGrWOQtY5hzkS3CvWqu4o24AS7ejcdURUuM2pBI0RhAi8XbGBL?=
 =?us-ascii?Q?HkRaW/Cn3iBXg7U2Cp6KYtRsYF/TnPmG9Oe+Gdz1VB02tBV2aMwCrALekWfw?=
 =?us-ascii?Q?L7oNFklAl/fcx8AEj9oCvsdIUQolIPkQAIZKStiz54Hke4JjAaK/jewW1Wgx?=
 =?us-ascii?Q?ZIeumUEyo33SbNhgJrHjndCVMJT3fKZFbsWjU5ec3tZuwr3S+sYyJIFGB46Q?=
 =?us-ascii?Q?p4UEjfw3ojTaumDvpiXQRiIOG5IjFI0boDOlK6Ete1FoLw+kgMPCgQvOwhdG?=
 =?us-ascii?Q?goQ8ODVJqBot6jYFDViPPtVrvLUYjPcMQFk9R6wJzHgchT7Qcvm3Fm/SggPf?=
 =?us-ascii?Q?R4n+LbPwueGXTnqUQQS+JDSCqGcRz6I5c61lz9Hbpu2g0srF7l1Pfkp1NCAn?=
 =?us-ascii?Q?T6A2uh/VCq/0JOTFLPooEAq54nU0xr5ofxnwF17oBOseKeuURIi4ghd2f9Di?=
 =?us-ascii?Q?70t9/bZBRQ4Vr0EJkR5zyYz/z33OxSnp/Wq9gPEQiqGd04JdRBouBNyqMIK2?=
 =?us-ascii?Q?op3LL2bM7GhZlkgcWsVvEg6PU4S/R86M9EozWMOon20xAdEPzo1c2rDeBwJP?=
 =?us-ascii?Q?yTh5g63k+hpJtUgpP7NstNqVdC58vb1dlBRSpKxqdXmIME//WVmE8Q7nsosV?=
 =?us-ascii?Q?Sew3jtKcq+8DakxE+MOHkpMU3MSPs3E09mY/OWoDVFlzef8ImpMcSxSDycdK?=
 =?us-ascii?Q?IxrdjuIoca0Yw/LU0On4sU8lyw94IV79zil3dkHZLAf1MWzaU8/AQjEVQHX8?=
 =?us-ascii?Q?m62JSW7vAo3IOiuRkUy+Co5P55zKSwy2WAg/i1jkSWrmEVPaXZBMUiOdDtis?=
 =?us-ascii?Q?mKbKAnXM5yMriyBP7Wg/T19q3XwXK4ojCa+nXpK2kqD390yYV7Y1DZNzEzDn?=
 =?us-ascii?Q?NHy91lgcdyXwXSmrgyFTA1UrRN8jA/BHj9omtbOie9qaXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KxXot1Af8Gzr7rhbmasOb9WAYDrNlM96qQc1gc8GJz/EfeujEtEucHS+GAqY?=
 =?us-ascii?Q?MiDQTY+mS7n+9q5g54SgKtPNiWK5OE2o33ZF6KUd2zf0t49SPYF/GAlb8aa/?=
 =?us-ascii?Q?ddGb0olYkR8AjqBWMVZTdJ0rof/ypZHHldIliaFzbYlNeYq9WvPbnlmRBcPQ?=
 =?us-ascii?Q?h4162O5YE6jA0XQoZWuwGOJ/UP7UBHdfpxCkISR2houW9tNjppyCj4O+uGMf?=
 =?us-ascii?Q?NatUOq6PFtspjzlmdbUmtYeGb7xNfJra9FJuv2Q2jR81rSKnaB3bS33JE9Zj?=
 =?us-ascii?Q?30FcdDWjItHTfjOApFkkpgvhYyYNhbJvU++XcEIy5JTG4yqN5KAozG1y6tDn?=
 =?us-ascii?Q?xwr12iBlN3CT5K9HBZlaIT4XoDDTHW/GiwghwXhF8rNirO0afw37tXXXV0cR?=
 =?us-ascii?Q?e1i3u0FFoIkECMkz1D38j45gnyNB+R7kyq76TIaJSEkBA0ZCHTGtjCu1gwdc?=
 =?us-ascii?Q?/2aceG4/hPTzg6/eS5NpZFNByswL/bg0b/XR72BKiLfCWBTN5fsRZ/oayCPD?=
 =?us-ascii?Q?QYbrEEZbCZhXHASz+DfwIXM7kzXYfvKOLjJ7sduVNDZ+NFc9MSq0rw6RMgv6?=
 =?us-ascii?Q?P6zNO+8Ml1REkP3zHsPEnF+nOdD0VqofhLV7QWZiweyIqWzK1yvB+Vkfeqgu?=
 =?us-ascii?Q?h7ZAAKVHrzsxHV0UFUfQYap+dnFXE0W7sirAgs3tVglTnPaGMDLgOb00rBWe?=
 =?us-ascii?Q?lXV+7NLeU36wkutdr87z8OmZ6KXODXyKpkUv1DXkSsnEnnA4bdpAX3ksgXhX?=
 =?us-ascii?Q?ul64Bw9yDR/MowBC/myqux9XWKUr4fwAP6+WZ/p3IOoKQlSASytlhbXGmPtk?=
 =?us-ascii?Q?hZsrm9GyTaKf2cPEBQvm5P+yOnQsBVdlDTmCFB5b/tJI+k6UsJpKtoipqINo?=
 =?us-ascii?Q?al6KlUNNwW589xuOhsT8MOyICKsHwaN8iyjFofovIkCCILODL1qH6o7WAXv1?=
 =?us-ascii?Q?IYrcqnXgn+nOnK5gDP7TfPXrrBeNs2g5cdhc0jDp4QQ0DnfC8BSx2l02CQO+?=
 =?us-ascii?Q?g7dPVr1ZywLD6PhJRGypyf7GPJ5dmC+qdpxuUB54v9LEQQF9As7iiA5/mkkB?=
 =?us-ascii?Q?tIRUaBR1lAFYS3bAnBMMIFF2D54J8xD44UcGC9J3hjSVW9fvq2K3hs/Cke+M?=
 =?us-ascii?Q?cjni6q+n06Opb0dpw0FTvBuvskW3Sz8AuMha4Q8Su17iunRyCdJoix+icUgy?=
 =?us-ascii?Q?AVeAlPJePHKgaEG52kBlGNjYXBAuK/vKLYlSh1Y5zMM+mxDsjdJptDkukABr?=
 =?us-ascii?Q?7FR7DCZqAg5FuixC3p9M4HBy45Jl4IRHAqrAK5R5DlE+IGbyOnn9QGYF8ICl?=
 =?us-ascii?Q?lZMmpSCk2LwP24PXxfklsjiuNTDYCnn5pXJybfEMBNxgA9PAgdtPNioo+uqB?=
 =?us-ascii?Q?tfbugrGKswb+PzCw/1XHocGAjs9rWMfz0AMlcMYnwYUL219Qy9BANa/0p8/M?=
 =?us-ascii?Q?MJcWIZz0qSr45jZd8yRecXKEiu4mqzjbom/Lkz4qtZUh/NzIaXvkZRSST4Id?=
 =?us-ascii?Q?uRGCnEvHA5V3HUrD/VlHLZ2a5WFRgLQNvaB9oUeuUMs/81MzxGlS4E872tSR?=
 =?us-ascii?Q?HVOZAUdBSTn8HxEsgiLm378Tq+A/ggO87nU5Qeto?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f76209-1231-4e95-de0b-08dccda5916d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 12:23:37.4198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5v/8TXzRZhOzv1LHRvfzPXfhVu4COSxJ2XvYwMgueXTXFdhhJ1UdA2TH/7s9WeSI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6879

On Thu, Sep 05, 2024 at 12:17:14PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, September 5, 2024 8:01 PM
> > 
> > On Tue, Sep 03, 2024 at 05:59:38PM -0700, Dan Williams wrote:
> > > Jason Gunthorpe wrote:
> > > > It would be a good starting point for other platforms to pick at. Try
> > > > iommufd first (I'm guessing this is correct) and if it doesn't work
> > > > explain why.
> > >
> > > Yes, makes sense. Will take a look at that also to prevent more
> > > disconnects on what this PCI device-security community is actually
> > > building.
> > 
> > We are already adding a VIOMMU object and that is going to be the
> > linkage to the KVM side
> > 
> > So we could have new actions:
> >  - Create a CC VIOMMU with XYZ parameters
> >  - Create a CC vPCI function on the vIOMMU with XYZ parameters
> >  - Query stuff?
> >  - ???
> >  - Destroy a vPCI function
> > 
> 
> I'll look at the vIOMMU series soon. Just double confirm here.
> 
> the so-called vIOMMU object here is the uAPI between iommufd
> and userspace. Not exactly suggesting a vIOMMU visible to guest.
> otherwise this solution will be tied to implementations supporting
> trusted vIOMMU.

Right, the viommu object today just wraps elements of HW that are
connected to the VM in some way. It is sort of a security container.

If the VMM goes on to expose a vIOMMU to the guest or not should be
orthogonal.

I expect people will explicitly request a secure vIOMMU if they intend
to expose the vIOMMU to the CC VM. This can trigger any actions in the
trusted world that are required to support a secure vIOMMU.

For instance any secure vIOMMU will require some way for the guest to
issue secure invalidations, and that will require some level of
trusted world involvement. At the minimum the trusted world has to
attest the validity of the vIOMMU to the guest.

> Then you expect to build CC/vPCI stuff around the vIOMMU
> object given it already connects to KVM?

Yes, it is my thought

We alreay have a binding of devices to the viommu, increasing that to
also include creating vPCI objects in the trusted world is a small
step.

Jason

