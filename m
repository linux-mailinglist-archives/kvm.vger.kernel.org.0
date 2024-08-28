Return-Path: <kvm+bounces-25282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4DDF962E5B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EA62283C93
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE451A4F28;
	Wed, 28 Aug 2024 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qhreb6us"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A4116087B
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724865644; cv=none; b=Zzmyoe2zyGZisvt9j060w3AK45JgLZGqvDxdiDCqgDNy2UlohtubgcFLvx680WSyHSPcDYRNrbiMhpTlQwN9YwAsYj7WkU4zJRZIA50ioHRJDdPBdsYSfIZvUy86FPiw1Hxai8qe3eMnwA505Hp6nng1ciE4n2mjLmUbJY4LB0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724865644; c=relaxed/simple;
	bh=h9R6S9+O5A/XQiahn9D7RyjUvwdMhNrGmZExdzAtjAk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t6nGzBr1ySPd6+ifgb5kMmI5UQ40ksfeIp463L87fj4EsBKMXTRbQpcRb66uvQ84S4zxwPcekHwRa+g3OJzMQkHPqfcTXuPtv2J65d9RHJrKqBM5EtzfYWbh44l7f6pv8VjIEcKkrfZuQZ6YmAX63o6mE2WmmRMHUVTb7ufheSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qhreb6us; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1653c8a32eso12565666276.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 10:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724865641; x=1725470441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ud9z72caXm+f390HH1IGgLuO5urSY20tGnmPiQesyJU=;
        b=Qhreb6usZSSVF1h9CNz0pw4eig5J87CjOVCmcmuqRwhyyDYkVVA0ajEHN27pvHf/2A
         lKMNZveGSLUyKfvab/jfeMXEQncsS452c30dmt8vv8R6A+tn4nKk08jiT43rT+yXDUO9
         zeJNHlsWJxqR4PVqE+/rgvFsxsgFJSwBngxvkpMPVYywd7muKyrDAcDHRzn+HVW2gLtg
         ASdieg8NCUMs9FA6/JrFa24IorcnbK0FQRXSJvSOeHwhUvPXGGNXNIQNNAGCuny+Fj2C
         OZJso5ucCiATywJwhCsD/OB6jfAELJSndnC11m9PNYSGQXCR+IrE1yQejc5cClmG0c/7
         W4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724865641; x=1725470441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ud9z72caXm+f390HH1IGgLuO5urSY20tGnmPiQesyJU=;
        b=itXz7uDph4d1R4OBCwZ9lfwvGUdHE3U3aWMw3N5o+NKu8Td1Bv6yAJZDQVgQ00eA+b
         qWJFxhrsqbqnRUEDHEjT6GkdChHqifH5CE3/5ZEY/Pk6iam8tPZEuMPrxH6TWot6te9Q
         +Bs85h+vkL+0nwuHqhiu2tM06x0inODWsfwDzas2JnYZnJlPK4M8/0+TNGddOhXY01++
         9AXIbAaSfVfYDaKcovX4zDaGCFtqIqxDLrK5vjXJ3fI7ZRKZGN7bPJhUhD4nU9anewPS
         4TI1SFWzPyBsW58bf2nh2fjYcCYmeieKbOudM9pqgyeku0hTEKpEp1ucsftSwnUOHhK0
         eqBA==
X-Gm-Message-State: AOJu0YzLhTcPBP5V4KN9KYGCMKrwMOsee3fEt77falsXDDcqLD3BmdJJ
	sOxB/QXej6q3HG7XgRwraNM2AmDHwH9rg4tA38kGSY1d88u7KVbiW2gr/98n6Cs+yc3C5ppCIzs
	4Ug==
X-Google-Smtp-Source: AGHT+IHXBkiwOUXWnIFxo0l/v5ta+6hUYZXNaG8HnYMG0qCsvf7DSfMyig0B7iNSNA9l4P9h7kCUoJMFENQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bfc9:0:b0:e16:67ca:e24f with SMTP id
 3f1490d57ef6-e1a5ae0f741mr48276.10.1724865641464; Wed, 28 Aug 2024 10:20:41
 -0700 (PDT)
