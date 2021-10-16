Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA381430317
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 16:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhJPOsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 10:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbhJPOsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Oct 2021 10:48:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937B9C061570;
        Sat, 16 Oct 2021 07:45:58 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634395556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=kAFJBnSLTqfQsfjUFXNB8J7JS9w/yK8JoPLJSMwqBsk=;
        b=xSvehYeO8Sj+DDJIhOeoHgvNy60QsxoGYyhV6WBimWN89DEAbwWIeAocnrvHxtbVSdpwIc
        oaRgq/oA2C9XmyvG9ne0Gdjt8FF5rL26h9oeNmP1zRpOO1zZ9CCDSFd1kDkGxwaG/YKxKa
        qcLhtGbD6Zpr+ZqTVrquSbXPGT67ZAmMxBDevR2H3PVmee68/oXzxj4VF4h6XNMAXtJgje
        HchKoMfGcHdKFfOcCGLDOf04DuJi0lDmCNA+rqJw6+NEY37Zuz7khj6gyCzWGGH0Jl0DHb
        oWA5D651LvoHnv28DK5a1CX27MZCJpQg8cN/9xEzlfUCKLGSGvwVysDf/L1IhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634395556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=kAFJBnSLTqfQsfjUFXNB8J7JS9w/yK8JoPLJSMwqBsk=;
        b=wbeCstOdFvMvE5iDLzW1wW5loi5KByTh/fzrMB+InIxr6QbntEnnSzv/hrvrP9Iwn7+l2b
        7zIcF/57xtPD5ZAg==
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <BYAPR11MB3256B3120DEB5FE0DD53B5B9A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
Date:   Sat, 16 Oct 2021 16:45:55 +0200
Message-ID: <87mtn93u58.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jing,

On Fri, Oct 15 2021 at 14:24, Jing2 Liu wrote:
> On 10/15/2021 5:36 PM, Thomas Gleixner wrote:
>> If you carefully look at part 2 of the rework, then you might notice that there
>> is a fundamental change which allows to do a real simplification for KVM FPU
>> handling:
>> 
>>    current->thread.fpu.fpstate
>> 
>> is now a pointer. So you can spare one FPU allocation because we can now
>> do:
>
> Trying to understand your point, seems struct fpu will add a guest_fpstate
> pointer. And this will be allocated when vcpu_create() by the following
> function. Swap between the two pointers in load/put. What I was thinking 
> is that vcpu keeps having guest_fpu and delete user_fpu.

unfortunately we can't do that in vcpu_create() because the thread doing
that is not necessarily the vCPU thread which invokes vcpu_run()
later. But that does not matter much.

So vcpu_create() will do

   vcpu->arch.guest_fpstate = fpu_alloc_guest_fpstate();

and in vcpu_run() invoke

    fpu_swap_kvm_fpstate(guest_fpstate, ...)

which in turn does:

int fpu_swap_kvm_fpstate(struct fpstate *guest_fps, bool enter_guest,
			 u64 restore_mask)
{
	struct fpu *fpu = &current->thread.fpu;
	struct fpstate *fps = fpu->fpstate;

	fpregs_lock();
	if (!test_thread_flag(TIF_NEED_FPU_LOAD))
		save_fpregs_to_fpstate(fpu);

	/* Swap fpstate */
	if (enter_guest) {
		fpu->__task_fpstate = fps;
		fpu->fpstate = guest_fps;
	} else {
		fpu->fpstate = fpu->__task_fpstate;
		fpu->__task_fpstate = NULL;
	}

	fps = fpu->fpstate;

	/*
	 * Once XFD support is added, XFP switching happens here
	 * right before the restore.
	 */
	restore_mask &= XFEATURE_MASK_FPSTATE;
	restore_fpregs_from_fpstate(fps, restore_mask);

	fpregs_mark_activate();
	fpregs_unlock();
	return 0;
}

That's a simplified version of what I have already running on top of the
FPU rework part 3, but you get the idea.

If you are curious:

  https://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git/log/?h=x86/fpu-3-kvm

If you compare that to the current KVM FPU swap handling then you'll
notice that there is only _one_ buffer required and in case that
TIF_NEED_FPU_RELOAD is set there is no memcpy() required either because
the state is already saved in the to be swapped out buffer.

That's a valuable cleanup and improvement independent of AMX.

See?

This also makes the confidential computing case less awkward because we
can do:

	if (!fpstate->is-scratch && !test_thread_flag(TIF_NEED_FPU_LOAD))
		save_fpregs_to_fpstate(fpu);

instead of the current hack of freeing guest_fpu. See the git tree.

