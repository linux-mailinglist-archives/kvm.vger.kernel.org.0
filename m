Return-Path: <kvm+bounces-11336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C777875B20
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 00:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEEBAB21E9A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 23:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23CD13FE31;
	Thu,  7 Mar 2024 23:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QtxsAbla"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C642139856
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 23:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709854055; cv=none; b=fnV+ZQ7IgDXowEwazGYRsBg+oAQgZSL4sdOg1Khcxov1y+jy1miYMhFJ82PaZwNxxksC+cdoCGnOkfjLnGL/zah5in+ailu/4Tem0h0+y57HB6lbcLMQgJRbl3NEdYFnfXDafpNWg1YwxJbZccegJ4BI+G4UcKRaHTdLZr1CJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709854055; c=relaxed/simple;
	bh=UeFX0QZdKqJmdeZmlyeJodORP3Tg5kuVTjxdtBgNJfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7EvM/PlbcR0Fl/ZQOf2BPNMu405H+aFKV6UBUv3gRV4xHmYaDoYsKcA3kebSqr/NJawn8x44lE9jzM3DvI6/vvZqZgeAaNoIrhwloJ0GLb8sEpdbYrqAYlV+5O5hYu6o8nJ0RP4KrhKr9LK5n+bxCsdtlc93naTDxkgsQ+siYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QtxsAbla; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dc139ed11fso18719755ad.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 15:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709854053; x=1710458853; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bYt4Ve1DD/hVybWGoZ7DGugsY7ToXf8+kbu5XK/ag8Q=;
        b=QtxsAblaRKzSzr6Ja2bdWvzx8MSVaBosMh79KISs6fNF8v42qq5HHrLqUWWhXxYwel
         D9mPTutNCIY+2UtT5+uRoZql/8Mb29EfKIjfbyV1FLqdvoYiN0aNu5YZhgczdcAFe3hO
         pSW2v7qqdP4P9rk5hnpm0a/eFXZpRym92f0vyHiohX3K4T+5ZdIartLCNK9fjsfhqpl0
         fznxgamrB0UPS8dFvdc8TwkXyBjmnyUBfauromxArYd9SXHp6jsQoGpRGzNh2FcZLBQd
         nQeXbHIMJP7ne+d9GHi1P0KQDcVNAvWULYm+ouyTleZ2jsXoB8AGPUvpb94CJBifjkMc
         0uMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709854053; x=1710458853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYt4Ve1DD/hVybWGoZ7DGugsY7ToXf8+kbu5XK/ag8Q=;
        b=puFN+LgWdGHmOgJlxfVzkKAVD6f2LwA15Pum95UMXxPF1Z/vVEuMwDG1sRcXSHeOjz
         YHfWYg1fPAj2dIgJMvCg907BanPUiem4Hk4qK6Z+pT/tyXRwURjDQdBBiLY9z3UWegYG
         fj4FE0puEhMjZfX2B529B4Ppyq1LELx+djxfMrr9BuKlH70+UtUhFJSjFmXH/D2JbFcr
         O8i8fV8nIa1QsN71Xgtg7XCDOLagW9MKRXB+NM09n1/Wg1KY/Hp1MjZR3y8+9p0/av8Z
         jhx2xDiwr/2tCe9sQwDolABrHtdfU/Gorme3DPCyayu1rGtM5TH3WP0fC4mIq9leC/Ky
         Rxfg==
X-Forwarded-Encrypted: i=1; AJvYcCVTFd/FbUzaSvaEiN//p7iHMxSml22fKsLak05HPPq3tJ7f9yFQcujGirwY3nARIWBjInE64DsAiljM0fQu4Z8qNT7g
X-Gm-Message-State: AOJu0Yxx9/2Y6R0QzwnZtM9zpTpmdpwnpVSASQ1djJwJEncqQW1Gsall
	3wrW98zRfPZ8tfBTV4WIGDBxXikd+WPBokZ79MAasJBUYBQZLR2lumixOgKKkQ==
X-Google-Smtp-Source: AGHT+IFIvbieMJxT9N1gPqmRYPPtAuosyj41gK4VtoiMgii93lJafkR9hPRFkUj1jmVuJXgM0DYxRw==
X-Received: by 2002:a17:902:ce0f:b0:1dd:4cb:cc57 with SMTP id k15-20020a170902ce0f00b001dd04cbcc57mr5132668plg.0.1709854052807;
        Thu, 07 Mar 2024 15:27:32 -0800 (PST)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id d14-20020a170903230e00b001da15580ca8sm15159294plh.52.2024.03.07.15.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 15:27:32 -0800 (PST)
Date: Thu, 7 Mar 2024 15:27:28 -0800
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>,
	Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on
 x86_64
