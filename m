Return-Path: <kvm+bounces-17850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 918148CB23B
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B35491C2152D
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5014147C6B;
	Tue, 21 May 2024 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NJmoWryd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C9917556;
	Tue, 21 May 2024 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309249; cv=fail; b=CF8l8KILPMTCJ69JJB9TCIhesutIakK/k5A53VBQ/gDEcTr+esPluvMQkmt7HjdnAoWMRiQzvzCOVRWFWYFYujNn/4w+wHTMOdyUS3B584KgXuf9tN6qLcJXhfvIQr6zoLykg0bFgl21ROkmSbtyPLB8ET1t8Q0v9WQQrKsPGJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309249; c=relaxed/simple;
	bh=xdlCnv+nyak6qQiIJMiPP4LCbxLBaKkl5EZLVTTJGic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ILZvG4CM3Dzitr2Nsvf9wCAYTrE7U+me7A2Cs5AroSRkGZXpPsZS0g9beYRnWPSbnJD39GkAUJXvhhyXSO2UKpCIhGbxbTmbvxh899GagVqZEdeKuQ9Zq99uCy/o/mIiiefWg6hckyZGReX+d96Hp+2b0TZjNP+w8RZdoZvvyl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NJmoWryd; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwnA2iQdrpZ7Qf8yNtAa0uRDU68Khuvc+wjiN4/b1z6OMmSpyaG3KfeGmcZ7/wRDJub27ypxfx5Eff4As77JxerwBLPCaKyrTcp/CLnjoxBNf7b4UE7CXuCK5NSVa0PgBy7AKare0PTUcHNHEmF5I1UeMPrPvcxwFfT5WadTRkCj1Zcht0Ecvza/Sle/qxkUu6zJsIwOiQhySK7YQNfR0uXM7jAJlOwJmuxQaX3PSJnTInaykWx/85KzEmBudvQRIfp3cn14Il+cJBD9GDzNrdA7IE/QdrLXwbVPFcof+s0CQHXTVsCkU64nOtxEy83owBCkNQODRJFttIwFsZZgpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEy5FaShT9wfPTdnNHXnc/0HHn+RZs5ScHre18vOaNU=;
 b=OUau+HaYORuLa+5t/GOcks1H98kH+jg7lY12zenvIlwWlUmsb5FD4EbhsFwyQ+oVCLq+aWXkaYHX2/iyErm4RsKmBJ1IIbZaXJmK/iuylVxVf1GC9BdG94ms9oopSVxPRnqC49O4VlsPpY9acZGJDmno8LOt+F2kBv0u3ALGCWNXVevcz3MRZxltNuGXuHJ4WRRwx7rQXxV5Ndru4i/KwCBtHTZfiBBEQOLUtqYz1QLSLlj6wlZos0XjyTGAsAeCSIhKm/vFkeccL03JlHU1GYDMWcbql2aZcpfqkp0YJIy+b62Cz4dYjibqLuaaPsqxSjGMzwNMOSNCLOgkSiuvPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEy5FaShT9wfPTdnNHXnc/0HHn+RZs5ScHre18vOaNU=;
 b=NJmoWrydnTMHE3wfdsEh/Iyz5g18R5PWyVPQ4rrm8Xybb+B4TfOra/YsOZvsR2OKe90QMZirnTobF2LPsk/a4n+L/MJqOGZxI0YC7n4fYtv6eVJAx4Qbv2MmYg12RmvdNVH5LZ0kCWj72ylJm3SBqtVA3EapEBiEcLZewYtGben1SI5lwuuDcf4pQdBsdECwLjkOli0tIvmxRzIjuU1uDLg85tiOJsETXi7hpPRwIPqbOYJ321clg0o1jEv7bIZoiVUSXY3ieVf7Cso9+vtT0oDlN6biRG11LEJ/H5XiyT0PFxrjxKAtE5IofLWOAllae+oURkWPRtBACQbmvPXclA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB7786.namprd12.prod.outlook.com (2603:10b6:806:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Tue, 21 May
 2024 16:34:02 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 16:34:01 +0000
Date: Tue, 21 May 2024 13:34:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240521163400.GK20229@nvidia.com>
References: <20240509121049.58238a6f.alex.williamson@redhat.com>
 <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521102123.7baaf85a.alex.williamson@redhat.com>
X-ClientProxiedBy: YT1PR01CA0075.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::14) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: d2691a14-3404-4f41-4293-08dc79b3d251
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gs41oBfftNDKW9xbHpTMHmRgUvqtENTA9hiF/kYquFyK3ftuMiFPH3RYK69n?=
 =?us-ascii?Q?uWLwI1tbeSacLvZLKbhqBsN9K2+SeK2JRlc3AQDZ90m6VUy6vMEhGU/96M2b?=
 =?us-ascii?Q?a30Q7GuueafHa6MO2KkkXjBQs4W+h8Z3lc68J+UH1V+vhQUR7A2aVu6McJc/?=
 =?us-ascii?Q?cavZECosgs76iDl/6GqVo5EjyORu1brvu4Cj3Q9US+snysDlIzSx8wzXWq9b?=
 =?us-ascii?Q?T7/JuXh3qj/BtQA80QAZdQd7Rdr7oWpkyUtJXAVKC3V2DsMv0+Nb2HJ8Wwq2?=
 =?us-ascii?Q?zCCqrB6MjSEoSY4bScJllPMZC6B7PgvYhlFuYuIl44hRitNLBSKzgmW4uHmg?=
 =?us-ascii?Q?o9VhiNIZXOmnk2GmSpo+C+UzpcOKFat1rjOwzLZKFENkW/pX4UIkBfG+TCGP?=
 =?us-ascii?Q?PbuYkuotjUzFpuutlBqcY4VT0USqHuTYzGsNCITZRQPKwg57lgwKEvWhtRAG?=
 =?us-ascii?Q?/4oeamh0q8O6o72BdBTUp/4ZScoqZvFqGeySkqHVXWgI/KoQB0DY4B3NaCGI?=
 =?us-ascii?Q?52pHcc6ALEwEx+ogykr+KgvVVdIlYAc9+d0w8MLeTgQjKyM9v6J1LRe7r44c?=
 =?us-ascii?Q?+SUDugHnla2+xgGXyjNRw/SV1HyT5TsrV33L/EFkDZ8dqLCc/BXlwed3FI85?=
 =?us-ascii?Q?GHPxuBYxbIHwwids1dTYwx1FPtt1/M2AF+KWLpoxWwvcFjQ2tP+Z1/sfOtvz?=
 =?us-ascii?Q?SA2LLOWjTdzocGx7Cq36uTX8Bo5D8crLmC9WWKe1xSrn8w//828lb5yjQ10T?=
 =?us-ascii?Q?38zp3bMFfgpFUbgRMVfPthMcMob9p2TZFD2M4PWyth44AkB0GoeTaoSZrioY?=
 =?us-ascii?Q?77AvP+WAKVaNgYvUMIDWhw9m2JSuuK5yVivqcATjO7C2N+QnXCuobCYRCmlE?=
 =?us-ascii?Q?MHN7yRt59S/E2mBaTneYvdY4/ijIUT1y6Bf2v5OMYCrfOrkU/ploRrmYudH3?=
 =?us-ascii?Q?IfPMf8qnp9ZHdNJhLWr2DYJUwQa2CkAwE1ob+RpVEFgtIWKg6LDi12hYhvHT?=
 =?us-ascii?Q?KQCwYZQ2ox/yJUJV69FQOzRknFlNx7RmS1SUWH6vZWjFkunHI+Z2hmxzAaZT?=
 =?us-ascii?Q?7no26h3B7yCDIzdTOIRYmccqOedvqxd2SphOGP6XjaGfH78V5djg1z3j7Exj?=
 =?us-ascii?Q?rQ2x1+qDU67d7dY1+A19wQ50TVl0Zu94DLq2+QwiXdaWBSvHT/c4td6mwj2U?=
 =?us-ascii?Q?kJooOTzzw5J0BifTCtlNOL8a9Tv3LA0GoI3S0tYYqXGhwf1Q0zhv0iEGYdmO?=
 =?us-ascii?Q?U9mISvnZ6oU2yuRxKE3xbm2FM4XQp6Q3y+x0qeKoQA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nygWYMGRBcy2pDHcnbKqXDZxdjQBtVktfnqL3nBUkAVmIyMLhuXIElq5VFdc?=
 =?us-ascii?Q?jluOL8Iu1CAaoQRo6bH7qW7DZtOMHPowejmZhESPBBsX+Me2x1fOSiwKYFN5?=
 =?us-ascii?Q?Yc8GzGuzlsU/0SZZEtNuEjSgSEje+cIPhkp45F9wWI3VNVpHFGPD6So4Emze?=
 =?us-ascii?Q?08XZQWNBNzF325+JjMEkHKWMLUCx/0+wACOddSoL8Q+cgaJ82rHdb1JXjqG2?=
 =?us-ascii?Q?cT7t8YC8x4q+A+jl08aWrnO4lb3aUeH+tf+vzfrcRu6Z0/Ma7NtYDKsZPEH8?=
 =?us-ascii?Q?841ucD2ZJXwUcqwXrJIEzi+agzfgWRWlzOGpyRnwdWIkjeVSjpJezI0pDMex?=
 =?us-ascii?Q?3zIP4xyg2AsCuk6onPGIJVG4FP4XJAPQ3Id5CRggXFa7vVFUtMAUGIVuPAut?=
 =?us-ascii?Q?DH0RmHLktUM4Ymxi/F2yy7rq/bamS5xP1wrGbEspZQVqmCFGJfSGEVCrt7y0?=
 =?us-ascii?Q?APo3ugXJfwMR5o0EvQt82ES7VmjU/S1Kx/JsHf+LGm3cG/YeXyy6XxDKxZZK?=
 =?us-ascii?Q?Hj4oS48zZQ7qYY+ynpbjlF7SHx21E+rdamFJDQpW92SB0TTOPbFdwwPd9mbD?=
 =?us-ascii?Q?kW70LBTu1Ctsj8Gudc4NUWx0QhkR+A3tWc849hAzyky4CMLY2t+0xonaJ+6R?=
 =?us-ascii?Q?WFfqVoiqGWw4LB3PaTu8x9cZs2MMMjqSGZWKCrHGWas4b/9ySiknkendUBs0?=
 =?us-ascii?Q?x5UZthrESKdKRjIGq5GAf18ccjp+VM3NdqBCOEFB7FvSdPOc5UJjA89CHICv?=
 =?us-ascii?Q?0J8XnvjrXKIfHd04kMysZ/W6QkB4mTlGBKccdMTswiJQI2XuoAD1hkw7zHZj?=
 =?us-ascii?Q?9s3f6SR1yLTv9Xb2CBtkYPhC6qNcsMFkChNhzsaxsOJvUvCV6FFOvphEHYdx?=
 =?us-ascii?Q?hh7dN/lgojGKJCQ7giwLD/0YcQvcEQT7XB4qTAKxPt5r5tkuGt0bHi1zJLOh?=
 =?us-ascii?Q?PiEaeskNKi9djT21i9QikezF8i/f1D1ZdqKdltdxvbZciiQ5b51QnZRhjOo+?=
 =?us-ascii?Q?Oa7FbDHmKuGTlnLFZ9hAmUL/vVT6lpg6hzvtNQOK9I16tKIgvrlnIf4QzQ5S?=
 =?us-ascii?Q?3LPp3lKTC44HHbc+gXXk8ZcL8C8ldSDeOzT2JAK2KhGPkTQtoRTpBYiQDFyr?=
 =?us-ascii?Q?OFTb8FD5wLf1Oe1Vqk5th+XEwkPP5pAQmQbDAZGRRixBk2NvsOMEEen3m6aw?=
 =?us-ascii?Q?XjkwwzzvCa0PzTNA38bB9tysVXmM3T5Vpi21xuwL93bE0LmFRf3u1q/UaezY?=
 =?us-ascii?Q?jvBwxvFOrjKkXXg/jaH7T8OygVxn8yDbcgkFX8dOyUKCAE4Q17/RFihJGS5q?=
 =?us-ascii?Q?bdfxRnDWfdXsKXGYLVH+OL/sg3lI1/2OX5kruvrZTGKXDB+FBntPjS8bsxH2?=
 =?us-ascii?Q?W6cxUCx4L8Fj3yLZpQwWwKoF1mmXxqDDw+XTs9PPOyW3YkrU5tY/ezOFTuyG?=
 =?us-ascii?Q?hztgv1HVcLkRuUgOzBIDgB49ne5vEuXGhfKvitOEXJCfddeN5T5SqTtxbx4z?=
 =?us-ascii?Q?dH2vnWyxtOCqp4nkJhN6hvpACL85Jx5KPXGHLjCAYli+02DjmSVoKgswA4Xo?=
 =?us-ascii?Q?fvYCc+ho+8MDru3qpG/xsuhp8ml7Bv7wqbd/0SgT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2691a14-3404-4f41-4293-08dc79b3d251
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 16:34:01.5689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1brBfhT0gf6hGijX6z3ubNOdMCgYajuTZtrtN9qfBY+8UnO1Xse/pbqUYtCZn+p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7786

