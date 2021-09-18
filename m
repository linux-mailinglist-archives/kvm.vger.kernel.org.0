Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152444102C0
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 03:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhIRBuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 21:50:46 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35382 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233801AbhIRBuq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 21:50:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Uojp1ta_1631929760;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Uojp1ta_1631929760)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 09:49:21 +0800
Subject: Re: [PATCH V2 08/10] KVM: X86: Remove FNAME(update_pte)
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
 <20210918005636.3675-9-jiangshanlai@gmail.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <914263d8-bf05-9557-d7a8-e74045c581b6@linux.alibaba.com>
Date:   Sat, 18 Sep 2021 09:49:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210918005636.3675-9-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/9/18 08:56, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Its solo caller is changed to use FNAME(prefetch_gpte) directly.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---

Sorry, I've forgotten to add Maxim's Reviewed-by from V1:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

>   arch/x86/kvm/mmu/paging_tmpl.h | 10 +---------
>   1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index c3edbc0f06b3..ca5fdd07cfa2 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -589,14 +589,6 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   	return true;
>   }
>   
> -static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> -			      u64 *spte, const void *pte)
> -{
> -	pt_element_t gpte = *(const pt_element_t *)pte;
> -
> -	FNAME(prefetch_gpte)(vcpu, sp, spte, gpte, false);
> -}
> -
>   static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
>   				struct guest_walker *gw, int level)
>   {
> @@ -1001,7 +993,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>   						       sizeof(pt_element_t)))
>   				break;
>   
> -			FNAME(update_pte)(vcpu, sp, sptep, &gpte);
> +			FNAME(prefetch_gpte)(vcpu, sp, sptep, gpte, false);
>   		}
>   
>   		if (!sp->unsync_children)
> 
