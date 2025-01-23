Return-Path: <kvm+bounces-36452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2768EA1AD74
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AA9F188F4EF
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972B81D63E2;
	Thu, 23 Jan 2025 23:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZTFwX9/o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94C91D47CB
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675939; cv=none; b=ZqicBq9EehGKdGVEr3wT2A/d4QjMQ1Wmp0tjEtd4djLUCs/ra9jQ66+mOTsTGSqOjKmrUL7nBCLUBMoNx5NOSV+HnAJBat1mgwvmxRkz77Kw2Ur0gIeUgtGjPoH+I4MAm8vFA5YLnI7lmm4dOR5atlvpeoIH1CEIU3YOdzPnDoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675939; c=relaxed/simple;
	bh=oICil2Av/WIFxfgmb1hOsCIIQZoAtNIZoxb8rKmknSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGNkiC04fdnztT0LFH/Egslcd9BeLYuEVNTKZ6p79dAtSSnqBYUqZsq88G2i26u8hoi+FxfBDbze4Q0OJN4uqZLJmED37E9Hg8cppj+UvLjKs5NWKvp8uQBUawCQNCNA0Qsr/t41bVTNUhjkyB8N+U5zuh34kSEg0nSB2g+quuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZTFwX9/o; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43618283dedso15516405e9.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675936; x=1738280736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhTovaxYyVYo/iAlHiQi1CfSH3sOOBet2z8bCBrBkk0=;
        b=ZTFwX9/oM1GKyRVPkTnP1S1hsX8tfEEhLFBq0prRdlD591hyaRMXr7yb0wLD6Vllk9
         +4GdxHcCkILIoxidUTWwdKLqq/JIyITayPbO0wVkRTNfsqm9F3JdQVMieSR5xMTLrZA8
         nsNtK1nX5IH0/kt0G9ijyqIovMoYsI9oyfMYpdfDXqdUY//gHmthUfOCqI14R3pokPFU
         2a8e2c2IptyHk9NooFtskIh37JdOk57Am/4RbdcVq1ymIqEl/onF9xbXrD6grJfPrjoH
         dzVijROM3D5b4m8o4cn0zLKP/Lxj/gR2gDbNM+xv/O/QjE67fwBPs2qXdqJFrCmv036Q
         YyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675936; x=1738280736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QhTovaxYyVYo/iAlHiQi1CfSH3sOOBet2z8bCBrBkk0=;
        b=ZJRpTNLqJ2d2GDYHtOLlx7hIORormPFzBINObL4qtNJ4lTSQwLHKpzkBkwuPoxnqIv
         3o7ZwfKi2nhyYH3UVl+9GEMpe6hWGGZIxPsPM/b21uAEVbbGvBWYhnZ6+3cKRD9FCc1s
         wiq4g4KYahS4mdI5NoUUGOhuZm8wvJNvEbZucsmm/or4UOCO7SCXdbwt+OAglksfh8P7
         31EDMAFp0XE+YDCDpwMOrl4m+6ukMsVMaCsKgYF4olo6sL7zaPUoCkosTMlhQDb6bgT/
         s0RmleDT53tLu+tIXXOUqgLYljsY0ak2NelGhUuvmyTaatJD4anxUAN/PcrUexoFY9we
         JQuA==
X-Forwarded-Encrypted: i=1; AJvYcCXuHp3w0RgwACtEwfL+zBqCCJzcgBgUmbLTI6VH9jwWkqoqq1bXOQ1MfjSno80OWhw/Szo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJjiGaulC5pKy6UWzG8+1aG8yqm0BGVaT8epc1pv9N0c2xfpaC
	Fkw8LG7I8ySmFWUS/sIannWUl64toE4frzL/mXC37bv6iXOcfUm+21U3PbSxZN0=
X-Gm-Gg: ASbGncv/4B1dNf/HY2YBg4ufBpHH7RB4WlU4m71KsaazOy54HBh74cLYMQG8QQ8pTIt
	tQP+3ztnB13r5CVNkkZT1L1B8bdknJ8FOxnqx5i8wCq7W3KKJbu1OAiqCUoKNvApGsqgzXQmsnc
	z9XTKM9+Nsfr4tmn2Sy7q74Tt6b/JUddGAliG/NlFhCjfwq8RTCEcKz2S5gP2vusC/LaBmJ4DT+
	8DE63nXTyv/5D5W0Ughx5rcEKBiEelK2qUtY2ja4EB0vumw2xYOmf41QivDF7s5zfzzBUCzrDSQ
	LvAmzYMNwN0XRFGnlqEogFqKLIOMKDVH6ND5DnVWqqZsymqSQBk6+gQf/LTHK30FDw==
