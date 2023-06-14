Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A50F73061A
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 19:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbjFNRfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 13:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjFNRfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 13:35:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E730189
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 10:35:19 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-25dbcf8ad37so718643a91.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 10:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686764119; x=1689356119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FINHWVuF9dPFXtAFp+YSQIwqxWqp3Z+QxlozugrxYpA=;
        b=rrPILjJs9pdAauHMA0OgQJafLDH468H2vIlWGQdJnuFGjyQLoATb71ofxIKTzT/q0R
         Uzkn8iA2MzM08yzOzp/QxN9H55AsYBjFSP3kE8TBk0p5PQBsUyalxjZZrCYHM/bNAUUU
         bb62ZJ0ToeeIGKgaNO31tQJnTmgsDLdgNJyhRpjAT2F4wvZROS6RiwEttUUBOItwGtNt
         Xa0PUJt0IXaurKfBtDxj+g7zBW4cnNelSypFGXOBwORe6X7FekgR1VsDLsA7HNSJhaAp
         fSll4zmfaGYBGpQ8XqmHOuv3PuH11DaVMAcWQL4khwck3gYk0fdPVUFchD5gqr5SNDCF
         GMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686764119; x=1689356119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FINHWVuF9dPFXtAFp+YSQIwqxWqp3Z+QxlozugrxYpA=;
        b=KJoX6pX85ZvgfuROuRLMfYw87GonD98Fd92DqQImL5nKKqEuNSEKOJgToJq9F+0SxJ
         EFzPFgwqGIf4cbKSKUEPHHwAL3Rq4McUWpr6REhzr/WOA8Xu7gwTnNzyl3sAu8Gt+Xwk
         CXfhlTLI8Ly1a/Byy9wAXtReTJ/Fg3ttMI5w4yXGe5QaNFulG6VxmD8MAQfDvo15B34T
         wMfRWeFNFiLxPgibCjVsgmAEnCmZ/AB58VxDJa2PRe6nqndXmEsyAICbm8ea9U6/sbz0
         qjbyC5LTonT2ff2+OHg0c3o1O7g7c7eu4qv2ZlJUzC4lq2wu3LguBSPCuIVzIEoctd8P
         iblw==
X-Gm-Message-State: AC+VfDyKiIF7b/3dBKKC+kWsayDKZrc7nUgVH8+Cr/drQMJMMX9ADaV9
        Ck3G98rCW+wlVnWDsY7B/qYmu2H2Gw0=
X-Google-Smtp-Source: ACHHUZ5G9Xl6UoRXgEU6Nww4P4YArg3b+1LkloAzJJUxjU4WXFRQsFZeC273Urf/42A1BcgQK4zqtQCKVAY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:da03:b0:25d:cf9f:5a93 with SMTP id
 e3-20020a17090ada0300b0025dcf9f5a93mr407104pjv.2.1686764118914; Wed, 14 Jun
 2023 10:35:18 -0700 (PDT)
Date:   Wed, 14 Jun 2023 10:35:17 -0700
In-Reply-To: <20230602161921.208564-4-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
Message-ID: <ZIn6VQSebTRN1jtX@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> +The 'gpa' and 'len' (in bytes) fields describe the range of guest
> +physical memory to which access failed, i.e. [gpa, gpa + len). 'flags' is a
> +bitfield indicating the nature of the access: valid masks are
> +
> +  - KVM_MEMORY_FAULT_FLAG_WRITE:     The failed access was a write.
> +  - KVM_MEMORY_FAULT_FLAG_EXEC:      The failed access was an exec.

We should also define a READ flag, even though it's not strictly necessary.  That
gives userspace another way to detect "bad" data (flags should never be zero), and
it will allow us to use the same RWX bits that KVM_SET_MEMORY_ATTRIBUTES uses,
e.g. R = BIT(0), W = BIT(1), X = BIT(2) (which just so happens to be the same
RWX definitions EPT uses).

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0e571e973bc2..69a221f71914 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2288,4 +2288,13 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>  /* Max number of entries allowed for each kvm dirty ring */
>  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>  
> +/*
> + * Attempts to set the run struct's exit reason to KVM_EXIT_MEMORY_FAULT and
> + * populate the memory_fault field with the given information.
> + *
> + * WARNs and does nothing if the exit reason is not KVM_EXIT_UNKNOWN, or if
> + * 'vcpu' is not the current running vcpu.
> + */
> +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,

Tagging a globally visible, non-static function as "inline" is odd, to say the
least.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fd80a560378c..09d4d85691e1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4674,6 +4674,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  
>  		return r;
>  	}
> +	case KVM_CAP_MEMORY_FAULT_INFO: {

No need for curly braces.  But that's moot because there's no need for this at
all, just let it fall through to the default handling, which KVM already does for
a number of other informational capabilities.

> +		return -EINVAL;
> +	}
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> @@ -6173,3 +6176,35 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
>  
>  	return init_context.err;
>  }
> +
> +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,

