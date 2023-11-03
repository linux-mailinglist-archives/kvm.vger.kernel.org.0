Return-Path: <kvm+bounces-468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C84487DFFCE
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 09:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B6FF281E5E
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 08:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F9A8824;
	Fri,  3 Nov 2023 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O7OBvEnl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5527A2D62B
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 08:46:52 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989DDD43;
	Fri,  3 Nov 2023 01:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699001207; x=1730537207;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iZngW5rXWKkeW1Q/Hb/R5AYhv/wlE/pSFkg01PyU2AM=;
  b=O7OBvEnlPzHuQPgMy011z+92OK2QCjkDak4m6N/HYC93wGAaZ9hbnOAt
   3SetVPgv3C1XZtkQ++hlSd8eWT0FYAFPra+VkOWQqTvXGZ48Z+JDTIdfH
   c90w+9Fx3RPwY16x78N5W6BbJ0P06fUbKmjrnGs+iC2EenldBf+ZptioI
   WFaVliIaDfbGSSCy0V94feJqYZ+r3RfbNZlCpvZUtSdkbspl+7SbpYDQH
   QbKJmSYSY/GOrLmCyt6YeIM7sFEri/nOj1k3uEghgW5iYZVR0HG7KFNSB
   xHqVd2L6I8D0XGnX6fAO6mudUU2LJrOUjqlaHrEduMNLe8iLLR4Sfsumg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="392785447"
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="392785447"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2023 01:46:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="852208532"
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="852208532"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Nov 2023 01:46:46 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 3 Nov 2023 01:46:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 3 Nov 2023 01:46:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 3 Nov 2023 01:46:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYBf71DeR+1JMIamc7rW7ev0TZHRQ6P/azuOvdo0ngXZK/AFfiAAxIlxjmSu27tKwZVubzEau/nK1iiMB+0SdFGUSfpVzQsA4UU7gC6vblN2w2SUUhB1ZZZI9jcEEMCIfD125rDXHVZzJBR7wc3OsCXacG3SdYJiHsr6qAoNUnMJhYOrzhse0Mbkzmr7z2//Son3X1djAeaKKg1y7W5YgeClApt7sUIaSHOLnzKNy7N0A/BH61B9dE9I9lGR8d75VqfPNX3Y/IibgScMqFwHLQy4aI36aCGEO5PBI3mn5fUYePGsiKe/qvLYNUwXRmDkEHcKGTWiipK4FlILi93q8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qz0QcdqIpziZkyWrLeSgOLyjpujIRXj1S3tFtWnFr34=;
 b=VxIqUAAGMMRGwfq3sSu/THJcxmK8ERPNtusG37WPX9Q9roXTP3pJInc+M7/9YexOZSE44woNAvJtJEq6tKbRTggnlUrKjpfhF5pZyI9agqio4OhJjPpeu4ve871X8YLsHR1tlLLWctdct43xcTMqIJL3DWlksikZk2TYSoy+NdO6/T5g0XiNcdt0pllIM83HYqXz9BWPIecmGYMn32sJiNRrBg6ZzJ/9kaJKOScpoPG+L56iQgDEGWGvQ8kxXi9lPdQP21hvLgQ1D5LxYIDi/XuhjbXXAGc+dhGhBCYGRKRKh8jVRRfI47dc/LlQxaWg8iCm9V/NU5HhXw3jAubVFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL3PR11MB6505.namprd11.prod.outlook.com (2603:10b6:208:38c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Fri, 3 Nov
 2023 08:46:38 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.6954.021; Fri, 3 Nov 2023
 08:46:37 +0000
Message-ID: <10fd9a3e-1bc2-7d4d-0535-162854fc5e9d@intel.com>
Date: Fri, 3 Nov 2023 16:46:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 14/25] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dave.hansen@intel.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-15-weijiang.yang@intel.com>
 <2b1973ee44498039c97d4d11de3a93b0f3b1d2d8.camel@redhat.com>
 <ZUKTd_a00fs1nyyk@google.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZUKTd_a00fs1nyyk@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0206.apcprd04.prod.outlook.com
 (2603:1096:4:187::21) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL3PR11MB6505:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a89d51b-bd11-4d70-f563-08dbdc49643c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZTKpUsxe/4tTFG1frj8e5zJhAEdjvkCtSwUxdDEIhn+vvKoR5n8quD3JkE2spglrjjxvJeZWW91yecrsHTlH8OtruYqOtpbDvDXbd35/9ok/mknNMz1dTAxD6DbDvhXkiGOSFRLXdsRZ0u+YIpYRekwq3dd3CVe1ztI1y9LRY94+dVoAhLdphdOVWQpc6fr/m0P5G5rTnz0OHQt5R2OgGhBTimGiov5uUuJ5b9Hl8g7LN8uETI7yIryqIwozDojsbumi+IjPOvCT8pF0QJKy5/fnSnIdhlYNnpauv4oGqJnn9VKk2B8FNPE3D6+zeLgQ61kB30dq+K+iRwyio3AXaeg7lQ/4o5cZRMENjMzm2QBtskJUoGi175rC1x5IiJGfInhfTdLlDAFj5EfN5RZdAdvI4+1aGGtR/O8sW0QPb7CVqXwy9xDYYTe4MuWeiTN08zwwxT7Y+tZO2ONIBeqGz7jLJf4Ax4jLyCUh+Y27M7vyAULkWSj1DtVgbWaHCvL6XR275yqEJ50EOT8z7SQSL6P7/KkR4ldLuQ4Ad2Qec4pNHy6IzWZKVy33Ax5CGtlluLFe8hX69FBokAUxd2NoO8KpKV9U4m4LmlrbArWUjGSCP0Z5ay3joeb4Jtmkpw8037ICd7UfW96k6QS6jw62A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(31686004)(26005)(66556008)(66946007)(66476007)(316002)(110136005)(36756003)(86362001)(31696002)(38100700002)(82960400001)(6512007)(83380400001)(6666004)(2616005)(53546011)(6506007)(2906002)(478600001)(6486002)(41300700001)(8936002)(5660300002)(4326008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDE4VnBnOEhCVlJTaEQ4cUV6Q3A2cHY2VEVjTFI0ZnB0SDRoV2tOc3lkYll3?=
 =?utf-8?B?dm9XWW02dFNiakZrMUJDRkNtRDZJOEhZVFNYNDFvMFNJM2I4aWczUzJMSnJT?=
 =?utf-8?B?a2kzekZ3eE01Qk1CdjNQcmlQeWRpZnB5QWFwVzJHTGFEek5BRjBFTTdNZzR5?=
 =?utf-8?B?VDVYV05YK0tIK0FQNkkvTytMT0RIWitHaldPNTRIRk9mRW5ucEZCSTlJQk1k?=
 =?utf-8?B?Y21jMThhbzBFVVl2aVcrcys3RGc2ckd2TjVjVEJBbXpmOEhqQm9ZMkF5SXJw?=
 =?utf-8?B?ckJyTTUyT1FVZE40OGhQOCtOL2M5SmR1NS8raHV0bHh2Z3orSG1pZ3RyUFJ0?=
 =?utf-8?B?dnd1RWxrcGxQREtVb295S0dXV1J4U1hwLzVTQWNkOHppcEw2T3dGZFhuemgy?=
 =?utf-8?B?eXNYd2s1SlVFMnZCVlUzVUVnSExhVGdjamxEUVRvUnNYTHhLNEh3R0tialIw?=
 =?utf-8?B?THptYTFFN01tS091NVR2U3Y5R09ua1dGUkVhUWROZ2RpSG1pQm9Xbmx0T25k?=
 =?utf-8?B?QkFDSjdnazVsMHJINWIvMlgxWitSRFcwdC85cVcvNFZSdjcyMmpMbWNXck8x?=
 =?utf-8?B?Q3NvL3A4YnZNYjBCL09UcEFiUmtlTHBkZHpmVDVtaUpDNmJadzd3TU45UllB?=
 =?utf-8?B?MFFYa2JxaHc5Z2lNRjdVL1pCRWJJSVAzeDBacWtPYjcwOUZ0K0xhMVZxOUFo?=
 =?utf-8?B?Q2l3eEEyVjFjRDJwKzBxSWErUWlSMng3TFVkOURhT09aUG9WeGRENzViK1Y2?=
 =?utf-8?B?WXk0UkljRGdpc0VuOGFrQU9reFJrc0hvZ3k2NCtHWW4yY08rTHJwRjlacHI2?=
 =?utf-8?B?UXM5eVdzWkIyMTExTU9DSFIxV3VaVFhlVlErTVRDNG53QWRsRkRkWXYzdlpV?=
 =?utf-8?B?RkhTekx0TmZYeGxsOFhHT3Rway8rTGtSaHdXTS9WclhOcHJKL2o1cVkxVnU5?=
 =?utf-8?B?cllFcWFBWjNER214M1hVblpPbmFrTjBaMklYTklMcXh2Y1dqTis0SlJ6b2p3?=
 =?utf-8?B?aXZPbFNvRTZ1dXU5VnA5ZUpuRXlTdlY1T2Y0ZTUvdmpvaEE1am55Q0t3MW10?=
 =?utf-8?B?VFZzMzF3UU1mbXNQVmlzRXdZK0ljSWdCTlJ0blRRWFlPNVJxZ0IrNFk5anVG?=
 =?utf-8?B?SUoxMXgxZXhkSVpVQnhzOStzUXU4SW1mNS9raXhBd2ZNcmVBVWp2UEJOa2xG?=
 =?utf-8?B?UGdOVVBVSXI0TVhoZTU1VW5lSmdLejQ3U3ZkRE9GblpUakdTK0tzMkl6UmRt?=
 =?utf-8?B?U0lVaUt3T2V0eXBwWFhxUmpQZU9iRldsd0VWaEE4R2VsYzkyeitJN1BiS3RP?=
 =?utf-8?B?ZDNIYWVMcmNmdjYxOVlXT08yQnQzVENLYmR6NzRvL2MxZDNiNnNITHJDcU9K?=
 =?utf-8?B?UFppLzJablBLZEs5T29yM0Rxb0FHUS9BaE5qdEpJZXdZVHZzcWZxdXptRnlC?=
 =?utf-8?B?MVhQamhXVjNIWmxoWTQyT1VSdm1pb1d4YXVtK1h3OHoyemExaTl5SUJGRU5n?=
 =?utf-8?B?ZzBGR2EwR2ZMd3VJa3FHc1BkbXJXdTZ4bHNGcG91YlRDc0x0akdzbkUzSVZr?=
 =?utf-8?B?VzNlcDhUVFBrQ3M4TmZqYmJqR1dvWmwraUo5a0F5b3ZvWnh4L2laRkR3Mm52?=
 =?utf-8?B?Q2dBVndLc2pJQUtPRVNKVVhleXcwT0dUV01NOVVUK1BseGRLdUJvb0UvYzJj?=
 =?utf-8?B?QzVjTlNGWldVbUNlUHhlTWxrdzFiTHYrU05pUFI3YzhjZlRlT2ZtZFYwVzZ2?=
 =?utf-8?B?K21hcmNMOCtTN0VBbXFLZnFDcHQ1a3ljN2tPWHl1ckhoQ2hyYzloSXJ5enZK?=
 =?utf-8?B?TkJvc1Zob0RwQ1JVc2ttQnVCZ3VubzU0cTYrSTN4NERkWjJSck9MWWMrV1Jq?=
 =?utf-8?B?UXB5K3B4YXpTeXkvdVFhck8zV2xsRE82bmd0SllabTEvU0YrTnhoYmIwRWNh?=
 =?utf-8?B?c0hwbHpSZkdVLzVyS2V4QTdDNTRFdGt0WmkvWFFzTEZrM2Rja25kdWhUQVRr?=
 =?utf-8?B?M1V6d1BmN3VYUGkwL21uOGNKMWo0MGVzR3V3dTBxV3hDTTAxSC84SnA1L04r?=
 =?utf-8?B?b1dUSDVJQi9IeUc1bGxsNTNlbjB5U05KMysrWmJXMjlOUU5XQjIwVzZEOGJ3?=
 =?utf-8?B?U2NzMzZsSmxmT2FNQk5QVnRkZXRaaVZLbzVPK1c0VmNSUEwwUWtVemtjTW9S?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a89d51b-bd11-4d70-f563-08dbdc49643c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2023 08:46:37.7365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFhx4v82eH66vjkbJS8eFUR5srJFUaQLfW2sEMwRySKBhFoblPhCJpr26//aRoFzRo5EMNfSBjt2p0Slai+CIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6505
X-OriginatorOrg: intel.com

On 11/2/2023 2:05 AM, Sean Christopherson wrote:
> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
>> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 66edbed25db8..a091764bf1d2 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -133,6 +133,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>>>   static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>>>   
>>>   static DEFINE_MUTEX(vendor_module_lock);
>>> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
>>> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
>>> +
>>>   struct kvm_x86_ops kvm_x86_ops __read_mostly;
>>>   
>>>   #define KVM_X86_OP(func)					     \
>>> @@ -4372,6 +4375,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   }
>>>   EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>>>   
>>> +static const u32 xstate_msrs[] = {
>>> +	MSR_IA32_U_CET, MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP,
>>> +	MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
>>> +};
>>> +
>>> +static bool is_xstate_msr(u32 index)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < ARRAY_SIZE(xstate_msrs); i++) {
>>> +		if (index == xstate_msrs[i])
>>> +			return true;
>>> +	}
>>> +	return false;
>>> +}
>> The name 'xstate_msr' IMHO is not clear.
>>
>> How about naming it 'guest_fpu_state_msrs', together with adding a comment like that:
> Maybe xstate_managed_msrs?  I'd prefer not to include "guest" because the behavior
> is more a property of the architecture and/or the host kernel.  I understand where
> you're coming from, but it's the MSR *values* are part of guest state, whereas the
> check is a query on how KVM manages the MSR value, if that makes sense.
>
> And I really don't like "FPU".  I get why the the kernel uses the "FPU" terminology,
> but for this check in particular I want to tie the behavior back to the architecture,
> i.e. provide the hint that the reason why these MSRs are special is because Intel
> defined them to be context switched via XSTATE.
>
> Actually, this is unnecesary bikeshedding to some extent, using an array is silly.
> It's easier and likely far more performant (not that that matters in this case)
> to use a switch statement.
>
> Is this better?

