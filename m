Return-Path: <kvm+bounces-27560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E09AE9873C0
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 14:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AC1C281DC7
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 12:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FAF728DD0;
	Thu, 26 Sep 2024 12:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="quH3fHAa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176A52746D
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 12:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727354565; cv=fail; b=gWqrRNO46FG+zVmRUH2dbKG2uAIHsWsoFZ6pF1xY32irQqrYepqoCo/oj0xYhiR8ylYm0FE3aaKYAZSb9QiUFc6onyK6GreIMXIZ+nncP5Vfa5a1rbjA8c9CPkOeRzVysEgQZPPq1hQQRXPxPTvBAlQa61ivTNziVu2u646/5fY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727354565; c=relaxed/simple;
	bh=9Uqww/wjraMI5Sb03ZgGGa4N4hYus7BPeKnVLIw60AM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eeQDE3QQO139kah18DTI/sdPHbIXlJKjbgSypSSoSvptd926CJg1/ZZyuBZZ6fJsQ+pe5Ok0T4lGkzAy8t2NPtbB8my33tWrQpSAhQVZxQnkpjh5LrBI9du+sb7ky/VNvOYLLit6m6EP9p8W5opkkBANymmREwWg3QzmK6/BVWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=quH3fHAa; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ae1WXpqexCkTgOeL6XkAsDsKBzQPlDg6sQPQJxSQEMiuxXej6a7GX4OFt8HRkhifw9OFaxyycgZW+DomMKKS5CndT6J1aqfgCaFEcEanZiwK3l7bNqWtpTTMCtefyQlSKKQi2vfPDPK68wHxLzjOsidAn0a8MZF7lGlLZIw2NM940yYS+o1tjsMB3VtwnGMFYNCFlik7IfjnsmzKNS4vpN51DrXgi9etc2ULW3XzhAPauvmMg71TvKZWsK6IAF0MCXDPNrWjGCqAAzhSepiNz0FHZ58ARjG+JuynBdcOUuM30JPTYeS09LZMpJ8Jt4Yx92b3G9qsZgV8UCESVWxcyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WqMzVHT0NBb2TpmsOBty7ToGIt+yZhj8M6i9QnvMxI=;
 b=v7xl+G7g2Psg+52XeNUagvzJuVyWVfShvzk69SOoLuf3QMa4WltDXFva/uhX6F0iAnBnOn6icWkHt+/JYtJuzL+HC/QKRaX8KENBiCaHEg0ovFgLqtLNtUONRQX/1LlXo+lfreD8izLkWwUqz3diRZpKzfp8bpV+HRzPsdFnGgM5JoLaq3+eNMwfMsu7LequzjZDwPopvm8q5xr4WDZeW1ud8yKONzWVPGmPm2l9proMW/KYFaEMyx2Mp+QDZOEq5tUedF44MYO8WLSx+DvqTl63wp7DlASiLGgJ2Nz7fFLrSD+GGpTWBC7bJLgB5NHQqh1m70xZgEzRUerhTlvVjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WqMzVHT0NBb2TpmsOBty7ToGIt+yZhj8M6i9QnvMxI=;
 b=quH3fHAa3dSmLI//YanO3AB7/XBcgRJPte1SbN9XPFpTz8fSKxV+g+iadMHzNY867uTTVDxVjkvfhn/mJNhSdPW/BKvv9L/7PiYDhFtWS/WGIMr5m4SZI2fzMQei/7FRdiUueiqd5LwPzDUNYdWkjORMtUvkl5ClZ4lNAurOPxJeYS5EaCgOKB4dL6IFsgaN0gm9tCj28mL0cIZbEo3VeW9kcDCubpA+Pn15D8rGQa8+cymhLSnaIMQhUmc5k2EF1SqCyfRsIoosXQ9AWzgdVqi+gHMSPzHcm1jzHlt4NEk2MO31M2oqLZvr0aqqGrMdxABQvDgTxYVae0nhiB1m0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7334.namprd12.prod.outlook.com (2603:10b6:303:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21; Thu, 26 Sep
 2024 12:42:40 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 12:42:40 +0000
