Return-Path: <kvm+bounces-43276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA889A88CC9
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 22:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CF323B33C9
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 20:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CBE1E8332;
	Mon, 14 Apr 2025 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wJmvWFiY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1340B1DE4C3
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744661380; cv=none; b=E4uGRb/jO9cAxf1RBMy7fEab2SOsPVhpdURnSoYiiY5DHx339iCQ4+e0O9/U4hPXGaR01cxHDQLJxBx3hnGo4kDi1it0zNoCoi0q6ZxEFQJyumGRhpb4BMXvFEaEJLpJmVkAXPeDctsMnbweSx6V0wezw4xnhXZ4X8Ob2qpcdqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744661380; c=relaxed/simple;
	bh=Q5s04arBO6wP0YtImTtLVVwE4rPFfsjS9e7jXcuiB/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T5iF5uUN0eaKK9ZG/yfkfbxcsG9Lkh/K7hbsp04KeYuuxzjWT2cZRwqyVox4kwbegqyB5vFpzkdu+rq12IxVUs9xT+p93EmRwEG3hJIjO6PsPVmC0WYcEI7FWArjFAHBHEKywqa/fZUYkTsULVcuZdkxqEMyLZEflDRcmUvtjsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wJmvWFiY; arc=none smtp.client-ip=209.85.219.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-6e916df0d5dso73917386d6.2
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 13:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744661377; x=1745266177; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZNC09kfFvwbMY+TuFPooH5ZpXiI2zM5Sfzza51R45o=;
        b=wJmvWFiYg9QaVghWy5s5AXVGVAxY7585xwC2gINmLTtz5CGwUbvbq+ta4FOHqIg7TW
         4XAnExKQOIRcjok6lelBg8AJg7gYswe/WHJdNXIAjBZLdlpZhH4RqY/Z4cDgjO35XkfZ
         v1LkpG9NdPFeZ2Mp7UgKY3nUzsCDi6JM6Dq17KpkvBdEuzP2Jjrva0GrWKPQ5TMv+Ypv
         YAIN/eyFFpJLPTrNjgvcFl3JAEGJJ9eTJVXXQCOfBf18T6ZGYE8VRuBKruYnOWlJO/tk
         MVgiln6lrs10eMzmaqStcvmu0icEmtQUHfNPHZKcqYFCJBLFOW0avywDGLuU0mItTDw5
         9MTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744661377; x=1745266177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZNC09kfFvwbMY+TuFPooH5ZpXiI2zM5Sfzza51R45o=;
        b=KwK2ZoBHsTg7ShfCotVBm3iMKs46c2Z9VsnYH1OSppnFuoWwpmEJT6f0Ma8Db5CONN
         EPMuoJz9tabOKjke9RsFnoTW4uohSafUsmtFMu8GpzyQB1LNtGL1ELyVqTjoh+FS/09g
         aXvm1xkI5PWTvEElT2RvekpTg8M2awa8jKWmLB/RQRR9+rsJbUI6cz2IQH0EG7s2kV46
         iQJOm1ph7zn93ywBsAytFr/DSQyht9rolQkq/JcTSccyEtfKz5iJi/8tsj99icWf1Y/v
         UWiFz6Ht/TQ40TvsKFr9oTFJjWEPlEUKDt1f38GArMBUIO65/X4Afn/sYbMcYr93awKD
         np8g==
X-Forwarded-Encrypted: i=1; AJvYcCV/46rBT35wBJ2YSm4KtmoGetLQUikTpwG7P/T5aVyiwUHKnHPgGJqmMXx+D1aqxnotK6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWfclw3o0GHTjTJHdXsRxYqMNdGfAfZc1AHg6ToT9bR7PFEBiH
	qUKziumZqWekYX5QJUzsb/aQFejuMK1wAyUccgx2MiIroHA8kPsRVYdoY/7NDN6FN2W+Qv6EM54
	P9eoz6zViWi7g62dtgg==
X-Google-Smtp-Source: AGHT+IEmhHPOtSLRv5SjgoAz4o7I3BOkLb3Ktb52XwE92Hh9Nyak79yxZ3UyDRTI9exZl8vbFvxhssgNe4SMJrXM
X-Received: from qvb1.prod.google.com ([2002:a05:6214:6001:b0:6eb:2b16:6854])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:ad4:5ca4:0:b0:6f0:e2d4:51fe with SMTP id 6a1803df08f44-6f230d950dfmr184580506d6.26.1744661376927;
 Mon, 14 Apr 2025 13:09:36 -0700 (PDT)
