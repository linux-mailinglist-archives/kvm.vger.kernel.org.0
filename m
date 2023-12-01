Return-Path: <kvm+bounces-3052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1900580018A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 03:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 496071C20E95
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECC34440D;
	Fri,  1 Dec 2023 02:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JxVrnRn5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC87115;
	Thu, 30 Nov 2023 18:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701397404; x=1732933404;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jpsySEYYE+OHtZZSiTDa8xMx0KEHS/YSGyhLZRSbcao=;
  b=JxVrnRn5emsl2V99NxIcUiTdExiIcDR1EUfcXdsk/v8CLoIT5JsicIH0
   OKtet9KbWMdvvHcWXhYbV3IZ7WSEzoyWi9guMgemqLHvCr4PXjhYTRtcp
   sq+Y+drAbyi1OqOOPTGNYTm8CCnfewRd7yAQiYKa0cYn+1/3LMS0Fn3mg
   CrCWXSRk6dgJkUIJd6iMsawUi9XKPfG9gojgdzG6kBT/CRfqItn+5UEsT
   N5AIp50LfuAUUh3zt480pE8EK9tZkSXBN3keK4qbIuxTv3jDxQ+ThNABt
   OMuUNRdEEDWwSOYmsruOPhxrsycI3vvCKJMhgIwbpowj9CWP3qXfNKjQB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="14973850"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="14973850"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 18:23:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="840014932"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="840014932"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 18:23:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 18:23:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 18:23:19 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 18:23:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n89hpCSnxUyfWzBIEP9dM2txFPnHXk7Pef0Kh39NFb8vxb/TKpwO3o3MP/YLAYwtljJHyJnJugdsfkxEerWA2HVm4nbNTWjtrlYQsfX9VK8LOd1Mb2dU+kZF7Z2f67rLLNc3fTUpsMq2ML1W5LT5sRaSMuZwQzPdAVj/5UDE6aiH+EOPMMorK6mvGQ1JR7wnwnQPCzf5c1TafahfgtEyYPzC4nG+LG9VyQeYTBeoJc+gTB5DO+Wq7GecBoM8Cfd5W20oO814J8Fu7c6/GBPe3bc3yixdqzSBjuKRsXugvEv6NRuXvDJN2owoehspiP5z8lv+fUYkPneu/Qp5kv5Ubg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Illqm9H4x9UIsAP5K9i8IK93IJ4M45Epcuh5nmn5x2s=;
 b=I0Whcbl0r14GY0nE2dEgB+Yvqw3zLjuOXwDzeHgPY5h72R4Xu6axDP2Cw627neQ+g7BWV7n/AWorqc7yXyJyC+YLLbmhb1vI43intFYO1UhNK7bkIdqV4HvjfLM3u+fOWVvgyXbx0KAa9j1zoAYMX5rvC7hdAitYsMc8AK7IsiVwvD7qeHCdzkMaApK/qR/1T6XhyWcLE0tSAm2idzJ4cWPBiIyoFmtd96DjRsH6sdX+Xi6hInQnDjhUgD6XD8K9TdAcEctiwtuN4oDttz2zd4HBhQaPVfQu3PdDBXLR9+uQGznFFOQIVgNKSP5VabDzbrfIlYJKCW6BpShVZ21icA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 02:23:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7025.022; Fri, 1 Dec 2023
 02:23:12 +0000
Date: Fri, 1 Dec 2023 10:23:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: Yang Weijiang <weijiang.yang@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <dave.hansen@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v7 21/26] KVM: x86: Save and reload SSP to/from SMRAM
Message-ID: <ZWlDhYBYGiX7ir4X@chao-email>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-22-weijiang.yang@intel.com>
 <d2be8a787969b76f71194ce65bd6f35426b60dcc.camel@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d2be8a787969b76f71194ce65bd6f35426b60dcc.camel@redhat.com>
