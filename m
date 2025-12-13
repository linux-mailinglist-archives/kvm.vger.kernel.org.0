Return-Path: <kvm+bounces-65912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 874D6CBA19C
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D38330A4B1E
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E753A1A316E;
	Sat, 13 Dec 2025 00:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pKB5ceJ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973392110E
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 00:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765584896; cv=none; b=SefNjPtQ/BTybK82i3dh4A9yHWDPu/l5s3lWQWVLDoLepBwsHYtKpVJ1LM4PAztJM4QpugPjudX/pORRUpFYtz88WCFKkMuTnpzVpyQ3wYXbL5G6nuoBDFlrif7/aIWw7anCaEFqUbxNsroAGnRjJ+6p1uKgxVCcOwfGuqEbNL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765584896; c=relaxed/simple;
	bh=OyZd0jMzKlJrVGDzcwWpQ+1qBttzT2dSWjy0jVkb8SU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RZzcx00V7V8YfgJpbKKGiELx/2/o4/4r2RqgxUTqrzwdhRJHXbKJffjLrt0sCujElamYjTl1fVe/JCf9pqBjIBawU+GRVVL+w+KNRbsO0uN3RdjLT8Ro+/1WyRgHrCPwhsP4ZEzuUdkjhafym5y52cdSmaM+Fc1YlyOxbQWCgiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pKB5ceJ8; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-bc240cdb249so1589219a12.3
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 16:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765584894; x=1766189694; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cIINZ9mAAnwnFIApNJGoEI7Ff32PcTgxuAaJihLVJeo=;
        b=pKB5ceJ8t57LyYnL/XFBUl2+g0ef9oW3gIjbr37h4mkBSM5uZh6qFyaHlrUKR5fwyE
         XY009xfWBSx0Qinr9utcMcN7eOFvAUUgP5PXHi03fXCzil+gw+HURf9U0qypit7DlvB4
         s0wfNNZ2yPH0j7mQOWy4vb+Tuh+AeYaOv7iahwRR4cX6TSoxNI4z7zRlwVDj7rDUzfOU
         Mt6wfLzLqGQY8nkeoMwpLQpo59XXQaltHFVIxv/piaKU/Qj1J/GTzTS6LRfNSrDaXFn3
         Qm/kmWQMVyuumti1y/+iyTCw4iKzigxBwnnPYbPovmVwoPLD8zPfTvb747MFzHlsAgkr
         f5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765584894; x=1766189694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIINZ9mAAnwnFIApNJGoEI7Ff32PcTgxuAaJihLVJeo=;
        b=acUqGV3du9/TfuHqgi/1Q7oim82i6AwvjAjE2v7ns3yYZBZajURCKO1h/rEM7U5g/d
         nJxDzt2QFoVerZzcQs/sT6pN/HrwUA4BgV9IqTJhC5GTNif4wB+EtjDzs8iixZp8kA0D
         9EMFJRGBEFN7WpcQl0rpq6S0BmKSkjBx13bo1g4HuhEnMBs3UUlFflUaiIs7ppw2Ee94
         kNRSGErsxn6anMjzDPpYClQBSSqyNafKsxhnMA8+Z4h2CnWFewkW1cn/Cb2CyzSF54RJ
         tFOmM2Ig+kOTnBI8LUVu8DqHODW49mdhqHRVKqGz8ujv6nvJLIYnms2FI/strIiRtIz6
         tnJA==
X-Forwarded-Encrypted: i=1; AJvYcCVKaGpxnV/61oTmZQHELH1Rfs13QxjAEqG6R1tSSqCL63oLZ2HScsAQ2QbwTiHuQUb/cC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWdyIQ0235iMxMeFs5ddzT91yXVAb0bjiJJyOjvaIKsjub0xn3
	fapkbzDlM0g6OInPVs3eRes0dFhJGPnjo4EIHoKFNNIoQkXLPJgVOi725sNi2oLgnJYZROJiy+U
	/6uEw+Zhy3g+eLoDJISXaYQ==
