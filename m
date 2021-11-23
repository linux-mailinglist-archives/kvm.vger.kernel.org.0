Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D714459F5A
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 10:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhKWJhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 04:37:46 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:46518 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhKWJhq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 04:37:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UxueP3J_1637660074;
Received: from 30.22.113.103(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UxueP3J_1637660074)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Nov 2021 17:34:35 +0800
Message-ID: <31a86235-dd24-5215-907b-c05e356dee38@linux.alibaba.com>
Date:   Tue, 23 Nov 2021 17:34:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144634.88972-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <20211111144634.88972-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hello, Paolo

any thought/concern about this one?

Thanks
Lai


On 2021/11/11 22:46, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> For shadow paging, the pae_root needs to be reconstructed before the
> coming VMENTER if the guest PDPTEs is changed.
> 
> But not all paths that call load_pdptrs() will cause the pae_root to be
> reconstructed. Normally, kvm_mmu_reset_context() and kvm_mmu_free_roots()
> are used to launch later reconstruction.
> 
> The commit d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and
> CR0.NW are changed") skips kvm_mmu_reset_context() after load_pdptrs()
> when changing CR0.CD and CR0.NW.
> 
> The commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
> PCID on MOV CR3 w/ flush") skips kvm_mmu_free_roots() after
> load_pdptrs() when rewriting the CR3 with the same value.
> 
> The commit a91a7c709600("KVM: X86: Don't reset mmu context when
> toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
> load_pdptrs() when changing CR4.PGE.
> 
> Normally, the guest doesn't change the PDPTEs before doing only the
> above operation without touching other bits that can force pae_root to
> be reconstructed.  Guests like linux would keep the PDPTEs unchaged
> for every instance of pagetable.
> 
> Fixes: d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
> Fixes: 21823fbda552("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
> Fixes: a91a7c709600("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/x86.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0176eaa86a35..cfba337e46ab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -832,8 +832,14 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>   	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
>   		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
>   		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> -		/* Ensure the dirty PDPTEs to be loaded. */
> -		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +		/*
> +		 * Ensure the dirty PDPTEs to be loaded for VMX with EPT
> +		 * enabled or pae_root to be reconstructed for shadow paging.
> +		 */
> +		if (tdp_enabled)
> +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +		else
> +			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
>   	}
>   	vcpu->arch.pdptrs_from_userspace = false;
>   
> 
