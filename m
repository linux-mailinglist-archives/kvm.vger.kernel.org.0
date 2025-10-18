Return-Path: <kvm+bounces-60411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B9EBEC190
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 205DA407D56
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45FB72625;
	Sat, 18 Oct 2025 00:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kbR9T3Om"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7227FBF6
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 00:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746049; cv=none; b=G+vUswmAVbLJ5dUU463V2JO0hm7fj7DJQ9e2L52un5uPhnZdNXls/+2F3NxG7+3v7XjccZ5ZjSISodhZrxGHy2RDPVXLJpRM76oFbeSlO7jI7I89RzPTRkrUGOEmvl80SdoR7o0mBuo/WvDBNaJ95DaHpDAhIrxnQWxnr7dTI3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746049; c=relaxed/simple;
	bh=im+NROWrioLAUoKDcU09gT2O29uHv1ZmiGbPd4DQRmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EGic/q79Gg46dpUtZn0Mq7txZX7sXRipr2gVnKZLYMtBKxl7HATU9XvIuy39pKh74fQKa+y9MHjLkh0awfTZ1B+aCDjGCTLFgOgWvdudYe/N6P3yA39F++Plfsks/avOiXJPYD8V61Cg5FHEI2df1gLRmFfb7/UwxaDylgk3GDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kbR9T3Om; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so1981568a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760746047; x=1761350847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TOMpaEfu4XDoTJxqADAIr7pPqza8QEwPDO10nSptr+w=;
        b=kbR9T3OmQXmuFr53LJzhhSY27qM7Y0YEtiuNVP3wbv2peVkeuKnni4j5IULcyo8hO5
         rbwUQVrboGd7NKeN/nulONuBk+rOV03BRc9MHdWGXiDFGo0WbyemHYWScIRBVYHFzSO3
         j/7Na8mtkYnyoS69gI8WlH1BAhfoHZOpeHwFnefyIcZtP2TRIRDbtjPeepmTPkPoBLQO
         W05MjYw0ErFzJCSgrKLdMAH6r3z4EGPfUws+EI/kjjtybXUJ82HlYzyFWmAeFzfbhj59
         B9Ff/TXJ6LHVe/+3GIw8fkcaxYGC6r5I+5Xily0WyAi/gYYVDo3AJ0nzh4YyjqDGYFVb
         0Xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760746047; x=1761350847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TOMpaEfu4XDoTJxqADAIr7pPqza8QEwPDO10nSptr+w=;
        b=ctiKhVdS0+Hk2Ykn5bTf6PIAwoR/SKzj4luzhmF4uVozvov3wLnwTk7uKUO1+E0TF1
         +PRWttdlHzQ6Tq4YGYLbngd6GPXMy4q08UUZttoq2trBHYBQT9bdpO1AJABj+wl6nLlp
         c1PsODGs+PsyIgzTliO9oigMCFIrbfL+6Blr7zcXE6PCyMhGKOJNi16M+tuyA6WE87f8
         RHKQimczanqU4CnMhbenxc/vbbt3Uo4wFF5k1iIpISDw9TpQAbcjLQm5DfBBer5dXbMy
         M1krvqeqa2b6N2rz8r0IqjNpNAbfjh7JjKk0Tj5ExPjHGUf6rUE+xwaUL7WzanoaZWmi
         ht0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUufgJ3FTbFHVDNfY/RLxGF0mzZAP8nDYWZ+ZHj4DgpZEyLb50Ysp6GGSlT7iLXQFnnZOo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxwsu7sjmWq7oZZJwvutl3jIQG6d/VjKFNZCr9gxvg8XwYBRLI
	XUTbd3nRNsThQj6O04ooC9CVfSqZn/486B0PNE8HpUryZoJJzgUir3bkPSYzeQprHP9tCf9xhpI
	AKbWgohlvQw==
X-Google-Smtp-Source: AGHT+IGrRMKQ0oOHM8/+DeUTvxakoLf63/yRNJYFuzUrt0w+O2bY/RazLDAQzrZ9LelmGXwMAfCodkPK+Jmb
X-Received: from pjop7.prod.google.com ([2002:a17:90a:9307:b0:33b:aa58:175c])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d408:b0:33b:dec9:d9aa
 with SMTP id 98e67ed59e1d1-33bdec9da92mr4818277a91.25.1760746047288; Fri, 17
 Oct 2025 17:07:27 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:06:54 -0700
In-Reply-To: <20251018000713.677779-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251018000713.677779-3-vipinsh@google.com>
Subject: [RFC PATCH 02/21] selftests/liveupdate: Create library of core live
 update ioctls
From: Vipin Sharma <vipinsh@google.com>
To: bhelgaas@google.com, alex.williamson@redhat.com, pasha.tatashin@soleen.com, 
	dmatlack@google.com, jgg@ziepe.ca, graf@amazon.com
Cc: pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org, 
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com, 
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com, 
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Create liveupdate_util.mk library of core live update APIs which can
be shared outside of liveupdate selftests, for example, VFIO selftests.

