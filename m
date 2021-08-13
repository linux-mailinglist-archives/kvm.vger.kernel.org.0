Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38303EB191
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbhHMHhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:37:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239486AbhHMHhB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628840195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0GudUQwxoRGaM8Ug8csU9EG508ZlzE+xcxQopbBunHk=;
        b=DE9qEpI3KN/8w//QQ0gNBR3z3U2KNhi+SxwSBcqwuWDH+838sorrU1m4XCIv0NgIa6lmsC
        ajV6oMax/AKybndqwwaRZTYuXr3en8Vcu9sW3bG2RXnawg9mOI9hRZrNsD780T8wU9ZkS6
        dclYK29GGYM4WyV/gkJMLEOeQUrMnI8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-vOnOM-QbOXiDDEWzOYn2Kg-1; Fri, 13 Aug 2021 03:36:33 -0400
X-MC-Unique: vOnOM-QbOXiDDEWzOYn2Kg-1
Received: by mail-ej1-f70.google.com with SMTP id h13-20020a1709062dcdb02905aec576a827so2651714eji.23
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 00:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0GudUQwxoRGaM8Ug8csU9EG508ZlzE+xcxQopbBunHk=;
        b=dalmVUZ4jb5ZwCVN4t1JZc1XR3qMuZKmnfqn3e+54pcT/4SnJQC7MrfPlHdMoDDHpz
         u2zbp2nYAPyDpAApHK+pXJjwOdZ6DzA7WVN84fIVFAC5HYKDCIwTapFUH9K1vPDZuX7d
         0JAfH6hVS9OADHMxGfT5Sv5lwY3jiufXrlhlVlR3uTB37XsnYSMdQYm3D0fz3E8lyK1Y
         AytIAHZgbgEm9Ep+Eo3/9km+bpmmm97GXF/dxh/imEpEshKxQIxCXow70n3WZxRAd1uu
         Q73MTjhE9ESH/C2hUy6+/JKk1b7zKyAEePd7/YLXHQR7yJUkKqlx8aM1gxTj3Y3galK6
         kxfA==
X-Gm-Message-State: AOAM533PYSfg2HOXPBQ38tc6fz8oSqs3bxxUZG6s4fcHjMfFdSJmenfr
        MNWR9gJXgI3XAWg6Sf0OsPhO5hukdhNtMI2TKBPO8M0bf2e+63TcCgxrlBr5EkoVQYzEGyfj7d/
        5kwNwP4MR+ccG
X-Received: by 2002:aa7:ce87:: with SMTP id y7mr1433535edv.306.1628840192585;
        Fri, 13 Aug 2021 00:36:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwx3+/UqdrAF2yU81a3Rs+lfogK6oq62/3Ts4GudcXjfrDMq6m+WjBytrWf29miY8SiWOaS4g==
