Return-Path: <kvm+bounces-12100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 650C087F8BB
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9E5A1F2105E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8C654BF6;
	Tue, 19 Mar 2024 08:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cj6nWnlY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15691E536
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835275; cv=none; b=B9HZOg6oXQh8oqmC316clOJmnFhfLSyi5hRxuCI2AggdlPFsWYFD9TSRZWF5mHcS/wkpRtwtT9uMKEHBa20mYwL84AvsvMtCq6M/NNX7jy3UT/8LBWiNjwSun1geY7Ghua6uXZJMauzfqj43udr7Bpfmlj2PKf9Dl4xzc1Vt8xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835275; c=relaxed/simple;
	bh=Rjbwhgd/1RjFL4GPcxJrN4wE5c1g0D7Nu0RLCiRHamI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RalfKiGWCtLn5hVi6ce9ZycUs+THEJ1PKt3eU2z/gPoG0s+gBMOfOH0eHLamkEPwqs3p9j1Oxr6J+PjRDuL6qL2QRGBFeDQl2uDWac1HSbieknml8/LDkLo5UuGda3a4lbcTgKQBQc9WPMkc5oST+AYYE3c8Ol25LanooMjMac4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cj6nWnlY; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e6082eab17so4599061b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835273; x=1711440073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2v3m6/HzaZ1rQ7x7lB6tdszFjgJSQvXgFZcRwhVCtA=;
        b=Cj6nWnlYG62ZEcCbLLSTuQmAyWNGn9AuN8fFUTG4ce9bHPUpZrO+FxFReyyLBEHPFp
         xVH1QnwweAqD29E3isdwBShEJRlQjCECFY/vv7EXyKPbMnxEkKqQ/YMz+mobGX9ho4wV
         bJX2l++MvPudqOql5XkYZExPAZ/1V/CgPyDCPzGXpNFfD0h+U2pn6O7Li+MN2ksE+PNT
         E41Z5GSvzLZABs1V++O1mlaVZP+kNTu1TkuRlAML6n2PA9i1j4kDNhxZjnKCLvDgggGB
         yqAkJsiAiCv4GfBof6jpVlI74p0ECZU0IJUtuXTUynpB+i1ZD7eQuNg7DEasSTmcGRoj
         KJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835273; x=1711440073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T2v3m6/HzaZ1rQ7x7lB6tdszFjgJSQvXgFZcRwhVCtA=;
        b=AxS0Kdf0NHGMjJ9O1Thq93zgarg2NprIzZlw27CmVAMdc5ZX1Zg2zGhgqrXD23AX35
         b6+qTaLaPN+YfiBHuS+Ch7cfgzoDI1WoBxN1SOPY1hAOD74CGbc9VcAuLBavcbFurulC
         QvMh2nok/pxABsdVupK5fBew/eThGHgqU8Lx/sgWa1u0QFv+Ct3KI7CGITsPZOHKxEmI
         d6EmJbuC1XaQ40bbF/Rv2CxcRYGXcxcI0sWl5wlTmQ0ZDp+gk/b+vsugvnXn+MLR7vUH
         wV3kA4j6sFe5fFHNy2NaLFOKM9huf8Wt1dtgGpPcnSgG1o6IeO5dWF/7zh0KDAxnuYPC
         np0A==
X-Forwarded-Encrypted: i=1; AJvYcCXuoU+9wV4NGboKZoh1ZD+8qzZSvsrytcESxALItwk58NLsDHtWRHb51aJgJLemmGC4igcPGL51DLDnk467b/WbK29f
X-Gm-Message-State: AOJu0YwoYS5fnxfAxEIesTMm0k5N3ra2uaA88yIbUNrhxCKFikS/weGb
	qE9s3eaiE0W6OYwsY1fh62cl5hC5BxL84LeWlieUG/Nq8uz7gna7kSVucW/uXvY=
X-Google-Smtp-Source: AGHT+IHdwH83NuMcW/BwylTDBox7NJE3DY6u/Tq9cnPn3D+qzkwPfiyEb4jrVhG+XmeamI42Xsmw8Q==
X-Received: by 2002:a05:6a00:398a:b0:6e6:b155:b9a3 with SMTP id fi10-20020a056a00398a00b006e6b155b9a3mr14286931pfb.11.1710835273174;
        Tue, 19 Mar 2024 01:01:13 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:10 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 24/35] powerpc: Avoid using larx/stcx. in spinlocks when only one CPU is running
Date: Tue, 19 Mar 2024 17:59:15 +1000
Message-ID: <20240319075926.2422707-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
2.42.0


