Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130A93DBE1A
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 20:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhG3SIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 14:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhG3SIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 14:08:35 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45783C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 11:08:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso21989191pjq.2
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U22IQhYTRPCkpysTSxxrY3OXIOUsjrcBM5qAQtaDVGA=;
        b=BJssnUAjT5z70MZ1iYT6dX4sF9p17EqqxIOWql+F9Uk8seuT1Mmsl7bvn2fUo1Pxfs
         C0mI9NqkKrBsVLH21YczNMMZWnEb00G/LeWP+XWxMl9sekNLaTj2vC3Vnm74nx/G0dMn
         eNiQ1lqpoxIHiIUv6WBxrWXpe/VXZLNqKGHiwmR5kARWiynI3rNGZ1js4fLeXV5ynjeg
         6EPIuYKuAoyH8YJ7gJSSc90S35Rxgbrix/L5TDPDQWBMyyFfmmrNWLdpJnEQDHoj1xaA
         PzOZepFRIe5aFLECjxaqVYxxkEyfC6P5u5zunGvK2WGla6dONwBDm1nEg60N/MesbBpP
         35pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U22IQhYTRPCkpysTSxxrY3OXIOUsjrcBM5qAQtaDVGA=;
        b=M2vu/9OG3HKbrnus5rVWBWWExlixQWD+jL9VT+RK9MOwM/L973BUxYgxyQnohaQLEA
         GvMudy7aw1TVFgVWgW+MCfdKh+1O6GEiXxATWO69trgONRoI5k1jI0GN+EotuV0Svspj
         vyFSzzGZnMU1ZT2kqcjXqLneO3km6rt61pEIpF+HrgH1JPpE4cOVxyq04aXkmBkryDHM
         jEIU1qHrGYMg2uKdsziuJfuNmDR4zcrfP0H1igHYP0IOeRA+/SG4h+R3MgfW57P59eQ7
         SpnDulooS8JcZI4xrWNTx3EpAWU42rIgkyLL9aTrd3kMhKhnLEKAEQqB6LFjZ+IXXDAm
         PCiA==
X-Gm-Message-State: AOAM531zECqotETBXv9i4oxSFSNSHnaTkb6zdr7Y0hX/tg0lxmsJIvIK
        TbaCgrP2yk8y9BtSwo7WYQMXSA==
X-Google-Smtp-Source: ABdhPJzMaCyOmywV/AHhhMPn1KKKBoyFNH+eqA4FYc+b1MRy4AW0ZMGXtjZhMOgw+LQ8/a9GL5IIXQ==
X-Received: by 2002:a17:90b:250f:: with SMTP id ns15mr4291311pjb.26.1627668509611;
        Fri, 30 Jul 2021 11:08:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h7sm1368044pjs.38.2021.07.30.11.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 11:08:29 -0700 (PDT)
Date:   Fri, 30 Jul 2021 18:08:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v5 02/13] KVM: x86: Refactor tsc synchronization code
Message-ID: <YQRAGSJ1PxwXA2m/@google.com>
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729173300.181775-3-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021, Oliver Upton wrote:
> Refactor kvm_synchronize_tsc to make a new function that allows callers
> to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
> for the sake of participating in TSC synchronization.
> 
> This changes the locking semantics around TSC writes.

"refactor" and "changes the locking semantics" are somewhat contradictory.  The
correct way to do this is to first change the locking semantics, then extract the
helper you want.  That makes review and archaeology easier, and isolates the
locking change in case it isn't so safe after all.

> Writes to the TSC will now take the pvclock gtod lock while holding the tsc
> write lock, whereas before these locks were disjoint.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> +/*
> + * Infers attempts to synchronize the guest's tsc from host writes. Sets the
> + * offset for the vcpu and tracks the TSC matching generation that the vcpu
> + * participates in.
> + *
> + * Must hold kvm->arch.tsc_write_lock to call this function.

Drop this blurb, lockdep assertions exist for a reason :-)

> + */
> +static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
> +				  u64 ns, bool matched)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	bool already_matched;

Eww, not your code, but "matched" and "already_matched" are not helpful names,
e.g. they don't provide a clue as to _what_ matched, and thus don't explain why
there are two separate variables.  And I would expect an "already" variant to
come in from the caller, not the other way 'round.

  matched         => freq_matched
  already_matched => gen_matched

> +	unsigned long flags;
> +
> +	lockdep_assert_held(&kvm->arch.tsc_write_lock);
> +
> +	already_matched =
> +	       (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
> +
> +	/*
> +	 * We track the most recent recorded KHZ, write and time to
> +	 * allow the matching interval to be extended at each write.
> +	 */
> +	kvm->arch.last_tsc_nsec = ns;
> +	kvm->arch.last_tsc_write = tsc;
> +	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
> +
> +	vcpu->arch.last_guest_tsc = tsc;
> +
> +	/* Keep track of which generation this VCPU has synchronized to */
> +	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
> +	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
> +	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
> +
> +	kvm_vcpu_write_tsc_offset(vcpu, offset);
> +
> +	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);

I believe this can be spin_lock(), since AFAICT the caller _must_ disable IRQs
when taking tsc_write_lock, i.e. we know IRQs are disabled at this point.

> +	if (!matched) {
> +		/*
> +		 * We split periods of matched TSC writes into generations.
> +		 * For each generation, we track the original measured
> +		 * nanosecond time, offset, and write, so if TSCs are in
> +		 * sync, we can match exact offset, and if not, we can match
> +		 * exact software computation in compute_guest_tsc()
> +		 *
> +		 * These values are tracked in kvm->arch.cur_xxx variables.
> +		 */
> +		kvm->arch.nr_vcpus_matched_tsc = 0;
> +		kvm->arch.cur_tsc_generation++;
> +		kvm->arch.cur_tsc_nsec = ns;
> +		kvm->arch.cur_tsc_write = tsc;
> +		kvm->arch.cur_tsc_offset = offset;

IMO, adjusting kvm->arch.cur_tsc_* belongs outside of pvclock_gtod_sync_lock.
Based on the existing code, it is protected by tsc_write_lock.  I don't care
about the extra work while holding pvclock_gtod_sync_lock, but it's very confusing
to see code that reads variables outside of a lock, then take a lock and write
those same variables without first rechecking.

> +		matched = false;

What's the point of clearing "matched"?  It's already false...

> +	} else if (!already_matched) {
> +		kvm->arch.nr_vcpus_matched_tsc++;
> +	}
> +
> +	kvm_track_tsc_matching(vcpu);
> +	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
> +}
> +
