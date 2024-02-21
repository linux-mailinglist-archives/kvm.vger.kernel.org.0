Return-Path: <kvm+bounces-9249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA5985CEC2
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:29:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A41152840C0
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69E438F9B;
	Wed, 21 Feb 2024 03:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgNWR1XE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA850383BF;
	Wed, 21 Feb 2024 03:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486153; cv=none; b=X3+AVmHbaFdkhwtAtLHpDgMAeh9KGvT7UKe4fgzPo9TFiYEo31WhZ1Gw8CTjnqRaihbAde9qZKU3xRf/oqHZGWj0KxcYjZuYdpH3vt5jRpfvHiD4ZLX2T6+gF5n3pzOHcUD+kloPCg+P19okjEqnuGi4D04tnKwz7bD61SMTwyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486153; c=relaxed/simple;
	bh=lE4WrwkyDtaQgF2D2jO1Cwot422cIfXq3YZMhla4BRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu+22HlQkIUl0soLty36BjnYNnmjUjH6u/3eNEYr6JGGhWo6XoIsO2LOsvrYBgoRqK2q/eet7sKjBJ7InOslDKeoSnBt3iXOsXVMrLsZRjzNpmeoqjf6vryFA/55pOhqrmyDmJwmFRGYAZBZ0/wTLXKujAsHxf93jPppvQP/Y6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cgNWR1XE; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e466a679bfso140684b3a.1;
        Tue, 20 Feb 2024 19:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486150; x=1709090950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuBjCwoeaNr8AGy/7SQu2RQwLY1MBjVxyn5YkQsjDDI=;
        b=cgNWR1XEMhx7Tt16+03kYqjp0+z3ds41dSwEFV8ntV0xHlc2YN3LVGp5YVbuaH5K4o
         rWx/N0XJnzvEfKVAfGCWTqAe1VXuIzTD7Cl9IPJRSuLyklXXyEu6UC6BJGM99PjIFtdg
         rw1E94KTki7k0x1NjtOscVHFksDQ+ZNGO0VegZ0f5ZNYbRI2tKy6n9WfvDwZRxgLVxXa
         x9l+se4R40yyQvxjyphdasFNQpq8joh4qOm6XSB9QL8pH8DzCsDh6U4RWfKUcSmoaZRi
         Pi1Vq9tei2UcEG5TCiFGSYA5MhuXNjMC5/xfcH8JihpLut8GrRVqNW2LDlf4qJuwL9YG
         4cuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486150; x=1709090950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nuBjCwoeaNr8AGy/7SQu2RQwLY1MBjVxyn5YkQsjDDI=;
        b=Y2dNekrV1XX22tl8VtlWGzn2LGNO7VrT69ikIZ7gYPjQyrmCcw4AKTU/WNTnP8xgJP
         sEsQqJSw20a6Hc04KcGwS5KaN9q/vayHEDH/oamJgAdtddWSd0IlQIqPEL1kL7zDVvjd
         dK2So3JS0wqgsSLAJjLH2BtuQo+0Yh4OTo4qG5uUoBNQ+3UJMErGUBImUwaqAkQVFBCt
         I4ngg8fznnYiT8xLVFsaSviFbPgOm04qEFj2oPyRaf5kelMcO7leumSHpI45jAwBKykv
         Z1hFXmZ8Wr0USlGUy5pOJBHLrZmW9JVRcpWq6tAq7eKNGIDO1w5fqL20QMNXtD06YMMY
         0Lzg==
X-Forwarded-Encrypted: i=1; AJvYcCWMrB+9Yowpku0wjpKRyyhgcPq9140yv6m/Cwi603ptXk8JjyZliL+lKUmrOBAA7AYIPr20HiUbm0enkmAkgoYMsuIWQo38Vft7QgLQgXq6n6urKFNm9bi8X81OhL5GBw==
X-Gm-Message-State: AOJu0YymOJ1Cg114sEWIjA2H5HPilGzyPAdBNRv5n7krmYYkw6y4ciIp
	8XhbRVH2IH3kbcOOoYeDztlUm1IRZMUPPODI0Uh6P7PuyHw/9/yE
X-Google-Smtp-Source: AGHT+IFMU4gzIndebrpd/hVeeR/Ex4Y3al2xaliSFhhET1KuVUMyOzj4zCCOyaTOOsv8L4D8Foc82g==
X-Received: by 2002:a05:6a20:d703:b0:19c:6fb0:2b02 with SMTP id iz3-20020a056a20d70300b0019c6fb02b02mr17269437pzb.61.1708486150696;
        Tue, 20 Feb 2024 19:29:10 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:29:10 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 7/8] Add common/ directory for architecture-independent tests
