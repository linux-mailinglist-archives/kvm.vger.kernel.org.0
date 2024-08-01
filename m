Return-Path: <kvm+bounces-22904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E60944754
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3EFC2818A4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A997B170A1C;
	Thu,  1 Aug 2024 09:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0fu2Apxv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4E716DC35
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502895; cv=none; b=FAghG6nhAKL5hMS9wDAftQHMCpmL/0SBYa+jZh4THQj028D8R6iUgMSsYONtzxBnXKYz1mkKGAHNnY17NvNwPHCn+UiJXabj5BTyicW6C9Je1oiVpOr2XZgr/R5tw80EpIo0JXGBSmuehWtobsD0WQwGu438spqdNtVxjdjhjK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502895; c=relaxed/simple;
	bh=zbjEJuwMf5QM2G3YeMI5M3nCWbiG7wC9OQ0aFSyGqoE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Unuc52/EBHdxyXvbOlSYd380cY+2xIlzSBloLWQoXOxqRX5xyM2yVHsvBmY8Myfsr5uLpT5NoCMf7+LuxGXC4HJWfTkeqPa3KFjOf0fZwFid6Hw7SS5XvnluOvkZvlmlGRYdxTUkmuorzkczq393j8eeHSX2ei87WiHKMxnpu3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0fu2Apxv; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-654d96c2bb5so123865107b3.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502893; x=1723107693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FenZNVmro9JWmRf8yJhfaxf1ruU6PeQcDA6Tq5ucplA=;
        b=0fu2ApxvCQOoT4ROGNMcW28XaI3XGgtt/HG/CKsDSDds8dGKr5h6DFYyiSgUv+l5ol
         Teov9NoyTElhrw79iZlINd6aC2cHLR0FxwELVVjE6eek4KImdHiUxiJAeE/he+FEysG6
         Wlj+T4IbGURcSiNMX1JWZVbD6I+1Xxz+sZIN0IOk7aSvIvCF31xWF3pvpEnB3ZQEZlXA
         A/kuOqzJExgom3SJ9YAidg6thkbqRYBD6k3Cgc8XyTAmVQMSmpTxmvrW//D4OweKmU2F
         Q5HhAC7wHzJ6Z70kHmbRSJ91DZwoqB6eJvpu9RleM4BUn0Otf1fUOeHJzb3hsmn+M8iK
         VpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502893; x=1723107693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FenZNVmro9JWmRf8yJhfaxf1ruU6PeQcDA6Tq5ucplA=;
        b=EWCcv2dV2JHaRqK2wnzlpZkZSefw+Baw23QuiPWcD3W7s/Ky4PUwamTLhcBKtrIlkb
         HstodfXJUziyY1kP+I6BQfxx/BQcPO13HN11haWC+QyKOTB9COSytCZUptTJjSiyi5HZ
         HPE9xX40/obrtUqz9kOrawX0D6kF2quBIkG4LZWK6vadYNXtddN72KKkNr2KZesB1Iad
         VPjROzPCnprh7vk+gMQj0TUGTUqr9q+chGkIcV+Ad9Ms9Xvn91BVySvkU6BpBB28Lv50
         JmhglD9ElOBlOPKUknGqQhoStHHqTl+10ptWn6zZe0qQHeW78Oqfe02euyPuW+wjhbtl
         Sf+w==
X-Gm-Message-State: AOJu0YzzqhA5PtnfjD3zppsTovEbRVvkSYtYi59u2HEmJCSgnYsrn9kP
	+jOdabCQZixc41Kgsl94KMaio0gFuLJkMTRj9oMPTnRUWRIxGxCYlZMGulcUkML6q2z4dEIEWuQ
	8LAyl8LLx7VeFI0r5KerveyjkBrjvDVu1Pd2Ycpqd4KTmxMd/wCyAhMSwdxZE7KpWa9r8vSz6D0
	cwSVAUzJNui4hquJeiwfZtWeg=
X-Google-Smtp-Source: AGHT+IGm9QckLnDbVxc2uajSqqnHpYUpgzy1Qib76hzzsjZLg4j1Inen+nQBahz4WB8vSdsSSS9dwIaeEA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:dcf:b0:665:a4a4:57c1 with SMTP id
 00721157ae682-6874a9ec608mr269487b3.2.1722502892571; Thu, 01 Aug 2024
 02:01:32 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:12 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-6-tabba@google.com>
Subject: [RFC PATCH v2 05/10] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Expand the guest_memfd selftests to include testing mapping guest
memory if the capability is supported, and that still checks that
memory is not mappable if the capability isn't supported.

Also, build the guest_memfd selftest for aarch64.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 47 ++++++++++++++++++-
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ac280dcba996..fb63f7e956d4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -166,6 +166,7 @@ TEST_GEN_PROGS_aarch64 += arch_timer
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
+TEST_GEN_PROGS_aarch64 += guest_memfd_test
 TEST_GEN_PROGS_aarch64 += guest_print_test
 TEST_GEN_PROGS_aarch64 += get-reg-list
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ba0c8e996035..c6bb2be5b6e2 100644
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
@@ -190,7 +233,7 @@ int main(int argc, char *argv[])
 	fd = vm_create_guest_memfd(vm, total_size, 0);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+	test_mmap(fd, total_size);
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
-- 
2.46.0.rc1.232.g9752f9e123-goog


