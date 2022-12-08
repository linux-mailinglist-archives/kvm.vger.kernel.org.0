Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65061646F4C
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 13:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiLHMKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 07:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLHMKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 07:10:06 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2076.outbound.protection.outlook.com [40.107.100.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00725444D;
        Thu,  8 Dec 2022 04:10:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVthjqmXDA6EJszV4rluVBzkiC5+HpwxV8KH9ftB+C4XXqfXxQlcrxgpsVDHxXIkX4roqvUnG/mqSlcrP3MPsFfbzJP9ajTSVONLM3IwRsg/d9fVODiPW/cHXpOxc2XT4v2glkx366EL71Xz2KhnGn3Bat2TTNDFfXe0diZj+KRy8yd/7PHDoQIfQhZMtvj1PZnrGEZ8qmqXCWiaAmUkzyTlO/2oDCxm8ZboR9ZWZ5x86TaUhd04AzMH9G7tdZfoe3NptfXdyksR/toqoTxE6xV14r1xD3RU2vLIWc5o8Id9sriAb66o+rnUU7YwRKO4U9kmDLM59f1sWjQw85tFbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEahMelRiz7SVjiH4uQ6odxJbhazHbDGvjxJBf0Dgyw=;
 b=cKdMewM5Hopl7BwbrqiFAPw6tvG48EKHMPwP1N0oO8RLuRdybI0EEhdYL/qTF8x8W68U+QqQ4veI5eOvAU9NLZUnomt2hUkS6QM3aA4e6KLaIgydynXu/ECyVMbS/4Ul9ZPN7ZHEpOwuY+ivpxM6dIjGN3yL/zOSR7yoC5ighOG9x0iU9XjxnVPOwPmK69ZVb5Go86b7IbB4kKpluopqNiJhr23c9h9buTo9/TnkO/wk1Dje0jc7rsMY3XjXYPblboB642RYScf6aDz+jHAj0SCQTn81E7zFIBfRHWJeaDaZLDWm3yQqKdFUxNP0pK2KwtNBL35mkyt4PLNr2UlInQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEahMelRiz7SVjiH4uQ6odxJbhazHbDGvjxJBf0Dgyw=;
 b=erndL7TsO1UtD3/xZ2F+qOuqRkmsBrhVrlcs7ArgKwwLPGro8Uxe10QNnjhGqSUXW3IoHihzOAnqRWky8I14pLUmwidYYITr0YdbYcSy22lxKkYKSzQkIQua4ud3dMIe8lTJom1BLhchtvhWuBBV+nE/YzLesYUyLq8qVy3zrrY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH0PR12MB5042.namprd12.prod.outlook.com (2603:10b6:610:e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 12:10:00 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%4]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 12:10:00 +0000
Message-ID: <70078abb-f8b7-cd33-5bdd-bc6ee44c0bd3@amd.com>
Date:   Thu, 8 Dec 2022 17:39:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 06/11] KVM: SVM: add wrappers to enable/disable IRET
 interception
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-7-mlevitsk@redhat.com>
 <41abb37b-c74a-f2cf-c0ce-74d5d6487e92@amd.com>
 <181f437164296e19683f086c11bf64c11a3f380e.camel@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <181f437164296e19683f086c11bf64c11a3f380e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0056.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::20) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|CH0PR12MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: f9870377-4264-48c8-214d-08dad91520bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8plbkLReGkeVa2ezVaxUi0ohJk8moJ3h39rAzJBlAdHRE8hKZmZ6Ske4zmRLOdE2MfBa+9C6XVOs/88IZg90HlLZ/z37BXo8ZWb2OaH5Gxn9TjIMWdv7RFQZQMaHmOQwRFtdegRBJW4vx5T0Ib+6BzBBarj9eNT2uTHBLLCmf1yoGCwHbDcGXx7pLND74Rg/7JlMCX9N0QmUyNgjRy+R7aqbY/H0lOOds+g1cwdQ5PlqH/q9DrE8b1x+ePy2f0q2HC1TVgJUsKlfVtJuxNiifsY6CYS9amD+1scMqozCV2HoB3rx50lhc05276Zc2V8MPg7MFHw1WN0cxtiRzuvu7h83Ok1xb7BQir/I8yWQIUPw6Ti/zIRDeqzaIZ2niCm27vcnD0mlSnidEg0DSpeF9Bd22Dkwmn4wBDo4+2PPQj/gVL9Os0M1zIEGWj2GQ28vU63uACfAXwkxBpOXX/ltFtvABQBiYdAY7v1ihyMAtoHpB7X4yM23cn2ita6Qrvps8dlLoMzkR5Chxokqr/L6exMJtvZXK6Mbq8v4AZjepD89I0Lo3pQI2u/Tpi1fuBQwWrVMtmBgiLcgKEaYAPVIu+bjpty7BRUqVnRs4EAmfNiOFLrqJdXrwruRpnuBJ+uZKROaKnabxHdo61lyM1i8RAgEBjh3Lpe6xzswgl+6+T23WGZDelgp2ZTz5j1cUgf8lXiq521JKTldAbZwesG22FneaCNjigJvQjt+UAH3prk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199015)(31696002)(186003)(7416002)(86362001)(5660300002)(2616005)(83380400001)(44832011)(8936002)(41300700001)(38100700002)(2906002)(36756003)(6512007)(26005)(53546011)(31686004)(6666004)(478600001)(6486002)(316002)(6506007)(4326008)(66946007)(66476007)(66556008)(8676002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djlrVWo3YWxqT25pYzllZjg4Z0hLZzJzZldRVkR2K25TODFrT0JZUGZLakJS?=
 =?utf-8?B?M3VPWE4zVmxyazJ1SDRCMU1kb2RLNjNxSEFUTnZXbDY1Wjg4OExjbXFlWVBv?=
 =?utf-8?B?L0VtaVJsU1EyRFdraGNTNE1yd3BzK3lLK28wWTB5UGpTWFhkQXExWVRVNytP?=
 =?utf-8?B?QlFsbUJSdVhNVlMwVjczempTVVk1Q1Mrek1ZQ3IrZmk4YWE1cEJpOXd6Vmxo?=
 =?utf-8?B?U1dOSXpYZWxIQ2orY08xRTg5NGd2ekFESmVFK1hFSFpvS1lBMU1hRWdGSXcz?=
 =?utf-8?B?MmhKL2wrWTFLR0JjQ2tFVGZpWlVBQlpKbVMxNStiZk5CWlZRMXAwVkx2VFRN?=
 =?utf-8?B?bVRoWHQydjhZMUpNajF1MExqM1ZYSVRremdQeDFkUGxJNUxXZ1E2WSs5MlJp?=
 =?utf-8?B?TkpBS001NlhnWWhPYmtOSTdSek1yUW9abFI4RHoxSjNLNGQ5NS9TZjgwbCtO?=
 =?utf-8?B?NUhRWjI1eXQrR1EyN2Z0b2lmY0pYZ1ZxY0JJOWd0Ky9BWnJ1SzZBd04zTUhm?=
 =?utf-8?B?RmpLV2ZWZ1FHakxJN3BzeE1EYitmOGx3ZzJ4cDlNSDN5YjRTcnFtZmpqT1dz?=
 =?utf-8?B?SjNSWkkvMTRuTHl6RGZLeFVvdDd2Mkc3NlUvYldlV2V4NkZQSSsybnRjak51?=
 =?utf-8?B?MFpYZ09lNnpaR1BHV1VLdlZDRk52cVRUbGMvcHByUk13YkhVWmVWWG92M0NG?=
 =?utf-8?B?SDFwNXpCa3pHU2ZrSTlUU1M1QWFPWkZrU1NqWkp6TTJUb09pTDR5bFR0NkVZ?=
 =?utf-8?B?eXdIWUhQSFlvQlpWTlpIOVFFS3gwSy8yRFp5TzFseFAyQ0JRRWNJZ3M3bnVE?=
 =?utf-8?B?djg5bDVIRFd3K2V5ZThpZEFud2VrL0pMTDl0a0pwWCtqMzlQM3hPZEdhSXFj?=
 =?utf-8?B?V1NVdGxXWFVQUTEyVUFibVUrYmMyRDRYYnpLMXMwUFZjdFFINnIzNzUvOStK?=
 =?utf-8?B?S2dObWNENm1VT0wxTzRLRHFWMmh2QU5YNitGYWRpV3B4dWtSZk1TTlprUnZP?=
 =?utf-8?B?WUtRSCtrNy8zTGxuNkQyaWVrblRsalBFMWl5TEcvRXZRQ2cwNWhva2pUbGZZ?=
 =?utf-8?B?UUhoTitGdUpOeDVWQ3o1am1BbXliQ1J2L1BaUlplZERGNFFhaG5VaTBKeW9r?=
 =?utf-8?B?VUkzOXA3SFV6L2hpZlhtclpXQXo5YmZxOHBkOTQyVm9NZElmVCszZzRibC90?=
 =?utf-8?B?VkVIenJDWlMxc2dkdUxZM0RhM3pqMzVYV2o1Q3JIazFKM0Jqdlc4THM5Wkpq?=
 =?utf-8?B?aUF1bXc5dGFuRUhYdjd2clFEWkdET01xTHFRbGFDQWZjUlkrTWpHbVhwZVMx?=
 =?utf-8?B?SkVRLy9IalRmSXN2TElIRnBmMC9Mb2dyTTB5bGhYQklsZnhEeS9GeWxCWTdY?=
 =?utf-8?B?NkpMbmtVTkU2eE5KcWJxRCt3Qm92dnV4UFhYYXNvOVNIWlZmT002QkhRTmdI?=
 =?utf-8?B?TjJVQzBEM3RpR0JxVjF3RU1FVkRtRXo1cENFc3U3T1VDSjF4OE1uaFhyRjhR?=
 =?utf-8?B?RFE1dzBQR1dwRVg2Y01rRzY4OWRhRWpVaGQxVTlLNnJ6K1Z5c3ZXOXFzditF?=
 =?utf-8?B?OHNkWGhVdGJuMnprMk5hR3BGei9lejI0L24vR1B4eVJGUmE2VXNucnp5VlBX?=
 =?utf-8?B?TGFTTENDQkw2Z1lOeDBDbEhSWHIrS3Rtdk9ra1J4c2MwQVF3NENsTFlueHB0?=
 =?utf-8?B?V01SbXI0NHdZU3UwaGtCSzEzU1BpWkdFWlRUODNieWtydXVvZUJFSjZiT0Rj?=
 =?utf-8?B?SVNPSUsxTWxxMU5zU2F3blFpTkRnNW5xa3NleDBxaXEydGtBUitNc3NlSzV5?=
 =?utf-8?B?SzhaaUJWVFVDRCttZ1dMMEZLRDNhazNqbHNsUXNPSVlCTWM0aHZHTGQ4ZlBu?=
 =?utf-8?B?NVVHSVArSnFCbngzVzJEYWZnbkRHLy9PQ3ArRDZ6TFZoMk9RLzZmaU1LM21j?=
 =?utf-8?B?TW9qcnQ4bWluZTZQOXZZTGN2dk9yd2ZGK094ODR3TFI0THl0b3VLQkI0RHFJ?=
 =?utf-8?B?MjNBOXB3MXB6Tm00azFZc3lrMmhXQjh2RXo1bFRMQ1VaNkJWZEllZVRiN2lE?=
 =?utf-8?B?NytJSTdvVGZxWDRpZEdCTlo0WkhZSHhhWkpXVUgyRW5NVVk4aVNZeCtFd1hZ?=
 =?utf-8?Q?u8OEfycSHcvF8CCSTPMYFKDl8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9870377-4264-48c8-214d-08dad91520bf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 12:09:59.8282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Gb/xfIUbd89J21aHFClG8dFC2gLzK9w3h7opnOTwQMTza3mLenjfEV2KhJn06Gl3UPQo13LhJsPhvw9vCHv5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5042
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/2022 5:44 PM, Maxim Levitsky wrote:
> On Mon, 2022-12-05 at 21:11 +0530, Santosh Shukla wrote:
>> On 11/30/2022 1:07 AM, Maxim Levitsky wrote:
>>> SEV-ES guests don't use IRET interception for the detection of
>>> an end of a NMI.
>>>
>>> Therefore it makes sense to create a wrapper to avoid repeating
>>> the check for the SEV-ES.
>>>
>>> No functional change is intended.
>>>
>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>> ---
>>>  arch/x86/kvm/svm/svm.c | 28 +++++++++++++++++++---------
>>>  1 file changed, 19 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 512b2aa21137e2..cfed6ab29c839a 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -2468,16 +2468,29 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
>>>  			       has_error_code, error_code);
>>>  }
>>>  
>>> +static void svm_disable_iret_interception(struct vcpu_svm *svm)
>>> +{
>>> +	if (!sev_es_guest(svm->vcpu.kvm))
>>> +		svm_clr_intercept(svm, INTERCEPT_IRET);
>>> +}
>>> +
>>> +static void svm_enable_iret_interception(struct vcpu_svm *svm)
>>> +{
>>> +	if (!sev_es_guest(svm->vcpu.kvm))
>>> +		svm_set_intercept(svm, INTERCEPT_IRET);
>>> +}
>>> +
>>
>> nits:
>> s/_iret_interception / _iret_intercept
>> does that make sense?
> 
> Makes sense. I can also move this to svm.h near the svm_set_intercept(), I think
> it better a better place for this function there if no objections.
> 
I think current approach is fine since function used in svm.c only. but I have
no strong opinion on moving to svm.h either ways.

