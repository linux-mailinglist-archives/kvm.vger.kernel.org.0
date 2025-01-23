Return-Path: <kvm+bounces-36440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79733A1AD5D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFC82161B55
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FB431D5CFD;
	Thu, 23 Jan 2025 23:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lwbG9DcN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59351D5CDE
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675870; cv=none; b=P1UNjbs7HVxj8n8ftOQ+dTIvp2/ktNiQ4s9iNv3pKvP0X4rG9RzUTisXzD6ukmHi1ijOcmZr1xZOUiBysuT7yrh22Ta7FrhLN6+pP0eBbdOSf0xCGX/M1Rb384+xToXcVdD+jYvT1WtjWGoS6kbLlDQd5ebLDF3JEALjeIKeqQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675870; c=relaxed/simple;
	bh=h9j7Hcv3N60SkNiwJxa+iXQ3vRq1q6A0wFw0y+Fz1Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TuhJ0IzUp6vnz04PTqXIz4VBqn+AAWVnUWxdbBLl7Pea9wgcYWA2lE4cFfMttfFl3pWAa39IZ+P9hy9mF84PH1Xt71ZUEWEgk1xAgiibcsAf8reg6OWC7WBawSohzmt0cZxI+RXj0gJKX0eADRuRijhPsEj04UCxePMk4erCRyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lwbG9DcN; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4361f65ca01so15614735e9.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675867; x=1738280667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nuXtmGFXC6ord9LKCUcMBdqEKN9u5T/6Xkbf7Pq9+s=;
        b=lwbG9DcNmomqckoMq5KtsaZcO0k9t+I0xsY34x52tP9Ym2TTM8QcBT6BnszedUx/jB
         THw6CTDPy4o0zWuwSrF32jAC2Gnsfg1ZWn0JoBMXtD7fazApK0QzKwRjYPcp4b8+pDJw
         /y2WiRGOEYp4ZR2R3I9hGti8QMHrZDZB54yrIT2S0uiTOxMpTzZGGJUlYoR7R/x6sMCF
         knETem2l1BFQLgxO+hlDDEmVJJeN5XFqW2tyxN0v6uaOqA9P9kbm8WdCPxN9ZPCJmQ2H
         BI1z80LnUn8Yo8eLtGqf6Vj1Z7Y5mdTS6oW7xrU906Cy8C3W9SvbC4ttQYS2emSMtRSx
         tmoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675867; x=1738280667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nuXtmGFXC6ord9LKCUcMBdqEKN9u5T/6Xkbf7Pq9+s=;
        b=QoL114joLdmoX8Cy39Qkb8N2417B8Ir7NCoTixeJx26wqTxq9/TPN0ksSBAY9jbQ6I
         lwXJ9nmqFokIkTWe4twVbwsN6WPU9tNFOCtEX8XEdQf122jF5RqOXxlz4iEyxT+2e9nk
         hCuzOYxgFekO3hlIRej7SMeJwe1Ffe1cX578jm0oRCfHvZjcWnkLAIy0vNGcYL+qAKlN
         Yg+na6rVSI76LXnQpf2xtgP6RW1yxMUtUYXPWPpBw2KgLCvyEPipg7qDkqbuAevxfTTp
         ZvByIolhN6L4ZO9g7mBG4cLKIpiJNndSqra3BP6eHizUi3Gc8hM3PaGtwPmY9pLM0lgT
         ReMw==
X-Forwarded-Encrypted: i=1; AJvYcCVJqiLaou92J1Ln3hsK4E/AorJrtEQmN9XdGaq39375jqRKRbimVan/dlO9DS0/bQlgQrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHLiH1bmk++uEFw4idr0Ee4gpmJQ0cMJPwWB/RoQB44L2Txzr9
	UtcqzwKDPlTRU5f2rfHxXXwVChmw9i4kETiingEE2rGIHBcY5u1WrbVV4zxdBFc=
X-Gm-Gg: ASbGncsS523oHWAVYHRYts7eqdqg0dBE0niwN978T+55wrmM+G9y4jSGEYUPxtKaNfs
	rO9ofJPovZBnwn2XASgUp0a6G2O0Zr9yE6KzXHZttXLmxcRBjbf6c94MOw76rvqoNjSqOc5VCYj
	ol9Fk5CcQaSjnQAt2s9eoHZxUV5drBbTYt7g7s77B507Mcs5sFyvUr3UcARpblv+eKFtnkxMt3T
	yE/Loyo0Xp8hNnCOz9TqsusX+0kVtxcC9A1dCy327+2KTpg2n0YRfXDDta5pMOsF7PQyxp61z9F
	VLC8E7/0ni0qfCtLvlpluq1/70DNQC5k4sJJrkCB8wAe9m3iAymN6+E=
X-Google-Smtp-Source: AGHT+IHv5zns5zWE/8mYKYb9FdwvG4F/GC7lN2DJcXXFDd0WLjCHyuvzadU0RlDxZ5dNLmoZuF9u5A==
X-Received: by 2002:a05:6000:1887:b0:38a:87cc:fb42 with SMTP id ffacd0b85a97d-38bf56639d5mr27205303f8f.21.1737675867076;
        Thu, 23 Jan 2025 15:44:27 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a17d6e2sm989811f8f.23.2025.01.23.15.44.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:44:26 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 02/20] user: Extract common MMAP API to 'user/mmap.h'
