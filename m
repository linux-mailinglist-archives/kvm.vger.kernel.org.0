Return-Path: <kvm+bounces-45969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DFE8AB0322
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 20:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FABC985621
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 18:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C73B2798ED;
	Thu,  8 May 2025 18:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dab/8Qes"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B965287509
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 18:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730016; cv=none; b=c/FKyt/dWcphc6tG6/LonjhqaY7Y8UmT7b0cG4mZSVaZqKjl9X6/PEw3PuFaBMQwlOri7/6Rli/1RJjTGX2D9poF9JKv46QQuv79W+15FQezLwUhGnjpiT4ZVufOgozJJ71QXCUfQ7XEcilnSlKkPl/AOaCjMQyYoz/E3kElZAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730016; c=relaxed/simple;
	bh=2zlOsbrXOKvpKxOQtyINONcY1OAOsAyDfaqD4GbpVTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JFIp9h6Ikhy+aTEIgXoXoht7XaqAOjemru+7aQG6vcOKVuReuL7Cu4FeSkUhyZ1ZCrxZqhmfwYUlksL+F2e+kcVCbaJGh194hoHBi5VeSwHyTUzdXWsDfwIsVh9rgaildqQZiPMp2wmQ5556UXZUCwwR/f+O6jhKAlmthRcy2Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dab/8Qes; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-4c58bbe00ebso316590137.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 11:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746730013; x=1747334813; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ho5EBVy1X8wD8IAytwlI/FNNysTpSwOecb1lJqJ7yC0=;
        b=dab/8QesuUddepHr57OdcWA2CcKbptQBNoTfSAZ9uSap1K9cXeVb4vCKEcSzsUzu2S
         fC4QvYmdTF/wyGEA3Nm8xTtUy5DbOhqpVvT0WM4Obx4E1bDVJm815WMRIsQaOZtgDnes
         lYqRvd75HgzpE26XJqWCVV+ISI3xgPpWqN/KxWvP/1Z0Z0VMfin35OOj5ayngT9ISmup
         smkC3DjMYMoHyL/R9vFqNCueEEM1xORwd8eNI54tKFyd+Bk+PO8k+3CegP9grusKtcAn
         PDs5niUsjsfnS6dqS1RTF1VVN/QjbN8twvwmhkpWKyTst4CF1ALMy3uzt1BHVuWVuPNi
         W2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730013; x=1747334813;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ho5EBVy1X8wD8IAytwlI/FNNysTpSwOecb1lJqJ7yC0=;
        b=tPsO8GG7wxRo/F24Kewp6qqVk8aMULJQz7jGsOL9NAofFY37go0A/OXqtxKXIn1gJe
         qX3Q+brRgGiD0JobC2diWP/zDkSoSHmRXpneEU7YFanui3pFncZ74ktQClJFKz/7ZoI0
         lrUrmJU9bUutDuUl88EmsOyjSjhJUK3GYrfa0xJAiAqgqVfwNDohQro61ehLvibhGYkL
         uXWw73JN0Ce0Il6gkyMB4ks/x7tzx9KTF/gc8SoE00ojeDWvf0eXMND/TEcmDhUUOva1
         NxioAwaHBL/i1WScird4JvPczxTbja6ny2Y1AC/l8wCm2Ys99dovRJkChOaEuHuEqgeT
         3Zrw==
X-Forwarded-Encrypted: i=1; AJvYcCVLGy4Z05NN9Gyhg3f0Vwd4ttuGMBPqdcqp2iVXg6l1q2yih/Zje2230wPl7nEIVOh/kmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgAdHOln3CEoyN7WmOX2q4UD7BbfPCbhtb3Fl5qLFZTWWBJr6e
	vZ/GHLbPPCLusTN651NI6U1Whoemd4T6lB51E3b16+d3VbvqvpPQoOELtYi9v1xg5bFizojm+wH
	ob8BuTP/uikJLYRchvA==
