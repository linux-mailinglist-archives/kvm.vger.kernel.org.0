Return-Path: <kvm+bounces-59602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B47CEBC2D6D
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:16:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DDBB44F81DA
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32CE26D4CD;
	Tue,  7 Oct 2025 22:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3uxT0e+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFA92673A5
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875291; cv=none; b=ZmRv79Y/dlJvIxsbaUJw9YPBBAHzH00MUnnN0Af/KtbZQnPzuJOIjl3EQXPKxhSBSJYOl72luaeTVpqNgbVNLrYFSaMXiDtFTKh4Xtl1YdH2GhjIYQXgvZRexgLeWI0pNUOpicLAgUYjii71CzXa1SHkbGmZkfq4z9D/ZQ/WVjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875291; c=relaxed/simple;
	bh=9QNfABOWraA3taQoApqjT7Pwa5AuzjKaFuc0/UUE1Pg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TF/vnfQ0/hqYfb7AFDTl1HfdE9Sf/ttUS59ualPjmTxDEPRz8aqmDUTexHbHAMm6aWN0uAwX9Asq1WDJpmsy/HvWKHBz3vlhXGWvH91oSfy163n+xgc40QyPLYYlolNyzZUCBSqJkN3EhhhezK1+rAfeXuW79O1zQXRRZ63Wkoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3uxT0e+P; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc08so11562677a91.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875288; x=1760480088; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4KNNgsguWMAVMteoKqbz2qkx1TQM7zG2UmyWb4nmWLc=;
        b=3uxT0e+Pr6XrtdEkZqp3ijc3qZD4WWvfy9cl1pPtgZolSOzzCU/03X17zDBGT/0dxP
         D+8UflqoCGr1xqOQpOS+QofLyYOuyDOYSIvXKNr5ZRhQw3adjm435AZREXHO/ZUnmU95
         wK23FgIDJL+cyOphdRWFdyIPdd8OFyWVnzdctAgzRqF4mxkysXgzX16khn7TmHIgRiFD
         OtbuSnxhBlny238rxtg5yE3C3GpArTIW9bEfOvSH5Vy0kqWU9TjDWKHx4PknVLzDK+0s
         LwsgP/zA/EZwO1z37baqQnGs4zG+q2ixRmUyrB06+C8/Mszs5Xjd25UzhDfnEXujVhAw
         a/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875288; x=1760480088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KNNgsguWMAVMteoKqbz2qkx1TQM7zG2UmyWb4nmWLc=;
        b=vPMfKrh3ZFA5Ld8W3n6VHgyvoNO4ru7SYd/lk1mIJ8RibkwLUM9SIedCaeTAQHhTxG
         tD3Yr26wEkhxsc9vrNggkJv0BYNdRWUHkQS3OMfKBdKovmPnEq34yXnlRdZTzhmG1hy0
         4WarA9mgtBY+Nd9KMQ5n8SjtQD5o1e5VqHXzwu1gkatP4wkWwcXmb8Ai8Ru874DOBF6i
         rRjS+9viQ2Hgz9RgTQNV85ysaXc5qFQ6wPuk/ZldcX2DkReVSEbO70ywLWNH0OZHsYa2
         QggkZWCQyZWD6s1/Lpj4iGuchqoFOS47cjVSb5QD2cvEExHktb+8q1ZtZX4PpVajo4eU
         0xIA==
X-Forwarded-Encrypted: i=1; AJvYcCVA3EzqNzCjyFjKRiZht6mB0pWtJMlNb6u8bJL2UO41uOIzBZD/3rRuJo+KQMTl51sJmTM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp0doLdumNKICySr6cL8M+2kTTSZJp5on0ovH4J7MlC+BjzbSX
	xdmDC9QK91ztJNwlhvsXLZxljZiNLmqYxfi5C/NICpNO+N6gm19Ll+K+baAM+7+mgsyGgTNFeRU
	xJjKVkQ==
