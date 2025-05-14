Return-Path: <kvm+bounces-46598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99260AB7A20
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 251431BA5EBC
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8236E268FED;
	Wed, 14 May 2025 23:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0W3/fhgV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E78A2673BB
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266247; cv=none; b=UfLFAFBq58xi7jDDX/omktdXiPg0xSvdsvxfRos2m+Jo3JNcokXY7UnFxPggn8dHko0u76I5k2vs4t4qBr+XmRY50Ft5Nw5tmZwYLpiB/KqbwBq8Qv853hqLzDCszgvB2VW04kyRyg3D4dvHvzHRCEJSfaNi+o87xho/yeu+v/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266247; c=relaxed/simple;
	bh=ImmIEjgg6VN8oNGIpqxRIgN7oquIvMOxprY/MGcEcGE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UwfSSx/idjW5oYA6QLKROVHulJ/kyUh2/0rGjcQ5gE/Nywd+ARb5s67wH9MC+9yvNbDWxY2BZK1HbdxQ8Eu72V49NgCjHYZZkwvgqKTn7am7L2IakIyAwhKCTLSIc171g5Uw16tpECiH3N5mUMyEhfdgtM1NZvj1tRVUxInPniE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0W3/fhgV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ad9303655so660456a91.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266245; x=1747871045; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SBKCNvKK5vlZpa9NXE6RG3mzzUtnLi6xsQAbwU+j9NQ=;
        b=0W3/fhgVZ11Cn4xKO5UKmaPuSvVsFeGMUWxWpo+lsw078JMc59Z5og1ROChyi5Y8mR
         mh4sNPY1ompG+R2+oYBZ+TUETVFrS3PA8DHR7CcCNFSgyn7l04BKAOMdRHn7TEwuVqdD
         1fQep59JFbCNDnMz/22g8kSY/MMkaeuN3ZMnYiiqiGw9JL/SnEUHL2DyKTD0GQcAgVbJ
         Wu0cv91wDzr6/EaoTW7Pcw2r1c2oReiUuhN56rlrw9MrV67tnT+nlVzDgiN/2BAjySiK
         clhYVbv1rXT6bOxYAq6XJ3z3Du1y0pOVJ7nIQcsSG9q2ffXmIparZgpzFBVIihalirQz
         VxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266245; x=1747871045;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBKCNvKK5vlZpa9NXE6RG3mzzUtnLi6xsQAbwU+j9NQ=;
        b=XbsQq3/2CjpgTq9uE/HtkPRnSfMAg7jFhSpOF/glVRgwCVKXdNcnfFNAmME725PTxR
         eb+jzZ1gga2h9yr7uyzChWz3BjTMmf/CjKd5X7jWWnPRABaVEG4/TdLs7pnmou1oYzp/
         aXXjxv84nc9FvBfF7tT2vdg/ZwfK1AvBt5ju0VUcZB8M1Qs8FC4J7+xfLXQfm8U+NmZR
         cYiyAGLB3nqPd4HC8uNJs7hhoxLcwwi116/IPVUiPwwb3S+BN1VnbEZNKYYO+RyoxmYA
         LzOsG+BYLf0nkN5iWft9E+CFayufU2be3nSOqXPov+y8vfqOTu7iXtLihIvFOxYakE3q
         kFsw==
X-Gm-Message-State: AOJu0YyfhtxkkukgLyd9lDhRZG/2LQvgZNKy/hLyeJjaJlbGBYTvJZad
	vAcLRTabAc5tLXdy66LnAiYjOHmCVSqusRxufdS8gTblZp6LSS6nd/t0Rg9vFRWELdFL1GlVph7
	UYkW6jxOILrWWxH/6yUrFT4ns/b8yo6v9Opgnt/cMTYouXeJBLt4ybunvY/xr7/Dr5CrNjC0VHD
	fguAF8dW3xSxZ58peuy6Oy6/bBpMaY1ufLDtcEtYlbk+P+yEctZLli1OI=
