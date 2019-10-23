Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F98BE15F0
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 11:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390884AbfJWJaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 05:30:02 -0400
Received: from [217.140.110.172] ([217.140.110.172]:45894 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2390870AbfJWJaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 05:30:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B9D41682;
        Wed, 23 Oct 2019 02:29:32 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89D783F718;
        Wed, 23 Oct 2019 02:29:31 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:29:30 +0200
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
Subject: Re: [PATCH v2 12/15] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20191023092930.GG2652@e113682-lin.lund.arm.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-13-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022003537.13013-13-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 05:35:34PM -0700, Sean Christopherson wrote:
> Move the implementations of KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG
> for CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT into common KVM code.
> The arch specific implemenations are extremely similar, differing
> only in whether the dirty log needs to be sync'd from hardware (x86)
> and how the TLBs are flushed.  Add new arch hooks to handle sync
> and TLB flush; the sync will also be used for non-generic dirty log
> support in a future patch (s390).
> 
> The ulterior motive for providing a common implementation is to
> eliminate the dependency between arch and common code with respect to
> the memslot referenced by the dirty log, i.e. to make it obvious in the
> code that the validity of the memslot is guaranteed, as a future patch
> will rework memslot handling such that id_to_memslot() can return NULL.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

For the Arm parts:

Acked-by: Christoffer Dall <christoffer.dall@arm.com>

> ---
>  arch/mips/kvm/mips.c      | 62 ++---------------------------
>  arch/powerpc/kvm/book3s.c |  5 +++
>  arch/powerpc/kvm/booke.c  |  5 +++
>  arch/s390/kvm/kvm-s390.c  |  5 +--
>  arch/x86/kvm/x86.c        | 60 ++--------------------------
>  include/linux/kvm_host.h  | 20 ++++------
>  virt/kvm/arm/arm.c        | 47 ++--------------------
>  virt/kvm/kvm_main.c       | 84 ++++++++++++++++++++++++++++++++-------
>  8 files changed, 99 insertions(+), 189 deletions(-)
> 
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 713e5465edb0..5c4feeeee447 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -965,69 +965,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl,
>  	return r;
>  }
>  
> -/**
> - * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
> - * @kvm: kvm instance
> - * @log: slot id and address to which we copy the log
> - *
> - * Steps 1-4 below provide general overview of dirty page logging. See
> - * kvm_get_dirty_log_protect() function description for additional details.
> - *
> - * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
> - * always flush the TLB (step 4) even if previous step failed  and the dirty
> - * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
> - * does not preclude user space subsequent dirty log read. Flushing TLB ensures
> - * writes will be marked dirty for next log read.
> - *
> - *   1. Take a snapshot of the bit and clear it if needed.
> - *   2. Write protect the corresponding page.
> - *   3. Copy the snapshot to the userspace.
> - *   4. Flush TLB's if needed.
> - */
> -int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
> -	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
> -	bool flush = false;
> -	int r;
>  
> -	mutex_lock(&kvm->slots_lock);
> -
> -	r = kvm_get_dirty_log_protect(kvm, log, &flush);
> -
> -	if (flush) {
> -		slots = kvm_memslots(kvm);
> -		memslot = id_to_memslot(slots, log->slot);
> -
> -		/* Let implementation handle TLB/GVA invalidation */
> -		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> -	}
> -
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
>  }
>  
> -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
> -	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
> -	bool flush = false;
> -	int r;
> -
> -	mutex_lock(&kvm->slots_lock);
> -
> -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> -
> -	if (flush) {
> -		slots = kvm_memslots(kvm);
> -		memslot = id_to_memslot(slots, log->slot);
> -
> -		/* Let implementation handle TLB/GVA invalidation */
> -		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> -	}
> -
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
> +	/* Let implementation handle TLB/GVA invalidation */
> +	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
>  }
>  
>  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index a5d4a1014fdf..84f66c1592a3 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -829,6 +829,11 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
>  	return vcpu->kvm->arch.kvm_ops->check_requests(vcpu);
>  }
>  
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> +{
> +
> +}
> +
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
>  {
>  	return kvm->arch.kvm_ops->get_dirty_log(kvm, log);
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index a22ff567724a..35a4ef89a1db 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -1796,6 +1796,11 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> +{
> +
> +}
> +
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
>  {
>  	return -ENOTSUPP;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 21f61dae7db1..c0e9929bdb34 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -572,8 +572,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return r;
>  }
>  
> -static void kvm_s390_sync_dirty_log(struct kvm *kvm,
> -				    struct kvm_memory_slot *memslot)
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
>  	int i;
>  	gfn_t cur_gfn, last_gfn;
> @@ -633,7 +632,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  	if (!memslot->dirty_bitmap)
>  		goto out;
>  
> -	kvm_s390_sync_dirty_log(kvm, memslot);
> +	kvm_arch_sync_dirty_log(kvm, memslot);
>  	r = kvm_get_dirty_log(kvm, log, &is_dirty);
>  	if (r)
>  		goto out;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index adf384ef5969..3d3d70aac031 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4615,77 +4615,23 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
>  	return 0;
>  }
>  
> -/**
> - * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
> - * @kvm: kvm instance
> - * @log: slot id and address to which we copy the log
> - *
> - * Steps 1-4 below provide general overview of dirty page logging. See
> - * kvm_get_dirty_log_protect() function description for additional details.
> - *
> - * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
> - * always flush the TLB (step 4) even if previous step failed  and the dirty
> - * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
> - * does not preclude user space subsequent dirty log read. Flushing TLB ensures
> - * writes will be marked dirty for next log read.
> - *
> - *   1. Take a snapshot of the bit and clear it if needed.
> - *   2. Write protect the corresponding page.
> - *   3. Copy the snapshot to the userspace.
> - *   4. Flush TLB's if needed.
> - */
> -int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
> -	bool flush = false;
> -	int r;
> -
> -	mutex_lock(&kvm->slots_lock);
> -
>  	/*
>  	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
>  	 */
>  	if (kvm_x86_ops->flush_log_dirty)
>  		kvm_x86_ops->flush_log_dirty(kvm);
> -
> -	r = kvm_get_dirty_log_protect(kvm, log, &flush);
> -
> -	/*
> -	 * All the TLBs can be flushed out of mmu lock, see the comments in
> -	 * kvm_mmu_slot_remove_write_access().
> -	 */
> -	lockdep_assert_held(&kvm->slots_lock);
> -	if (flush)
> -		kvm_flush_remote_tlbs(kvm);
> -
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
>  }
>  
> -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
> -	bool flush = false;
> -	int r;
> -
> -	mutex_lock(&kvm->slots_lock);
> -
> -	/*
> -	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
> -	 */
> -	if (kvm_x86_ops->flush_log_dirty)
> -		kvm_x86_ops->flush_log_dirty(kvm);
> -
> -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> -
>  	/*
>  	 * All the TLBs can be flushed out of mmu lock, see the comments in
>  	 * kvm_mmu_slot_remove_write_access().
>  	 */
>  	lockdep_assert_held(&kvm->slots_lock);
> -	if (flush)
> -		kvm_flush_remote_tlbs(kvm);
> -
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
> +	kvm_flush_remote_tlbs(kvm);
>  }
>  
>  int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index bfb8194d0366..80dd823a1a8b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -797,23 +797,19 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
>  
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
>  
> -int kvm_get_dirty_log(struct kvm *kvm,
> -			struct kvm_dirty_log *log, int *is_dirty);
> -
> -int kvm_get_dirty_log_protect(struct kvm *kvm,
> -			      struct kvm_dirty_log *log, bool *flush);
> -int kvm_clear_dirty_log_protect(struct kvm *kvm,
> -				struct kvm_clear_dirty_log *log, bool *flush);
> -
>  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  					struct kvm_memory_slot *slot,
>  					gfn_t gfn_offset,
>  					unsigned long mask);
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
>  
> -int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
> -				struct kvm_dirty_log *log);
> -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
> -				  struct kvm_clear_dirty_log *log);
> +#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm, struct kvm_memory_slot *slot);
> +#else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
> +int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
> +int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> +		      int *is_dirty);
> +#endif
>  
>  int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>  			bool line_status);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 86c6aa1cb58e..03f668e812ea 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1203,55 +1203,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	return r;
>  }
>  
> -/**
> - * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
> - * @kvm: kvm instance
> - * @log: slot id and address to which we copy the log
> - *
> - * Steps 1-4 below provide general overview of dirty page logging. See
> - * kvm_get_dirty_log_protect() function description for additional details.
> - *
> - * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
> - * always flush the TLB (step 4) even if previous step failed  and the dirty
> - * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
> - * does not preclude user space subsequent dirty log read. Flushing TLB ensures
> - * writes will be marked dirty for next log read.
> - *
> - *   1. Take a snapshot of the bit and clear it if needed.
> - *   2. Write protect the corresponding page.
> - *   3. Copy the snapshot to the userspace.
> - *   4. Flush TLB's if needed.
> - */
> -int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
> -	bool flush = false;
> -	int r;
>  
> -	mutex_lock(&kvm->slots_lock);
> -
> -	r = kvm_get_dirty_log_protect(kvm, log, &flush);
> -
> -	if (flush)
> -		kvm_flush_remote_tlbs(kvm);
> -
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
>  }
>  
> -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
> -	bool flush = false;
> -	int r;
> -
> -	mutex_lock(&kvm->slots_lock);
> -
> -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> -
> -	if (flush)
> -		kvm_flush_remote_tlbs(kvm);
> -
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
> +	kvm_flush_remote_tlbs(kvm);
>  }
>  
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c3e481986099..c0ce5081dd00 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -781,7 +781,7 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>  
>  /*
>   * Allocation size is twice as large as the actual dirty bitmap size.
> - * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
> + * See kvm_vm_ioctl_get_dirty_log() why this is needed.
>   */
>  static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
>  {
> @@ -1123,6 +1123,7 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
>  	return kvm_set_memory_region(kvm, mem);
>  }
>  
> +#ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  int kvm_get_dirty_log(struct kvm *kvm,
>  			struct kvm_dirty_log *log, int *is_dirty)
>  {
> @@ -1156,13 +1157,12 @@ int kvm_get_dirty_log(struct kvm *kvm,
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
>  
> -#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +#else /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>  /**
>   * kvm_get_dirty_log_protect - get a snapshot of dirty pages
>   *	and reenable dirty page tracking for the corresponding pages.
>   * @kvm:	pointer to kvm instance
>   * @log:	slot id and address to which we copy the log
> - * @flush:	true if TLB flush is needed by caller
>   *
>   * We need to keep it in mind that VCPU threads can write to the bitmap
>   * concurrently. So, to avoid losing track of dirty pages we keep the
> @@ -1179,8 +1179,7 @@ EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
>   * exiting to userspace will be logged for the next call.
>   *
>   */
> -int kvm_get_dirty_log_protect(struct kvm *kvm,
> -			struct kvm_dirty_log *log, bool *flush)
> +static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
>  {
>  	struct kvm_memslots *slots;
>  	struct kvm_memory_slot *memslot;
> @@ -1188,6 +1187,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
>  	unsigned long n;
>  	unsigned long *dirty_bitmap;
>  	unsigned long *dirty_bitmap_buffer;
> +	bool flush;
>  
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
> @@ -1201,8 +1201,10 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
>  	if (!dirty_bitmap)
>  		return -ENOENT;
>  
> +	kvm_arch_sync_dirty_log(kvm, memslot);
> +
>  	n = kvm_dirty_bitmap_bytes(memslot);
> -	*flush = false;
> +	flush = false;
>  	if (kvm->manual_dirty_log_protect) {
>  		/*
>  		 * Unlike kvm_get_dirty_log, we always return false in *flush,
> @@ -1225,7 +1227,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
>  			if (!dirty_bitmap[i])
>  				continue;
>  
> -			*flush = true;
> +			flush = true;
>  			mask = xchg(&dirty_bitmap[i], 0);
>  			dirty_bitmap_buffer[i] = mask;
>  
> @@ -1236,21 +1238,55 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
>  		spin_unlock(&kvm->mmu_lock);
>  	}
>  
> +	if (flush)
> +		kvm_arch_dirty_log_tlb_flush(kvm, memslot);
> +
>  	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
>  		return -EFAULT;
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(kvm_get_dirty_log_protect);
> +
> +
> +/**
> + * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
> + * @kvm: kvm instance
> + * @log: slot id and address to which we copy the log
> + *
> + * Steps 1-4 below provide general overview of dirty page logging. See
> + * kvm_get_dirty_log_protect() function description for additional details.
> + *
> + * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
> + * always flush the TLB (step 4) even if previous step failed  and the dirty
> + * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
> + * does not preclude user space subsequent dirty log read. Flushing TLB ensures
> + * writes will be marked dirty for next log read.
> + *
> + *   1. Take a snapshot of the bit and clear it if needed.
> + *   2. Write protect the corresponding page.
> + *   3. Copy the snapshot to the userspace.
> + *   4. Flush TLB's if needed.
> + */
> +static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
> +				      struct kvm_dirty_log *log)
> +{
> +	int r;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	r = kvm_get_dirty_log_protect(kvm, log);
> +
> +	mutex_unlock(&kvm->slots_lock);
> +	return r;
> +}
>  
>  /**
>   * kvm_clear_dirty_log_protect - clear dirty bits in the bitmap
>   *	and reenable dirty page tracking for the corresponding pages.
>   * @kvm:	pointer to kvm instance
>   * @log:	slot id and address from which to fetch the bitmap of dirty pages
> - * @flush:	true if TLB flush is needed by caller
>   */
> -int kvm_clear_dirty_log_protect(struct kvm *kvm,
> -				struct kvm_clear_dirty_log *log, bool *flush)
> +static int kvm_clear_dirty_log_protect(struct kvm *kvm,
> +				       struct kvm_clear_dirty_log *log)
>  {
>  	struct kvm_memslots *slots;
>  	struct kvm_memory_slot *memslot;
> @@ -1259,6 +1295,7 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  	unsigned long i, n;
>  	unsigned long *dirty_bitmap;
>  	unsigned long *dirty_bitmap_buffer;
> +	bool flush;
>  
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
> @@ -1282,7 +1319,9 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
>  	    return -EINVAL;
>  
> -	*flush = false;
> +	kvm_arch_sync_dirty_log(kvm, memslot);
> +
> +	flush = false;
>  	dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
>  	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
>  		return -EFAULT;
> @@ -1305,17 +1344,32 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  		 * a problem if userspace sets them in log->dirty_bitmap.
>  		*/
>  		if (mask) {
> -			*flush = true;
> +			flush = true;
>  			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
>  								offset, mask);
>  		}
>  	}
>  	spin_unlock(&kvm->mmu_lock);
>  
> +	if (flush)
> +		kvm_arch_dirty_log_tlb_flush(kvm, memslot);
> +
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(kvm_clear_dirty_log_protect);
> -#endif
> +
> +static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
> +					struct kvm_clear_dirty_log *log)
> +{
> +	int r;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	r = kvm_clear_dirty_log_protect(kvm, log);
> +
> +	mutex_unlock(&kvm->slots_lock);
> +	return r;
> +}
> +#endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>  
>  bool kvm_largepages_enabled(void)
>  {
> -- 
> 2.22.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
