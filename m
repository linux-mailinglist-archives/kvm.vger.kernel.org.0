Return-Path: <kvm+bounces-51438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C97AF7138
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC0661C220F0
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0CAC2E2F03;
	Thu,  3 Jul 2025 10:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nsrLcOaJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4978A22D78F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540332; cv=none; b=Vv2r3DjRjDak8XzX4eIn3tLhPD6h1e3mRHrRYZSR3pkBI6RzGdttwlztWLG8psmO6C/KWK7UvotEbnQO/bgq+A/GK+yzVx1lclm7oxbYNwKxtogpO15njvL4CuF+RhIXF/1vv4xwO8lbed+68sVzuCPUwiH8JDCzoBT0U8JdoRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540332; c=relaxed/simple;
	bh=7xJaucOEXCQQfDOGo/w4OETpahH6fzqmsr7waZvSiTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qwf+HreVXJl91FkOOpJnOWb4U6w4g5wwA9ehtiHU4GS/oLg8B6FWcAtyd0DTiM7hguQCCttMa8eqe8eO8ylR5qUuR3/YCk0mtDIIAlDmbmWIgQ783lXg4c3Bd54EB+5woh/iavrFFvaR00nChZM4H/B38a+N0kKumfhcpMnXi2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nsrLcOaJ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a6d1369d4eso4373242f8f.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540328; x=1752145128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHMs7nmOn+MVUxcnTbQfOV+3h+SOD8dybVNBbhpVafQ=;
        b=nsrLcOaJcQ3riXOPFNUA5nSjBP17z3Vq/RKedwqJb/dxTsjk03f680CmcMmf9VSldh
         O/Ihr5g7b4FcvRwHElkJHSLxFYqJNu06ypp2N0Su2Q/6v6JhJuPFuHQloqenPbIAuCzB
         t4gV8lqhRQruGEDxHIZKlXoXhGiU3nQASqDLsmus1GgxVuAcI/d+rMQSlkossI/dMLGM
         dUgx9CNlAoDCLJkz3IYoLTqBrtyYfWGlCiaebWoUcwyMdWXpxF6RzUNkutu02bG/vfXN
         TfUBbiddzLVT/OHxmXmqA2n50i7hu9VrAjvJBezdGaW2Dd8VUXYBJoP8gK9vfkWyIxHY
         BtGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540328; x=1752145128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LHMs7nmOn+MVUxcnTbQfOV+3h+SOD8dybVNBbhpVafQ=;
        b=echM0GO9vhlniCMfOOUWse1QqCrq+EK1M8eAgJYoofJv5uL6JCVvKysmXwHWbkLfvG
         E1bmvpPgAy34PF8THhAh8vCEoi3RW84UOc8Q42nijLoOPRde89SkZNMgww9DZgwsw9Zv
         D7kf96+Hq6F25xqu9wlyBHjypJwz+XL3NPgCi5IJhD9q4oXmtRCFVmxqRf75Qh3In6UM
         FWkGbEBVoW8wl8huz7z2mrsrojTvgdr6Nqvte6YqDwVwgYr1A8A3zFkBvfNtl3BmqmTT
         6lsEN+xs6+N0XlzW1OCvdWzBAq05/0hHR0RFSHgT0n7CD+kEbp15il/BIadtNrQFGuGi
         daMg==
X-Forwarded-Encrypted: i=1; AJvYcCU56bFbUBVvTjJJzaX+WYVQi94tWJ6AQVzvuld7lpkVsMpRKJ+HznCyUEC++D+8Yc2Zkqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsdOhbAxpIIvHVxWSs8wHDuAaihU1dNJ1O5a5oVDf/D/WOELBy
	i89sMh6997zKdS9EwBwxi+fv7lw3ta64qa+0TSb/eLJkD4hrd0sCojawW8lqLubkspE=
X-Gm-Gg: ASbGnctMKMYbA/coCk2JnmuW7/P7ogrvLOQSpfVuvfUnh/WPimmJuxy1zovtoGri4Tn
	NkY+Qkntqp2fXnGzJnNFl38xFsFcGFwyEO9jp0Se+QG7X8bTlsB2Q6Eu+noJNRVirELTcCjEbHn
	N0pu97chOtkpxmqjjZ0+yd8kusv6l6ACcHyNu0sOQtJHpWljo3i3lDN8f88qOE0nZwVhJq10s+o
	zQBNJkRY6+tkCogRT/92DfVVaUrkhe5dspeM58gt8mjeNyt2s2vkrAdHce7cNclSqtI2QyMyZ95
	Bv815UCTOiakiPr5DeMMWMjiJMm9hriN4FsvVMuLUUKvEmB1o16N2VLrBzZoWQKIu1n12qVepLO
	14xHx8J4zoq8=
