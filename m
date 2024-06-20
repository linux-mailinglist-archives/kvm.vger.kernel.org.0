Return-Path: <kvm+bounces-20101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 673CC9109AC
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E599C1F2203F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303D31B0132;
	Thu, 20 Jun 2024 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QXnMZlDL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6AA1AF6BF
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896954; cv=none; b=pa4F4Nqom4ZrGFn3pMs08GD2JLgzOu3GrY5FXRD/3Do6zxtPtb5MU9IunHqCfMtPyZgeh2HWBC5hSyDEtcrQ3GdHvYMPXZIbwYwVuyiLD+8g5qxxaZDt8FZbLlBXAXnppWKu4SAJGHq+ZVNCuGvgZpGNRvWnTXKhspKdYjW4R5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896954; c=relaxed/simple;
	bh=pBZQmPLUYgPnwPvlGfOu/fmGzScvPOJIZeOOrlx1/wU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cynRXj7iHp4s8WZno/bQdVLZo7bzp30UOkhvy4GySRAqHJL3PULy8tFG+4eYax4HhVYDokotvxcOKD4dUUHo9Wtnr1jufYgJP+uqIyi7EBpl7khV7Ab6PWMRlOqoGqvDBo6Z9bY22+0BKhB/hAbAJytWe8LOzEglUsAN+7Xo4ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QXnMZlDL; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a6e43dad8ecso175842266b.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896951; x=1719501751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUsmThce/MAXtT1TzjuV9l3/1dXmfT3EJ/fU+1YA9l4=;
        b=QXnMZlDL3yGFl1kn0HJevB7RFjzL+rts2BEGlE2KJa4twqpKxGnI5iRDKl/+PRCrfC
         0iM7D3Czof9CTguCBmJAH8kxitsAluoc3RmrXwdeMPoDoGzIP+NbJe2yDyDsXAjFSr1O
         rTZt3g6ofH/mTjH+3M8akf5WbOqWS+oKIhH5rGBxCKawKgmzOOBajzJ22GiEQmt7ssbA
         wHHEVxapBn31TLYblitbwWHTp2SihIRK1Iq/gcn0tc+MyYBclrt8QEVsTzJCjpGHcwG9
         sc+xujhIUr+gSCkEU7SnEnb8m+nGOKVkNF1VvVNnKS6PgYILGGKPbOD9cCs5KXd5mLQA
         ROQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896951; x=1719501751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oUsmThce/MAXtT1TzjuV9l3/1dXmfT3EJ/fU+1YA9l4=;
        b=SD7PPWPqgxiLJL0yURjzxPkqFOKi83rnyDuFU8m50EzYz7M9SrjCdQhQROaKojtI19
         asdzudzeSmFwkTZZ/qf9oIth4S1IpucVF2zY1BAO6GZhl+7TGIfrs5ZSFiaKXVqJ2Sif
         OeLwbXJ7dnQ4CjpjeIVgFTqC4kNgtmDZcuxurCwyvITadx8u9M1yRnjTNC6ix+uuEY6I
         vJDCBXAq839Y8Hx1Sx5J4xdOpZp+uhsfLS9WzLfSG3pPzGRBYSZSUScj+wdj37DC9YQN
         IuXtBkgNoEqVhZbY84Yk6dve1C3w2R0gQmzui1HF06QfZlrDZsoZRLK0Egv3evfL/7f9
         p+IA==
X-Forwarded-Encrypted: i=1; AJvYcCV0dqBrsROHrXdcHB3U36MK3sR6gSEBT+B9KQGK7uRdEZoBjk0586lOjeMHusMy1f6H6HP53fdz3SSg39krEVoQWGN+
X-Gm-Message-State: AOJu0Ywm3ucWNpLiY/wgKTUF8UGugaDJ6u/eDVfKRLpbRfo3Di8Hs7ss
	oCZk6fy78MRRhddb76pxtdRFi4UMpsw70gEgdMI4wL5pM9s4c8aMpTpH7Oaafjs=
X-Google-Smtp-Source: AGHT+IGBJTUn4G0TBWUY3naga/9fZR+Z7x69pBYcJ3DVPNOToXNR3nJuUN8FrHtPnIvFdocGF8wdUQ==
X-Received: by 2002:a17:907:d042:b0:a6f:9550:c0ee with SMTP id a640c23a62f3a-a6fa430f3f1mr452004166b.18.1718896950979;
        Thu, 20 Jun 2024 08:22:30 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56f416dfsm775943366b.164.2024.06.20.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 9CFFA5FA01;
	Thu, 20 Jun 2024 16:22:21 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 06/12] sysemu: generalise qtest_warp_clock as qemu_clock_advance_virtual_time
Date: Thu, 20 Jun 2024 16:22:14 +0100
Message-Id: <20240620152220.2192768-7-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Move the key functionality of moving time forward into the clock
sub-system itself. This will allow us to plumb in time control into
plugins.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20240530220610.1245424-4-pierrick.bouvier@linaro.org>

--
v2
  - use target_ns in docs and signature
