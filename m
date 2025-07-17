Return-Path: <kvm+bounces-52773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B924B091DB
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D90864A141F
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7103D301148;
	Thu, 17 Jul 2025 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r8SGMOVE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AED301124
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769677; cv=none; b=qDLx+u5LyLyadF878P0PPpU6LXJy53ELvQ5xZxdvvYvrG8SOxpJjWxgK4jWdAup+a/P5uj6qQLe3Q9lUL0Hp04vY8X5yiKlGmLZdSkhteoB3xx/Y2J66UXUjweSciQqJxCH/79M6Px6cJtB1Aih2vjKt2Te16yI6HfuFrqgTMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769677; c=relaxed/simple;
	bh=jAvdSBF6ErICG+NEpfatzuDkGTq13Xbznj+zSIuwAMI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JSRz69EWOBTviCgYggWDRP9nzjCXxdzIw2+V0KOrLyeGi69d+YxpX2XUl2c+duF8zAjn394Hd/+qEJdMOylr2T9hST65tOef859Un0G1y+eyuNijD4yfoKjAWKorKfRwTJKdjFQdlFqLCmZfjC4lKdTT8QuYaNK/p5EBYeGPzcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r8SGMOVE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4562985ac6aso12238485e9.3
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769674; x=1753374474; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PyWDW2GdZSY3pYipsk/pHc4HVtYKhYoUBzgDwVtzkAs=;
        b=r8SGMOVEKfyUjPNHrcpxfSJRSNV2HlhdDTHASHV/jlJtq2EggmkwjcosRVjRNTyTeS
         N7PxjgWP9MlEhllfN8RZS9e7ahEO3CmWI4Xwp/a1BnM6wpQ1pdHTGMfHrBN+AfAEw2Y6
         ovu1rgBqlL4tTrWMr1AlUVX/UwG5nKKDnX2mqOl1/sx5CL2/8OxT8vVFVzJdd05d1O+Y
         4DCTX3LT/9AZewfQmLd8LeXF/gxz8bqosUlLkwGSl1Aq2QgwjljwvvfG5v9cu01U2xsD
         /RcQk1l75OV8lmvbcsLfrMiwsUkNUo6a9p/HOOhqeornNCeQuzhtR4wSf3pvyD/3RH2R
         D4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769674; x=1753374474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PyWDW2GdZSY3pYipsk/pHc4HVtYKhYoUBzgDwVtzkAs=;
        b=abgQ3XPOxfI+zaxnMGeC5EX9KZM7ZgPlFsAguaGv3d20ckMGQMiMAoYgw2uFNKs3N1
         vitw1PO/I3yHKch4RpOaTeLCahuUkEm9LIUiGL4LS+TuCOrPYkbdN6LkfuzZeQ9zQ4b9
         oVlw5sASPIR7/DOXLQ9fdLRf8yYDVBQvB3n/sW1f+MOtzYudJ4VYgTjsLLj0Bv1ONNmt
         OAO/id6XutKro6F8S340LDL0wg/gVu4W7vAEb5u/GgYlfHLl68pVvDPEzflyhO/p3Yba
         va+55H0cP5wvDyErI6wyH6bfaQEvNgCaKJMIGMrHUQiJzE1zUb+/dWJelCIXGmp3Vnk7
         MUCw==
X-Gm-Message-State: AOJu0YzjBmrvqof52NgnBbUzvQ6ZpZJo+3AJku4gvT5VWgwXeqPazpwl
	dbGqVS+tWxyC+aeZzZaeSsze9X1mgVktRTur7iZqUgyMcYaMpgR7vnXKI2BDdUX2kza3axV4bVg
	vCBZVAQAI4dHqBE2y8gyapzSlPYr3+GgvuzKzjtThyBfW1VBV615jr0xXA1EMY5y6nCZYnz95zS
	zvngtMMDIowv2PBcmyws9JZieZrbg=
X-Google-Smtp-Source: AGHT+IGv5tAnpeFqMKvzppwNIKCihpsjFMpWOmPXitLL470jwmf7cFcxdWyCvv6TRZTUsmikMzzmMHDPQA==
X-Received: from wmdd25.prod.google.com ([2002:a05:600c:a219:b0:456:ddf:4040])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4007:b0:3a5:2694:d75f
 with SMTP id ffacd0b85a97d-3b60e53ebc8mr5882105f8f.52.1752769673468; Thu, 17
 Jul 2025 09:27:53 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:30 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-21-tabba@google.com>
Subject: [PATCH v15 20/21] KVM: selftests: Do not use hardcoded page sizes in
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

Update the guest_memfd_test selftest to use getpagesize() instead of
hardcoded 4KB page size values.

Using hardcoded page sizes can cause test failures on architectures or
systems configured with larger page sizes, such as arm64 with 64KB
pages. By dynamically querying the system's page size, the test becomes
more portable and robust across different environments.

Additionally, build the guest_memfd_test selftest for arm64.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Suggested-by: Gavin Shan <gshan@redhat.com>
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
2.50.0.727.gbf7dc18ff4-goog


