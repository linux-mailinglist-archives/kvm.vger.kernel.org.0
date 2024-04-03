Return-Path: <kvm+bounces-13419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EA98962EC
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 05:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BE7A1F245D1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 03:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668C22E636;
	Wed,  3 Apr 2024 03:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WKXqNO/9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4ED1BC59;
	Wed,  3 Apr 2024 03:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712114736; cv=fail; b=fgSmjPSuKZL/6TKAAg4aKYP4c8C4XukW2rG39RC4jO74A0YPGatAbzlR28/iTnjNmFGQymzyZJ9W0F5Y0AGJ+pCNIVSR6K4v+cvaWKlFyfh/J/SSDKa9dGGAHJrv7PHD0dFqg5x8B0FnGTQ1AJDd9ppkKyhmCzGHd8+qNqNiwX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712114736; c=relaxed/simple;
	bh=FZrZ29P9tD49Ls5ErHt6giAdwEtYjp88Xj0fXt0wSn8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rL8hMTUXlPn8Rs8M5QQ+nKTZEoV5KJvGfM2M/aUcN2xB/nZ1uz6n7RBZKRJsMcCoH1gnRtJr7K4ZnQ4U8uPMRyb8luaGiAI6MmBhnNo8rwZZeXpYoUWWxw6K0KCRX5fEZgYiB3rSMbZo1lhdDaUlfWl4SkjqlfSyiI20QLLEu6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WKXqNO/9; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712114735; x=1743650735;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FZrZ29P9tD49Ls5ErHt6giAdwEtYjp88Xj0fXt0wSn8=;
  b=WKXqNO/9KbEpeLoli9IDx1Phi80o3+GYOVUhbCmzhRnnU+2xZEr9DeOC
   RQg5Bi3hrPlilBW3Ig0E/NYfCGAxnyJjNCdWR58EmR3RH9dWnIWD2xJhZ
   QhhnBjW5uMC0ThJ3OotBD21ECBc5ZMSJYWTxXWqcnC2OKfYlMp208UcgV
   zqzmag7u/Bw4+KWoDegwPy18mEcGSUSZF/jKq2pXeBEuwvoxRM1gW9Jf/
   ozd1R6++eKQUHoohf4s5UdD6WSDPdA0C19SOGepUUMPfSn6Jn+bVyQQhR
   Wxp1K+6LKyg+F8BVZXdbkdOCzhhXKV0KZhWmHbuJoOxm3CzUrTD7AaUFZ
   g==;
