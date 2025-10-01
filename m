Return-Path: <kvm+bounces-59278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61365BAFF9B
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 12:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 151723AF962
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 10:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556E72BDC17;
	Wed,  1 Oct 2025 10:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ja95ato+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38421E8331
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 10:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313895; cv=none; b=j6ODo8p9W7h2koOrVjo4ldlc2/BWkzIVWgxLC94YCHl7jUJ37wKrCqgz2VBv5bQCb8li1cjcSOuKt3p+houULuHDZobvpGgGfcin0v4VyeQlTjQ568LVeUDd3OdlzyQrzyXnnlCRm3MSk1YVfMn8wriux+gHVqySqIRrXH4/UFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313895; c=relaxed/simple;
	bh=5odNuqzjnRPKzNOPYsgV9ApoKyRj6fT7pI7CUBknz2k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WmQcmEe6C1mGVNfAAsje8fA0I78oEAyOphbUuGM5qldmgFdw8CkZtcsOCyv+UOQhIHkFzIZ+PGPtcXzDPh5VpnXdb6mqDJ85+8B2s0zaglKLFzW7IhW6xho/4PUD/xmElCJuT0/tCAHOG0b5Zkr14x+aY19fidAnmPJrbNs2Dhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ja95ato+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28e538b5f23so24173445ad.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 03:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759313892; x=1759918692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVjzhac2/7CNw9Es+ykENwtYeWjltG28Fn53f4nEIe0=;
        b=Ja95ato+LNFdtVgIc8X2V6fXLs5c45cGFYlCD7fTr+2Dme0dQdfDNRWxysii7lXLzN
         ASlETsd8S3CQ2r06T1CklxF2ixugqN83OpFEWFlLaL+Na7u+jR4QypzJwbsnLTXhIZ6I
         IwDJGC4lULstkS6475ztm8lr2+LHDhY5wGw1MUhXlUZo2IWoYHEJFH5AYCah9MpinXut
         F/CXZ/EoOV1OSSvNho/3FC8DSndzybIvt9hItqVlwWIVGvcc7OkIJNqPk23Wq4L+8sQD
         QDrCZoR+vmFhRIvTU0c7br2lI4ujgaS1W1EX808XwXFAM/LXoqFgd/wwn6S36JbxSttr
         BcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759313892; x=1759918692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wVjzhac2/7CNw9Es+ykENwtYeWjltG28Fn53f4nEIe0=;
        b=XrF3Hp1RS7G9vhSJjkVqnCUzCkIFYnFmIUZ8+IOoU32rnixSifiKZmDZEfGM/SMi3D
         Ks/eiHVNz76YRTyplWau9oofAQ2BXXzlrqPUh69nShvEJXGT4FLsG585EsknY1Sm5vrk
         ENo2l0n6cbSijsnmKt8fwTWdAd7Yq7+yRqV3WgmVaF2pSQ0eP5Lr+ZO9Ko6Kr32fmKaP
         qB20lKJIw4pUr6hdBMIOoZti9P1RbKJBncJYHo/gDBEfVcYR+slSJ1RjhK9mgkVOx2EI
         EuaW5KOC6gpWqy5sXKcgsM8ych7UTMGy7IF/ObNUDU1TcU2ooBoFn3IALA0D7r6Wwbeb
         kPEA==
X-Forwarded-Encrypted: i=1; AJvYcCUV52mTmoAa+43Dtw8vrtF1uwxKxRfZb/eOuaOGEXrR6o2kUAdKfDzmMrSxu+ixPZYKzVg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIH64CiurTKnV1IxXlu618TWjDRV4q4ZoaKOAYqGlWyQWK25O8
	2TSPZ9vHDSI5awT23FCfN2d/KlDTXI+G8wsAmf6nWMdZ4gDcZ+8f9ANmFsehndKES5EuE1QVyqO
	4yj0WFi74N7M4MSFSOxSkkgq7FA==
