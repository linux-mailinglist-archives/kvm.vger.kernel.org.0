Return-Path: <kvm+bounces-51437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B8CAF7136
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7720452738F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0C02E4259;
	Thu,  3 Jul 2025 10:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xcc65YFn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1033B22D78F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540326; cv=none; b=WNihZnsdTPDExAmQzDGLy4j1S86IuaNMBr6e099+a/98izei3RUMmUN0YqGNrDKVUuyPj/MetlMB6Bhvmnu7oTZa8/KK2yfsc5yCGEjFpJ7h0xcNzn6moONjaEDQlsZAPO1FFwwd+SHG5p5AFJiJsIpEPk8Z6y5VfHqtq9SbzTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540326; c=relaxed/simple;
	bh=cJT50YBHJQaxUwI7u57XO0qmS9SIiZn3bVmgMM9j2Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYZUmZVZC1KI4xkK7CF8Q+WAaoFFLmoa41Zl72Z9RuZtvAkO8BfqeQXjBkmXQGo3JXXN8oDoB1/R5Epoc9k6OpX5umrQ5kIdool0EFtDxBuldxhrqzMejRuVqCWoqpnkpB/PiDlwL8f3JFna43D9NuIf4WeG+xBC47SYMHrYugk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xcc65YFn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-451e2f0d9c2so5428705e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540323; x=1752145123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/IUtIm3JHDSf2CDlC9ODm0iBh8kfs+CSjmgEqHJOxOs=;
        b=Xcc65YFnRmfqIo0la+A2qLumQUqOd4MNyaPfLEwQRHRTxf4cnTur+dVxKtS+BJVPWD
         LX8iWSZffyUuPiXNLQY18tQLElX/c651hj1j8y0cvla9BkRTTCX2vIgPdmQ9GjMgqhE6
         QM3q331kRtBfSLljsagm6lYQr0S5gh6jOB1m9HBn/yPzTjNreQYHB7hsd7kOfGCprMBP
         U1V/CeTtcbUI4/DlbutI0iMFHPo64OLTg2ImU6mltz61P34u5vRdv+e86NNJDdQqxuEO
         nK/EBxdWbZfohbNh/1Fot+EPfYr5mNn0HFp55WzyCavO5i3MO6ns0/FJ/TtbbQi9h1NK
         w+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540323; x=1752145123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/IUtIm3JHDSf2CDlC9ODm0iBh8kfs+CSjmgEqHJOxOs=;
        b=xR9mg5A0vV6fbc2rAFIjAqoxwGjbeRKjW/JNI3sVjXBwX459+YGcM/z2yfbBBIWm4Z
         Od7LfZqN8dwuMNyJiNFfgD8E0gv0sLDA7vEuIu1xPmPAsmW/ImupvFAgySzlIFTj/hKF
         on90LYnEHRoriibreFA5+AkaAfr6wcII9U2oOQ4bTHekjiENUYKJ1b9PBQ3rf+LtCqTL
         UYxSm4wYizbCENKnNkIAXWtPceWYPL9KIuCQtcvAcmA3oPZlz4WM3g7ml7MHsBDSlWKg
         MMJOYOg+DeZfQEve5TWJAypASKb5HwAV3likVNMWu2l8R2tScawYYNT4qsZxStT4O9fg
         gVfw==
X-Forwarded-Encrypted: i=1; AJvYcCXbaXLDNI3RXuhajEVxVGVgtlCxb3cGHeprcB5xKFbPrw8njPpxma2uS3cEDNg51UHYeRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSewFzVm/7aw7T3CLf32OuDPYuw3HSwHorSIFXwHnTwCpBH92L
	i4pWfC4eFbXfDYJJRLgOmbv/QoyzcOqtRBGjTFj8nuukbv8dWZU+6tnZ3VI+iBe0a0k=
X-Gm-Gg: ASbGnctu1XEUBuzuhzhaFzgdEfZyLw8HuFT0mdxxEFP9+Xkq+oX6fYrIh/ovmP2k0Vi
	LiLdGXAKdjGO/dCe1xiB5HPvfKtfZwgsN0CxZeRvjpRxMgSbO+pcBFd8Mp6sg3LRJFd18Ue8ekX
	BPvnT9dIhQQWR02O+crXtcRs/IyIX240Yys6X+FqGou8j3B+KHp+ZDxZwuzJ+pAvISiRPm3+y6w
	zwqKNdTUvUv31zfWIznUC+Av31XZfN47XMFeOy3sXGR52IXyQRCdD3N3iAoEdOUXniLgFqy3kja
	gjNaK1/53BwzYPAP5ih3+hrF5dRVIvvDHfyoEhzT7wIqwSrGxxSpmToz/zONx/Y2FYWbaml9wrl
	s2KzFs0FWgxg=
