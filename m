Return-Path: <kvm+bounces-28420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8AC99857E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A38BFB21793
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CF41C3F2E;
	Thu, 10 Oct 2024 12:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DOl/fKsl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3902518FDBE;
	Thu, 10 Oct 2024 12:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728561843; cv=fail; b=V5nykFSqZVICdzIGll0b5erTYa5ceupz1Y3WM08n7QEsEcki2qA0nJg4K8dPQGOLbsoCcfjSNG7B1JBhTWzMarcmZ5VoIuVMLsoKVKlwdgAiGcKh2WQsNU7qaI3H7Q9IlxMBQ0U7Z+/xvCM940KP7Y7cUOhlxh5mi0zo62fqCvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728561843; c=relaxed/simple;
	bh=ueAU24NYW+BI4yK5Skoe/VlHLsPgCV5793lsoyxfdjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q4VibrwGgzYulGl5tPjg7sc6JpE5OVm67H5oEsC3i+PLhN1I4bLutt9yauxSj6aiGyvScxzOaoYjm8lMWU1qfuDOEcl0AxCpncHvn8kV/YhqKxOAEWNY+4lUVcU3YAziw1r7W96f1kqp/sFmW7SESXKz1D32F/V5EqAMvCLQnj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DOl/fKsl; arc=fail smtp.client-ip=40.107.92.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRJSWpS9tKCDBBGxbGSjhxSgK5FBS+QvbbXNoRuZxX1zs+PfOFfqyFuyeh20qYabzgiQfzac6LrAusBosqWe2sX4LvX7HSWmGOjUpQWO/E27j3Ivb9OPB1W9B7K5ikbxb1sTyq4ThaD5TvAaU6OAz2EdhgZCbRbU34VVkAme5T915+AlPj45aDqLVWsUDf9DXIbji19fB72PlGkCN1ZpQPhn2scU36dxMy4oi65R7gnNZIVcbasTD1S44v0MO4BCuZVbbIlTyKOqDvmIYf9A/iCfuIHWr34mBQKAKjDAYIuiUixoBPd/AsumkaJt1OcU7Hdiie7GkqgJsI9RWJQVxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASwVg4VWy0cF8u2/WtUzwqBlpMxK2ae44XN2qqGBR0w=;
 b=JaJFzyBAQwmlkSpokNMRs/3oDfZ/XfpqSRYYsArkMFPKdI6EyRoRwDT9npYhs5vLtgd3ZOMwm8W0Z0mcqeGljT/HlW3IMXc4iRHcFYCJLR82PDWzN4pe5Qw6q+BijgNWF73o9YvUJsoPhGXScPYLxozQs8Un8Q0ohf/2xXMVCeQgVrcOus9CREAgra7nDom3XElkkcAdRGNYKxAlZCo14rlzEtmgdTgBmKogj07WXn7fHe09BudpiWtPa06U2ukohA3wEM1nG8DK/ATNDrDwCY1QIdGXkX4PnYmBbDyvtvEljgVumwdyw99HQrpz6DMS9dUtXcfSNV85KK6of7FkjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASwVg4VWy0cF8u2/WtUzwqBlpMxK2ae44XN2qqGBR0w=;
 b=DOl/fKsl8C2ur1mI76j38qN8dAKuSt02z+t384CLyXGonmsQIeliX85fO4FcdGw/6jiRBgYdmQenxNApRkvzj+P6jLpEB1zBb7vjqZZN6XE01zGRaHRoB1am03sqkr6uB1hpvuUf3aiiFqsP0BwKzXBFZLyY4tgXRHYdwoHQJslmk34r0iliueRUJ4ilsezvBZJeM4m62Gwe63NbBPOOthXf7yv9xR1OXXUNTc3i/kWbbFHnonnJtIYKKWMCW+/FElAHzgmkaKY8mEmI4LzCnW/GeTWOnxzdC2yWJZ+E3Ei+bQOV8EI008Y28qbvspZ7gaSFfngYcKZugOBhnK/eoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4043.namprd12.prod.outlook.com (2603:10b6:5:216::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 10 Oct
 2024 12:03:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 12:03:58 +0000
Date: Thu, 10 Oct 2024 09:03:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Fuad Tabba <tabba@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org,
	hch@infradead.org, rientjes@google.com, jhubbard@nvidia.com,
	fvdl@google.com, hughd@google.com, jthoughton@google.com
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
Message-ID: <20241010120356.GB3394334@nvidia.com>
References: <20241010085930.1546800-1-tabba@google.com>
 <20241010085930.1546800-5-tabba@google.com>
 <i44qkun5ddu3vwli7dxh27je72ywlrb7m5ercjhvprhleapv6x@52dwi3kwp2zx>
 <CA+EHjTwOsbNRN=6ZQ4rAJLhpVNifrtmLLs84q4_kOixghaSHBg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwOsbNRN=6ZQ4rAJLhpVNifrtmLLs84q4_kOixghaSHBg@mail.gmail.com>
X-ClientProxiedBy: LV3P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4043:EE_
X-MS-Office365-Filtering-Correlation-Id: 1211460d-5f6b-455f-b1a3-08dce9239ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N/Wgwvk6KkN37DrpPSM8DScD9YWTiftIYqVGRS80PiZuBacq230GYE6o/uAs?=
 =?us-ascii?Q?doXEdIj+MziPcbTew7yru3DUzqkpYXAduq+eg7AMTbxcBwWjfrP/HiVGVsKq?=
 =?us-ascii?Q?S8fO2WSfRLup8utuBlxlwLaIsWcKVCoUD+cDqHCICv/1KAMNQL7ckHpEs0L/?=
 =?us-ascii?Q?N+R4KKfwd/N5IxfpbiaYFPDBhDn9CjKQgt2iBvoVVS2MyK0TLUWQ/FkLYtFz?=
 =?us-ascii?Q?P3QX+1BSAQG/Dy+ssGaOZ1oQC3pe8AGup7PT/GCpgZ1mEv7DkB9IkMpXCbaF?=
 =?us-ascii?Q?6DSefmggaUL//FRLYlU2/EgVC7Ysx/GLGA+pdyb/Zr2qQLJ7glcTwya/TlZ5?=
 =?us-ascii?Q?1H8NoKdCIIAyrjOIXx/GiIPpc7FWw0St8NMDX8z4K0p5sC4j3jw5dRdgNBI+?=
 =?us-ascii?Q?cxhtC5vwZaxgyou5eeedjW+Xg7BUUnKZUcs1xD/G9WsiK+avDORLgGFVwqLt?=
 =?us-ascii?Q?ex5jPgFnO07W6/7TM6W3iBsSCWsBtgRjppmenAu+4GXsg70yH2rP4cnPEmk/?=
 =?us-ascii?Q?XGPMG5ncIIrZ3Y2hdPY12hyDQMNUErDVCHcnQ8sQWlJA7OpCYQs5Mz+6ukgx?=
 =?us-ascii?Q?tMiPeZv/I54eJco/lE9CdSq+QOZwjwT/5enCmYi3SMgXFy+vOfdhfbxkhdrb?=
 =?us-ascii?Q?b6Y65xTBcTreQFL1w0qFW8aInD4zp1g0HhfpB3aC/r70WMuoxpuHNHdwv8Gz?=
 =?us-ascii?Q?qGJaNqSwrBm0vO913xjXcHDSPhDsTTw2e3o1BBbrUfmsTjRH49hhm6uCvzcr?=
 =?us-ascii?Q?K5E0bWEFsVGDA/vdXcKTbhNBTawv/UqyblP2uzl2HgUhTa1yums7YpMfUaqo?=
 =?us-ascii?Q?bGKp3npMWSc2J7yJdg0XT26ryUXZyKgByXgDyoa3jIl/ukdMg+X5BmOgVewd?=
 =?us-ascii?Q?jkh7QHEGcOMiLEHWB4dyk33+Hjh/Hi1mH4oSNJboSyJoC7KGffdMc+7aoKTD?=
 =?us-ascii?Q?EsIq5GHlXXbrYlnHHzIE59wIYmeeS8kL9D2Ib9eseT+v8GWB59wsYdzJeixR?=
 =?us-ascii?Q?WDOdkv/0nZdT98kDogdtNLr7XB6J3lFK4nttcriqgJxuGBNZhMNV0fFTMyc/?=
 =?us-ascii?Q?L+zY9aQZWbPzV7WZUrfpTW0ut+ULpw9d5OvXDRQ8DTrShYy8gl0NNFdTCF98?=
 =?us-ascii?Q?mVDVPzxVExzjkUpf9ki6dJ7U6/xIZYC2LLilatmjtuzM9BK1K+pM+3u1M8/G?=
 =?us-ascii?Q?iT6vtS57ppA9peZqPNAeR0h4qMxuvs9zpQVSVcXO1M3PkfFClEfftH0mGZVU?=
 =?us-ascii?Q?0SB8FnFFIxgxoRGySvC0RY7OW2LP5aZqY7mqV0P/QQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xQknfLWvTqIjk8fG3D3A289iUhgxDaDm8Us0VJ/xRFhHWXPP8Kui7qkjmx1u?=
 =?us-ascii?Q?5K13ApRnRmMiuAbrRhMy/dgIvaLnHAunQclipHeupXrIkmqJRjwKDc+TEglE?=
 =?us-ascii?Q?Jwt6YDkeHRVpORWJ/5e7zES8U+Fw+zu81ZFnP/054oSGmC9gqHFvOwCybBJf?=
 =?us-ascii?Q?meINMT7PJcjzODG8+akAbqCNmKW0F5Sd5FLEtvDtB7aU6MwtzHpMweq+UuD7?=
 =?us-ascii?Q?S/1Al51reft1G2oZFfZQZYhEkVHi8N914IKcm9MQSZWAwmTwN9sGm8Ng/Ejm?=
 =?us-ascii?Q?HaS4CD0KSI5Nhhk+HPOEirpHpIdnwL1ZSnyTSi6ZyXklerp+C1z3DG+h1GyD?=
 =?us-ascii?Q?Rjg4qIfxZEDZj0PNK9ySoaRIXVpfuMFD31Wv4aJir9gMCUQD8huWioI83Zlr?=
 =?us-ascii?Q?dElFJpGk5B7KFfSwlEmMyy0Bm3PXtpNrfxj/BQkDLl3ctWgQ7deW56u5Gyy8?=
 =?us-ascii?Q?L1+xGXy1ytnhGxSx9df0P3AQXAXUee8NcmEBnp4TNFZyMxRYmUSCr1joXPhS?=
 =?us-ascii?Q?5W/inMC9KRxf6y5TSLgCqwG3aJFJoVeiKgtXRCdtIkWAT5z9WzcbfX7h/dGs?=
 =?us-ascii?Q?z48r6QIH3u0sXEiscQpoJtB00T2ZL/qAc6MiB9zwSLHLRtURDfxS3EIPnZyM?=
 =?us-ascii?Q?KCwbtSC/+lzcG/Qviw1qLx6IdSmyqjxBUliy+rXffNHdEbbDu2XO8b+JxP3m?=
 =?us-ascii?Q?NcbLqGzyPEdSqdIeHtdzZQltS5TFIxmrvIydO1LCrA6RASXKuRgZHWg9mL3j?=
 =?us-ascii?Q?VdOTvSvmF1dl/DBMIdsqrfNzObOgsePiFucqmfFU8Y/01A1fj3yvRWwoPsms?=
 =?us-ascii?Q?aD57T1t6lbJrgFeEAducMh8k7tihAwsoTBIhduKlHaCra4Xvyf0VItX2E+vu?=
 =?us-ascii?Q?MtT3IOUE/CjCEJatCyAy438cxydIBkb3V0h1uQnp65L11SYb7JokA7/X/DtE?=
 =?us-ascii?Q?zmkxfN5Fo0vhD9qQ5pVtPPa5GxYNPKcMQ7A9n764k4Ewhk0/L/qK8vhTafn3?=
 =?us-ascii?Q?0lKURMhVXTxuwUiYgMYQUJ8KonOTvDPAFroaAVR9VlA+4eM7/XwwH1Xi8fSB?=
 =?us-ascii?Q?S6WZLWLa6T5bKEAMt00BAwuHe569gVpCrrjVRSmeMHprsD+jcsPxKQYLFmzT?=
 =?us-ascii?Q?XzYYAAlnakXOybTgmNLC5n6OKyBwgZAtrMOIRyDMjmYRSyBfHYvdYBf+4bPX?=
 =?us-ascii?Q?3ejgRZtTY+feQsJWBfwVIu085J87YsAg3TXeOUA9yK28ykhpkMWg+qEqh0AB?=
 =?us-ascii?Q?UpguRStbfWEPYBziRdXoRXXDU6yvHHxmckuyHjLXb9dnv0ZdKiQZu/ogFlri?=
 =?us-ascii?Q?KZhy6FpQ+vva78DaRWrSBcH/9zRJbnt1A6/1ENkQPkgsZ3yHz22VFpFwc9kw?=
 =?us-ascii?Q?31lwJ1ekoN0EiT1mPknN7lsb54AMw21BhmGdXJFijrWhuH1rC37fuuRFAVuj?=
 =?us-ascii?Q?6aR60vivWhjFibul93/Hb/27MaaA74o7uageT/53UtntwNiN57QrVEr/lHbl?=
 =?us-ascii?Q?w2AROhig5Zh7JCEUXOqNxFWxu/UQ6L8E1XJpbD/AdEXuX0nsE/7hkE2ktCMv?=
 =?us-ascii?Q?ElZtyV3aPCflk+2CHhU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1211460d-5f6b-455f-b1a3-08dce9239ee9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 12:03:58.1817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSt4o2CUHufbY2N4GRoQWvO515ZQow7QsxXX9pe9SOLh/VjYRo2KCFwAkdGdDraM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043

On Thu, Oct 10, 2024 at 11:23:55AM +0100, Fuad Tabba wrote:
> Hi Kirill,
> 
> On Thu, 10 Oct 2024 at 11:14, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >
> > On Thu, Oct 10, 2024 at 09:59:23AM +0100, Fuad Tabba wrote:
> > > +out:
> > > +     if (ret != VM_FAULT_LOCKED) {
> > > +             folio_put(folio);
> > > +             folio_unlock(folio);
> >
> > Hm. Here and in few other places you return reference before unlocking.
> >
> > I think it is safe because nobody can (or can they?) remove the page from
> > pagecache while the page is locked so we have at least one refcount on the
> > folie, but it *looks* like a use-after-free bug.
> >
> > Please follow the usual pattern: _unlock() then _put().
> 
> That is deliberate, since these patches rely on the refcount to check
> whether the host has any mappings, and the folio lock in order not to
> race. It's not that it's not safe to decrement the refcount after
> unlocking, but by doing that i cannot rely on the folio lock to ensure
> that there aren't any races between the code added to check whether a
> folio is mappable, and the code that checks whether the refcount is
> safe. It's a tiny window, but it's there.

That seems very suspicious as the folio lock does not protect the
refcount, and we have things like speculative refcount increments in
GUP.

When we talked at LPC the notion was you could just check if the
refcount was 1 without sleeping or waiting, and somehow deal with !1
cases. Which also means you shouldn't need a lock around the refcount.

Jason

