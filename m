Return-Path: <kvm+bounces-31944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A274C9CF2AB
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:18:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9E8CB3EBC3
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 16:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4A11D63ED;
	Fri, 15 Nov 2024 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YIo06UAz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DB61474DA
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689255; cv=fail; b=JdkxVpEt3uN84Jn936Wg34CmJbBjk4HOv80bPmq29W9kIbTa3fO755Cae2TK6ZdOoM/4SLKxFg3LmeW/k2hvskK31rAOPW55Up5YN+trgqX1Bj1iQ5yWnL1jy46xDMlnhttGDXwH3m/9Kk/yhnNxSxlrscDALgzOmRn00SEBSRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689255; c=relaxed/simple;
	bh=ha3XQLyC1VbMuPkSdDFDm/8nVFrPq/ku0joXeLkp/bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h3tEG6WNTBcCwAK/0lVus7gskoq9UgnbN0ihUcdNXC7JGCAjcfSL1DElalCx18FAC7yBfQGAbINtCHT02UhwYeQCMV1sRF4e/itHXXKGOXQFmnePrGpFtcovc/isdpJELtObqeStkZkR6rw5gatRZxAWyD0V8RKbNSjz8s5FV9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YIo06UAz; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BR5UhCuMU8/S/L1KA0Vb5fhD2ArqaIkskuX+Q/9+UxYW9rMYpcE4NQi0wlfvGfOfxoGicJXRdKbxMOiifCyTWXXoI3mzODWsQ6TVzupe1TCsOK12+gKb9Qpxiy2Z49TfhtdAl5Kb9l/jpSjAYXiQt1MggcMrGcRa0jpiVsd2IjAVHodvvhwJ81qyXlCPe3gCNRWcylvIVhmSCnQ6XEaJq8zQcpWhdXtMnt96RWz1kixIm/Zwx4VCJyPuDkD/1F6z2yofmSvbRf1PUYl9T/kAsxrawrYBdSTDfA0MCgOdWJEang8acdYjvumNm7i64aEmMeBtq9OXFy9v0H9HDgfJGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXstdCBZjotUKW/7ldLh5h77JRi5TIcMuMWZpmJld6A=;
 b=UbMlE90ZMG1td/Mgj6l1OWKNHmJJsvDbpDpxF/WYzMW/AMxIb//eynl5BtR4+/UD2FHFFEpN85V4wjx5B4FF8ua799hazFQPLqIA1vjMius8VmMJf2nPG+DtY8V761Pv3zeYI7BUvMAf9bQG4yRqEUP/NHnVNdL3NNxEZewtngVWefzTJg6f9Q9QHodIWgHU5NaG4Aqpw/tMvKKnU+lCcfHdBxNk++4SfXUrSBpJlDRP2lF/aAgxRHe904n4sFL8Kxiwt9/GMJ90hFqsPMwLkXlIItOvVciMhuR7RTM3F+9jF5jvu22V1cpyecpOvPAYuEQ6YZHKlCZg80dnbqTl3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXstdCBZjotUKW/7ldLh5h77JRi5TIcMuMWZpmJld6A=;
 b=YIo06UAz2/M55dCq291/D5fre8p5FE+5ENh0tE6zQiNf05kIz2sg1+kP9YDX4gl2tXLersAKmvSWS35rU/uWTV2h+UsIwro5YXbxpAa3M5kqd3O6RNHk2rYBkdF7h1Picptewv0E0DGfr4y3UF8tFTQVvbkF+Yl/1WpZPWQU9nJz/xgPZtWjxvJdM+Ty9e0nESJBS4WgOMQIXq0M4eKYX+DD8D4OcD98JcUyBmOHWpI74bu9QnnYnFpsz3D5G9qHPGx5sAXPDzrLKxGjXBFttfzf5K1LpQfasMhOa5ApLOutvhbNW9XEA6E1oRU/AOlfIKXNBNBgymdGUH9x3SgTrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5261.namprd12.prod.outlook.com (2603:10b6:5:398::22)
 by PH8PR12MB7229.namprd12.prod.outlook.com (2603:10b6:510:227::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.20; Fri, 15 Nov
 2024 16:47:27 +0000
Received: from DM4PR12MB5261.namprd12.prod.outlook.com
 ([fe80::e175:f839:8e2e:2885]) by DM4PR12MB5261.namprd12.prod.outlook.com
 ([fe80::e175:f839:8e2e:2885%6]) with mapi id 15.20.8158.019; Fri, 15 Nov 2024
 16:47:27 +0000
Date: Fri, 15 Nov 2024 08:47:22 -0800
From: Rob Nertney <rnertney@nvidia.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Wu Hao <hao.wu@intel.com>, Xu Yilun <yilun.xu@intel.com>
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
Message-ID: <Zzd69pa75CKM1OzU@rnertney-mlt>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <b7197241-7826-49b7-8dfc-04ffecb8a54b@intel.com>
 <84ef5f82-6224-4489-91be-8c1163d5b287@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84ef5f82-6224-4489-91be-8c1163d5b287@intel.com>
X-ClientProxiedBy: BY1P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::12) To DM4PR12MB5261.namprd12.prod.outlook.com
 (2603:10b6:5:398::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5261:EE_|PH8PR12MB7229:EE_
X-MS-Office365-Filtering-Correlation-Id: 72c8d62a-6da8-4339-b943-08dd05953011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gUoQi/AihHErbg0zG0DFIccv+gWDT+yWy7vJUDFX4Ys2LJEaOCX1A8XrpoGE?=
 =?us-ascii?Q?QQnq5PvSCTxAKTNVB1u0NykdO5EF1xJY9JHiVLwCHpU0nvxinzVAs12U0a1F?=
 =?us-ascii?Q?d23E6f30Ru63Ev64a7eqOEVQSAuGa2ky6RFb7y8Ko5/SSgGFzSbzWXG5Xscj?=
 =?us-ascii?Q?i0nPMBMx0J5yZ1NmmAkmUmI18rOGVKCvRAe2gd5gwyLPrUHY18trqEhbItKp?=
 =?us-ascii?Q?CLQyAmLkHBc/p9rMk4GQS3dghVGIsB4Q1l8Vk9+SJaGrOiQr+c1iOZ0fZpEF?=
 =?us-ascii?Q?EzZJj6nb5Rhsdnhj6/P0/TXmy6n2YDr7lz2WNBbSjzPo6lBiwiuRKXooUb7C?=
 =?us-ascii?Q?gbNuP/UfhLiR76/dGPa9WeemRys0XgM72fQgHjmn38wGPN/gCK5I33MwB4os?=
 =?us-ascii?Q?s8mo25M29lLg+3DNNaITmIo4vnajdMrInR1QJDkcQ/5HqV4izu48EeLpJ0rM?=
 =?us-ascii?Q?x1LFw0vBbxwFG9mb8VncVXcU5ERBD+UFZXwSi6wfzMa6momoTohbYH6gM70e?=
 =?us-ascii?Q?4V0m9kwWRF/B5h41IVv9fm3NdzvRuXI+y+lfK5zDFrw8nlTQkE0L2bde3eFd?=
 =?us-ascii?Q?TpfBGNwZnLefcd+sUVc7wmQ38PwEUI3+qigIq4RTFNUrexux/Tt71dZsWEkS?=
 =?us-ascii?Q?OQKf42QpirInDpZRN90liPf21tYkT1NdJWpp++DspDyXDmTmk9ykwQfxp2u4?=
 =?us-ascii?Q?C+nRhDBzj9pXugpNJl/oo3bHpU++eAT/XFzx4fPUtBuMVhyV9SW8Oqd0H+th?=
 =?us-ascii?Q?vqRZKtDfoTKHG48HUeqLAFuM+9hVFPnzLgfiFr0PpBbyJQlqd+pFGRGymyAd?=
 =?us-ascii?Q?mQFyEE57FVt0YI7Vf9Vz7QNzz6BRjS/2HnrGPUvqUdLq4mY2wEC5GuQqCjFG?=
 =?us-ascii?Q?+pYS36z6P1qb3kWiuBuhkEwojAae7hqJWYsYwLVjQsjusISt1sFjsUtlE41b?=
 =?us-ascii?Q?B+BWEVGqDH/m+IuAw+/xw/aagDVwNob0H0xlg2o4X2bVXb9hRHFuzEMlB6u3?=
 =?us-ascii?Q?BDZcfQi/GdZ5CiIpqVoKokZznFpgl1NRnHXiLEcEIY39SeJjN5mTF1keTqgY?=
 =?us-ascii?Q?JWXEEouhuYSkCxDLcC+WJ4+CuPm07EBmw3xDLmf+KlBQUORszk9WYZO/N22E?=
 =?us-ascii?Q?jNx8eNCaTEx3GwyqgbMRIdBWAp9qC93iHNfHCZzKivx2bJrm0st3GbrK/p39?=
 =?us-ascii?Q?35Cmtf4PLHDGfAfmgNaE7fRZ4pCt1tB4MILgLK78dULigztC0p68hU6N6515?=
 =?us-ascii?Q?WUyagqfgcmSyuYphX7QPwhOsPv5Q02OUfr5zADmxDU7+fl8S8PQV7V/ykYjY?=
 =?us-ascii?Q?hUYMQ6BwTWGyiCTqd9EDjgvF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5261.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xhrx9QZpWXCb9I/J1u8fNjnTV+2SIyUiN6ZXiGan6adS29sF8kLtXXJgGAuf?=
 =?us-ascii?Q?AElt4LSvw/gOjq1igBaj9AGZOgbkWU2ytgctgnz5ajUDNv7k+0ti+JS7ZzIl?=
 =?us-ascii?Q?nq/2mNutX9KfS0443abnk8f1iiTJ7M9bUNh4E35ZyXIr8MFeqTMdVi7LxSnC?=
 =?us-ascii?Q?TRXc0x4hNpxs3qjCi0tCPsnNkNRnjvV/xJdfP2BCJm1rw3/lVHUpBO7mmQBn?=
 =?us-ascii?Q?7dANe4hk9fUP8F4HfOe9MzpqY0lgBGIpGiJ5PqrhVSTik/e73CW3HwyULXbk?=
 =?us-ascii?Q?peMz1lnSR9xAKnTc1/C2JQEkL1bKT2sM9VTmsHQSIRSTmzwEbEcn6NWhpMLS?=
 =?us-ascii?Q?zn/8PPNADz5X1t7G4RMK30AGJ4/B8paHoNmbOcXhyryAVZkZ6m1yQoy2gJTA?=
 =?us-ascii?Q?aJRHUZgHlYSuQ8kz7MCuv4ce6YesEOGGka828990rbd+JVUsY6LWZsZ3fMXK?=
 =?us-ascii?Q?VGxJOofGx25P3rohV4SR3iLY/zOENacN6GIw+LWDhxBrcngundNe9ubMgkYi?=
 =?us-ascii?Q?/E2quvJJM9ICk5fsdm0TTdrSdv6ihImQET4KZJveds13dkT2BPhvVxTgQGEq?=
 =?us-ascii?Q?DRsYBDfGi53kce2/CAvceckwqjelbcq/HLTMo0tSFETj1UXbFq6mwlDDNaWJ?=
 =?us-ascii?Q?S2E6YvebVI5ORAugY3rEQvSyLMZDavp3XBMedprjjx0FJLjIxll8jxrTF4MR?=
 =?us-ascii?Q?RChPbmWGOs8SfIfMDPb4PG8GkMyWX/Zxznkc9TQfdrfnxK7LhkSpAiMkBQ3g?=
 =?us-ascii?Q?30wsHqokMyLjVuMTMzHgMT7SeBQtmzXBEl98DHgyachRBlFjOdCLRiaQvK84?=
 =?us-ascii?Q?NcjlSvwzFe+xMcIi4A+dm7ZXOuQ8T+3UKOX85K6zuzJvxRAB37Ps1laA6ffi?=
 =?us-ascii?Q?2JHKMWJhda0EzFa2QyRUSbwF0JKHz8oaX9AHjx2rothbcseQUGGuYGWIELxJ?=
 =?us-ascii?Q?d2roV1R3lSFGFrMwbMSXgxOX5KrKnVmOtLVbZzj+ss7bhd4Mm+gFmoYVP3FE?=
 =?us-ascii?Q?kTVpGfx+4795giCSGgmQyjWb04qkYih17haO5oJzRbhQ2sdviQzF+V1euu63?=
 =?us-ascii?Q?7YCCgZMxVztvBkfX6Bo5UTybxJ/OPzagKgPeZDPuDRfGXXmsg2FYKGvQL6Ug?=
 =?us-ascii?Q?d/VI+VVvtrCV7/zCnnre+HMa1EcsUzi3pTgQEYO7iqPQMAwOjPSBnfa7Ut99?=
 =?us-ascii?Q?xGhZhvSQO3tftvYseegdVcSfEmQvlW1HXHzXtYX5BmWPSRumo91IHyckjjtB?=
 =?us-ascii?Q?oecc/wMevNHChzwiV7iWmkLDMIac7Z4+4q1r37/G+DjoM12q29BKxt5JNrZ4?=
 =?us-ascii?Q?HTIAjOyuofYsq8/hH5XdMz9Kixhb0fT/T1aumidOUSE6Y8xWwvsGlS0XZLAc?=
 =?us-ascii?Q?XqtUAFbYs1MUBCkdiCrHSHfmuebfQwYKRHuBwg6Ol94Tn0MFiNhpavAUWf4+?=
 =?us-ascii?Q?W4GpwXqrKn0sLWnsiQqcEQHWhaZDy4zmLzhurtga40dNbbGOk3SzwYJwyXHL?=
 =?us-ascii?Q?onKROWrKfoj/ghfUes4N6PkDoTdomkn02LRd7fC7osAw6rS+R0/f4uswXMwl?=
 =?us-ascii?Q?OQHdNMf3SmrIanv++uc5LBt2/oFAt6zPLBzcFQJ1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c8d62a-6da8-4339-b943-08dd05953011
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5261.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 16:47:27.2953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oshbiyhb/oKVw39u3G6DQeYAggVbRS9R+ZE6sd0h5o9pjLQP9R+yF0WamgbdBKGo38wbYt5GaNI0OspTnko4+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7229

On Tue, Oct 08, 2024 at 04:59:45PM +0800, Chenyi Qiang wrote:
> Hi Paolo,
> 
> Kindly ping for this thread. The in-place page conversion is discussed
> at Linux Plumbers. Does it give some direction for shared device
> assignment enabling work?
>
Hi everybody.

Our NVIDIA GPUs currently support this shared-memory/bounce-buffer method to
provide AI acceleration within TEE CVMs. We require passing though the GPU via
VFIO stubbing, which means that we are impacted by the absence of an API to
inform VFIO about page conversions.

The CSPs have enough kernel engineers who handle this process in their own host
kernels, but we have several enterprise customers who are eager to begin using
this solution in the upstream. AMD has successfully ported enough of the
SEV-SNP support into 6.11 and our initial testing shows successful operation,
but only by disabling discard via these two QEMU patches:
- https://github.com/AMDESE/qemu/commit/0c9ae28d3e199de9a40876a492e0f03a11c6f5d8
- https://github.com/AMDESE/qemu/commit/5256c41fb3055961ea7ac368acc0b86a6632d095

This "workaround" is a bit of a hack, as it effectively requires greater than
double the amount of host memory than as to be allocated to the guest CVM. The
proposal here appears to be a promising workaround; are there other solutions
that are recommended for this use case?

This configuration is in GA right now and NVIDIA is committed to support and
test this bounce-buffer mailbox solution for many years into the future, so
we're highly invested in seeing a converged solution in the upstream.

Thanks,
Rob

> Thanks
> Chenyi
> 
> On 8/16/2024 11:02 AM, Chenyi Qiang wrote:
> > Hi Paolo,
> > 
> > Hope to draw your attention. As TEE I/O would depend on shared device
> > assignment and we introduce this RDM solution in QEMU. Now, Observe the
> > in-place private/shared conversion option mentioned by David, do you
> > think we should continue to add pass-thru support for this in-qemu page
> > conversion method? Or wait for the option discussion to see if it will
> > change to in-kernel conversion.
> > 
> > Thanks
> > Chenyi
> > 
> > On 7/25/2024 3:21 PM, Chenyi Qiang wrote:
> >> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> >> discard") effectively disables device assignment with guest_memfd.
> >> guest_memfd is required for confidential guests, so device assignment to
> >> confidential guests is disabled. A supporting assumption for disabling
> >> device-assignment was that TEE I/O (SEV-TIO, TDX Connect, COVE-IO
> >> etc...) solves the confidential-guest device-assignment problem [1].
> >> That turns out not to be the case because TEE I/O depends on being able
> >> to operate devices against "shared"/untrusted memory for device
> >> initialization and error recovery scenarios.
> >>
> >> This series utilizes an existing framework named RamDiscardManager to
> >> notify VFIO of page conversions. However, there's still one concern
> >> related to the semantics of RamDiscardManager which is used to manage
> >> the memory plug/unplug state. This is a little different from the memory
> >> shared/private in our requirement. See the "Open" section below for more
> >> details.
> >>
> >> Background
> >> ==========
> >> Confidential VMs have two classes of memory: shared and private memory.
> >> Shared memory is accessible from the host/VMM while private memory is
> >> not. Confidential VMs can decide which memory is shared/private and
> >> convert memory between shared/private at runtime.
> >>
> >> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
> >> private memory. The key differences between guest_memfd and normal memfd
> >> are that guest_memfd is spawned by a KVM ioctl, bound to its owner VM and
> >> cannot be mapped, read or written by userspace.
> >>
> >> In QEMU's implementation, shared memory is allocated with normal methods
> >> (e.g. mmap or fallocate) while private memory is allocated from
> >> guest_memfd. When a VM performs memory conversions, QEMU frees pages via
> >> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
> >> allocates new pages from the other side.
> >>
> >> Problem
> >> =======
> >> Device assignment in QEMU is implemented via VFIO system. In the normal
> >> VM, VM memory is pinned at the beginning of time by VFIO. In the
> >> confidential VM, the VM can convert memory and when that happens
> >> nothing currently tells VFIO that its mappings are stale. This means
> >> that page conversion leaks memory and leaves stale IOMMU mappings. For
> >> example, sequence like the following can result in stale IOMMU mappings:
> >>
> >> 1. allocate shared page
> >> 2. convert page shared->private
> >> 3. discard shared page
> >> 4. convert page private->shared
> >> 5. allocate shared page
> >> 6. issue DMA operations against that shared page
> >>
> >> After step 3, VFIO is still pinning the page. However, DMA operations in
> >> step 6 will hit the old mapping that was allocated in step 1, which
> >> causes the device to access the invalid data.
> >>
> >> Currently, the commit 852f0048f3 ("RAMBlock: make guest_memfd require
> >> uncoordinated discard") has blocked the device assignment with
> >> guest_memfd to avoid this problem.
> >>
> >> Solution
> >> ========
> >> The key to enable shared device assignment is to solve the stale IOMMU
> >> mappings problem.
> >>
> >> Given the constraints and assumptions here is a solution that satisfied
> >> the use cases. RamDiscardManager, an existing interface currently
> >> utilized by virtio-mem, offers a means to modify IOMMU mappings in
> >> accordance with VM page assignment. Page conversion is similar to
> >> hot-removing a page in one mode and adding it back in the other.
> >>
> >> This series implements a RamDiscardManager for confidential VMs and
> >> utilizes its infrastructure to notify VFIO of page conversions.
> >>
> >> Another possible attempt [2] was to not discard shared pages in step 3
> >> above. This was an incomplete band-aid because guests would consume
> >> twice the memory since shared pages wouldn't be freed even after they
> >> were converted to private.
> >>
> >> Open
> >> ====
> >> Implementing a RamDiscardManager to notify VFIO of page conversions
> >> causes changes in semantics: private memory is treated as discarded (or
> >> hot-removed) memory. This isn't aligned with the expectation of current
> >> RamDiscardManager users (e.g. VFIO or live migration) who really
> >> expect that discarded memory is hot-removed and thus can be skipped when
> >> the users are processing guest memory. Treating private memory as
> >> discarded won't work in future if VFIO or live migration needs to handle
> >> private memory. e.g. VFIO may need to map private memory to support
> >> Trusted IO and live migration for confidential VMs need to migrate
> >> private memory.
> >>
> >> There are two possible ways to mitigate the semantics changes.
> >> 1. Develop a new mechanism to notify the page conversions between
> >> private and shared. For example, utilize the notifier_list in QEMU. VFIO
> >> registers its own handler and gets notified upon page conversions. This
> >> is a clean approach which only touches the notifier workflow. A
> >> challenge is that for device hotplug, existing shared memory should be
> >> mapped in IOMMU. This will need additional changes.
> >>
> >> 2. Extend the existing RamDiscardManager interface to manage not only
> >> the discarded/populated status of guest memory but also the
> >> shared/private status. RamDiscardManager users like VFIO will be
> >> notified with one more argument indicating what change is happening and
> >> can take action accordingly. It also has challenges e.g. QEMU allows
> >> only one RamDiscardManager, how to support virtio-mem for confidential
> >> VMs would be a problem. And some APIs like .is_populated() exposed by
> >> RamDiscardManager are meaningless to shared/private memory. So they may
> >> need some adjustments.
> >>
> >> Testing
> >> =======
> >> This patch series is tested based on the internal TDX KVM/QEMU tree.
> >>
> >> To facilitate shared device assignment with the NIC, employ the legacy
> >> type1 VFIO with the QEMU command:
> >>
> >> qemu-system-x86_64 [...]
> >>     -device vfio-pci,host=XX:XX.X
> >>
> >> The parameter of dma_entry_limit needs to be adjusted. For example, a
> >> 16GB guest needs to adjust the parameter like
> >> vfio_iommu_type1.dma_entry_limit=4194304.
> >>
> >> If use the iommufd-backed VFIO with the qemu command:
> >>
> >> qemu-system-x86_64 [...]
> >>     -object iommufd,id=iommufd0 \
> >>     -device vfio-pci,host=XX:XX.X,iommufd=iommufd0
> >>
> >> No additional adjustment required.
> >>
> >> Following the bootup of the TD guest, the guest's IP address becomes
> >> visible, and iperf is able to successfully send and receive data.
> >>
> >> Related link
> >> ============
> >> [1] https://lore.kernel.org/all/d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com/
> >> [2] https://lore.kernel.org/all/20240320083945.991426-20-michael.roth@amd.com/
> >>
> >> Chenyi Qiang (6):
> >>   guest_memfd: Introduce an object to manage the guest-memfd with
> >>     RamDiscardManager
> >>   guest_memfd: Introduce a helper to notify the shared/private state
> >>     change
> >>   KVM: Notify the state change via RamDiscardManager helper during
> >>     shared/private conversion
> >>   memory: Register the RamDiscardManager instance upon guest_memfd
> >>     creation
> >>   guest-memfd: Default to discarded (private) in guest_memfd_manager
> >>   RAMBlock: make guest_memfd require coordinate discard
> >>
> >>  accel/kvm/kvm-all.c                  |   7 +
> >>  include/sysemu/guest-memfd-manager.h |  49 +++
> >>  system/guest-memfd-manager.c         | 425 +++++++++++++++++++++++++++
> >>  system/meson.build                   |   1 +
> >>  system/physmem.c                     |  11 +-
> >>  5 files changed, 492 insertions(+), 1 deletion(-)
> >>  create mode 100644 include/sysemu/guest-memfd-manager.h
> >>  create mode 100644 system/guest-memfd-manager.c
> >>
> >>
> >> base-commit: 900536d3e97aed7fdd9cb4dadd3bf7023360e819
> 
> 