The change looks good to me! Thanks!

> /*
>   * Returns true if the MSR in question is managed via XSTATE, i.e. is context
>   * switched with the rest of guest FPU state.
>   */
> static bool is_xstate_managed_msr(u32 index)

How about is_xfeature_msr()? xfeature is XSAVE-Supported-Feature, just to align with SDM
convention.

> {
> 	switch (index) {
> 	case MSR_IA32_U_CET:
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> 		return true;
> 	default:
> 		return false;
> 	}
> }
>
> /*
>   * Read or write a bunch of msrs. All parameters are kernel addresses.
>   *
>   * @return number of msrs set successfully.
>   */
> static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
> 		    struct kvm_msr_entry *entries,
> 		    int (*do_msr)(struct kvm_vcpu *vcpu,
> 				  unsigned index, u64 *data))
> {
> 	bool fpu_loaded = false;
> 	int i;
>
> 	for (i = 0; i < msrs->nmsrs; ++i) {
> 		/*
> 	 	 * If userspace is accessing one or more XSTATE-managed MSRs,
> 		 * temporarily load the guest's FPU state so that the guest's
> 		 * MSR value(s) is resident in hardware, i.e. so that KVM can
> 		 * get/set the MSR via RDMSR/WRMSR.
> 	 	 */
> 		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
> 		    is_xstate_managed_msr(entries[i].index)) {
> 			kvm_load_guest_fpu(vcpu);
> 			fpu_loaded = true;
> 		}
> 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
> 			break;
> 	}
> 	if (fpu_loaded)
> 		kvm_put_guest_fpu(vcpu);
>
> 	return i;
> }


