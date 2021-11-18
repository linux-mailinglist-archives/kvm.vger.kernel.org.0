Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DDA4556F2
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 09:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244593AbhKRI34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 03:29:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244588AbhKRI31 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 03:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637223987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9VMfTiHkTF3nZOiS8hS9ax2BxFge20pDcqXYK/sUOoA=;
        b=Gblit5psG3ECIChI6BznPbYOuP/9me8FhoF5DesyBZe8e+57uJPC/rkYpz94s/tLvNYjlD
        6nafssiBDlOHAHSU5kPwzB4FYE9UIl0ENdaZK+etA01Ra/40O1b+Yatd8EbJfXy72IhkH3
        ihERAoAZn7mS/+OOiW6UrGaIumXGbjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-FbkYbfklNxuBdljtieYSDA-1; Thu, 18 Nov 2021 03:26:23 -0500
X-MC-Unique: FbkYbfklNxuBdljtieYSDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC7AEE75C;
        Thu, 18 Nov 2021 08:26:21 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A680A76608;
        Thu, 18 Nov 2021 08:26:00 +0000 (UTC)
Message-ID: <7b8ca1df-f599-100b-aebe-9b6be7532b4e@redhat.com>
Date:   Thu, 18 Nov 2021 09:25:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 06/15] KVM: x86/mmu: Remove need for a vcpu from
 mmu_try_to_unsync_pages
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-7-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211115234603.2908381-7-bgardon@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 00:45, Ben Gardon wrote:
> The vCPU argument to mmu_try_to_unsync_pages is now only used to get a
> pointer to the associated struct kvm, so pass in the kvm pointer from
> the beginning to remove the need for a vCPU when calling the function.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          | 16 ++++++++--------
>   arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>   arch/x86/kvm/mmu/spte.c         |  2 +-
>   3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7d0da79668c0..1e890509b93f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2561,10 +2561,10 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
>   	return r;
>   }
>   
> -static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> +static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>   {
>   	trace_kvm_mmu_unsync_page(sp);
> -	++vcpu->kvm->stat.mmu_unsync;
> +	++kvm->stat.mmu_unsync;
>   	sp->unsync = 1;
>   
>   	kvm_mmu_mark_parents_unsync(sp);
> @@ -2576,7 +2576,7 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>    * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
>    * be write-protected.
>    */
> -int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> +int mmu_try_to_unsync_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
>   			    gfn_t gfn, bool can_unsync, bool prefetch)
>   {
>   	struct kvm_mmu_page *sp;
> @@ -2587,7 +2587,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>   	 * track machinery is used to write-protect upper-level shadow pages,
>   	 * i.e. this guards the role.level == 4K assertion below!
>   	 */
> -	if (kvm_slot_page_track_is_active(vcpu->kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
> +	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
>   		return -EPERM;
>   
>   	/*
> @@ -2596,7 +2596,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>   	 * that case, KVM must complete emulation of the guest TLB flush before
>   	 * allowing shadow pages to become unsync (writable by the guest).
>   	 */
> -	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
> +	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
>   		if (!can_unsync)
>   			return -EPERM;
>   
> @@ -2615,7 +2615,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>   		 */
>   		if (!locked) {
>   			locked = true;
> -			spin_lock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
> +			spin_lock(&kvm->arch.mmu_unsync_pages_lock);
>   
>   			/*
>   			 * Recheck after taking the spinlock, a different vCPU
> @@ -2630,10 +2630,10 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>   		}
>   
>   		WARN_ON(sp->role.level != PG_LEVEL_4K);
> -		kvm_unsync_page(vcpu, sp);
> +		kvm_unsync_page(kvm, sp);
>   	}
>   	if (locked)
> -		spin_unlock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
> +		spin_unlock(&kvm->arch.mmu_unsync_pages_lock);
>   
>   	/*
>   	 * We need to ensure that the marking of unsync pages is visible
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 52c6527b1a06..1073d10cce91 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -118,7 +118,7 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
>   	       kvm_x86_ops.cpu_dirty_log_size;
>   }
>   
> -int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> +int mmu_try_to_unsync_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
>   			    gfn_t gfn, bool can_unsync, bool prefetch);
>   
>   void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 75c666d3e7f1..b7271daa06c5 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -160,7 +160,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   		 * e.g. it's write-tracked (upper-level SPs) or has one or more
>   		 * shadow pages and unsync'ing pages is not allowed.
>   		 */
> -		if (mmu_try_to_unsync_pages(vcpu, slot, gfn, can_unsync, prefetch)) {
> +		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
>   			pgprintk("%s: found shadow page for %llx, marking ro\n",
>   				 __func__, gfn);
>   			wrprot = true;
> 

Queued, thanks.

Paolo

