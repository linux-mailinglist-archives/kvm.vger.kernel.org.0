Return-Path: <kvm+bounces-24466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 987B7955459
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 02:37:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F419EB21FD1
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D752C440C;
	Sat, 17 Aug 2024 00:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PaKBc9yf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0938B33C8
	for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 00:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723855066; cv=fail; b=HdODzz6t3/pAxd4WN719DdqTQhXqIvotco3eNyFLD4OWs9c33z+y5fXpcYdTmLbPlW6/xNssbKcUilH+sqO2h8BcXQv+EDz1RWoqwAJZ4oBZlzlOQ6+14MWZRtHRXuh9R70OkdPhpY+B9010Rc0lBixPwp2i8CzB5RXbiLeF3lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723855066; c=relaxed/simple;
	bh=obQaBmlvOfB48MjtsYH1+/SJiFus2SfnDkQP+mEmMgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XfIyj9a3f7DsvDslVOHhmjUI4qLo/WDZMq3hPF0xWDqLcSBNFOqAuFGpteUmUBUbhhOrDpa2rT+1UdroyFHA2b6epK0NSPKEMkyFyA926BGFMJLNVe+C+Z0wEI6UikrhdaPWBe2SM9Pp9Owm0uXbN2MAoDVD6nyVS93+lAzQlek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PaKBc9yf; arc=fail smtp.client-ip=40.107.96.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmUhKtnSb1gr6nxBgetarjUnoJAUxQvAH+nxuTXqY59GJxfNlqbbNxiC/FB3oopD9nyCnxggoGXcqkD1g05Hf5CT6LE58JknmEUGEGh0KBXMFXmmzA3QDrQgxGjEVGdPWPTFdEmJuC18PH9NYQIas/L7vDvaS/tjIYEVn2dr/va5jFjU3Co0AurPmOHbJuFjx67l0gDXHDsRe4gcF6M8aLH87ugmq6FWUzrp7SfJFU2af9N/sgIPZanZFUyQPUhO5jGnfBtp2VzV5vFxQdRK521EvByKwp+REgPmHJrIzBrhwl7Z+p9Kgq6Kc9+6oHQcs4R5N9IzFRov32xmUtIhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+b/4kLMgvH9aw9mciTohH+J8CXizrjfv2zH5y80hetQ=;
 b=CLEQD2MjC2AKD9c5j7zwP4+n9tWmuTsSIZb/m96BT/AG2sp+NVMJ5bau4kbwRpeoXIeLhuFxa6NQX5PNiPdGvJEkUOBraOIzOEXzhOBvyU1D9eE/Z5PqY6Aqa6z/Rz2VrDFrPCj82MCEFVaovyadHnr+b15N3tMxhHITuHNAAO5j8DYkHXBojd/VLOejgZ1ctMDCwwIBy/MtNoGNItxCkmRDRXLYtbU63KpCKsXFJG1VyBhaAXzs2VByew4g6A2iOOehz/kuCGkxsC9ldxsd1zyEBA0BXfNGOaOz+XfETo23VYitXUkwvFWmOTU468PT3FgPrHMa/cG5cqray5kTWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b/4kLMgvH9aw9mciTohH+J8CXizrjfv2zH5y80hetQ=;
 b=PaKBc9yfYT6BkE8laxBT8L+HRwkKEaGcqS7LuYzgJ/LsTNHgBzcGQg/brJdcBYSJ60i64uDOg2QkHTc6t9oji4meZbkQt1qvbmsNDzzjZ4sBlW+v3ODg7xly8GxtU+TP9K5TSuR5vaOP4uEj6sebpNL+8BnOx98DErEpj43BnMA4XbiJgTmZPP4fmPGoExDG6FPIUYTLVdATG0wDFm4qsfd1vuT5Z4ZBcxwjLTIwgoDZx0eVo9ydVAbTni2dIQj4HxpmdOvQNiSgxEGixiomJfyf7gp7V2B/Itev+Bu7IHArfLbtYwMJtHNLCyGDbvBDopXyg+kvuVfPqmMoruOquw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SJ2PR12MB9007.namprd12.prod.outlook.com (2603:10b6:a03:541::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Sat, 17 Aug
 2024 00:37:42 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Sat, 17 Aug 2024
 00:37:41 +0000
Date: Fri, 16 Aug 2024 21:36:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>, iommu@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Tina Zhang <tina.zhang@intel.com>
Subject: Re: [PATCH 13/16] iommupt: Add the x86 PAE page table format
Message-ID: <20240817003630.GF2032816@nvidia.com>
References: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
 <13-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
 <Zr-mrsewGxXt1rAC@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr-mrsewGxXt1rAC@google.com>
X-ClientProxiedBy: BL1PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SJ2PR12MB9007:EE_
X-MS-Office365-Filtering-Correlation-Id: 0779b5fc-1508-4360-48bc-08dcbe54cd7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+riury+KV4o6lzYFMaF3DeFsgpzJdF3SMCBZgdTjSg9sQthrJHiKbxuagprM?=
 =?us-ascii?Q?2KylA0GBw85F2/e9XMztXuKpiUh3Jd/9qQlSVrZ5F2ln/Y3RK9iAmINETbbZ?=
 =?us-ascii?Q?Z7+YsYFWsUF6fEmx0N404gwwaefsVOEjjPGr+se9rNaqkR+PUgzGvtMx/vUl?=
 =?us-ascii?Q?IkajAIjNhfZTdCSpkXYrzHGHB4d1dVXJHCcQnKmHD35oBWX4MWRCeSqoJIzN?=
 =?us-ascii?Q?u9d/8CoQXpKcQRK8UuzmlBfc980FWHFZNLsPp0b55Le9tuIuKM1V+1sQilxZ?=
 =?us-ascii?Q?b5Oz1JzktRAkBb4uRtHs4qHrfTK2ZR3a/PxD2I02rSyEDMztjfdyoPFg2N+5?=
 =?us-ascii?Q?KncrV5mBvzhW3dVjgdct6xUYzGfTWrsbF1cdhP7y4BOu3efr2DoaU3l1SKCK?=
 =?us-ascii?Q?KDAwuk+IwGYUkEbl7OYm9GrKMUwV1GZ17JXGVJIz8zOW8gKE0iKvxmLPxRsa?=
 =?us-ascii?Q?rEC22KL+sBw/kHARj36QsWRSdJ+JlhRh6Es8ghd/Qq6ltwnalvy3W+VVynFO?=
 =?us-ascii?Q?b4okInfR1kqzgIeJIgDJl+bjLdxJF+TLdTj2k6gRylaWDsWXzSu4dyIwIXkh?=
 =?us-ascii?Q?cX5OFUn8ahO39a8mpWq+XCPMKRUYuaodQqrVqyagB7uRL5S3x9Mz5QfVEl4X?=
 =?us-ascii?Q?FEnKv214YDOYG44h3C7G2FMWJciXw2uO8CMQg1yBFR2XPmT+fTMBoaSdysyb?=
 =?us-ascii?Q?izgvhE/i76BUYgL/DpGDJoGQSy8Wv5joq/vSyVybUFJPtXdtNZKdZTedKZz7?=
 =?us-ascii?Q?JKKw/E9HfZOdUC+k7Wju6HIApFR3/Wi6ENw5v9Q8+1BDUvEyWUqZxW3xoMDb?=
 =?us-ascii?Q?pEaU06xJHVKIevqwVBUziwgraE8Jq//glMBDXY3bta8dEt26a5TCSVjc+ac9?=
 =?us-ascii?Q?v+Ky16pYWoMEStxM5YEeypohZ5oMfWjxLaO5rt2V0TVTvXvTaDizsXP/3oGi?=
 =?us-ascii?Q?RoVZCnDukqzdf18Lbqtf7885Rk3wXkHRQFX+GZxtr1q8ptQygBWCaxgyDP7m?=
 =?us-ascii?Q?MlU5RufKEElSWl5Rw2mX9/+lHReMY7n5nwgFoiZyZGPGDjoJDi4/zFnt9f44?=
 =?us-ascii?Q?47HcszArowfswlcTFbOD9V/3NhN6poJO70c1bfpE8K7n/uAX9q8hadGJ7z+5?=
 =?us-ascii?Q?JlcMDQCEbeiBGTK7mh79gqf5mSDEvplcYBBj4pzB1xmVJXlkT1yDFlAvPefA?=
 =?us-ascii?Q?koP0wUdJ9ZLUwU/I/ElaFm8cVfKqegfrt/BPD20tyhrcLpLIsz2pz/5xfKg6?=
 =?us-ascii?Q?a564E18ItpbYEg7PBcYNBx7dxNptzXNqZNcwyB9BZzIPgdgjGUqS434wyeOl?=
 =?us-ascii?Q?nKu5kqO7Kat4Uumm/C0gYX7JbY9zIwSVNvHNovXQCa02Ug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WhwshgcJldZZlXQ0/iao2wGGQLly84HlQICyeQKnistTCyeIeXWqAwArsW0i?=
 =?us-ascii?Q?fvjK15xieFPjftaGjb/v+kjDpOt/U4RSUja42VSzxr/CDHFJKxhztlg19DXT?=
 =?us-ascii?Q?/qqepkicXNmx6vuGq75MCkP90roOw7CNUs0E5GSTLj0RlXEB7viHzQWo8T+H?=
 =?us-ascii?Q?Rh/XvzfD1EFnZyGI86P2zcBXXNJd+55UZteY8wl31AUJSfkX9Pq/tamdEMA+?=
 =?us-ascii?Q?2x1MalE09Ijd9/ctF5CFWVn5yRGgEVxSsjqbP+jWnby/SGPQrHx7anHqV3Wf?=
 =?us-ascii?Q?7ovoDrehPPTruLZTJDNKOKDHW3yv/goI5jejVHIYY7AzBhRAOORRwlHO0dTI?=
 =?us-ascii?Q?23mwZ3ASkbZYiWo7SGstB0QqsFOXiI3WmpjaOLxzq5QiL4Qj5YoQeHDjrlHz?=
 =?us-ascii?Q?RCUM0CmjJfsMYZ9Xy8qEHpfRF4toKcxaCgbc6zxWor9xOBZsr0BnmlfumAHz?=
 =?us-ascii?Q?5bIsN/sPS64zD5KxA9rSSEGNBR4a6Nfa6Zurno51b1MZ7uiqc3+KdovifUX3?=
 =?us-ascii?Q?o+OnhIZeSkCO+7n7Xu31BQG/yJ+1ySQ9Ie1FguMyIvpY5DoFdrTyNIVeF+K4?=
 =?us-ascii?Q?w02nwDn/Ny1Q0QJaM7wtGXXImtu2Y89A2RRqDfwq5nx5I2LSDyw406mRGbVL?=
 =?us-ascii?Q?IcxIAeeCxjCqFBBAnGE8LpUszATOnDxRLl/lEGItlQNeiMsxJExKLgPLU7rB?=
 =?us-ascii?Q?zMgDnCplUNe8ZBbQ2Ppd9egdcuZ42LI6X709MYYUdCLLAOnDiRrcbEcXQ1w9?=
 =?us-ascii?Q?q5AlAqKN760/XcVVNW8yTL2bHGuO4kMrSS2PjepJvznjqxcAqztEDN6TkKYk?=
 =?us-ascii?Q?xtOxF/9HN13xN/HIT4JfnrSjzyW1RRCbPejH7t7CXiXgCJ/lFxmCFMzvoqnD?=
 =?us-ascii?Q?b+ZFKHZuAl2reGqzlGc9Bl700R+1HiloKPEFia7C2Q9uIcrCTvBE/RWDdz4Y?=
 =?us-ascii?Q?QYyMXB6m+2DycRUp4hB/veO7CRB9SYLh6j+Xs1LTP3vF/f6QEYgXIZVYWvEQ?=
 =?us-ascii?Q?fjZA4KPKCI1yTzq66/D3pGw9WupjCx2IFrW87SmWw0s5h26Dcmp9iRpR7V76?=
 =?us-ascii?Q?V4wzq/hADqZFdeepbFbj6dcjDZg0Ybmz759bxy/N1AgvwUeQQHA17hSmfVzU?=
 =?us-ascii?Q?Tg0jKOdFl8PuLSGCrztpILhtCCNC1+vxnsxTz8JlTq/p6I+j3w9m7gaqJO9X?=
 =?us-ascii?Q?alqiZDoqWU3zWT8cBCXAzCZ8fUzOtAzVZUWQpN1lJ17iq4gbm19bBmPupBZi?=
 =?us-ascii?Q?F7k7whwBGxXfeMOQDiTunvh12x7eKYAymeeQ638yp5PnwXMRSYwP3x9wYH/x?=
 =?us-ascii?Q?p7JdLCYmyaFC4yqENDqEEUbNA7IDKFoBYE1cpaymeXpvPwyytPhx50sggwc2?=
 =?us-ascii?Q?hzPhFF2DrAQnqDpVQ6nq4rDcGcOuCeiy6VywzB46TKzMXoNOcPwfJh3MZ1fl?=
 =?us-ascii?Q?4MW0Oe6LeZHL9eocigcouSsUNTXvL01MCJD9dkqnBejE+SG0o/yi50WAPQtr?=
 =?us-ascii?Q?f043ciNx69604MaqHvClKqfr/3MDAD+YxT6SI91qaqQxRoVyUKIs/h/Uh1cv?=
 =?us-ascii?Q?0dRvxvuNAcvHuRi/rbg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0779b5fc-1508-4360-48bc-08dcbe54cd7c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2024 00:37:41.5325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZL1EFjPxpjp8bCEK9kPA3mqiW8NOGvNV+TFsYAGd0+fnkI7ICs5ieAeZlXB5unXY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9007

On Fri, Aug 16, 2024 at 12:21:18PM -0700, Sean Christopherson wrote:
> On Thu, Aug 15, 2024, Jason Gunthorpe wrote:
> > This is used by x86 CPUs and can be used in both x86 IOMMUs. When the x86
> > IOMMU is running SVA it is using this page table format.
> > 
> > This implementation follows the AMD v2 io-pgtable version.
> > 
> > There is nothing remarkable here, the format has a variable top and
> > limited support for different page sizes and no contiguous pages support.
> > 
> > In principle this can support the 32 bit configuration with fewer table
> > levels.
> 
> What's "the 32 bit configuration"?

Oh, the three level version

> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> > + *
> > + * x86 PAE page table
> > + *
> > + * This is described in
> > + *   Section "4.4 PAE Paging" of the Intel Software Developer's Manual Volume 3
> 
> I highly doubt what's implemented here is actually PAE paging, as the SDM (that
> is referenced above) and most x86 folks describe PAE paging.  PAE paging is
> specifically used when the CPU is in 32-bit mode (NOT including compatibility mode!).
> 
>   PAE paging translates 32-bit linear addresses to 52-bit physical addresses.

