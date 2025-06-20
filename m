Return-Path: <kvm+bounces-50081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26004AE1B8D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4278D7AB961
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F56B293B73;
	Fri, 20 Jun 2025 13:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F0+Jmp19"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34B929290F
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424914; cv=none; b=QQ2ZxkevADflJCP5sVlPYMrf2FDZH5aru03mwi0HiCbonNi5FEkwLEOhd9Uvnc2zEo/1BTvDmPNu92eFcL7/4BYclcRICa8GSPFpRH4mq11z32UAx08kx2nj+oZj7z7gG69+MHihTz6yHFlfVkAwj8Mk+FYsHIQheVUbjS5u/40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424914; c=relaxed/simple;
	bh=yyqnUEjDD9oZh/wgQPdGXi51drE5gp9Y0ysKeHS5SgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QJWfq1Z1Jz6uYO51TANbht2SyO3dQVEw9qh2VTy+ryaUBRF/hJ0fj7//aHWpOFYcncrSZvnVBOVSvZVtfJdlXxB7gLL/ymqk71dGEPuLcj/Gtad+17qtNKv4UIg6A6zjRu7EkRfg6aFOXhPQXN4ThOUog1SUwNC3+X6yUjjcQ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F0+Jmp19; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-450cf0120cdso15036985e9.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424911; x=1751029711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOQFF5IHVggEpZxvhH4Dg2y5NDppFE2+idPk4kXeUTw=;
        b=F0+Jmp19xqHNt6JMVGXNYOC9lR/xsQQcfozA7HsEhBU+gDnj6qAxhD8BQ0Nq8iXAPV
         vwChXdAkqnu4gKnmkgCDvckxHtfZvaIvOIxzSsNKfc0DbNG7F8yDbL8oGoc6cTGT+NeK
         K86DQqWlG6KyExjGSv9gIlXZqaQaYSD0gxNcabBlluD2d6rU3Oo3LmkUjRhifINaZX83
         PMLkCwaU8D+VQihUXnrYsfCDsINXSHDE601DQYvhe+ai0KDqkrkVuCQfAbbL3xtLF3gS
         R3B1v39YkhQRPuKfKVm+mDu7YdyCcXEkjDPUWHCNwaH6rD1opm/mO/fYtr6sndX8uoVn
         AWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424911; x=1751029711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOQFF5IHVggEpZxvhH4Dg2y5NDppFE2+idPk4kXeUTw=;
        b=Xx0h7HxQu54BL5sokxE4co6kOr3ARc0P+5n8yIwCdCkfVKZsxLBYBleXokOoCJYoIV
         dhpdAQC+pNnZafkFlpi33a2ffSaX1XEGLUz160g2tVMpMwtrhHvh3RwRwMOIEsG6IVwX
         FzvvFtkrDJCO87ZuDW8d5OYXkt3o0P5aJp0LO9VHwohhA+5fTsCznzwJuqiSiV5rHcyu
         U/xt0BFq6qs/vuzrBp0Y3+FbfdWbXYVVaGsy29iHkfdCOoaIC0qZfj0urhJZ967GpDP1
         yIiCURwSciX3m9IZMeWLTpH6KHvgk7h5KRPfYk1Igkw4Q6b9Wuirn8M4YgPspk0uVUIE
         p9Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUBZMBOzRA+ygtOZR95lkoW6QT0MTXLz6CpMpEhpgIb9X0FOXlwWakFF2boduuXv51q+tw=@vger.kernel.org
X-Gm-Message-State: AOJu0YykGXo+arfyxfwUimAeXpnChGlA8KMSoObLXtHs1x0CbL+hnvBk
	HFipYQVpfkR34kgNZN7sJn/6KseIM1wduMCHUcxaVVhQYPmtGhPPYXZak0XB0U2xNoc=
X-Gm-Gg: ASbGncvhD0AS3rjXPbBWFip4uGfij260Bg3ljXWxP1iV2pc68F97Vo5ylieIMyeRbNN
	KzRbwpA9dhTa/CiwHkUBdVBG5FWzEZVWz9gPbqoliKbM2U5u5LMVJ1OUH7X8T+TV+OLX58BPxRH
	Y4ynLJK00dwPEC+4CyhjI/CnOjextZwoDxxlze7NGZ3GYtXShM0pYR70yn3M3hm1kDFHLooQk4f
	Dy/V2EOQSKAvMWT5dkE/vsoN1Wyg46xtj0FWrIQu4CmNi6GljGei0eHtTLnQwzmnFyymGV5u3BS
	Au9fPelqiTxOBZBNuLDoURg/Vda31cl4bP9YE87aEbwR2IfJoRk/pAJFwJlab8JP8ETxBcEMxFl
	soqJhb7RmESOOEZhj0Lb+CsZgN3DeEToomaeG
X-Google-Smtp-Source: AGHT+IG5VJ2wmm6aaoN33zTA0rvHD7SHc9CVgH1xuOcv58TCSdw7oIYTR3igTV8EZ3sVBVJ+FyYcCw==
X-Received: by 2002:a05:6000:98f:b0:3a5:24a9:a5d3 with SMTP id ffacd0b85a97d-3a6d12a41ebmr2293268f8f.17.1750424911290;
        Fri, 20 Jun 2025 06:08:31 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d117c0f1sm2083859f8f.53.2025.06.20.06.08.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:30 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 14/26] accel: Keep reference to AccelOpsClass in AccelClass
Date: Fri, 20 Jun 2025 15:06:57 +0200
Message-ID: <20250620130709.31073-15-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
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


