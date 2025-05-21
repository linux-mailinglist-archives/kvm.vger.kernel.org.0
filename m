Return-Path: <kvm+bounces-47291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E359DABFA48
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5494D8C1BE6
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE75322172E;
	Wed, 21 May 2025 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0MCkY5V9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66578165F13
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842325; cv=none; b=rstqwYmBHAN9empSpEC3sa6EdhX1Dx1oJUREgWOlA9TF8ZJMC3TDsLFa17UeLMYuNfAglZuzGI3+Vuq9BF7hkLnF6oBYZ0FcSVRuc76W1Qaw1hjxqlXloRuWtIsK75mBMpZDozVbl8XrqaCxgDkkK+reNly3jM5DfWnwr1BF9JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842325; c=relaxed/simple;
	bh=yoo7Pbk4q9EQbJCx1fpa8UGP4E7ZGrMF4YnmPofM9Hg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ezig4QXdychLcWtjWmcJQfQkPiIx+xyiRt2Zb5dIg2w7Zcs+TtYs+g1RmBnskNcC/PmEiqmUynLVjM7snY833ELWa2e7R/UY+r4CJPbSGIQ3BKlajVegvnrtO7qkVoitUXTU4ZcMsoZ2TwvqRzI2OYX7nuGn5u761QoTw1+NBg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0MCkY5V9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e896e116fso4325573a91.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747842322; x=1748447122; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KGfD6Lt7AWlUqczGy/2lWkOYK/KBxBEZXw+C7OEpdvI=;
        b=0MCkY5V9dyoJp5w7PrEuFgOqP7qyi7/QYSXpyJzlrEhYy088JvqXAWbR1qttJxHSWV
         r9lDocPutfYvloUUqenWCUDEx71PyWdbr+poOrAFQZO9m62G/SFwD6Gdy9ACXUVR4D/K
         hljY3LAvS6HQbgIckQeZSe5mqidZle6Q+1agBVJ9QRV9+bEu9YZy2XpjXNIaLYPWF54x
         wQxVBR0ZMXjgb9B1rFpwI8/exAq4NOO8hCY0JaBB1boeeX3UKpyfecoQ9Yi4P8pygqq6
         zGi30ZYwc0Gc5432z7g+vgoasDPpK9fnm0b0T4ygqqBcCMFi2ozcDYFyg/9nfN4g2nyo
         /lPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747842322; x=1748447122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KGfD6Lt7AWlUqczGy/2lWkOYK/KBxBEZXw+C7OEpdvI=;
        b=XIbVQGQpl8F4xxpAKgQzQ6NnNnItutB9vC2o7nNyin5sHF6sCqc01iGEiHsk7LAJKQ
         lZgR+5LKhGZCxT6WYTcT8/uOKFgTNovggDuboQdIZtHh1uyxD35PC37LjajQfQvkMQPP
         vqg+nEHAAL9/ECtReacNS65gF+bNopJi2aOETuhpnY81hW+FWMLgR0EEJK+hswHk6gbV
         ncHoJ6St3xpvzNjkqbRQnrI+axFCEZxD6abFn3x8PbB0qQM7I/ZHYS9xMkGSO/eLQzIq
         wx4VrpUStXti5StAu0rbdv6AIkZLHEndgYHQ+A5MuZUe5zt06p2iCDyk2tMNX08W1/OW
         gIEA==
X-Forwarded-Encrypted: i=1; AJvYcCW4K5Q9ndasb2c779h1bnLMwfMEgiNadltGlFOboAPwbCTjFIV6OwwjPQV979AAkl3JdjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZL9FqkaZT0Qy18MYmyxJNnQTG2yg2+qY4V686xswgrUOwpzJb
	i12bGEGe8qjutOBK5EgZLk1J/8BkfPhrfLFQ4rH90JdJTPpd+E+abOOqkaDZNrG1KFZiPOcKxkO
	9Iz2zkA==
