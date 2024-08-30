Return-Path: <kvm+bounces-25518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA82B9661D8
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93C0B282DEB
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C10199FC1;
	Fri, 30 Aug 2024 12:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q3dM8PKM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDD819882E;
	Fri, 30 Aug 2024 12:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725021370; cv=fail; b=bOYid4+D5Kp6EoKC6T37ynLABLWiEUNHQiNRcehKAg9hcT3UhZvvHx6+RmWOxJU6ma/KCj9KiTSh3KfpEU+ynlfs69hhtWA5dsJYXamHsSKvPF7Kmbij4sBl3m+YEY8dHozeH5yrgPHcX0h83Rz/y++DhXbzmlI61wGuMnECNGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725021370; c=relaxed/simple;
	bh=poOjockwR8mNc+P/6iDo8rV8fSEiNcSqkykTCRtQlYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kYK0d5rsTd8qYgr0XwRQf6xvKIb5PoAu4WLgOrLNrTy1oXGVnChfMBj7nSO+MppJCViIuUg/AJBYaGXJGUF4qTRxn2R8qVYWragILYw2RJgC6zu44i3NwIQYTYbivY0/mOKnuw+BHUkKmGh2J4kbUfbijyNzV8WiU+ckjFQbeEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q3dM8PKM; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=McC9GzmAlCjU8BtppySxf1kx6SMhTVIHLDsrGXwQ4JRH5cXSjAft5Sgtz8O7WwMcPEfNgYLfia7A0vWTP5u6fPZEC7f5MtagG2U0OvDbgmWbdG4AJWLA7sQCN3+tYLtBD41S0LEg01OqPT0PHlhpk5eDvpsPcU3T1xxoO8ig0pYBu9FLNU/qoUI6ScnhZolnztVLq2ifvNl1MCHzose9d49omtNLBMiHvj+rlOkX5e/qaoEDYDNDcI7PUa8jDCW3G3kHv06yo5f/+GJLu24O8323m4GrZfDglDrjw4Tst+BgFI2liqTKdxr0pX0hp1Nq9Tep6D7d5n9CkmOkuTg/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16igvCXMHKSaLEkL2TqG3aHvQQEHgZ0Nd2RvHMkUgLI=;
 b=cYxnBVtoOTNPq5M5xknVD0z+Jo0haCbZh4/e/PA+15sp5FP/JXNYm1Fio2P5XTJUPGcMjIO3erRKJ+si7XyX1d7Dolyxa3gBZEA1+jrhXIUmykJ41eruvhC32ilxXYPo1nWlUtTE4fHSFMl94bswwuUKW4VI+qbvkrMhrgAGQSU8Pp7DWpNFMsBM6NiouXDVRgCjJbT/b5UUsW1w8qrCoYiDKonaBNpntfIzJK39cMf3LG/bQCcj4xfnaZkQieyisFbH46E3Oc2U5jD/exOOgLXl76q11pvlRPb2zmaPqr1C9KPG7pkaJaGqflduv+J/jwZire4h/k61PTR3xPlAiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16igvCXMHKSaLEkL2TqG3aHvQQEHgZ0Nd2RvHMkUgLI=;
 b=q3dM8PKM0NdvKyVs/tbKII8VNTDrPI1xRjIF4crE+KAPvDAjG9ZhXIrW3E/A/iR7qJUN2HJGDQ2FKPZrBnLxza400w4xtY5wl7PDXRR0Ea1F7oTxsKGuHOUBlaUfjfKQmSvT7HIdkCE9GAi3AfMqZ2cpJBHnbMQ72SZLfzS0YGNI177mpz22eBDkUIgYZuhnrTl0cOo0sH4KUuDFqq2ssczsIUqycwEk9ZCHf9Wh5FKA0JGaGoewvyvioGYLYuHGH0YwWAWEe0hW8xWPFvYYh1Zl+5famObjyyg3UR6MlULVdfuxcnbriHqkCgyWlTHSGPjziwAofohCyeg+F97+Bw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH7PR12MB7260.namprd12.prod.outlook.com (2603:10b6:510:208::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 12:35:42 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 12:35:42 +0000
Date: Fri, 30 Aug 2024 09:35:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
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
Message-ID: <20240830123541.GN3773488@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <c4156489-f26b-498c-941d-e077ce777ff4@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4156489-f26b-498c-941d-e077ce777ff4@amd.com>
X-ClientProxiedBy: MN2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::11) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH7PR12MB7260:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b72bbc5-ce5f-4c9f-4a2a-08dcc8f04307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JGc5P6jaGSknVh+P8VnrN4ZiYjMgcYdLtJgQLX2AAs5FRiQUx89WFUT3a5/T?=
 =?us-ascii?Q?8/q0E4WDQxVAZHJcfpK/9IBl7yAunxGqMe/Dzl34iB5IrdLMXgLeK7wzciWp?=
 =?us-ascii?Q?qwRQqTp0dVLViaSQwNCJ16n1KzJLENj7dcqVbym//hdvYnkNg9eDvWkD8g/n?=
 =?us-ascii?Q?TcDo8VnOJQ3vYdr3OiPdUHlLe02lgc07Mfl5z3dv12curvAX6CnuRMnxvybk?=
 =?us-ascii?Q?eaOHnezK+g3yjMpOHpHUZscytsgIajWvzjmyMIs3o9Ta989G7E0iKJOfdT62?=
 =?us-ascii?Q?g+1kySLPnhVYj/gcD4hmOK6GgravGPLvotUAzDYYh7VoaCcbGc2rvRv4ssl/?=
 =?us-ascii?Q?Ccg4z8esGqMMoI0y309DeRHBDeYctm41LD6SxlfdwQE1Vvsd/EiNdstbXu9f?=
 =?us-ascii?Q?IM/0WiP31HopvDzfVGPHSH/pboEijjJ66WcYALI4P6DoJRuuUZyPel7wS0MK?=
 =?us-ascii?Q?EfAQ6TDR3ZXq4/uFEIneG7st3FGVJwQrPsdZMJDpqV16jwoGxq4jWhHqksyE?=
 =?us-ascii?Q?RWS3/8J7fKbGRdzqOVcaFH3atHyjzvEQS+xGxEffde36KYED0ATNHgW7jYaR?=
 =?us-ascii?Q?Yp31fk8UHe9HoVOm413p+OXCBrOiAf6noemYpHTMjBkIitL1yAXBCfNq/N6J?=
 =?us-ascii?Q?FrY9h4hTpb0mC/ae/Yz+AZlaqHX0X94xVhvZJarBaQb/gAV4OYmYBsykTQhY?=
 =?us-ascii?Q?C9PY7S8Gf0yAP1N/v4VVUnlx+1ubpKNkwN4rIvHy9oTHW5HnwC1Hepn8RIIQ?=
 =?us-ascii?Q?xZUe070a4+OxJMLnfJMju53tHBSpWhBcLgnB/sHjeMwXO+uulyGW8VIDaE7T?=
 =?us-ascii?Q?/dASrtY2CfpHhFcl1YAEdI2m2822JfWWl1ckFKbXD0vXiWYsyetCSOTdTvnJ?=
 =?us-ascii?Q?Bm3aNGnrjnr9GFkLyQZTr7YmGWaPCTpQ0dPLJIlSHi8WqunU/8InpKnySCBJ?=
 =?us-ascii?Q?yT48X8yC7B0DLDP/khNRzIMKweiVlVUBQjAfyyMX9TkX8LJMhNEj8sVHBTnP?=
 =?us-ascii?Q?ieSQIQTmUOxiraVWaeGJ1mJjzbTqAtYHNs3J3iI03/KHRYaDBZ5Rbi6c5asd?=
 =?us-ascii?Q?TOLAfm4nzyV8aJehIXS7YHRf4e6WruXbYVHx0CwjhsWIjwiTIBYstgLHeEtL?=
 =?us-ascii?Q?GMWhAERxOC6V8IK4oHu6RA7xgjaIgn+SxDaJgVItRekpw3NptCk0YcjAeoCn?=
 =?us-ascii?Q?ly2CF0IP8jgxySs39I8pOeUAEuT2ntb2u1Dz5fq/EcHXICn0vqvDf/ea2caS?=
 =?us-ascii?Q?BaSeasxWgGcjYJnxl6J2+qz0pQJHO5VKOvWv6ULR5kqpQbsJ5hmNFdk7FknN?=
 =?us-ascii?Q?3pchAX2VfajJPqaWTv1NrtF9B1JzHMI4AgyIC07WrCd0DQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Piw/ofmucypcbhQiJDmGkfOOOdogPg7ELyTCv/e+0CTpfW4jNIPyuEMKXCz?=
 =?us-ascii?Q?MLZpa0bWhoGMq6QuZ+fpKWzLSESnnoqAFktiQ1ooivNiiRALgMHbJvkHkcP0?=
 =?us-ascii?Q?UAtQfKMpJhi6m19wzVr72/8uLGInkslLUkphMVHzNFY/rzDezE7NqE/ySato?=
 =?us-ascii?Q?gjgZeR9yJl5cVDTM7SNUOsWo1yyLYdfGqR3pih1pLXPL91QeiKDCoKCS5FbW?=
 =?us-ascii?Q?8WmBKXfUkMjJJhDXbNspJMVlxTdWBhRL9idjT7Kah1yXxN5Ihjl3jrLbiM/7?=
 =?us-ascii?Q?EINV79qdkjjNnwCShMAX+95G0+6ykrPhLt5m/8DFx5/1e6Efs+iqeVOwoRNf?=
 =?us-ascii?Q?dKWow6qmLUICNgx0JJ/14UiCF/KGmTGrm82cfSbL5ek9nZhGcbH3u4qZwwbe?=
 =?us-ascii?Q?ZgiGz5UqeTEA78ravQqS16q8xcSrrwi93wFn1OX1RxvmAgR9oMblKTGn4XA3?=
 =?us-ascii?Q?aJgDba4xhAiKSJNc8DcuJomPu0h96v23+7FjVIMicqyD/5FvWNBVeLElo4b9?=
 =?us-ascii?Q?gFriLneC9G1DBoXmpn9rkDvGULZoVZLpO7KuZtNRbvADddfjv4RsUnhJoVCf?=
 =?us-ascii?Q?Gc0krt00B55z+OVvCNVOI5GSFCHNljCGAuv9h3MFoYaG+7eolM3gAb7909uK?=
 =?us-ascii?Q?cl2VSLckVC/9bkAoIB31sBxTCXRiHR4DJs5XYLfYNW+oecganL7ZJ8+fAJIR?=
 =?us-ascii?Q?PVyA2T79UirymR7X6ICoApvV8e4eZaADZIkru1GCpI+Smm4+XrRaYmJywt31?=
 =?us-ascii?Q?2Lrrah9gJKnsvHGDS+V0h7UDQOr9R7A1zVEfSOQ1Gs9yYWhI8lcvtPiIY+mm?=
 =?us-ascii?Q?bQ5asDinLiEGCkquWCoS7h9rMGsgvVnTDXC7U2ptQOZl7CsktBoG3iMd3wtf?=
 =?us-ascii?Q?boa7NhqTunLx5hcVl0ohbirhwzLXRwWJ6pupIbptbeNLnUATkeHbvvRBTkpc?=
 =?us-ascii?Q?d5xywiT8cbWks76PwgWdyaQYwZE8EXHZSoN7xRi3vRmmGAtQOEUnldDnG2FC?=
 =?us-ascii?Q?fv0ojdE4MXaMMrh2DRiXPSzKV9Ljl4H/JO0NHl076wdYIkv+fYtKDEXEB0kv?=
 =?us-ascii?Q?PjofAkfsCrs9epniOE1L9LfNcBsNDylEEq1lNxPr36/anl8RGiee7jRU/ZHI?=
 =?us-ascii?Q?SxduqixKmr0atGDCG4k8smU/DD89oFzImUXTauD6VGWKF+oqJzXUYZ8pR8pl?=
 =?us-ascii?Q?s8469UWikWInGgH9/lbmsuYg3eROXkdB5vx2qeRs9EobY/MiQk6lW/Eekhc/?=
 =?us-ascii?Q?h5mtjGkOMrxSJwgxGlOvir0FUG5QoTo65uR2aAfz3sO9agxyx8LDw1r1J6L2?=
 =?us-ascii?Q?VIuDzCt+6N/mIXB70TM83Pz5OkqXt/yCTnbGW7lV0oyPl7BagcyEGNGtPtxX?=
 =?us-ascii?Q?eDFMPBWp3D0Y45OJZRrZsrCzbIe3Kr61a64x/je/ai4O+F1a0nQ1rOXjU6RS?=
 =?us-ascii?Q?mYq0SfVIu+b1kNAOFMZpYazviXZTrzSsj9EtPiVAWKB9YzYx3tnL2dT4OaKr?=
 =?us-ascii?Q?BsOUqnjaMd28TCIBmhZwaABAXVPtM4gmAtRXpEY5vOXAC/VyMwbXFAJkAC1R?=
 =?us-ascii?Q?PYF3EMo9LmCfNk8Mh7+Kkzsso8vlUy0lrpRwFSTn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b72bbc5-ce5f-4c9f-4a2a-08dcc8f04307
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 12:35:42.3139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cDWPgkDFyrEY6uHC6TYJqO1MnHo2miH0LClupFQaj9zDUD+tEdgrDbYPyYkUQ4xp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7260

