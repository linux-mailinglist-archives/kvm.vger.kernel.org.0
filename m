Return-Path: <kvm+bounces-36459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 975F3A1AD83
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:46:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E1123A585C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2799C1EEA3C;
	Thu, 23 Jan 2025 23:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HaoNOBLb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5AB1D61A3
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675974; cv=none; b=NzChuB2h+xuzt38NUnrfmUitibkFtzQB2TxrlkmD023Z0RdleREojrzYTSyLdHiCrNkMv+fcnVMla1AiGso+y+89GFlNyfrY5XIzcRkmPA6MkkbU/85SVdT9MnsnV31ANiamdaR0E67QIW2qw/jFLenYd5RxY4/X5szBd1r6EVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675974; c=relaxed/simple;
	bh=JxV8ICm/dyssa1IQy7DHLpPEFQ9ElMcvH8bEdcJpFNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rI/0SzBLbW4njDXdwGsFKtJxXXij/8q3bGK0wUd9bOMYgiwtgPvABloYtRvkk/TJbmb6qs2odV0BtOjeVGa9x2UgMufwjTtjigX5GEP21UxzzSVJB3sLLxhxfH8GlQflLKjNxQ3vnOlf5JUCnTPRGiZtjM2B/w5F2x8KCURBypA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HaoNOBLb; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-386329da1d9so841661f8f.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675971; x=1738280771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSu/7xOdAlhOhpGqndt0dd/xIMB7MzmL+xgNpZ/1JvM=;
        b=HaoNOBLb/jWzAAoKNzLdk26cNdmUUG/nmVa/yJYK9ruUf+glCnrPsgKAN/uDiip2ps
         VGhVf0GoE7eVfh1MGez7ANm1TrXhm/Qs94GyrzMHdraR9PN9AK/eNEQztZZRYdN3f/v5
         0fiGg40stoMxo3G3MuI6uFB67d40uHaLNNknc9PLWsMWLlyyfDaJN9c42h9i9wTPKAfj
         PshPKaSFJejAzFxVbKVea9MSQZknsFvoMApYkk/dmGhhKAxp0zKWcunT6QxYt8Ls+CZ3
         lQfSgyAxHB+ekiAfWemSWBEhvMmUtPYsfSEYB/Sr749JKJKPiojipCQz532h2Jzu0El3
         +NxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675971; x=1738280771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xSu/7xOdAlhOhpGqndt0dd/xIMB7MzmL+xgNpZ/1JvM=;
        b=vpoY/JaQkg7P59aIVtHSlYY50hHtaJWDeQnQ1tSgJnzM+qxhKdlitJ4BwaPKB9CDyw
         58K9/ujmISCRmL3FcG2ErUZhphIJKQL1WMAQTT0gcF7vl204ucgBzW7vC+vzAiSzbVhT
         qukamqj8Ny2AtCLrp4A2Vh1fCHUvq193zqtd9vg78lzWAmavEu+5tUNXZrjMQE7PLu9k
         UGUNzUE7fTjL8cdQLbU6xINZqbzSZQOBSqgSKDliXQ6LhGuVTt9BYIuciTZ6AW0UqoIW
         yf8OtfevrVgYkVLNi1/GAx2Do7s2XHI4d4+Q+CfgSDOowEETEx1GpRjlmCpZ8xbbPDhP
         KJkw==
X-Forwarded-Encrypted: i=1; AJvYcCUxT+XPq2JbeA+Zb+DLjvZJenMxeWxnM90Zsqya2R5GgM7+rsS/qj2OUqx236rI+LJ0W4w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw62G6EEteBYnEzvvKSp4nzDHdpDV0ZmdQ4KQtcTpelvbHQ4cMJ
	DUXe7RmBMZTK3B8snwmcK71RHwQ34Ta0q+0WSrABTDqQSxiGy/OvVybRpcxXScw=
