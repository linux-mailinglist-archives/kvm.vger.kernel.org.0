Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38B1E15FB
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 11:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403899AbfJWJ3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 05:29:37 -0400
Received: from [217.140.110.172] ([217.140.110.172]:45816 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1732648AbfJWJ3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 05:29:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92F5932B;
        Wed, 23 Oct 2019 02:29:09 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CDE23F718;
        Wed, 23 Oct 2019 02:29:08 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:29:07 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 01/15] KVM: Reinstall old memslots if arch preparation
 fails
Message-ID: <20191023092907.GD2652@e113682-lin.lund.arm.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022003537.13013-2-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 05:35:23PM -0700, Sean Christopherson wrote:
> Reinstall the old memslots if preparing the new memory region fails
> after invalidating a to-be-{re}moved memslot.
> 
> Remove the superfluous 'old_memslots' variable so that it's somewhat
> clear that the error handling path needs to free the unused memslots,
> not simply the 'old' memslots.
> 
> Fixes: bc6678a33d9b9 ("KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU update")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ef3f2e19e8..9afd706dc038 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -924,7 +924,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	unsigned long npages;
>  	struct kvm_memory_slot *slot;
>  	struct kvm_memory_slot old, new;
> -	struct kvm_memslots *slots = NULL, *old_memslots;
> +	struct kvm_memslots *slots;
>  	int as_id, id;
>  	enum kvm_mr_change change;
>  
> @@ -1032,7 +1032,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		slot = id_to_memslot(slots, id);
>  		slot->flags |= KVM_MEMSLOT_INVALID;
>  
> -		old_memslots = install_new_memslots(kvm, as_id, slots);
> +		/*
> +		 * We can re-use the old memslots, the only difference from the
> +		 * newly installed memslots is the invalid flag, which will get
> +		 * dropped by update_memslots anyway.  We'll also revert to the
> +		 * old memslots if preparing the new memory region fails.
> +		 */
> +		slots = install_new_memslots(kvm, as_id, slots);
>  
>  		/* From this point no new shadow pages pointing to a deleted,
>  		 * or moved, memslot will be created.
> @@ -1042,13 +1048,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		 *	- kvm_is_visible_gfn (mmu_check_roots)
>  		 */
>  		kvm_arch_flush_shadow_memslot(kvm, slot);
> -
> -		/*
> -		 * We can re-use the old_memslots from above, the only difference
> -		 * from the currently installed memslots is the invalid flag.  This
> -		 * will get overwritten by update_memslots anyway.
> -		 */
> -		slots = old_memslots;
>  	}
>  
>  	r = kvm_arch_prepare_memory_region(kvm, &new, mem, change);
> @@ -1062,15 +1061,17 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	}
>  
>  	update_memslots(slots, &new, change);
> -	old_memslots = install_new_memslots(kvm, as_id, slots);
> +	slots = install_new_memslots(kvm, as_id, slots);
>  
>  	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
>  
>  	kvm_free_memslot(kvm, &old, &new);
> -	kvfree(old_memslots);
> +	kvfree(slots);
>  	return 0;
>  
>  out_slots:
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +		slots = install_new_memslots(kvm, as_id, slots);
>  	kvfree(slots);
>  out_free:
>  	kvm_free_memslot(kvm, &new, &old);
> -- 
> 2.22.0

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