X-Google-Smtp-Source: AGHT+IGgExOMV0YIM7rmm9IiUJFl3PZd47hgnUxkpuhuP1B/XsRQRkmjfiWNgh6xxO8JVQv67XJShabxkfw=
X-Received: from pjbot13.prod.google.com ([2002:a17:90b:3b4d:b0:33b:51fe:1a92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a87:b0:335:2d4:8b3d
 with SMTP id 98e67ed59e1d1-33b5138625emr1311365a91.31.1759875288025; Tue, 07
 Oct 2025 15:14:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:14 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-7-seanjc@google.com>
Subject: [PATCH v12 06/12] KVM: selftests: Define wrappers for common syscalls
 to assert success
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Add kvm_<sycall> wrappers for munmap(), close(), fallocate(), and
ftruncate() to cut down on boilerplate code when a sycall is expected
to succeed, and to make it easier for developers to remember to assert
success.

Implement and use a macro framework similar to the kernel's SYSCALL_DEFINE
infrastructure to further cut down on boilerplate code, and to drastically
reduce the probability of typos as the kernel's syscall definitions can be
copy+paste almost verbatim.

Provide macros to build the raw <sycall>() wrappers as well, e.g. to
replace hand-coded wrappers (NUMA) or pure open-coded calls.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  2 +-
 .../selftests/kvm/include/kvm_syscalls.h      | 81 +++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  | 29 +------
 .../selftests/kvm/kvm_binary_stats_test.c     |  4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 31 ++-----
 .../kvm/x86/private_mem_conversions_test.c    |  9 +--
 6 files changed, 96 insertions(+), 60 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 6338f5bbdb70..8d7758f12280 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -636,7 +636,7 @@ static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
 	}
 
 	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++)
-		close(fd[f]);
+		kvm_close(fd[f]);
 }
 
 /* handles the valid case: intid=0xffffffff num=1 */
diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
new file mode 100644
index 000000000000..d4e613162bba
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_SYSCALLS_H
+#define SELFTEST_KVM_SYSCALLS_H
+
+#include <sys/syscall.h>
+
+#define MAP_ARGS0(m,...)
+#define MAP_ARGS1(m,t,a,...) m(t,a)
+#define MAP_ARGS2(m,t,a,...) m(t,a), MAP_ARGS1(m,__VA_ARGS__)
+#define MAP_ARGS3(m,t,a,...) m(t,a), MAP_ARGS2(m,__VA_ARGS__)
+#define MAP_ARGS4(m,t,a,...) m(t,a), MAP_ARGS3(m,__VA_ARGS__)
+#define MAP_ARGS5(m,t,a,...) m(t,a), MAP_ARGS4(m,__VA_ARGS__)
+#define MAP_ARGS6(m,t,a,...) m(t,a), MAP_ARGS5(m,__VA_ARGS__)
+#define MAP_ARGS(n,...) MAP_ARGS##n(__VA_ARGS__)
+
+#define __DECLARE_ARGS(t, a)	t a
+#define __UNPACK_ARGS(t, a)	a
+
+#define DECLARE_ARGS(nr_args, args...) MAP_ARGS(nr_args, __DECLARE_ARGS, args)
+#define UNPACK_ARGS(nr_args, args...) MAP_ARGS(nr_args, __UNPACK_ARGS, args)
+
+#define __KVM_SYSCALL_ERROR(_name, _ret) \
+	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
+
+/* Define a kvm_<syscall>() API to assert success. */
+#define __KVM_SYSCALL_DEFINE(name, nr_args, args...)			\
+static inline void kvm_##name(DECLARE_ARGS(nr_args, args))		\
+{									\
+	int r;								\
+									\
+	r = name(UNPACK_ARGS(nr_args, args));				\
+	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR(#name, r));			\
+}
+
+/*
+ * Macro to define syscall APIs, either because KVM selftests doesn't link to
+ * the standard library, e.g. libnuma, or because there is no library that yet
+ * provides the syscall.  These
+ */
+#define KVM_SYSCALL_DEFINE(name, nr_args, args...)			\
+static inline long name(DECLARE_ARGS(nr_args, args))			\
+{									\
+	return syscall(__NR_##name, UNPACK_ARGS(nr_args, args));	\
+}									\
+__KVM_SYSCALL_DEFINE(name, nr_args, args)
+
+/*
+ * Special case mmap(), as KVM selftest rarely/never specific an address,
+ * rarely specify an offset, and because the unique return code requires
+ * special handling anyways.
+ */
+static inline void *__kvm_mmap(size_t size, int prot, int flags, int fd,
+			       off_t offset)
+{
+	void *mem;
+
+	mem = mmap(NULL, size, prot, flags, fd, offset);
+	TEST_ASSERT(mem != MAP_FAILED, __KVM_SYSCALL_ERROR("mmap()",
+		    (int)(unsigned long)MAP_FAILED));
+	return mem;
+}
+
+static inline void *kvm_mmap(size_t size, int prot, int flags, int fd)
+{
+	return __kvm_mmap(size, prot, flags, fd, 0);
+}
+
+static inline int kvm_dup(int fd)
+{
+	int new_fd = dup(fd);
+
+	TEST_ASSERT(new_fd >= 0, __KVM_SYSCALL_ERROR("dup()", new_fd));
+	return new_fd;
+}
+
+__KVM_SYSCALL_DEFINE(munmap, 2, void *, mem, size_t, size);
+__KVM_SYSCALL_DEFINE(close, 1, int, fd);
+__KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, len);
+__KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
+
+#endif /* SELFTEST_KVM_SYSCALLS_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index ee60dbf5208a..c610169933ef 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -23,6 +23,7 @@
 
 #include <pthread.h>
 
+#include "kvm_syscalls.h"
 #include "kvm_util_arch.h"
 #include "kvm_util_types.h"
 #include "sparsebit.h"
@@ -283,34 +284,6 @@ static inline bool kvm_has_cap(long cap)
 	return kvm_check_cap(cap);
 }
 
