Return-Path: <kvm+bounces-59090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE9DBABC1D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8456B7A7FE9
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E812BD5A7;
	Tue, 30 Sep 2025 07:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0lO8Xds8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6A81F462C
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 07:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759216170; cv=none; b=TquJaedb4GVkAzKRynhNxCZ/Ih+RoCdc8XKkk03gZqAFAh3dGp7652ItmRtkiMOPsx9Re7Y7lqk5Z5pxRgOcrUm5/i6WoAIn7BDxenkKjWgroxTfMyz1tsQgYGzs/EAqSq6lFfz7QfwAutqInn+N6TMWY6/lTKMP9O9WsliKYDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759216170; c=relaxed/simple;
	bh=nEib4Ghi85l3FWyJxphX9jSiYJFIQEl6res5LifHFg4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KO/7JSVeCQ4BJdTof8Ko6dP9sPvfFUloxeiTSrE7iJG+AaXDNRwGnusX7cmfTD1+853JZjZje0sCLXkc7P8iZ/rK9wbs15hcWxHknpcORXIfT4TdMgaHTbKvqpeimVW2vr9eJLexrsgFYmpnJ+Z2nV/cRNBMlsbf0rYikHp0thk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0lO8Xds8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-782063922ceso2632937b3a.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759216168; x=1759820968; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UP672iBXqfF/M4eb7b0fPJvD5RDYtZGt7W3+nRDDW7U=;
        b=0lO8Xds8ydbtanpWt92wS2riIySTmNyo5zdDZVcxYVjpQ6dDK29Q762W2rqKxm74sT
         3bbkiJ9iy5hxsUwjw2Ei5MJDo3JYPHhwkE/Qq/87g7hCAHmAOT/QaMDZdrqadObmDxks
         lkuu2x9Z3YuDYPJtDi5sMPdhcm+C6MN1mnrQF/jQ0T1UZjH0t0V+uMLJNq98f11TIDQX
         RSl4QjHXt/KN9XJPjzyx3JYer9UpE026K1i+SWd+uyniVUWDRwW6g2sE3aqN94jkMLOb
         /xI2ZCIIYa8urue2W4iZ4c8ARLognClJ1SQBJRJv4/2W76HeVuulMSjmEZ/DSd/aGsRp
         bzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759216168; x=1759820968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UP672iBXqfF/M4eb7b0fPJvD5RDYtZGt7W3+nRDDW7U=;
        b=qVRTVnaFSCH74gIr6w5TNSkMDOTl5NFxvMzBGl7C+4RXRc5FLcqwIzFo6ujegiiIBk
         zNgSTNTgEnIU27dfmvvZiCktuelCeqqlpufLTNBl6u0Vl1P+51bGgbGn+xRz5OxTKtfT
         J24tMJO5Yt3594raVR0Kdl6DlZlv6yRIp7VhXFG93lJZLQi+S4ifoncTp/1wDmYbQSkt
         TxyN1YOfRjAeACxfjvwmWhPQl1hbFwvQh3MES2KsxU4WFhwNM4wfakA7NOgpcGLXXGsL
         2Aq6FoDj01Ufuu7DAVHIQWI4hxR9C5+SmQogFtgl8mtPm6sDl/zzwMeYAyZEYRQnsTUV
         WoOQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5c2Eshy1BAKNIx92LSJrQlFWfac+KaglPfmfSmI+h3LjFHMmmfe/j+qloQ224HnnvLkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YysPOj9gIo8+PypERz+XYZEzdKKWZVO2P2HazIoAq+Ic7a6gupH
	gchG0kDbsNW+8bgYBWbaTlOWLDB/lUc5x9r23RCdcHSZ/dwE1Ixx69JCtdR35lhyecsX9UXzU0A
	Nv2H5AyCeiIBTBHUJjSHJhvI6NQ==