X-Google-Smtp-Source: AGHT+IE1g5Lka6yaX7yxmvTjxCMF9sNPmOLsz1lyorKlxhPYpXBg1FExyYB9qYVhhui8O2rA+ot5eQ==
X-Received: by 2002:a05:600c:3b0a:b0:434:9c60:95a3 with SMTP id 5b1f17b1804b1-438913ca93cmr282415605e9.11.1737675935797;
        Thu, 23 Jan 2025 15:45:35 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd507d60sm6676495e9.18.2025.01.23.15.45.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:34 -0800 (PST)
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
Subject: [PATCH 14/20] accel/tcg: Move cpu_memory_rw_debug() user implementation to user-exec.c
Date: Fri, 24 Jan 2025 00:44:08 +0100
Message-ID: <20250123234415.59850-15-philmd@linaro.org>
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

cpu_memory_rw_debug() system implementation is defined in
system/physmem.c. Move the user one to accel/tcg/user-exec.c
to simplify cpu-target.c maintenance.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/user-exec.c |  92 +++++++++++++++++++++++++++++++++++++
 cpu-target.c          | 102 +-----------------------------------------
 2 files changed, 94 insertions(+), 100 deletions(-)

diff --git a/accel/tcg/user-exec.c b/accel/tcg/user-exec.c
index c4454100ad7..e7e99a46087 100644
--- a/accel/tcg/user-exec.c
+++ b/accel/tcg/user-exec.c
@@ -19,6 +19,8 @@
 #include "qemu/osdep.h"
 #include "accel/tcg/cpu-ops.h"
 #include "disas/disas.h"
+#include "exec/vaddr.h"
+#include "exec/tswap.h"
 #include "exec/exec-all.h"
 #include "tcg/tcg.h"
 #include "qemu/bitops.h"
@@ -35,6 +37,7 @@
 #include "internal-common.h"
 #include "internal-target.h"
 #include "tb-internal.h"
+#include "qemu.h"
 
 __thread uintptr_t helper_retaddr;
 
@@ -969,6 +972,95 @@ static void *cpu_mmu_lookup(CPUState *cpu, vaddr addr,
     return ret;
 }
 
+/* physical memory access (slow version, mainly for debug) */
+int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
+                        void *ptr, size_t len, bool is_write)
+{
+    int flags;
+    vaddr l, page;
+    void * p;
+    uint8_t *buf = ptr;
+    ssize_t written;
+    int ret = -1;
+    int fd = -1;
+
+    while (len > 0) {
+        page = addr & TARGET_PAGE_MASK;
+        l = (page + TARGET_PAGE_SIZE) - addr;
+        if (l > len)
+            l = len;
+        flags = page_get_flags(page);
+        if (!(flags & PAGE_VALID)) {
+            goto out_close;
+        }
+        if (is_write) {
+            if (flags & PAGE_WRITE) {
+                /* XXX: this code should not depend on lock_user */
+                p = lock_user(VERIFY_WRITE, addr, l, 0);
+                if (!p) {
+                    goto out_close;
+                }
+                memcpy(p, buf, l);
+                unlock_user(p, addr, l);
+            } else {
+                /* Bypass the host page protection using ptrace. */
+                if (fd == -1) {
+                    fd = open("/proc/self/mem", O_WRONLY);
+                    if (fd == -1) {
+                        goto out;
+                    }
+                }
+                /*
+                 * If there is a TranslationBlock and we weren't bypassing the
+                 * host page protection, the memcpy() above would SEGV,
+                 * ultimately leading to page_unprotect(). So invalidate the
+                 * translations manually. Both invalidation and pwrite() must
+                 * be under mmap_lock() in order to prevent the creation of
+                 * another TranslationBlock in between.
+                 */
+                mmap_lock();
+                tb_invalidate_phys_range(addr, addr + l - 1);
+                written = pwrite(fd, buf, l,
+                                 (off_t)(uintptr_t)g2h_untagged(addr));
+                mmap_unlock();
+                if (written != l) {
+                    goto out_close;
+                }
+            }
+        } else if (flags & PAGE_READ) {
+            /* XXX: this code should not depend on lock_user */
+            p = lock_user(VERIFY_READ, addr, l, 1);
+            if (!p) {
+                goto out_close;
+            }
+            memcpy(buf, p, l);
+            unlock_user(p, addr, 0);
+        } else {
+            /* Bypass the host page protection using ptrace. */
+            if (fd == -1) {
+                fd = open("/proc/self/mem", O_RDONLY);
+                if (fd == -1) {
+                    goto out;
+                }
+            }
+            if (pread(fd, buf, l,
+                      (off_t)(uintptr_t)g2h_untagged(addr)) != l) {
+                goto out_close;
+            }
+        }
+        len -= l;
+        buf += l;
+        addr += l;
+    }
+    ret = 0;
+out_close:
+    if (fd != -1) {
+        close(fd);
+    }
+out:
+    return ret;
+}
+
 #include "ldst_atomicity.c.inc"
 
 static uint8_t do_ld1_mmu(CPUState *cpu, vaddr addr, MemOpIdx oi,
diff --git a/cpu-target.c b/cpu-target.c
index 20933bde7d4..6d8b7825746 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -19,18 +19,12 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
-
-#include "exec/target_page.h"
-#include "exec/page-protection.h"
 #include "hw/qdev-core.h"
 #include "hw/qdev-properties.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
 #include "migration/vmstate.h"
-#ifdef CONFIG_USER_ONLY
-#include "qemu.h"
-#include "user/page-protection.h"
-#else
+#ifndef CONFIG_USER_ONLY
 #include "hw/core/sysemu-cpu-ops.h"
 #include "exec/address-spaces.h"
 #include "exec/memory.h"
@@ -38,16 +32,15 @@
 #include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "system/tcg.h"
-#include "exec/tswap.h"
 #include "exec/replay-core.h"
 #include "exec/cpu-common.h"
 #include "exec/exec-all.h"
 #include "exec/tb-flush.h"
-#include "exec/translation-block.h"
 #include "exec/log.h"
 #include "accel/accel-cpu-target.h"
 #include "trace/trace-root.h"
 #include "qemu/accel.h"
+#include "hw/core/cpu.h"
 
 #ifndef CONFIG_USER_ONLY
 static int cpu_common_post_load(void *opaque, int version_id)
@@ -367,97 +360,6 @@ void cpu_abort(CPUState *cpu, const char *fmt, ...)
     abort();
 }
 
