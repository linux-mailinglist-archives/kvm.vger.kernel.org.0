Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B0DF19A3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 16:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfKFPOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 10:14:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:57717 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfKFPO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 10:14:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 07:14:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="196235732"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 06 Nov 2019 07:14:28 -0800
Date:   Wed, 6 Nov 2019 07:14:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: Re: [Patch v1 2/2] KVM: x86: deliver KVM IOAPIC scan request to
 target vCPUs
Message-ID: <20191106151428.GB16249@linux.intel.com>
References: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
 <1573047398-7665-3-git-send-email-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573047398-7665-3-git-send-email-nitesh@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 08:36:38AM -0500, Nitesh Narayan Lal wrote:
> In IOAPIC fixed delivery mode instead of flushing the scan
> requests to all vCPUs, we should only send the requests to
> vCPUs specified within the destination field.
> 
> This patch introduces kvm_get_dest_vcpus_mask() API which
> retrieves an array of target vCPUs by using
> kvm_apic_map_get_dest_lapic() and then based on the
> vcpus_idx, it sets the bit in a bitmap. However, if the above
> fails kvm_get_dest_vcpus_mask() finds the target vCPUs by
> traversing all available vCPUs. Followed by setting the
> bits in the bitmap.
> 
> If we had different vCPUs in the previous request for the
> same redirection table entry then bits corresponding to
> these vCPUs are also set. This to done to keep
> ioapic_handled_vectors synchronized.
> 
> This bitmap is then eventually passed on to
> kvm_make_vcpus_request_mask() to generate a masked request
> only for the target vCPUs.
> 
> This would enable us to reduce the latency overhead on isolated
> vCPUs caused by the IPI to process due to KVM_REQ_IOAPIC_SCAN.
> 
> Suggested-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/ioapic.c           | 33 ++++++++++++++++++++++++++++--
>  arch/x86/kvm/lapic.c            | 45 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/lapic.h            |  3 +++
>  arch/x86/kvm/x86.c              |  6 ++++++
>  include/linux/kvm_host.h        |  2 ++
>  virt/kvm/kvm_main.c             | 14 +++++++++++++
>  7 files changed, 103 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 24d6598..b2aca6d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1571,6 +1571,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  
>  void kvm_make_mclock_inprogress_request(struct kvm *kvm);
>  void kvm_make_scan_ioapic_request(struct kvm *kvm);
> +void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
> +				       unsigned long *vcpu_bitmap);
>  
>  void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work);
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index d859ae8..c8d0a83 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -271,8 +271,9 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  {
>  	unsigned index;
>  	bool mask_before, mask_after;
> -	int old_remote_irr, old_delivery_status;
>  	union kvm_ioapic_redirect_entry *e;
> +	unsigned long vcpu_bitmap;
> +	int old_remote_irr, old_delivery_status, old_dest_id, old_dest_mode;
>  
>  	switch (ioapic->ioregsel) {
>  	case IOAPIC_REG_VERSION:
> @@ -296,6 +297,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  		/* Preserve read-only fields */
>  		old_remote_irr = e->fields.remote_irr;
>  		old_delivery_status = e->fields.delivery_status;
> +		old_dest_id = e->fields.dest_id;
> +		old_dest_mode = e->fields.dest_mode;
>  		if (ioapic->ioregsel & 1) {
>  			e->bits &= 0xffffffff;
>  			e->bits |= (u64) val << 32;
> @@ -321,7 +324,33 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG
>  		    && ioapic->irr & (1 << index))
>  			ioapic_service(ioapic, index, false);
> -		kvm_make_scan_ioapic_request(ioapic->kvm);
> +		if (e->fields.delivery_mode == APIC_DM_FIXED) {
> +			struct kvm_lapic_irq irq;
> +
> +			irq.shorthand = 0;
> +			irq.vector = e->fields.vector;
> +			irq.delivery_mode = e->fields.delivery_mode << 8;
> +			irq.dest_id = e->fields.dest_id;
> +			irq.dest_mode = e->fields.dest_mode;
> +			kvm_get_dest_vcpus_mask(ioapic->kvm, &irq,
> +						&vcpu_bitmap);
> +			if (old_dest_mode != e->fields.dest_mode ||
> +			    old_dest_id != e->fields.dest_id) {
> +				/*
> +				 * Update vcpu_bitmap with vcpus specified in
> +				 * the previous request as well. This is done to
> +				 * keep ioapic_handled_vectors synchronized.
> +				 */
> +				irq.dest_id = old_dest_id;
> +				irq.dest_mode = old_dest_mode;
> +				kvm_get_dest_vcpus_mask(ioapic->kvm, &irq,
> +							&vcpu_bitmap);
> +			}
> +			kvm_make_scan_ioapic_request_mask(ioapic->kvm,
> +							  &vcpu_bitmap);
> +		} else {
> +			kvm_make_scan_ioapic_request(ioapic->kvm);
> +		}
>  		break;
>  	}
>  }
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index b29d00b..90869c4 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1124,6 +1124,51 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>  	return result;
>  }
>  
> +/*
> + * This routine identifies the destination vcpus mask meant to receive the
> + * IOAPIC interrupts. It either uses kvm_apic_map_get_dest_lapic() to find
> + * out the destination vcpus array and set the bitmap or it traverses to
> + * each available vcpu to identify the same.
> + */
> +void kvm_get_dest_vcpus_mask(struct kvm *kvm, struct kvm_lapic_irq *irq,
> +			     unsigned long *vcpu_bitmap)
> +{
> +	struct kvm_lapic **dest_vcpu = NULL;
> +	struct kvm_lapic *src = NULL;
> +	struct kvm_apic_map *map;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long bitmap;
> +	int i, vcpus_idx;
> +	bool ret;
> +
> +	rcu_read_lock();
> +	map = rcu_dereference(kvm->arch.apic_map);
> +
> +	ret = kvm_apic_map_get_dest_lapic(kvm, &src, irq, map, &dest_vcpu,
> +					  &bitmap);
> +	if (ret) {
> +		for_each_set_bit(i, &bitmap, 16) {
> +			if (!dest_vcpu[i])
> +				continue;
> +			vcpus_idx = dest_vcpu[i]->vcpu->vcpus_idx;
> +			__set_bit(vcpus_idx, vcpu_bitmap);
> +		}
> +	} else {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			if (!kvm_apic_present(vcpu))
> +				continue;
> +			if (!kvm_apic_match_dest(vcpu, NULL,
> +						 irq->delivery_mode,
> +						 irq->dest_id,
> +						 irq->dest_mode))
> +				continue;
> +			vcpus_idx = dest_vcpu[i]->vcpu->vcpus_idx;

This can't possibly be correct.  AFAICT, dest_vcpu is guaranteed to be
*NULL* when kvm_apic_map_get_dest_lapic() returns false, and on top of
that I'm pretty sure it's not intended to be indexed by the vcpu index.

But vcpus_idx isn't needed here, you already have @vcpu, and even that
is superfluous as @i itself is the vcpu index.

It's probably worth manually testing this path by forcing @ret to false,
I'm guessing it's not being hit in normal operation.

> +			__set_bit(vcpus_idx, vcpu_bitmap);
> +		}
> +	}
> +	rcu_read_unlock();
> +}
> +
>  int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
>  {
>  	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 1f501485..49b0c6c 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -226,6 +226,9 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
>  
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
>  
> +void kvm_get_dest_vcpus_mask(struct kvm *kvm, struct kvm_lapic_irq *irq,
> +			     unsigned long *vcpu_bitmap);
> +
>  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
>  			struct kvm_vcpu **dest_vcpu);
>  int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff395f8..ee6945f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7838,6 +7838,12 @@ static void process_smi(struct kvm_vcpu *vcpu)
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  }
>  
> +void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
> +				       unsigned long *vcpu_bitmap)
> +{
> +	kvm_make_cpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC, vcpu_bitmap);
> +}
> +
>  void kvm_make_scan_ioapic_request(struct kvm *kvm)
>  {
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 31c4fde..2f69eae 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -786,6 +786,8 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>  				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
>  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
> +bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
> +				unsigned long *vcpu_bitmap);
>  
>  long kvm_arch_dev_ioctl(struct file *filp,
>  			unsigned int ioctl, unsigned long arg);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 24ab711..9e85df8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -242,6 +242,20 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>  	return called;
>  }
>  
> +bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
> +				unsigned long *vcpu_bitmap)
> +{
> +	cpumask_var_t cpus;
> +	bool called;
> +
> +	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
> +
> +	called = kvm_make_vcpus_request_mask(kvm, req, vcpu_bitmap, cpus);
> +
> +	free_cpumask_var(cpus);
> +	return called;

kvm_make_all_cpus_request() should call this new function, the code is
identical except for its declared vcpu_bitmap.  

> +}
> +
>  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  {
>  	cpumask_var_t cpus;
> -- 
> 1.8.3.1
> 
