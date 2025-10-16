Return-Path: <kvm+bounces-60193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1618EBE4DCD
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B8082507BFA
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4696F34575B;
	Thu, 16 Oct 2025 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Auifua72"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B084B340DB1
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635830; cv=none; b=LMAcz8FPVaSuJ68/5ClJoPdXD8UgsyDHG8RslOVwW4cmyj/F+h1B+x85+C3Lt41tHoVLnES7/HuoYlXZc55iJsaxGLlV9RnAOE6ssTVemM9T0jyN/sOn2nV11s6539am2Gw+lS3hr2+wpwGd5M1SSnF8jVWbbrrmMJOom+2O3VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635830; c=relaxed/simple;
	bh=C2oacOVaYmakYuuj01sv0kUdLX8KmQYOY8HvA7F3pWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pcMRjbdo12WF5jj0Ec/u8g2YhFlkDPP1TEJO3m9Z+DgO/WsfUT0bnkST7r68/k5SHtoX2qYm8SHgVhpp5hp2Ek+IPh6Dp2HyRb5WztF2jGtar1k/KraIUCAHzCnzSdTFxm7xvGP8XVWMaIXz0H0Vythou8AE9DQEa0M4A+zMKEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Auifua72; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-272ed8c106eso6966145ad.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635828; x=1761240628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RviFSJTeDXrAnxp03nizg0uEL1EB4BJAqQICQBGlk4U=;
        b=Auifua72X2vwTv8JgEizsVVJvaoer5KZqGa2aNgCC/T3MtIb+oCxPCtyluUAjlArtS
         +p12hQWkKaaSZ5/BMzFbF3ZiholHdVKnm12X0vghNCD2JsAXJTl0z9cL+rUVboG+ypHN
         lKmvKw5ZqQ7wr+oZ7bKUcestkswKaJL5yfsFdsJvPUdlpESImGV6vcqxxO7mQRo/rSey
         lvtYm9RyVTjPUsP6DrY88KGqC5ExMlfC4+FFqQXcqiD9+UoPjPdK6RQGdyU2vdOmbQ8R
         eaoHrZ4wX+Ods4086+uwN3zvoo0BGg7XIAQMs5EADZbe95mjPP2Mqiu/hRc+uJKoPzNZ
         Q31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635828; x=1761240628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RviFSJTeDXrAnxp03nizg0uEL1EB4BJAqQICQBGlk4U=;
        b=jHtziWwVEyOysaQXleWSRejcAtBaGyxxkh51xUVRv6lCrjsCmt4PmhlkFY4BkDLqnr
         e/fgUO60aFMGpkmq5wu/WQeuW789YkhTjHsqepECyGB8Dn1Dus3QyBhw7TmybT2EbYFT
         eW0GeJDc61bebRYDO+a7vzJCiHIWrL4wnYVA8rHtWcqHZ3pob9nQRj0R2DjeM3ZMBC1D
         adhJYoVouLT2/QG6dpoKMzDud6o97GKj7bbMSGw0S/GJPxm52Xz92kgGTgIBW7TYizji
         q9w7oiSoSHg8VMp3hjDJKX46+LW2UNlJK0PBzV1xwI/B1FgBK/Rq28LBwKoYsMnxxLo4
         +axw==
X-Forwarded-Encrypted: i=1; AJvYcCUigbAw24bowkyr5r4PA8C/EPC/R9YGaUZXT8KKXAXCoN5AvcS5zzFupuPEV+rXjqBsm/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4fcLvltfTvXcg9fbZBmc/e5uSVgbR24xCo/gJRvvTs2ejkXBE
	+RARNxdjLFs/qI/myFI8znKF5jXhOTB5mpMDL9xTf2zOyO8hT6oNDNUbQ85PTiOpJliO5ETWE1A
	Zw0wviw==