X-Google-Smtp-Source: AGHT+IH3/UwZotGsVgSZHuoT5n5Xo4BXNmDVYcUbgIEep1ky9MnljUnSllPi+qyg6Yd8nz6gX6uPHjFaQ4H70gXl1Q==
X-Received: from plbiy5.prod.google.com ([2002:a17:903:1305:b0:267:b6b7:9ac3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:19e6:b0:24a:a6c8:d6c4 with SMTP id d9443c01a7336-28e7f2dcc13mr36461995ad.26.1759313891933;
 Wed, 01 Oct 2025 03:18:11 -0700 (PDT)
Date: Wed, 01 Oct 2025 10:18:10 +0000
In-Reply-To: <aNvoB6DWSbda2lXQ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-6-seanjc@google.com>
 <diqztt0l1pol.fsf@google.com> <aNrCqhA_hhUjflPA@google.com>
 <diqzfrc41kns.fsf@google.com> <aNvoB6DWSbda2lXQ@google.com>
Message-ID: <diqz7bxfsz6l.fsf@google.com>
Subject: Re: [PATCH 5/6] KVM: selftests: Add wrappers for mmap() and munmap()
 to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Sep 30, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > To be perfectly honest, I forgot test_util.h existed :-)
>>
>> Merging/dropping one of kvm_util.h vs test_util.h is a good idea. The
>> distinction is not clear and it's already kind of messy between the two.
>
> That's a topic for another day.
>
>> It's a common pattern in KVM selftests to have a syscall/ioctl wrapper
>> foo() that asserts defaults and a __foo() that doesn't assert anything
>> and allows tests to assert something else, but I have a contrary
>> opinion.
>>
>> I think it's better that tests be explicit about what they're testing
>> for, so perhaps it's better to use macros like TEST_ASSERT_EQ() to
>> explicitly call a function and check the results.
>
> No, foo() and __foo() is a well-established pattern in the kernel, and in KVM
> selftests it is a very well-established pattern for syscalls and ioctls.  And
> I feel very, very strong about handling errors in the core infrastructure.
>
> Relying on developers to remember to add an assert is 100% guaranteed to result
> in missed asserts.  That makes everyone's life painful, because inevitably an
> ioctl will fail on someone else's system, and then they're stuck debugging a
> super random failure with no insight into what the developer _meant_ to do.
>
> And requiring developers to write (i.e. copy+paste) boring, uninteresting code
> to handle failures adds a lot of friction to development, is a terrible use of
> developers' time, and results in _awful_ error messages.  Bad or missing error
> messages in tests have easily wasted tens of hours of just _my_ time; I suspect
> the total cost throughout the KVM community can be measured in tens of days.
>
> E.g. pop quiz, what state did I clobber that generated this error message with
> a TEST_ASSERT_EQ(ret, 0)?  Answer at the bottom.
>
>   ==== Test Assertion Failure ====
>   lib/x86/processor.c:1128: ret == 0
>   pid=2456 tid=2456 errno=22 - Invalid argument
>      1	0x0000000000415465: vcpu_load_state at processor.c:1128
>      2	0x0000000000402805: save_restore_vm at hyperv_evmcs.c:221
>      3	0x000000000040204d: main at hyperv_evmcs.c:286
>      4	0x000000000041df43: __libc_start_call_main at libc-start.o:?
>      5	0x00000000004200ec: __libc_start_main_impl at ??:?
>      6	0x0000000000402220: _start at ??:?
>   0xffffffffffffffff != 0 (ret != 0)
>
> You might say "oh, I can go look at the source".  But what if you don't have the
> source because you got a test failure from CI?  Or because the assert came from
> a bug report due to a failure in someone else's CI pipeline?
>
> That is not a contrived example.  Before the ioctl assertion framework was added,
> KVM selftests was littered with such garbage.  Note, I'm not blaming developers
> in any way.  After having to add tens of asserts on KVM ioctls just to write a
> simple test, it's entirely natural to become fatigued and start throwing in
> TEST_ASSERT_EQ(ret, 0) or TEST_ASSERT(!ret, "ioctl failed").
>
> There's also the mechanics of requiring the caller to assert.  KVM ioctls that
> return a single value, e.g. register accessors, then need to use an out-param to
> communicate the value or error code, e.g. this
>
> 	val = vcpu_get_reg(vcpu, reg_id);
> 	TEST_ASSERT_EQ(val, 0);
>
> would become this:
>
> 	ret = vcpu_get_reg(vcpu, reg_id, &val);
> 	TEST_ASSERT_EQ(ret, 0);
> 	TEST_ASSERT_EQ(val, 0);
>
> But of course, the developer would bundle that into:
>
> 	TEST_ASSERT(!ret && !val, "get_reg failed");
>
> And then the user is really sad when the "!val" condition fails, because they
> can't even tell.  Again, this't a contrived example, it literally happend to me
> when dealing with the guest_memfd NUMA testcase, and was what prompted me to
> write this syscall framework.  This also shows the typical error message that a
> developer will write.
>
> This TEST_ASSERT() failed on me due to a misguided cleanup I made:
>
> 	ret = syscall(__NR_get_mempolicy, &get_policy, &get_nodemask,
> 		      maxnode, mem, MPOL_F_ADDR);
> 	TEST_ASSERT(!ret && get_policy == MPOL_DEFAULT && get_nodemask == 0,
> 		"Policy should be MPOL_DEFAULT and nodes zero");
>
> generating this error message:
>
>   ==== Test Assertion Failure ====
>   guest_memfd_test.c:120: !ret && get_policy == MPOL_DEFAULT && get_nodemask == 0
>   pid=52062 tid=52062 errno=22 - Invalid argument
>      1	0x0000000000404113: test_mbind at guest_memfd_test.c:120 (discriminator 6)
>      2	 (inlined by) __test_guest_memfd at guest_memfd_test.c:409 (discriminator 6)
>      3	0x0000000000402320: test_guest_memfd at guest_memfd_test.c:432
>      4	 (inlined by) main at guest_memfd_test.c:529
>      5	0x000000000041eda3: __libc_start_call_main at libc-start.o:?
>      6	0x0000000000420f4c: __libc_start_main_impl at ??:?
>      7	0x00000000004025c0: _start at ??:?
>   Policy should be MPOL_DEFAULT and nodes zero
>
> At first glance, it would appear that get_mempolicy() failed with -EINVAL.  Nope.
> ret==0, but errno was left set from an earlier syscall.  It took me a few minutes
> of digging and a run with strace to figure out that get_mempolicy() succeeded.
>
> Constrast that with:
>
>         kvm_get_mempolicy(&policy, &nodemask, maxnode, mem, MPOL_F_ADDR);
>         TEST_ASSERT(policy == MPOL_DEFAULT && !nodemask,
>                     "Wanted MPOL_DEFAULT (%u) and nodemask 0x0, got %u and 0x%lx",
>                     MPOL_DEFAULT, policy, nodemask);
>
>   ==== Test Assertion Failure ====
>   guest_memfd_test.c:120: policy == MPOL_DEFAULT && !nodemask
>   pid=52700 tid=52700 errno=22 - Invalid argument
>      1	0x0000000000404915: test_mbind at guest_memfd_test.c:120 (discriminator 6)
>      2	 (inlined by) __test_guest_memfd at guest_memfd_test.c:407 (discriminator 6)
>      3	0x0000000000402320: test_guest_memfd at guest_memfd_test.c:430
>      4	 (inlined by) main at guest_memfd_test.c:527
>      5	0x000000000041eda3: __libc_start_call_main at libc-start.o:?
>      6	0x0000000000420f4c: __libc_start_main_impl at ??:?
>      7	0x00000000004025c0: _start at ??:?
>   Wanted MPOL_DEFAULT (0) and nodemask 0x0, got 1 and 0x1
>
> Yeah, there's still some noise with errno=22, but it's fairly clear that the
> returned values mismatches, and super obvious that the syscall succeeded when
> looking at the code.  This is not a cherry-picked example.  There are hundreds,
> if not thousands, of such asserts in KVM selftests and KVM-Unit-Tests in
> particular.  And that's when developers _aren't_ forced to manually add boilerplate
> asserts in ioctls succeeding.
>
> For people that are completely new to KVM selftests, I can appreciate that it
> might take a while to acclimate to the foo() and __foo() pattern, but I have a
> hard time believing that it adds significant cognitive load after you've spent
> a decent amount of time in KVM selftests.  And I 100% want to cater to the people
> that are dealing with KVM selftests day in, day out.
>

Thanks for taking the time to write this up. I'm going to start a list
of "most useful explanations" and this will go on that list.

>> Or perhaps it should be more explicit, like in the name, that an
>> assertion is made within this function?
>
> No, that's entirely inflexible, will lead to confusion, and adds a copious amount
> of noise.  E.g. this
>
> 	/* emulate hypervisor clearing CR4.OSXSAVE */
> 	vcpu_sregs_get(vcpu, &sregs);
> 	sregs.cr4 &= ~X86_CR4_OSXSAVE;
> 	vcpu_sregs_set(vcpu, &sregs);
>
> versus
>
> 	/* emulate hypervisor clearing CR4.OSXSAVE */
> 	vcpu_sregs_get_assert(vcpu, &sregs);
> 	sregs.cr4 &= ~X86_CR4_OSXSAVE;
> 	vcpu_sregs_set_assert(vcpu, &sregs);
>
> The "assert" is pure noise and makes it harder to see the "get" versus "set".
>
> If we instead annotate the the "no_assert" case, then we'll end up with ambigous
> cases where a developer won't be able to determine if an unannotated API asserts
> or not, and conflict cases where a "no_assert" API _does_ assert, just not on the
> primary ioctl it's invoking.
>
> IMO, foo() and __foo() is quite explicit once you become accustomed to the
> environment.
>
>> In many cases a foo() exists without the corresponding __foo(), which
>> seems to be discouraging testing for error cases.
>
> That's almost always because no one has needed __foo().
>
>> Also, I guess especially for vcpu_run(), tests would like to loop/take
>> different actions based on different errnos and then it gets a bit
>> unwieldy to have to avoid functions that have assertions within them.
>
> vcpu_run() is a special case.  KVM_RUN is so much more than a normal ioctl, and
> so having vcpu_run() follow the "standard" pattern isn't entirely feasible.
>
> Speaking of vcpu_run(), and directly related to idea of having developers manually
> do TEST_ASSERT_EQ(), one of the top items on my selftests todo list is to have
> vcpu_run() handle GUEST_ASSERT and GUEST_PRINTF whenever possible.  Having to add
> UCALL_PRINTF handling just to get a debug message out of a test's guest code is
> beyond frustrating.  Ditto for the 60+ tests that had to manually add UCALL_ABORT
> handling, which leads to tests having code like this, which then gets copy+pasted
> all over the place and becomes a nightmare to maintain.

+1000 this is exactly where I had to avoid assertions!

>
> static void __vcpu_run_expect(struct kvm_vcpu *vcpu, unsigned int cmd)
> {
> 	struct ucall uc;
>
> 	vcpu_run(vcpu);
> 	switch (get_ucall(vcpu, &uc)) {
> 	case UCALL_ABORT:
> 		REPORT_GUEST_ASSERT(uc);
> 		break;
> 	default:
> 		if (uc.cmd == cmd)
> 			return;
>
> 		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> 	}
> }
>
>> I can see people forgetting to add TEST_ASSERT_EQ()s to check results of
>> setup/teardown functions but I think those errors would surface some
>> other way anyway.
>
> Heh, I don't mean to be condescending, but I highly doubt you'll have this
> opinion after you've had to debug a completely unfamiliar test that's failing
> in weird ways, for the tenth time.
>
>> Not a strongly-held opinion,
>
> As you may have noticed, I have extremely strong opinions in this area :-)
>
>> and no major concerns on the naming either. It's a selftest after all and
>> IIUC we're okay to have selftest interfaces change anyway?
>
> Yes, changes are fine.  It's the churn I want to avoid.
>
> Oh, and here's the "answer" to the TEST_ASSERT_EQ() failure:
>
>   ==== Test Assertion Failure ====
>   include/kvm_util.h:794: !ret
>   pid=43866 tid=43866 errno=22 - Invalid argument
>      1	0x0000000000415486: vcpu_sregs_set at kvm_util.h:794 (discriminator 4)
>      2	 (inlined by) vcpu_load_state at processor.c:1125 (discriminator 4)
>      3	0x0000000000402805: save_restore_vm at hyperv_evmcs.c:221
>      4	0x000000000040204d: main at hyperv_evmcs.c:286
>      5	0x000000000041dfc3: __libc_start_call_main at libc-start.o:?
>      6	0x000000000042016c: __libc_start_main_impl at ??:?
>      7	0x0000000000402220: _start at ??:?
>   KVM_SET_SREGS failed, rc: -1 errno: 22 (Invalid argument)

