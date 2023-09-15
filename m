Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392507A21F5
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbjIOPJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 11:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbjIOPJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 11:09:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B2630F8;
        Fri, 15 Sep 2023 08:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oi08XULtHYVFNm8qnmRumeTCkbEPhalbf9Nl3L4Ow42lRlNuzlx3Ia+QCMmmewj5zoWiDeZmsK6pU7finOgRRNtN1A4UWG3ht/w/lVBmMFBiSxg5Wuxlgi8c2qlCcHyS2nYibGZTS4zkyjRPZw919P+0KgCGMVp6axzAKSzCXn/q+eB3G5iNAmelU7l5nx227pQOAZKFYV9vdM4t8UfRH7C54m1qUA+pZ2FEENtnHEoxbBaz/qmfNargg9DhSG5qdWch+rJyzutaNOFHzCz+DyjtPMLQxEW5OgYJqr5+p50Lai5IBOe6sZ3NyYGsZwBDTlDq8feg+x1t5esKs5O7FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C57jSI/Css3VBFklk1lzdoGndFZVLMtIrsOaz4PD758=;
 b=OWEHlSjEYocbpbxpZ6fqzNwDqNi+OxSSywcOMyuqlxCfcIOeb6q5HPrRmwWxDoNfEGP3AjzrySfsoktef/bb75xtwrmXENXI9VX5OVq4AuuRkaC/s6aREhmmGA+8vextpNj49lRlgfE/cP1MKnOFN1ZEdI7L1OIxPUnlumDMXUnLZ1HKJTqsYOBIKVsPHLPI124vIzkLc3h3JEOYzRW4XIstSJfhb9nluWO/YeKMJHVTPJztseA2p9Qso3zTIHXKQg35AVf+YgoLBioSd8OM0oh1r0FK/1GergDdeSD/5I/h+kDHur3gxlgSt3Ad/cRQMEVnhfjEeWtW5qXoKbaGEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C57jSI/Css3VBFklk1lzdoGndFZVLMtIrsOaz4PD758=;
 b=jlHBr8avxmCWEd/TuI/oM7HcFfF7ByVG616BVh8+Y/UQuWb1A2CUw4E880AONWyg49YKe/Yl4whaDm3dFoAd5oIoD1p7ZTmW/d+O0lxrQCH97mmbHKXGWl60cBURCa96fDXFPtlxuMTlduTk92IJG1qxnzUdLX4I76Dk0n5O0ZY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 15 Sep
 2023 15:08:43 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 15:08:43 +0000
