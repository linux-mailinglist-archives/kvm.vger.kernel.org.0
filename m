Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83804D96BB
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 09:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346229AbiCOIwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 04:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346221AbiCOIwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 04:52:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 512784D61C
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647334261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iJfPNwORsYGtURUoL7s3z0la28b4kkixiHIx/VOk9p4=;
        b=hfPb0Pojntqlp6RGC1S57T1hZX92joP6yxW/qt3Cqk6ZPNjdUkAZxsg8FCl/br7d7FEUnP
        h0Lt6V/9prauaycxcs/qpe8lJFtXKGqwG5xpBpPgZTlXq+rfbwpYbcYjkY5C/IZEeS0kKC
        qIfypCv6SDGPt4wyudz1d36UpYeqNHk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-p6Q8smNlNEWYBNfFulZlZw-1; Tue, 15 Mar 2022 04:51:00 -0400
X-MC-Unique: p6Q8smNlNEWYBNfFulZlZw-1
Received: by mail-pl1-f197.google.com with SMTP id d13-20020a170902b70d00b0015317d9f08bso6663802pls.1
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iJfPNwORsYGtURUoL7s3z0la28b4kkixiHIx/VOk9p4=;
        b=xUZuTMCA4UoJriHvGTlJmw9jYqdwQ1sqpZoTbryiKC43rPaA8Lhx2pDJ6SX9dlSi45
         QmTnP+YGHib+ADSseWMA+doPOC2St2rPgBtTysNDi2R5KmWwqdm2DCsy35rLvKxkvl6t
         RRCZylKi+56KLrU6A2eJpry5EQxUHT7VuMs7l4ilpo7KIhrp3WnG1e25l1guu7WkKXqx
         6pYk2l/DM3NxBNwcWpdG3ehgVLDjDrdZOV79XZdGL/3Fxi2pFhhKWT1wvSmkLdGzD65s
         Q9fUm2Zk0KgCakUdrw+1+JdEeevFhWLIit2/inU2HxWKZvLlwaTXdjtNP23fz3I3znGO
         8Vvg==
X-Gm-Message-State: AOAM5330AooO6v4SpkJGUPZEfW+Y8AJy9j0BNgnrIltfMFEKO65g1AYa
        obIsJLSlTSmhpmG9jrf5r0LeeIIjNACgjnpORVDtdhiNKSxNkzKgX802cyufihskljCEduWDNgG
        Gw034rMD35teT
X-Received: by 2002:a17:903:3112:b0:151:a940:1574 with SMTP id w18-20020a170903311200b00151a9401574mr27501169plc.63.1647334258847;
        Tue, 15 Mar 2022 01:50:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHWj9bKrdm/9Y/tsKI6ZrYi5hSyGCM7zNyQtEZKMz/CbNWKzPkd9lMjLNsISJclLrmbrGh3w==
X-Received: by 2002:a17:903:3112:b0:151:a940:1574 with SMTP id w18-20020a170903311200b00151a9401574mr27501135plc.63.1647334258490;
        Tue, 15 Mar 2022 01:50:58 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43])
        by smtp.gmail.com with ESMTPSA id gb5-20020a17090b060500b001bd312f7396sm2197473pjb.45.2022.03.15.01.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 01:50:58 -0700 (PDT)
Date:   Tue, 15 Mar 2022 16:50:50 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v2 04/26] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
Message-ID: <YjBTal9gWoEKybxi@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-5-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:06AM +0000, David Matlack wrote:
> Decompose kvm_mmu_get_page() into separate helper functions to increase
> readability and prepare for allocating shadow pages without a vcpu
> pointer.
> 
> Specifically, pull the guts of kvm_mmu_get_page() into 3 helper
> functions:
> 
> __kvm_mmu_find_shadow_page() -
>   Walks the page hash checking for any existing mmu pages that match the
>   given gfn and role. Does not attempt to synchronize the page if it is
>   unsync.
> 
> kvm_mmu_find_shadow_page() -
>   Wraps __kvm_mmu_find_shadow_page() and handles syncing if necessary.
> 
> kvm_mmu_new_shadow_page()
>   Allocates and initializes an entirely new kvm_mmu_page. This currently
>   requries a vcpu pointer for allocation and looking up the memslot but
>   that will be removed in a future commit.
> 
>   Note, kvm_mmu_new_shadow_page() is temporary and will be removed in a
>   subsequent commit. The name uses "new" rather than the more typical
>   "alloc" to avoid clashing with the existing kvm_mmu_alloc_page().
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks good to me, a few nitpicks and questions below.