X-Google-Smtp-Source: AGHT+IFlY73C7NnEaCyZjX9EVeyEjmbdYFDraUMzvzxmT+X894pXxbvAFLXXKcOPJa5mxHY7SeCxnzAUoVQK/RAQbA==
X-Received: from pjbqx6.prod.google.com ([2002:a17:90b:3e46:b0:30a:7c16:a1aa])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2585:b0:2f4:4003:f3ea with SMTP id 98e67ed59e1d1-30e5195f760mr820504a91.33.1747266244464;
 Wed, 14 May 2025 16:44:04 -0700 (PDT)
Date: Wed, 14 May 2025 16:42:22 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <e232d7e84ebb1bffa323ec554474d0cf759e8bae.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 43/51] KVM: selftests: Update conversion flows test for HugeTLB
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: ackerleytng@google.com, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

This patch updates conversion flows test to use
GUEST_MEMFD_FLAG_HUGETLB and tests with the 2MB and 1GB sizes.

Change-Id: If5d93cb776d6bebd504a80bba553bd534e62be38
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/guest_memfd_conversions_test.c        | 171 ++++++++++--------
 1 file changed, 98 insertions(+), 73 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 34eb6c9a37b1..22126454fd6b 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2024, Google LLC.
  */
 #include <linux/kvm.h>
+#include <linux/sizes.h>
 #include <stdio.h>
 #include <string.h>
 #include <sys/mman.h>
@@ -228,6 +229,11 @@ static struct kvm_vm *setup_test(size_t test_page_size, bool init_private,
 	if (init_private)
 		flags |= GUEST_MEMFD_FLAG_INIT_PRIVATE;
 
+	if (test_page_size == SZ_2M)
+		flags |= GUEST_MEMFD_FLAG_HUGETLB | GUESTMEM_HUGETLB_FLAG_2MB;
+	else if (test_page_size == SZ_1G)
+		flags |= GUEST_MEMFD_FLAG_HUGETLB | GUESTMEM_HUGETLB_FLAG_1GB;
+
 	*guest_memfd = vm_create_guest_memfd(vm, test_page_size, flags);
 	TEST_ASSERT(*guest_memfd > 0, "guest_memfd creation failed");
 
@@ -249,79 +255,80 @@ static void cleanup_test(size_t guest_memfd_size, struct kvm_vm *vm,
 		TEST_ASSERT_EQ(close(guest_memfd), 0);
 }
 
-static void test_sharing(void)
+static void test_sharing(size_t test_page_size)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int guest_memfd;
 	char *mem;
 
-	vm = setup_test(PAGE_SIZE, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
+	vm = setup_test(test_page_size, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
 
 	host_use_memory(mem, 'X', 'A');
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'A', 'B', 0);
 
 	/* Toggle private flag of memory attributes and run the test again. */
-	guest_memfd_convert_private(guest_memfd, 0, PAGE_SIZE);
+	guest_memfd_convert_private(guest_memfd, 0, test_page_size);
 
 	assert_host_cannot_fault(mem);
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'B', 'C', 0);
 
-	guest_memfd_convert_shared(guest_memfd, 0, PAGE_SIZE);
+	guest_memfd_convert_shared(guest_memfd, 0, test_page_size);
 
 	host_use_memory(mem, 'C', 'D');
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'D', 'E', 0);
 
-	cleanup_test(PAGE_SIZE, vm, guest_memfd, mem);
+	cleanup_test(test_page_size, vm, guest_memfd, mem);
 }
 
-static void test_init_mappable_false(void)
+static void test_init_mappable_false(size_t test_page_size)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int guest_memfd;
 	char *mem;
 
-	vm = setup_test(PAGE_SIZE, /*init_private=*/true, &vcpu, &guest_memfd, &mem);
+	vm = setup_test(test_page_size, /*init_private=*/true, &vcpu, &guest_memfd, &mem);
 
 	assert_host_cannot_fault(mem);
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'X', 'A', 0);
 