X-ClientProxiedBy: SG2PR03CA0122.apcprd03.prod.outlook.com
 (2603:1096:4:91::26) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: 9633d216-ec55-4516-cb2e-08dbf2147693
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpYZL6ghHP/rNpV5ah4azB/ZmMefa8xvZLOS3cH/qoRocppxKEpTTvkTo5Yo+AgIodJlBvI99vjiqN5DMpT90K0BmuEjaWmgvopV0ynpT2KcYFdiDSRTExasxbP6gDBaluL/TJuzJFEUuPQFFlOO0VVtovP1A6lvLEpcl38L53uDNynL6vS+Twi7hw6gCDS60v47+IaNBSgUAzQYqebMg5NjNRZCThOUZtrn7Z0+cMogaYXhwRETc1RJKhW0qCooCmPjjsYqeqvpLdYXqwqGW4Q28E6ZiJUsSRX/lPtNhB91l/VRAvwMWhHAXhOtIM+w2eCXaM+g51J4i7PE7nxIIoDua3y9EGIUZ1K0zgr4xfEOFIC/qMCQDDDDphakTL1oMQPTO9I0kB6/Nf/YypetDEGgvDissyAij4UfXNW68VCP2DpSzYCMmtAjgp1tocuUax9CmqQqky2PY6abHoDUdsW1O+AQ+rLFjfHZ19/YrXlGXi9JpjrGn3jvHXi0dJ89CTpR35Ah2Wyz01UbhZAi+hK/AXRInuR1i3mmfwSJaeqUf8AUAONhk7nnB4ij+z8C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(136003)(396003)(346002)(376002)(366004)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(86362001)(83380400001)(6506007)(26005)(9686003)(6666004)(6512007)(4001150100001)(6486002)(478600001)(44832011)(8936002)(5660300002)(8676002)(41300700001)(2906002)(4326008)(66556008)(33716001)(316002)(66946007)(6916009)(66476007)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oo4GFcEgsSZWcUM2ZgZ27zle5EWuSRolq4a6nvMhh4dM0WqImPUdOJ6AOlPn?=
 =?us-ascii?Q?Lb+Pt+P9Uhvwen8zA46Hpf7Tr1+41ON7/O9GXzWsDF4OrTXiNyH0hkLgugew?=
 =?us-ascii?Q?Lo4qmTG2itPfw7Xe5Lda9MJPghTRDzhjAl3UdPPoySk27HYZm8UMvARewNLW?=
 =?us-ascii?Q?+2FVez+uJ0mlFt5F2RygSeLKkXfCz3dimJdYBeQ/Vjy/LcDcKrrORVr9Vp0M?=
 =?us-ascii?Q?CMeYWRMw58VFz41ZP5Dg18TDwdYZc+MvrA7X0tE2rfLtTTta1u3qzyNjYPCg?=
 =?us-ascii?Q?LAqkfQjTjyWS5MuSN6neQvbSxOp/vFEhgyZMOhxgOtdb8xqKLhpIIXE+cGR8?=
 =?us-ascii?Q?89c1hLxcMq52M1QZbrYyTO0ldheImYGfbBC/azmMkwjqhqSY2RAHq8xhtPRI?=
 =?us-ascii?Q?H78YrYcZOcxRgcdW7MLR15rRbAVLcURyUmW8gvoz7sn+wXrvTCEMv/dT+oQc?=
 =?us-ascii?Q?/8FqK9gSigocux5Ypth5fifCiGDRvLmTkU/BZoAXsCX29yg93FqJCJhaIdH0?=
 =?us-ascii?Q?3vcprLXY4NwjK5gOD10UQspZRApL7+dJzUUvViN1WwNlcLPd3UMFAXra2hkZ?=
 =?us-ascii?Q?kbm8AgrICadAssI8xsSLfmJ8NjNT4Ji1w00M9mrgD3A3VWYCtG+eAUoLa2wT?=
 =?us-ascii?Q?69Jj6pxLx3dCrP3gFXsTJEBa6jOwvGAkB17AM6rugu88g5+VYjXSz1GG/MWW?=
 =?us-ascii?Q?4N0WM6lemny49lGqbaocM0TP7ZHulR96HPROw2gS8W33bJW8LiqPgOhvXrFE?=
 =?us-ascii?Q?tgbwAFzm5aKEVsfxJGHWK4JgqGJPggi/9HSSWClRffR5VKWqVokbQDLZXGhe?=
 =?us-ascii?Q?mmFbfSkqfuBNSXgGB0DNj9fx/N83LVmqvEgBlTPorC/lXTRyn/6NxupZpYmS?=
 =?us-ascii?Q?PlDbxmKv7Jhq5yVQC7FyYNhDxSi6W4mlDZmcYnRxWFj5PWaefv1onZNeyuY2?=
 =?us-ascii?Q?eNVbrBlzwGYLBXTtup92gE92OqMhJPe8WNvGmrNdaVIqn38Z0hO2U0+F0huX?=
 =?us-ascii?Q?m9fZf0koy1z/HWsAoSILejKftBDFl4TuG6dTHbf5rIen6kXCo+5skbWdPX/8?=
 =?us-ascii?Q?xN2F7EgDwilQj12h4M9K5fv5LlcFwQKBUjg43o3VKI43lD3lPPDdPzQoRBsx?=
 =?us-ascii?Q?qxXPPIiz540mLvM3QiA8ca4LN3GXZF2VFCGu7wzAAHdCNqHkf3cglkmFmAZF?=
 =?us-ascii?Q?o7Exca0ryvwZxmkzbwguv2ZJ0SA9HnnsTi4PYuNRoUPeCBtJ/zxdw0OuP5Ui?=
 =?us-ascii?Q?yxbs/aUzK7Lw5oGmv1X+DmAG3UxBKNeK1joDPYslTKN0zNbPrLY6kS11e2ON?=
 =?us-ascii?Q?BebEbEJITJVCj+oSID4HVO7V+lixtV6MxKBh0vAHGhGu+BQ94zqADdp5UR2f?=
 =?us-ascii?Q?0WFtiklFrqhYbUf1zFUbcF6TY775+x+gbetWF8JzmvKXAvADzrmChiYDfDRv?=
 =?us-ascii?Q?WoeqDqtmKv75qpZR7wrnGpJUh2PlYwlZtCjNvqJtiYH6ewolEw9b0SalD2F9?=
 =?us-ascii?Q?5BedDDufnOglnUWzmlgV9GE8opQSpV6T/UepZUuS8o2RJMMiq/CGtULn1aiB?=
 =?us-ascii?Q?mVPE7sIJ7dqRwq/XQTmZzZd/p0dQabzJlY/qgfQC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9633d216-ec55-4516-cb2e-08dbf2147693
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 02:23:11.1514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eWMqEeKk98/28xUhTR+tG3//cG2OXo1+87Doqk2ahgPOUvyrDTnPk7X+fcguO1nKWE5FVHnrzUyX8ij2DUhHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6763
X-OriginatorOrg: intel.com

