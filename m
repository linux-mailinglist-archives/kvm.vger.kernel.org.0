Return-Path: <kvm+bounces-50325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 166E9AE3FF8
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA6F7189AD43
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81623248895;
	Mon, 23 Jun 2025 12:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HGBjd6bx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3828238C16
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681202; cv=none; b=K2UopqoyxN/8FEQSnm3xqBJNX3FVffZwLlw7b30pjpys7l+cDCaKO544Jz9LoK5PztanT094whIY5dg2095LHB37dT0olj0PqVTzkOBv5SN09VwFkJjEVj2y1G9ZnIXFkznfY50F69aJlcSWbDzospFQ58UZ5y47l2gj5FP/01U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681202; c=relaxed/simple;
	bh=yyqnUEjDD9oZh/wgQPdGXi51drE5gp9Y0ysKeHS5SgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DSqjyw1W4nrTAbz1UiIEG3HTpjSDm1Unoa3lcPzOcsTU72LR6iUMeYfAWUB7ltiReaOuhJ65IpvcoiMVzfVZ9EfSDq3wLe4JtNwVr+0s5YlviFr/0vemZNUyFpWhBu+GoO68gqUzwJUxFnF4c7Mal49EV4LYse3cGxfwgwkkBr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HGBjd6bx; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-442fda876a6so37083875e9.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681199; x=1751285999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOQFF5IHVggEpZxvhH4Dg2y5NDppFE2+idPk4kXeUTw=;
        b=HGBjd6bx3X1PmCDOaNamWArAVK8qpaxPtEW8Qw9yb+1IRidNW00jHWH2NmBD9KfoIq
         kHsZ3gCHjd08HujvRR1Bxv42WNJ14N8/hsBQ6sf2dpsKafwihVh9AnfWg3e5nceydYP0
         uTepzvqBcL7sTf144RlXtSwaI+afDEltKvScVImpJpvS1Lr1wbyVhbNBKLsm+kQ4LtF+
         eXXUeI27y8mVYcPVPGk/LKKLR350WcG8BTOryxoDzdg4hmzsdltFMwNajFkHsFnI7VGu
         W0G+Wor3FKld+FpygO4ee8VPo8Hhhv4gKpirr+O2kG6MN6zVoi7yNlnb7z0+ZXZSSqJa
         dkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681199; x=1751285999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOQFF5IHVggEpZxvhH4Dg2y5NDppFE2+idPk4kXeUTw=;
        b=bp9UcuKfuEjam4r8/IOhhV5Z/xl6AAPsaXNFl0jAAZlNKwpW6CDF6u1GRY3FS3uhka
         V0lD9TYHzkRUnBdnq1KLxjFz09LjgvC1G9rjwhWBiauN5PREL+ZOC8Pw96tgvBFcWgIM
         FIBVW+OepmXvTUwYleYaVvWyBecw/ovcssGtreu6MonW2mH5vQuYUcW4u5ucTF23CKNG
         qC7mXyN3Nu8x3NM5/fLgmWxPdMyyAdBteAetBeHhRwgpMIB49UGNaN5SaZkdMGj2yMzs
         KltG0fcqBoHNJ/BFc59l8yXl/q9J18M9w6yKJebFYxBu5d4wBfO8bFvPb7+u09q45IVo
         8kcw==
X-Forwarded-Encrypted: i=1; AJvYcCXTdpuyio+gByMrSCBvzePabIWD+6R7fq73jHWgbfKCTQsIOjF/wZneo/CwkFr6qmmfITQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPYF+3sFv4l0HOXHDzogf6S0ALrNGfKKLEUhkigbUJkx6QtniE
	XwVqMaJQUZqtwvr4GmwVDMK2t0I4IQ0knHWo8lzg9PGdssB4app9Ax3PSjTuHfK4zzQ=
