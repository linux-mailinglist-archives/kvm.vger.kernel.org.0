Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F1666AEA
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 06:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbjALFp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 00:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbjALFp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 00:45:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9629DBCF;
        Wed, 11 Jan 2023 21:45:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciFOaCcaX5/mldmKUUVyIIX2HBEi2w7DQiAArY5pzuqBPain5NXiAPz/1SK+UUpQ7khVkIk0I0EN83a3fhtH4seRKdI9JN3MCHxyhG4U5CmkujjBee7a1atcgGhFraGDcCyal+0AyRSxeTVFezdUWrmod2HcVLtoTeUzLVTOxfG7jTe7Tw/5z3LGCc3sJQJK2c0m3aWnnkrQ88T9PADVtdMEPDZSsUqQ513wU0qVuw6/d42jxmADEybbp0ir/UoCkN0//gSA7FBDvr8mBFCwXJ0zM/wDX3AflMrUegbuCYrBFIDxGJNXwlimjN7zWwoYNLk5NUeSKfcRWlrV0IfY2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86gOaMn3dd7nVkPGPmyivTr0TWXYSifSXrtBaHOsMd0=;
 b=mpyznxUHph2aApx1nQnkSQC/ozCR7gKiqef+N3n4MmGvWVCKsuZmkOHl/TGPS9BYQFBj5Ru5JNFzVv+S9D6C/n3bF1m53OumMRHtvjJe395dHx08gRToI/n+vTsMBw9B/I+Dp4GEGXT/SpTJHXH8NcbSMn7nDRXnCMgz65XKKhFKnvz0WqCaMrOgjnkWfZnWtHkto321U7ooa/Va8pM1BDOq3+7MQhOxscc/xaXeMALZQca2eb+Ss3i/2N5oM7jChHCpnPuGpeW+M5tXOp+4Kta4m6FEeizLi4hEm9WAH1Jw+9CHpyINiV8hiOVSmhHRfPrzDR0FwryKz3vBceVKCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86gOaMn3dd7nVkPGPmyivTr0TWXYSifSXrtBaHOsMd0=;
 b=yNN2r7/+lZM5ZMx4B8ayVjtZs/n3atJlyhwCsKxMpo/j3KKgy5qmgH/Tx3bqkFr92N0KFsBh94crCc1SdJeNwlMFKyEHi24CKpiadeSAM7ytuBKQi9jvwQGQy5qlw7yCuMGbISS0uq22KNbBO6vUJ1DTjq0bqUegIg2kn+rAwaI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 DS0PR12MB7677.namprd12.prod.outlook.com (2603:10b6:8:136::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Thu, 12 Jan 2023 05:45:52 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 05:45:52 +0000
Message-ID: <f18c83ac-dc9a-6173-7ab3-d5e3718a0047@amd.com>
Date:   Thu, 12 Jan 2023 16:45:34 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v2 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221209043804.942352-1-aik@amd.com>
 <20221209043804.942352-3-aik@amd.com> <Y72nyuKT+VJYiEUi@zn.tnic>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y72nyuKT+VJYiEUi@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0030.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::17) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|DS0PR12MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be752c0-dbab-4c25-8701-08daf46043e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v2RvEuB343yXHpXkWU2Pp5TMw4t7pPV8iQk/INVNVsbojc0FC3CHTqTbCs171GKbtbjSHa5TTDje6uHecfxqCsvruT/XeUpKpnEW/VaZk8aPZlglC5T7tkuSHEGqNFPVTLzMqX/NPipO9tDtKhK+Djm2ra0r7/uyW0vAwuprEpfgb+TR9njLpUiLMMpT7n4i4XHmQMzRGM8QkGpB3gP3bqgE9ey5YN3+NC9Z8weCwCIfYD9wgZDwY1MfxV9Gc7vpeigjJSYoKYImO6mg11orACEFo0jkuJtbE4T579Wd0M28RyVuOOmGSnRiRlnKhnsjpKD0mY6hsaudmQDvtaSNvGGZ8fDxoGYun/jszGVwSFaMeURLi/nSPk5GI5o7z+3YR4Qv9Hopj0Pk/k6j6UAOxSOyP8LUmH3HpEl9pxYi/rzhvr90HxF/W24dAC19D8nCajfcHwhy4IpctTVKaXfYZLctX2D5p8RehFieivSpCBTpS+ehABF09+adtLrvZiLD5nB30C/2NwdroneAbgcUZVlU5mmn0s1WxGllZAIb7KOfG9TJHcFzFD+lML8Tbl6RSdilC8sTg1M5rifHcehj0UaBQuQaUGZIKqjD1bE9XtlD5s8DLmj7vr5s3pVhWqzEGJNoZioAOKJjflOgDdzccDgYqpKfuvpsIJGqDQlRWo58oeigRSQXBx04eEOgUaAa75ryLw2AcsKaDRWF/FoKhEfhs6hzsq9eXwx9vPbPars=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199015)(31686004)(54906003)(2906002)(6636002)(110136005)(66946007)(5660300002)(6486002)(7416002)(36756003)(31696002)(8936002)(4326008)(316002)(66556008)(8676002)(66476007)(38100700002)(6506007)(53546011)(83380400001)(41300700001)(2616005)(6512007)(186003)(6666004)(26005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUw0UHExbTNvVHFjUFh0amgrK0xTOVEvMFdrVFMxTU1pbXJNMDVZVllkUkVJ?=
 =?utf-8?B?VjlaYzlrdVVsVVhkRjZSdW5VZHZSb3lMVmo1dThnYlN2ZHhOdy90VUpGeTI4?=
 =?utf-8?B?OE1VSGZDUnpxKzA5UUI5S2xUbFNmRmZHTHRFQzZQNkNSbWhpTHlTTjhsampQ?=
 =?utf-8?B?OTFYUnV6b21YMC9rSjlVRmZYUDNWeHJlNVMwVVZNZVpjRU9aZEsyVDU3aHlO?=
 =?utf-8?B?amZIaUNkZVBxczkvczF2clRiVUcrQmxsL0tSeTVQSXBma1VQLzhRVUR2K2t3?=
 =?utf-8?B?TEF1VjhtMFFDSy9vZ0ZJMStOODVBNnh0Vi8raHJyYyt3SEo1NVd5R1pqeHdU?=
 =?utf-8?B?TENNQWN1b0FTVE1qbjJzcXV6eXJHS016bExNQ01aUEtKVnhlVEFzT2RKVjVY?=
 =?utf-8?B?ZzhUWkpHc3ZQVHpraG0zWlZuMHJ6cDFoZThlVmoyaytEVXhtTnlpWGFOekIx?=
 =?utf-8?B?N2VvMno1cGJwam9CMjVvSGYyeGhZY0xpaXZzSE53YUxGQjdmTDVtMGYrRWt4?=
 =?utf-8?B?M3JFTGQzeFdiV0M1Vm0yR2J1SlAxMEEzeFBkSUl0RWpUY3d2bi9oSDRhMkZo?=
 =?utf-8?B?bTh2WFlFS1NkUWhwRUc5ajk5WEpuMVRCcUFTelVManc1dWZpN0pzQXI5cEgw?=
 =?utf-8?B?SHBCYzlNeVlNNVMrei81c1ZvL2VWb1NlSXkra2VaZUQwbHRPL2czMnZaYStm?=
 =?utf-8?B?N0g1Wm9nZE82NFZzSVZUUEdhRHJHdHhlcTBaSktoZEpaVTgwZTZDY1pNTldJ?=
 =?utf-8?B?LzBHYmwrWEd0WXl1K1IxUDFEcXl6WFE4b0NpOGlwemV4M1IrL3cxODVaZmdC?=
 =?utf-8?B?VzhLUmxUYjhVYWhnRUM4VHVXWUJlZE1uODZwN3N3UGRmUWhYQ2dRTVhRTjV1?=
 =?utf-8?B?RGcyTHJMRk54Ulk1YTlqejRIcW1yZjBGRnVubnUyblpRWCtkbU9YbTR5MnpO?=
 =?utf-8?B?eC9qdU9meFAySGIxUEZ6OUd4dXBmbWc4MFlZdEdFYjhZVkV2WU1jcmNxL0pV?=
 =?utf-8?B?Y3V0Y1RWVzNZei9yVW9QMG5oOTdPcStqY0dtRkNEK1BXZG4zOG13SCswY1ZT?=
 =?utf-8?B?ZnV2N0syNEwzRUJ4bmVmK2U3V1lKSDE5ayt3VkdVdkt5ZklRSDdDcnpUWndI?=
 =?utf-8?B?ai92UmNsblE4MldGV2VJc1FuS2dkc2JBQlZmN1ZoY0dIM28yVUxkbzlqWVdn?=
 =?utf-8?B?UVkxeHJnOTZhTnluVWovcm1ZUUJQREwwa2ptYy9wUHFhOThvcDM5NDBYY3BE?=
 =?utf-8?B?K2hkcHhvNTliWjIwaWVRZ1VZVXZyK09jaFRoOFVzZXFPWnN5SWxvK3ZaWDhZ?=
 =?utf-8?B?TE9HSTF1YzlzMUpDZHB2KzBlWUl3alZiTDdJOHNNeUp2RmwxYXZhd1ZTZkpL?=
 =?utf-8?B?Z3o3TnV3TW1rcllnYVVvQnp5U2Q1SEhObWdVbk0reVRRelh1a1hpMXE5V1ox?=
 =?utf-8?B?K3l0cGZBQ2dxcDNVL3I3QWVWVFM5UHNSazNnUW1oUDNwM3Q5U1NkcUZaSkxJ?=
 =?utf-8?B?Y1pmR1VEc09SUkY1NXVmK2hlNHNDTDEzTmVJR0c5NlRmR0VvT0tsREFnSVlB?=
 =?utf-8?B?c3RuR1ZxT09uUC9lVE94YnNlUXlYUjBhVXFXdEhtN2s3NTNyLzRjYlQwdzdo?=
 =?utf-8?B?RWcrRDVEK2hrNS9tOTJTZ3Nmc01uZUpOclBWaFlvZzd5VUZyRjFLQktpamNX?=
 =?utf-8?B?RG9MYjNwaVFROTg5dW5jc2c1OXF3K0p4VzgwZk9TTXJWQXhQbHVtTTFZUXlJ?=
 =?utf-8?B?UjlxS3E3OUdZUUFsdGZKWXhTek9MQlBkL1pYbGtTKytZRmo3clh5c0VnaVBw?=
 =?utf-8?B?cThYS20wcGZOaWhkendjSU9wNE45K2h2bDBrdTBUN3JJemhjMUdHNW4xWVpm?=
 =?utf-8?B?WUdESm5MbndNOWhBK2FiVnJIYUR1a1JKR0pHc2ZYZWdRRjZBYVl6RDRtT3ha?=
 =?utf-8?B?cDd3UXc1dnFhRy9pZTYzVFIxS09Rc3FrSmJVOFlONTdQTllGL3BBalBDdUN2?=
 =?utf-8?B?Y21KZmtSVzExdERtU1pCMG1KajhxVllVcDlJWnUxRzd5QytjU1UrRU1ySmt4?=
 =?utf-8?B?RTNreWpJUkNqUW1qMkg0cFNaMlV3Y1I0aUtHSnI5VENpME5tYTk2SEJhdk1X?=
 =?utf-8?Q?cMwbUIBPkv58T47DwLPP+1Gxu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be752c0-dbab-4c25-8701-08daf46043e6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 05:45:52.1440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QL4N78p6R5quV73SohidPkTMwnC9PbUqoDz76bD0BE7d6u4aaatnS2slgYOtxqvK9zHvc2TKBNJ4XIqoWXStA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/1/23 05:00, Borislav Petkov wrote:
> On Fri, Dec 09, 2022 at 03:38:03PM +1100, Alexey Kardashevskiy wrote:
>> AMD Milan (Fam 19h) introduces support for the swapping, as type 'B',
> 
> "type B" means nothing to people who don't have an intimate APM knowledge.
> 
> Let's try again, this time with a more accessible formulation:
> 
> "The debug registers are handled a bit differently when doing a world switch of a
> SEV-ES guest: the guest debug registers values are saved and restored as usual
> and as one would expect.

Well, SEV-ES KVM (ES == Encrypted State) does not save/restore them for 
the guest (well, as I would expect) as the guest registers are not 
visible to host to save, they are intercepted and the VM does this GHCB 
dance with VMGEXIT(SVM_EXIT_WRITE_DR7).


> The *host* debug registers are not saved to the host save area so if the
> host is doing any debug activity, that host should take care to stash its debug
> registers values into the host save area before running guests.
> 
> See Table B-3. Swap Types and the AMD APM volume 2."
> 
> And now you can go into detail explaining which regs exactly and so on.
> 
>> of DR[0-3] and DR[0-3]_ADDR_MASK registers. Software enables this by
>> setting SEV_FEATURES[5] (called "DebugSwap") in the VMSA which makes
>> data breakpoints work in SEV-ES VMs.
>>
>> For type 'B' swaps the hardware saves/restores the VM state on
>> VMEXIT/VMRUN in VMSA, and restores the host state on VMEXIT.
> 
> Yeah, close but I'd prefer a more detailed explanation and a reference to the
> APM so that people can follow and read more info if needed.


Well, the only place in APM is that "Table B-3. Swap Types and the AMD 
APM volume 2", and it is pretty brief, do I miss something? Thanks,

> >> Enable DebugSwap in VMSA but only if CPUID Fn80000021_EAX[0]
>> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
>> supported by the SOC as otherwise a malicious guest can cause
>> the infinite #DB loop DoS.
>>
>> Save DR[0-3] / DR[0-3]_ADDR_MASK in the host save area before VMRUN
>> as type 'B' swap does not do this part.
>>
>> Eliminate DR7 and #DB intercepts as:
>> - they are not needed when DebugSwap is supported;
>> - #VC for these intercepts is most likely not supported anyway and
>> kills the VM.
>> Keep DR7 intercepted unless DebugSwap enabled to prevent
>> the infinite #DB loop DoS.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>> Changes:
>> v2:
>> * debug_swap moved from vcpu to module_param
>> * rewrote commit log
>>
>> ---
>>
>> "DR7 access must remain intercepted for an SEV-ES guest" - I could not
>> figure out the exact reasoning why it is there in the first place,
>> IIUC this is to prevent loop of #DBs in the VM.
> 
> Let's ask Mr. Lendacky:
> 
> 8d4846b9b150 ("KVM: SVM: Prevent debugging under SEV-ES")
> 
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index efaaef2b7ae1..800ea2a778cc 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -21,6 +21,7 @@
>>   #include <asm/pkru.h>
>>   #include <asm/trapnr.h>
>>   #include <asm/fpu/xcr.h>
>> +#include <asm/debugreg.h>
>>   
>>   #include "mmu.h"
>>   #include "x86.h"
>> @@ -52,11 +53,21 @@ module_param_named(sev, sev_enabled, bool, 0444);
>>   /* enable/disable SEV-ES support */
>>   static bool sev_es_enabled = true;
>>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>> +
>> +/* enable/disable SEV-ES DebugSwap support */
>> +static bool sev_es_debug_swap_enabled = true;
>> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
>>   #else
>>   #define sev_enabled false
>>   #define sev_es_enabled false
>> +#define sev_es_debug_swap false
>>   #endif /* CONFIG_KVM_AMD_SEV */
>>   
>> +bool sev_es_is_debug_swap_enabled(void)
>> +{
>> +	return sev_es_debug_swap_enabled;
>> +}
>> +
>>   static u8 sev_enc_bit;
>>   static DECLARE_RWSEM(sev_deactivate_lock);
>>   static DEFINE_MUTEX(sev_bitmap_lock);
>> @@ -604,6 +615,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>   	save->xss  = svm->vcpu.arch.ia32_xss;
>>   	save->dr6  = svm->vcpu.arch.dr6;
>>   
>> +	if (sev_es_is_debug_swap_enabled())
>> +		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>> +
>>   	pr_debug("Virtual Machine Save Area (VMSA):\n");
>>   	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
>>   
>> @@ -2249,6 +2263,9 @@ void __init sev_hardware_setup(void)
>>   out:
>>   	sev_enabled = sev_supported;
>>   	sev_es_enabled = sev_es_supported;
>> +	if (sev_es_debug_swap_enabled)
>> +		sev_es_debug_swap_enabled = sev_es_enabled &&
>> +			boot_cpu_has(X86_FEATURE_NO_NESTED_DATA_BP);
> 
> check_for_deprecated_apis: WARNING: arch/x86/kvm/svm/sev.c:2268: Do not use boot_cpu_has() - use cpu_feature_enabled() instead.
> 

-- 
Alexey
