Return-Path: <kvm+bounces-51455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F7FAF7163
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D847E4E7315
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF95F2E3B18;
	Thu,  3 Jul 2025 11:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SlASLj2g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC2B246798
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540420; cv=none; b=jL2zg3PewYCI0StNmlkL0/EYWHUpqjM2PySu8mWnIM20llXXaS8WN6gEgp7TYw7Vl8fpOMbKI+R26CLIhbYLmEReebd4yhd21Mxj5D+4ir1tjKlzsu2MY878PDULd53eiMSMd7vtsQm67Krc1v4QTaqjmYaCCwWodrOn/NzOEVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540420; c=relaxed/simple;
	bh=4DOzeU71uIeinUxnWuA/dGKC0x2I6Fh2h7qi0jLGtAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FB85CHxjeyppBqGY2SWHnIkKajwea6NpPNxfHz5jP4FiMUuysxvjV1KLlJEpl1xExjLS/Pz6/CH2ZeVBt+7GhHEKT+krEaCZ924j/0H+9l912+5ghH+7TtZrtf3vZW0rY3g/hBMFQkiG4GkyRuE5zqqQFKu0fzGo81G1xHv+eUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SlASLj2g; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a503d9ef59so4099130f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540416; x=1752145216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDEWo1rnLUm5BJBdCICU6CLKmSMFjw+gxKuOsuwVDUo=;
        b=SlASLj2gp8XDdgng/8C8TSS2eYkAIPIM+Aj7uBJsP4iR29vWHU/XpgtOfT2X8cHTW6
         Nt6Z4NEfb+Xd5Oqu2tf8n56cME2F+YBVe3KR02JCx79aD62Z0PzfqcP6C4pktmMQse+k
         se7JxvrLnOXI13BQde7tMSfEy8/7MkGb8DIKScxaa4vIudz8P+nUp71gxB+ci9DkmJxH
         MmUL5QX4kdokRvp04vnQbkfM4lusBisMksZJvg1Kj3e6Cb8uz4yK8lN8hIY+wHCdUjxU
         DsXVeKoiDjmoPZCsVsrxTa539YCI3+xpkgRGu23G4fBlsPsTQiyWFm6OqOI4v/gL39h4
         oFRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540416; x=1752145216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rDEWo1rnLUm5BJBdCICU6CLKmSMFjw+gxKuOsuwVDUo=;
        b=Epb7BVnRfURca6jetrtjJ4hLjMI4YYcRdtiMShtcjNdhvgYekhI2/YuIOdEZl1+DYc
         HYJJmGbv13d5bCI2uVMqvDP5XNPikizr4XmvL8ABZ04S20BU3xcd7+cVw9oopacZ4wzE
         feip2DOQu9sGf+wPSCO1CiRYNuvjIOA1U2mUc4TukP9rQ7OvSYKWsGrZKHLtA/jMBK1D
         hIZBEWKn59bH+f2hC8Sspu6N1ttfs3sVyTBE2twZ1fah7h6oqxzu9t62PNpE7W3+9ybV
         FR/fsTG0Y4UMr+deQdSV2pScENE7gWx4IkZA7eGe72Pb/OKD5CjMAnNLb3XsbxOX783x
         GdLw==
X-Forwarded-Encrypted: i=1; AJvYcCWa71GMElHwvfiou6AZVJOsqr8ZebTk10BWJTukE18amjgqtMNCaMQE31k7JQbrubfOFVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjO+Ba6OM1ioB/32H2SVzjOCzLsBxMhY9+3VQG2Agd+8YM5f8V
	EotntPF25QjKMXsaWeWpYPClJn1xzkmYvoYcGejm5Husa4fawAqGBL0SHkMCOsWSPiY=