X-CSE-ConnectionGUID: Wn35WBNNSVukHUXb8v4pAg==
X-CSE-MsgGUID: yfuvWY4wS0ST6nWSCtsu3w==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="18769019"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="18769019"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 20:25:35 -0700
X-CSE-ConnectionGUID: aNTxGoeGSvCoAjcX6zelLA==
X-CSE-MsgGUID: 5JG2WuYgQYSxNp6o9M7Htg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="18349523"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2024 20:25:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 20:25:33 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 20:25:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Apr 2024 20:25:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 20:25:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EY755Q7e/F3ORke3B0PQ2NQ5/OJH48FTnUQRAagnTwmmNStCGvxvRIVZ/oIpsnsilrJ2WKIOrni1LCjCFtM/wRTzcXWaodphfvsbIVxBNt1qJa2/yNapdhnF9CgiZZxd+S48ct5LTZ7iaFkWUzL/161FNdZNwvCcB9RH4ICJkCv3FvE96TPSkHLOqeSZD1gXr8vbxwv/PY5k1sn9mrPdfdd8yKsgvgQjKPeIKZNM55wKMlPU9A+ehDa5Dbj8nEUukf1w8paZvHrrP5s0Qb5y+dJLNgXZ+vexBo7MOikDXWGp7qrk9wXnFTtd/ApoDrGkWd6TVCrTCPjTRlOrC+JJ6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+az/0opsm0BgSQ5qTNtTHTJQ1H+xW8FyMpYzt/375aY=;
 b=QKgpQd7U2LiCkE0P+esI5fHR5HA7ZBw0I+yR/d82bCQCRw74fmhnsLFQPUTVoYNyeJB2rAK3yKGwQIURMIs8gRBUtHHUhEJcU9L/IH34Cdg8v86RDNEqHsBp1vLCW9G0nT7JwOZ61RzF7rGZ2QIYCMI82+WUGe7/wUOpEI6tBqgKq8rCVcixFbsUba29TmJrEorV7c2MA905Iwqve8PlfJPUIl9x5xPcX7nI0zj3nzGKlrbNl+SqXlj0dpvuuvYls1WKZkRQxKQrmVI2SkIUyy1VEXUh2PQE3+jsNW0I7eJH7wtmqHifYUaLXmN+XdIS4ORHY9fx/1rcpf6SDyOoKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW5PR11MB5929.namprd11.prod.outlook.com (2603:10b6:303:194::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.23; Wed, 3 Apr
 2024 03:25:28 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 03:25:28 +0000
Date: Wed, 3 Apr 2024 11:25:19 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 108/130] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <ZgzMH3944ZaBx8B3@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c083430632ba9e80abd09bccd5609fb3cd9d9c63.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c083430632ba9e80abd09bccd5609fb3cd9d9c63.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:196::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW5PR11MB5929:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +IRWoYDl+9kfE0vUVkIMY9/0g45jrviIHbpmuF96Cxh+Klp/W9qUv1xztf61F24mcDSPfej20Dw/YfGEhx1++HkVj+Qp71i3wzRqxExZ+++3EMtjEMRHUxjGS3XGW3nIq9D2ukw4fdkUui4qv2wnS1/+9HHX0R0PpyB8fXleIa0pEZUjS4dacXKksymOib5j3Kgv2xwN986Rn1sfL6UfHxbsUlZyjeNtOc305zhlDTMm3rtMwBCshAUumR7BCQy4gDCq1F45JhI4RxcHqY2ZS+CXRzPeOaN9wTub/0J8guxU4imcOpBQ2UEIugS7Ms3NOLA018JJt1ktH0qQfZ5kylxa8Pum9jpEOZvjfbR7YoQXIsdT9HgdurGUzb3HpejJ7evwZ0AxZwZr4Vz/IAlEAo9H31gM7NZ9sQIW8EasnRopEC9W0b+/53l2oVIACYtoPNxdyuU4bgTwUC7/7LK827orkEHRkS954mfpm7qcSbPMdy4eXPMA6xxsqPWVv2clHqwaKhuuMw+droYVSQa7Aqx2wLwSdbBU6ju9LN3Pvkw+9JMknHxb7778g/7f8Speso0SCJTpZ06pcV4xW/79AJXPVAJWOfV6HdBRoIOEmiu/kvUnPXpSZJDXTXpEo0Rl20Wx4Gq0bSMG/XNWb9/Z3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V9Rr0QFnPR182LGtbaAfhjXthQkboj8AbwOIOYWkAt/t45rMQ/jISXyc8X4N?=
 =?us-ascii?Q?DqmSdqnw7jzWrSqjLX9uMeYWeZHRQ01zWpfN4d7ULwX3VMQrA5mK58IJIyEh?=
 =?us-ascii?Q?04y3P3GAG471s55rOAnZebrMbpdDciN1x0ufdud99mYViNxh7Ko4ybJjJfMw?=
 =?us-ascii?Q?khSMCqveJJMBneubbr6jGQMtseG08sBpskhXu2+fpevYt6IAaJxN4CcC0dqw?=
 =?us-ascii?Q?Wt1AeMCgSUNDGFjLd3Hhp7EswCvdaa4lHW9PdUQYzjFqnbQf4ZMArA9lbosK?=
 =?us-ascii?Q?jrsMQQDHO3pF1mipiuRBC5uPhJDSD3eD2z8yznB9qWZ0341VSNyqQ89oHJ2t?=
 =?us-ascii?Q?+b8qA0vVtwm90rXzwObq9E6voAux4qA8wfqW5b7/4971uYZr2ckJIrPpgQX1?=
 =?us-ascii?Q?ZLqM000iI27OyR7kpJLIz23wftsySQ4drmUpAjlzOorq0Ean/bjEcnze8xQP?=
 =?us-ascii?Q?3VI5Kz5iEvZdox6NixML3PD3qo2XWIkO3gs7MVnhIXKrVrfsAQ8Ymj67lilu?=
 =?us-ascii?Q?P75k3iENlv2F4bm0NAHzccl9+S3rCNARwIEmCSQ6cAIBMVjN/tZVbgiySTBA?=
 =?us-ascii?Q?L+mP9HD1EP/o4qNdHbx/SGH4r+W/SUYpC/Pw2i/6fyrNelhfGBXXRmKT//IG?=
 =?us-ascii?Q?Knfbd4UqjY4gCRCR/zzM/dTqz5NtT0zegQ0mgr6nMIDLDP5q8zX3mrb/xwtx?=
 =?us-ascii?Q?gJKK4DBY3DYLL9DTOox7d/tqsWh+JPTD0PEnMpd4o+xoHk8vmLK5//k2UMym?=
 =?us-ascii?Q?/JBxE4JUkgK7W9E91NYhQiI9OqESMfu3t+LesdfcTDya1PdODtDPjvFMEZGh?=
 =?us-ascii?Q?U6is0589UdHlUnHrOsuCVb7p+WxgbN41QoLEyQh8xQljjJ1Xe7706xZ3J1NV?=
 =?us-ascii?Q?ZFLj3x9xd9fulVaBKXQVxrOrz3aGxT3LPh5mZpS0RJnX3+DPQd+jknth2Ap+?=
 =?us-ascii?Q?qj9U7TO5R/F5Lvovl+XkT1IbtK5i2R4Il9+ckPmz/+LL3wXk+YAMr001hk15?=
 =?us-ascii?Q?Z1G0kEZCne009KzaTWLpmXP8CgBeITX3o792M+si4wZu1hg66jLRFkQ+D8Ie?=
 =?us-ascii?Q?pskupaPJt29lVq2Fx1SAorKZgzUHv2OqBcaeTpc96snh+up72gW7sOLxjlz5?=
 =?us-ascii?Q?gwvhtK8z/oQ/BtTpCogzjUHhW9H32LjWs1YIsTySTsoKOCTyitfxiSRDwOWT?=
 =?us-ascii?Q?JZ8NnmJChYXmmRPbYmnYh9t8JgQh1jilBGxYffXdUTjJeJ5jmk/P3YsfVncv?=
 =?us-ascii?Q?PPLwVF7qUh8Qk6BQBWpx9PbndV5mCCBUJPKq4mRtrfoDhTE7ROpsM1jOHyLq?=
 =?us-ascii?Q?7h6PtVEtwf3/hvXbxlXW6ShBFN2uIWNsQBwh+VWE1SnKwF8SWf3g0hT4Zzqp?=
 =?us-ascii?Q?XdF6Xb21c8XlU/ihcuFHIOXbG37wFrb74KH0RQ/drudXxOgRQ9F8oksedU6J?=
 =?us-ascii?Q?s22lqM/XbG/UNe1Za7zKwuXmWOaWjsh96IYTPDDi8QMfqg+OjqQ752BfZ7Ms?=
 =?us-ascii?Q?gd/SAESujJ7tlVvC0MxNoDYsZfDrXXrmWmr7v0C2Uac5fKKa+CDgpOabKxmT?=
 =?us-ascii?Q?nTL4lOVZd3aOGJPTzdwHhJl2BOVi1QAk8Qu5i2EK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d44092-ff1b-44eb-b59c-08dc538db58e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 03:25:28.2676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Of/fu+CmJjZujtQJ58hXytddQaeboAS8aoZmAzPlw+Qb4G0NSaBHAu8WW3ECXBPIZNsDzBHfVwvyZdMSsUGtKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5929
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:50AM -0800, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Wire up TDX PV HLT hypercall to the KVM backend function.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
>v19:
>- move tdvps_state_non_arch_check() to this patch
>
>v18:
>- drop buggy_hlt_workaround and use TDH.VP.RD(TD_VCPU_STATE_DETAILS)
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> arch/x86/kvm/vmx/tdx.c | 26 +++++++++++++++++++++++++-
> arch/x86/kvm/vmx/tdx.h |  4 ++++
> 2 files changed, 29 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index eb68d6c148b6..a2caf2ae838c 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -688,7 +688,18 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> 
> bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
> {
>-	return pi_has_pending_interrupt(vcpu);
>+	bool ret = pi_has_pending_interrupt(vcpu);

Maybe
	bool has_pending_interrupt = pi_has_pending_interrupt(vcpu);

"ret" isn't a good name. or even call pi_has_pending_interrupt() directly in
the if statement below.

>+	union tdx_vcpu_state_details details;
>+	struct vcpu_tdx *tdx = to_tdx(vcpu);
>+
>+	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
>+		return true;

Question: why mp_state matters here?

>+
>+	if (tdx->interrupt_disabled_hlt)
>+		return false;

Shouldn't we move this into vt_interrupt_allowed()? VMX calls the function to
check if interrupt is disabled. KVM can clear tdx->interrupt_disabled_hlt on
every TD-enter and set it only on TD-exit due to the guest making a
TDVMCALL(hlt) w/ interrupt disabled.

>+
>+	details.full = td_state_non_arch_read64(tdx, TD_VCPU_STATE_DETAILS_NON_ARCH);
>+	return !!details.vmxip;
> }
> 
> void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>@@ -1130,6 +1141,17 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
> 	return 1;
> }
> 
>+static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
>+{
>+	struct vcpu_tdx *tdx = to_tdx(vcpu);
>+
>+	/* See tdx_protected_apic_has_interrupt() to avoid heavy seamcall */
>+	tdx->interrupt_disabled_hlt = tdvmcall_a0_read(vcpu);
>+
>+	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
>+	return kvm_emulate_halt_noskip(vcpu);
>+}
>+
> static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> {
> 	if (tdvmcall_exit_type(vcpu))
>@@ -1138,6 +1160,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> 	switch (tdvmcall_leaf(vcpu)) {
> 	case EXIT_REASON_CPUID:
> 		return tdx_emulate_cpuid(vcpu);
>+	case EXIT_REASON_HLT:
>+		return tdx_emulate_hlt(vcpu);
> 	default:
> 		break;
> 	}
>diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>index 4399d474764f..11c74c34555f 100644
>--- a/arch/x86/kvm/vmx/tdx.h
>+++ b/arch/x86/kvm/vmx/tdx.h
>@@ -104,6 +104,8 @@ struct vcpu_tdx {
> 	bool host_state_need_restore;
> 	u64 msr_host_kernel_gs_base;
> 
>+	bool interrupt_disabled_hlt;
>+
> 	/*
> 	 * Dummy to make pmu_intel not corrupt memory.
> 	 * TODO: Support PMU for TDX.  Future work.
>@@ -166,6 +168,7 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> }
> 
> static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
>+static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
> 
> #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
> static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
>@@ -226,6 +229,7 @@ TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
> TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
> 
> TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
>+TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
> 
> static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
> {
>-- 
>2.25.1
>
>

