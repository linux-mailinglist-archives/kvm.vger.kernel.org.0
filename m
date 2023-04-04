Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F566D679B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbjDDPj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbjDDPjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:39:14 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02olkn2071.outbound.protection.outlook.com [40.92.43.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3047A5590
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDYRdzuepiBhJRoIkA/b6Gp6/gL+sA148k6qYaeQw/MlnsRtTQGKySGo8wgc7iPgFxhaqlMTTWmfLKXtue3bauscBqDn4hf2o/63lKU9jIOBwJOqgVG+yICYmLKPIRXsKWDHjEnCNvUXhnQ35HB8xC3OXlDCxyoMBUB2Ieyq7KPPEGdE8CyPzg4k6OZMRV06YeKMeuVhqPOONhIv+Q9RGQ6IBZRYUgwvR8r9Q1brYnXOXN/e3vKOST/4yeaU7jjBerQ2EIi+FBilhiRxo2tZSMpjlWaOv2Ufk/WtaUNsatDb1eLMd1pSFfacDMYmNTBqqbKNUOQ9VrezF35uAruK+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qu4/4CcE0GJ6VOHmC6WmRJW3FbT5D2plEU0+gbiz/sQ=;
 b=nj6Tr4Fv/wfbNWdNWpls2S+SK8BKF+1uUSH6mWj5RBAfr94RxOuHmwjRS9nWVTXp3vJYTMRiP547OleE7CEkAIa0j0o+WwXCsVTnq6WboQcdms1og3YBi09wwbDlPU/uFpIlqif4eb2XoR+WIjmYiw4HPJgZzDEUSJhrV0xZw/p4go1kqB2+rhMUapUjQExqJxqfcM/GsxnXZfdYYwY7nhO3MaYRTQF5n0KRLKH+KfzE4PIb0fUtePV7ScqQjZrF2HdpDKNialgE97XRYf6SD3EmoJQy9f6d/HRex57/gBG/KYzlTuAuLQYsc/UImp7oka0QnsM7uaaQxQ/eh1qegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qu4/4CcE0GJ6VOHmC6WmRJW3FbT5D2plEU0+gbiz/sQ=;
 b=Rp7+1F4UKbtTfN6aYkFXX5A2nHwMyvEnKKWkgEmH44nYPX1jZV67Ep9x6U2BtCYg5hiFZzM9WK99cvyT9vCqltT8GUyoF/Q1hgfIPHlmFHJRsiOL2WonKJYspQIjTj+dX5F0nLvtJTvdmEOdxc09r65wMPt5HxXWvjwpDvIndW/xhwX9E/IWBfjn7pUzwd0WZ69ZFpA1rNB4D0wDn/24aeI9tww3qpiY8KFDBz/mN24ppLdlfrPGUFoBfvOEDV8GNTvUDs0xBMNITlNmgh5rd4n6mh+UXzQu1XSLyC9eyaxmbFvqsQt3kqqNyoM1iheiJrpA9GgIz8GqY1yPfrybmw==
Received: from BYAPR12MB3014.namprd12.prod.outlook.com (2603:10b6:a03:d8::11)
 by PH7PR12MB5733.namprd12.prod.outlook.com (2603:10b6:510:1e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 15:38:41 +0000
Received: from BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::5442:1d2e:772b:c994]) by BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::5442:1d2e:772b:c994%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:38:41 +0000
Message-ID: <BYAPR12MB301427E268ABAFA3365E2494A0939@BYAPR12MB3014.namprd12.prod.outlook.com>
Date:   Tue, 4 Apr 2023 17:38:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: ping: Re: Nested virtualization not working with hyperv guest/windows
 11
From:   =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat@outlook.com>
To:     kvm@vger.kernel.org
References: <MN2PR12MB3023F67FF37889AB3E8885F2A0849@MN2PR12MB3023.namprd12.prod.outlook.com>
 <ZB22ZbhyneWevHJo@google.com>
 <a054ea77-e53c-8207-1e25-1081e4ecbb50@outlook.com>
 <9e2ac05c-74f7-ecf6-b81f-873e24425795@outlook.com>
