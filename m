Return-Path: <kvm+bounces-39137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1ADAA4473C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:03:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED94D17156B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC8118DB34;
	Tue, 25 Feb 2025 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GpbJFp3f"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB54158520
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740502939; cv=fail; b=FoXZVJ1v9QU0sq6lNia2CNNvDQaVzeAm6mbEIJ4vP8k2wimJz9AlO0gfNFjWPI4Zm19m8GlVcf/elsI7KN/3MBVW7yFckUYgPd+roj6NkSwjaLGF5wriVf5N1im25iFoqUzx6pjtJZ7MNvkvTMOdhz98AYGoc+YDKziXvRWiA80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740502939; c=relaxed/simple;
	bh=UDZKlFjAI3D4qBF1eYS5wWqRJ9cYbQs0/KY+rjTErqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xt8VEpABWRmwMh8dceGid48RTilJPmPepUkiEzWLPWi6bmCcW89f/Cj4ElgKqVaciQxqmag7pf6+H3R3sG+1DMcX2YSxDH+PBP7Wg4s1OHd6FKU4X1nMJa4TcbM7JfhJCCW8pPhhCWhTxV2Vjyh1GQnyNJyl2MV8RG4w94laWkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GpbJFp3f; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mD77T3EG5ECCdJVyuY223tv2CrDuMKSDJrtTYUICGRYiODHHJTY941HOoEzwV9ArKBh0Z7mVPtfiW8MM6bCT48NcLjwyEbJaaEoViyLrl2ZKzdmv/qF3SLUWkwlujc/+Hx4S7fWjIQQ3o4R6DqFwefcHalolKD5UVMXjZqRd36liODJVZaqSQrrZo2NPRxLqeCx5WwVxXcf/fKXZYRCrbmWnjCwC0l/8a/gL6jhkEqs/lBr9podzB7/x8vjY6OAo5m0pHdAb9s3taiNf34ItoFrADeORqaPyXDZO6Txcm81E5vZYt8BWyEAirspRrN84CDmsMB5gqKwXmD8Jt28+JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QwKbh01aK1JmhywiEJcMt5/9mlVVFQKSs8FazJhjYUk=;
 b=OTwqe9zKgVxsWqNfm3+8Gi8ww4RSJ/iyCrtAlAEMknUXlW9kqnUH8I2F76WxKgW3yq8Zt4dxYU2KGG5IIyvF9o+dX8yHQWSWP3sOFJDItfZijAU3kq88UQulZDGCXoBTDM3gKR8DPGVZT2wZekuzP2jdqYzWad5yJd/Tm6ABYV0MUAGkAqemU2DlwE1eW8W6G+C9CLTnZ55BwLqiswsoYi/Y8VCtJZ3ydPNETYeTm60uwMr9x1nuJqZhtm7eEJXaXC9A6ektz8SUTIwHgex3Iu5Xk+XMrHTjxBuOucZuaxCqOPNBrGe5Un2TAfLI45RmqEF4Qa7S8ILFtSJQSjmUVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwKbh01aK1JmhywiEJcMt5/9mlVVFQKSs8FazJhjYUk=;
 b=GpbJFp3fNp9Gp1VigRZBQje/2yyN3GLgnLiEEqrsB4nVRt3ZF7Y7A6FHmLpBgp4hEdxXBv8/xqk5CZRgXmF9he4wOk96DY2dujXhA1y1OqRQCgWC8GLNyPOPW+3vqe/y8zPN0yxm1Y8ftjdwYrY5xqoyVszn9sIBomzWtrs9zaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 17:02:03 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%5]) with mapi id 15.20.8489.018; Tue, 25 Feb 2025
 17:02:02 +0000
Date: Tue, 25 Feb 2025 11:01:42 -0600
From: John Allen <john.allen@amd.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	davydov-max@yandex-team.ru,
	Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v5 1/6] target/i386: Update EPYC CPU model for Cache
 property, RAS, SVM feature bits
