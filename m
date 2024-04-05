Return-Path: <kvm+bounces-13664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D00BA899807
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 333AD28895D
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929F115FCEF;
	Fri,  5 Apr 2024 08:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqnOpt3q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501C115F3E0
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306250; cv=none; b=JmjJOe3476VUJiQd0h0Oh3RRKeBHnnHFzNAspR5FuzLdwvZ/MBUAdBE5qsxZk0VJdLPhx42HZ2PeCN+GyTB5HpOvin3DvoKjznwTrH19yRRUWJkr8/JXtmMoh9bIkTYTD2hlQzOiZxdy0HNj9vP9GsOhEJJDB7cxQMXZa4ReOCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306250; c=relaxed/simple;
	bh=1fEFC6c9DoRG31mWbJKXrNV0TuUOVl0C9+1/otmtguM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzXhHKfl1oaAlg40DlEfNqejgsKc58a8fBejY0fyJWjk22SJKdxYCnoTpvUL/7smumnuQGnCMb/zUW127V9XCZZZij/08Nr1rQfybebcpcOjeXFh1dqOqPDNP+I6O2I8l0FSGxpZ8UM9keFuImboi8s+Xa620cB5GIDFOfjtKZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqnOpt3q; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-369f986176fso2929585ab.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306247; x=1712911047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kzbtoE/UL8zs6u75F6pI7GziWulTjnRNpnOgNK7TAQ=;
        b=HqnOpt3qkG5269ruC6YbEQnWr1cCFI33lhR/ePRfuMcdRPaAip6NBfnZdEGvhlSrjs
         jCXcSh4Cqazbk0q30mG/L7XSOAP0MDyoPl154jDfySuHloGHXt3QPnnZGzxfk74IWQj7
         uPcAQJPfx5JFsKuGaUDQWjZNtKFNNfVaaS63dEsRSTV46664oPCdnkLh/GwQZgVyEd2s
         gy6X77wBEEdYKGP/Yew8s+KMA2T+O2BHTZqiuqxL9DM5ALwLmZ6OrV2aIMkinGY1joJK
         lGLfmvpagIO4b6aM1rJWbt/lNQ8zIkSiK3U6Uyx9zbgrjkY9z3Py1safOR1jbVV3eEVu
         hPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306247; x=1712911047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kzbtoE/UL8zs6u75F6pI7GziWulTjnRNpnOgNK7TAQ=;
        b=b0V7gQ+K22tTdPwPG5M01oGFGxbXViFZdPL2gNCfldEDo6Wyd4uX4v69kOmVTaYotd
         KIJtzgLVLcS9L4h+TIrNIV7qEfYjMx2h0tXNpWHxbTkm1MJ8HdweWiw1zjSuKtAf0J4v
         kWvOZ0Yfz7RSzPBf7BkzFB12qh2XRDUZFzVicKvPeWOceWJ7rAhx84BvLW0M2FLIv5qT
         o8KQ1Q+IHjOSBtFoPzEr/Q/8nVlojj0LHDvvsXBRq0lLvwG9vSDaZ6CbK695oFn+cJuw
         YyCEJDCnHfieqAxzFmttGy69DsGz3giBrIeLtWiVcigPFDcjJP1cgWeuXAnSITn420ib
         J2MQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2qh+KOkR/5RKXEbaO4huopKFJqBUJ4Jb7Ll9n/Z7h7PVo24emU7YFxYttI1jnQ5Vumpn+BlZyBQ301DdT0FAF+hhz
X-Gm-Message-State: AOJu0YxowqPs9hKTAzA4Nw7/nJqJZ1M3C2e34HqrKDc9WaY7bvZY7FGo
	yi6itHgWwjUmVtikH96K8Y7czy0D4xdJXSSpiKVovbnJnidZrKPdR4Abr0n7
X-Google-Smtp-Source: AGHT+IECFV+iDS9TmZXS9MXN+sZFqxHCUkctVKUIwJDWuE2r5FFJ2939TTxhNHmcVwHCQURkor6zGA==
X-Received: by 2002:a05:6e02:156f:b0:366:a7e1:7677 with SMTP id k15-20020a056e02156f00b00366a7e17677mr888211ilu.3.1712306247486;
        Fri, 05 Apr 2024 01:37:27 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:37:27 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 24/35] powerpc: Avoid using larx/stcx. in spinlocks when only one CPU is running
Date: Fri,  5 Apr 2024 18:35:25 +1000
Message-ID: <20240405083539.374995-25-npiggin@gmail.com>
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
index 4519e5436..6ef3ae521 100644
--- a/lib/powerpc/asm/smp.h
+++ b/lib/powerpc/asm/smp.h
@@ -15,6 +15,7 @@ struct cpu {
 
 extern int nr_cpus_present;
 extern int nr_cpus_online;
+extern bool multithreaded;
 extern struct cpu cpus[];
 
 register struct cpu *__current_cpu asm("r13");
diff --git a/lib/powerpc/smp.c b/lib/powerpc/smp.c
index a3bf85d44..f3b2a3faf 100644
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
@@ -308,8 +311,10 @@ bool start_all_cpus(secondary_entry_fn entry)
 
 void stop_all_cpus(void)
 {
+	assert(multithreaded);
 	while (nr_cpus_online > 1)
 		cpu_relax();
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
index 744dfc1f7..02af54b83 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -48,6 +48,7 @@ cflatobjs += lib/powerpc/rtas.o
 cflatobjs += lib/powerpc/processor.o
 cflatobjs += lib/powerpc/handlers.o
 cflatobjs += lib/powerpc/smp.o
+cflatobjs += lib/powerpc/spinlock.o
 
 OBJDIRS += lib/powerpc
 
-- 
2.43.0