Content-Language: en-US
In-Reply-To: <9e2ac05c-74f7-ecf6-b81f-873e24425795@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [vdWYyTIh+fk44Rty1A7Kk/id2rJ4wauQ]
X-ClientProxiedBy: BE1P281CA0268.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:86::13) To BYAPR12MB3014.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::11)
X-Microsoft-Original-Message-ID: <4cee07a8-a5c4-de0e-1bf8-7794a0b5041a@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3014:EE_|PH7PR12MB5733:EE_
X-MS-Office365-Filtering-Correlation-Id: 00457c07-cf45-412d-230e-08db3522aac3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X7h8+80PRLcfLt5XqOQjmpjlDeeAcEbMEEvWCjL8MR6Vw6Ky58HfkrOo329pyKV33VtuU3XhPw7duh1746a0NaQWZeI+eTVuPPXpPiT8Dg8MaeCoGyVZf4ew6WF7M62ubUGkddnhDTimdGJiuNcV4wIL7fYSY4w+uiEVtxE4cCeKpHaWp5WaQdkG0ZKP9AY0fkAa1pJc9DXuFGoveS4a8nLCGFLnSw4wYZI986vwCqofD5xnQF20eyR2zdB8hg8dQP4Br3A6Vv8ojVtqIj6sSysSOik+vg8hm//7/p2aOFSBve19nApUa1Jtm6bm+QLR0/B1q9CMTRCIMrd8Xi6tpGTnb1BfTxH0DzdqJ+g7K8EaLXMe00jC2khKJtxJkpRoL6Jz0Dakovh5i5oqtneMglEtl6AMMrgn2LiD4cHjtKbvtlrPgF5t8JBwqm3zondGMnCGfucBT9CU7U10gXm/UUMiy6UDHWxbHFOhFnKHYOEUfw55P57oiWAaiTcwpI9tnH0h5gOptNlU/QfnhvFSv4OM7JHJy8wTEPXbhNI3YE7ykDImxWaWhTRFXDesQ8AFOW2mXeADItakPnO4culBIWMC2peIt8DsjlUo6KnyfFBhgzT2iYaT1789WK0goGBnxt4K6dB8G70yJUS+VxxKrJklV+zpo95PU0oovvUjWU08J/0NK7Ctf7N0Jq1wJL4231QXJCPbt7LNq0YNlypVtB6qQpNUmRwJZa3lpnpEOTo7B4TnkpoCtJJjR3yxS10n
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFVHUjNXRTFkTUpaZVRMWTJzVDRHWDNGV3Juc2Z3YTJmeUpIQTlvRnNxUFM2?=
 =?utf-8?B?TmpiSTdKNGRqYU56WEhuN3pQSDhJeDYzTkRwYWF2N3BEeURjMVgrOWQ4Vllt?=
 =?utf-8?B?K3ZGMU12eWxaTWl0WHYvUlNzS1JzU3R2K1lhY0pRbTl1SEdkK25ZL3Myclo3?=
 =?utf-8?B?Mk11R3l6SkE1QXR0YjhvT0tBRUVqc3RxNTh3WWRKVXpYOWRpdXI1M0Y5STBm?=
 =?utf-8?B?UGdKcHdzK0Mwa0pQaytaOWdrSG1HMy96S2M5RUtpNWVqV2xWV3ZGTHl0Tndj?=
 =?utf-8?B?U0tvWGkrT0xQeUlRNWoyQVZ6WmxtcVRkbHlJNlp0a2MwbVMwVkxjU0V3VkpD?=
 =?utf-8?B?NmNtRDZpZ244RFYvRjFHa2pMODdIV3FDdmtPYXhIVEZVcDZvTXhVOW9CTlhj?=
 =?utf-8?B?bEpvdmxxdE1tM0RPSkVocldyZXlHSWdSemZKOUNjaGhETWhVWkdTRS9BNWtv?=
 =?utf-8?B?TjM5dGVwcXlnQWMwT0ZBYm9JMkVudm52aW1SaU9LbGk5MjZxYlowelBRR2Y0?=
 =?utf-8?B?bHdUaFFCWUpBZ2FvdHNVMzgwQmVjeCtsWWpGZGFpWkd0YUg1TnFIMUhPVEI1?=
 =?utf-8?B?cG4xa3NxMEZRL20wTWdtRzVtU2ZLY3Awckthc25vZnVGVVZzeFYzRGFIT2tW?=
 =?utf-8?B?dVY5OVpneUNTSFZzbjg5OVd1ZUFOSkNDNjlUbWN5Q1ZXazU1eXFWcHphWHRn?=
 =?utf-8?B?bnBpaEZNRTFUSWFuYWlxelF0N0ptc0JtTHhNczNBeVFPUi9CMVBubVRzcm0v?=
 =?utf-8?B?OUduZFJKN1Q2OWxERFBudXV5NzJmOFhmcDZTSUUxK2hRT1NOdjE1WlZpbkJ1?=
 =?utf-8?B?UmpLSjU5VzdaZTlpQnVzTW9iazZyaUtRNHdDZTlLM3dOZDMzSks5djFKS1VI?=
 =?utf-8?B?c29WcW9BQnlWbFA2K2c3Z2xtWEhoSitEK3pwalRoZE5uRHRDeiswWlQxcUpx?=
 =?utf-8?B?aFhFOVlXQk5GTXI2Qi9PVGE2Z0tQMkNOdGVxNmk0R1R3eHFmMjRtZFl4Y1hH?=
 =?utf-8?B?TG9pLy91cHQzQkp5TDFBeWkwQlEwUW1xOU5iRG5Hd0x6YXhuRHluMWdtdi96?=
 =?utf-8?B?T20wVVlGZUpDUnZ2Z0J1ZHFSL3Btb3JkTm9TbE5YNG1rS1BVVWZ4ZVBHb0hy?=
 =?utf-8?B?T2orYkVUN3EyeXQvcFhsaUVKdHYvem1JK3RKTE5ZSFNEY0c5dnJiU0N3b3ZU?=
 =?utf-8?B?cjMwaXhJcnhCS1MySGxkZ2lRbDVKbnZ5cGJmdHNQSmF5WjlBWlgwb2hYblBI?=
 =?utf-8?B?UXdJZVlrTElQbDNuNlpBdDgxUHRNdlVwcVZ3Y3ZRNTFoSWpscXdzZ1c3N1I1?=
 =?utf-8?B?L0hndmZQcCthVEVQVnMrT1o0Zlg2dE8zMG5aZ2ZweUx1Ulgxdy96WHRqYkpY?=
 =?utf-8?B?K0VSZm9aYnUvcTFESEdLUGR1WVBsMkwxeHNSOFNsc3l5L1VlK2YzVHc2NVBD?=
 =?utf-8?B?T3owTmViNUN0UWJXN1Y0MS9HbnU1Z2R4RGJjdmxPOW5BSzd0UDM2ZWxjS0xi?=
 =?utf-8?B?SG53L1NPTmFaNU1uQ1VYM2c0dDd2VU1uTGZ4VXJhTWI3NHRDdG1ab0xVQ1FJ?=
 =?utf-8?B?anlUV0dyeVlNUUFSMit3MDhZNFVQU0RrcXdIZmxNU1pCaXB2VlRRbkVjcjJC?=
 =?utf-8?B?a08zZEwyajk5OThoQ1pBdnpDeitDVEE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00457c07-cf45-412d-230e-08db3522aac3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3014.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 15:38:41.8076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5733
