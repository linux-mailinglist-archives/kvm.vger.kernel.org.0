Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082E16E7ABB
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbjDSN2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbjDSN17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:59 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626205242
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:52 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id q5so17102570wmo.4
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910871; x=1684502871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmoGW5X1O839Cwu8Q7/lXYJaS1OiSBNH/27QndO9Yqc=;
        b=iu8BNsFASwRmYCmLAkI8gpitRqLAGARQs33KvZi6k+ro3vRggzWzNh+be7jzJCHT0E
         3L3WgfWK5988Pi2IToPtKG+CgeAayyj21Q8FwtGcdvRp1qH5d+5orYRS4Vo/0enMClbz
         JWAfLOyRyOvLNE+G4T+7HYBiThPYpZTuC+0YTdObiTkLgyswnGNGlrQCxUUIuJenVExX
         leXJcWI94wt1uYSKhSl152nrFU26yiSQ2VR0jU4m4eUrbIInS1wWtZF3iIo/qTboFNVu
         pa9VXmuVluwKXtJ8SPc6dlrOrOdQNJj5Ud+PDiM1BrHvSMwBTXnFsgGLXEY8iaS3eIiN
         PTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910871; x=1684502871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vmoGW5X1O839Cwu8Q7/lXYJaS1OiSBNH/27QndO9Yqc=;
        b=OGaYcZ135Rmoim5eyxkWf78KY2iC14e4b5+nzq7+QYFgMBDULjXqY6pdnHFDnWENoN
         ZeBx5YSDEEDr0PuI9De6bjh5tyyPtPV7qLHzRTkwzOt2252bUWCd63qQUkMd/we+NfwN
         434vCxGaFiaKVgX8SD4DMWH7fY2EBheD+L7Ix417GI+eMXBqz7P44I5r+4HydRLy6xJU
         MRHyxhtM927wrZf+OEWf0AjYD7DfTzzA5djcQvHu03bMFCSfwTiSuDDmBB/34dcInei2
         qAEtLg3aUCKxENlrPM8Oc9IWQEffCYKqI3IwZBn5Xp3mOshlYXvqIF1QqGy658GaQnag
         GyOQ==
X-Gm-Message-State: AAQBX9cpv+nK9TRDIdwQwqMVfQpEceYYumD+zr0rCLiUZEnRvVRJdhjQ
        Y4H8ja/33a1Ube5u9wPTzQE/RxE+aFbCtYnjmFw=
X-Google-Smtp-Source: AKy350Z3l/qgOAMab7FXe1T0+BciW8XQQ8M02hdD8sFDM0n8nEfflTYkDNNK5fYnNUAKSQJQz56lRQ==
X-Received: by 2002:a05:600c:20b:b0:3f1:72dc:8bae with SMTP id 11-20020a05600c020b00b003f172dc8baemr9487957wmi.21.1681910870792;
        Wed, 19 Apr 2023 06:27:50 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:50 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 14/16] Factor epoll thread
Date:   Wed, 19 Apr 2023 14:21:18 +0100
Message-Id: <20230419132119.124457-15-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419132119.124457-1-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both ioeventfd and ipc use an epoll thread roughly the same way. In
order to add a new epoll user, factor the common bits into epoll.c

Slight implementation changes which shouldn't affect behavior:

* At the moment ioeventfd mixes file descriptor (for the stop event) and
  pointers in the epoll_event.data union, which could in theory cause
  aliasing. Use a pointer for the stop event instead. kvm-ipc uses only
  file descriptors. It could be changed but since epoll.c compares the
  stop event pointer first, the risk of aliasing with an fd is much
  lower there.

* kvm-ipc uses EPOLLET, edge-triggered events, but having the stop event
  level-triggered shouldn't make a difference.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Makefile            |   1 +
 include/kvm/epoll.h |  17 ++++++++
 epoll.c             |  89 ++++++++++++++++++++++++++++++++++++++
 ioeventfd.c         |  94 ++++++----------------------------------
 kvm-ipc.c           | 103 +++++++++++++-------------------------------
 5 files changed, 149 insertions(+), 155 deletions(-)
 create mode 100644 include/kvm/epoll.h
 create mode 100644 epoll.c

