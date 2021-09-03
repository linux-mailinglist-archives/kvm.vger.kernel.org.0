Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8523FF870
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 02:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346366AbhICApz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 20:45:55 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33446 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345668AbhICApz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 20:45:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0Un301am_1630629893;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Un301am_1630629893)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 08:44:54 +0800
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-3-jiangshanlai@gmail.com> <YTFhCt87vzo4xDrc@google.com>
 <YTFkMvdGug3uS2e4@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <c8cd9508-7516-0891-f507-4b869d7e4322@linux.alibaba.com>
Date:   Fri, 3 Sep 2021 08:44:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTFkMvdGug3uS2e4@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/9/3 07:54, Sean Christopherson wrote:
> 
>   trace_get_page:
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50ade6450ace..5b13918a55c2 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -704,6 +704,10 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   			access = gw->pt_access[it.level - 2];
>   			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
>   					      it.level-1, false, access);
> +			if (sp->unsync_children) {
> +				kvm_make_all_cpus_request(KVM_REQ_MMU_SYNC, vcpu);
> +				return RET_PF_RETRY;

Making KVM_REQ_MMU_SYNC be able remotely is good idea.
But if the sp is not linked, the @sp might not be synced even we
tried many times. So we should continue to link it.

But if we continue to link it, KVM_REQ_MMU_SYNC should be extended to
sync all roots (current root and prev_roots).  And maybe add a
KVM_REQ_MMU_SYNC_CURRENT for current root syncing.

It is not going to be a simple.  I have a new way to sync pages
and also fix the problem,  but that include several non-fix patches.

We need to fix this problem in the simplest way.  In my patch
mmu_sync_children() has a @root argument.  I think we can disallow
releasing the lock when @root is false. Is it OK?



> +			}
>   		}
> 
>   		/*
> --
> 
