Return-Path: <kvm+bounces-27461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70520986399
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9221D1C253C5
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 15:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A746208D1;
	Wed, 25 Sep 2024 15:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KO1Sq+U1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EF11D5AA0
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727278088; cv=fail; b=KfU9CTYd0mAj2wpfP6YjpL53FR4HdS2h3TAebLy9s5TAnA+zgLrGr6JkqGhIVA0eqPIXokU0hqb3tVGuUkiu4MkzHBb9gY6d8l4APs7Qu0Ik3z1erAFTLeRP0L84kXKqhL5A394V+PZN0NTY05VOo9/fddIXmVUTD4QD1/FLMvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727278088; c=relaxed/simple;
	bh=Of2yiiUjOdN7xrtjlmYRpGiJEM/sy58I15JJQNmYoCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L1kbBZERSelLumglZOYNtle9vmGFwiuqoFI/iU4Q3Vu/RDvmzObciAo27g/bgSrEDXZBqvXb2pxHs7GUR2ZgJFUXrDDJ8kRlxYV6b/e4EEcI3oFgl3x/YFBpo9QnL/+oSsJo5juh9BV/4DIi2zGimE6h/Ve95cVYFYWw85U7x9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KO1Sq+U1; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NR/ZcCul3MgjQgl06GWfpZn0sO7oD/L27zPtCgf3kpdBtP3tmHZh4q3Cao7aZ4sDW31DOaTsDKJ9aqHYzBjvU/RnwcqXLTGKPjA0UYoUKNmgd0Fz0RI6V902n72A4aewpHxmhrf78Ur8Yf70dSgnA68xKobE25ziF5UYsu4C6wbtiSRIiq1J4gGapTe+4vDMF3u3yvY39dmKZoklv+vXe8zpuK5doCChVKsnQDIWuJv9gxeJenNhiIVuytlSXenQgT1QJQ7z6cw9BRhwyfmnFKcU8OrTUaegmk3cBP+gLBp+R58gPghMV250iJceHWwbZvEgB6goXpqGVYv/N9AU6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qV4XbLTRNKVQo1ku3vtsETw9cksulhi3gC+CFh80wg=;
 b=UG62jprqLubBxafhDpW1tIn2ETHIOO+xaPM0y1B2mkutWPs+Zytn4iCronPqbZSVHqDrhY4Dx2KjGdOjsi5IPWG3Ud8jatpg5aLbql/CufUwBHZQNFCyjoM50+bKNKxIbpyOUqUgyMyL5J/QMl3yO9GK6rSDiVQ4XBsLYdiYVjmqB7f5i9EoSw3qUAmhbT9UqOr0wXW2TaXyFe20/jhPNXuSTG/Z4ghfzGcTysdsptRIPDH1rpSDAWiDTd5AgpZkCKtz5BTHjEHoADo8g6uIi4hgEd8CYICfJTfl4J9M+J0SMS4l4qTpV8o6UlK8NGukTzHxg1BlrJd5xY/7fBwNzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qV4XbLTRNKVQo1ku3vtsETw9cksulhi3gC+CFh80wg=;
 b=KO1Sq+U1tcEFREMcqujyzGAeW2qE/Ie8dnieFzgjCflbxqy53zy1vbJc2PgjwCn/OmR4CrhnupL6nbSR/r9iupnyUBTOXdIOycoz9YA0kyUafB3t0x28J6n0oBJKOMrtxNZknDzkvea4qeTVsrTpXDpVKRYCPT558gIFPKZ4OQJSZQEmmhYyE2o8Ux5NDUgPqzg3UvsjmzqBZ7h9wy8XBvMbCurBguGD8t1qOS+V8Et2SMULh2qKrOyWiF0bCb2XeWdMA4iDbmZGMsPbyN13XBtUKp4aC1SiqKOK71SO16wbfymcmg36pqanZT6FTyla//dNr2EnUu3Jq7yUSyQRjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7873.namprd12.prod.outlook.com (2603:10b6:8:142::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Wed, 25 Sep
 2024 15:28:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 15:28:01 +0000
