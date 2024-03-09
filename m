Return-Path: <kvm+bounces-11449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E298877240
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 17:29:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8610C28199E
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 16:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB4747784;
	Sat,  9 Mar 2024 16:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QjRdzJ07"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731A244C9C;
	Sat,  9 Mar 2024 16:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710001758; cv=fail; b=KCQ4DnZTEqVsoAk9JKqBhPs+4jxbbpqhvB7qZAuCXMgqOt8HTUogTkNY/g0o9yW3jPHVnmAm5iIR9ZobDfG9SBqB9bM0F/QKS1WR9M9LGvhqlLwsMwDVdoRPfbFuhu/X2aGaCmb4kJ49/E03Mxjize5QnWIPTWU05zD/C7nCvWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710001758; c=relaxed/simple;
	bh=ZAclD84bgO0R77dmQWr6VoHm6OHfuYHrOn2vLp/VtCQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZHa6FyXnxW2HQ13k0ntzVZ7L3bPFQQJzJLaPID6tvONT5tQqgwutIfuwnLU0BGfj6jyBg3/zpJsyWDaSjyLT+N55yOwRsRskDuBvf3H6A/JyqTINvYU+lfYo8LYTNmMQvzyZwhh6o/Ooj08/puoHZxKTO9f8CQtVn7PaKdWcn7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QjRdzJ07; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710001756; x=1741537756;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZAclD84bgO0R77dmQWr6VoHm6OHfuYHrOn2vLp/VtCQ=;
  b=QjRdzJ07Ts7D8nqsyPHOi/Yj/XNhvqxzGw0TDwIw3ljc4MmrbE3GXLW7
   hopLd/pZ+30ahreWMc7JIOy21tf0WhcLAhvLhDadTJpcRUMpJnCBaQIO5
   6Dj7AfhpNfsx26A8WESNY7ccsxMIC0OTzLVymODpFQKaqOds/IlzUDZRm
   B3AtMKOxmXKoyWoefxHCVqehZGAuMG2vgJkO5TtXUVsP6vYzcZU3MIzQj
   BS1+m/ADrz5kWbIy1k6E9PYJX8reujwVUj5t0X+ces21j8+XT2KtkNygV
   wqvWTEEtRHTM9vqggZViYiP3ihTBH4oxkrvPl7ra+qOobgaKNQg1yrgyB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11008"; a="4556253"
X-IronPort-AV: E=Sophos;i="6.07,112,1708416000"; 
   d="scan'208";a="4556253"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2024 08:29:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,112,1708416000"; 
   d="scan'208";a="10840021"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Mar 2024 08:29:16 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 9 Mar 2024 08:29:15 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 9 Mar 2024 08:29:15 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 9 Mar 2024 08:29:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAbLevEB2w2ntZx5wX+eHQWguMyg7rT/36QKpllF0aXqXHLu2gIzvARXEqSsCIUFrajfcVp1cbvqnZOVlv0Gr4TeVFTrVGWav7GJgZg8ww8MsJlVwpPuJKn8RBwzemHD0oVIny+442s6cm/eyrrf6ZVWyw79McdfHNtF2BW2uNXh+SEb1GOHbBOfv5Z4NbJ0XNa6XzU81bXtBeeqWhkd2tcQ7BJhA/h0eCjLmCh2yUEgzAqeK8XIcHlzMmeD/ikbfowGMSWrS0ol4SgmQXiScpk2YplcYMW0cK7ncfdL5J3YoJOKgmJ22dFfPy8wiiXFhE1bxo9IQqFs7XjLT4vq9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnMCSWN3vGcZ3AqVWG/n7CebCJSdjoXJp+tYofFQPjo=;
 b=AdYjFX72bAvVn5x2ennEE0tqAu4lfdIn1rRPXfm5k3Jhb3BxBsyaNgB+xBgBOwxv4HmoXnUtt/aOjy6+sMj2X3tl2H+r0zSED5JfV5mgtNliO9gCHttNBdTtIQbtlzpF6axxdy0mF0TXdsf7S4cvCuAsMpODbLFhBwKOLy/hucs9fgyoEMgZ96sh70N/vAyYW8eVE/RyPWVMjigxbw9SZxyad0wtoXVMmL2O2R7j7keKp6dSWhHoejWyabA/quqwX6bF9rRgPaRKTC/83musNJEAZUkULB9icq1uH3XcnO4YWXppjquE3FngRrhnyRja4IwfVuirkOFLBvJipxP9Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 MW4PR11MB6569.namprd11.prod.outlook.com (2603:10b6:303:1e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Sat, 9 Mar
 2024 16:29:11 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::7ab1:eed9:f084:6889]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::7ab1:eed9:f084:6889%4]) with mapi id 15.20.7386.013; Sat, 9 Mar 2024
 16:29:10 +0000
Date: Sun, 10 Mar 2024 00:28:55 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>,
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 080/130] KVM: TDX: restore host xsave state when exit
 from the guest TD
