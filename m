Return-Path: <kvm+bounces-44627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB773A9FEB7
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2E693AB7A7
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 01:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2B313D8A3;
	Tue, 29 Apr 2025 01:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bB08tbqF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263CB35947
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 01:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745888630; cv=none; b=ChZBz3IpAolJGpnPGsoOMgPVYdb8XTvVCJmPfW6IpOELQ+YXVrKb/HajZceWCZoBkrlfyTRDs3ytAHd0Zl7h9vMPXN7//I5pK9Tcw2rDLd+TiMZypzE/TIvRvDD3122D+tS6Yw1/qAOqTzy6pXpKjGdGxHfIpL/8QwObz6yPatI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745888630; c=relaxed/simple;
	bh=NMyHvEndM32QeMidto5Mn6t7yVRhd/4xcM1I2rtn6KQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NZRE1ZWGExTUlo7/w+vqrpDFpvF1vLzxDB01S2cg/wCn4hkR7lvrRIfWOGDt9Rm7xUlMjFz+f7tLB5TKV4sekScvojnvvyxccLPUmK/LFT7mK5KUZ2oe9R6ZeLcoiB3+SmI/0w9AG0fx47uYcq/ArTUzuqUOvHDtd7lg4yEt3Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bB08tbqF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22650077995so77129735ad.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 18:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745888628; x=1746493428; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0N6vnpk8vIOh+0TQjKECTwgmvexWONMh7U9hSe/aVEc=;
        b=bB08tbqFKJCwNBJmMDpLUVxAl/VNkoGE8dwGSIu4xCZwN9YaJ2cIhzJ1mizLdY++He
         Vpl+wVOLchq2KF5FftvwNdMH+lOm5wEYVo0YhIMK0usrkc4svAgdpOAr0a90IcNh7iDt
         JHJp+XL4WhtuXNon7hQDxuWjXdr0mblEjH2nKkoM5Xfei1+QDMyrhbcD8I5Oa7ng15O5
         6Dxbb1qSUSGTqFl7SithGLL8pRYJtRXwvGqEKccsW/+FfrvM2lhY/NV7fRBsDiOEG9tU
         sNdszg3Um1rIebIGqIyMGffuIJbRoOWcrC9IRAnU2p2X50ygGb5D8LoCd6xrbVleKpI7
         oqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745888628; x=1746493428;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0N6vnpk8vIOh+0TQjKECTwgmvexWONMh7U9hSe/aVEc=;
        b=FWHD9Rw8AX0odeJCAAOCNYDMCgh9H+/hT2jlCCrOl28vmb0UYrAw2UDZvO7teITddi
         y2Fh6w6ufaRo+SKkSIiY2l0pvn+INfECBxL/RRKhJ0Db9lHdX6stgk/NrvrdI0mcfl9Z
         wqAf2JAeQ2wir75eBC7ZlwxM4nLEf4l3XXnuPlPAxkVIqPhltlmAOAOih5f8RIAWPa2Q
         /q9MAmnByiQuDTD80C0H9Sn5diPLSIH8xm9kHxIENCzIRm39FQlkr4s+/LGHXfYu+XQO
         KBcSB2c2NuhJa9jHhofNoGT6S5zPo5VrfkECptlhc5Bgh3sbWw06FLXaYEUzKxMr3JjC
         yBEA==
X-Gm-Message-State: AOJu0YwcvicxhcV2rx5OpMjlp3BdhkabTgid9IKGQ/hoN3Has/JAYSqq
	YLsgpZ7u6cfrutRCkOfSr7sKKRUgFls1EVTgcCY8M7auxSxiAWE8gtfeINJ4avALjfgjCJXyiOh
	RWw==
