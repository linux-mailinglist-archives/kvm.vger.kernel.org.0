Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EED7643D7E
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 08:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiLFHPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 02:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiLFHPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 02:15:11 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2075.outbound.protection.outlook.com [40.107.101.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF4314D04;
        Mon,  5 Dec 2022 23:15:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNAVYruij43VRlDCYQxrBBwyUsSslIo92ptV9VZMKoSSL5oOffLBezKtItSTxTgaWZvo7xiXRpPXtodxr6+cMQVZMeIYBr8QAuy3CagezgDpRhnUNDpaBMCV5/0g0i/eZ+mLjvCfXkH4OksIBLQjfzc2hBwLyhqkeCC3ZqLBGmJrDtG+FppXLavIXtNvOJ1KMgvitaH6FQQGh2XcfV6o22LqLvAlMJGEcg9IhoCblYSHAhsHmPQrOXLT6DFNaN9B0N+lb9++wXlUCQ72zWIgC3pzuePzMHgRUHMDw3toHJDf9I3JphsY9WWlILolVUKDXe8HbDDA9R1EGdL3NVWIjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vh/MHjYK5PopSrRlwbY2Mp5mzBsXVTzUdg/igClFNHA=;
 b=mPiyHfw+X+l/A22BPm72nvXELtt/bQRVUgEQNA57u7RMzBMuTE+a8hYHocOednMOw7iNTSyjVGsRvyJ4yzIpkmTURZe1uR7bKFPZ3buur6Kr3X4mMJXJcrxI3FD6WJYBEFaeiSvkHNJR7/OtjbPLq0ca40hRtcaPCjhR+527ajrWvlekmQ3aKTgwF/h6zOWL7q9T/tdg1XIP2YNBoaqUHEYVyUCs/wLPRpYnGGXAuYg1sVQ/Vbv/dJ3C+WZe/nhW1moA4HCo8JWlcU7eBMEgMv/1K+OsSRjmoN+C8MvCvsvI0+jERJwiE4RzpE//IOqetNPNvbik5UqloEdVosIJPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vh/MHjYK5PopSrRlwbY2Mp5mzBsXVTzUdg/igClFNHA=;
 b=rZjjQ+Ts0AwClOHs2lEd67zHHEfrvQH8vLCRaJtA348U4w5D/Qa07L/340x13T0nCmX/ngd8/VeS3+HQPC55Nx0BOC5C4BY7xVc+NwO5UMirxu1hFDmxg69TZhrg/CwO2qympr82YaU5pyHIX7SzVqBc9Ea7dbdto+uzCu+HUY8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 DM4PR12MB6638.namprd12.prod.outlook.com (2603:10b6:8:b5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 07:15:04 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4%6]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 07:15:04 +0000
Message-ID: <b28f0cb9-b321-cc55-db31-61296e1a494e@amd.com>
Date:   Tue, 6 Dec 2022 18:14:53 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu
 variables
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-2-aik@amd.com> <Y4jdIl1elcnL8JUU@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y4jdIl1elcnL8JUU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY4P282CA0002.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::12) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|DM4PR12MB6638:EE_
X-MS-Office365-Filtering-Correlation-Id: 784b7f9e-bfe9-4b27-5742-08dad75998a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/ZGocUYu5jLA5SbiOwD7cOMLYiH7l+0JceKiy+8IPmiB2CcDfqNLSFqmvXF4U9w3Zp72RnWJsNeYyHpBRZC9jEvGAs2mw2phgxtOAx/PJzJF5F92tp7YQ7KIIynCBmjnpof1z15MUTJwLg/kRgbNd5xQ1m4v/Ypi9CRypZ9YwhISV5YrdcxEFYwcLo25SJ/2C/RCrvJok/xjjGRceCx9u+lIN0sdv81TFgvSZi/dlLatkIX/pZZhTQVaf1QmA1sV9KeYJ0f2KlPaoUqzmr653BqQughoRvESX5ymbu46oXZof4DMz3pY5S2JBT/5r7go65VQLhJrkvo3jiU0jPdbIil3dzd8azls94DLq63c/uR2OHP6lzhn95wDlNy83MBnQjO/oSjQWB6f1yxTzFbJeNVUieqIY40/sj4WlDPT7RUUF5FzbUAqU2Us5ShJxYvzfQN9SYl1c3GAhOEb7Gv4WOovdhcsDk4J82DvdQ65+f98RxHNdJfur8dUa0+t+4YzJoLrvPZxAGXlbXYfpjGzFdA6UJHN5Rzsnt35K0GqNqDlsyNve6mXATm/LF+fHsZH/0T5WbSydz+jgsVs7mZu6Xw2N9JrQv30+FC4SqQrlokJwYqdJOoaMwfPyQaMBQ9vp7sALHOgN97yypVgFOgw40c0rr+ShHB4msUJlU6Akn+EiCvEWL9z2D9EB3GFbGoD6+iE8UT4RyawCIpVxCNfUrIi6krTw8V8BHGZzaIyQI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199015)(31686004)(41300700001)(8676002)(4326008)(66556008)(66946007)(8936002)(38100700002)(7416002)(54906003)(6916009)(316002)(83380400001)(478600001)(6666004)(53546011)(6486002)(31696002)(2906002)(186003)(5660300002)(66476007)(6512007)(6506007)(36756003)(26005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUtGelJkallOR2hjRUhiSEdDNzJJRkxWeTNJdHZvZER6SlNxZjdodzE5MVFa?=
 =?utf-8?B?dWFJZzc2K3VYdmhLZzRPYk1oZ1I5anJtWmQzS3k1ek5jRTA1RTU0cnJWcUdy?=
 =?utf-8?B?eURYMzZ5WTF6aFdvcGcyTS9velZzVDMzejhENVoyWnNrbDZaRS9OVGZXTzgv?=
 =?utf-8?B?eG1sUjBYSC93MldjTjhEV1BaaFFFOVk4UW5RVDVSbFVrdk5PWFJabGE1U0Ra?=
 =?utf-8?B?Y1B5NlBkdjM0L0VkaVB1RmNxS3JhdTR1UHFObU9FMGRZN3RUUEYwa2F3WDR5?=
 =?utf-8?B?YVpmOW1LVDgxVndBRXVvN1UySmtMY3JBcHI3ME9LZ1huNUVJM0ZsVlZVbnY4?=
 =?utf-8?B?ZEhjc1IyQW1rNGxoTjNFVm05RGxDYklITmFJY1U4M2pLWFFJSVpWVnh3UzB6?=
 =?utf-8?B?eDVnMVFkTFo3T3ZrWC84bFJWcnVqbDh0c3JRNUZSMk50Q3JhWmU2bGc2RVpO?=
 =?utf-8?B?dFFVNUFXYlhGM3RmaUN0MWtxU1Z6N0VIQ2RZZ2FtaktKWFdVdjM0SWlsVTdK?=
 =?utf-8?B?M20zUGJGa0xrZjJQU2l5YmtYcmZMTU9wY3MwcUQxNTM3LzFLK2lVa3JveitL?=
 =?utf-8?B?a3NxaGpIMnRJcXNBT0JoUGlYaS9pNjZqbDduTzNPVmptcHBja2RWM1BsS3hG?=
 =?utf-8?B?NUdHcjA1eWlGemUvNkxUYVpNWGNSSThZQnRtQk5ja2syQ0wzeWw3amFiMGRy?=
 =?utf-8?B?VVlKU0tTMHBSblN4Kzg2czFBbDJXc2FsWWczZi9sZXVzai96aWVHMWJrRnJS?=
 =?utf-8?B?a2twWk45RFB5MmlPMmZ0QktTc3p1dlJORVhqTElnWG5CMmVpbnphMVRCUmFD?=
 =?utf-8?B?UEtOa0lZZ0Q2ckZEelVvczdodDg0ZlMycnBRN3lZMmNoOXBuMFVHTEhYVlhO?=
 =?utf-8?B?OHpXRjQ4V2NjVkFJZmZGS0ZCTUhET2doZ3I3T2cwdGR5MmNpS1dNeGhvWnEw?=
 =?utf-8?B?dTZvUmloOVY4WG52ZnlqYmlMbytiYXYzWlZ4MTZqZHdxdVpFYkVjU1dnQ3Iy?=
 =?utf-8?B?eG42eTZFamMxU2xxNFI3MytndUpKTHVMRzBpUUU0STdiRmlOa01QdmxhNjVN?=
 =?utf-8?B?cndCNlNlcGlocForK2tpUmVQcGtza0Q2TFR3WGsxRVV2dlhVSmtwZFlBaHJB?=
 =?utf-8?B?bFNOdTlWczhLR29Wd2RLOUpQNE1DSUVCOFA0S0ZycU9jbkd1djhJSm5rWng1?=
 =?utf-8?B?ckdJdjZqWlR4ZE84MUQ1RTBqbmtuMGRiT1dOdmFjOGJUYnZUaVc4cnR0cVFN?=
 =?utf-8?B?M0F3RGxSZTQ2MS83cTd4aDhsU3hmSnp2SmtLU0NZdmt2SlRlN0JjRjhqVmtC?=
 =?utf-8?B?ZUhsNWFMOUN4MlVWSUtQSEhrNzZ2OUFaRmdmdkUzVmRBRjFGVWZUenQxSTg1?=
 =?utf-8?B?ZWozN2xFWXFIQnBIUWRJdG9qZWt0K2Y0S1dYaHdQMU1zeXFOS2RWZTM1MDZr?=
 =?utf-8?B?RE5XN2M4MG5zU3haaWVPcDJhV1paTFFrYjdCQWJsbnoyb1Z5VzUyelV3RHdR?=
 =?utf-8?B?MlpsblNreG1PaUxyQW8zQlN4c3VLbjVGY0E3ek8zcG5jTXN2V2xKNzdoOGVz?=
 =?utf-8?B?ODRuZVdyejFMMXNQeUp4R0Rja3BDMmxJMlE4cUphWExvTGNVSEFiUERQVWt4?=
 =?utf-8?B?dEZXenFvNlZpcW5hdWhqc2lGUGtLWVJ4L1hMYWxkNWlSL3Q0Tnk2eHkwT01P?=
 =?utf-8?B?RU95U29Ccks5TWhtNWlkMjY5Uml0c1JtTzk3eDVIRTJWd2NiQ1RVZjNWdk9N?=
 =?utf-8?B?ZDA1YmF5YmRDSEZPVnNVcTZtY3VGang4MWQyaVlEV2c1bkdPcVpDa1dlamcv?=
 =?utf-8?B?aXBFMFFVNzlpaTdjVHdlVXNQNnpIY3VzcEtmbVMzMnFTdmVMVVV0Y3BETUdi?=
 =?utf-8?B?amZkYnJzRUNTZGpKQ0JjRFFLbk5SNVRQQkwzQlF5d3JRUmFKR0w5Rlh5aW1F?=
 =?utf-8?B?cWpkWDRvcDdFZ2R6clYzMzFYcmhRaTZsL1RsOUNXcDNUTFdWUEpjTWNCSXJM?=
 =?utf-8?B?YTVZMW1kKzRVOWN5d3RlMlFBY3RFbjZZMTA0ZUxUWXBjUHdDOG1VRnJ6RGpH?=
 =?utf-8?B?VkZJTVVvL05MUnpjK1A3eXdLa1ByRWV5ZUNpbysrSEU5NkpUWlk2ZjByRkl0?=
 =?utf-8?Q?Z09YWQv3kvKqf5BDHMrRRGT/b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 784b7f9e-bfe9-4b27-5742-08dad75998a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 07:15:04.3261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AffIVR2zg4AHiTNmMDYWG69LxMp3bP5G2ncBws04ciV6iDC6seYV8SF+UpVPoMbSJI3JLc4XZvNbIKzh9cpDhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6638
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/22 03:58, Sean Christopherson wrote:
> On Thu, Dec 01, 2022, Alexey Kardashevskiy wrote:
>> Reading DR[0-3]_ADDR_MASK MSRs takes about 250 cycles which is going to
>> be noticeable when the AMD KVM SEV-ES's DebugSwap feature is enabled and
>> KVM needs to store these before switching to a guest; the DebugSwitch
>> hardware support restores them as type B swap.
>>
>> This stores MSR values from set_dr_addr_mask() in percpu values and
>> returns them via new get_dr_addr_mask(). The gain here is about 10x.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   arch/x86/include/asm/debugreg.h |  1 +
>>   arch/x86/kernel/cpu/amd.c       | 32 ++++++++++++++++++++
>>   2 files changed, 33 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
>> index cfdf307ddc01..c4324d0205b5 100644
>> --- a/arch/x86/include/asm/debugreg.h
>> +++ b/arch/x86/include/asm/debugreg.h
>> @@ -127,6 +127,7 @@ static __always_inline void local_db_restore(unsigned long dr7)
>>   
>>   #ifdef CONFIG_CPU_SUP_AMD
>>   extern void set_dr_addr_mask(unsigned long mask, int dr);
>> +extern unsigned long get_dr_addr_mask(int dr);
>>   #else
>>   static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
> 
> KVM_AMD doesn't depend on CPU_SUP_AMD, i.e. this needs a stub.  Or we need to add
> a dependency.

The new symbol is under CONFIG_CPU_SUP_AMD and so is its only user 
arch/x86/kernel/cpu/amd.c:

arch/x86/kernel/cpu/Makefile:
obj-$(CONFIG_CPU_SUP_AMD)               += amd.o


Is this enough dependency or we need something else? (if enough, I'll 
put it into the next commit log).


>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index c75d75b9f11a..ec7efcef4e14 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -1158,6 +1158,11 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
>>   	return false;
>>   }
>>   
>> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr0_addr_mask);
>> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr1_addr_mask);
>> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr2_addr_mask);
>> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr3_addr_mask);
>> +
>>   void set_dr_addr_mask(unsigned long mask, int dr)
>>   {
>>   	if (!boot_cpu_has(X86_FEATURE_BPEXT))
>> @@ -1166,17 +1171,44 @@ void set_dr_addr_mask(unsigned long mask, int dr)
>>   	switch (dr) {
>>   	case 0:
>>   		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
> 
> LOL, I'd love to hear how MSR_F16H_DR0_ADDR_MASK ended up with a completely
> different MSR index.
>> +		per_cpu(dr0_addr_mask, smp_processor_id()) = mask;
> 
> Use an array to avoid the copy+paste?  And if you're going to add a cache, might
> as well use it to avoid unnecessary writes.

I'll do this, I did not realize DEFINE_PER_CPU_READ_MOSTLY can do 
arrays. Thanks,

> 
>>   		break;
>>   	case 1:

-- 
Alexey
