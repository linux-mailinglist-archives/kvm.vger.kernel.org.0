Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F086468EC
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 07:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLHGLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 01:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHGLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 01:11:41 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0224D9AE19;
        Wed,  7 Dec 2022 22:11:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU78ss6swedCMXQ2cAi9G5l+c9DrAlqcIx6pO6Io5D+Eoug5seBpalsdeyGsnXMLj/wYSNOMVoJNR5Ciq5I3HT/8EEpTN2Dr7M4+vnR6d2oknrq7qyBfaM98G9S2CR3ELWuQnYoXQR9eHz1xDGVYB+aQME+rPLhnD468uYfVrj2U+YzOGT4yg4g0sjvC/OQJA1IdwOlJIfoMiG+Gv8hcfxieXtcxziEiWlg5IUzsXclX2A+GX+36Vkanibd9WGuKGrd6ZqkQObE3JePBMTfttPyT81YQzucOWTXSCt8U9jQWsMQqUbu8MoXK3BTIuTUJx1xPkJRlS3cokQUkC7QtEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfLMJ8CU3HFlIZ0wm711U7PNLrV1YhGbZ54qGI0OeF8=;
 b=kCJ2rh7QjtqKDxnUu7zd2Ivop3Lhf1cQEI39ZsysRCSGbGHwTiPspO3IRE6i3R+3f01qzSEtxuznM4H+MMgEq7yHf7yxlCMdUcOUougYAtAquX8ydxF9xmaLFchYGgG9m+Bb3ayBpIsxqrYoLQT/T8NRiUGDoNdbeEHzeW/vfrNOORMZUO8RQCE2AVsqYgYS8EHz4LFAoxoS1KsRjXySWCIx0RWCkE7epzWzfVXzPbBqkUUCujLR11YXWu1lvfPo9GuGhzTOp3OzHWrMCN1/kMuy7NxzaSx6j7S+b70qPdfcrnPnSoEjpznNKNLa71+d9GVQ9K3cpyBveaGnpKSdMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfLMJ8CU3HFlIZ0wm711U7PNLrV1YhGbZ54qGI0OeF8=;
 b=tc3D+KO07zzQBMHHIuvMJ0SKao7wr9cRSzu5UxgzDiDl55t0cf0oMKSkWEUmZbq/mMxNU2VUwE7flkbfjzYqhCJg7SgsuCSvCzbsxvWETkEkPWXoX5KrxB7+BgOLTiylaCTHzBqxGNnW4EwwWPYgcVH6nFZ5dPk3LVY45cL7378=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 DS7PR12MB5765.namprd12.prod.outlook.com (2603:10b6:8:74::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 06:11:38 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4%6]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 06:11:38 +0000