X-Gm-Gg: ASbGnctlx6vTeeRLGyBibAA6YujDmSsqIwdH+qUP21AjddGAJoHfRF0C1rmj7ewcJR8
	9OMPFSpxMxNwdU7MOcYzzeTuU52rAsyeUhEF/0rtt11ZYE9GaljtQxo3lVvrnIDpLajk3KC/suL
	FTOAXd7wD52C4SWkMma7l54EWx7pQAwLLww5QwQFhCZW33iSx1QApBk45LCnOuR1U4vN07AcVf+
	C8boucbGTXWWSJkyi1wAE34wSFL/SGeeQ4TDNCmHJgfYHBqQOkJMlTBvEuezMevFpodJZOhGb+R
	/La0ohMiJMeVjrm9IsildW/WfuZlGfZHpmmfAnlj0h85NXMWAake9MFi3yZWZzDiKs1w8E6F2y/
	xYALfip4Qk9MhU/UwFZSLLFdS644Z8+T0TMjC
X-Google-Smtp-Source: AGHT+IFwQfth961QDPwmcQSOPunexZxZtRH6B1UX0+3skNQVMIAOIVx+CTDwFZCmfuogwrFQqEjVTQ==
X-Received: by 2002:a05:600c:1c28:b0:442:ccf0:41e6 with SMTP id 5b1f17b1804b1-453656c2172mr118658905e9.3.1750681199364;
        Mon, 23 Jun 2025 05:19:59 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e983a4bsm143750295e9.13.2025.06.23.05.19.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:58 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 14/26] accel: Keep reference to AccelOpsClass in AccelClass
Date: Mon, 23 Jun 2025 14:18:33 +0200
Message-ID: <20250623121845.7214-15-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allow dereferencing AccelOpsClass outside of accel/accel-system.c.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/qemu/accel.h       | 3 +++
 include/system/accel-ops.h | 3 ++-
 accel/accel-common.c       | 1 +
 accel/accel-system.c       | 3 ++-
 accel/tcg/tcg-accel-ops.c  | 4 +++-
 5 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index fbd3d897fef..9dea3145429 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -37,6 +37,9 @@ typedef struct AccelClass {
     /*< public >*/
 
     const char *name;
+    /* Cached by accel_init_ops_interfaces() when created */
+    AccelOpsClass *ops;
+
     int (*init_machine)(MachineState *ms);
     bool (*cpu_common_realize)(CPUState *cpu, Error **errp);
     void (*cpu_common_unrealize)(CPUState *cpu);
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 4c99d25aeff..44b37592d02 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -10,6 +10,7 @@
 #ifndef ACCEL_OPS_H
 #define ACCEL_OPS_H
 
+#include "qemu/accel.h"
 #include "exec/vaddr.h"
 #include "qom/object.h"
 
@@ -31,7 +32,7 @@ struct AccelOpsClass {
     /*< public >*/
 
     /* initialization function called when accel is chosen */
-    void (*ops_init)(AccelOpsClass *ops);
+    void (*ops_init)(AccelClass *ac);
 
     bool (*cpus_are_resettable)(void);
     void (*cpu_reset_hold)(CPUState *cpu);
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 4894b98d64a..56d88940f92 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -10,6 +10,7 @@
 #include "qemu/osdep.h"
 #include "qemu/accel.h"
 #include "qemu/target-info.h"
+#include "system/accel-ops.h"
 #include "accel/accel-cpu.h"
 #include "accel-internal.h"
 
diff --git a/accel/accel-system.c b/accel/accel-system.c
index a0f562ae9ff..64bc991b1ce 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -85,8 +85,9 @@ void accel_init_ops_interfaces(AccelClass *ac)
      * non-NULL create_vcpu_thread operation.
      */
     ops = ACCEL_OPS_CLASS(oc);
+    ac->ops = ops;
     if (ops->ops_init) {
-        ops->ops_init(ops);
+        ops->ops_init(ac);
     }
     cpus_register_accel(ops);
 }
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index b24d6a75625..da2e22a7dff 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -198,8 +198,10 @@ static inline void tcg_remove_all_breakpoints(CPUState *cpu)
     cpu_watchpoint_remove_all(cpu, BP_GDB);
 }
 
-static void tcg_accel_ops_init(AccelOpsClass *ops)
+static void tcg_accel_ops_init(AccelClass *ac)
 {
+    AccelOpsClass *ops = ac->ops;
+
     if (qemu_tcg_mttcg_enabled()) {
         ops->create_vcpu_thread = mttcg_start_vcpu_thread;
         ops->kick_vcpu_thread = mttcg_kick_vcpu_thread;
-- 
2.49.0