X-Google-Smtp-Source: AGHT+IGBuYj/q0jGYUG7M3fPbV2JRBsFGwjHP1fPe6GdcNCfcMiclGAvh4hoSmA12qBaQKnFC6Jqg4jVIDpe2cQnaA==
X-Received: from pffj26.prod.google.com ([2002:a62:b61a:0:b0:77f:5d99:87b6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a1d:b0:781:275a:29d9 with SMTP id d2e1a72fcca58-781275a2b55mr13651457b3a.18.1759216168240;
 Tue, 30 Sep 2025 00:09:28 -0700 (PDT)
Date: Tue, 30 Sep 2025 07:09:27 +0000
In-Reply-To: <aNrCqhA_hhUjflPA@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-6-seanjc@google.com>
 <diqztt0l1pol.fsf@google.com> <aNrCqhA_hhUjflPA@google.com>
Message-ID: <diqzfrc41kns.fsf@google.com>
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

> On Mon, Sep 29, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > Add and use wrappers for mmap() and munmap() that assert success to reduce
>> > a significant amount of boilerplate code, to ensure all tests assert on
>> > failure, and to provide consistent error messages on failure.
>> >
>> > No functional change intended.
>> >
>> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>> > ---
>> >  .../testing/selftests/kvm/guest_memfd_test.c  | 21 +++------
>> >  .../testing/selftests/kvm/include/kvm_util.h  | 25 +++++++++++
>> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 44 +++++++------------
>> >  tools/testing/selftests/kvm/mmu_stress_test.c |  5 +--
>> >  .../selftests/kvm/s390/ucontrol_test.c        | 16 +++----
>> >  .../selftests/kvm/set_memory_region_test.c    | 17 ++++---
>> >  6 files changed, 64 insertions(+), 64 deletions(-)
>> >
>> > 
>> > [...snip...]
>> > 
>> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
>> > index 23a506d7eca3..1c68ff0fb3fb 100644
>> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
>> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
>> > @@ -278,6 +278,31 @@ static inline bool kvm_has_cap(long cap)
>> >  #define __KVM_SYSCALL_ERROR(_name, _ret) \
>> >  	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
>> >  
>> > +static inline void *__kvm_mmap(size_t size, int prot, int flags, int fd,
>> > +			       off_t offset)
>> 
>> Do you have a policy/rationale for putting this in kvm_util.h as opposed
>> to test_util.h? I like the idea of this wrapper but I thought this is
>> less of a kvm thing and more of a test utility, and hence it belongs in
>> test_util.c and test_util.h.
>
> To be perfectly honest, I forgot test_util.h existed :-)
>

Merging/dropping one of kvm_util.h vs test_util.h is a good idea. The
distinction is not clear and it's already kind of messy between the two.

>> Also, the name kind of associates mmap with KVM too closely IMO, but
>> test_mmap() is not a great name either.
>
> Which file will hopefully be irrevelant, because ideally it'll be temporary (see
> below). But if someone has a strong opinion and/or better idea on the name prefix,
> I definitely want to settle on a name for syscall wrappers, because I want to go
> much further than just adding an mmap() wrapper.  I chose kvm_ because there's
> basically zero chance that will ever conflict with generic selftests functionality,
> and the wrappers utilize TEST_ASSERT(), which are unique to KVM selftests.
>
> As for why the current location will hopefully be temporary, and why I want to
> settle on a name, I have patches to add several more wrappers, along with
> infrastructure to make it super easy to add new wrappers.  When trying to sort
> out the libnuma stuff for Shivank's series[*], I discovered that KVM selftests
> already has a (very partial, very crappy) libnuma equivalent in
> tools/testing/selftests/kvm/include/numaif.h.
>
> Adding wrappers for NUMA syscalls became an exercise in frustration (so much
> uninteresting boilerplate, and I kept making silly mistakes), and so that combined
> with the desire for mmap() and munmap() wrappers motivated me to add a macro
> framework similar to the kernel's DEFINE_SYSCALL magic.
>
> So, I've got patches (that I'll post with the next version of the gmem NUMA
> series) that add tools/testing/selftests/kvm/include/kvm_syscalls.h, and
> __kvm_mmap() will be moved there (ideally it wouldn't move, but I want to land
> this small series in 6.18, and so wanted to keep the changes for 6.18 small-ish).
>
> For lack of a better namespace, and because we already have __KVM_SYSCALL_ERROR(),
> I picked KVM_SYSCALL_DEFINE() for the "standard" builder, e.g. libnuma equivalents,
> and then __KVM_SYSCALL_DEFINE() for a KVM selftests specific version to handle
> asserting success.
>

