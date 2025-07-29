Return-Path: <kvm+bounces-53702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4281FB155A4
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F9E43A4085
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118E22D8382;
	Tue, 29 Jul 2025 22:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yK+99fF4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE082D6419
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829771; cv=none; b=YpNAwjQQCBo8h1Y2Vf8DR4AzlaZsPPIdjDTOWX+hDD4G0cjjbcmU+TKW0EAOYyMie+rFlJ/AmKoa4rOfOA3x15QpfgpspWRNmvEQ5w5y1VAkp/HAHxeDCq1l3E4I1wTcHb0dUenCiX4BIwEFgkJVUtWKcslYuR0rKj5MDQ/16+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829771; c=relaxed/simple;
	bh=OHF0d3xJE+lvk3i6OCBD5mRif8KdjhliFuoV3VGobDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P1/0obkZdNJFuQh0Z49T5ll4ru5J1WkPKHrY37oydCBMl61/fb7Xrn0OfRjBSx+WNZTEA8mktAsqkQ5orEY2M5acl7kKCH/wofmzqoEF8kGGKKiQhlepOaLOgNsGl0Ok/5ncvIFXAVqSYn5Na16/QGIKmRmwVhz/nlJoev1Dqd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yK+99fF4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so6112170a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829769; x=1754434569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+ESC0itWrrYha2Tf9gSEwP/cvcMjKDVsb022arfffBY=;
        b=yK+99fF405r5uq1Ws9LPVXuOG52sd26T5Jvmpm9j92Cxn7Gof8MySx333f8FJX+OEz
         d0mU5ucN84y63LoLsPdVzju04tuPN8i9L63jylIuSQIVG/6TXH0MTsiTjm7/SX40Fyar
         XxY5d3vVuU3MCkAgiD2U9pqfrdbK6dubpgWrCk6ERI/FcDANSIXqUIHa8U5i0hL2FHaR
         37ovO/UKY8fhYiWOzLBb/kSJ7D0i8ob7SyisWmiTwEol04gvGIWjGpH3e974WdAOFSVW
         p6DxETP8UH3xLXwBLH8grAntRjR/dClAu3jrIEF5cIxSi62Jl/5FqMUxBZtZ3YtchQ3S
         UUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829769; x=1754434569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ESC0itWrrYha2Tf9gSEwP/cvcMjKDVsb022arfffBY=;
        b=QVsuN8JkOyqy5I82Ce+aR8RdaCg9bE3+DYdQXSzLSdfRUzf4W3069SxFkccCWhseZB
         YA4l8xu0L2Gm1pcTRVoLEHHNlL2frruGiuP011cZLQ6pqcAhVA9SfD43F5RoYFSgXDd6
         vjeocfFNrQfd0Y4SOp8wbsQvh02TI2ntmatwnhIrCkJj2uZINDMgc/BO22348m68NgnF
         ElKtiEMRvifqfstw5bHZxrln+i7eVoMnpKzRk4pxmkvNfAeNpjmJdlwHZjoNKT41h6QQ
         U0Ggfk6ByGhF/CTPBFU8NZnu1UsqExtl6ppSs7UDGoQWziHPTDEuv9x8EXf2VnOGfml9
         lFSQ==
X-Gm-Message-State: AOJu0Yy/jBnDuZU/ueMyvgGH7K7zk2GmVywemOFNlKdZyuf4gNvyZPg9
	TNXOBuRNGGc7I9PRa/odcRA3YZaDXlwQo0JLcDoDqVzu9sdVLit4FeXeQjX3cM5H/9MleEYCTBX
	L88nJ8g==
X-Google-Smtp-Source: AGHT+IEP72ZXZaJ48/ldlCnpX6zM87VMY86dQ66SFrkWz5+rNp24L8qvClHiEDb9z5cTOvOVU6+mQmJCcYQ=
X-Received: from pjbst4.prod.google.com ([2002:a17:90b:1fc4:b0:311:f309:e314])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2683:b0:312:1dc9:9f67
 with SMTP id 98e67ed59e1d1-31f5dd6b52fmr1710635a91.2.1753829769155; Tue, 29
 Jul 2025 15:56:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:53 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-23-seanjc@google.com>
Subject: [PATCH v17 22/24] KVM: selftests: Do not use hardcoded page sizes in
 guest_memfd test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm       |  1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 40920445bfbe..963687892bcb 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -174,6 +174,7 @@ TEST_GEN_PROGS_arm64 += arch_timer
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
2.50.1.552.g942d659e1b-goog


