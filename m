Return-Path: <kvm+bounces-16582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3394E8BBB49
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AAEFB2138B
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C982557F;
	Sat,  4 May 2024 12:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E1cDSzk8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D088F22611
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825806; cv=none; b=BfUp7RWzEK3lSP7Ft4bCXPAqUY3kz1P9bb3EAoWoDU3Q+cwqsWm3LiK3pdomTvrUYT5G8eLp30n5YuuuzbIDmjcQJ2aokqtmGmHUn8d1nNjPiznS2xZUIKat5CcYRNzPElssc2TEMrApAtmXeBGdkLtCheRlOlK0yhalAPScn1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825806; c=relaxed/simple;
	bh=7VA9sk/bLG7s1uX6xYd/Ykj03bJXyed+4/Afp4ZN9fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQmJLYGQrYcZ0EMQKyByysQTd0DNxSNugDqr32GtJz3qIvLmj266c8rK7mfL5KMNqkT6224ZLZ+3CTAEKbongIbmIdt/+KtXkc7rzh6KP90QXs9dX1WBXYD8FBINLCafnva75+epQ7H4UWb44O6K8XaK22skPQmZTnJOZ9OKCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E1cDSzk8; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6f3e3d789cdso486105b3a.1
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825804; x=1715430604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1J1rerHtz2/IUl9CIlFdWIoy05A/oeTKAK2mDsoOQ0I=;
        b=E1cDSzk8qH/W03eStzNAfsWsBxSpfjslqIUyzzelRfGWJ34FRPInc1LFB60dvzprvd
         ktwfTfqhaz9+b3xplMV2XQiw85WtFlzEKugs/YAMDe/kOH+SYGyAK7hTaQjuMDuEna3Q
         g81XG2R2ou3ziFd/SnGowq/eU97LI+o/y8d/siL6A8wsfVg3dO680PY0CoeO6+vuZqEX
         rKEXCLeDhJO0LZ1QdyulgLAtR+1dkXexdK2F7fDyUxW4kz5JgUbUKBB1GMptzg5LEaQE
         EO3FVwAwUzlqbzBjH0ReOekOQEM7v+cACo6eAeEibNb5I0wyYqcjrH8lMQuVOa2vZITk
         Hvkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825804; x=1715430604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1J1rerHtz2/IUl9CIlFdWIoy05A/oeTKAK2mDsoOQ0I=;
        b=omB70SB8221+TgBLMJmmGrH9ywRlnljlXVMlNYt36kbggAL5vZr2mefNFnKXzgdBbb
         CcFgYqulIJsO1CKBFJWtTVyt2SoGZuv0thIygiTV+B3gLJ5WDNlff0bDkjzNJ/N6o4Un
         b7Cn22dqtfbDATA2pmJtlpqkOC7YzTjrxk48pfqTwT8AWSjr2xDWl7riiBN5uZH7xlJQ
         xkCdDsfd82VXHBognRXK7Ulxq36mW/xcWUbQnCIfePaDY/GVQyi50ei0+FPJVJ0/zMC7
         Q312nWVA4lZmdBOsXpE5dsUWC51cunqreu2/LEMWriBkSTmdhRAYb2EcJYT00vZ2q2tK
         7Hnw==
X-Forwarded-Encrypted: i=1; AJvYcCUxaUsO6CQx53LME8pHz+Lr1lLMepQaEWWYwr/lzMLc/9NxJdQOnKe7YzLEMjmXVgOc3l9vYgDJ1QtKF7ksv0sHaioa
X-Gm-Message-State: AOJu0Yyo1jfV3n51BHwkwkMR0OP9RU2T0cs1gsDmBlLhLXMC4LLDK/e/
	KpS31En05hQvfSeSHZqExhksecZM297cf0ZbDeUhUbR9mE41mcqJ
X-Google-Smtp-Source: AGHT+IE705BbaLHg0dkpi38AsyXDqDVglxsJuuZBWB5uM1M5vnAAvSQE55y3EV0uFEDzYsyhbYKW+A==
X-Received: by 2002:a05:6a00:1799:b0:6ed:4aaa:3cbf with SMTP id s25-20020a056a00179900b006ed4aaa3cbfmr6768331pfg.3.1714825804126;
        Sat, 04 May 2024 05:30:04 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:03 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 19/31] powerpc: Avoid using larx/stcx. in spinlocks when only one CPU is running
