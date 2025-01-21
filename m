Return-Path: <kvm+bounces-36173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 448A5A18326
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A4E31668CA
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079F71F55F3;
	Tue, 21 Jan 2025 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BERKQF8u"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990021F238E;
	Tue, 21 Jan 2025 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737481390; cv=fail; b=cxiaallMTRqrQf+zVtejIv8xFnBqpqJIN/CpxiVJnHdoFTTx7QBwB+LE0v9EhjMVi6MOptFshPIz/aG6g2lPgjcia5TAnc+XBgTluXEEXeyEG91RnTbdB3xeBJvp5WVNE5SiiVh40uvcYxLmCUkgUKAPAEbmCYoOC8E89rIwQIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737481390; c=relaxed/simple;
	bh=6rvkY5t6OQnz5nPGYCCFoZtc+mcDypCBNjvJQGpwguE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ig2Qk+zA2TGq4mJFM0BjEXVl3uD681LtUk3t0MsiSwiVLvg/5QpFydvBqitCQmBZZ/LBOqy0KED9feunpL1cnlO5cdremXJC4MY0QlG64BCFUP6KCIFXnn0q6thsqwWAng6ZOHyHnMIF0gqMgUXTaJuX2r+9VbCTeCtQ5DkSlxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BERKQF8u; arc=fail smtp.client-ip=40.107.237.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHffL1pxgrliuaS0Wmt+O4gBpLMRqr7Na4c4YiS7CVdLrEns+3tDNq4JQNY9rbVjhZ7yv7I9Fp7wODnvSwfmgw/zMOE5TQECcDciZ+EdCX0/V9Ja+kHIuGCZ18YuFfD2KvGpVfRvo1zJ4FY5vObg0a46YI7XAmq+gciSMGxpzF+zaLvPMnjO3TQkpG47+5HCKgFjWHxwACqibg9P29X+pm8UT/RaderAUE2gDSXei91bNYSdzLxss6BcPpxiK03uw1xpZE6Ow11+CSARsl1h2h/cHGD+2HSzhalzQeLFPoKmBeq0fN5h6sU/bMyv8gcNdhGQYjRw8V+Sv9NxOO+yoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rvkY5t6OQnz5nPGYCCFoZtc+mcDypCBNjvJQGpwguE=;
 b=VnGhMPA+Uolcjr1B+QHowvPR4MtH5BVClPT2DsHonhwpgtd6/ZGMzm1HAaP8BT6YJIdGGjt7iIGhELmgxYthClkgRcjm8Yt+mm9JS8SuZgI/WxMexePKJ0KQMFD3MpUhIxtUSxAukZF3b0s0NCGTUcIMTru+O0wHNt/sI6TIuBk5wNtg4oLce0Oj1h/VCmM+5NLAMiA6/YicXAixpFBCD7fDz1aKR+DCvKd3zI5uc7E69hHAipO4Px2F11MKtyEx13F56w5WcTGf36kxvFpshb1Yc4WhKRBjFkNKALgzjq+xNzpS+bSMTTn+HMTjmsphf8+2GUhmhUgyGHv52Al+sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rvkY5t6OQnz5nPGYCCFoZtc+mcDypCBNjvJQGpwguE=;
 b=BERKQF8u1XkBcEkN3qd9Pg2u+I23cUUdZisXjF4TiL9ZnYtNJoLAqpAuy67/rjwx2UmEIDAT/gyVBIUVF2cXwknXdmEGqMcAZOrHPfgrItDQCVipCkvdOGbs3ChYDxIy7bzGbFD5OF2NlTgjO4gOxMY8SWn3xzgYHUgKsvOmRbJlDfBEAC7ruryRcXZkCXDdXuav0IvUwdE1TcuCcxtamEH04cx5XfE63i9AbzdlqtkBufezHdcRUJXi5wRxud9bX5sOBgk5BVTrkDLMIZywdLTwiDf6oO4p93mTuZCu/igO/TigpoLUbpuVtWENOinxJfyyM+peTjaizaifqxdR0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6211.namprd12.prod.outlook.com (2603:10b6:208:3e5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Tue, 21 Jan
 2025 17:43:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Tue, 21 Jan 2025
 17:43:04 +0000
Date: Tue, 21 Jan 2025 13:43:03 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <20250121174303.GV5556@nvidia.com>
References: <20250113164935.GP5556@nvidia.com>
 <ZnDGqww5SLbVD6ET@yilunxu-OptiPlex-7050>
 <20250114133553.GB5556@nvidia.com>
 <17cd9b77-4620-4883-9a6a-8d1cab822c88@amd.com>
 <20250115130102.GM5556@nvidia.com>
 <f1ac048f-64b1-4343-ab86-ad98c24a44f5@linux.intel.com>
 <20250117132523.GA5556@nvidia.com>
 <Znh+uTMe/wX2RIJm@yilunxu-OptiPlex-7050>
 <20250120132525.GH5556@nvidia.com>
 <ZnnhKtA2n4s1CLyf@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnnhKtA2n4s1CLyf@yilunxu-OptiPlex-7050>
X-ClientProxiedBy: BN9PR03CA0183.namprd03.prod.outlook.com
 (2603:10b6:408:f9::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: fba5816b-c9d8-4686-b9db-08dd3a430eac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k0VDEF9fkXi38haXvXT004b2K2Y+HymDFcOJoH6W+iFQpY6di2d4Zirh4B1X?=
 =?us-ascii?Q?EKurN//hEmvJBLJad4WTjwdWUk/fuWp+hEMwgQ7rU03PqPhf9lSEcRRxuIGQ?=
 =?us-ascii?Q?MESocFvF0zczA1ICx9fYxgujqew612zsbDHxNfkD/2PDZay3PdmnyQa0AM2q?=
 =?us-ascii?Q?N1BBGn46SyZ7T1CP/IYRkVIA+l1IKLSyrlc7yUjHcQoGF2BEydIspm4Q3u1b?=
 =?us-ascii?Q?JGatP/nJUShYfCCbcHZA0j58eEN7uuRinWJnPYgGhZhhFRghwrQ6vsmuNjSS?=
 =?us-ascii?Q?08jVeozV2kACRYNno8O3Gw4eWWqLacUrqt/X24dv/ElIwJMoR3mT1A4dBol4?=
 =?us-ascii?Q?IRDrMX7P79nobTdVJP5O5smxUctbmPfOD5OFVYk/akiW4WqQvzvYzyG9y1vC?=
 =?us-ascii?Q?MJO2V1FadyGglExsHmhC41n+kbs+MfPqxglLNCz4AvfrDCtDN+pgwWUnXsDq?=
 =?us-ascii?Q?ci58ZvN8sJTys8lye3I37neJ6ZZM8KH09oVCwVsWNg8u85BW/ZgBtYxL1N/4?=
 =?us-ascii?Q?wIJs6mANAOFY7wnNvSwiS4/+HJ/39ay6O1Wm39QI+Sfav6M78frlWoaYA70A?=
 =?us-ascii?Q?xSf2D+/ClcGnyZRe7+olTqS56bRYzunT6X60oI5YoXUj8u5+LRrpXNCohYTc?=
 =?us-ascii?Q?dzuMfIdBanQXJATYq0bXSnEL0mFXaRiq22Cz4xZDhskCFO7RRBmxtc4nj9bL?=
 =?us-ascii?Q?yVcSkMBvwwyTrV5664AIOb35a5kVSMqC3cQ58x65533qVvc2vgr3gVrWyTr6?=
 =?us-ascii?Q?2a1U/KiC1OmigQ0uKS5dn6s8i+iik2ubWUbQMshG3ExPbASf/TNbSY+WKDBh?=
 =?us-ascii?Q?ErC6l9sEyGQSqoUozgib8UPVIFAEBBx2ghBSNESkzpzXS7JUali8H1V5szEy?=
 =?us-ascii?Q?MlMLt+vXH7V3+8eNn3mO44UrfVZzNZEv2215yUx8PieRlurUgvrk0oAxx17u?=
 =?us-ascii?Q?YRajyYc0F07Kec88HvAhVC0olfUBXUc931zr/vo8PHhQWmsNJsRRmJmDTV39?=
 =?us-ascii?Q?ZQh6lZCcedknLFhHLGp3sNTsrepHrBViIJ4LcOWisNfFBKn4lFBQ3DM0U5WK?=
 =?us-ascii?Q?hDTZoI7r5Ql2CxnUP83UfeBBiK/8yX19FFHyuo+ob2FNf1DDFEtcRSVEIvy7?=
 =?us-ascii?Q?fw8ElySNA+PI0R3Dpm0RED9spsGjQ0kZpMnqO2v1lxpmlH3oCiGJx/GZMXk1?=
 =?us-ascii?Q?7PtnW24j1+CYZsgIR1Q9kSudNbCsBWvQSm0jEccDylL4OBJxAOOdg1J/LOz3?=
 =?us-ascii?Q?+Iz3wRwkqlrIR7f3PGO/viRpdO5qkuoZb56BZv57tz1K4gVbUroGshF66Fij?=
 =?us-ascii?Q?SQJWuo6GgLx14L7T8eLg1Y6e2u9gSvST9vmLQYhl9KIHT8f2MYVYd0T4oWHt?=
 =?us-ascii?Q?wKPK+gVZFgsydC7M+C5nNojUX18x?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vx6Kitf06gHKibfDf8CQP63uqW4MRF0Lgs4z2uIxYyQanMZZTWKEVzGJ5g5f?=
 =?us-ascii?Q?JRXosuHCxYtq9F6+2rpewOtzwgd6yaHhRzG0kH7J54u/rdOrnp6+1Cq0IFbU?=
 =?us-ascii?Q?5XWwoplK2vydGQMhp/EpEsCrFhjHtjiveRd4pKAkOM/aPkk+UsW7sbsl6daz?=
 =?us-ascii?Q?rJ8mJLwPFOQECjM5GM4SlEIiuaHeA6gm+Uvhsoq7SPr4WmS9S/6iKhJ2NEhz?=
 =?us-ascii?Q?gOtlTgaRVEIYMj4skW0t6se995x/ELeEwPybXmCg0m396iuQ5ndgJ7bXxbEc?=
 =?us-ascii?Q?omCYWkIxV0VGa4UsjYYJaKGsbl6iZ76IBkq+mbETCqqH+BvwCW5gcmLfPH8c?=
 =?us-ascii?Q?cSnnPggS97li5nuPzZODQ2aIglHvzSvE2ZWSPTQguDIgC09DDvorG+SwvCPY?=
 =?us-ascii?Q?+js7R5JMBmvqaIPx3uR3YDUdCrphhPFsXV15R6o90EXDUuRlcvRybaUscm/H?=
 =?us-ascii?Q?LczHx4XyB4S1JeXMBlOsKoBw9a3qS4kgz48ilEUfFUwOoR7H/oRMOvUTqEzJ?=
 =?us-ascii?Q?xkhde5KtkORNV2ay3hx7Kb9eRAe+LdO7FVMQ+9DzGEwzVlaW4Jv2e9cCxjzv?=
 =?us-ascii?Q?Hry1LyfKGkBiSQ7EMxzZ6BHYmlCK2f4hNDd02F9s8MkELtDT51rgOTxB0Djy?=
 =?us-ascii?Q?R8Cjz297dlUg6CALtcLIJIeZUT4ITPbUPZi/4DF63JwyntovO2hEO2car/fc?=
 =?us-ascii?Q?sn7jh8Jjx1kf/7BEYpGPPq4DOvtMEJQVQcdR7jI8wkftFasX991FOVtRDvfV?=
 =?us-ascii?Q?FRvohYUSU42v6MHnBazfkZ3dVdIk1XpxPUNYoeOC2LACpE1kQWaDTAURdrjn?=
 =?us-ascii?Q?hDlsmMEvKtl2nJ5Uz2ULfiGrnZYmHhRltXotDmK0rfGZzREw4xAH6BzmRZNh?=
 =?us-ascii?Q?Xtsy+tAB5Tqzlgci+NOm0hyVhHhFbhdTgiVLFk7cGhpyeL1YYqe/r1QF1zOQ?=
 =?us-ascii?Q?DDouyaFa68l4HZ3aRRG7v5EaDiDpNzC75YUiif40qgTRB6vhTddV0j05goqI?=
 =?us-ascii?Q?2wkoppL1qkgBRcn6nUYhbTo+A7+sCpSEIJkdsBImgyfzMFw2BrrpG8+zYjJB?=
 =?us-ascii?Q?i5nQ2hazsXfxsSyUtLCkeb2qTOSlPYRR2tdAqJ09EnLZnaMoBs/+1r8gYFJk?=
 =?us-ascii?Q?TUIZQhUzvqKxTREGJJE7Mrf9GIiF30XRiEKR5y68VTIwyK9uejWFOyQSt07b?=
 =?us-ascii?Q?EZpqW1WD2OD6FzTSNsuMMQ58qkJEfrTIsVyQ7VB+D7hOgnKAOEtRIUyiJn4R?=
 =?us-ascii?Q?aOw94o1uFMHwRGbOJjhkmlb9Xrf7e7nAQWJDkG3CjhRWbgpEXG4cIrzuwfCc?=
 =?us-ascii?Q?99grj55BJV6EUgakn50IpukvAPpLxg+sxetDAG6NJqwI4TnaNFvIvXIcaTK6?=
 =?us-ascii?Q?7NySmxq88GTg++mYXVpUjTktBkZoI0G9gNpK3QQNhJSFUQnb5+EpCz0rfYJm?=
 =?us-ascii?Q?fF1qfsJNdN0DPHcVInuZ5TEjz8anJ4mrENGoikLY+bYKwKR2KDz6cw+7pstx?=
 =?us-ascii?Q?2kAT+RYvCJt2VjB3NDdP3qkO/0DGItypqEXoj2ZT3IUvj+dz0cjQ2+KKa63S?=
 =?us-ascii?Q?rFpm7AjWjWp/07bTocuheiII7kO5nLBEa/nyi84u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba5816b-c9d8-4686-b9db-08dd3a430eac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 17:43:04.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKB7e6v1VNhKlay9rvO4ECxsBOha+Ir5rzRNTRdLDrbicz6OVfETobZ5bK86jKgN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6211

On Tue, Jun 25, 2024 at 05:12:10AM +0800, Xu Yilun wrote:

> When VFIO works as a TEE user in VM, it means an attester (e.g. PCI
> subsystem) has already moved the device to RUN state. So VFIO & DPDK
> are all TEE users, no need to manipulate TDISP state between them.
> AFAICS, this is the most preferred TIO usage in CoCo-VM.

No, unfortunately. Part of the motivation to have the devices be
unlocked when the VM starts is because there is an expectation that a
driver in the VM will need to do untrusted operations to boot up the
device before it can be switched to the run state.

So any vfio use case needs to imagine that VFIO starts with an
untrusted device, does stuff to it, then pushes everything through to
run. The exact mirror as what a kernel driver should be able to do.

How exactly all this very complex stuff works, I have no idea, but
this is what I've understood is the target. :\

Jason

