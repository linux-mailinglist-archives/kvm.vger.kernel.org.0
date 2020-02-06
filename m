Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE10D154DCE
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 22:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgBFVVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 16:21:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:31710 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgBFVVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 16:21:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 13:21:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="250191235"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 06 Feb 2020 13:21:20 -0800
Date:   Thu, 6 Feb 2020 13:21:20 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200206212120.GF13067@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206200200.GC700495@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
> On Tue, Jan 21, 2020 at 02:31:53PM -0800, Sean Christopherson wrote:
> 
> [...]
> 
> > -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> > +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
> > +				  struct kvm_memory_slot *memslot)
> 
> If it's to flush TLB for a memslot, shall we remove the "dirty_log" in
> the name of the function, because it has nothing to do with dirty
> logging any more?  And...

I kept the "dirty_log" to allow arch code to implement logic specific to a
TLB flush during dirty logging, e.g. x86's lockdep assert on slots_lock.
And similar to the issue with MIPS below, to deter usage of the hook for
anything else, i.e. to nudge people to using kvm_flush_remote_tlbs()
directly.

> >  {
> > -	struct kvm_memslots *slots;
> > -	struct kvm_memory_slot *memslot;
> > -	bool flush = false;
> > -	int r;
> > -
> > -	mutex_lock(&kvm->slots_lock);
> > -
> > -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> > -
> > -	if (flush) {
> > -		slots = kvm_memslots(kvm);
> > -		memslot = id_to_memslot(slots, log->slot);
> > -
> > -		/* Let implementation handle TLB/GVA invalidation */
> > -		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> > -	}
> > -
> > -	mutex_unlock(&kvm->slots_lock);
> > -	return r;
> > +	/* Let implementation handle TLB/GVA invalidation */
> > +	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> 
> ... This may not directly related to the current patch, but I'm
> confused on why MIPS cannot use kvm_flush_remote_tlbs() to flush TLBs.
> I know nothing about MIPS code, but IIUC here flush_shadow_memslot()
> is a heavier operation that will also invalidate the shadow pages.
> Seems to be an overkill here when we only changed write permission of
> the PTEs?  I tried to check the first occurance (2a31b9db15353) but I
> didn't find out any clue of it so far.
> 
> But that matters to this patch because if MIPS can use
> kvm_flush_remote_tlbs(), then we probably don't need this
> arch-specific hook any more and we can directly call
> kvm_flush_remote_tlbs() after sync dirty log when flush==true.

Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
that prevents calling kvm_flush_remote_tlbs() directly, but I have no
clue as to the important of that code.

> >  }
> >  
> >  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> > diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> > index 97ce6c4f7b48..0adaf4791a6d 100644
> > --- a/arch/powerpc/kvm/book3s.c
> > +++ b/arch/powerpc/kvm/book3s.c
> > @@ -799,6 +799,11 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
> >  	return vcpu->kvm->arch.kvm_ops->check_requests(vcpu);
> >  }
> >  
> > +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> 
> Since at it, maybe we can start to use __weak attribute for new hooks
> especially when it's empty for most archs?
> 
> E.g., define:
> 
> void __weak kvm_arch_sync_dirty_log(...) {}
> 
> In the common code, then only define it again in arch that has
> non-empty implementation of this method?

I defer to Paolo, I'm indifferent at this stage.
