Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E19782612
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbjHUJLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjHUJLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:11:23 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65567C4;
        Mon, 21 Aug 2023 02:11:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VqEqKAv_1692609076;
Received: from 30.221.109.103(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0VqEqKAv_1692609076)
          by smtp.aliyun-inc.com;
          Mon, 21 Aug 2023 17:11:17 +0800
Message-ID: <6d10dcf7-7912-25a2-8d8e-ef7d71a4ce83@linux.alibaba.com>
Date:   Mon, 21 Aug 2023 17:11:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, shannon.zhao@linux.alibaba.com,
        pbonzini@redhat.com, seanjc@google.com,
        linux-kernel@vger.kernel.org
References: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
 <ZOMWM+YmScUG3U5W@chao-email>
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
In-Reply-To: <ZOMWM+YmScUG3U5W@chao-email>
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

For reason that,

The turbo frequency info depends on specific machine type. And the msr 
value of MSR_PLATFORM_INFO may be diferent on diffrent generation machine.

Get following msr bits (needed by turbostat on intel platform) by rdmsr 
MSR_PLATFORM_INFO directly in KVM is more reasonable. And set these msr 
bits as vcpu->arch.msr_platform_info default value.
  -bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
  -bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)

On 2023/8/21 15:52, Chao Gao wrote:
> On Mon, Aug 21, 2023 at 11:26:32AM +0800, Hao Xiang wrote:
>> For intel platform, The BzyMhz field of Turbostat shows zero
>> due to the missing of part msr bits of MSR_PLATFORM_INFO.
>>
>> Acquire necessary msr bits, and expose following msr info to guest,
>> to make sure guest can get correct turbo frequency info.
> 
> Userspace VMM (e.g., QEMU) can configure this MSR for guests. Please refer to
> tools/testing/selftests/kvm/x86_64/platform_info_test.c.
> 
> The question is why KVM needs this patch given KVM already provides interfaces
> for QEMU to configure the MSR.
