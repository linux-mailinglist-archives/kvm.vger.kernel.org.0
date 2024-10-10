Return-Path: <kvm+bounces-28449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A10998A62
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 576F81C238FF
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F72E1CDFBB;
	Thu, 10 Oct 2024 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YlgjIMWI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F266C1A2643;
	Thu, 10 Oct 2024 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728571042; cv=fail; b=m1I/xC9sNkCv5UzIErg/Vdu61OH4MRdm07gZYydOhAPVi7lc9eNzllCFLmoVdghRELq36LuvPveNjSDcSpXtRjemSz6bp065xpY4/9eCSlzTTFhZk7NN8LDHKGyxB6osKQXvOQDShT3/So9tuPZqf/8hPREjlwlQs0uS23y/ylc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728571042; c=relaxed/simple;
	bh=y0BHaFzdLQUYkZ01AlZ0mx4G5GKRBq5h5YS2g18NPps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GbmQMKgGJLiHb8dCFDKq1AVEGFkMBC/ZNzLt7qcPnKVVuVv9JbPes6JC5WLS8YhIMWyfg/bdb6ThGCDaNRiD7O3cKzasdD1yEsow+iKOwGZddoqKkZL6H+yAArUrrOrBtv/Xg7rYuWMNlzs2EhYAktEUqP/PBB0O7oOk2OCICos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YlgjIMWI; arc=fail smtp.client-ip=40.107.237.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTjufZQsul6ZRwxqLuwVoV8uA++tTHE74yR62cvqH6vRCyLr4phCuZhp8kix4PVX3XM17pxwDK6KoODODAFfqT5HdJW0sA4QgBIi8F2zZG2FR4XMgr8EjASGQaTg1WH1XLd+ufq6AjcoJgLNMyTJjcy0IaejMuZWvrpY6sksQOeV0Q5OnUDe9BCaDNVg61g+PZkffN/fBtjuVc0dwHC2mMXms9+nXSy5xBe7vwFXNhyjb20U1DUkuSolhKuZkGMvmr7cwz+bZY2bUrRaq/Preiuq5DTv9Xd3Oqi8mgg5bUexym3UD6DYYHTBryS2R7t5dYs3YIVpTSLzYmb4wVSb/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LozogDE+qTKLQOhI/HqkImBSh8aY0PlGQzXH9JhZKWQ=;
 b=IqJLbs3wLApgsb/LCe0L5n2rkYOUOrDm71X1OoR1UOcB8qUJkJ86Pg5vnX2YkVVlzyGGh5QqIEDDdlp1l3H7mEK95zITB3FkVftGOrqyIEX93qzc82eC+o2QBamaQOUP2piUrTqQPFlTQZoao3dg8xwKC5QgevdyulaREvP6UvDZjUMQUYn/y5mpw8uZac1cVNeScMJc+pK21PbbHxxO6LB1KSwXKeRk3UZ0Qu7FVST9TStatne5mNxuROT2yJ/PYfMy7O/L9msb10wAoAZz/HVsT1Ubk+SgudZGQxt6UzuQUZ1woz1pbaq7emvawENHXqk1r29gLqDw4x+4fLvWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LozogDE+qTKLQOhI/HqkImBSh8aY0PlGQzXH9JhZKWQ=;
 b=YlgjIMWIoLJpUJ4qZepYNDxzc5I6ADVcCNRaW4m1BWGXNw3VjGacglKxqvKrvwmZ9gjydn6wcVepcWzU8Zqn0gPUvQeQRzM01jrGykAnpmXBOJ0O3GvvMqAq80hsIswlbJmCBMI584K9+K6Jh0FJPkj/R3SASuyD70A/D1Qw2XxESZSld8889EmqqyGsLtroi3CnaOTn8tBg/gGfIiOjfrX/v27d2Eyy5pG6vIpNuatD61nj3GUQgrniiqO3ZfOotcEcRJuO0nojmX2i21coWe7BvTcUiXkIFArC+OzNrmtPfCDOk96iVqYrkEO+Bj1bDstHNl0MUCmgE2HManARvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB8558.namprd12.prod.outlook.com (2603:10b6:8:187::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 10 Oct
 2024 14:37:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 14:37:17 +0000
Date: Thu, 10 Oct 2024 11:37:16 -0300
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
Message-ID: <20241010143716.GC3394334@nvidia.com>
References: <20241010085930.1546800-1-tabba@google.com>
 <20241010085930.1546800-5-tabba@google.com>
 <i44qkun5ddu3vwli7dxh27je72ywlrb7m5ercjhvprhleapv6x@52dwi3kwp2zx>
 <CA+EHjTwOsbNRN=6ZQ4rAJLhpVNifrtmLLs84q4_kOixghaSHBg@mail.gmail.com>
 <mr26r6uvvvdevwqz6flhnzbqjwkf7ucictnjhk3xsuktwsujh5@ncf57r3v6w6p>
 <CA+EHjTwEmXcQhCzGJG1icBzHvWEBUVVH33-ng60ngup6LMcC4Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwEmXcQhCzGJG1icBzHvWEBUVVH33-ng60ngup6LMcC4Q@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0263.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB8558:EE_
X-MS-Office365-Filtering-Correlation-Id: 01fa6988-38c3-4e25-ca12-08dce9390a0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rrU1eqPpmWJ/b3J+qdu9GciHIvidEjbFkJUVSsBC7LTMmhwxLaOn5EWRnlRZ?=
 =?us-ascii?Q?Gm4K/ko+2r8KehRlpuN1dE08EuoYsmCu74L5agoJjIY9B8IKNFgXTYKua2v0?=
 =?us-ascii?Q?+dEmxgUhhHe8IqhBmWCmG6krq3qfrSnEx8tlEl/xedlYQCptiWKBtfH+Y1So?=
 =?us-ascii?Q?pV3JGxZwpcDc73jSPeA4soBIPPG8n/eLGlCvClqlsfvoXRxm88AjfVhz4Kuz?=
 =?us-ascii?Q?zCbFir02kYrKeIwwYOK7sujmtnuqoE7+edm/IGRDfUN+HKk6uKkFvJKGLWi9?=
 =?us-ascii?Q?PjsHpGCtt2y4TwyV9qOHAlFt3CbjLNYwFrXTpCoVwZUuNQpJ3TAeHVYuMPIC?=
 =?us-ascii?Q?8LYAsnerJXWUQ3dNoqQJSVNeY9qjxZ5kZ5Rlg8TyhUdblxrJtEufK3OQWb9Y?=
 =?us-ascii?Q?04ME9qxxYip9jI/4VCudgEvQbvztqKgxF/IlNe3nUMobvaqc/3YlLy8TUh/h?=
 =?us-ascii?Q?iuGtaRLP0LHdebLM5lU+jty8Sh/7XzeQIsas3d4F5E9cDdBDWVb+drcYIJAh?=
 =?us-ascii?Q?fd/gImJlZSZjuwlWk+pFEkcFbnboJf2dktDoxBcOnsKx5sQ/48G8vCfA4NRU?=
 =?us-ascii?Q?HPqe7C0Z6llJGpCFd3Os23pi1qUOtjqgNpgAAI47rvls8r0uBVOTcs8rXqWH?=
 =?us-ascii?Q?FRmWzwFpBwbzCwlh+7eBGRAdK3hZIz8vATS1VLmv5ztf1O2euoYGoLSbNsfN?=
 =?us-ascii?Q?cDuvdqTu9dAz7AEb5TgSswL/hU41b3nan46XGBNVA+aTP7dZLKcouoG59vqU?=
 =?us-ascii?Q?HuQDReRosKnnPE09OLala7ZPEF0ikS+V53mSI4bVjy6OtFX7BV8iyeMlpTrV?=
 =?us-ascii?Q?bbeTw1kt1+ogkVTHHPLeggxmGgaEVF5zJo8QcZb56wVTq8kJP7Rtg4K04lwX?=
 =?us-ascii?Q?dVV4hHlrZ6+qZbXOiaRf6jdsFtAFpvGgkGGm1gQ1ajTrad7zSVc+B4qqzGRR?=
 =?us-ascii?Q?MeajJEgVuS1hMg8Gsa2bN5fFoGY1TysHpFiz9dwLaO3qePzhbtuP82f9X8s+?=
 =?us-ascii?Q?HsCerqUFPHzdzl462Pkq4lEa9tcmrZLcFiXOy1M5JAtxvrwHJa7zZYWiQemo?=
 =?us-ascii?Q?q8s+lP3EXw9oj2OxxETeH8YlQ6Jrl5tMFWOeM4b8VmiLqOkzIOYTEWpB0bmT?=
 =?us-ascii?Q?lVRNSQY4UhrlGu+yVGW5zuol7oHQunHXkXWILagHJcUkfwnbtBvfZy83a2rb?=
 =?us-ascii?Q?oTOfmXOJGR4AZbtRLfAN6BrQjeVRqjvrs3l31A3JdZEz2EXeWW5AUYveC1Qq?=
 =?us-ascii?Q?2/78d3ZawHXw6JPqjjGhXfD5b04nds057v1eKn7P8Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?08mQIMKBvOEB5BXranZeXYkkQ84cO8p0DJPqw9G+oAwDdeKgqkPBWoRC/q4p?=
 =?us-ascii?Q?jXJMU2wOcIBUzOH4oZDDVOA0X0DP7JBAwVzrWr/ogIC/43FcbLHnvS897Odl?=
 =?us-ascii?Q?YXoIw5eoLDluC0HVlTyQqyz6Ze4YeHkQR3U1nAihUxI4V58S0oDxslj6bXN7?=
 =?us-ascii?Q?f2EbT2OnRCIRcODEet15Yj87sfJ/NkdWw37O4+AxXonsFOZaYuHQf5kzq8bu?=
 =?us-ascii?Q?w9AH35NRiMxYI533cZcEl3CMY8uINyPb9Z7mYYmRQ+QhH1OrEsCdV5Qr3G1a?=
 =?us-ascii?Q?ssULgH/SMTmWJ23Ne3smkrGZO9m/LF86OmWxwneoLaLMkVw8c7GIe6Rjm55D?=
 =?us-ascii?Q?mxeZ0PYRcEDAn1Ss3Erek+qzUCKh0maa+L1jcPNA81Ili7e5xHsfUvwAAm39?=
 =?us-ascii?Q?bM6k1lfcXXySIZnI91GPVnl+x9Dwn+Uz+XhtiT3gAScEsRxdUGeKgonDa3Ry?=
 =?us-ascii?Q?n1Nhfx3csAZK4AW/USNmTt+yhm2AM49RecYEORgq/ZieduSxOYIoFfu5wCe7?=
 =?us-ascii?Q?rSUEKEa/GjXZPgDcBrJwVh5Wv1SPRrCE4rmm73q1WYQnyze1jluK4m6PJrFS?=
 =?us-ascii?Q?UdlOYq4Vh5KTYup5haucMEBrq7FkUeiZCLgZQENf4uxRnVKGCMruforMeZbv?=
 =?us-ascii?Q?dQjz2lkWejQhVqXaG10IGcB/xos1FWsxq1zvpP/jG26Up42qSy+Cl3kpt905?=
 =?us-ascii?Q?JBGxIuV7TqGL4rLZNaxgSm8R8gsPcpkxIV75jUVdpzRKN7MGQK41+1oox5/w?=
 =?us-ascii?Q?h7rrAtVAU7dJrg+EKUMCfDPglFzgQQdVV9dg7Nxz1sZjqEHClWxwSwSeZTCq?=
 =?us-ascii?Q?/KVs4LsYm+r/+EZFlWv92xam+Dt9ApaA9jYHQ0FZnqYZzSZt/YQ9PkOSouNU?=
 =?us-ascii?Q?IFj/lsXC0LKgXz46ONOlet08oVAmn9L5DPgIaR/WJ5h0K6KLtKKwgDMVcBMp?=
 =?us-ascii?Q?sMGEQLiNM/w7x3xqRm76P9TV/WjH2b+9CnSMycFXWXcLWbSBPaw4BOicMndx?=
 =?us-ascii?Q?A7OY6z23joImlVPmeuGD+xwBQAnCMh0Jr3YIWpjFKNbYQLqUuJT1LREjPQ55?=
 =?us-ascii?Q?BUAwiIg3mxMqmeIisSsdxHuPY6bqA/b7mb+nTxgkQPHMTwBwDolEv5GHz4fw?=
 =?us-ascii?Q?YdkKVPKF7k+C4d+oiVL6zO+7nzUILsjHrLEd1Crg2nIs6sJ/EDy0Amb5fs51?=
 =?us-ascii?Q?0MwaWw9YBJpeDvPTKFMNXkARY3TTdQVKR/5div3uLp/6D7ImslnU5xylsFqL?=
 =?us-ascii?Q?RdT9s8dsjJNGpPv7NOxhNusCxbDeOT4Q3Ix1+skXcADT+ecEG6AmCunfhvO3?=
 =?us-ascii?Q?JT4FKuhO6H5jXQaA+nklMm3KUrTLIFnlFXxXNGya292iW1oG3Wd0G5XLWEQ8?=
 =?us-ascii?Q?C8iRvnFu9XhZs/XKjbadknboFmOJG3IK30YRvd3kC7kxti7IzkxBe+NnpGsZ?=
 =?us-ascii?Q?dl0pwqGMjpFMegAVy1xBM2Q2gRQZ8sdNvLjk9AdxwrTrsoqdAk3T8Xn6Fs/J?=
 =?us-ascii?Q?DMvAOADeNduR/E3Bbex0F2EFDfHgyrxbrMKv/fDwGt8Pfj5IsZkKUmTFx9Va?=
 =?us-ascii?Q?lfeh0YVp7l/2Xna5Tvs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fa6988-38c3-4e25-ca12-08dce9390a0f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 14:37:17.2494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJL1Lhm14K4bkrayh+TfAYPYgVB3CnD8iVQUAByuncA1bRCsRfdUTafie098v/Fi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8558

On Thu, Oct 10, 2024 at 03:28:38PM +0100, Fuad Tabba wrote:

> I remember discussing this before. One question that I have is, is it
> possible to get a transient pin while the folio lock is held, 

No, you can't lock a folio until you refcount it. That is a basic
requirement for any transient pin.

Jason

