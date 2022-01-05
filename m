Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6528F484FB2
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 10:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiAEJCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 04:02:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbiAEJCU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 04:02:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641373339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uKvynMYoI7ndWuR89MhoYNvUzSRTZ3Q5kTxLQB/IWzU=;
        b=IMbbFiy+Hbh5SOg820DtaitoH61UzK/OfOHv18Fk/CPccwFtCKXbxTR/kR8NfwbSbmV6tw
        BOgMWfp9PMjnKd9l0goSSX+2sIvljaPiYN3vsaONufhBV5fODBih+uRnVqfDZRVFVohnjn
        ziGEomLOWh9lf1fS/RZny+NCuelkw0M=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-zAxkasqhMMGO-0vDV6Y_FQ-1; Wed, 05 Jan 2022 04:02:16 -0500
X-MC-Unique: zAxkasqhMMGO-0vDV6Y_FQ-1
Received: by mail-pf1-f200.google.com with SMTP id d127-20020a623685000000b004bcdb7cce18so1288967pfa.21
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 01:02:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uKvynMYoI7ndWuR89MhoYNvUzSRTZ3Q5kTxLQB/IWzU=;
        b=11x/Dug7XPTGmRpa4KKwrS4fT8rwK2eLdrYKEhrTVyYqMmBTKVujH4DRdMjBetYFYv
         QqvN2WghYGlcxH16cxZYM3I+LaBVVWyuf8KGlBEG/ULxC3/gMwy9w8nJtmOSV3l7JumN
         UFRHfj9MZuIkokYeA4Ts8TcrbwUkPymPEajvjwxPRj1z83LDs+Ke+mP+msxwoEeVps8m
         NQm9Wq6H1pXHJ9eAVVg19Nyhg4cq6xy+yPSBFfRgcI6hfK9lBWKKEmMZMbK7ExzhRqhb
         HYfRs6OwXtCwQhNThJlK35FmGl+iJ2h+Oki0finJ8M6jrlJI433mEO2BVfRYwrLTBSgB
         2A8Q==
X-Gm-Message-State: AOAM531x+wFzwneboWBO75T0fGh+otQn4EojvbBlohk1jWG7y2K9elWH
        2ZJMLn2RUjWHV9xhZy9tGpzM3Cm4NGSBtV5HVb9dhXAcnblac3ulNR2VPHAINDlbYkQH9tgWsWE
        CM9wLdz+2lgdu
X-Received: by 2002:a63:2166:: with SMTP id s38mr47093370pgm.125.1641373335285;
        Wed, 05 Jan 2022 01:02:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznty1sNigoiRvmucJc+qexhcdx6ZNqh3gXqZ2SyFhzVf2BqyoO8y5K7RUHmfEQVlVHBlSwQA==
X-Received: by 2002:a63:2166:: with SMTP id s38mr47093345pgm.125.1641373335030;
        Wed, 05 Jan 2022 01:02:15 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id q22sm47373939pfk.27.2022.01.05.01.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 01:02:14 -0800 (PST)
Date:   Wed, 5 Jan 2022 17:02:06 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 11/13] KVM: x86/mmu: Split huge pages during
 CLEAR_DIRTY_LOG
Message-ID: <YdVejo2TODD3Z+QC@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-12-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-12-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:16PM +0000, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c9e5fe290714..55640d73df5a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1362,6 +1362,20 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  		gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
>  		gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
>  
> +		/*
> +		 * Try to proactively split any huge pages down to 4KB so that
> +		 * vCPUs don't have to take write-protection faults.
> +		 *
> +		 * Drop the MMU lock since huge page splitting uses its own
> +		 * locking scheme and does not require the write lock in all
> +		 * cases.
> +		 */
> +		if (READ_ONCE(eagerly_split_huge_pages_for_dirty_logging)) {
> +			write_unlock(&kvm->mmu_lock);
> +			kvm_mmu_try_split_huge_pages(kvm, slot, start, end, PG_LEVEL_4K);
> +			write_lock(&kvm->mmu_lock);
> +		}
> +
>  		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);

Would it be easier to just allow passing in shared=true/false for the new
kvm_mmu_try_split_huge_pages(), then previous patch will not be needed?  Or is
it intended to do it for performance reasons?

IOW, I think this patch does two things: (1) support clear-log on eager split,
and (2) allow lock degrade during eager split.

It's just that imho (2) may still need some justification on necessity since
this function only operates on a very small range of guest mem (at most
4K*64KB=256KB range), so it's not clear to me whether the extra lock operations
are needed at all; after all it'll make the code slightly harder to follow.
Not to mention the previous patch is preparing for this, and both patches will
add lock operations.

I think dirty_log_perf_test didn't cover lock contention case, because clear
log was run after vcpu threads stopped, so lock access should be mostly hitting
the cachelines there, afaict.  While in real life, clear log is run with vcpus
running.  Not sure whether that'll be a problem, so raising this question up.

Thanks,

-- 
Peter Xu

