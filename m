Return-Path: <kvm+bounces-27572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E35559878DA
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 20:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E546B23C37
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 18:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D50016088F;
	Thu, 26 Sep 2024 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AvMw6Lcb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D027613A24D
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727374104; cv=fail; b=Y6wtVSFI0zjAJCbUj/98n5sh+9zi9M0N0kyeUA7lBEH374PK5ZvF/9zXmJhVqgmd8gEQ45OlBsrzhwqW7hy+qYemJhBodzvaTAgYdASkyPvDqvfZqtQYU8X1Uh4qBI8GzuS05okwMpWvHHXTz0OdF+bOLqrWv4XfrARnxWDtptg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727374104; c=relaxed/simple;
	bh=opNUZbpX3EV84OzymwPmDU5k2IaHNy5G0oznApwUihI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UveAmqh3OyTym9RPrt+UyD8NwDDk4PEW/ZvqCoWcIOYruiDr7JlDKj0sIdV9GLDsz3q6RZjdxpg+QcVeajklQ8MQ7Wl+bKailyMHe4UScCsnKBpJ+rd6ViDXgoMm8XNuMyNSFifPqsU4XFwja9Q3d7kUIKqPmWX/F3LU2+pZveY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AvMw6Lcb; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HvjmcEYgnl7IlMPVUfaRVJJw+4SiQCXxtoPtj6gy/VGEZ7HrKG7La+csOHe28C1TGP0rRM6M61EYZQ9G1hJDfQKkDLlTIEjm8SkYqCFBPuMSLI4CWQQY5sJqLrP3C4y9f5u99pEF4XRsKLBUY52OStIcsCtW9kWbgr2F8wlaJcxqj2/u/xzQVc/yI2XhuYWyBAEer322lEHoRYNPz+EVoFkg78/QJhsKHXbxiQyrJSQ8eIztG00hM4K7Eea6t9qx75fRe8Xrz14KCX+nMMqabTFfo/URrt8s0XoEAr98VDrcO2EUbZyQQt0+1KoxWbE0TNyngnGr6AqvbGHfP0CFPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5iyjnLQkQbG57217JEYmGvWCduuakoy4/wuQiAMsDXY=;
 b=GP7jnLMW/1zgLxsunkbZCMzj4JKQH22cA1yLH7/MV4stmJxBrUV+jFwtjzCtKylbY5noafmNSOdzGI/ZqMAS5xcZETjr/IRRqG9HVZgPiUu2Bl/93paaMXWstIOgWdH607OS7Sq/CptY0eslGRp3Z+8JyxMb37TKx3gEMRMhq4MFggJV1ORMB2VCitH/saMeDFIBPH7J5YAA7P9+kI7c6onv3ifYf6pn14wXg+iij+u0MzxRQvyEx1suoRifE9TlE+kM2fGSjyuLYXZby4raERn5gxEaq0QaopG+DxAWgFhBn81SJrbCUZ0ckqwClwPbZpJn/37Zsj/ixl7m1E8yuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ffwll.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iyjnLQkQbG57217JEYmGvWCduuakoy4/wuQiAMsDXY=;
 b=AvMw6Lcbwlyy99EpjbgIFwxUzNGcDy7TCYHlThxOfDzRVdyNFXMw4ucyjLR3IxdTy+wMLuOz8pjBMI83d7aLUxSFdKwxMJkrXCSbyBRzJy8E1qqnF1MYXIw/zJGw6sWLN+HfHLZzCFULBNh5B05Ir/4x3mpJbj3P163IiB0iUefa+lOFHEG82/lW6EPyE4uqd8oPEcn2u+wKOzLJtU9bKxAYVAR+a8t66CHG1xMOoDJ2tSk57tTiRaUMssWqHEiMSGA6caMUXT+p7irzXXdnCVDeNDZC6nNIRhzbIl7gJAYZ8La0AT+i8yW2zWZ3Co/tYV1afe85mAkBG60CyYEW4w==
