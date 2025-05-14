Return-Path: <kvm+bounces-46599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB415AB7A24
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34807188BDA6
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBB322DF85;
	Wed, 14 May 2025 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DV0gRTyo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FC922DA07
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266248; cv=none; b=gr/u3OhootrAxxLgFbSgnJe18pqxqJwvGu+zi1087pjQPNgUJQnrVLav53oaAtpzd2bXU2eEJ/5GU9TmF63K5lMqyc1KOu0GDb2vZ9GnMAOaUG5qbVp63+lQeCHbiaF3kCUZFGcr9a9rJokSdh55rYGvdFWIUN7r1vMja+wI6Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266248; c=relaxed/simple;
	bh=LDbOHPoSGuNFXS8JdzaelZFxT0RmINDPbHD9pwKJJaU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CXoyUrHq1q/k2Ng9Wnvopw/ehoK/Fy+wYNm5vY7AVImTWFmm2Fx82Wvn1cBobvRapoZvACiWA0iuY+Xkl+HeMdg8URr6M3g2XDyhriZzsenX49Dkfje/P+kuLPZVRlkp2e1IWUhcVwJLRT2X1n4ab5wONYTnX1t307zbEw3i2fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DV0gRTyo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ac9abbd4bso590588a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266246; x=1747871046; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7kvSCkXJQhrKVgucxSGtwwGYhLWVqw+CwFYL4UvJquE=;
        b=DV0gRTyoMlCf+hIaASLoGpat9PrzeZ1QCbiAZw970dEqBkFPkQAE0Os4NFQoba8HlV
         SArGOOQoFnM94aj+hfSJpffgF2gCg/IaUFg5vIXaufr7dU0QVhDXEMJfnz2wIfZ+UXGA
         IsBadfrKRNRq0D4tN+kBFVpUb5wEnM5HzNyzTAYDw6P2BLgqxjEIYXzkNoFkqw+dKEZ0
         WbZJzTq8DtFWTa5LsW9ZNXgS4S6cJsJMN6GLlnNONDsNY8RyrQ/oRKiFAewWcJ4gF0mb
         oq/1UnLdl3DMeAe0/5eO0xAL5J8TW+GZ8/haAx/ZxyF9hAFn6J3t8HvyX2SaY14eJ0XU
         clog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266246; x=1747871046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7kvSCkXJQhrKVgucxSGtwwGYhLWVqw+CwFYL4UvJquE=;
        b=ShA5kXpds0QrBc4HQ77k0N33luB/1QZ+sAakhQ3Qxc+FRWSoqsJsmuOYVUu+oQyOeU
         aJ9YCMp0h47VaGwGWx741sP70MrXk3eVCBwiX6vYPOOk4IraGuPm6Rv+/IMgBeFe9Ib7
         BVcJYxKAZIf8HslDORRrTeYDvB0pnoXzl7th4AmoCD1qO2Wc2QPBZJEir1fDxtChUKlC
         sAzf+WDrMx9feiP62Jhj1ZDbIH2r+Wmz3bpneXFsWybEh3MaiiGtyooYr9rDLvNaox4z
         wRYT/jM8RchSzYYxYMnaZsuKfWumGXX4tq5y9HKRCbX/CLKvbsnQ80bX9IDWa53yXjoR
         Do9A==
X-Gm-Message-State: AOJu0Yx5OFibnwovdYNA1/Ebxi3GLKv9BHAG0H91DS3YTXtNC6GJvYAk
	ZdJjrPhf2n9dK9SryfQPLs1jmEJ5ipHHJgPo3uIg+UN7uAE4mvJ+gRZnpXkURE5LVWuXkso2LSP
	ndGrtOsZMYoUjQ5dYhQm7V7jc9r0J2lA+gKUPtgMYsDbkCmD49ta3z1Q6ZPAT0ALcEjR6jv5g+2
	DaosPJQjc0uigTSMb4bsDtAhXLh8k3h0nkgz7lg1mEB5iEiLjp1r/eUL4=
X-Google-Smtp-Source: AGHT+IE20STsLMarzTx6jgJoU5OziT731+lq67F3PvF/P+tS/GIdT+Mf8wt3BdWWvNKEn5ln5kbUV5Kg3XvNRqtHxw==
X-Received: from pjbcz5.prod.google.com ([2002:a17:90a:d445:b0:2fa:a101:755])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d88c:b0:2f2:a664:df20 with SMTP id 98e67ed59e1d1-30e51570e69mr753738a91.7.1747266245969;
 Wed, 14 May 2025 16:44:05 -0700 (PDT)
