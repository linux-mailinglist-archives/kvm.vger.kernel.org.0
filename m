Return-Path: <kvm+bounces-3063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C218003EF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 07:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCF5228181F
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 06:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B639111739;
	Fri,  1 Dec 2023 06:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S9rvc/Dc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BC4171A;
	Thu, 30 Nov 2023 22:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701412420; x=1732948420;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W/37fozz7ZQ5iBJhneeRnw0ayuS+mPbhzztxOsEjmRM=;
  b=S9rvc/DcL3MX/rYITDSJ0iFUgyrjOf6YvRpwLGfRrBSN/EvPz2VmZHoG
   u9wQMEchWIPdVSvvFWu5Ce3zIlysWwg8Q9UavRD+6dPVLSmfda3ZHN34Y
   1z5U0h6cmmkZq5I2O+V4/Kaug0qdIwjetsHIDSWspf2s6ApLBnTKXNruL
   h9wx8MSSHtzNLTrN651dEPFf0ldh3Cy5DfBw3MnDWtsrpCgnWtR26K/PD
   01wAtpWRwHassjeJuYS+BhzU8ww5SvTLGLdRxhRnciZ1QViestmhTCIl4
   9ytdmR+2zDSphgq1jsfNxZp0yqXyI8/nON3oftdS7cDLnXyEorGfbu3Ur
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="390611679"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="390611679"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 22:33:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="745891512"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="745891512"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 22:33:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 22:33:28 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 22:33:28 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 22:33:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf1/860w4bT8Z43wqF/vgqz4v0SlsZsv8qwgCOwBN1QgQIatMV1gTOZQM6shLz0+9bu0hNsX0lhoDCs8XI0Kglhhk1phOxlMl6aAgfcW1jjUGeRGMSeJuJ8EOfixZyR4PqJpseixfC4s+m2qiviB2XDd+NFq9ogrJ5omGalL6+HGVw0qx1s8WxT2cGZheS9Nlqq+3GQtNUg8R/ERCez7DOXUzbhFMZ8IKgrpnia3z3oM8Y/hcCHrsVK8kIij3y0dNtwlqeWCLRJA/t7TrCCKEdFhroSg4lr7WDf6KClhV3rG/Cw7rlUDxtuQDV+bIMvEk5T0MRK61bhFhhb/23xuKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXOzSIeeoxfZbIy7nXYWec3R74DFgQjdMseOyCWLSno=;
 b=HFPues10HTDIx2mnChSYSPuDXwy2KhQ3fwXQkIlHXd87+G50II5IzTHDc61Fsy/SdQCx3QXnW8v7oxUVorMWozAFywzizKLTVlSvQJKFZxBW9CNXk9RkdPtxtKT8CczKnt2jlnsXJihjVGDwOekgFHFCyWozOGdmyrj+JVKOnQj2XVVpsHNRzDGluXCU+uNM1wYTrqqbSr3AkFqZsrnui2TXS5Z34vRnyzVKDK+FXejkVQGfCBDa078yNmSUrl/o6+e+kcNhlOk89vcnL1vOn6NtqbdNkVhKZVOxx/JLoQji9wn4LNZpwsXUM2ji5JM0ZXQAbQajUFLQbr29BeK7vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB8208.namprd11.prod.outlook.com (2603:10b6:8:165::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Fri, 1 Dec
 2023 06:33:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 06:33:26 +0000
Date: Fri, 1 Dec 2023 14:33:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: Yang Weijiang <weijiang.yang@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <dave.hansen@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v7 22/26] KVM: VMX: Set up interception for CET MSRs
Message-ID: <ZWl+K55yUaCLCtqw@chao-email>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-23-weijiang.yang@intel.com>
 <393d82243b7f44731439717be82b20fbeda45c77.camel@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <393d82243b7f44731439717be82b20fbeda45c77.camel@redhat.com>
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 815d61d2-8ccd-4b45-5414-08dbf2376b55
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l2GmH0VO3u+Q+RXvb7WJs2T62Jr+cS1L/yqEyE7P63ldhHJuKES/gQ5WfjbgNxTGp9vj0CzrqZJngBCafbV60tHw+SKbY7tLRIY+Bz6p5msAj271TcA9zF3rGpDN8uw/93iqZNgoxh2+9kd6S3n8JaJ+AnSBcoFzscyxKqy/eQmkWioofFBEpKZXlJlzCm6mnGVu2LokogWYoXVYVCMXHSwLQRWQVXypdpIEfxMikANnR3zOjKU+hcDcfy3rmpuM6hsYNbMQPDlvbHe7+beEwPfxd29WBsK2795eAbRUBeAGxtPDbR28ggta71omRr4UUkDEdQerrS9aGZwBqWBmu/LrfEt3SciFTK+lEWp3IC+TFwDARYRXgElU8ECDbokr8YhDWM0RfAYDbO6OjZCfQLbX3XtaUQ6de68qg2weHFThY2FwEseNgGExSLiKyNa2UX+89T/jvv4TqtKEqrg91641D2U17DUQxkEFSTsoCb3jL8cR1AntjY52HLmB2z7lTmRxmpx6h6tc3nAebVtntd4BKP99CWD2+bWzEGDQFj+r24DFABu8nrJQlSXrD5Aept89gczmTFiLlQSpFJKzXF9c6aBgzYsfLmkmigDd1eY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(39860400002)(346002)(136003)(396003)(376002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(41300700001)(33716001)(4326008)(86362001)(44832011)(8936002)(5660300002)(6666004)(8676002)(26005)(2906002)(38100700002)(4001150100001)(6506007)(478600001)(316002)(66556008)(66946007)(6486002)(6916009)(66476007)(83380400001)(82960400001)(9686003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rotE9RY4q7t2+YN5sgZgSaRYgcpgoZalC0/07/x2n1snJdcmfqLIKqQv8IHK?=
 =?us-ascii?Q?JtyKkp7K7s6D/wzvaSeutm5/QT+7Mtc6mpdK6xyvAkNy0Fp6JMSo6hjOYZZb?=
 =?us-ascii?Q?CrLqiKVgLRMn5ICSagNsapUyB0TYgaFDjQTzYvSolPGgGv5AWyMFIksTkP/N?=
 =?us-ascii?Q?H8my9ildCqKj4lwJfmHZdwXZUiTbUAI80wmE632Z1RXF6gAcfNmrZBP6GcN8?=
 =?us-ascii?Q?zKyS3svYxrThVgkIq5QUvsooOxioj7xgmMI4lAASwt09oHh5LTV/gKtZCBo8?=
 =?us-ascii?Q?kmy5zsiYLO+fD0TutQx0p9h7Ga/GO3YOxSpHCBP0T0SLcZHxVZiWIa6eQ408?=
 =?us-ascii?Q?pB9tOtNzZa/1+GWIISsDfvP9Q4h3TRXi+HWP0VJ0AaQSGvhXSLf1Nd2NH37T?=
 =?us-ascii?Q?jFQGeoQi3YbjR+sNbDaXdZmMdC6Y2xLZF8wnR5p/1xoeytRDvge30+olM+03?=
 =?us-ascii?Q?uLaCv2NFdckPPRDo8lVM8nJgv6PttvkLe86W19n1DlWkC/RlZjDWEEZ7Om9H?=
 =?us-ascii?Q?MqMuNEvbwvZ6ZmOYMzWkEkGQbr5hJfQWPO2Q3exYk5Vz17qPtqodHjjhMnHg?=
 =?us-ascii?Q?ku4mkCpMyCnUy8t7kSHahl/MXxZnIKkFxBzfSTb4rAykr4OwTS6deQBTgcx/?=
 =?us-ascii?Q?wzNQqggMr71ZDY7xLrAaDb54rDVYbBCO6Z2WlqkKCVJeTbFEesmvQHHjzMtK?=
 =?us-ascii?Q?zTikwucNgsdPrVH5QDlSY9kmdBHKN57ZKYy+6lraN/rqda1RRjcSdZAh7qOb?=
 =?us-ascii?Q?vlJhy0elk3oftRFQseH3owVUYrMN+7k1YvmSIgRxDV7sh/y43uW0562hi8Yu?=
 =?us-ascii?Q?Y+l9LsVWcRERKtnxAUruEKhzXQhnI0W3utAxIfqrZPlT1h0VE54pOzHylUej?=
 =?us-ascii?Q?5CGni/hqUA1H74XMWqVGLMYIDviPmHfojjZGNEUZ/ElGmftkentAxY8pjxSt?=
 =?us-ascii?Q?FbXzOy4vVcm69Vq4MvpsMDuTGME3qsFrGlzxIlB5ltuvV/2FkS4F699MR3cl?=
 =?us-ascii?Q?GhNLXGO/AaRz8jCCB6XEMJcvBICNXvsK5tFjlg7CwdNBukL135nxtCX9Mj5R?=
 =?us-ascii?Q?i47jOP73VldD+grazXclQc06rE/mcZsT+MlCWPUdVLtjMaihmeMzttMnIqT3?=
 =?us-ascii?Q?YnaOcFisF9qSlLqjsJ2QY7ownO/QqBdp5UnQGNLM6hwnVCyKolNFxm8J/OwA?=
 =?us-ascii?Q?7xuLRqimll7Xm1KTbgmnkrh1TeEFrHERMyJcm2/d31UJl06L2m5ZVUjKYSxb?=
 =?us-ascii?Q?Ie6nVJ2nkOr8o2S3a0uX2D7lHKDE1vpVTZuowwOmhhg8KS5sKJGD3qRrWNJV?=
 =?us-ascii?Q?NR7e4QoU2tVHCEwVB7DmDNFlfUzpKGaAnydLYC4BslFBZxrkMDfRZJTwgRG1?=
 =?us-ascii?Q?AOB6P11duGbKaeqeY2rG7Hh4R3Q8ZvsPOyl0Aku3LppOMYSD9M/Bi6HSBeKD?=
 =?us-ascii?Q?kbg/FJ7FLdrP8jtRw+7NmXDFgx0PbVuIVHWas7pjY2p3GANXkyQY9SIQj3Iv?=
 =?us-ascii?Q?3CFoNXrsoe9j43L5UZyY9hi4qRC0hzlWzL/MLwTESSDZ1uoc3Mucyy12VQ8T?=
 =?us-ascii?Q?0oRNRWGGsGftvk6t13UtcmrW88sXEYYLN15Nfv0l?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 815d61d2-8ccd-4b45-5414-08dbf2376b55
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 06:33:25.2631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+g5lNLxEsc4srBRcADN0AL0PGhTiHOYSe6I6uSoqyk0VYIgqJfwUTKtQ380BFF6KHdbi+Km/8lvAEmLedmBsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8208
X-OriginatorOrg: intel.com

On Thu, Nov 30, 2023 at 07:44:45PM +0200, Maxim Levitsky wrote:
>On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Enable/disable CET MSRs interception per associated feature configuration.
>> Shadow Stack feature requires all CET MSRs passed through to guest to make
>> it supported in user and supervisor mode while IBT feature only depends on
>> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
>> 
>> Note, this MSR design introduced an architectural limitation of SHSTK and
>> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
>> to guest from architectual perspective since IBT relies on subset of SHSTK
>> relevant MSRs.
>> 
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 42 insertions(+)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 554f665e59c3..e484333eddb0 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -699,6 +699,10 @@ static bool is_valid_passthrough_msr(u32 msr)
>>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>>  		return true;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		return true;
>>  	}
>>  
>>  	r = possible_passthrough_msr_slot(msr) != -ENOENT;
>> @@ -7766,6 +7770,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>>  }
>>  
>> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>> +{
>> +	bool incpt;
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
>> +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>> +						  MSR_TYPE_RW, incpt);
>> +		if (!incpt)
>> +			return;
>> +	}
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +	}
>> +}
>> +
>>  static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> @@ -7843,6 +7883,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>  
>>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>>  	vmx_update_exception_bitmap(vcpu);
>> +
>> +	vmx_update_intercept_for_cet_msr(vcpu);
>>  }
>>  
>>  static u64 vmx_get_perf_capabilities(void)
>
>My review feedback from the previous patch still applies as well,
>
>I still think that we should either try a best effort approach to plug
>this virtualization hole, or we at least should fail guest creation
>if the virtualization hole is present as I said:
>

>"Another, much simpler option is to fail the guest creation if the shadow stack + indirect branch tracking
>state differs between host and the guest, unless both are disabled in the guest.
>(in essence don't let the guest be created if (2) or (3) happen)"

Enforcing a "none" or "all" policy is a temporary solution. in future, if some
reserved bits in S/U_CET MSRs are extended for new features, there will be:

	platform A supports SS + IBT
	platform B supports SS + IBT + new feature

Guests running on B inevitably have the same virtualization hole. and if kvm
continues enforcing the policy on B, then VM migration from A to B would be
impossible.

To me, intercepting S/U_CET MSR and CET_S/U xsave components is intricate and
yields marginal benefits. And I also doubt any reasonable OS implementation
would depend on #GP of WRMSR to S/U_CET MSRs for functionalities. So, I vote
to leave the patch as-is.

>
>Please at least tell me what do you think about this.

>
>Best regards,
>	Maxim Levitsky
>
>
>

