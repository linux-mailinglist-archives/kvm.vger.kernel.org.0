Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241CD354CE0
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 08:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243976AbhDFG0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 02:26:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15551 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbhDFG0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 02:26:13 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FDyBv2FFrzPmFw;
        Tue,  6 Apr 2021 14:23:19 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 14:26:01 +0800
Subject: Re: [PATCH] KVM: MMU: protect TDP MMU pages only down to required
 level
To:     Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <20210402121704.3424115-1-pbonzini@redhat.com>
CC:     Ben Gardon <bgardon@google.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <8d9b028b-1e3a-b4eb-5d44-604ddab6560e@huawei.com>
Date:   Tue, 6 Apr 2021 14:26:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210402121704.3424115-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

I'm just going to fix this issue, and found that you have done this ;-)
Please feel free to add:

Reviewed-by: Keqian Zhu <zhukeqian1@huawei.com>

Thanks,
Keqian

On 2021/4/2 20:17, Paolo Bonzini wrote:
> When using manual protection of dirty pages, it is not necessary
> to protect nested page tables down to the 4K level; instead KVM
> can protect only hugepages in order to split them lazily, and
> delay write protection at 4K-granularity until KVM_CLEAR_DIRTY_LOG.
> This was overlooked in the TDP MMU, so do it there as well.
> 
> Fixes: a6a0b05da9f37 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index efb41f31e80a..0d92a269c5fa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5538,7 +5538,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
>  				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
>  	if (is_tdp_mmu_enabled(kvm))
> -		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
> +		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
>  	write_unlock(&kvm->mmu_lock);
>  
>  	/*
> 