-	guest_memfd_convert_shared(guest_memfd, 0, PAGE_SIZE);
+	guest_memfd_convert_shared(guest_memfd, 0, test_page_size);
 
 	host_use_memory(mem, 'A', 'B');
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'B', 'C', 0);
 
-	cleanup_test(PAGE_SIZE, vm, guest_memfd, mem);
+	cleanup_test(test_page_size, vm, guest_memfd, mem);
 }
 
 /*
  * Test that even if there are no folios yet, conversion requests are recorded
  * in guest_memfd.
  */
-static void test_conversion_before_allocation(void)
+static void test_conversion_before_allocation(size_t test_page_size)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int guest_memfd;
 	char *mem;
 
-	vm = setup_test(PAGE_SIZE, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
+	vm = setup_test(test_page_size, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
 
-	guest_memfd_convert_private(guest_memfd, 0, PAGE_SIZE);
+	guest_memfd_convert_private(guest_memfd, 0, test_page_size);
 
 	assert_host_cannot_fault(mem);
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'X', 'A', 0);
 
-	guest_memfd_convert_shared(guest_memfd, 0, PAGE_SIZE);
+	guest_memfd_convert_shared(guest_memfd, 0, test_page_size);
 
 	host_use_memory(mem, 'A', 'B');
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'B', 'C', 0);
 
-	cleanup_test(PAGE_SIZE, vm, guest_memfd, mem);
+	cleanup_test(test_page_size, vm, guest_memfd, mem);
 }
 
