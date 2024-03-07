Return-Path: <kvm+bounces-11275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE818749A9
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00B341F23C23
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24448287D;
	Thu,  7 Mar 2024 08:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zz5NoI6j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF14F823BC;
	Thu,  7 Mar 2024 08:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709800357; cv=fail; b=kqQoRcOlCI2hSyBZc4zq4ArEzvlUC1mtltnSe4uWpD4wFenbQQ+akxtqCAvJRDoulk07tvDX5VlDWxwF42UCN/Y97F7dcpMigLPDnmB7IjaWcLYlgBiRH4+IogPmQNu1VwwwLkgz2Xou/UrgY5s7DwbBCZNypluTOrpMCN6zUx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709800357; c=relaxed/simple;
	bh=LXdIxN0mIs+uI9zGFhUXG+K8Si97zd8av4RCE9C5sMc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LMc0Y5kuj9kO87NOCLuzI73h3LLQ+cAgPJ/5WhvHbWbCV9CHasDeMeUOoVXe8wxZcEpivNkID3N021xS1+R3U/lEDrfxTGsc4aas9x2HbGBk4EqbOLyKzBdpmTVmUfM/DNoGF+5FrhpzL97MyZjjDRTyON1vgSzRlto7XIneb/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zz5NoI6j; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709800356; x=1741336356;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LXdIxN0mIs+uI9zGFhUXG+K8Si97zd8av4RCE9C5sMc=;
  b=Zz5NoI6jMnl8mbkSVK79tbaPMlZ07ESecmON5DtyaOfVY9EjWDxXDFDs
   /AyoOInsr7tFdDBRNq0pvLIJcsjJ/ngUkf/UJgqIyegWPTY/Er7NxNNIG
   1xEyXlMIWPit8PA01+v0sX2F4hLVZTEclKrwmR78s2R8lvUh/4bWMObn1
   qRX2ngJmSn64Jwlrxr3VujugKMOtTD64CRwZiSDQgH/8LlYmfN4H+deje
   8Cu8KH4HUb6vRgaRPMo3bdEJfPVG+V7zJg0ZDkbe3DRk5VwSESNyQV0di
   OEC3rbBYz79EweCyXk+AQ4l01abtgjn1HtD3+79kQc9yESTNUIZLUUd0n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4600087"
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="4600087"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 00:32:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="14698911"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 00:32:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:32:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:32:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 00:32:34 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 00:32:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgXil3Y+c//nWH5osHGtvKRDOLsASntQeHlqMJksrOKj9vHlejzDeqf4nITozijI8NTIDG3t/Z1iULnVu4yV0cIURHeRO8EVS08Nzfp2FGQ8Wrv51g/pNB6dGT/c/hQEFd/EjuhSV3ZJcR8P0mtf/hSovbdXH0YUdY3fwsfhWfPVJ3F3LtWoYW9l/n2C1OY6ZpB2cUlA0gnFhdCIggVkJeHpg+OGLKrh7ndA/+iX7RwiBh47CtIG+BrOD0Swl8VfW390UCiCycwKmez3JYQeABKqEvNQKvv7ra5M60r3szUZHveGfvdTStX0qgCQl3KzvrBpU6Vizbi3rYLj2ZoCUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRC6fu7FZbfzNkJy/HoacSXXORgsW4e65rjMtI1f1mE=;
 b=fW/0MewRRvJE0DQIS/CQofbxI+x3Ev48TWvzXSUib2aY4pxWDSz0Fe6j9e3Y/ySZquCNU1eSAfIGZGnLgau91TzQDyot4yUMvTNaBJxwcaJXoxbbyPDhxPwZXN1N5DLu/3AlhZnZEqCAZ0d+nY8eCpNyXcOIysdhGyLRz7wctH0QPcjErl5lLa9HQJjvOdG6HZ24HsS8kAc87eLa74z0bLrWdpk0LBZTuaf6R+y+EoLVP9UcHLcHv9Lk1p/VsDiVUwBUV5KjO6fdbMEewBYHoZ1TmT9Axx5qPrQEpS9UVcQew6iKQaM5m6IcGXVUnQFO6GL6S3SKu6BEs6wJYcAhJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CO1PR11MB4897.namprd11.prod.outlook.com (2603:10b6:303:97::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.24; Thu, 7 Mar 2024 08:32:31 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::7ab1:eed9:f084:6889]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::7ab1:eed9:f084:6889%4]) with mapi id 15.20.7386.006; Thu, 7 Mar 2024
 08:32:31 +0000
