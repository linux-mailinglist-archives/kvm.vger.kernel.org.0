Return-Path: <kvm+bounces-27400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA75D9850A3
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 03:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F53728496C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 01:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840EE147C9B;
	Wed, 25 Sep 2024 01:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kcIAmoM2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B85146A7B
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 01:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727227781; cv=fail; b=amMnEmODm8YHuA7Hz8ERCqFq90iTVYtMvWdnA/m6ydsHa4lePRa19JfTKbknWiRFUNnzfA8aJmZIgQ8lUrd/vNHshJV1jI8gHNpM9jI4++F4kLa/Pv7E2/4qdQvrK19JjIpWMdJF0g+V9w6IPCiim3syJNkzhA5eG/QOhYPYjhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727227781; c=relaxed/simple;
	bh=cWIG60wOW1C8Op4FbleZjgTRCCqrtWULAbx+yGvT++4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GDJlCC3VtOiJ0ykDISXjjWofjSV/1L+ZGACTrBJf5dpg7cbadx2j3n1qJmdG+xw4IGEsNzdYU6Rc8Wk6SUuk2W/1TcoQ4uHAAaWQj5qBWqawVILAnpf3adeLqWsgylQDnbTLVb9NkR5Uh3a6mhsnA00g5eUsZ73dVtfufh2vKSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kcIAmoM2; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DH+evcT+dRmQUsQHoTuwUmFl3qQK1yL8UQJPFMJ7qc6AQNu3GTV0q+m8E4gx3lWFUM24dSlkL1691nEzazmNZ820lHn58mgxemAL8RTQZAcz1BMhZwxxWFOQRP8T9ipXxSVlD9R/kU+l1cPLFItZSg7pTxNU83v62rDSflkKUDzZOXKq7JK997dOhBF1Zg8MI9r6J/NmSpSA9FdJRm7wgiuuZZPFiSpLOroOwthju8xZVtiD0lHi3bmIQ5ELWOfoG9owkxoq0YDtR+k/z8iB32+vSeC20k3yX/m3fmV2cS7NZL4+BUeGlDutbDcOhFnxR9/781oLUJ9qb2yEoDaXUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQGJVTfcfOGukN/wqn42eQkyJSDGVaQxvHsrL8yY1VU=;
 b=R9SHrJrutTjrT3ZFA1JCbYjxfoRjS9gNMbaLgOqMYDHZEtucfwmQ4E6t7AKbEbsREhl+lE0RaA9HygSqcxr7+x4tgnzTQY7Cr5zf/OsVAbhGZ5Iq4j4fRY/voXJJv3UgYrO/pLbqFXVkA6Q+FUYN4I8ewq7/xliQnx/IeX9rra1SKiCUrzrgD/Nn/npKRU9I/XXWm5cE9y6iP/v5rLJclnJqLJMYBgI+36TkU2Tv0z/cK6QAbIkM+1MabfPSWr8Zqu1Cb484DySwPB/EUIhiGduOisNAq0JSmmMq9vWAGVrVnhJcOWU6EDzJPwLj/ek0+O41feGO568J9V9mM1LyGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQGJVTfcfOGukN/wqn42eQkyJSDGVaQxvHsrL8yY1VU=;
 b=kcIAmoM2+dxEcHL4uWhNlgayi9KEzjfj0j/bKO28vSeriFXy3pNoUNJoiPp9Fo2mA4cKRHDZZSMgykHE9ts/cbPf8HXYUThb1H765pzODW+JbsLrtl91709nCyfLgzNSnY+QKfMnFwFmaqSrDgA3T45CNpIeRIzuts/beXBka+B9ryQKj9pp48wwqdDNK5iSVa4GSEx1/ou63jVXHZzDmfku66SjbPah9/sACLWfX2klHE00lMXuH9yIgmKiLbS0bndA5GJNGxsxPzF/w5Tqva5AsMmMMcquUCJlP1rQbDM9fGngMdaaiBhlwlraK3KEdbnShCh6853AA6yyFuMnbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB8593.namprd12.prod.outlook.com (2603:10b6:510:1b1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Wed, 25 Sep
 2024 01:29:37 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 01:29:36 +0000
Date: Tue, 24 Sep 2024 22:29:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240925012935.GQ9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com>
 <ZvMZisyZFO888N0E@cassiopeiae>
 <CAPM=9twKGFV8SA165QufaGUev0tnuHABAi0TMvDQSfa7PJfZaQ@mail.gmail.com>
 <20240924234737.GO9417@nvidia.com>
 <CAPM=9tx+uU=uceg=Zr4N9=Y28j8kHnBVD+J9sf9xkfJ1xtTXEA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tx+uU=uceg=Zr4N9=Y28j8kHnBVD+J9sf9xkfJ1xtTXEA@mail.gmail.com>
X-ClientProxiedBy: MN2PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:208:23d::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB8593:EE_
X-MS-Office365-Filtering-Correlation-Id: 4824a838-e3fe-4412-03fb-08dcdd018458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X6EVdkEv9mCNHUa+cXN99ijoKBMXs1Okj3R0704HoNEBrtRuwK1Wp6Ua4yOZ?=
 =?us-ascii?Q?2+gSujN11f4TxdTu9yIDfTBdBmlrHu5S30rd/OjtUWUN6UT3bgt60BSpkQOu?=
 =?us-ascii?Q?wT+kJPtGg8xqjFjQgg2+pPTivchwN1/HT2/O5l+IH3db5Lhn3gD5RUF8cuFq?=
 =?us-ascii?Q?PzIjYWO7JC6M+REfH5zZ/SKNAY36/GUABxB6sBq7B9Dg0YZ0HelMtsGwL5Qi?=
 =?us-ascii?Q?q9npKFsh77a+cjGawDYGusNeHo1OxSiHBwoQB/tmCb0gEb4x/J8Dxx9svHP/?=
 =?us-ascii?Q?CqkvyGyUt3Lf/02kBlfTVVzd+sv1k4rYMaPWlR9RK49nUkMPOVPSN1nhoeh+?=
 =?us-ascii?Q?hCJEymzHh57RIWpCzdd1K1fdGMniopgdMhx3TYjgyBjguJX2h4bw2vOU4w8S?=
 =?us-ascii?Q?3fG314T/v1CvfiOI0HD/bWt0f2e5gwTAhd269Aa3W+NPWIbv2cBOgoRtLq7f?=
 =?us-ascii?Q?CKw+zM5BZKAF3x0lfh7OKQ99itfocYuRr6CPCP2gd+GyjEfyzt7soWYEOB4W?=
 =?us-ascii?Q?OsQmD3d7UuSyrU4cRVlxaY2XNMfEKV1dfgo/AceH4arJ8pjmsuutUw/SGjid?=
 =?us-ascii?Q?/kN248/Oebv8JlDavoFc+oLg8klomtcUJYjMmQrMCjwQQiDvqMqFBig/Opua?=
 =?us-ascii?Q?AgLnToc0BAOA+QmUSa46JBmqnMKvLlFNrx61IdNR2Y80sNC2BYh/+urWDwOU?=
 =?us-ascii?Q?cvks3GcuGJw1wgWw74Lrah0vH36ZPtEDG7UQzfE9jGTTxnKxZ7x5Ns/sDYBW?=
 =?us-ascii?Q?d/auaQNGBSiObQ1tZEEn5NqMFk+CHTeLPfLtkxNnyaoCS07T65cHmOWIxYeF?=
 =?us-ascii?Q?ouHlWsFZDat4s4uK6GdlHDzV9+nF9JdoizmGcHr6YuN3YczWss/sG9wcnQuj?=
 =?us-ascii?Q?Et9JB2MJnhqX/I5cvQfSqEh2wLLou+4eG1SISvAbOK55cnEWOKV6pDxJ8tzU?=
 =?us-ascii?Q?jiwfKUObdOoVjV9IutVCxc2lOujdRSX2wkZDnQg87Sue26huWGcnokdATePI?=
 =?us-ascii?Q?VQ6hUh2TCFnFBIN76Zl9QWweK3n0guGcV2bcfcJUtNLmYmIme6WdGlbEQ32Z?=
 =?us-ascii?Q?v73YH6Qdphb8ZfJBf5wOUs2HN5hkwY/WWmvJG/SPfqeYcoOkBOm1xyzs+kKY?=
 =?us-ascii?Q?tMg1pV3MwEXoY9hajpPgoEiD7nsKZnpj61FOhstAplbVjKDPiDr18sf42vkJ?=
 =?us-ascii?Q?qlOBa5vVWGPSql23RMHgAYlepVGL8phrGVPsPfOVuTX38E6hejJf+tOne5vh?=
 =?us-ascii?Q?4Ce7JWMFRlQJkDKQQdyFjofu8fq0uvdEyuWYYND5CeRfNhkwFRNwuMAxKjeK?=
 =?us-ascii?Q?HDz4bx3oHi7iRTkyS7XDwIHIUnaPKBKjXmA1SpRMHUbyRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4hEzHtDxfffKlUIbh0PuMF7CgXx0pFV9lNtZbLUkoEZPSDAh2wwdrFpZC38c?=
 =?us-ascii?Q?htKmK5UX3eRfnGoo1Y2WsJdcPLUnEnq2OgcQPxBhOFzlwjKbHQV/Wthk0oPc?=
 =?us-ascii?Q?kn3rPO0e5e/2trsndY8nyAzS5UPGYiXcaTCIRr9UHN1wwtwZJTEEe82YOp5l?=
 =?us-ascii?Q?o7gW/pLd1FEA0kgRedQoKVK46VamHdim7Y9SAGhWZqV8NzcEuD/RpB/ohl1N?=
 =?us-ascii?Q?vqoM9qxw8NKVt0iYy+F2hc7oM0O0IchYh5JoLoXFc5WFLJ5OOk1i6bddtxwM?=
 =?us-ascii?Q?eB5UU1fsVFqWrvO9Uv7Axv4jYYzi2R78YyvA7eGo6khatCNmGpcB3SIgNxQc?=
 =?us-ascii?Q?psSA5q/ie01cNPy//reN8ftzqLgdNT8sIXJlKH0ClPEJFqF+SOm+oOX814AQ?=
 =?us-ascii?Q?XFyb7sFgg3KE/A0dEaKfIdNy4y4MBgurTo4fc/QLCla8eorDCPtdktRRE3P1?=
 =?us-ascii?Q?PSevft5WSk0IT4axEPCl/dX5C+40LaEHOmMoJIVA9gKsnKYvmIHOxRvs9+4G?=
 =?us-ascii?Q?BefbKFVTZqrEqzmXEuvfxW8O6JpWbHszULGzaEZZuXeSmPG/YRy+Fiwo67zU?=
 =?us-ascii?Q?vKyFVRsee56bas4Mf70ObN/vCQkzMIlU3GHfD6liMHxR4vdG/dTQr8DxkHP/?=
 =?us-ascii?Q?T6aGi/LPE1cgJHAMoOzGWFcb+KgaGhT8aeJ8w6WGAarTBP6PZmV/o/ovBKqP?=
 =?us-ascii?Q?kcKG+ArXJfGZZXFDfMm0bVQbILLG4c9o0femR1bcz5Mxm/MyEAYJ3JuGgJFY?=
 =?us-ascii?Q?dkdBEPxvrIaKJVpiin+HitCYnIvls3dnhEMCtl7hhGsBVLCrNQh+/uPwzFu5?=
 =?us-ascii?Q?JsVg6WvqN8G1CioaKj13uKl9KTIrSOBr9EnFGiRUP7nBgkgR6WbgUWYV2Sw7?=
 =?us-ascii?Q?NAjEq7vXouste8Qlruj4VaLAMFKXshaO+TTWUIAopN4CiVut7Al5v1kuJBZR?=
 =?us-ascii?Q?zBnIam1BH5BYZsm1THviAySfYyen3WVP10mK1LUoZ8aF/wum3ofQCmKBY3PW?=
 =?us-ascii?Q?yBzdcdrry9Wyq1YE0lzpl7m6TA4dEpJ91gY/NfxFCC3n4acyLEy/0Mey2ogM?=
 =?us-ascii?Q?sTovK1pjgMXop66tDo/P/NA65+gCNmEad+UX4u8LqMyvoqQUceBoacT7VtCp?=
 =?us-ascii?Q?liBDfO8sDn1foDHLGyVEZPwwfVQE6bHKebvSImJ4FjNsKwuYZobgPkm2/Vg+?=
 =?us-ascii?Q?oGpjQ154zughLHJOUNbZ0sQnlChoXsh70cBCemDy6tLAHhZt638DmtU8He1O?=
 =?us-ascii?Q?YumAo59JW8RClrox+NDthe1VKeiE/adCpxsCBFDdRws1BVSV7XDQLFn3MrrH?=
 =?us-ascii?Q?KIOi3TKGoZwIDkLvQ8yYIcBwygDIAB1CBHXK0XRU6QekpjtLYgRezg+EMK8x?=
 =?us-ascii?Q?1xC31Mtpy18d4qqQtL5WQXMnzwtvPi6LUC9BID0NvfmggBZSLceTQdtX7oFr?=
 =?us-ascii?Q?WIyiGfHUrVZ0LJrWFo6M0jN6r63eW0KqzN7gl1XOGD5YuPek0UVaXKsNDS2w?=
 =?us-ascii?Q?Ky4L/TJ1HVPRu1pYfHSWNWfy1+33AS6c/Ignl7TApDFDkF+rWiq3qIAsgNQg?=
 =?us-ascii?Q?ALNc5drxyoUiLg6088o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4824a838-e3fe-4412-03fb-08dcdd018458
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 01:29:36.6129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uDraaNHsxeVCqtHfhLir+9e2QcosdlUZ53Ibfd8wUWOtQBnQpzj+ggymjVkPm9pL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8593

On Wed, Sep 25, 2024 at 10:18:44AM +1000, Dave Airlie wrote:

> > ? nova core, meaning nova rust, meaning vfio depends on rust, doesn't
> > seem acceptable ? We need to keep rust isolated to DRM for the
> > foreseeable future. Just need to find a separation that can do that.
> 
> That isn't going to happen, if we start with that as the default
> positioning it won't get us very far.

What do you want me to say to that? We can't have rust in VFIO right
now, we don't have that luxury. This is just a fact, I can't change
it.

If you say upstream has to be rust then there just won't be upstream
and this will all go OOT and stay as C code. That isn't a good
outcome. Having rust usage actively harm participation in the kernel
seems like the exact opposite of the consensus of the maintainer
summit.

> The core has to be rust, because NVIDIA has an unstable firmware API.
> The unstable firmware API isn't some command marshalling, it's deep
> down into the depths of it, like memory sizing requirements, base
> message queue layout and encoding, firmware init procedures.

I get the feeling the vast majorty of the work, and primary rust
benefit, lies in the command marshalling.

If the init *procedures* change, for instance, you are going to have to
write branches no matter what language you use.

I don't know, it is just a suggestion to consider.

> Now there are maybe some on/off ramps we can use here that might
> provide some solutions to bridge the gap. Using rust in the kernel has
> various levels, which we currently tie into one place, but if we
> consider different longer term progressions it might be possible to
> start with some rust that is easier to backport than other rust might
> be etc.

That seems to be entirely unexplored territory. Certainly if the
backporting can be shown to be solved then I have much less objection
to having VFIO depend on rust.

This is part of why I suggested that a rust core driver could expose
the C APIs that VFIO needs with a kconfig switch. Then people can
experiment and give feedback on what backporting this rust stuff is
actually like. That would be valuable for everyone I think. Especially
if the feedback is that backporting is no problem.

Yes we have duplication while that is ongoing, but I think that is
inevitable, and at least everyone could agree to the duplication and I
expect NVIDIA would sign up to maintain the C VFIO stack top to
bottom.

> The end result though is to have nova core and nova drm in rust, that
> is the decision upstream made 6-12 months ago, I don't see any of the
> initial reasons for using rust have been invalidated or removed that
> warrant revisiting that decision.

Never said they did, but your decision to use Rust in Nova does not
automatically mean a decision to use Rust in VFIO, and now we have a
new requirement to couple the two together. It still must be resolved
satisfactorily.

Jason

