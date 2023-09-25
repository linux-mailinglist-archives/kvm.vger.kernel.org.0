Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A361B7AE1A4
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 00:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbjIYWZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 18:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbjIYWZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 18:25:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598D1107;
        Mon, 25 Sep 2023 15:25:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jc4FDgQ/lgTerOHdg5f4zZfvaka13I2u32SiCZvSbU/ZxTNZbsm98ov8OB4qaBnJQfQYF5QEjp57yDWxDkA3URJoEvE6ldnXwOEDCz02+/tkeJxUuW1EOl8rC3Bli6YXRz4hB02iobBmFSUdpnYk7nx41kglGlQeR1wnAAmiMjdiqxE6zvXMJeFDdQl9Bwrtd1qscUzQnbn5xmmYMTJUFd4AhXoD601G8+pq8rTo9iEfyE9vyFf6ttwxFbO1kS1CgYYtw4PAdITcSjKT9Ji6eezKcVYn433pOqznBCrHeKx+MVsZg5aakYMFD60OdWNwIyWzYrSh062lTNER+jOmKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6HgBcnTCXD8TARrarXon6ji+h+GRRruuSa+X163nKY=;
 b=HPfX3CJnpodTl52C0lKCUgI4WUO52JF1nTQn8lnW3wQy/tbkIh6KnVVZFd5rdpaJF7rXFtwCfg4FL8dx7FQZVXexJr+5W8eRL3EC275dUWpDsZjppYVlTec54LpBvg1JE1WK2OHDJaCiij/gIn9o07uX1ZFQB2nCAWOkDmGM2ZHunrF+ItiYjOl5yVxG+1rBnpm/VS6wUF5bc8YWjHzFDlbNHOP0kwDaBI41kDWAXihsmvIYLz097SiUe9bHTFVUclb9HWd+jt4lLP9ZYNupVcrAepTc00/jQYhE+KBI2eQgFuRXfar2zXSjzECDh1zpJV5sZ53tX83miDunQqfvvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6HgBcnTCXD8TARrarXon6ji+h+GRRruuSa+X163nKY=;
 b=ksOwo+1QkcBgh4IrkYo6B+UW+c1DjDj8Udt6Nuv2ScbKZwPKDTjlC+fXc8c2epLZdy8GThS5MQ/n4qIEEgi9kLr9l2wbQkgG1cV3nQwuvyNgikDodAEb7H5YblNq30QEeyrTXflb7LGBcGY52WVS52tI/mdGAii6SMGV8T0I07g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by MN2PR12MB4341.namprd12.prod.outlook.com (2603:10b6:208:262::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Mon, 25 Sep
 2023 22:25:41 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::29d3:8fd9:55f0:aee9]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::29d3:8fd9:55f0:aee9%7]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 22:25:41 +0000
Message-ID: <ac402dd4-8bf3-87a8-7ade-50d62997ce97@amd.com>
Date:   Mon, 25 Sep 2023 17:25:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86: Ignore MSR_AMD64_BU_CFG access
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <0ffde769702c6cdf6b6c18e1dcb28b25309af7f7.1695659717.git.maciej.szmigiero@oracle.com>
 <ZRHRsgjhOmIrxo0W@google.com>
 <8c6a1fc8-2ac5-4767-8b02-9ef56434724e@maciej.szmigiero.name>
 <ZRHckCMwOv3jfSs7@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZRHckCMwOv3jfSs7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0068.namprd05.prod.outlook.com
 (2603:10b6:803:41::45) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:EE_|MN2PR12MB4341:EE_
