Return-Path: <kvm+bounces-71458-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMqKDxb9m2kC+wMAu9opvQ
	(envelope-from <kvm+bounces-71458-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:09:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8091728F6
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ED033304128B
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 07:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51DAC34EEE5;
	Mon, 23 Feb 2026 07:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="je3w3GSQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9D034CFA8
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 07:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771830310; cv=none; b=mdfi/mbuwjSws+rKfiTdHBQlg2wV+G1C0j8apf9XzYgIKSNgl4MVaC0al1EeLY5hEJDPkNjg6dwlhkzWm9Sk3ZrJeIJVz1Wj+dnMQj4QTt49WDmImK8nS7vDvHTDIwe+zFR1f3L4Fa9FrdRXdBTDRP6y6mnOeasTeIeO3IXK+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771830310; c=relaxed/simple;
	bh=ea4iA5nlwgN+CFTzjyIou+eBChaZJ3B2VNlr77gxrsY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PQsYoXuzK76EWoIJqBEoCQSykBm3oorVnUAdp+xYanzkcjZYejwmZ9J1AGEwsNqDx0GA9mF9eNIqCYZT4OoAZrDdOM6OStop0n1+ZL6VygFq8Qtxo+5LpDKqQ8z9MO1AOF3sf1QouDf+S1aKeF2khq9zlDSevXQBp12SqRK8hvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=je3w3GSQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35464d7c539so3848233a91.0
        for <kvm@vger.kernel.org>; Sun, 22 Feb 2026 23:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830304; x=1772435104; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=29bxp0SrERjlT2nttg/iVluHBRhM/KYKZg8jrRhN0Y0=;
        b=je3w3GSQoCU+0acbqtQWtBrzOqtRPaSjXu1hWW8XIk9qkdODHGWfe0WpZOjhsYHAL+
         k5ahNSwIOQrm+lJH/nmA7bOEjtYYLuLluijZd2Yr0jmd1l1j3kxNAjKqab2Z1123jjY+
         wA/n52FEfu/geyjv+Tr1Bm9H5gYf2bjqMWgs9ZU0MU+2144dIJECaBvgp4duskBby2bE
         QzCZq4SVgq3fusFu1Fpov0//XzkVqNjBQbJgJjYX2DvefE4DC/lPJeoy0HcNWVNi3kje
         +T3KHXxZprkzY62UH3EboFg2CpXshkaYsaYQU+BKSjrm/OYmy0hZxXbL40lZ/4wEW9Pt
         khOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830304; x=1772435104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=29bxp0SrERjlT2nttg/iVluHBRhM/KYKZg8jrRhN0Y0=;
        b=YpbD6yq8oQdMmn3Te5sGYg5BsJdWtudhp9jqStFyostRYaac6hb38RXPOB9H8zUNWf
         XlsTQoDaecYI9Ic4Fm84Id2cBGhiJCf7N8yGt3vjNERi9XoGMUsxF4gEDiGNCbBrzwkf
         8bY7ctodSb+dJ+9Dk4onyO45PuqDno7ucQZ1fkJeX7QYIzvJe5wenDXBpKdW0MTQ/cbc
         +l0RdmBPgrPMnMzZUCNRFPhIoZi5qZDqNybJhW3VPn+65pGw7o46nade8AMdEa2fa0p8
         3bNZwZker3+aRembJbEq3P4eu0Ky40uyIikVZ25lcN61yWdt3W3NI2NSR+JRE+JwtPeo
         TGAw==
X-Forwarded-Encrypted: i=1; AJvYcCVcI7bVhTkCZVLCg8S+g4AoDjQmJfZtB66HuCXjjCHkVIIrNchiB2vjy5v4eWqG6EHaIgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRhpSdXfDah6d1hvsfWk7fe6nBpvBKgqMVRofVqEg/qvRqOGcY
	ZD0Cxil6etcp1m0a2h5COH9nDBltNNa7iN9EkwTtGUqbwnAsIagFCBQy/sZZyMcwwOEDJywLmvm
	ffnkwyM5mIhC39JRF1tRV+PRPZA==
X-Received: from pjbtb14.prod.google.com ([2002:a17:90b:53ce:b0:353:3526:238b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2b8c:b0:356:2c7b:c010 with SMTP id 98e67ed59e1d1-358ae812409mr8015127a91.11.1771830303714;
 Sun, 22 Feb 2026 23:05:03 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:42 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <3525199b4a04f0054566abe90eb99cdd5b9939e4.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 09/10] KVM: selftests: Wrap fstat() to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71458-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[30];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7E8091728F6
X-Rspamd-Action: no action

Extend kvm_syscalls.h to wrap fstat() to assert success. This will be used
in the next patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c    | 15 +++++----------
 .../testing/selftests/kvm/include/kvm_syscalls.h  |  2 ++
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
2.53.0.345.g96ddfc5eaa-goog


