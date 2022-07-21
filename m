Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA9A57CB90
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbiGUNMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiGUNM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:12:28 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF2EB3F;
        Thu, 21 Jul 2022 06:12:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQtlbl1X1so7WsY13nGZHCTScOVD++wlDQjJwqobWrD/3QkRYRfv+vybxT/vFiItEQRCRy1RKyBBUgHNjnO4UqRKCu0J5cltSXnseZ90xAhKG3SKVRPf2OVZUQkJaBt/+a++xlLwOPIg5nN32+eA9hidypG9ymtpbj1oE0spDW558kz0Krt2Mh7pVS/Vysz9S+i0C6OcGXEO8RsUH+Amv34mvALcZczdPGILklihKfKdTFuREsU7Zw6zn4LuHZZmmdeiSA5IEaosct5o0ABIpZ6VCvqBpkEgsP4DpRe0uo1LdQQpn9IKZ27cBVeVmoy2n9RVP/0hxJNtmotLE9MDNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VubHxmcpGQ8Q7wY5cEnktyeodQEASXMSwqZe41OHjbQ=;
 b=FD8oepqnNS8Zi+bk+3Es5vzgeXBSsYQnTXDNx9K54sExQLtxzn/B612Rv6sLzc3gC5+zoHFy8YiLhzd07l/SVBrFspoZxRfIcqMHazlVyH+IlNuMx0Tb9Y47Mv1dH0u/GvZRGIeqa83kNWIvNxDgEuZzV63NGe48hmoUWgFS9hPPL3b9gJB+vx2q+uNmkCJVRj0kvqzbNdaHEJZeViWxq4x9iRfCtdo7IZN2bPXR6lhFf9nd9dLKeDnEzzgGsFuzQEeBh+F0l2wua+nggilJhDOk+cHW9WS8HoqQjGgQfgs0GJGFMq/SHKBP/+Bu+zOvtbRvLvrYmEFXc/On5rQLbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VubHxmcpGQ8Q7wY5cEnktyeodQEASXMSwqZe41OHjbQ=;
 b=bMgW6km/H/M7YXQ8DGhj545fc44/A/duS+ECc+UqUlUphCeDaANf0TOSlVVh0SUveDDVWj82tylR8ddMHXkGg8aVhsg6Xd9PIUBF7si8x3dxq+98Q19vwoi24DuNlWQ3bJoG7EbeYR2Hmid73fodsmokeup+nZmqc7gQFLpH1RM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH2PR12MB3910.namprd12.prod.outlook.com (2603:10b6:610:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Thu, 21 Jul
 2022 13:12:20 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 13:12:20 +0000
Message-ID: <a6b40519-e777-da9b-f5bf-4b65490d439a@amd.com>
Date:   Thu, 21 Jul 2022 18:42:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHv2 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-4-santosh.shukla@amd.com>
 <641b171f53cb6a1e596e9591065a694fd2a59b69.camel@redhat.com>
 <6a1e7ce4-81af-ffb9-d193-a98375b632fd@amd.com>
 <d5df7e9e18528de56c41c24958901ace1e2d0aca.camel@redhat.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <d5df7e9e18528de56c41c24958901ace1e2d0aca.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0181.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::14) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 817f3794-34c9-4b85-ad49-08da6b1aa48a