-static void __test_conversion_if_not_all_folios_allocated(int total_nr_pages,
+static void __test_conversion_if_not_all_folios_allocated(size_t test_page_size,
+							  int total_nr_pages,
 							  int page_to_fault)
 {
 	const int second_page_to_fault = 8;
@@ -332,15 +339,15 @@ static void __test_conversion_if_not_all_folios_allocated(int total_nr_pages,
 	char *mem;
 	int i;
 
-	total_size = PAGE_SIZE * total_nr_pages;
+	total_size = test_page_size * total_nr_pages;
 	vm = setup_test(total_size, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
 
 	/*
 	 * Fault 2 of the pages to test filemap range operations except when
 	 * page_to_fault == second_page_to_fault.
 	 */
-	host_use_memory(mem + page_to_fault * PAGE_SIZE, 'X', 'A');
-	host_use_memory(mem + second_page_to_fault * PAGE_SIZE, 'X', 'A');
+	host_use_memory(mem + page_to_fault * test_page_size, 'X', 'A');
+	host_use_memory(mem + second_page_to_fault * test_page_size, 'X', 'A');
 
 	guest_memfd_convert_private(guest_memfd, 0, total_size);
 
@@ -348,37 +355,37 @@ static void __test_conversion_if_not_all_folios_allocated(int total_nr_pages,
 		bool is_faulted;
 		char expected;
 
-		assert_host_cannot_fault(mem + i * PAGE_SIZE);
+		assert_host_cannot_fault(mem + i * test_page_size);
 
 		is_faulted = i == page_to_fault || i == second_page_to_fault;
 		expected = is_faulted ? 'A' : 'X';
 		guest_use_memory(vcpu,
-				 GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
+				 GUEST_MEMFD_SHARING_TEST_GVA + i * test_page_size,
 				 expected, 'B', 0);
 	}
 
 	guest_memfd_convert_shared(guest_memfd, 0, total_size);
 
 	for (i = 0; i < total_nr_pages; ++i) {
-		host_use_memory(mem + i * PAGE_SIZE, 'B', 'C');
+		host_use_memory(mem + i * test_page_size, 'B', 'C');
 		guest_use_memory(vcpu,
-				 GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
+				 GUEST_MEMFD_SHARING_TEST_GVA + i * test_page_size,
 				 'C', 'D', 0);
 	}
 
 	cleanup_test(total_size, vm, guest_memfd, mem);
 }
 
-static void test_conversion_if_not_all_folios_allocated(void)
+static void test_conversion_if_not_all_folios_allocated(size_t test_page_size)
 {
 	const int total_nr_pages = 16;
 	int i;
 
 	for (i = 0; i < total_nr_pages; ++i)
-		__test_conversion_if_not_all_folios_allocated(total_nr_pages, i);
+		__test_conversion_if_not_all_folios_allocated(test_page_size, total_nr_pages, i);
 }
 
-static void test_conversions_should_not_affect_surrounding_pages(void)
+static void test_conversions_should_not_affect_surrounding_pages(size_t test_page_size)
 {
 	struct kvm_vcpu *vcpu;
 	int page_to_convert;
@@ -391,40 +398,40 @@ static void test_conversions_should_not_affect_surrounding_pages(void)
 
 	page_to_convert = 2;
 	nr_pages = 4;
-	total_size = PAGE_SIZE * nr_pages;
+	total_size = test_page_size * nr_pages;
 
 	vm = setup_test(total_size, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
 
 	for (i = 0; i < nr_pages; ++i) {
-		host_use_memory(mem + i * PAGE_SIZE, 'X', 'A');
-		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
+		host_use_memory(mem + i * test_page_size, 'X', 'A');
+		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * test_page_size,
 				 'A', 'B', 0);
 	}
 
-	guest_memfd_convert_private(guest_memfd, PAGE_SIZE * page_to_convert, PAGE_SIZE);
+	guest_memfd_convert_private(guest_memfd, test_page_size * page_to_convert, test_page_size);
 
 
 	for (i = 0; i < nr_pages; ++i) {
 		char to_check;
 
 		if (i == page_to_convert) {
-			assert_host_cannot_fault(mem + i * PAGE_SIZE);
+			assert_host_cannot_fault(mem + i * test_page_size);
 			to_check = 'B';
 		} else {
-			host_use_memory(mem + i * PAGE_SIZE, 'B', 'C');
+			host_use_memory(mem + i * test_page_size, 'B', 'C');
 			to_check = 'C';
 		}
 
-		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
+		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * test_page_size,
 				 to_check, 'D', 0);
 	}
 
-	guest_memfd_convert_shared(guest_memfd, PAGE_SIZE * page_to_convert, PAGE_SIZE);
+	guest_memfd_convert_shared(guest_memfd, test_page_size * page_to_convert, test_page_size);
 
 
 	for (i = 0; i < nr_pages; ++i) {
-		host_use_memory(mem + i * PAGE_SIZE, 'D', 'E');
-		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
+		host_use_memory(mem + i * test_page_size, 'D', 'E');
+		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * test_page_size,
 				 'E', 'F', 0);
 	}
 
@@ -432,7 +439,7 @@ static void test_conversions_should_not_affect_surrounding_pages(void)
 }
 
 static void __test_conversions_should_fail_if_memory_has_elevated_refcount(
-	int nr_pages, int page_to_convert)
+	size_t test_page_size, int nr_pages, int page_to_convert)
 {
 	struct kvm_vcpu *vcpu;
 	loff_t error_offset;
@@ -443,50 +450,50 @@ static void __test_conversions_should_fail_if_memory_has_elevated_refcount(
 	int ret;
 	int i;
 
-	total_size = PAGE_SIZE * nr_pages;
+	total_size = test_page_size * nr_pages;
 	vm = setup_test(total_size, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
 
-	pin_pages(mem + page_to_convert * PAGE_SIZE, PAGE_SIZE);
+	pin_pages(mem + page_to_convert * test_page_size, test_page_size);
 
 	for (i = 0; i < nr_pages; i++) {
-		host_use_memory(mem + i * PAGE_SIZE, 'X', 'A');
-		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
+		host_use_memory(mem + i * test_page_size, 'X', 'A');
+		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * test_page_size,
 				 'A', 'B', 0);
 	}
 
 	error_offset = 0;
-	ret = __guest_memfd_convert_private(guest_memfd, page_to_convert * PAGE_SIZE,
-					    PAGE_SIZE, &error_offset);
+	ret = __guest_memfd_convert_private(guest_memfd, page_to_convert * test_page_size,
+					    test_page_size, &error_offset);
 	TEST_ASSERT_EQ(ret, -1);
 	TEST_ASSERT_EQ(errno, EAGAIN);
-	TEST_ASSERT_EQ(error_offset, page_to_convert * PAGE_SIZE);
+	TEST_ASSERT_EQ(error_offset, page_to_convert * test_page_size);
 
 	unpin_pages();
 
-	guest_memfd_convert_private(guest_memfd, page_to_convert * PAGE_SIZE, PAGE_SIZE);
+	guest_memfd_convert_private(guest_memfd, page_to_convert * test_page_size, test_page_size);
 
 	for (i = 0; i < nr_pages; i++) {
 		char expected;
 
 		if (i == page_to_convert)
-			assert_host_cannot_fault(mem + i * PAGE_SIZE);
+			assert_host_cannot_fault(mem + i * test_page_size);
 		else
-			host_use_memory(mem + i * PAGE_SIZE, 'B', 'C');
+			host_use_memory(mem + i * test_page_size, 'B', 'C');
 
 		expected = i == page_to_convert ? 'X' : 'C';
-		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
+		guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA + i * test_page_size,
 				 expected, 'D', 0);
 	}
 
-	guest_memfd_convert_shared(guest_memfd, page_to_convert * PAGE_SIZE, PAGE_SIZE);
+	guest_memfd_convert_shared(guest_memfd, page_to_convert * test_page_size, test_page_size);
 
 
 	for (i = 0; i < nr_pages; i++) {
 		char expected = i == page_to_convert ? 'X' : 'D';
 
-		host_use_memory(mem + i * PAGE_SIZE, expected, 'E');
+		host_use_memory(mem + i * test_page_size, expected, 'E');
 		guest_use_memory(vcpu,
-				 GUEST_MEMFD_SHARING_TEST_GVA + i * PAGE_SIZE,
+				 GUEST_MEMFD_SHARING_TEST_GVA + i * test_page_size,
 				 'E', 'F', 0);
 	}
 
@@ -496,15 +503,18 @@ static void __test_conversions_should_fail_if_memory_has_elevated_refcount(
  * This test depends on CONFIG_GUP_TEST to provide a kernel module that exposes
  * pin_user_pages() to userspace.
  */
-static void test_conversions_should_fail_if_memory_has_elevated_refcount(void)
+static void test_conversions_should_fail_if_memory_has_elevated_refcount(
+		size_t test_page_size)
 {
 	int i;
 
-	for (i = 0; i < 4; i++)
-		__test_conversions_should_fail_if_memory_has_elevated_refcount(4, i);
+	for (i = 0; i < 4; i++) {
+		__test_conversions_should_fail_if_memory_has_elevated_refcount(
+			test_page_size, 4, i);
+	}
 }
 
-static void test_truncate_should_not_change_mappability(void)
+static void test_truncate_should_not_change_mappability(size_t test_page_size)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -512,40 +522,40 @@ static void test_truncate_should_not_change_mappability(void)
 	char *mem;
 	int ret;
 
-	vm = setup_test(PAGE_SIZE, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
+	vm = setup_test(test_page_size, /*init_private=*/false, &vcpu, &guest_memfd, &mem);
 
 	host_use_memory(mem, 'X', 'A');
 
 	ret = fallocate(guest_memfd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
-			0, PAGE_SIZE);
+			0, test_page_size);
 	TEST_ASSERT(!ret, "truncating the first page should succeed");
 
 	host_use_memory(mem, 'X', 'A');
 
-	guest_memfd_convert_private(guest_memfd, 0, PAGE_SIZE);
+	guest_memfd_convert_private(guest_memfd, 0, test_page_size);
 
 	assert_host_cannot_fault(mem);
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'A', 'A', 0);
 
 	ret = fallocate(guest_memfd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
-			0, PAGE_SIZE);
+			0, test_page_size);
 	TEST_ASSERT(!ret, "truncating the first page should succeed");
 
 	assert_host_cannot_fault(mem);
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'X', 'A', 0);
 