X-Google-Smtp-Source: AGHT+IGcb+B+2eqTUNX8uRFTTQzUgMkV/m7rHzIH497ND/XiKF/P31S+FmWv5xa9JLBwoq6QvhSzaA==
X-Received: by 2002:adf:9ccc:0:b0:3a4:ed10:c14 with SMTP id ffacd0b85a97d-3b32ca3f42emr1548364f8f.14.1751540328474;
        Thu, 03 Jul 2025 03:58:48 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7fa2a7sm18184359f8f.21.2025.07.03.03.58.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:48 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>
Subject: [PATCH v5 35/69] accel/hvf: Move per-cpu method declarations to hvf-accel-ops.c
Date: Thu,  3 Jul 2025 12:55:01 +0200
Message-ID: <20250703105540.67664-36-philmd@linaro.org>
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

hvf-all.c aims to contain the generic accel methods (TYPE_ACCEL),
while hvf-accel-ops.c the per-vcpu methods (TYPE_ACCEL_OPS).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/hvf/hvf-accel-ops.c | 29 +++++++++++++++++++++++++++++
 accel/hvf/hvf-all.c       | 29 -----------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index ada2a3357eb..be044b9ceaa 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -50,6 +50,7 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
+#include "qemu/queue.h"
 #include "system/address-spaces.h"
 #include "gdbstub/enums.h"
 #include "hw/boards.h"
@@ -492,6 +493,34 @@ static void hvf_start_vcpu_thread(CPUState *cpu)
                        cpu, QEMU_THREAD_JOINABLE);
 }
 
+struct hvf_sw_breakpoint *hvf_find_sw_breakpoint(CPUState *cpu, vaddr pc)
+{
+    struct hvf_sw_breakpoint *bp;
+
+    QTAILQ_FOREACH(bp, &hvf_state->hvf_sw_breakpoints, entry) {
+        if (bp->pc == pc) {
+            return bp;
+        }
+    }
+    return NULL;
+}
+
+int hvf_sw_breakpoints_active(CPUState *cpu)
+{
+    return !QTAILQ_EMPTY(&hvf_state->hvf_sw_breakpoints);
+}
+
+static void do_hvf_update_guest_debug(CPUState *cpu, run_on_cpu_data arg)
+{
+    hvf_arch_update_guest_debug(cpu);
+}
+
+int hvf_update_guest_debug(CPUState *cpu)
+{
+    run_on_cpu(cpu, do_hvf_update_guest_debug, RUN_ON_CPU_NULL);
+    return 0;
+}
+
 static int hvf_insert_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
 {
     struct hvf_sw_breakpoint *bp;
diff --git a/accel/hvf/hvf-all.c b/accel/hvf/hvf-all.c
index 8c387fda24d..481d7dece57 100644
--- a/accel/hvf/hvf-all.c
+++ b/accel/hvf/hvf-all.c
@@ -12,7 +12,6 @@
 #include "qemu/error-report.h"
 #include "system/hvf.h"
 #include "system/hvf_int.h"
-#include "hw/core/cpu.h"
 
 const char *hvf_return_string(hv_return_t ret)
 {
@@ -41,31 +40,3 @@ void assert_hvf_ok_impl(hv_return_t ret, const char *file, unsigned int line,
 
     abort();
 }
-
-struct hvf_sw_breakpoint *hvf_find_sw_breakpoint(CPUState *cpu, vaddr pc)
-{
-    struct hvf_sw_breakpoint *bp;
-
-    QTAILQ_FOREACH(bp, &hvf_state->hvf_sw_breakpoints, entry) {
-        if (bp->pc == pc) {
-            return bp;
-        }
-    }
-    return NULL;
-}
-
-int hvf_sw_breakpoints_active(CPUState *cpu)
-{
-    return !QTAILQ_EMPTY(&hvf_state->hvf_sw_breakpoints);
-}
-
-static void do_hvf_update_guest_debug(CPUState *cpu, run_on_cpu_data arg)
-{
-    hvf_arch_update_guest_debug(cpu);
-}
-
-int hvf_update_guest_debug(CPUState *cpu)
-{
-    run_on_cpu(cpu, do_hvf_update_guest_debug, RUN_ON_CPU_NULL);
-    return 0;
-}
-- 
2.49.0