It's a common pattern in KVM selftests to have a syscall/ioctl wrapper
foo() that asserts defaults and a __foo() that doesn't assert anything
and allows tests to assert something else, but I have a contrary
opinion.

I think it's better that tests be explicit about what they're testing
for, so perhaps it's better to use macros like TEST_ASSERT_EQ() to
explicitly call a function and check the results.

Or perhaps it should be more explicit, like in the name, that an
assertion is made within this function?

In many cases a foo() exists without the corresponding __foo(), which
seems to be discouraging testing for error cases.

Also, I guess especially for vcpu_run(), tests would like to loop/take
different actions based on different errnos and then it gets a bit
unwieldy to have to avoid functions that have assertions within them.

I can see people forgetting to add TEST_ASSERT_EQ()s to check results of
setup/teardown functions but I think those errors would surface some
other way anyway.

Not a strongly-held opinion, and no major concerns on the naming
either. It's a selftest after all and IIUC we're okay to have selftest
interfaces change anyway?

> /* Define a kvm_<syscall>() API to assert success. */
> #define __KVM_SYSCALL_DEFINE(name, nr_args, args...)			\
> static inline void kvm_##name(DECLARE_ARGS(nr_args, args))		\
> {									\
> 	int r;								\
> 									\
> 	r = name(UNPACK_ARGS(nr_args, args));				\
> 	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR(#name, r));			\
> }
>
> /*
>  * Macro to define syscall APIs, either because KVM selftests doesn't link to
>  * the standard library, e.g. libnuma, or because there is no library that yet
>  * provides the syscall.  These
>  */
> #define KVM_SYSCALL_DEFINE(name, nr_args, args...)			\
> static inline long name(DECLARE_ARGS(nr_args, args))			\
> {									\
> 	return syscall(__NR_##name, UNPACK_ARGS(nr_args, args));	\
> }									\
> __KVM_SYSCALL_DEFINE(name, nr_args, args)
>
>
> The usage looks like this (which is odd at first glance, but makes it trivially
> easy to copy+paste from the kernel SYSCALL_DEFINE invocations:
>
> KVM_SYSCALL_DEFINE(get_mempolicy, 5, int *, policy, const unsigned long *, nmask,
> 		   unsigned long, maxnode, void *, addr, int, flags);
>
> KVM_SYSCALL_DEFINE(set_mempolicy, 3, int, mode, const unsigned long *, nmask,
> 		   unsigned long, maxnode);
>
> KVM_SYSCALL_DEFINE(set_mempolicy_home_node, 4, unsigned long, start,
> 		   unsigned long, len, unsigned long, home_node,
> 		   unsigned long, flags);
>
> KVM_SYSCALL_DEFINE(migrate_pages, 4, int, pid, unsigned long, maxnode,
> 		   const unsigned long *, frommask, const unsigned long *, tomask);
>
> KVM_SYSCALL_DEFINE(move_pages, 6, int, pid, unsigned long, count, void *, pages,
> 		   const int *, nodes, int *, status, int, flags);
>
> KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
> 		   const unsigned long *, nodemask, unsigned long, maxnode,
> 		   unsigned int, flags);
>
> __KVM_SYSCALL_DEFINE(munmap, 2, void *, mem, size_t, size);
> __KVM_SYSCALL_DEFINE(close, 1, int, fd);
> __KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, len);
> __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
>
> [*] https://lore.kernel.org/all/0e986bdb-7d1b-4c14-932e-771a87532947@amd.com

