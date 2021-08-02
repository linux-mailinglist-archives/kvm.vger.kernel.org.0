Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16813DDBB0
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 16:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhHBO6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 10:58:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233981AbhHBO6y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 10:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627916325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5eSq/Oh9tuy6oQIyaKCjPjo8c+CPqQbNuxdiVHvRMVo=;
        b=SlEX6Hn2gXV6wMXiRKAwORVdj3x0ZkR0tK8Z20Zh34XDLbE2trgQj7iPWeRAJSLTBifps0
        UCRcgoTKR6NHtcxfcKZAtK9O/5jsIrBZSFBPOXnFEeZF0PrEp64KMED7Iv392lPkLTpA7m
        z0c9du+lS3JYbSMzcUBPt6MblcNU/ME=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-E5yWxhk_NjCiRydLwzVj4g-1; Mon, 02 Aug 2021 10:58:43 -0400
X-MC-Unique: E5yWxhk_NjCiRydLwzVj4g-1
Received: by mail-wr1-f70.google.com with SMTP id d7-20020adffd870000b02901544ea2018fso3464476wrr.10
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 07:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5eSq/Oh9tuy6oQIyaKCjPjo8c+CPqQbNuxdiVHvRMVo=;
        b=OcCoUvEJBa37VtzhH8CH5haJNUQ0U2LmdKddO4GXXut3m4QTVr/0J9s1uPUhvpvFtE
         pTD8WWI09kBJIQzQIToEDZvSBxkHxihp4UWoaDEI3sBPXJzo8/1N8NpnPlpN6okz51mC
         j9TG96DuwK7UnJb9kO47RXlCeTuFSFay0wfsGYzo6zqV1PkmvyR//lYTN8jDnfXHus8E
         SAZ8z+3etZz67RnuxVzcaSWlP2Jd6911cIImoSpwIpTU1fxYHl0ALnWDLPIsoQpndLL4
         T9wSrXQ8X95oX6it9FBDz8nwV9uZS4QQHJJ39X6lz4CGH7rFPY3YQoRj3X1oloXlwh/U
         kN9A==
X-Gm-Message-State: AOAM530G3EKz1IxBU3Lb036e7OmKMvAEtEse+4mCDHYADR/0jgiaIkUd
        40c/IrUq6FNGe5FgTwD1toINcL5ujAqhP/EzycOUPiP4T2iS+oJLLZa1HdAmvvXyqMiw3r/uJDN
        UN/bbfqJINYn7
X-Received: by 2002:adf:c3c5:: with SMTP id d5mr18349969wrg.76.1627916322604;
        Mon, 02 Aug 2021 07:58:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzi6i3/Qn2OD1G4drXJSDwsTCQ0oaBhfVFFXfohM/YFT3vwMByQf7BIvduNgZo0OIo2R/OAcA==
X-Received: by 2002:adf:c3c5:: with SMTP id d5mr18349950wrg.76.1627916322437;
        Mon, 02 Aug 2021 07:58:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 9sm10312818wmf.34.2021.08.02.07.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:58:41 -0700 (PDT)
Subject: Re: [PATCH 4/6] KVM: x86/mmu: Leverage vcpu->lru_slot_index for
 rmap_add and rmap_recycle
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210730223707.4083785-1-dmatlack@google.com>
 <20210730223707.4083785-5-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9f849ffb-3758-b71c-9220-b1f370352825@redhat.com>
Date:   Mon, 2 Aug 2021 16:58:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730223707.4083785-5-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/21 00:37, David Matlack wrote:
> rmap_add() and rmap_recycle() both run in the context of the vCPU and
> thus we can use kvm_vcpu_gfn_to_memslot() to look up the memslot. This
> enables rmap_add() and rmap_recycle() to take advantage of
> vcpu->lru_slot_index and avoid expensive memslot searching.
> 
> This change improves the performance of "Populate memory time" in
> dirty_log_perf_test with tdp_mmu=N. In addition to improving the
> performance, "Populate memory time" no longer scales with the number
> of memslots in the VM.
> 
> Command                         | Before           | After
> ------------------------------- | ---------------- | -------------
> ./dirty_log_perf_test -v64 -x1  | 15.18001570s     | 14.99469366s
> ./dirty_log_perf_test -v64 -x64 | 18.71336392s     | 14.98675076s
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 35 ++++++++++++++++++++---------------
>   1 file changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a8cdfd8d45c4..370a6ebc2ede 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1043,17 +1043,6 @@ static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
>   	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
>   }
>   
> -static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
> -					 struct kvm_mmu_page *sp)
> -{
> -	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *slot;
> -
> -	slots = kvm_memslots_for_spte_role(kvm, sp->role);
> -	slot = __gfn_to_memslot(slots, gfn);
> -	return __gfn_to_rmap(gfn, sp->role.level, slot);
> -}
> -
>   static bool rmap_can_add(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_mmu_memory_cache *mc;
> @@ -1064,24 +1053,39 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
>   
>   static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
>   {
> +	struct kvm_memory_slot *slot;
>   	struct kvm_mmu_page *sp;
>   	struct kvm_rmap_head *rmap_head;
>   
>   	sp = sptep_to_sp(spte);
>   	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
> -	rmap_head = gfn_to_rmap(vcpu->kvm, gfn, sp);
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
>   	return pte_list_add(vcpu, spte, rmap_head);
>   }
>   
> +
>   static void rmap_remove(struct kvm *kvm, u64 *spte)
>   {
> +	struct kvm_memslots *slots;
> +	struct kvm_memory_slot *slot;
>   	struct kvm_mmu_page *sp;
>   	gfn_t gfn;
>   	struct kvm_rmap_head *rmap_head;
>   
>   	sp = sptep_to_sp(spte);
>   	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
> -	rmap_head = gfn_to_rmap(kvm, gfn, sp);
> +
> +	/*
> +	 * Unlike rmap_add and rmap_recycle, rmap_remove does not run in the
> +	 * context of a vCPU so have to determine which memslots to use based
> +	 * on context information in sp->role.
> +	 */
> +	slots = kvm_memslots_for_spte_role(kvm, sp->role);
> +
> +	slot = __gfn_to_memslot(slots, gfn);
> +	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
> +
>   	__pte_list_remove(spte, rmap_head);
>   }
>   
> @@ -1628,12 +1632,13 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>   
>   static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
>   {
> +	struct kvm_memory_slot *slot;
>   	struct kvm_rmap_head *rmap_head;
>   	struct kvm_mmu_page *sp;
>   
>   	sp = sptep_to_sp(spte);
> -
> -	rmap_head = gfn_to_rmap(vcpu->kvm, gfn, sp);
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
>   
>   	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
>   	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
> 

