Return-Path: <kvm+bounces-52533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 480E7B06650
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 20:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C4631AA18D3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 18:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2993E2BE7DD;
	Tue, 15 Jul 2025 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="saTv2glE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1230288C9B
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 18:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752605628; cv=fail; b=diO/zk4m3zU2S8SfOUboexEcF4kazxbGhoPLyBiPr7KnEBE/J0lIvHx1BniFGx/Fy/xkDXN3V5NhOLwsfbYIjLQbNnv/AwmSyRU7rEYIAS/4fQGpbV5Q7Z0cJLAp2i+Np7qS8Ey8Ju9CgBjxLzo1GigmShYMGspNYNH2WT6rK6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752605628; c=relaxed/simple;
	bh=MZIMPB3R6MuNloWGm546jBn82rPAW/kiGPQxxvG9lKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e+hscuEWugbKQP/AZ6vrxRLuWMswlMbS8EhndM6zi5qUhaVXb1LUQuRyMJRMp36EkKRsaQMDumtZEo2L5bwMnZOKreMho4afz5cQtBJv9NyuBt4qA+lvajyta67c/QSeWUudYB9lqLhtRRLeAvGNVwnq3AUSB4cKAbdXLRxxhWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=saTv2glE; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jF7leGjsv5ngC16Haaqq86bbSQDDs1wGud5zhlvR00LwCTqVUt9amI6GQU07wX8QkrUFjrOeIiNJ2fIaH8XYH/5a6rXBaLRWwL37cL76xS/ZGKr3XIJ6O80MLgYnozJIF/gGE5I4rfB1O3dDv1UPd5XoAXCA0w714W5yMKhrCTkWr9iR6KQvVRZr9r1MrAUz7/JWxHz11vHH3N71EkyG9kvddDq/0ZiWahXU0shpGC+UHCDulM1GbfJ2R2ZZJrswfplk7qOPqGFfyJZm5chF1UZp2Eand6esXF/2Wyn54b/nhUNuHHTNJaJc2SmtVX+aopYd3dZ0cB0dkMNLX0Mx4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZIMPB3R6MuNloWGm546jBn82rPAW/kiGPQxxvG9lKM=;
 b=mwftMUaq5/I7zRrTZ0vA45kkwdbnGNjCNcuZQgk+qhIXPUVf4gM5PPtKS8gLZngDy6aIk3aJZ8eD5kw7hyr5d/JFkUzK4BJqcb+knDEVDVRuF62pUyGk+1XZrOZN8+gEBV9DF0u2RzKrZIn6f+LKe6NMfHcW76ocYgdGSKIwLgQzUAsxFLIEPtNJhttrOaP6bygPHHiqZdHgPezkkwNOKo3xw4aznZKL25BtbnY1miF6bmTImJO4u89+T8tPt6ZeCKRVcv6mhfA6gqik/2lZVAEqOTuIl5U/74XzJm3PBIeFDVEvH/NMUpWj1Uli+xd7brul1PR8Z1AhscEBmO+VWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZIMPB3R6MuNloWGm546jBn82rPAW/kiGPQxxvG9lKM=;
 b=saTv2glE6G2I0Caqil/iHjqbdspn8OXhbFt7t9o1R0ZPUapJOF+8F5NGSxE6uzOCYnrAHa1ZJq8pqBJL8mvOMVL/T63spcR6JZiISNAF+Jxlv5c6G7GCh6bgbDUuo28QgeQ+mvACtZUD1vDm28hJyaY3M3CFiIMO9Qw3migukatIDt1aO4jJmv6Vg8B/jjglwoIUWdgQpVvKMlmJxHHdx2TxhRM2fXrXo6STXsgqY84A8lE7z20LZdI6jtoqfV0JtV1B+ohaGX3CfLh2qiKKV2qSh9IUwd0Ppn1JX+YxcVRtRG4ruIhK6r8zMlko2lxpsgZqhqQzLKpI5Ffv2yGMVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Tue, 15 Jul
 2025 18:53:41 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%7]) with mapi id 15.20.8901.033; Tue, 15 Jul 2025
 18:53:41 +0000