Date: Sat,  4 May 2024 22:28:25 +1000
Message-ID: <20240504122841.1177683-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test harness uses spinlocks if they are implemented with larx/stcx.
it can prevent some test scenarios such as testing migration of a
reservation.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/smp.h    |  1 +
 lib/powerpc/smp.c        |  5 +++++
 lib/powerpc/spinlock.c   | 29 +++++++++++++++++++++++++++++
 lib/ppc64/asm/spinlock.h |  7 ++++++-
 powerpc/Makefile.common  |  1 +
 5 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 lib/powerpc/spinlock.c

diff --git a/lib/powerpc/asm/smp.h b/lib/powerpc/asm/smp.h
index c45988bfa..66188b9dd 100644
--- a/lib/powerpc/asm/smp.h
+++ b/lib/powerpc/asm/smp.h
@@ -15,6 +15,7 @@ struct cpu {
 
 extern int nr_cpus_present;
 extern int nr_cpus_online;
+extern bool multithreaded;
 extern struct cpu cpus[];
 
 register struct cpu *__current_cpu asm("r13");
diff --git a/lib/powerpc/smp.c b/lib/powerpc/smp.c
index 27b169841..73c0ef214 100644
--- a/lib/powerpc/smp.c
+++ b/lib/powerpc/smp.c
@@ -276,6 +276,8 @@ static void start_each_secondary(int fdtnode, u64 regval __unused, void *info)
 	start_core(fdtnode, datap->entry);
 }
 
+bool multithreaded = false;
+
 /*
  * Start all stopped cpus on the guest at entry with register 3 set to r3
  * We expect that we come in with only one thread currently started
@@ -290,6 +292,7 @@ bool start_all_cpus(secondary_entry_fn entry)
 
 	assert(nr_cpus_online == 1);
 	assert(nr_started == 1);
+	multithreaded = true;
 	ret = dt_for_each_cpu_node(start_each_secondary, &data);
 	assert(ret == 0);
 	assert(nr_started == nr_cpus_present);
@@ -361,10 +364,12 @@ static void wait_each_secondary(int fdtnode, u64 regval __unused, void *info)
 
 void stop_all_cpus(void)
 {
+	assert(multithreaded);
 	while (nr_cpus_online > 1)
 		cpu_relax();
 
 	dt_for_each_cpu_node(wait_each_secondary, NULL);
 	mb();
 	nr_started = 1;
+	multithreaded = false;
 }
diff --git a/lib/powerpc/spinlock.c b/lib/powerpc/spinlock.c
new file mode 100644
index 000000000..623a1f2c1
--- /dev/null
+++ b/lib/powerpc/spinlock.c
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: LGPL-2.0 */
+#include <asm/spinlock.h>
+#include <asm/smp.h>
+
+/*
+ * Skip the atomic when single-threaded, which helps avoid larx/stcx. in
+ * the harness when testing tricky larx/stcx. sequences (e.g., migration
+ * vs reservation).
+ */
+void spin_lock(struct spinlock *lock)
+{
+	if (!multithreaded) {
+		assert(lock->v == 0);
+		lock->v = 1;
+	} else {
+		while (__sync_lock_test_and_set(&lock->v, 1))
+			;
+	}
+}
+
+void spin_unlock(struct spinlock *lock)
+{
+	assert(lock->v == 1);
+	if (!multithreaded) {
+		lock->v = 0;
+	} else {
+		__sync_lock_release(&lock->v);
+	}
+}
diff --git a/lib/ppc64/asm/spinlock.h b/lib/ppc64/asm/spinlock.h
index f59eed191..b952386da 100644
--- a/lib/ppc64/asm/spinlock.h
+++ b/lib/ppc64/asm/spinlock.h
@@ -1,6 +1,11 @@
 #ifndef _ASMPPC64_SPINLOCK_H_
 #define _ASMPPC64_SPINLOCK_H_
 
-#include <asm-generic/spinlock.h>
+struct spinlock {
+	unsigned int v;
+};
+
+void spin_lock(struct spinlock *lock);
+void spin_unlock(struct spinlock *lock);
 
 #endif /* _ASMPPC64_SPINLOCK_H_ */
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index b98f71c2f..1ee9c25d6 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -49,6 +49,7 @@ cflatobjs += lib/powerpc/rtas.o
 cflatobjs += lib/powerpc/processor.o
 cflatobjs += lib/powerpc/handlers.o
 cflatobjs += lib/powerpc/smp.o
+cflatobjs += lib/powerpc/spinlock.o
 
 OBJDIRS += lib/powerpc
 
-- 
2.43.0


