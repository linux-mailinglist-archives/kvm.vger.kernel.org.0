Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F1C6C8090
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbjCXO7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjCXO7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:59:44 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2058.outbound.protection.outlook.com [40.92.22.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DE4196BA
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:59:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+6fdDvyAs7tSMQiD0MQRRSuOkywSDuiw1zUK6bxPjeubCJxVZrGRN9+cAVrFFRg7OTyCmu379nd81DR5qFK+vSonULao2jzp4+xYTeof14QYQfc0GJDgVgqVpoEGLByC8zvAnc5Fu1QGQafa0JyHWq6BsA+bIMI27fj7qAlUlPWrtJCg/FVvjCqevTz8b3ogyiBh1BY6MEy25jsf/sjLubyF62wlHAbJDS67sJ8wwatoDtrOxfgVhPRPlHd/M/mj5dlVpbCHvSZLOOdq/mOV+EYF7s9M+CYDSrbDPov10d+89UX67f6PvN2Zid/jsQlGlmjD9uzpXx+XX1qwadmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngjVp2+jy0DAbIOCd6VQ46lAZHPPCBj2FLJJw/zJhYk=;
 b=j1CEZnYAbSAvgAdVb0EcBvcGCRQD8QaO7Jy+DiuW+W2J4RH/tCLN44qFum/NCsumyYjSKpc2xLCd9eWtDXqzn/EmaRYJALCZQCpflfwJLWXPJEezY5UgHqvzh0avVKDGze63K5WKO1XQh/UdgQtYi3Pwah+QDPO3MGhNulJm1gxOcFuotL8lRFEQEtZj8REQVg6Qu8z4PdVzK+mBB/tvrz7MGfT8LTwDudf84/23xRZcaEJE8Y+cudKjdPgHybVp3CD13ScwovsvJyrC0KheQp9bG9jR/zeEf9dXqnYD7bfKmls+Y+Xrtq1xWrKEciw/MjK/sHxCsifHkmZinMdiGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngjVp2+jy0DAbIOCd6VQ46lAZHPPCBj2FLJJw/zJhYk=;
 b=LJ4fynF+jOYw+4D4iepAUkgWfPR4KAg9cFGxDNqvVFfkC5WC/Y8ojQZipA9WFnHcd2hDz9ZJ/tAxmTmyo4VD3zeSZaCDam6dkIn3slwQxY4GQm+fot1SrYIAypfIBJuidko3FGGLKsG5Fmi+zVOtzsQ9dwlOYi2VuJ/MuqEZzo2xq6/EixDSYxuB6ZUUvzVeBDmtzZWZ8uXLpvEkYrkslmwI8kxksWOxi7nHQNG7I/kiIHVSSLRQmkG/lSN9RZMuDXAiiYqOr520u2BCPYEOg10ZS+pOjw8dQlNiCTSq3CXOPN4QWEhgAfsWmNoAn5D1uYbixoceMHoK+p7Gv7LPDw==
Received: from BYAPR12MB3014.namprd12.prod.outlook.com (2603:10b6:a03:d8::11)
 by LV2PR12MB5750.namprd12.prod.outlook.com (2603:10b6:408:17e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 14:59:42 +0000
Received: from BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::9d3:d006:8433:da86]) by BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::9d3:d006:8433:da86%7]) with mapi id 15.20.6178.039; Fri, 24 Mar 2023
 14:59:42 +0000
Message-ID: <BYAPR12MB30142EE0C695F6BB4C6B84DDA0849@BYAPR12MB3014.namprd12.prod.outlook.com>
Date:   Fri, 24 Mar 2023 15:59:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Nested virtualization not working with hyperv guest/windows 11
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <MN2PR12MB3023F67FF37889AB3E8885F2A0849@MN2PR12MB3023.namprd12.prod.outlook.com>
 <ZB22ZbhyneWevHJo@google.com>
