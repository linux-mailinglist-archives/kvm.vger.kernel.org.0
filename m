Return-Path: <kvm+bounces-59478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D10BB8616
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:27:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F6E34A5606
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15494287518;
	Fri,  3 Oct 2025 23:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tsq0v68m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFEA280330
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533979; cv=none; b=KZ80vYu1fvWNSP+UW9p25vrKUintb6K7kt9iiVfrn3xgesDYljZPBfsBO9RhkBlwoS4Whnu1jKssMTtEgA0hTmw1nK7bB3AHbo/41Cdnv2ipQAuMlJv4yFWo2JxOqUsYxwzJZl0+OoZr1ziOFpLbjGVI0z5JFrG+MveZuuTGLQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533979; c=relaxed/simple;
	bh=1v/mhrPlVxJZgZzeIdRHd4nNgyUm+aJgX/qajFTMclY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=By3mb2U1uuWN7voNAMY5KTu3Ow+tCBdZ5B45yIj8N8P2iyfqoOJAXXuXGxsKp3iUy88IiTCObCNJafOR9Cz1b4aqEI/LYlpN4Ac5iPQ+3CNpboYFUEGtpuP3s6aZHFSM4oNPwPKRNkHYCPYpVUZv5imWOJVJVKImqpcCQuHq5tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tsq0v68m; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso4596549a91.2
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533977; x=1760138777; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dErpNYwkBnA4Ms/9JY48CCyGK42f8PnH4KojDbSi2ZQ=;
        b=tsq0v68m4Q8XGsb36fvGYMi0BmWqSAWgyjx2B6us0aGKI1lYzxpJUViqjBzXiwAziy
         IrK+w5fzKOOKT0MEOmY8SkjKHlfVogX8AjvvVl84ALxwHyMiMtOv94KTZ3v3lVqcM1nv
         gZZA1OWzgLW1PBptxXVwGL5Sl4RkLIfoB18befV+F/vHPnq3KVdhmnrgRvLkiOiuhtWi
         r3K9wgwtmXwJpVpqy2h08m05TW3v5Gp/6lcXQftwqrY7jQi5RdDnDUO3sjAoYuRKm4PG
         cCQLRXKrAYN23LAiDRVCwjF+Z+X9S7SIiSgklhuFog6RqM4R69XAKLtxhEahKAeJISBS
         r/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533977; x=1760138777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dErpNYwkBnA4Ms/9JY48CCyGK42f8PnH4KojDbSi2ZQ=;
        b=oA/LtNU1XJEb83d3Gs5VHz503/uCXJ70ccI8m8jxUyVPtNU+Hu+wU9wl8pMu3S1lPU
         dlavHCswcWwgKiPbNV0v+vJakz977QFA7rz/tp8Ae+EkYzPuhb0mMoEVoN28Ml+Bwq8L
         Y1KOyS2f9bH3K7cVbktXh2r4pxHIUDZQJQH/ofutX+RpaqXeUSAWnXw6nJ1j9UVHQQyH
         mzAR7/2Do/peDPEcjafFy/QYGp5NQQZbuatMZzSNeeTwmpDQ/dWLEw1WrVDQqxKIM4WF
         qWXFE3dIgI7qBJnD4U/5MjIjww9Hz352Hw/iJdJKEzWBCPzBg9hO5l4LUS1O0ht7Xxtb
         +4iA==
X-Gm-Message-State: AOJu0YzPEF/iuAzlV40WpmMp2jRKNJyFRVvs9mufrMIzBKLFGmNPnFiQ
	y9V4+xQFuN3Vr2tnKQ+378YGWVuLnqkEFsQ7SLn6FWwaNz79+NU/IkWvgJ+tE2mNy/CAEmCgXNz
	rYsWrbQ==
