Return-Path: <kvm+bounces-11348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB21875D46
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 05:53:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A15F1F218A5
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 04:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA22F2E642;
	Fri,  8 Mar 2024 04:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EGCEski/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9C723775;
	Fri,  8 Mar 2024 04:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709873575; cv=fail; b=oN/HQkjHxHLLyZdqB+Zl2uGeJSKpfMIy0qwMBodUAD82mBqfhwGqUJ18om2kfCJ+w4vLihu19vPKxb4ey0nB5cUP78SPp7l2ZaPaqnmCAo9yiZx191CqJA93WJhwEgtWH/R4hRCVukxX+/r72OH3vXtXapSgJcaaKxbtR16cOlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709873575; c=relaxed/simple;
	bh=ZLhRerQ7Tyb3ZgHevvnWA+LZEB0c35gIxMRDWjC4fjs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RLo3yj0ieQnwhMCu7nDa32Ttrj7omk6FKw6t659Av7hdudYMu2j0l5zMlYroE/j91VYEOyLstoT5LuYU1WirWnb/kHcU3xGAsvgeZbT0PncV9NFen+bB/oYGnNDJqb50ld1gCOqaeiitYc/HzfXalq5Gzw9t0yk95ZolAAe0OqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EGCEski/; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709873574; x=1741409574;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ZLhRerQ7Tyb3ZgHevvnWA+LZEB0c35gIxMRDWjC4fjs=;
  b=EGCEski/JRgXQtpWo69HKbJtfqqEBshi375DtnFYl+vz0HzJqItU3M9n
   I2D2nNVlNFToHyPgpwkKwriYlT5lxzjiZqEFZtRvvlGAOSef/DyxLVVGA
   xSrLNWXnsr3ejb4XSBx8sThbZAJJvWIxSMm1y4rdsZMqnymJV312sgB84
   3HwUnhqJ3oLwjZtdh7Uu5DxT9sudDyOqcCMcaSMTQZ+EIxJ41Vl6FSPuG
   rAxUU2pCxobZyLcPuKCnCPFhOI5CeLhVE1+ZCqkRH6SjkHMBOAJvlhQc9
   ILWceW7+MdHHm7EOag2c3p+de0PvYfoFTfd4RtnmksW0+6O2ogh8uPRHr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4760883"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4760883"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 20:52:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10397471"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 20:52:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 20:52:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 20:52:52 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 20:52:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgLvCRgwuTJ7btoR4sExdf6pnfXharZlyM4lgAlkQDD0rrQ32cuUdVNEmUSGgmznOcGzxUEr+6w/1MKIBeN5PexRCNoCFFQVZDelSzDPdTt/Ikan4B9b5YDJVE1+QrcZcfN1VCSvjfjYONz80TqyTnC4ptYlBGK6ZMMzPtMj0drV+JZa1yXAi4NtP9Fknp0+EHE6fZ7D3rN8orPnHXIO/WqvStMOyhDDoSqo4+jy0VR8nzhymQzbfNi91c1OvE14+PYgtfDW/rVoMeH3zA4oRxvEXy6HnRYGyDvRh/fLMAnB/R5GutHASsntHQeM8h+qqPcL3qCV8qvkM8z7Esnzeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eHtNPVTiwFBbHUkVPQF3qvwQGnSep8Ub4hbhyBxUKA=;
 b=XeiE9I3YKIfbkZq3FT1ObN3RLxda9v7WgTaAzxhGeLqm7HN+OYdivh6awgR1VUns7tRh68mDW4hjtUPs4FnScxB/s/VS9ScDrvMD2UnVGoLGXVypRcoj/bcyMkQ5Iia+aqD1RRQ1kJLGRIQwRVk5kv0wsTAAGNIh74gcpGubHgNwBitKLwg9XJqB82qpYjr7RqG6o3ycZ/az71XXVYreMXz2ake5jYnWKkSF/x+necOGMve0PVoQy0ev7McAWzjkBc8c/NhOoE/pqJSx33xFl2x0ZGfR2kFReMMKzzN6bqFh5BEksXXoVQgJv1ieq+c/xzBKLjZ8ah19Ijq4pgP2xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4757.namprd11.prod.outlook.com (2603:10b6:208:26b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 04:52:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 04:52:43 +0000
Date: Fri, 8 Mar 2024 12:22:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
	"David Matlack" <dmatlack@google.com>
Subject: Re: [PATCH 01/16] KVM: x86/mmu: Exit to userspace with -EFAULT if
 private fault hits emulation
Message-ID: <ZeqSncClqOQqCO41@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240228024147.41573-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0054.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4757:EE_
X-MS-Office365-Filtering-Correlation-Id: 58345414-2d89-45f5-0fd9-08dc3f2b9726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yMC08dmVVB6wieavLc1xxAH8RtO/eqANiJ07HW+frh2MEK56Zy2r8TCbAnSfegfOUtW1X7QoUBfYuVhCxnO3Vay6K3BxACB7taY5wOW9nO7Z+4cgKiJvPW4AZp5S4aQKyvaaQhTFoDdVy6ufBgyMPGZUbX/u0Q/MeCgimCQul13A28PGrS9lGMqBf+BPQcuNNUl9yJ8+M0M/KSLQ+WoVW+Igu4l3LXckbOFLoINO/hJlB79OhMpjaezARu1v5X5OWEfSwUx0P7PbRZhotXOzFB9t2AhtFJJIdrAXAcuWkjtKQftsSYTj3KtAcw+lwqLDAs3XzQ70q5yiIdppXfz+e8VFn0sbXMjoiMeDV2t5pofC+nGouEgr9gJdd8TaHLcsGw/wRv/9zCUkt7b64eBAL5H97B4DxdhkhDxEmw6BRicmeVk0RIILyBdGwSQZ8NhCFgIZ8WSPUuKknktUQdszHBtkruc0ArpV61Rvc1tO0Cq6h5vxUIHTuwQKOr8zDo4f/kyWH8X44BKts1dKV3htWxXccOQLT/I2RbUscKMDmQBNd8vcRAM75/IWSuNWKeqvQPsO/sFOhkqpXndQmgjFvki1YfyXPg3unK11rvZ55ICKGc2IfFkFKNo8Zhfvs0HgJ+8YkMvRfjumPx0Fz3Q9F9oShPfvTbk/pu5CWdXdGCo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W8Fub0NOgjsXVygcGaSWTJE/EFfsxoSppAddjvJzyHMjvuuEo4ozMib5/4z3?=
 =?us-ascii?Q?Erzq2T2Epnmx8b8zAkU64ktv/THycR4fMO/SzDDsjEi45wm4caSzbeUVw7+E?=
 =?us-ascii?Q?MsffbqdY75KjVSUMrkbKulChG2H51VCitLgZUrdBpRSSJyhs29XYo966jcC4?=
 =?us-ascii?Q?iWBZ8Dgwmar0JzAro4VPMUCiZtfPbUE6s49eKgJVYeEMFkB56G5Jd63MPuca?=
 =?us-ascii?Q?GnZrdzDIDS8AJcYPfY4zTyNkOg8jCmfW9Z8sPD/eue/Sbj33/LGllsccDjbv?=
 =?us-ascii?Q?2noi1A/HDTtJY+1gu9pouUxyylCmKlgEfPgmQYn0vinIOAVCS59E3KgzDBuk?=
 =?us-ascii?Q?MpVPQksoM5kvAbz0CoQ/9L5hwzpscV7IgEDovLA7hJyqE+I1zzPKnm/H39ki?=
 =?us-ascii?Q?yYWdniAQct+1Oot7ng9gjMgD6zoOgYD5HwadZIoHKh2zAKJXQ/s/+uA3re66?=
 =?us-ascii?Q?2BfK/HhXQDq3n3yitwmN6Oj9AUjyLrKgEQ+TOZdLDeB6As9IV2/q5DNvRfjb?=
 =?us-ascii?Q?+8oxTv+MqVz5iREmDDv/Y48+3KEC8Lh8duZg5b9OJIjsDPPpgXttf5c0UtZa?=
 =?us-ascii?Q?PmieO9XrfjciBJgD/pawB5MLW0S01bvglO9cpLdMOq8NY4XI9CbS+aQ2TRhs?=
 =?us-ascii?Q?PlPawEi3fy8its7xkl5iSL6b/ZrbLqACy4FMyYnX66Ed9GUWr+FX0pFd9BwG?=
 =?us-ascii?Q?pvzJjyyWp0bgqxq9qn1QR41MfeTFmXJZ7iQR7xtTxb563jT1F/C4Wuq2vqIb?=
 =?us-ascii?Q?5Vx/pN/3hl+tx93LyynheNpa6Ydq9q6ysy1ryAMd7GnInPkAK06MqCA19gJx?=
 =?us-ascii?Q?42PPMMzJsjxTjj5xW+2eYjQmW5vAjFKu90yT+YtlRanoRoj1MOJp7yRbxsSA?=
 =?us-ascii?Q?o9ENNAgDozi7CCtLXfk4WCzeUykCTgnVLqgHmgfYp/e1yYshGa2whpO71j7M?=
 =?us-ascii?Q?fKQvHG7ylUdkzSaNULXTp0VkL59ctou4Kv8YS85v9QKjCFv8C5EX2mydk7Ff?=
 =?us-ascii?Q?XrEZ4dB2w13VzyzjWRP/Z3GiWSzj0WyXPn6q9/kT+0AeYNV+0U1Pl9wXbkLo?=
 =?us-ascii?Q?Ri6Blo8E1b+3KaRi3i5TuBxZgxlEfNE4c8K+/aAj/XriwTCY0dSsn2X+tf+6?=
 =?us-ascii?Q?vVh1qSd9V94gW/eAMObDdcQMrful6TNknErPq6NTILfHuMTUcn2hQceMefjq?=
 =?us-ascii?Q?+AHkUpx3M42Gpzs5NgvFhr0731rs7/BSg/WyJtYVcKQazTeEaVRxQXKQeP2q?=
 =?us-ascii?Q?W+zQGQGvcqEg170pvgYR/28D1pFIqeUy/FnRWE/v0WH1UmODNHIUrqooAjH8?=
 =?us-ascii?Q?c7MQe/c9WDARLAvbPqYimCPBPGVSKBPMuaYYvZgQqbTy5i+X+69qMcLX792L?=
 =?us-ascii?Q?Pi50O1nnsZAw2ooHDWFJkmG91xf/HB+YJNGInGzw5vuQsXIOmCXa4vKHzvZX?=
 =?us-ascii?Q?N+NYJhoWxesfHI2tTH+l4oHGt2hDFdkETscsbm6GSKc8Ki2tgmyDRiQEPzWw?=
 =?us-ascii?Q?WgJXcnjUVMY6lsNCcB328LBwCWhdAz4v59Yw2biHKe8qAfrcnomEeZaaQFaw?=
 =?us-ascii?Q?bnHgLJNGLQHzKosacihIJTAYhu5njEDO5s1BO8/T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58345414-2d89-45f5-0fd9-08dc3f2b9726
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 04:52:43.2825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJHooAemVunuxvjecVK17K0bjCuHEaqvXozPSJOfTXb+84tT+g5DGxH173BsrfESJJqHd6M6v0CpEqUdsCxgXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4757
X-OriginatorOrg: intel.com

On Tue, Feb 27, 2024 at 06:41:32PM -0800, Sean Christopherson wrote:
> Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private fault
> triggers emulation of any kind, as KVM doesn't currently support emulating
> access to guest private memory.  Practically speaking, private faults and
> emulation are already mutually exclusive, but there are edge cases upon
> edge cases where KVM can return RET_PF_EMULATE, and adding one last check
> to harden against weird, unexpected combinations is inexpensive.
> 
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          |  8 --------
>  arch/x86/kvm/mmu/mmu_internal.h | 13 +++++++++++++
>  2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e4cc7f764980..e2fd74e06ff8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4309,14 +4309,6 @@ static inline u8 kvm_max_level_for_order(int order)
>  	return PG_LEVEL_4K;
>  }
>  
> -static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> -					      struct kvm_page_fault *fault)
> -{
> -	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> -				      PAGE_SIZE, fault->write, fault->exec,
> -				      fault->is_private);
> -}
> -
>  static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  				   struct kvm_page_fault *fault)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 0669a8a668ca..0eea6c5a824d 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -279,6 +279,14 @@ enum {
>  	RET_PF_SPURIOUS,
>  };
>  
> +static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> +						     struct kvm_page_fault *fault)
> +{
> +	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> +				      PAGE_SIZE, fault->write, fault->exec,
> +				      fault->is_private);
> +}
> +
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  					u32 err, bool prefetch, int *emulation_type)
>  {
> @@ -320,6 +328,11 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	else
>  		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
>  
> +	if (r == RET_PF_EMULATE && fault.is_private) {
Should we just check VM type + RET_PF_EMULATE, and abort?
If r is RET_PF_EMULATE, and fault is caused by accesing a shared address,
the emulation code could still meet error if guest page table pages are in
private memory, right?

> +		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
> +		return -EFAULT;
> +	}
> +
>  	if (fault.write_fault_to_shadow_pgtable && emulation_type)
>  		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
>  
> -- 
> 2.44.0.278.ge034bb2e1d-goog
> 

