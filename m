Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CA57A28D0
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbjIOU6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237697AbjIOU5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:57:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A6430FE;
        Fri, 15 Sep 2023 13:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CycNLcmMX4RoVr2Oyxpf1YkA8uZIZW7tZ0JJYaVm0v4a6izWGLUnkN4PcaVrvgsiQsC5tXEpBbSxoDzIdAelK5ZiTqLjSZS5cXOtyST8Ij6nQelU0P0YvMSDIT6t6GMxXi0VBmZBRzpWoX6IFBkKGA7Pegf/spfY1vs3wqPxcZ4AuZhMm6E1Cvh936uegz8KKVtQ21ko4WVeZLNMdjGX8PgNNbAOpzwEtid3yCpaA5IOAITIoc42+xkmc6PoJjINwSngumiw0VEDj16v5+9Ase4OyMR2uQR+x5KiT8MF+3u4fry8+w5qvk8vLeYOgUB1zdUZbk/+OGoMFLFMTLXVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/u7Y9N/tJ6VhIiKADc2PcXlWfNVnVpsC/Jd2c+go5iA=;
 b=lecuBsw2x5tEM8LBVME/HDS31zADhibkS0W8Svb04DTuAkJQ6IVXkuQlLXsaqOrOWJEqe/A057lZBbQemJui0kPrHGlZR+cEU742MLwxuCeCkGaJFWkGVnTcwx4McH/ex6avE77FEnW3kxkttyQ4zbKBAmcaVokd8mLT4+bCsya2fNcwkOCN4a8JwwwGbKWHiXVbwYiA93Dk+iLqW5Z8dwbZjG49sekwywjF3YRTkeLfsKRK2bK6M3f044IwhXCHFaIChnlriGz/SwlUIQTW5qH6poCVJ6RXo8dpfsbUeczx5KAwCOS4QNJHVOjapIFJcbhiiWt+158j5yBwV0ZtNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u7Y9N/tJ6VhIiKADc2PcXlWfNVnVpsC/Jd2c+go5iA=;
 b=hHr2Txcu4MfwKyBK3hhpoU9KuvwrIa/qdT4Qv7mHCQU6nW0IRmCDzR+BQxFN24OtiX4uUtvIK9XdsjmbJPBMe4ZpxkTbunJumH2gRAo74u5olQTerjcJfck5a+iebWlnsDTSvdlPtYjRgBHs6fvQm5d2VZ9jQ6q/2SLB6djCrr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW4PR12MB7117.namprd12.prod.outlook.com (2603:10b6:303:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Fri, 15 Sep
 2023 20:54:13 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 20:54:12 +0000
Message-ID: <ff993ee2-fdc6-1849-4290-efd2efc6ca06@amd.com>
Date:   Fri, 15 Sep 2023 15:54:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] KVM: SVM: Fix TSC_AUX virtualization setup
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
 <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
 <ZQNs7uo8F62XQawJ@google.com> <f2c0907c-9e30-e01b-7d65-a20e6be4bf49@amd.com>
 <8b047dad-84ac-69f9-3875-38bca92d7534@amd.com> <ZQSVFQ78M/OUtWaj@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZQSVFQ78M/OUtWaj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR2101CA0009.namprd21.prod.outlook.com
 (2603:10b6:805:106::19) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MW4PR12MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ca3ee6-e0ac-42e9-46e8-08dbb62dea64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMMT9KrXusDXJrhSpoGLfeEVMTmHQntl5obsnajcyTwaFI9osH2P8kVKfuXdcCiwMUO305JGRw7OSNGWViZebHi1NUWqobniagBfegHj/Si2lTmuNEeEe9bSc4WnU8htU6nJ+BtWklGIQvppvLluzgQXIuez/dPlJw3v2ZwOogbEVHJK6UGlsXBQFQZFGUAh9Ig9zkrkJEcOWGHb1HWauvH0eMetAnwKpqtQZkR6/juGYQfNQ2PXZcKP/2vpPL8uoH+9W5gqK+EmDQZ+SJL9L92jJaBWSNl0sA8VMwwenPmDduXMZtIPD3cl36TWIWtSPCrKzvswp0p4EjpYSnul9MqNk3vQt5lgZf4Jew6jkdNbIIu0J/19+s1D2Vr4JBqUKWu/AzKSl31hom3UtFLX9QImLwuH/7vCc4V7sUIeuBaW+6hdaUm4dwczeoDyR2ZowjAs32mx3mnhUJD2t8ePw0qGPP8tnEO3zsct9xU36LAY89vu1TyCvp1O8aO0NHaGrtyi6jp9/orlwt5HDFlTmErMusppyFk1r3jYO0FuUK7g8BWS4RlVsVUgZLiKUhKZE3sfB47cp24rBEMvBMZbNLfgNieCOGnmraa4PoH1BQVlS9IuYqpUzuMkr/ZG1OeyKrxenEh1hlAeZzZ0fqiU2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(376002)(396003)(39860400002)(186009)(451199024)(1800799009)(2616005)(26005)(478600001)(38100700002)(6512007)(66899024)(6666004)(53546011)(6506007)(6486002)(4326008)(8676002)(8936002)(5660300002)(41300700001)(66476007)(66946007)(66556008)(36756003)(6916009)(86362001)(31696002)(316002)(2906002)(83380400001)(54906003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFhkYURiem04dnFTU2IvQzNEc0Y2OXBnRGxxSlpEZWdoRGlwcTE0N2hiSk1x?=
 =?utf-8?B?T3FPTGJhcXNWc1VuQ3pDTDY3b25ZU09BRlROMHh3Vi9SOFBzS0pIM1pMTXps?=
 =?utf-8?B?TVArYTdUd1JERkxuYTY5bzhJcXplc0tIell1TnNtZmMvNGI2N3R3M3pUTUVr?=
 =?utf-8?B?dGZzZXV6VTQzR0RVVmtTbVBQbjJ4K2Z2T1QwcmREMWlCT2tkenJlZzZidlZ3?=
 =?utf-8?B?RFI2WTM2bGU3eHc0c3JZTThMYWRXNDBvQ1NJS09ZMitpNWVoRVBLNTBHNVFv?=
 =?utf-8?B?emdUTmZ6M3dtM2FETEFPbHUyMHJvYUlLcURnYlZZdG0zTjZNajJVb1BLTng4?=
 =?utf-8?B?Y0RMQk54akdpUXNNZzBrc3Vzc0V0bUZTVUhjVmRRR2JYd0lNUWF3b0JqY0hI?=
 =?utf-8?B?dnJJSVp0bXBwMS9icHpBL2I0azI3RzVVV1ZFVkQrT0dvTmFTOUUwTU8xYzNt?=
 =?utf-8?B?bk1IS05KQjNDR1h3NURlK1JTL0MrSFQ3am4wVUhVcEZYQ1BLMTJMTDVsb3Na?=
 =?utf-8?B?Zm93ZVhsNjZ5OFFGNW1kdXk1aVZSVTRIUzBMNjBxSUlmMStEOU5UOEh6bFNy?=
 =?utf-8?B?SDZaTDFzVXRnQlJvTS9PL2crdGllTXJtU0Fpc2kycW9xQklSUHpGOE4rVjA5?=
 =?utf-8?B?RE1UdW1PUUdqa2J1VkZJN2d6SkNkdzJjZ1ZYejJIbFcrbitOVlR3YTJvMVky?=
 =?utf-8?B?Y0U5OWxhME4zQVNSVGY3ZE5QVTJ4aUZSWVJpNlFhY2hUSE5saHlpYlI0eXFC?=
 =?utf-8?B?VlJoN212bU1RY21zaWd4NE5iVG1xYmpVVGhRZTFQdFhIemRjVVFnNkVhdVRK?=
 =?utf-8?B?bWdaa2llemRWbjh6cXVqY2RMQjRROE96UTVxQ1htaHpLN04wUlVQb1UyNmE5?=
 =?utf-8?B?aWpMN3UvbGRxYS9aZUNVdEFUQVpKYW1kR3kwYmk5TDl5bGVHRlhEUFJYVCtI?=
 =?utf-8?B?eWhjdXROV1ZhVGE5bnl0L0hJcTc1d1JaV0RUdEU4MGJWemszQ0RuekppMnNY?=
 =?utf-8?B?Um5ZUk1pSU5xc2tZUGtBQXd4YTVzdmVqb2FHZmM4RWxBaEFVZXVDVXVCSkhu?=
 =?utf-8?B?RlhaYlZBRkhGWHlKeW9FMzhuZ0NMZHBYd3YwUUlIVVdZNkROcnBOQU5sQ3Bl?=
 =?utf-8?B?dlIwci9TMjFCOSsrY1dEUXcxa2ZGSVFEUWswVGk4Zm1mcjFpMmNmcTFRdHNL?=
 =?utf-8?B?eStjVzltSHBEeEV3N2tmeEh3dWp0RXlpcU4vUjJHTWNHeGJtQ0o0aHhkWFo1?=
 =?utf-8?B?aGlvSTNjam9mdlhQNi9PYmJRVXliNnJSS056SHA0MTVJdElGZTlMbWxaNUhp?=
 =?utf-8?B?a1MyYkpZbExrN2pYWnV2T3dJNlJWSUlzdExseUMvV0NhL1VRdDIwa2RoLzVG?=
 =?utf-8?B?UkJ4Q014UHpuTkRrb05NOGZxaE93MXNkeWtyam93ek0zTERCMGEwWUVKNmVY?=
 =?utf-8?B?MWpPVFFuQnIwOFZRelY0NG9BOXdiWCsyWnpTdDZzdUFiUTR0eXVOMWtqY3Mx?=
 =?utf-8?B?UVgzdnN5WS82VWNTUkhRaFZ3UWtIU1I1WStmZ0FvUStTL1FaUnFvbEFNTDNG?=
 =?utf-8?B?aWxxendKU3prcDBCWXhGWTMzSzRqRGgya0xnZlVobUhBY21PSjdjNTZaRFoz?=
 =?utf-8?B?eUhnTHA0aGtGZmtlMWF4dWl5MTV3OVB0dDJENWxIMG1hZHpGWGNheEozcXVM?=
 =?utf-8?B?NlRFZ0lBU0lBWWRheWNrdUN2SkI2RDJZTnNXZHBuOUVWWFk3eUN4cjRnREJT?=
 =?utf-8?B?aTBYMGV6dWc5RTdWOVJVWVJZc2VhQXlubENPVFpxaXVYa1FqaXo1c0RRaFNx?=
 =?utf-8?B?V29xUjdvZnB2QnNJRWoxM1NTYmd1WGduN3RNZTJROWM3RUltQWxGOXhtaUN4?=
 =?utf-8?B?QWFWZi9TM3EwK2RzVU50ZnVYVVp6QWx5Y1BVQVViMlU3TU5iZUtSQVVyUWYx?=
 =?utf-8?B?elhoZ0cyQW9IYkpLT2t1ejBmL3V5dko5ekY2WXE3VWg2MGZGRUpNUHZtQUs2?=
 =?utf-8?B?T0ZTTnptRDBEdVZMYlh2MGN6bHV1RWNBTzA0Zk5NNlBpb2o4NXcxVEFzdkxh?=
 =?utf-8?B?S1diejdrODZCUVVSN2VXaWFSTi9nYWhWZUQ4aFMvd3RwRnF3ZWVabnNVT1ZE?=
 =?utf-8?Q?AzGndGxv7HVc8wlCJHwlLLF1p?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ca3ee6-e0ac-42e9-46e8-08dbb62dea64
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 20:54:12.7061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmoOET4q5ruGyt1FYNUWYgFTLinU1eCe37LL/FDkNjXc7MoFFvrWGlr1qULGq/EZ7flWQGoS63YNBH/P/CWmcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7117
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/23 12:32, Sean Christopherson wrote:
> On Fri, Sep 15, 2023, Tom Lendacky wrote:
>> On 9/14/23 15:48, Tom Lendacky wrote:
>>> On 9/14/23 15:28, Sean Christopherson wrote:
>>>> On Thu, Sep 14, 2023, Tom Lendacky wrote:
>>
>>>
>>>>
>>>>> +        if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>>>>> +            svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>>>>
>>>> Same thing here.
>>>
>>> Will do.
>>
>> For RDTSCP, svm_recalc_instruction_intercepts() will set/clear the RDTSCP
>> intercept as part of the svm_vcpu_set_after_cpuid() path, but it will only
>> do it based on kvm_cpu_cap_has(X86_FEATURE_RDTSCP) being true, which is very
>> likely.
>>
>> Do you think that is good enough and we can drop the setting and clearing of
>> the RDTSCP intercept in the sev_es_vcpu_set_after_cpuid() function and only
>> deal with the TSC_AUX MSR intercept?
> 
> The common handling should be good enough.
> 
>> On a side note, it looks like RDTSCP would not be intercepted if the KVM cap
>> X86_FEATURE_RDTSCP feature is cleared, however unlikely, in
>> kvm_set_cpu_caps() and RDTSCP is not advertised to the guest (assuming the
>> guest is ignoring the RDTSCP CPUID bit).
> 
> Hmm, yes, though the only scenario in which KVM clears RDTSCP on AMD comes with
> a WARN (it's a guard against KVM bugs).  If the guest ignores CPUID and uses
> RDTSCP anyways, the guest deserves its death, and leaking the host pCPU doesn't
> seem like a major issue.
> 
> That said, if hardware behavior is to ignore unknown intercepts, e.g. if KVM can
> safely set INTERCEPT_RDTSCP even when hardware doesn't support said intercept,
> then I wouldn't be opposed to doing:
> 
> 	/*
> 	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
> 	 * roots, or if INVPCID is disabled in the guest to inject #UD.
> 	 */
> 	if (!kvm_cpu_cap_has(X86_FEATURE_INVPCID) ||
> 	    !npt_enabled || !guest_cpuid_has(&svm->vcpu, X86_FEATURE_INVPCID))
> 		svm_set_intercept(svm, INTERCEPT_INVPCID);
> 	else
> 		svm_clr_intercept(svm, INTERCEPT_INVPCID);
> 
> 	if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP) &&
> 	    guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> 		svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> 	else
> 		svm_set_intercept(svm, INTERCEPT_RDTSCP);
> 
> Alternatively, KVM could check boot_cpu_has() instead or kvm_cpu_cap_has(), but
> that's not foolproof either, e.g. see Intel's of hiding PCID to workaround the
> TLB flushing bug on Alderlake.  So my vote would either be to keep things as-is,
> or do the above (if that's safe).

Keep things as-is works for me :)

Thanks,
Tom