Though I'm not sure whether the logic for this "is_scratch" optimization
is correct as I implemnted it, but I'm neither sure that the current
logic in KVM is correct. But that's just a implementation detail which
needs to be looked at.

XFD support will be also fully consistently integrated:

  XFD will be switched before the restore and this will be fully
  consistent with everything we are doing vs. host side support because
  current->thread.fpu.fpstate->xfd will always be the authoritive
  answer. No need to copy any information from one place to another.

Ergo: No 4 copies of XFD.

>> In a second step:
>> 
>> fpu_swap_kvm_fpu(bool enter_guest, u64 guest_needs_features) {
>>         possibly_reallocate(enter_guest, guest_needs_features);
>
> When KVM traps guest wrmsr XFD in #NM, I think KVM need allocate
> fpstate buffer for full features.
> Because in next vmexit, guest might have dynamic state and KVM
> can be preempted before running fpu_swap_kvm_fpu().
> Thus, here the current->thread.fpu.fpstate already has enough space
> for saving guest.

I think we are talking past each other.

You are looking at this from the point of view of what you have been
doing so far and I am looking at it from a design and abstraction point
of view.

That explains why we have different excpectations vs. XCR0/XFD/#NM.

So the regular boring case will be:

H   vcpu_run()
H   	fpu_swap_kvm_fpstate() <- Sets guest_fpstate->xfd
H
H        while (..) {
H           vmenter()

G              ....
G              ....     -> vmexit (unrelated to XCR0/XFD)

H           ...
H        }
H
H  	fpu_swap_kvm_fpstate() <- Sets user (task) XFD

Now let's look at the XFD/XCR0 intercept case:

H   vcpu_run()
H   	fpu_swap_kvm_fpstate() <- Sets guest_fpstate->xfd
H
H        while (..) {
H           vmenter()

G              ....
G              write to XFD/XCR0;        -> intercept

H           ...
H           if (reason == write to XFD/XCR0)) {
H                if (needs_action(guest_fpstate, $XFDVAL, $XCR0VAL)) {
H                        fpstate_set_realloc_request(guest_fpstate);
H
H                        break;
H
H                }
H           }
H           .....
H        }
H
H  	fpu_swap_kvm_fpstate()

fpu_swap_kvm_fpstate() will see the reallocation request in
guest_fpstate and act accordingly.

Both user and guest state are fully consistent at that point. Why?

It does not matter at all whether the wrmsrl(XFD) or XSETBV affecting
XCR0 in the guest happens because the guest decided it is cool to enable
it just for fun or because the guest took a #NM and wrote to XFD.

In both cases the XFD controlled component is in init state at that
point. So there is _nothing_ to save and _nothing_ which can be lost and
no buffer size problem at all.

Therefore it does also not matter whether the vCPU thread gets preempted
or not on the way out to fpu_swap_kvm_fpstate(). It's all still
consistent.

So fpu_swap_kvm_fpstate() will do in case of a reallocation request:

  1) Allocate new guest fpstate

     If that fails, it does a save and restore with the existing
     fpstates and return an error code which makes KVM drop out to user
     space to decide what to do.

     On success initialize the state properly including the new XFD
     value.

  2) Save guest state into new guest fpstate

  3) Restore host (user) state from the existing fpstate

See?

It does not even have to allocate a new host (user) fpstate to do
that. Why?

  Because once the fpstate pointer is flipped the state is consistent in
  both directions including XFD.

See?

Now if you think about the other way round then the same principle
applies:

  If the host (user) side of the vCPU thread used a dynamic state it has
  a large buffer, but that does not require the guest side buffer to be
  large as well.

  So this is what Paolo wanted, right? I was fighting that because with
  the existing three buffer scheme this cannot not work.

See?

The point is that: 

  - the simple state switching was impossible because the proposed host
    side infrastructure had the wrong abstraction:

    It just reallocated the register buffer, but did not give
    it a container which carries the other relevant information,
    i.e. features, sizes and importantly xfd.

  - the simple state switching was impossible because the user/guest FPU
    concept of KVM was preventing that.

  - it was tried to plug the reallocation into the wrong place:

    There is no point to do that from inside the vcpu_run() loop. It's a
    one off event and that extra overhead of going out to the place
    where this can be handled sanely does not matter at all.

Just to be clear: I'm not blamning you for any of this at all.

There have been enough senior people involved who should have seen the
obvious instead of misguiding you.

So please just forget the horrors which you went through due to lack of
proper guidance, sit back and think about it.