---
 include/qemu/timer.h | 15 +++++++++++++++
 system/qtest.c       | 25 +++----------------------
 util/qemu-timer.c    | 26 ++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/include/qemu/timer.h b/include/qemu/timer.h
index 9a366e551f..5ce83c7911 100644
--- a/include/qemu/timer.h
+++ b/include/qemu/timer.h
@@ -245,6 +245,21 @@ bool qemu_clock_run_timers(QEMUClockType type);
  */
 bool qemu_clock_run_all_timers(void);
 
+/**
+ * qemu_clock_advance_virtual_time(): advance the virtual time tick
+ * @target_ns: target time in nanoseconds
+ *
+ * This function is used where the control of the flow of time has
+ * been delegated to outside the clock subsystem (be it qtest, icount
+ * or some other external source). You can ask the clock system to
+ * return @early at the first expired timer.
+ *
+ * Time can only move forward, attempts to reverse time would lead to
+ * an error.
+ *
+ * Returns: new virtual time.
+ */
+int64_t qemu_clock_advance_virtual_time(int64_t target_ns);
 
 /*
  * QEMUTimerList
diff --git a/system/qtest.c b/system/qtest.c
index 5be66b0140..8cb98966b4 100644
--- a/system/qtest.c
+++ b/system/qtest.c
@@ -337,26 +337,6 @@ void qtest_set_virtual_clock(int64_t count)
     qatomic_set_i64(&qtest_clock_counter, count);
 }
 
-static void qtest_clock_warp(int64_t dest)
-{
-    int64_t clock = cpus_get_virtual_clock();
-    AioContext *aio_context;
-    assert(qtest_enabled());
-    aio_context = qemu_get_aio_context();
-    while (clock < dest) {
-        int64_t deadline = qemu_clock_deadline_ns_all(QEMU_CLOCK_VIRTUAL,
-                                                      QEMU_TIMER_ATTR_ALL);
-        int64_t warp = qemu_soonest_timeout(dest - clock, deadline);
-
-        cpus_set_virtual_clock(cpus_get_virtual_clock() + warp);
-
-        qemu_clock_run_timers(QEMU_CLOCK_VIRTUAL);
-        timerlist_run_timers(aio_context->tlg.tl[QEMU_CLOCK_VIRTUAL]);
-        clock = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
-    }
-    qemu_clock_notify(QEMU_CLOCK_VIRTUAL);
-}
-
 static bool (*process_command_cb)(CharBackend *chr, gchar **words);
 
 void qtest_set_command_cb(bool (*pc_cb)(CharBackend *chr, gchar **words))
@@ -751,7 +731,8 @@ static void qtest_process_command(CharBackend *chr, gchar **words)
             ns = qemu_clock_deadline_ns_all(QEMU_CLOCK_VIRTUAL,
                                             QEMU_TIMER_ATTR_ALL);
         }
-        qtest_clock_warp(qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + ns);
+        qemu_clock_advance_virtual_time(
+            qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + ns);
         qtest_send_prefix(chr);
         qtest_sendf(chr, "OK %"PRIi64"\n",
                     (int64_t)qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL));
@@ -777,7 +758,7 @@ static void qtest_process_command(CharBackend *chr, gchar **words)
         g_assert(words[1]);
         ret = qemu_strtoi64(words[1], NULL, 0, &ns);
         g_assert(ret == 0);
-        qtest_clock_warp(ns);
+        qemu_clock_advance_virtual_time(ns);
         qtest_send_prefix(chr);
         qtest_sendf(chr, "OK %"PRIi64"\n",
                     (int64_t)qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL));
diff --git a/util/qemu-timer.c b/util/qemu-timer.c
index 6a0de33dd2..213114be68 100644
--- a/util/qemu-timer.c
+++ b/util/qemu-timer.c
@@ -645,6 +645,11 @@ int64_t qemu_clock_get_ns(QEMUClockType type)
     }
 }
 
+static void qemu_virtual_clock_set_ns(int64_t time)
+{
+    return cpus_set_virtual_clock(time);
+}
+
 void init_clocks(QEMUTimerListNotifyCB *notify_cb)
 {
     QEMUClockType type;
@@ -675,3 +680,24 @@ bool qemu_clock_run_all_timers(void)
 
     return progress;
 }
+
+int64_t qemu_clock_advance_virtual_time(int64_t dest)
+{
+    int64_t clock = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
+    AioContext *aio_context;
+    aio_context = qemu_get_aio_context();
+    while (clock < dest) {
+        int64_t deadline = qemu_clock_deadline_ns_all(QEMU_CLOCK_VIRTUAL,
+                                                      QEMU_TIMER_ATTR_ALL);
+        int64_t warp = qemu_soonest_timeout(dest - clock, deadline);
+
+        qemu_virtual_clock_set_ns(qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) + warp);
+
+        qemu_clock_run_timers(QEMU_CLOCK_VIRTUAL);
+        timerlist_run_timers(aio_context->tlg.tl[QEMU_CLOCK_VIRTUAL]);
+        clock = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
+    }
+    qemu_clock_notify(QEMU_CLOCK_VIRTUAL);
+
+    return clock;
+}
-- 
2.39.2


