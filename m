Return-Path: <kvm+bounces-26427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A609746F2
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99C0D1C252F1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E7C1C3F1F;
	Tue, 10 Sep 2024 23:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ryFoj5lE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDBD1C3302
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011937; cv=none; b=sgMyso1G326KgJ2EBDXlW3uDiO7qxqFh9EXleMQ8ylWyACvgAVMJ6/P+Zgo7E6IXAT/d3KZF3yeiun1VBLWdTiFg/prKAl7PvGtMWnjEagemPt1wyze2K7YOZG/E3l7TwNtyRHiyHV1deO+heqmLSr4gizBYrcHjSerr5Jb6L6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011937; c=relaxed/simple;
	bh=xDhJT0jtukUSht8M1rW68Et+r1brKb18kxNSu0XqBak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wj50XXPuG77m6A4x0R6TH2PNtElCZFXJYpjeRLc0D5qejXGoYPDe2RlvdGJmioS7YOoVvCGidlciuIJYbL9Dl+3ukoE5TymyA9EKKNtzqFrDH6/eDCV4Dtb1lQIX/ykPR5Yzght5kwbNcgXdeGndbyOKy9bD1wYS3bCHNT0DGvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ryFoj5lE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2070e327014so13337335ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011934; x=1726616734; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PU0eLeT/Khb6QlOSfPgwKdSujIEPbf2Mi98Qjlq+ljA=;
        b=ryFoj5lEkrpo5/Oin/SfkYzGXzKADf/1aAH+vux+vxk9jWoiuWcQCyLE4oT1FIB7Tu
         LzR5Q6RPxnEiEha2NzW4AxVN5YlXiB9Q8UE36XAOSURV1kHiXngHx5KVsdmgPnKR60yI
         j4/g6Qm/BvA160B9TYg1HPdT6gI6+K4My0v3IheLzqbN1lmXS1Zm6BVbc5gUe6KJo7Nx
         FgGBfCQCpA3GusBRgEDavhyo9PsMQuPE3LTkWskm4KJKtEH4UIDfGiacNWQEvnIoJrsl
         uIBhWJ4vh72sRLkAbtKyxx78s9UQWq5ynUf5UwLwlcu8sMrpeif44qKb9trZWSU+d088
         rFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011934; x=1726616734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PU0eLeT/Khb6QlOSfPgwKdSujIEPbf2Mi98Qjlq+ljA=;
        b=kh43n9Y21TrfmAfuiSrlaxcp5ZRpSN9ptFwTrI5wSRqW9oWRk1daj3oeu5ZYGVw+Ml
         XS0qLgV7XmksHHZPEivTJ0pFB9UdlW8S3+OgrLs02NlHWEfvQIZykKXx702mG3KJ4/5P
         3VwSf9uEHuE6d7mjvFsm4zZYh3XbZFEWtGjQ2FXnihp3KuY0OeWM5Y6Y/MUx5euDORGk
         egQ1Jk28XBbqyfpl5AntNXLvyCykgh/XR3kUFcHyEv7B9fuAKCxwK5Wg8VS9whT52wWx
         Y2yQNx1nMSP0Dr+vC7N6cp3chEIF/nzFY3p/4m9dScLcWollfXwd/er2SYL/0rn3bW8p
         +3tg==
X-Forwarded-Encrypted: i=1; AJvYcCVFZOxzH3fqsbzbVF5YeCZ8boim2IWLpfD7jtx59MxkXGnYjzEvU9AWHpeP5/nnUJTlSIY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7tOLQsUCSBiq67cza4zmm7zUstm/HMS2BvYVXena5m5D9U8+E
	/LT4ahRFQq0IPf040wFXR7S/U99fPE/7/BQrX8AKmJIarZz5DGjo6uGlJpTjv2ax1HShWgm49QG
	2whV3pcWBtwKll4EMXnXUag==
X-Google-Smtp-Source: AGHT+IFVTG93FUeTatq9dmJkXI56Xlmri3CwyYIl4IemmSnQkPMQ4ndLEBPGw8YCyak9fs0iNwaTmELdbdpO3NZKxw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:f687:b0:206:c776:4f11 with
 SMTP id d9443c01a7336-207522167damr522595ad.8.1726011933308; Tue, 10 Sep 2024
 16:45:33 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:44:06 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <09892ae14d06596aee8b766b5908c8a7fdda85b4.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 35/39] KVM: selftests: Test that pinned pages block KVM
 from setting memory attributes to PRIVATE
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