Shared library avoids the need for VFIO to define its own APIs to
interact with liveupdate ioctls.

No functional changes intended, in this patch only few functions are
moved to library without changing the code.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/liveupdate/Makefile   |  6 +-
 .../liveupdate/lib/include/liveupdate_util.h  | 23 +++++++
 .../selftests/liveupdate/lib/libliveupdate.mk | 17 +++++
 .../liveupdate/lib/liveupdate_util.c          | 68 +++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 55 +--------------
 .../selftests/liveupdate/luo_test_utils.h     | 10 +--
 6 files changed, 114 insertions(+), 65 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/lib/include/liveupdate_util.h
 create mode 100644 tools/testing/selftests/liveupdate/lib/libliveupdate.mk
 create mode 100644 tools/testing/selftests/liveupdate/lib/liveupdate_util.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index fbcacbd1b798..79d1c525f03c 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -26,7 +26,9 @@ CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += $(KHDR_INCLUDES)
 LDFLAGS += -static
 
-$(OUTPUT)/liveupdate: $(liveupdate_SOURCES) $(LUO_SHARED_HDRS)
+include lib/libliveupdate.mk
+
+$(OUTPUT)/liveupdate: $(liveupdate_SOURCES) $(LUO_SHARED_HDRS) $(LIBLIVEUPDATE_O)
 	$(call msg,LINK,,$@)
 	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
@@ -35,7 +37,7 @@ $(foreach test,$(LUO_MANUAL_TESTS), \
 	$(eval $(test)_SOURCES := $(test).c $(LUO_SHARED_SRCS)))
 
 define BUILD_RULE_TEMPLATE
-$(OUTPUT)/$(1): $($(1)_SOURCES) $(LUO_SHARED_HDRS)
+$(OUTPUT)/$(1): $($(1)_SOURCES) $(LUO_SHARED_HDRS) $(LIBLIVEUPDATE_O)
 	$(call msg,LINK,,$$@)
 	$(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@
 	$(Q)chmod +x $$@
diff --git a/tools/testing/selftests/liveupdate/lib/include/liveupdate_util.h b/tools/testing/selftests/liveupdate/lib/include/liveupdate_util.h
new file mode 100644
index 000000000000..f938ce60edb7
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/lib/include/liveupdate_util.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef SELFTESTS_LIVEUPDATE_LIB_LIVEUPDATE_UTIL_H
+#define SELFTESTS_LIVEUPDATE_LIB_LIVEUPDATE_UTIL_H
+
+#include <linux/liveupdate.h>
+
+#define LUO_DEVICE "/dev/liveupdate"
+
+int luo_open_device(void);
+int luo_create_session(int luo_fd, const char *name);
+int luo_retrieve_session(int luo_fd, const char *name);
+
+int luo_set_session_event(int session_fd, enum liveupdate_event event);
+int luo_set_global_event(int luo_fd, enum liveupdate_event event);
+int luo_get_global_state(int luo_fd, enum liveupdate_state *state);
+
+#endif /* SELFTESTS_LIVEUPDATE_LIB_LIVEUPDATE_UTIL_H */
diff --git a/tools/testing/selftests/liveupdate/lib/libliveupdate.mk b/tools/testing/selftests/liveupdate/lib/libliveupdate.mk
new file mode 100644
index 000000000000..b3fc2580a7cf
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/lib/libliveupdate.mk
@@ -0,0 +1,17 @@
+LIBLIVEUPDATE_SRCDIR := $(selfdir)/liveupdate/lib
+
+LIBLIVEUPDATE_C := liveupdate_util.c
+
+LIBLIVEUPDATE_OUTPUT := $(OUTPUT)/libliveupdate
+
+LIBLIVEUPDATE_O := $(patsubst %.c, $(LIBLIVEUPDATE_OUTPUT)/%.o, $(LIBLIVEUPDATE_C))
+
+LIBLIVEUPDATE_O_DIRS := $(shell dirname $(LIBLIVEUPDATE_O) | uniq)
+$(shell mkdir -p $(LIBLIVEUPDATE_O_DIRS))
+
+CFLAGS += -I$(LIBLIVEUPDATE_SRCDIR)/include
+
+$(LIBLIVEUPDATE_O): $(LIBLIVEUPDATE_OUTPUT)/%.o : $(LIBLIVEUPDATE_SRCDIR)/%.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@
+
+EXTRA_CLEAN += $(LIBLIVEUPDATE_OUTPUT)
\ No newline at end of file
diff --git a/tools/testing/selftests/liveupdate/lib/liveupdate_util.c b/tools/testing/selftests/liveupdate/lib/liveupdate_util.c
new file mode 100644
index 000000000000..1e6fd9dd8fb9
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/lib/liveupdate_util.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define _GNU_SOURCE
+
+#include <liveupdate_util.h>
+#include <linux/liveupdate.h>
+#include <errno.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+
+int luo_open_device(void)
+{
+	return open(LUO_DEVICE, O_RDWR);
+}
+
+int luo_create_session(int luo_fd, const char *name)
+{
+	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
+
+	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
+		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
+	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_CREATE_SESSION, &arg) < 0)
+		return -errno;
+	return arg.fd;
+}
+
+int luo_retrieve_session(int luo_fd, const char *name)
+{
+	struct liveupdate_ioctl_retrieve_session arg = { .size = sizeof(arg) };
+
+	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
+		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
+	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_RETRIEVE_SESSION, &arg) < 0)
+		return -errno;
+	return arg.fd;
+}
+
+int luo_set_session_event(int session_fd, enum liveupdate_event event)
+{
+	struct liveupdate_session_set_event arg = { .size = sizeof(arg) };
+
+	arg.event = event;
+	return ioctl(session_fd, LIVEUPDATE_SESSION_SET_EVENT, &arg);
+}
+
+int luo_set_global_event(int luo_fd, enum liveupdate_event event)
+{
+	struct liveupdate_ioctl_set_event arg = { .size = sizeof(arg) };
+
+	arg.event = event;
+	return ioctl(luo_fd, LIVEUPDATE_IOCTL_SET_EVENT, &arg);
+}
+
+int luo_get_global_state(int luo_fd, enum liveupdate_state *state)
+{
+	struct liveupdate_ioctl_get_state arg = { .size = sizeof(arg) };
+
+	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_GET_STATE, &arg) < 0)
+		return -errno;
+	*state = arg.state;
+	return 0;
+}
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index c0840e6e66fd..0f5bc7260ccc 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.c
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -17,39 +17,12 @@
 #include <sys/mman.h>
 #include <errno.h>
 #include <stdarg.h>
