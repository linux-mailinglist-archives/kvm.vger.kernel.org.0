Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDC16D0B9C
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjC3Qqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 12:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbjC3Qq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 12:46:29 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2061.outbound.protection.outlook.com [40.92.42.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FFCCDF6
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 09:46:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btWsLviS5Rbqp/+MgzoU/gzISxoaog6XdmkcoDswFJj57rXnBDR0sR4KqZMg4x5oHg+/CBW+tPFRk4whpChEP8Lxe/F0xVsOYhCtwmwN09chWQC1Ut0HD6SKou9jGqpz2XtT4DmPksCT5KKSM/nlF3T93MOykr1tlsrMUp3r8Yp3crGrptNafKv58+PCcTX2YEi79X779ZByBV/fQ/dfluDe6U+AyeSg4D7bssTPj6Vqy/3SR2fb32xg37dEvPmQx6+1RPWQN6kwid626rXvgE5fm0jvtHMy34W6LphmssiPkQBwHPwDy792DS1a7oYEwfQBPOZxk0TjA1zi5c3oPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHDJ914M4KmjMUZu8uIXgaAgNRzcLBadt7IzZJzFQAw=;
 b=maEv1sU+xdPdShGc+0R7cYn25LvYt6JXFClWKvz9MXps2ro6DkleSGD0sUYq3vCBbuGXXp9umanlWe7UPneuSwpiQOJ9thwSbik1s1gvm23sBKvouMJorlIBhsUF375QecyG5TbKUd11QtHkwGc1xD98WmIyVKvDy52j/CmKVpf8I9cMvGpN5a8p2GFE0JkdKNp/SGjJmP3P4dEyssSGF40AcIc84sYfWSw0Ws+N9kmK7g2/52nJwABf5Q4F+FR3SdgZh4QGR7Bvax5nz+wyxthMFeSF1vSTdaVbck4aS8IgKzogYeKdtV/sRyS+irLMO7ObvfuYurjjwxXJqfqT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHDJ914M4KmjMUZu8uIXgaAgNRzcLBadt7IzZJzFQAw=;
 b=ZlSHXmWVE3USrb5VRioO7gxF+Dqy/M7kzXhPwZhE+vQ0CHKOS9XmSMjPrGBe5W5iIh8/sEia4XUZ3ZI95hrDWFRgoxLDVOj/fMIUn6iWeHZnHZcJwzBs5rjw/ZQTeS0qL046310Nzn4YFizXPuT2/nzxtIVFN5v1zucHsx0VzWUExLQp/5gZI/Xmg6sqKmG9JKOOlpa0WkDkJthvI9CV0ezyeytgr4zKCZph5CHRQNU1i4jU9p/V0JhZtFghuKusgJFqrRqDH3URPWSN0eLC4hqgoy+PEdKjjvk0SNNaJqhEXMEdrj+bZa3qHUgtG91sGUNC/gcjG5uXUYGO2/0Q1g==
Received: from MN2PR12MB3023.namprd12.prod.outlook.com (2603:10b6:208:c8::26)
 by MN0PR12MB6245.namprd12.prod.outlook.com (2603:10b6:208:3c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.31; Thu, 30 Mar
 2023 16:46:19 +0000
Received: from MN2PR12MB3023.namprd12.prod.outlook.com
 ([fe80::4060:ba42:3bf:fac6]) by MN2PR12MB3023.namprd12.prod.outlook.com
 ([fe80::4060:ba42:3bf:fac6%3]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 16:46:18 +0000
Message-ID: <MN2PR12MB30236B144DD58AD37EDE01FAA08E9@MN2PR12MB3023.namprd12.prod.outlook.com>
Date:   Thu, 30 Mar 2023 18:46:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: ping: Re: Nested virtualization not working with hyperv guest/windows
 11
From:   =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat@outlook.com>
To:     kvm@vger.kernel.org
References: <MN2PR12MB3023F67FF37889AB3E8885F2A0849@MN2PR12MB3023.namprd12.prod.outlook.com>
 <ZB22ZbhyneWevHJo@google.com>
 <a054ea77-e53c-8207-1e25-1081e4ecbb50@outlook.com>
Content-Language: en-US
In-Reply-To: <a054ea77-e53c-8207-1e25-1081e4ecbb50@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [/8C6BDPKGel9LRMekFiPnDpugL8T/nti]
X-ClientProxiedBy: BE1P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::10) To MN2PR12MB3023.namprd12.prod.outlook.com
 (2603:10b6:208:c8::26)
X-Microsoft-Original-Message-ID: <9e2ac05c-74f7-ecf6-b81f-873e24425795@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3023:EE_|MN0PR12MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: bc5e2189-94dd-4ea9-3d29-08db313e48eb
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nacE01vqa1H8vDZAId0guQHde0aInZFJVuRDNhtj3P/HRc0vbHf+vdBWSNg/O9xOusDbjH9W3MlyWt2BkWf+m9ggDUFuVfeAfVj6TPTIlVEEG+4u1h6HsUAUe3Zfd6B7WL6luDw8fGw6TpEc45YZL5kKtY0vUgVJ5dic08inhDomz1MLLxiZPpu/ZwvzT5tYXrcXMVWe5DWkk7F6G6tLnBpf8EHnSo9JE21wUrVRukEnqMjCF6xHOkXxvOf6QT1kellqfr36hXh/jlDQTVkcjhu1I1wFmTzQk8a2MQc+7gauB0DRqjMQ6m6nuZmsro+Y4NlVGrllDGAh2nk2enxJEMC/5NubSDg0L7AS0036ecUcdqoXfxjScM86IQL7xuvxFwkXUUC0PyBbsm9AhuqfH/LIId5HLykxNGK8MBOLozAbY596xVVlwXil8g16rH/IF9CAyeZnDF+gPO+v7cM/9kHkeNVkJMQ/v79reiYbc+NNeEvBiApoC202jTVnq2FRJDhjEeeZqq+SMpfVKGqq2pU6MCfizs+4ZQNqYb2SFsE=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YndwQTR6N3ZhNlhvSk5lRk54cmI4MGRES3dXYjZTOVh5NnFCejY2VmZDUFpw?=
 =?utf-8?B?dDUvVWNUNVpxZlVOb3ZDTzNCQ0dGRjFOSk10emhlWHVPb2tDL3Y3VEkyN0hk?=
 =?utf-8?B?RzFNOWpDckpBT0tuSkY0NU9kR2FycXVBTnFOeTI3TEdac0xldGVranY1b0wr?=
 =?utf-8?B?SS9LQkJxZyt2alU5cDJieVFzdVZ3OHZXV09seThQY0hDY0lOVDc2b3NKOVA4?=
 =?utf-8?B?Vk9MUDk0VTJXUzNwRFIySi9PVkVYeWRudTBVY0hWWkJwZDA5Y2xYWmQybDJY?=
 =?utf-8?B?UVpvUElWWnBraWtzK1E4bkxiazE1WG9CdU93QUYvaElySGY3SjhueEFndHgy?=
 =?utf-8?B?OHhXMDdseW5oN3dETnYyRkdPajVWMHVyYm5FN1ByRW5zV3Z3SkNCMHZNcVBa?=
 =?utf-8?B?TVhxSGN0bDh0aG0rWHJETkpZRnNua3F1VS9MU1pqUmhMc0NvaVFhdUtyNDRU?=
 =?utf-8?B?S3JIQkdvQStHMXVvV01sZ0ZUbzhwTlhtbFFyREpaWGR4bkJlczFzdWxaS2V6?=
 =?utf-8?B?NitJNjlabXY0Q0lYRVBmKzRQVmlVcjlWYXFCdlJtZVFLNkNYZTlUeDJuc2kv?=
 =?utf-8?B?N3NYSE81RmNOVUJMK2xZYmswdU1mZDRmc1hhblFod1hlTzlrbUNXYUI0Sjd4?=
 =?utf-8?B?eStEWWh1ZisrcWVqcXFHV3JHcmxUbGM2WkhPMkpNM2Nyc3ltYXhnT2ZQdjNz?=
 =?utf-8?B?TkYwQ0RUbXZvVGhuOCtWaTJ6cW83TCtiZEFrMlZ4TFFYVng3UzVFOWhRb0oz?=
 =?utf-8?B?SmY0Y3EyRTVzdnhsQU9iOE5pZWlUdm9oZ21BREF1MFp6Y3FkRzFIckZNdWV5?=
 =?utf-8?B?akhvRkJteDNnMFdlODIvSThqdXptbFJValVGZjFEb01JZURyZlNuZGw1L1NL?=
 =?utf-8?B?L0s0R2xqMWRYeUV0dlJZU0xYWjRHV2hxYmoyQWh5a2VRM01ucGg1WEJDY1px?=
 =?utf-8?B?Qnc0V29yUkNPcU4zTUNxTGI1WXA5dWlhSVVuY08xdGNLT3VJcHhydFJ4WTZE?=
 =?utf-8?B?dGFRaEFyem96RUxhV0xuQWZqVlR2aW5kOEUvSUEvbGxlUWVhN0ExWVN5M1Y0?=
 =?utf-8?B?Q3BlOUllTkp4NTVGZkdpQXN5V0R3VGlRdTFIYW5YT1VSS1FJdEMyUndWNXNN?=
 =?utf-8?B?ZzZ6MUtYZjVNdW05aG9uVUZJb2dPY2J1ZTV5Uk94NXpZWVZYUXFab20rS0k3?=
 =?utf-8?B?OTZTZmxTTGZ6VjhLQlZIeXBLMEN2QXRaZUgyYmRNa2Q0ejhwME5iNTZ6MzM4?=
 =?utf-8?B?YUQrRmhQdm9oMUdWZUNUeW9SNXF1bW1WOHNOdnRwVldBRjgyRmgyNzBBcU12?=
 =?utf-8?B?U2VUZ2JpbG1oem1vdEVUNXV3bmt0dUJMckxUcitTK1oxbDU1STJRdFR2MWc3?=
 =?utf-8?B?V2YxYmIxeHBkR1B5N0o0cjgvVzMwRkd0Yjg4bHhGRjFSdm9FSlJkNktNckE0?=
 =?utf-8?B?VlBhQzZTeTZjRmJpQndsd3BpcklxMmJhdUlYb2lEczhFVkRoZ2dMOVpwWm5w?=
 =?utf-8?B?NE1Bd1Z4djJCR0xuN2ZUcGRXcmlyY2QwM3ZWT09VS2dkVnZkQngxZUI3bXBC?=
 =?utf-8?B?SnBhdFhnRFliU2tVTjBVSkxiSndEYmEvaDYxVjBkMnF6L3dzc3pSeVZmTm1T?=
 =?utf-8?B?c0hpZnNyRVlLMWlQa3JXRzdsM3ZSSmc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5e2189-94dd-4ea9-3d29-08db313e48eb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3023.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 16:46:18.8646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6245
X-Spam-Status: No, score=1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


W dniu 24.03.2023 o 15:59, Michał Zegan pisze:
> Hello,
>
> Thanks for the reply.
>
> doesn't qemu actually panic on entry failure? note i don't have 
> crashes nor anything in logs, I've tried to enable ignore_msrs in kvm 
> parameters to see if maybe this will report something, but no luck.
>
> Tracing data are here: https://transfer.sh/1lfnMc/kvmtrace.gz
>
> Also unsure if I didn't lose some data in the process, although if 
> this was actually three reboots, not just instantly going to recovery, 
> it shouldn't matter.
>
> I definitely cannot get anything useful from it.
>
> W dniu 24.03.2023 o 15:40, Sean Christopherson pisze:
>> On Fri, Mar 24, 2023, Michał Zegan wrote:
>>> Hi,
>>>
>>> I've sent this some time ago, but was not subscribed here, so unsure 
>>> if I
>>> didn't get a reply or maybe missed it, so repeating:
>>>
>>> I have a linux host with cpu intel core i7 12700h, kernel currently 
>>> 6.2,
>>> fedora37.
>>>
>>> I have a kvm/qemu/libvirt virtual machine, cpu model set to host, 
>>> machine
>>> type q35, uefi with secureboot enabled, smm on.
>>>
>>> The kvm_intel module has nested=y set in parameters so nested 
>>> virtualization
>>> is enabled on host.
>>>
>>> The virtual machine has windows11 pro guest installed.
>>>
>>> When I install hyperv/virtualization platform/other similar 
>>> functions, after
>>> reboot, the windows does not boot. Namely it reboots three times and 
>>> then
>>> goes to recovery.
>> This is going to be nearly impossible to debug without more 
>> information.  Assuming
>> you can't extract more information from the guest, can you try 
>> enabling KVM
>> tracepoints?  E.g. to see if KVM is injecting an exception or a 
>> nested VM-Entry
>> failure that leads to the reboot.
>>
>> I.e. enable tracing
>>
>>      echo 1 > /sys/kernel/debug/tracing/tracing_on
>>
>> and then to get the full blast from the trace firehose:
>>
>>      echo 1 > /sys/kernel/debug/tracing/events/kvm/enable
>>
>> or to get slightly less noisy log:
>>
>>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_entry/enable
>>      echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exit/enable
>>      echo 1 > 
>> /sys/kernel/debug/tracing/events/kvm/kvm_inj_exception/enable
>>      echo 1 > 
>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_intercepts/enable
>>      echo 1 > 
>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_intr_vmexit/enable
>>      echo 1 > 
>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmenter_failed/enable
>>      echo 1 > 
>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmexit/enable
>>      echo 1 > 
>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmexit_inject/enable
>>      echo 1 > 
>> /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmenter/enable
>>
>> To capture something useful, you may need to (significantly) increase 
>> the size of
>> the buffer,
>>
>>      echo 131072 > /sys/kernel/debug/tracing/buffer_size_kb
>>
>> The log itself can be found at
>>
>>      /sys/kernel/debug/tracing/trace
