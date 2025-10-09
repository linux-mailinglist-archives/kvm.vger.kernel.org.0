Return-Path: <kvm+bounces-59744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6803CBCB2BB
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D75EA4E65E1
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 23:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF3428726F;
	Thu,  9 Oct 2025 23:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u1LrsfmA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2B3155C88
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 23:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760051328; cv=none; b=uxolrDZphi99N8lC5a4O+T1AMz5C35w9L/qa0dUezSm2/MdDM2RRv61yJOKYJteMd+55MuPLob9s9/PwQ4awm8B/NJd55g4YzCpMbu3omGYk0EAeOfirMFaxUlBY0m9Qrps9nsA+0++aCvwtriZpdYPH5UR/Rgam6kxavdNHLac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760051328; c=relaxed/simple;
	bh=mO3BfBl7Y/2I52TbjPHtPsUEdKOX2+l8+hnFuUeuyKo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GnbBzDXSYlw0KTjjgiYpIh1MFelKZA33byiZh5kpNBQu+arDYM8BFqq8hL6efox6fQbYM8XFMmxQTuUqwQR2rc96M/bM+aocTqh5NrcMHys0/DymOWA7XB7i8LauVDQRboYFJ6jw+glNWV2ZQ0hPdmmTOuOXVQC03ZbqyypasSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u1LrsfmA; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5a013bc46dso2340300a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 16:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760051326; x=1760656126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDpIaffmoR6Qy88AeMwNPxO5iOtC8dDi++B0iTvo01A=;
        b=u1LrsfmA3WrZtKf5hktbo5bfAjsWJWtD2zwrucbY+opy798sJyLX0i8LHuWmhQNcsG
         ytI2MS0Q6+9x/btCzlaYdDTNxnjKOp4Uz0eywr8T5RBwryyjAfjWTnwrpQY141FEEtgc
         Rlji/CClZrjvB96qrFqjDKApp8YDDpge4JxeY401x+ci1yRlHMsMx+RAKRhM8fxFHbJS
         kyAORDGwsaBbhOwESzlfDD+c+o545SiltxCGBpAL/2KBGY4gmz5FuAFDE5PQ70Zfa0n0
         1eMX6fcWWim3YlZHpyXDHEzEf1JB+8lmMQ3eYYdCl31I4BHNGwAoZQSFqVuX4iPcS9ya
         LvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760051326; x=1760656126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDpIaffmoR6Qy88AeMwNPxO5iOtC8dDi++B0iTvo01A=;
        b=SyUtm9QRr6rPuEZfQkkFCNrcTUd+JEM1jOPEIwpWQVEh4a8L+PvcQ3c+VoI347rgnr
         YGgrnWqe0TNju12OrHcvdH0J/QzGueGS5jSaO2y9avzodu6UIo4ja0iUwSg/+Q0J/4GF
         KiBDyMrx8iAfLYkm+z8VeKYfzuMljcLXIazMMQ+cyt/0Abhdzm4eIC31JisPGlfzB70Z
         XCD4xlXfPT/TMb2EnaB2FJyKLLC6kbAF7h3+SCiViBTyf6KlDfanXeCL3Hum4DvWkTZe
         2BTru9dX28BONz7Dzwngt6W9gTZJMGTghrK1kx0b8+piJ6T39oP5Ke+attFo2AW7PP57
         ChYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtc1dLbv4aNrC8KbMZEgrYp66KgQSfUuYgT2oQSXdpvPOHhSSDaT2y23+WIPvoresUtWk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe8I/f9L/HDccDfSJ1lf2UCriAySjFkd0lzACWktIlO2rAWOe5
	vGp4xwTcgQva1vU5yN5xPQCWZ9tW41qFzxS1h60Hs9yiash3YXpV7UQBeQsCLAn+PtKHs/1kcvc
	OQnteYp5F8AF7EoKBA4XR7fMOoA==
