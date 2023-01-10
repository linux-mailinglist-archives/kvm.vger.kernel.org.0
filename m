Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6C6664BFF
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 20:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbjAJTIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 14:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239743AbjAJTID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 14:08:03 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A7C5A8A3;
        Tue, 10 Jan 2023 11:06:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjZCsQiDM8vZPgXd4//NRscdFRjkiCeSN4rsLo1tJm37xhobe03waDOkh8v3oHMystNtfXEObOEQqS9mEO/wOvKx5ukqh2sPLvxkNi/e11ZsheRF0JI1nHtnhtfIoIg4TkaqtS0XJxWq0dhmtQ5o1BxghUbTcuIdelX8+LtyebzjWPsS3+0HwW+e+zBkWo8w1+lQWO8AEKH8OL4ABMaVRVPg1upkVaNMvkfMUoccpLkXaueX8HHMenRKCUpnSdDJqmX3pHsSDzgQ8WwTfx6QujsIqu/WmZoUJe7ISELnNVBgrk2CG1T6BJrPGrGrMRdt0DxJ4gVfaQFps8RKZG22Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXv9uuh00uY791GCkizPR5dW2JuXiJ6sjpkZy6bTjf0=;
 b=fBc1x+w277lXiD5zgsBc32NQ9UU1Hv6rFlH59f+y+MgjoyoaQsC1JVoMiFqAQsn8Q1z4Q66MRGemNkgrUz+traFQO8qmf6qAcf9tNPKukZ+2AzzTxJ6VtSn5wnEnAvVY18LLEVAghxq43jZTwKRF5DOnNeHtTpgpJeS70nsWyUNYHkoLD1qEfcZZXcvVHzsbil/5y94WS2HDdaLGEbxJhweslLdYi/SYzPeLxnRWoYYc/0iImlnj+a4nJqc7KX4q0iPfEMpW8qW2qZuZXXcoGeyEQ2FbZ4LlDoXzRiHarn1qEpYGWDWj1dSdSCVFsbn+BEhBIG7li9mhSJy7M0E1NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXv9uuh00uY791GCkizPR5dW2JuXiJ6sjpkZy6bTjf0=;
 b=4SefMu3Cwi3e+VV5XfH/4VK9ja2mJP14sP7Cuo3eAYncXW4uoXVX1KRTvP/wHX0xxHMd5ugNtm8Kml84+4uQ4epFCuQLvYZ6Es6qJULt/T062E8svDH1suBHJqkIAzbEpzSaIVgtrKgclAaC6CalN+HctlMinbjtNHDUCMu0dNk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB6665.namprd12.prod.outlook.com (2603:10b6:510:1a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 19:06:42 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%4]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 19:06:42 +0000