Date: Fri, 24 Jan 2025 00:43:56 +0100
Message-ID: <20250123234415.59850-3-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Keep common MMAP-related declarations in a single place.

Note, this disable ThreadSafetyAnalysis on Linux for:
- mmap_fork_start()
- mmap_fork_end().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 bsd-user/qemu.h        | 12 +-----------
 include/user/mmap.h    | 32 ++++++++++++++++++++++++++++++++
 linux-user/user-mmap.h | 19 ++-----------------
 3 files changed, 35 insertions(+), 28 deletions(-)
 create mode 100644 include/user/mmap.h

diff --git a/bsd-user/qemu.h b/bsd-user/qemu.h
index 4e97c796318..c1c508281a8 100644
--- a/bsd-user/qemu.h
+++ b/bsd-user/qemu.h
@@ -32,6 +32,7 @@
 extern char **environ;
 
 #include "user/thunk.h"
+#include "user/mmap.h"
 #include "target_arch.h"
 #include "syscall_defs.h"
 #include "target_syscall.h"
@@ -233,19 +234,8 @@ void print_taken_signal(int target_signum, const target_siginfo_t *tinfo);
 extern int do_strace;
 
 /* mmap.c */
-int target_mprotect(abi_ulong start, abi_ulong len, int prot);
-abi_long target_mmap(abi_ulong start, abi_ulong len, int prot,
-                     int flags, int fd, off_t offset);
-int target_munmap(abi_ulong start, abi_ulong len);
-abi_long target_mremap(abi_ulong old_addr, abi_ulong old_size,
-                       abi_ulong new_size, unsigned long flags,
-                       abi_ulong new_addr);
 int target_msync(abi_ulong start, abi_ulong len, int flags);
-extern abi_ulong mmap_next_start;
-abi_ulong mmap_find_vma(abi_ulong start, abi_ulong size);
 void mmap_reserve(abi_ulong start, abi_ulong size);
-void TSA_NO_TSA mmap_fork_start(void);
-void TSA_NO_TSA mmap_fork_end(int child);
 
 /* main.c */
 extern char qemu_proc_pathname[];
diff --git a/include/user/mmap.h b/include/user/mmap.h
new file mode 100644
index 00000000000..4d004e6b822
--- /dev/null
+++ b/include/user/mmap.h
@@ -0,0 +1,32 @@
+/*
+ * MMAP declarations for QEMU user emulation
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#ifndef USER_MMAP_H
+#define USER_MMAP_H
+
+#include "user/abitypes.h"
+
+/*
+ * mmap_next_start: The base address for the next mmap without hint,
+ * increased after each successful map, starting at task_unmapped_base.
+ * This is an optimization within QEMU and not part of ADDR_COMPAT_LAYOUT.
+ */
+extern abi_ulong mmap_next_start;
+
+int target_mprotect(abi_ulong start, abi_ulong len, int prot);
+
+abi_long target_mmap(abi_ulong start, abi_ulong len, int prot,
+                     int flags, int fd, off_t offset);
+int target_munmap(abi_ulong start, abi_ulong len);
+abi_long target_mremap(abi_ulong old_addr, abi_ulong old_size,
+                       abi_ulong new_size, unsigned long flags,
+                       abi_ulong new_addr);
+
+abi_ulong mmap_find_vma(abi_ulong, abi_ulong, abi_ulong);
+
+void TSA_NO_TSA mmap_fork_start(void);
+void TSA_NO_TSA mmap_fork_end(int child);
+
+#endif
diff --git a/linux-user/user-mmap.h b/linux-user/user-mmap.h
index b94bcdcf83c..dfc4477a720 100644
--- a/linux-user/user-mmap.h
+++ b/linux-user/user-mmap.h
@@ -18,6 +18,8 @@
 #ifndef LINUX_USER_USER_MMAP_H
 #define LINUX_USER_USER_MMAP_H
 
+#include "user/mmap.h"
+
 /*
  * Guest parameters for the ADDR_COMPAT_LAYOUT personality
  * (at present this is the only layout supported by QEMU).
@@ -39,24 +41,7 @@
 extern abi_ulong task_unmapped_base;
 extern abi_ulong elf_et_dyn_base;
 
-/*
- * mmap_next_start: The base address for the next mmap without hint,
- * increased after each successful map, starting at task_unmapped_base.
- * This is an optimization within QEMU and not part of ADDR_COMPAT_LAYOUT.
- */
-extern abi_ulong mmap_next_start;
-
-int target_mprotect(abi_ulong start, abi_ulong len, int prot);
-abi_long target_mmap(abi_ulong start, abi_ulong len, int prot,
-                     int flags, int fd, off_t offset);
-int target_munmap(abi_ulong start, abi_ulong len);
-abi_long target_mremap(abi_ulong old_addr, abi_ulong old_size,
-                       abi_ulong new_size, unsigned long flags,
-                       abi_ulong new_addr);
 abi_long target_madvise(abi_ulong start, abi_ulong len_in, int advice);
-abi_ulong mmap_find_vma(abi_ulong, abi_ulong, abi_ulong);
-void mmap_fork_start(void);
-void mmap_fork_end(int child);
 
 abi_ulong target_shmat(CPUArchState *cpu_env, int shmid,
                        abi_ulong shmaddr, int shmflg);
-- 
2.47.1