X-Google-Smtp-Source: AGHT+IF/2wryDBFn3Vm/ZItHrOO8Cutyh10iJkyo92xaEeL3XVP9OxJeQvoekCLXXPfR84HIRIYnmu6+FJY=
X-Received: from plsq3.prod.google.com ([2002:a17:902:bd83:b0:27e:ec80:30c6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b8b:b0:24c:ed95:2725
 with SMTP id d9443c01a7336-290c9c89badmr7138805ad.4.1760635828021; Thu, 16
 Oct 2025 10:30:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:52 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-12-seanjc@google.com>
Subject: [PATCH v13 11/12] KVM: selftests: Add guest_memfd tests for mmap and
 NUMA policy support
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Shivank Garg <shivankg@amd.com>

Add tests for NUMA memory policy binding and NUMA aware allocation in
guest_memfd. This extends the existing selftests by adding proper
validation for:
  - KVM GMEM set_policy and get_policy() vm_ops functionality using
    mbind() and get_mempolicy()
  - NUMA policy application before and after memory allocation

Run the NUMA mbind() test with and without INIT_SHARED, as KVM should allow
doing mbind(), madvise(), etc. on guest-private memory, e.g. so that
userspace can set NUMA policy for CoCo VMs.

Run the NUMA allocation test only for INIT_SHARED, i.e. if the host can't
fault-in memory (via direct access, madvise(), etc.) as move_pages()
returns -ENOENT if the page hasn't been faulted in (walks the host page
tables to find the associated folio)

[sean: don't skip entire test when running on non-NUMA system, test mbind()
       with private memory, provide more info in assert messages]

Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index e7d9aeb418d3..618c937f3c90 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -19,6 +19,7 @@
 #include <sys/stat.h>
 
 #include "kvm_util.h"
+#include "numaif.h"
 #include "test_util.h"
 #include "ucall_common.h"
 
@@ -75,6 +76,101 @@ static void test_mmap_supported(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+static void test_mbind(int fd, size_t total_size)
+{
+	const unsigned long nodemask_0 = 1; /* nid: 0 */
+	unsigned long nodemask = 0;
+	unsigned long maxnode = 8;
+	int policy;
+	char *mem;
+	int ret;
+
+	if (!is_multi_numa_node_system())
+		return;
+
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+
+	/* Test MPOL_INTERLEAVE policy */
+	kvm_mbind(mem, page_size * 2, MPOL_INTERLEAVE, &nodemask_0, maxnode, 0);
+	kvm_get_mempolicy(&policy, &nodemask, maxnode, mem, MPOL_F_ADDR);
+	TEST_ASSERT(policy == MPOL_INTERLEAVE && nodemask == nodemask_0,
+		    "Wanted MPOL_INTERLEAVE (%u) and nodemask 0x%lx, got %u and 0x%lx",
+		    MPOL_INTERLEAVE, nodemask_0, policy, nodemask);
+
+	/* Test basic MPOL_BIND policy */
+	kvm_mbind(mem + page_size * 2, page_size * 2, MPOL_BIND, &nodemask_0, maxnode, 0);
+	kvm_get_mempolicy(&policy, &nodemask, maxnode, mem + page_size * 2, MPOL_F_ADDR);
+	TEST_ASSERT(policy == MPOL_BIND && nodemask == nodemask_0,
+		    "Wanted MPOL_BIND (%u) and nodemask 0x%lx, got %u and 0x%lx",
+		    MPOL_BIND, nodemask_0, policy, nodemask);
+
+	/* Test MPOL_DEFAULT policy */
+	kvm_mbind(mem, total_size, MPOL_DEFAULT, NULL, 0, 0);
+	kvm_get_mempolicy(&policy, &nodemask, maxnode, mem, MPOL_F_ADDR);
+	TEST_ASSERT(policy == MPOL_DEFAULT && !nodemask,
+		    "Wanted MPOL_DEFAULT (%u) and nodemask 0x0, got %u and 0x%lx",
+		    MPOL_DEFAULT, policy, nodemask);
+
+	/* Test with invalid policy */
+	ret = mbind(mem, page_size, 999, &nodemask_0, maxnode, 0);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "mbind with invalid policy should fail with EINVAL");
+
+	kvm_munmap(mem, total_size);
+}
+
+static void test_numa_allocation(int fd, size_t total_size)
+{
+	unsigned long node0_mask = 1;  /* Node 0 */
+	unsigned long node1_mask = 2;  /* Node 1 */
+	unsigned long maxnode = 8;
+	void *pages[4];
+	int status[4];
+	char *mem;
+	int i;
+
+	if (!is_multi_numa_node_system())
+		return;
+
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+
+	for (i = 0; i < 4; i++)
+		pages[i] = (char *)mem + page_size * i;
+
+	/* Set NUMA policy after allocation */
+	memset(mem, 0xaa, page_size);
+	kvm_mbind(pages[0], page_size, MPOL_BIND, &node0_mask, maxnode, 0);
+	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, page_size);
+
+	/* Set NUMA policy before allocation */
+	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
+	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
+	memset(mem, 0xaa, total_size);
+
+	/* Validate if pages are allocated on specified NUMA nodes */
+	kvm_move_pages(0, 4, pages, NULL, status, 0);
+	TEST_ASSERT(status[0] == 1, "Expected page 0 on node 1, got it on node %d", status[0]);
+	TEST_ASSERT(status[1] == 1, "Expected page 1 on node 1, got it on node %d", status[1]);
+	TEST_ASSERT(status[2] == 0, "Expected page 2 on node 0, got it on node %d", status[2]);
+	TEST_ASSERT(status[3] == 0, "Expected page 3 on node 0, got it on node %d", status[3]);
+
+	/* Punch hole for all pages */
+	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
+
+	/* Change NUMA policy nodes and reallocate */
+	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
+	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
+	memset(mem, 0xaa, total_size);
+
+	kvm_move_pages(0, 4, pages, NULL, status, 0);
+	TEST_ASSERT(status[0] == 0, "Expected page 0 on node 0, got it on node %d", status[0]);
+	TEST_ASSERT(status[1] == 0, "Expected page 1 on node 0, got it on node %d", status[1]);
+	TEST_ASSERT(status[2] == 1, "Expected page 2 on node 1, got it on node %d", status[2]);
+	TEST_ASSERT(status[3] == 1, "Expected page 3 on node 1, got it on node %d", status[3]);
+
+	kvm_munmap(mem, total_size);
+}
+
 static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 {
 	const char val = 0xaa;
@@ -273,11 +369,13 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
+			gmem_test(numa_allocation, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
 
 		gmem_test(mmap_cow, vm, flags);
+		gmem_test(mbind, vm, flags);
 	} else {
 		gmem_test(mmap_not_supported, vm, flags);
 	}
-- 
2.51.0.858.gf9c4a03a3a-goog


