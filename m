Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D973ABBCB
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 20:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhFQSaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 14:30:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232345AbhFQSaI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Jun 2021 14:30:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623954480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6ETG+pltWJSznK09vGdsqaT22gUDBs8M4SpJDfF/cM=;
        b=h/6hz3mfC718iWJYon5FLVJhH0ybHzY2UvBXau/ZnxeZIlnt80gJwfgJzXik3C5BooXT6q
        hAYoCLym0YRizwvbitAGPMr/EuaxUp4+Jm7SAWmjR2e/SFFj+cQpHb+kc5JntUx61WML52
        0usX9vQ4tf/Z9m5WTIs3mXmtrZ5DH8s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-6zxYPKGcMUCll01OHoO_qw-1; Thu, 17 Jun 2021 14:27:58 -0400
X-MC-Unique: 6zxYPKGcMUCll01OHoO_qw-1
Received: by mail-ej1-f71.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso2802368ejc.7
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 11:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6ETG+pltWJSznK09vGdsqaT22gUDBs8M4SpJDfF/cM=;
        b=Y7cpmeq6Ov4anf/9pB/lM0yEgvdAVdqH+XG23MnRzD+kX9b7tBaZQZnwGgPayZDW29
         CwJ2DqDdbcRfBdSW4R+6iogNrRFuS16qJAP7J8rXzFabtEBR8NlCXTznlWNZ873dYrvR
         PGtBtwwsW/ug0B7Ej2xAEFQXI8CdlSPfsx3YWRbMCHnbOGXpOMeWuG3fnNzNAIy/n7K/
         ApILG8UhvrMrbhS8Y9+MdlXAuN5+NxTs2KTlErxxTi1ujGjAjthiU+dCTiFAAmYkOr1p
         5fFQ3nG8OaAsw8JysV/snPNc8bDe+zKIHlSfiOsHoYx7fwdSyUXZN6xSa28nraZxjeWx
         VLfg==
X-Gm-Message-State: AOAM531fTQl3jjjwxXc4rL9m9iBUM0CQWe4mupudm37nRjR7bYp/PDux
        u1lZ8aEAtrB4K9hDoYOKkAJsg+nOvdey5DZM3euouC0rnzyoel8+te/v8pw+gz8BVyv0ububjWG
        i4HKbBYlTPMxv
X-Received: by 2002:a05:6402:1ac9:: with SMTP id ba9mr8717036edb.250.1623954477664;
        Thu, 17 Jun 2021 11:27:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJHulM41GnpU3LPKV/FycrT2wYjnJWy7+ouilV2eeCjMFpGkWTkq0HwedVdZD3/XEJAw8sZg==
X-Received: by 2002:a05:6402:1ac9:: with SMTP id ba9mr8717028edb.250.1623954477485;
        Thu, 17 Jun 2021 11:27:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w1sm4910349eds.37.2021.06.17.11.27.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 11:27:56 -0700 (PDT)
Subject: Re: [PATCH v3 3/3] KVM: x86/mmu: Fix TDP MMU page table level
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org
Cc:     bgardon@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
References: <cover.1623717884.git.kai.huang@intel.com>
 <bcb6569b6e96cb78aaa7b50640e6e6b53291a74e.1623717884.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e53a99c-b2ea-c49e-07d5-e401c1ca5340@redhat.com>
Date:   Thu, 17 Jun 2021 20:27:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <bcb6569b6e96cb78aaa7b50640e6e6b53291a74e.1623717884.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/21 02:57, Kai Huang wrote:
> TDP MMU iterator's level is identical to page table's actual level.  For
> instance, for the last level page table (whose entry points to one 4K
> page), iter->level is 1 (PG_LEVEL_4K), and in case of 5 level paging,
> the iter->level is mmu->shadow_root_level, which is 5.  However, struct
> kvm_mmu_page's level currently is not set correctly when it is allocated
> in kvm_tdp_mmu_map().  When iterator hits non-present SPTE and needs to
> allocate a new child page table, currently iter->level, which is the
> level of the page table where the non-present SPTE belongs to, is used.
> This results in struct kvm_mmu_page's level always having its parent's
> level (excpet root table's level, which is initialized explicitly using
> mmu->shadow_root_level).
> 
> This is kinda wrong, and not consistent with existing non TDP MMU code.
> Fortuantely sp->role.level is only used in handle_removed_tdp_mmu_page()
> and kvm_tdp_mmu_zap_sp(), and they are already aware of this and behave
> correctly.  However to make it consistent with legacy MMU code (and fix
> the issue that both root page table and its child page table have
> shadow_root_level), use iter->level - 1 in kvm_tdp_mmu_map(), and change
> handle_removed_tdp_mmu_page() and kvm_tdp_mmu_zap_sp() accordingly.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
>   arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
>   2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index efb7503ed4d5..4d658882a4d8 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -337,7 +337,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>   
>   	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
>   		sptep = rcu_dereference(pt) + i;
> -		gfn = base_gfn + (i * KVM_PAGES_PER_HPAGE(level - 1));
> +		gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
>   
>   		if (shared) {
>   			/*
> @@ -379,12 +379,12 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>   			WRITE_ONCE(*sptep, REMOVED_SPTE);
>   		}
>   		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> -				    old_child_spte, REMOVED_SPTE, level - 1,
> +				    old_child_spte, REMOVED_SPTE, level,
>   				    shared);
>   	}
>   
>   	kvm_flush_remote_tlbs_with_address(kvm, gfn,
> -					   KVM_PAGES_PER_HPAGE(level));
> +					   KVM_PAGES_PER_HPAGE(level + 1));
>   
>   	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>   }
> @@ -1030,7 +1030,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>   			if (is_removed_spte(iter.old_spte))
>   				break;
>   
> -			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
> +			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
>   			child_pt = sp->spt;
>   
>   			new_spte = make_nonleaf_spte(child_pt,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index f7a7990da11d..408aa49731d5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -31,7 +31,7 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
>   }
>   static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   {
> -	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
> +	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);
>   
>   	/*
>   	 * Don't allow yielding, as the caller may have a flush pending.  Note,
> 

Queued, thanks.

Paolo

