Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B73C400338
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349961AbhICQ0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 12:26:31 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:40513 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235434AbhICQ0a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 12:26:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0Un7j614_1630686327;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Un7j614_1630686327)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 04 Sep 2021 00:25:28 +0800
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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
 <c8cd9508-7516-0891-f507-4b869d7e4322@linux.alibaba.com>
 <YTJIBr/lm5QU/Z3W@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <7067bec0-8a15-1a18-481e-e2ea79575dcf@linux.alibaba.com>
Date:   Sat, 4 Sep 2021 00:25:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTJIBr/lm5QU/Z3W@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/9/4 00:06, Sean Christopherson wrote:

> 
>   trace_get_page:
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50ade6450ace..2ff123ec0d64 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -704,6 +704,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   			access = gw->pt_access[it.level - 2];
>   			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
>   					      it.level-1, false, access);
> +			if (sp->unsync_children &&
> +			    mmu_sync_children(vcpu, sp, false))
> +				return RET_PF_RETRY;

It was like my first (unsent) fix.  Just return RET_PF_RETRY when break.

And then I thought that it'd be better to retry fetching directly rather than
retry guest when the conditions are still valid/unchanged to avoid all the
next guest page walking and GUP().  Although the code does not check all
conditions such as interrupt event pending. (we can add that too)

I think it is a good design to allow break mmu_lock when mmu is handling
heavy work.


>   		}
> 
>   		/*
> --
> 
