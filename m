Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C6A135E47
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387653AbgAIQ3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:29:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27467 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728840AbgAIQ3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 11:29:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578587380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=joT3+DxfzgdbRFzmUTzPn2j4/DYUC+tWYCVvFAVt+qs=;
        b=MGKXkP3Hy4/uEdaJvrixfUrpCVwev2NQ0yPScSHuEVcnge75aAlLNCdqkSXNMIhLfgILcv
        oasFpd8N7aoppTSVQmGjNn9MTT+kT+ugAE/BRAKZq0m5CJ9cP3dbjaiaMbivL1xrqVOImh
        5nd5/y/mAZvUeWth6ifFb8Q9ibkezUI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-qOe4R56oMrSQWQdl2452ew-1; Thu, 09 Jan 2020 11:29:39 -0500
X-MC-Unique: qOe4R56oMrSQWQdl2452ew-1
Received: by mail-qt1-f200.google.com with SMTP id k27so4519917qtu.12
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 08:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=joT3+DxfzgdbRFzmUTzPn2j4/DYUC+tWYCVvFAVt+qs=;
        b=mZUpxhk+J7SDdGpewCxdD2rtNZQklynTQ0aeiret39SbnwpJkFclE3ad5BAbOP2iDR
         cRFZwZTi2ab/9/3gAAPOZVQ9Lbt1BHjW49hcm/ZUifwbef9yJj5VLvss5prT8ajqvSVq
         5vxtE3thcuL6fnAIiHF+c5v8nDK+B4Z3vIahx1xDr4676LzyQQY/0ffo4hvOUhQNqN61
         W4OAQelevjYPf2Y6cMHvFDR78Ol33EFFJMk9Eu76TSlip8+jUhyoRsCcyxvw9faS0wkE
         cn6uZw8AMF0HQfbJEyzVFXLBeeKZKi+0LdReOVy04CDdH4u7KxOmdJfXr4wYowXOFZzx
         dRZg==
X-Gm-Message-State: APjAAAX1YNZxOd0UWmL1+3T3MrjHa6nL7cQRwLzbkFSONSqJVK8ylynS
        xAUXgRfCPdAMKCxcHdcWGRRPbAdVeOfM4lxT0AeuzmTVVHfSZCtHgCaQ3sA/D6DN58RxGcWgD32
        ch7gu8h32JGGe
X-Received: by 2002:a0c:8bd2:: with SMTP id a18mr9513539qvc.38.1578587376691;
        Thu, 09 Jan 2020 08:29:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqxqTyX+zvLsUBbJzsQ2ICT1iIyaaa7Dp4WQ5N0oShRpIR9uAZgI6Pb7PMl0xLyxbgUfT0fSWw==
X-Received: by 2002:a0c:8bd2:: with SMTP id a18mr9513500qvc.38.1578587375884;
        Thu, 09 Jan 2020 08:29:35 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id i6sm3245100qkk.7.2020.01.09.08.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 08:29:34 -0800 (PST)
Date:   Thu, 9 Jan 2020 11:29:28 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200109110110-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109145729.32898-13-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 09:57:20AM -0500, Peter Xu wrote:
> This patch is heavily based on previous work from Lei Cao
> <lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]
> 
> KVM currently uses large bitmaps to track dirty memory.  These bitmaps
> are copied to userspace when userspace queries KVM for its dirty page
> information.  The use of bitmaps is mostly sufficient for live
> migration, as large parts of memory are be dirtied from one log-dirty
> pass to another.  However, in a checkpointing system, the number of
> dirty pages is small and in fact it is often bounded---the VM is
> paused when it has dirtied a pre-defined number of pages. Traversing a
> large, sparsely populated bitmap to find set bits is time-consuming,
> as is copying the bitmap to user-space.
> 
> A similar issue will be there for live migration when the guest memory
> is huge while the page dirty procedure is trivial.  In that case for
> each dirty sync we need to pull the whole dirty bitmap to userspace
> and analyse every bit even if it's mostly zeros.
> 
> The preferred data structure for above scenarios is a dense list of
> guest frame numbers (GFN).

No longer, this uses an array of structs.

