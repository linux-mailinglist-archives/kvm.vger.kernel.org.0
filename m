Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BB636DFB8
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 21:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbhD1TjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 15:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241865AbhD1Ti7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 15:38:59 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472B7C061343
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:38:11 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id o129-20020a6292870000b0290241fe341603so23778462pfd.14
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kb9fVqaEasPXHJjemr3PZzkN5J5eezfWbFcJnEMHVOk=;
        b=qYfUcI8x807JKI9l/U++/Sjw5vGfSNZMigPQb/7mDMyNfDYLHzJFME3Uqw/MuOgZD2
         0lfHwNTEgAIOWQgk66R/oDvcXHdumTv9zq418P889zjGuVU4ZGYt/qs5kXL9RAdkQ9JY
         uTqSql1MXi3dScdoztfMsdDmL3/E3yvQUFQKPE98W62s/O5AJKMstqN2tGzwZdjT7pjm
         CYfU/fZkXzkZYu0o0hPkEQbKBcnL/oTCpX5TRIsGC13JAxwsXEPbnhKZwaElvbqnNrZ/
         vhH1el2m7YkUf5qLVtLclOzld0FgUWh6wkZsF5xH8vqzfmi6ymN2E1pBZJgIIu12Yb3S
         j7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kb9fVqaEasPXHJjemr3PZzkN5J5eezfWbFcJnEMHVOk=;
        b=Tk/3TOTwxPu5228f3xh/UWcr7yjFJA9BAZ62GCHlAvmUOCcpwUffnDMFTMWMZZ9KVP
         Jr8K4BQWt8PeIfgVRWA828gE6NuynsJzE+XaBS84V3iupyXiz+xJ1anMtmJ5QiGdIchx
         ypR61pP9x8VYfPSeX+Fj1ftgKRrUrtjHx6v+GLarsFBxEojM1VAvB3z9Uk3LUNVbkuue
         NpIxmuGTdu3mgokBh8v9urel/WkzLkb/K/J1x3JP74DmYw1EGMx2RlGARtcviL7qFUhX
         8g5D7O0N+BdSokR2Gx2TrtN/7pmoNdlO2VWiBBb3Iqw5/FtPryL4/kvYguQqPAOfZR1X
         1vTw==
X-Gm-Message-State: AOAM530IpKwe3SXZRmXyGRwjaCsGxumIhuUUJ6h5Ep4v0E3PijI+b3GB
        yy+KUZNW/LgzE5zMW2Bdiir2SEJb8x0vOg==
X-Google-Smtp-Source: ABdhPJwPmbenM3CsmT9vP1tWe3dIypjdM10FSYepgnZLeP8dGuDFufxk/aY5Gct8Pc7q72KuuqdCSYTrLZA97A==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:74c5:b029:ed:d41:1ca0 with SMTP
 id f5-20020a17090274c5b02900ed0d411ca0mr22592543plt.66.1619638690836; Wed, 28
 Apr 2021 12:38:10 -0700 (PDT)
Date:   Wed, 28 Apr 2021 12:37:55 -0700
In-Reply-To: <20210428193756.2110517-1-ricarkol@google.com>
Message-Id: <20210428193756.2110517-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20210428193756.2110517-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5/6] KVM: selftests: Introduce utilities for checking x86 features
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add utilities for checking CPU features using the same x86 features
format used in the kernel (defined in cpufeatures.h). This format embeds
the function, index, and register to use. By using this format and these
utilities, tests will not have to define their own feature macros and
will be able to use kvm_cpuid_has(FEATURE_XYZ) or
this_cpu_has(FEATURE_XYZ) without having to worry about what register or
index to use.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/x86_64/cpuid.h      | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/cpuid.h

diff --git a/tools/testing/selftests/kvm/include/x86_64/cpuid.h b/tools/testing/selftests/kvm/include/x86_64/cpuid.h
new file mode 100644
index 000000000000..4d8c67d528f4
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/cpuid.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Adapted from /arch/x86/kvm/cpuid.h
+ */
+
+#ifndef SELFTEST_KVM_CPUID_FEATURE_H
+#define SELFTEST_KVM_CPUID_FEATURE_H
+
+#include <stdint.h>
+#include <asm/cpufeatures.h>
+#include <asm/kvm_para.h>
+#include "reverse_cpuid.h"
+
+static __always_inline u32 *kvm_cpuid_get_register(unsigned int x86_feature)
+{
+	struct kvm_cpuid_entry2 *entry;
+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
+
+	entry = kvm_get_supported_cpuid_index(cpuid.function, cpuid.index);
+	if (!entry)
+		return NULL;
+
+	return __cpuid_entry_get_reg(entry, cpuid.reg);
+}
+
+static __always_inline bool kvm_cpuid_has(unsigned int x86_feature)
+{
+	u32 *reg;
+
+	reg = kvm_cpuid_get_register(x86_feature);
+	if (!reg)
+		return false;
+
+	return *reg & __feature_bit(x86_feature);
+}
+
+static __always_inline bool kvm_pv_has(unsigned int kvm_feature)
+{
+	u32 reg;
+
+	reg = kvm_get_supported_cpuid_entry(KVM_CPUID_FEATURES)->eax;
+	return reg & __feature_bit(kvm_feature);
+}
+
+static __always_inline bool this_cpu_has(unsigned int x86_feature)
+{
+	struct kvm_cpuid_entry2 entry;
+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
+	u32 *reg;
+
+	entry.eax = cpuid.function;
+	entry.ecx = cpuid.index;
+	__asm__ __volatile__("cpuid"
+			     : "+a"(entry.eax), "=b"(entry.ebx),
+			       "+c"(entry.ecx), "=d"(entry.edx));
+
+	reg = __cpuid_entry_get_reg(&entry, cpuid.reg);
+	return *reg &  __feature_bit(x86_feature);
+}
+
+#endif /* SELFTEST_KVM_CPUID_FEATURE_H */
-- 
2.31.1.498.g6c1eba8ee3d-goog

