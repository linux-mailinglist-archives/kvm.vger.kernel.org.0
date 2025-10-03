Return-Path: <kvm+bounces-59488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3B26BB8655
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8151219E4FD6
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EC72E173E;
	Fri,  3 Oct 2025 23:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sS5C0DtV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BA82E090E
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533995; cv=none; b=gXcM+cXsIsoFGhFTlfRp2J1bbqHFSCqh6FpI4LvTFn4dUZo7V5miS/eloQjkDrGw7qIkY9rAK7LJeAMXOcVeTeqzJr1byGoj4mh205z6Aik3d0VIv2wcsyZU1N2i/MapQ13WneNBaIPKnNOiLyWCne91imPgKHMDgzmrK/6Jg7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533995; c=relaxed/simple;
	bh=6uqrO3Vhg7mkad1zptZdqvbuIbBUIta4UqDjm7wBzuk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dRS92feCJpsSa49cAazQxZPGcPKi0S+VlFJdqA5et+BCc6fjvZbJTVAjTyJm0m6gZdYXvm3tfJ1B9GC4xERVasT2kfewCc+s+4jkaqSfi/625LVEf87wuTm2012fgYBJI/nexBQQxGUj3+sEww/NP+iUzBHi5PJNmrXe/Tf2MlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sS5C0DtV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ea7fcddd8so5688621a91.3
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533993; x=1760138793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Yy7lp5RaPXPHpRWe5+i+QNM7MtRBx8dgxw3nVvMM/XM=;
        b=sS5C0DtV91YaNxs/8pEmZ2mzemHL3T/GI879dnRQnvd1nEWLcOqbkIS+ylDPAUnz26
         DmeF6JgGlGrJXyp0WdCKHwFfP4Y7EbFPR8PSnTxgWgrd21wx7nETs9C8JnBMnYLHOWBZ
         aQL0o+M7wiBV2NroiOLev9FoJ0rUBtctkT+CmJQ14qAUFD/TgoOi22W98otLpejTtXG6
         sh96O8pHTEv+WGokHF8aMGQgSBK7EP2HwAyj3OV9u6FVrWwz9bNkJ2u0STu0aBgCgm1o
         2jyzebq1Asy20UDPnWTP8Ttzdw0JJIGqRNVarvAfhPj0fknBoW++6Hckbu5Jm/WRwalZ
         8vaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533993; x=1760138793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yy7lp5RaPXPHpRWe5+i+QNM7MtRBx8dgxw3nVvMM/XM=;
        b=cSrWVl7ItL56M5RpErep3ft6dFLV4rsahiKkdGXetB+2KuLi8XKxpDZqvDpjYJqqDt
         tY1b3L7aiOiP9F/9dgxTzwoLL6J8gTZlTIYOZ4CEl5Xyv/fmVQBlNS/vkhqjBcFIksgH
         u7fGfI0Ysn2tPeHSOzlhrHNA1HWIxoKXWeG7W09mimhlcjlq4GreVpvbr7nxuTmUPmIq
         5mt3Js7YDbgQuQBWcsrS5/eTXUNDv8rPE9jY0LWtAuCE3wqPvX3T6t8swx+kOkSHi93l
         YOQOE7p1p5EC8JzbRPmWu0hQqyseY45P7HGu5HmuVJ1hEa88sb19m6txlhzx1Sa07OnT
         B79Q==
X-Gm-Message-State: AOJu0Yy4UI7dmwJsviy+EdZZnP0xB6AOzS+NmF61QxNTubz63fIsJmns
	XvBc0+1YR5+JTDr9gbLJHIC6VCSIX0gNMjRLUT8bZX8FvRrL3X/X9Gy85ol+2uZOA1D+TK3X/Uh
	UArHYcA==
X-Google-Smtp-Source: AGHT+IFfuiPoH8pmTuIAcORqENRGSyiyZ9lFDpHEhjjXbL3pcNCiLYlIibeSuvn2z0Bbu9yPs03FzDZbrjI=
X-Received: from pjzh12.prod.google.com ([2002:a17:90a:ea8c:b0:329:7261:93b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a8e:b0:32b:96fa:5f46
 with SMTP id 98e67ed59e1d1-339c272481emr4895352a91.5.1759533993262; Fri, 03
 Oct 2025 16:26:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:26:05 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-13-seanjc@google.com>
Subject: [PATCH v2 12/13] KVM: selftests: Verify that faulting in private
 guest_memfd memory fails
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a guest_memfd testcase to verify that faulting in private memory gets
a SIGBUS.  For now, test only the case where memory is private by default
since KVM doesn't yet support in-place conversion.

Deliberately run the CoW test with and without INIT_SHARED set as KVM
should disallow MAP_PRIVATE regardless of whether the memory itself is
private from a CoCo perspective.

Cc: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 26 +++++++++++++++----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 73c2e54e7297..f5372fdf096d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -75,9 +75,8 @@ static void test_mmap_supported(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
-static void test_fault_overflow(int fd, size_t total_size)
+static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 {
-	size_t map_size = total_size * 4;
 	const char val = 0xaa;
 	char *mem;
 	size_t i;
@@ -86,12 +85,22 @@ static void test_fault_overflow(int fd, size_t total_size)
 
 	TEST_EXPECT_SIGBUS(memset(mem, val, map_size));
 
-	for (i = 0; i < total_size; i++)
+	for (i = 0; i < accessible_size; i++)
 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
 
 	kvm_munmap(mem, map_size);
 }
 
+static void test_fault_overflow(int fd, size_t total_size)
+{
+	test_fault_sigbus(fd, total_size, total_size * 4);
+}
+
+static void test_fault_private(int fd, size_t total_size)
+{
+	test_fault_sigbus(fd, 0, total_size);
+}
+
 static void test_mmap_not_supported(int fd, size_t total_size)
 {
 	char *mem;
@@ -260,9 +269,14 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 	gmem_test(file_read_write, vm, flags);
 
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
-		gmem_test(mmap_supported, vm, flags);
+		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
+			gmem_test(mmap_supported, vm, flags);
+			gmem_test(fault_overflow, vm, flags);
+		} else {
+			gmem_test(fault_private, vm, flags);
+		}
+
 		gmem_test(mmap_cow, vm, flags);
-		gmem_test(fault_overflow, vm, flags);
 	} else {
 		gmem_test(mmap_not_supported, vm, flags);
 	}
@@ -282,6 +296,8 @@ static void test_guest_memfd(unsigned long vm_type)
 	__test_guest_memfd(vm, 0);
 
 	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
+	if (flags & GUEST_MEMFD_FLAG_MMAP)
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
 
 	/* MMAP should always be supported if INIT_SHARED is supported. */
 	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
-- 
2.51.0.618.g983fd99d29-goog