>  This patch series stores the dirty list in
> kernel memory that can be memory mapped into userspace to allow speedy
> harvesting.
> 
> This patch enables dirty ring for X86 only.  However it should be
> easily extended to other archs as well.
> 
> [1] https://patchwork.kernel.org/patch/10471409/
> 
> Signed-off-by: Lei Cao <lei.cao@stratus.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  Documentation/virt/kvm/api.txt  |  89 ++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |   3 +
>  arch/x86/include/uapi/asm/kvm.h |   1 +
>  arch/x86/kvm/Makefile           |   3 +-
>  arch/x86/kvm/mmu/mmu.c          |   6 ++
>  arch/x86/kvm/vmx/vmx.c          |   7 ++
>  arch/x86/kvm/x86.c              |   9 ++
>  include/linux/kvm_dirty_ring.h  |  55 +++++++++++
>  include/linux/kvm_host.h        |  26 +++++
>  include/trace/events/kvm.h      |  78 +++++++++++++++
>  include/uapi/linux/kvm.h        |  33 +++++++
>  virt/kvm/dirty_ring.c           | 162 ++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c             | 137 ++++++++++++++++++++++++++-
>  13 files changed, 606 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/kvm_dirty_ring.h
>  create mode 100644 virt/kvm/dirty_ring.c
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index ebb37b34dcfc..708c3e0f7eae 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -231,6 +231,7 @@ Based on their initialization different VMs may have different capabilities.
>  It is thus encouraged to use the vm ioctl to query for capabilities (available
>  with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
>  
> +
>  4.5 KVM_GET_VCPU_MMAP_SIZE
>  
>  Capability: basic
> @@ -243,6 +244,18 @@ The KVM_RUN ioctl (cf.) communicates with userspace via a shared
>  memory region.  This ioctl returns the size of that region.  See the
>  KVM_RUN documentation for details.
>  
> +Besides the size of the KVM_RUN communication region, other areas of
> +the VCPU file descriptor can be mmap-ed, including:
> +
> +- if KVM_CAP_COALESCED_MMIO is available, a page at
> +  KVM_COALESCED_MMIO_PAGE_OFFSET * PAGE_SIZE; for historical reasons,
> +  this page is included in the result of KVM_GET_VCPU_MMAP_SIZE.
> +  KVM_CAP_COALESCED_MMIO is not documented yet.
> +
> +- if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
> +  KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE.  For more information on
> +  KVM_CAP_DIRTY_LOG_RING, see section 8.3.
> +
>  
>  4.6 KVM_SET_MEMORY_REGION
>  
> @@ -5376,6 +5389,7 @@ CPU when the exception is taken. If this virtual SError is taken to EL1 using
>  AArch64, this value will be reported in the ISS field of ESR_ELx.
>  
>  See KVM_CAP_VCPU_EVENTS for more details.
> +
>  8.20 KVM_CAP_HYPERV_SEND_IPI
>  
>  Architectures: x86
> @@ -5383,6 +5397,7 @@ Architectures: x86
>  This capability indicates that KVM supports paravirtualized Hyper-V IPI send
>  hypercalls:
>  HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
> +
>  8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
>  
>  Architecture: x86
> @@ -5396,3 +5411,77 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
>  flush hypercalls by Hyper-V) so userspace should disable KVM identification
>  in CPUID and only exposes Hyper-V identification. In this case, guest
>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> +
> +8.22 KVM_CAP_DIRTY_LOG_RING
> +
> +Architectures: x86
> +Parameters: args[0] - size of the dirty log ring
> +
> +KVM is capable of tracking dirty memory using ring buffers that are
> +mmaped into userspace; there is one dirty ring per vcpu.
> +
> +One dirty ring is defined as below internally:
> +
> +struct kvm_dirty_ring {
> +	u32 dirty_index;
> +	u32 reset_index;
> +	u32 size;
> +	u32 soft_limit;
> +	struct kvm_dirty_gfn *dirty_gfns;
> +	struct kvm_dirty_ring_indices *indices;
> +	int index;
> +};
> +
> +Dirty GFNs (Guest Frame Numbers) are stored in the dirty_gfns array.
> +For each of the dirty entry it's defined as:
> +
> +struct kvm_dirty_gfn {
> +        __u32 pad;

How about sticking a length here?
This way huge pages can be dirtied in one go.

> +        __u32 slot; /* as_id | slot_id */
> +        __u64 offset;
> +};
> +
> +Most of the ring structure is used by KVM internally, while only the
> +indices are exposed to userspace:
> +
> +struct kvm_dirty_ring_indices {
> +	__u32 avail_index; /* set by kernel */
> +	__u32 fetch_index; /* set by userspace */
> +};
> +
> +The two indices in the ring buffer are free running counters.
> +
> +Userspace calls KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM ioctl
> +to enable this capability for the new guest and set the size of the
> +rings.  It is only allowed before creating any vCPU, and the size of
> +the ring must be a power of two.