Message-ID: <ce2b2cac-2a18-ef23-7bdf-4040c28ffa24@amd.com>
Date:   Thu, 8 Dec 2022 17:11:26 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu
 variables
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-2-aik@amd.com> <Y5DhvRZX0Aizu1ya@zn.tnic>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y5DhvRZX0Aizu1ya@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0087.ausprd01.prod.outlook.com
 (2603:10c6:10:3::27) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|DS7PR12MB5765:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fe20d7e-2ae2-4ffa-1d56-08dad8e31116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: edQtbb1FqrsRKq7FaAy+2WVVeYyNc3CI82UYgkLcUIS0iE4Tu8rA1DtP1U9qXrwHD2rHnEyp00d+Ha6SUZTIYFTaetZncsn21sjrFsxB0vJCf84JpWSkp1Ee4vWzGq8efKOVM/x5ZczadYh7odiQwD6xCBs1dEgURXMv/aHr0YUQCxOkiQ2BjLu4lgXLECQyQNuFZXk1MjdKMtW+gu7BtYG7nDgO6cEybWfe5BaRg5PJB9thSUc33sBHTkZ8AzLoC7Agh0A4NhZlYkP5clMursfbaT0I6fktKg1rePn8XVwCaD4kXM2vCrCLXHr4ZhaFpv8BWPQqs43m6boaA7UMXJpdvHDcUqOI3hpBqmLxKokDUAnceBKxgLiWljdl/wXK/Vb52TFVXZjbXxrh5p+TiOrEnmMqB7G4tnyyysJXF49wfKhyrjFE1qo0O8p6zNM36W9sFrnF5LcogSyWJ1MubcXRT9SDYuP3mtWWtX6BF2gFfeR6LQymaqaS3m/3NeAXiQCES/JEXf0WC+HaXHxVQjO617SAjPOan+LJsIP7Csd40utniqwCwSO9MqdBkrM6rbB7vCdfAp5yXutUljdaAxmyki0oJqEEo1ENAfRSi/Upy0pUUM74ElJpo8T0pvdNjEtbD9YPDDpbXdyWMhY4FB/7bq3LN0mwGRuXnodJMU/3X/U0Aiw9cB/eMwHub8s996OlMsZyhEEeGlmLICUB0EX3m1pB0oOwfzssCzJ+eq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199015)(36756003)(5660300002)(31696002)(41300700001)(4326008)(2906002)(83380400001)(38100700002)(66476007)(2616005)(6486002)(66556008)(6916009)(316002)(31686004)(54906003)(7416002)(66946007)(478600001)(8676002)(8936002)(6666004)(6512007)(6506007)(186003)(26005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnNDcnZWV1V6OHlKNFhUcW5qTzQwcS9HOEgrNG1qd0FaOEwrN2JXSUo4OWdh?=
 =?utf-8?B?QWNFYXIrQnFUaURMWU9vZStMM0JZTHQ1RHZadmt2bUoxOE9yOUJzaGZJMjZO?=
 =?utf-8?B?M2xtYmx6cGtXVjNkRzlCQVdjemErK0E2cWlJT2ZvQ1RpOE5yM1pQV1dreTlF?=
 =?utf-8?B?ZmVGZk1OaGU5NVdwZlZCeGFkUlVzVVIwdG9QRnN1d1l2Tm9UTzRWeE1DcTBp?=
 =?utf-8?B?Q0YrV0hpaXRXZElBSEhSa1ZYZEZpak9CYnh6RW5lSVJNTWozKzJTMnNTN0hq?=
 =?utf-8?B?NGhGdDJONUl3N0dyWGR1MVNzY2l5cUZ0RW1wZHpZNmlSMHlmMWNSUnJEcGow?=
 =?utf-8?B?UUlIdS9aWFF1MHQvWi9HbnlKbEwwYVNDMkJ5Y0tOZGNkUDlGSGkyR0JFODZ4?=
 =?utf-8?B?UU5mWVpnUFpPQmk5NE1HbFJTS3RrSmgxQkZ1d29PYUxvMFVub0FvK3ZVcERG?=
 =?utf-8?B?VFVZL3lYWFp3QkJkL2dtdndUcTBQU2xiazJpNEJJSFo5SGFkTGJuQmNyOVI4?=
 =?utf-8?B?Tm9WYms2RGcwb3VBUGdaNGVuUUNnS2VzSFBDWXE2d1R2WjFQL3ZRZGFPbGdl?=
 =?utf-8?B?TFNLdWJOcWJ0RGNEKzJWaFlUWXZXUDNud2krY0tMZW5MMlBEeGViMTBGR1Ro?=
 =?utf-8?B?UGRhWmtIdU9LcEVrWkZLMEpHNko3ZlVxUEZDRGhGd3N5RjJDYnhESlVTYkpv?=
 =?utf-8?B?OGpML2lpWHRXSDJiY05JNncxbEdMa1F6K3NpcEJ1VC9XNGRGd01UOHEyTVBn?=
 =?utf-8?B?ei93S1poM29LVG1ZTGt4QzY2SzMwZUxNTEl4SklIOFFDNXMyVGJOd2ZBaExa?=
 =?utf-8?B?RFViVUc3Yk9KZlJKTGxIVjNHRmZEby9TNWE0a1BlbG1qeVNaZ1hybG5QdGk2?=
 =?utf-8?B?SUlsZEd5dVJjeHhxK0t3NjI1OTJCSkdReTBRM05Kb2pVRnFNcUQ0cDErYTBH?=
 =?utf-8?B?WHh3a2pDVGVFaS9icldrNkxBZlhGVGVSK0dWcjhPNDFZbWtKOGN0MmxYeG8r?=
 =?utf-8?B?SGZPZThSMS9RbU16d0o0V3lxbEhOa0VXUDFxaVNHRTJHaXFjSGt1UDBvdUJp?=
 =?utf-8?B?WFAvY1EySkV0YjNBQTY0TzFJN2NRNG04YWpmUWZiSHdyR09WMFdkd3JpaVVs?=
 =?utf-8?B?Zm5YL29KdXZtdkpnZmdoY2l5V1RGZWVoRERxT3U5YUF2N2hxRnZXQjYwUVFT?=
 =?utf-8?B?MS9BZWJ2MG9UNVY1RzZoSkVFRVBtQ05qY0hqSGlBNmIwOXg3aTkxOXRxZFY5?=
 =?utf-8?B?cXhoSVdEWGhPVlV2SENIQThFWm0zSXFCcVMzQ0M3ZkRwK1BBSk1weEhjLzZE?=
 =?utf-8?B?bXQ0Qmc0UEVnb1MyT1VtZ3hvc2J5OVRGdjhEMXhjMVlSS3YyUWh3NVBPWjhE?=
 =?utf-8?B?SXlLeFBwOEpwYjMzcTgvSStNakhGWTFQWXpPb2pmaHF4cVIzNHUvK0g4R2Fv?=
 =?utf-8?B?RC9DZ3IvU0pTeXROYWZHTFhhWEl3a1NnRWh4NHhiMDJIL0FXNCt3dmRzRloy?=
 =?utf-8?B?ck5lOU9LWmtqUjM0eS9BdDNuYVVPUC9LelZ1amd4NjQrWmZPWWNUd3ZETVdo?=
 =?utf-8?B?WXZEa25LemNWSmx4ODdKMTg0Qng5WEptTWl0MzZWZ29VVlpNZ0cwc3FhSGJQ?=
 =?utf-8?B?RE5DRnhLOGpnV2ZXUy9IQUdmRHVFbnlXZHlSVHFaV2oyeW9sQ2hSUE0xcG9i?=
 =?utf-8?B?dnNidUNvRkhaZTYzeHNFNXNoVkNZMlJkQmxKZ1YyS0wxdGVGbUtVTm95YXEy?=
 =?utf-8?B?ZUZaU2tGQ0ZINEhDanI1ek9xRnJ3Zi9sbWVPNzRkalFnYnZ4OGloTWRTcFla?=
 =?utf-8?B?Q0kwQ0QxbEYyeTZBM2RTQ0tHWmNWNmFCUUtXYXdsN05zWWw1SFp0WUdVRlJN?=
 =?utf-8?B?aTJ6dG82dTFLakxoNVp4eUhWZWVleVlsU090bGJONXBMZXA2QmdoVlRxdkF2?=
 =?utf-8?B?TXhJb3l3SEZXbEQ0TVJsakUwem10aXR3WjdXZ0VjaFpQQ1dNekxNY2dkdFZJ?=
 =?utf-8?B?eVNwMXordFAyUUR4Zlg5N1dla0FkS3BiL2RjdkRNakswWTBoWUEyVkVIZDVo?=
 =?utf-8?B?Y0FERWp4ZEtJRWpPeHM5QW03aUxKVGovb3VzNDNtRHVEOVdVUXJINEQvUzUv?=
 =?utf-8?Q?IfKO2wmk7DMshY9ETgLIDoTVD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe20d7e-2ae2-4ffa-1d56-08dad8e31116
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 06:11:38.3434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJtHURjYyQmO/Go4qAosk2iAbPfosMzyut3JaezcUxoYmeFAhOmcU8JsEdj1MfFOsQ2Eng1l1yObwN/NrPDlAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5765
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/12/22 05:55, Borislav Petkov wrote:
> On Thu, Dec 01, 2022 at 01:19:46PM +1100, Alexey Kardashevskiy wrote:
>> Subject: Re: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu variables
> 
> "x86/amd: " is perfectly fine as a prefix.
> 
>> Reading DR[0-3]_ADDR_MASK MSRs takes about 250 cycles which is going to
>> be noticeable when the AMD KVM SEV-ES's DebugSwap feature is enabled and
> 
> which does what? I.e., a sort of lazy DR regs swapping...
> 
>> KVM needs to store these before switching to a guest; the DebugSwitch
>> hardware support restores them as type B swap.
> 
> I know this is all clear to you but you should explain what type B
> register swap is.
> 
>> This stores MSR values from set_dr_addr_mask() in percpu values and
> 
> s/This stores/Store/
> 
>  From Documentation/process/submitting-patches.rst:
> 
>   "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>    instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>    to do frotz", as if you are giving orders to the codebase to change
>    its behaviour."
> 
> Also, do not talk about what your patch does - that should hopefully be
> visible in the diff itself. Rather, talk about *why* you're doing what
> you're doing.
> 
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
>>   #endif
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
> 
> This BPEXT thing is AMD-only, right?
> 
> I guess those should be called amd_drX_addr_mask where X in [0-3].
> 
> Yeah yeah, they are used in AMD-only code - svm* - but still.
> 
>>   void set_dr_addr_mask(unsigned long mask, int dr)
>>   {
>>   	if (!boot_cpu_has(X86_FEATURE_BPEXT))
>> @@ -1166,17 +1171,44 @@ void set_dr_addr_mask(unsigned long mask, int dr)
>>   	switch (dr) {
>>   	case 0:
>>   		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
>> +		per_cpu(dr0_addr_mask, smp_processor_id()) = mask;
>>   		break;
>>   	case 1:
>> +		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
>> +		per_cpu(dr1_addr_mask, smp_processor_id()) = mask;
>> +		break;
>>   	case 2:
>> +		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
>> +		per_cpu(dr2_addr_mask, smp_processor_id()) = mask;
>> +		break;
>>   	case 3:
>>   		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
>> +		per_cpu(dr3_addr_mask, smp_processor_id()) = mask;
>>   		break;
>>   	default:
>>   		break;
>>   	}
>>   }
>>   
>> +unsigned long get_dr_addr_mask(int dr)
> 
> This function name is too generic for an exported function.
> 
> amd_get_dr_addr_mask() I'd say.
> 
>> +	if (!boot_cpu_has(X86_FEATURE_BPEXT))
> 
> check_for_deprecated_apis: WARNING: arch/x86/kernel/cpu/amd.c:1195: Do not use boot_cpu_has() - use cpu_feature_enabled() instead.
> 
> You could fix the above one too, while at it.
> 
>> +		return 0;
>> +
>> +	switch (dr) {
>> +	case 0:
>> +		return per_cpu(dr0_addr_mask, smp_processor_id());
>> +	case 1:
>> +		return per_cpu(dr1_addr_mask, smp_processor_id());
>> +	case 2:
>> +		return per_cpu(dr2_addr_mask, smp_processor_id());
>> +	case 3:
>> +		return per_cpu(dr3_addr_mask, smp_processor_id());
> 
> 	default:	
> 		WARN_ON_ONCE(1);
> 		break;
> 
> Just in case.
> 
> And as a matter of fact, make that short and succinct:
> 
>          switch (dr) {
>          case 0: return per_cpu(dr0_addr_mask, smp_processor_id());
>          case 1: return per_cpu(dr1_addr_mask, smp_processor_id());
>          case 2: return per_cpu(dr2_addr_mask, smp_processor_id());
>          case 3: return per_cpu(dr3_addr_mask, smp_processor_id());
>          default: WARN_ON_ONCE(1); break;
>          }


Not an array, as Sean suggested? Uff...


> 
> Thx.
> 

-- 
Alexey
