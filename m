Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357DC455769
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 09:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244888AbhKRI5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 03:57:23 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:33303 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244873AbhKRI4X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 03:56:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UxBM4BC_1637225601;
Received: from 30.22.113.233(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UxBM4BC_1637225601)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Nov 2021 16:53:21 +0800
Message-ID: <dc7cc86b-7606-573c-cfd6-86473fd67ab5@linux.alibaba.com>
Date:   Thu, 18 Nov 2021 16:53:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 00/15] KVM: X86: Fix and clean up for register caches
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,all

Ping

Thanks
Lai

On 2021/11/8 20:43, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> The patchset was started when I read the code of nested_svm_load_cr3()
> and found that it marks CR3 available other than dirty when changing
> vcpu->arch.cr3.  I thought its caller has ensured that vmcs.GUEST_CR3
> will be or already be set to @cr3 so that it doesn't need to be marked
> dirty.  And later I found that it is not true and it must be a bug in
> a rare case before I realized that all the code just (ab)uses
> vcpu->arch.regs_avail for VCPU_EXREG_CR3 and there is not such bug
> of using regs_avail here.
> (The above finding becomes a low meaning patch_15 rather than a fix)
> 
> The unhappyness of the reading code made me do some cleanup for
> regs_avail and regs_dirty and kvm_register_xxx() functions in the hope
> that the code become clearer with less misunderstanding.
> 
> Major focus was on VCPU_EXREG_CR3 and VCPU_EXREG_PDPTR.  They are
> ensured to be marked the correct tags (available or dirty), and the
> value is ensured to be synced to architecture before run if it is marked
> dirty.
> 
> When cleaning VCPU_EXREG_PDPTR, I also checked if the corresponding
> cr0/cr4 pdptr bits are all intercepted when !tdp_enabled, and I think
> it is not clear enough, so X86_CR4_PDPTR_BITS is added as self-comments
> in the code.
> 
> Lai Jiangshan (15):
>    KVM: X86: Ensure the dirty PDPTEs to be loaded
>    KVM: VMX: Mark VCPU_EXREG_PDPTR available in ept_save_pdptrs()
>    KVM: SVM: Always clear available of VCPU_EXREG_PDPTR in svm_vcpu_run()
>    KVM: VMX: Add and use X86_CR4_TLB_BITS when !enable_ept
>    KVM: VMX: Add and use X86_CR4_PDPTR_BITS when !enable_ept
>    KVM: X86: Move CR0 pdptr_bits into header file as X86_CR0_PDPTR_BITS
>    KVM: SVM: Remove outdate comment in svm_load_mmu_pgd()
>    KVM: SVM: Remove useless check in svm_load_mmu_pgd()
>    KVM: SVM: Remove the unneeded code to mark available for CR3
>    KVM: X86: Mark CR3 dirty when vcpu->arch.cr3 is changed
>    KVM: VMX: Update vmcs.GUEST_CR3 only when the guest CR3 is dirty
>    KVM: VMX: Reset the bits that are meaningful to be reset in
>      vmx_register_cache_reset()
>    KVM: SVM: Add and use svm_register_cache_reset()
>    KVM: X86: Remove kvm_register_clear_available()
>    KVM: nVMX: Always write vmcs.GUEST_CR3 during nested VM-Exit
> 
>   arch/x86/kvm/kvm_cache_regs.h | 13 ++++++------
>   arch/x86/kvm/svm/nested.c     |  1 -
>   arch/x86/kvm/svm/svm.c        | 17 ++++++++--------
>   arch/x86/kvm/svm/svm.h        | 26 ++++++++++++++++++++++++
>   arch/x86/kvm/vmx/nested.c     | 30 ++++++++++++++++++----------
>   arch/x86/kvm/vmx/vmx.c        | 12 +++++++-----
>   arch/x86/kvm/vmx/vmx.h        | 37 +++++++++++++++++++++++++----------
>   arch/x86/kvm/x86.c            | 13 ++++++------
>   8 files changed, 101 insertions(+), 48 deletions(-)
> 