Date: Wed, 25 Sep 2024 12:28:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240925152800.GT9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com>
 <ZvMZisyZFO888N0E@cassiopeiae>
 <20240925005319.GP9417@nvidia.com>
 <CAPM=9txix6tO7B+kRtsNXSVPfLGU4vbfga=pt9yqmszecuEbyw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txix6tO7B+kRtsNXSVPfLGU4vbfga=pt9yqmszecuEbyw@mail.gmail.com>
X-ClientProxiedBy: BN9P221CA0014.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7873:EE_
X-MS-Office365-Filtering-Correlation-Id: d0e8a5fa-5b79-4c0c-5888-08dcdd76a407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kQSzRX7nJaq8jHBo9TjE06gJqd8OS/Ka3ul+s3HsTBnb58sWcQHm3fp9dBhz?=
 =?us-ascii?Q?C9xr4RMy2Gbvvmn80U5gv3svZzJ6DC6PNzephQR165FcuJ7QVa6wmCRBvXFA?=
 =?us-ascii?Q?TN3ZcODawXrBBXrsykfP+uivz0O3QawHZ46xZ1k02Ge3PavPP3xvZf/3Z1DE?=
 =?us-ascii?Q?bmj5PP5nsi2TNrIX4pX8OTwBV55DPskTfvAm96GTRUCzSHZxKEvtvTCF2/lH?=
 =?us-ascii?Q?upw+ueD77Vhqmyq2sGU3dOx2W7xjS0VZb/doFit+s3a+Ys3HXfmWIGhKParR?=
 =?us-ascii?Q?QvlrU92YGcPAmmwX1HLYIn9pBtN4bzDmxtn2zsZ1+8tWMj4vU6uepuCrFeuF?=
 =?us-ascii?Q?DoifYVmR1OpXYIFOA1x2R6QfVz3gFfrKnrt1CbaiQC6zhcUQM9mChXsGnule?=
 =?us-ascii?Q?csWcZaX72H2YbGFPcUsaGoHwGkS4QKnUWGMX8vN+W9wayPdgKKI1XahODNel?=
 =?us-ascii?Q?s99UhcgPzC5Rb/7tRLxgD/TeqZUnfI3iRxkUEH9ntkhIF1yaDX7Aa8rX4sNI?=
 =?us-ascii?Q?m8/QKOBwILY7638U9VOOS8hwjMXZjwGLwisJgelrJZegYguIZhne0r0ThiR5?=
 =?us-ascii?Q?r7o3LMx82qx/SyylN0BP9/cCdM5PbXtY0ACxDpW0w4AmdiZkmlqOxgKUHYKy?=
 =?us-ascii?Q?vsMVfKJjs96aUaTs9DSMANrPkXc6xD3KwJK+5pXPc3H3m/Lvude2ZxwxWEIX?=
 =?us-ascii?Q?0Mj+iH2RMr99OunSprneZA/9otfyYnRdnEj1vku6cU1kHCHjC9eLbmWK0Tnm?=
 =?us-ascii?Q?BADFvuJ/dglJnHXtO8U0dcW2w27rdzYOn1UItnT1xnc4fyn41osFp7uLZJLa?=
 =?us-ascii?Q?exbkIQIQzsNwSHA2APILJGNQ6hd08tDqLQNVhJQTliwwUl/tEGbmD3w2jfWd?=
 =?us-ascii?Q?1Dshvv7zMRdN739REa4SlASrQSr1YC/b/0MYzzejF26nq6/1SlSutJ4BfP3m?=
 =?us-ascii?Q?qxIXAvk7WDxisLsAXPsD0q2xuaHMKohAQYF7+sOXiPg1jmHkDIKvjdudB+hj?=
 =?us-ascii?Q?mxCA313JJQIcoNs5Ty4v+bft33hy29K3EWJhoDqTSocqvqmaMkYafQaZJ9RI?=
 =?us-ascii?Q?HYz/zJmSV+r/cHCj24WJ47tTy+QP6NbydoSWuswhMmjAjlZtmJRjKbQDDe9t?=
 =?us-ascii?Q?fx46msZJKjcx2hyDUGd5b31G/cIEekKnWGKEDQGpVJFMrYaukOEIeddPdR2P?=
 =?us-ascii?Q?peBi3EjaQsL3gOU7Ld57zTJjwcRtpeMLxZn8TLpiUELi4UetKq+AGoEq6NS9?=
 =?us-ascii?Q?UUTItP+LWBf78e681LK+JUzzJSFS+4KnvpfVTCsijQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rB2O1yuzXKI8oLXqXBO+uMKliVxefbacM3OVpiVtdSJ37g3aRnHAYtpgAOFa?=
 =?us-ascii?Q?Yp3TW0h61hMDVV5mFAzvgLo24eg1SPfQOE4IVW8sbeF1iQAbBPRQPz2RPLJG?=
 =?us-ascii?Q?N/VM3xv1+RXEMt1fOUlBHK0aUhnoJ5KH/471s4WNkuItX0fh9/OfSaWlVFIx?=
 =?us-ascii?Q?JxTFXQAprMI1JC8bZy1aTR1ozpRYu4OwkG7Gaj1ec9lfszDASynbuwANx6lF?=
 =?us-ascii?Q?4HJ36ngaLcTdrXVDFM62cGONvmJR5Wi3O+Jp6ESh+jbgpm53E2v9vIkgTwKu?=
 =?us-ascii?Q?GIIJ1Tm9DcBee3FfLmdGPIJFB9M8j7Y2CMep6OzIF2rmkeGiC74beEg7XJoN?=
 =?us-ascii?Q?BdU4hIBxDelVmpAn4FGTa9vi/GTsJ3+13hXxIfKJ/umzK2bb1btsfYJ4E/5f?=
 =?us-ascii?Q?T6Ns8CHe2sCa25tDGR9SPyOsdqNpCRCAGZfvB1wckAbbJ5c0QMb6+JFbkC2S?=
 =?us-ascii?Q?+OpRjeZuSzQMV6JzR+T0YzflOdyOVE5HoQTjvlco7qyGNB2c/9RYUU+JxcO1?=
 =?us-ascii?Q?PWCysCLd0jyFFTtFJjPNTEpAsHjgOdNPrahM/nn6yU/EehfK3ou5G7lMMA14?=
 =?us-ascii?Q?Woq8L4PoJ+eCiD22wxQL8p7NUqXYyrmLb3P9wKokqYN3afZMTSJeRU5q1uHi?=
 =?us-ascii?Q?Izz6nWufXs5RYixoDmFpTSHG7yZM/ftSYmMj5yX1s8wP4hP/QE9QRf6u7mBa?=
 =?us-ascii?Q?QplZEmPa0SxuYf1UovreVq/zP/U24MgGfwxLFs78r5hgfZsQF/HUKYFvWTw/?=
 =?us-ascii?Q?3AS2QvisMmoDYH2KzqXMunsFUNJHrPK72NHs7vv+svTxmH22OSjqETYY0ZaV?=
 =?us-ascii?Q?ux5ofrL7c+2yKivbx2ylZqlX6o+RlppIYHJpl5bxjSEvhjiAGiQwCd9dxU/9?=
 =?us-ascii?Q?u5M1FNaYs8Zy2IWIJi2IOQBCIlvj0YSDjMLdmUE8P/1u1OOor8pkUECQhNKX?=
 =?us-ascii?Q?/ZuVCBHxiJz+rAtrwrVPYZdObb9W1aKpVO6lF/5G0YEBM/iZ7XA66VT2ytcc?=
 =?us-ascii?Q?3eMFdlrP7gaWgjBIqqdIEyCf21IWufTZtrwCerwcv5Y3zzpvV9ITEKni+6gE?=
 =?us-ascii?Q?HD17lqTf3EATIWeHLhFXOare3PMNAaWckDH9oxBpobYLFn+9l7Z4BCIs2nim?=
 =?us-ascii?Q?7hC/8bPuFce5UVRx7xT1TnS6Zy2rckmJbEOPwFAg2mb2ZauC8VPcnuVpJrUn?=
 =?us-ascii?Q?PRvr+GxDaBrRw8A2F4OnR2u/8wYYft+++94M3feMly0A57Tj28TSa97QgvoB?=
 =?us-ascii?Q?vyRKYaUKb+YXGN14ePKp8+s37g4/7mY6EVSDV2uuBvo4ACugCKdwvD4xUTGR?=
 =?us-ascii?Q?BUPmIzFTjcZ67GTdWJWLG8+f5ljdsYGNgqEV1YKhZtzOorx4nDIkKiJpoA6i?=
 =?us-ascii?Q?39D9nBVWR4l0WHLe1Z0JGUxxMlNklM0BYxmwDAaABjBa1bkS/NKKiKsfvd2N?=
 =?us-ascii?Q?eMGS+VTtP2wD+rSVEdGUpHY89bvTvu5upyGzGNMx5mZHRDl4QqYzPZUthqev?=
 =?us-ascii?Q?GQ+8LRpz0nAOIk9qQKB63kzagk28Gl1GIRWPNCT9HDxly0ZmVrp+5TbyzRIO?=
 =?us-ascii?Q?OPPzhSNxjNWtSpW5lJg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e8a5fa-5b79-4c0c-5888-08dcdd76a407
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 15:28:00.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sweOTu5S2LpccBmFazGIrEiyhlCW/k867uFHSYYbedttnsCLN+cW6knegQ68Lrv6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7873