X-MS-TrafficTypeDiagnostic: CH2PR12MB3910:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iLUH40Uq8ivuA4VKZROn31lxOEoQ3Nh7P3tb20LcsnGGoUAumGXqODAyG1GLMAMQfbZddCe17GYOvWOanYLkVkxUbcWThbRigs/BX90XVAroFZUcjutalNjjxPZ3DHEK1IQJS5+tydBg2FX6efYDw11iFdiAe0JxsjTen07bjKH2C1vB2ql3Aw2me02JkLROdajeXWRWTrHn+jEXNSi1jtCqGFt3jVa+uDIGV712bAFFYz8zaVXlRy1qIvLPnyvHf5V8L1kOGE8aRXlfx5arj2fuTRw1GixIbmodP3cDikYwnsQQraqdGD0dFYH+FbzFCPmgAIAX1osQXSr4NMFvk/JQgyaOfuM/YWwROSuRNohXQb4jftoSCUp7XaQHeVHmRdmX01ZaBWkLPv6lsRYe28g0+5amlWuXSITtuNL9pumckftYc6HahZeb+ijtCtrqncksGir1aGt4/dujVMMNXFSSiPycaBRA+yZj+yMycJeHVtCIrwx3NbDz9zkwDi4DVMPUKBeWLiiYa/cV8PmdZ6UW8prx0SIJEUJf6pE04EMdfnN8YUQHU7VbxG4ViwU0t2FflaIuNUdKRoyl/cBYX42YIwWovwud7EuT0bb0LeSnwF+uKA6dbldCaw0TdnBWfpuxd119doem8msssC+BDG7vU4oDVOCQ36rLWQqQVI8UHv2gS/QgRoCr8syhdV06May3+/dY0tFMhqkT85HjIxDOHhxOk8fAkjVMueImDrxkawRAx8dpoQQ8adTTpjyvqWoi9GmAjP6n592+o0cplI0gqi0qehnG1UbbUV8ohZH2MKv9DHoM4lfrp+QBODVT5ogWkfcsMg1GZ/cAcXpLLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(110136005)(36756003)(41300700001)(316002)(54906003)(6486002)(6666004)(478600001)(66946007)(38100700002)(83380400001)(53546011)(2616005)(55236004)(26005)(6506007)(6512007)(66556008)(186003)(31686004)(2906002)(5660300002)(8936002)(66476007)(4326008)(31696002)(86362001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEM2ZVF4cWd5bEFpSys2L2JNamJhaFBselVVVDNyaEs5eDBMbVh3MlFpVkMy?=
 =?utf-8?B?a2ovekpxTEExYjRXRkpyWG5IbFVPckZ0VFJIRGRSRDlSVmp1K1NSYjBEQ3ZE?=
 =?utf-8?B?Q1B5STVmQkpvcWc2aUpEVmxRQ01tVTAxcnJuK0RDcTduTWtOaXNDMVdJdm5j?=
 =?utf-8?B?T0ZYbitydUEzelRPZ1NkNXFWNEUzODI2Z0ZRcmVYMHJ1UFJiS2RHMThyWmtm?=
 =?utf-8?B?bnJmc0VObzRObk42MHh2aXR5cnlnZS9ManRCNkRDcWhiUmhFTlRQUjhwdjkv?=
 =?utf-8?B?OTd6ZVJndjBYdTQ2MWRXSDhoMmdlUWFKSk1NT2ZTb2RZcGhBaXoyNlRMYWEz?=
 =?utf-8?B?VktXdi9scXcremtlUDdUZ3J5WmR2NGN2eEdkdm5NZ0RtMjlsVkE2RFYrbDFR?=
 =?utf-8?B?d2pCbGlBaFFUZUl2QXpTczcxMXdpMEFHQkw1K2EwQ0cxdjNxbFh6Q1ZhTkVm?=
 =?utf-8?B?YWRFTkt6QjU4ZUdoWmsyNE41QWhScmdmRUJ1OG96MjhQL2VLOUxZdW41akw3?=
 =?utf-8?B?Ty9zOWhFRlgyWHgzT09KWnJsTEhJVjR5ZDVnT1RGM1BLdXVXeHI5MGxrNUxk?=
 =?utf-8?B?bGh5K2hidmxjQldxZUl1OFhOQWsxeDRWWXd6c2c5NnliSG44R2NKZHlscFNa?=
 =?utf-8?B?VGFvcDdNTEFreWhubzJJa3Z4Ui9vQ2RVOEhtd3dpSzdhOUtIWEdiTUFwMFM4?=
 =?utf-8?B?blJ5WkVhMDVQNEFHU1BUOFFDRXFMUC9aTjYvdHkyNnVjOC9oUE1kVDVrUmJu?=
 =?utf-8?B?Y3ZjMWgxeWtXRStzYklGN0hINGo1SUVoeFU3ZFpYaVlGTUxuSG1qbU5FN0R3?=
 =?utf-8?B?bldjczYvaWwxMER5c0pQTXZONHFXbHVxVmUzUWt2ZzhTVkgwalBwTjZhN3F3?=
 =?utf-8?B?RVptUzVrTlpIb0ROb1RLZWYyUlQzYzZ4VXZ1UnIvRjhyQU1QNzBPTzZZUUpi?=
 =?utf-8?B?NVAvNElSMW15MDBQNlNIV3JSYnpWOEE2VjRpZzNDRExTbTJQMGwxV05SQ1pB?=
 =?utf-8?B?ZU0rSzliOVQwMWRBcHVUcTFVL0dVeGlGMTEvWjIvdkVRVm0rei9PWW9Vem94?=
 =?utf-8?B?MkxNQUFMSVdSUVRML0puWGRnNXd6VHQvVEZNeEt0OS8rN2pqRjg4dUNUeStI?=
 =?utf-8?B?bnM5VFRDd3dxTzNwT21RdUsvL2lPMzhlTHN0aG5vL2M1dk12VkV4dDZlSi9t?=
 =?utf-8?B?N05LTG9vUlFUWGZQakRaZXYwOXczZUZWbS9lWS96WGF3Y2pqT24yWDJrMmgz?=
 =?utf-8?B?ZVE5ekg0aWR0dHFORjNsSWdOeGgzbWRGblk4MWd1Yy9Fc1A2Wk1OWkQxUzRP?=
 =?utf-8?B?VFdGbXN0azlBLzZuV0ZJK0haVGpJcWMxbWZJL1lXOTdKdWlZWWFkTmZQSE9k?=
 =?utf-8?B?bjFNNnVtKys1T3NmS0FIYWQ1N2lKcmRnN3ZrSm9mZ0gvL3VKSVFGUml3S1By?=
 =?utf-8?B?K2k3WDBHWkQwcndCZlVxQ1lKZGFBaWRyMktxUmkzcmJBeFVQLytqQ2FHYzFs?=
 =?utf-8?B?Y3U4TzFjcnY5a1cvYU1EV1RDNzhNcUpvdjZxbFB5bjRnL0F6SmxNanVRdGE3?=
 =?utf-8?B?L3FSUVhGM240clVvS1IwS0tZQjV5MzBaUTBqK2xpVkpVRVZEc0I0TFpuTHky?=
 =?utf-8?B?WmZPMUczNHJIVHpvZ1ZkREkvQUVyYUlmMmtIL0s5RnE1U0pWc3dpd3RTMHRE?=
 =?utf-8?B?Nm9pSmxBemZobWxoSWNmNXpucDNkRUZ1bFhyUUdaZ3RuOEk1SzJwL2MxUklG?=
 =?utf-8?B?TjNsR2xjTzV3TUw4TkgvNDdEdktUM0t4ei9ycUNPOXFWRlQ1a2ZOK2dNeUo2?=
 =?utf-8?B?TzlwMUtIN2QrdXRiM0hMM09rTUc1RmoxUjdOdHFLLzNCSFhWT3hGNnE5eXU3?=
 =?utf-8?B?SjF3ZU9GQk1mOXJHWm5qVHFOSEtDTzIzYm1YekpWelpBamlQblhtYno2MzZU?=
 =?utf-8?B?UjlWQ0dLY3RiazFXWXNYZzdQNlNSZ1E5NWtxbzdiUEF2Qkw4d2x0Nk5QSjV1?=
 =?utf-8?B?ZzNxQ0dvcG12ZUV2ZTVFZXZid0NPNXJKdlZDMnUrU3UvcU0zYThQdDRTb1Z3?=
 =?utf-8?B?aW9meUpOd3E4Vzk4dTFIMGxEVTNjWVlHLzBLUHllMlRvcFVaV2lXMDBQMFVE?=
 =?utf-8?Q?M6EaXrpu81gYTdXf/asGpds8h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 817f3794-34c9-4b85-ad49-08da6b1aa48a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 13:12:20.3827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UVHEF+IT7P7tUuaix8UjVl8izocrYq9HHUvMrpgvtoelH0SWCrLYkqs//IzL7AuX0M5bMvx0ZQNpx/1QZ/KBDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3910
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/21/2022 5:31 PM, Maxim Levitsky wrote:
> On Thu, 2022-07-21 at 15:04 +0530, Shukla, Santosh wrote:
>>
>> On 7/10/2022 9:45 PM, Maxim Levitsky wrote:
>>> On Sat, 2022-07-09 at 19:12 +0530, Santosh Shukla wrote:
>>>> VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
>>>> NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
>>>> read-only in the hypervisor and do not populate set accessors.
>>>>
>>>> Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
>>>> L2.
>>>>
>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>> ---
>>>> v2:
>>>> - Added get_vnmi_vmcb API to return vmcb for l1 and l2.
>>>> - Use get_vnmi_vmcb to get correct vmcb in func -
>>>>   is_vnmi_enabled/_mask_set()
>>>> - removed vnmi check from is_vnmi_enabled() func.
>>>>
>>>>  arch/x86/kvm/svm/svm.c | 12 ++++++++++--
>>>>  arch/x86/kvm/svm/svm.h | 32 ++++++++++++++++++++++++++++++++
>>>>  2 files changed, 42 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index baaf35be36e5..3574e804d757 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -198,7 +198,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
>>>>  bool intercept_smi = true;
>>>>  module_param(intercept_smi, bool, 0444);
>>>>  
>>>> -static bool vnmi;
>>>> +bool vnmi = true;
>>>>  module_param(vnmi, bool, 0444);
>>>>  
>>>>  static bool svm_gp_erratum_intercept = true;
>>>> @@ -3503,13 +3503,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>>>>  
>>>>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>>>>  {
>>>> -	return !!(vcpu->arch.hflags & HF_NMI_MASK);
>>>> +	struct vcpu_svm *svm = to_svm(vcpu);
>>>> +
>>>> +	if (is_vnmi_enabled(svm))
>>>> +		return is_vnmi_mask_set(svm);
>>>> +	else
>>>> +		return !!(vcpu->arch.hflags & HF_NMI_MASK);
>>>>  }
>>>>  
>>>>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>>>>  {
>>>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>>>  
>>>> +	if (is_vnmi_enabled(svm))
>>>> +		return;
>>>> +
>>>>  	if (masked) {
>>>>  		vcpu->arch.hflags |= HF_NMI_MASK;
>>>>  		if (!sev_es_guest(vcpu->kvm))
>>>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>>>> index 9223ac100ef5..f36e30df6202 100644
>>>> --- a/arch/x86/kvm/svm/svm.h
>>>> +++ b/arch/x86/kvm/svm/svm.h
>>>> @@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>>>>  extern bool npt_enabled;
>>>>  extern int vgif;
>>>>  extern bool intercept_smi;
>>>> +extern bool vnmi;
>>>>  
>>>>  /*
>>>>   * Clean bits in VMCB.
>>>> @@ -509,6 +510,37 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>>>>  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>>>>  }
>>>>  
>>>> +static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
>>>> +{
>>>> +	if (!vnmi)
>>>> +		return NULL;
>>>> +
>>>> +	if (is_guest_mode(&svm->vcpu))
>>>> +		return svm->nested.vmcb02.ptr;
>>>> +	else
>>>> +		return svm->vmcb01.ptr;
>>>> +}
>>>
>>> This is better but still not enough to support nesting:
>>>
>>>
>>> Let me explain the cases that we need to cover:
>>>
>>>
>>> 1. non nested case, vmcb01 has all the VNMI settings,
>>> and I think it should work, but need to review the patches again.
>>>
>>>
>>>
>>> 2. L1 uses vNMI, L2 doesn't use vNMI (nested_vnmi_enabled() == false).
>>>
>>>   In this case, vNMI settings just need to be copied from vmcb01 to vmcb02
>>>   and vise versa during nested entry and exit.
>>>
>>>
>>>   This means that nested_vmcb02_prepare_control in this case should copy
>>>   all 3 bits from vmcb01 to vmcb02, and vise versa nested_svm_vmexit
>>>   should copy them back.
>>>
>>>   Currently I see no indication of this being done in this patch series.
>>>
>>
>> Yes, Thanks for pointing out, in v3 series.
>>
>>>   vmcb02 should indeed be used to read vnmi bits (like done above).
>>>
>>>
>>> 3. L1 uses vNMI, L2 uses vNMI:
>>>
>>>   - First of all in this case all 3 vNMI bits should be copied from vmcb12
>>>     to vmcb02 on nested entry and back on nested VM exit.
>>>
>>>     I *think* this is done correctly in the patch 6, but I need to check again.
>>>
>>>  
>>>   - Second issue, depends on vNMI spec which we still don't have, and it
>>>     relates to the fact on what to do if NMIs are not intercepted by
>>>     the (nested) hypervisor, and L0 wants to inject an NMI
>>>
>>>     (from L1 point of view it means that a 'real' NMI is about to be
>>>     received while L2 is running).
>>>
>>>
>>>     - If VNMI is not allowed to be enabled when NMIs are not intercepted,
>>>       (vast majority of nested hypervisors will want to intercept real NMIs)
>>>       then everything is fine -
>>>
>>>       this means that if nested vNMI is enabled, then L1 will have
>>>       to intercept 'real' NMIs, and thus L0 would be able to always
>>>       inject 'real' NMIs while L2 is running by doing a VM exit to L1 without
>>>       touching any vNMI state.
>>>
>> Yes. Enabling NMI virtualization requires the NMI intercept bit to be set.
> 
> Those are very good news. 
> 
> What would happen though if the guest doesn't intercept NMI,
> and still tries to enable vNMI? 
> 
> Failed VM entry or vNMI ignored?
> 

VMEXIT_INVALID.

> This matters for nested because nested must work the same as real hardware.
> 
> In either of the cases some code is needed to emulate this correctly in the nested
> virtualization code in KVM, but the patches have none.
>

Yes,. in v3.

Thanks,
Santosh
 
> Best regards,
> 	Maxim Levitsky
> 
> 
>>
>>>     - If the vNMI spec states that if vNMI is enabled, real NMIs
>>>       are not intercepted and a real NMI is arriving, then the CPU
>>>       will use vNMI state to handle it (that is it will set the 'pending'
>>>       bit, then check if 'masked' bit is set, and if not, move pending to masked
>>>       and deliver NMI to L2, in this case, it is indeed right to use vmcb02
>>>       and keep on using VNMI for NMIs that are directed to L1,
>>>       but I highly doubt that this is the case.
>>>
>>>
>> No.
>>
>>>     - Most likely case - vNMI is allowed without NMI intercept,
>>>       and real NMI does't consult the vNMI bits, but rather uses 'hosts'
>>>       NMI masking. IRET doesn't affect host's NMI' masking as well.
>>>
>>>
>>
>> No.
>>
>> Thanks,
>> Santosh
>>  
>>>       In this case, when L0 wants to inject NMI to a nested guest
>>>       that has vNMI enabled, and doesn't intercept NMIs, it
>>>       has to:
>>>
>>>       - still consult the vNMI pending/masked bits of *vmcb01*,
>>>         to know if it can inject a NMI
>>>
>>>       - if it can inject it, it should update *manually* the pending/masked bits
>>>         of vmcb01 as well, so that L1's vNMI the state remains consistent.
>>>
>>>       - inject the NMI to L2, in the old fashioned way with EVENTINJ,
>>> 	or open NMI window by intercepting IRET if NMI is masked.
>>>
>>>
>>> Best regards,
>>> 	Maxim Levitsky
>>>
>>>
>>>
>>>
>>>> +
>>>> +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
>>>> +{
>>>> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
>>>> +
>>>> +	if (vmcb)
>>>> +		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
>>>> +	else
>>>> +		return false;
>>>> +}
>>>> +
>>>> +static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
>>>> +{
>>>> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
>>>> +
>>>> +	if (vmcb)
>>>> +		return !!(vmcb->control.int_ctl & V_NMI_MASK);
>>>> +	else
>>>> +		return false;
>>>> +}
>>>> +
>>>>  /* svm.c */
>>>>  #define MSR_INVALID				0xffffffffU
>>>>  
> 
> 
