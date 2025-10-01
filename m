Return-Path: <kvm+bounces-59279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56933BAFFFE
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 12:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E601C188DE95
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 10:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1053E2BE05E;
	Wed,  1 Oct 2025 10:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z8JGxV7R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8346238159
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 10:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759314379; cv=none; b=aTv0kXL85nWDFX4p8Zm3S5uzBW8VsXTGJxvCvoX0yRV90yy7NSHlSPS2eOhnw0FfDiKmg0A0vsQFExY6+GfCujjFNsK1ZFRUuGOH2F1jCXrzAh445SDg9cMWwKjTZPFMveCu0cwOOq2+WfxnIUCI+PE+u2NRVp+XO8GACELIcVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759314379; c=relaxed/simple;
	bh=8yD0KyHjri3QH9RK4HyNaJiWhDXUozznQkpMAzjO4ug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p7+EZiVzIOVZe4n9VeqfzHe+bpEwRpveJzqDKn6OiuM6AU1588PNfB0ua8kSm9bJ6gvYu42PHLef5AyarqEfMYfwx4GnDddlMFO5xffcH1zXbhnBepiVRdgjW/hlGieehtho1zLxrseHGTTvdWPsAqa2iZYjihWVinnA/k74E6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z8JGxV7R; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2681623f927so67222095ad.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 03:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759314377; x=1759919177; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RSeamtURp7luZ5+zPShFxKdfm9ffQoU6mLL1dQ5PHbg=;
        b=z8JGxV7ROEj53f+XZfywA/QOxcSWh8pF1moLMI99MnD/BvI3x3oVTZ1UQyGlDqz19L
         uFn7P+5VAjB8A0xe6sX4dRuHyiYFXzQ4GGpq6Nozbren5oxTjS9aDMxfoZbUSMItES4W
         vnJxvgh2IbPJ8QsVrQXona0CJqIumwkx13Xd09mMlEztVDuf+wrO9oL3d+ySvpE2rPmg
         DbGzUBNmsPWF31jCXfrhfbyICou8eF1H0PZC27Mfj82TzVfaUdP7W9SAcWs0p5YWhlrH
         vjQD5CMWtpM+JjGXpAlWI+XApg1QexDeeiEnXW+o0w9bgCYMF3+uYPvgLKiYouHhlTU5
         8mlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759314377; x=1759919177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RSeamtURp7luZ5+zPShFxKdfm9ffQoU6mLL1dQ5PHbg=;
        b=kCvOUHRnzAePQkLIO0Amh0tZnCAPmQ/dPxinjEvVbBIU/w2Qfeq+Cj8QFOeY938jWP
         LEv9e70JrcVjGCeIKHkdU1i2JmP+ri5Bw35DUSvvAl0VU1pf8ou7hS3sKC2v9SmgLfeS
         SgI7DcoTd0cEw+T1Hezm50meVYJP60EYCJNgjpgqY79XZLKTlfL2WE20hNtpJo7BwYas
         h34jXR473S42bZhL4o1YOzKvBlykIMUS5gND9u9vsIi17NXvABL3S58yRLE1qH5hnItx
         W7kO2FHaZIxE8+1QkXBwmKQ69UEPzMEB64sMOjoQHo1isxE/zwwIrAIqA6088tabZyzC
         REug==
X-Forwarded-Encrypted: i=1; AJvYcCWwQe/G//4Jw9O6ZfsWwauNu/XbO/dzQ6zdbTlq8ZdbR5tBVa0lWUFYEJ+xNCW/qu8Qu2U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsUyCbEvVNOoWtrzuKTTpITAWyWlg/QrG4NQjUB6fKJ/OPLPBD
	Y1xwStwp737c2VHpCB4CzONNP+WrrOxdIEUoo/jyuiwWjBdo+I9jUxB7Vyf3cYoZ5FpswzO6hjP
	Ee0uv5P0rjoJAY0eLR0q0E9tAnw==
X-Google-Smtp-Source: AGHT+IE7DzZayHrClR+Aot7d4WgnPUURYPZhOmhZOVrGWNSHGmEgGCqiK4VXVX+wYtoX7OwswOw3ykMm9CqdFzYwnA==
X-Received: from pjzp24.prod.google.com ([2002:a17:90b:118:b0:32e:3830:65f2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:244c:b0:25a:24f2:af00 with SMTP id d9443c01a7336-28e7f276e28mr43250165ad.12.1759314377137;
 Wed, 01 Oct 2025 03:26:17 -0700 (PDT)
Date: Wed, 01 Oct 2025 10:26:16 +0000
In-Reply-To: <aNvwB2fr2p45hhC0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-7-seanjc@google.com>
 <diqzldlx1fyk.fsf@google.com> <aNrLpkrbnwVSaQGX@google.com>
 <diqza52c1im6.fsf@google.com> <aNvwB2fr2p45hhC0@google.com>
Message-ID: <diqz4isiuddj.fsf@google.com>
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

> On Tue, Sep 30, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> [...snip...]
>> 
>> 
>> At some point, sigaction, sigsetjmp, etc could perhaps even be further
>> wrapped. For testing memory_failure() for guest_memfd we will want to
>> check for SIGBUS on memory failure injection instead of on host fault.
>> 
>> Would be nice if it looked like this (maybe not in this patch series):
>> 
>> + TEST_ASSERT_WILL_SIGBUS(READ_ONCE(mem[i]))
>> + TEST_ASSERT_WILL_SIGBUS(WRITE_ONCE(mem[i]))
>> + TEST_ASSERT_WILL_SIGBUS(madvise(MADV_HWPOISON))
>
> Ooh, me likey.  Definitely can do it now.  Using a macro means we can print out
> the actual action that didn't generate a SIGUBS, e.g. hacking the test to read
> byte 0 generates:
>
> 	'(void)READ_ONCE(mem[0])' should have triggered SIGBUS
>
> Hmm, how about TEST_EXPECT_SIGBUS?  TEST_ASSERT_xxx() typically asserts on a
> value, i.e. on the result of a previous action.  And s/WILL/EXPECT to make it
> clear that the action is expected to SIGBUS _now_.
>
> And if we use a descriptive global variable, we can extract the macro to e.g.
> test_util.h or kvm_util.h (not sure we want to do that right away; probably best
> left to the future).
>
> static sigjmp_buf expect_sigbus_jmpbuf;
> void fault_sigbus_handler(int signum)
> {
> 	siglongjmp(expect_sigbus_jmpbuf, 1);
> }
>
> #define TEST_EXPECT_SIGBUS(action)						\
> do {										\
> 	struct sigaction sa_old, sa_new = {					\
> 		.sa_handler = fault_sigbus_handler,				\
> 	};									\
> 										\
> 	sigaction(SIGBUS, &sa_new, &sa_old);					\
> 	if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {				\
> 		action;								\
> 		TEST_FAIL("'%s' should have triggered SIGBUS", #action);	\
> 	}									\
> 	sigaction(SIGBUS, &sa_old, NULL);					\
> } while (0)
>
> static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
> {
> 	const char val = 0xaa;
> 	char *mem;
> 	size_t i;
>
> 	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
>
> 	TEST_EXPECT_SIGBUS(memset(mem, val, map_size));
> 	TEST_EXPECT_SIGBUS((void)READ_ONCE(mem[accessible_size]));
>
> 	for (i = 0; i < accessible_size; i++)
> 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
>
> 	kvm_munmap(mem, map_size);
> }
>

Awesome! Thanks!

And thanks for the explanations on the other suggestions.

>> 
>> [...snip...]
>> 

