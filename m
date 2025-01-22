Return-Path: <kvm+bounces-36264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA768A1953E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13EA518813C2
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F402147E5;
	Wed, 22 Jan 2025 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P9lmBN5a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A607F214A97
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559681; cv=none; b=S0BsNW8FdQoWLvGEKGiIOhjb/jbYYIA7KN4Di9QDJ4mKUodQpC0YR67O11IPL1VQB4+h7N0zLnQAYCDulHZi4impf+dck7mx64O8G0na1QoWdiuUXAJAINVbrYBq1Syc/ZJGMuP38qSx9Q7UcdWvf6OdELf69/MUvkGDSDADxwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559681; c=relaxed/simple;
	bh=v8bvIB0SR5ZqHNQbiU5nzzMn7CaF8SquFt9ItHh08aM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LBLlZFIyiP7jfAg8iTClK56Ba88jJwu0IvAu4dCH59VIPh2HjHaFMTSMsOoH71ak9rOSPAtSS9sOvbUd4oAh2V9j8VBNqRH31Lhxe7TJglJM5xP4KE6ey7jRYw8+OJ8cugRnvFs9QoFWXCBE7pjoSFr6of1X/WtYW16h3WzAgZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P9lmBN5a; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43619b135bcso36417035e9.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 07:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737559678; x=1738164478; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=npQ4G6IRMYUbsOMeJWf56VvRGJDHzOqgY/NEKvIEjT0=;
        b=P9lmBN5aa/9RBPBdyihTc98t57LVFAX728ElWPw5XYW6iFh7NF2cbxzSg3JnjkJQp9
         hqL9edLKIgBE4lJkC84fr0gTpz6YQlwgdFNkhVWNsSw1mgaQ2rP5Rl1jIKysETMKLClq
         VFWp/hMcGJeP52jTbwUMa3PE/ZZXWFIW6eEvp3m/vUfZA83/QdQC4u7NEjNTzSViGsf7
         mX90/D0FlhMaPIiCTSv+fsOYaN9hM/5gdOud90YYqGb3elR2Q4e916uwiOmM/44uwKiG
         g366AhYJChUhdSLzBhgVBPmsRHkh3ONUpteP1tvEfivMBr/MUVpJQUWEzhGpE3lhEIQx
         JHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737559678; x=1738164478;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=npQ4G6IRMYUbsOMeJWf56VvRGJDHzOqgY/NEKvIEjT0=;
        b=nOk7B3ziaXatNYRO5kKSmhOwZidtlxSMplA7wwYo6f+VNKbifLybf7WG0TNSXaX3Xy
         41gVsUd6qSOdvRKSK4QpBP91BvCBQGijQY7XsNOt0X1d+SYsrFNbHZiN3mnj2/WOiBy9
         /18zR0vg2zwORppU0vEengCFwCEqj1Q5nyWwWdjClJIIGF/09u80YvZKoThU9Sj2sU/t
         swutFHaDOIXYhqa4YMDArhhSlDlVoq5yngjZpQyFFzp2pC9THANrIWmAytFJdtkqSJBR
         Bs5PSP88ajAm8zud/kK9YA402r6gEjBFv7aLgUCUzehRk3/mhywxL9TXLqy8BhUPdcOc
         U+iA==
X-Gm-Message-State: AOJu0YxVrVCEtfoKVeknyztRWvg002ZnMvuwawT0Q5Hc6kpHig4ma8o2
	X3KZXGdDpSAzka0JI5ckIBC5hCtngSsDiTfWspnjLXwnWFi6S715mpXfQBbT/s7beIiB459cgP3
	GV6YRKGVQsGhziXz+ydtVNK/8jYXRt44TFYsv94dWm+kv65oWoPA2F/NzPH/xXFktG1XWX+ffF8
	5Q3fn3LbD73saH3FdgGCr2wLw=
X-Google-Smtp-Source: AGHT+IFMt51o/dm1bu2dWWRmK/754r3bTaAX9g4hoTpYJtAfuY1vj2C8A/Y3n5D7Vdmv0hIc0uGo5eq33Q==
X-Received: from wmbjn3.prod.google.com ([2002:a05:600c:6b03:b0:434:a7ee:3c40])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4c24:b0:434:f3a1:b214
 with SMTP id 5b1f17b1804b1-4389da1e6c7mr184498125e9.28.1737559678054; Wed, 22
 Jan 2025 07:27:58 -0800 (PST)
Date: Wed, 22 Jan 2025 15:27:37 +0000
In-Reply-To: <20250122152738.1173160-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250122152738.1173160-9-tabba@google.com>
Subject: [RFC PATCH v1 8/9] KVM: guest_memfd: selftests: guest_memfd mmap()
 test when mapping is allowed
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Expand the guest_memfd selftests to include testing mapping guest
memory if the capability is supported, and that still checks that
memory is not mappable if the capability isn't supported.

Also, build the guest_memfd selftest for aarch64.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 60 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    |  3 +-
 3 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 41593d2e7de9..c998eb3c3b77 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -174,6 +174,7 @@ TEST_GEN_PROGS_aarch64 += coalesced_io_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
+TEST_GEN_PROGS_aarch64 += guest_memfd_test
 TEST_GEN_PROGS_aarch64 += guest_print_test
 TEST_GEN_PROGS_aarch64 += get-reg-list
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..6c501cb865f3 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -34,12 +34,55 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap(int fd, size_t page_size)
+static void test_mmap_allowed(int fd, size_t total_size)
 {
+	size_t page_size = getpagesize();
+	char *mem;
+	int ret;
+	int i;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
+
+	memset(mem, 0xaa, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xaa);
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			page_size);
+	TEST_ASSERT(!ret, "fallocate the first page should succeed");
+
+	for (i = 0; i < page_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0x00);
+	for (; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xaa);
+
+	memset(mem, 0xaa, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xaa);
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+}
+
+static void test_mmap_denied(int fd, size_t total_size)
+{
+	size_t page_size = getpagesize();
 	char *mem;
 
 	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 	TEST_ASSERT_EQ(mem, MAP_FAILED);
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT_EQ(mem, MAP_FAILED);
+}
+
+static void test_mmap(int fd, size_t total_size)
+{
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MAPPABLE))
+		test_mmap_allowed(fd, total_size);
+	else
+		test_mmap_denied(fd, total_size);
 }
 
 static void test_file_size(int fd, size_t page_size, size_t total_size)
@@ -172,17 +215,24 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 
 int main(int argc, char *argv[])
 {
-	size_t page_size;
+	unsigned long type = VM_TYPE_DEFAULT;
+	struct kvm_vm *vm;
 	size_t total_size;
+	size_t page_size;
 	int fd;
-	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MAPPABLE)) {
+#ifdef __aarch64__
+		type = KVM_VM_TYPE_ARM_SW_PROTECTED;
+#endif
+	}
+
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
-	vm = vm_create_barebones();
+	vm = vm_create_barebones_type(type);
 
 	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
@@ -190,7 +240,7 @@ int main(int argc, char *argv[])
 	fd = vm_create_guest_memfd(vm, total_size, 0);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+	test_mmap(fd, total_size);
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 480e3a40d197..098ea04ec099 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -347,9 +347,8 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 	}
 
 #ifdef __aarch64__
-	TEST_ASSERT(!vm->type, "ARM doesn't support test-provided types");
 	if (vm->pa_bits != 40)
-		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
+		vm->type |= KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
 #endif
 
 	vm_open(vm);
-- 
2.48.0.rc2.279.g1de40edade-goog