Date: Thu, 7 Mar 2024 16:32:16 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 080/130] KVM: TDX: restore host xsave state when exit
 from the guest TD
Message-ID: <Zel7kFS31SSVsSaJ@chenyu5-mobl2>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <2894ed10014279f4b8caab582e3b7e7061b5dad3.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2894ed10014279f4b8caab582e3b7e7061b5dad3.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CO1PR11MB4897:EE_
X-MS-Office365-Filtering-Correlation-Id: d9714560-e2e5-4a12-d0d9-08dc3e81218c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/Kk9ggGiD9Dfad3F53jYskhKekJyGoH1a4UCivTo7eAUbEx+7pnloAdj3lyQ5MDAXryDkKmmcED1E4bIQa+/vuwm/lWLbSDdtNYcxCfD/1yiAgtDyq3WFfW2uqm8tJYQisrylTCPqIeuLr8yvrNY/kIRMqlE8qFQab+o4u95yG2UFa6VnSo/5S0LnNiSj+SP9Ule1HKPj1cZ43qiwEg8n22beNCNU9XRPspZtLQvtqM38B7YUh2LbvEFNqXV+u6qfCf89M2bQRioPJy/0fNFCjdVFRc900NCCbZVyXCed6aBjPm4YQYGRkWJ6KbMcpemNFXy41Ca8lOQsKZL5WEfgB/gVfxA9iell3lpnWfs7z/J/MmfBI2JTFs5OuqMtGeUpszj52mbpNjUkm73rKY5NgNlsyh+2AHyptMQRMngEArt8ghstggvn+KhTZZE6XInRLtePndfPnOo7zCXjE7aJ8GfvNRgQ4eEXOp/NkKjpzRnc5klfut2iANnHaTS6DVKm9bdjMyuXv9dHcA/QnZQOjLJiYuzf+JqL5bk+PSaRu20Avdwnzr1V1Bm1SvDDCCbfx+YptkWUxOGlmHgNpQlK5eTqPmtlBRVMxtQXfDxuFsTDlMMVx8Al9t/NmRliGnKnp+NTF/su9yEVQzner+6Y/O+59RWpQgymSMj2KQA0A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?imLSun0Xw7GaSaabQHiXs+fT1mQJ70vOoNnimRjbqd99y4HWQZFp0W6ue1+e?=
 =?us-ascii?Q?WPIBoYdlEU5lMNK09pGGPbbMAsWFfMQwNPBZ8wZagp/NGrxClJNO0EKCxcr+?=
 =?us-ascii?Q?IK2bqDFYS5l0v+dZI3HT3dgbLeZQJpwuEXr4Lq0TNT57HrJdfgbk3sM+bD8Q?=
 =?us-ascii?Q?lESeNR9Ssc2/KKMaCSj7MJ/EqC83/tzrIdr2jkM0gC9VQLbc5iqWOvTkB4Gy?=
 =?us-ascii?Q?HOEj5yJN3K3ihDUuayngDqDvm5RFk1GE+5DmeqvN98Ff5GGIIkbWNStZh8ya?=
 =?us-ascii?Q?FrZQhy9mEx7B7siToq3oW13KLEYgF220BJSI2pV4iiLwIHEtaiHRYF8Oj3cr?=
 =?us-ascii?Q?02CXJjinWpCL3gRpVc/jxVAhnw72AhsujjXXx8j7KGl6KtbJq+ahDlUs9vVl?=
 =?us-ascii?Q?2J7Sx3mK2n+cAxzrZFgu8cQmE0rp6nrvz+9OVJZsWd1kw/b4YBKPDLXCk57h?=
 =?us-ascii?Q?78L9Cl59CvNDRvsPEV6/L7rfXgDXBZMv0caFYayPPQmTsAldUk3AZ76Sg4QA?=
 =?us-ascii?Q?rap/qf+/DtyKr62r3r0jCIR6n838E0hA/JTjD1kJKKLevMY0U8PRjur3UNar?=
 =?us-ascii?Q?omSgb1sZE9PSjuzKNsBzbHGKmmIunAFQ6BShlR+zDvZJWycAcNfuGu1MKVH2?=
 =?us-ascii?Q?Nv9lqr7Xh5xxXAA1OIk1+01u7k5WDITbxOQB3DmBIgpIiffTQBNWdNCW99O/?=
 =?us-ascii?Q?DFAUcaix3d2Acix+kfX4QsfHKSI+aJgP/iU7dH1G4juQivn009Sw0xufOLkf?=
 =?us-ascii?Q?BfDiMpVmbYlccMDXb8c0fFg1sL40g4f/LKp96joRqwmYKUfaRg70WpaiEGg3?=
 =?us-ascii?Q?GsKCTnGZnH4wtraidfzTVTp/l0EynJtFWouUkpPQxKN99IbezPk0BRThAz6d?=
 =?us-ascii?Q?nbXJi79ARazxlaQxZ1HYmUkV+EYcwd7AH0PFpWRAnsTi+3geu59nN81RG2Lu?=
 =?us-ascii?Q?AdeYr01AsVLanXAQ4dfZDzhg/DlcMfO32Xoi5b6gy2zSILKlSe3ahScQ61v9?=
 =?us-ascii?Q?28poPgs5fJU5djjQ5nRt800asx0hJPWxREUa6U7SRUZILmEAqPKwz4mIOLt/?=
 =?us-ascii?Q?YmcHkjY4K47VPOo1r09Tr2OhLVDNu4mv2qhwYytaKq3jZLFRkz8c38Qy38LT?=
 =?us-ascii?Q?aj+oCBxWhHGA+VgssfRnI/xot5pXANPrbcZigUbwuluprxQ4wjTncsfc/IWT?=
 =?us-ascii?Q?Hq5fnTXqxldlo1C6SyjuuC+AW20jo0xxU0iJbeWeG1/+2RroF/2fj22qgxOa?=
 =?us-ascii?Q?F2eUyNGRnQc0ESPYBcTBgQuPX1hrFYn4cp0FN2gYM0K+jSGLSvtOS6Nk21an?=
 =?us-ascii?Q?RpWKyMdWpZwhNV8FZtDvV4m/I5ks5BVXtttf7FixOeEf65OnGp1CgmPmwUgo?=
 =?us-ascii?Q?H7raagfq8rKoET04ENUkDBIMsxd3vLsW97NYmquy8G6bq5RoCq7qLkcjlCCR?=
 =?us-ascii?Q?lmDMOwZ38NGumqNAi4ltrYU98Q8NMMMSRkWNIzzczMLwEaWbx1st6PzjYSlB?=
 =?us-ascii?Q?DLpI6KifNOa0GF6DJiXfY1YMwPmQ03I+sO8cb0gY8e/QHpW9M85sl7G+x+mN?=
 =?us-ascii?Q?y/d4p29HnNuEVIZPgEG+XVonf+waaqwcTb5J7/op?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9714560-e2e5-4a12-d0d9-08dc3e81218c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 08:32:31.6510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNhv/2EfkxTnsDE+8fEn2pMaiGS4palgZ3jdvfT0SxXUakm2TjSPmH96AucXoCUhR9VBgZM+xqybQJ2HoWw6FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4897
