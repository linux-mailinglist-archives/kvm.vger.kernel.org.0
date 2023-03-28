Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A7E6CC764
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbjC1QCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbjC1QCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:02:23 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6657E049
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:02:21 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l37so7291778wms.2
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680019340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyRcr9DasCtgvInsYY6GlB+tbhS02lFwPYhN+M0bqAw=;
        b=M/V1i9iWetntCRWzrdkWeGidDB588xHxXoR+BeABnw3ooUjzybpg9e3+r+Q0Zmkd70
         5/EG66HBTqiYyxNjit8pVI20J/nY57KRVTImmW4VZBbiy2Mt2waNfp70Ig2F2w7ut11a
         JobQqrP2ocleeTiv5b6UCHOEedXqK5pZIQwPGEciAV2ECerpZV/tDlyCQMjFn2xYy8MJ
         ydi1oyXJkFMW3im5pHwawf995v2kV5hq3TF7mtas0/yt8U9QHyp6cQZ2h9Uky7LdPUZo
         lzeeJKxX4uC6TYUYdREct6y9MssE9rjbVyt+B1Rz+HoPMbEANrrY5jxR23Mmme4zuG1q
         vJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680019340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OyRcr9DasCtgvInsYY6GlB+tbhS02lFwPYhN+M0bqAw=;
        b=jxHOjyN3t/k6suZqBnpnQxvQPxuHW70k389ykx1LEj8eSCh01zp8ql127xtk0bb5b5
         Lhzs0DvSXht+V7zu5WZ713BHdUGLJ1V4zCDKmWlm7/xfkVTd6y+n374mbxZXibSdx5Lc
         JSUfxBWtB2GxvTxx2pW64DYFvgQbo8oJ6TqnYascG2rnbFcHv6GAFbDjbeIhD9izJf8o
         p0qZdV091YkG3/f1ztFQTOA1amwRIVLC2jV6akS2HaIMcnC5hFljezSDNnsRvkF9I1m0
         OV9nrUA1U8vaQpzHvmkq+eRHwJY/L0sH0jdWPrYQrKaY+xfOOo6hUbMiJ8Xz7PZD56ba
         okcA==
X-Gm-Message-State: AO0yUKXQBSYWHzFWii1Jy8X2ZcrQon1oHGnCZ+H8srfmxx0SmZ1lxE1d
        P9H6UTZawmlPUvPHbe71eclGPw==
X-Google-Smtp-Source: AK7set/ZtqVx903RDtVSYGptsz18zUVgqjMNZ/IkszSkzAZarRI2FxJklBhqfOllK+78VU2eGn5OQQ==
X-Received: by 2002:a05:600c:2114:b0:3dc:1687:9ba2 with SMTP id u20-20020a05600c211400b003dc16879ba2mr11868573wml.35.1680019340251;
        Tue, 28 Mar 2023 09:02:20 -0700 (PDT)
Received: from localhost.localdomain ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b003ee10fb56ebsm17690163wmk.9.2023.03.28.09.02.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Mar 2023 09:02:19 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        qemu-s390x@nongnu.org, Fabiano Rosas <farosas@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Yanan Wang <wangyanan55@huawei.com>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-8.0 2/3] softmmu: Restrict cpu_check_watchpoint / address_matches to TCG accel
Date:   Tue, 28 Mar 2023 18:02:02 +0200
Message-Id: <20230328160203.13510-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230328160203.13510-1-philmd@linaro.org>
References: <20230328160203.13510-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both cpu_check_watchpoint() and cpu_watchpoint_address_matches()
are specific to TCG system emulation. Declare them in "tcg-cpu-ops.h"
to be sure accessing them from non-TCG code is a compilation error.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h         | 37 ------------------------------
 include/hw/core/tcg-cpu-ops.h | 43 +++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 821e937020..ce312745d5 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -970,17 +970,6 @@ static inline void cpu_watchpoint_remove_by_ref(CPUState *cpu,
 static inline void cpu_watchpoint_remove_all(CPUState *cpu, int mask)
 {
 }
-
-static inline void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
-                                        MemTxAttrs atr, int fl, uintptr_t ra)
-{
-}
-
-static inline int cpu_watchpoint_address_matches(CPUState *cpu,
-                                                 vaddr addr, vaddr len)
-{
-    return 0;
-}
 #else
 int cpu_watchpoint_insert(CPUState *cpu, vaddr addr, vaddr len,
                           int flags, CPUWatchpoint **watchpoint);
@@ -988,32 +977,6 @@ int cpu_watchpoint_remove(CPUState *cpu, vaddr addr,
                           vaddr len, int flags);
 void cpu_watchpoint_remove_by_ref(CPUState *cpu, CPUWatchpoint *watchpoint);
 void cpu_watchpoint_remove_all(CPUState *cpu, int mask);
-
-/**
- * cpu_check_watchpoint:
- * @cpu: cpu context
- * @addr: guest virtual address
- * @len: access length
- * @attrs: memory access attributes
- * @flags: watchpoint access type
- * @ra: unwind return address
- *
- * Check for a watchpoint hit in [addr, addr+len) of the type
- * specified by @flags.  Exit via exception with a hit.
- */
-void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
-                          MemTxAttrs attrs, int flags, uintptr_t ra);
-
-/**
- * cpu_watchpoint_address_matches:
- * @cpu: cpu context
- * @addr: guest virtual address
- * @len: access length
- *
- * Return the watchpoint flags that apply to [addr, addr+len).
- * If no watchpoint is registered for the range, the result is 0.
- */
-int cpu_watchpoint_address_matches(CPUState *cpu, vaddr addr, vaddr len);
 #endif
 
 /**
diff --git a/include/hw/core/tcg-cpu-ops.h b/include/hw/core/tcg-cpu-ops.h
index 20e3c0ffbb..0ae08df47e 100644
--- a/include/hw/core/tcg-cpu-ops.h
+++ b/include/hw/core/tcg-cpu-ops.h
@@ -175,4 +175,47 @@ struct TCGCPUOps {
 
 };
 
+#if defined(CONFIG_USER_ONLY)
+
+static inline void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
+                                        MemTxAttrs atr, int fl, uintptr_t ra)
+{
+}
+
+static inline int cpu_watchpoint_address_matches(CPUState *cpu,
+                                                 vaddr addr, vaddr len)
+{
+    return 0;
+}
+
+#else
+
+/**
+ * cpu_check_watchpoint:
+ * @cpu: cpu context
+ * @addr: guest virtual address
+ * @len: access length
+ * @attrs: memory access attributes
+ * @flags: watchpoint access type
+ * @ra: unwind return address
+ *
+ * Check for a watchpoint hit in [addr, addr+len) of the type
+ * specified by @flags.  Exit via exception with a hit.
+ */
+void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
+                          MemTxAttrs attrs, int flags, uintptr_t ra);
+
+/**
+ * cpu_watchpoint_address_matches:
+ * @cpu: cpu context
+ * @addr: guest virtual address
+ * @len: access length
+ *
+ * Return the watchpoint flags that apply to [addr, addr+len).
+ * If no watchpoint is registered for the range, the result is 0.
+ */
+int cpu_watchpoint_address_matches(CPUState *cpu, vaddr addr, vaddr len);
+
+#endif
+
 #endif /* TCG_CPU_OPS_H */
-- 
2.38.1

