Return-Path: <kvm+bounces-57030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5BDB49D93
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 01:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDDAD3C55BE
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 23:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84C730BF70;
	Mon,  8 Sep 2025 23:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ODOl/lRS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534CC1D5AC0
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 23:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757375247; cv=none; b=ebcpeH7b8lwb2svLVx+r41jwdlu++b8X4NirTK7AaZp0306j0xjcj3B5DFa+pzZvfDHGlOuO5ThncWAyYO170V9UEpVqOuDggYpMmqtfBolU6LvNi8WMKtgAI5bkEXG2kId70XaZb39EF9F8pQEEvyXT8tZuNlDiIrBf/IbqHUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757375247; c=relaxed/simple;
	bh=8aqTuRCejIpuCS8ou960e7PRXbIxItGNHFrJCuWb4l4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TDy9uTMo8pUyp3ssbTYjjmEfa0qXnaEHmvTnjDxyhmZNnYCKYWc/DNBg0EhmmcyKyZNc4MmABu/j1+/WqwvMcmg7IFTIBu5Cx86QfEmxVXoUvMN3UAHSD85TJG/VZr6fbvtAwEOOxZlAacleIQSwpaDId9j6HmuytEoUZ8cVxbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ODOl/lRS; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4fc06ba4c1so3843490a12.1
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 16:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757375244; x=1757980044; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A1VaNxRefI7j0o+B2S9CKOufLjzCN6AGZ4LGfh0Njgc=;
        b=ODOl/lRSGiswGkJRf512mSi4OnqRGUFTgbBbGDz43J1sgkBSVV71v3Y3/vcwVcDRmX
         bVU88GivdDGo/tLg/oN4LRkOVnnh+WgAiY5t6SonZpRBdrvmlmRsa73WsIkug/l8BrDQ
         A8MlvZtQxz6gynqSIQGmJXj5aQDfwwWDe5MZHQs9ncvmMfYBlM97lkOIL6iQszP12VvD
         UsbRD4Ge+jj/wIhLviGZ1zCqTTXH3XeQ85P7IDysti6pZxJDuhPrpFoAWq3py6KdMxR2
         vv36T8BQqJOl8RH0ZXAodsKqzGpH5KbEnRzuNY3L6YOJmj7XaN0qbpO4VA40ucKyB5Ht
         vSLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757375244; x=1757980044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A1VaNxRefI7j0o+B2S9CKOufLjzCN6AGZ4LGfh0Njgc=;
        b=IAeQ7o57j2/aUijWqSLDuxij8Pel5K3p5hSerxrbWmQ4GBFi+8aVQzqm2JTSK5Z5P7
         Ut2MhMl8xnCF2v/fUPouclN681auTa+MlwPCZ4rDNkZVNMfbnzLJ06vWceH5w3XD2CWr
         20ePFRf21F/cJjUUGZ9+PIUFvyWbq1Q3deseDwfxwGclxnOtI+9HSWj9Gca9qUdNwEIx
         olLWKLZNWULqlsfj5KNFQR4kCujiTdptsJWHZGK/AXMRJl3O5GOK3+kpM1Y71+i6zyyu
         nM9itQ/S4jZK8YdnlHSWLdvPQnFLjHVIj4QKy4V20eTaVD91ftxaOkBbupaf4VKkR8oI
         6oYw==
X-Forwarded-Encrypted: i=1; AJvYcCWdXwuFunRGOzjGEdwQXh2efZ4muUsOhIzb/EF66b8CmViu43WiItE7j5YdHlvgz8ijutQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVzgfz8yaWECe3xz3+8g7/YljYoBweA7QzDeiHxXBylyjYa4cA
	qMc8jGDOfWryx5uxvSxQmzd0uSFdTq8Ob9k9Lv6/ZjHvyQVFDFohL0Z39mxXdL7alqyqlOknZYM
	dFiSdRQ==
X-Google-Smtp-Source: AGHT+IHc6lGnlKYr6vKweQxbxOj2RZDvfbTrxSaBL44zjiwpX9Vc5oxHqCC2rZOwq92+HG5EslwU6JXZv/Q=
X-Received: from plbmn8.prod.google.com ([2002:a17:903:a48:b0:24a:ad96:175])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e551:b0:24d:cd5a:5e88
 with SMTP id d9443c01a7336-2516da07750mr123229315ad.2.1757375244495; Mon, 08
 Sep 2025 16:47:24 -0700 (PDT)