On Thu, Nov 30, 2023 at 07:42:44PM +0200, Maxim Levitsky wrote:
>On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
>> behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
>> at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
>> one of such registers on 64bit Arch, so add the support for SSP.
>> 
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>  arch/x86/kvm/smm.c | 8 ++++++++
>>  arch/x86/kvm/smm.h | 2 +-
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>> index 45c855389ea7..7aac9c54c353 100644
>> --- a/arch/x86/kvm/smm.c
>> +++ b/arch/x86/kvm/smm.c
>> @@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>>  	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>>  
>>  	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>> +
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>> +		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
>> +			   vcpu->kvm);
>>  }
>>  #endif
>>  
>> @@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>>  	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>>  	ctxt->interruptibility = (u8)smstate->int_shadow;
>>  
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>> +		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
>> +			   vcpu->kvm);
>> +
>>  	return X86EMUL_CONTINUE;
>>  }
>>  #endif
>> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>> index a1cf2ac5bd78..1e2a3e18207f 100644
>> --- a/arch/x86/kvm/smm.h
>> +++ b/arch/x86/kvm/smm.h
>> @@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
>>  	u32 smbase;
>>  	u32 reserved4[5];
>>  
>> -	/* ssp and svm_* fields below are not implemented by KVM */
>>  	u64 ssp;
>> +	/* svm_* fields below are not implemented by KVM */
>>  	u64 svm_guest_pat;
>>  	u64 svm_host_efer;
>>  	u64 svm_host_cr4;
>
>
>My review feedback from the previous patch series still applies, and I don't
>know why it was not addressed/replied to:
>
>I still think that it is worth it to have a check that CET is not enabled in
>enter_smm_save_state_32 which is called for pure 32 bit guests (guests that don't
>have X86_FEATURE_LM enabled)

can KVM just reject a KVM_SET_CPUID ioctl which attempts to expose shadow stack
(or even any CET feature) to 32-bit guest in the first place? I think it is simpler.