I strongly prefer to avoid "populate" and "efault".  Avoid "populate" because
that verb will become stale the instance we do anything else in the helper.
Avoid "efault" because it's imprecise, i.e. this isn't to be used for just any
old -EFAULT scenario.  Something like kvm_handle_guest_uaccess_fault()? Definitely
open to other names (especially less verbose names).

> +				     uint64_t gpa, uint64_t len, uint64_t flags)
> +{
> +	if (WARN_ON_ONCE(!vcpu))
> +		return;

Drop this and instead invoke the helper if and only if vCPU is guaranteed to be
valid, e.g. in a future patch, don't add a conditional call to __kvm_write_guest_page(),
just handle the -EFAULT in kvm_vcpu_write_guest_page().  If the concern is that
callers would need to manually check "r == -EFAULT", this helper could take in the
error code, same as we do for kvm_handle_memory_failure(), e.g. do 

	if (r != -EFAULT)
		return;

here.  This is also an argument for using a less prescriptive name for the helper.

> +
> +	preempt_disable();
> +	/*
> +	 * Ensure the this vCPU isn't modifying another vCPU's run struct, which
> +	 * would open the door for races between concurrent calls to this
> +	 * function.
> +	 */
> +	if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
> +		goto out;

Meh, this is overkill IMO.  The check in mark_page_dirty_in_slot() is an
abomination that I wish didn't exist, not a pattern that should be copied.  If
we do keep this sanity check, it can simply be

	if (WARN_ON_ONCE(vcpu != kvm_get_running_vcpu()))
		return;

because as the comment for kvm_get_running_vcpu() explains, the returned vCPU
pointer won't change even if this task gets migrated to a different pCPU.  If
this code were doing something with vcpu->cpu then preemption would need to be
disabled throughout, but that's not the case.

> +	/*
> +	 * Try not to overwrite an already-populated run struct.
> +	 * This isn't a perfect solution, as there's no guarantee that the exit
> +	 * reason is set before the run struct is populated, but it should prevent
> +	 * at least some bugs.
> +	 */
> +	else if

Kernel style is to not use if-elif-elif if any of the preceding checks are terminal,
i.e. return or goto.  There's a good reason for that style/rule too, as it allows
avoiding weirdness like this where there's a big block comment in the middle of
an if-elif sequence.

> (WARN_ON_ONCE(vcpu->run->exit_reason != KVM_EXIT_UNKNOWN))

As I've stated multiple times, this can't WARN in "normal" builds because userspace
can modify kvm_run fields at will.  I do want a WARN as it will allow fuzzers to
find bugs for us, but it needs to be guarded with a Kconfig (or maybe a module
param).  One idea would be to make the proposed CONFIG_KVM_PROVE_MMU[*] a generic
Kconfig and use that.

And this should not be a terminal condition, i.e. KVM should WARN but continue on.
I am like 99% confident there are existing cases where KVM fills exit_reason
without actually exiting, i.e. bailing will immediately "break" KVM.  On the other
hand, clobbering what came before *might* break KVM, but it might work too.  More
thoughts below.

[*] https://lkml.kernel.org/r/20230511235917.639770-8-seanjc%40google.com

> +		goto out;

Folding in your other reply, as I wanted the full original context.

> What I intended this check to guard against was the first problematic
> case (A) I called out in the cover letter
>
> > The implementation strategy for KVM_CAP_MEMORY_FAULT_INFO has risks: for
> > example, if there are any existing paths in KVM_RUN which cause a vCPU
> > to (1) populate the kvm_run struct then (2) fail a vCPU guest memory
> > access but ignore the failure and then (3) complete the exit to
> > userspace set up in (1), then the contents of the kvm_run struct written
> > in (1) will be corrupted.
>
> What I wrote was actually incorrect, as you may see: if in (1) the
> exit reason != KVM_EXIT_UNKNOWN then the exit-reason-unset check will
> prevent writing to the run struct. Now, if for some reason this flow
> involved populating most of the run struct in (1) but only setting the
> exit reason in (3) then we'd still have a problem: but it's not
> feasible to anticipate everything after all :)
>
> I also mentioned a different error case (B)
>
> > Another example: if KVM_RUN fails a guest memory access for which the
> > EFAULT is annotated but does not return the EFAULT to userspace, then
> > later returns an *un*annotated EFAULT to userspace, then userspace will
> > receive incorrect information.
>
> When the second EFAULT is un-annotated the presence/absence of the
> exit-reason-unset check is irrelevant: userspace will observe an
> annotated EFAULT in place of an un-annotated one either way.
>
> There's also a third interesting case (C) which I didn't mention: an
> annotated EFAULT which is ignored/suppressed followed by one which is
> propagated to userspace. Here the exit-reason-unset check will prevent
> the second annotation from being written, so userspace sees an
> annotation with bad contents, If we believe that case (A) is a weird
> sequence of events that shouldn't be happening in the first place,
> then case (C) seems more important to ensure correctn`ess in. But I
> don't know anything about how often (A) happens in KVM, which is why I
> want others' opinions.
>
> So, should we drop the exit-reason-unset check (and the accompanying
> patch 4) and treat existing occurrences of case (A) as bugs, or should
> we maintain the check at the cost of incorrect behavior in case (C)?
> Or is there another option here entirely?
>
> Sean, I remember you calling out that some of the emulated mmio code
> follows the pattern in (A), but it's been a while and my memory is
> fuzzy. What's your opinion here?

I got a bit (ok, way more than a bit) lost in all of the (A) (B) (C) madness.  I
think this what you intended for each case?

  (A) if there are any existing paths in KVM_RUN which cause a vCPU
      to (1) populate the kvm_run struct then (2) fail a vCPU guest memory
      access but ignore the failure and then (3) complete the exit to
      userspace set up in (1), then the contents of the kvm_run struct written
      in (1) will be corrupted.

  (B) if KVM_RUN fails a guest memory access for which the EFAULT is annotated
      but does not return the EFAULT to userspace, then later returns an *un*annotated
      EFAULT to userspace, then userspace will receive incorrect information.

  (C) an annotated EFAULT which is ignored/suppressed followed by one which is
      propagated to userspace. Here the exit-reason-unset check will prevent the
      second annotation from being written, so userspace sees an annotation with
      bad contents, If we believe that case (A) is a weird sequence of events
      that shouldn't be happening in the first place, then case (C) seems more
      important to ensure correctness in. But I don't know anything about how often
      (A) happens in KVM, which is why I want others' opinions.

(A) does sadly happen.  I wouldn't call it a "pattern" though, it's an unfortunate
side effect of deficiencies in KVM's uAPI.

(B) is the trickiest to defend against in the kernel, but as I mentioned in earlier
versions of this series, userspace needs to guard against a vCPU getting stuck in
an infinite fault anyways, so I'm not _that_ concerned with figuring out a way to
address this in the kernel.  KVM's documentation should strongly encourage userspace
to take action if KVM repeatedly exits with the same info over and over, but beyond
that I think anything else is nice to have, not mandatory.

(C) should simply not be possible.  (A) is very much a "this shouldn't happen,
but it does" case.  KVM provides no meaningful guarantees if (A) does happen, so
yes, prioritizing correctness for (C) is far more important.

That said, prioritizing (C) doesn't mean we can't also do our best to play nice
with (A).  None of the existing exits use anywhere near the exit info union's 256
bytes, i.e. there is tons of space to play with.  So rather than put memory_fault
in with all the others, what if we split the union in two, and place memory_fault
in the high half (doesn't have to literally be half, but you get the idea).  It'd
kinda be similar to x86's contributory vs. benign faults; exits that can't be
"nested" or "speculative" go in the low half, and things like memory_fault go in
the high half.

That way, if (A) does occur, the original information will be preserved when KVM
fills memory_fault.  And my suggestion to WARN-and-continue limits the problematic
scenarios to just fields in the second union, i.e. just memory_fault for now.
At the very least, not clobbering would likely make it easier for us to debug when
things go sideways.

And rather than use kvm_run.exit_reason as the canary, we should carve out a
kernel-only, i.e. non-ABI, field from the union.  That would allow setting the
canary in common KVM code, which can't be done for kvm_run.exit_reason because
some architectures, e.g. s390 (and x86 IIRC), consume the exit_reason early on
in KVM_RUN.

E.g. something like this (the #ifdefs are heinous, it might be better to let
userspace see the exit_canary, but make it abundantly clear that it's not ABI).

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 143abb334f56..233702124e0a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -511,16 +511,43 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID     (1 << 0)
                        __u32 flags;
                } notify;
+               /* Fix the size of the union. */
+               char padding[128];
+       };
+
+       /*
+        * This second KVM_EXIT_* union holds structures for exits that may be
+        * triggered after KVM has already initiated a different exit, and/or
+        * may be filled speculatively by KVM.  E.g. because of limitations in
+        * KVM's uAPI, a memory fault can be encountered after an MMIO exit is
+        * initiated and kvm_run.mmio is filled.  Isolating these structures
+        * from the primary KVM_EXIT_* union ensures that KVM won't clobber
+        * information for the original exit.
+        */
+       union {
                /* KVM_EXIT_MEMORY_FAULT */
                struct {
                        __u64 flags;
                        __u64 gpa;
                        __u64 len;
                } memory_fault;
-               /* Fix the size of the union. */
-               char padding[256];
+               /* Fix the size of this union too. */
+#ifndef __KERNEL__
+               char padding2[128];
+#else
+               char padding2[120];
+#endif
        };
 
+#ifdef __KERNEL__
+       /*
+        * Non-ABI, kernel-only field that KVM uses to detect bugs related to
+        * filling exit_reason and the exit unions, e.g. to guard against
+        * clobbering a previous exit.
+        */
+       __u64 exit_canary;
+#endif
+
        /* 2048 is the size of the char array used to bound/pad the size
         * of the union that holds sync regs.
         */