> ---
>  arch/x86/kvm/mmu/mmu.c         | 132 ++++++++++++++++++++++++---------
>  arch/x86/kvm/mmu/paging_tmpl.h |   5 +-
>  arch/x86/kvm/mmu/spte.c        |   5 +-
>  3 files changed, 101 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 23c2004c6435..80dbfe07c87b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2027,16 +2027,25 @@ static void clear_sp_write_flooding_count(u64 *spte)
>  	__clear_sp_write_flooding_count(sptep_to_sp(spte));
>  }
>  
> -static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> -					     union kvm_mmu_page_role role)
> +/*
> + * Searches for an existing SP for the given gfn and role. Makes no attempt to
> + * sync the SP if it is marked unsync.
> + *
> + * If creating an upper-level page table, zaps unsynced pages for the same
> + * gfn and adds them to the invalid_list. It's the callers responsibility
> + * to call kvm_mmu_commit_zap_page() on invalid_list.
> + */
> +static struct kvm_mmu_page *__kvm_mmu_find_shadow_page(struct kvm *kvm,
> +						       gfn_t gfn,
> +						       union kvm_mmu_page_role role,
> +						       struct list_head *invalid_list)
>  {
>  	struct hlist_head *sp_list;
>  	struct kvm_mmu_page *sp;
>  	int collisions = 0;
> -	LIST_HEAD(invalid_list);
>  
> -	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> -	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> +	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> +	for_each_valid_sp(kvm, sp, sp_list) {
>  		if (sp->gfn != gfn) {
>  			collisions++;
>  			continue;
> @@ -2053,60 +2062,109 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  			 * upper-level page will be write-protected.
>  			 */
>  			if (role.level > PG_LEVEL_4K && sp->unsync)
> -				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
> -							 &invalid_list);
> +				kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
> +
>  			continue;
>  		}
>  
> -		/* unsync and write-flooding only apply to indirect SPs. */
> -		if (sp->role.direct)
> -			goto trace_get_page;
> +		/* Write-flooding is only tracked for indirect SPs. */
> +		if (!sp->role.direct)
> +			__clear_sp_write_flooding_count(sp);
>  
> -		if (sp->unsync) {
> -			/*
> -			 * The page is good, but is stale.  kvm_sync_page does
> -			 * get the latest guest state, but (unlike mmu_unsync_children)
> -			 * it doesn't write-protect the page or mark it synchronized!
> -			 * This way the validity of the mapping is ensured, but the
> -			 * overhead of write protection is not incurred until the
> -			 * guest invalidates the TLB mapping.  This allows multiple
> -			 * SPs for a single gfn to be unsync.
> -			 *
> -			 * If the sync fails, the page is zapped.  If so, break
> -			 * in order to rebuild it.
> -			 */
> -			if (!kvm_sync_page(vcpu, sp, &invalid_list))
> -				break;
> +		goto out;
> +	}
>  
> -			WARN_ON(!list_empty(&invalid_list));
> -			kvm_flush_remote_tlbs(vcpu->kvm);
> -		}
> +	sp = NULL;
>  
> -		__clear_sp_write_flooding_count(sp);
> +out:
> +	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
> +		kvm->stat.max_mmu_page_hash_collisions = collisions;
> +
> +	return sp;
> +}
>  
> -trace_get_page:
> -		trace_kvm_mmu_get_page(sp, false);
> +/*
> + * Looks up an existing SP for the given gfn and role if one exists. The
> + * return SP is guaranteed to be synced.
> + */
> +static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
> +						     gfn_t gfn,
> +						     union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *sp;
> +	LIST_HEAD(invalid_list);
> +
> +	sp = __kvm_mmu_find_shadow_page(vcpu->kvm, gfn, role, &invalid_list);
> +	if (!sp)
>  		goto out;
> +
> +	if (sp->unsync) {
> +		/*
> +		 * The page is good, but is stale.  kvm_sync_page does
> +		 * get the latest guest state, but (unlike mmu_unsync_children)
> +		 * it doesn't write-protect the page or mark it synchronized!
> +		 * This way the validity of the mapping is ensured, but the
> +		 * overhead of write protection is not incurred until the
> +		 * guest invalidates the TLB mapping.  This allows multiple
> +		 * SPs for a single gfn to be unsync.
> +		 *
> +		 * If the sync fails, the page is zapped and added to the
> +		 * invalid_list.
> +		 */
> +		if (!kvm_sync_page(vcpu, sp, &invalid_list)) {
> +			sp = NULL;
> +			goto out;
> +		}
> +
> +		WARN_ON(!list_empty(&invalid_list));

Not related to this patch because I think it's a pure movement here,
however I have a question on why invalid_list is guaranteed to be empty..

I'm thinking the case where when lookup the page we could have already
called kvm_mmu_prepare_zap_page() there, then when reach here (which is the
kvm_sync_page==true case) invalid_list shouldn't be touched in
kvm_sync_page(), so it looks possible that it still contains some page to
be commited?

> +		kvm_flush_remote_tlbs(vcpu->kvm);
>  	}
>  
> +out:

I'm wondering whether this "out" can be dropped.. with something like:

        sp = __kvm_mmu_find_shadow_page(...);

        if (sp && sp->unsync) {
                if (kvm_sync_page(vcpu, sp, &invalid_list)) {
                        ..
                } else {
                        sp = NULL;
                }
        }

[...]

> +static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> +					     union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *sp;
> +	bool created = false;
> +
> +	sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
> +	if (sp)
> +		goto out;
> +
> +	created = true;
> +	sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
> +
> +out:
> +	trace_kvm_mmu_get_page(sp, created);
>  	return sp;

Same here, wondering whether we could drop the "out" by:

        sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
        if (!sp) {
                created = true;
                sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
        }

        trace_kvm_mmu_get_page(sp, created);
        return sp;

Thanks,

-- 
Peter Xu