Date: Mon, 14 Apr 2025 20:09:27 +0000
In-Reply-To: <20250414200929.3098202-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414200929.3098202-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250414200929.3098202-4-jthoughton@google.com>
Subject: [PATCH v3 3/5] cgroup: selftests: Move cgroup_util into its own library
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

KVM selftests will soon need to use some of the cgroup creation and
deletion functionality from cgroup_util.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/cgroup/Makefile       | 21 ++++++++++---------
 .../selftests/cgroup/{ => lib}/cgroup_util.c  |  2 +-
 .../cgroup/{ => lib/include}/cgroup_util.h    |  4 ++--
 .../testing/selftests/cgroup/lib/libcgroup.mk | 19 +++++++++++++++++
 4 files changed, 33 insertions(+), 13 deletions(-)
 rename tools/testing/selftests/cgroup/{ => lib}/cgroup_util.c (99%)
 rename tools/testing/selftests/cgroup/{ => lib/include}/cgroup_util.h (99%)
 create mode 100644 tools/testing/selftests/cgroup/lib/libcgroup.mk

diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index 1b897152bab6e..e01584c2189ac 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -21,14 +21,15 @@ TEST_GEN_PROGS += test_zswap
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 
 include ../lib.mk
+include lib/libcgroup.mk
 
-$(OUTPUT)/test_core: cgroup_util.c
-$(OUTPUT)/test_cpu: cgroup_util.c
-$(OUTPUT)/test_cpuset: cgroup_util.c
-$(OUTPUT)/test_freezer: cgroup_util.c
-$(OUTPUT)/test_hugetlb_memcg: cgroup_util.c
-$(OUTPUT)/test_kill: cgroup_util.c
-$(OUTPUT)/test_kmem: cgroup_util.c
-$(OUTPUT)/test_memcontrol: cgroup_util.c
-$(OUTPUT)/test_pids: cgroup_util.c
-$(OUTPUT)/test_zswap: cgroup_util.c
+$(OUTPUT)/test_core: $(LIBCGROUP_O)
+$(OUTPUT)/test_cpu: $(LIBCGROUP_O)
+$(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
+$(OUTPUT)/test_freezer: $(LIBCGROUP_O)
+$(OUTPUT)/test_hugetlb_memcg: $(LIBCGROUP_O)
+$(OUTPUT)/test_kill: $(LIBCGROUP_O)
+$(OUTPUT)/test_kmem: $(LIBCGROUP_O)
+$(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
+$(OUTPUT)/test_pids: $(LIBCGROUP_O)
+$(OUTPUT)/test_zswap: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
similarity index 99%
rename from tools/testing/selftests/cgroup/cgroup_util.c
rename to tools/testing/selftests/cgroup/lib/cgroup_util.c
index 1e2d46636a0ca..f047d8adaec65 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -17,7 +17,7 @@
 #include <unistd.h>
 
 #include "cgroup_util.h"
-#include "../clone3/clone3_selftests.h"
+#include "../../clone3/clone3_selftests.h"
 
 /* Returns read len on success, or -errno on failure. */
 static ssize_t read_text(const char *path, char *buf, size_t max_len)
diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
similarity index 99%
rename from tools/testing/selftests/cgroup/cgroup_util.h
rename to tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 19b131ee77072..7a0441e5eb296 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -2,9 +2,9 @@
 #include <stdbool.h>
 #include <stdlib.h>
 
-#include "../kselftest.h"
-
+#ifndef PAGE_SIZE
 #define PAGE_SIZE 4096
+#endif
 
 #define MB(x) (x << 20)
 
diff --git a/tools/testing/selftests/cgroup/lib/libcgroup.mk b/tools/testing/selftests/cgroup/lib/libcgroup.mk
new file mode 100644
index 0000000000000..7a73007204c39
--- /dev/null
+++ b/tools/testing/selftests/cgroup/lib/libcgroup.mk
@@ -0,0 +1,19 @@
+CGROUP_DIR := $(selfdir)/cgroup
+
+LIBCGROUP_C := lib/cgroup_util.c
+
+LIBCGROUP_O := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBCGROUP_C))
+
+LIBCGROUP_O_DIRS := $(shell dirname $(LIBCGROUP_O) | uniq)
+
+CFLAGS += -I$(CGROUP_DIR)/lib/include
+
+EXTRA_HDRS := $(selfdir)/clone3/clone3_selftests.h
+
+$(LIBCGROUP_O_DIRS):
+	mkdir -p $@
+
+$(LIBCGROUP_O): $(OUTPUT)/%.o : $(CGROUP_DIR)/%.c $(EXTRA_HDRS) $(LIBCGROUP_O_DIRS)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
+EXTRA_CLEAN += $(LIBCGROUP_O)
-- 
2.49.0.604.gff1f9ca942-goog


