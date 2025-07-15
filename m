Return-Path: <kvm+bounces-52493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FDC0B05A78
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 14:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86DF016AE6A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 12:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC592E0901;
	Tue, 15 Jul 2025 12:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2SCn59ee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E64F26D4F2
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 12:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752583389; cv=none; b=IyQ0Dw+o7tgiJL6xwINeaOGr+E2tF1nTf+JCpqAZjVDeXpVlZG4LGMgIrK5VyA+ymnNE1yFu7MflXBlqWGsVtEK6iUad3+bg6R+czIXc1xJ+NXSKvFRe1+MMB9DiqXWe5/Reh6kqst/wuOY33WWDLBqHkfSRR7nqwzJG2RKjH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752583389; c=relaxed/simple;
	bh=Bow8Whodk8OpZ1fFxs24Ye77cNnQKi5oxNsWfrNHhLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQlbx4M6z9qCozAJjSd44CxE3ntp0kCM1sqx8yMPeRQzVT588WG0lye9YS8ZJVF0irue/aciezZ4DgHgFBuhZQsiCH6UGRkLvhYXPWQ6CyePSknnoZm4DhY0uVel/KjdVogeQb/d349uXX844gT1gDslVj68w/OS486SRrkR0nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2SCn59ee; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a50956e5d3so4140439f8f.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 05:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752583386; x=1753188186; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HLCrHLHQ+bmiE5FmpjfpP8oXqhj6N2L4tcvx67/KA60=;
        b=2SCn59eeg9Lnr0Wxi9i5E/OgTmyME3JPtTtGAxdqK09fgHWU0DPbAhOiEGttYdslw9
         3QAzb/Eu0um2PEYqLMBypTP3Bpky6Jf1tDfMKlRIxmj2imetpBc0tzH4BP3HfmFNWCMz
         Qima4CKItHgcATyec8EXSig83XzQEoaOj0yWsMOJ74Leipm0bzRcdXDFFd5FlHTcWR7P
         mweXIFEoLhGsmc+E6XrEvT1weRqhBEYSSL8paWNXIfUQLTNkaHPgYLD75Lic0ycQMTDU
         lNEyxnJtlqyLftweYn73YjWu6RxPTVn0hLjq9rFDEkoslKUY+L5vIkkAPmHwOhPoiTxg
         /kcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752583386; x=1753188186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLCrHLHQ+bmiE5FmpjfpP8oXqhj6N2L4tcvx67/KA60=;
        b=Mde/bzxLjrLBOX8WIj8zKN4TpTrrQkb3vazI1HRtqWV5E9TktiaMepHSFWcyfE1nNn
         79iSgbf9T/4wvZ1imXhQnHrTSlcyzMu9r1wllxYCvZ/EoaMWtHTYAfNuFekFaOHMOJ54
         +2vxin3VbXn+MVvc276N2fFFLKyyKWFCg5yBbosLP3R/gUe2qqECE3ygY4pChiIB1rMH
         2zZI6HxUFmpuG4SiqoK9Q4c4c5YoM/WsEdtekPmTFXBbXUfnIOwvBMJKw2sLk7fr5h9S
         xYK2AX+ciMbb2WBKB3ELVTTNGhr1FJE/MVew06B7kvb7EIBpWKrT9DmivUBfr2/xb+mj
         Fa/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSOTBus+eac3vEq+aiz2QLYPSTnPMo4ATZkLme7Ovorqq2E3DHlrjbTsaqrRU1SfjGJmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJQad2ZaepFYhia6k9DI7Q7f3OfT9eDqrIKahRUhQDQqMl2+9I
	GGyWv8WraHgQ05baybhBVVvx4c4H/vujYsZdSGdz9VUjCN06CdQwy+rt3FGynhK4Pw==
X-Gm-Gg: ASbGncuY9r5UiqGL4ekpOXpzRNRNTCcu/VUAtEIF3meHV39Q4bNgQdYKQ8TAhTeEEpE
	Ox3kG2sr3OYFS1TXJ11R//ZCOeEt7mJIU6FOBrf/JX+p933LsLn2JiP7ubRFu+ObBy5Ml4HQAFv
	wRoOmTgUdjgOne+E930wo8iBQ4qTlfZP3ExIzhyHOci/927qYpA2ehG2aFuMjF+hilZ7kbSmAr8
	rIeMiL4PKNct+oJ4huQTAXHulYWyHt2ILXjaVXyXIsFXODUkrVp1I0YjUW9l+FSaWzacLVGui1Q
	dqE0YuysEn9sapuDigvMY2QC5fzP1grbnk3Booj01xJ22usdhuS1L4TteaHAjJmmgP2xSNBRsFj
	QqJLKeO+OSkCS6bw9CwWErsWEi542N2eXYFGJlnlWn+SZzIldunO7YmLr9GQLdySsENYLcw==