-	cleanup_test(PAGE_SIZE, vm, guest_memfd, mem);
+	cleanup_test(test_page_size, vm, guest_memfd, mem);
 }
 
-static void test_fault_type_independent_of_mem_attributes(void)
+static void test_fault_type_independent_of_mem_attributes(size_t test_page_size)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int guest_memfd;
 	char *mem;
 
-	vm = setup_test(PAGE_SIZE, /*init_private=*/true, &vcpu, &guest_memfd, &mem);
-	vm_mem_set_shared(vm, GUEST_MEMFD_SHARING_TEST_GPA, PAGE_SIZE);
+	vm = setup_test(test_page_size, /*init_private=*/true, &vcpu, &guest_memfd, &mem);
+	vm_mem_set_shared(vm, GUEST_MEMFD_SHARING_TEST_GPA, test_page_size);
 
 	/*
 	 * kvm->mem_attr_array set to shared, guest_memfd memory initialized as
@@ -558,8 +568,8 @@ static void test_fault_type_independent_of_mem_attributes(void)
 	/* Guest can fault and use memory. */
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'X', 'A', 0);
 
-	guest_memfd_convert_shared(guest_memfd, 0, PAGE_SIZE);
-	vm_mem_set_private(vm, GUEST_MEMFD_SHARING_TEST_GPA, PAGE_SIZE);
+	guest_memfd_convert_shared(guest_memfd, 0, test_page_size);
+	vm_mem_set_private(vm, GUEST_MEMFD_SHARING_TEST_GPA, test_page_size);
 
 	/* Host can use shared memory. */
 	host_use_memory(mem, 'X', 'A');