diff --git a/Makefile b/Makefile
index 86e19339..6b742369 100644
--- a/Makefile
+++ b/Makefile
@@ -80,6 +80,7 @@ OBJS	+= virtio/vhost.o
 OBJS	+= disk/blk.o
 OBJS	+= disk/qcow.o
 OBJS	+= disk/raw.o
+OBJS	+= epoll.o
 OBJS	+= ioeventfd.o
 OBJS	+= net/uip/core.o
 OBJS	+= net/uip/arp.o
diff --git a/include/kvm/epoll.h b/include/kvm/epoll.h
new file mode 100644
index 00000000..dbb5a8d9
--- /dev/null
+++ b/include/kvm/epoll.h
@@ -0,0 +1,17 @@
+#include <sys/epoll.h>
+#include "kvm/kvm.h"
+
+typedef void (*epoll__event_handler_t)(struct kvm *kvm, struct epoll_event *ev);
+
+struct kvm__epoll {
+	int fd;
+	int stop_fd;
+	struct kvm *kvm;
+	const char *name;
+	pthread_t thread;
+	epoll__event_handler_t handle_event;
+};
+
+int epoll__init(struct kvm *kvm, struct kvm__epoll *epoll,
+		const char *name, epoll__event_handler_t handle_event);
+int epoll__exit(struct kvm__epoll *epoll);
diff --git a/epoll.c b/epoll.c
new file mode 100644
index 00000000..e0725a57
--- /dev/null
+++ b/epoll.c
@@ -0,0 +1,89 @@
+#include <sys/eventfd.h>
+
+#include "kvm/epoll.h"
+
+#define EPOLLFD_MAX_EVENTS	20
+
+static void *epoll__thread(void *param)
+{
+	u64 stop;
+	int nfds, i;
+	struct kvm__epoll *epoll = param;
+	struct kvm *kvm = epoll->kvm;
+	struct epoll_event events[EPOLLFD_MAX_EVENTS];
+
+	kvm__set_thread_name(epoll->name);
+
+	for (;;) {
+		nfds = epoll_wait(epoll->fd, events, EPOLLFD_MAX_EVENTS, -1);
+		for (i = 0; i < nfds; i++) {
+			if (events[i].data.ptr == &epoll->stop_fd)
+				goto done;
+
+			epoll->handle_event(kvm, &events[i]);
+		}
+	}
+done:
+	read(epoll->stop_fd, &stop, sizeof(stop));
+	write(epoll->stop_fd, &stop, sizeof(stop));
+	return NULL;
+}
+
+int epoll__init(struct kvm *kvm, struct kvm__epoll *epoll,
+		const char *name, epoll__event_handler_t handle_event)
+{
+	int r;
+	struct epoll_event stop_event = {
+		.events = EPOLLIN,
+		.data.ptr = &epoll->stop_fd,
+	};
+
+	epoll->kvm = kvm;
+	epoll->name = name;
+	epoll->handle_event = handle_event;
+
+	epoll->fd = epoll_create(EPOLLFD_MAX_EVENTS);
+	if (epoll->fd < 0)
+		return -errno;
+
+	epoll->stop_fd = eventfd(0, 0);
+	if (epoll->stop_fd < 0) {
+		r = -errno;
+		goto err_close_fd;
+	}
+
+	r = epoll_ctl(epoll->fd, EPOLL_CTL_ADD, epoll->stop_fd, &stop_event);
+	if (r < 0)
+		goto err_close_all;
+
+	r = pthread_create(&epoll->thread, NULL, epoll__thread, epoll);
+	if (r < 0)
+		goto err_close_all;
+
+	return 0;
+
+err_close_all:
+	close(epoll->stop_fd);
+err_close_fd:
+	close(epoll->fd);
+
+	return r;
+}
+
+int epoll__exit(struct kvm__epoll *epoll)
+{
+	int r;
+	u64 stop = 1;
+
+	r = write(epoll->stop_fd, &stop, sizeof(stop));
+	if (r < 0)
+		return r;
+
+	r = read(epoll->stop_fd, &stop, sizeof(stop));
+	if (r < 0)
+		return r;
+
+	close(epoll->stop_fd);
+	close(epoll->fd);
+	return 0;
+}
diff --git a/ioeventfd.c b/ioeventfd.c
index 3ae82672..a0fc2578 100644
--- a/ioeventfd.c
+++ b/ioeventfd.c
@@ -9,113 +9,45 @@
 #include <linux/kvm.h>
 #include <linux/types.h>
 