X-Google-Smtp-Source: AGHT+IGtJ0cI//sX+xQO2okCH3UjY/N8mn1LD8ELSsOTVKgUuaoSzuNpUsRkyEMDk9mdHMZB/nR0mA==
X-Received: by 2002:a05:600c:8b23:b0:453:69dc:2621 with SMTP id 5b1f17b1804b1-454ab34b49bmr23287835e9.12.1751540323244;
        Thu, 03 Jul 2025 03:58:43 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bde3b9sm23830665e9.28.2025.07.03.03.58.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:42 -0700 (PDT)
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
Subject: [PATCH v5 34/69] accel/hvf: Restrict internal declarations
Date: Thu,  3 Jul 2025 12:55:00 +0200
Message-ID: <20250703105540.67664-35-philmd@linaro.org>
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

Common code only needs to know whether HVF is enabled and
the QOM type. Move the rest to "hvf_int.h", removing the
need for COMPILING_PER_TARGET #ifdef'ry.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hvf.h     | 41 ----------------------------------------
 include/system/hvf_int.h | 36 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/include/system/hvf.h b/include/system/hvf.h
index 7b9384d816c..d3dcf088b3f 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -14,10 +14,6 @@
 #define HVF_H
 
 #include "qemu/accel.h"
-#include "qemu/queue.h"
-#include "exec/vaddr.h"
-#include "qom/object.h"
-#include "exec/vaddr.h"
 
 #ifdef COMPILING_PER_TARGET
 # ifdef CONFIG_HVF
@@ -40,41 +36,4 @@ typedef struct HVFState HVFState;
 DECLARE_INSTANCE_CHECKER(HVFState, HVF_STATE,
                          TYPE_HVF_ACCEL)
 
-#ifdef COMPILING_PER_TARGET
-struct hvf_sw_breakpoint {
-    vaddr pc;
-    vaddr saved_insn;
-    int use_count;
-    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
-};
-
-struct hvf_sw_breakpoint *hvf_find_sw_breakpoint(CPUState *cpu,
-                                                 vaddr pc);
-int hvf_sw_breakpoints_active(CPUState *cpu);
-
-int hvf_arch_insert_sw_breakpoint(CPUState *cpu, struct hvf_sw_breakpoint *bp);
-int hvf_arch_remove_sw_breakpoint(CPUState *cpu, struct hvf_sw_breakpoint *bp);
-int hvf_arch_insert_hw_breakpoint(vaddr addr, vaddr len, int type);
-int hvf_arch_remove_hw_breakpoint(vaddr addr, vaddr len, int type);
-void hvf_arch_remove_all_hw_breakpoints(void);
-
-/*
- * hvf_update_guest_debug:
- * @cs: CPUState for the CPU to update
- *
- * Update guest to enable or disable debugging. Per-arch specifics will be
- * handled by calling down to hvf_arch_update_guest_debug.
- */
-int hvf_update_guest_debug(CPUState *cpu);
-void hvf_arch_update_guest_debug(CPUState *cpu);
-
-/*
- * Return whether the guest supports debugging.
- */
-bool hvf_arch_supports_guest_debug(AccelState *as);
-
-bool hvf_arch_cpu_realize(CPUState *cpu, Error **errp);
-
-#endif /* COMPILING_PER_TARGET */
-
 #endif
diff --git a/include/system/hvf_int.h b/include/system/hvf_int.h
index d774e58df91..ea6730f255d 100644
--- a/include/system/hvf_int.h
+++ b/include/system/hvf_int.h
@@ -12,6 +12,8 @@
 #define HVF_INT_H
 
 #include "qemu/queue.h"
+#include "exec/vaddr.h"
+#include "qom/object.h"
 
 #ifdef __aarch64__
 #include <Hypervisor/Hypervisor.h>
@@ -77,4 +79,38 @@ int hvf_put_registers(CPUState *);
 int hvf_get_registers(CPUState *);
 void hvf_kick_vcpu_thread(CPUState *cpu);
 
+struct hvf_sw_breakpoint {
+    vaddr pc;
+    vaddr saved_insn;
+    int use_count;
+    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
+};
+
+struct hvf_sw_breakpoint *hvf_find_sw_breakpoint(CPUState *cpu,
+                                                 vaddr pc);
+int hvf_sw_breakpoints_active(CPUState *cpu);
+
+int hvf_arch_insert_sw_breakpoint(CPUState *cpu, struct hvf_sw_breakpoint *bp);
+int hvf_arch_remove_sw_breakpoint(CPUState *cpu, struct hvf_sw_breakpoint *bp);
+int hvf_arch_insert_hw_breakpoint(vaddr addr, vaddr len, int type);
+int hvf_arch_remove_hw_breakpoint(vaddr addr, vaddr len, int type);
+void hvf_arch_remove_all_hw_breakpoints(void);
+
+/*
+ * hvf_update_guest_debug:
+ * @cs: CPUState for the CPU to update
+ *
+ * Update guest to enable or disable debugging. Per-arch specifics will be
+ * handled by calling down to hvf_arch_update_guest_debug.
+ */
+int hvf_update_guest_debug(CPUState *cpu);
+void hvf_arch_update_guest_debug(CPUState *cpu);
+
+/*
+ * Return whether the guest supports debugging.
+ */
+bool hvf_arch_supports_guest_debug(AccelState *as);
+
+bool hvf_arch_cpu_realize(CPUState *cpu, Error **errp);
+
 #endif
-- 
2.49.0