X-Google-Smtp-Source: AGHT+IEjtd6f/7IfvZJOyn66KWqMNuxRmgibcj9Nl8nmoK9MypT8QzVR2KZI/EnuhOhULIAj3dtnmA==
X-Received: by 2002:a05:6000:985:b0:3a5:2949:6c38 with SMTP id ffacd0b85a97d-3b60a1bad1emr2110664f8f.52.1752583386084;
        Tue, 15 Jul 2025 05:43:06 -0700 (PDT)
Received: from google.com (120.142.205.35.bc.googleusercontent.com. [35.205.142.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562797b956sm18158585e9.17.2025.07.15.05.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 05:43:05 -0700 (PDT)
Date: Tue, 15 Jul 2025 12:43:01 +0000
From: Keir Fraser <keirf@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 3/3] KVM: Avoid synchronize_srcu() in
 kvm_io_bus_register_dev()
Message-ID: <aHZM1ZhTsET5AE91@google.com>
References: <20250624092256.1105524-1-keirf@google.com>
 <20250624092256.1105524-4-keirf@google.com>
 <aFrANSe6fJOfMpOC@google.com>
 <aGJf7v9EQoEZiQUk@google.com>
 <aGwWvp_JeWe9tIJx@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGwWvp_JeWe9tIJx@google.com>

On Mon, Jul 07, 2025 at 11:49:34AM -0700, Sean Christopherson wrote:
> On Mon, Jun 30, 2025, Keir Fraser wrote:
> > On Tue, Jun 24, 2025 at 08:11:49AM -0700, Sean Christopherson wrote:
> > > +Li
> > > 
> > > On Tue, Jun 24, 2025, Keir Fraser wrote:
> > > > Device MMIO registration may happen quite frequently during VM boot,
> > > > and the SRCU synchronization each time has a measurable effect
> > > > on VM startup time. In our experiments it can account for around 25%
> > > > of a VM's startup time.
> > > > 
> > > > Replace the synchronization with a deferred free of the old kvm_io_bus
> > > > structure.
> > > > 
> > > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > > ---
> > > >  include/linux/kvm_host.h |  1 +
> > > >  virt/kvm/kvm_main.c      | 10 ++++++++--
> > > >  2 files changed, 9 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 3bde4fb5c6aa..28a63f1ad314 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -205,6 +205,7 @@ struct kvm_io_range {
> > > >  struct kvm_io_bus {
> > > >  	int dev_count;
> > > >  	int ioeventfd_count;
> > > > +	struct rcu_head rcu;
> > > >  	struct kvm_io_range range[];
> > > >  };
> > > >  
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index eec82775c5bf..b7d4da8ba0b2 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -5924,6 +5924,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(kvm_io_bus_read);
> > > >  
> > > > +static void __free_bus(struct rcu_head *rcu)
> > > > +{
> > > > +	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
> > > > +
> > > > +	kfree(bus);
> > > > +}
> > > > +
> > > >  int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> > > >  			    int len, struct kvm_io_device *dev)
> > > >  {
> > > > @@ -5962,8 +5969,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> > > >  	memcpy(new_bus->range + i + 1, bus->range + i,
> > > >  		(bus->dev_count - i) * sizeof(struct kvm_io_range));
> > > >  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> > > > -	synchronize_srcu_expedited(&kvm->srcu);
> > > > -	kfree(bus);
> > > > +	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
> > > 
> > > I'm 99% certain this will break ABI.  KVM needs to ensure all readers are
> > > guaranteed to see the new device prior to returning to userspace.
> > 
> > I'm not sure I understand this. How can userspace (or a guest VCPU) know that
> > it is executing *after* the MMIO registration, except via some form of
> > synchronization or other ordering of its own? For example, that PCI BAR setup
> > happens as part of PCI probing happening early in device registration in the
> > guest OS, strictly before the MMIO region will be accessed. Otherwise the
> > access is inherently racy against the registration?
> 
> Yes, guest software needs its own synchronization.  What I am pointing out is that,
> very strictly speaking, KVM relies on synchronize_srcu_expedited() to ensure that
> KVM's emulation of MMIO accesses are correctly ordered with respect to the guest's
> synchronization.
> 
> It's legal, though *extremely* uncommon, for KVM to emulate large swaths of guest
> code, including emulated MMIO accesses.  If KVM grabs kvm->buses at the start of
> an emulation block, and then uses that reference to resolve MMIO, it's theoretically
> possible for KVM to mishandle an access due to using a stale bus.
> 
> Today, such scenarios are effectively prevented by synchronize_srcu_expedited().
> Using kvm->buses outside of SRCU protection would be a bug (per KVM's locking
> rules), i.e. a large emulation block must take and hold SRCU for its entire
> duration.  And so waiting for all SRCU readers to go away ensures that the new
> kvm->buses will be observed if KVM starts a new emulation block.
> 
> AFAIK, the only example of such emulation is x86's handle_invalid_guest_state().
> And in practice, it's probably impossible for the compiler to keep a reference to
> kvm->buses across multiple invocations of kvm_emulate_instruction() while still
> honoring the READ_ONCE() in __rcu_dereference_check().
>  
> But I don't want to simply drop KVM's synchronization, because we need a rule of
> some kind to ensure correct ordering, even if it's only for documentation purposes
> for 99% of cases.  And because the existence of kvm_get_bus() means that it would
> be possible for KVM to grab a long-term reference to kvm->buses and use it across
> emulation of multiple instructions (though actually doing that would be all kinds
> of crazy).
> 
> > > I'm quite confident there are other flows that rely on the synchronization,
> > > the vGIC case is simply the one that's documented.
> > 
> > If they're in the kernel they can be fixed? If necessary I'll go audit the callers.
> 
> Yes, I'm sure there's a solution.  Thinking more about this, you make a good
> point that KVM needs to order access with respect to instruction execution, not
> with respect to the start of KVM_RUN.
> 
> For all intents and purposes, holding kvm->srcu across VM-Enter/VM-Exit is
> disallowed (though I don't think this is formally documented), i.e. every
> architecture is guaranteed to do srcu_read_lock() after a VM-Exit, prior to
> reading kvm->buses.  And srcu_read_lock() contains a full smp_mb(), which ensures
> KVM will get a fresh kvm->buses relative to the instruction that triggered the
> exit.

I've got a new patch series ready to go, but thinking more about the
one-off accesses after a VM-Exit: I think VM-Exit is a barrier on all
architectures? That would mean the changes to include
smp_mb__after_srcu_read_lock() are unnecessary and confusing. Maybe I
can drop those hunks. What do you think?

 Regards,
 Keir

> 
> So for the common case of one-off accesses after a VM-Exit, I think we can simply
> add calls to smp_mb__after_srcu_read_lock() (which is a nop on all architectures)
> to formalize the dependency on reacquiring SRCU.  AFAICT, that would also suffice
> for arm64's use of kvm_io_bus_get_dev().  And then add an explicit barrier of some
> kind in handle_invalid_guest_state()?
> 
> Then to prevent grabbing long-term references to a bus, require kvm->slots_lock
> in kvm_get_bus() (and special case the kfree() in VM destruction).
> 
> So something like this?  I think the barriers would pair with the smp_store_release()
> in rcu_assign_pointer()?
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4953846cb30d..057fb4ce66b0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5861,6 +5861,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>                 if (kvm_test_request(KVM_REQ_EVENT, vcpu))
>                         return 1;
>  
> +               /* Or maybe smp_mb()?  Not sure what this needs to be. */
> +               barrier();
> +
>                 if (!kvm_emulate_instruction(vcpu, 0))
>                         return 0;
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3bde4fb5c6aa..066438b6571a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -967,9 +967,8 @@ static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
>  
>  static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
>  {
> -       return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
> -                                     lockdep_is_held(&kvm->slots_lock) ||
> -                                     !refcount_read(&kvm->users_count));
> +       return rcu_dereference_protected(kvm->buses[idx],
> +                                        lockdep_is_held(&kvm->slots_lock));
>  }
>  
>  static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index eec82775c5bf..7b0e881351f7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1228,7 +1228,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  out_err_no_arch_destroy_vm:
>         WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>         for (i = 0; i < KVM_NR_BUSES; i++)
> -               kfree(kvm_get_bus(kvm, i));
> +               kfree(rcu_dereference_check(kvm->buses[i], &kvm->srcu,
> +                                           !refcount_read(&kvm->users_count));
>         kvm_free_irq_routing(kvm);
>  out_err_no_irq_routing:
>         cleanup_srcu_struct(&kvm->irq_srcu);
> @@ -5847,6 +5848,9 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>                 .len = len,
>         };
>  
> +       /* comment goes here */
> +       smp_mb__after_srcu_read_lock();
> +
>         bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
>         if (!bus)
>                 return -ENOMEM;
> @@ -5866,6 +5870,9 @@ int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
>                 .len = len,
>         };
>  
> +       /* comment goes here */
> +       smp_mb__after_srcu_read_lock();
> +
>         bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
>         if (!bus)
>                 return -ENOMEM;
> @@ -6025,6 +6032,9 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  
>         srcu_idx = srcu_read_lock(&kvm->srcu);
>  
> +       /* comment goes here */
> +       smp_mb__after_srcu_read_lock();
> +
>         bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
>         if (!bus)
>                 goto out_unlock;
> 
> 

