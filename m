Return-Path: <kvm+bounces-58890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C094BA4A44
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EEC21C01C88
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4134F2FC031;
	Fri, 26 Sep 2025 16:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oj/3rMa7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5A02FB97E
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758904293; cv=none; b=PWomg7ZMWTyUaNvvK5puCU6J+kzugnfP/ljOPVGqYmsJSyVdUaDrGLx2p/Boan7ISoBgK/ssfk6FOnvMmsMPINYrU1keKuRBqJ+M0KoL6rnguhe18Mhs1eovEslmlBtsB26EGOpHwL0fw6z2xvK7Af+2SiTmwWW6qu1CorStX4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758904293; c=relaxed/simple;
	bh=DenFYgCl3E/nB8eGrwdfhtBbP3Ex8K/c68ZGtk2IY8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bpN5PBsa8M6JDicT6RDELrdSjJeQdGyDoWAly5qig8u2wgXCm0EUkOah3HwV+5AfTExX+w1xdZjTZPBe1snNBX032aHKnmhVAfEvclmB324THPfejj8ZpRM+sFOrVss8IwTzKzV9k18PPlm6V5UItLVS6KSFr+QgIHHyXa9knf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oj/3rMa7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-334b0876195so2252317a91.1
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 09:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758904291; x=1759509091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NCJm+oneDJ5rwsc/098MYrhburwn9yZWwqWNnrNvoPY=;
        b=oj/3rMa7BQsnZekp8ZYyQ4IjlQppnoRs6VjL7MEkqoMxXD1XnUsi74PjbgZFjC3W+2
         kkZu5c3gTxXU8fZXlmYdQSOS9HSdpNG+YA0MeqVsi3KcVPe5mct8zuXkHMb3piybjUIf
         f/wSAs2yoYFadqO1h6KM57rhdgoXDKyASIslQlHaQPNZrMo1r6YRlAXSrxGB/xhfzP8y
         RJFBpivc/eZ+6Uj7No3pzMg306PzUjm4gSXjNyssGzcftAmW6MHzCsHjREKFNItT96K6
         yHdXjcqfRrVAAZ3xdgvOti+cTvxodvgfwJP/N/OCEAk1i+UekrsOWYd79iaN+4+MCt84
         c8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758904291; x=1759509091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NCJm+oneDJ5rwsc/098MYrhburwn9yZWwqWNnrNvoPY=;
        b=gLQ5FJX2KbYgNN/KKQzaBGlujaAfIRQcdUBgW1x+n7ceUPHwuLdspZdOYgeZYP9zp5
         94Ym+9gzhc57gLdDKm4Q0Gv8m4+2fJqcp6/eu1wjANYWLNQBbsA+JLUgfR7OOE1FBcK3
         NXuDf4svYbtgH7C+Om5AIPyqFDILhPfg7FSPMCtqrSvzJ5wPhld/3yEqG0rPG2i4Ovng
         JIIWSsY2uqzLE6xovBUnUbTg9hvsC7ZhXFi8AeRTig53TBVWjQOBjZFd3uCZiDncKYeR
         SoYbWesmCyL1XCmsHdplT0eySxmmAkseH+iZSucRSZFOlMhuH8RTK1jN8V+jHPCsLIPI
         1iOw==
X-Gm-Message-State: AOJu0YycY/K8q3qMjBM+aTJROSW0IErslpq2cjoycGXOR5gJ7dkDIABo
	mF9U9KszkuposjVC7tC9pcJ5wvnAZbzFp9L0yVIf8Pa5dLuF/4nXUVKyKhTx1gH/WUPVZ77L2Wa
	yuFt3DA==
