Return-Path: <kvm+bounces-19399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B29A8904AD0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CE9F1F233EE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F362E414;
	Wed, 12 Jun 2024 05:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4g6w7OB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2285E3BBF6
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169831; cv=none; b=uetn9qNAHxlWxuoZikeDWuZ5sR1hiAno19xKjg8JtjXFwD5p62Ixm5WRzz7iX6DSUzse8ddevySovPGfwifKjQZNoi6trFXVRT5HrubJC6Hl4PW0FLVEi/T10Fat+4GoDEf4PT1zzXrP5TTl+UYCyfh0rw9/lI21g6ZlVOk7UMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169831; c=relaxed/simple;
	bh=FubDrlJDZVUQJl/U+53sKZswuwaTppA8aML8RXPLzYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb5pdfLDQKRoAcoanArBlDK6A+jqXmZwYkO/bowsnSthgnjBv3zetjNEz7/uNwSd0LAVimE5AgSR9xsy/M9hHGwPmhRfPL0AXNffbgK8MO33NA/xshd8L2Au2WsmV+rbOfK9XVCeFY0bj8otrvMNW8MUJXBsaUBPb2000lRPCoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4g6w7OB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1f6fabe9da3so30513275ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169829; x=1718774629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=whEhZTtPT00OFJB/07kvSJ13rQAZJafg7Gn5tcNqzNY=;
        b=E4g6w7OBJ8EzCc+iG9G22xMHDgJ+5f+N9HddxeYRdfibO9DqnXLXxhbMTBzmz4wPFv
         +DQCjXImnaXJ1X+5axG3Onhgu2YPGiEYcTGjLj1nBPNHuyohRqtOnXWExaSLNqxUYXhF
         90z5yzHY4D6fAKApm9M0fudQXK/D61h+w1ARR0IMvcJDke7a/zG6WR596wqqt/tvYZok
         +2X/XzirQ200Xt4FcJWV57RSUUx6t1QpUOflbckVIGulSb50uqExWM5zkFhpleQUN9cO
         ZitMKn9WXn8mTPDdAl4KEqEELEUQ11/1sU0uv3gnMtVTCs4r45ThuDKRqzrCrhN2LiU9
         kqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169829; x=1718774629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=whEhZTtPT00OFJB/07kvSJ13rQAZJafg7Gn5tcNqzNY=;
        b=rE2tOG9jCkNethmgtbjSxTn7u9X0qjfbOuAlfdW/bHrqUZ6JGIuYSTmvTwlECX0JZp
         IzXgfYVuwSNbNv9hLK+jEAs1ZpoVgvwKn3omVvp9K8hRZzP8kRKOt8yPhDCwyZGxdnAf
         cdSR5jN+KdonTzDsHyM2l81HqUM1Q+sfDe5JviHem2kK3mvJ0ZKAY0LnPHDfL9naSkNU
         4Sb9/ypeqk4DbCUq4KXcp8jWqYws68vwBkZgnY95/IJJw/YsktHSwkzQrnkzWphn9eSP
         zwcac1DbJX21Al6nNaBhORkC0RrdusWUvRf+Ysx5DZecD+9W7sj6UwK80rENc7uig4aJ
         ogXg==
X-Forwarded-Encrypted: i=1; AJvYcCUz3wC3AyjbIybQwL0ZiwFLnIxNBcZ0/pxvCVRqA2n+PCmPHW9Djkp+t5um+AoFBZX//WS0ism3rR5fhNlS7X40fwyx
X-Gm-Message-State: AOJu0Yxv/HZb0uwG6XOW72MCjwp8bwy2drwVFqbspoXPeLTuOwKr+8vH
	ESA/gD2Nlccfosr74tI9vcn20QTog+tXjLage8K6w9WprtFddXh+