Date: Wed, 21 Feb 2024 13:27:56 +1000
Message-ID: <20240221032757.454524-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

x86/sieve.c is used by s390x, arm, and riscv via symbolic link. Make a
new directory common/ for architecture-independent tests and move
sieve.c here.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/sieve.c    |  2 +-
 common/sieve.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 riscv/sieve.c  |  2 +-
 s390x/sieve.c  |  2 +-
 x86/sieve.c    | 52 +-------------------------------------------------
 5 files changed, 55 insertions(+), 54 deletions(-)
 create mode 100644 common/sieve.c
 mode change 100644 => 120000 x86/sieve.c

diff --git a/arm/sieve.c b/arm/sieve.c
index 8f14a5c3d..fe299f309 120000
--- a/arm/sieve.c
+++ b/arm/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/common/sieve.c b/common/sieve.c
new file mode 100644
index 000000000..8150f2d98
--- /dev/null
+++ b/common/sieve.c
@@ -0,0 +1,51 @@
+#include "alloc.h"
+#include "libcflat.h"
+
+static int sieve(char* data, int size)
+{
+    int i, j, r = 0;
+
+    for (i = 0; i < size; ++i)
+	data[i] = 1;
+
+    data[0] = data[1] = 0;
+
+    for (i = 2; i < size; ++i)
+	if (data[i]) {
+	    ++r;
+	    for (j = i*2; j < size; j += i)
+		data[j] = 0;
+	}
+    return r;
+}
+
+static void test_sieve(const char *msg, char *data, int size)
+{
+    int r;
+
+    printf("%s:", msg);
+    r = sieve(data, size);
+    printf("%d out of %d\n", r, size);
+}
+
+#define STATIC_SIZE 1000000
+#define VSIZE 100000000
+char static_data[STATIC_SIZE];
+
+int main(void)
+{
+    void *v;
+    int i;
+
+    printf("starting sieve\n");
+    test_sieve("static", static_data, STATIC_SIZE);
+    setup_vm();
+    test_sieve("mapped", static_data, STATIC_SIZE);
+    for (i = 0; i < 3; ++i) {
+	v = malloc(VSIZE);
+	test_sieve("virtual", v, VSIZE);
+	free(v);
+    }
+
+    return 0;
+}
diff --git a/riscv/sieve.c b/riscv/sieve.c
index 8f14a5c3d..fe299f309 120000
--- a/riscv/sieve.c
+++ b/riscv/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/s390x/sieve.c b/s390x/sieve.c
index 8f14a5c3d..fe299f309 120000
--- a/s390x/sieve.c
+++ b/s390x/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/x86/sieve.c b/x86/sieve.c
deleted file mode 100644
index 8150f2d98..000000000
--- a/x86/sieve.c
+++ /dev/null
@@ -1,51 +0,0 @@
-#include "alloc.h"
-#include "libcflat.h"
-
-static int sieve(char* data, int size)
-{
-    int i, j, r = 0;
-
-    for (i = 0; i < size; ++i)
-	data[i] = 1;
-
-    data[0] = data[1] = 0;
-
-    for (i = 2; i < size; ++i)
-	if (data[i]) {
-	    ++r;
-	    for (j = i*2; j < size; j += i)
-		data[j] = 0;
-	}
-    return r;
-}
-
-static void test_sieve(const char *msg, char *data, int size)
-{
-    int r;
-
-    printf("%s:", msg);
-    r = sieve(data, size);
-    printf("%d out of %d\n", r, size);
-}
-
-#define STATIC_SIZE 1000000
-#define VSIZE 100000000
-char static_data[STATIC_SIZE];
-
-int main(void)
-{
-    void *v;
-    int i;
-
-    printf("starting sieve\n");
-    test_sieve("static", static_data, STATIC_SIZE);
-    setup_vm();
-    test_sieve("mapped", static_data, STATIC_SIZE);
-    for (i = 0; i < 3; ++i) {
-	v = malloc(VSIZE);
-	test_sieve("virtual", v, VSIZE);
-	free(v);
-    }
-
-    return 0;
-}
diff --git a/x86/sieve.c b/x86/sieve.c
new file mode 120000
index 000000000..fe299f309
--- /dev/null
+++ b/x86/sieve.c
@@ -0,0 +1 @@
+../common/sieve.c
\ No newline at end of file
-- 
2.42.0


