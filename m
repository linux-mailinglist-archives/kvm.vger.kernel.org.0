Return-Path: <kvm+bounces-9824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B21DE8670F9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:29:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66B1828F464
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82E55EE82;
	Mon, 26 Feb 2024 10:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9gkiHS0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAA85EE68
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942438; cv=none; b=aBdgmksmnbB2+cNtEud3xb8by9h+7K6SgqdhM1yWnavmKKWzh9c5FSc+5CToUETDLscpj8pr7+wEyP2D3sYZwPWoSHrwY76BiwV1Ndiy9X1DpsVphHbMluFlDnZFfuRBnoZCfR8RQjSfcEDEuj7zJGRc7Z9Xs0Hxw+6SRmaVX9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942438; c=relaxed/simple;
	bh=Kivn6ssdG5nLLxiN7iOgyD/nf4kk1ePHj2uQ+fK7x/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwIYM/7Qj5nyUSewKuSjgwRGsVyNqqWkdsF+bCh9+6M1+Dg/i13gpRTCxN2GiFnAfs0hIMpOookEUMogO/GeSBEydOuTAoVtnGkBpJ/X0yhF3KkTcx5JgqLQsGRlN8YzTSLQ5EAbp+lS21iBlZ9pQpBxwm+RoElk6QfdYF2IzlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9gkiHS0; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e45bd5014dso672123b3a.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942437; x=1709547237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkVk2G/rqE98/Gll6ggbBTcIfup8NN9Tv/n5dXqJucI=;
        b=A9gkiHS0cuiMl/g7/rbE8K2qnuvLp9e8LEjxkWLaOm2gDkKMbtnBhCv+3H5he2Iwg4
         WAgTVrGKvFc/Z4O2fWR8ZfLMSZfniESe3lIEyCja/BdzvitFW+u3h340p78ewdLDm3Ke
         HTg08HxOI2wslPz20iEaESWIPFzVi15ylVtgJkQoDz7P00PHuX1ttvYNVMpc3qG8sRwj
         MxVN9oD6856MsT+ojR0t6eu1MRbsllZUujbS0BdXnta8OYsdfqJKNowT6bGTnoxaZ1US
         ZcTs+IPZjZ51DkN44PG0XsbRWQF0C5BNL2ivOvlxRoY2LzUF0DcJReeZD8pYRxBsa8EE
         XlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942437; x=1709547237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rkVk2G/rqE98/Gll6ggbBTcIfup8NN9Tv/n5dXqJucI=;
        b=IkopKzp/dZQMdLdGsU1pXM6zILXZnCwrf5iQOmStq1YRzQ0q0SrHP1wgpaM4nK5E9+
         ghquQt2bJGgC/PwqvaYZrYz+dsZ+AcadQfbgnpIWPCOxXSh14cvvbN50ohxWUnR87074
         y2y07doAozhK66P+NaYt+jmDxVwKKJ9Xp0oFeOZ6g0yOvxTGDWMdZq8IO3+9ahQnqsOK
         YD/mA8f+h3dvGp3NrRGLRUlYzJG4A5F3c62JaN3leXR5Dfxnmvvx/VMpn52ITGe+Cf3S
         4lpCNY4SHI8/rz0FXnzLbdq5+W5eSK/UJoU9DZLV4P48HVc0g/AFZyg5/hKZJ5pw7qRi
         gZPw==
X-Forwarded-Encrypted: i=1; AJvYcCUBFnQ6bIWsPwCGqw6J1xyH7KF4Y5Yrwx+ZHXo3dgmXa++56j5b4dqsF6mI6xkTdQqyGcrbe8zFaj8Uo4r3GSideUNP
X-Gm-Message-State: AOJu0YwKHDifO5xhUa1CCo+9pW7zjTfLR6JvPusnwEzppdBoUx2IMxqA
	0dq324dbVnOilfLoGTX11XEFP4cb/nWVGbnUTsFFfQLnhSlGXvnU
X-Google-Smtp-Source: AGHT+IFH9gVhSndX7xO/ej/POQdOAvFUZA3vacssw6GqCBJBdXMnMxrgK7MTernWExIL9aE2n9kaNQ==
X-Received: by 2002:a05:6a00:2da2:b0:6e4:c5a1:e41d with SMTP id fb34-20020a056a002da200b006e4c5a1e41dmr6797568pfb.29.1708942436655;
        Mon, 26 Feb 2024 02:13:56 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:56 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 20/32] powerpc: Avoid using larx/stcx. in spinlocks when only one CPU is running
Date: Mon, 26 Feb 2024 20:12:06 +1000
Message-ID: <20240226101218.1472843-21-npiggin@gmail.com>
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

The test harness uses spinlocks if they are implemented with larx/stcx.
it can prevent some test scenarios such as testing migration of a
reservation.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/smp.h    |  1 +
 lib/powerpc/smp.c        |  5 +++++
 lib/powerpc/spinlock.c   | 28 ++++++++++++++++++++++++++++
 lib/ppc64/asm/spinlock.h |  7 ++++++-
 powerpc/Makefile.common  |  1 +
 5 files changed, 41 insertions(+), 1 deletion(-)
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
index 000000000..238549f12
--- /dev/null
+++ b/lib/powerpc/spinlock.c
@@ -0,0 +1,28 @@
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


