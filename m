Return-Path: <kvm+bounces-46564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E4BAB79A7
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:46:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E24791BA5987
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99A02356C9;
	Wed, 14 May 2025 23:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmIxfLHE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58500231A57
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266194; cv=none; b=OHKXCT1qtso+YppgUEt5MnRqBrZ/EdPvW+rProZvAdnC0tekGXB8Qaz8Y+SyZ+qVbNIhdhUiO/RDPZxnpK8gXAaeJDVTw15rnFGPxaehKMXl0qX/faBZmSLcKNiwFG+jD6yAEk6qQQNgDiTp+uAwEKnkm8bVdeWDRQhH+X/fijQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266194; c=relaxed/simple;
	bh=ROz3Vh7FyPzpWClrBL5MnADoPmYX3e2sldFKqiqdpas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l8/XEHW5HHJWV2kZz+dzrF1wl1gwNht6NV3Wzu9CdDrvhAPz3FVz9EEiRhVe6adxANLkLuOJbnG38J3xPUvCy4M+pcr+Env2seVFvfR2p53a3K8C82suGe243bRklWloGRYCwbSznMUWt8dPqMOfpPlKLgtuTyMXDFt/rQJLQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lmIxfLHE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30cbf82bd11so285605a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266192; x=1747870992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XIQY9yLRzDdCwjnfungXTg71dAj8IwxkOejXFn+6ono=;
        b=lmIxfLHEsuCKyaI9Uajg4xoQQjTCd4zv3bJtU1dNQAb959/Ibk1+X9y2drc4bokyFn
         bihXAOGAsFrCVuoexDfZp270rBJwA1wMXvarqZ9Mzd86ghg/UDB3jRS42FxKxp3HHTFn
         F5Kg/iCBDSNXO71/rdoVAro/OygbNNwX+4Ffsx+6GGF/LtMA6TlgTpeno72ObETefTbY
         iNEPvtJY4hENuUnuc+PGBk1oYadhHaJcEdnRkMf0WSasZuvon4ZLXl9UXpewaQVhsN0i
         pafpE5/bP7iBp9JJTsWq/4lM+9PSQvpKD50kI/3rQpWRoNM47fF6ljDsj22wG2VkmE2+
         +gLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266192; x=1747870992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIQY9yLRzDdCwjnfungXTg71dAj8IwxkOejXFn+6ono=;
        b=sg08yNBb7zLLPl+Ji3YyODbeY9l04ew1mkNxh5hoOe9K7lCFnnx+MHq5Ot8esQIeXG
         XfIUkcnYfraZj7U+YXY3F/9ZYUfsKFe7wE2Z9uqAujCwsETw+QS9Aq1IdZsyv4OibvUC
         GqdFxQYemun/4E9q21yG3gFitBSrkaqBemnxjpI9BKu1hx/aOw5QZAbxb/AxQVoQ9iJg
         OXbGA2/DmV3n/yLPPFCCQRwEfYiIE1/xwCvQvlC8ET3L3truPqlJObRFrAk9JzeJALVa
         vUFAvYqSjGit1Rf5IEAUMj6szzxY3Fa+Ln0jSctTBqgCMpgG4GmZVT5pLZzDWjg8UycE
         aUmA==
X-Gm-Message-State: AOJu0YyNkkFOrd2T/Cc/sJIw8KmRSWN1fNQNt7hY2Swsi51bEIKeP1k9
	7ln+28Qp1q252p3YcfpcQ1NUEoNJ3Ez783biSf8BHUiPbY3ljUezzYMqPoIcPYAUsVMAJNgyw5T
	ms1WF2t13nElOrEbxVys06iR2vaYDZ/TZZ+lxY5rvwAMDd/LR4cMQtSOqKGu/A6wN2C/ytZeCrp
	GYJ2qRuDbcbxAywHDQqj5YvDuCOokDoHIMTv65n+k8qVlqjHodcDKFJt8=
X-Google-Smtp-Source: AGHT+IHC0afSzx4CRGLb+NEtt5FopkBc14R3Tsx3Oo5v/U8eDsNNnam5RHpBwQ1p1qHPCM63buWzU71Ko18fm+qY7w==
X-Received: from pjbnd11.prod.google.com ([2002:a17:90b:4ccb:b0:2fa:a101:743])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d4f:b0:30a:3e8e:12cd with SMTP id 98e67ed59e1d1-30e51914e56mr638587a91.22.1747266191346;
 Wed, 14 May 2025 16:43:11 -0700 (PDT)