On Wed, Sep 25, 2024 at 11:08:40AM +1000, Dave Airlie wrote:
> On Wed, 25 Sept 2024 at 10:53, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Tue, Sep 24, 2024 at 09:56:58PM +0200, Danilo Krummrich wrote:
> >
> > > Currently - and please correct me if I'm wrong - you make it sound to me as if
> > > you're not willing to respect the decisions that have been taken by Nouveau and
> > > DRM maintainers.
> >
> > I've never said anything about your work, go do Nova, have fun.
> >
> > I'm just not agreeing to being forced into taking Rust dependencies in
> > VFIO because Nova is participating in the Rust Experiment.
> >
> > I think the reasonable answer is to accept some code duplication, or
> > try to consolidate around a small C core. I understad this is
> > different than you may have planned so far for Nova, but all projects
> > are subject to community feedback, especially when faced with new
> > requirements.
> >
> > I think this discussion is getting a little overheated, there is lots
> > of space here for everyone to do their things. Let's not get too
> > excited.
> 
> How do you intend to solve the stable ABI problem caused by the GSP firmware?
> 
> If you haven't got an answer to that, that is reasonable, you can talk
> about VFIO and DRM and who is in charge all you like, but it doesn't
> matter.

I suggest the same answer everyone else building HW in the kernel
operates under. You get to update your driver with your new HW once
per generation.