X-MS-Office365-Filtering-Correlation-Id: c35c71e9-1348-4a4f-d180-08dbbe1659b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c74fbf1QhwT5quncUlimZqlO6nDsAQkMk0C612UUQVPztCqnC+OJsfx8ZVod0JBKlF67b6JgXCnLqKn1XC1kshlxuyWZroXvYBPxNvJ5Bhb1i2Jy4BP670kejE7rdC0YKsypCh0RHrNCJY0YRjYNAOZGCB7Pn3jeHaxgOw2PWghBqNWE9AyzQ4mG/Lhm3GLxp2jCVyJQ3RdF6c/q05ekoIu25PWzBVq+t2Nul78O2zfcGjOD2YR0HTRZ9C3zhBqM2x/WxldoPhV/vhhRg0k7Io5lKmzG27leKden1QC3ghMJBiwPrNrSaUCU40kctBRHQLlt8Ca2VOkQmgo1QkPV1cBnw/4hDLyZZO3yyMHL6jkBbMAnvhE64jIM5F8dYxhtpofVBauoqVvBjvtyeyE4qmCWwDWY6YhlnikjcNH6Kv4UR0JQshrpajlp7mdxhhhrpL1O/HXbh6ycMb6mary1436DYIb7xTQw12DKuqN65XHE2N5dvuWS2oFVvqIEY2w0d9YrJL2tr1obT3pln8GWav+tTc0ftXbQGMcK40+Vupztdju3ecv+SnwjsJZWA17L8BB6lIOWpN+DzSWPZFfw1i43BXjV9O0SQ5TN5D+l2fwIWJfRs2CSS/bPfEh1hl6zYTzZ1qV9U6Agnd/Xv2HYSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(376002)(346002)(366004)(230922051799003)(1800799009)(186009)(451199024)(6512007)(6506007)(53546011)(6486002)(6666004)(31696002)(86362001)(38100700002)(36756003)(2616005)(26005)(2906002)(110136005)(31686004)(8936002)(8676002)(4326008)(41300700001)(66556008)(66946007)(54906003)(316002)(66476007)(5660300002)(478600001)(45080400002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXdjcTVEbmtid3pEVmpUZGJzemMyQUFnRERNdkFrLzhzOExZTEFtSlNxcG8x?=
 =?utf-8?B?Q1czN1lnZk81bVhndVZsQjJ1OXJoQVlhcklNYWNwb2hhL3B4U2V2QjloVTdG?=
 =?utf-8?B?MmZaM0xYSHNEWGdObEZOR2NFV3ROSU9BUzgvUmtTOS9VcjJuT2NBcUVLU0kx?=
 =?utf-8?B?VUdidEVYakMxeGZ1dHpWNlY1bWdUNmRxSUVYV3AzL2dYZVpWa0w5aDcrRkU2?=
 =?utf-8?B?cER2QVJyUStnR0VpYzNjUnRFOUI3QldkWTlUR2lwS3NiZnJ6alNtZGM1L0hX?=
 =?utf-8?B?QjFNNTR1S2xKalcrZ1NrK2RINGd3cG1FdkE3ZW1CMFl1U0pHSWNDUDkwQ1lZ?=
 =?utf-8?B?Z0FSdDNobkdGYWhVQS9XSHNEbG91WGcxTUh3eCtOTzZSaWQ2VldEV2dXL1d0?=
 =?utf-8?B?YjBwcHJudmFqSUVHdWdhaXNKLytNOVR2emt6RVA5d1ZwRHZaRGFmQThsTmtU?=
 =?utf-8?B?bVliTVBNV3B2eVdJS1htQ2EyKzZkL3lXYzQ0RHlqRWp5SkVhZzRObTBxYWxi?=
 =?utf-8?B?UnMyeXhUbFlDZFUreXltRWpyNVhtbVFDVmlLYTlUM3pLcWF5TUR0UlpIZVNp?=
 =?utf-8?B?VWVpMG55KzF1eEVwaFZPUXpoaStLS3VSOWI3d1ZpcENFVFJTRHRFMTU3VU9O?=
 =?utf-8?B?Q1JUSm90dHdJb0NwdUdzRy9pN3JVRnF5TFJ5SHVqUnFIbmU0cTRGanpBRlFt?=
 =?utf-8?B?L2IrVFJlMHdxT3dnejNYd0h2ejFrMU5ORDFrd1lnMmZWNExkSGk5dmZPaVhp?=
 =?utf-8?B?WERrZkptd3lrWThzb2E1RVlxSm9KZGltS09Rbmg4QlBnNmthUmNzQ0JWbGhR?=
 =?utf-8?B?aDdsMktYbk9DRVhCMkF1Qndac2ZPUWZPVFptNHY5RnNtQ0x5QTZ5bXY5OEVC?=
 =?utf-8?B?NDRXaTd3TndSNDhTdjRxbGdsdTlydGNZS3NpWCtvY1M0NXRPSUFtUlV0TVVB?=
 =?utf-8?B?NFppM2JSb1JWVnJtUHhydDVHTzU0Tkt2Y1o3NWxIUnpMOGlqUVZqTDVJcUpp?=
 =?utf-8?B?VHlkdlgzQ2d0Q0JybVNtNUdZVGk4TkU4MHZyTTdFenZvSWxsbHI0dmd4LzJE?=
 =?utf-8?B?NVF3bEtSSDViUFNyU1pxT2dqdkpZZ2RaczUzTXVkQ2srK21KUCtCOFlsYWND?=
 =?utf-8?B?RzNRQnh5UTVFOEdtT3NjVkdCOVhyU1lZUCtUYlE4TFVYcDB2UnQrWE41NFNr?=
 =?utf-8?B?VWJMUHBBeWJ2R0lGZVUwNTduNzFlNVU2ZUdnRlVjbGZRSm5HUFB5eHZjeTc3?=
 =?utf-8?B?TWlJenZNN1Z3V1RyNFRzemF1UVlBV2lJcC9DMFRjaDRNL3JRVDVDRStSTmhJ?=
 =?utf-8?B?QUk4Zzd3U28yekhQcnlrZmlrd3ErNmRNTnhZS0xNTFROcmRKYlRWVkZFRGJD?=
 =?utf-8?B?dHQ4UUk1ajJJdXlPNU9FbC9NSW1CMUZVWnpndWxqTXJKbnRrZUY4cHZhWkps?=
 =?utf-8?B?Q0RpelZsd0ZrMSsxTHAyM1Y0SmtzWjN3czdqbkFBYmVDQTgyYlhpVXRDTU5q?=
 =?utf-8?B?ajFvdm5mcmJWbUd6emJPZVFuZlZhYTE0TXBuUUxrdHpkbk91VDBsZ1J4ZzNu?=
 =?utf-8?B?ZzRsckxPbFZxWUxaQlVDNVQzelJqRjlPWGtYNTRPL0F1K0xFaTBNdzUzQ0h6?=
 =?utf-8?B?NzNMOGhFWXNUdTB6bGtKcXN3M0RMZkRMZmZpaG9DMmN2ZkJBMkZDdlRMUW5k?=
 =?utf-8?B?N3Q5TFN4b0ROanBBSEFQWElXY0o2Y2gyWkNsNVBXTlRjbFV1bUJJNWF2SHNn?=
 =?utf-8?B?eWRUaUtYR1FUYStEUWJRaVlIRTdtQTNjR1pCNG5zUXpzUFVtYmo4YXdPQXZC?=
 =?utf-8?B?aWx4RTRnUGREbC9Gc3hnWUZtaW8xVDkzTHM4eWxlQ3p0VmVCYndyelM5VUNH?=
 =?utf-8?B?MEtIOGNHSitoVmZkMXJRSlNnbEhpMXJtTTRVMWV2NEdKWXN6WC9BYTJyMnBx?=
 =?utf-8?B?bGxwbFlxL2pXTllnOFh0SEx5UU5DQkI3QUk1MHlXbWs1bVJpZTBFWHBGdGdQ?=
 =?utf-8?B?UE12dEZVdXAxYXdjeUZsb1hVYjhBbllQZmdCOHVDVGxPSzJsWEYwdThPb1lp?=
 =?utf-8?B?c04yNDBvdEQ0WmIxREROUThXZXcxbU05SUJabnVpMzZ3T21JMFZ1UXkrM2ZO?=
 =?utf-8?Q?AJ3Yh5UDaYHsowbzSrdMKF/mv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c35c71e9-1348-4a4f-d180-08dbbe1659b7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 22:25:40.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFYFtz4kNwwQxSJhtg14GzMKpMqIlkO7U5FA43C2ZTeBfyCWqMtypUwBMtxXSJnRxrUvve4O9LZ6ENH5bczxTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4341
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/25/23 14:16, Sean Christopherson wrote:
> +Tom
> 
> On Mon, Sep 25, 2023, Maciej S. Szmigiero wrote:
>> On 25.09.2023 20:30, Sean Christopherson wrote:
>>>>
>>>> Hyper-V enabled Windows Server 2022 KVM VM cannot be started on Zen1 Ryzen
>>>> since it crashes at boot with SYSTEM_THREAD_EXCEPTION_NOT_HANDLED +
>>>> STATUS_PRIVILEGED_INSTRUCTION (in other words, because of an unexpected #GP
>>>> in the guest kernel).
>>>>
>>>> This is because Windows tries to set bit 8 in MSR_AMD64_BU_CFG and can't
>>>> handle receiving a #GP when doing so.
>>>
>>> Any idea why?
>>
>> I guess it is trying to set some chicken bit?
>>
>> By the way, I tested Windows Server 2019 now - it has the same problem.
>>
>> So likely Windows 11 and newer version of Windows 10 have it, too.
> 
> ...
> 
>>>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>>>> index 1d111350197f..c80a5cea80c4 100644
>>>> --- a/arch/x86/include/asm/msr-index.h
>>>> +++ b/arch/x86/include/asm/msr-index.h
>>>> @@ -553,6 +553,7 @@
>>>>    #define MSR_AMD64_CPUID_FN_1		0xc0011004
>>>>    #define MSR_AMD64_LS_CFG		0xc0011020
>>>>    #define MSR_AMD64_DC_CFG		0xc0011022
>>>> +#define MSR_AMD64_BU_CFG		0xc0011023
>>>
>>> What document actually defines this MSR?  All of the PPRs I can find for Family 17h
>>> list it as:
>>>
>>>      MSRC001_1023 [Table Walker Configuration] (Core::X86::Msr::TW_CFG)
>>
>> It's partially documented in various AMD BKDGs, however I couldn't find
>> any definition for this particular bit (8) - other than that it is reserved.
> 
> I found it as MSR_AMD64_BU_CFG for Model 16h, but that's Jaguar/Puma, not Zen1.
> My guess is that Windows is trying to write this thing:
> 
>    MSRC001_1023 [Table Walker Configuration] (Core::X86::Msr::TW_CFG)
>    Read-write. Reset: 0000_0000_0000_0000h.
>    _lthree0_core[3,1]; MSRC001_1023
> 
>    Bits   Description
>    63:50  Reserved.
>    49     TwCfgCombineCr0Cd: combine CR0_CD for both threads of a core. Read-write. Reset: 0. Init: BIOS,1.
>           1=The host Cr0_Cd values from the two threads are OR'd together and used by both threads.
>    48:0   Reserved.
> 
> Though that still doesn't explain bit 8...  Perhaps a chicken-bit related to yet
> another speculation bug?
> 
> Boris or Tom, any idea what Windows is doing?  I doubt it changes our options in
> terms of "fixing" this in KVM, but having a somewhat accurate/helpful changelog
> would be nice.

It's definitely not related to a speculation bug, but I'm unsure what was 
told to Microsoft that has them performing that WRMSR. The patch does the 
proper thing, though, as a guest shouldn't be updating that setting.

And TW_CFG is the proper name of that MSR for Zen.

Thanks,
Tom