-#define __KVM_SYSCALL_ERROR(_name, _ret) \
-	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
-
-static inline void *__kvm_mmap(size_t size, int prot, int flags, int fd,
-			       off_t offset)
-{
-	void *mem;
-
-	mem = mmap(NULL, size, prot, flags, fd, offset);
-	TEST_ASSERT(mem != MAP_FAILED, __KVM_SYSCALL_ERROR("mmap()",
-		    (int)(unsigned long)MAP_FAILED));
-
-	return mem;
-}
-
-static inline void *kvm_mmap(size_t size, int prot, int flags, int fd)
-{
-	return __kvm_mmap(size, prot, flags, fd, 0);
-}
-
-static inline void kvm_munmap(void *mem, size_t size)
-{
-	int ret;
-
-	ret = munmap(mem, size);
-	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
-}
-
 /*
  * Use the "inner", double-underscore macro when reporting errors from within
  * other macros so that the name of ioctl() and not its literal numeric value
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index f02355c3c4c2..b7dbde9c0843 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -239,14 +239,14 @@ int main(int argc, char *argv[])
 		 * single stats file works and doesn't cause explosions.
 		 */
 		vm_stats_fds = vm_get_stats_fd(vms[i]);
-		stats_test(dup(vm_stats_fds));
+		stats_test(kvm_dup(vm_stats_fds));
 
 		/* Verify userspace can instantiate multiple stats files. */
 		stats_test(vm_get_stats_fd(vms[i]));
 
 		for (j = 0; j < max_vcpu; ++j) {
 			vcpu_stats_fds[j] = vcpu_get_stats_fd(vcpus[i * max_vcpu + j]);
-			stats_test(dup(vcpu_stats_fds[j]));
+			stats_test(kvm_dup(vcpu_stats_fds[j]));
 			stats_test(vcpu_get_stats_fd(vcpus[i * max_vcpu + j]));
 		}
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 83a721be7ec5..8b60b767224b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -704,8 +704,6 @@ userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 
 static void kvm_stats_release(struct kvm_binary_stats *stats)
 {
-	int ret;
-
 	if (stats->fd < 0)
 		return;
 
@@ -714,8 +712,7 @@ static void kvm_stats_release(struct kvm_binary_stats *stats)
 		stats->desc = NULL;
 	}
 