Message-ID: <Z733dp+gePxwDsyW@AUSJOHALLEN.amd.com>
References: <cover.1738869208.git.babu.moger@amd.com>
 <c777bf763a636c8922164a174685b4f03864452f.1738869208.git.babu.moger@amd.com>
 <Z7cLFrIPmrUGuqp4@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7cLFrIPmrUGuqp4@intel.com>
X-ClientProxiedBy: SJ0PR05CA0178.namprd05.prod.outlook.com
 (2603:10b6:a03:339::33) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: a5bbc472-b5a1-4711-f33e-08dd55be1fe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DzBYJ/X22FSPWXQyDWxwIv4uZadalZFuf51I2OhBecUzNQwE+0Y9gs+K2PZj?=
 =?us-ascii?Q?CIeFBLrSrhsZzYqznL6gJl7uxpN+6nVKhMJzGQ89fT0vcpoU/QvYXgaAKO0/?=
 =?us-ascii?Q?ZCDO3Kfdbtk7n+sA8AI8E3hij3hw8bqANVcBH7jZ0XDcjYaQzT8iHojkutpT?=
 =?us-ascii?Q?poVW2crcTtAHc9TCJ6qcSS6dQUZHHWRcaw7ebwXn/JFsc93iobSgkHeUxVx6?=
 =?us-ascii?Q?iNeShqEyoxhZx5PQBh6j0wAqV9smZGqKZDkkWUwWvyf9/maPmT8hzhsiaR9U?=
 =?us-ascii?Q?L6cC1cCiwmZ/xzH756Jo0UMsUudst1DhOImXD59AaUgELCSwp61TdLb7W1wm?=
 =?us-ascii?Q?w9Gin4yWxoffe+yyM7VGbHr+LKE1Xiz29AUylh8Xj5GEF1MvxPN4BuyXa0Ua?=
 =?us-ascii?Q?XeLNj9xEx+FCZYeNakuBN1ITMLQbjKnxE9YpsCp+b1UCj/bjMiyUuK4sOAKq?=
 =?us-ascii?Q?Um0U/CUrdjM+mHiCAdLVp/ttvrxnMHNwO2ir4HAfSmqRjV/Ey/1I5gNXJsW0?=
 =?us-ascii?Q?CC2u4pEoZ67L6awzLnPx4ER984wuQG70+wgdD7KdjV9Fcy0Mf9qHTpTWE6V4?=
 =?us-ascii?Q?NvrrH78OVE6unzVoy4GbcJswiVsSu6VVxKLSaLBR1jGoX7+xGfj6jJyO8WkE?=
 =?us-ascii?Q?lwrZAdCBBdCNDmqk7mwGhkcM7rFAykoBxXpROjazpgOLrBDeiUSX+tFOQJNS?=
 =?us-ascii?Q?Oyc77ZfL8NQdKQn4iI6DKHpSVnAWAUg29NYvtzeMqPtLgr3/yIklPm3cpP6u?=
 =?us-ascii?Q?elb0kRY41JUGjlBcRc44aUIwIFrGHPEhNXkWG/PGWL5jfKS+eaiervlxcMBG?=
 =?us-ascii?Q?xrBCqbRa/Q3aCcQ0jhjDQyslBDFoXVV0jUjwKLHEMlpIXpi/Rg7tG6K+oq+q?=
 =?us-ascii?Q?kehow+W9SCYkTwvLBf+aB61azA9A3F7fYnkxqWppizF5RJ+3pbmHWnj/SIrK?=
 =?us-ascii?Q?2vXiuy0pTKqYcKaD5SqpkCf2yzjqhuxicCg6QEQlVCJeT17F24TjjQCvq0mw?=
 =?us-ascii?Q?KOgFmu5CrghzZLSQ++jEZEVv5LBYjgMwkqyrtduxPSFndAC1BzC21pIy29Be?=
 =?us-ascii?Q?hoQuCIYgb40DhkcLfxBcg0F/k12vPYVN0joRo+2Pb+yECsabHlpQPmlYr/VU?=
 =?us-ascii?Q?X6DEJkO6azPmNecmKF/uUmiWgKoLjUmu4WydrO7t0cmD6xymBNzkhqcWK0bJ?=
 =?us-ascii?Q?94AxqlM4DPkrOp7/JMtCQbWCp6usNPHsMwclImnoBM+Nbm8mo5odVhw8B22o?=
 =?us-ascii?Q?kuibkWPtRLot+Yh/Cc5opJuDHK7JQK0Kj3Ye8fOUnYOogLSqfcYYCXj6wKMp?=
 =?us-ascii?Q?P1k+ST2uwMN9S2tvrD3Q25C+sgNt2ViiKEtMwpbrufsBqWmOxRXiTU3vQMDX?=
 =?us-ascii?Q?2IbOdsGvms7d6PfJHq5JlOz42Suj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NoJLRM1y/ii9LpC3EqtXKmeoqDIofwTPk1uIwKosv2RzP6aJUw5d9HkRzJLU?=
 =?us-ascii?Q?NfMJL7eHC6SFAVytdgDYn5l/7L0IMS2GQbKjpV+ZDhFtrPSPf51yPUvrH8Zg?=
 =?us-ascii?Q?sw0BtLQZBTPkwmblMM9KobCFip4DSiwbsXesATQE583If7G93GGP0PsC2uAb?=
 =?us-ascii?Q?ci9+giw6YL3Esgx2r/k3kNwafm8NE+dmCnP1ZpjTpgt56lB0NSJld4JJtmq4?=
 =?us-ascii?Q?lL1WPJ5+JUX73EgKFZzo10OM/Oo6819mrwqEH2cumJPqVXZ5B6rFznsDPYZz?=
 =?us-ascii?Q?wLdSxWu0hFC+DhyKTNPqpuFCeHzA74Uj3ZvAXbsM9cZu81s39wudaOu2M8L7?=
 =?us-ascii?Q?VWb7PKJ6V5xMLspy9roaorai+S3DpuO5Hu3DSfM2BY3t5UfKLYJPYK7lI23w?=
 =?us-ascii?Q?qUw/sl3CDukaDSFfrvzBz4k0BcUtJzmv9tpzwarxuHJQGCgqgRKc5ix6Zx5q?=
 =?us-ascii?Q?sqaT5p5jja9LvSG0ThGQ+1hA0IMCHEvCUgtZqwrLV92kjePmAf6l8ntgZwEp?=
 =?us-ascii?Q?yDetUCnUg9WEtgKbmxiBQHMgm+/GSkXBEtifVNw6Hd3frcN8NgAfUBMO3p4A?=
 =?us-ascii?Q?EHskhmt7dHVigOQyLl9J1ICfTo3l39PYq2z1ohgXjj2AZgufpLdnak57Te0/?=
 =?us-ascii?Q?RdjFEEc2b8XU0zMlY3F35pBwBiaYiA0rrzmgGNXhFp0rzFsRc6BodmlZ6YfI?=
 =?us-ascii?Q?kji20OXRiHN+zP/V87KjefWMnGjvhRURmzcSNrDXjdciMs+181AfA59QBsfa?=
 =?us-ascii?Q?GnqHc8apXDmOmNEFyCTZi8eusRqyZI/6FAG8Sa0dNwieEHGWdaV1Ll6JIqpl?=
 =?us-ascii?Q?24AF/1fvx0v+B50BW84LbYqmc6aCIewreZftPD0+z165mvVkSW3I2pooCcN0?=
 =?us-ascii?Q?IMQaeBrg7WVJpd+xVOm9+udlh565MSdlPfmi6pGShQS5Pk9qIPQ4lwmiRcg8?=
 =?us-ascii?Q?3a5rzrS3XgHRcDngaIViC4g319iGI803BTI1x7au292WgeVgNuYI17mQ09Ml?=
 =?us-ascii?Q?rkMDtaGi0BqmkmG5zj1RdjfUyU+jidXLp0AqODqZnMX5xpI+kB9vZkzNFQDf?=
 =?us-ascii?Q?/12oc/JoyKdgh0y48zW6/k2WQNWhVSxN1WSnqyN/+AUcBgGtMxeIh/fMbIFY?=
 =?us-ascii?Q?LWmQQVjp0KCpUQjsnDSgrGvY/ACoS9ZV6q7tN5yqhOR6B78DOywG/ucqZXio?=
 =?us-ascii?Q?NMb0NpmP2tSyXAx9IeGS5DQ1Ojm0p2o/4JGeZHS6fJtSQQM4dxtD4mV4iapv?=
 =?us-ascii?Q?p4ZCG6qNnpowks3S057vTGUx0oa3YHxE9FEJR144knnjoFnFjA3sV4ZvAqhU?=
 =?us-ascii?Q?uOKUcjRUpvM3BhzfE2Rr8RXCCHIs1JUJ0CIrWyxdRpd7Poiwykk3WQqJhaAz?=
 =?us-ascii?Q?ZFyxce52cFYcClUqt/brgMPNvZhrJxAE9zyli/yj1P+UM//EHz4RJEYomS88?=
 =?us-ascii?Q?KP1lpTXZH145/TQNhz7Ztlm3IGosLtdleZa8/QROQqhKf4cPkZYFXe2OzfO9?=
 =?us-ascii?Q?k96CeYp8pLH/hOikpToBxN0iGJSoycHMuGUtmAUfrwChqJGlBxQadPRg1n9o?=
 =?us-ascii?Q?Y/tYo4+pRp92fUyVNzJHntaPXgZ1payHAEVysvRy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bbc472-b5a1-4711-f33e-08dd55be1fe9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 17:02:02.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhhAJ+JqwRnLvR6Nyi11b1ifgltYeYKZuKfYIC1Amm/c3Zvb9SqrhpuDSENWQqF+kTZyrOR31LLxCdYNnlmwIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493