X-Google-Smtp-Source: AGHT+IERTu/TvouPTqzMqN3ZIas79v3Ibpzrcwkdq6SBy47/OiGEzsE9m49kedocAPClataQQ5xVjjJRVwvvkCtI
X-Received: from dlg19.prod.google.com ([2002:a05:7022:793:b0:119:78ff:fe0f])
 (user=marcmorcos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7023:a85:b0:11a:fec5:d005 with SMTP id a92af1059eb24-11f34bde202mr2623159c88.10.1765584893863;
 Fri, 12 Dec 2025 16:14:53 -0800 (PST)
Date: Sat, 13 Dec 2025 00:14:41 +0000
In-Reply-To: <20251213001443.2041258-1-marcmorcos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251213001443.2041258-1-marcmorcos@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251213001443.2041258-3-marcmorcos@google.com>
Subject: [PATCH 2/4] thread-pool: Fix thread race
From: Marc Morcos <marcmorcos@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Eduardo Habkost <eduardo@habkost.net>, "Dr . David Alan Gilbert" <dave@treblig.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Marc Morcos <marcmorcos@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a data race occurred between `worker_thread()` writing and
`thread_pool_completion_bh()` reading shared data in `util/thread-pool.c`.

Signed-off-by: Marc Morcos <marcmorcos@google.com>
---
 util/thread-pool.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/util/thread-pool.c b/util/thread-pool.c
index d2ead6b728..1ced3bd371 100644
--- a/util/thread-pool.c
+++ b/util/thread-pool.c
@@ -18,6 +18,7 @@
 #include "qemu/defer-call.h"
 #include "qemu/queue.h"
 #include "qemu/thread.h"
+#include "qemu/atomic.h"
 #include "qemu/coroutine.h"
 #include "trace.h"
 #include "block/thread-pool.h"
@@ -39,9 +40,13 @@ struct ThreadPoolElementAio {
     ThreadPoolFunc *func;
     void *arg;
 
-    /* Moving state out of THREAD_QUEUED is protected by lock.  After
-     * that, only the worker thread can write to it.  Reads and writes
-     * of state and ret are ordered with memory barriers.
+    /*
+     * Accessed with atomics.  Moving state out of THREAD_QUEUED is
+     * protected by pool->lock and only the worker thread can move
+     * the state from THREAD_ACTIVE to THREAD_DONE.
+     *
+     * When state is THREAD_DONE, ret must have been written already.
+     * Use acquire/release ordering when reading/writing ret as well.
      */
     enum ThreadState state;
     int ret;
@@ -105,15 +110,14 @@ static void *worker_thread(void *opaque)
 
         req = QTAILQ_FIRST(&pool->request_list);
         QTAILQ_REMOVE(&pool->request_list, req, reqs);
-        req->state = THREAD_ACTIVE;
+        qatomic_set(&req->state, THREAD_ACTIVE);
         qemu_mutex_unlock(&pool->lock);
 
         ret = req->func(req->arg);
 
         req->ret = ret;
-        /* Write ret before state.  */
-        smp_wmb();
-        req->state = THREAD_DONE;
+        /* _release to write ret before state.  */
+        qatomic_store_release(&req->state, THREAD_DONE);
 
         qemu_bh_schedule(pool->completion_bh);
         qemu_mutex_lock(&pool->lock);
@@ -180,7 +184,8 @@ static void thread_pool_completion_bh(void *opaque)
 
 restart:
     QLIST_FOREACH_SAFE(elem, &pool->head, all, next) {
-        if (elem->state != THREAD_DONE) {
+        /* _acquire to read state before ret.  */
+        if (qatomic_load_acquire(&elem->state) != THREAD_DONE) {
             continue;
         }
 
@@ -189,9 +194,6 @@ restart:
         QLIST_REMOVE(elem, all);
 
         if (elem->common.cb) {
-            /* Read state before ret.  */
-            smp_rmb();
-
             /* Schedule ourselves in case elem->common.cb() calls aio_poll() to
              * wait for another request that completed at the same time.
              */
@@ -223,12 +225,12 @@ static void thread_pool_cancel(BlockAIOCB *acb)
     trace_thread_pool_cancel_aio(elem, elem->common.opaque);
 
     QEMU_LOCK_GUARD(&pool->lock);
-    if (elem->state == THREAD_QUEUED) {
+    if (qatomic_read(&elem->state) == THREAD_QUEUED) {
         QTAILQ_REMOVE(&pool->request_list, elem, reqs);
         qemu_bh_schedule(pool->completion_bh);
 
-        elem->state = THREAD_DONE;
-        elem->ret = -ECANCELED;
+        qatomic_set(&elem->ret, -ECANCELED);
+        qatomic_store_release(&elem->state, THREAD_DONE);
     }
 
 }
-- 
2.52.0.239.gd5f0c6e74e-goog


