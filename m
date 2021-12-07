Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D01446C839
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 00:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242573AbhLGXeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 18:34:08 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55363 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238125AbhLGXeI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 18:34:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0Uzp41ZO_1638919832;
Received: from 192.168.2.97(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Uzp41ZO_1638919832)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Dec 2021 07:30:33 +0800
Message-ID: <e350fd1c-f8e4-5e4a-cc0a-baa735277083@linux.alibaba.com>
Date:   Wed, 8 Dec 2021 07:30:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 3/4] KVM: X86: Handle implicit supervisor access with SMAP
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211207095039.53166-1-jiangshanlai@gmail.com>
 <20211207095039.53166-4-jiangshanlai@gmail.com> <Ya/XoYTsEvkPqRuh@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <Ya/XoYTsEvkPqRuh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/8 05:52, Sean Christopherson wrote:

> 
>> +	 *
>> +	 * This computes explicit_access && (rflags & X86_EFLAGS_AC), leaving
> 
> Too many &&, the logic below is a bitwise &, not a logical &&.

The intended logic is "explicit_access &&" ("logic and") and the code ensures
explicit_access has the bit X86_EFLAGS_AC and morphs it into "&" ("binary and")
below to achieve branchless.

Original comments is "(cpl < 3) &&", and it is morphed into "(cpl - 3) &" in
code to achieve branchless.

The comments is bad in this patch, it should have stated that the logic operations
on the conditions are changed to use "binary and" to achieve branchless.

> 
>>   	 * the result in X86_EFLAGS_AC. We then insert it in place of
>>   	 * the PFERR_RSVD_MASK bit; this bit will always be zero in pfec,
>>   	 * but it will be one in index if SMAP checks are being overridden.
>>   	 * It is important to keep this branchless.
> 
> Heh, so important that it incurs multiple branches and possible VMREADs in
> vmx_get_cpl() and vmx_get_rflags().  And before static_call, multiple retpolines
> to boot.  Probably a net win now as only the first permission_fault() check for
> a given VM-Exit be penalized, but the comment is amusing nonetheless.
> 
>>   	 */
>> -	unsigned long not_smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
>> +	u32 not_smap = (rflags & X86_EFLAGS_AC) & vcpu->arch.explicit_access;
> 
> I really, really dislike shoving this into vcpu->arch.  I'd much prefer to make
> this a property of the access, even if that means adding another param or doing
> something gross with @access (@pfec here).

En, it taste bad to add a variable in vcpu->arch for a scope-like condition.
I will do as you suggested.

> 
>>   	int index = (pfec >> 1) +
>>   		    (not_smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
>>   	bool fault = (mmu->permissions[index] >> pte_access) & 1;
