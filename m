Return-Path: <kvm+bounces-35817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A54A15457
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:31:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF11E3A4B31
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9462919E979;
	Fri, 17 Jan 2025 16:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NkJ602gf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD5A19F462
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131428; cv=none; b=aLxqZbYD4YHt9MVRybhkjR3rHyQlY/h4PrUAXH3hZMXx2nUvPwVm41aOOjqmm+lVzRPiQ76JND3drwrOzqEhPdlDzjEm/kOTv0NlmycdJKQrHtdwGT3NXUXtS/E3eBd5bheC2+KacnyLgx7Fl4x0EMrhc1DqJGQUer1Z10KO1LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131428; c=relaxed/simple;
	bh=SNCigYc9J0MoXMLnVEGDyK3YVByWEysZdrZNCK1K+H8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nk1kC+fgj+qsgDdWw8xVlSAJC2eMuyQCbpJEhw4cXUU4EZdRrK/qkaAAp1Co04P9kef+RsaC3ZJbCusPsd1oVAmqLtHuD2Wztn+/3cqKs///BlIKRYzokb4nv149UHkw96Wvjq24srDj6BNFP2AXJtQUNamXIOscMDOHflqMKPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NkJ602gf; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43625ceae52so11895685e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737131425; x=1737736225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xo0QGcWhFZe9U6hSQiSPOH6tARFYvfNnZ2E+qSQ4HQk=;
        b=NkJ602gfo+4xOLrPLpy4g0KR4kJhZVPEfaS7CD1rUy2DmpRoFYTXoylDuXu4ujj77Q
         Wo55E7smx5+l1VJ2jD1DSd5J/KO9R8dvwy06aYkrOcwqfuITpVJBdkH0oLxQS5SJ201g
         DbRbigDhOoo8ZrM6vO+V1AdYsDbjb8uwTSaMfQ46t539k19/cmpOC4fo/DgnqDV5W0ua
         5EXqsom7HgFg7YIuLWqD5L/VZojlSleNDSUAKgZoAPsgrdyDg6cAhNOqJnVnP5MfpCXy
         OFj5T2tQ/sz1bWkFiSLPpWJLmlQcLUBLHij9lYQdKHf5GY4MJajDiWe76e35KCDin7oe
         ySoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131425; x=1737736225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xo0QGcWhFZe9U6hSQiSPOH6tARFYvfNnZ2E+qSQ4HQk=;
        b=bykpEly6VHFluzBLEyMT2eUbr3FazzgP971DS3/MLhP+7YBHfWnK9antUnnmyYU8YR
         LRXJxtk8lQRffwXR1oJwyLjNFZrFMIlXV0Q7OU7d/6/xXD69cK7fYclVHVKhAoU+BPBA
         6trA0P6iMU07ORu2HLqpCyW6tgY1OwEd28T3d8V95fmopP7AlgcgiETGRcH/fzGz69CY
         pItvFa4xbJb48JnvEB53TtyD61L4W6BuAj+SCL28ldneIaA2i8k1ceBHnE6JC4Vw7Rr3
         JMi+u04bLElA/ExFUbsSE8EXgP4FiWGGbZ+wus8Syf513NAe0fPoDr6HQq9J5zDclZvh
         62KQ==
X-Gm-Message-State: AOJu0YyV85hQ5sq25kvfbQL4HIwYvRAaNbLu9coBJOEW/W3dvsf1Zemv
	9iaxXSEd6dUdDa+whQxqUpDXGQjNBxszVPs27oz7C1XRMjBL9J7cfWNHQBVMwhTsCVyExuyrzIu
	PHsm5OlAVl6VgH/gi5f1y3v+Z5qukp3jHvzHjDbZ2e/ENlri2OAHOIhbew98uSmZ0xm/you98Yd
	/DQMLLhz5Ybi6g1KDn5PUq4j8=
X-Google-Smtp-Source: AGHT+IEr5gHEVjnL0bNACXR5FJY9vyiyHwTa1xX0TfEkZNy7DAbAsx+X4Pqj72+4G5i8n4A/x2j0nCfypw==
X-Received: from wmsn40.prod.google.com ([2002:a05:600c:3ba8:b0:434:a1af:5d39])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f82:b0:436:fbe0:cebe
 with SMTP id 5b1f17b1804b1-43891452f6emr37291625e9.30.1737131425133; Fri, 17
 Jan 2025 08:30:25 -0800 (PST)
Date: Fri, 17 Jan 2025 16:29:56 +0000
In-Reply-To: <20250117163001.2326672-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117163001.2326672-11-tabba@google.com>
Subject: [RFC PATCH v5 10/15] KVM: guest_memfd: Add a guest_memfd() flag to
 initialize it as mappable
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

Not all use cases require guest_memfd() to be mappable by the
host when first created. Add a new flag,
GUEST_MEMFD_FLAG_INIT_MAPPABLE, which when set on
KVM_CREATE_GUEST_MEMFD initializes the memory as mappable by the
host. Otherwise, memory is private until shared by the guest with
the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst                 | 4 ++++
 include/uapi/linux/kvm.h                       | 1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 7 +++++--
 virt/kvm/guest_memfd.c                         | 6 +++++-
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f15b61317aad..2a8571b1629f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6383,6 +6383,10 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
+If the capability KVM_CAP_GUEST_MEMFD_MAPPABLE is supported, then the flags
+field supports GUEST_MEMFD_FLAG_INIT_MAPPABLE, which initializes the memory
+as mappable by the host.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 021f8ef9979b..b34aed04ffa5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_INIT_MAPPABLE		(1UL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..04b4111b7190 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -123,7 +123,7 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
 static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 {
 	size_t page_size = getpagesize();
-	uint64_t flag;
+	uint64_t flag = BIT(0);
 	size_t size;
 	int fd;
 
@@ -134,7 +134,10 @@ static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 			    size);
 	}
 
-	for (flag = BIT(0); flag; flag <<= 1) {
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MAPPABLE))
+		flag = GUEST_MEMFD_FLAG_INIT_MAPPABLE << 1;
+
+	for (; flag; flag <<= 1) {
 		fd = __vm_create_guest_memfd(vm, page_size, flag);
 		TEST_ASSERT(fd == -1 && errno == EINVAL,
 			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 159ffa17f562..932c23f6b2e5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -939,7 +939,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_gmem;
 	}
 
-	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE)) {
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
+	    (flags & GUEST_MEMFD_FLAG_INIT_MAPPABLE)) {
 		err = gmem_set_mappable(file_inode(file), 0, size >> PAGE_SHIFT);
 		if (err) {
 			fput(file);
@@ -968,6 +969,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE))
+		valid_flags |= GUEST_MEMFD_FLAG_INIT_MAPPABLE;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.48.0.rc2.279.g1de40edade-goog


