Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8424154E9
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 02:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbhIWBAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 21:00:44 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54947 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237852AbhIWBAn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 21:00:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UpGxa-f_1632358750;
Received: from 192.168.3.6(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0UpGxa-f_1632358750)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Sep 2021 08:59:11 +0800
Message-ID: <84cd2713-3cc4-3120-946e-0cf8b8a8187d@linux.alibaba.com>
Date:   Thu, 23 Sep 2021 08:59:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH] KVM: VMX: Check if bus lock vmexit was preempted
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chenyi.qiang@intel.com,
        shannon.zhao@linux.alibaba.com,
        Sean Christopherson <seanjc@google.com>,
        hao.xiang@linux.alibaba.com
References: <1631964600-73707-1-git-send-email-hao.xiang@linux.alibaba.com>
 <87b411c3-da75-e074-91a4-a73891f9f5f8@redhat.com>
 <57597778-836c-7bac-7f1d-bcdae0cd6ac4@intel.com>
 <a0d6bcd8-11e4-4efd-0317-0bec6e59f06a@redhat.com>
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
In-Reply-To: <a0d6bcd8-11e4-4efd-0317-0bec6e59f06a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/9/22 20:40, Paolo Bonzini wrote:
> On 22/09/21 12:32, Xiaoyao Li wrote:
>>>
>>
>> EXIT_REASON.bus_lock_detected may or may not be set when exit reason 
>> == EXIT_REASON_BUS_LOCK. Intel will update ISE or SDM to state it.
>>
>> Maybe we can do below in handle_bus_lock_vmexit handler:
>>
>>      if (!to_vmx(vcpu)->exit_reason.bus_lock_detected)
>>          to_vmx(vcpu)->exit_reason.bus_lock_detected = 1;
>>
>> But is manually changing the hardware reported value for software 
>> purpose a good thing?
>
> No.  That said, Hao's patch is just making the code clearer; there's 
> no behavioral change since the "if" will just redo the same 
> assignments as handle_bus_lock_vmexit.
>
> Paolo
I agree Paolo. EXIT_REASON.bus_lock_detected may or may not be set when 
exit_reason=EXIT_REASON_BUS_LOCK,  It clould depend on hardware 
implementaion. No matter when intel states it clearly, I think it is 
better that we avoid repeated assignment by adding additional check 
condition in vmx_handle_exit.  Of course , it is also ok that 
hand_bus_lock_vmexit do nothing , but the code is not clear, and the 
code logic will be inconsistent with spec description.
