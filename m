Return-Path: <kvm+bounces-71142-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wNj5HPzHk2kf8gEAu9opvQ
	(envelope-from <kvm+bounces-71142-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 02:44:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A17191486DB
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 02:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 583353004437
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 01:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CE0254B18;
	Tue, 17 Feb 2026 01:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lVP+WNez"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BBD1FF7C7
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 01:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771292648; cv=none; b=EEjs8lwzENOmKkuaVNHd+khCr4urSb4DKX5ZCmcbMA8KWs+9H0t2DUQrSujj4AEfhxsEnt/a0BdcH4nYVFxqB9P5KNQt0Zy2Nlk5pARSyuqLrWgcgQzdDlP4tTaZdH+c9M735cgVXH4h1I/g9TUnmlyVuzOlPgX8Rga16DGLuRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771292648; c=relaxed/simple;
	bh=9gALOijIBxBkf1lU8Wm58TBO8TUbib6/9i83EJ9Bnvo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zr05DK34Ktm30YhWLwXhvYEGyFlR4Az/9mM9vxDT95TRmzh7Iykpbjhz3ygifLFND0TXVELRABw+md4KXIXoI8uZ95BhrmnfSztCXmaBguH7du+wITEEMFoJ/Z3g83WUcvHxXguUTc85nqW/dB8b+M9gxG2C2/hrFj8aOlx1oW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lVP+WNez; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a944e6336eso217847065ad.0
        for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 17:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771292646; x=1771897446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0+U5Pc41BVwnFvqdSoAa/2Rz/ZDywih7O6BgvsAgYk=;
        b=lVP+WNezuprj2Wl3Oloa6H09VGoHR+xKBXtLWjdizrSnRto7PlYjviwRot733oWtNr
         0otXc6WLYykTfr/oGVPRYtvnENHJOf6hSUQREX5EnT8w1KC9u8cYzmsY4cgzBjxg3VE6
         WkaV3X4XDVoh7K4v2Y3xhmxvcqpW3Gl45b/iHPcOwX46hmjFOylgdJkzfdW5ogPw8wK7
         0IWKhMBoVBUj41nAF8SeiYMQsd7KU2sW6O5kL+qZF7Vghgg4IrHf23fazanXYDiaDJYg
         iHSWjQJnFokGNcSJC3oysrO81SAKmR2iRofrUfywpY16/WdplNfh3q0Kdf7VZ+Sw5nTB
         W9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771292646; x=1771897446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0+U5Pc41BVwnFvqdSoAa/2Rz/ZDywih7O6BgvsAgYk=;
        b=Hthh3GRGPusrfuBKyF4Yn9FZOwY9rbtiEgX3fu9R216fNldDLtcuV4C6nPLUdM9po2
         oicERrA0vuBCkC+d82jYz9KA1KnPRTRC61Fkt9ZF8op3NrVuX0aVRsU4oI6+Sgogn/jz
         b2XQ4EbTveo7F2D+zUZ+ANMeKjFd0d0ObsNwiYs7r3ux/8JCpztDg8JRJMgfO0Y5TR2E
         3AgqGYnDF3RyxRO0EdvtXftyfQgLYwEzKnPw3NPinxJ7MqZIn1VhQzZYplpKW178SqVS
         DTiGqjJSudFoj7BNZRbCFQJIQo32pm+5dVHrCjzM5eWNDEg8YMKO36F3Ltu19f2hwkXr
         RVTg==
X-Forwarded-Encrypted: i=1; AJvYcCUrNoNqSOYjqQSYhzxBrWStCeMy9iIfIxCQa1FyQOaN7yPwk4DfxF+tRMvObYUI6qkQAzU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzooZ5piPDejNJrJMmWtrmNlnRaadceA2abTpoUdyRjeNydtmCz
	AC4PGfut4bz44ZUxoUG7+/NQzw/D0hdpDJ9tObaskth84zClU2NHPr6pLGRLwJbkkEo20HxdY8m
	T1wuiy/QZ3ZWEdSaMFW1A8JENig==
X-Received: from plqu18.prod.google.com ([2002:a17:902:a612:b0:2a7:8c71:aa97])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e943:b0:2ab:2311:e4fc with SMTP id d9443c01a7336-2ab50603a4amr130385745ad.56.1771292645552;
 Mon, 16 Feb 2026 17:44:05 -0800 (PST)
Date: Tue, 17 Feb 2026 01:44:02 +0000
In-Reply-To: <20260214001535.435626-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214001535.435626-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217014402.2554832-1-ackerleytng@google.com>
Subject: [PATCH] KVM: selftests: Test MADV_COLLAPSE on GUEST_MEMFD
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71142-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,google.com,redhat.com,kernel.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[google.com,oracle.com,linux-foundation.org,kernel.org,linux.alibaba.com,arm.com,maskray.me,linux.dev,vger.kernel.org,kvack.org,redhat.com,gmail.com,syzkaller.appspotmail.com,nvidia.com];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A17191486DB
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
 .../testing/selftests/kvm/guest_memfd_test.c  | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90f..d16341a4a315d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -171,6 +171,77 @@ static void test_numa_allocation(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+static size_t getpmdsize(void)
+{
+	const char *path = "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size";
+	static size_t pmd_size = -1;
+	FILE *fp;
+
+	if (pmd_size != -1)
+		return pmd_size;
+
+	fp = fopen(path, "r");
+	TEST_ASSERT(fp, "Couldn't open %s to read PMD size.", path);
+
+	TEST_ASSERT_EQ(fscanf(fp, "%lu", &pmd_size), 1);
+
+	TEST_ASSERT_EQ(fclose(fp), 0);
+
+	return pmd_size;
+}
+
+static void test_collapse(struct kvm_vm *vm, uint64_t flags)
+{
+	const size_t pmd_size = getpmdsize();
+	char *mem;
+	off_t i;
+	int fd;
+
+	fd = vm_create_guest_memfd(vm, pmd_size * 2,
+				   GUEST_MEMFD_FLAG_MMAP |
+				   GUEST_MEMFD_FLAG_INIT_SHARED);
+
+	/*
+	 * Use aligned address so that MADV_COLLAPSE will not be
+	 * filtered out early in the collapsing routine.
+	 */
+#define ALIGNED_ADDRESS ((void *)0x4000000000UL)
+	mem = mmap(ALIGNED_ADDRESS, pmd_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_SHARED, fd, 0);
+	TEST_ASSERT_EQ(mem, ALIGNED_ADDRESS);
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
+	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_HUGEPAGE), 0);
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
+	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_DONTNEED), 0);
+	READ_ONCE(mem[0]);
+
+	kvm_munmap(mem, pmd_size);
+	kvm_close(fd);
+}
+
 static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 {
 	const char val = 0xaa;
@@ -370,6 +441,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
+			test_collapse(vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
-- 
2.53.0.273.g2a3d683680-goog