Message-ID: <380463c9-30ee-ce7e-32ab-0ed91825bdaa@amd.com>
Date:   Fri, 15 Sep 2023 10:08:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 2/2] KVM: SVM: Do not use user return MSR support for
 virtualized TSC_AUX
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
References: <cover.1694721045.git.thomas.lendacky@amd.com>
 <025fd734d35acbbbbca74c4b3ed671a02d4af628.1694721045.git.thomas.lendacky@amd.com>
 <ZQRtpVjXTwjeJ5rI@google.com> <ZQRvjy/NQa3HcKsY@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZQRvjy/NQa3HcKsY@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:6e::24) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM4PR12MB5072:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a08b102-2133-47d9-ba9f-08dbb5fda6e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQ1obqC6/RzVsfD0YBZJBEU0gnxso1Nh1LWiP71w/e+W2sTBOUmXn393dKKSdxHgabQJiqw7vBWhF1iZzS2aGXkWY5BZ2pbYVpXIly1+iNCrT5cugOUA7/pg70y8AerlvN39QxWnA70h0ug0wX7ez2uJRDMTJfrzkAAD2ahQSt01JclIp/oPwSR43YgkwcYTcSBx6RMilo71wk1U4IbBgckyd8z/zPQ4CyKCrBLZ8xXGYP1+HlM3j7+FsIKnNTkr+jr0gDVGhotiLYO33IZYQVFHEvH8j6wXFJ/8vEGi7zCTa0Jn0Kc1X/S6mk5kl9Dh6NRBXYDv8/Z84YrrOq3YEZ74gwqRvgtR3pmf1z+jLWqHqOeWyQ2g06stT4ju6qlvllSx96DClqJMSbDKFqGjSGl5gwzrqZobN9TgsPmICzGioKr0byrzV6Bawo9+m18wiJMplYKFRHMRFgx5Ej5I3wpfzUJKCWgqIiMNJ/eWKvjUynPqXkn3J4HwNA3JCGCk4pm2qONowRSTiuIumhbkjE5++Rkbx8Nepn5Qnn1xAypVaMBKrf7cAKWoMzv6iuUm+L2ZnL5tYPQ/DLcx+kOgvqPlvWtsyu0FFHgsEL8ONYfM6vAccPsEXnEQ4hk4205JJoRQES0eivTz1b+uPDugAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(376002)(39860400002)(186009)(451199024)(1800799009)(26005)(41300700001)(6916009)(316002)(66476007)(54906003)(66946007)(66556008)(2906002)(478600001)(5660300002)(8936002)(4326008)(8676002)(31686004)(6486002)(6506007)(53546011)(6512007)(36756003)(2616005)(83380400001)(38100700002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aERlVWFWVFhxTnZCSThJZW16aUkxZ2Nkd3RpNFYvbHVXbnNQdmFqdmdWZit2?=
 =?utf-8?B?UTlUUWlvM0FFRC9KRk1rQWVrM2FQNzFSdTQ5cEZ2Q2Iwa0FMblJiVysrcGhj?=
 =?utf-8?B?UXczNUZZRVUxR2lGQ0pHV2x5Y3drNkQyUzBRY1YwcVhBVGdYNkhvamMzSFNE?=
 =?utf-8?B?dC9sc0JKaS9Gdk42UUxiRk02MDdKUkIyZTY4aTYwWDgxNkU3KzFGYStjYjky?=
 =?utf-8?B?cXpLWmNTa0FrU01vRFVENGh3dEpNa21VKzAvR0s0aFJNL0pDdkFCZldqeG50?=
 =?utf-8?B?VmJwYVBtdTY2RVNwL3NTQXV4ckVGMDE4ZnpPNDUyTEpYay9FRTF0K1FlUWVI?=
 =?utf-8?B?R0tUdjRHT0ZZZzFXTG9KZWlEZEVlQUVjQUJJYWZnSExVQmNzN2lUVHAxSlZk?=
 =?utf-8?B?aHFGVFlBWmlybWZ4aEVjRWJtMlAzY0x5RzNHbnJxRlZyUFhtSVIvdTNmSEpV?=
 =?utf-8?B?OVJuaUw4MXVzcHFldzdoOTZNUk1mRkJVTGVnUHJBOFF3KytDTG52Z1ZZMDg3?=
 =?utf-8?B?ZE1qUUFzdVR1TlAxV3pybzVmVVB2OXNEYkN4NitRTDI3Q204aWFnS053SWxX?=
 =?utf-8?B?aURzUmtTdnJoVFBZam5GTUkyQXFORUdxaXV4bFNLOEJ0WE8zTGg1ekpPdGhN?=
 =?utf-8?B?cjBTcmM2dkZKRjhxYjZZL2FMV2dSbVkxdzFHd0U0NWl3cFJ5Y0FjZU5oYUpT?=
 =?utf-8?B?L2c5VUFlYk9aR3FsQ1luNlZTRFRXTE9FZzFoaWZEbFJzb2ZEMmJ3TzhieENL?=
 =?utf-8?B?cmtjOVp5a3VNNE1PWXNEYTdBalBGV3pBUXV4SGYyM3QyZytWdmY5ZUtQZEFm?=
 =?utf-8?B?VHNHZmp5MHZKSWFQR1dyMlJRNHpJTG44QTVOTmZRV0NpS3VDblc1TktBL0or?=
 =?utf-8?B?NDR1ZTZHbFRVbVJxSStoMUxDbHNnRWNPZzZTVlVhVHNlVVNhU3haalJDcG12?=
 =?utf-8?B?K0s1ak9pb01rQ2ZabXdYYlRRT1JUWWNKOU1aV1JOQWU0REpDbDBHQS9ROG5N?=
 =?utf-8?B?WUNuRDgrdW9WRFBJOUJLRGJINEtSUDRKcjlyRWcwVUlITWNobEY1SEpFdVlX?=
 =?utf-8?B?aHBCamRmeTAvem1zTzhhYUM4anNJdkNzTjU4c1VMSElIS3J4eFZiZ2R0TzA2?=
 =?utf-8?B?eUNrWFM1ZmpDRjRYREtQalNxOW1IalpiR2VGSEd6WjBmTGdZQkF6cTQ1OXJM?=
 =?utf-8?B?UENJY0xnUXlHU3BwTGxWWHVZbVJMbDUvOXpJaXVpd2hHd3BZakNrZ3hCNTdV?=
 =?utf-8?B?ay9ZU1M1d0FhbTNCcCtpNEUvQWtwenJCa1h0WGlYekhFd3cvSitBR0I1eXph?=
 =?utf-8?B?Ni8xUm82T2hkdjAxbGxHMDlVaHdkaURyUHcrNDhIWWxzdzZ2anpxTVg3elNh?=
 =?utf-8?B?MHJkOGc1RUsxUkZwK2JoQ2pLbzBLMFpGMTE2UlJiVHpUZkJoelduSVVOaG5i?=
 =?utf-8?B?T1U2Q2JsWTM1QXZkTmlRYy9ibnB3ZUVzckRkejVTNWg3S01iMkl1NzhWOGh5?=
 =?utf-8?B?bDJSREVwUXBXeWpoalY0cmdlaVpEd3dVcTgxUHpUMVhOQjR3MGZURFh2b2g3?=
 =?utf-8?B?cDFFV1hUVGtUa1ZPL1FvNkFMcDc5Z1pMRlVpTjFqSzFJU1J5TFJPMFVORlhw?=
 =?utf-8?B?TGZ4N3U5WXI3REpsYS85Rk1aZWRQWnBxeHpIa085R0NMMkwxWkF6emxleFlh?=
 =?utf-8?B?NnYwZFNObUZTcDlxRmJ6WGdhL1FkeVJKM3EzSlV4OEZpUFhyeVFmK0VCa0du?=
 =?utf-8?B?OFF4NlhwdHZtblBiVWFqRUxFU0Z5aUFCTnMzZTY1MVMwUUF4ODg4TlliRHpv?=
 =?utf-8?B?WnNOOVJaSCtEWXdoelBzUFIxaVVJVkZPYXdaalNPUExvV29jYndQa2tWSEJm?=
 =?utf-8?B?emRlVXpXL1NRRjVVa1hZbHo3MjhEQUFBN2tmT2dqalQ4V1gyc2gySzMvSzNk?=
 =?utf-8?B?em92SjUxYWg3NHpCd21tUDc5YnhQbzdGS2VYd25iVi9qbUthSFdqakJrMTF2?=
 =?utf-8?B?MkVrcHhTNjEwb1VxTzZOdWlCOFpSZnRXS3VOMGdXbmdMYjh1aHk2NDk1NDln?=
 =?utf-8?B?MDZ2QW1heFVEa1l6NVdzeDh3TzBsd04xQ3d3OEQxS2VIei9xcEJUdFJoVTFS?=
 =?utf-8?Q?sEQD/gEBiBLLq9q2HogJPhi/9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a08b102-2133-47d9-ba9f-08dbb5fda6e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 15:08:43.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhPr5wxndXvUWkEplTKlAH/2TllohQxeqG59CDSI5pRCOWsmi1yeCwy+pb+StTk9ochoO5aEFc2Brj+IzYSUQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/23 09:51, Sean Christopherson wrote:
> On Fri, Sep 15, 2023, Sean Christopherson wrote:
>> On Thu, Sep 14, 2023, Tom Lendacky wrote:
>>> When the TSC_AUX MSR is virtualized, the TSC_AUX value is swap type "B"
>>> within the VMSA. This means that the guest value is loaded on VMRUN and
>>> the host value is restored from the host save area on #VMEXIT.
>>>
>>> Since the value is restored on #VMEXIT, the KVM user return MSR support
>>> for TSC_AUX can be replaced by populating the host save area with current
>>> host value of TSC_AUX. This replaces two WRMSR instructions with a single
>>> RDMSR instruction.
>>>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>   arch/x86/kvm/svm/sev.c | 14 +++++++++++++-
>>>   arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++----------
>>>   arch/x86/kvm/svm/svm.h |  4 +++-
>>>   3 files changed, 32 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 565c9de87c6d..1bbaae2fed96 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -2969,6 +2969,7 @@ static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
>>>   	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
>>>   	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
>>>   	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
>>> +		svm->v_tsc_aux = true;
>>>   		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
>>>   		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>>>   			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>>> @@ -3071,8 +3072,10 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>>>   					    sev_enc_bit));
>>>   }
>>>   
>>> -void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>> +void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
>>>   {
>>> +	u32 msr_hi;
>>> +
>>>   	/*
>>>   	 * All host state for SEV-ES guests is categorized into three swap types
>>>   	 * based on how it is handled by hardware during a world switch:
>>> @@ -3109,6 +3112,15 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>>   		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
>>>   		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
>>>   	}
>>> +
>>> +	/*
>>> +	 * If TSC_AUX virtualization is enabled, MSR_TSC_AUX is loaded but NOT
>>> +	 * saved by the CPU (Type-B). If TSC_AUX is not virtualized, the user
>>> +	 * return MSR support takes care of restoring MSR_TSC_AUX. This
>>> +	 * exchanges two WRMSRs for one RDMSR.
>>> +	 */
>>> +	if (svm->v_tsc_aux)
>>> +		rdmsr(MSR_TSC_AUX, hostsa->tsc_aux, msr_hi);
>>
>> IIUC, when V_TSC_AUX is supported, SEV-ES guests context switch MSR_TSC_AUX
>> regardless of what has been exposed to the guest.  So rather than condition the
>> hostsa->tsc_aux update on guest CPUID, just do it if V_TSC_AUX is supported.
>>
>> And then to avoid the RDMSR, which is presumably the motivation for checking
>> guest CPUID, grab the host value from user return framework.  The host values
>> are per-CPU, but constant after boot, so the only requirement is that KVM sets
>> up MSR_TSC_AUX in the user return framework.
> 
> Actually, duh.  The save area is also per-CPU, so just fill hostsa->tsc_aux in
> svm_hardware_setup() and then sev_es_prepare_switch_to_guest() never has to do
> anything.

Ah, right, because Linux never changes TSC_AUX post boot. Much simpler.

I'll rework based on the comments and send a v2 series.

Thanks,
Tom