-
+#include <liveupdate_util.h>
 #include "luo_test_utils.h"
 #include "../kselftest.h"
 
 /* The fail_exit function is now a macro in the header. */
 
-int luo_open_device(void)
-{
-	return open(LUO_DEVICE, O_RDWR);
-}
-
-int luo_create_session(int luo_fd, const char *name)
-{
-	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
-
-	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
-		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
-	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_CREATE_SESSION, &arg) < 0)
-		return -errno;
-	return arg.fd;
-}
-
-int luo_retrieve_session(int luo_fd, const char *name)
-{
-	struct liveupdate_ioctl_retrieve_session arg = { .size = sizeof(arg) };
-
-	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
-		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
-	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_RETRIEVE_SESSION, &arg) < 0)
-		return -errno;
-	return arg.fd;
-}
-
 int create_and_preserve_memfd(int session_fd, int token, const char *data)
 {
 	struct liveupdate_session_preserve_fd arg = { .size = sizeof(arg) };
@@ -119,32 +92,6 @@ int restore_and_verify_memfd(int session_fd, int token,
 	return ret;
 }
 
-int luo_set_session_event(int session_fd, enum liveupdate_event event)
-{
-	struct liveupdate_session_set_event arg = { .size = sizeof(arg) };
-
-	arg.event = event;
-	return ioctl(session_fd, LIVEUPDATE_SESSION_SET_EVENT, &arg);
-}
-
-int luo_set_global_event(int luo_fd, enum liveupdate_event event)
-{
-	struct liveupdate_ioctl_set_event arg = { .size = sizeof(arg) };
-
-	arg.event = event;
-	return ioctl(luo_fd, LIVEUPDATE_IOCTL_SET_EVENT, &arg);
-}
-
-int luo_get_global_state(int luo_fd, enum liveupdate_state *state)
-{
-	struct liveupdate_ioctl_get_state arg = { .size = sizeof(arg) };
-
-	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_GET_STATE, &arg) < 0)
-		return -errno;
-	*state = arg.state;
-	return 0;
-}
-
 void create_state_file(int luo_fd, int next_stage)
 {
 	char buf[32];
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
index e30cfcb0a596..4d371b528a01 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.h
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -11,9 +11,9 @@
 #include <errno.h>
 #include <string.h>
 #include <linux/liveupdate.h>
+#include <liveupdate_util.h>
 #include "../kselftest.h"
 
-#define LUO_DEVICE "/dev/liveupdate"
 #define STATE_SESSION_NAME "state_session"
 #define STATE_MEMFD_TOKEN 999
 
@@ -30,19 +30,11 @@ struct session_info {
 	ksft_exit_fail_msg("[%s] " fmt " (errno: %s)\n",		\
 			   __func__, ##__VA_ARGS__, strerror(errno))
 
-int luo_open_device(void);
-
-int luo_create_session(int luo_fd, const char *name);
-int luo_retrieve_session(int luo_fd, const char *name);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 int verify_session_and_get_fd(int luo_fd, struct session_info *s);
 
-int luo_set_session_event(int session_fd, enum liveupdate_event event);
-int luo_set_global_event(int luo_fd, enum liveupdate_event event);
-int luo_get_global_state(int luo_fd, enum liveupdate_state *state);
-
 void create_state_file(int luo_fd, int next_stage);
 int restore_and_read_state(int luo_fd, int *stage);
 void update_state_file(int session_fd, int next_stage);
-- 
2.51.0.858.gf9c4a03a3a-goog