Date: Tue, 15 Jul 2025 15:53:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"aaronlewis@google.com" <aaronlewis@google.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"vipinsh@google.com" <vipinsh@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"jrhilke@google.com" <jrhilke@google.com>
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250715185340.GS2067380@nvidia.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
 <20250702160031.GB1139770@nvidia.com>
 <20250702115032.243d194a.alex.williamson@redhat.com>
 <20250702175556.GC1139770@nvidia.com>
 <BN9PR11MB52760707F9A737186D818D1F8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250703132350.GC1209783@nvidia.com>
 <20250703142904.56924edf.alex.williamson@redhat.com>
 <20250703233533.GI1209783@nvidia.com>
 <20250715124223.67a36d2a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715124223.67a36d2a.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0118.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::33) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 468d6b3c-b765-4d9b-a253-08ddc3d0eac9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qIGqov/xPcY3Ahm8J0Honc2xLqgJOeDWLEeLZRh7q1+dnMrSPc6SDS2X0mXs?=
 =?us-ascii?Q?bpIYt0nwUbJ1s6v+Y6KqXlxRIT6EMCert6tjdnKQ2gVieTKvQ/QtIWee1ytQ?=
 =?us-ascii?Q?aPHE9qGvh5rPApgwgIsDpaQ/YRLXZ7TM3Ds8NM2WQpehkMXcGdXP/C7ju8QN?=
 =?us-ascii?Q?cxlVVYeGvE335yyLNwJeA4OmXo+AEFWqFzt+xaK4BEui3MY/SdQQN6JAG/s7?=
 =?us-ascii?Q?zwuBq74mh4p4PiRquUsFkD02lAbs3GfeCLtitq+D+7lQTQzqMBY3e2IE5O2C?=
 =?us-ascii?Q?58fseL/DxWwbcKhbz8zzyNsHLPKDLWBXIkDKW7DbGI7jwOYJrRunC72uHsX/?=
 =?us-ascii?Q?7sdHzzJIqugRbcDaQQRrFdGPNv2g/qmZZo7WD7R1Vwop6xoBpupCmc72H+Pf?=
 =?us-ascii?Q?yKrdhLEG/PsQO8G5MMV3qkZLTr3T0a09/B0FMCd7JYL+8jlLSYgtFA1dVcMb?=
 =?us-ascii?Q?iljplmZioKQb0nOrTSWQ82MfKp8IdmnSVrs4Hn1xKOdPOg/sgj0ODH/D4492?=
 =?us-ascii?Q?k3apTKdiAOwXsxEqk510QwplgnzUrQN997gqe565DiBL0CDlS1ROp/XwIlC2?=
 =?us-ascii?Q?9diWY925EzagmVFPU1VhjGU8shXL9JodZqyUIBWw2ztxW46N3FMC3K70sCD1?=
 =?us-ascii?Q?wGxgdVTo4C8H3ekeEX7z9JYyLlv65onALYrvzkEAk51WG93SByqd/TbdvjSV?=
 =?us-ascii?Q?57K4DRJgekn46SccHue4o+5iAk4ZqFrsWFM+VrKQX8ojpdFme6Cm/7hMfrdM?=
 =?us-ascii?Q?oiYwmHnjbeGYM0VzIzvRDWvgoA5dBtLcc2KwCJhMQrNtx9zZZ/9VFYll8sZA?=
 =?us-ascii?Q?4daI53cE0epQ4rVVe+B1xgD5N+7tm6cxNaNENWVWyczl53rdFCnyBQWq7IMu?=
 =?us-ascii?Q?2urlnjOlYxE9uKtlvrnYvNoK/DBom9gR6D0AKUxweI3OMoMyEofq41o92050?=
 =?us-ascii?Q?nUWgWxrLQFsBZcMVmZw1nl5lcjGrEao/KgF/tVcyP97yfzvpwFZFSHs+1rqm?=
 =?us-ascii?Q?k0ud/nmADp8p5Bj0Rq/01iRy+QZDVp4UE1OscJ/ZAXcLMyPGBMrVxYoUhd/P?=
 =?us-ascii?Q?9+vyTymrAemJDRfqDCvXQrVC2BlqUFXCHHtfArUkRU0Rvy71L9l3+UEzenwe?=
 =?us-ascii?Q?FSiDei3dCNEHcQfss7UQtWXD3CcGqlfdtTvjzCVIl6I6GowtbwE+aMC5X7DJ?=
 =?us-ascii?Q?oFBB2CpOSf/bFVQS37ws2rT2STBuFpGORyYFH63ICTVljntMwjRUqkcGfcle?=
 =?us-ascii?Q?a9mGSZU4ocSa/BxbKpk7RWpRq9biqWOWFE1MWKLyRP2a2nf070gT7tNVQhDI?=
 =?us-ascii?Q?/ZbqMSDecd3+0PINHLGlYLQZdjJ14TaQ3LHI53U+NCbuFaAJZ7MRz7bk0zuU?=
 =?us-ascii?Q?w7L+FVdc406furAc8aTlXr5qKpTPwBKU4nPOtdJ9jq8g6LMPQWF08LYfhEHh?=
 =?us-ascii?Q?4CmpJ5SmGZU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QLTfoLu65r7vCdaA7DtBV0VAEqJM2JUSpe2XeWjGQTnkmAQabgc+8Ja0gZ56?=
 =?us-ascii?Q?q06/FGVN4+Gem3FUoiTVO5iWkUlGJhxgnAthj+XlVtQZJFH4AkRLSPfQ0QoZ?=
 =?us-ascii?Q?VqSm4negvpowjTw2aprAt2dQuQyhR1IcyfWMiUNVg5RsKigFh/d7hcKTzCqL?=
 =?us-ascii?Q?NAl25o1+td+JYFrL7aa6luK12VBDtR8GX/9QCoBZdTSheKKb8ZZXOuaxNysy?=
 =?us-ascii?Q?WONOYqEUs8dAJyy06qBb6wiVCu5qkfm6cMEGTdF468eUKUeFrBS0eyV6GHNd?=
 =?us-ascii?Q?Qm2BUBNyayNE+nwzT2QnPDU7gkWdqEM7Pz4CpnGGieOAlvgiyfyZs/QpAQ0d?=
 =?us-ascii?Q?s+ZYZSYs0cO41hceFOt127ULS2gH+k0SzfCeEPNzYrFynB0+1rVHb46iiDno?=
 =?us-ascii?Q?PfRjBhl8SjVUL1fziwBv36JsE2lJAXClegBjaMd/k/5TjTwNT/fWotHHnjAI?=
 =?us-ascii?Q?YUt8q8jgSgDBboxWVt8dN/N2RYfWiCar2AlBST7xccGu0WWoFrgvz+SL5Pt9?=
 =?us-ascii?Q?ZGeXh0lamQAPPZoNBSPKvs0vAYJgQPGJims+0Ba+tf+rJA/G9f8z7b3CMfM2?=
 =?us-ascii?Q?C+yNnyBJn41fTaOh1TAaaxBS1WNSSnJPc8AriJ+qlZJd0mfYttwdHt0ISwhy?=
 =?us-ascii?Q?nQPwnlE5Sb1x4tAjl4T2P5llqPU9oPjKhSXyuUqy93igK4T7WGTq9kfvNZ+Z?=
 =?us-ascii?Q?Zh40vJXmUU+x+8an36iTRN8C3fSp18J5zCs7BA6f3FmBIpEIDkaYN2nEEFE3?=
 =?us-ascii?Q?4UuVL6rZt/2qaK+hYMQZcDuEaacV3bnDns8DECRaTRTLY7kSNJsofe08MSvn?=
 =?us-ascii?Q?NW6QchrJAfOngVqixy3L0KiKd844gPPh/FQlo8sfoxUNY7zgPs1vIMo5w/0n?=
 =?us-ascii?Q?aqwqyQeuI8GSdp8BTes6opGajf6kb7GqqkD2SjVBn5/MVJh9/bOzRuVZ6tEx?=
 =?us-ascii?Q?bsFAs8zDepkC96GpGgf38EXHL1fXRfB8JgYmhmTSzTkiGqrlvBW4X6e+ETA/?=
 =?us-ascii?Q?YWa1rOqOZCGaKnLkIrcbgIJSD2ZQqGwKqtKAXXobIzvvdS3QYUnV79Mr4D/C?=
 =?us-ascii?Q?krkZgmpXLEDhwHKuQGrdrXiCRPVCO3RSdjKCuG430Qf6IkOglehDDbqEWpwR?=
 =?us-ascii?Q?cUZpvOxV7p1Iz0c9yoo/dU18eh/5hLEEGZrl/1277Hs0AHGrxZMHbRhpN6HL?=
 =?us-ascii?Q?URu4WJ/HX0c1oLdulZ6vZVqkynSAAHqhA2C63TOHrlawUXKQCTpTqEGIv9y/?=
 =?us-ascii?Q?qZldp9S3sQAo8gkROR9M03m2EpwQ0L4GWATii5G2RHpgYtr53QR3Ove/4l7o?=
 =?us-ascii?Q?kzMAdfE4GFSRArL6sHQIFB+3wtuUKJQ8/RZiX2W3nmRVNChN6NQbOZH3ksyY?=
 =?us-ascii?Q?G+KrbLG7bJY2fJN/+ButK/xnXIJgo9YH6IdAiS/V4FdoHeAFgzxCGTAjkDtk?=
 =?us-ascii?Q?ZUsboWZO/KFIY4fsgRCSbv3uD2OTHakmXECUvMUE2NWCPctnSZSK6FCYivGp?=
 =?us-ascii?Q?NcvMb1zRcFj6Bky+ZnCZLPnRS+JSRy+DXmEzJU2IKVEVCDWlXt7OqgJwpQTe?=
 =?us-ascii?Q?fg8sCGlR1tahIetkoQ6ODhOgsgpHIglrJHxdvXcD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 468d6b3c-b765-4d9b-a253-08ddc3d0eac9
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 18:53:41.8232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJ5pBt7D0I/b0qafqv+KZnFCifVqkbIeIaJvYjd0Xwp/F2r4kJ3q4oCyNXdzgwqg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

On Tue, Jul 15, 2025 at 12:42:23PM -0600, Alex Williamson wrote:

> I went ahead and added this to my next branch because I think your
> impression is that this is generally ok based on the vf-token, but if
> this raises new concerns I can drop it and we can discuss further.

Yeah, I think vf token will be good enough

Jason

