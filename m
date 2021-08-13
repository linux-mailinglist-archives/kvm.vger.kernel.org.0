Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B0C3EBDC6
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhHMVNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbhHMVNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:13:13 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F67DC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gc3-20020a17090b3103b0290178c33479a3so998403pjb.7
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wYh8smn48aXYYcSZU2IfL26LMTAImxlTzaqpMoQB+vI=;
        b=iIGAVHZKcKykf2UqiNJ/VKf7aiay1nVLZHYOH8PaIA8fPmijWDk+FHZsqqA1SiHX1t
         P+ZdTARp1CHBoyv6p3tP0h77nFP0nImCCGLPusXOJimW2BlBJ7ge9ulg4sbg7sIPHzIE
         EcbnAXDoIhPtUK749za3Ou+LVywp2EKagHgVYHInRj39M9zUKkxzOx6QGK+xUHzDF/5W
         xV6ujJ9gZojENTSzqheUUk6LJaXSzTvR/ufOk8Gi+IoEI4fXdchr84z9es0nrmSwGmZT
         PYAQE9UKwZIs5nMxlKSLnuBvCHO6mgErDKed8ZcgUDSNC7NYvBt92cfdBp+SCvfoPCio
         s16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wYh8smn48aXYYcSZU2IfL26LMTAImxlTzaqpMoQB+vI=;
        b=CHiX39ujKGQCDhFxlKsxSUtLSbLG2gXmBviNPy43SLKdH8i5rQooum3GCOzZ7f5mBl
         +FZVyi73vQiDO8+EnUKN3YQLL36JiBrmjBQXJJs/YZcPuiineFUUnaw9g3v+jMoSaEB/
         YyC7TfVXhSHUCLoRcDAcrx8MnsWVIQyXaBhDUxBjWiRzIUpmz1jSc6hAmtq3lFpXwwLB
         uJKFzXQlhCKYcsjJ3ohh7/34ii93iG94WpST60McaF5kqV7OZNo9vCrzJptd7c+PAxlq
         uf2hQcoxR3zr8mIgzapnF/vBOpHFzADyFDbLoqgw4keP7ImMSiQcIjMgHRN3Ron0cN93
         HF5g==
X-Gm-Message-State: AOAM532yLabTVEQRJD7eAd6ja7mybvhVtvnoizoZo72RhvAR+YDIg2dx
        wnl+8fCqtBQN0iTH4jVJlDIE9mzW1ng5
X-Google-Smtp-Source: ABdhPJzUyv3Nks/6akzkm7bz9MQ715ZbZPPEn21lRfbkNUcq/rc2orF4f9CipW4kCxAi5eDudD/vFX39FKh3
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:ee16:0:b029:2fe:ffcf:775a with SMTP id
 e22-20020a62ee160000b02902feffcf775amr4111078pfi.59.1628889165936; Fri, 13
 Aug 2021 14:12:45 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:09 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-9-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 08/10] KVM: arm64: selftests: Add light-weight spinlock support
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a simpler version of spinlock support for ARM64 for
the guests to use.

The implementation is loosely based on the spinlock
implementation in kvm-unit-tests.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/kvm/include/aarch64/spinlock.h  | 13 +++++++++
 .../selftests/kvm/lib/aarch64/spinlock.c      | 27 +++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5832f510a16c..8f6d82b570bd 100644
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
index 000000000000..6d66a3dac237
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
+	uint32_t val, res;
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
2.33.0.rc1.237.g0d66db33f3-goog

