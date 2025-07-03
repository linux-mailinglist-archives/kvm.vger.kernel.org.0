Return-Path: <kvm+bounces-51423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0494FAF7123
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C37C4E44C5
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430CC2E3B1C;
	Thu,  3 Jul 2025 10:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mpYuYIkD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D75E2E266C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540252; cv=none; b=V64Pi68jynLpLZNrD/BLQ33QBKM2SVecKYC1eX/rBhp30gQ2C3mE0HM8j60DtZQsZkoCNeeOyaREYw0dtkiGLq62vYOC15CM+8feOs20jsqS1dFsxrlGdWr2LgirfssgxEl000K+cxst8GaGWXf95TcZmwFj/SF1cNh78GtP6Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540252; c=relaxed/simple;
	bh=RKS3wSM7SIha0UJdhQ/0+oexE/qY0I2gHhKjyKn1DJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ofFRidBwmLwTZ0X3cB84nO+xW1xIM+GifB3xVHhe1yVVX04zylicw55F6iDYEURjLSX6hVOpVHhAw2klq+RJfLLnIWXOVTFK9tm7NAdKFB2GzWpIvDFrIka07ktKBcpvQQCLf1mA526TU90hNOemdkxRfYXWam5PskXTJNZvLm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mpYuYIkD; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45310223677so38343525e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540249; x=1752145049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFRxRvBg/Kw+lCEJUMnsPGlqNMegEysmKneUwCu7PxI=;
        b=mpYuYIkD8le6T9VPNfsI5Q/7b/O0X9VooVSZyjNAHpFG45USe20N57km/se8hK6let
         EFWcwWIycwk2h0/ggI8y+IovPMW2j1iVM2CrXn0Ca8LA336JWjfUkbCOPs1USfKZpltM
         8FyFWe+UcnVDh8+K4fahgjQu0NjS7/Vq6n0gVpZzJDmHubjoJzTfbMkhCMJUeOG1wVQu
         UhEY3DNiZBVJwEvt+TTXG8ySABaGH4E8bgBHzYk7YlbW7sUgMDAl6gVMgBNL6qB4tTAQ
         7G0P1HS1rL5JcrX5q44UCefDT+8Sue+2yEnF3lyOi9ie4hbqkoLURK+eu29wpggz2Nj2
         wxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540249; x=1752145049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFRxRvBg/Kw+lCEJUMnsPGlqNMegEysmKneUwCu7PxI=;
        b=mKXcz6r/6tgjuk1KeUNkqkPMHHSvDLIpmqgy0yv1AtxhDvSPNmEFWgDYnfTwITioOt
         BAo/PRIK3PUkNyUpS42K++SNgnIjePEA6Zuict1uTMisIqAFSvsy+X3GN4h3ZUXuNpuH
         DjlVAut5K+2rZDaA9JLDv7YAL/TyoZLi4t7MzszzD+VgvH6g1SKiAmIZcOqoQqM74Os2
         zb8D7qIptTIKkz2Devae2ejRdUrzg3UBkBE2XuLxU6f8LPFeClI8PlkgtpP6sAXfRROP
         tetyCfL9MNLv4f+wsFK2RAtjLiV9moApkr9kP1oZYXCZ5xVKa+Zs5E7HJadlOntZpTzr
         7Rbw==
X-Forwarded-Encrypted: i=1; AJvYcCWJqcM24wdF1fQH9cJHzPrB7O7tv6dC00Bk/ZNnLLfc2AqQ/Hi/p3zSfABT/DyKGaXNOOs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHEfVR2LdOlQJKdAV/dIuTU+mwlgfAgx+OnLiI5MqU3dqzZWgS
	Y3jMC0iJaeQj4Xu1C0DLerwyswQXE938PYZ75brWpeQ3MHV7Ik7Ard+3G8AXpVDlmeM=
X-Gm-Gg: ASbGncuCyf68AgaDw8tpltHNUNQGG3X0S6PHwTO8X7lEoxRR8EPqmX6E/vZn6VGN8s6
	bO5chmM+65z2TtufrMIJwlRGVzH3rFSOoNhOsqoaFhZjQuhEmyhpnETZ9s4l2yURd6uDEznI5w4
	BrVgZ1pGIXGnMB9D4t0C05Q2xYCLjgZl/y75qpQBpxwGyjQszUC5BS/UYfML3MKSvb4VhLFcisi
	TJxEG0zP5bK+fCEVETZPbwvl6QfobDfedyfa1ku21+IR8aJ9eGMyEBTUm+ECxlzllPKqVn4vpcV
	5AH23GYY0IB7aA0jeqkoz9pGySDdPJN86GoND+9d1jaowYvKhtGARwdUqQ7mdm2uNBokfHTxuFo
	BM7/ULA1STu0=