On Tue, May 21, 2024 at 10:21:23AM -0600, Alex Williamson wrote:

> > Intel GPU weirdness should not leak into making other devices
> > insecure/slow. If necessary Intel GPU only should get some variant
> > override to keep no snoop working.
> > 
> > It would make alot of good sense if VFIO made the default to disable
> > no-snoop via the config space.
> 
> We can certainly virtualize the config space no-snoop enable bit, but
> I'm not sure what it actually accomplishes.  We'd then be relying on
> the device to honor the bit and not have any backdoors to twiddle the
> bit otherwise (where we know that GPUs often have multiple paths to get
> to config space).

I'm OK with this. If devices are insecure then they need quirks in
vfio to disclose their problems, we shouldn't punish everyone who
followed the spec because of some bad actors.

But more broadly in a security engineered environment we can trust the
no-snoop bit to work properly.

> We also then have the question of does the device function
> correctly if we disable no-snoop.

Other than the GPU BW issue the no-snoop is not a functional behavior.

> The more secure approach might be that we need to do these cache
> flushes for any IOMMU that doesn't maintain coherency, even for
> no-snoop transactions.  Thanks,

Did you mean 'even for snoop transactions'?

That is where this series is, it assumes a no-snoop transaction took
place even if that is impossible, because of config space, and then
does pessimistic flushes.

Jason