X-Gm-Gg: ASbGnctT9Fav4F2NL9lJN9E3iNQb1Pf2gRNC7bMOpfuQt5d5E/LuPrI35j1V/G0bHI8
	5LEOxbb1TZz/61d9T0/DKCQVwNRawEgKgAF6cWifAZ3W33vZQfYxIMzHOJWK0jDF6s5M9xHcPsV
	jKt6GuGHUfHypwWyZKzsZJQwMQmSvUwc04xuMx/LUYFIzaKrqrGkLfFHKoQoRLHbznu6FS/jjw6
	WTM3vo4Ykj1GYGqJ0+FiVkW7OpgTB3+Z0Ce2yI5EZZgrCWKYzsIAduTjM/XgBChJxT0lpcDE9Ls
	Y/oOnGLKfOVa3H3DJDtsc7Pod0NF7wDabmRyp0JnrN0kRGCmBrAzwjA=
X-Google-Smtp-Source: AGHT+IFycJysfhMaCpSR16Rzr8MUGZyLqdkkV1WoJ+3KdF//Z7stLVwsFpncYG19E6JH49Nuy1YUSA==
X-Received: by 2002:a05:6000:e4a:b0:385:ed16:c91 with SMTP id ffacd0b85a97d-38bf566f3bemr20406552f8f.24.1737675970851;
        Thu, 23 Jan 2025 15:46:10 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4d34e3sm6953255e9.39.2025.01.23.15.46.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:46:10 -0800 (PST)
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
Subject: [PATCH 20/20] cpus: Build cpu_exec_[un]realizefn() methods once
Date: Fri, 24 Jan 2025 00:44:14 +0100
Message-ID: <20250123234415.59850-21-philmd@linaro.org>
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

Now that cpu_exec_realizefn() and cpu_exec_unrealizefn()
methods don't use any target specific definition anymore,
we can move them to cpu-common.c to be able to build them
once.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Eventually they'll be absorbed within cpu_common_[un]realizefn().
---
 cpu-target.c         | 30 ------------------------------
 hw/core/cpu-common.c | 26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/cpu-target.c b/cpu-target.c
index bfcd48f9ae2..8f4477be417 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -19,43 +19,13 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
-#include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
 #include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "exec/replay-core.h"
-#include "exec/cpu-common.h"
 #include "exec/log.h"
 #include "accel/accel-cpu-target.h"
 #include "trace/trace-root.h"
-#include "qemu/accel.h"
-#include "hw/core/cpu.h"
-
-bool cpu_exec_realizefn(CPUState *cpu, Error **errp)
-{
-    if (!accel_cpu_common_realize(cpu, errp)) {
-        return false;
-    }
-
-    /* Wait until cpu initialization complete before exposing cpu. */
-    cpu_list_add(cpu);
-
-    cpu_vmstate_register(cpu);
-
-    return true;
-}
-
-void cpu_exec_unrealizefn(CPUState *cpu)
-{
-    cpu_vmstate_unregister(cpu);
-
-    cpu_list_remove(cpu);
-    /*
-     * Now that the vCPU has been removed from the RCU list, we can call
-     * accel_cpu_common_unrealize, which may free fields using call_rcu.
-     */
-    accel_cpu_common_unrealize(cpu);
-}
 
 char *cpu_model_from_type(const char *typename)
 {
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 71425cb7422..c5382a350fc 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -193,6 +193,20 @@ static void cpu_common_parse_features(const char *typename, char *features,
     }
 }
 
+bool cpu_exec_realizefn(CPUState *cpu, Error **errp)
+{
+    if (!accel_cpu_common_realize(cpu, errp)) {
+        return false;
+    }
+
+    /* Wait until cpu initialization complete before exposing cpu. */
+    cpu_list_add(cpu);
+
+    cpu_vmstate_register(cpu);
+
+    return true;
+}
+
 static void cpu_common_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cpu = CPU(dev);
@@ -234,6 +248,18 @@ static void cpu_common_unrealizefn(DeviceState *dev)
     cpu_exec_unrealizefn(cpu);
 }
 
+void cpu_exec_unrealizefn(CPUState *cpu)
+{
+    cpu_vmstate_unregister(cpu);
+
+    cpu_list_remove(cpu);
+    /*
+     * Now that the vCPU has been removed from the RCU list, we can call
+     * accel_cpu_common_unrealize, which may free fields using call_rcu.
+     */
+    accel_cpu_common_unrealize(cpu);
+}
+
 static void cpu_common_initfn(Object *obj)
 {
     CPUState *cpu = CPU(obj);
-- 
2.47.1