Message-ID: <ZeyOR/YaubFwyiOC@chenyu5-mobl2>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <2894ed10014279f4b8caab582e3b7e7061b5dad3.1708933498.git.isaku.yamahata@intel.com>
 <Zel7kFS31SSVsSaJ@chenyu5-mobl2>
 <20240308205838.GA713729@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240308205838.GA713729@ls.amr.corp.intel.com>
X-ClientProxiedBy: SI1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::20) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|MW4PR11MB6569:EE_
X-MS-Office365-Filtering-Correlation-Id: fff7818f-5bab-4169-be32-08dc40560c9c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YIYTCYQYGH+WkAXYCLMeVJqdgKLQ1RmHbTxaw3ergz3T4hTml46pGdJgCvpbiF1JdjoW6Yn43Mb8tP36p6Ccl9+zyXg4Dt7GO64Qw3DQFjflSP8gYr8f4ubGMr0+3KQ3VJQNA+XsuqRPDyNzog+aC76LuZUwvj14RIcteOmeVA13T389HB2/N9cnh0O8TB7dxQYCZ9IlVFMkJnQBROKm+Fes98qLhZSxgO/ggeX3D8yNgnMSD+WgaK7scn77wOLRmQVhaIDgjm/d74G3/9kUgMpk+oARk/s1XdqhV3cY50tIxIzzr01l1njAny+oqbnzO70GLiTdLu6ZLTFuC0iGhs7rNO5MXg2gFLE/cgEKxviCmpyiuPWg2FhKa9aLVqHXILKMXdSsMV7RzWIOtSPGvuroUCc2WDA/9ayuwP+D+3V1RMw6CNcF2wVsj2hZM2RqzcadbTEiRwbFJZbmrS1fPZrfqDGzGZnvFV4HVPYt2IWOXLxy9jtoMnM3J58BCYFR0bowE0tbnV+DIRL6zHazOtViQgZZqwYx1A/VuYY3WsKsxYUxLk9GqrqzXme2cn9CKb1fuxrh0/O/89xbskxv/3D+YBhowJogVHrQfiKjvhY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cdemv5TeaI9/iPkzY4gUwy4xAbsEANDDhlyGaU80Ekq3mGSR2tJ8nZCq/NyR?=
 =?us-ascii?Q?DYHy/+d85u9MxKJde0U7lIU7b27RAfEwY3AuNr1EfVh8VZ1QTA/oYPFeUKnq?=
 =?us-ascii?Q?+3Q09j3SyfNEC4e/0j8MLsepXf6QJpew9RxtSJG2WIIg8kb12y09gNz6+oF6?=
 =?us-ascii?Q?WufJxVmu4Iijef/F346et5JUX8W37tt0MEK/V7JPx03ZomNLB9F3nSQu9vCw?=
 =?us-ascii?Q?EUBCjrgHH2UOpFks5WmSp7myWt2ZnP3Vl2x25EsFdivc9S+Td6lm5wy1fEDw?=
 =?us-ascii?Q?+3/a5PolCSNzQb+LDW1z4rMqTJDdYtg4mBfVvVsT4GfsGbRRmD8ND8Ro53Hw?=
 =?us-ascii?Q?ssPLVWg0atcZIrhLQDrGAZTB9gkHGM6pE2wrVQq56VVajZQXhMjXixJjIHh1?=
 =?us-ascii?Q?1nfLOUC1tXqJ+9Z4KyfgD9DnIL0KTcAszr8zHLatMgPN0vrU5fzOrv8oVNHc?=
 =?us-ascii?Q?03uA6Qh0O5Badq28ejfJGQ185DH84d2+POp2s0bMtTALDhOXhDt8M8roG/dt?=
 =?us-ascii?Q?TkHrKDnaUffWQi+M+aYiW9ghvjwhb7nUalMT4RxDMqcpWzUBOrfDKADutSD1?=
 =?us-ascii?Q?gUv0MADhNxh9x/ooXrdAqgekvlwKk3dnhYKTvxeP7JXPOjxVaoH01LC/1GHe?=
 =?us-ascii?Q?7vmk7EGnLpAnu3bm7IxYk7b5z4FKwHKgrakp9mOLqM2mDZtuFOdsZKkexpUq?=
 =?us-ascii?Q?H3spEOfXy7VMAGRxusy3hsNISYmOMxqaFhuVr4fVJXyfIJpcmjlG2WLZtBdT?=
 =?us-ascii?Q?R/laEsuPLBb/61ynCUxt+taoLmYzIwVoE0iPQVv2WZpeAJnIPj1/awdZ3O53?=
 =?us-ascii?Q?4pYOYRP1naXvfG3ic1N2uV51Hj4J1nPzNJ2cIAXMvwcYyPmQqMMxg3LD94Hq?=
 =?us-ascii?Q?O8brUN+i6X+AoVgQEhIJMyQxxixkoblkLuTmfkUTDNcbQ7Yv3S65nDd2hdnj?=
 =?us-ascii?Q?ZufxU+iDk+lZtJEf7C/eRL/32kIT2kTXC39kw2/EnwzNUmr81BMskEGv7vs5?=
 =?us-ascii?Q?dud+6rQJh8bhnjcITnOuhSuryL202ju6hduTYda/KVfWu/lDaALxlzFapoVK?=
 =?us-ascii?Q?jV0hDbqxrOdpFLFixij6AvcT4wcIxs27GOxbm23LzehZ6EfkdkLbMMM9+LoP?=
 =?us-ascii?Q?JVSwuKX9lpkRL01/m0Cfn8J/Rdk1F+pmhhoZfJN1zT95F8pCWAzzISTJv/Hw?=
 =?us-ascii?Q?kuaMvs4fg8eYKXvZwXdstmtDfeNmniE6i1gF5cqGTegk+bBLwcBSlQAz61sl?=
 =?us-ascii?Q?eczq6N/uwS1+iHBbm2P+60tx6uXUaFuhWCi9z+T2Xd8f3Fy6zqlmspUJvCJW?=
 =?us-ascii?Q?1jGlWW16uMSRUs2cLttHk1KfPGztumlznEqCjcqP1EOsvAVhZUgalYhX/Om8?=
 =?us-ascii?Q?fbHUsrjGiWXUUCUApfQgs7hnHk9+EFmiwGSVEbtX/hd7sgfRLU9BMRN0krpQ?=
 =?us-ascii?Q?SxPryHrBlhOAgvFYkRqgz1EWZmcgKyn4RyYUaNt1iPz9VkqcpziqgMZOXqvW?=
 =?us-ascii?Q?9W2W2i5spW4Cajy5JQYZIlBDuz91RILH2kHpH8njc2ldJLktOl3jk8fw6ETi?=
 =?us-ascii?Q?mXE86q3L7+MBfAlht4TgzVVN1mnuZji/m29WnyOc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fff7818f-5bab-4169-be32-08dc40560c9c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2024 16:29:10.4030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tmfkeRF3OwRYNiq6y1eEeG4lIuVp7lQuZMldqTPXyuw8tYiVIbRpR/Zw6uHmUWnrMAe7RtwgmX6ggftyAMSjhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6569