-	ret = close(stats->fd);
-	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+	kvm_close(stats->fd);
 	stats->fd = -1;
 }
 
@@ -738,8 +735,6 @@ __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
  */
 static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
-	int ret;
-
 	if (vcpu->dirty_gfns) {
 		kvm_munmap(vcpu->dirty_gfns, vm->dirty_ring_size);
 		vcpu->dirty_gfns = NULL;
@@ -747,9 +742,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 	kvm_munmap(vcpu->run, vcpu_mmap_sz());
 
-	ret = close(vcpu->fd);
-	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
-
+	kvm_close(vcpu->fd);
 	kvm_stats_release(&vcpu->stats);
 
 	list_del(&vcpu->list);
@@ -761,16 +754,12 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 void kvm_vm_release(struct kvm_vm *vmp)
 {
 	struct kvm_vcpu *vcpu, *tmp;
-	int ret;
 
 	list_for_each_entry_safe(vcpu, tmp, &vmp->vcpus, list)
 		vm_vcpu_rm(vmp, vcpu);
 
-	ret = close(vmp->fd);
-	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
-
-	ret = close(vmp->kvm_fd);
-	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+	kvm_close(vmp->fd);
+	kvm_close(vmp->kvm_fd);
 
 	/* Free cached stats metadata and close FD */
 	kvm_stats_release(&vmp->stats);
@@ -828,7 +817,7 @@ void kvm_vm_free(struct kvm_vm *vmp)
 int kvm_memfd_alloc(size_t size, bool hugepages)
 {
 	int memfd_flags = MFD_CLOEXEC;
-	int fd, r;
+	int fd;
 
 	if (hugepages)
 		memfd_flags |= MFD_HUGETLB;
@@ -836,11 +825,8 @@ int kvm_memfd_alloc(size_t size, bool hugepages)
 	fd = memfd_create("kvm_selftest", memfd_flags);
 	TEST_ASSERT(fd != -1, __KVM_SYSCALL_ERROR("memfd_create()", fd));
 
-	r = ftruncate(fd, size);
-	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR("ftruncate()", r));
-
-	r = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, size);
-	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR("fallocate()", r));
+	kvm_ftruncate(fd, size);
+	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, size);
 
 	return fd;
 }
@@ -1084,8 +1070,7 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 			 * needing to track if the fd is owned by the framework
 			 * or by the caller.
 			 */
-			guest_memfd = dup(guest_memfd);
-			TEST_ASSERT(guest_memfd >= 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd));
+			guest_memfd = kvm_dup(guest_memfd);
 		}
 
 		region->region.guest_memfd = guest_memfd;
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 82a8d88b5338..1969f4ab9b28 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -380,7 +380,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
 	struct kvm_vm *vm;
-	int memfd, i, r;
+	int memfd, i;
 
 	const struct vm_shape shape = {
 		.mode = VM_MODE_DEFAULT,
@@ -428,11 +428,8 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	 * should prevent the VM from being fully destroyed until the last
 	 * reference to the guest_memfd is also put.
 	 */
-	r = fallocate(memfd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, memfd_size);
-	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR("fallocate()", r));
-
-	r = fallocate(memfd, FALLOC_FL_KEEP_SIZE, 0, memfd_size);
-	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR("fallocate()", r));
+	kvm_fallocate(memfd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, memfd_size);
+	kvm_fallocate(memfd, FALLOC_FL_KEEP_SIZE, 0, memfd_size);
 
 	close(memfd);
 }
-- 
2.51.0.710.ga91ca5db03-goog


