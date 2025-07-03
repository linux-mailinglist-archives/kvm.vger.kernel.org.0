Return-Path: <kvm+bounces-51432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82CE3AF712C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A42F6520AF6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1D02E2F03;
	Thu,  3 Jul 2025 10:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V1ulcyXV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3222E3360
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540299; cv=none; b=BQR4tZuSR0dsCRilXnhKpN0XUoJoLHNCHVn80Vtn895EKPCw9CBf2+BejVFFj2cjUlHgf4V4+kAcoFxu1ZNMLFm6IjEwnRWOLm1MLBtTPl4Fek1QDuspDUlSTxMsKf3/+qe5P5Y8nKoSWXviCNsK+dL+C5BouCXMMCCZl5RSk9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540299; c=relaxed/simple;
	bh=h4qSEVQje40su/WO0cC3xPeuNWZyUKKsYSIIRtlwPPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9e/xLK8PwdCCML1nf0vpq91lN9qKw8ZmwdAtor7icG6JSu/XYusIGXYmqPN/GRPdkmn3Q9TJ2NqW17xoPEF6NHgSEhQnWfbajKAwe+y9bslclEh0b6XeDjSoYWwq1r3ixvM/HtSx506k+o8dcVBMdS9krNlgaoma7Jq5eb+F1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V1ulcyXV; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4531e146a24so46609905e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540296; x=1752145096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZ/hvC4u2jp7Pix4yjeZfPZoKMalJ7KXbdnBXGN8XCk=;
        b=V1ulcyXVNFgDvAEE0kjUbUfcCLRUFWlp9MnsBbroDv3LB/AchkSQ108aZl2aear/Bf
         1VhvtJR/DvvgCH4TdLKAK6xkeDRrz8qpCU0gwd3vorUTa9hTVztzc6OwZkzehb+ZAySe
         XXpZ6b/qz1mu56mOcQMkqMmDzidbxVdf+JB08TtJV6gT7mIpK/PFjYxBx2N+W8EAmLBB
         g9Z0A+9YUKYkKH8Js989ZhJT+qk2TCC/P/qCnCdZO1lRdNbAhfYFN8LTnELli7tSwMpB
         l08xY3RzUMTesz9wisAipuq9P2ooAZCU/xJwe6vAq9hHj8BUYbiEfTIG/i3WbCFbZP3/
         OnHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540296; x=1752145096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EZ/hvC4u2jp7Pix4yjeZfPZoKMalJ7KXbdnBXGN8XCk=;
        b=BrsXz9W+UiOcG1uT0ybrvVnqFjilk6Ta1fstfRAZ5x8xl2qSqdywLbP1lxpAKc8bzE
         5wSVKEneR473YU1Wi+oIAxjK37BwYU7jlUpKNk3QMReGhji62AFU+mfI3vNxbs+L/+Bj
         rxwlvDmqZx8Qmy+BLczcW6uuRQQHpoe/9u4Gkd4voAi0L+ujW9KXtTtZPFPuqlsM4Zya
         HhIvxV+GZc4jOHXFZXKCvZ9IQcyBjCHd+G69EegCvZKRP+7+qWcIFvtJcTJHXAC0eeQL
         DKkgdOL6ZvwkzqDdpuMELSzy2IvyNVZNGUPDA1WBNXMKZffrf2nZ3+i4FLElT1S6ugA6
         ZGDw==
X-Forwarded-Encrypted: i=1; AJvYcCUZRmwHS7CwQzTyDu6XAVio8aMME8hCLfvHLHvBVXAo+WCdf8GtqyvMtv8RonFnX9U0t9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSQv9T6j5cSade4jLNbFwuh99SMi5MZhGs0IgfXjamqyjjdjiC
	eKv24y/VWWsh9VyqpZgKDg7PYNIUNH1m90rcoeAPzYo3ZSYBe5pxD38wJzr0zpTExrg=
X-Gm-Gg: ASbGncs7DGQskJDPlxmMcE9zEDG8GAQjMJGi69iVN05M7gmLsFTzfJHah3WL8bZhUfr
	dYU7pEniEfgZfaM91kGfGPC2DFLlSrCPre6yXLRsIl2ZuA0L17fqgmEZSYj3HvSYWJ06jUMn6Gt
	qG7k6cfUDjz14rTwT1ipwHBudjV+QntxHJX+0lEKKfHGmztz/442yCByySUyX2J942Zx/Ln/Pda
	bbdFGjbc1DN6N43OKnhoIVzBAagQ1W8xKZdYLcABwZZMApu1h8FliPyrulneVY9uKimf4/I9a6Q
	E2u+qZpOZ+9etj1g9YGO6eLBvUsoE/BpkBhtekgSLtZNtlqlPuH01bEK1UmaKZwmS8XinFeKyVf
	BSOiWRPGnDwA=