> Presumably what's implemented here is what Intel calls 4-level and 5-level paging.
> Those are _really_ similar to PAE paging, 

I *think* this needs to support the three level "PAE" format as well?

I'm not really sure yet, but it looked to me like really old
non-scalable Intel vt-d iommu might need it?? Or maybe it uses the
vtdss format with 3 levels.. It is not something I've checked deeply
into yet.

So the intention was to also capture the 32 bit PAE format with three
levels and the 4/5 level as well. The idea will be that like arm and
others you select how many levels you want when you init the table.

If the three level format needs some bit adjustments also it would be
done with a feature bit. I haven't yet got to comparing against the
bit patterns the VT-D driver uses for this file, but I expect any
differences are minor.

> Unfortuntately, I have no idea what name to use for this flavor.  x86pae is
> actually kinda good, but I think it'll be confusing to people that are familiar
> with the more canonical version of PAE paging.

I struggled too. The name wasn't good to me either.. I think if this
is confusing lets just call it x86_64? Sort of a focus on the new.

> > + *   Section "2.2.6 I/O Page Tables for Guest Translations" of the "AMD I/O
> > + *   Virtualization Technology (IOMMU) Specification"
> > + *
> > + * It is used by x86 CPUs and The AMD and VT-D IOMMU HW.
> > + *
> > + * The named levels in the spec map to the pts->level as:
> > + *   Table/PTE - 0
> > + *   Directory/PDE - 1
> > + *   Directory Ptr/PDPTE - 2
> > + *   PML4/PML4E - 3
> > + *   PML5/PML5E - 4
> 
> Any particularly reason not to use x86's (and KVM's) effective 1-based system?
> (level '0' is essentially the 4KiB leaf entries in a page table)