X-Google-Smtp-Source: AGHT+IHf8iskGQ6DNM8Nf1fvjQgzr4swkoP/BW0g4dMf4f28rpBqyuTlnjIcqMfwWwIRw7lvEIHdzw==
X-Received: by 2002:a17:902:e80f:b0:1f6:fcd9:5b86 with SMTP id d9443c01a7336-1f83b56617cmr10187605ad.12.1718169829461;
        Tue, 11 Jun 2024 22:23:49 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:23:49 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 05/15] common/sieve: Support machines without MMU
Date: Wed, 12 Jun 2024 15:23:10 +1000
Message-ID: <20240612052322.218726-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not all powerpc CPUs provide MMU support. Define vm_available() that is
true by default but archs can override it. Use this to run VM tests.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/sieve.c      | 14 ++++++++------
 lib/ppc64/asm/mmu.h |  1 -
 lib/ppc64/mmu.c     |  2 +-
 lib/vmalloc.c       |  7 +++++++
 lib/vmalloc.h       |  2 ++
 5 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/common/sieve.c b/common/sieve.c
index 8fe05ef13..db084691a 100644
--- a/common/sieve.c
+++ b/common/sieve.c
@@ -40,12 +40,14 @@ int main(void)
 
     printf("starting sieve\n");
     test_sieve("static", static_data, STATIC_SIZE);
-    setup_vm();
-    test_sieve("mapped", static_data, STATIC_SIZE);
-    for (i = 0; i < 3; ++i) {
-	v = malloc(VSIZE);
-	test_sieve("virtual", v, VSIZE);
-	free(v);
+    if (vm_available()) {
+	    setup_vm();
+	    test_sieve("mapped", static_data, STATIC_SIZE);
+	    for (i = 0; i < 3; ++i) {
+		v = malloc(VSIZE);
+		test_sieve("virtual", v, VSIZE);
+		free(v);
+	    }
     }
 
     return 0;
diff --git a/lib/ppc64/asm/mmu.h b/lib/ppc64/asm/mmu.h
index 32f1abab6..2bf94e498 100644
--- a/lib/ppc64/asm/mmu.h
+++ b/lib/ppc64/asm/mmu.h
@@ -4,7 +4,6 @@
 
 #include <asm/pgtable.h>
 
-bool vm_available(void);
 bool mmu_enabled(void);
 void mmu_enable(pgd_t *pgtable);
 void mmu_disable(void);
diff --git a/lib/ppc64/mmu.c b/lib/ppc64/mmu.c
index 9e62cc800..6f9f4130f 100644
--- a/lib/ppc64/mmu.c
+++ b/lib/ppc64/mmu.c
@@ -23,7 +23,7 @@
 
 static pgd_t *identity_pgd;
 
-bool vm_available(void)
+bool vm_available(void) /* weak override */
 {
 	return cpu_has_radix;
 }
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 572682576..cf2ef7a70 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -206,10 +206,17 @@ void init_alloc_vpage(void *top)
 	spin_unlock(&lock);
 }
 
+bool __attribute__((__weak__)) vm_available(void)
+{
+	return true;
+}
+
 void __setup_vm(void *opaque)
 {
 	phys_addr_t base, top;
 
+	assert_msg(vm_available(), "Virtual memory not available. Must check vm_available() before calling setup_vm()");
+
 	if (alloc_ops == &vmalloc_ops)
 		return;
 
diff --git a/lib/vmalloc.h b/lib/vmalloc.h
index 0269fdde9..e81be39f4 100644
--- a/lib/vmalloc.h
+++ b/lib/vmalloc.h
@@ -17,6 +17,8 @@ extern void setup_vm(void);
 /* As above, plus passes an opaque value to setup_mmu(). */
 extern void __setup_vm(void *opaque);
 
+/* common/ tests must check availability before calling setup_vm() */
+extern bool vm_available(void);
 /* Set up paging */
 extern void *setup_mmu(phys_addr_t top, void *opaque);
 /* Walk the page table and resolve the virtual address to a physical address */
-- 
2.45.1