X-Spam-Status: No, score=1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


W dniu 30.03.2023 o 18:46, Michał Zegan pisze:
>
> W dniu 24.03.2023 o 15:59, Michał Zegan pisze:
>> Hello,
>>
>> Thanks for the reply.
>>
>> doesn't qemu actually panic on entry failure? note i don't have 
>> crashes nor anything in logs, I've tried to enable ignore_msrs in kvm 
>> parameters to see if maybe this will report something, but no luck.
>>
>> Tracing data are here: https://transfer.sh/1lfnMc/kvmtrace.gz
>>
>> Also unsure if I didn't lose some data in the process, although if 
>> this was actually three reboots, not just instantly going to 
>> recovery, it shouldn't matter.
>>
>> I definitely cannot get anything useful from it.
>>
>> W dniu 24.03.2023 o 15:40, Sean Christopherson pisze:
>>> On Fri, Mar 24, 2023, Michał Zegan wrote:
>>>> Hi,
>>>>
>>>> I've sent this some time ago, but was not subscribed here, so 
>>>> unsure if I
>>>> didn't get a reply or maybe missed it, so repeating:
>>>>
>>>> I have a linux host with cpu intel core i7 12700h, kernel currently 
>>>> 6.2,
>>>> fedora37.
>>>>
>>>> I have a kvm/qemu/libvirt virtual machine, cpu model set to host, 
>>>> machine
>>>> type q35, uefi with secureboot enabled, smm on.
>>>>
>>>> The kvm_intel module has nested=y set in parameters so nested 
>>>> virtualization
>>>> is enabled on host.
>>>>
>>>> The virtual machine has windows11 pro guest installed.
>>>>
>>>> When I install hyperv/virtualization platform/other similar 
>>>> functions, after
>>>> reboot, the windows does not boot. Namely it reboots three times 
>>>> and then
>>>> goes to recovery.
>>> This is going to be nearly impossible to debug without more 
>>> information.  Assuming
>>> you can't extract more information from the guest, can you try 
>>> enabling KVM
>>> tracepoints?  E.g. to see if KVM is injecting an exception or a 
>>> nested VM-Entry
>>> failure that leads to the reboot.
>>>
>>> I.e. enable tracing
>>>
>>>      echo 1 > /sys/kernel/debug/tracing/tracing_on
>>>
>>> and then to get the full blast from the trace firehose:
>>>
>>>      echo 1 > /sys/kernel/debug/tracing/events/kvm/enable
>>>
>>> or to get slightly less noisy log:
>>>
>>>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_entry/enable
>>>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exit/enable
>>>      echo 1 > 
>>> /sys/kernel/debug/tracing/events/kvm/kvm_inj_exception/enable
>>>      echo 1 > 
>>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_intercepts/enable
>>>      echo 1 > 
>>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_intr_vmexit/enable
>>>      echo 1 > 
>>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmenter_failed/enable
>>>      echo 1 > 
>>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmexit/enable
>>>      echo 1 > 
>>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmexit_inject/enable
>>>      echo 1 > 
>>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmenter/enable
>>>
>>> To capture something useful, you may need to (significantly) 
>>> increase the size of
>>> the buffer,
>>>
>>>      echo 131072 > /sys/kernel/debug/tracing/buffer_size_kb
>>>
>>> The log itself can be found at
>>>
>>>      /sys/kernel/debug/tracing/trace
