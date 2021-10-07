Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2683E426095
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 01:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbhJGXhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 19:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241532AbhJGXhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 19:37:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2B8C061775
        for <kvm@vger.kernel.org>; Thu,  7 Oct 2021 16:35:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s6-20020a254506000000b005b6b6434cd6so10057476yba.9
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 16:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q7y95FHiaft0lqoqJNHjM0WpKZuDHTR8jqan7ASS4mc=;
        b=l71lnosf3HrI9aon/pt84xBBqjPvBzcdmQk34E6QmaZ5JHCUgHDmwxcybuFjVIMIWE
         DfdROrINx5+ZTq7qnZCDLThV0G9tJnyxuVdst9iasCeJ0Ekpv2K7jNrbjx1MIG8EqeNq
         vUHEi35UsuqDXC9Wf9+CSPx6nFgOAhC688SK0QDcRaKvseHIUat5El6C59j7YUWItsl/
         dbVH1XRCILfzOd7Aqo4Ktn2T+t8Yt6LVXHFhRKtCJwkUcHgJXWqpMcoQWhXLSijGDF3v
         qPUcNy1AS0Dt+O7cJxJ7JU6Nzi3fhXGwc/geU/Pmuf8eeT4TzydnMukbrTx4dRN9RhOI
         hajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q7y95FHiaft0lqoqJNHjM0WpKZuDHTR8jqan7ASS4mc=;
        b=wjju1Rp76aU7bIimZBEaKfvdvLsg+RPQCn3ZagOyG1Rd5Q1RJ/dd036IwK948QWAhs
         R6X3+FIVnojpetqNmjwDU2AzWjW91mxOSmanoXfy2GAxBH4SqSQSQsxdwkeW2+KKkLw5
         SPpesmyPaT4w8gJ24lsbTeGR90kJSz1GY8bJmrLtPF0AhsS0/LyZzDloxqzupB4oLczI
         8FUKbg7YKRrsesI4m5RY63l/VjyT9B/mwBbjs+7ozQ5uP6eRieDbruqomDVW2g8PwcQ0
         DS8ofEHRciuiIxtUA2ZPcmy3mjptkyfLDmRV8oXfTM/BIQ0T70sQrVLbO+lmkiFm/e5F
         0VLA==
X-Gm-Message-State: AOAM533UzDA5ljLWyTsZhE/pw6kkQF+NXMgPXDhWwCk7pPSHf1oAVege
        yWi0iSDQBVudaOvUC98RwGoB9kjbJ6DP
X-Google-Smtp-Source: ABdhPJwiqsvAFwzWglWlKAGwaLP8XjvKa1nO61jqoECDO+wCudXZe0fCV3LV3memQ/jCpI2h6IMS4qzX8J8z
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:2a91:: with SMTP id
 q139mr8300650ybq.146.1633649713791; Thu, 07 Oct 2021 16:35:13 -0700 (PDT)
Date:   Thu,  7 Oct 2021 23:34:35 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-12-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 11/15] KVM: arm64: selftests: Add light-weight spinlock support
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a simpler version of spinlock support for ARM64 for
the guests to use.

The implementation is loosely based on the spinlock
implementation in kvm-unit-tests.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/kvm/include/aarch64/spinlock.h  | 13 +++++++++
 .../selftests/kvm/lib/aarch64/spinlock.c      | 27 +++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d1774f461393..d8fb91a5ea7b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -35,7 +35,7 @@ endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
 LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/include/aarch64/spinlock.h b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
new file mode 100644
index 000000000000..cf0984106d14
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SELFTEST_KVM_ARM64_SPINLOCK_H
+#define SELFTEST_KVM_ARM64_SPINLOCK_H
+
+struct spinlock {
+	int v;
+};
+
+extern void spin_lock(struct spinlock *lock);
+extern void spin_unlock(struct spinlock *lock);
+
+#endif /* SELFTEST_KVM_ARM64_SPINLOCK_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/spinlock.c b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
new file mode 100644
index 000000000000..a076e780be5d
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM64 Spinlock support
+ */
+#include <stdint.h>
+
+#include "spinlock.h"
+
+void spin_lock(struct spinlock *lock)
+{
+	int val, res;
+
+	asm volatile(
+	"1:	ldaxr	%w0, [%2]\n"
+	"	cbnz	%w0, 1b\n"
+	"	mov	%w0, #1\n"
+	"	stxr	%w1, %w0, [%2]\n"
+	"	cbnz	%w1, 1b\n"
+	: "=&r" (val), "=&r" (res)
+	: "r" (&lock->v)
+	: "memory");
+}
+
+void spin_unlock(struct spinlock *lock)
+{
+	asm volatile("stlr wzr, [%0]\n"	: : "r" (&lock->v) : "memory");
+}
-- 
2.33.0.882.g93a45727a2-goog

