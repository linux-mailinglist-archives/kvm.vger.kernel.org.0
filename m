Return-Path: <kvm+bounces-71806-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mIThEIWmnmmrWgQAu9opvQ
	(envelope-from <kvm+bounces-71806-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:36:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DCAB51938C2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EEF9331C38D3
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F30B2D77FA;
	Wed, 25 Feb 2026 07:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kl49/QXT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5E131B82B
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772004056; cv=none; b=B/z/zrqRFzdDw0kn3w/27lathR1uGPk6rd5vYexfDLIL+Pq8AAVjxg7hei6IXbzd2DzwFexYt5Uo3YnWz7Pdx81RvDnbRcRnQrdGCuqTeOpc1ClZO3PTNHTKqe44aLQZOVgxPRCeoWXmpRu0t/tPZpzyZm+ESk4eb2mHqXCIQRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772004056; c=relaxed/simple;
	bh=41+6neAL0d27ks2wQws7sEuDZgQjzT5nG62AnxD5qpc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jQ/s68dnCiqvLpHNjP89eBoT53s4mHQelipJlVAu+c20Tb7YjZPyn6++EZdlo/bOT4jWZL5FLmNWIMfdkgdI4xOTmXEp13PDs6BXWdUbBX5gt7SKUCrjuaGhpNxINqveI4V3ck/Rbi+WofL5zROYHdQfHZJlqRumgUNKcJKr6mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kl49/QXT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso6368691a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 23:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004053; x=1772608853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lmqeDy1YGPO6heAH4dtg7V9yIhQw7gZPhshB9Ud1SBU=;
        b=kl49/QXTyHNtzK3awy/yDH8SdYKO5eimqBUQi+UII5h9a9SBFLxjantR3qhGW+uYd8
         mYgQLJVaw0XA6/AV9emQXbYPTYlV4sNCnCj3XUCI8QdJcRtMWv3kYRCiSsZJ+1hV9Hcp
         hBuwHtRnVIszSeYM465KYcCumfhasyjWMat+2JnYCcBAWI9Rl9AhupAbcrc5jdp6chno
         TxlQX9RNq5CXzsQ72qm7LnUK7P286lheZHu9aVJULLBDqjMAokM6/p/U9zeINILNcUMH
         2+ZPyG4CREVQWJ2erErVhEeUsY2SCnGFCAojzxw/ZLnUtQgiogxK004UD809ZrIm8z1j
         b3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004053; x=1772608853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmqeDy1YGPO6heAH4dtg7V9yIhQw7gZPhshB9Ud1SBU=;
        b=s89ID+iI4lzK3qEmlTDuEVXJTbEiTHbRDoBR+94HZW5qhOKDRYd9vXLq71lFRw6HzW
         LqZiLdUqnQjSAGVaqCQrqK4Utx1q60w8WOZEmvAJgp4H7C2vOAiRmVeLhYnoe8dJN9T4
         ZQKrpejrMAXc7XweQXwq/mWXavnNqT8vQ9L8RA8riojq+K6hAwylBFkrvvNYJ7TPPSJ9
         tNyFlBihapAP0wGXJ/uYFGOgOxPwcSeNMi6EYeaw5h0+wfoLIYgwv3q8WGIRtDJpwuL1
         u2pgFPJ+GtfiMVDwICckSBSB5m2oksz6jWuA5mDF8WSP0yh8/lCaBZO/JCXjw/uXTsUN
         s06g==
X-Gm-Message-State: AOJu0YzJIKSghfOMn9aQtxy7uOs6geVxsOp7XDYrlYNSsX5Q/1ORu+a6
	SZaysvIURZfdsmgmW1xrdVZ6Rlgw+WTk0JwDD6hpaHtWugPuc7kICJtyug7FmDpPydVUngn28ay
	n8Qt+PewA7eKp9XxXNyZ7JW5XLA==
X-Received: from pgbfp5.prod.google.com ([2002:a05:6a02:2ce5:b0:c0e:c1b4:51a5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7f89:b0:394:58eb:48fa with SMTP id adf61e73a8af0-39545dc0482mr14694770637.6.1772004052747;
 Tue, 24 Feb 2026 23:20:52 -0800 (PST)
Date: Wed, 25 Feb 2026 07:20:40 +0000
In-Reply-To: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772004043; l=3022;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=41+6neAL0d27ks2wQws7sEuDZgQjzT5nG62AnxD5qpc=; b=Qf0H2UQ2mVaGwE9fmA4IWjbnRJGJ7WGDq8UI2QM5uIsOM4kNu9y1rdgzh53H+jjev44oOi+/r
 kT+aePH4Im8Br8uVg3C6xnPFChAqWmmulNjoE70K9V+ksKWXjrvsGjL
X-Mailer: b4 0.14.3
Message-ID: <20260225-gmem-st-blocks-v2-5-87d7098119a9@google.com>
Subject: [PATCH RFC v2 5/6] KVM: selftests: Wrap fstat() to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71806-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_TWELVE(0.00)[35];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: DCAB51938C2
X-Rspamd-Action: no action

Extend kvm_syscalls.h to wrap fstat() to assert success. This will be used
in the next patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c     | 15 +++++----------
 tools/testing/selftests/kvm/include/kvm_syscalls.h |  2 ++
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90f..81387f06e770a 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -212,10 +212,8 @@ static void test_mmap_not_supported(int fd, size_t total_size)
 static void test_file_size(int fd, size_t total_size)
 {
 	struct stat sb;
-	int ret;
 
-	ret = fstat(fd, &sb);
-	TEST_ASSERT(!ret, "fstat should succeed");
+	kvm_fstat(fd, &sb);
 	TEST_ASSERT_EQ(sb.st_size, total_size);
 	TEST_ASSERT_EQ(sb.st_blksize, page_size);
 }
@@ -303,25 +301,22 @@ static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
 
 static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 {
-	int fd1, fd2, ret;
+	int fd1, fd2;
 	struct stat st1, st2;
 
 	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
 	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
 
-	ret = fstat(fd1, &st1);
-	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	kvm_fstat(fd1, &st1);
 	TEST_ASSERT(st1.st_size == page_size, "memfd st_size should match requested size");
 
 	fd2 = __vm_create_guest_memfd(vm, page_size * 2, 0);
 	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
 
-	ret = fstat(fd2, &st2);
-	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	kvm_fstat(fd2, &st2);
 	TEST_ASSERT(st2.st_size == page_size * 2, "second memfd st_size should match requested size");
 
-	ret = fstat(fd1, &st1);
-	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	kvm_fstat(fd1, &st1);
 	TEST_ASSERT(st1.st_size == page_size, "first memfd st_size should still match requested size");
 	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
 
diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index d4e613162bba9..3f039c34e12e0 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_SYSCALLS_H
 #define SELFTEST_KVM_SYSCALLS_H
 
+#include <sys/stat.h>
 #include <sys/syscall.h>
 
 #define MAP_ARGS0(m,...)
@@ -77,5 +78,6 @@ __KVM_SYSCALL_DEFINE(munmap, 2, void *, mem, size_t, size);
 __KVM_SYSCALL_DEFINE(close, 1, int, fd);
 __KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, len);
 __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
+__KVM_SYSCALL_DEFINE(fstat, 2, int, fd, struct stat *, buf);
 
 #endif /* SELFTEST_KVM_SYSCALLS_H */

-- 
2.53.0.414.gf7e9f6c205-goog


