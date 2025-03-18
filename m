Return-Path: <kvm+bounces-41414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF8AA6793D
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 544B519C7DE9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B3C211491;
	Tue, 18 Mar 2025 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ScgpIAv8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45666212F89
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314868; cv=none; b=mc0hck7y/Xj/VuQRKc2stsu+tc2JhYlhVLN0qzoJxSiggFs4rZqE6HC2JCMx1uRWNUgcLNNIBX/h5yGxPER6v1y/nYeoVn/+3lCtrN025Qt8nip8xQumDPLiv1J2nnUk9dl8ZDJuDe7hk8kYqnMOK146M+LTHzp17P7Bqp1Q8pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314868; c=relaxed/simple;
	bh=PCszwYmlt7Nl7NqWG5DO7Cuq8LIT0s0e6rIMF1sSTTE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g/RXmZ9sP5wEZwZV7vsy0bLlbBl7kXuhQ5I05uiDTHT4kPotwv5vyNcbw9af935bhVoQbVtndzyBp2yvWsoFfCPDc8xKm7I1STWAakA7jkRbQsxkQ887MfmHBjTqC5Lraz8vSgofRR5R0yxcwEmhF63UNY/tL+iU5OzoTj4ZqRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ScgpIAv8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf44b66f7so25660265e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314862; x=1742919662; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rd6be5I6g0Af011AYVWod/OD1lPj9HqVBk4Grxnf+mY=;
        b=ScgpIAv8Oqew8fq/v23VIyePgocwc55aI+Ptreyeh69xAFx6SXahaV7WhQBvQt/Zon
         Hyz9XzwdSlu0Am0KdbJT2JAwxxhOU7eOr8Idm/dNV9LIQsZ17il3QIkcsS1m5gspAcvY
         bF4ittSUrFlizYthPSK8nGfiCELWW6JWNfEooNTGTUYmdqLs8qQs0pvuSGWXAinlSVUV
         +0v8BdQllH/aEhDds+HyeBNeyjNI7ZnT0nH3JPV1vNHIy34d1kuXrDLChlsARIAsGJs5
         KqiqX+qHEBB4i438jd57j7d4vOtgRG7xshLZpTcfVASnHVfCK27PET1D9CcnIeZii3o8
         17VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314862; x=1742919662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rd6be5I6g0Af011AYVWod/OD1lPj9HqVBk4Grxnf+mY=;
        b=RPUceIQtzTCs04OK9BEdEsJYOqHsGjauk/TsyjRhkZ1eqofg9p38ro6BH2xT0IFwZ4
         idd6xZyTu7G5tbX0Cz/7KxqQn2Pz2L5gf3sHpbxlvlqH/P3t660Gm5aK029jiXlYzTiE
         40Xg3ymOLxF8sC7KXzUpBWzaGDOesAp1jFjH0aBdvB8E1MfQVMmcZyyefM8cfUQzl0/3
         Btzgx2UxilHU2V+GH1QxaN8Q82Ln5ArcmFk/Y/pqFpK204O7GO0LzN+FbsKuWv6UcrMK
         aKGpvhF3hZYEVqrSygnfCpQnH+npsiNaxhBRh6FR3yVznHJhXmiRCS7SW1jojMAZJpLQ
         bV+A==
X-Gm-Message-State: AOJu0YzvJQDw1Wcbj3oHkO0X1WdTsQbQAV16y0RxjGDp6vdqi57md2lC
	DIYY++KUTpoT17PbbjC9piY/j4MoHOF2aS3tV6AvYAJ9jUbUrZ4Jq9/rDShjIW0DdtsCBLWwcK/
	D+D7GRegdjRUWS4jRdSCyETzqC13fdMU5y935SVW/EdulP46Vc+/FOh6QC1lC2VZpKIkOslY2xU
	g8qgAqVBUsVE25Dw56cOUc3ic=
X-Google-Smtp-Source: AGHT+IFTQwZzOpfOU0EGgsy+KvdlZSjBRDdavIz7oAkVvTl07k3n0vOwWg2N3mGBwzwh7UY/m+wnPF3ykA==
X-Received: from wmby26.prod.google.com ([2002:a05:600c:c05a:b0:43d:c77:3fd8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19d2:b0:43d:5ec:b2f4
 with SMTP id 5b1f17b1804b1-43d3b98d127mr28080345e9.10.1742314861661; Tue, 18
 Mar 2025 09:21:01 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:20:46 +0000
In-Reply-To: <20250318162046.4016367-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318162046.4016367-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162046.4016367-8-tabba@google.com>
Subject: [PATCH v6 7/7] KVM: guest_memfd: Add a guest_memfd() flag to
 initialize it as shared
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Not all use cases require guest_memfd() to be shared with the host when
first created. Add a new flag, GUEST_MEMFD_FLAG_INIT_SHARED, which when
set on KVM_CREATE_GUEST_MEMFD initializes the memory as shared with the
host, and therefore mappable by it. Otherwise, memory is private until
explicitly shared by the guest with the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst                 |  4 ++++
 include/uapi/linux/kvm.h                       |  1 +
 tools/testing/selftests/kvm/guest_memfd_test.c |  7 +++++--
 virt/kvm/guest_memfd.c                         | 12 ++++++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b52eb77e29c..a5496d7d323b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6386,6 +6386,10 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
+If the capability KVM_CAP_GMEM_SHARED_MEM is supported, then the flags field
+supports GUEST_MEMFD_FLAG_INIT_SHARED, which initializes the memory as shared
+with the host, and thereby, mappable by it.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 117937a895da..22d7e33bf09c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_INIT_SHARED		(1UL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 38c501e49e0e..4a7fcd6aa372 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -159,7 +159,7 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
 static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 {
 	size_t page_size = getpagesize();
-	uint64_t flag;
+	uint64_t flag = BIT(0);
 	size_t size;
 	int fd;
 
@@ -170,7 +170,10 @@ static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 			    size);
 	}
 
-	for (flag = BIT(0); flag; flag <<= 1) {
+	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
+		flag = GUEST_MEMFD_FLAG_INIT_SHARED << 1;
+
+	for (; flag; flag <<= 1) {
 		fd = __vm_create_guest_memfd(vm, page_size, flag);
 		TEST_ASSERT(fd == -1 && errno == EINVAL,
 			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0487a08615f0..d7313e11c2cb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1045,6 +1045,15 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_gmem;
 	}
 
+	if (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&
+	    (flags & GUEST_MEMFD_FLAG_INIT_SHARED)) {
+		err = kvm_gmem_offset_range_set_shared(file_inode(file), 0, size >> PAGE_SHIFT);
+		if (err) {
+			fput(file);
+			goto err_gmem;
+		}
+	}
+
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
@@ -1066,6 +1075,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
+		valid_flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


