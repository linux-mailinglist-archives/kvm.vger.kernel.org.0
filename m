Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33171677DB0
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 15:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjAWOMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 09:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjAWOME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 09:12:04 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2115.outbound.protection.outlook.com [40.107.21.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F747173C
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 06:12:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5eRwA20N0slZeUlnFATIsVobTEnqDm13HEKWED3g9JRwWBRerVAuXMFnaWYlLZZuGefjOxQTaaW0LqZCiuJSZiBWhiayoR9BwkqylerbmIgxawo2LhMytQTj/QQd7pSynNDBq5qB1tvbY+wh8YqFKYoxSTEmzmKl1UxsyhYRpTNS8nKtUhxjz8WNYSpyVM6m84mUDfOn0zK+NrVrQmW7RZkKRbhy4l418KxV2TcOAkDx/NR8Pz7RcbwWp1Oe4Ko7hqjXSKinvcc2IEBhQuG+jCwG6x3Aq0/GVYST2KELPDT/ryZZF4VQ/7B9WJhy1WtZmmNr3LHi3T9AS99oc9kbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21rtZbrg020IluDk3BJhjqMBgmzaI8hL4/xebdD+Xw4=;
 b=OVfYveQk6qt3VHalsan4zow+j7aHwWSjK2iDYxDY5IR8Vo+BRRbm3Mq/PC3NyEv2BVGVU+BpAlsHrHFR4QHA9zDX9jOr8+yIT0BF7U5DsxDkd2zUhK6+lXMmGOyLNLwbwAKIAVaN5Sau16H2SceSsLJmLeVSROh94s4xhknNySFvatMrl+4h0PV7Tap10UcDS5OwkStScF1bJieX4E5oIyvujTw3CZOYkG7W2YJsVhTiDF8yhswX8e3gRXzKI/Yr0xdiYL5EaCNalKt/WlTWOXokyBARmdMS4aXMyenrUol0exqDMqW5VO3pEoZxwXiwtF1ZdN+Oc4dBs2XiO0YnRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21rtZbrg020IluDk3BJhjqMBgmzaI8hL4/xebdD+Xw4=;
 b=kd4egWKn9ZVlZl9ngQWEscQjcHt+IVx1iybUP4s+b+fhg8bpsQi3RuxCOdmyhLay7nIUpzHYKsnUnKwm0vOkAuyvnerWBMvnY1dx4qhr9mUyCJxiXiEeiv8xtfiffRCqCn7admT/ohG4rC6js5mnG8C42oyDSLuO4v7oY1LnAukiT1QWmX9f0yU7xmO8AlINGdUOD1uSMGxYxMtZJRZOLTcuobTpu8glm9sdsA7rDB0aCUTyTuz6kG4/OgOcnVPTUA8XFEWR2kkEFTSrsGHBAEAGkyosEbQnIdHlZ+ZXZZtt8/L1WKco1C+dR6nUuTCdbsogu72SI99Egg12AW6hOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by DB9PR02MB6538.eurprd02.prod.outlook.com (2603:10a6:10:1fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 14:11:58 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 14:11:58 +0000
Message-ID: <e591f716-cc3b-a997-95a0-dc02c688c8ec@uipath.com>
Date:   Mon, 23 Jan 2023 16:11:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v2] KVM: VMX: Fix crash due to uninitialized current_vmcs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>,
        Alexandru Matei <alexandru.matei@uipath.com>
References: <20230123124641.4138-1-alexandru.matei@uipath.com>
 <87edrlcrk1.fsf@ovpn-194-126.brq.redhat.com>
Content-Language: en-US
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <87edrlcrk1.fsf@ovpn-194-126.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR08CA0231.eurprd08.prod.outlook.com
 (2603:10a6:802:15::40) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|DB9PR02MB6538:EE_
X-MS-Office365-Filtering-Correlation-Id: 80f076ef-f8f9-42d1-5728-08dafd4bca46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 01wBqdx+x1jm1gjBG+rDx7eJf640ccIKPn1EMF8StlLIiWbt+oOiMBXtEAD9z6ZCLo1UQ31xqeUUW44cchhee0gGxyGVjHALXbukLbqQZh5jrgD5hkrh9ivBfGkFKDBm3U1fpvRxN8ab9x9Zfeh90b9gGzX9EQS6MdyZ+0s3UnNnleUGWWL1l02AXbahpgBfvecXLmuUYgDH1+FpGfrw0zbPTC+xH1AwCRTSYsK0Rm4KdjSRGALhzwe22+ADdNFvZENpLUzzLdcouRm3F1hYiuh3RwH95TmbS0/4b4MycP+/DeJ3ivx0S3tNaUZ0inx6fFR6Mme+A7EFSR1EG4YcuLxQlQGErw2D2HXhYZ0t1x3S2U3TCqurh9lXKc8OIt+safqgDeLR76cOWHoQRguNlqKCc/hOBO0Hnp9zXcyZkcl59oisnCj1BPioQNKFItwCqvJQvvrWSgkh9YCd4LSgk5KOTA5iSh/4GLD6hZGVc58ZgJaVYG2alg5pqllKOoGjuf29a97++ywimM41K2+Bn85kqWjcQ0MwM60PeYX92VCY/+7G8i21e3XDgBEpPKVnZK3Nv+mxy6YDd77OH8yuLzSdjcjZp1PhXNFitQRs+L/5rpQW1Zt2QjbyNMv/k2WCsudjZNLOK/iI6Zo1g1P/mDIW3yPcN9zaEEjzdRC/K1WRsnGwijUzYBUB/dbnKgZyth3ycLvp+ukcWtJPma2AtngiOggT8C+xFoxp6qiunlAWSEPkNF/FkCQKkAn6rwbY8LRcQsE5W1bL+ikQvkT00w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199015)(83380400001)(66946007)(66476007)(66556008)(86362001)(8676002)(4326008)(110136005)(54906003)(36756003)(53546011)(6506007)(316002)(107886003)(6666004)(26005)(186003)(6512007)(966005)(6486002)(478600001)(2616005)(31686004)(8936002)(44832011)(5660300002)(31696002)(41300700001)(2906002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGtnWE1pQXNTNlptM3lsVXlUb215VzYwdmN2bWEzRXJNL3UwWUlVeHRnWHJQ?=
 =?utf-8?B?S3djSUVxN2w4anpLaGs1R28vbVZXRTRSTzZic2FxMTdiT1lyTjEzRXdFOE5y?=
 =?utf-8?B?cUpEb3I2dWhKSkh6QnNyMklWSVpsSXlqWnRVVDYzQ284ZVdFbUR1ZGFDNkpQ?=
 =?utf-8?B?eEtKaDMrREtvOCt0VGc2TU5POFYzZXdKT2E4dEFIOHh3M0MvMjFsSmRTbW1h?=
 =?utf-8?B?YWljYTd4YXNjYXRHOTMxRzlQcm9KdlRsUjJzL3EyUmV2OFpzNGtCRTZCSjhy?=
 =?utf-8?B?WFNkanRKZ2JCRjJQNWFaQVRwNWVWVXBTelJXQyt3RTcyVXl3MWZrVXBvNk1i?=
 =?utf-8?B?R2ttdkZrNDRKSEJ1em1PekFlRnkvdGRyY3pndTlaMUxmaEFYL1cwaHRXU1cx?=
 =?utf-8?B?bWd0bnNBdjZZYXluV3ZoZ3JML2ZtRDFyWlJXV0YycHhybnJpMXcxTnByMEta?=
 =?utf-8?B?aG5BVUl6SGNDNXhreWJ0N2JkMjlNTThZQm8xeWN3SkltU0RYc2oveGxMSkIx?=
 =?utf-8?B?QXg3bVJsaFZBUVJTdnZVRXg4eThIZ1lORHQ5RDVHQzBneWpTcHZHZG11cC94?=
 =?utf-8?B?U0dqbytuSG1NbE5rVi9YTDNNalQySUZwYXpEQ3JtVWxnVXozVW9hNzR1OFB5?=
 =?utf-8?B?OGNxdlNXK1MwOEU1alF1cEhjK0ZvVGJaVG4zeFBYN1g5bmorNlJxWmtTeThu?=
 =?utf-8?B?QTVxeWR6eHBueVViNW9rYkpqczkxcE5wRmVjUWZjaG5WT0w1NzRTd2xhbWJD?=
 =?utf-8?B?ckszRUJSM2h1MVNidFp5R3hqRWlBQWdLaDVxOXlmVXkyZWlHKytIM3JnSE9G?=
 =?utf-8?B?d0FKOGNVQm5TWlBZbVhPOUtmcVg0RGlqNTRLSnNnZW82UE9wSDArR0xQYkZ1?=
 =?utf-8?B?QVVRM3FiMStweE0wc2FQWW1uTkJJdW52bmp1OFBqaUxRWVVPR0NuWVp3Wi9U?=
 =?utf-8?B?VEVhWmh4QjJWbEJGemFiMmRBUmIwby9uWVhsOWlkdHRybWNTQ21RSEI1b01t?=
 =?utf-8?B?QWZxOGNRYWNKZ1dMbTduNUlnMFh5dUJpSnpSa2ZMU2xuTW9ZYmxuOUlOWEdx?=
 =?utf-8?B?VkZYMjYycTJ1UDUxeU9VcUIxNElaL0FwdEpMY2xSeGVtQjhLOWE4VU9xWFMv?=
 =?utf-8?B?eEQvSklWalRoWGhTUVhSWDNDMUY1dFBqT1BhZHkzcHY0cjdYdUhxZExnaWVq?=
 =?utf-8?B?Znd6WHpyUlFqYkUyK2FyWVN3MStNNDIrZzEzNEwrNVdKNmxhdDJwWE5HV2RV?=
 =?utf-8?B?QXpmN2xzdzNnbEI0YVZjbzVRcU4wMlVPQWxWbFl5UGJINUQzTTBzekZGclNZ?=
 =?utf-8?B?Q25FSzFkMkI1Q3p5SWFURHUwU0lHdE1hTmIxd2dOaTlOYkk0TXMvWlF5TVN5?=
 =?utf-8?B?REpmZnBYNHhHVDlKbnBZK0JZUjdxK25NQ0xWN0lhQnRTb2R1eTJkcEhraHNl?=
 =?utf-8?B?bWxJaDI0eXZpN3RIUkZrYjVCbjBjU0lXL1ZRL25JZ1dkdXhrckVEZDRFQ0tl?=
 =?utf-8?B?ZTg2NlU3cmR6Y0NMczJ0ZGgxb2Z3QlVzNnAyTmNFWUF2WVdyYXQ3OC9zQ0I5?=
 =?utf-8?B?Z3BmUngvRWlEc3hzUU9NYVpiOEF2TkYwdk1lTXdDV3R0VXlIOUlPbU5WMy9a?=
 =?utf-8?B?N0hkcUtqOXhnaEVGNEJtVWJOcGEyMmNZMFBEdXNXWFNFczVXMTZqNHlKdnlH?=
 =?utf-8?B?REFsaWxTVE9vSUNTbHhkZTZjdkc5d0F4U2xhb29oaTdxWFZYM3UyQVNuNi9x?=
 =?utf-8?B?SWI0dUNuNDJreEo1eUtLb1cwTFdEMmk3L2ZJWld3cVkyd1k0TXNJYkVaUXZN?=
 =?utf-8?B?cHRMRlByZkpJZDFzeUZoMWxwVTBrd0dpRXBnM01NeTF4Y1R5YVMzdUU4ZHB4?=
 =?utf-8?B?Y1JOVzRkSWo5S3FPZnJuQXYrSlBwTHY2RjVwYnY2QWZmQWJVZFZpMldVZ1R3?=
 =?utf-8?B?VFlhMkhZN0E1eGlJV3M5OU1DdkJrUU5hdjNJamY3VEVqRjdzUlE3ME9TVUti?=
 =?utf-8?B?K1M4dUVBblRSTm95WHI3YW12a0RhcERWbzlyRS9aY2svMXRzSGdNd1VRTFBW?=
 =?utf-8?B?SFd3YVVOYksrWmY0YVo1NlNlUjQ5MjlnR2hnaFhWa0k2a1F4dEVHUEs4RVNm?=
 =?utf-8?B?bU00SWN2emFuc0ZxMnVkUXRZRC8rVkd6MUZxeDJIaElKYXBBdnBySHc2Z3BR?=
 =?utf-8?B?YXc9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f076ef-f8f9-42d1-5728-08dafd4bca46
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 14:11:58.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wldncpUEMNKbT1ijN2gIibz6a3553VKnj70H7X7LoXOlbze6euA028A7RmSBu3AL+wESIwLHTo87Wmy3M2qgOlhNIyxEkaGK02G5iTzv8WA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR02MB6538
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/23/2023 3:24 PM, Vitaly Kuznetsov wrote:
> Alexandru Matei <alexandru.matei@uipath.com> writes:
> 
>> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
>> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
>> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
>> that the msr bitmap was changed.
>>
>> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
>> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
>> function checks for current_vmcs if it is null but the check is
>> insufficient because current_vmcs is not initialized. Because of this, the
>> code might incorrectly write to the structure pointed by current_vmcs value
>> left by another task. Preemption is not disabled, the current task can be
>> preempted and moved to another CPU while current_vmcs is accessed multiple
>> times from evmcs_touch_msr_bitmap() which leads to crash.
>>
>> The manipulation of MSR bitmaps by callers happens only for vmcs01 so the
>> solution is to use vmx->vmcs01.vmcs instead of current_vmcs.
>>
>> BUG: kernel NULL pointer dereference, address: 0000000000000338
>> PGD 4e1775067 P4D 0
>> Oops: 0002 [#1] PREEMPT SMP NOPTI
>> ...
>> RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
>> ...
>> Call Trace:
>>  vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
>>  vmx_vcpu_create+0xe6/0x540 [kvm_intel]
>>  ? __vmalloc_node+0x4a/0x70
>>  kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
>>  kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
>>  ? __handle_mm_fault+0x3cb/0x750
>>  kvm_vm_ioctl+0x53f/0x790 [kvm]
>>  ? syscall_exit_work+0x11a/0x150
>>  ? syscall_exit_to_user_mode+0x12/0x30
>>  ? do_syscall_64+0x69/0x90
>>  ? handle_mm_fault+0xc5/0x2a0
>>  __x64_sys_ioctl+0x8a/0xc0
>>  do_syscall_64+0x5c/0x90
>>  ? exc_page_fault+0x62/0x150
>>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>> ---
>> v2:
>>   - pass (e)vmcs01 to evmcs_touch_msr_bitmap
>>   - use loaded_vmcs * instead of vcpu_vmx * to avoid
>>     including vmx.h which generates circular dependency
>>
>> v1: https://lore.kernel.org/kvm/20230118141348.828-1-alexandru.matei@uipath.com/
>>
>>  arch/x86/kvm/vmx/hyperv.h | 16 +++++++++++-----
>>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>>  2 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
>> index 571e7929d14e..132e32e57d2d 100644
>> --- a/arch/x86/kvm/vmx/hyperv.h
>> +++ b/arch/x86/kvm/vmx/hyperv.h
>> @@ -190,13 +190,19 @@ static inline u16 evmcs_read16(unsigned long field)
>>  	return *(u16 *)((char *)current_evmcs + offset);
>>  }
>>  
>> -static inline void evmcs_touch_msr_bitmap(void)
>> +static inline void evmcs_touch_msr_bitmap(struct loaded_vmcs *vmcs01)
> 
> Personally, I would've followed Sean's suggestion and passed "struct
> vcpu_vmx *vmx" as 'loaded_vmcs' here is a bit ambiguos....

I couldn't use vcpu_vmx *, it requires including vmx.h in hyperv.h 
and it generates a circular depedency which leads to compile errors.

> 
>>  {
>> -	if (unlikely(!current_evmcs))
>> +	/*
>> +	 * Enlightened MSR Bitmap feature is enabled only for L1, i.e.
>> +	 * always operates on (e)vmcs01
>> +	 */
>> +	struct hv_enlightened_vmcs* evmcs = (void*)vmcs01->vmcs;
> 
> (Nit: a space between "void" and "*")
> 
> .. or, alternatively, you can directly pass 
> (struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs as e.g. 'current_evmcs'
> and avoid the conversion here.

OK, sounds good, I'll pass hv_enlightened_vmcs * directly.

> 
>> +
>> +	if (WARN_ON_ONCE(!evmcs))
>>  		return;
>>  
>> -	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
>> -		current_evmcs->hv_clean_fields &=
>> +	if (evmcs->hv_enlightenments_control.msr_bitmap)
>> +		evmcs->hv_clean_fields &=
>>  			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
>>  }
>>  
>> @@ -219,7 +225,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
>>  static inline u32 evmcs_read32(unsigned long field) { return 0; }
>>  static inline u16 evmcs_read16(unsigned long field) { return 0; }
>>  static inline void evmcs_load(u64 phys_addr) {}
>> -static inline void evmcs_touch_msr_bitmap(void) {}
>> +static inline void evmcs_touch_msr_bitmap(struct loaded_vmcs *vmcs01) {}
>>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>>  
>>  #define EVMPTR_INVALID (-1ULL)
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index fe5615fd8295..2a3be8e8a1bf 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -3869,7 +3869,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>>  	 * bitmap has changed.
>>  	 */
>>  	if (static_branch_unlikely(&enable_evmcs))
>> -		evmcs_touch_msr_bitmap();
>> +		evmcs_touch_msr_bitmap(&vmx->vmcs01);
>>  
>>  	vmx->nested.force_msr_bitmap_recalc = true;
>>  }
> 