Received: from SJ0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:a03:331::29)
 by DM4PR12MB5963.namprd12.prod.outlook.com (2603:10b6:8:6a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.29; Thu, 26 Sep 2024 18:08:16 +0000
Received: from SJ5PEPF000001D0.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::3f) by SJ0PR03CA0084.outlook.office365.com
 (2603:10b6:a03:331::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.22 via Frontend
 Transport; Thu, 26 Sep 2024 18:08:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D0.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.15 via Frontend Transport; Thu, 26 Sep 2024 18:08:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 26 Sep
 2024 11:08:02 -0700
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 26 Sep
 2024 11:08:02 -0700
Date: Thu, 26 Sep 2024 11:07:56 -0700
From: Andy Ritger <aritger@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Danilo Krummrich <dakr@kernel.org>,
	Zhi Wang <zhiw@nvidia.com>, <kvm@vger.kernel.org>,
	<nouveau@lists.freedesktop.org>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiwang@kernel.org>
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <ZvWi_NawH9zzznzi@bartok.localdomain>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
 <20240926124239.GX9417@nvidia.com>
 <2024092619-unglazed-actress-0a0f@gregkh>
 <20240926144057.GZ9417@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240926144057.GZ9417@nvidia.com>
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D0:EE_|DM4PR12MB5963:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b42b470-078d-49cc-505c-08dcde5631fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aCT5KBqHDlgav5dEM9ZLiFoXGIXRURjee+EOWdvQW9zzgeUtDtMs16BSXrFK?=
 =?us-ascii?Q?y7y9MqvjRe4ZXd37jOSaohoJPm0N3oDw4gtyG6ww5TbxoNPjkKtu6uolPUAk?=
 =?us-ascii?Q?iovwWlKei77ot/XQjZy1up+VjcCwi4/W79kcXkeahEjiaKQY3DveyHSu+h5q?=
 =?us-ascii?Q?t2at5xhmAyfZonvwZbTz2lGmrVA9T3ShxcDVzwddFiwvMUBfM5GN+V9Ghr/H?=
 =?us-ascii?Q?d45JXRfI/d3IsunpKJOahJe2kxLhCidq+FIBDCyP8097FTDphA0wyWKrpc1A?=
 =?us-ascii?Q?DlWTOno83XLbyxuuiF2tehYsWXZw2uUOIUh8St6VYBeLwRvnph2JdyaYSUCn?=
 =?us-ascii?Q?CCfbp4SPwAfe2W4M0H9kJTuVEqqFsrMCvnVXgQTWR5DCUqVzvtx8AWt5pKhB?=
 =?us-ascii?Q?vlTaGcmU2K9kZBa8HCi5vIZv4w38nMZe78FB9AXhhccUgX+tgiuBMG3gxSDn?=
 =?us-ascii?Q?TiyW/dCsxcG3j/54KepKhjJL8U3HeWAOD1fdrdXpdQQRaXkujNi5glXEnGaD?=
 =?us-ascii?Q?EJzAVAx2mo16I0t6K87wFektd0l6UPc2RWPRNIKeTnKRWUxT3bNUg/ZCzHWw?=
 =?us-ascii?Q?oOurkKVHWmHMvOan4iOEaMCJJgouuv/COKj4/raziRXL0Jn354C6gfKcySzk?=
 =?us-ascii?Q?n1O7Wshq9AI567nlGYqnYNCJ7aW1UxLwQLFkJWgmrhvu6nwLQ6dakXeEyYSm?=
 =?us-ascii?Q?dE4aE5OQiLCEgAeWKbN5DjiCrbGpe0YT47MoYrhQnhyQNOvHl8Cyg4FMHrQz?=
 =?us-ascii?Q?B74Rtqey6UA6WWPaoVXsgJLX+I1LPMC8dXXQoQ10l9rJBDaCJOe+Ay0MQAKj?=
 =?us-ascii?Q?cLhTqXqJjoYDZH2wWofLc3bMwZlSoevCMkEhG+j38TEDBZ7PmoiD0RCMyfHS?=
 =?us-ascii?Q?NwrVmvqqit9Z2KXJkHJ3R5x1cp2zbYPceAqivAKx7WLsgcXyZ/k5xDcTF/sH?=
 =?us-ascii?Q?NOhPXTwo2PvxPr+HY9M+M4rUW2CevHqPWITzrBBYQLKXxRve3CogdNKqDRsy?=
 =?us-ascii?Q?fzDMjS7sxXTy9HH5zjchVrRqjwQIC6MsaP31AEDZN85xDUU4jBA0d7pDYA9d?=
 =?us-ascii?Q?0qTNpPR1M7rPuUcJrdXWCazpe5NffzKRv+Pxqzp+k6cC16oEYdctlKs59Izv?=
 =?us-ascii?Q?4z1lidQ9YABdY+7CTdUc+h2fE1ReNdtAQXoAU74r50ohlw3zYk/aCaalxgg6?=
 =?us-ascii?Q?IjN9TMtcHpsatEeopzdleVBAceXggu+kMgxkL9YxcG5GiA6wOvlJAr3qUnaZ?=
 =?us-ascii?Q?rDXFTNLVWy8IBzk3Pk3I7+c3W+dV3bMadxplJp2OK4A4hMBIAr43itkZ+Ez7?=
 =?us-ascii?Q?iTQaOK1L11hUIwPXaj1HAgzRGMLfU8tKyYQ+WdiXcKfxDrfhn4N0t3hFiDWJ?=
 =?us-ascii?Q?xp2E0ctDecTcJ2ng1kn+c7BXpgdOuGqfNRGxDEPgBw/g+UIiiHYcahCAhCVn?=
 =?us-ascii?Q?Iovj3IlGAooPxo2W67OWmz3luVlFW+u2?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 18:08:16.4934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b42b470-078d-49cc-505c-08dcde5631fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5963


I hope and expect the nova and vgpu_mgr efforts to ultimately converge.

First, for the fw ABI debacle: yes, it is unfortunate that we still don't
have a stable ABI from GSP.  We /are/ working on it, though there isn't
anything to show, yet.  FWIW, I expect the end result will be a much
simpler interface than what is there today, and a stable interface that
NVIDIA can guarantee.

But, for now, we have a timing problem like Jason described:

- We have customers eager for upstream vfio support in the near term,
  and that seems like something NVIDIA can develop/contribute/maintain in
  the near term, as an incremental step forward.

- Nova is still early in its development, relative to nouveau/nvkm.

- From NVIDIA's perspective, we're nervous about the backportability of
  rust-based components to enterprise kernels in the near term.

- The stable GSP ABI is not going to be ready in the near term.


I agree with what Dave said in one of the forks of this thread, in the context of
NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS:

> The GSP firmware interfaces are not guaranteed stable. Exposing these
> interfaces outside the nvkm core is unacceptable, as otherwise we
> would have to adapt the whole kernel depending on the loaded firmware.
>
> You cannot use any nvidia sdk headers, these all have to be abstracted
> behind things that have no bearing on the API.

Agreed.  Though not infinitely scalable, and not
as clean as in rust, it seems possible to abstract
NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS behind
a C-implemented abstraction layer in nvkm, at least for the short term.

Is there a potential compromise where vgpu_mgr starts its life with a
dependency on nvkm, and as things mature we migrate it to instead depend
on nova?


On Thu, Sep 26, 2024 at 11:40:57AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 26, 2024 at 02:54:38PM +0200, Greg KH wrote:
> 
> > That's fine, but again, do NOT make design decisions based on what you
> > can, and can not, feel you can slide by one of these companies to get it
> > into their old kernels.  That's what I take objection to here.
> 
> It is not slide by. It is a recognition that participating in the
> community gives everyone value. If you excessively deny value from one
> side they will have no reason to participate.
> 
> In this case the value is that, with enough light work, the
> kernel-fork community can deploy this code to their users. This has
> been the accepted bargin for a long time now.
> 
> There is a great big question mark over Rust regarding what impact it
> actually has on this dynamic. It is definitely not just backport a few
> hundred upstream patches. There is clearly new upstream development
> work needed still - arch support being a very obvious one.
> 
> > Also always remember please, that the % of overall Linux kernel
> > installs, even counting out Android and embedded, is VERY tiny for these
> > companies.  The huge % overall is doing the "right thing" by using
> > upstream kernels.  And with the laws in place now that % is only going
> > to grow and those older kernels will rightfully fall away into even
> > smaller %.
> 
> Who is "doing the right thing"? That is not what I see, we sell
> server HW to *everyone*. There are a couple sites that are "near"
> upstream, but that is not too common. Everyone is running some kind of
> kernel fork.
> 
> I dislike this generalization you do with % of users. Almost 100% of
> NVIDIA server HW are running forks. I would estimate around 10% is
> above a 6.0 baseline. It is not tiny either, NVIDIA sold like $60B of
> server HW running Linux last year with this kind of demographic. So
> did Intel, AMD, etc.
> 
> I would not describe this as "VERY tiny". Maybe you mean RHEL-alike
> specifically, and yes, they are a diminishing install share. However,
> the hyperscale companies more than make up for that with their
> internal secret proprietary forks :(
> 
> > > Otherwise, let's slow down here. Nova is still years away from being
> > > finished. Nouveau is the in-tree driver for this HW. This series
> > > improves on Nouveau. We are definitely not at the point of refusing
> > > new code because it is not writte in Rust, RIGHT?
> > 
> > No, I do object to "we are ignoring the driver being proposed by the
> > developers involved for this hardware by adding to the old one instead"
> > which it seems like is happening here.
> 
> That is too harsh. We've consistently taken a community position that
> OOT stuff doesn't matter, and yes that includes OOT stuff that people
> we trust and respect are working on. Until it is ready for submission,
> and ideally merged, it is an unknown quantity. Good well meaning
> people routinely drop their projects, good projects run into
> unexpected roadblocks, and life happens.
> 
> Nova is not being ignored, there is dialog, and yes some disagreement.
> 
> Again, nobody here is talking about disrupting Nova. We just want to
> keep going as-is until we can all agree together it is ready to make a
> change.
> 
> Jason

