Return-Path: <kvm+bounces-40848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B56A5E34E
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63CE53A9107
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5129625A2AB;
	Wed, 12 Mar 2025 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VMenEBkN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85A5258CE9
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802329; cv=none; b=U1kP7J+Hkj6yxkDE7/e/CiEmxxjyCy+Mg/JuTxLhX2i+WgiY/vMp63P0cTGPn9KhPutdR2xnRwAQ2+lWHybA09lDMkMgPpmFzPTtbJHs+zWSfM9+Vz5zTIOK8wrOSec0dww1RgZd/iQxBu83reZGENLT2XimyYl3uzfc6eZli2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802329; c=relaxed/simple;
	bh=dBp330nwbC7q4iPH2IoIUZ3Q0GJxinDrCajbj2wj9s0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OvLN/XNrtzPWzVlJla6JLaI90eXgq/41/ERWjsE5SaILR6dGNZaROMfE5lBv5PSibWcuxhie1lmbuCxaW2IAp30YFkpYdp/ZZWqYSUXs/4RbEV2e77BYyffrsCVRw8faiwnuG0vFSng/IQzFAbG59VOi2lSz7XFfGBfYhsboIZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VMenEBkN; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bc97e6360so311655e9.3
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 10:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741802326; x=1742407126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IlIj3TjUhtkedIPYTVHeRQbthVzaFoCCtbaBiaH1aMs=;
        b=VMenEBkNgjG7/kRyc1xc2e8vAftptPXLVORUiTRFurTxFfUYQZmorBRSvN25uudUQy
         g585dTGZOz/Lo2aDflADS5rS8YAJwyAMzptUjN7nw9foymv438eP1y+dgkEGt7tvGEmm
         fsQgP/2l/0AFPQqu7PkvI5fbOy/X9r0g1X25i4akgDJjq9Q1ij8vKtvjxh06razNV8TI
         Pi49jUkd7f4K8XDYsjrZ8dOX49YoQMflOZcFPfeJndWdDsO9UzDySd7SGFx7ZNeq47JZ
         B4aVHH5vMOcJypUAEa6vD6UOiasGrn64Gh4Q0ZS797E84ulmvBYiSjCeX/pkubxJRUvM
         7chA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741802326; x=1742407126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IlIj3TjUhtkedIPYTVHeRQbthVzaFoCCtbaBiaH1aMs=;
        b=phQBsD6CtKvpW/AOyTJV8xtNp4NQIx/WGt3sxxWVxgfrykzzU5NnSxl0m+vMUwEc1p
         L0wskDfH8wdruJqOODPbLlQgpGmZenZFI5KvYShqQURe9y3ut6u/pRxmb4SpJndr/xDR
         MhHe5sGMkgruaLV0lxpsISFaBzWg6E3afwPPbm21tLF0uccgJVENTqr+I+d47piiVjBV
         jLfZr/O4jvmHB+K7EltL7zjra8WrePeksUHBPbggY0JhojW1JqiyjweWH/U9ED/pHJG6
         rFH9riuIBadj/h85x2s8NegpgCw/aVau1WzdepnzL4MNhdj7S+eAFnhgAj4GssbepjmM
         eADQ==
X-Gm-Message-State: AOJu0YxEXVcetUCgMnVgm77UIY4jHgcVi7zVyFoVYI0Ix8k53RyKVG+z
	nkEPnIzS1JXZ9DZAfnPbT4vnAO87vjc9p75gUo4JGyVfJ/B3nReOUZKxJL+AOqWajxHQ18oed7k
	PUtqRdvhMMsRnUWHb2B64VqOUDUcycIqC/7xUwT0ZC8CxPPVVc7SIn9el6+mRaDyAIn07sU8OR8
	ORDD8WkL16AMHpbmZc8nlvHuc=
X-Google-Smtp-Source: AGHT+IEjvTr2HYGSAjPDkNMw4G4npR8OoTHD1VZTAuD0hSm6xCoVT94NRgIvuCOHObtSUaBMEiPsUwonRg==
X-Received: from wmqa16.prod.google.com ([2002:a05:600c:3490:b0:43c:fa2a:77d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d09:b0:43c:efed:732b
 with SMTP id 5b1f17b1804b1-43cefed78bcmr140968325e9.5.1741802326090; Wed, 12
 Mar 2025 10:58:46 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:58:23 +0000
In-Reply-To: <20250312175824.1809636-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250312175824.1809636-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250312175824.1809636-11-tabba@google.com>
Subject: [PATCH v6 10/10] KVM: guest_memfd: selftests: guest_memfd mmap() test
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
2.49.0.rc0.332.g42c0ae87b1-goog