Date: Thu, 26 Sep 2024 09:42:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240926124239.GX9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024092614-fossil-bagful-1d59@gregkh>
X-ClientProxiedBy: BN9PR03CA0537.namprd03.prod.outlook.com
 (2603:10b6:408:131::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7334:EE_
X-MS-Office365-Filtering-Correlation-Id: b69bad9b-cb6c-4073-d905-08dcde28b54b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JQ7tdppvSjMYVD5umqlVgkeOv9jEYwQh5H4/JvS/T4jSqd5QlNnJpXMtSeZO?=
 =?us-ascii?Q?V0CGZVLVyi+53A1iQ75L4F91yCLuVnOyo2+00e1RY+N4lqamRzM/0wsTcsF5?=
 =?us-ascii?Q?r6N7eJUCpcSRR/gMQQEdNuvRFA1550auqonWbbU7Bf1HSNIt1Jmf6qD4qxLx?=
 =?us-ascii?Q?LGwDhvlwNjgG1wtjMLsJGH1pMrTWcxA+fNUamiH/m6aA5HJ9x6y1+fgY/d+J?=
 =?us-ascii?Q?WHrtUs8xtudbWOLmJNnqeavAuEO91WEPLinfFRXfnWE94Cp5MsuZupqW4Nia?=
 =?us-ascii?Q?KKWuGoNcZQ85PNgB8wU4ZdToOR17YLRhPsXmcziXWnt8HXozJ1oC3QHezwEY?=
 =?us-ascii?Q?BANf+mE9C1gwqfOBOg//XZZUVZ49s+TEzbPuLnmcEwOJCRQK0pV2QxcFdjo+?=
 =?us-ascii?Q?DZmRAQtVpgQ8Tqxuy1PoBCWkSOWoZQ6XR4W20PM4YUqmQ1tujK9NuOCyQbaU?=
 =?us-ascii?Q?ZUiG49DiF+Xj2jk3ddi7ysZFgxcQiPs9Ho7dhbUbxdF1jtEAMtgsWCV7j9Mp?=
 =?us-ascii?Q?wTVNFD0gKaHNUvAvmUSq/YyxPIUWjfTG+sQUfdPvG+QacwS6gLnJXfMvX0Fs?=
 =?us-ascii?Q?6nuPOd9FiCP0w7G+GYFIKb0tJXWJ2uDoDi1kqZcHwgM6RIXhM3fnCnevEkuJ?=
 =?us-ascii?Q?ljIVNMGW4u/Ygkdral/xF1l2bGYpocKIe3D9oM1taL0cjkpE196XSuNhB1Q0?=
 =?us-ascii?Q?x0v1VBlFWoqO6E0vmbSclG/CjfryC7ouxlsid9LpIruev5R2125Y0caM0JlS?=
 =?us-ascii?Q?Nb7/ZEUNG5w4S5D7ya72ew6ba135P1tJ7sopEHhFQsUw18vHExPsVItQs5sq?=
 =?us-ascii?Q?UI6n4l+s0dJRrMShVW/Yh92DoDTECXi9IyJQX9eGtmgEbx+WxdWGsdyHdRJZ?=
 =?us-ascii?Q?GJeryiaaB0DhvAO6xumI2BS86hB5vdwQTPmhaufHP0f0Mrf0LYJwbEwTqaU+?=
 =?us-ascii?Q?WQa+AU1khXL1YkEA0RLa3hlyKUG35ZjA3LpKBV1GMoVTZIwJJ2aA1FBA2qv3?=
 =?us-ascii?Q?42FNaXNxpIKftIILH3ApjOvawWi4zsOf3mEghkmBqAzI3JUoqAdwMd++DAkB?=
 =?us-ascii?Q?/Ui2VqxJeRvxmcMNlE+OTaNRULESERcV2p4ZGabRKsdcdfxzWFH3Fnve36Ox?=
 =?us-ascii?Q?lux3KslZ3i/dDnS29R9QhaMZ4sYXa9+cpH5ZfQnhT1C11YPWBv1UgBRZHQTf?=
 =?us-ascii?Q?pIXqj/UVYfItrn/DX/Std+Wh9p4Eo5G+fOCeupdijLaMmEQERZeoSDkYq+GI?=
 =?us-ascii?Q?mQukBrcHebxsBMPmlQRbbHKr0NLavJsxhJ4JNBZDUw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RUryVfjGQt7rVNDCPynGKign3AWxl9Ez92uv/KjE+vP49IvNeadJoTnc0EbV?=
 =?us-ascii?Q?6nqJxQZhFpiFYA4Ljs24FuiZ611T4Gjrqqe/56zNcm2+PpZOwOUVL7E/atTr?=
 =?us-ascii?Q?tzL7OAX5rX4U0DMV2oReooBDAgxjeuS56JtmpCQHyIhlFoWMdwfW8ZwVWsnv?=
 =?us-ascii?Q?XziSOWW9qTB8FdRoSmKzWLGBAASyQGqXY5IWuTxnmEseMEN+JK6DgAS5h6II?=
 =?us-ascii?Q?Xi+OyfmKH3VxwPsouqNx0mLwFeCRiwA8n9UC6pUOeE3FUMQH3RiZsvUDCNpl?=
 =?us-ascii?Q?+9UBFiOJ0ptskCX8bFtsAv/OdN/XJx/Mwupswu1omFliB9haIIKkbTxIY5mP?=
 =?us-ascii?Q?5XoAMb4jkQU3JMjqlZyQISbno0xJKQapC3RwWPvQLuUwVgDCftoYs3IJOvFo?=
 =?us-ascii?Q?4ieccASTAo/8Ier8Lw4sTk3FbCrAN+J2Vj8hYcs7e5ngLHiV1f4sKtXg+h9n?=
 =?us-ascii?Q?231hJLQTj8R6uOkPUu5z+xnf1OITNDTD7gMhkZ2pA1zzJRdGsJfw0HPusi+r?=
 =?us-ascii?Q?ebEkf/S08iJvgp2c8FCXuTzjwMtoExX9s47Y+gk6SiZYU9t6ondXHiQYXrFL?=
 =?us-ascii?Q?stKRoPzANlHKWKo42SlL28kdROIb9RpXvyD4oFoXnrg9jx4nHPSbOXjhr4wG?=
 =?us-ascii?Q?sJSgdsPd/3NRWCXkeYCqI6lM4Mn9eGkcTRYIpXCe9vRKOho5xspJ30n0oZO/?=
 =?us-ascii?Q?5qfSt4yZoaKex0MGurSmWmkzVSDOzqY21rhWd7gLO2PyS2UoCwrufhaozSnz?=
 =?us-ascii?Q?Q1msKkqmuheoZw/8P+6U/BQW82wgpHoUjihdIEqz6aEAOKocHVU6LAo9xqbQ?=
 =?us-ascii?Q?L3Fm3bPIOi85+y4WXFt68kGOUlwG2u4EYTeK1+HoYQwYDX4A207z1WJve9GB?=
 =?us-ascii?Q?JsB2zsVESjJAM5Nr/w82QOPU97SeBl+gpvKuhGjnArHjXI6MdJoRMMfFyMbO?=
 =?us-ascii?Q?IIXpo28KJDSgZFoFfofhrRFVNvApilBGU1DQ/9jxVVoT3gWkiZn1Hk7CNdNk?=
 =?us-ascii?Q?TSRAz/pB9r0Tqsnycw3RpokAGhnj6dir5bEzuS6KKYi3Ky9JrXWHvb7fZiAt?=
 =?us-ascii?Q?wDrGAiUcvPwlSY08Aoh74bpzW4n2JlhL+EA/6jmfDRHhtDGU4Lk06ab9Ambl?=
 =?us-ascii?Q?gEJN4t/TlbhSvuAxO04gmOWqR2PArn98Cm2hl0iOB0WXBqoj8BeVeiVgk8Qz?=
 =?us-ascii?Q?G8dQE+ul0UQOYnFwSocFs84+MGQyY/hus9He8b8PPoabu7OMcH/SfHOxnDtC?=
 =?us-ascii?Q?d2bBFXw41joKLLTmHJ+By0L7OWqDmRon9mdkQkHBJbIXNJnny+d/lHE9Fnpm?=
 =?us-ascii?Q?NZm5ELmqSSRwu7/aooB0eUqno3zXE/om1cNEnYm+VgwZJ6TQyV1iNqS/IAsN?=
 =?us-ascii?Q?iQDgn1fghiq2+eV6p/y6xQY8ho6Mcw8ONsWR3Ho6kcEOVUYdMJdGrYV8WdsL?=
 =?us-ascii?Q?MbjZ5kyRheCeRfA8o/vk40UeDvoCd1nV1em76LAgFnYwfZniT49YE0FuovsA?=
 =?us-ascii?Q?mXH0DsxKc+dJiLPtLMAklw9ybICqA/50Mepq+G4lD0L/TQiUtjvIY3pNaODn?=
 =?us-ascii?Q?PxWRNUCzeXd3FLoW4/I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69bad9b-cb6c-4073-d905-08dcde28b54b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 12:42:40.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jnskpyj1OZmfVcI0Lkf6trsDBxv+ECEniyfQ2QOE0FgqeSxavnXVhp0POv5Sm+2X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7334

On Thu, Sep 26, 2024 at 11:14:27AM +0200, Greg KH wrote:
> On Mon, Sep 23, 2024 at 12:01:40PM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 23, 2024 at 10:49:07AM +0200, Danilo Krummrich wrote:
> > > > 2. Proposal for upstream
> > > > ========================
> > > 
> > > What is the strategy in the mid / long term with this?
> > > 
> > > As you know, we're trying to move to Nova and the blockers with the device /
> > > driver infrastructure have been resolved and we're able to move forward. Besides
> > > that, Dave made great progress on the firmware abstraction side of things.
> > > 
> > > Is this more of a proof of concept? Do you plan to work on Nova in general and
> > > vGPU support for Nova?
> > 
> > This is intended to be a real product that customers would use, it is
> > not a proof of concept. There is alot of demand for this kind of
> > simplified virtualization infrastructure in the host side. The series
> > here is the first attempt at making thin host infrastructure and
> > Zhi/etc are doing it with an upstream-first approach.
> > 
> > >From the VFIO side I would like to see something like this merged in
> > nearish future as it would bring a previously out of tree approach to
> > be fully intree using our modern infrastructure. This is a big win for
> > the VFIO world.
> > 
> > As a commercial product this will be backported extensively to many
> > old kernels and that is harder/impossible if it isn't exclusively in
> > C. So, I think nova needs to co-exist in some way.
> 
> Please never make design decisions based on old ancient commercial
> kernels that have any relevance to upstream kernel development
> today.

Greg, you are being too extreme. Those "ancient commercial kernels"
have a huge relevance to alot of our community because they are the
users that actually run the code we are building and pay for it to be
created. Yes we usually (but not always!) push back on accommodations
upstream, but taking hard dependencies on rust is currently a very
different thing.

> If you care about those kernels, work with the companies that get paid
> to support such things.  Otherwise development upstream would just
> completely stall and never go forward, as you well know.

They seem to be engaged, but upstream rust isn't even done yet. So
what exactly do you expect them to do? Throw out whole architectures
from their products?

I know how things work, I just don't think we are ready to elevate
Rust to the category of decisions where upstream can ignore the
downstream side readiness. In my view the community needs to agree to
remove the experimental status from Rust first.

> As it seems that future support for this hardware is going to be in
> rust, just use those apis going forward and backport the small number of

"those apis" don't even exist yet! There is a big multi-year gap
between when pure upstream would even be ready to put something like
VFIO on top of Nova and Rust and where we are now with this series.

This argument is *way too early*. I'm deeply hoping we never have to
actually have it, that by the time Nova gets merged Rust will be 100%
ready upstream and there will be no issue. Please? Can that happen?

Otherwise, let's slow down here. Nova is still years away from being
finished. Nouveau is the in-tree driver for this HW. This series
improves on Nouveau. We are definitely not at the point of refusing
new code because it is not writte in Rust, RIGHT?

Jason

