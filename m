Return-Path: <kvm+bounces-38471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2D4A3A441
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A627F16DB87
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E2B272903;
	Tue, 18 Feb 2025 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CP2sbgKy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E19271823
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899527; cv=none; b=jxdu2abXAf30g5jylcGOYrFuFkCaZrxSIhP8YvMdQm2u/CjAzQ9wSkM/oe+oODb7Cob5U1cLVnInj+QK7erAndNTpe/fz/lXn0mQj5V3mSCSVcfc6FXsEOgIBNNRK9cixU9vujeIosh2szQu+jsIdmIrjEz9af5T005xXDSQcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899527; c=relaxed/simple;
	bh=So/ODguRobsiMOmS+iLPdjxlB9A2T4w8hVf2uniuTyc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A0AVtmpW0x35PmH2b/xNGYU5VTnSIfu6TJVJrN3HQInZxs3bCk60+/ThpsT4bcS1nZ2bUMOEQ2gKmrWCdY1L8r3u9tSe/S9EA/yMlUjqNY3vTpV6xqzrMejvAwaqrpqkBt2tfhkfBA3Fnpey1HaZ+/sOFMr8A2FPrxkPMRP8ryg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CP2sbgKy; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43933b8d9b1so30508315e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739899524; x=1740504324; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9GhkdiTtGRQx7HkZyWp1aLkTAfBUArmMth/ZSf0dJkM=;
        b=CP2sbgKyFhP+4HtQ7rECtNpRfbNJwWGkfXL58KxkU+QCQC7IrhNb848+rCRZU6K8tY
         b8LODWVx+cjxn0CeIvzE9Y07q8d7qOH/6PhtkDu/a5UGVrvC23k46Hi8eLymgNUF07tD
         XKl0oOAmfBN8IXe6/m0ri67eVEr1OI8vLOjYKqsAEXuW03Y7yTvU2HS/TxBXOdFtLHAl
         xyYM8W6UmJQPJI16g3e3/CaBxvRTMGncZCICWnXuYVM0vL3nvPyRwUNoCiFeo1KthRbQ
         h3tciq8r4+T2B1XpW5p2bEuCIi23qJFQjHRNIbuNPZVOVgtH37Xf2WCFvAQqLAXgrtHV
         5gEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899524; x=1740504324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9GhkdiTtGRQx7HkZyWp1aLkTAfBUArmMth/ZSf0dJkM=;
        b=TSk2t7A0TF3Dpzdj/++lQDGB961bdS2K4m3u9zYodkCZXOGPEwgVMNck+bFe6UXM7n
         xZ9QwZroub1Z7SqkhX8yW8hvwopsb+J4Xmo9Hf0n11mZcXdV2lYbJzM1lmKw9RamCsyK
         XIYzK1Jg9z/9iSfLvdZfA3k68rELXTEp1nPZocAXJDsNTlE1gIafkG+fZdPMMNRjE6rk
         CHOt6/y1x2uDHQ34yCLfpeEUaNeyMFom6RQPa53kXosQmBr8mRxqOUTeNFbWt9zhaSgM
         m47Hg6+erPb0Yrm2wdC3pX5OuTJfmOOLo983iFl3hzPcq/PhFsZLC5On9AJYzloeATsO
         5ohQ==
X-Gm-Message-State: AOJu0YxspApZ9RrszKXbpiBtySfrLfPC8AkSqlTPWrDLwxmfBF026rLe
	bQ+B6C81C3JZuoCLBjxZ33nWJ7cxah6OR6pAQAl28TbWi7ITag32WJCTiQXnfdFnikBnjBoJyju
	kP9OjGC+XBLhn3x35Y5kwmPWwWvgScbIK2yFGOp9Uqa2zs+XSAh/2ApaXPpbWeVvRz6P9edaeaZ
	DjoMNtqwj+NIcGzHfySdP/U0k=
X-Google-Smtp-Source: AGHT+IEV4feF4d+8DAbHzGAlutoYlJf9k+yhRtIv1D+yKbeY7XS93jwvPa8IZZ9GBcPiztNTCq3yl8l6ig==
X-Received: from wmbec10.prod.google.com ([2002:a05:600c:610a:b0:439:9379:38c7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c83:b0:439:9828:c44b
 with SMTP id 5b1f17b1804b1-4399828c601mr19285985e9.14.1739899523888; Tue, 18
 Feb 2025 09:25:23 -0800 (PST)
Date: Tue, 18 Feb 2025 17:25:00 +0000
In-Reply-To: <20250218172500.807733-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218172500.807733-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250218172500.807733-11-tabba@google.com>
Subject: [PATCH v4 10/10] KVM: guest_memfd: selftests: guest_memfd mmap() test
 when mapping is allowed
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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
memory for VM types that support it.

Also, build the guest_memfd selftest for aarch64.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 75 +++++++++++++++++--
 2 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4277b983cace..c9a3f30e28dd 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -160,6 +160,7 @@ TEST_GEN_PROGS_arm64 += coalesced_io_test
 TEST_GEN_PROGS_arm64 += demand_paging_test
 TEST_GEN_PROGS_arm64 += dirty_log_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
+TEST_GEN_PROGS_arm64 += guest_memfd_test
 TEST_GEN_PROGS_arm64 += guest_print_test
 TEST_GEN_PROGS_arm64 += get-reg-list
 TEST_GEN_PROGS_arm64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..38c501e49e0e 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -34,12 +34,48 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap(int fd, size_t page_size)
+static void test_mmap_allowed(int fd, size_t total_size)
 {
+	size_t page_size = getpagesize();
+	const char val = 0xaa;
+	char *mem;
+	int ret;
+	int i;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
+
+	memset(mem, val, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], val);
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			page_size);
+	TEST_ASSERT(!ret, "fallocate the first page should succeed");
+
+	for (i = 0; i < page_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0x00);
+	for (; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], val);
+
+	memset(mem, val, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], val);
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
 }
 
 static void test_file_size(int fd, size_t page_size, size_t total_size)
@@ -170,19 +206,27 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
-int main(int argc, char *argv[])
+unsigned long get_shared_type(void)
 {
-	size_t page_size;
+#ifdef __x86_64__
+	return KVM_X86_SW_PROTECTED_VM;
+#endif
+	return 0;
+}
+
+void test_vm_type(unsigned long type, bool is_shared)
+{
+	struct kvm_vm *vm;
 	size_t total_size;
+	size_t page_size;
 	int fd;
-	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
-	vm = vm_create_barebones();
+	vm = vm_create_barebones_type(type);
 
 	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
@@ -190,10 +234,29 @@ int main(int argc, char *argv[])
 	fd = vm_create_guest_memfd(vm, total_size, 0);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+
+	if (is_shared)
+		test_mmap_allowed(fd, total_size);
+	else
+		test_mmap_denied(fd, total_size);
+
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
 
 	close(fd);
+	kvm_vm_release(vm);
+}
+
+int main(int argc, char *argv[])
+{
+#ifndef __aarch64__
+	/* For now, arm64 only supports shared guest memory. */
+	test_vm_type(VM_TYPE_DEFAULT, false);
+#endif
+
+	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
+		test_vm_type(get_shared_type(), true);
+
+	return 0;
 }
-- 
2.48.1.601.g30ceb7b040-goog