Not any super strong one. The math is slightly more natural with 0
based, for instance the most general version is arm 32 bit:

	return PT_GRANUAL_LG2SZ +
	       (PT_TABLEMEM_LG2SZ - ilog2(sizeof(u32))) * pts->level;

This is the only case where PT_GRANUAL_LG2SZ=12 and
PT_TABLEMEM_LG2SZ=10, so the above needs no adjustment to level.

It also ensures that 0 is not an invalid value that needs to be
considered, and that little detail helps a few micro optimization.

Every document seems to have its own take of this, the intel/amd ones
all like to start at 1 and go up, the ARM ones are reversed and start
at 4 and goes down to 0.

> Starting at '1' is kinda odd, but it aligns with thing like PML4/5,
> allows using the pg_level enums from x86, and diverging from both
> x86 MM and KVM is likely going to confuse people.

And ARM people will say not using their totally different numbers
confuses them. I feel there is no winning here. So I went with
something mathematically clean and assumed we'd have this
discussion :)

At the end of the day the intersting stuff is done using the generic
code and API, so that can't make assumptions about the structure from
any of the documents. In that regard having it be different from
everything else (because it has to be a superset of everything else)
is not necessarily a bad thing.

In truth the number of places where you have to look at level is
really pretty small so I felt this was OK.

