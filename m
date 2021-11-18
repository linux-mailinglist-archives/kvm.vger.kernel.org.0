Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D6A45527A
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 03:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242432AbhKRCIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 21:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242427AbhKRCIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 21:08:17 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6F6C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 18:05:17 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id o14so3866229plg.5
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 18:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UFmDZX3iZjmhuVQR+vjc6h7KMRvGK/W6qGNnrnIksJI=;
        b=hEsvcYnEadPA6+b0djAbkweEqFuulYFEhfsUUAdZShhuJLcwjOufRelSUOU6Dwez8U
         Dqc3aQX6FahSu/C7FU5UFvh/SDrSzs2f957l7nTjJtgl+qnGNevYYJKJ7R02mitbVCO+
         QoJTdn/ILVJITrUuVeoxXjV7eYxAaf3gmKc+qFhJxcoVsufiPuHeL3L8VE3IkZ+QLSMK
         BDpEM/8JZw2RjPQ/eekKdqim5pT3k1G0l+GaGEO5KowuLdbimYgM731P1xx/DILAgzYM
         fi0lZ8iWqLGNE6UxiiXVzHm33TQ3AgaIoNvuYictx222GyKifm9HMMNBGp3tT7EeC3YG
         azRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UFmDZX3iZjmhuVQR+vjc6h7KMRvGK/W6qGNnrnIksJI=;
        b=yrEalhMrBReSpOKuf+9B4xJ8n2fLGImkSODaLPQKvAHMe4+Y24ZTt6bW23vO9e9HUR
         m84s4Db/A47q0Wjt+lKu6TbcuzguV3bl1W3Y6gAkYzyMshS4OSzPr2MqdL5VjSdmDldX
         ANsiTGoWA39Jj/T0M5VjqajiuLdbgIraFux9tHSAA1f7KKy/JlSDH7bTHoork5FnDqQQ
         pvkTBmg57Td8Kp4ZCMbEI6+6aLK2NCSqMSvQY8R4wHZnBaepK57sZaJRST+WbRCWQZ9Q
         AMUIeZrZJWUaXUuXyDijF/8I5evUylRD3DpNWyrEuybi2AENJ0+eI8YefUJnvkZmEDYI
         IPow==
X-Gm-Message-State: AOAM5303ekWto/5OxrCWBi29wAIOpc+UMv6eRmCj/n4KSi4hxiT9iI8D
        aXeMdKuCQRzFTKCKnHlWF03I/A==
X-Google-Smtp-Source: ABdhPJyGYwQLyMPnIzlZjzcdU17UtKHkMGVxlOCCUMdlp8IjJ88xlZMgN5PPyznT5dNXAQrSz7G/UQ==
X-Received: by 2002:a17:902:ab8d:b0:143:8d6f:2b52 with SMTP id f13-20020a170902ab8d00b001438d6f2b52mr61118529plr.78.1637201117095;
        Wed, 17 Nov 2021 18:05:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mq14sm7225211pjb.54.2021.11.17.18.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 18:05:16 -0800 (PST)
Date:   Thu, 18 Nov 2021 02:05:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Message-ID: <YZW02M0+YzAzBF/w@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110223010.1392399-12-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021, Ben Gardon wrote:
> In the interest of devloping a version of make_spte that can function
> without a vCPU pointer, factor out the shadow_zero_mask to be an
> additional argument to the function.
> 
> No functional change intended.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/spte.c | 11 +++++++----
>  arch/x86/kvm/mmu/spte.h |  3 ++-
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index b7271daa06c5..d3b059e96c6e 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -93,7 +93,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       struct kvm_memory_slot *slot, unsigned int pte_access,
>  	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
>  	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
> -	       u64 mt_mask, u64 *new_spte)
> +	       u64 mt_mask, struct rsvd_bits_validate *shadow_zero_check,

Ugh, so I had a big email written about how I think we should add a module param
to control 4-level vs. 5-level for all TDP pages, but then I realized it wouldn't
work for nested EPT because that follows the root level used by L1.  We could
still make a global non_nested_tdp_shadow_zero_check or whatever, but then make_spte()
would have to do some work to find the right rsvd_bits_validate, and the end result
would likely be a mess.

One idea to avoid exploding make_spte() would be to add a backpointer to the MMU
in kvm_mmu_page.  I don't love the idea, but I also don't love passing in rsvd_bits_validate.