Date: Mon, 8 Sep 2025 16:47:23 -0700
In-Reply-To: <20250822070554.26523-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822070305.26427-1-yan.y.zhao@intel.com> <20250822070554.26523-1-yan.y.zhao@intel.com>
Message-ID: <aL9rCwZGQofDh7C3@google.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Test prefault memory during
 concurrent memslot removal
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, reinette.chatre@intel.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 22, 2025, Yan Zhao wrote:
>  .../selftests/kvm/pre_fault_memory_test.c     | 94 +++++++++++++++----
>  1 file changed, 78 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> index 0350a8896a2f..56e65feb4c8c 100644
> --- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
> +++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> @@ -10,12 +10,16 @@
>  #include <test_util.h>
>  #include <kvm_util.h>
>  #include <processor.h>
> +#include <pthread.h>
>  
>  /* Arbitrarily chosen values */
>  #define TEST_SIZE		(SZ_2M + PAGE_SIZE)
>  #define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
>  #define TEST_SLOT		10
>  
> +static bool prefault_ready;
> +static bool delete_thread_ready;
> +
>  static void guest_code(uint64_t base_gpa)
>  {
>  	volatile uint64_t val __used;
> @@ -30,17 +34,47 @@ static void guest_code(uint64_t base_gpa)
>  	GUEST_DONE();
>  }
>  
> -static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
> -			     u64 left)
> +static void *remove_slot_worker(void *data)
> +{
> +	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
> +
> +	WRITE_ONCE(delete_thread_ready, true);
> +
> +	while (!READ_ONCE(prefault_ready))
> +		cpu_relax();
> +
> +	vm_mem_region_delete(vcpu->vm, TEST_SLOT);
> +
> +	WRITE_ONCE(delete_thread_ready, false);

Rather than use global variables, which necessitates these "dances" to get things
back to the initial state, use an on-stack structure to communicate (and obviously
make sure the structure is initialized :-D).

> +	return NULL;
> +}
> +
> +static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
> +			     u64 size, u64 left, bool private, bool remove_slot)
>  {
>  	struct kvm_pre_fault_memory range = {
> -		.gpa = gpa,
> +		.gpa = base_gpa + offset,
>  		.size = size,
>  		.flags = 0,
>  	};
> -	u64 prev;
> +	pthread_t remove_thread;
> +	bool remove_hit = false;
>  	int ret, save_errno;
> +	u64 prev;
>  
> +	if (remove_slot) {

I don't see any reason to make the slot removal conditional.  There are three
things we're interested in testing (so far):

 1. Success
 2. ENOENT due to no memslot
 3. EAGAIN due to INVALID memslot

#1 and #2 are mutually exclusive, or rather easier to test via separate testcases
(because writing to non-existent memory is trivial).  But for #3, I don't see a
reason to make it mutually exclusive with #1 _or_ #2.

As written, it's always mutually exclusive with #2 because otherwise it would be
difficult (impossible?) to determine if KVM exited on the "right" address.  But
the only reason that's true is because the test recreates the slot *after*
prefaulting, and _that_ makes #3 _conditionally_ mutually exclusive with #1,
i.e. the test doesn't validate success if the INVALID memslot race is hit.

Rather than make everything mutually exclusive, just restore the memslot and
retry prefaulting.  That also gives us easy bonus coverage that doing
KVM_PRE_FAULT_MEMORY on memory that has already been faulted in is idempotent,
i.e. that KVM_PRE_FAULT_MEMORY succeeds if it already succeeded (and nothing
nuked the mappings in the interim).

If the memslot is restored and the loop retries, then #3 becomes a complimentary
and orthogonal testcase to #1 and #2.

This?  (with an opportunistic s/left/expected_left that confused me; I thought
"left" meant how many bytes were left to prefault, but it actually means how many
bytes are expected to be left when failure occurs).

---
 .../selftests/kvm/pre_fault_memory_test.c     | 122 +++++++++++++++---
 1 file changed, 105 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 0350a8896a2f..2dbabf4b0b15 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -10,6 +10,7 @@
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
+#include <pthread.h>
 
 /* Arbitrarily chosen values */
 #define TEST_SIZE		(SZ_2M + PAGE_SIZE)
@@ -30,18 +31,66 @@ static void guest_code(uint64_t base_gpa)
 	GUEST_DONE();
 }
 
-static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
-			     u64 left)
+struct slot_worker_data {
+	struct kvm_vm *vm;
+	u64 gpa;
+	uint32_t flags;
+	bool worker_ready;
+	bool prefault_ready;
+	bool recreate_slot;
+};
+
+static void *delete_slot_worker(void *__data)
+{
+	struct slot_worker_data *data = __data;
+	struct kvm_vm *vm = data->vm;
+
+	WRITE_ONCE(data->worker_ready, true);
+
+	while (!READ_ONCE(data->prefault_ready))
+		cpu_relax();
+
+	vm_mem_region_delete(vm, TEST_SLOT);
+
+	while (!READ_ONCE(data->recreate_slot))
+		cpu_relax();
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, data->gpa,
+				    TEST_SLOT, TEST_NPAGES, data->flags);
+
+	return NULL;
+}
+
+static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
+			     u64 size, u64 expected_left, bool private)
 {
 	struct kvm_pre_fault_memory range = {
-		.gpa = gpa,
+		.gpa = base_gpa + offset,
 		.size = size,
 		.flags = 0,
 	};
-	u64 prev;
+	struct slot_worker_data data = {
+		.vm = vcpu->vm,
+		.gpa = base_gpa,
+		.flags = private ? KVM_MEM_GUEST_MEMFD : 0,
+	};
+	bool slot_recreated = false;
+	pthread_t slot_worker;
 	int ret, save_errno;
+	u64 prev;
 
-	do {
+	/*
+	 * Concurrently delete (and recreate) the slot to test KVM's handling
+	 * of a racing memslot deletion with prefaulting.
+	 */
+	pthread_create(&slot_worker, NULL, delete_slot_worker, &data);
+
+	while (!READ_ONCE(data.worker_ready))
+		cpu_relax();
+
+	WRITE_ONCE(data.prefault_ready, true);
+
+	for (;;) {
 		prev = range.size;
 		ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
 		save_errno = errno;
@@ -49,18 +98,56 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
 			    "%sexpecting range.size to change on %s",
 			    ret < 0 ? "not " : "",
 			    ret < 0 ? "failure" : "success");
-	} while (ret >= 0 ? range.size : save_errno == EINTR);
 
-	TEST_ASSERT(range.size == left,
-		    "Completed with %lld bytes left, expected %" PRId64,
-		    range.size, left);
+		/*
+		 * Immediately retry prefaulting if KVM was interrupted by an
+		 * unrelated signal/event.
+		 */
+		if (ret < 0 && save_errno == EINTR)
+			continue;
 
-	if (left == 0)
-		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+		/*
+		 * Tell the worker to recreate the slot in order to complete
+		 * prefaulting (if prefault didn't already succeed before the
+		 * slot was deleted) and/or to prepare for the next testcase.
+		 * Wait for the worker to exit so that the next invocation of
+		 * prefaulting is guaranteed to complete (assuming no KVM bugs).
+		 * Always retry prefaulting to simply the retry logic.  Either
+		 * prefaulting already succeeded, in which case retrying should
+		 * also succeed, or retry is needed to get a stable result.
+		 */
+		if (!slot_recreated) {
+			WRITE_ONCE(data.recreate_slot, true);
+			pthread_join(slot_worker, NULL);
+			slot_recreated = true;
+			continue;
+		}
+
+		/*
+		 * All done if there are no remaining bytes to prefault, or if
+		 * prefaulting failed (EINTR was handled above, and EAGAIN due
+		 * to prefaulting a memslot that's being actively deleted should
+		 * be impossible since the memslot has already been recreated).
+		 */
+		if (!range.size || ret < 0)
+			break;
+	}
+
+	TEST_ASSERT(range.size == expected_left,
+		    "Completed with %llu bytes left, expected %lu",
+		    range.size, expected_left);
+
+	/*
+	 * Assert success if prefaulting the entire range should succeed, i.e.
+	 * complete with no bytes remaining.  Otherwise prefaulting should have
+	 * failed due to ENOENT (due to RET_PF_EMULATE for emulated MMIO when
+	 * no memslot exists).
+	 */
+	if (!expected_left)
+		TEST_ASSERT_VM_VCPU_IOCTL(!ret, KVM_PRE_FAULT_MEMORY, ret, vcpu->vm);
 	else
-		/* No memory slot causes RET_PF_EMULATE. it results in -ENOENT. */
-		__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
-					    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+		TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
+					  KVM_PRE_FAULT_MEMORY, ret, vcpu->vm);
 }
 
 static void __test_pre_fault_memory(unsigned long vm_type, bool private)
@@ -97,9 +184,10 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 
 	if (private)
 		vm_mem_set_private(vm, guest_test_phys_mem, TEST_SIZE);
-	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, 0);
-	pre_fault_memory(vcpu, guest_test_phys_mem + SZ_2M, PAGE_SIZE * 2, PAGE_SIZE);
-	pre_fault_memory(vcpu, guest_test_phys_mem + TEST_SIZE, PAGE_SIZE, PAGE_SIZE);
+
+	pre_fault_memory(vcpu, guest_test_phys_mem, 0, SZ_2M, 0, private);
+	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
+	pre_fault_memory(vcpu, guest_test_phys_mem, TEST_SIZE, PAGE_SIZE, PAGE_SIZE, private);
 
 	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
 	vcpu_run(vcpu);

base-commit: ecbcc2461839e848970468b44db32282e5059925
--