X-Google-Smtp-Source: AGHT+IGmLnipcJ89n+6tzffsI8k91zXGxgNt382krjG/YtWM7Ua8ai7tDSt5Ju3IqqrXrgiSZn6heHHqOuc=
X-Received: from pjbnn13.prod.google.com ([2002:a17:90b:38cd:b0:32e:3830:65f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d0:b0:330:6c5a:4af4
 with SMTP id 98e67ed59e1d1-339c27cf614mr5247147a91.35.1759533976769; Fri, 03
 Oct 2025 16:26:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:25:55 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-3-seanjc@google.com>
Subject: [PATCH v2 02/13] KVM: guest_memfd: Add INIT_SHARED flag, reject user
 page faults if not set
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a guest_memfd flag to allow userspace to state that the underlying
memory should be configured to be initialized as shared, and reject user
page faults if the guest_memfd instance's memory isn't shared.  Because
KVM doesn't yet support in-place private<=>shared conversions, all
guest_memfd memory effectively follows the initial state.

Alternatively, KVM could deduce the initial state based on MMAP, which for
all intents and purposes is what KVM currently does.  However, implicitly
deriving the default state based on MMAP will result in a messy ABI when
support for in-place conversions is added.

For x86 CoCo VMs, which don't yet support MMAP, memory is currently private
by default (otherwise the memory would be unusable).  If MMAP implies
memory is shared by default, then the default state for CoCo VMs will vary
based on MMAP, and from userspace's perspective, will change when in-place
conversion support is added.  I.e. to maintain guest<=>host ABI, userspace
would need to immediately convert all memory from shared=>private, which
is both ugly and inefficient.  The inefficiency could be avoided by adding
a flag to state that memory is _private_ by default, irrespective of MMAP,
but that would lead to an equally messy and hard to document ABI.

Bite the bullet and immediately add a flag to control the default state so
that the effective behavior is explicit and straightforward.

Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
Cc: David Hildenbrand <david@redhat.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst                 |  5 +++++
 include/uapi/linux/kvm.h                       |  3 ++-
 tools/testing/selftests/kvm/guest_memfd_test.c | 15 ++++++++++++---
 virt/kvm/guest_memfd.c                         |  6 +++++-
 virt/kvm/kvm_main.c                            |  3 ++-
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7ba92f2ced38..754b662a453c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6438,6 +6438,11 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
   ============================ ================================================
   GUEST_MEMFD_FLAG_MMAP        Enable using mmap() on the guest_memfd file
                                descriptor.
+  GUEST_MEMFD_FLAG_INIT_SHARED Make all memory in the file shared during
+                               KVM_CREATE_GUEST_MEMFD (memory files created
+                               without INIT_SHARED will be marked private).
+                               Shared memory can be faulted into host userspace
+                               page tables. Private memory cannot.
   ============================ ================================================
 
 When the KVM MMU performs a PFN lookup to service a guest fault and the backing
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b1d52d0c56ec..52f6000ab020 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1599,7 +1599,8 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
-#define GUEST_MEMFD_FLAG_MMAP	(1ULL << 0)
+#define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
+#define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 3e58bd496104..0de56ce3c4e2 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -239,8 +239,9 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
-static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
+static void test_guest_memfd_flags(struct kvm_vm *vm)
 {
+	uint64_t valid_flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
 	size_t page_size = getpagesize();
 	uint64_t flag;
 	int fd;
@@ -274,6 +275,10 @@ static void test_guest_memfd(unsigned long vm_type)
 	vm = vm_create_barebones_type(vm_type);
 	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
 
+	/* This test doesn't yet support testing mmap() on private memory. */
+	if (!(flags & GUEST_MEMFD_FLAG_INIT_SHARED))
+		flags &= ~GUEST_MEMFD_FLAG_MMAP;
+
 	test_create_guest_memfd_multiple(vm);
 	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
 
@@ -292,7 +297,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
 
-	test_guest_memfd_flags(vm, flags);
+	test_guest_memfd_flags(vm);
 
 	close(fd);
 	kvm_vm_free(vm);
@@ -334,9 +339,13 @@ static void test_guest_memfd_guest(void)
 	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLAG_MMAP,
 		    "Default VM type should support MMAP, supported flags = 0x%x",
 		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLAG_INIT_SHARED,
+		    "Default VM type should support INIT_SHARED, supported flags = 0x%x",
+		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
 
 	size = vm->page_size;
-	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
+	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |
+					     GUEST_MEMFD_FLAG_INIT_SHARED);
 	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
 
 	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 94bafd6c558c..cf3afba23a6b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -328,6 +328,9 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
+	if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
+		return VM_FAULT_SIGBUS;
+
 	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 	if (IS_ERR(folio)) {
 		int err = PTR_ERR(folio);
@@ -525,7 +528,8 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 valid_flags = 0;
 
 	if (kvm_arch_supports_gmem_mmap(kvm))
-		valid_flags |= GUEST_MEMFD_FLAG_MMAP;
+		valid_flags |= GUEST_MEMFD_FLAG_MMAP |
+			       GUEST_MEMFD_FLAG_INIT_SHARED;
 
 	if (flags & ~valid_flags)
 		return -EINVAL;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e3a268757621..5f644ca54af3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4930,7 +4930,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 	case KVM_CAP_GUEST_MEMFD_FLAGS:
 		if (!kvm || kvm_arch_supports_gmem_mmap(kvm))
-			return GUEST_MEMFD_FLAG_MMAP;
+			return GUEST_MEMFD_FLAG_MMAP |
+			       GUEST_MEMFD_FLAG_INIT_SHARED;
 
 		return 0;
 #endif
-- 
2.51.0.618.g983fd99d29-goog


