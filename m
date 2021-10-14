Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF58D42DED2
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 18:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhJNQGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 12:06:03 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:52428 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230359AbhJNQGC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 12:06:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Urv6D08_1634227435;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Urv6D08_1634227435)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 00:03:56 +0800
Subject: Re: [PATCH 0/2] KVM: X86: Don't reset mmu context when changing PGE
 or PCID
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
References: <20210919024246.89230-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <506c12c4-4a56-bcbf-a566-a3e75c0814aa@linux.alibaba.com>
Date:   Fri, 15 Oct 2021 00:03:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210919024246.89230-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping

On 2021/9/19 10:42, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> This patchset uses kvm_vcpu_flush_tlb_guest() instead of kvm_mmu_reset_context()
> when X86_CR4_PGE is changed or X86_CR4_PCIDE is changed 1->0.
> 
> Neither X86_CR4_PGE nor X86_CR4_PCIDE participates in kvm_mmu_role, so
> kvm_mmu_reset_context() is not required to be invoked.  Only flushing tlb
> is required as SDM says.
> 
> The patchset has nothing to do with performance, because the overheads of
> kvm_mmu_reset_context() and kvm_vcpu_flush_tlb_guest() are the same.  And
> even in the [near] future, kvm_vcpu_flush_tlb_guest() will be optimized,
> the code is not in the hot path.
> 
> This patchset makes the code more clear when to reset the mmu context.
> And it makes KVM_MMU_CR4_ROLE_BITS consistent with kvm_mmu_role.
> 
> Lai Jiangshan (2):
>    KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
>    KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE
> 
>   arch/x86/kvm/mmu.h | 5 ++---
>   arch/x86/kvm/x86.c | 7 +++++--
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 
