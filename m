Return-Path: <kvm+bounces-58687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A094AB9B18A
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E043A7A5377
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85134315D3E;
	Wed, 24 Sep 2025 17:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0Wkc1/p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B0A1C831A
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758735780; cv=none; b=M7/hWDxhTyYrTrYPbFhQePTyldvHi8A6I0QLUg77gDmnT9szO9531gWr/HhO631gTdhtAuGLfL+fehlMMNArCul89q/MOvThwKQb7oJhj9+O9sK8DtFEdDiylz8/Z+5Eli2gB+dcHfOYhno+K4oLQU3FUlZJrOl0SnsnLkBnTIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758735780; c=relaxed/simple;
	bh=G+3ZRqT1PoaXjRdb5oeX5rvzeJjyHI1vcgX8HaETxWE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=O4wATeP5+J2DUVeNOnT8HBkXQrxHXnFlqWxlDGvQ3okJb1wZ+ObbvEhlvxQRVuqOc+5InWiMVFOfYjwTYKfS8ueDImzSeEK86uYENtS6QJxQor+0h7nA1+rVc34AzG0e0Ish1tEF+ZChrL3aSnnpFXiKD3SVmvniAWkdyUN9GAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s0Wkc1/p; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec67fcb88so71688a91.3
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 10:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758735778; x=1759340578; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NKLHKuSSH5KomJKM38o7XR7NGc4hSYm/KrkL7rWCOhI=;
        b=s0Wkc1/pO0w+kTx7E4dy+4XRUXrQwUyVBbJI0P4w8JDW/7IEUZlNAYjije59K8z6UA
         XXWT49Ay+6Ml2mI2s9TULe5wCetf3iVQEdXwfqY0WPO20f3sTN1oTvT/QhjGV1tJ7nUd
         YDKg8o8Ah+uQ2AcxPkDDHBKGokid70KJAkaArAeY/3qLgd1fecE4F4CASJ1YZClu1ssw
         HRe8SPs9RFLnoU1kV784gn2GwX4XCcFCoj9JQ28e8rNsg/eifXwXRwwxUlLo55AvhqcZ
         IsbEgk9+AM7KZAmTf1gf2xi7owWds6RPsJ89DURDpyjlOjH+pBwIksBsJASAqAtpUqyr
         9vLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758735778; x=1759340578;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NKLHKuSSH5KomJKM38o7XR7NGc4hSYm/KrkL7rWCOhI=;
        b=Ng85Ux4XAiMUYQfdjYCUuJVvGNskis2Co9SRwwpJR/A3MJbbWvxVhidmhHukhSwdSP
         iLcQ1761Mze9uhmHglkLM2gKfSVSvDSkVQEMsFPTqdiZUV8SqUGZQE7GIy0RQgosqxDJ
         YJncUoVxbF3GQa0k+whP14kRTBm1jkwfHRCzNDtRIXOPhQjFzduzneEYqKn+fUKX+yXy
         CFxMZUhdyjD6NAZftWxpE0fA7KRi6oVirsK3gJn2Vx/gjrf4zCmPeqQWhR7uH1hbOyBZ
         g7+141M5+V/fDLaZuDPPv9A2lCUyjtR2Ttt3F38xYJ2co5SvcxElLgvgN44mdckvVtBv
         Vtpg==
X-Gm-Message-State: AOJu0YyHsAWoSfz2erOjQ0YBhIa3WkUigvDALmmX2yDAoBBz+bSMah/O
	fSPgHdaAtSOUOX0NDgSCpPDe47CoPQMe33+Hl8ZhucwFm0/PRNNJnYcUB2ddz3Fgeql1UO5CvtF
	CHo9SBQ==
X-Google-Smtp-Source: AGHT+IHdLIFgjQqMCG7KTukyX1lK7wVnctYuW/7FsXop1pIla2RIXjz99qbnEjDth8Kr2bCD1ntyG42LX3M=
X-Received: from pjbcx21.prod.google.com ([2002:a17:90a:fd95:b0:329:ccdd:e725])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c04:b0:334:18f9:8008
 with SMTP id 98e67ed59e1d1-3342a2701e7mr581983a91.8.1758735778322; Wed, 24
 Sep 2025 10:42:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 24 Sep 2025 10:42:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250924174255.2141847-1-seanjc@google.com>
Subject: [PATCH v3] KVM: selftests: Test prefault memory during concurrent
 memslot removal
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Yan Zhao <yan.y.zhao@intel.com>

Expand the prefault memory selftest to add a regression test for a KVM bug
where TDX's retry logic (to avoid tripping the zero-step mitigation) would
result in deadlock due to the memslot deletion waiting on prefaulting to
release SRCU, and prefaulting waiting on the memslot to fully disappear
(KVM uses a two-step process to delete memslots, and KVM x86 retries page
faults if a to-be-deleted, a.k.a. INVALID, memslot is encountered).

To exercise concurrent memslot remove, spawn a second thread to initiate
memslot removal at roughly the same time as prefaulting.  Test memslot
removal for all testcases, i.e. don't limit concurrent removal to only the
success case.  There are essentially three prefault scenarios (so far)
that are of interest:

 1. Success
 2. ENOENT due to no memslot
 3. EAGAIN due to INVALID memslot

For all intents and purposes, #1 and #2 are mutually exclusive, or rather,
easier to test via separate testcases since writing to non-existent memory
is trivial.  But for #3, making it mutually exclusive with #1 _or_ #2 is
actually more complex than testing memslot removal for all scenarios.  The
only requirement to let memslot removal coexist with other scenarios is a
way to guarantee a stable result, e.g. that the "no memslot" test observes
ENOENT, not EAGAIN, for the final checks.

So, rather than make memslot removal mutually exclusive with the ENOENT
scenario, simply restore the memslot and retry prefaulting.  For the "no
memslot" case, KVM_PRE_FAULT_MEMORY should be idempotent, i.e. should
always fail with ENOENT regardless of how many times userspace attempts
prefaulting.

Pass in both the base GPA and the offset (instead of the "full" GPA) so
that the worker can recreate the memslot.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v3 of Yan's series to fix a deadlock when prefaulting memory for a TDX
guest.  The KVM fixes have already been applied, all that remains is this
selftest.

v3: Test memslot removal for both positive and negative testcases, and simply
    ensure a stable result by restoring the memslot and retrying if necessary.

v2: https://lore.kernel.org/all/20250822070305.26427-1-yan.y.zhao@intel.com

 .../selftests/kvm/pre_fault_memory_test.c     | 131 +++++++++++++++---
 1 file changed, 114 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 0350a8896a2f..f04768c1d2e4 100644
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
@@ -49,18 +98,65 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
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
+		 */
+		if (!slot_recreated) {
+			WRITE_ONCE(data.recreate_slot, true);
+			pthread_join(slot_worker, NULL);
+			slot_recreated = true;
+
+			/*
+			 * Retry prefaulting to get a stable result, i.e. to
+			 * avoid seeing random EAGAIN failures.  Don't retry if
+			 * prefaulting already succeeded, as KVM disallows
+			 * prefaulting with size=0, i.e. blindly retrying would
+			 * result in test failures due to EINVAL.  KVM should
+			 * always return success if all bytes are prefaulted,
+			 * i.e. there is no need to guard against EAGAIN being
+			 * returned.
+			 */
+			if (range.size)
+				continue;
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
@@ -97,9 +193,10 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 
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
2.51.0.536.g15c5d4f767-goog


