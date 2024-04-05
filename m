Return-Path: <kvm+bounces-13669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0171689980D
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84E341F22CE9
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BAA15FD02;
	Fri,  5 Apr 2024 08:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WZzIeso+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E1015FA8A
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306271; cv=none; b=Vhx/zhshM13VRaOeL6hFqxiec+Bjp/zjZW9+URlKKEU57VSC/FU+slweYNaN4dDS3cFnK8oWACRQS1OzlGe0gCKSoa0DFrirsFad0yHj4YjV6bOUVYBHpPvpd4z9VqXP/Sa3aVtNVkzyj03F8v8wy5oxH4Yktc2F4hOutzB3heM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306271; c=relaxed/simple;
	bh=pJeo4pwcA9lalmG/Qxg0dYsEHgiJKgBrY3J7VxNeV20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2N+2bpfjHMlrZGD0CopRcZDjnefLqSW79YxRIpzFfVbXvvZQTso1+DlCbQgaYLyo7eT+QhnAEfDMUdhXvWyZ1ZgJ57i2qTsU1fQxH7p5qCulvQN6Y2pFR9zYiWZh+70VekWLyWMGTa8zJkZyWO+nyyd44iS/IewUjXMEF2eCRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WZzIeso+; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6e6a00de24aso974869a34.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306269; x=1712911069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVFESOjcVNNLos51ELml5v9t1FTREA6sVge5yqZTLzY=;
        b=WZzIeso+p0lYcJH0f9odHxPtxf2PtWf10+0Zf7cnT3lcu+duKAs7PKNKBDW7Unkjs/
         Ek2FuisLK7/mZqllUoEfDbclAN59FGLsdHQ0uYPWu92qj8CMkTD5MCKuEEcQVzNJJY8k
         P/2hUjk05Z1vyVY7UomfSX4JfH51oW96TljhyN0F9DmaAhxImFfqcBOnnVN2pw0qlP3w
         DpwIu7IqrxheEudkD+uz3u/qbxOjrQTrNiKpPBmhi9Ky/aCGk53TWHO+Bu0Bq6Uf4I3Z
         Jf/jhNtqOKDqnbXIKFJzO0yGH6x9kcA5Mi7sC1UNia5VPCLQQ4EzT8Oz0N51QyvB0d1L
         VUjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306269; x=1712911069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KVFESOjcVNNLos51ELml5v9t1FTREA6sVge5yqZTLzY=;
        b=e2+gOGKK/c4cZVDMJCGoCsYevaI1dYFc1s0lf2rXG/IK+KyLwRun4LaTPepqtMKL+Z
         UNSPJSPzvKYLfUH+A1WnhSh6S5C4YsCraSTjoeYJ2sjQYG8ZEPfPSAKfA8fYWhuwvzeg
         IU2ex1a//IFJMm6AchraoFhTRBXCm7T9hgH7O0uJLpt09nz9gs5hOJjkRNbMl4D8LjRz
         ExtXsLk4KPlgDx/SveV+E9faKFurAHwjML+B5+5WoWi8eeUv53vHDBWd4nf0j7XZIsUA
         mQyYkJH+RL6+dN3kqnGtwix+xZWksvykUPhUsHBbxoZRKxCQveDbbamLk1EIYqNLw1ax
         a7Gg==
X-Forwarded-Encrypted: i=1; AJvYcCUNjAgYIvRUrIv44zF+V4mNtndEYcgUyqK7RMw28eAxnzwTyEBgwF6HvpA3Gt5uj0dTvd3n0KdIH0fI+VOUfMDFHaLn
X-Gm-Message-State: AOJu0YwI/RiGFxqCZKaaj1dombvr/Ozd3ngAlc2pNewh+rkNBUN/kSpM
	nkJIsOPV3ZECDKNeAmkzfXc+lImd4V5kLYXVjKxDdC+M89LEXyl8
X-Google-Smtp-Source: AGHT+IHVOuA69ER65+xddK5ckvCsnmvJfddxakbq65AQZDNkYvQ4G74j7SWW8EQqLdsFts08sTuatQ==
X-Received: by 2002:a05:6830:13ca:b0:6e6:8564:6672 with SMTP id e10-20020a05683013ca00b006e685646672mr794574otq.25.1712306269104;
        Fri, 05 Apr 2024 01:37:49 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:37:48 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 29/35] common/sieve: Support machines without MMU
Date: Fri,  5 Apr 2024 18:35:30 +1000
Message-ID: <20240405083539.374995-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not all powerpc CPUs provide MMU support. Define vm_available() that is
true by default but archs can override it. Use this to run VM tests.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org
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
index fadeee4bc..eaff0f1f7 100644
--- a/lib/ppc64/asm/mmu.h
+++ b/lib/ppc64/asm/mmu.h
@@ -3,7 +3,6 @@
 
 #include <asm/pgtable.h>
 
-bool vm_available(void);
 bool mmu_enabled(void);
 void mmu_enable(pgd_t *pgtable);
 void mmu_disable(void);
diff --git a/lib/ppc64/mmu.c b/lib/ppc64/mmu.c
index 5307cd862..84be31752 100644
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
2.43.0


