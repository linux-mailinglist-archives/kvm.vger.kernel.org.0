Return-Path: <kvm+bounces-59477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50AD9BB8613
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:26:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED1E819E2458
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29EB3283C8E;
	Fri,  3 Oct 2025 23:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CHQYf0Tq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B441F27AC57
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533977; cv=none; b=Sb5+tYSDwerBKNVNXORkUnQT/qJrCgnBVypK5wOkru1Fhy0o/9WwNsFrDNFxK9CtRm5QKv7lG+pP5T5T1GN6TGEtqhBIi8I/1Mda1r0qRsNbMmGun4XXqaDQarC1gaMT7E9gKAsyxsmq03GfZTzQQeyhPKrQ1B911TqSMbMG7Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533977; c=relaxed/simple;
	bh=cBSCbLGuyu0i+pnnFJtW9XyUg/AWI2CO30mF/qWuptw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FaU1vSwzSxhABh7viB+qw+KstGB39OxOEFbHPRj43x6lSr31x0oTMMOT5YX3CnFfjgJb5ghIMM7cUhWLQZ++8fTLyH8KT7uMXM35T+orrIxFK5+TqOvy0WYsKHdrIMI+jDP7Z7gg9EThkQgdlwj5Nt/tnklz+anYLFfuNQpaBqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CHQYf0Tq; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27c62320f16so28045335ad.1
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533975; x=1760138775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=a+1Sii0G7hC5FMVOBHLi5jl/sMVLEnhBfdq+sbGC028=;
        b=CHQYf0TqTZQI5I5kXp73C2fng2vjg6GDQWfALKXP3ep2AQFKRw2kyzO/NHnd3B4m09
         DlOye0CDH5hs/q2W17YvzWiWhChvjdU0JCxXOxIhMKVxO9afzmribIgthk4+5P1L3wiY
         7ifN7TctI6y+IfV5/25DarjHo24bi+CuGkgsG4lb7w35ZlZQf0ima8Ls0al0U1fjqVYt
         2Y+kBO1Bu1PpAu3Vv4AOKLnrHe03SeSoo+TZjU5pZ0JzoYqyPQRsAEdF56q9AglFD16A
         s/jTJXZrpFSur5GgmNWjQxQPPmq+xKO1Ws+3RICoky7g/eMExOIxC84ydURmOZ4z2eU6
         gOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533975; x=1760138775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a+1Sii0G7hC5FMVOBHLi5jl/sMVLEnhBfdq+sbGC028=;
        b=ChEizqtKLYbmKIMywHY0NO42kAjuMFP20Fb3e0YmA7WdGrBP0ld3N3LzlxonI87xUw
         dcw4D49dRN9gGPVwSCDQ7A9VdXUnG3Qvc9sUfmC1oC1Zgdg48LZs8St4B/8Ls5wygp1i
         bm4FCvbGQBIjhKS9egXbBunnalUC5LTjGyBlsheVe7sXKpy6rQTI2e67O7mW9ZojHxJz
         KTMyCnrthADN/xFkN/2UvcxFD/3OH3kxvBF1N/6hE8GcxX0rrtevJpfxdkNNo4Ij+GR0
         HdkmQAlmrCx0CQTniISN0AxVS8UeyF30XbKQ7NUoezeToLXH0Q4Jc0oGcHPHmDUUTzJt
         e9dg==
X-Gm-Message-State: AOJu0YwzRgi2t/QKvNe5iE8+waB/2TBDrGu3nrCnSZ6ZO8C5wflf61sF
	4BHMMJMv96N1X9Eo2inoJ8dZ7qlknL9N0d2lYG8zboNJiMtEHJ+k1fAU111dK3kezJ84Y+VQNYP
	a8XXFPg==
X-Google-Smtp-Source: AGHT+IG79/9POvgYVBzEf8BKcEg3XVerQtIRac7iIPaoy9Au32zTuew6jnYHjJjthe8oCk/nymcslvQyqis=
X-Received: from plpj14.prod.google.com ([2002:a17:903:3d8e:b0:269:7d7a:40c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c0c:b0:269:8edf:67f8
 with SMTP id d9443c01a7336-28e9a6646dbmr53564545ad.52.1759533974981; Fri, 03
 Oct 2025 16:26:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:25:54 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-2-seanjc@google.com>
Subject: [PATCH v2 01/13] KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework the not-yet-released KVM_CAP_GUEST_MEMFD_MMAP into a more generic
KVM_CAP_GUEST_MEMFD_FLAGS capability so that adding new flags doesn't
require a new capability, and so that developers aren't tempted to bundle
multiple flags into a single capability.

Note, kvm_vm_ioctl_check_extension_generic() can only return a 32-bit
value, but that limitation can be easily circumvented by adding e.g.
KVM_CAP_GUEST_MEMFD_FLAGS2 in the unlikely event guest_memfd supports more
than 32 flags.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst                 | 10 +++++++---
 include/uapi/linux/kvm.h                       |  2 +-
 tools/testing/selftests/kvm/guest_memfd_test.c | 13 ++++++-------
 virt/kvm/kvm_main.c                            |  7 +++++--
 4 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6ae24c5ca559..7ba92f2ced38 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6432,9 +6432,13 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
-When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
-supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
-enables mmap() and faulting of guest_memfd memory to host userspace.
+The capability KVM_CAP_GUEST_MEMFD_FLAGS enumerates the `flags` that can be
+specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
+
+  ============================ ================================================
+  GUEST_MEMFD_FLAG_MMAP        Enable using mmap() on the guest_memfd file
+                               descriptor.
+  ============================ ================================================
 
 When the KVM MMU performs a PFN lookup to service a guest fault and the backing
 guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6efa98a57ec1..b1d52d0c56ec 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -962,7 +962,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
-#define KVM_CAP_GUEST_MEMFD_MMAP 244
+#define KVM_CAP_GUEST_MEMFD_FLAGS 244
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index b3ca6737f304..3e58bd496104 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -262,19 +262,17 @@ static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
 
 static void test_guest_memfd(unsigned long vm_type)
 {
-	uint64_t flags = 0;
 	struct kvm_vm *vm;
 	size_t total_size;
 	size_t page_size;
+	uint64_t flags;
 	int fd;
 
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
 	vm = vm_create_barebones_type(vm_type);
-
-	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
-		flags |= GUEST_MEMFD_FLAG_MMAP;
+	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
 
 	test_create_guest_memfd_multiple(vm);
 	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
@@ -328,13 +326,14 @@ static void test_guest_memfd_guest(void)
 	size_t size;
 	int fd, i;
 
-	if (!kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+	if (!kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS))
 		return;
 
 	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
 
-	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP),
-		    "Default VM type should always support guest_memfd mmap()");
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLAG_MMAP,
+		    "Default VM type should support MMAP, supported flags = 0x%x",
+		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
 
 	size = vm->page_size;
 	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 226faeaa8e56..e3a268757621 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4928,8 +4928,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:
 		return 1;
-	case KVM_CAP_GUEST_MEMFD_MMAP:
-		return !kvm || kvm_arch_supports_gmem_mmap(kvm);
+	case KVM_CAP_GUEST_MEMFD_FLAGS:
+		if (!kvm || kvm_arch_supports_gmem_mmap(kvm))
+			return GUEST_MEMFD_FLAG_MMAP;
+
+		return 0;
 #endif
 	default:
 		break;
-- 
2.51.0.618.g983fd99d29-goog