X-Received: by 2002:aa7:ce87:: with SMTP id y7mr1433509edv.306.1628840192356;
        Fri, 13 Aug 2021 00:36:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r27sm454935edb.66.2021.08.13.00.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 00:36:31 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86/mmu: Protect marking SPs unsync when using
 TDP MMU with spinlock
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210812181815.3378104-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2476ccf6-1542-c7ad-993b-7d1f703d390e@redhat.com>
Date:   Fri, 13 Aug 2021 09:36:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812181815.3378104-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/21 20:18, Sean Christopherson wrote:
> Add yet another spinlock for the TDP MMU and take it when marking indirect
> shadow pages unsync.  When using the TDP MMU and L1 is running L2(s) with
> nested TDP, KVM may encounter shadow pages for the TDP entries managed by
> L1 (controlling L2) when handling a TDP MMU page fault.  The unsync logic
> is not thread safe, e.g. the kvm_mmu_page fields are not atomic, and
> misbehaves when a shadow page is marked unsync via a TDP MMU page fault,
> which runs with mmu_lock held for read, not write.
> 
> Lack of a critical section manifests most visibly as an underflow of
> unsync_children in clear_unsync_child_bit() due to unsync_children being
> corrupted when multiple CPUs write it without a critical section and
> without atomic operations.  But underflow is the best case scenario.  The
> worst case scenario is that unsync_children prematurely hits '0' and
> leads to guest memory corruption due to KVM neglecting to properly sync
> shadow pages.
> 
> Use an entirely new spinlock even though piggybacking tdp_mmu_pages_lock
> would functionally be ok.  Usurping the lock could degrade performance when
> building upper level page tables on different vCPUs, especially since the
> unsync flow could hold the lock for a comparatively long time depending on
> the number of indirect shadow pages and the depth of the paging tree.
> 
> For simplicity, take the lock for all MMUs, even though KVM could fairly
> easily know that mmu_lock is held for write.  If mmu_lock is held for
> write, there cannot be contention for the inner spinlock, and marking
> shadow pages unsync across multiple vCPUs will be slow enough that
> bouncing the kvm_arch cacheline should be in the noise.
> 
> Note, even though L2 could theoretically be given access to its own EPT
> entries, a nested MMU must hold mmu_lock for write and thus cannot race
> against a TDP MMU page fault.  I.e. the additional spinlock only _needs_ to
> be taken by the TDP MMU, as opposed to being taken by any MMU for a VM
> that is running with the TDP MMU enabled.  Holding mmu_lock for read also
> prevents the indirect shadow page from being freed.  But as above, keep
> it simple and always take the lock.
> 
> Alternative #1, the TDP MMU could simply pass "false" for can_unsync and
> effectively disable unsync behavior for nested TDP.  Write protecting leaf
> shadow pages is unlikely to noticeably impact traditional L1 VMMs, as such
> VMMs typically don't modify TDP entries, but the same may not hold true for
> non-standard use cases and/or VMMs that are migrating physical pages (from
> L1's perspective).
> 
> Alternative #2, the unsync logic could be made thread safe.  In theory,
> simply converting all relevant kvm_mmu_page fields to atomics and using
> atomic bitops for the bitmap would suffice.  However, (a) an in-depth audit
> would be required, (b) the code churn would be substantial, and (c) legacy
> shadow paging would incur additional atomic operations in performance
> sensitive paths for no benefit (to legacy shadow paging).
> 
> Fixes: a2855afc7ee8 ("KVM: x86/mmu: Allow parallel page faults for the TDP MMU")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   Documentation/virt/kvm/locking.rst |  8 ++++----
>   arch/x86/include/asm/kvm_host.h    |  7 +++++++
>   arch/x86/kvm/mmu/mmu.c             | 28 ++++++++++++++++++++++++++++
>   3 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index 8138201efb09..5d27da356836 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -31,10 +31,10 @@ On x86:
>   
>   - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
>   
> -- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock is
> -  taken inside kvm->arch.mmu_lock, and cannot be taken without already
> -  holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
> -  there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
> +- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
> +  kvm->arch.mmu_unsync_pages_lock are taken inside kvm->arch.mmu_lock, and
> +  cannot be taken without already holding kvm->arch.mmu_lock (typically with
> +  ``read_lock`` for the TDP MMU, thus the need for additional spinlocks).
>   
>   Everything else is a leaf: no other lock is taken inside the critical
>   sections.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 20daaf67a5bf..cf32b87b6bd3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1036,6 +1036,13 @@ struct kvm_arch {
>   	struct list_head lpage_disallowed_mmu_pages;
>   	struct kvm_page_track_notifier_node mmu_sp_tracker;
>   	struct kvm_page_track_notifier_head track_notifier_head;
> +	/*
> +	 * Protects marking pages unsync during page faults, as TDP MMU page
> +	 * faults only take mmu_lock for read.  For simplicity, the unsync
> +	 * pages lock is always taken when marking pages unsync regardless of
> +	 * whether mmu_lock is held for read or write.
> +	 */
> +	spinlock_t mmu_unsync_pages_lock;
>   
>   	struct list_head assigned_dev_head;
>   	struct iommu_domain *iommu_domain;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a272ccbddfa1..cef526dac730 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2596,6 +2596,7 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
>   {
>   	struct kvm_mmu_page *sp;
> +	bool locked = false;
>   
>   	/*
>   	 * Force write-protection if the page is being tracked.  Note, the page
> @@ -2618,9 +2619,34 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
>   		if (sp->unsync)
>   			continue;
>   
> +		/*
> +		 * TDP MMU page faults require an additional spinlock as they
> +		 * run with mmu_lock held for read, not write, and the unsync
> +		 * logic is not thread safe.  Take the spinklock regardless of
> +		 * the MMU type to avoid extra conditionals/parameters, there's
> +		 * no meaningful penalty if mmu_lock is held for write.
> +		 */
> +		if (!locked) {
> +			locked = true;
> +			spin_lock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
> +
> +			/*
> +			 * Recheck after taking the spinlock, a different vCPU
> +			 * may have since marked the page unsync.  A false
> +			 * positive on the unprotected check above is not
> +			 * possible as clearing sp->unsync _must_ hold mmu_lock
> +			 * for write, i.e. unsync cannot transition from 0->1
> +			 * while this CPU holds mmu_lock for read (or write).
> +			 */
> +			if (READ_ONCE(sp->unsync))
> +				continue;
> +		}
> +
>   		WARN_ON(sp->role.level != PG_LEVEL_4K);
>   		kvm_unsync_page(vcpu, sp);
>   	}
> +	if (locked)
> +		spin_unlock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
>   
>   	/*
>   	 * We need to ensure that the marking of unsync pages is visible
> @@ -5604,6 +5630,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>   {
>   	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
>   
> +	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
> +
>   	if (!kvm_mmu_init_tdp_mmu(kvm))
>   		/*
>   		 * No smp_load/store wrappers needed here as we are in
> 

Queued, thanks.

Paolo