X-OriginatorOrg: intel.com

On 2024-02-26 at 00:26:22 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> On exiting from the guest TD, xsave state is clobbered.  Restore xsave
> state on TD exit.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v19:
> - Add EXPORT_SYMBOL_GPL(host_xcr0)
> 
> v15 -> v16:
> - Added CET flag mask
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
>  arch/x86/kvm/x86.c     |  1 +
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9616b1aab6ce..199226c6cf55 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2,6 +2,7 @@
>  #include <linux/cpu.h>
>  #include <linux/mmu_context.h>
>  
> +#include <asm/fpu/xcr.h>
>  #include <asm/tdx.h>
>  
>  #include "capabilities.h"
> @@ -534,6 +535,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	 */
>  }
>  
> +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> +	    host_xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
> +	    host_xss != (kvm_tdx->xfam &
> +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET)))
> +		wrmsrl(MSR_IA32_XSS, host_xss);
> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
> +		write_pkru(vcpu->arch.host_pkru);
> +}

Maybe one minor question regarding the pkru restore. In the non-TDX version
kvm_load_host_xsave_state(), it first tries to read the current setting
vcpu->arch.pkru = rdpkru(); if this setting does not equal to host_pkru,
it trigger the write_pkru on host. Does it mean we can also leverage that mechanism
in TDX to avoid 1 pkru write(I guess pkru write is costly than a read pkru)?

thanks,
Chenyu