+#include "kvm/epoll.h"
 #include "kvm/ioeventfd.h"
 #include "kvm/kvm.h"
 #include "kvm/util.h"
 
 #define IOEVENTFD_MAX_EVENTS	20
 
-static struct	epoll_event events[IOEVENTFD_MAX_EVENTS];
-static int	epoll_fd, epoll_stop_fd;
 static LIST_HEAD(used_ioevents);
 static bool	ioeventfd_avail;
+static struct kvm__epoll epoll;
 
-static void *ioeventfd__thread(void *param)
+static void ioeventfd__handle_event(struct kvm *kvm, struct epoll_event *ev)
 {
-	u64 tmp = 1;
+	u64 tmp;
+	struct ioevent *ioevent = ev->data.ptr;
 
-	kvm__set_thread_name("ioeventfd-worker");
+	if (read(ioevent->fd, &tmp, sizeof(tmp)) < 0)
+		die("Failed reading event");
 
-	for (;;) {
-		int nfds, i;
-
-		nfds = epoll_wait(epoll_fd, events, IOEVENTFD_MAX_EVENTS, -1);
-		for (i = 0; i < nfds; i++) {
-			struct ioevent *ioevent;
-
-			if (events[i].data.fd == epoll_stop_fd)
-				goto done;
-
-			ioevent = events[i].data.ptr;
-
-			if (read(ioevent->fd, &tmp, sizeof(tmp)) < 0)
-				die("Failed reading event");
-
-			ioevent->fn(ioevent->fn_kvm, ioevent->fn_ptr);
-		}
-	}
-
-done:
-	tmp = write(epoll_stop_fd, &tmp, sizeof(tmp));
-
-	return NULL;
-}
-
-static int ioeventfd__start(void)
-{
-	pthread_t thread;
-
-	if (!ioeventfd_avail)
-		return -ENOSYS;
-
-	return pthread_create(&thread, NULL, ioeventfd__thread, NULL);
+	ioevent->fn(ioevent->fn_kvm, ioevent->fn_ptr);
 }
 
 int ioeventfd__init(struct kvm *kvm)
 {
-	struct epoll_event epoll_event = {.events = EPOLLIN};
-	int r;
-
 	ioeventfd_avail = kvm__supports_extension(kvm, KVM_CAP_IOEVENTFD);
 	if (!ioeventfd_avail)
 		return 1; /* Not fatal, but let caller determine no-go. */
 
-	epoll_fd = epoll_create(IOEVENTFD_MAX_EVENTS);
-	if (epoll_fd < 0)
-		return -errno;
-
-	epoll_stop_fd = eventfd(0, 0);
-	epoll_event.data.fd = epoll_stop_fd;
-
-	r = epoll_ctl(epoll_fd, EPOLL_CTL_ADD, epoll_stop_fd, &epoll_event);
-	if (r < 0)
-		goto cleanup;
-
-	r = ioeventfd__start();
-	if (r < 0)
-		goto cleanup;
-
-	r = 0;
-
-	return r;
-
-cleanup:
-	close(epoll_stop_fd);
-	close(epoll_fd);
-
-	return r;
+	return epoll__init(kvm, &epoll, "ioeventfd-worker",
+			   ioeventfd__handle_event);
 }
 base_init(ioeventfd__init);
 
 int ioeventfd__exit(struct kvm *kvm)
 {
-	u64 tmp = 1;
-	int r;
-
 	if (!ioeventfd_avail)
 		return 0;
 
-	r = write(epoll_stop_fd, &tmp, sizeof(tmp));
-	if (r < 0)
-		return r;
-
-	r = read(epoll_stop_fd, &tmp, sizeof(tmp));
-	if (r < 0)
-		return r;
-
-	close(epoll_fd);
-	close(epoll_stop_fd);
-
+	epoll__exit(&epoll);
 	return 0;
 }
 base_exit(ioeventfd__exit);