Date: Wed, 28 Aug 2024 10:20:39 -0700
In-Reply-To: <20240820133333.1724191-7-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820133333.1724191-1-ilstam@amazon.com> <20240820133333.1724191-7-ilstam@amazon.com>
Message-ID: <Zs9cZ1ome6AjJ5nc@google.com>
Subject: Re: [PATCH v3 6/6] KVM: selftests: Add coalesced_mmio_test
From: Sean Christopherson <seanjc@google.com>
To: Ilias Stamatis <ilstam@amazon.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk, nh-open-source@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, Ilias Stamatis wrote:
> Test the KVM_CREATE_COALESCED_MMIO_BUFFER, KVM_REGISTER_COALESCED_MMIO2
> and KVM_UNREGISTER_COALESCED_MMIO2 ioctls.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
> +	/*
> +	 * Test that allocating an fd and memory mapping it works
> +	 */
> +	ring_fd = __vm_ioctl(vm, KVM_CREATE_COALESCED_MMIO_BUFFER, NULL);
> +	TEST_ASSERT(ring_fd != -1, "Failed KVM_CREATE_COALESCED_MMIO_BUFFER");
> +
> +	ring = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
> +		    ring_fd, 0);
> +	TEST_ASSERT(ring != MAP_FAILED, "Failed to allocate ring buffer");

If we end up with KVM providing the buffer, there needs to be negative tests to
do weird things with the mapping.

> +	/*
> +	 * Test that the first and last ring indices are zero
> +	 */
> +	TEST_ASSERT_EQ(READ_ONCE(ring->first), 0);
> +	TEST_ASSERT_EQ(READ_ONCE(ring->last), 0);
> +
> +	/*
> +	 * Run the vCPU and make sure the first MMIO write results in a
> +	 * userspace exit since we have not setup MMIO coalescing yet.
> +	 */
> +	vcpu_run(vcpu);
> +	assert_mmio_write(vcpu, MEM_REGION_GPA, MMIO_WRITE_DATA);
> +
> +	/*
> +	 * Let's actually setup MMIO coalescing now...
> +	 */
> +	zone.addr = COALESCING_ZONE1_GPA;
> +	zone.size = COALESCING_ZONE1_SIZE;
> +	zone.buffer_fd = ring_fd;
> +	r = __vm_ioctl(vm, KVM_REGISTER_COALESCED_MMIO2, &zone);
> +	TEST_ASSERT(r != -1, "Failed KVM_REGISTER_COALESCED_MMIO2");
> +
> +	/*
> +	 * The guest will start doing MMIO writes in the coalesced regions but
> +	 * will also do a ucall when the buffer is half full. The first
> +	 * userspace exit should be due to the ucall and not an MMIO exit.
> +	 */
> +	vcpu_run(vcpu);
> +	assert_ucall_exit(vcpu, UCALL_SYNC);
> +	TEST_ASSERT_EQ(READ_ONCE(ring->first), 0);
> +	TEST_ASSERT_EQ(READ_ONCE(ring->last), KVM_COALESCED_MMIO_MAX / 2 + 1);

For testing the content, I generally prefer my version of the test as it has
fewer magic values.  To prep for this likely/potential future, I'll post a v2
that wraps the ring+mmio+pio information into a structure that can be passed
around, e.g. to guest_code() and the runner+verifier.  And I'll also tweak it
to include the GPA/PORT in the value written, e.g. so that the test will detect
if streams get crossed and a write goes to the wrong buffer.

struct kvm_coalesced_io {
	struct kvm_coalesced_mmio_ring *ring;
	uint32_t ring_size;
	uint64_t mmio_gpa;
	uint64_t *mmio;
#ifdef __x86_64__
	uint8_t pio_port;
#endif
};


That way, the basic test for multiple buffers can simply spin up two vCPUs and
run them concurrently with different MMIO+PIO regions and thus different buffers.

If we want a test case that interleaves MMIO+PIO across multiple buffers on a
single vCPU, it shouldn't be too hard to massage things to work with two buffers,
but honestly I don't see that as being super interesting.

What would be more interesting, and probably should be added, is two vCPUs
accessing the same region concurrently, e.g. to verify the locking.  The test
wouldn't be able to verify the order, i.e. the data can't be checked without some
form of ordering in the guest code, but it'd be a good fuzzer to make sure KVM
doesn't explode.