X-Google-Smtp-Source: AGHT+IEuN0jVmRpBpWx/3F8JjrZDICpuvuBuWma263BrzMgnHysFP/hDSn3CyvPN+WSuLtCvOQGX6Q==
X-Received: by 2002:a05:600c:190f:b0:44a:ac77:26d5 with SMTP id 5b1f17b1804b1-454a36e926fmr70940985e9.14.1751540296019;
        Thu, 03 Jul 2025 03:58:16 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9969a8bsm23507045e9.2.2025.07.03.03.58.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:15 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Markus Armbruster <armbru@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eric Blake <eblake@redhat.com>
Subject: [PATCH v5 29/69] accel/system: Introduce @x-accel-stats QMP command
Date: Thu,  3 Jul 2025 12:54:55 +0200
Message-ID: <20250703105540.67664-30-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Unstable QMP 'x-accel-stats' dispatches to the
AccelOpsClass::get_stats() and get_vcpu_stats() handlers.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 qapi/accelerator.json      | 17 +++++++++++++++++
 include/qemu/accel.h       |  2 ++
 include/system/accel-ops.h |  3 +++
 accel/accel-qmp.c          | 34 ++++++++++++++++++++++++++++++++++
 accel/accel-system.c       |  1 +
 accel/meson.build          |  2 +-
 6 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100644 accel/accel-qmp.c

diff --git a/qapi/accelerator.json b/qapi/accelerator.json
index 00d25427059..81308493c66 100644
--- a/qapi/accelerator.json
+++ b/qapi/accelerator.json
@@ -55,3 +55,20 @@
   'returns': 'HumanReadableText',
   'if': 'CONFIG_TCG',
   'features': [ 'unstable' ] }
+
+##
+# @x-accel-stats:
+#
+# Query accelerator statistics
+#
+# Features:
+#
+# @unstable: This command is meant for debugging.
+#
+# Returns: accelerator statistics
+#
+# Since: 10.1
+##
+{ 'command': 'x-accel-stats',
+  'returns': 'HumanReadableText',
+  'features': [ 'unstable' ] }
diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 065de80a87b..598796bdca9 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -41,6 +41,8 @@ typedef struct AccelClass {
     AccelOpsClass *ops;
 
     int (*init_machine)(AccelState *as, MachineState *ms);
+    /* get_stats: Append statistics to @buf */
+    void (*get_stats)(AccelState *as, GString *buf);
 
     /* system related hooks */
     void (*setup_post)(AccelState *as);
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index af54302409c..2a89641aa81 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -50,6 +50,9 @@ struct AccelOpsClass {
 
     void (*handle_interrupt)(CPUState *cpu, int mask);
 
+    /* get_vcpu_stats: Append statistics of this @cpu to @buf */
+    void (*get_vcpu_stats)(CPUState *cpu, GString *buf);
+
     /**
      * @get_virtual_clock: fetch virtual clock
      * @set_virtual_clock: set virtual clock
diff --git a/accel/accel-qmp.c b/accel/accel-qmp.c
new file mode 100644
index 00000000000..318629665b3
--- /dev/null
+++ b/accel/accel-qmp.c
@@ -0,0 +1,34 @@
+/*
+ * QMP commands related to accelerators
+ *
+ * Copyright (c) Linaro
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/accel.h"
+#include "qapi/type-helpers.h"
+#include "qapi/qapi-commands-accelerator.h"
+#include "system/accel-ops.h"
+#include "hw/core/cpu.h"
+
+HumanReadableText *qmp_x_accel_stats(Error **errp)
+{
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+    g_autoptr(GString) buf = g_string_new("");
+
+    if (acc->get_stats) {
+        acc->get_stats(accel, buf);
+    }
+    if (acc->ops->get_vcpu_stats) {
+        CPUState *cpu;
+
+        CPU_FOREACH(cpu) {
+            acc->ops->get_vcpu_stats(cpu, buf);
+        }
+    }
+
+    return human_readable_text_from_str(buf);
+}
diff --git a/accel/accel-system.c b/accel/accel-system.c
index 11ba8e24d60..246ea55425f 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -26,6 +26,7 @@
 #include "qemu/osdep.h"
 #include "qemu/accel.h"
 #include "hw/boards.h"
+#include "hw/core/cpu.h"
 #include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "qemu/error-report.h"
diff --git a/accel/meson.build b/accel/meson.build
index 52909314bfa..25b0f100b51 100644
--- a/accel/meson.build
+++ b/accel/meson.build
@@ -1,6 +1,6 @@
 common_ss.add(files('accel-common.c'))
 specific_ss.add(files('accel-target.c'))
-system_ss.add(files('accel-system.c', 'accel-blocker.c'))
+system_ss.add(files('accel-system.c', 'accel-blocker.c', 'accel-qmp.c'))
 user_ss.add(files('accel-user.c'))
 
 subdir('tcg')
-- 
2.49.0