X-Google-Smtp-Source: AGHT+IEKbmOpgQyGpF8iZG/gJeSzfxpKObXTtqbwqaHzaJgPnDoFIt/+KkqyzPgCgGNzWKTNkqyAjVnIwO8aJ2WY7Q==
X-Received: from pjca12.prod.google.com ([2002:a17:90b:5b8c:b0:32b:35fb:187f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d8b:b0:329:e703:d00b with SMTP id 98e67ed59e1d1-33b51386449mr12422922a91.19.1760051326203;
 Thu, 09 Oct 2025 16:08:46 -0700 (PDT)
Date: Thu, 09 Oct 2025 16:08:44 -0700
In-Reply-To: <20251007221420.344669-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-12-seanjc@google.com>
Message-ID: <diqzcy6vhdvn.fsf@google.com>
Subject: Re: [PATCH v12 11/12] KVM: selftests: Add guest_memfd tests for mmap
 and NUMA policy support
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> From: Shivank Garg <shivankg@amd.com>
>
> Add tests for NUMA memory policy binding and NUMA aware allocation in
> guest_memfd. This extends the existing selftests by adding proper
> validation for:
>   - KVM GMEM set_policy and get_policy() vm_ops functionality using
>     mbind() and get_mempolicy()
>   - NUMA policy application before and after memory allocation
>
> Run the NUMA mbind() test with and without INIT_SHARED, as KVM should allow
> doing mbind(), madvise(), etc. on guest-private memory, e.g. so that
> userspace can set NUMA policy for CoCo VMs.
>
> Run the NUMA allocation test only for INIT_SHARED, i.e. if the host can't
> fault-in memory (via direct access, madvise(), etc.) as move_pages()
> returns -ENOENT if the page hasn't been faulted in (walks the host page
> tables to find the associated folio)
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> [sean: don't skip entire test when running on non-NUMA system, test mbind()
>        with private memory, provide more info in assert messages]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 98 +++++++++++++++++++
>  1 file changed, 98 insertions(+)
>
> 
> [...snip...]
> 
> +static void test_numa_allocation(int fd, size_t total_size)
> +{
> +	unsigned long node0_mask = 1;  /* Node 0 */
> +	unsigned long node1_mask = 2;  /* Node 1 */
> +	unsigned long maxnode = 8;
> +	void *pages[4];
> +	int status[4];
> +	char *mem;
> +	int i;
> +
> +	if (!is_multi_numa_node_system())
> +		return;
> +
> +	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +
> +	for (i = 0; i < 4; i++)
> +		pages[i] = (char *)mem + page_size * i;
> +
> +	/* Set NUMA policy after allocation */
> +	memset(mem, 0xaa, page_size);
> +	kvm_mbind(pages[0], page_size, MPOL_BIND, &node0_mask, maxnode, 0);
> +	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, page_size);
> +
> +	/* Set NUMA policy before allocation */
> +	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
> +	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
> +	memset(mem, 0xaa, total_size);
> +
> +	/* Validate if pages are allocated on specified NUMA nodes */
> +	kvm_move_pages(0, 4, pages, NULL, status, 0);
> +	TEST_ASSERT(status[0] == 1, "Expected page 0 on node 1, got it on node %d", status[0]);
> +	TEST_ASSERT(status[1] == 1, "Expected page 1 on node 1, got it on node %d", status[1]);
> +	TEST_ASSERT(status[2] == 0, "Expected page 2 on node 0, got it on node %d", status[2]);
> +	TEST_ASSERT(status[3] == 0, "Expected page 3 on node 0, got it on node %d", status[3]);
> +
> +	/* Punch hole for all pages */
> +	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
> +
> +	/* Change NUMA policy nodes and reallocate */
> +	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
> +	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
> +	memset(mem, 0xaa, total_size);
> +
> +	kvm_move_pages(0, 4, pages, NULL, status, 0);
> +	TEST_ASSERT(status[0] == 0, "Expected page 0 on node 0, got it on node %d", status[0]);
> +	TEST_ASSERT(status[1] == 0, "Expected page 1 on node 0, got it on node %d", status[1]);
> +	TEST_ASSERT(status[2] == 1, "Expected page 2 on node 1, got it on node %d", status[2]);
> +	TEST_ASSERT(status[3] == 1, "Expected page 3 on node 1, got it on node %d", status[3]);
> +

Related to my comment on patch 5: might a test for guest_memfd with
regard to the memory spread page cache feature provided by the cpuset
subsystem be missing?

Perhaps we need tests for

1. Test that the allocation matches current's mempolicy, with no
   mempolicy defined for specific indices.
2. Test that during allocation, current's mempolicy can be overridden with
   a mempolicy defined for specific indices.
3. Test that during allocation, current's mempolicy and the effect of
   cpuset config can be overridden with a mempolicy defined for specific
   indices.
4. Test that during allocation, without defining a mempolicy for given
   index, current's mempolicy is overridden by the effect of cpuset
   config

I believe test 4, before patch 5, will show that guest_memfd respects
cpuset config, but after patch 5, will show that guest_memfd no longer
allows cpuset config to override current's mempolicy.

> +	kvm_munmap(mem, total_size);
> +}
> +
>  static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
>  {
>  	const char val = 0xaa;
> @@ -273,11 +369,13 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>  		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
>  			gmem_test(mmap_supported, vm, flags);
>  			gmem_test(fault_overflow, vm, flags);
> +			gmem_test(numa_allocation, vm, flags);
>  		} else {
>  			gmem_test(fault_private, vm, flags);
>  		}
>  
>  		gmem_test(mmap_cow, vm, flags);
> +		gmem_test(mbind, vm, flags);
>  	} else {
>  		gmem_test(mmap_not_supported, vm, flags);
>  	}
> -- 
> 2.51.0.710.ga91ca5db03-goog