X-Google-Smtp-Source: AGHT+IG+Ktw2TRWaNA2c/slycRN+I23OsKqIBnhedgC898fwZF1LQsk23WFexmZdOVeoiRImDSIoMtqhLLazt25f
X-Received: from vsvj5.prod.google.com ([2002:a05:6102:3e05:b0:4dd:b44f:e267])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3e18:b0:4de:81a:7d3e with SMTP id ada2fe7eead31-4deed32b1fcmr767025137.2.1746730013348;
 Thu, 08 May 2025 11:46:53 -0700 (PDT)
Date: Thu,  8 May 2025 18:46:44 +0000
In-Reply-To: <20250508184649.2576210-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508184649.2576210-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250508184649.2576210-4-jthoughton@google.com>
Subject: [PATCH v4 3/7] cgroup: selftests: Move memcontrol specific helpers
 out of common cgroup_util.c
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Sean Christopherson <seanjc@google.com>

Move a handful of helpers out of cgroup_util.c and into test_memcontrol.c
that have nothing to with cgroups in general, in anticipation of making
cgroup_util.c a generic library that can be used by other selftests.

Make read_text() and write_text() non-static so test_memcontrol.c can
use them.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
---
Sean's original patch[1] didn't build for me, hence the read_text() and
write_text() change.

[1]: https://lore.kernel.org/kvm/aBAlcrTtBDeQCL0X@google.com/
---

 tools/testing/selftests/cgroup/cgroup_util.c  | 82 +------------------
 tools/testing/selftests/cgroup/cgroup_util.h  |  8 +-
 .../selftests/cgroup/test_memcontrol.c        | 78 ++++++++++++++++++
 3 files changed, 83 insertions(+), 85 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/s=
elftests/cgroup/cgroup_util.c
index 1e2d46636a0ca..0ef3b8b8d7f74 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -20,7 +20,7 @@
 #include "../clone3/clone3_selftests.h"
=20
 /* Returns read len on success, or -errno on failure. */
-static ssize_t read_text(const char *path, char *buf, size_t max_len)
+ssize_t read_text(const char *path, char *buf, size_t max_len)
 {
 	ssize_t len;
 	int fd;
@@ -39,7 +39,7 @@ static ssize_t read_text(const char *path, char *buf, siz=
e_t max_len)
 }
=20
 /* Returns written len on success, or -errno on failure. */
