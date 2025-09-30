Return-Path: <kvm+bounces-59099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A965BABE97
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4B53BFB27
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274862D3A96;
	Tue, 30 Sep 2025 07:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RFX3zRmt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3D22C0286
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 07:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759218822; cv=none; b=KkugWI5dnEZlMmRchQLyCq0LOWwneVDOG79buBqjGKEdp3S4mr/0L+7YpRD01048W35kqC8a7nY4dT0/S19bmBzKV2lffwQOelLRgQAMzGryeH+g5hpmqW7Z8Z6kVI5Vzkq+C3G0KUOYCm15GqpDwhu+hOTOnXo5dntzToEXuZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759218822; c=relaxed/simple;
	bh=PRLFLpJagjo4igMVRiaCV24ienbgLYFYkfF39ql7Tn8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CPmvjxAsMWkYEweotCpczk6hzr94xt+HwME3kfxU7RqmTlrNC/dqStYRQWquVo4Qjtk6+1w7aoKV91u3N/h0STnPrPUEHooUCCYloyTfZsaXWkXRfXlbtkVKI0OFDggotVoVazEDx7i86Mv2c0L6MXx3MgegRGB7Us3z7vDAnvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RFX3zRmt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28bd8b3fa67so18045155ad.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759218819; x=1759823619; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ARPuefy6xt1h44Lmz1DwT7zsJ1Q7j9YMD1jtO1M5gDo=;
        b=RFX3zRmttA0POqm9iR4QkzPWvinfFxl0H2P71VzVcJbWdcvlXxzSNEqPjZsBvYKbqA
         X5ufYs3FOUCyQoONSw5oQ0pOg5cSdQO9WdxE4XosVFmzfRXQXDA6mFrCIpkpykogXold
         jS4JAN1DwIx98ErRsHVe5P8Vz/bZi22dpIkBquqwrR24fMubQwB9Yg6xdWlzKpX/qWYG
         mttnfwsXGnhUqw9ApDA7YcdSjz4XeWB2D0pSYIwkfGQKHM1C0gEh5IMuWC1+UK9Kro1O
         4gLsy9O/VK3qcv3n6e1+Eulmi93cg+PsDiTQo2CSTys5Wm8tHf9886yw31of0px8yCT6
         KPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759218819; x=1759823619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ARPuefy6xt1h44Lmz1DwT7zsJ1Q7j9YMD1jtO1M5gDo=;
        b=mQxk8W69Oip96JV2LfI3aWJxldnFBKynpguu+eOcXWVINNFWDbW0fT3cIBlhW6VRgw
         Hib5NBl12q07P4lN6A80PJuNe/yKnTtHKmTuwIjcDH/nZSwS3c2NQ2wuomXbNECbF12s
         otVlburpV/XdQj9kmCwQm/yweKY728jNippsC4P/1qUcj/iHz3CLrxR5znfHFhXpxj2U
         6PjJeeMh8V6twHVu+dNBTTObGXeO62mTfUDY9OyowWu/pfh/aF5IR2jH1HKoy0Fcu1GP
         DCHQvf+Oo1RRXZ5WUIFzrj73hCY4/yEN2bnxsH86RLSHwlLdxVUL9rixQUlM/4rSRhic
         r48g==
X-Forwarded-Encrypted: i=1; AJvYcCUHmViO2ckd1x6KlGuYgfhMqE2oUqg4daW4kKHgIO+azx22xjV1evdnftdM+zcJajDcUqs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3sF/sLmSCjYpOWYwodSsMSm1phGoDpdwuVshHXzNJsQWYbLTQ
	vGoLA37FqYZMzGl4PQ1qgVbV+UAOjFrhXy8btCvukpFUma/ga59Ta6CPGNC+kyr01R+auVhXiSd
	Z8gqVsShCFWooVD6nWqZ5atVtvg==
