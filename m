Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98A68A33B
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 20:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjBCTsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 14:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjBCTsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 14:48:50 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327A2A42A5;
        Fri,  3 Feb 2023 11:48:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bH7UcQqg8byTnGTo2yCnbD0MogmYvNF81QLNnu/dOnQgcAnJXZtCWg7GHoOkGzmkBsh7a8tyYsy6K442P1bhLpFNU/wPyUGAW8tQuMBcaVweQdonZ5nmv6TZzscdXtudCqravR2D0SxAxVxzr2JQ6o1rW53kO5Ziug6dRjAbfONM/UmMq9EvaWt+Tyta8oSlaKAb8QPf2NbWmzHXwzi696VhHAVmLZmBu5w/G62+BP/pSCfVpegovjJ0uyBRaKTLUe3Z8v2kIjc6o5xyvPqXeTFOo5PzwrFzBl/XYx0Bg+10JCZwmr3IfbcNcy1qtyZEWKEacM4Yf1qYVS00khTsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIqIRXnxzr0Qi0esljTI0yvU97OAMPXl5BHsYPDmH5k=;
 b=OvXyxpNo+igNGC7jBU/lNKIzkm+pRnHSkSdI4UINPwR0QrAcVYggvQtsscm0BBLhCoHnGwF+OSdC9/EVt7BBQrFp4F+ooUYR8993UG6Wb4D8cJcwtYVvfwejqNqCuN3UMBKbOZ+Jl19FvHqVsKlEKjEoQsXpCCrXb1nqmlJGts4FmjEzJixPC3z6LjFlYE4Z0E70M4dOZFJqAkGKuzbT2lDfbiXEBqTuF9PATXMwyMsNNl7p6h65P3RwABFyidVkWYLySEkFtH8IymVpKos4WyV3NGh+tfGyiXUZjWGbh0x/wt/5HHwBq1mzey3PLTO4fJGTs8I/1R3EmKUykOBSdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIqIRXnxzr0Qi0esljTI0yvU97OAMPXl5BHsYPDmH5k=;
 b=r95NiSblia3py4YSmqDXP4Lh6mq4RhfLJPj98Nrzpl/0jqnP31VQGJZtQRLQGtvLQ7pQeH+N28HkqsLlTf80S+lP8dVpLrcTi32nej/dnAo6NddHGMnJSnFmUL/YJQc7DxSEr2QWi4R/AoQ6MMs9PaCAfmcO3qMlMNUy3QxaO2w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 PH8PR12MB7158.namprd12.prod.outlook.com (2603:10b6:510:22a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27; Fri, 3 Feb 2023 19:48:45 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::2ba2:7ffc:1e24:4bba]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::2ba2:7ffc:1e24:4bba%9]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 19:48:44 +0000
