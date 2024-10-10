Return-Path: <kvm+bounces-28401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 388E2998168
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC33AB21296
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2501C6F6F;
	Thu, 10 Oct 2024 08:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Dh7dfju"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5AD1BC9FE
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550797; cv=none; b=mogl/WKSGC+p9Ti4DaU2cBv2sxqCN3QmZQfAoWZNsHbA4DkbLEHCxBY7jRLp3MP0Y+n7nBfn65kBBKqOQeuXO+x2glKdO4C9T8UK/tG05GuAWkmn5Aq/pwLzxeg8WvaxqH9UD4JAfQTMBSkCWJ9nl6528G21RBkf66zkPirptKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550797; c=relaxed/simple;
	bh=6O9oX/Eb/qfSLrwuOSLT7z4LMccm6m6RtLN57f3JkYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xdg0xOWopucMxwJ9oHuJlm6aREfP1nE+ENo6ThDiQDsZVj3gvCA2iQM/GxzPWis9BWPImYnIiPKJ4KR8cQm7rJnJr97SEjgCqq77fhsHt3pGMOmNPPSoU5nGU6oODLQHwKHD+5AloXLBQ//xqKM2VSnbRCF6zt7WJKcIzVRgnXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Dh7dfju; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-37d5116f0a6so16073f8f.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728550794; x=1729155594; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qzUThw8QDZNv9fDcMVRqMkWYYerRinZf/dn/Fj9e+Nk=;
        b=2Dh7dfjuppkYalWgx8VMPebkCiwmkZkCLkeH04I0isJnWjaA4sv12nJnHs87K6ahzw
         zZXCneO/F3vmknQI7Vytwb7qRQBMFYil7xi/Hx1FU7zsIHsLzlYe5IBlW/rGhrCYIkWw
         R//JBggrllpvztKB7cOks/bvMJpxPt7SrJc8bJun/J2U588H8n5jcFNzA0vrAkrad1Rn
         Gxceu9f7yid1/f3fw7gOM7DFyrUHfNc3zJXsdCx9cLdmXaM3KFkQezL9+eWB9QVUF1F3
         s2ZBtTcpmW810Fa8sZg4e/RA5U8UIP0bZx+kkiKhhcy3xDgF8Bl59mOLCe6oV2iTf4/V
         IW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550794; x=1729155594;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qzUThw8QDZNv9fDcMVRqMkWYYerRinZf/dn/Fj9e+Nk=;
        b=hWC7E0Qph2WBYkedJWbwEQqN4k+2n3NJBkg3hlLJ1zX0679xZYV6maQ2jKSXwYQ/uU
         rqJcjphwNDduiFrlnJGHDzlGUbSDU3OBaBzYunMJZ6WytO0Sg/63SRLMNR+d3GZDUUBk
         Mad7SigyZVggU6Ecvdx9e3d15ER4n/pAahcCe1SIjtmHV/kvl9bFKh+qAkoPDgjdCIOT
         IpgW3aSnnr0wPz/24TYUu+8vG+FNnINxbmp941qr3AwDGp6AvJkKJ40Ts2CSFlTlowhT
         tSABYCWbfnsB1yvStsppZNE4iYcEgKR8XL/rSxCnI9HE1RPvraCBCEAHdO9Ji+jSwirL
         EMnw==
X-Gm-Message-State: AOJu0YzCYxOaE9deEd3x4gRdmIpyBw1tdUM38jJlYOjskV2TPnTzI0CC
	qB7SWHuPa/ncaTEQowKlJP3RaTVglzP/j6YSfuZs2zZPc5zTITswZ3XA8Z3rY7tsWK+zuLz4Fcx
	EHkj1ofwDH0tPk19I63fmRKbL3z8nWUYwRkOiFIi6hPMHJUG2Pse9blzdUEHzfycrRONnyqofsT
	f+qTkc15P+AXFSdetW85e4fKo=
X-Google-Smtp-Source: AGHT+IGnEPVNJA5hNA6zgaReNf096hRtQziouC1E1cxYtRNCKe4dTpHEgBlCo1zAywzne6jSW5D++vxtyg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:420f:0:b0:37d:31a7:6610 with SMTP id
 ffacd0b85a97d-37d3a8ef27amr2808f8f.0.1728550793139; Thu, 10 Oct 2024 01:59:53
 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:59:27 +0100
In-Reply-To: <20241010085930.1546800-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241010085930.1546800-9-tabba@google.com>
Subject: [PATCH v3 08/11] KVM: guest_memfd: selftests: guest_memfd mmap() test
 when mapping is allowed
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Expand the guest_memfd selftests to include testing mapping guest
memory if the capability is supported, and that still checks that
memory is not mappable if the capability isn't supported.

Also, build the guest_memfd selftest for aarch64.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 57 +++++++++++++++++--
 2 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 960cf6a77198..c4937b6c2a97 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -172,6 +172,7 @@ TEST_GEN_PROGS_aarch64 += coalesced_io_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
+TEST_GEN_PROGS_aarch64 += guest_memfd_test
 TEST_GEN_PROGS_aarch64 += guest_print_test
 TEST_GEN_PROGS_aarch64 += get-reg-list
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ba0c8e996035..ae64027d5bd8 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -34,12 +34,55 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap(int fd, size_t page_size)
+static void test_mmap_allowed(int fd, size_t total_size)
 {
+	size_t page_size = getpagesize();
+	char *mem;
+	int ret;
+	int i;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
+
+	memset(mem, 0xaa, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xaa);
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			page_size);
+	TEST_ASSERT(!ret, "fallocate the first page should succeed");
+
+	for (i = 0; i < page_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0x00);
+	for (; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xaa);
+
+	memset(mem, 0xaa, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xaa);
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
+}
+
+static void test_mmap(int fd, size_t total_size)
+{
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MAPPABLE))
+		test_mmap_allowed(fd, total_size);
+	else
+		test_mmap_denied(fd, total_size);
 }
 
 static void test_file_size(int fd, size_t page_size, size_t total_size)
@@ -172,13 +215,17 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 
 int main(int argc, char *argv[])
 {
-	size_t page_size;
+	uint64_t flags = 0;
+	struct kvm_vm *vm;
 	size_t total_size;
+	size_t page_size;
 	int fd;
-	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MAPPABLE))
+		flags |= GUEST_MEMFD_FLAG_INIT_MAPPABLE;
+
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
@@ -187,10 +234,10 @@ int main(int argc, char *argv[])
 	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
 
-	fd = vm_create_guest_memfd(vm, total_size, 0);
+	fd = vm_create_guest_memfd(vm, total_size, flags);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+	test_mmap(fd, total_size);
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
-- 
2.47.0.rc0.187.ge670bccf7e-goog