X-Google-Smtp-Source: AGHT+IHM/661ZgZTepSBi2SA8Zn8aAamYmT/Kekoyia+DCTLnkUFlpflJKv4vilM+e8xUe42MNChePiEZoA=
X-Received: from plqw20.prod.google.com ([2002:a17:902:a714:b0:220:e952:af68])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da88:b0:224:5a8:ba2c
 with SMTP id d9443c01a7336-22de703cff0mr15246705ad.52.1745888628471; Mon, 28
 Apr 2025 18:03:48 -0700 (PDT)
Date: Mon, 28 Apr 2025 18:03:46 -0700
In-Reply-To: <20250414200929.3098202-5-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414200929.3098202-1-jthoughton@google.com> <20250414200929.3098202-5-jthoughton@google.com>
Message-ID: <aBAlcrTtBDeQCL0X@google.com>
Subject: Re: [PATCH v3 4/5] KVM: selftests: Build and link selftests/cgroup/lib
 into KVM selftests
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2025, James Houghton wrote:
> libcgroup.o is built separately from KVM selftests and cgroup selftests,
> so different compiler flags used by the different selftests will not
> conflict with each other.

This fails to build on some of my systems.  And it generates a warning, whi=
ch
thanks to me building KVM selftests with -Werror, is the only such warning =
in
all of KVM selftests.

tools/testing/selftests/cgroup/lib/cgroup_util.c:511:17: warning: ignoring =
return value of =E2=80=98read=E2=80=99 declared with attribute =E2=80=98war=
n_unused_result=E2=80=99 [-Wunused-result]
  511 |                 read(fd, buf, sizeof(buf));
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~

In file included from /usr/include/fcntl.h:314,
                 from tools/testing/selftests/cgroup/lib/cgroup_util.c:6:
In function =E2=80=98open=E2=80=99,
    inlined from =E2=80=98get_temp_fd=E2=80=99 at tools/testing/selftests/c=
group/lib/cgroup_util.c:493:9:
/usr/include/x86_64-linux-gnu/bits/fcntl2.h:50:11: error: call to =E2=80=98=
__open_missing_mode=E2=80=99 declared with attribute error: open with O_CRE=
AT or O_TMPFILE in second argument needs 3 arguments
   50 |           __open_missing_mode ();
      |           ^~~~~~~~~~~~~~~~~~~~~~


Given that the code in question has nothing to do with cgroups and is used =
only
by test_memcontrol.c, my vote is to move it into test_memcontrol.c and let =
the
cgroups folks sort things out at their leisure (if it even ever becomes an =
issue
for them).

E.g. slot this is before making cgroup_util.c a library?

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 28 Apr 2025 17:38:14 -0700
Subject: [PATCH] selftests: cgroup: Move memcontrol specific helpers out of
 common cgroup_util.c

Move a handful of helpers out of cgroup_util.c and into test_memcontrol.c
that have nothing to with cgroups in general, in anticipation of making
cgroup_util.c a generic library that can be used by other selftests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/cgroup/cgroup_util.c  | 78 -------------------
 tools/testing/selftests/cgroup/cgroup_util.h  |  5 --
 .../selftests/cgroup/test_memcontrol.c        | 78 +++++++++++++++++++
 3 files changed, 78 insertions(+), 83 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/s=
elftests/cgroup/cgroup_util.c
index 1e2d46636a0c..023a87ff7ebc 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
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
index 19b131ee7707..bdc50a8e6b85 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -49,11 +49,6 @@ extern int cg_enter_current_thread(const char *cgroup);
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
index 16f5d74ae762..5414ca4df24c 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -24,6 +24,84 @@
 static bool has_localevents;
 static bool has_recursiveprot;
=20
+static int get_temp_fd(void)
+{
+	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
+}
+
+static int alloc_pagecache(int fd, size_t size)
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
+static int alloc_anon(const char *cgroup, void *arg)
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
+static int is_swap_enabled(void)
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
+static int set_oom_adj_score(int pid, int score)
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

base-commit: 4a243ec9b255aeb0f033c646148aaf662fd92c64
--