CONFIG_GUP_TEST provides userspace with an ioctl to invoke
pin_user_pages(), and this test uses the ioctl to pin pages, to check
that memory attributes cannot be set to private if shared pages are
pinned.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/guest_memfd_pin_test.c      | 104 ++++++++++++++++++
 2 files changed, 105 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_pin_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 3c1f35456bfc..c5a1c8c7125a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -136,6 +136,7 @@ TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
 TEST_GEN_PROGS_x86_64 += guest_memfd_test
 TEST_GEN_PROGS_x86_64 += guest_memfd_hugetlb_reporting_test
 TEST_GEN_PROGS_x86_64 += guest_memfd_sharing_test
+TEST_GEN_PROGS_x86_64 += guest_memfd_pin_test
 TEST_GEN_PROGS_x86_64 += guest_print_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/guest_memfd_pin_test.c b/tools/testing/selftests/kvm/guest_memfd_pin_test.c
new file mode 100644
index 000000000000..b45fb8024970
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_pin_test.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test that pinned pages block KVM from setting memory attributes to PRIVATE.
+ *
+ * Copyright (c) 2024, Google LLC.
+ */
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "../../../../mm/gup_test.h"
+
+#define GUEST_MEMFD_PIN_TEST_SLOT 10
+#define GUEST_MEMFD_PIN_TEST_GPA 0x50000000ULL
+#define GUEST_MEMFD_PIN_TEST_OFFSET 0
+
+static int gup_test_fd;
+
+void pin_pages(void *vaddr, uint64_t size)
+{
+	const struct pin_longterm_test args = {
+		.addr = (uint64_t)vaddr,
+		.size = size,
+		.flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE,
+	};
+
+	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
+}
+
+void unpin_pages(void)
+{
+	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_STOP), 0);
+}
+
+void run_test(void)
+{
+	struct kvm_vm *vm;
+	size_t page_size;
+	void *mem;
+	int fd;
+
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
+
+	page_size = getpagesize();
+	fd = vm_create_guest_memfd(vm, page_size, 0);
+
+	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
+		   GUEST_MEMFD_PIN_TEST_OFFSET);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should return valid address");
+
+	/*
+	 * Setting up this memslot with a KVM_X86_SW_PROTECTED_VM marks all
+	 * offsets in the file as shared.
+	 */
+	vm_set_user_memory_region2(vm, GUEST_MEMFD_PIN_TEST_SLOT,
+				   KVM_MEM_GUEST_MEMFD,
+				   GUEST_MEMFD_PIN_TEST_GPA, page_size, mem, fd,
+				   GUEST_MEMFD_PIN_TEST_OFFSET);
+
+	/* Before pinning pages, toggling memory attributes should be fine. */
+	vm_mem_set_private(vm, GUEST_MEMFD_PIN_TEST_GPA, page_size);
+	vm_mem_set_shared(vm, GUEST_MEMFD_PIN_TEST_GPA, page_size);
+
+	pin_pages(mem, page_size);
+
+	/*
+	 * Pinning also faults pages in, so remove these pages from userspace
+	 * page tables to properly test that pinning blocks setting memory
+	 * attributes to private.
+	 */
+	TEST_ASSERT_EQ(madvise(mem, page_size, MADV_DONTNEED), 0);
+
+	/* Should fail since the page is still faulted in. */
+	TEST_ASSERT_EQ(__vm_set_memory_attributes(vm, GUEST_MEMFD_PIN_TEST_GPA,
+						  page_size,
+						  KVM_MEMORY_ATTRIBUTE_PRIVATE),
+		       -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	unpin_pages();
+
+	/* With the pages unpinned, kvm can set this page to private. */
+	vm_mem_set_private(vm, GUEST_MEMFD_PIN_TEST_GPA, page_size);
+
+	kvm_vm_free(vm);
+	close(fd);
+}
+
+int main(int argc, char *argv[])
+{
+	gup_test_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	/*
+	 * This test depends on CONFIG_GUP_TEST to provide a kernel module that
+	 * exposes pin_user_pages() to userspace.
+	 */
+	TEST_REQUIRE(gup_test_fd != -1);
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
+
+	run_test();
+
+	return 0;
+}
-- 
2.46.0.598.g6f2099f65c-goog


