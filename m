Return-Path: <kvm+bounces-26424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 608049746E8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18335283CC3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5C51C2DAE;
	Tue, 10 Sep 2024 23:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="liqKuMGg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC281C2429
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011931; cv=none; b=KBp4ms8sY1TVMIp4v4g+nC+6GToZCNWJhLK5aDdP/t/SGFkklEWmFDjbGed/OW9uGxNooS6tOWJds6E3R4whTM61m20YNCNxpd4FET6S30e2Ndx7uMPyxKpy941NHGgC/1xkBQvuOd++CeM4ySE3HmHXrKSpreWUK/9v2Erwi5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011931; c=relaxed/simple;
	bh=G1xvv3VhKdX7sOu89I1TMKp58s4sr/aulFadLA7UKxQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oIiNzq4vV5gqD/67DvzbLkD3fBeZjfDG36gUKFNYpiYprFT2Wc0ZhkJFnDWCo6lGJ79+cXx1NCaOI6/MFXTeZl6bf4W5gAjfw8nd0O8biayMnrU+0Xn3kVF4yBTOj4uG30WrGuqA1xnmlx9VQxMH+Us5HSejvtctxiu1f6Xnupo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=liqKuMGg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2db5d285f7cso1652674a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011928; x=1726616728; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OpTxhyUXuMtHPMfLsf+VosdcWmSbqHHnAO9eI97+DWM=;
        b=liqKuMGg/lEQECBg5CK0FuCJNHVl2PQKknoWbsPLpOR99fsxuP+ZEspceZutrYZQtv
         RUhRj5V8QPJupdqfMSusP9e2aTVLcXS1Jqla70O3eR1FAosCr1mWtg2OFsDHWBzzSPKd
         Y5i9P4LL4/FvWSKBvNlElj5x9Dj9XhrZLmsP2CDzFFZBTlfSzBAIDET3y5TwIZDb0plA
         D7s+iL89lLluD3NAcVEu4vOAnw4N+iQ49Bu9xrAl+5qHiXA9a5d0VezZwyp0qXQrz9ud
         kRcrjcS4rrqGJL2ONpnSm1+XGK3bnl6SvYtZatS/OUGUoA1YucVjtrkcErxi8S9ShbSY
         qahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011928; x=1726616728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OpTxhyUXuMtHPMfLsf+VosdcWmSbqHHnAO9eI97+DWM=;
        b=BGfRyxsht0Pv+1ckxYpvhwNEvygviNtuYCtJnWDFcjm9rYVQ+e05DOewS6Qb6x4NMm
         pJYnGwe6uzW7q9ON7zjtq6sWEJOibFs+v+GKk1J79qGJrfbavZxw3+cAJJAosd0XO7/c
         xD90Td/AiAinj6UM0nMGHlEK5c2X2kO+aB4h0YjMztSMcMqIj/ctXbWCCxjXkBN9iwzc
         jy52KJx7L5JfQlV7Yzg3EDLmy89iqkQ5ucnpypI1T0nUcdgRwRyQPUDKNDrnWzC2dh2Z
         Cv7UInZDlLUhy+tIIfdld/6xvx8nbjMXAOyro5+T86ZGXBnpzXFIqKj49OMaS69E+yGQ
         s9Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUaMMn8CvbUCQXxA5f3rwi5wLjBIcaDP/bnjL9JsSA11ycT5Ywk/oLmIXBx+9pj3rAEfUw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtzs4WrRJomcRgom9BY764Q5alPlRAy/qFOZXxh2WgaQ9eq2sC
	MJJZ2ButcfFzixDzNig/Uuuf3dkPJ+Ibw7UsDAHM2tldzgJfZZMd+l8ZnwBeNMtTK0lo9bfu1SG
	0ZI9nsdS/0sJ64DLVn+EZ4w==
X-Google-Smtp-Source: AGHT+IGDCVAzc3Os2kH8Tey/rqyfjIzDxCVVgwAtu26YcOS+JGYzGKn0YwTy0lhdNyewynSeBma3RYB4AAVHIEMUkQ==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:90b:4f49:b0:2da:6c1e:1576 with
 SMTP id 98e67ed59e1d1-2dad4b8ba79mr41392a91.0.1726011928288; Tue, 10 Sep 2024
 16:45:28 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:44:03 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <a9b095b8e5f5e921e60c6cd6d5d52d61ba677910.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 32/39] KVM: selftests: Test using guest_memfd memory from userspace
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