I know index design is popular, but testing with virtio showed
that it's better to just have a flags field marking
an entry as valid. In particular this gets rid of the
running counters and power of two limitations.
It also removes the need for a separate index page, which is nice.



>  The larger the ring buffer, the less
> +likely the ring is full and the VM is forced to exit to userspace. The
> +optimal size depends on the workload, but it is recommended that it be
> +at least 64 KiB (4096 entries).

Where's this number coming from? Given you have indices as well,
4K size rings is likely to cause cache contention.

> +Just like for dirty page bitmaps, the buffer tracks writes to
> +all user memory regions for which the KVM_MEM_LOG_DIRTY_PAGES flag was
> +set in KVM_SET_USER_MEMORY_REGION.  Once a memory region is registered
> +with the flag set, userspace can start harvesting dirty pages from the
> +ring buffer.
> +
> +To harvest the dirty pages, userspace accesses the mmaped ring buffer
> +to read the dirty GFNs up to avail_index, and sets the fetch_index
> +accordingly.  This can be done when the guest is running or paused,
> +and dirty pages need not be collected all at once.  After processing
> +one or more entries in the ring buffer, userspace calls the VM ioctl
> +KVM_RESET_DIRTY_RINGS to notify the kernel that it has updated
> +fetch_index and to mark those pages clean.  Therefore, the ioctl
> +must be called *before* reading the content of the dirty pages.
> +
> +However, there is a major difference comparing to the
> +KVM_GET_DIRTY_LOG interface in that when reading the dirty ring from
> +userspace it's still possible that the kernel has not yet flushed the
> +hardware dirty buffers into the kernel buffer (which was previously
> +done by the KVM_GET_DIRTY_LOG ioctl).  To achieve that, one needs to
> +kick the vcpu out for a hardware buffer flush (vmexit) to make sure
> +all the existing dirty gfns are flushed to the dirty rings.
> +
> +If one of the ring buffers is full, the guest will exit to userspace
> +with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the KVM_RUN
> +ioctl will return to userspace with zero.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f536d139b3d2..3fe18402e6a3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1181,6 +1181,7 @@ struct kvm_x86_ops {
>  					   struct kvm_memory_slot *slot,
>  					   gfn_t offset, unsigned long mask);
>  	int (*write_log_dirty)(struct kvm_vcpu *vcpu);
> +	int (*cpu_dirty_log_size)(void);
>  
>  	/* pmu operations of sub-arch */
>  	const struct kvm_pmu_ops *pmu_ops;
> @@ -1666,4 +1667,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>  #define GET_SMSTATE(type, buf, offset)		\
>  	(*(type *)((buf) + (offset) - 0x7e00))
>  
> +int kvm_cpu_dirty_log_size(void);
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 503d3f42da16..b59bf356c478 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -12,6 +12,7 @@
>  
>  #define KVM_PIO_PAGE_OFFSET 1
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
> +#define KVM_DIRTY_LOG_PAGE_OFFSET 64
>  
>  #define DE_VECTOR 0
>  #define DB_VECTOR 1
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index b19ef421084d..0acee817adfb 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -5,7 +5,8 @@ ccflags-y += -Iarch/x86/kvm
>  KVM := ../../../virt/kvm
>  
>  kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
> -				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
> +				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
> +				$(KVM)/dirty_ring.o
>  kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
>  
>  kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7269130ea5e2..621b842a9b7b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1832,7 +1832,13 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_x86_ops->write_log_dirty)
>  		return kvm_x86_ops->write_log_dirty(vcpu);
> +	return 0;
> +}
>  
> +int kvm_cpu_dirty_log_size(void)
> +{
> +	if (kvm_x86_ops->cpu_dirty_log_size)
> +		return kvm_x86_ops->cpu_dirty_log_size();
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 62175a246bcc..2151de89456d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7689,6 +7689,7 @@ static __init int hardware_setup(void)
>  		kvm_x86_ops->slot_disable_log_dirty = NULL;
>  		kvm_x86_ops->flush_log_dirty = NULL;
>  		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
> +		kvm_x86_ops->cpu_dirty_log_size = NULL;
>  	}
>  
>  	if (!cpu_has_vmx_preemption_timer())
> @@ -7753,6 +7754,11 @@ static __exit void hardware_unsetup(void)
>  	free_kvm_area();
>  }
>  
> +static int vmx_cpu_dirty_log_size(void)
> +{
> +	return enable_pml ? PML_ENTITY_NUM : 0;
> +}
> +
>  static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.cpu_has_kvm_support = cpu_has_kvm_support,
>  	.disabled_by_bios = vmx_disabled_by_bios,
> @@ -7875,6 +7881,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.flush_log_dirty = vmx_flush_log_dirty,
>  	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
>  	.write_log_dirty = vmx_write_pml_buffer,
> +	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
>  
>  	.pre_block = vmx_pre_block,
>  	.post_block = vmx_post_block,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff97782b3919..9c3673592826 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7998,6 +7998,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	bool req_immediate_exit = false;
>  
> +	/* Forbid vmenter if vcpu dirty ring is soft-full */
> +	if (unlikely(vcpu->kvm->dirty_ring_size &&
> +		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
> +		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
> +		trace_kvm_dirty_ring_exit(vcpu);
> +		r = 0;
> +		goto out;
> +	}
> +
>  	if (kvm_request_pending(vcpu)) {
>  		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
>  			if (unlikely(!kvm_x86_ops->get_vmcs12_pages(vcpu))) {
> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> new file mode 100644
> index 000000000000..d6fe9e1b7617
> --- /dev/null
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -0,0 +1,55 @@
> +#ifndef KVM_DIRTY_RING_H
> +#define KVM_DIRTY_RING_H
> +
> +/**
> + * kvm_dirty_ring: KVM internal dirty ring structure
> + *
> + * @dirty_index: free running counter that points to the next slot in
> + *               dirty_ring->dirty_gfns, where a new dirty page should go
> + * @reset_index: free running counter that points to the next dirty page
> + *               in dirty_ring->dirty_gfns for which dirty trap needs to
> + *               be reenabled
> + * @size:        size of the compact list, dirty_ring->dirty_gfns
> + * @soft_limit:  when the number of dirty pages in the list reaches this
> + *               limit, vcpu that owns this ring should exit to userspace
> + *               to allow userspace to harvest all the dirty pages
> + * @dirty_gfns:  the array to keep the dirty gfns
> + * @indices:     the pointer to the @kvm_dirty_ring_indices structure
> + *               of this specific ring
> + * @index:       index of this dirty ring
> + */
> +struct kvm_dirty_ring {
> +	u32 dirty_index;
> +	u32 reset_index;
> +	u32 size;
> +	u32 soft_limit;
> +	struct kvm_dirty_gfn *dirty_gfns;
> +	struct kvm_dirty_ring_indices *indices;
> +	int index;
> +};
> +
> +u32 kvm_dirty_ring_get_rsvd_entries(void);
> +int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
> +			 struct kvm_dirty_ring_indices *indices,
> +			 int index, u32 size);
> +struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm);
> +
> +/*
> + * called with kvm->slots_lock held, returns the number of
> + * processed pages.
> + */
> +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
> +
> +/*
> + * returns =0: successfully pushed
> + *         <0: unable to push, need to wait
> + */
> +void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset);
> +
> +/* for use in vm_operations_struct */
> +struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset);
> +
> +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
> +bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring);
> +
> +#endif
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index cbd633ece959..c96161c6a0c9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -34,6 +34,7 @@
>  #include <linux/kvm_types.h>
>  
>  #include <asm/kvm_host.h>
> +#include <linux/kvm_dirty_ring.h>
>  
>  #ifndef KVM_MAX_VCPU_ID
>  #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
> @@ -321,6 +322,7 @@ struct kvm_vcpu {
>  	bool ready;
>  	struct kvm_vcpu_arch arch;
>  	struct dentry *debugfs_dentry;
> +	struct kvm_dirty_ring dirty_ring;
>  };
>  
>  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
> @@ -502,6 +504,7 @@ struct kvm {
>  	struct srcu_struct srcu;
>  	struct srcu_struct irq_srcu;
>  	pid_t userspace_pid;
> +	u32 dirty_ring_size;
>  };
>  
>  #define kvm_err(fmt, ...) \
> @@ -831,6 +834,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  					gfn_t gfn_offset,
>  					unsigned long mask);
>  
> +void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask);
> +
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  				struct kvm_dirty_log *log);
>  int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
> @@ -1409,4 +1414,25 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
>  				uintptr_t data, const char *name,
>  				struct task_struct **thread_ptr);
>  
> +/*
> + * This defines how many reserved entries we want to keep before we
> + * kick the vcpu to the userspace to avoid dirty ring full.  This
> + * value can be tuned to higher if e.g. PML is enabled on the host.
> + */
> +#define  KVM_DIRTY_RING_RSVD_ENTRIES  64
> +
> +/* Max number of entries allowed for each kvm dirty ring */
> +#define  KVM_DIRTY_RING_MAX_ENTRIES  65536
> +
> +/*
> + * Arch needs to define these macro after implementing the dirty ring
> + * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
> + * starting page offset of the dirty ring structures, while
> + * KVM_DIRTY_RING_VERSION should be defined as >=1.  By default, this
> + * feature is off on all archs.
> + */
> +#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
> +#define KVM_DIRTY_LOG_PAGE_OFFSET 0
> +#endif
> +
>  #endif
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 2c735a3e6613..3d850997940c 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -399,6 +399,84 @@ TRACE_EVENT(kvm_halt_poll_ns,
>  #define trace_kvm_halt_poll_ns_shrink(vcpu_id, new, old) \
>  	trace_kvm_halt_poll_ns(false, vcpu_id, new, old)
>  
> +TRACE_EVENT(kvm_dirty_ring_push,
> +	TP_PROTO(struct kvm_dirty_ring *ring, u32 slot, u64 offset),
> +	TP_ARGS(ring, slot, offset),
> +
> +	TP_STRUCT__entry(
> +		__field(int, index)
> +		__field(u32, dirty_index)
> +		__field(u32, reset_index)
> +		__field(u32, slot)
> +		__field(u64, offset)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->index          = ring->index;
> +		__entry->dirty_index    = ring->dirty_index;
> +		__entry->reset_index    = ring->reset_index;
> +		__entry->slot           = slot;
> +		__entry->offset         = offset;
> +	),
> +
> +	TP_printk("ring %d: dirty 0x%x reset 0x%x "
> +		  "slot %u offset 0x%llx (used %u)",
> +		  __entry->index, __entry->dirty_index,
> +		  __entry->reset_index,  __entry->slot, __entry->offset,
> +		  __entry->dirty_index - __entry->reset_index)
> +);
> +
> +TRACE_EVENT(kvm_dirty_ring_reset,
> +	TP_PROTO(struct kvm_dirty_ring *ring),
> +	TP_ARGS(ring),
> +
> +	TP_STRUCT__entry(
> +		__field(int, index)
> +		__field(u32, dirty_index)
> +		__field(u32, reset_index)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->index          = ring->index;
> +		__entry->dirty_index    = ring->dirty_index;
> +		__entry->reset_index    = ring->reset_index;
> +	),
> +
> +	TP_printk("ring %d: dirty 0x%x reset 0x%x (used %u)",
> +		  __entry->index, __entry->dirty_index, __entry->reset_index,
> +		  __entry->dirty_index - __entry->reset_index)
> +);
> +
> +TRACE_EVENT(kvm_dirty_ring_waitqueue,
> +	TP_PROTO(bool enter),
> +	TP_ARGS(enter),
> +
> +	TP_STRUCT__entry(
> +	    __field(bool, enter)
> +	),
> +
> +	TP_fast_assign(
> +	    __entry->enter = enter;
> +	),
> +
> +	TP_printk("%s", __entry->enter ? "wait" : "awake")
> +);
> +
> +TRACE_EVENT(kvm_dirty_ring_exit,
> +	TP_PROTO(struct kvm_vcpu *vcpu),
> +	TP_ARGS(vcpu),
> +
> +	TP_STRUCT__entry(
> +	    __field(int, vcpu_id)
> +	),
> +
> +	TP_fast_assign(
> +	    __entry->vcpu_id = vcpu->vcpu_id;
> +	),
> +
> +	TP_printk("vcpu %d", __entry->vcpu_id)
> +);
> +
>  #endif /* _TRACE_KVM_MAIN_H */
>  
>  /* This part must be outside protection */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f0a16b4adbbd..df4a1700ff1e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
>  #define KVM_EXIT_IOAPIC_EOI       26
>  #define KVM_EXIT_HYPERV           27
>  #define KVM_EXIT_ARM_NISV         28
> +#define KVM_EXIT_DIRTY_RING_FULL  29
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -247,6 +248,13 @@ struct kvm_hyperv_exit {
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
>  
> +struct kvm_dirty_ring_indices {
> +	__u32 avail_index; /* set by kernel */
> +	__u32 padding1;
> +	__u32 fetch_index; /* set by userspace */
> +	__u32 padding2;
> +};
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>  	/* in */
> @@ -421,6 +429,8 @@ struct kvm_run {
>  		struct kvm_sync_regs regs;
>  		char padding[SYNC_REGS_SIZE_BYTES];
>  	} s;
> +
> +	struct kvm_dirty_ring_indices vcpu_ring_indices;
>  };
>  
>  /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
> @@ -1009,6 +1019,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
>  #define KVM_CAP_ARM_NISV_TO_USER 177
>  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
> +#define KVM_CAP_DIRTY_LOG_RING 179
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1473,6 +1484,9 @@ struct kvm_enc_region {
>  /* Available with KVM_CAP_ARM_SVE */
>  #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
>  
> +/* Available with KVM_CAP_DIRTY_LOG_RING */
> +#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>  	/* Guest initialization commands */
> @@ -1623,4 +1637,23 @@ struct kvm_hyperv_eventfd {
>  #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
>  #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
>  
> +/*
> + * The following are the requirements for supporting dirty log ring
> + * (by enabling KVM_DIRTY_LOG_PAGE_OFFSET).
> + *
> + * 1. Memory accesses by KVM should call kvm_vcpu_write_* instead
> + *    of kvm_write_* so that the global dirty ring is not filled up
> + *    too quickly.
> + * 2. kvm_arch_mmu_enable_log_dirty_pt_masked should be defined for
> + *    enabling dirty logging.
> + * 3. There should not be a separate step to synchronize hardware
> + *    dirty bitmap with KVM's.
> + */
> +
> +struct kvm_dirty_gfn {
> +	__u32 pad;
> +	__u32 slot;
> +	__u64 offset;
> +};
> +
>  #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> new file mode 100644
> index 000000000000..67ec5bbc21c0
> --- /dev/null
> +++ b/virt/kvm/dirty_ring.c
> @@ -0,0 +1,162 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * KVM dirty ring implementation
> + *
> + * Copyright 2019 Red Hat, Inc.
> + */
> +#include <linux/kvm_host.h>
> +#include <linux/kvm.h>
> +#include <linux/vmalloc.h>
> +#include <linux/kvm_dirty_ring.h>
> +#include <trace/events/kvm.h>
> +
> +int __weak kvm_cpu_dirty_log_size(void)
> +{
> +	return 0;
> +}
> +
> +u32 kvm_dirty_ring_get_rsvd_entries(void)
> +{
> +	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
> +}
> +
> +static u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
> +{
> +	return READ_ONCE(ring->dirty_index) - READ_ONCE(ring->reset_index);
> +}
> +
> +bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
> +{
> +	return kvm_dirty_ring_used(ring) >= ring->soft_limit;
> +}
> +
> +bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
> +{
> +	return kvm_dirty_ring_used(ring) >= ring->size;
> +}
> +
> +struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +
> +	WARN_ON_ONCE(vcpu->kvm != kvm);
> +
> +	return &vcpu->dirty_ring;
> +}
> +
> +int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
> +			 struct kvm_dirty_ring_indices *indices,
> +			 int index, u32 size)
> +{
> +	ring->dirty_gfns = vmalloc(size);
> +	if (!ring->dirty_gfns)
> +		return -ENOMEM;
> +	memset(ring->dirty_gfns, 0, size);
> +
> +	ring->size = size / sizeof(struct kvm_dirty_gfn);
> +	ring->soft_limit = ring->size - kvm_dirty_ring_get_rsvd_entries();
> +	ring->dirty_index = 0;
> +	ring->reset_index = 0;
> +	ring->index = index;
> +	ring->indices = indices;
> +
> +	return 0;
> +}
> +
> +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> +{
> +	u32 cur_slot, next_slot;
> +	u64 cur_offset, next_offset;
> +	unsigned long mask;
> +	u32 fetch;
> +	int count = 0;
> +	struct kvm_dirty_gfn *entry;
> +	struct kvm_dirty_ring_indices *indices = ring->indices;
> +	bool first_round = true;
> +
> +	fetch = READ_ONCE(indices->fetch_index);

So this does not work if the data cache is virtually tagged.
Which to the best of my knowledge isn't the case on any
CPU kvm supports. However it might not stay being the
case forever. Worth at least commenting.


> +
> +	/*
> +	 * Note that fetch_index is written by the userspace, which
> +	 * should not be trusted.  If this happens, then it's probably
> +	 * that the userspace has written a wrong fetch_index.
> +	 */
> +	if (fetch - ring->reset_index > ring->size)
> +		return -EINVAL;
> +
> +	if (fetch == ring->reset_index)
> +		return 0;
> +
> +	/* This is only needed to make compilers happy */
> +	cur_slot = cur_offset = mask = 0;
> +	while (ring->reset_index != fetch) {
> +		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> +		next_slot = READ_ONCE(entry->slot);
> +		next_offset = READ_ONCE(entry->offset);

What is this READ_ONCE doing? Entries are only written by kernel
and it's under lock.

> +		ring->reset_index++;
> +		count++;
> +		/*
> +		 * Try to coalesce the reset operations when the guest is
> +		 * scanning pages in the same slot.
> +		 */
> +		if (!first_round && next_slot == cur_slot) {
> +			s64 delta = next_offset - cur_offset;
> +
> +			if (delta >= 0 && delta < BITS_PER_LONG) {
> +				mask |= 1ull << delta;
> +				continue;
> +			}
> +
> +			/* Backwards visit, careful about overflows!  */
> +			if (delta > -BITS_PER_LONG && delta < 0 &&
> +			    (mask << -delta >> -delta) == mask) {
> +				cur_offset = next_offset;
> +				mask = (mask << -delta) | 1;
> +				continue;
> +			}
> +		}

Well how important is this logic? Because it will not be
too effective on an SMP system, so don't you need a per-cpu ring?



> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +		cur_slot = next_slot;
> +		cur_offset = next_offset;
> +		mask = 1;
> +		first_round = false;
> +	}
> +	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +	trace_kvm_dirty_ring_reset(ring);
> +
> +	return count;
> +}
> +
> +void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
> +{
> +	struct kvm_dirty_gfn *entry;
> +	struct kvm_dirty_ring_indices *indices = ring->indices;
> +
> +	/* It should never get full */
> +	WARN_ON_ONCE(kvm_dirty_ring_full(ring));
> +
> +	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
> +	entry->slot = slot;
> +	entry->offset = offset;
> +	/*
> +	 * Make sure the data is filled in before we publish this to
> +	 * the userspace program.  There's no paired kernel-side reader.
> +	 */
> +	smp_wmb();
> +	ring->dirty_index++;


Do I understand it correctly that the ring is shared between CPUs?
If so I don't understand why it's safe for SMP guests.
Don't you need atomics or locking?


> +	WRITE_ONCE(indices->avail_index, ring->dirty_index);
> +
> +	trace_kvm_dirty_ring_push(ring, slot, offset);
> +}
> +
> +struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset)
> +{
> +	return vmalloc_to_page((void *)ring->dirty_gfns + offset * PAGE_SIZE);
> +}
> +
> +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
> +{
> +	vfree(ring->dirty_gfns);
> +	ring->dirty_gfns = NULL;
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5bbd8b8730fa..5e36792e15ae 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -64,6 +64,8 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/kvm.h>
>  
> +#include <linux/kvm_dirty_ring.h>
> +
>  /* Worst case buffer size needed for holding an integer. */
>  #define ITOA_MAX_LEN 12
>  
> @@ -357,11 +359,22 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  	vcpu->preempted = false;
>  	vcpu->ready = false;
>  
> +	if (kvm->dirty_ring_size) {
> +		r = kvm_dirty_ring_alloc(&vcpu->dirty_ring,
> +					 &vcpu->run->vcpu_ring_indices,
> +					 id, kvm->dirty_ring_size);
> +		if (r)
> +			goto fail_free_run;
> +	}
> +
>  	r = kvm_arch_vcpu_init(vcpu);
>  	if (r < 0)
> -		goto fail_free_run;
> +		goto fail_free_ring;
>  	return 0;
>  
> +fail_free_ring:
> +	if (kvm->dirty_ring_size)
> +		kvm_dirty_ring_free(&vcpu->dirty_ring);
>  fail_free_run:
>  	free_page((unsigned long)vcpu->run);
>  fail:
> @@ -379,6 +392,8 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
>  	put_pid(rcu_dereference_protected(vcpu->pid, 1));
>  	kvm_arch_vcpu_uninit(vcpu);
>  	free_page((unsigned long)vcpu->run);
> +	if (vcpu->kvm->dirty_ring_size)
> +		kvm_dirty_ring_free(&vcpu->dirty_ring);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
>  
> @@ -2284,8 +2299,13 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
>  {
>  	if (memslot && memslot->dirty_bitmap) {
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
> +		u32 slot = (memslot->as_id << 16) | memslot->id;
>  
> -		set_bit_le(rel_gfn, memslot->dirty_bitmap);
> +		if (kvm->dirty_ring_size)
> +			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
> +					    slot, rel_gfn);
> +		else
> +			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>  	}
>  }
>  
> @@ -2632,6 +2652,16 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
>  
> +static bool kvm_page_in_dirty_ring(struct kvm *kvm, unsigned long pgoff)
> +{
> +	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
> +		return false;
> +
> +	return (pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
> +	    (pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
> +	     kvm->dirty_ring_size / PAGE_SIZE);
> +}
> +
>  static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
>  {
>  	struct kvm_vcpu *vcpu = vmf->vma->vm_file->private_data;
> @@ -2647,6 +2677,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
>  	else if (vmf->pgoff == KVM_COALESCED_MMIO_PAGE_OFFSET)
>  		page = virt_to_page(vcpu->kvm->coalesced_mmio_ring);
>  #endif
> +	else if (kvm_page_in_dirty_ring(vcpu->kvm, vmf->pgoff))
> +		page = kvm_dirty_ring_get_page(
> +		    &vcpu->dirty_ring,
> +		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
>  	else
>  		return kvm_arch_vcpu_fault(vcpu, vmf);
>  	get_page(page);
> @@ -2660,6 +2694,15 @@ static const struct vm_operations_struct kvm_vcpu_vm_ops = {
>  
>  static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> +	struct kvm_vcpu *vcpu = file->private_data;
> +	unsigned long pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> +
> +	/* If to map any writable page within dirty ring, fail it */
> +	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
> +	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
> +	    vma->vm_flags & VM_WRITE)
> +		return -EINVAL;
> +
>  	vma->vm_ops = &kvm_vcpu_vm_ops;
>  	return 0;
>  }
> @@ -3242,12 +3285,97 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #endif
>  	case KVM_CAP_NR_MEMSLOTS:
>  		return KVM_USER_MEM_SLOTS;
> +	case KVM_CAP_DIRTY_LOG_RING:
> +#ifdef CONFIG_X86
> +		return KVM_DIRTY_RING_MAX_ENTRIES;
> +#else
> +		return 0;
> +#endif
>  	default:
>  		break;
>  	}
>  	return kvm_vm_ioctl_check_extension(kvm, arg);
>  }
>  
> +void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
> +{
> +	struct kvm_memory_slot *memslot;
> +	int as_id, id;
> +
> +	as_id = slot >> 16;
> +	id = (u16)slot;
> +	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> +		return;
> +
> +	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> +	if (offset >= memslot->npages)
> +		return;
> +
> +	spin_lock(&kvm->mmu_lock);
> +	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
> +	spin_unlock(&kvm->mmu_lock);
> +}
> +
> +static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
> +{
> +	int r;
> +
> +	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
> +		return -EINVAL;
> +
> +	/* the size should be power of 2 */
> +	if (!size || (size & (size - 1)))
> +		return -EINVAL;
> +
> +	/* Should be bigger to keep the reserved entries, or a page */
> +	if (size < kvm_dirty_ring_get_rsvd_entries() *
> +	    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
> +		return -EINVAL;
> +
> +	if (size > KVM_DIRTY_RING_MAX_ENTRIES *
> +	    sizeof(struct kvm_dirty_gfn))
> +		return -E2BIG;
> +
> +	/* We only allow it to set once */
> +	if (kvm->dirty_ring_size)
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (kvm->created_vcpus) {
> +		/* We don't allow to change this value after vcpu created */
> +		r = -EINVAL;
> +	} else {
> +		kvm->dirty_ring_size = size;
> +		r = 0;
> +	}
> +
> +	mutex_unlock(&kvm->lock);
> +	return r;
> +}
> +
> +static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
> +{
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +	int cleared = 0;
> +
> +	if (!kvm->dirty_ring_size)
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	if (cleared)
> +		kvm_flush_remote_tlbs(kvm);
> +
> +	return cleared;
> +}
> +
>  int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  						  struct kvm_enable_cap *cap)
>  {
> @@ -3265,6 +3393,8 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  		kvm->manual_dirty_log_protect = cap->args[0];
>  		return 0;
>  #endif
> +	case KVM_CAP_DIRTY_LOG_RING:
> +		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> @@ -3452,6 +3582,9 @@ static long kvm_vm_ioctl(struct file *filp,
>  	case KVM_CHECK_EXTENSION:
>  		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
>  		break;
> +	case KVM_RESET_DIRTY_RINGS:
> +		r = kvm_vm_ioctl_reset_dirty_pages(kvm);
> +		break;
>  	default:
>  		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
>  	}
> -- 
> 2.24.1

