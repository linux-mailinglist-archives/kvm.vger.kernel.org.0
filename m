Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4520B462960
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 02:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhK3BEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 20:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhK3BE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 20:04:29 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD408C061574
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 17:01:11 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so16952108pju.3
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 17:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uqZ6KaX/LZNKK/U1xMm7U20FtP5AZfHeKxb0hw08vyk=;
        b=aMxplbiofMx/l/2R2IQPCkTg1T5J09NQ3zL48go3w6Xxhm/V5rvdRtFsMaHMHg9Nd2
         P5mN6Erhdlxr9mvxH7Qo9Xw5L+c3Hje4iLdSnfACOQ/sZbF55UNymhCA5XBLVz5BkrOr
         1/lnMOFFr20T3Oxj0Xrv2iQGAsKAJOiaIVnHcAHbwU4WF8MOpNgZJxyNtmawXAAZ+8cl
         68b73Vg90QWbSs9kVyEgBh5Eqk5+3Ar/rbzqu88E6MtJWhKvw0RdSKUCGDivHcmBAr5m
         8NxApU9aKU0vWBsfZO4H1QJTftHTuBneimUTjt5wE13tM+nRE6nNyijB4BMbiJgy/oKa
         B/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uqZ6KaX/LZNKK/U1xMm7U20FtP5AZfHeKxb0hw08vyk=;
        b=uB1quzd9fja8gcpoMknLAImHr1427FGM9F+tWONoA77j8RVJKF0VWSWZxD1TwsB5Zw
         U9bLQGOrcUWR0QiJcnNFRLMlG58n0SeZNUP4can8QYaa98ac6D/U42IcLJWZ4FXywIFQ
         Tyscsved0gSdyTQQQ4gNEopf37OnEVf6zEQnR2qGwMaAxzc2LQtpucYjnnhLRXfgEn3x
         BLSOs1ajg9n2FYA7NoUVDha48/P9WDyti5RdnVNiwX3LH1NSNoN4ARgZajMTA/Wca2mS
         GLM83DrenABq/I6QRalSXNR2EMB5E7EB+DZXENohH89tAwp3pzbukoDU91GWWGyxSBU3
         khwg==
X-Gm-Message-State: AOAM530F2i4jdHUGlgDICR/Z0sDUfoZB2gumj9gC1N7BjvPvxGTJMxJ1
        t9rC6MEQWA0ndximRIzOowWWjA==
X-Google-Smtp-Source: ABdhPJymdCi6qiFw9ovg+bQ4gteXYrrpV4iWt+iuznTWOlJjne73F5Yvgo+UINos1pmeuZSGGavBBQ==
X-Received: by 2002:a17:902:dad2:b0:141:fbea:178d with SMTP id q18-20020a170902dad200b00141fbea178dmr63857671plx.78.1638234070897;
        Mon, 29 Nov 2021 17:01:10 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id lt5sm465983pjb.43.2021.11.29.17.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 17:01:09 -0800 (PST)
Date:   Tue, 30 Nov 2021 01:01:06 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Update number of zapped pages even if
 page list is stable
Message-ID: <YaV30lD5ipdB642C@google.com>
References: <20211129235233.1277558-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129235233.1277558-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 11:52:33PM +0000, Sean Christopherson wrote:
> When zapping obsolete pages, update the running count of zapped pages
> regardless of whether or not the list has become unstable due to zapping
> a shadow page with its own child shadow pages.  If the VM is backed by
> mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
> the batch count and thus without yielding.  In the worst case scenario,
> this can cause a soft lokcup.
> 
>  watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [dirty_log_perf_:13020]
>    RIP: 0010:workingset_activation+0x19/0x130
>    mark_page_accessed+0x266/0x2e0
>    kvm_set_pfn_accessed+0x31/0x40
>    mmu_spte_clear_track_bits+0x136/0x1c0
>    drop_spte+0x1a/0xc0
>    mmu_page_zap_pte+0xef/0x120
>    __kvm_mmu_prepare_zap_page+0x205/0x5e0
>    kvm_mmu_zap_all_fast+0xd7/0x190
>    kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
>    kvm_page_track_flush_slot+0x5c/0x80
>    kvm_arch_flush_shadow_memslot+0xe/0x10
>    kvm_set_memslot+0x1a8/0x5d0
>    __kvm_set_memory_region+0x337/0x590
>    kvm_vm_ioctl+0xb08/0x1040
> 
> Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
> Reported-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
> 
> v2:
>  - Rebase to kvm/master, commit 30d7c5d60a88 ("KVM: SEV: expose...")
>  - Collect Ben's review, modulo bad splat.
>  - Copy+paste the correct splat and symptom. [David].
> 
> @David, I kept the unstable declaration out of the loop, mostly because I
> really don't like putting declarations in loops, but also because
> nr_zapped is declared out of the loop and I didn't want to change that
> unnecessarily or make the code inconsistent.

Sounds good. For stable patches I definitely agree with not changing
variable declarations needlessly. And as a general rule, I get your
point on the other thread about shadowing variables and therefore
preferring to declare all variables at function scope.

I have some other ideas on this topic but it's out of scope for this
patch so I'll post it on the other thread.

> 
>  arch/x86/kvm/mmu/mmu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0c839ee1282c..208c892136bf 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5576,6 +5576,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *sp, *node;
>  	int nr_zapped, batch = 0;
> +	bool unstable;
>  
>  restart:
>  	list_for_each_entry_safe_reverse(sp, node,
> @@ -5607,11 +5608,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>  			goto restart;
>  		}
>  
> -		if (__kvm_mmu_prepare_zap_page(kvm, sp,
> -				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
> -			batch += nr_zapped;
> +		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
> +				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
> +		batch += nr_zapped;
> +
> +		if (unstable)
>  			goto restart;
> -		}
>  	}
>  
>  	/*
> -- 
> 2.34.0.rc2.393.gf8c9666880-goog
> 
