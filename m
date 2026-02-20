Return-Path: <kvm+bounces-71431-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECLqKZX0mGkaOgMAu9opvQ
	(envelope-from <kvm+bounces-71431-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:56:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E2FA16B75A
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A0843099140
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B46318EF9;
	Fri, 20 Feb 2026 23:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qoE+6pNO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4595E316912
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 23:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771631687; cv=none; b=oOSQKMGEQvG3+6MDp02Bv/suLpw9ZORxqOEZM0hj16ib0ZTHYgNI6c/GJYmn2lPhRMO+vAFGu8jYajbQZSD2RNvK3ib2At6sbKDhN8uKyJGDmBkDZOTUOc6H4wLgOzS6KfHfgN2Pwc5qg+F6kXNNyPUMpzODUjcHGX5y5BID6ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771631687; c=relaxed/simple;
	bh=xQmQKRSPkBcxt00vHcqWtQXUDsYhNrAym2RYyWUg24I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WHxjofAraaLBJtoNqvMvyDT3hEcRCrdifBuc5irTdnf/59sbTYLQAXMbm9v4kkElBeyBN1IVW+/NJMYfIYqgmGvNrgjLRjawsZTp4qReMlsNG0kEgnHlrdn6zJMQUmO04AaGJWRLaoJaxKubZWko6US4kIkEhAqJf8bEmtl8C7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qoE+6pNO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-824ae2c9ff4so8659649b3a.0
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 15:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771631686; x=1772236486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9n+rIu6TMqcCjcRNbiRVZNUoVIfjXuiOSfksLOomjk=;
        b=qoE+6pNOvS/ZI0NNxvdrAFIf0hO7DnsYTxcfI+eyG16jewTBVNDXf/N/WGLB9CVndG
         EJfC9TldM9kDI82Nq7m6u+TxGE2JQGDM5WBUdCcb9psiha36QVquYsncNlj137DuwwvI
         X6PCVJJdM9VWu1Ytp7W+f1xToOw8W55CDHs/2EGAs1M5TdyLnSZ8wToQE0JlQt18LU/o
         kjfktnsi0YzNdA+LA+AHxA0jQqx+Lms8PgK8jp/geP5568ctBFYNbwfx4S/EQiFCv52b
         RLeHzmtr2SC/SEJsnUfawnklqxDfCmJO1iWEXibRf/5iLW/3Qj66pz3prNJMm8XebG2U
         Wiqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771631686; x=1772236486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9n+rIu6TMqcCjcRNbiRVZNUoVIfjXuiOSfksLOomjk=;
        b=a1y68a83ue+qlsgvLmW5rplPr2tClwa4b2+TXRW7Vg6r0Jysdn5jhqzm5pYmWzQRIT
         9OBWBnaJvHLN9mmWHn93lEEVYUKDClEQmpMSZeS4DAdIINCnAfm9RSIl6Feu2tumUF46
         oFFz7o+Sc0khnor+g7TQ1LZPmntQEwdRQ+JMoMM/0rCHTFI/hxS9JrtkhwSAIXTbd1AF
         EeY/pB1R/HOpPxMTZR5lC/01n9dhvKJxPMhg7DzqFIqvlV4pgHESK6SmkxqkOcbVLxrf
         cggAN+LFJEJtUL/bqw1g5u86uKVH8tPqX8eVJe7TzehA5SSlHsM29w0HGM/Wc95L7W1X
         eudQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLIx6e+UbmQIYPIiMBxP1pWKHXwrRpSm8iRYffs78TfIFra1lWWrf09Cl7agqrcSJNkP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEsIFDVTe8XAtnbrBKKQcWM1xhP70Lyo8RavGhrZwMHiGrjyu7
	sD2daa6a+9pNpzAF2z1uECCIhrIMGV6EFnK+Rsgf8PcKUqrq7VltGTN32zuKPIz1WbzM1DwnKEK
	DiM2CPNDgokZldwqRdhI14/1T3Q==
X-Received: from pfbjo15.prod.google.com ([2002:a05:6a00:908f:b0:824:bfe3:b54e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:b92:b0:81f:b3ce:17a3 with SMTP id d2e1a72fcca58-826daa20081mr1165866b3a.48.1771631685524;
 Fri, 20 Feb 2026 15:54:45 -0800 (PST)
Date: Fri, 20 Feb 2026 23:54:36 +0000
In-Reply-To: <cover.1771630983.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1771630983.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <8048d04f150326d1e2231318aa9f1b3fce3e2e2c.1771630983.git.ackerleytng@google.com>
Subject: [PATCH v2 2/2] KVM: selftests: Test MADV_COLLAPSE on guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: kartikey406@gmail.com, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: vannapurve@google.com, Liam.Howlett@oracle.com, ackerleytng@google.com, 
	akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, i@maskray.me, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, shy828301@gmail.com, 
	stable@vger.kernel.org, syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-71431-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,google.com,redhat.com,kernel.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[google.com,oracle.com,linux-foundation.org,kernel.org,linux.alibaba.com,arm.com,maskray.me,linux.dev,vger.kernel.org,kvack.org,redhat.com,gmail.com,syzkaller.appspotmail.com,nvidia.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,syzkaller.appspot.com:url]
X-Rspamd-Queue-Id: 0E2FA16B75A
X-Rspamd-Action: no action

guest_memfd only supports PAGE_SIZE pages, and khugepaged or MADV_COLLAPSE
collapsing pages may result in private memory regions being mapped into
host page tables.

Add test to verify that MADV_COLLAPSE fails on guest_memfd folios, and any
subsequent usage of guest_memfd memory faults in PAGE_SIZE folios. Running
this test should not result in any memory failure logs or kernel WARNings.

This selftest was added as a result of a syzbot-reported issue where
khugepaged operating on guest_memfd memory with MADV_HUGEPAGE caused the
collapse of folios, which then subsequently resulted in a WARNing.

Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 70 ++++++++++++++++++-
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90f..0edbc7cf6c1ad 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -171,6 +171,64 @@ static void test_numa_allocation(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+static void test_collapse(int fd, uint64_t flags)
+{
+	const size_t pmd_size = get_trans_hugepagesz();
+	void *reserved_addr;
+	void *aligned_addr;
+	char *mem;
+	off_t i;
+
+	/*
+	 * To even reach the point where the guest_memfd folios will
+	 * get collapsed, both the userspace address and the offset
+	 * within the guest_memfd have to be aligned to pmd_size.
+	 *
+	 * To achieve that alignment, reserve virtual address space
+	 * with regular mmap, then use MAP_FIXED to allocate memory
+	 * from a pmd_size-aligned offset (0) at a known, available
+	 * virtual address.
+	 */
+	reserved_addr = kvm_mmap(pmd_size * 2, PROT_NONE,
+				 MAP_PRIVATE | MAP_ANONYMOUS, -1);
+	aligned_addr = align_ptr_up(reserved_addr, pmd_size);
+
+	mem = mmap(aligned_addr, pmd_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_SHARED, fd, 0);
+	TEST_ASSERT(IS_ALIGNED((u64)mem, pmd_size),
+		    "Userspace address must be aligned to PMD size.");
+
+	/*
+	 * Use reads to populate page table to avoid setting dirty
+	 * flag on page.
+	 */
+	for (i = 0; i < pmd_size; i += getpagesize())
+		READ_ONCE(mem[i]);
+
+	/*
+	 * Advising the use of huge pages in guest_memfd should be
+	 * fine...
+	 */
+	kvm_madvise(mem, pmd_size, MADV_HUGEPAGE);
+
+	/*
+	 * ... but collapsing folios must not be supported to avoid
+	 * mapping beyond shared ranges into host userspace page
+	 * tables.
+	 */
+	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_COLLAPSE), -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	/*
+	 * Removing from host page tables and re-faulting should be
+	 * fine; should not end up faulting in a collapsed/huge folio.
+	 */
+	kvm_madvise(mem, pmd_size, MADV_DONTNEED);
+	READ_ONCE(mem[0]);
+
+	kvm_munmap(reserved_addr, pmd_size * 2);
+}
+
 static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 {
 	const char val = 0xaa;
@@ -350,14 +408,17 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	}
 }
 
-#define gmem_test(__test, __vm, __flags)				\
+#define __gmem_test(__test, __vm, __flags, __gmem_size)			\
 do {									\
-	int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);	\
+	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
 									\
-	test_##__test(fd, page_size * 4);				\
+	test_##__test(fd, __gmem_size);					\
 	close(fd);							\
 } while (0)
 
+#define gmem_test(__test, __vm, __flags) 				\
+	__gmem_test(__test, __vm, __flags, page_size * 4)
+
 static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 {
 	test_create_guest_memfd_multiple(vm);
@@ -367,9 +428,12 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
+			size_t pmd_size = get_trans_hugepagesz();
+
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
+			__gmem_test(collapse, vm, flags, pmd_size);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
-- 
2.53.0.345.g96ddfc5eaa-goog