On Fri, Aug 30, 2024 at 01:47:40PM +1000, Alexey Kardashevskiy wrote:
> > > > Yes, we want a DMA MAP from memfd sort of API in general. So it should
> > > > go directly to guest memfd with no kvm entanglement.
> > > 
> > > A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
> > > takes control of the IOMMU mapping in the unsecure world.
> > 
> > Yes, such is how it seems to work.
> > 
> > It doesn't actually have much control, it has to build a mapping that
> > matches the RMP table exactly but still has to build it..
> 
> Sorry, I am missing the point here. IOMMU maps bus addresses (IOVAs) to host
> physical, if we skip IOMMU, then how RMP (maps host pfns to guest pfns) will
> help to map IOVA (in fact, guest pfn) to host pfn? Thanks,

It is the explanation for why this is safe.

For CC the translation of IOVA to physical must not be controlled by
the hypervisor, for security. This can result in translation based
attacks.

AMD is weird because it puts the IOMMU page table in untrusted
hypervisor memory, everyone else seems to put it in the trusted
world's memory.

This works for AMD because they have two copies of this translation,
in two different formats, one in the RMP which is in trusted memory
and one in the IO page table which is not trusted. Yes you can't use
the RMP to do an IOVA lookup, but it does encode exactly the same
information.

Both must agree on the IOVA to physical mapping otherwise the HW
rejects it. Meaning the IOMMU configuration must perfectly match the
RMP configuration.

Jason

