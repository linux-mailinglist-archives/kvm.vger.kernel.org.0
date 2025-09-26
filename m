Return-Path: <kvm+bounces-58886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D30C7BA4A2F
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2C0617A0CA
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177392F7ACE;
	Fri, 26 Sep 2025 16:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XdgwTAyf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4932EB86C
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758904286; cv=none; b=us+Eenr93DWOwBcJQFgEFFBVbxkP3NR2ni3qr5tHXAQn4aeqY2EUHElVnb++kRtZc7vc1DB6uSVH0IRPCkB16+HUMevnFwBtkZB/wP8yLF+z3IfiGY8WAR8ExxGmf9dX+g+yTR+SQExll54sf1LfvDQeaZK0GJFmtPiejDQnF1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758904286; c=relaxed/simple;
	bh=0SQATKFA5gi2ffa5TCQYKJ7IY8wK+LLtm/R1ws10kd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EhotdyRvYza9rlbckkMSf3gOxg1vlVW+pH2pRNXBE29mY5sdSpmJOB0HMIN232QuP/yY70h9j6286YC9uM0tbxeqwIcnLD6LMcnLiW+iPLhtL1adfOVsKaCuooqVvM0vfJilDInb+cZ6l3V/FWWVjGoM4VADhFH4n+k19zum1kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XdgwTAyf; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b550fab38e9so1706020a12.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 09:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758904283; x=1759509083; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sa4dCKWOiWX52uFMDDYKBgVjziPASjCyYcwrRWASNCs=;
        b=XdgwTAyfGLOQVsTPqGrCdq96jMfQAMg0sLbq++CckR+g19YmNI0CTWVIQT2V0GqYPY
         zVG7Thz4Jmsl7O8LpXh3yojrQ1zjgphoImNV3FK5FKCrn2INSVcLj0YWIkFUVCGjsve9
         eToTAEOPy41tZ2g/8brKBlJL5amFPaXQAqbe2TyPmqa3IpdPeAoWZNTZME/WnHU/O3KC
         OSKwCYcvEjSqq+430W0HHDHO0x7KWhaWmnfM/wgmJc6Sy9OzoRZRuponJsCNQxnYZb8k
         JO44KTv/vLI3t0YpbhkEI99m2URifoCiuniJXclKLn0CQ2N0Q6BVqXUPACtMeI2vjUZD
         kwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758904283; x=1759509083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sa4dCKWOiWX52uFMDDYKBgVjziPASjCyYcwrRWASNCs=;
        b=VmewMS1kSbhoT4ymitixXK1cBwUwTcpgTAfzGvw70g6kLR4YVrZebHP09HAj0fao9M
         81QKxqy1M/5S6ubDjlTGtcNefNTFyeAvaEblHj4tAJPhBjIKPxPWAMzyqLgjzb93OaWQ
         mEpL9DR54lsBrD304ev8KYpEBFSTyWkg3r58j9qvPLR5FP2/oGuwVgEyUpTMyQ3VjWbI
         Z32bCMmPUsZNsOk4kQXNQgUFF+X6B+ExEIAg5d5V4sVzXfrKzob/XExPm0XgHDl4w/fy
         yrDwsFEC89obApO2apZ1IcgnGEG1lUlQ4/sAx7SmWxrrGWPvgKh2HMGkWZiknaZuvv7f
         v7SQ==
X-Gm-Message-State: AOJu0Yzufz2HuYMg42QiczCm+etAn2Y8qneiWP9XSkOwMj9JpO4s9Z2A
	RVhuL/GfgD4hD/bPsI46hxioRy13kzpa9/LKw+5TBrfmr2/4PsfPFUa8v1lImHKbNO9JgmpD/M3
	QBLZKng==
X-Google-Smtp-Source: AGHT+IHxkuYFJdCTH53s6GSi6lSMHFNJPOSAv81AidBatI33QbAC/pL6MnFbStGz6ZCbISY/uGwjnu+EBo8=
X-Received: from pjdn93.prod.google.com ([2002:a17:90a:2ce6:b0:330:6513:c709])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c1:b0:32b:d8af:b636
 with SMTP id 98e67ed59e1d1-3342a2b9556mr8924156a91.19.1758904283515; Fri, 26
 Sep 2025 09:31:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 09:31:03 -0700
In-Reply-To: <20250926163114.2626257-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250926163114.2626257-3-seanjc@google.com>
Subject: [PATCH 2/6] KVM: selftests: Stash the host page size in a global in
 the guest_memfd test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Use a global variable to track the host page size in the guest_memfd test
