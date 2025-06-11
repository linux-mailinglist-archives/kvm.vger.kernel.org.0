Return-Path: <kvm+bounces-49064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6B8AD5749
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD3441BC17D3
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2D72BE7D7;
	Wed, 11 Jun 2025 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QvFVlrfG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657D72BE7BA
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648851; cv=none; b=qHrD6XZeaWgDa+lTw9gqTAZv3bxabdL1JwK6qyb16v3sLegf45nXkQPlLJg69Ws2AYHk33Qi9PlpEDDc0iQCiKJxC1t/7GqgPJqbtotcufWu4IRT9Y3FavC48YEh3D5vFH+Dp3GZr1KUp8Yhb+kkqqz24DYTtRZXr19JL/HX1C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648851; c=relaxed/simple;
	bh=m1FXF0Pr/WuTL57w9QC810/IuAAA62qhWISWmGtCWp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WmVx+92+27i7xjYummD7muR0GK/bhNjO9M7OsNcereVVfSYYGCrxP43qkGSV0bAkE5Qc3W4S0a1mH1KIZAfEhWitDQwVgS9HiCnB5LPxa7VsMpPaJHSGxWfLNlwDPAZrP3rQskVu+Y7h6Wzr9aiqOy2fTqvzRtDvKEIQfhCxbrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QvFVlrfG; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so38833595e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648848; x=1750253648; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HhMMHPCLGACkcKVf5+6mUDlWv9E5h4gdh0oW2i6XcGE=;
        b=QvFVlrfGNrSV7yZkVMlr80eFtRReZRAnnf9yy3t/LJSlSAbQrMbzQLdzfpWOTotdbl
         3+UlE/d2JyZHJzKN+YkoA5kjChJN8AoLCvHy45UruDdqlyzC3n31xL3P94Rb6d6eFMMQ
         o6Uldb8fMNlizERqmaym5zOY0xeswHdnvSwIp0sOVh/OwssiUVPwQs0LPF3NLOS8rZq2
         6RRIVQ6AzkZIdJh7Lid6LTXuD72h6etO9vujWs3pEo0HmJ2Htn6jW/+Sn4jz9XBKiHbN
         zdb0BT0aJtGHSJwTzY8MX1jy+zmJ7orJ//nqVLyvhdEKplyaGkFKNLK1uKXkfs4cYhqM
         t8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648848; x=1750253648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhMMHPCLGACkcKVf5+6mUDlWv9E5h4gdh0oW2i6XcGE=;
        b=eAHbzt04CxtlZUhV2NWBsyTd7k7PZ0iqmHxkiYSedcYT7AtwR868CHDkEktLQAH/ij
         U7YQYhIDGulJQTTXYPt94DOQzYK52j8QsFP8iNsL0k/rcsRAIRhz8BWrMC/cgt+ZnkYP
         GBsLxZBBcQX3fJz/teml5xjmWElvqFyWNbwsrDNQJKvFnjyUQdxdhBYruoXmwmD33pQb
         Q4SpIF/Zi/BKmznSkMffa8KHS+Acb0t2aZTy6k4kacCiPFREqx9HQ6GVhTSGh0oOvVN0
         s/3PW5GOecWMGcNX71oYNdh7c8MrWjAKBfiWLGUWH9VRA0QDWGz4QcTfrA7mXeAiXwC6
         HX1A==
X-Gm-Message-State: AOJu0YxJWRmT+7DOXfZfsmh9vYn1i49xxlp6MyByClIfnXXEGmRXInwW
	dDWDYwM/vbyI6TFu8XfWiH/HTm4kKIEt4ARCaH1YXIJ4FBOv3KDwVTRrFZIPrFEL1uwY4WchdIZ
	1GlaOJlfhS/moFEwwfedF79LMybvE88rdG0hO65ig/KsqEAx3xzU391Y0tvvNND5q8LisGkjUlQ
	L6wLaK2eZlrLOrZpmprSmlMRasMoA=
X-Google-Smtp-Source: AGHT+IFl2rGDbEyyq3Z/x9draA1KG6JcfdmJL5N0xgRsAf7iQvJmF31fca8I9HdR2qtrE21yQqMSi290GA==
X-Received: from wmth23.prod.google.com ([2002:a05:600c:8b77:b0:451:d768:b11d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d92:b0:450:cd50:3c66
 with SMTP id 5b1f17b1804b1-45324f4017dmr26302775e9.29.1749648847434; Wed, 11
 Jun 2025 06:34:07 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:29 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-18-tabba@google.com>
Subject: [PATCH v12 17/18] KVM: selftests: Don't use hardcoded page sizes in
 guest_memfd test
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Using hardcoded page size values could cause the test to fail on systems
that have larger pages, e.g., arm64 with 64kB pages. Use getpagesize()
instead.

Also, build the guest_memfd selftest for arm64.

Reviewed-by: David Hildenbrand <david@redhat.com>
Suggested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm       |  1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 38b95998e1e6..e11ed9e59ab5 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -172,6 +172,7 @@ TEST_GEN_PROGS_arm64 += arch_timer
 TEST_GEN_PROGS_arm64 += coalesced_io_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
 TEST_GEN_PROGS_arm64 += get-reg-list
+TEST_GEN_PROGS_arm64 += guest_memfd_test
 TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
 TEST_GEN_PROGS_arm64 += memslot_perf_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..341ba616cf55 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -146,24 +146,25 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 {
 	int fd1, fd2, ret;
 	struct stat st1, st2;
+	size_t page_size = getpagesize();
 
-	fd1 = __vm_create_guest_memfd(vm, 4096, 0);
+	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
 	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
 
 	ret = fstat(fd1, &st1);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st1.st_size == 4096, "memfd st_size should match requested size");
+	TEST_ASSERT(st1.st_size == page_size, "memfd st_size should match requested size");
 
-	fd2 = __vm_create_guest_memfd(vm, 8192, 0);
+	fd2 = __vm_create_guest_memfd(vm, page_size * 2, 0);
 	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
 
 	ret = fstat(fd2, &st2);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st2.st_size == 8192, "second memfd st_size should match requested size");
+	TEST_ASSERT(st2.st_size == page_size * 2, "second memfd st_size should match requested size");
 
 	ret = fstat(fd1, &st1);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st1.st_size == 4096, "first memfd st_size should still match requested size");
+	TEST_ASSERT(st1.st_size == page_size, "first memfd st_size should still match requested size");
 	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
 
 	close(fd2);
-- 
2.50.0.rc0.642.g800a2b2222-goog