Date: Wed, 14 May 2025 16:42:23 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <e06338f2c4aad92a6994a868483f9dcc17f84c5a.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 44/51] KVM: selftests: Test truncation paths of guest_memfd
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

When guest_memfd folios are truncated, if pages are split, they have
to be merged.

For truncations, userspace will get an error if there are unexpected
refcounts on the folios.

For truncation on closing, kernel will handle the merging even if
there are unexpected refcounts on the folios.

This patch tests the above two scenarios.

Change-Id: I0f0c619763f575605fab8b3c453858960e43ed71
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/guest_memfd_conversions_test.c        | 95 +++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 22126454fd6b..435f91424d5f 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -4,6 +4,7 @@
  *
  * Copyright (c) 2024, Google LLC.
  */
+#include <linux/guestmem.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
 #include <stdio.h>
@@ -580,6 +581,97 @@ static void test_fault_type_independent_of_mem_attributes(size_t test_page_size)
 	cleanup_test(test_page_size, vm, guest_memfd, mem);
 }
 
+static void test_truncate_shared_while_pinned(size_t test_page_size)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int guest_memfd;
+	char *mem;
+	int ret;
+
+	vm = setup_test(test_page_size, /*init_private=*/false, &vcpu,
+			&guest_memfd, &mem);
+
+	ret = fallocate(guest_memfd, FALLOC_FL_KEEP_SIZE, 0, test_page_size);
+	TEST_ASSERT(!ret, "fallocate should have succeeded");
+
+	pin_pages(mem, test_page_size);
+
+	ret = fallocate(guest_memfd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			0, test_page_size);
+	if (test_page_size == PAGE_SIZE) {
+		TEST_ASSERT(!ret, "truncate should have succeeded since there is no need to merge");
+	} else {
+		TEST_ASSERT(ret, "truncate should have failed since pages are pinned");
+		TEST_ASSERT_EQ(errno, EAGAIN);
+	}
+
+	unpin_pages();
+
+	ret = fallocate(guest_memfd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			0, test_page_size);
+	TEST_ASSERT(!ret, "truncate should succeed now that pages are unpinned");
+
+	cleanup_test(test_page_size, vm, guest_memfd, mem);
+}
+
+static void test_truncate_private(size_t test_page_size)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int guest_memfd;
+	char *mem;
+	int ret;
+
+	vm = setup_test(test_page_size, /*init_private=*/true, &vcpu,
+			&guest_memfd, &mem);
+
+	ret = fallocate(guest_memfd, FALLOC_FL_KEEP_SIZE, 0, test_page_size);
+	TEST_ASSERT(!ret, "fallocate should have succeeded");
+
+	ret = fallocate(guest_memfd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			0, test_page_size);
+	TEST_ASSERT(!ret, "truncate should have succeeded since there is no need to merge");
+
+	cleanup_test(test_page_size, vm, guest_memfd, mem);
+}
+
+static void __test_close_with_pinning(size_t test_page_size, bool init_private)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int guest_memfd;
+	char *mem;
+	int ret;
+
+	vm = setup_test(test_page_size, init_private, &vcpu, &guest_memfd, &mem);
+
+	ret = fallocate(guest_memfd, FALLOC_FL_KEEP_SIZE, 0, test_page_size);
+	TEST_ASSERT(!ret, "fallocate should have succeeded");
+
+	if (!init_private)
+		pin_pages(mem, test_page_size);
+
+	cleanup_test(test_page_size, vm, guest_memfd, mem);
+
+	if (!init_private)
+		unpin_pages();
+
+	/*
+	 * Test this with ./guest_memfd_wrap_test_check_hugetlb_reporting.sh to
+	 * check that the HugeTLB page got merged and returned to HugeTLB.
+	 *
+	 * Sleep here to give kernel worker time to do the merge and return.
+	 */
+	sleep(1);
+}
+
+static void test_close_with_pinning(size_t test_page_size)
+{
+	__test_close_with_pinning(test_page_size, true);
+	__test_close_with_pinning(test_page_size, false);
+}
+
 static void test_with_size(size_t test_page_size)
 {
 	test_sharing(test_page_size);
@@ -590,6 +682,9 @@ static void test_with_size(size_t test_page_size)
 	test_truncate_should_not_change_mappability(test_page_size);
 	test_conversions_should_fail_if_memory_has_elevated_refcount(test_page_size);
 	test_fault_type_independent_of_mem_attributes(test_page_size);
+	test_truncate_shared_while_pinned(test_page_size);
+	test_truncate_private(test_page_size);
+	test_close_with_pinning(test_page_size);
 }
 
 int main(int argc, char *argv[])
-- 
2.49.0.1045.g170613ef41-goog