> > +/* Shared descriptor bits */
> > +enum {
> > +	X86PAE_FMT_P = BIT(0),
> > +	X86PAE_FMT_RW = BIT(1),
> > +	X86PAE_FMT_U = BIT(2),
> > +	X86PAE_FMT_A = BIT(5),
> > +	X86PAE_FMT_D = BIT(6),
> > +	X86PAE_FMT_OA = GENMASK_ULL(51, 12),
> > +	X86PAE_FMT_XD = BIT_ULL(63),
> 
> Any reason not to use the #defines in arch/x86/include/asm/pgtable_types.h?

This is arch independent code, I don't think I can include that header
from here?? I've seen Linus be negative about wild ../../ includes..

Keeping everything here arch independent is one of the big value adds
here, IMHO.

> > +static inline bool x86pae_pt_install_table(struct pt_state *pts,
> > +					   pt_oaddr_t table_pa,
> > +					   const struct pt_write_attrs *attrs)
> > +{
> > +	u64 *tablep = pt_cur_table(pts, u64);
> > +	u64 entry;
> > +
> > +	/*
> > +	 * FIXME according to the SDM D is ignored by HW on table pointers?
> 
> Correct, only leaf entries have dirty bits.  

To add some colour, this logic is exactly matching the bit patterns
that existing amd v2 iommu code is creating.

It looks to me like the AMD IOMMU manual also says it ignores this bit
in table levels, so it is possibly a little mistake in the existing
code.

I'll make a little patch fixing it and ask them that way..

> > +	 * io_pgtable_v2 sets it
> > +	 */
> > +	entry = X86PAE_FMT_P | X86PAE_FMT_RW | X86PAE_FMT_U | X86PAE_FMT_A |
> 
> What happens with the USER bit for I/O page tables?  Ignored, I assume?

Not ignored, it does stuff. AMD's IOMMU manual says:

 U/S: User/Supervisor. IOMMU uses same meaning as AMD64 processor page tables. 0=access is
 restricted to supervisor level. 1=both user and supervisor access is
 allowed.

 Software Note: For a peripheral not using U/S, software should program
 the bit to signal user mode.  If MMIO Offset 0030h[USSup] = 0, this
 field is ignored

IIRC it also comes out through the ATS replies.

I expect VTD is similar.

Thanks for checking, your remarks in the room at LPC were inspiring
this was the right way to go!

Thanks,
Jason