Date: Wed, 14 May 2025 16:41:48 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <3d2f49b409f1d6564eaff49494789908eb9b74e5.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 09/51] KVM: selftests: Test faulting with respect to GUEST_MEMFD_FLAG_INIT_PRIVATE
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

Test that faulting is denied when guest_memfd's shareability is
initialized as private with GUEST_MEMFD_FLAG_INIT_PRIVATE and allowed
if the flag is not specified.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>

Change-Id: Id93d4683b36fc5a9c924458d26f0525baed26435
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 112 +++++++++++++++---
 1 file changed, 97 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 51d88acdf072..1e79382fd830 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -16,6 +16,7 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/wait.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -34,7 +35,7 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap_allowed(int fd, size_t page_size, size_t total_size)
+static void test_faulting_allowed(int fd, size_t page_size, size_t total_size)
 {
 	const char val = 0xaa;
 	char *mem;
@@ -65,6 +66,53 @@ static void test_mmap_allowed(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT(!ret, "munmap should succeed");
 }
 
+static void assert_not_faultable(char *address)
+{
+	pid_t child_pid;
+
+	child_pid = fork();
+	TEST_ASSERT(child_pid != -1, "fork failed");
+
+	if (child_pid == 0) {
+		*address = 'A';
+		TEST_FAIL("Child should have exited with a signal");
+	} else {
+		int status;
+
+		waitpid(child_pid, &status, 0);
+
+		TEST_ASSERT(WIFSIGNALED(status),
+			    "Child should have exited with a signal");
+		TEST_ASSERT_EQ(WTERMSIG(status), SIGBUS);
+	}
+}
+
+static void test_faulting_sigbus(int fd, size_t total_size)
+{
+	char *mem;
+	int ret;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
+
+	assert_not_faultable(mem);
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+}
+
+static void test_mmap_allowed(int fd, size_t total_size)
+{
+	char *mem;
+	int ret;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+}
+
 static void test_mmap_denied(int fd, size_t page_size, size_t total_size)
 {
 	char *mem;
@@ -364,40 +412,74 @@ static void test_bind_guest_memfd_wrt_userspace_addr(struct kvm_vm *vm)
 	close(fd);
 }
 
-static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
-			   bool expect_mmap_allowed)
+static void test_guest_memfd_features(struct kvm_vm *vm, size_t page_size,
+				      uint64_t guest_memfd_flags,
+				      bool expect_mmap_allowed,
+				      bool expect_faulting_allowed)
 {
-	struct kvm_vm *vm;
 	size_t total_size;
-	size_t page_size;
 	int fd;
 
-	if (!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type)))
-		return;
-
-	page_size = getpagesize();
 	total_size = page_size * 4;
 
-	vm = vm_create_barebones_type(vm_type);
+	if (expect_faulting_allowed)
+		TEST_REQUIRE(expect_mmap_allowed);
 
-	test_create_guest_memfd_multiple(vm);
-	test_bind_guest_memfd_wrt_userspace_addr(vm);
 	test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page_size);
 
 	fd = vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
 
 	test_file_read_write(fd);
 
-	if (expect_mmap_allowed)
-		test_mmap_allowed(fd, page_size, total_size);
-	else
+	if (expect_mmap_allowed) {
+		test_mmap_allowed(fd, total_size);
+
+		if (expect_faulting_allowed)
+			test_faulting_allowed(fd, page_size, total_size);
+		else
+			test_faulting_sigbus(fd, total_size);
+	} else {
 		test_mmap_denied(fd, page_size, total_size);
+	}
 
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
 
 	close(fd);
+}
+
+static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
+			   bool expect_mmap_allowed)
+{
+	struct kvm_vm *vm;
+	size_t page_size;
+
+	if (!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type)))
+		return;
+
+	vm = vm_create_barebones_type(vm_type);
+
+	test_create_guest_memfd_multiple(vm);
+	test_bind_guest_memfd_wrt_userspace_addr(vm);
+
+	page_size = getpagesize();
+	if (guest_memfd_flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED) {
+		test_guest_memfd_features(vm, page_size, guest_memfd_flags,
+					  expect_mmap_allowed, true);
+
+		if (kvm_has_cap(KVM_CAP_GMEM_CONVERSION)) {
+			uint64_t flags = guest_memfd_flags |
+					 GUEST_MEMFD_FLAG_INIT_PRIVATE;
+
+			test_guest_memfd_features(vm, page_size, flags,
+						  expect_mmap_allowed, false);
+		}
+	} else {
+		test_guest_memfd_features(vm, page_size, guest_memfd_flags,
+					  expect_mmap_allowed, false);
+	}
+
 	kvm_vm_release(vm);
 }
 
-- 
2.49.0.1045.g170613ef41-goog