X-Google-Smtp-Source: AGHT+IGbW0znf+hbz18B0RsM2MuWbTAgJCt01aIieGYP5RHDzWd9uLU880IDur91SfMRbbEPcg0G+g==
X-Received: by 2002:a05:600c:4f84:b0:450:d37c:9fc8 with SMTP id 5b1f17b1804b1-454a3e1a96amr68969665e9.13.1751540248698;
        Thu, 03 Jul 2025 03:57:28 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bde8c8sm23739305e9.31.2025.07.03.03.57.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:28 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 20/69] accel: Move cpu_common_[un]realize() declarations to AccelOpsClass
Date: Thu,  3 Jul 2025 12:54:46 +0200
Message-ID: <20250703105540.67664-21-philmd@linaro.org>
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

AccelClass is for methods dealing with AccelState.
When dealing with vCPUs, we want AccelOpsClass.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/accel.h       |  2 --
 include/system/accel-ops.h |  2 ++
 accel/accel-common.c       | 10 ++++++----
 accel/tcg/tcg-accel-ops.c  |  3 +++
 accel/tcg/tcg-all.c        |  2 --
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 3c6350d6d63..518c99ab643 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -41,8 +41,6 @@ typedef struct AccelClass {
     AccelOpsClass *ops;
 
     int (*init_machine)(AccelState *as, MachineState *ms);
-    bool (*cpu_common_realize)(CPUState *cpu, Error **errp);
-    void (*cpu_common_unrealize)(CPUState *cpu);
 
     /* system related hooks */
     void (*setup_post)(AccelState *as);
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index d854b84a66a..fb199dc78f0 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -34,6 +34,8 @@ struct AccelOpsClass {
     /* initialization function called when accel is chosen */
     void (*ops_init)(AccelClass *ac);
 
+    bool (*cpu_common_realize)(CPUState *cpu, Error **errp);
+    void (*cpu_common_unrealize)(CPUState *cpu);
     bool (*cpu_target_realize)(CPUState *cpu, Error **errp);
     void (*cpu_reset_hold)(CPUState *cpu);
 
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 1d04610f55e..d1a5f3ca3df 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -102,10 +102,12 @@ bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
     }
 
     /* generic realization */
-    if (acc->cpu_common_realize && !acc->cpu_common_realize(cpu, errp)) {
+    if (acc->ops->cpu_common_realize
+        && !acc->ops->cpu_common_realize(cpu, errp)) {
         return false;
     }
-    if (acc->ops->cpu_target_realize && !acc->ops->cpu_target_realize(cpu, errp)) {
+    if (acc->ops->cpu_target_realize
+        && !acc->ops->cpu_target_realize(cpu, errp)) {
         return false;
     }
 
@@ -118,8 +120,8 @@ void accel_cpu_common_unrealize(CPUState *cpu)
     AccelClass *acc = ACCEL_GET_CLASS(accel);
 
     /* generic unrealization */
-    if (acc->cpu_common_unrealize) {
-        acc->cpu_common_unrealize(cpu);
+    if (acc->ops->cpu_common_unrealize) {
+        acc->ops->cpu_common_unrealize(cpu);
     }
 }
 
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 07b1ec4ea50..95ff451c148 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -46,6 +46,7 @@
 #include "tcg-accel-ops-mttcg.h"
 #include "tcg-accel-ops-rr.h"
 #include "tcg-accel-ops-icount.h"
+#include "internal-common.h"
 
 /* common functionality among all TCG variants */
 
@@ -212,6 +213,8 @@ static void tcg_accel_ops_init(AccelClass *ac)
         }
     }
 
+    ops->cpu_common_realize = tcg_exec_realizefn;
+    ops->cpu_common_unrealize = tcg_exec_unrealizefn;
     ops->cpu_reset_hold = tcg_cpu_reset_hold;
     ops->insert_breakpoint = tcg_insert_breakpoint;
     ops->remove_breakpoint = tcg_remove_breakpoint;
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 93972bc0919..ae83ca0bd10 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -244,8 +244,6 @@ static void tcg_accel_class_init(ObjectClass *oc, const void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "tcg";
     ac->init_machine = tcg_init_machine;
-    ac->cpu_common_realize = tcg_exec_realizefn;
-    ac->cpu_common_unrealize = tcg_exec_unrealizefn;
     ac->allowed = &tcg_allowed;
     ac->supports_guest_debug = tcg_supports_guest_debug;
     ac->gdbstub_supported_sstep_flags = tcg_gdbstub_supported_sstep_flags;
-- 
2.49.0