so that the information doesn't need to be constantly passed around.  The
state is purely a reflection of the underlying system, i.e. can't be set
by the test and is constant for a given invocation of the test, and thus
explicitly passing the host page size to individual testcases adds no
value, e.g. doesn't allow testing different combinations.

Making page_size a global will simplify an upcoming change to create a new
guest_memfd instance per testcase.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 37 +++++++++----------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 81b11a958c7a..8251d019206a 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -24,6 +24,8 @@
 #include "test_util.h"
 #include "ucall_common.h"
 
+static size_t page_size;
+
 static void test_file_read_write(int fd)
 {
 	char buf[64];
@@ -38,7 +40,7 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
+static void test_mmap_supported(int fd, size_t total_size)
 {
 	const char val = 0xaa;
 	char *mem;
@@ -78,7 +80,7 @@ void fault_sigbus_handler(int signum)
 	siglongjmp(jmpbuf, 1);
 }
 
-static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
+static void test_fault_overflow(int fd, size_t total_size)
 {
 	struct sigaction sa_old, sa_new = {
 		.sa_handler = fault_sigbus_handler,
@@ -106,7 +108,7 @@ static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT(!ret, "munmap() should succeed.");
 }
 
-static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
+static void test_mmap_not_supported(int fd, size_t total_size)
 {
 	char *mem;
 
@@ -117,7 +119,7 @@ static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT_EQ(mem, MAP_FAILED);
 }
 
-static void test_file_size(int fd, size_t page_size, size_t total_size)
+static void test_file_size(int fd, size_t total_size)
 {
 	struct stat sb;
 	int ret;
@@ -128,7 +130,7 @@ static void test_file_size(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT_EQ(sb.st_blksize, page_size);
 }
 
-static void test_fallocate(int fd, size_t page_size, size_t total_size)
+static void test_fallocate(int fd, size_t total_size)
 {
 	int ret;
 
@@ -165,7 +167,7 @@ static void test_fallocate(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
 }
 
-static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
+static void test_invalid_punch_hole(int fd, size_t total_size)
 {
 	struct {
 		off_t offset;
@@ -196,8 +198,7 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
 }
 
 static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
-						  uint64_t guest_memfd_flags,
-						  size_t page_size)
+						  uint64_t guest_memfd_flags)
 {
 	size_t size;
 	int fd;
@@ -214,7 +215,6 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 {
 	int fd1, fd2, ret;
 	struct stat st1, st2;
-	size_t page_size = getpagesize();
 
 	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
 	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
@@ -241,7 +241,6 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 
 static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
 {
-	size_t page_size = getpagesize();
 	uint64_t flag;
 	int fd;
 
@@ -265,10 +264,8 @@ static void test_guest_memfd(unsigned long vm_type)
 	uint64_t flags = 0;
 	struct kvm_vm *vm;
 	size_t total_size;
-	size_t page_size;
 	int fd;
 
-	page_size = getpagesize();
 	total_size = page_size * 4;
 
 	vm = vm_create_barebones_type(vm_type);
@@ -277,22 +274,22 @@ static void test_guest_memfd(unsigned long vm_type)
 		flags |= GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_DEFAULT_SHARED;
 
 	test_create_guest_memfd_multiple(vm);
-	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
+	test_create_guest_memfd_invalid_sizes(vm, flags);
 
 	fd = vm_create_guest_memfd(vm, total_size, flags);
 
 	test_file_read_write(fd);
 
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
-		test_mmap_supported(fd, page_size, total_size);
-		test_fault_overflow(fd, page_size, total_size);
+		test_mmap_supported(fd, total_size);
+		test_fault_overflow(fd, total_size);
 	} else {
-		test_mmap_not_supported(fd, page_size, total_size);
+		test_mmap_not_supported(fd, total_size);
 	}
 
-	test_file_size(fd, page_size, total_size);
-	test_fallocate(fd, page_size, total_size);
-	test_invalid_punch_hole(fd, page_size, total_size);
+	test_file_size(fd, total_size);
+	test_fallocate(fd, total_size);
+	test_invalid_punch_hole(fd, total_size);
 
 	test_guest_memfd_flags(vm, flags);
 
@@ -367,6 +364,8 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
+	page_size = getpagesize();
+
 	/*
 	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
 	 * support guest_memfd have that support for the default VM type.
-- 
2.51.0.536.g15c5d4f767-goog