From:   =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat@outlook.com>
In-Reply-To: <ZB22ZbhyneWevHJo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [VngG3uQzgw3c+a6vWpPbSdWqhs/uK0SS]
X-ClientProxiedBy: BE1P281CA0238.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8c::11) To BYAPR12MB3014.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::11)
X-Microsoft-Original-Message-ID: <a054ea77-e53c-8207-1e25-1081e4ecbb50@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3014:EE_|LV2PR12MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: d4cffaad-6d87-4859-333c-08db2c786598
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oTujmCcfEm4kzSRY2zeUhTKjq7SpnPghldKmyNs2+A6UoLVE3wAwT8kcoicdxhMBfBXvC5ewRjSJ5J0wYo1M8Po3WJ5jCIhsLTYAZPHG0W7R6wUUBSuQ4ywIpFxkuohdfT6Pu/HLY8e4IocF4gIQEg9vl2VgZv9+uSYdn3JXp3+6SziaqT271E7IvQwsBAme8sQp2QO5Lvl+ggfgllYOn6dv9Fuf8CjwGCjU2lEwbIVNaQrKKek4XwupcgV1MKmS9lPIdzzdVilYd0Dh4ljwfkmrBZrxswL37Fuow5H3HEp5giNBlhNOcBgw4tRRkj6M9+2sVfNyCIn21TNBwGpfTUTzcO3SUuecuaarTohJ7O0awL82edlgHvo5nABOfeEmCe4TDrdn7/wLM/wvBQI2Ef0UaJlvfKP6CfOLP2oO+FzFf1YOgz/+UT56eYYwNR16jlr/EabNwlkSPWuhxAUAnf6NX2oOrp1N10KNZ4Gft/Ud3NQ9uobAECmiKZhKruu5mylv4yaihi0+b6OCZZQYbx13jPgvZGtsUePKafSw1NlDY80OedwBeC7VtC6rDr/jh88Kyeq9vGrPJW+XwNfuEGb1egT7WQ9FgAyZXUb8X4CxScZ9EPbIxVgEPvWd0pqOb3CcscKde5uKp54x1gx8Wg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW5ZRytUdWlXaklpTi9kUWVQblhZTzVIdG1KWU9IWHhuSWNJUWtzanlXYjdR?=
 =?utf-8?B?K0xTZnFOZzlrd3orUm5MeFpJZ1MwYUpIM1NSbElqWnFDSlFEM0FwWmJ3S216?=
 =?utf-8?B?SmhQN1BGaFJEdk5BV0xsYnBYTVIxWmovbEt0c0twaVNsaFUrSFZSb21VcktI?=
 =?utf-8?B?VUxYcVgvdHl5cUZuQmc1elVNd00vYWdSdlhwRVgrUEZQaStEc0NYWklwNzVO?=
 =?utf-8?B?QUpMWnhrWjJaZ3NYYkw1TWw2alJOQTZkbXMwMHJtbjlBVVNnTmtLcVFYUGNq?=
 =?utf-8?B?SmZnUzVldmQ2c2dKWGEreXlsVXN5ZjRJYXZjcTFhVHExNTVHQ1VDdzBQaVVs?=
 =?utf-8?B?WFZjdGZuOC9OVHpxelFiTk1uSE9VM0lDZE5aZzFSaVhNcGtwdXRIVE9NWnNx?=
 =?utf-8?B?NUUyeVQzTlNFYzVzZ21PNEp3RzZzOEI5Y1ZSdTBoQUs0Q0dIZVlFZG5ranor?=
 =?utf-8?B?Snk0V2Q3SnJvTnhBRjNFN3ZCWlBYeXdGRGY5aHJOQTBPVmdqeDhPR1pMMzFx?=
 =?utf-8?B?MzVVZkk1M3VUb2RYcnhLSTV3S2t6MUZ0WHAxWFlUT1VwK25EWjNqbElRMUNR?=
 =?utf-8?B?MU4vZmFwSWNHbEQ5RWNlSzBTdnpsL2ozRHlseUZnVVdoOTNsdEdCSjVURGV3?=
 =?utf-8?B?RU0vNkg4NWpOS28wdEQvYkpMdXluLzJUc1djcStiS2tRem5qUkdKeWg3UWZR?=
 =?utf-8?B?WHZYbHNCV28rZXF4bjZGaE9FdFllRElhUk1sU3I1OGpPT3dSZlJXREdCd01j?=
 =?utf-8?B?RzFSK3hDbkYxMjRyRjNOd0NuRXJ4aVRPaGJpQUJCVUl2Y2d5NTJLc2hTNGZv?=
 =?utf-8?B?bXA1bFFPNjk0b3pmaG14VEZ5ZlV1L2U0dlZOUk1QNlZydHRXUFBxMFJJcVJu?=
 =?utf-8?B?NlEralF3NVIvQWdEampSZlI3cEZuTURJWUhtMlAvKzhTYmFmNTllWlQxZ0px?=
 =?utf-8?B?WEQ5MDlvVGw1eWlrMmx4dUtCUGR0SWJvb0JadDRNYW1CVy91aXNrNXFyWFpZ?=
 =?utf-8?B?U08xQzJUR1NGbkJobGZnYjE3em5OUU1jMVgyOU5oVCtXbTUwM0ZHcG9kRksy?=
 =?utf-8?B?QmVTN25Zak5LSVQ0ajRCTmN3SmRxMFA5M2diN1RlbUJvc2grLzRVaC94YmVx?=
 =?utf-8?B?Z2xaRmtKNlRranNKalUrbE1vSEMwY0JtL0ZCZW81NmNVLzQ4N0xHZEkvN2Y3?=
 =?utf-8?B?ckVsSDhIRW5TYXR5b3J1ZXhuN0dkdW9GSHcwOGlkZHFKK29WRzZPZGNqalFQ?=
 =?utf-8?B?S0JMeXlhUkdvZ1lqRWwwcWwwQmNRV1F0dXJCNlZHbkQ0bTVad1ZPcW8ydm5L?=
 =?utf-8?B?WVhTZ2w5bytsdU5BK2R0MGJTSDZlb3FYSkdaaTlHMHVWQlhrTUdBUklLTW41?=
 =?utf-8?B?MGFTdlJYODZvaGJUUWIyeC84bXpBNmRZeHB3YWF6ajFLckxpZHJML3Z5RWpz?=
 =?utf-8?B?SjVYTjdBSWxrZWxoQndlSjZFNlc1Y1pESjYrNGk2WFovTWltMHA3SjU5bUdR?=
 =?utf-8?B?OWc3aXBRWVR5anVwMjRKRFBrcjRqUVNIRHpKRDdUek5kRGI2MXhZcHFRZXdo?=
 =?utf-8?B?RWZ1WGVMN0xGTnRyWUE3RmVOVlBxNmR2NEhRWlN4blBJVERneXRnWFBHUm1P?=
 =?utf-8?B?MEFQL3kzQ3pRVDdCVjZKZmlMaUVUaGVTRHUwRW9lVDR5SmdlaVlSWjA3TXRX?=
 =?utf-8?B?NnNtYnJzaWtCUTVMYlJ5UnkyQ2lCSHB3RnVkeXQwSURWZVU3VDlHYVVBPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4cffaad-6d87-4859-333c-08db2c786598
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3014.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 14:59:41.9602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5750
X-Spam-Status: No, score=1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