Message-ID: <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
Date:   Fri, 3 Feb 2023 13:48:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        tglx@linutronix.de, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>,
        Mario Limonciello <Mario.Limonciello@amd.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <20230202215625.3248306-8-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0004.namprd14.prod.outlook.com
 (2603:10b6:208:23e::9) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|PH8PR12MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: 033fd487-7c41-4e70-ff6a-08db061fa8a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5i+3ysx2JgywUEFbodIxOnJXTGytWOt69ItqHWSKPhe7GOop7/zxW2wTTU9BD8RZG6KACaTdowu5Y8U/gjJ4fg2fV1qFNbuScK1u+uUEeiSmdQhYomvjo4z8rLl63HVFIc1g6ks9rWcQVRk/fMt50Ksk+h5m44eXq8JfIKpO6ABFu8iEBVgfKCAwXdoM5Fz6D8HxXGaF1nZivx7xTERsw0GHwZLpDrJL7IS5qKoDobaII5A2J8ykJXIKW/6Rcf9fsD8h1YiuaOH1xLhDXn3n/ZCoUCmQqXQh3MfRTLKx6L9oxh29HbFihrdNv7u8bzAQ1qD/tBt9CKMc7YXnGzeRYtPtYKPapPHnkepdTxh58OwMenPya3qcQXoeAzMJutZzvbXdjeOitDzzHX8w6gyDmC00UFjvvh60465pTAh6i3LP/eq2Sg0Gul1OLBghkS+PbX4Wgb4vAaLKjaZGD0vPHH2JtdLuKcx/gr1sEvZOJ29mT9PN08qycU7Ue/rKCbljNOGWMuewVEW3alg7JJOyDRdgnQ8cafjAySUMANpXsE6/LzKUjs+IGzS8LbqNUY7sNpRyGlrCiynQJBgxXHHzuGqgrHZfTLZBD9thREC/vToXVJrLNRGMPlOu2AbN3WongFpJ3C590E+BMzca0p0OslvLNH5DEayRNkGq9IHiUYC/zSBMRH5TFkhJTeOfwQE3F+TwCtvwG6r9eNAcrQ7DOQSg44pT3u4mdlNPmrbjLNs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199018)(2616005)(83380400001)(31686004)(38100700002)(8676002)(66946007)(44832011)(8936002)(66556008)(31696002)(66476007)(41300700001)(7416002)(86362001)(5660300002)(2906002)(4326008)(36916002)(478600001)(6506007)(6486002)(54906003)(6666004)(316002)(186003)(53546011)(45080400002)(36756003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1pGT1oveHJldUpDdVpCemFlM2t5V0hiMWltTnR0Kysxcm4rbzVMMnBlU0tj?=
 =?utf-8?B?WnJlWlVySHBPNWd0WjBuY3E1RWkxRVJac0RLZjc4N2RkVDNPWHB6ckp4Q2ps?=
 =?utf-8?B?Y0NxbU55cHdta0pZdVNrL21kYkdYbGE1VzhrYlE4RXFsRHJLbUpHVWtRK2dz?=
 =?utf-8?B?NEZEU25PU3hFUXVic2dVTEJIUS9mQU9nQSt4VnVvR0VnL1F3Q0JmNm05bEV1?=
 =?utf-8?B?clBjNmNrQm9CNEhCMVVqRXNFL0s5ajVnM2FXeXRjN1Z2OXdpb1VlZ2hGeDJV?=
 =?utf-8?B?dDZ5NGkxajJOdU51a3dXRy9vZjd6MzV5SVVYbis5emRMcGNyZFRUdXVwSnNR?=
 =?utf-8?B?aEhhZllBMnRleFpFSHYxM3JPSzZVbGJkRXVndXVoV3I4ZzhmZ2FoTkh1eVVO?=
 =?utf-8?B?Z2xLaUVEVjY4aWtqQWN1cElBM29NM3VNeEJsUTZLYjQzMkVQUEllQVB3TVYw?=
 =?utf-8?B?OGJGaGYrMkxnZVZwY0J5Z0thL2R0alphd29xa0x4WXdrMnBXeHZaQXVvM1lx?=
 =?utf-8?B?SXI0NU9ndlNMWTRxOWNWZHE0YUpUWUdDWXQ2bEhwcTRKbUphTlJZMkFsMlR2?=
 =?utf-8?B?OTgzanRCVXpKVjdObHBQZnoyWWRuSlJldmsyejl2aUNVTkRhdUFwQlVtbFdD?=
 =?utf-8?B?Ymo5c0ZUOTR4NS9UOCtqV3hWRE5NTE9BNEhVZWFEWXFPeVBXQ2FUL2Vpa2dx?=
 =?utf-8?B?eWdxMnpoaDFiR3FJSFRQUTBUVUVNcjdNaU9leG5tT0ZzVG5wR3I5bVUrN0hs?=
 =?utf-8?B?RExMTURLd3JYQURnZGRpWmJtaXJLTUVlVW5FMnpGT1VzRU5acDRoMGl5ZHF4?=
 =?utf-8?B?RE5FUUJuYXpvSlFSRzNyazN6bVM4dXJJazZTVTZPUXRUTFhsaHVYSG5tc1Bs?=
 =?utf-8?B?MzBYalc4MTAwMlB1RVRqb0ptT2piaFpwejBNVnFzNitEUVdrcjd1ZC9ia0ZR?=
 =?utf-8?B?cEpCaGRJeHAwZmFnRDBVZHZZVllYQWEyMDNGMnIxS0hJUnVuS1hYRzM3WTNm?=
 =?utf-8?B?N09xUDE1ZUYyd0xIWjQ4bnV0M2x4eGFnbHczSi91aGVIa3RaVGswNVd5OVhy?=
 =?utf-8?B?dnRGZVFCQVhYL1FsVDJMd3J1dE0rNFNLSTVUN3JiMDV6V1pKdVF3N3VPaGZj?=
 =?utf-8?B?ZzArY0kvc2xOL0UxQjI0dG01TGU0Vnk0emQ1b0ZybGQ4dXVmdm83WFcxR0I4?=
 =?utf-8?B?djAwRm4wbkp2YitQWW44ek5aemZFRkVVL21nT2dSUFhDY2N6Z2ZtZ1kzSG1m?=
 =?utf-8?B?MDlaVm03clNMc3VHdnR2S0xTWG9DZzE5bGNYdE9NcFAwTEtRcGM3T1ZBelYx?=
 =?utf-8?B?OG54Ty8xVUl2OWNMakdsVEdTd0ZHcWx6czJCWVI3R01mYTNtNWpISlFqTmdm?=
 =?utf-8?B?dG5KV1Bna1IwVzhRS0ZuVjFzSTdvdmZjd3ZRN0hnV2kwYlhTUWIyWldueTFS?=
 =?utf-8?B?S1dyT3JRZit5RjlZK1RZSGU4N1oyK1pQQjM2YkFhR0xSRmJ3WGU2L2wzZThT?=
 =?utf-8?B?S0w4UDlRb1FPU3FNSFRjaUdSYmxkbzZKZEVhNXZYWUx2Vitwc1FFZjA1cUQ3?=
 =?utf-8?B?SlI3Z2pSVFVNZHdrcHVLN3RWVGVTeElPVnZNN1l2dE81Y0FXaUVVampDK1Jh?=
 =?utf-8?B?K3hBTE9FdU1oRXlMMUoyYXpWSDcwVlkrMGUxbUdydjJlQnlPbkNJTDE1VHAw?=
 =?utf-8?B?YzE0VlQvNGJDZzl4emxMOTE1bkRJdXpoSWdTMkY3aHpvQ2kxWk9scnFTTjVl?=
 =?utf-8?B?NTVCSVdQN2daanJrNE01K2ZYNTlhMkpGWGtMbGlLZ3h0YUVpYTdYSGZyd05h?=
 =?utf-8?B?YWpEOEE0WnUyRzBadjc0Q3RQM3FFeDR3U09VRnpHSW5FeUdKRmd5TU9Tdkls?=
 =?utf-8?B?R3gwdDdyL3lSamx0aUs3MTFIU0RvdjhTZXJXUzM4bkZadHJEMFVQZjRPRUox?=
 =?utf-8?B?alVhempJVjNQWXhLUmduZ3IvemNvZWFwenVpM0RHWHdoTWJqS0F4dGNNYVVV?=
 =?utf-8?B?T0tWMXZXRU5mMHdmUGptUkJ2Um9GRFBsOWp5WkZsZUZCMkQ2dkhXbmxteWZX?=
 =?utf-8?B?QlBXZVdhWW9wSjBBdEtuRVJCSWxHSFJ5RlZrN3hyOWJxV09FQjZmTlQwV3F6?=
 =?utf-8?B?Tk1rY2Q1bWEySm9kSlltZFRPaUtzeWh0ejdodlBGU25jWFdpRlIyNThuNjQ4?=
 =?utf-8?Q?niz2Bx3YSKOtEKRNu5gvgvPrrPyUF8ogqNDUrALMKJoz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 033fd487-7c41-4e70-ff6a-08db061fa8a0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 19:48:44.7495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBUR2VHzhRb+5BiIf8HCOv5TvEdMMkOP3Edle0OH9nZwMPYbw5kilfE0zctmzT1Zfl4HAEQoyjHpVJ6tsBAWrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7158
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Mario

Hi,

On 2/2/23 3:56 PM, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---

I'd like to nack this, but can't (and not because it doesn't have
commit text):

If I:

  - take dwmw2's parallel-6.2-rc6 branch (commit 459d1c46dbd1)
  - remove the set_cpu_bug(c, X86_BUG_NO_PARALLEL_BRINGUP) line from amd.c

Then:

  - a Ryzen 3000 (Picasso A1/Zen+) notebook I have access to fails to boot.
  - Zen 2,3,4-based servers boot fine
  - a Zen1-based server doesn't boot.

This is what's left on its serial port:

[    3.199633] smp: Bringing up secondary CPUs ...
[    3.200732] x86: Booting SMP configuration:
[    3.204242] .... node  #0, CPUs:          #1
[    3.204301] CPU 1 to 93/x86/cpu:kick in 63 21 -114014307645 0 . 0 0 0 0 . 0 114025055970
[    3.204478] ------------[ cut here ]------------
[    3.204481] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/cpu/common.c:2122 cpu_init+0x2d/0x1f0
[    3.204490] Modules linked in:
[    3.204493] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.2.0-rc6+ #19
[    3.204496] Hardware name: AMD Corporation Speedway/Speedway, BIOS RSW1009C 07/27/2018
[    3.204498] RIP: 0010:cpu_init+0x2d/0x1f0
[    3.204502] Code: e5 41 56 41 55 41 54 53 65 48 8b 1c 25 80 2e 1f 00 65 44 8b 35 20 e4 39 55 48 8b 05 5d f7 51 02 44 89 f2 f0 48 0f ab 10 73 06 <0f> 0b eb 02 f3 90 48 8b 05 3e f7 51 02 48 0f a3 10 73 f1 45 85 f6
[    3.204504] RSP: 0000:ffffffffac803d70 EFLAGS: 00010083
[    3.204506] RAX: ffff8d293eef6e40 RBX: ffff8d1d40010000 RCX: 0000000000000008
[    3.204508] RDX: 0000000000000000 RSI: ffff8d1d1c40b048 RDI: ffffffffac566418
[    3.204509] RBP: ffffffffac803d90 R08: 00000000fffffe14 R09: ffff8d1d1c406078
[    3.204510] R10: ffffffffac803dc0 R11: 0000000000000000 R12: 0000000000000000
[    3.204511] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    3.204512] FS:  0000000000000000(0000) GS:ffff8d1d1c400000(0000) knlGS:0000000000000000
[    3.204514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.204515] CR2: 0000000000000000 CR3: 0000800daec12000 CR4: 00000000003100a0
[    3.204517] Call Trace:
[    3.204519] ---[ end trace 0000000000000000 ]---
[    3.204580] [Firmware Bug]: CPU0: APIC id mismatch. Firmware: 0 APIC: 2
[    3.288686]    #2
[    3.288735] CPU 2 to 93/x86/cpu:kick in 210 42 -114355248756 0 . 0 0 0 0 . 0 114356192013
[    3.288798] ------------[ cut here ]------------
[    3.288804] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/cpu/common.c:2122 cpu_init+0x2d/0x1f0
[    3.288815] Modules linked in:
[    3.288819] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc6+ #19
[    3.288823] Hardware name: AMD Corporation Speedway/Speedway, BIOS RSW1009C 07/27/2018
[    3.288826] RIP: 0010:cpu_init+0x2d/0x1f0
[    3.288831] Code: e5 41 56 41 55 41 54 53 65 48 8b 1c 25 80 2e 1f 00 65 44 8b 35 20 e4 39 55 48 8b 05 5d f7 51 02 44 89 f2 f0 48 0f ab 10 73 06 <0f> 0b eb 02 f3 90 48 8b 05 3e f7 51 02 48 0f a3 10 73 f1 45 85 f6
[    3.288835] RSP: 0000:ffffffffac803d70 EFLAGS: 00010083
[    3.288838] RAX: ffff8d293eef6e40 RBX: ffff8d1d40010000 RCX: 0000000000000008
[    3.288841] RDX: 0000000000000000 RSI: ffff8d1d1c40b048 RDI: ffffffffac566418
[    3.288844] RBP: ffffffffac803d90 R08: 00000000fffffe14 R09: ffff8d1d1c406078
[    3.288845] R10: ffffffffac803dc0 R11: 0000000000000000 R12: 0000000000000000
[    3.288848] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    3.288850] FS:  0000000000000000(0000) GS:ffff8d1d1c400000(0000) knlGS:0000000000000000
[    3.288852] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.288855] CR2: 0000000000000000 CR3: 0000800daec12000 CR4: 00000000003100a0
[    3.288857] Call Trace:
[    3.288859] ---[ end trace 0000000000000000 ]---
[    3.288925] [Firmware Bug]: CPU0: APIC id mismatch. Firmware: 0 APIC: 8
6.36[   [    3. 68 33]3 [ #3[  [ #
                               [    3.368623[    3
  [    3.368623]    #3
[    3.368662] ------------[ cut here ]------------
[    3.368673] CPU 3 to 93/x86/cpu:kick in 504 315 -114684508974 0 . 0 0 0 0 . 0 114685353594
[    3.368705] BUG: scheduling while atomic: swapper/0/1/0x00000003
[    3.368708] 7 locks held by swapper/0/1:
[    3.368710]  #0: ffffffffacbff920 (console_lock){....}-{0:0}, at: vprintk_emit+0x13a/0x2e0
[    3.368721]  #1: ffffffffacbffd48 (console_srcu){....}-{0:0}, at: console_flush_all+0x2d/0x250
[    3.368728]  #2: ffffffffac87f540 (console_owner){....}-{0:0}, at: console_emit_next_record.constprop.22+0x189/0x350
[    3.368735]  #3: ffffffffadaae838 (&port_lock_key){....}-{2:2}, at: serial8250_console_write+0x88/0x3c0
[    3.368745]  #4: ffffffffac86aa50 (cpu_add_remove_lock){....}-{3:3}, at: cpu_up+0x6a/0xd0
[    3.368753]  #5: ffffffffac86a9a0 (cpu_hotplug_lock){....}-{0:0}, at: _cpu_up+0x3d/0x2f0
[    3.368760]  #6: ffffffffac8763b0 (smpboot_threads_lock){....}-{3:3}, at: smpboot_create_threads+0x21/0x80
[    3.368769] Modules linked in:
[    3.368770] Preemption disabled at:
[    3.368771] [<ffffffffaae717a4>] do_cpu_up+0x3e4/0x780
[    3.368777] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc6+ #19
[    3.368781] Hardware name: AMD Corporation Speedway/Speedway, BIOS RSW1009C 07/27/2018
[    3.368782] Call Trace:
[    3.368783]  <TASK>
[    3.368789]  dump_stack_lvl+0x49/0x63
[    3.368795]  ? do_cpu_up+0x3e4/0x780
[    3.368799]  dump_stack+0x10/0x16
[    3.368802]  __schedule_bug+0xad/0xd0
[    3.368808]  __schedule+0x76/0x8a0
[    3.368812]  ? sched_clock+0x9/0x10
[    3.368817]  ? sched_clock_local+0x17/0x90
[    3.368826]  ? sort_range+0x30/0x30
[    3.368830]  schedule+0x88/0xd0
[    3.368833]  schedule_timeout+0x40/0x320
[    3.368840]  ? __this_cpu_preempt_check+0x13/0x20
[    3.368844]  ? lock_release+0x353/0x3c0
[    3.368852]  ? sort_range+0x30/0x30
[    3.368856]  wait_for_completion_killable+0xe0/0x1c0
[    3.368864]  __kthread_create_on_node+0xfe/0x1e0
[    3.368876]  ? wait_for_completion_killable+0x38/0x1c0
[    3.368884]  kthread_create_on_node+0x46/0x70
[    3.368894]  kthread_create_on_cpu+0x2c/0x90
[    3.368899]  __smpboot_create_thread+0x87/0x140
[    3.368905]  smpboot_create_threads+0x3f/0x80
[    3.368909]  ? idle_thread_get+0x40/0x40
[    3.368913]  cpuhp_invoke_callback+0x13c/0x5d0
[    3.368921]  __cpuhp_invoke_callback_range+0x69/0xf0
[    3.368929]  _cpu_up+0x12a/0x2f0
[    3.368937]  cpu_up+0x8f/0xd0
[    3.368942]  bringup_nonboot_cpus+0x7c/0x160
[    3.368950]  smp_init+0x2a/0x83
[    3.368957]  kernel_init_freeable+0x1a1/0x309
[    3.368961]  ? lock_release+0x353/0x3c0
[    3.368972]  ? rest_init+0x140/0x140
[    3.368977]  kernel_init+0x1a/0x130
[    3.368980]  ret_from_fork+0x22/0x30
[    3.368996]  </TASK>
[    3.369419]
[    3.369420] .... node  #1, CPUs:     #4
[    3.369466] ------------[ cut here ]------------
[    3.369469] CPU 4 to 93/x86/cpu:kick in 378 42 -114685407543 0 . 0 0 0 0 . 0 114687022569
[    3.369474] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/cpu/common.c:2122 cpu_init+0x2d/0x1f0
[    3.369487] Modules linked in:
[    3.369491] ------------[ cut here ]------------
[    3.369494] DEBUG_LOCKS_WARN_ON(val > preempt_count())
[    3.369493] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc6+ #19
[    3.369499] Hardware name: AMD Corporation Speedway/Speedway, BIOS RSW1009C 07/27/2018


...which points to the WARN_ON here:

static void wait_for_master_cpu(int cpu)
{
#ifdef CONFIG_SMP
         /*
          * wait for ACK from master CPU before continuing
          * with AP initialization
          */
         WARN_ON(cpumask_test_and_set_cpu(cpu, cpu_initialized_mask));
         while (!cpumask_test_cpu(cpu, cpu_callout_mask))
                 cpu_relax();
#endif
}

Let me know if you'd like me to test any changes.

Thanks,

Kim