@@ -567,7 +577,19 @@ static void test_fault_type_independent_of_mem_attributes(void)
 	/* Guest can also use shared memory. */
 	guest_use_memory(vcpu, GUEST_MEMFD_SHARING_TEST_GVA, 'X', 'A', 0);
 
-	cleanup_test(PAGE_SIZE, vm, guest_memfd, mem);
+	cleanup_test(test_page_size, vm, guest_memfd, mem);
+}
+
+static void test_with_size(size_t test_page_size)
+{
+	test_sharing(test_page_size);
+	test_init_mappable_false(test_page_size);
+	test_conversion_before_allocation(test_page_size);
+	test_conversion_if_not_all_folios_allocated(test_page_size);
+	test_conversions_should_not_affect_surrounding_pages(test_page_size);
+	test_truncate_should_not_change_mappability(test_page_size);
+	test_conversions_should_fail_if_memory_has_elevated_refcount(test_page_size);
+	test_fault_type_independent_of_mem_attributes(test_page_size);
 }
 
 int main(int argc, char *argv[])
@@ -576,14 +598,17 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_GMEM_SHARED_MEM));
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_GMEM_CONVERSION));
 
-	test_sharing();
-	test_init_mappable_false();
-	test_conversion_before_allocation();
-	test_conversion_if_not_all_folios_allocated();
-	test_conversions_should_not_affect_surrounding_pages();
-	test_truncate_should_not_change_mappability();
-	test_conversions_should_fail_if_memory_has_elevated_refcount();
-	test_fault_type_independent_of_mem_attributes();
+	printf("Test guest_memfd with 4K pages\n");
+	test_with_size(PAGE_SIZE);
+	printf("\tPASSED\n");
+
+	printf("Test guest_memfd with 2M pages\n");
+	test_with_size(SZ_2M);
+	printf("\tPASSED\n");
+
+	printf("Test guest_memfd with 1G pages\n");
+	test_with_size(SZ_1G);
+	printf("\tPASSED\n");
 
 	return 0;
 }
-- 
2.49.0.1045.g170613ef41-goog