X-OriginatorOrg: intel.com

On 2024-03-08 at 12:58:38 -0800, Isaku Yamahata wrote:
> On Thu, Mar 07, 2024 at 04:32:16PM +0800,
> Chen Yu <yu.c.chen@intel.com> wrote:
> 
> > On 2024-02-26 at 00:26:22 -0800, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > On exiting from the guest TD, xsave state is clobbered.  Restore xsave
> > > state on TD exit.
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > > v19:
> > > - Add EXPORT_SYMBOL_GPL(host_xcr0)
> > > 
> > > v15 -> v16:
> > > - Added CET flag mask
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
> > >  arch/x86/kvm/x86.c     |  1 +
> > >  2 files changed, 20 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 9616b1aab6ce..199226c6cf55 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -2,6 +2,7 @@
> > >  #include <linux/cpu.h>
> > >  #include <linux/mmu_context.h>
> > >  
> > > +#include <asm/fpu/xcr.h>
> > >  #include <asm/tdx.h>
> > >  
> > >  #include "capabilities.h"
> > > @@ -534,6 +535,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > >  	 */
> > >  }
> > >  
> > > +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > > +
> > > +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> > > +	    host_xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> > > +		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> > > +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> > > +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
> > > +	    host_xss != (kvm_tdx->xfam &
> > > +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET)))
> > > +		wrmsrl(MSR_IA32_XSS, host_xss);
> > > +	if (static_cpu_has(X86_FEATURE_PKU) &&
> > > +	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
> > > +		write_pkru(vcpu->arch.host_pkru);
> > > +}
> > 
> > Maybe one minor question regarding the pkru restore. In the non-TDX version
> > kvm_load_host_xsave_state(), it first tries to read the current setting
> > vcpu->arch.pkru = rdpkru(); if this setting does not equal to host_pkru,
> > it trigger the write_pkru on host. Does it mean we can also leverage that mechanism
> > in TDX to avoid 1 pkru write(I guess pkru write is costly than a read pkru)?
> 
> Yes, that's the intention.  When we set the PKRU feature for the guest, TDX
> module unconditionally initialize pkru.

I see, thanks for the information. Please correct me if I'm wrong, and I'm not sure
if wrpkru instruction would trigger the TD exit. The TDX module spec[1] mentioned PKS
(protected key for supervisor pages), but does not metion PKU for user pages. PKS
is controlled by MSR IA32_PKRS. The TDX module will passthrough the MSR IA32_PKRS
write in TD, because TDX module clears the PKS bitmap in VMCS:
https://github.com/intel/tdx-module/blob/tdx_1.5/src/common/helpers/helpers.c#L1723
so neither write to MSR IA32_PKRS nor wrpkru triggers TD exit.

However, after a second thought, I found that after commit 72a6c08c44e4, the current
code should not be a problem, because write_pkru() would first read the current pkru
settings and decide whether to update to the pkru register.

> Do you have use case that wrpkru()
> (without rdpkru()) is better?

I don't have use case yet. But with/without rdpkru() in tdx_restore_host_xsave_state(),
there is no much difference because write_pkru() has taken care of it if I understand
correctly.

thanks,
Chenyu