Message-ID: <ZepNYLTPghJPYCtA@google.com>
References: <20240307194255.1367442-1-dmatlack@google.com>
 <ZepBlYLPSuhISTTc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZepBlYLPSuhISTTc@google.com>

On 2024-03-07 02:37 PM, Sean Christopherson wrote:
> On Thu, Mar 07, 2024, David Matlack wrote:
> > Create memslot 0 at 0x100000000 (4GiB) to avoid it overlapping with
> > KVM's private memslot for the APIC-access page.
> 
> This is going to cause other problems, e.g. from max_guest_memory_test.c
> 
> 	/*
> 	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
> 	 * the guest's code, stack, and page tables.  Because selftests creates
> 	 * an IRQCHIP, a.k.a. a local APIC, KVM creates an internal memslot
> 	 * just below the 4gb boundary.  This test could create memory at
> 	 * 1gb-3gb,but it's simpler to skip straight to 4gb.
> 	 */
> 	const uint64_t start_gpa = SZ_4G;
> 
> Trying to move away from starting at '0' is going to be problematic/annoying,
> e.g. using low memory allows tests to safely assume 4GiB+ is always available.
> And I'd prefer not to make the infrastucture all twisty and weird for all tests
> just because memstress tests want to play with huge amounts of memory.
> 
> Any chance we can solve this by using huge pages in the guest, and adjusting the
> gorilla math in vm_nr_pages_required() accordingly?  There's really no reason to
> use 4KiB pages for a VM with 256GiB of memory.  That'd also be more represantitive
> of real world workloads (at least, I hope real world workloads are using 2MiB or
> 1GiB pages in this case).

There are real world workloads that use TiB of RAM with 4KiB mappings
(looking at you SAP HANA).

What about giving tests an explicit "start" GPA they can use? That would
fix max_guest_memory_test and avoid tests making assumptions about 4GiB
being a magically safe address to use.

e.g. Something like this on top:

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 194963e05341..584ac6fea65c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -101,6 +101,11 @@ struct kvm_vm {
 	unsigned int page_shift;
 	unsigned int pa_bits;
 	unsigned int va_bits;
+	/*
+	 * Tests are able to use the guest physical address space from
+	 * [available_base_gpa, max_gfn << page_shift) for their own purposes.
+	 */
+	vm_paddr_t available_base_gpa;
 	uint64_t max_gfn;
 	struct list_head vcpus;
 	struct userspace_mem_regions regions;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c8d7e66d308d..e74d9efa82c2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -17,6 +17,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <linux/kernel.h>
+#include <linux/sizes.h>
 
 #define KVM_UTIL_MIN_PFN	2
 
@@ -414,6 +415,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	uint64_t nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct userspace_mem_region *slot0;
+	vm_paddr_t ucall_mmio_gpa;
 	struct kvm_vm *vm;
 	int i;
 
@@ -436,7 +438,15 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	 * MMIO region would prevent silently clobbering the MMIO region.
 	 */
 	slot0 = memslot2region(vm, 0);
-	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
+	ucall_mmio_gpa = slot0->region.guest_phys_addr + slot0->region.memory_size;
+	ucall_init(vm, ucall_mmio_gpa);
+
+	/*
+	 * 1GiB is somewhat arbitrary, but is chosen to be large enough to meet
+	 * most tests' alignment requirements/expectations.
+	 */
+	vm->available_base_gpa =
+		SZ_1G * DIV_ROUND_UP(ucall_mmio_gpa + vm->page_size, SZ_1G);
 
 	kvm_arch_vm_post_create(vm);
 
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 6628dc4dda89..f5d77d2a903d 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -156,18 +156,10 @@ static void calc_default_nr_vcpus(void)
 
 int main(int argc, char *argv[])
 {
-	/*
-	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
-	 * the guest's code, stack, and page tables.  Because selftests creates
-	 * an IRQCHIP, a.k.a. a local APIC, KVM creates an internal memslot
-	 * just below the 4gb boundary.  This test could create memory at
-	 * 1gb-3gb,but it's simpler to skip straight to 4gb.
-	 */
-	const uint64_t start_gpa = SZ_4G;
 	const int first_slot = 1;
 
 	struct timespec time_start, time_run1, time_reset, time_run2;
-	uint64_t max_gpa, gpa, slot_size, max_mem, i;
+	uint64_t start_gpa, max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
 	struct kvm_vcpu **vcpus;
@@ -229,6 +221,7 @@ int main(int argc, char *argv[])
 	for (i = 0; i < slot_size; i += vm->page_size)
 		((uint8_t *)mem)[i] = 0xaa;
 
+	start_gpa = vm->available_base_gpa;
 	gpa = 0;
 	for (slot = first_slot; slot < max_slots; slot++) {
 		gpa = start_gpa + ((slot - first_slot) * slot_size);