The code in that git branch is just a first step and requires a few
tweaks to get the reallocation handled correctly, but if you look at the
above then you might realize that there are two related but largely
independent problems to solve:

  1) What needs to be intercepted and analyzed in the intercept handlers
     of XCR0 and XFD

  2) Handling the reallocation problem

#1 is a KVM problem and #2 is a host FPU problem

As you are a KVM wizard, I let you sort out #1 with the KVM folks and
I'm looking at the #2 part together with Chang and Dave. Why?

  #1 is not my area of expertise, but I surely might have opinions.
  
  #2 is not any different from handling the host side lazy reallocation.

Can you spot the difference between the original approach and the approach
I have taken?

Maybe you understand now why I was explaining over and over that we need
consistent state and asked everyone to look at the AMX host series.

Just for the record. When I looked at that KVM FPU switching exactly two
weeks ago while I was thinking about the right abstraction for AMX, it
was bloody obvious that just reallocating the register state buffer is
wrong. And it was bloody obvious that the user/guest FPU concept of KVM
is nonsense to begin with and going to be in the way of doing a clean
integration.

Why?

Because when you switch buffers, you need to switch state information
which belongs to the buffer, i.e. features, sizes and xfd, as well
because otherwise you create inconsistent state. Sure you can copy tons
of stuff back and forth, but why would you do that if you just can
switch the full state by swapping the pointer to a container which
contains all the information which is needed and makes everything else
(KVM trap bits aside) just work.

So you can rightfully ask why I did not tell that plan right away?

The reason is that I wanted all of you look at the AMX host series and I
desperately hoped that my insisting on state consistency will make at
least one of the involved people come back and say:

  "Thomas, why don't you do the obvious in fpu_swap_kvm_fpu() and switch
   the fpstate pointers? That FPU switching with the three buffers you
   kept around is bloody stupid."

My answer would have been: "Doh, of course, it's obvious. Stupid me."

But that did not happen. Even when I brought up the

    vcpu_create() -> alloc_and_attach()
    vcpu_run() -> swap() -> vmenter_loop() -> swap()
    vcpu_destroy() -> detach_and_free()

proposal nobody told me:

     "Thomas, this can't work because the thread which creates the  vCPU
      is not necessarily the same as the one which runs it."

No, I had to ask the question myself because I had second thoughts when
I was starting to implement that scheme. I had not thought about that
when I wrote it up in mail simply because I'm not a KVM expert. But it
did not matter because the concept stayed the same, just the
implementation details changed:

    vcpu_create() -> alloc()
    vcpu_run() -> attach() -> vmenter_loop() -> detach()
    vcpu_destroy() -> free()

Why? Because everyone was busy trying to cram their hacks into the code
I just changed instead of rethinking the situation.

See?

Jing, as I said before, I'm not blaming you personally. What I blame is
the general approach to add new features to the kernel:

    Hack it into the existing mess until it works by some definition
    of works.

That simply cannot go anywhere because it makes the code slow and
unmaintainable in the long run.

If a new feature does not fit nicely into the existing code, then the
only viable approach is to sit back, look at the requirements of the new
feature and come up with proper abstractions and a plan how to refactor
the code so that the feature falls into place at the very end and does
not create mess and overhead all over the place.

If you look at the three series I posted, then you see not a single bit
which does not make sense on it's own, except for the last series which
adds the fpu config data structure with the pairs of default_* and
max_*.

Even the fpstate pointer makes sense on it's own because the resulting
cleanup of the KVM FPU switch code is already worthwhile even w/o AMX
and XFD in terms of memory consumption, performance and robustness.

See?

The real AMX stuff which still needs to be posted is just building upon
this refactoring. It adds the necessary infrastructure for AMX, which is
all slow path code.

In the hotpath it adds only the XFD update at exactly 4 places where
state is saved or restored. IOW, all hotpath operations are exactly the
same. If XFD is not available on a CPU then the overhead of the XFD
update code is a few extra NOPs due to the patched out static branch.
If enabled then yes, it has an extra conditional and when the XFD value
really changes then a wrmsrl, but that's inevitable.

See?

Now if you sit back and look at the KVM concepts I explained above then
you surely can see that the overhead for the KVM case is going to
exactly a few extra NOPs in the hotpath when XFD is not available.

When XFD is enabled then yes, it needs the extra setup for XFD, but the
common case in the vmenter_loop() will have only a minimalistic overhead
if at all. The common case in fpu_swap_kvm_fpstate() will only grow a
single conditional in the hotpath:

       if (unlikely(guest_fpstate->need_realloc)) {

       }

but that's not even measurable.

See?

Thanks,

        Thomas
