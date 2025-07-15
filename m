Return-Path: <kvm+bounces-52489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81962B056CD
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE52B188C955
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EFE9276026;
	Tue, 15 Jul 2025 09:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D586QWp3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC823E352
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572415; cv=none; b=HnD1RKC1pnjizE45hGBHmm4AEt3J3REFfve9j/M72KccZtrsQGSpiDa2bY3ChF0i4Su811BEd1dCOq3/S0amyIaMJosVk/IZ7qY8fpEHCl/JuXP3UvFDBk2eR8qaWn5jFATzycNSyT3LGFQ8viMQTJpP0VOToYYvvnyimokdkNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572415; c=relaxed/simple;
	bh=sFAWxHye44w1R+mM5V+LDiCzTr6ROyPDzwVyA8ugqX0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rrHaIkw2o3xEtaq7xH25t84MRde9fnczUNHJSyjju4rNdusUg8j4qOLQMRli1vcnaKUPLARCKgzH3y/dUPsg+HfEck5XmMc62P80zB+fls9aNcn1IdB0eUpKarUarv8/VKmrE6/7KIFDEdjaulsN16pEcj1q5M2xVqTVFH332ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D586QWp3; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ae708b158f2so323819866b.3
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572412; x=1753177212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOxTG6i7FEjwgO78cp+SZydc4yJ2EnAl5OEX1LUXtxU=;
        b=D586QWp3+gw0qj6cZ6OsX+OXpfxiy4edW6mBq/gT4R24vSbLVqkIRFyjVQha43IkIX
         osQwZR7dUxMGVpMcpPJaZZhXrvp9YXpX6eiitqntgzr2DDGQcWxOYRIWJ1SNUGm6j5n3
         sfdgThoEzO94gcs/9A2cOuWOVDRPTlMeRIw7udx6Z8OgODzezAB0ZdVGpGZnvlmsQp2S
         WGZBJLkzwdTxe687Y2sYk7JrcANzL6WMgfziXh0swpIKXlmUKcKSwMHgJXCiTI7IQy6+
         XWbd39Ky72CUZqvrQHayxKiCg8FMLPvCjjFS9lSOcXEkgbUBAboTZQczS8EoMANhbfCc
         DE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572412; x=1753177212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOxTG6i7FEjwgO78cp+SZydc4yJ2EnAl5OEX1LUXtxU=;
        b=kmZYP/2LzH7j22DbRIoOh6zUIDqrep/rkOB3izGjp4xyQ9x8gNRn/KhC4jVO0hYGTs
         ZJblaf7loClGNvKhdIqxk+KS9UzY4qOfXMys/QYhO4lrQ+eeCoL376DFnjjFDhH5UVP2
         +gftIupJzpNT+2YkrqzrNa6yzjd42J5757Od6nVz/OKjDesYivhU/rHb4FqnFmHShUNA
         2r9w3yAkarhvD2T5EA25sbaumJPcAcJjpkJI/0B+pbLfv7fU+JxE7NMAdW9yLCpQORZH
         okCv6VSnKDt1eduqAelPy8zdzM7/Bqys79vSzSNI0cxs2LiTvs3kosTrkmcObg9KF/7O
         15uQ==
X-Gm-Message-State: AOJu0Yz4CBnvY+2R+r7KiMtsEPvCFqnp/KuWNVhQwZNto6KGAJsQTFDz
	+G9IR10x0nYUlhkRr7t0EV6V/kBXxEmFXoUOO3rqgFqHXP2kd+4ih/JuU1+5zUT71kpRgjAywEB
	eRugc0sWFtM5gHBLb21I9zCJLuxPE9btu3NCxOvLCv4vHyKDqpRTGQcA1aFddA9woIJI5E0FMU3
	0lzD2Tt9WaZoQ6FrrmLdXB53r8pgs=
X-Google-Smtp-Source: AGHT+IGI610lCZHGfon3SNZZY/SVw9WaoOiFuKCCBX2T0KCJ+afRtNdmxFp5hhQEFR82WUfFrBduY0Ajzg==
X-Received: from edt19.prod.google.com ([2002:a05:6402:4553:b0:609:36ed:3901])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:378d:b0:5fb:c126:12c9
 with SMTP id 4fb4d7f45d1cf-611e84c2334mr13524470a12.25.1752572076080; Tue, 15
 Jul 2025 02:34:36 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:49 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-21-tabba@google.com>
Subject: [PATCH v14 20/21] KVM: selftests: Do not use hardcoded page sizes in
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
2.50.0.727.gbf7dc18ff4-goog