X-Google-Smtp-Source: AGHT+IEF1qPUzq4BlErEYu7Xd5Q90YOhv8rHaJY+RZXAoiCRRlJbaX8/E3b+d3lzEtxfAC35W1OjHa68m+s=
X-Received: from pjm6.prod.google.com ([2002:a17:90b:2fc6:b0:2fa:a101:755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d85:b0:2f9:d9fe:e72e
 with SMTP id 98e67ed59e1d1-30e8312dcd2mr40125626a91.16.1747842322673; Wed, 21
 May 2025 08:45:22 -0700 (PDT)
Date: Wed, 21 May 2025 08:45:21 -0700
In-Reply-To: <aC0wT68EY4Ybz+wI@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519023613.30329-1-yan.y.zhao@intel.com> <20250519023737.30360-1-yan.y.zhao@intel.com>
 <aCsy-m_esVjy8Pey@google.com> <52bdeeec0dfbb74f90d656dbd93dc9c7bb30e84f.camel@intel.com>
 <aCtlDhNbgXKg4s5t@google.com> <aCwUO7cQkPzIe0ZA@yzhao56-desk.sh.intel.com>
 <aCyqJTSDTKt1xiKr@google.com> <aC0wT68EY4Ybz+wI@yzhao56-desk.sh.intel.com>
Message-ID: <aC31EXLNzCVGT0EP@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Yan Zhao wrote:
> On Tue, May 20, 2025 at 09:13:25AM -0700, Sean Christopherson wrote:
> > > > @@ -4891,6 +4884,28 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
> > > >  
> > > > +int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> > > > +{
> > > > +	int r;
> > > > +
> > > > +	/*
> > > > +	 * Restrict to TDP page fault, since that's the only case where the MMU
> > > > +	 * is indexed by GPA.
> > > > +	 */
> > > > +	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	for (;;) {
> > > > +		r = kvm_tdp_map_page(vcpu, gpa, error_code, level);
> > > > +		if (r != -EAGAIN)
> > > > +			break;
> > > > +
> > > > +		/* Comment goes here. */
> > > > +		kvm_vcpu_srcu_read_unlock(vcpu);
> > > > +		kvm_vcpu_srcu_read_lock(vcpu);
> > > For the hang in the pre_fault_memory_test reported by Reinette [1], it's because
> > > the memslot removal succeeds after releasing the SRCU, then the old root is
> > > stale. So kvm_mmu_reload() is required here to prevent is_page_fault_stale()
> > > from being always true.
> > 
> > That wouldn't suffice, KVM would also need to process KVM_REQ_MMU_FREE_OBSOLETE_ROOTS,
> > otherwise kvm_mmu_reload() will do nothing.
> In commit 20a6cff3b283 ("KVM: x86/mmu: Check and free obsolete roots in
> kvm_mmu_reload()"), KVM_REQ_MMU_FREE_OBSOLETE_ROOTS is processed in
> kvm_mmu_reload().

Oh, right!  I completely forgot about that.  Hmm, that reduces the complexity a
little bit, but I'm still leaning towards punting -EAGAIN to userspace.

> > Thinking about this scenario more, I don't mind punting this problem to userspace
> > for KVM_PRE_FAULT_MEMORY because there's no existing behavior/ABI to uphold, and
> > because the complexity vs. ABI tradeoffs are heavily weighted in favor of punting
> > to userspace.  Whereas for KVM_RUN, KVM can't change existing behavior without
> > breaking userspace, should provide consistent behavior regardless of VM type, and
> > KVM needs the "complex" code irrespective of this particular scenario.
> > 
> > I especially like punting to userspace if KVM returns -EAGAIN, not -ENOENT,
> > because then KVM is effectively providing the same overall behavior as KVM_RUN,
> > just without slightly different roles and responsibilities between KVM and
> > userspace.  And -ENOENT is also flat out wrong for the case where a memslot is
> > being moved, but the new base+size still contains the to-be-faulted GPA.
> > 
> > I still don't like RET_PF_RETRY_INVALID_SLOT, because that bleeds gory MMU details
> > into the rest of KVM, but KVM can simply return -EAGAIN if an invalid memslot is
> > encountered during prefault (as identified by fault->prefetch).
> >
> > For TDX though, tdx_handle_ept_violation() needs to play nice with the scenario,
> > i.e. punting to userspace is not a viable option.  But that path also has options
> > that aren't available to prefaulting.  E.g. it could (and probably should) break
> > early if a request is pending instead of special casing KVM_REQ_VM_DEAD, which
> Hmm, for TDX, there's no request KVM_REQ_MMU_FREE_OBSOLETE_ROOTS for slot
> removal. (see commit aa8d1f48d353 ("KVM: x86/mmu: Introduce a quirk to control
> memslot zap behavior").
> 
> > would take care of the KVM_REQ_MMU_FREE_OBSOLETE_ROOTS scenario.  And as Rick
> > called out, the zero-step mess really needs to be solved in a more robust fashion.
> > 
> > So this?
> Looks good to me for non-TDX side.
> 
> For TDX, could we provide below fix based on your change?

Hmm, I'd prefer not to, mainly because I don't want to special case things even
more in the common MMU code, e.g. I don't want to bleed the "no memslot == exit"
logic into multiple locations.  And very strictly speaking, a memory fault exit
isn't guaranteed, as userspace could set a new memory region before the vCPU
retries the fault.

Returning -EAGAIN isn't an option because that would break userspace (e.g. our
VMM doesn't handle EAGAIN and supports SNP), and documenting the behavior would
be weird.  For KVM_PRE_FAULT_MEMORY, KVM's documentation can simply state that
EAGAIN is returned KVM encounters temporary resource contention and that userspace
should simply try again.  It's an ABI change, but for a nascent ioctl() and a
scenario that won't be hit in practice, so I'm confident we can make the change
without breaking userspace.

And again, this is an unfortunate side effect of zero-step; there's no such
restriction for SNP, and ideally the TDX zero-step pain will be solved and this
would also go away for TDX too, so I'm hesitant to bake this behavior into KVM's
ABI.

My best idea is to special case this in tdx_handle_ept_violation().  It's also
very gross, but at least the nastiness is limited to the zero-step mitigation
mess, and is co-located with the code that doesn't actually play nice with
RET_PF_RETRY.  E.g.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..ca47d08ae112 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1907,6 +1907,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
         * handle retries locally in their EPT violation handlers.
         */
        while (1) {
+               struct kvm_memory_slot *slot;
+
                ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
 
                if (ret != RET_PF_RETRY || !local_retry)
@@ -1920,6 +1922,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
                        break;
                }
 
+               slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
+               if (slot && slot->flags & KVM_MEMSLOT_INVALID)
+                       break;
+
                cond_resched();
        }
        return ret;

> For private fault, -EFAULT will be returned to userspace after the retry anyway
> after the slot is completed removed, which is unlike non-private faults that go
> to emulate path after retry.
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4602,6 +4602,11 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>                 if (fault->prefetch)
>                         return -EAGAIN;
> 
> +               if (fault->is_private) {
> +                       kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +                       return -EFAULT;
> +               }
> +
>                 return RET_PF_RETRY;
>         }
> 
> 
> And would you mind if I included your patch in my next version? I can update the
> related selftests as well.

Yes, please do!

