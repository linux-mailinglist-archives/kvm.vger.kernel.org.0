Return-Path: <kvm+bounces-58885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E668BA4A29
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26246168314
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB752EF65E;
	Fri, 26 Sep 2025 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xqp9tppY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F6F283FC2
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758904283; cv=none; b=Avq6VgQj2po3JpcuZeANVG/cF5UrcKB4VDuoESKehaPmvpkA5gF39YHKdHKbTVie0fWEjwKxEKLXReS9WxHO2YHhdFr6B1sOACWWlesgCTEq7misVIxaiHNJyHkx7uba6RxMwpq/arPEHbSCrxikvGKWcOdaHuSHBoEgrlIU8o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758904283; c=relaxed/simple;
	bh=f+Tzy0yIQ24Esao6nanWArdkkZC4I5k9qXHHhYacdLw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BPDoU0UiQnhrw7wkjGaXswWT22RqghMZbIu2cpL3mdF3OB2R+WDptzQSOGnNNmoCvBduqFi7F9BYv5z9qPZuscQ5LjdUL664PSyYtYvlMaAzQeM9mjsf5Ga7fynARdj3z8Xd74WrM/jTrao44jAghGOd/S+vW/ZF8ofzTcdhgCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xqp9tppY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4c72281674so1528250a12.3
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 09:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758904282; x=1759509082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Jrdnpe1IxxMyMBign8PA7N+60CNvizwtKgqYzwIpWS0=;
        b=xqp9tppY/tgF5Kzpbyy5g3EuX0w2c+RsaIeFMXzO1E4IPddG2rJfz2btGjFJHl2xZw
         v0N2wEGKOJFGMxgrV4nQ17wTyH15wnSRdLGnOp9yb87XrYGJVR67iK2IVKPlbsprBXDo
         zagWtSnIsYi0R/p+aOJtfYLa1memcTlmo3MtqpSkGwgzCqFP9IRilBUdmMWze+3VNYdO
         R7n7ukk6Vbqxf4Nvfm0cZLnRfYEOnnEePniJpe4f/q/7p182cGi7PgSlEDWO372iYei4
         PlOwUstxeWPGpaKYMBvaJlJNVNJm8THcTuI8Vc3nG915GJZ0OUT535w2g7F1r6pF3rkP
         rJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758904282; x=1759509082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jrdnpe1IxxMyMBign8PA7N+60CNvizwtKgqYzwIpWS0=;
        b=Xdhb03mPqi1qgoIWweVOOh7zFP4vpFlWgiCgyNRFvzD9nxwFiVdaBUbyv7bLMwDrmQ
         bSKBQdN99xIToyQvYw8aAaEvxFhLK7Mqhn88T1FgoSJEavL6+cbWIExLQ9E+7ZB160N2
         VmGrxL6o6poLcIXgO5WPqpTRb9PtIelVzKiv0CiBHhlwvUe/ixcFkhVF4NUCIWBCQoCJ
         wIQRi4/avhPa0GIrcx0eA5cUtntjTyn5Mn6afTpuVxTGDuko6j2/crN901DfLr2GU7yd
         KJxb4/5QuQPi2G+jA+elxRFARPUCxEzFJxvXRu83VH/UvipeP1ptZpkTrmVBpVfJXbcl
         frgQ==
X-Gm-Message-State: AOJu0YyWbmkBPh+Tt0+9FPUbG06EAFchS4jcbuSp+QvDinCKw/OJHVqa
	/ONXmhaKfkZx6A4XGp2J7eVOTdrLGoR3SDkEJ9AUS9LyW83r9juYj35P1uHzmBw2gOGuFMS2qsz
	6Kb5Ryg==
X-Google-Smtp-Source: AGHT+IHc0b7Kqaw2BbwPa1bS0TvTYtZb38Jra84sBINy0Wb/nOM/BBhCMtxiLzzsk4lLq4tKiNYiFQlnTiA=
X-Received: from pjbpg3.prod.google.com ([2002:a17:90b:1e03:b0:32d:69b3:b7b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0a:b0:32e:4924:690f
 with SMTP id 98e67ed59e1d1-3342a2437c4mr9057691a91.6.1758904281735; Fri, 26
 Sep 2025 09:31:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 09:31:02 -0700
In-Reply-To: <20250926163114.2626257-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250926163114.2626257-2-seanjc@google.com>
Subject: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject user
 page faults if not set
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a guest_memfd flag to allow userspace to state that the underlying
memory should be configured to be shared by default, and reject user page
faults if the guest_memfd instance's memory isn't shared by default.
Because KVM doesn't yet support in-place private<=>shared conversions, all
guest_memfd memory effectively follows the default state.

Alternatively, KVM could deduce the default state based on MMAP, which for
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
Cc: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst                 | 10 ++++++++--
 include/uapi/linux/kvm.h                       |  3 ++-
 tools/testing/selftests/kvm/guest_memfd_test.c |  5 +++--
 virt/kvm/guest_memfd.c                         |  6 +++++-
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c17a87a0a5ac..4dfe156bbe3c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6415,8 +6415,14 @@ guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
 When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
-supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
-enables mmap() and faulting of guest_memfd memory to host userspace.
+supports GUEST_MEMFD_FLAG_MMAP and  GUEST_MEMFD_FLAG_DEFAULT_SHARED.  Setting
+the MMAP flag on guest_memfd creation enables mmap() and faulting of guest_memfd
+memory to host userspace (so long as the memory is currently shared).  Setting
+DEFAULT_SHARED makes all guest_memfd memory shared by default (versus private
+by default).  Note!  Because KVM doesn't yet support in-place private<=>shared
+conversions, DEFAULT_SHARED must be specified in order to fault memory into
+userspace page tables.  This limitation will go away when in-place conversions
+are supported.
 
 When the KVM MMU performs a PFN lookup to service a guest fault and the backing
 guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6efa98a57ec1..38a2c083b6aa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1599,7 +1599,8 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
-#define GUEST_MEMFD_FLAG_MMAP	(1ULL << 0)
+#define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
+#define GUEST_MEMFD_FLAG_DEFAULT_SHARED	(1ULL << 1)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index b3ca6737f304..81b11a958c7a 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -274,7 +274,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	vm = vm_create_barebones_type(vm_type);
 
 	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
-		flags |= GUEST_MEMFD_FLAG_MMAP;
+		flags |= GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_DEFAULT_SHARED;
 
 	test_create_guest_memfd_multiple(vm);
 	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
@@ -337,7 +337,8 @@ static void test_guest_memfd_guest(void)
 		    "Default VM type should always support guest_memfd mmap()");
 
 	size = vm->page_size;
-	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
+	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |
+					     GUEST_MEMFD_FLAG_DEFAULT_SHARED);
 	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
 
 	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 08a6bc7d25b6..19f05a45be04 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -328,6 +328,9 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
+	if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_DEFAULT_SHARED))
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
+			       GUEST_MEMFD_FLAG_DEFAULT_SHARED;
 
 	if (flags & ~valid_flags)
 		return -EINVAL;
-- 
2.51.0.536.g15c5d4f767-goog