Message-ID: <41c493a4-9f3f-159a-f58b-a5bbff2c128d@amd.com>
Date:   Tue, 10 Jan 2023 13:06:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH kernel v2 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Alexey Kardashevskiy <aik@amd.com>
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Y72nyuKT+VJYiEUi@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:610:4c::14) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB6665:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d9c706f-e49c-4a44-e346-08daf33dcf0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vqmwbWRtI5oCRqp0VuQvbxKSEPVwifJJgBrcs6wCNoFCFKHZx2nk2+qmkU7tyUMGIYBE2fYzhk59BzUOY78td9OMDHw1K3R5bKIL6XeI8hZx76VHftW9J+7i6LVKc8P3yO33Nf6bW/+biTfp+VcZxqEFDh4M6xtEEe8J3mymwun0JFCXQxDlqzZVXu5Ilbr6xl7ntmIQbPl0Q39DJ8ecX9yx7O2Xx1yipEUdupg5KPxM+gVZFU2xFn8dnJeqX2A2QXnbut/YfNQY+8ONWeNmQ0LVP7zlPfyGq/4aNW7Qk87wclTOYwOtMpN/NPFMZ3wMY9fWoBN+3rnOZXpWEiW5NorEeNgsrsCO+ZW8aG/hDh5QQfdxe67ERMk8hURhOYfW7rdkftaqoXNnNjA3XlQ3ChGmSqRSBn1UUXU+4taYlWtYisRUXxz4SNo+05KJeAMTYKht2urGwC2eB8OAi1RXsWJ36gk0WkNOtAL97w+CdbkKGx96uH76BEmR0pjtnmgT9G5xV5u//aZzTkvzLKm/cJ0QYRpPS2poAkL6fD0Zo7JZzJ1LsuSJI0PVnI2qRppd1XsB09I7ny/6LPlZxXfObxKBNpOXinEMJWwvUsEEXlhxxyX9cT+yfbWkgKU9Eb/zeJpD/0BTPMIDpqIf0T4xL5W0SYZIEEnK2AQDBvsrA/RqVeq63uMPfxfYorl121v7MlO9DAreTpiCDz19Lx2GXeL0QsoBhM/aV42pzEgb8+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199015)(31686004)(36756003)(8676002)(66946007)(66556008)(4326008)(7416002)(8936002)(5660300002)(2906002)(66476007)(38100700002)(83380400001)(31696002)(86362001)(478600001)(6486002)(316002)(54906003)(6666004)(6636002)(110136005)(41300700001)(53546011)(2616005)(186003)(6506007)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlVFME55cTlzekRrdWJuamxnTDJxVW1PVC9Pc0NhVVZONmVCWHJ0Wlp5Wm5y?=
 =?utf-8?B?TGRucGF0TDZTdkZveVFaNGlNbWtxYlVSaDUzVjd6TlNMRitLY0ZkN3R6Smx1?=
 =?utf-8?B?YXJqZjBvS0dzdHBrakZuQUFUWGRBbFVhYXowbkJDSEtZTEQ5bTQ4VU94aGhC?=
 =?utf-8?B?MllZVDNUclhJQTJhS00vclo1ZS9wVmJkYVNwYjNrZWorZnp1VlY0Vmc2UzIr?=
 =?utf-8?B?S1BqWnNOcWF1Z2xPMmNPNllOZU40UTV6a2UzRDUyMzZMQ2p4MGJ0VW9SdDNV?=
 =?utf-8?B?QnJEcG9aYWZWVzdlNUl1QldLdlgrRCtzQWtSNHJGL0hhb3lCbXZIbEk1NXdi?=
 =?utf-8?B?cCtjQlBTalRITTBzQld6TXJHejRxSllVZmZTdmxUOXhWR3FlM2FPR0NDU1Vn?=
 =?utf-8?B?U1E5SG52TGdzN1ZLK0gvZkN0YU5SR0xFbDhpVHY0aU1yM3dndjNaWTFYbWY1?=
 =?utf-8?B?a0VxNm05bmE3UDlBUkM5QWZNdStNUFI1eEVWMzNCbUJ3a3pxVnZvbElBWm56?=
 =?utf-8?B?MnZIMGFiUyt3dkt4eENIalBYYkd1cndtZTg3TVc0YzJDUXBVZHRpY29rc0pl?=
 =?utf-8?B?U0txampUeVFoM2ROV2txdDVTcFBNZEptTTE2RzI5a3JEbGh6Z3VwS3lSWlox?=
 =?utf-8?B?ZnBHK3laR2pLSUlaRFVFN0tIVmt3QVh2SmQwVDA3d0hKMTF1NjhvYXZPMkRt?=
 =?utf-8?B?TytxRUluVEFKcWpLRWJpWURXNklPQ2hxREZ6N0cxMFlkT3Z2eEdna0d5V2Fk?=
 =?utf-8?B?ZWNYTjh4eXkvVHEyVWNrcDhEaXpsNWFmZ042eDJDTTRuM1hpb2xJWXJ6QUIv?=
 =?utf-8?B?N0VMdzJ5QW9wZmg1cWFwSXExc1l3dkdRd2dtYm9iTEpLK3c2YmJZalRnOFJn?=
 =?utf-8?B?MStDRjROVkI4OGw1NG5FRXhQY05jcHo1NEsrVkVYRHdCYXFKVlNUZEFuY2Nq?=
 =?utf-8?B?a0lhTEFWWGk3Rmw3UUY4R2YvK09ac0JwOEpiOGtyemU1SkRTcHQ3dGtIbHlS?=
 =?utf-8?B?dEQ3SmsxREE2UzllZWVxWkU0ZHc0Q3NQaXZwRmhyTXl0ZUZ4RkZuU01PcnRo?=
 =?utf-8?B?QUp2NHFDNmVDb0RXUFFQRkczVjhDb3FNZXh0TURmakZvL3ZhbW5iaU9sNHJ2?=
 =?utf-8?B?Sm12a2Fsc0hySXJIa0toazVxT3lQZXUyQUIxT2dXWXhXWmE0UWpUc21TN05J?=
 =?utf-8?B?Q2psWkd4MUIwL0ZPSTc0MlZwZXVFSGhuM3huclo4ekMxQVR4QTBFbENoMTFH?=
 =?utf-8?B?d29NZlhGUXRNcERMRmVyWG1yZEdPRHpsTUVJa0pudHQ1MUhYTFFYNlNmOERK?=
 =?utf-8?B?Nk9XUzRJMUFPR0o3Z04wang2aE03Nk1JOVhJYUxhL0Q1cExUaWRjd3dVaTJX?=
 =?utf-8?B?MEZEbVAvbFdmaTUvUkIrRUxWaVl4ZVBRQndWckNwUlcwVlF6Ujc3UDQzSHA4?=
 =?utf-8?B?YmRpZmhHblNJdEE0ZjZSU1dKa0thNXEyNHZCVVZScVRFQlR1WHh0MHBEL3NK?=
 =?utf-8?B?S1VXSmE3SWc3bTdwNEY2OW9UdXhKbnUydHdBTERRWExaYkVoZXJKMDAyZUJj?=
 =?utf-8?B?dUNKV2F0TlhIZ1ZBK0dRUHlxTFpWcTBaMkd0a0tFVVltc1dFQUV2dEpSTmlw?=
 =?utf-8?B?cnZQdUdha0crTUY2eURmdEZ2L3kvNVdYSklJUmhCYlFDNXlITjZjWThMSFF0?=
 =?utf-8?B?YzMvdnExNG9wMmZocWF6MXpRMUgyanFybUc3bTlCMzZMTzBsaW5pWDhZZHBI?=
 =?utf-8?B?eFl1WThsOGZvUk9NMmhFcXA4akM5Tm01WTZlT3NjME5VZGd0QnNlOEl2SW1v?=
 =?utf-8?B?d0xJZnlwZ2xvTS9xNmFTMW1LUVBmd2Zad0NhYXdXNXJ4bnV3TDZYUm55M0tZ?=
 =?utf-8?B?NmtMczlUTUI5Q3ViRGN3enNJbVN0UTlIVWg1aUl5clhvSzFoN0NXMjR2ejYw?=
 =?utf-8?B?RUpucDdiU3RodlJIQ3czaDdlY1lkaWdZVldPdithM1NHNHdYL01aeGx1c0pT?=
 =?utf-8?B?T1RrbVZwU2NOWW5PQU1oV1lhZE0rUzViTjl4Q2tDT1ZsN3hzREdNSjhKdTZQ?=
 =?utf-8?B?N0kxYkNLcVRONEdqUGsvNDVPSEltZFY4RW1wL1NNeE1KYllZWmVoQkszbTlU?=
 =?utf-8?Q?b7qMoprfy19yUyOYfBmn7NU5n?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d9c706f-e49c-4a44-e346-08daf33dcf0c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 19:06:42.7534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rxF1VjkMiXXljRU+gAvWOaf3u4nhL8hjmg89xAWaoNyx2mOIMYK82TrEIYFH6CAdzvcijDmEvZK8sKyvMgF4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6665
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 12:00, Borislav Petkov wrote:
> On Fri, Dec 09, 2022 at 03:38:03PM +1100, Alexey Kardashevskiy wrote:
>>

>> "DR7 access must remain intercepted for an SEV-ES guest" - I could not
>> figure out the exact reasoning why it is there in the first place,
>> IIUC this is to prevent loop of #DBs in the VM.
> 
> Let's ask Mr. Lendacky:
> 
> 8d4846b9b150 ("KVM: SVM: Prevent debugging under SEV-ES")

The DR7 requirements were to prevent a malicious SEV-ES guest from setting 
up data breakpoints on the #VC IDT entry/stack and causing an infinite loop.

Thanks,
Tom

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
