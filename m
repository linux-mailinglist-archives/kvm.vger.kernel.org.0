Return-Path: <kvm+bounces-39910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E17A4C96E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3315A188449E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943BF250BE5;
	Mon,  3 Mar 2025 17:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C213ZEtX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FF02500DF
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021838; cv=none; b=WmbGH0rsBfyq0oke4NIw3Wvw4ILy2dbADm012knSTPg5bufRmKF4LA9Y8LvJVeY58aHq3ScICRwrGJ3tRJ3QiPAEi5lPP4su9SpEhCuecm57KhgMox333QcO18iMiI+A5a8ytjwjp/CSmuisFbEhbjfX0MCFmaNLcSdax5oCa2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021838; c=relaxed/simple;
	bh=hHukxtvv+DhlvOpnT6JJgLuCaUBAiA8jyPZaBpcbwYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RT2DJoeVhUSFhAMBPYjTJlnOpOPuJbJrsfB1dinWuqH/MQwUbOScvmLBxfbSxLD5Gole1tsW+yn//edLp5UCf4DW6c0qCvV364tEwH7DfiMDWbguewrlArn74i4iEroO/sSwi9p95sVp2GLeiTSPlKqVYkQkNyqQlBiWD9w4/Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C213ZEtX; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-390e003c1easo2129374f8f.1
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741021835; x=1741626635; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=shxzjltmhVCSEs3XLEEf6Hj2khLkpxaqKL228sddyqU=;
        b=C213ZEtXEyvOT7om2kBYwZvTyG2f2rRjVduaq9UV7JfVr8UTn1RuuPQmfBdmdo8F6D
         6a4UD48fVYtI4+AFwK/jjTjWuqGeAuJUJCcmsNujeVl1dD0LwrdXQL/yokT99Sd145l5
         C7HRuhWPvAUp7o1Yuv7lF6QQsPJNJkYjPn4LQejBW7bd6U5REVJCrGsIoM6cSeFGNGcZ
         0VL/o8TVGXOvrnNe0jdbVElZyBdJw6rYVmKqs10O2tfnRbw4zJ//RWWgHIL1djEudJOh
         KZzBn0uda4dTrAIWj95uldgnzz2G28kWsSd0LbIahwpkjzrkm7hRVoqU7yUlZwMDh/ZI
         zQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741021835; x=1741626635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shxzjltmhVCSEs3XLEEf6Hj2khLkpxaqKL228sddyqU=;
        b=VN3BWl0PmxzHFKPYrYSFK2llzU/k46meTUksdoTG2MaRgOrAWQAczoN8469VP4Kgwm
         9IRSgxJdcZeHmK3AsO1QvvarXd4V6lll5TIGgFZFP/sypWKa5L/VALyltOhj/JBX2CtT
         0H31maVPwMv2NtY1pkWDjS9mKHtJiaerkxQuwbSKFTteZIbJRUKe0Fc15OSnW5h23p6y
         xpqHdfvt2DAULQdwpV9AnmeU4u3LJYoZU1nmlsdKjLB6tnJj9PHFYr0s/UpzQX1vk4TR
         dqb426/pwGAjWoSlha+eJEz4S5cGBfzX3USZItT1izLd5kt1WoHRxJ6+9wGpuMiuPIEA
         MOQw==
X-Gm-Message-State: AOJu0Ywfn3k64oRBx6HJ2EUidguDL4UAO1nxwuJXaOUzZAOBv4e459g+
	Cod0aZJX9lYZ7l9CPpSuo4KGvkCu8KZL7ja0Ar1XqW71VIwTuiR/DDstKYJJB1ePhCW3xJp+o9n
	l/uRrmNwR59dV54O/A9i+PZLkf2c0Y2ExCjiowJgvUHBIr2eShvy7Zg5nyfRMEMW3jiwujOBA9x
	2DSXCz17zaStON9OEP3pCTQ8U=
X-Google-Smtp-Source: AGHT+IFRshHAVxkzqZnB+ggYu/XSK/78X/FWHRdv+7cCRWE1mXA23VnZ9DwQ8SGznRbx9niCQ37rSqzPuA==
X-Received: from wmsd10.prod.google.com ([2002:a05:600c:3aca:b0:439:7e67:ca7b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2c7:b0:390:f0ff:2c10
 with SMTP id ffacd0b85a97d-390f0ff30camr10550328f8f.19.1741021834976; Mon, 03
 Mar 2025 09:10:34 -0800 (PST)
Date: Mon,  3 Mar 2025 17:10:13 +0000
In-Reply-To: <20250303171013.3548775-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250303171013.3548775-10-tabba@google.com>
Subject: [PATCH v5 9/9] KVM: guest_memfd: selftests: guest_memfd mmap() test
 when mapping is allowed
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

Expand the guest_memfd selftests to include testing mapping guest
memory for VM types that support it.

Also, build the guest_memfd selftest for aarch64.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 75 +++++++++++++++++--
 2 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4277b983cace..c9a3f30e28dd 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -160,6 +160,7 @@ TEST_GEN_PROGS_arm64 += coalesced_io_test
 TEST_GEN_PROGS_arm64 += demand_paging_test
 TEST_GEN_PROGS_arm64 += dirty_log_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
+TEST_GEN_PROGS_arm64 += guest_memfd_test
 TEST_GEN_PROGS_arm64 += guest_print_test
 TEST_GEN_PROGS_arm64 += get-reg-list
 TEST_GEN_PROGS_arm64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..38c501e49e0e 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -34,12 +34,48 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap(int fd, size_t page_size)
+static void test_mmap_allowed(int fd, size_t total_size)
 {
+	size_t page_size = getpagesize();
+	const char val = 0xaa;
+	char *mem;
+	int ret;
+	int i;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
+
+	memset(mem, val, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], val);
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			page_size);
+	TEST_ASSERT(!ret, "fallocate the first page should succeed");
+
+	for (i = 0; i < page_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0x00);
+	for (; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], val);
+
+	memset(mem, val, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], val);
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+}
+
+static void test_mmap_denied(int fd, size_t total_size)
+{
+	size_t page_size = getpagesize();
 	char *mem;
 
 	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 	TEST_ASSERT_EQ(mem, MAP_FAILED);
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT_EQ(mem, MAP_FAILED);
 }
 
 static void test_file_size(int fd, size_t page_size, size_t total_size)
@@ -170,19 +206,27 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
-int main(int argc, char *argv[])
+unsigned long get_shared_type(void)
 {
-	size_t page_size;
+#ifdef __x86_64__
+	return KVM_X86_SW_PROTECTED_VM;
+#endif
+	return 0;
+}
+
+void test_vm_type(unsigned long type, bool is_shared)
+{
+	struct kvm_vm *vm;
 	size_t total_size;
+	size_t page_size;
 	int fd;
-	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
-	vm = vm_create_barebones();
+	vm = vm_create_barebones_type(type);
 
 	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
@@ -190,10 +234,29 @@ int main(int argc, char *argv[])
 	fd = vm_create_guest_memfd(vm, total_size, 0);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+
+	if (is_shared)
+		test_mmap_allowed(fd, total_size);
+	else
+		test_mmap_denied(fd, total_size);
+
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
 
 	close(fd);
+	kvm_vm_release(vm);
+}
+
+int main(int argc, char *argv[])
+{
+#ifndef __aarch64__
+	/* For now, arm64 only supports shared guest memory. */
+	test_vm_type(VM_TYPE_DEFAULT, false);
+#endif
+
+	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
+		test_vm_type(get_shared_type(), true);
+
+	return 0;
 }
-- 
2.48.1.711.g2feabab25a-goog


