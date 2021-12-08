Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4E446D027
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 10:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhLHJhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 04:37:47 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:57728 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229449AbhLHJhq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 04:37:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UztY64i_1638956051;
Received: from 30.22.113.150(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UztY64i_1638956051)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Dec 2021 17:34:12 +0800
Message-ID: <bc3951cc-2c57-6ce4-6218-2f9bb4ad8196@linux.alibaba.com>
Date:   Wed, 8 Dec 2021 17:34:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 16/15] KVM: X86: Update mmu->pdptrs only when it is
 changed
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144527.88852-1-jiangshanlai@gmail.com> <Ya/xsx1pcB0Pq/Pm@google.com>
 <60743c95-f9aa-a7c6-1709-39c70e224321@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <60743c95-f9aa-a7c6-1709-39c70e224321@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/8 17:09, Paolo Bonzini wrote:
> On 12/8/21 00:43, Sean Christopherson wrote:
>> what guarantees the that PDPTRs in the VMCS are sync'd with
>> mmu->pdptrs?  I'm not saying they aren't, I just want the changelog
>> to prove that they are.
> 
> If they aren't synced you should *already* have dirty VCPU_EXREG_PDPTR and pending KVM_REQ_LOAD_MMU_PGD, shouldn't you?  
> As long as the caching invariants are respected, this patch is fairly safe, and if they aren't there are plenty of 
> preexisting bugs anyway.
> 


They can be not synced in other side: not available.

If (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
it will make no sense to compare mmu->pdptrs when EPT is enabled.

Because vmcs might have different copy, it is better to just mark it
dirty in load_pdptrs().

(SVM is OK even with NPT enabled, since vmcb doesn't have a copy)

I haven't investigated enough then and today.  It is quit complicated.

Thanks
Lai

> 
>> The next patch does add a fairly heavy unload of the current root for
>> !TDP, but that's a bug fix and should be ordered before any
>> optimizations anyways.