-static ssize_t write_text(const char *path, char *buf, ssize_t len)
+ssize_t write_text(const char *path, char *buf, ssize_t len)
 {
 	int fd;
=20
@@ -488,84 +488,6 @@ int cg_run_nowait(const char *cgroup,
 	return pid;
 }
=20
-int get_temp_fd(void)
-{
-	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
-}
-
-int alloc_pagecache(int fd, size_t size)
-{
-	char buf[PAGE_SIZE];
-	struct stat st;
-	int i;
-
-	if (fstat(fd, &st))
-		goto cleanup;
-
-	size +=3D st.st_size;
-
-	if (ftruncate(fd, size))
-		goto cleanup;
-
-	for (i =3D 0; i < size; i +=3D sizeof(buf))
-		read(fd, buf, sizeof(buf));
-
-	return 0;
-
-cleanup:
-	return -1;
-}
-
-int alloc_anon(const char *cgroup, void *arg)
-{
-	size_t size =3D (unsigned long)arg;
-	char *buf, *ptr;
-
-	buf =3D malloc(size);
-	for (ptr =3D buf; ptr < buf + size; ptr +=3D PAGE_SIZE)
-		*ptr =3D 0;
-
-	free(buf);
-	return 0;
-}
-
-int is_swap_enabled(void)
-{
-	char buf[PAGE_SIZE];
-	const char delim[] =3D "\n";
-	int cnt =3D 0;
-	char *line;
-
-	if (read_text("/proc/swaps", buf, sizeof(buf)) <=3D 0)
-		return -1;
-
-	for (line =3D strtok(buf, delim); line; line =3D strtok(NULL, delim))
-		cnt++;
-
-	return cnt > 1;
-}
-
-int set_oom_adj_score(int pid, int score)
-{
-	char path[PATH_MAX];
-	int fd, len;
-
-	sprintf(path, "/proc/%d/oom_score_adj", pid);
-
-	fd =3D open(path, O_WRONLY | O_APPEND);
-	if (fd < 0)
-		return fd;
-
-	len =3D dprintf(fd, "%d", score);
-	if (len < 0) {
-		close(fd);
-		return len;
-	}
-
-	close(fd);
-	return 0;
-}
-
 int proc_mount_contains(const char *option)
 {
 	char buf[4 * PAGE_SIZE];
diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/s=
elftests/cgroup/cgroup_util.h
index 19b131ee77072..139c870ecc285 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -21,6 +21,9 @@ static inline int values_close(long a, long b, int err)
 	return labs(a - b) <=3D (a + b) / 100 * err;
 }
=20
+extern ssize_t read_text(const char *path, char *buf, size_t max_len);
+extern ssize_t write_text(const char *path, char *buf, ssize_t len);
+
 extern int cg_find_unified_root(char *root, size_t len, bool *nsdelegate);
 extern char *cg_name(const char *root, const char *name);
 extern char *cg_name_indexed(const char *root, const char *name, int index=
);
@@ -49,11 +52,6 @@ extern int cg_enter_current_thread(const char *cgroup);
 extern int cg_run_nowait(const char *cgroup,
 			 int (*fn)(const char *cgroup, void *arg),
 			 void *arg);
-extern int get_temp_fd(void);
-extern int alloc_pagecache(int fd, size_t size);
-extern int alloc_anon(const char *cgroup, void *arg);
-extern int is_swap_enabled(void);
-extern int set_oom_adj_score(int pid, int score);
 extern int cg_wait_for_proc_count(const char *cgroup, int count);
 extern int cg_killall(const char *cgroup);
 int proc_mount_contains(const char *option);
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testi=
ng/selftests/cgroup/test_memcontrol.c
index 16f5d74ae762e..2908f4e0629db 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -24,6 +24,84 @@
 static bool has_localevents;
 static bool has_recursiveprot;
=20
+int get_temp_fd(void)
+{
+	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
+}
+
+int alloc_pagecache(int fd, size_t size)
+{
+	char buf[PAGE_SIZE];
+	struct stat st;
+	int i;
+
+	if (fstat(fd, &st))
+		goto cleanup;
+
+	size +=3D st.st_size;
+
+	if (ftruncate(fd, size))
+		goto cleanup;
+
+	for (i =3D 0; i < size; i +=3D sizeof(buf))
+		read(fd, buf, sizeof(buf));
+
+	return 0;
+
+cleanup:
+	return -1;
+}
+
+int alloc_anon(const char *cgroup, void *arg)
+{
+	size_t size =3D (unsigned long)arg;
+	char *buf, *ptr;
+
+	buf =3D malloc(size);
+	for (ptr =3D buf; ptr < buf + size; ptr +=3D PAGE_SIZE)
+		*ptr =3D 0;
+
+	free(buf);
+	return 0;
+}
+
+int is_swap_enabled(void)
+{
+	char buf[PAGE_SIZE];
+	const char delim[] =3D "\n";
+	int cnt =3D 0;
+	char *line;
+
+	if (read_text("/proc/swaps", buf, sizeof(buf)) <=3D 0)
+		return -1;
+
+	for (line =3D strtok(buf, delim); line; line =3D strtok(NULL, delim))
+		cnt++;
+
+	return cnt > 1;
+}
+
+int set_oom_adj_score(int pid, int score)
+{
+	char path[PATH_MAX];
+	int fd, len;
+
+	sprintf(path, "/proc/%d/oom_score_adj", pid);
+
+	fd =3D open(path, O_WRONLY | O_APPEND);
+	if (fd < 0)
+		return fd;
+
+	len =3D dprintf(fd, "%d", score);
+	if (len < 0) {
+		close(fd);
+		return len;
+	}
+
+	close(fd);
+	return 0;
+}
+
 /*
  * This test creates two nested cgroups with and without enabling
  * the memory controller.
--=20
2.49.0.1015.ga840276032-goog


