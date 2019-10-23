Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88299E1F39
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 17:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406734AbfJWPYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 11:24:49 -0400
Received: from mail-wr1-f74.google.com ([209.85.221.74]:40470 "EHLO
        mail-wr1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406683AbfJWPYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 11:24:48 -0400
Received: by mail-wr1-f74.google.com with SMTP id i10so3067971wrp.7
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 08:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5pfhpJx7UO/QNtR11zCiFnLuGkt6GlpMBjgSmMf75Tg=;
        b=amtMxUQEE/NOaMMB3lVYFv0UVIN4cbxrFTOMtC+0gOEicg9d0fwN7TprkrYhLBo/Qw
         2EleEu8IMAhzGJRgyAUacDO8oPPKbhqpC3R4dWMwut0HBsgzzBVDlz/ApsLhBcXyyTSm
         /eCD/zfLTh6s5SMDIXOKsRL2wDTNqNpwZqeVIVU9EF9beg2ShlZJPx/wjpr4r121AD4r
         J1naSOk9REiJ+0ShRF4cS702lhMN4FFHmRcdPJ6qvufDuGYARjHTD2Xpz5IW00jpiKBW
         8cijMl+bWToufDsT5R/eF6fNtOFNqFoN96aYFdTgT2zM1evjQCf9Rb/TDN7b5jUJEzw0
         AyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5pfhpJx7UO/QNtR11zCiFnLuGkt6GlpMBjgSmMf75Tg=;
        b=eub1SJ4CTpsG+n43CKfhU+oC23OYNdPYAyKl/eINZy5H4hMzLorh8rl8DabKM8/we6
         32ATHOTTVeJtc0DLNegUosFKQfvH3nhDu+l7BE2CXElKRpD5ml4ICWqSO6/Jvmw1AGiq
         PK7X8QmaFdysi1+0SahKwGRr7/abLNz6YcJ9eGOizd94DQIsppUGopi/b2DKCIed5/0x
         CdHZGrGtqRntb49SQ07LpRNbfWjdl30+g7I6+DDP5zZ+DH/esrC2dYOBgsQ5adt4Fj9n
         5aFbXIACIAOxjtyrJZxb5ATtG4lS0atX6dMYCm6tnnHQNZJsNI5R4xej6241jKCIEPix
         9tMA==
X-Gm-Message-State: APjAAAXESpKBnROXxBM3oaYcEvzr27XtD3akjnhLxFBXZupwpD2VW0JW
        E0y3/WAdEGRqILwCZFvP8exqnqT79S6M9iHn
X-Google-Smtp-Source: APXvYqzdi2O+812zGiyp5RRX+hLIIZ845MysjmhOziDahGLFuGnRWQ7rOw8CUUpGv+5aE1gSW2A1zPgWo9uj7H6o
X-Received: by 2002:a5d:6ac3:: with SMTP id u3mr9376179wrw.206.1571844285109;
 Wed, 23 Oct 2019 08:24:45 -0700 (PDT)
Date:   Wed, 23 Oct 2019 17:24:31 +0200
In-Reply-To: <cover.1571844200.git.andreyknvl@google.com>
Message-Id: <dbdc28301a918b307baf9e5d12fee1ed91a483f3.1571844200.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1571844200.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 3/3] vhost, kcov: collect coverage from vhost_worker
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds kcov_remote_start()/kcov_remote_stop() annotations to the
vhost_worker() function, which is responsible for processing vhost works.
Since vhost_worker() threads are spawned per vhost device instance
the common kcov handle is used for kcov_remote_start()/stop() annotations
(see Documentation/dev-tools/kcov.rst for details). As the result kcov can
now be used to collect coverage from vhost worker threads.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/vhost/vhost.c | 6 ++++++
 drivers/vhost/vhost.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 36ca2cf419bf..f44340b41494 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -30,6 +30,7 @@
 #include <linux/sched/signal.h>
 #include <linux/interval_tree_generic.h>
 #include <linux/nospec.h>
+#include <linux/kcov.h>
 
 #include "vhost.h"
 
@@ -357,7 +358,9 @@ static int vhost_worker(void *data)
 		llist_for_each_entry_safe(work, work_next, node, node) {
 			clear_bit(VHOST_WORK_QUEUED, &work->flags);
 			__set_current_state(TASK_RUNNING);
+			kcov_remote_start_common(dev->kcov_handle);
 			work->fn(work);
+			kcov_remote_stop();
 			if (need_resched())
 				schedule();
 		}
@@ -546,6 +549,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	/* No owner, become one */
 	dev->mm = get_task_mm(current);
+	dev->kcov_handle = kcov_common_handle();
 	worker = kthread_create(vhost_worker, dev, "vhost-%d", current->pid);
 	if (IS_ERR(worker)) {
 		err = PTR_ERR(worker);
@@ -571,6 +575,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 	if (dev->mm)
 		mmput(dev->mm);
 	dev->mm = NULL;
+	dev->kcov_handle = 0;
 err_mm:
 	return err;
 }
@@ -682,6 +687,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	if (dev->worker) {
 		kthread_stop(dev->worker);
 		dev->worker = NULL;
+		dev->kcov_handle = 0;
 	}
 	if (dev->mm)
 		mmput(dev->mm);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index e9ed2722b633..a123fd70847e 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -173,6 +173,7 @@ struct vhost_dev {
 	int iov_limit;
 	int weight;
 	int byte_weight;
+	u64 kcov_handle;
 };
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
-- 
2.24.0.rc0.303.g954a862665-goog