Not once per FW release, once per generation. That is a similar level
of burden to maintain as most drivers. It is not as good as the
excellence Mellanox does (no SW change for a new HW generation), but
it is still good.

I would apply this logic to Nova as well, no reason to be supporting
random ABI changes coming out every month(s).

> Fundamentally the problem is the unstable API exposure isn't something
> you can build a castle on top of, the nova idea is to use rust to
> solve a fundamental problem with the NVIDIA driver design process
> forces on us (vfio included), 

I firmly believe you can't solve a stable ABI problem with language
features in an OS. The ABI is totally unstable, it will change
semantically, the order and nature of functions you need will
change. New HW will need new behaviors and semantics.

Language support can certainly handle the mindless churn that ideally
shouldn't even be happening in the first place.

The way you solve this is at the root, in the FW. Don't churn
everything. I'm a big believer and supporter of the Mellanox
super-stable approach that has really proven how valuable this concept
is to everyone.

So I agree with you, the extreme unstableness is not OK in upstream,
it needs to slow down a lot to be acceptable. I don't necessarily
agree to Mellanox like gold standard as the bar, but certainly must be
way better than it is now.

FWIW when I discussed the VFIO patches I was given some impression
there would not be high levels of ABI churn on the VFIO side, and that
there was awareness and understanding of this issue on Zhi's side.

Jason

