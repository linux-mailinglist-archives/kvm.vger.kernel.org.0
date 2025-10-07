Return-Path: <kvm+bounces-59607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7CCBC2D77
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BEC819A2735
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047F22765E3;
	Tue,  7 Oct 2025 22:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FLWPwpq8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374EF25A2A2
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875299; cv=none; b=g9DsIBop7AsdpVx9V5bByZF4oc71VD1Zqpdb9rdTt/ym9xiSD+ZrSmNPSfE7vyv9Lqs8DvA5gi9c3upSC6cbhVXlD51A/1HF1XDa+j4KwjjIB6uTTJ16EiI+DZvo+4rkTTY/3iUCr48dc+txCj+hqvqC1td6zMYtheDrjQ7Jwq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875299; c=relaxed/simple;
	bh=CDrOrMNO9l5cLoWd98CveZ7KTkfm+YOe4TpGJ/Wt4fA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=taofAPGM4A4hoyolH/CjDHg3t9x2RU9FUKvimNtQTVjzY3uJIA0n+wXoKn3vIgPN49jt/33C0GWyMqn4eNgUlEqrnGsFZi7jLHeY5U7w0mAtASBkxCDuwK99IfIfjbh5Bg3t5yQoVPT6PCH0/xWiiGbqyMwDZoOLyztaBCnmcys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FLWPwpq8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so6323500a91.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875296; x=1760480096; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pq3jKNyKi/1WXgeEr4Kt/LxPicRmmT3+M3Z6Wud5iC8=;
        b=FLWPwpq8qHzErasoo0s+GiCDnuNienIoDh3KHs2K9VzAVAtpG8pMjwLOlOO4PbKkA+
         HZbw51XqkuHfXX7Jr6XQsgtq6a3Klbx+IKrhcepWh/MengsZhfuqLhcklu1SnSW7+XzF
         Bk2X/EtNrU0cAAccKOgXNxF1T64b/LZq8+L89c6lxTsUc5VtR5bWXl4CqM+DdWOm0JzV
         FYaSOq/Bo8hQ8ghkMbaJc68C4urD6ZH/lE1aDj6FkLwhVLbzKMmhEilHKglQyaaX53k9
         hqjvrMKyI1UFXFqQjB7stZINuWSlXVzkkrf82pfbhxpHZ3tQxoJDTzNYZf5+bp1kVXOT
         zJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875296; x=1760480096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pq3jKNyKi/1WXgeEr4Kt/LxPicRmmT3+M3Z6Wud5iC8=;
        b=evO1Xn6G2iPkQHcwAvtSgZPzLh8GWs6Fdd7By3ObIned3B24RUMGfh6NIAVv72nxCn
         BvN+hIfKIrR2qtLszT4r/H3wnmqg+uUUfwyqBqvWnoCycoMubGiHvX/5kqayZun0FXCx
         F5toa3Qxd/jxvzvRy3/CiGBJS+Jmmz8SN2ujHBO38Ngnj80yOR8vz4B3vYMpMIEmxOV1
         0+pFRzp5Llq9HxDf2uPRVfhaLlADgp53lAwkSZ097u46BCgABUttWuN/gTD3YgALwTCI
         +ahhJ1Fzp2Yuh53f9b6IVDX4gHhpp8+JI8tELwCWNcskjT2PaF3SEPytQbBEQ8b4sB4b
         tFlA==
X-Forwarded-Encrypted: i=1; AJvYcCX3aVvGKUYjBFdeVsJOFlp3QcWLcTwQCbnkl3EnDaudehEmkVGKHEB5Z0xMQciV7cdAARM=@vger.kernel.org
X-Gm-Message-State: AOJu0YybW5EhcNIpzGKDLuFYuEXRNMAkg+X2hj48P9jSQ/r8jv1adi7L
	WgPruEHd3XYZ/FKUIYluH5ul36yG07Qfo8Fkyw+WJc0Ds3xjJk08nUFBVPGT6XqqqIFOnoL6bxo
	OoA4sPA==
X-Google-Smtp-Source: AGHT+IFr1z+OHs2pqkHxNhtbO8xQGrGNQletDRxpDZROHoK8rGfdZgYkQaGuDGapxPz1ninSCtdpRZhLQBs=
X-Received: from pjbmw12.prod.google.com ([2002:a17:90b:4d0c:b0:329:b272:45a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b4c:b0:327:9e88:7714
 with SMTP id 98e67ed59e1d1-33b513ebf89mr1315059a91.37.1759875296568; Tue, 07
 Oct 2025 15:14:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:19 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-12-seanjc@google.com>
Subject: [PATCH v12 11/12] KVM: selftests: Add guest_memfd tests for mmap and
 NUMA policy support
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
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

Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
[sean: don't skip entire test when running on non-NUMA system, test mbind()
       with private memory, provide more info in assert messages]
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
2.51.0.710.ga91ca5db03-goog