X-Google-Smtp-Source: AGHT+IE2XuxOoKILu6nm+YtUWuNO19SuAk0lsfc/w/jR3J5fI+6uoNjtUKbQuml7WPGigdITGlQVSKwsO+4FE5j3dQ==
X-Received: from pgvm13.prod.google.com ([2002:a65:62cd:0:b0:b55:1852:3ef3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:db0e:b0:27d:6995:9911 with SMTP id d9443c01a7336-27ed4a7728amr219570925ad.28.1759218818749;
 Tue, 30 Sep 2025 00:53:38 -0700 (PDT)
Date: Tue, 30 Sep 2025 07:53:37 +0000
In-Reply-To: <aNrLpkrbnwVSaQGX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-7-seanjc@google.com>
 <diqzldlx1fyk.fsf@google.com> <aNrLpkrbnwVSaQGX@google.com>
Message-ID: <diqza52c1im6.fsf@google.com>
Subject: Re: [PATCH 6/6] KVM: selftests: Verify that faulting in private
 guest_memfd memory fails
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
>> 
>> [...snip...]
>> 
>> > -static void test_fault_overflow(int fd, size_t total_size)
>> > +static void *test_fault_sigbus(int fd, size_t size)
>> >  {
>> >  	struct sigaction sa_old, sa_new = {
>> >  		.sa_handler = fault_sigbus_handler,
>> >  	};
>> > -	size_t map_size = total_size * 4;
>> > -	const char val = 0xaa;
>> > -	char *mem;
>> > -	size_t i;
>> > +	void *mem;
>> >  
>> > -	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
>> > +	mem = test_mmap_common(fd, size);
>> >  
>> >  	sigaction(SIGBUS, &sa_new, &sa_old);
>> >  	if (sigsetjmp(jmpbuf, 1) == 0) {
>> > -		memset(mem, 0xaa, map_size);
>> > +		memset(mem, 0xaa, size);
>> >  		TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
>> >  	}
>> >  	sigaction(SIGBUS, &sa_old, NULL);
>> >  
>> > +	return mem;
>> 
>> I think returning the userspace address from a test is a little hard to
>> follow. This one feels even more unexpected because a valid address is
>> being returned (and used) from a test that has sigbus in its name.
>
> Yeah, and it's fugly all around.  If we pass in the "accessible" size, then we
> can reduce the amount of copy+paste, eliminate the weird return and split mmap()
> versus munmap(), and get bonus coverage that reads SIGBUS as well.
>
> How's this look?
>
> static void test_fault_sigbus(int fd, size_t accessible_size, size_t mmap_size)
> {
> 	struct sigaction sa_old, sa_new = {
> 		.sa_handler = fault_sigbus_handler,
> 	};
> 	const uint8_t val = 0xaa;
> 	uint8_t *mem;
> 	size_t i;
>
> 	mem = kvm_mmap(mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
>
> 	sigaction(SIGBUS, &sa_new, &sa_old);
> 	if (sigsetjmp(jmpbuf, 1) == 0) {
> 		memset(mem, val, mmap_size);
> 		TEST_FAIL("memset() should have triggered SIGBUS");
> 	}
> 	if (sigsetjmp(jmpbuf, 1) == 0) {
> 		(void)READ_ONCE(mem[accessible_size]);
> 		TEST_FAIL("load at first unaccessible byte should have triggered SIGBUS");
> 	}
> 	sigaction(SIGBUS, &sa_old, NULL);
>
> 	for (i = 0; i < accessible_size; i++)
> 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
>
> 	kvm_munmap(mem, mmap_size);
> }
>
> static void test_fault_overflow(int fd, size_t total_size)
> {
> 	test_fault_sigbus(fd, total_size, total_size * 4);
> }
>

Is it intentional that the same SIGBUS on offset mem + total_size is
triggered twice? The memset would have worked fine until offset mem +
total_size, which is the same SIGBUS case as mem[accessible_size]. Or
was it meant to test that both read and write trigger SIGBUS?

> static void test_fault_private(int fd, size_t total_size)
> {
> 	test_fault_sigbus(fd, 0, total_size);
> }
>

I would prefer more unrolling to avoid mental hoops within test code,
perhaps like (not compile tested):

static void assert_host_fault_sigbus(uint8_t *mem) 
{
 	struct sigaction sa_old, sa_new = {
 		.sa_handler = fault_sigbus_handler,
 	};

 	sigaction(SIGBUS, &sa_new, &sa_old);
 	if (sigsetjmp(jmpbuf, 1) == 0) {
 		(void)READ_ONCE(*mem);
 		TEST_FAIL("Reading %p should have triggered SIGBUS", mem);
 	}
        sigaction(SIGBUS, &sa_old, NULL);
}

static void test_fault_overflow(int fd, size_t total_size)
{
	uint8_t *mem = kvm_mmap(total_size * 2, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
        int i;

 	for (i = 0; i < total_size; i++)
 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);

        assert_host_fault_sigbus(mem + total_size);

        kvm_munmap(mem, mmap_size);
}

static void test_fault_private(int fd, size_t total_size)
{
	uint8_t *mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
        int i;

        assert_host_fault_sigbus(mem);

        kvm_munmap(mem, mmap_size);
}

assert_host_fault_sigbus() can then be flexibly reused for conversion
tests (coming up) at various offsets from the mmap()-ed addresses.

At some point, sigaction, sigsetjmp, etc could perhaps even be further
wrapped. For testing memory_failure() for guest_memfd we will want to
check for SIGBUS on memory failure injection instead of on host fault.

Would be nice if it looked like this (maybe not in this patch series):

+ TEST_ASSERT_WILL_SIGBUS(READ_ONCE(mem[i]))
+ TEST_ASSERT_WILL_SIGBUS(WRITE_ONCE(mem[i]))
+ TEST_ASSERT_WILL_SIGBUS(madvise(MADV_HWPOISON))

>> > +static void test_fault_private(int fd, size_t total_size)
>> > +{
>> > +	void *mem = test_fault_sigbus(fd, total_size);
>> > +
>> > +	kvm_munmap(mem, total_size);
>> > +}
>> > +
>> 
>> Testing that faults fail when GUEST_MEMFD_FLAG_DEFAULT_SHARED is not set
>> is a good idea. Perhaps it could be even clearer if further split up:
>> 
>> + test_mmap_supported()
>>     + kvm_mmap()
>>     + kvm_munmap()
>> + test_mmap_supported_fault_supported()
>>     + kvm_mmap()
>>     + successful accesses to offsets within the size of the fd
>>     + kvm_munmap()
>> + test_mmap_supported_fault_sigbus()
>>     + kvm_mmap()
>>     + expect SIGBUS from accesses to offsets within the size of the fd
>>     + kvm_munmap()
>> 
>> >  static void test_mmap_not_supported(int fd, size_t total_size)
>> >  {
>> >  	char *mem;
>> > @@ -274,9 +299,12 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>> >  
>> >  	gmem_test(file_read_write, vm, flags);
>> >  
>> > -	if (flags & GUEST_MEMFD_FLAG_MMAP) {
>> > +	if (flags & GUEST_MEMFD_FLAG_MMAP &&
>> > +	    flags & GUEST_MEMFD_FLAG_DEFAULT_SHARED) {
>> >  		gmem_test(mmap_supported, vm, flags);
>> >  		gmem_test(fault_overflow, vm, flags);
>> > +	} else if (flags & GUEST_MEMFD_FLAG_MMAP) {
>> > +		gmem_test(fault_private, vm, flags);
>> 
>> test_fault_private() makes me think the test is testing for private
>> faults, but there's nothing private about this fault,
>
> It's a user fault on private memory, not sure how else to describe that :-)
> The CoCo shared vs. private and MAP_{SHARED,PRIVATE} collision is unfortunate,
> but I think we should prioritize standardizing on CoCo shared vs. private since
> that is what KVM will care about 99.9% of the time, i.e. in literally everything
> except kvm_gmem_mmap().
>
>> and the fault doesn't even come from the guest.
>
> Sure, but I don't see what that has to do with anything, e.g. fault_overflow()
> isn't a fault from the guest either.
>

Maybe it's the frame of mind I'm working in (conversions), where all
private faults must be from the guest or from KVM. Feel free to ignore this.

>> >  	} else {
>> >  		gmem_test(mmap_not_supported, vm, flags);
>> >  	}
>> 
>> If split up as described above, this could be
>> 
>> 	if (flags & GUEST_MEMFD_FLAG_MMAP &&
>> 	    flags & GUEST_MEMFD_FLAG_DEFAULT_SHARED) {
>> 		gmem_test(mmap_supported_fault_supported, vm, flags);
>> 		gmem_test(fault_overflow, vm, flags);
>> 	} else if (flags & GUEST_MEMFD_FLAG_MMAP) {
>> 		gmem_test(mmap_supported_fault_sigbus, vm, flags);
>
> I find these unintuitive, e.g. is this one "mmap() supported, test fault sigbus",
> or is it "mmap(), test supported fault sigbus".  I also don't like that some of
> the test names describe the _result_ (SIBGUS), where as others describe _what_
> is being tested.
>

I think of the result (SIGBUS) as part of what's being tested. So
test_supported_fault_sigbus() is testing that mmap is supported, and
faulting will result in a SIGBUS.

> In general, I don't like test names that describe the result, because IMO what
> is being tested is far more interesting.  E.g. from a test coverage persective,
> I don't care if attempting to fault in (CoCO) private memory gets SIGBUS versus
> SIGSEGV, but I most definitely care that we have test coverage for the "what".
>

The SIGBUS is part of the contract with userspace and that's also part
of what's being tested IMO.

That said, I agree we don't need sigbus in the name, I guess I just
meant that there are a few layers to test here and I couldn't find a
better name:

1. mmap() succeeds to start with
2. mmap() succeeds, and faulting also succeeds
    + mmap() works, and faulting does not succeed because memory is not
      intended to be accessible to the host
3. mmap() succeed, and faulting also succeeds, but only within the size of
   guest_memfd

> Looking at everything, I think the only that doesn't fit well is the CoW
> scenario.  What if we extract that to its own helper?  That would eliminate the
> ugly test_mmap_common(), 
>

Extracting the CoW scenario is good, thanks!

> So my vote would be to keep things largely the same:
>
> 	if (flags & GUEST_MEMFD_FLAG_MMAP &&
> 	    flags & GUEST_MEMFD_FLAG_DEFAULT_SHARED) {
> 		gmem_test(mmap_supported, vm, flags);
> 		gmem_test(mmap_cow, vm, flags);
> 		gmem_test(fault_overflow, vm, flags);
> 		gmem_test(mbind, vm, flags);
> 		gmem_test(numa_allocation, vm, flags);
> 	} else if (flags & GUEST_MEMFD_FLAG_MMAP) {
> 		gmem_test(fault_private, vm, flags);
> 	} else {
> 		gmem_test(mmap_not_supported, vm, flags);
> 	}