X-Google-Smtp-Source: AGHT+IEcjS8XYUaIxvLwGVIG6V9ayVItEqtASIL24S1Lw4LUyDHuVM8ZHEEBRAHizK6NEBTV8/u3Tvd2yLk=
X-Received: from pjhk88.prod.google.com ([2002:a17:90a:4ce1:b0:323:25d2:22db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38ca:b0:335:2a00:6836
 with SMTP id 98e67ed59e1d1-3352a00692bmr4201028a91.18.1758904291403; Fri, 26
 Sep 2025 09:31:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 09:31:07 -0700
In-Reply-To: <20250926163114.2626257-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250926163114.2626257-7-seanjc@google.com>
Subject: [PATCH 6/6] KVM: selftests: Verify that faulting in private
 guest_memfd memory fails
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a guest_memfd testcase to verify that faulting in private memory gets
a SIGBUS.  For now, test only the case where memory is private by default
since KVM doesn't yet support in-place conversion.

Cc: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 62 ++++++++++++++-----
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 5dd40b77dc07..b5a631aca933 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -40,17 +40,26 @@ static void test_file_read_write(int fd, size_t total_size)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap_supported(int fd, size_t total_size)
+static void *test_mmap_common(int fd, size_t size)
 {
-	const char val = 0xaa;
-	char *mem;
-	size_t i;
-	int ret;
+	void *mem;
 
-	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 	TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
 
-	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+	mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+
+	return mem;
+}
+
+static void test_mmap_supported(int fd, size_t total_size)
+{
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+	int ret;
+
+	mem = test_mmap_common(fd, total_size);
 
 	memset(mem, val, total_size);
 	for (i = 0; i < total_size; i++)
@@ -78,31 +87,47 @@ void fault_sigbus_handler(int signum)
 	siglongjmp(jmpbuf, 1);
 }
 
-static void test_fault_overflow(int fd, size_t total_size)
+static void *test_fault_sigbus(int fd, size_t size)
 {
 	struct sigaction sa_old, sa_new = {
 		.sa_handler = fault_sigbus_handler,
 	};
-	size_t map_size = total_size * 4;
-	const char val = 0xaa;
-	char *mem;
-	size_t i;
+	void *mem;
 
-	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+	mem = test_mmap_common(fd, size);
 
 	sigaction(SIGBUS, &sa_new, &sa_old);
 	if (sigsetjmp(jmpbuf, 1) == 0) {
-		memset(mem, 0xaa, map_size);
+		memset(mem, 0xaa, size);
 		TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
 	}
 	sigaction(SIGBUS, &sa_old, NULL);
 
+	return mem;
+}
+
+static void test_fault_overflow(int fd, size_t total_size)
+{
+	size_t map_size = total_size * 4;
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+
+	mem = test_fault_sigbus(fd, map_size);
+
 	for (i = 0; i < total_size; i++)
 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
 
 	kvm_munmap(mem, map_size);
 }
 
+static void test_fault_private(int fd, size_t total_size)
+{
+	void *mem = test_fault_sigbus(fd, total_size);
+
+	kvm_munmap(mem, total_size);
+}
+
 static void test_mmap_not_supported(int fd, size_t total_size)
 {
 	char *mem;
@@ -274,9 +299,12 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 
 	gmem_test(file_read_write, vm, flags);
 
-	if (flags & GUEST_MEMFD_FLAG_MMAP) {
+	if (flags & GUEST_MEMFD_FLAG_MMAP &&
+	    flags & GUEST_MEMFD_FLAG_DEFAULT_SHARED) {
 		gmem_test(mmap_supported, vm, flags);
 		gmem_test(fault_overflow, vm, flags);
+	} else if (flags & GUEST_MEMFD_FLAG_MMAP) {
+		gmem_test(fault_private, vm, flags);
 	} else {
 		gmem_test(mmap_not_supported, vm, flags);
 	}
@@ -294,9 +322,11 @@ static void test_guest_memfd(unsigned long vm_type)
 
 	__test_guest_memfd(vm, 0);
 
-	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
+	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP)) {
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
 				       GUEST_MEMFD_FLAG_DEFAULT_SHARED);
+	}
 
 	kvm_vm_free(vm);
 }
-- 
2.51.0.536.g15c5d4f767-goog


