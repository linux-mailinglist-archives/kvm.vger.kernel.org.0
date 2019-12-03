Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44782111B59
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 23:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfLCWHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 17:07:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:13784 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727516AbfLCWHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 17:07:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 14:07:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,275,1571727600"; 
   d="scan'208";a="208640056"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 03 Dec 2019 14:07:52 -0800
Date:   Tue, 3 Dec 2019 14:07:52 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: X86: Use APIC_DEST_* macros properly in
 kvm_lapic_irq.dest_mode
Message-ID: <20191203220752.GJ19877@linux.intel.com>
References: <20191203165903.22917-1-peterx@redhat.com>
 <20191203165903.22917-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203165903.22917-4-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 11:59:00AM -0500, Peter Xu wrote:
> We were using either APIC_DEST_PHYSICAL|APIC_DEST_LOGICAL or 0|1 to
> fill in kvm_lapic_irq.dest_mode.  It's fine only because in most cases
> when we check against dest_mode it's against APIC_DEST_PHYSICAL (which
> equals to 0).  However, that's not consistent.  We'll have problem
> when we want to start checking against APIC_DEST_LOGICAL, which does
> not equals to 1.
> 
> This patch firstly introduces kvm_lapic_irq_dest_mode() helper to take
> any boolean of destination mode and return the APIC_DEST_* macro.
> Then, it replaces the 0|1 settings of irq.dest_mode with the helper.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 5 +++++
>  arch/x86/kvm/ioapic.c           | 9 ++++++---
>  arch/x86/kvm/irq_comm.c         | 7 ++++---
>  arch/x86/kvm/x86.c              | 2 +-
>  4 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b79cd6aa4075..f815c97b1b57 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1022,6 +1022,11 @@ struct kvm_lapic_irq {
>  	bool msi_redir_hint;
>  };
>  
> +static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode)
> +{
> +	return dest_mode ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;

IMO this belongs in ioapic.c as it's specifically provided for converting
an I/O APIC redirection entry into a local APIC destination mode.  Without
the I/O APIC context, %true==APIC_DEST_LOGICAL looks like a completely
arbitrary decision.  And if it's in ioapic.c, it can take the union
of a bool, which avoids the casting and shortens the callers.  E.g.:

static u64 ioapic_to_lapic_dest_mode(union kvm_ioapic_redirect_entry *e)
{
	return e->fields.dest_mode ?  APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
}

The other option would be to use the same approach as delivery_mode and
open code the shift.

> +}
> +
>  struct kvm_x86_ops {
>  	int (*cpu_has_kvm_support)(void);          /* __init */
>  	int (*disabled_by_bios)(void);             /* __init */
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 9fd2dd89a1c5..e623a4f8d27e 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -331,7 +331,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  			irq.vector = e->fields.vector;
>  			irq.delivery_mode = e->fields.delivery_mode << 8;
>  			irq.dest_id = e->fields.dest_id;
> -			irq.dest_mode = e->fields.dest_mode;
> +			irq.dest_mode =
> +			    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>  			bitmap_zero(&vcpu_bitmap, 16);
>  			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  						 &vcpu_bitmap);
> @@ -343,7 +344,9 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  				 * keep ioapic_handled_vectors synchronized.
>  				 */
>  				irq.dest_id = old_dest_id;
> -				irq.dest_mode = old_dest_mode;
> +				irq.dest_mode =
> +				    kvm_lapic_irq_dest_mode(
> +					!!e->fields.dest_mode);
>  				kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  							 &vcpu_bitmap);
>  			}
> @@ -369,7 +372,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  
>  	irqe.dest_id = entry->fields.dest_id;
>  	irqe.vector = entry->fields.vector;
> -	irqe.dest_mode = entry->fields.dest_mode;
> +	irqe.dest_mode = kvm_lapic_irq_dest_mode(!!entry->fields.dest_mode);
>  	irqe.trig_mode = entry->fields.trig_mode;
>  	irqe.delivery_mode = entry->fields.delivery_mode << 8;
>  	irqe.level = 1;
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8ecd48d31800..22108ed66a76 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -52,8 +52,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  	unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
>  	unsigned int dest_vcpus = 0;
>  
> -	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
> -			kvm_lowest_prio_delivery(irq)) {
> +	if (irq->dest_mode == APIC_DEST_PHYSICAL &&
> +	    irq->dest_id == 0xff && kvm_lowest_prio_delivery(irq)) {
>  		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
>  		irq->delivery_mode = APIC_DM_FIXED;
>  	}
> @@ -114,7 +114,8 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
>  		irq->dest_id |= MSI_ADDR_EXT_DEST_ID(e->msi.address_hi);
>  	irq->vector = (e->msi.data &
>  			MSI_DATA_VECTOR_MASK) >> MSI_DATA_VECTOR_SHIFT;
> -	irq->dest_mode = (1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_lo;
> +	irq->dest_mode = kvm_lapic_irq_dest_mode(
> +	    !!((1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_lo));
>  	irq->trig_mode = (1 << MSI_DATA_TRIGGER_SHIFT) & e->msi.data;
>  	irq->delivery_mode = e->msi.data & 0x700;
>  	irq->msi_redir_hint = ((e->msi.address_lo
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3ed167e039e5..3b00d662dc14 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7356,7 +7356,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
>  	struct kvm_lapic_irq lapic_irq;
>  
>  	lapic_irq.shorthand = 0;
> -	lapic_irq.dest_mode = 0;
> +	lapic_irq.dest_mode = APIC_DEST_PHYSICAL;
>  	lapic_irq.level = 0;
>  	lapic_irq.dest_id = apicid;
>  	lapic_irq.msi_redir_hint = false;
> -- 
> 2.21.0
> 