Thanks for the reply.

doesn't qemu actually panic on entry failure? note i don't have crashes 
nor anything in logs, I've tried to enable ignore_msrs in kvm parameters 
to see if maybe this will report something, but no luck.

Tracing data are here: https://transfer.sh/1lfnMc/kvmtrace.gz

Also unsure if I didn't lose some data in the process, although if this 
was actually three reboots, not just instantly going to recovery, it 
shouldn't matter.

I definitely cannot get anything useful from it.

W dniu 24.03.2023 o 15:40, Sean Christopherson pisze:
> On Fri, Mar 24, 2023, Michał Zegan wrote:
>> Hi,
>>
>> I've sent this some time ago, but was not subscribed here, so unsure if I
>> didn't get a reply or maybe missed it, so repeating:
>>
>> I have a linux host with cpu intel core i7 12700h, kernel currently 6.2,
>> fedora37.
>>
>> I have a kvm/qemu/libvirt virtual machine, cpu model set to host, machine
>> type q35, uefi with secureboot enabled, smm on.
>>
>> The kvm_intel module has nested=y set in parameters so nested virtualization
>> is enabled on host.
>>
>> The virtual machine has windows11 pro guest installed.
>>
>> When I install hyperv/virtualization platform/other similar functions, after
>> reboot, the windows does not boot. Namely it reboots three times and then
>> goes to recovery.
> This is going to be nearly impossible to debug without more information.  Assuming
> you can't extract more information from the guest, can you try enabling KVM
> tracepoints?  E.g. to see if KVM is injecting an exception or a nested VM-Entry
> failure that leads to the reboot.
>
> I.e. enable tracing
>
>      echo 1 > /sys/kernel/debug/tracing/tracing_on
>
> and then to get the full blast from the trace firehose:
>
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/enable
>
> or to get slightly less noisy log:
>
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_entry/enable
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exit/enable
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_inj_exception/enable
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_intercepts/enable
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_intr_vmexit/enable
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmenter_failed/enable
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmexit/enable
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmexit_inject/enable
>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmenter/enable
>
> To capture something useful, you may need to (significantly) increase the size of
> the buffer,
>
>      echo 131072 > /sys/kernel/debug/tracing/buffer_size_kb
>
> The log itself can be found at
>
>      /sys/kernel/debug/tracing/trace
