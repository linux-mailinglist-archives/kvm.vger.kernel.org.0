Return-Path: <kvm+bounces-41405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBFAA67910
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A9C317D2DB
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C78211A35;
	Tue, 18 Mar 2025 16:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IKgyblz5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D9920D4E3
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314726; cv=none; b=mNfDamOBhH+XcsKL3lH/H8Ecdv+kziRd2g8fkCgyfg13C/xEqF4hW6P8FxQJqngHzkJA85+vBbk3K8KOe6tJjf/oxIhEzOTqMIpqRPr44+sz2daqhWm/BAHUz4xKiEwI/LUUxwUVoXOBNuPH04wgNuE/4JWlJ1EWWeYXkBmInUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314726; c=relaxed/simple;
	bh=0353GbWNtiypns170IbaABKpnClWl7kFDc76MwvYHrQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CoFrdChXId6bPhmsegVsfDIb3eZfOoWDL92nQo33KV9ZQdZZrBwhOAYhxY+qMFMk6LMmz43VMVSKIem0oGEnlu/oO2C/ghEFxqhHTOY1fSurLFvpyDqXfqLDoO6TOYAZ2kESTdUH+T/CrtxZ8g033KEl/rQzcvjgf9A+OHnT0tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IKgyblz5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43947a0919aso24725335e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314723; x=1742919523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YWV37Fu+tJoPMYhPX//LQY4FHmLdXa7vPP9UtI4St3c=;
        b=IKgyblz5E+4HBMp0XM5HI52Fn5E3cxAfAmJzLoMN5JhUIim44FB0EQDYxS5ca4NpX5
         Jv71rMm5eEgbGqyzZ6ZMPkFtqMjrbdFXgIPC3Ov+WAE3mSKY8Neo0Jb1BYp7EUcPKm7/
         DN+ek6ZZ+rZZFBFJvqHO2GMx1CsL1GW6rJFlbe3rNK64kvoTosoCD++VuMUP7d2RjE2y
         lmYF5ruURGRY2eczyHO+4HKJRLx/8GFjAme07wX7ts0wseNYQzvh8jN3EzKhLyti06Rf
         9KWytlvuvKNszGVw0wWakZq2NGk0LftcM6F6evclngOYMnxK2SdUPlwPfjBGdOk5TR3Z
         9YkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314723; x=1742919523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YWV37Fu+tJoPMYhPX//LQY4FHmLdXa7vPP9UtI4St3c=;
        b=iOALKcwlDNekbZcBB3Mr5umd0L6xHiZmxKcNaLBEZ4oQ/IakAUIzJt+/1cdeHuJaTe
         YwruN4S4ixSC3ZbEOLsjH4/g4edxaWe11aGatF+f/I0bddlCuQKpfzqZpkYssHqSHlWB
         l/VK3Mt0+VYJHGaggk9eFavAVYUWd4VtCLsVeBpB3vSYUEg+tJ8f9eP1NAwSXHC2ZHI/
         soJed94W7yZs6RW9+SiY12p5DwxCRTOkWCYqe6a+CKWPO9OBK5EubR7KQ4gqNjZGT8xy
         dje+QH5oJPQXk9SvhjMHbnVqRXdnILXpwEWcjHbNxj8hCubbejfPi6rStAWZoqSlzZcq
         OixQ==
X-Gm-Message-State: AOJu0Yx1mqUedzgTjj/46MHXBiUaENoDngBDTCqziMBgyCBeb5+zo6BE
	XZdlSIPEJrtkjPNpUaWOjX2sRJmnepbVfX70tGSjTTZwTFLKM+UvuHW6Wr3/Xj9hxokSWI7ev7J
	fwI2tSUNUi6WRZ5pNYGY4BgEVKtpxlHMyUD2+FwOCtPl6W+TnbPeQu8Y6IyUQkE0AJ7rAUQmJwT
	JfbVfVtkb1Zr41EejHhtPxYKU=
X-Google-Smtp-Source: AGHT+IGRTYPnfa8CqiXnFH9ZNBBgKbN/7IfwN+GVa+iyNbSKldeysOLwqVRPA45JgaTBntykYDM/9tDKvA==
X-Received: from wmbez8.prod.google.com ([2002:a05:600c:83c8:b0:43c:fce2:1db2])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1909:b0:439:9a40:aa0b
 with SMTP id 5b1f17b1804b1-43d40ec6496mr3290515e9.25.1742314723020; Tue, 18
 Mar 2025 09:18:43 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:18:23 +0000
In-Reply-To: <20250318161823.4005529-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318161823.4005529-10-tabba@google.com>
Subject: [PATCH v7 9/9] KVM: guest_memfd: selftests: guest_memfd mmap() test
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

Also, build the guest_memfd selftest for arm64.

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
2.49.0.rc1.451.g8f38331e32-goog


