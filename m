Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE4E4042FD
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350079AbhIIBlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349822AbhIIBkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:40:22 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F5FC06121D
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:50 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v21-20020a05620a0a9500b003d5c1e2f277so626328qkg.13
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Yfk/5WrJir9rO+SgiBvLfxyg0zqQRKPrsZnNMh9tI1o=;
        b=FgSapgo3yaUlpvIAly4RkNBRa/0qA3lF0DyIuIrdjIdtaxmdmuIUroC3uyKBKbQ2Xd
         kR4hWpfOMD9rb22wY8AFBOmYOLfN4II1R+lVC9aTcdt3gmRPrS/W196ot8+KlhY4BnT9
         M2GiZU88/mreBK14pMjm1CkWQTMjZ0tWM450qgQ9W0KtMw18AJJ4SaLooZ+9FYgvmX27
         U2hFwa0esk2pe//VsFkTgQsXo0igrc4duaftb5u8jt1ukrHIyPQuklw+Gp+K2p3C5SjM
         mk/HVxPaMqtogARws8ic6KGVZ98g1zuqtapnydinamsaCWx+Z3gm2ZDBPm+DTV2XR3Bt
         ouJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Yfk/5WrJir9rO+SgiBvLfxyg0zqQRKPrsZnNMh9tI1o=;
        b=scXuun52Vdr9JMhHSu4lZ8dvn2Cpxr05eO4SjsRizm3zjFNa76rV83RTTZi4mqkghA
         BkR7LILqksrzkOMzwdqsqyrm1h2gdQdJN+NAXZwbsl2WqchT124kiHOpvxJxmanHTZf1
         iWr3hJl7XHMel2LIKwQiRVzSRUyZ9Xn3yiJ+QEOysUZl6WszzXAdIZ2zpAr76mMIl8Ud
         CtPP/n5AvpBEawmKd7PBFKJxy5G43k8UUWDRRREQ8lHyIOCKMQRkDMVlokAtJ2tLhDEO
         RUDqoz9uuhJL5GVbhnNcedXO89lv5gQ33WfDBtinF4cc50rsnROjaUX91pN/Qju0W7zl
         wA7Q==
X-Gm-Message-State: AOAM532QYvs3WFPNTA+1/Au+HbphIYu1EqcKKAMnhdalSsUpOWfRCvbo
        uoBltR8bTQp9VXIeiR7d25993m7lllIJ
X-Google-Smtp-Source: ABdhPJyp7E3A1cxSEyAvlS2QydS7wrZHzQawCfhJXfTRBXJUnzLJ9TumzfCpUT57gEvgCPhYIsv52SzvFbmD
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:268e:: with SMTP id
 gm14mr466174qvb.51.1631151529165; Wed, 08 Sep 2021 18:38:49 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:10 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-11-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 10/18] KVM: arm64: selftests: Add light-weight spinlock support
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
index 5d05801ab816..61f0d376af99 100644
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
2.33.0.153.gba50c8fa24-goog