X-Gm-Gg: ASbGncsRL+mbfQcxwf0HUShu/DhfdfLlZkpZlNXfbGOY5g91S6BBZYSeX68T3TrWGTy
	e8SQ39eB1aJBuDzLUT1LW/NjiQHxC/P9OL/DASD6vutHAtXqvR7KIKvfcyaxtOT9z2RUwxZMePp
	ck7l+s/lFD0XtWlmvsmR1/98wfQ3bpLv+X6Rmp6E411gkAz+SeC/p/WJB9csb11jMCldQx+sA3H
	Z0hV08iqWKDW6GxUuGi6v46ZwJO6k20EZU3OsgLcm+5tbY37o+63BTu+1vL0wRpVo+pAF1DAbqd
	miUz0IKXwHxvAj3j/mygzeobGkYWA6JgHXPx+F95zf7ChNkc2aXWyziTCsXNQunCMw4I8u17PoQ
	RzKcLQd8B6rQLoofG24f9sg==
X-Google-Smtp-Source: AGHT+IFhk+dJX89aeL6Cw0AQ89dfOnSUw7mCET4TWkmrNY6d5nurBwjiVVzjmOBE6Tzod4CCSgM23Q==
X-Received: by 2002:a05:6000:2f86:b0:3a4:e740:cd72 with SMTP id ffacd0b85a97d-3b1fe6b4e63mr4918822f8f.13.1751540416475;
        Thu, 03 Jul 2025 04:00:16 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52addsm18165861f8f.47.2025.07.03.04.00.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:16 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 52/69] accel: Introduce AccelOpsClass::cpu_thread_routine handler
Date: Thu,  3 Jul 2025 12:55:18 +0200
Message-ID: <20250703105540.67664-53-philmd@linaro.org>
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

In order to have a generic function creating threads,
introduce the thread_precreate() and cpu_thread_routine()
handlers.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/accel-ops.h |  5 ++++-
 accel/accel-common.c       | 16 +++++++++++++++-
 system/cpus.c              |  2 +-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 77bd3f586bd..d4bd9c02d14 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -39,7 +39,10 @@ struct AccelOpsClass {
     bool (*cpu_target_realize)(CPUState *cpu, Error **errp);
     void (*cpu_reset_hold)(CPUState *cpu);
 
-    void (*create_vcpu_thread)(CPUState *cpu); /* MANDATORY NON-NULL */
+    /* Either cpu_thread_routine() or create_vcpu_thread() is mandatory */
+    void *(*cpu_thread_routine)(void *);
+    void (*thread_precreate)(CPUState *cpu);
+    void (*create_vcpu_thread)(CPUState *cpu);
     void (*kick_vcpu_thread)(CPUState *cpu);
     bool (*cpu_thread_is_idle)(CPUState *cpu);
 
diff --git a/accel/accel-common.c b/accel/accel-common.c
index d719917063e..24038acf4aa 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -11,6 +11,7 @@
 #include "qemu/accel.h"
 #include "qemu/target-info.h"
 #include "system/accel-ops.h"
+#include "system/cpus.h"
 #include "accel/accel-cpu.h"
 #include "accel-internal.h"
 
@@ -104,7 +105,20 @@ void accel_create_vcpu_thread(AccelState *accel, CPUState *cpu)
     if (ac->ops->create_vcpu_thread != NULL) {
         ac->ops->create_vcpu_thread(cpu);
     } else {
-        g_assert_not_reached();
+        char thread_name[VCPU_THREAD_NAME_SIZE];
+
+        assert(ac->name);
+        assert(ac->ops->cpu_thread_routine);
+
+        if (ac->ops->thread_precreate) {
+            ac->ops->thread_precreate(cpu);
+        }
+
+        snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/%s",
+                 cpu->cpu_index, ac->name);
+        qemu_thread_create(cpu->thread, thread_name,
+                           ac->ops->cpu_thread_routine,
+                           cpu, QEMU_THREAD_JOINABLE);
     }
 }
 
diff --git a/system/cpus.c b/system/cpus.c
index 6055f7c1c5f..c2ad640980c 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -671,7 +671,7 @@ void cpu_remove_sync(CPUState *cpu)
 void cpus_register_accel(const AccelOpsClass *ops)
 {
     assert(ops != NULL);
-    assert(ops->create_vcpu_thread != NULL); /* mandatory */
+    assert(ops->create_vcpu_thread || ops->cpu_thread_routine);
     cpus_accel = ops;
 }
 
-- 
2.49.0


