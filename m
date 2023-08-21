Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D886278281E
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 13:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjHULoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 07:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjHULoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 07:44:17 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13226C3;
        Mon, 21 Aug 2023 04:44:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VqHrAjZ_1692618249;
Received: from 30.221.109.103(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0VqHrAjZ_1692618249)
          by smtp.aliyun-inc.com;
          Mon, 21 Aug 2023 19:44:10 +0800
Message-ID: <33f0e9bb-da79-6f32-f1c3-816eb37daea6@linux.alibaba.com>
Date:   Mon, 21 Aug 2023 19:44:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, shannon.zhao@linux.alibaba.com,
        pbonzini@redhat.com, seanjc@google.com,
        linux-kernel@vger.kernel.org
References: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
 <ZOMWM+YmScUG3U5W@chao-email>
 <6d10dcf7-7912-25a2-8d8e-ef7d71a4ce83@linux.alibaba.com>
 <ZOM/8IVsRf3esyQ1@chao-email>
Content-Language: en-US
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
In-Reply-To: <ZOM/8IVsRf3esyQ1@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-13.3 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/8/21 18:44, Chao Gao wrote:
> On Mon, Aug 21, 2023 at 05:11:16PM +0800, Hao Xiang wrote:
>> For reason that,
>>
>> The turbo frequency info depends on specific machine type. And the msr value
>> of MSR_PLATFORM_INFO may be diferent on diffrent generation machine.
>>
>> Get following msr bits (needed by turbostat on intel platform) by rdmsr
>> MSR_PLATFORM_INFO directly in KVM is more reasonable. And set these msr bits
>> as vcpu->arch.msr_platform_info default value.
>> -bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
>> -bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)
> 
> I don't get why QEMU cannot do this with the existing interface, e.g.,
> KVM_SET_MSRS.
> 
> will the MSR value be migrated during VM migration?
> 
> looks we are in a dilemma. on one side, if the value is migrated, the value can
> become inconsisntent with hardware value. On the other side, changing the ratio
> bits at runtime isn't the architectural behavior.
> 
> And the MSR is per-socket. In theory, a system can have two sockets with
> different values of the MSR. what if a vCPU is created on a socket and then
> later runs on the other socket?
> 

Set these msr bits (needed by turbostat on intel platform) in KVM by 
default.
Of cource, QEMU can also set MSR value by need. It does not conflict.

>>
>> On 2023/8/21 15:52, Chao Gao wrote:
>>> On Mon, Aug 21, 2023 at 11:26:32AM +0800, Hao Xiang wrote:
>>>> For intel platform, The BzyMhz field of Turbostat shows zero
>>>> due to the missing of part msr bits of MSR_PLATFORM_INFO.
>>>>
>>>> Acquire necessary msr bits, and expose following msr info to guest,
>>>> to make sure guest can get correct turbo frequency info.
>>>
>>> Userspace VMM (e.g., QEMU) can configure this MSR for guests. Please refer to
>>> tools/testing/selftests/kvm/x86_64/platform_info_test.c.
>>>
>>> The question is why KVM needs this patch given KVM already provides interfaces
>>> for QEMU to configure the MSR.