Test using guest_memfd from userspace, since guest_memfd now has
mmap() support.

Tests:

1. mmap() should now always return a valid address
2. Test that madvise() doesn't give any issues when pages are not
   faulted in.
3. Test that pages should not be faultable before association with a
   memslot, and that faults result in SIGBUS.
4. Test that pages can be faulted if marked faultable, and the flow of
   setting a memory range as private, which is:
   a. madvise(MADV_DONTNEED) to request kernel to unmap pages
   b. Set memory attributes of VM to private
   Also test that if pages are still mapped, setting memory attributes
   will fail.
5. Test that madvise(MADV_REMOVE) can be used to remove pages from
   guest_memfd, forcing zeroing of those pages before the next time
   the pages are faulted in.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>

---
 .../testing/selftests/kvm/guest_memfd_test.c  | 195 +++++++++++++++++-
 1 file changed, 189 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 3618ce06663e..b6f3c3e6d0dd 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -6,6 +6,7 @@
  */
 #include <stdlib.h>
 #include <string.h>
+#include <sys/wait.h>
 #include <unistd.h>
 #include <errno.h>
 #include <stdio.h>
@@ -35,12 +36,192 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap(int fd, size_t page_size)
+static void test_mmap_should_map_pages_into_userspace(int fd, size_t page_size)
 {
 	char *mem;
 
 	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	TEST_ASSERT_EQ(mem, MAP_FAILED);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should return valid address");
+
+	TEST_ASSERT_EQ(munmap(mem, page_size), 0);
+}
+
+static void test_madvise_no_error_when_pages_not_faulted(int fd, size_t page_size)
+{
+	char *mem;
+
+	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should return valid address");
+
+	TEST_ASSERT_EQ(madvise(mem, page_size, MADV_DONTNEED), 0);
+
+	TEST_ASSERT_EQ(munmap(mem, page_size), 0);
+}
+
+static void assert_not_faultable(char *address)
+{
+	pid_t child_pid;
+
+	child_pid = fork();
+	TEST_ASSERT(child_pid != -1, "fork failed");
+
+	if (child_pid == 0) {
+		*address = 'A';
+	} else {
+		int status;
+		waitpid(child_pid, &status, 0);
+
+		TEST_ASSERT(WIFSIGNALED(status),
+			    "Child should have exited with a signal");
+		TEST_ASSERT_EQ(WTERMSIG(status), SIGBUS);
+	}
+}
+
+/*
+ * Pages should not be faultable before association with memslot because pages
+ * (in a KVM_X86_SW_PROTECTED_VM) only default to faultable at memslot
+ * association time.
+ */
+static void test_pages_not_faultable_if_not_associated_with_memslot(int fd,
+								    size_t page_size)
+{
+	char *mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			 MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should return valid address");
+
+	assert_not_faultable(mem);
+
+	TEST_ASSERT_EQ(munmap(mem, page_size), 0);
+}
+
+static void test_pages_faultable_if_marked_faultable(struct kvm_vm *vm, int fd,
+						     size_t page_size)
+{
+	char *mem;
+	uint64_t gpa = 0;
+	uint64_t guest_memfd_offset = 0;
+
+	/*
+	 * This test uses KVM_X86_SW_PROTECTED_VM is required to set
+	 * arch.has_private_mem, to add a memslot with guest_memfd to a VM.
+	 */
+	if (!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
+		printf("Faultability test skipped since KVM_X86_SW_PROTECTED_VM is not supported.");
+		return;
+	}
+
+	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
+		   guest_memfd_offset);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should return valid address");
+
+	/*
+	 * Setting up this memslot with a KVM_X86_SW_PROTECTED_VM marks all
+	 * offsets in the file as shared, allowing pages to be faulted in.
+	 */
+	vm_set_user_memory_region2(vm, 0, KVM_MEM_GUEST_MEMFD, gpa, page_size,
+				   mem, fd, guest_memfd_offset);
+
+	*mem = 'A';
+	TEST_ASSERT_EQ(*mem, 'A');
+
+	/* Should fail since the page is still faulted in. */
+	TEST_ASSERT_EQ(__vm_set_memory_attributes(vm, gpa, page_size,
+						  KVM_MEMORY_ATTRIBUTE_PRIVATE),
+		       -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	/*
+	 * Use madvise() to remove the pages from userspace page tables, then
+	 * test that the page is still faultable, and that page contents remain
+	 * the same.
+	 */
+	madvise(mem, page_size, MADV_DONTNEED);
+	TEST_ASSERT_EQ(*mem, 'A');
+
+	/* Tell kernel to unmap the page from userspace. */
+	madvise(mem, page_size, MADV_DONTNEED);
+
+	/* Now kernel can set this page to private. */
+	vm_mem_set_private(vm, gpa, page_size);
+	assert_not_faultable(mem);
+
+	/*
+	 * Should be able to fault again after setting this back to shared, and
+	 * memory contents should be cleared since pages must be re-prepared for
+	 * SHARED use.
+	 */
+	vm_mem_set_shared(vm, gpa, page_size);
+	TEST_ASSERT_EQ(*mem, 0);
+
+	/* Cleanup */
+	vm_set_user_memory_region2(vm, 0, KVM_MEM_GUEST_MEMFD, gpa, 0, mem, fd,
+				   guest_memfd_offset);
+
+	TEST_ASSERT_EQ(munmap(mem, page_size), 0);
+}
+
+static void test_madvise_remove_releases_pages(struct kvm_vm *vm, int fd,
+					       size_t page_size)
+{
+	char *mem;
+	uint64_t gpa = 0;
+	uint64_t guest_memfd_offset = 0;
+
+	/*
+	 * This test uses KVM_X86_SW_PROTECTED_VM is required to set
+	 * arch.has_private_mem, to add a memslot with guest_memfd to a VM.
+	 */
+	if (!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
+		printf("madvise test skipped since KVM_X86_SW_PROTECTED_VM is not supported.");
+		return;
+	}
+
+	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should return valid address");
+
+	/*
+	 * Setting up this memslot with a KVM_X86_SW_PROTECTED_VM marks all
+	 * offsets in the file as shared, allowing pages to be faulted in.
+	 */
+	vm_set_user_memory_region2(vm, 0, KVM_MEM_GUEST_MEMFD, gpa, page_size,
+				   mem, fd, guest_memfd_offset);
+
+	*mem = 'A';
+	TEST_ASSERT_EQ(*mem, 'A');
+
+	/*
+	 * MADV_DONTNEED causes pages to be removed from userspace page tables
+	 * but should not release pages, hence page contents are kept.
+	 */
+	TEST_ASSERT_EQ(madvise(mem, page_size, MADV_DONTNEED), 0);
+	TEST_ASSERT_EQ(*mem, 'A');
+
+	/*
+	 * MADV_REMOVE causes pages to be released. Pages are then zeroed when
+	 * prepared for shared use, hence 0 is expected on next fault.
+	 */
+	TEST_ASSERT_EQ(madvise(mem, page_size, MADV_REMOVE), 0);
+	TEST_ASSERT_EQ(*mem, 0);
+
+	TEST_ASSERT_EQ(munmap(mem, page_size), 0);
+
+	/* Cleanup */
+	vm_set_user_memory_region2(vm, 0, KVM_MEM_GUEST_MEMFD, gpa, 0, mem, fd,
+				   guest_memfd_offset);
+}
+
+static void test_using_memory_directly_from_userspace(struct kvm_vm *vm,
+						      int fd, size_t page_size)
+{
+	test_mmap_should_map_pages_into_userspace(fd, page_size);
+
+	test_madvise_no_error_when_pages_not_faulted(fd, page_size);
+
+	test_pages_not_faultable_if_not_associated_with_memslot(fd, page_size);
+
+	test_pages_faultable_if_marked_faultable(vm, fd, page_size);
+
+	test_madvise_remove_releases_pages(vm, fd, page_size);
 }
 
 static void test_file_size(int fd, size_t page_size, size_t total_size)
@@ -180,18 +361,17 @@ static void test_guest_memfd(struct kvm_vm *vm, uint32_t flags, size_t page_size
 	size_t total_size;
 	int fd;
 
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
-
 	total_size = page_size * 4;
 
 	fd = vm_create_guest_memfd(vm, total_size, flags);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
 
+	test_using_memory_directly_from_userspace(vm, fd, page_size);
+
 	close(fd);
 }
 
@@ -201,7 +381,10 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
-	vm = vm_create_barebones();
+	if ((kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM)))
+		vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
+	else
+		vm = vm_create_barebones();
 
 	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
-- 
2.46.0.598.g6f2099f65c-goog