Thanks,
Santosh

> Best regards,
> 	Maxim Levitsky
>>
>> Thanks,
>> Santosh
>>
>>>  static int iret_interception(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>>  
>>>  	++vcpu->stat.nmi_window_exits;
>>>  	svm->awaiting_iret_completion = true;
>>> -	if (!sev_es_guest(vcpu->kvm)) {
>>> -		svm_clr_intercept(svm, INTERCEPT_IRET);
>>> +
>>> +	svm_disable_iret_interception(svm);
>>> +	if (!sev_es_guest(vcpu->kvm))
>>>  		svm->nmi_iret_rip = kvm_rip_read(vcpu);
>>> -	}
>>> +
>>>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>>>  	return 1;
>>>  }
>>> @@ -3470,8 +3483,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>  		return;
>>>  
>>>  	svm->nmi_masked = true;
>>> -	if (!sev_es_guest(vcpu->kvm))
>>> -		svm_set_intercept(svm, INTERCEPT_IRET);
>>> +	svm_enable_iret_interception(svm);
>>>  	++vcpu->stat.nmi_injections;
>>>  }
>>>  
>>> @@ -3614,12 +3626,10 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>>>  
>>>  	if (masked) {
>>>  		svm->nmi_masked = true;
>>> -		if (!sev_es_guest(vcpu->kvm))
>>> -			svm_set_intercept(svm, INTERCEPT_IRET);
>>> +		svm_enable_iret_interception(svm);
>>>  	} else {
>>>  		svm->nmi_masked = false;
>>> -		if (!sev_es_guest(vcpu->kvm))
>>> -			svm_clr_intercept(svm, INTERCEPT_IRET);
>>> +		svm_disable_iret_interception(svm);
>>>  	}
>>>  }
>>>  
> 
> 