@@ -165,7 +97,7 @@ int ioeventfd__add_event(struct ioevent *ioevent, int flags)
 			.data.ptr	= new_ioevent,
 		};
 
-		r = epoll_ctl(epoll_fd, EPOLL_CTL_ADD, event, &epoll_event);
+		r = epoll_ctl(epoll.fd, EPOLL_CTL_ADD, event, &epoll_event);
 		if (r) {
 			r = -errno;
 			goto cleanup;
@@ -213,7 +145,7 @@ int ioeventfd__del_event(u64 addr, u64 datamatch)
 
 	ioctl(ioevent->fn_kvm->vm_fd, KVM_IOEVENTFD, &kvm_ioevent);
 
-	epoll_ctl(epoll_fd, EPOLL_CTL_DEL, ioevent->fd, NULL);
+	epoll_ctl(epoll.fd, EPOLL_CTL_DEL, ioevent->fd, NULL);
 
 	list_del(&ioevent->list);
 
diff --git a/kvm-ipc.c b/kvm-ipc.c
index 23f7b12e..265d80c5 100644
--- a/kvm-ipc.c
+++ b/kvm-ipc.c
@@ -2,9 +2,9 @@
 #include <sys/un.h>
 #include <sys/types.h>
 #include <sys/socket.h>
-#include <sys/eventfd.h>
 #include <dirent.h>
 
+#include "kvm/epoll.h"
 #include "kvm/kvm-ipc.h"
 #include "kvm/rwsem.h"
 #include "kvm/read-write.h"
@@ -28,8 +28,8 @@ struct kvm_ipc_head {
 extern __thread struct kvm_cpu *current_kvm_cpu;
 static void (*msgs[KVM_IPC_MAX_MSGS])(struct kvm *kvm, int fd, u32 type, u32 len, u8 *msg);
 static DECLARE_RWSEM(msgs_rwlock);
-static int epoll_fd, server_fd, stop_fd;
-static pthread_t thread;
+static int server_fd;
+static struct kvm__epoll epoll;
 
 static int kvm__create_socket(struct kvm *kvm)
 {
@@ -268,7 +268,7 @@ static int kvm_ipc__new_conn(int fd)
 
 	ev.events = EPOLLIN | EPOLLRDHUP;
 	ev.data.fd = client;
-	if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, client, &ev) < 0) {
+	if (epoll_ctl(epoll.fd, EPOLL_CTL_ADD, client, &ev) < 0) {
 		close(client);
 		return -1;
 	}
@@ -278,7 +278,7 @@ static int kvm_ipc__new_conn(int fd)
 
 static void kvm_ipc__close_conn(int fd)
 {
-	epoll_ctl(epoll_fd, EPOLL_CTL_DEL, fd, NULL);
+	epoll_ctl(epoll.fd, EPOLL_CTL_DEL, fd, NULL);
 	close(fd);
 }
 
@@ -309,42 +309,26 @@ done:
 	return -1;
 }
 
-static void *kvm_ipc__thread(void *param)
+static void kvm_ipc__handle_event(struct kvm *kvm, struct epoll_event *ev)
 {
-	struct epoll_event event;
-	struct kvm *kvm = param;
+	int fd = ev->data.fd;
 
-	kvm__set_thread_name("kvm-ipc");
+	if (fd == server_fd) {
+		int client, r;
 
-	for (;;) {
-		int nfds;
-
-		nfds = epoll_wait(epoll_fd, &event, 1, -1);
-		if (nfds > 0) {
-			int fd = event.data.fd;
+		client = kvm_ipc__new_conn(fd);
+		/*
+		 * Handle multiple IPC cmd at a time
+		 */
+		do {
+			r = kvm_ipc__receive(kvm, client);
+		} while	(r == 0);
 
-			if (fd == stop_fd && event.events & EPOLLIN) {
-				break;
-			} else if (fd == server_fd) {
-				int client, r;
-
-				client = kvm_ipc__new_conn(fd);
-				/*
-				 * Handle multiple IPC cmd at a time
-				 */
-				do {
-					r = kvm_ipc__receive(kvm, client);
-				} while	(r == 0);
-
-			} else if (event.events & (EPOLLERR | EPOLLRDHUP | EPOLLHUP)) {
-				kvm_ipc__close_conn(fd);
-			} else {
-				kvm_ipc__receive(kvm, fd);
-			}
-		}
+	} else if (ev->events & (EPOLLERR | EPOLLRDHUP | EPOLLHUP)) {
+		kvm_ipc__close_conn(fd);
+	} else {
+		kvm_ipc__receive(kvm, fd);
 	}
-
-	return NULL;
 }
 
 static void kvm__pid(struct kvm *kvm, int fd, u32 type, u32 len, u8 *msg)
@@ -482,42 +466,21 @@ int kvm_ipc__init(struct kvm *kvm)
 
 	server_fd = sock;
 
-	epoll_fd = epoll_create(KVM_IPC_MAX_MSGS);
-	if (epoll_fd < 0) {
-		perror("epoll_create");
-		ret = epoll_fd;
+	ret = epoll__init(kvm, &epoll, "kvm-ipc",
+			  kvm_ipc__handle_event);
+	if (ret) {
+		pr_err("Failed starting IPC thread");
 		goto err;
 	}
 
 	ev.events = EPOLLIN | EPOLLET;
 	ev.data.fd = sock;
-	if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, sock, &ev) < 0) {
+	if (epoll_ctl(epoll.fd, EPOLL_CTL_ADD, sock, &ev) < 0) {
 		pr_err("Failed adding socket to epoll");
 		ret = -EFAULT;
 		goto err_epoll;
 	}
 
-	stop_fd = eventfd(0, 0);
-	if (stop_fd < 0) {
-		perror("eventfd");
-		ret = stop_fd;
-		goto err_epoll;
-	}
-
-	ev.events = EPOLLIN | EPOLLET;
-	ev.data.fd = stop_fd;
-	if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, stop_fd, &ev) < 0) {
-		pr_err("Failed adding stop event to epoll");
-		ret = -EFAULT;
-		goto err_stop;
-	}
-
-	if (pthread_create(&thread, NULL, kvm_ipc__thread, kvm) != 0) {
-		pr_err("Failed starting IPC thread");
-		ret = -EFAULT;
-		goto err_stop;
-	}
-
 	kvm_ipc__register_handler(KVM_IPC_PID, kvm__pid);
 	kvm_ipc__register_handler(KVM_IPC_DEBUG, handle_debug);
 	kvm_ipc__register_handler(KVM_IPC_PAUSE, handle_pause);
@@ -528,10 +491,9 @@ int kvm_ipc__init(struct kvm *kvm)
 
 	return 0;
 
-err_stop:
-	close(stop_fd);
 err_epoll:
-	close(epoll_fd);
+	epoll__exit(&epoll);
+	close(server_fd);
 err:
 	return ret;
 }
@@ -539,18 +501,11 @@ base_init(kvm_ipc__init);
 
 int kvm_ipc__exit(struct kvm *kvm)
 {
-	u64 val = 1;
-	int ret;
-
-	ret = write(stop_fd, &val, sizeof(val));
-	if (ret < 0)
-		return ret;
-
+	epoll__exit(&epoll);
 	close(server_fd);
-	close(epoll_fd);
 
 	kvm__remove_socket(kvm->cfg.guest_name);
 
-	return ret;
+	return 0;
 }
 base_exit(kvm_ipc__exit);
-- 
2.40.0