On Thu, Feb 20, 2025 at 06:59:34PM +0800, Zhao Liu wrote:
> And one more thing :-) ...
> 
> >  static const CPUCaches epyc_rome_cache_info = {
> >      .l1d_cache = &(CPUCacheInfo) {
> >          .type = DATA_CACHE,
> > @@ -5207,6 +5261,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
> >                  },
> >                  .cache_info = &epyc_v4_cache_info
> >              },
> > +            {
> > +                .version = 5,
> > +                .props = (PropValue[]) {
> > +                    { "overflow-recov", "on" },
> > +                    { "succor", "on" },
> 
> When I checks the "overflow-recov" and "succor" enabling, I find these 2
> bits are set unconditionally.
> 
> I'm not sure if all AMD platforms support both bits, do you think it's
> necessary to check the host support?

Hi Zhao,

IIRC, we intentionally set these unconditionally since there is no
specific support needed from the host side for guests to use these bits
to handle MCEs. See the original discussion and rationale in this
thread:

https://lore.kernel.org/all/20230706194022.2485195-2-john.allen@amd.com/

However, this discussion only applied to the SUCCOR feature and not the
OVERFLOW_RECOV feature and now that you bring it up, I'm second guessing
whether we can apply the same thinking to OVERFLOW_RECOV. I think we may
want to keep setting the SUCCOR bit unconditionally, but we may want to
handle OVERFLOW_RECOV normally. I'll have to track down some old
hardware to see how this behaves when the hardware doesn't support it.

Thanks,
John

> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 6c749d4ee812..03e463076632 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -555,7 +555,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>          cpuid_1_edx = kvm_arch_get_supported_cpuid(s, 1, 0, R_EDX);
>          ret |= cpuid_1_edx & CPUID_EXT2_AMD_ALIASES;
>      } else if (function == 0x80000007 && reg == R_EBX) {
> -        ret |= CPUID_8000_0007_EBX_OVERFLOW_RECOV | CPUID_8000_0007_EBX_SUCCOR;
> +        uint32_t ebx;
> +        host_cpuid(0x80000007, 0, &unused, &ebx, &unused, &unused);
> +
> +        ret |= ebx & (CPUID_8000_0007_EBX_OVERFLOW_RECOV | CPUID_8000_0007_EBX_SUCCOR);
>      } else if (function == KVM_CPUID_FEATURES && reg == R_EAX) {
>          /* kvm_pv_unhalt is reported by GET_SUPPORTED_CPUID, but it can't
>           * be enabled without the in-kernel irqchip
> 
> Thanks,
> Zhao
> 
> 

