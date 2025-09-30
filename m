Return-Path: <kvm+bounces-59163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1CE2BAD2A8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:24:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6B534A24EE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 14:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611822FC881;
	Tue, 30 Sep 2025 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2ZuA/d9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95A120B7E1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759242251; cv=none; b=ogQKp3evMZoHrbQiv1jfmX+PmlusGKMzFz5gwdEGZGgzRexlf2Km2YTCPUZ+TwY4G9/QJYMusrhRnQUYF02NQ35PIZPXFOF7atjTz+6T0IsfVY3zr+jjhR+Ln6PMIPky7ps+yDkGwWc308C4mxq8e9tDzERND3/2Ab50DlBS6sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759242251; c=relaxed/simple;
	bh=QX4I/lCarlYgvfsjBbMkBMBMASp/lik6TTXQ2+1tQ5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ELQK2U6zjauwxD1puARMqccuusjw9/HiAZLyDiJbJYyOw1na9CLrz7djV6X8X1EpLuIEI9+TAL5eP4cSRmzkZVH6ry2L+pdvIhSFUsbQqU7K9iK+BX4Xk3YlCKIX3JC9Bqxjm4Bo2myLloyeA/vlsiJDD7aoAQA0DegMxfkZrdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2ZuA/d9x; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3306543e5abso6781866a91.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 07:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759242249; x=1759847049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oQlJNmaSy7Vsey9bZkxA7JGXtQsD4l92RLpVpPchWDw=;
        b=2ZuA/d9x4STm9M28mbYFfxncb31DO8LaUjtbpc8kFduhRUUhKMuoPgHzhkIc18RvMo
         3tu2gJE+VPHxbBH5mK6CIECGIpAVw0gtx/VAX8wtt/oe3qUH8OoOXpQL1PZnQU65XWxp
         9q2xkAWZMlUxbVXfo10rcPP/WcOfnuQ3RJxFMT/O8zwZQoCjIcboG4cB3JT2pVTAL6KC
         aCGt/3jflz4vAxsfl0igIcT+NJ0Msvjc1YVkgplV7ZG/yw+GJsJxEfQD1w6/A9BeVwYj
         8YOBp8mXrn0cg9Dq+e1KKl6FmYR9BD1GQqODdApBozmg9gA6gPgGTPDdKfl1n7Llf4yY
         wgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759242249; x=1759847049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oQlJNmaSy7Vsey9bZkxA7JGXtQsD4l92RLpVpPchWDw=;
        b=FTInfPiw7nqtl9hRod1n2ijSM3jaA6tuOr0cmleq/A+RwQZEqM7K9/FhwRMpIJ2Mq/
         V2OcFDPp8YoPDDQzd0lAqpLvk4LxL6ED1xCZ7qvUHvslbIKzW16LHo2ozWs+R67m2e7Z
         IeARzmS9Xkko9z0P3y8QOkKkuBZ4qddzTCyAJoPYJgYbjkh6GOwb3hExfuxCSMwSlzhq
         lQIj4KpHayxitDyzBUe6+rFNCwpI/xoMyVwU/KlsAa26FtYqtcha/O1J+tp/kJxLhnif
         eaqkm/G1IR+QNKf8R+pCI9YuFP8yb1QNIGJVqGvJ+zMP8EaYNvfqIMxDytvaQg2jNERB
         iuJA==
X-Forwarded-Encrypted: i=1; AJvYcCVK598lbKt5aghSAiAsAdjFuaiBRtFzJQ2iL1492xwPNUkiPFvnobHs0/+HeHkdBegylVE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXsTyU9ZheqKzM1GgyTrO3xSlMAeY1f9x3aNXErXnvgfPMrnwM
	NUAKKceltBG6k+kC9y/X2o7mOAHKt2B5TG5C8wUR7NbGw6eicf8mncgOMMOVLU3WVU7WimaohrB
	559Nniw==