-/* physical memory access (slow version, mainly for debug) */
-#if defined(CONFIG_USER_ONLY)
-int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
-                        void *ptr, size_t len, bool is_write)
-{
-    int flags;
-    vaddr l, page;
-    void * p;
-    uint8_t *buf = ptr;
-    ssize_t written;
-    int ret = -1;
-    int fd = -1;
-
-    while (len > 0) {
-        page = addr & TARGET_PAGE_MASK;
-        l = (page + TARGET_PAGE_SIZE) - addr;
-        if (l > len)
-            l = len;
-        flags = page_get_flags(page);
-        if (!(flags & PAGE_VALID)) {
-            goto out_close;
-        }
-        if (is_write) {
-            if (flags & PAGE_WRITE) {
-                /* XXX: this code should not depend on lock_user */
-                p = lock_user(VERIFY_WRITE, addr, l, 0);
-                if (!p) {
-                    goto out_close;
-                }
-                memcpy(p, buf, l);
-                unlock_user(p, addr, l);
-            } else {
-                /* Bypass the host page protection using ptrace. */
-                if (fd == -1) {
-                    fd = open("/proc/self/mem", O_WRONLY);
-                    if (fd == -1) {
-                        goto out;
-                    }
-                }
-                /*
-                 * If there is a TranslationBlock and we weren't bypassing the
-                 * host page protection, the memcpy() above would SEGV,
-                 * ultimately leading to page_unprotect(). So invalidate the
-                 * translations manually. Both invalidation and pwrite() must
-                 * be under mmap_lock() in order to prevent the creation of
-                 * another TranslationBlock in between.
-                 */
-                mmap_lock();
-                tb_invalidate_phys_range(addr, addr + l - 1);
-                written = pwrite(fd, buf, l,
-                                 (off_t)(uintptr_t)g2h_untagged(addr));
-                mmap_unlock();
-                if (written != l) {
-                    goto out_close;
-                }
-            }
-        } else if (flags & PAGE_READ) {
-            /* XXX: this code should not depend on lock_user */
-            p = lock_user(VERIFY_READ, addr, l, 1);
-            if (!p) {
-                goto out_close;
-            }
-            memcpy(buf, p, l);
-            unlock_user(p, addr, 0);
-        } else {
-            /* Bypass the host page protection using ptrace. */
-            if (fd == -1) {
-                fd = open("/proc/self/mem", O_RDONLY);
-                if (fd == -1) {
-                    goto out;
-                }
-            }
-            if (pread(fd, buf, l,
-                      (off_t)(uintptr_t)g2h_untagged(addr)) != l) {
-                goto out_close;
-            }
-        }
-        len -= l;
-        buf += l;
-        addr += l;
-    }
-    ret = 0;
-out_close:
-    if (fd != -1) {
-        close(fd);
-    }
-out:
-    return ret;
-}
-#endif
-
 bool target_words_bigendian(void)
 {
     return TARGET_BIG_ENDIAN;
-- 
2.47.1


