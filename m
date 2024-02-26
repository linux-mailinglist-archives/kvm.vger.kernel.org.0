Return-Path: <kvm+bounces-9829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0353867100
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E35451C23128
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15BA45F560;
	Mon, 26 Feb 2024 10:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k36dKL+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD58D5F546
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942461; cv=none; b=edWZg8C8nyzVTjZ7OsF64uvzw5ntw5sSQpGgtiMFcVTrBi4MPwZO1A2rIuTTGFM6EQdJjvOyUZxyjiOx5HpCr7JSK7yzL5YbjuJ11XtBTsMvjNJKREO/20zuUY8H1Wg3b4vpkotns0ipgIOGVUEcN9g3R6PeFt3JK5O1OSwi6p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942461; c=relaxed/simple;
	bh=FRJJHt94iccIvBXcGKBzRbphZ4fMzsT0WXVvvV3GAKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoS/70X+6rUDXMm8Nv5WlV5oMNcCSTmtJqUogTClQTuY26/rw7TSyGg1Xa8KOb7eM+g+HDjJSlPF6wy6HnqbNoo0BRLSE5kocGGvRj+XibsCyWQDQwEMxy5ywcCz7mv1kihNQPdDxG4pzMSdYn2CmuwvIcAox0CjeUuPy/BeYKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k36dKL+S; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e46db0cf82so1819066b3a.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942459; x=1709547259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfwcDBIoywwZNy1awe5blDTng5UqVAab7H/ucqIcyI8=;
        b=k36dKL+SEwBvxLyNVqhHTq78zRmhWjD4esIXDULzEvCk9NPspi3BTTgxXh6lb+HENz
         xqjXQkVu+/0R+lTd6JHntQky1oilRsoNEq0yvxWS0NfEw2F9eD6Bjkv5rmsficNs+i0y
         rPSJL76eOY+pOpBoeqDUKp9YyRl3ExcDiMG5hJpZq5LfVlWtulGvenGw8E5BijNoVeL/
         pSNBkReM6z92TDTU6BBRD+0b6JC3DeupTKaBCU9ZFBM8jINRT19SoxYUs2QhVXSwnHhP
         VwJy1dZbIqhzva++srh1lJbCvwgK+u4mUxfK1v0c1rc7N1FWmJ3ZLN/l4+iup3hpWPGH
         8xRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942459; x=1709547259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EfwcDBIoywwZNy1awe5blDTng5UqVAab7H/ucqIcyI8=;
        b=BIXPl257MzyvG+3av9t6XelFux7x6iFlhLDjSi3z91PsrQhS6bOFwedZyRQdW7aBCg
         ARC6u2bQoIPcWbaFbk5lC4QFvHEmmi/HBiHL+oyy4Zkh343yaKqTrQ7ZpsOpyRqHBlBd
         cdZ95qUsnkkplnBGRcqDbAvnVCt5jyDPBrmI7wqcmOXDw2F7SoM3yzVXji2LwGfo7hPH
         TXsKId4wetCEu7zY3Onip73B+DLf4I/Aym9K0oRNC6mRExIxG7ciqJGzBCYQo2BfYlhf
         cXHIHtqwx8mdcE9VCeae2GAHUFSzFZzYwzCs627tI5X3FwPVKAWpxXN/c3J7qzJg9RuI
         Ji+A==
X-Forwarded-Encrypted: i=1; AJvYcCVobOV6pznCKl3B753E+HR27T7GgWHVCMlzXBZrI5b3tKvlhDJ3mmAMfmvicAOZPlKvJ3O6qxdaazSIx0p+W275dB4h
X-Gm-Message-State: AOJu0Yyso55ZqQXxWrDiuQf7PsO9Pk8/dvTNykwR1RM1k0C3d1HIXE0I
	WagXUNXiI2FiAupgHD4GqjIdXWZ1Dsp1TuHQoMk59qi2SqBxyGnp
X-Google-Smtp-Source: AGHT+IFFwkunH0uAN31qvc46kWCxjAGYqWfk/p1PpoOp8Y4nUVYJ+dKIxLsEVlzJYo7rVd0OC9gKyw==
X-Received: by 2002:a05:6a00:2d05:b0:6e5:3e11:d7f7 with SMTP id fa5-20020a056a002d0500b006e53e11d7f7mr195499pfb.6.1708942459205;
        Mon, 26 Feb 2024 02:14:19 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:19 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 25/32] common/sieve: Support machines without MMU
Date: Mon, 26 Feb 2024 20:12:11 +1000
Message-ID: <20240226101218.1472843-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
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
index 6adf94151..f1219033a 100644
--- a/lib/ppc64/mmu.c
+++ b/lib/ppc64/mmu.c
@@ -24,7 +24,7 @@
 
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
2.42.0