X-Google-Smtp-Source: AGHT+IFz/mOSeweoDFQEe1prKxm0oY3++suIaj9pQRWJfRm1ouaf2TCChsh41iBwxlNuzYnHzPTecD9i+ec=
X-Received: from pjbbk12.prod.google.com ([2002:a17:90b:80c:b0:32d:7097:81f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ac4:b0:32e:8c6d:5928
 with SMTP id 98e67ed59e1d1-3383abde248mr5248895a91.13.1759242249096; Tue, 30
 Sep 2025 07:24:09 -0700 (PDT)
Date: Tue, 30 Sep 2025 07:24:07 -0700
In-Reply-To: <diqzfrc41kns.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-6-seanjc@google.com>
 <diqztt0l1pol.fsf@google.com> <aNrCqhA_hhUjflPA@google.com> <diqzfrc41kns.fsf@google.com>
Message-ID: <aNvoB6DWSbda2lXQ@google.com>
Subject: Re: [PATCH 5/6] KVM: selftests: Add wrappers for mmap() and munmap()
 to assert success
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 30, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > To be perfectly honest, I forgot test_util.h existed :-)
> 
> Merging/dropping one of kvm_util.h vs test_util.h is a good idea. The
> distinction is not clear and it's already kind of messy between the two.

That's a topic for another day.

> It's a common pattern in KVM selftests to have a syscall/ioctl wrapper
> foo() that asserts defaults and a __foo() that doesn't assert anything
> and allows tests to assert something else, but I have a contrary
> opinion.
> 
> I think it's better that tests be explicit about what they're testing
> for, so perhaps it's better to use macros like TEST_ASSERT_EQ() to
> explicitly call a function and check the results.

No, foo() and __foo() is a well-established pattern in the kernel, and in KVM
selftests it is a very well-established pattern for syscalls and ioctls.  And
I feel very, very strong about handling errors in the core infrastructure.

Relying on developers to remember to add an assert is 100% guaranteed to result
in missed asserts.  That makes everyone's life painful, because inevitably an
ioctl will fail on someone else's system, and then they're stuck debugging a
super random failure with no insight into what the developer _meant_ to do.

And requiring developers to write (i.e. copy+paste) boring, uninteresting code
to handle failures adds a lot of friction to development, is a terrible use of
developers' time, and results in _awful_ error messages.  Bad or missing error
messages in tests have easily wasted tens of hours of just _my_ time; I suspect
the total cost throughout the KVM community can be measured in tens of days.
 
E.g. pop quiz, what state did I clobber that generated this error message with
a TEST_ASSERT_EQ(ret, 0)?  Answer at the bottom.

  ==== Test Assertion Failure ====
  lib/x86/processor.c:1128: ret == 0
  pid=2456 tid=2456 errno=22 - Invalid argument
     1	0x0000000000415465: vcpu_load_state at processor.c:1128
     2	0x0000000000402805: save_restore_vm at hyperv_evmcs.c:221
     3	0x000000000040204d: main at hyperv_evmcs.c:286
     4	0x000000000041df43: __libc_start_call_main at libc-start.o:?
     5	0x00000000004200ec: __libc_start_main_impl at ??:?
     6	0x0000000000402220: _start at ??:?
  0xffffffffffffffff != 0 (ret != 0)

You might say "oh, I can go look at the source".  But what if you don't have the
source because you got a test failure from CI?  Or because the assert came from
a bug report due to a failure in someone else's CI pipeline?

That is not a contrived example.  Before the ioctl assertion framework was added,
KVM selftests was littered with such garbage.  Note, I'm not blaming developers
in any way.  After having to add tens of asserts on KVM ioctls just to write a
simple test, it's entirely natural to become fatigued and start throwing in
TEST_ASSERT_EQ(ret, 0) or TEST_ASSERT(!ret, "ioctl failed").

There's also the mechanics of requiring the caller to assert.  KVM ioctls that
return a single value, e.g. register accessors, then need to use an out-param to
communicate the value or error code, e.g. this

	val = vcpu_get_reg(vcpu, reg_id);
	TEST_ASSERT_EQ(val, 0);

would become this:

	ret = vcpu_get_reg(vcpu, reg_id, &val);
	TEST_ASSERT_EQ(ret, 0);
	TEST_ASSERT_EQ(val, 0);

But of course, the developer would bundle that into:

	TEST_ASSERT(!ret && !val, "get_reg failed");

And then the user is really sad when the "!val" condition fails, because they
can't even tell.  Again, this't a contrived example, it literally happend to me
when dealing with the guest_memfd NUMA testcase, and was what prompted me to
write this syscall framework.  This also shows the typical error message that a
developer will write. 

This TEST_ASSERT() failed on me due to a misguided cleanup I made:

	ret = syscall(__NR_get_mempolicy, &get_policy, &get_nodemask,
		      maxnode, mem, MPOL_F_ADDR);
	TEST_ASSERT(!ret && get_policy == MPOL_DEFAULT && get_nodemask == 0,
		"Policy should be MPOL_DEFAULT and nodes zero");

generating this error message:

  ==== Test Assertion Failure ====
  guest_memfd_test.c:120: !ret && get_policy == MPOL_DEFAULT && get_nodemask == 0
  pid=52062 tid=52062 errno=22 - Invalid argument
     1	0x0000000000404113: test_mbind at guest_memfd_test.c:120 (discriminator 6)
     2	 (inlined by) __test_guest_memfd at guest_memfd_test.c:409 (discriminator 6)
     3	0x0000000000402320: test_guest_memfd at guest_memfd_test.c:432
     4	 (inlined by) main at guest_memfd_test.c:529
     5	0x000000000041eda3: __libc_start_call_main at libc-start.o:?
     6	0x0000000000420f4c: __libc_start_main_impl at ??:?
     7	0x00000000004025c0: _start at ??:?
  Policy should be MPOL_DEFAULT and nodes zero

At first glance, it would appear that get_mempolicy() failed with -EINVAL.  Nope.
ret==0, but errno was left set from an earlier syscall.  It took me a few minutes
of digging and a run with strace to figure out that get_mempolicy() succeeded.

Constrast that with:

        kvm_get_mempolicy(&policy, &nodemask, maxnode, mem, MPOL_F_ADDR);
        TEST_ASSERT(policy == MPOL_DEFAULT && !nodemask,
                    "Wanted MPOL_DEFAULT (%u) and nodemask 0x0, got %u and 0x%lx",
                    MPOL_DEFAULT, policy, nodemask);

  ==== Test Assertion Failure ====
  guest_memfd_test.c:120: policy == MPOL_DEFAULT && !nodemask
  pid=52700 tid=52700 errno=22 - Invalid argument
     1	0x0000000000404915: test_mbind at guest_memfd_test.c:120 (discriminator 6)
     2	 (inlined by) __test_guest_memfd at guest_memfd_test.c:407 (discriminator 6)
     3	0x0000000000402320: test_guest_memfd at guest_memfd_test.c:430
     4	 (inlined by) main at guest_memfd_test.c:527
     5	0x000000000041eda3: __libc_start_call_main at libc-start.o:?
     6	0x0000000000420f4c: __libc_start_main_impl at ??:?
     7	0x00000000004025c0: _start at ??:?
  Wanted MPOL_DEFAULT (0) and nodemask 0x0, got 1 and 0x1

Yeah, there's still some noise with errno=22, but it's fairly clear that the
returned values mismatches, and super obvious that the syscall succeeded when
looking at the code.  This is not a cherry-picked example.  There are hundreds,
if not thousands, of such asserts in KVM selftests and KVM-Unit-Tests in
particular.  And that's when developers _aren't_ forced to manually add boilerplate
asserts in ioctls succeeding.

For people that are completely new to KVM selftests, I can appreciate that it
might take a while to acclimate to the foo() and __foo() pattern, but I have a
hard time believing that it adds significant cognitive load after you've spent
a decent amount of time in KVM selftests.  And I 100% want to cater to the people
that are dealing with KVM selftests day in, day out.

> Or perhaps it should be more explicit, like in the name, that an
> assertion is made within this function?

No, that's entirely inflexible, will lead to confusion, and adds a copious amount
of noise.  E.g. this

	/* emulate hypervisor clearing CR4.OSXSAVE */
	vcpu_sregs_get(vcpu, &sregs);
	sregs.cr4 &= ~X86_CR4_OSXSAVE;
	vcpu_sregs_set(vcpu, &sregs);

versus

	/* emulate hypervisor clearing CR4.OSXSAVE */
	vcpu_sregs_get_assert(vcpu, &sregs);
	sregs.cr4 &= ~X86_CR4_OSXSAVE;
	vcpu_sregs_set_assert(vcpu, &sregs);

The "assert" is pure noise and makes it harder to see the "get" versus "set".

If we instead annotate the the "no_assert" case, then we'll end up with ambigous
cases where a developer won't be able to determine if an unannotated API asserts
or not, and conflict cases where a "no_assert" API _does_ assert, just not on the
primary ioctl it's invoking.

IMO, foo() and __foo() is quite explicit once you become accustomed to the
environment.

> In many cases a foo() exists without the corresponding __foo(), which
> seems to be discouraging testing for error cases.

That's almost always because no one has needed __foo().

> Also, I guess especially for vcpu_run(), tests would like to loop/take
> different actions based on different errnos and then it gets a bit
> unwieldy to have to avoid functions that have assertions within them.

vcpu_run() is a special case.  KVM_RUN is so much more than a normal ioctl, and
so having vcpu_run() follow the "standard" pattern isn't entirely feasible.

Speaking of vcpu_run(), and directly related to idea of having developers manually
do TEST_ASSERT_EQ(), one of the top items on my selftests todo list is to have
vcpu_run() handle GUEST_ASSERT and GUEST_PRINTF whenever possible.  Having to add
UCALL_PRINTF handling just to get a debug message out of a test's guest code is
beyond frustrating.  Ditto for the 60+ tests that had to manually add UCALL_ABORT
handling, which leads to tests having code like this, which then gets copy+pasted
all over the place and becomes a nightmare to maintain.

static void __vcpu_run_expect(struct kvm_vcpu *vcpu, unsigned int cmd)
{
	struct ucall uc;

	vcpu_run(vcpu);
	switch (get_ucall(vcpu, &uc)) {
	case UCALL_ABORT:
		REPORT_GUEST_ASSERT(uc);
		break;
	default:
		if (uc.cmd == cmd)
			return;

		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
	}
}

> I can see people forgetting to add TEST_ASSERT_EQ()s to check results of
> setup/teardown functions but I think those errors would surface some
> other way anyway.

Heh, I don't mean to be condescending, but I highly doubt you'll have this
opinion after you've had to debug a completely unfamiliar test that's failing
in weird ways, for the tenth time.

> Not a strongly-held opinion,

As you may have noticed, I have extremely strong opinions in this area :-)

> and no major concerns on the naming either. It's a selftest after all and
> IIUC we're okay to have selftest interfaces change anyway?

Yes, changes are fine.  It's the churn I want to avoid.

Oh, and here's the "answer" to the TEST_ASSERT_EQ() failure:

  ==== Test Assertion Failure ====
  include/kvm_util.h:794: !ret
  pid=43866 tid=43866 errno=22 - Invalid argument
     1	0x0000000000415486: vcpu_sregs_set at kvm_util.h:794 (discriminator 4)
     2	 (inlined by) vcpu_load_state at processor.c:1125 (discriminator 4)
     3	0x0000000000402805: save_restore_vm at hyperv_evmcs.c:221
     4	0x000000000040204d: main at hyperv_evmcs.c:286
     5	0x000000000041dfc3: __libc_start_call_main at libc-start.o:?
     6	0x000000000042016c: __libc_start_main_impl at ??:?
     7	0x0000000000402220: _start at ??:?
  KVM_SET_SREGS failed, rc: -1 errno: 22 (Invalid argument)

