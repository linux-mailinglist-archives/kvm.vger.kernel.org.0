Return-Path: <kvm+bounces-51408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47046AF7110
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 561E31C813E3
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D812E3363;
	Thu,  3 Jul 2025 10:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kCoQ0xlt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BC52E3B01
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540172; cv=none; b=ON5MTwC2qoJqvwyyQ8fwoq169zBKMW7kSVS0VULFcgOFocq0YMuRSYGSemxJaugs51ws9D+wVgPc5uXYNwCdHsH+VDLCPzn/OXB4iwWGNAk18n8pbeBYreN+VYeWly9KbisfibZ3hd1+gRhBD8rW7r9KdyeP4XitUr87W8AaVN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540172; c=relaxed/simple;
	bh=WsZ/VTSAhiCM3qnn34wBdOha0ROZhb+9/6Sn/nyteSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVolV6+IBpuY5vUIyqPNhs4eh5TQ7ooYbzCpjfk5u1k3MYE1ERs3D3TcBpM8wz6ihYnMVb2Ukc3h1RRU8I5fUV1n4XMoVFA34GYrc9dzUOfH5SrX7hNDKfsuVS/v1hdxzeGopsfujcjpgHpTKzosmLGYc93kbDIGBlgyDPSU1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kCoQ0xlt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-451d6ade159so39204305e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540169; x=1752144969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3xbRlHjkCKfI6F0ZyZVDa30naj6O26Xxb9NXVgkrI2o=;
        b=kCoQ0xltewRRy5WwG/d9NRou4hewcr0HqveqtXz6Rwl98yl+c0+XO3xHl+5/2F+wym
         dyXuYDLBXcM1BQu1P5Sx1KLI+CBXK2JLQchiyo0rGFeAZUXZL2x0RJlBOlBn2CbTLunL
         aHGVrlCEs02cDvjs5tM7LonZHOpUUIqBz8PsOFJZJ1QG1dalNDodv+VWyvxE7rItJzFz
         +ggGvlAklELJg1Tu6L1p1E8IDGc5RlUQ62qiAHhSBL2QuQV+JfmZKqbCMWAYAi2N/i3B
         Wr7Atc4RVH2MPidhX9pkTTfsiJH2/GXeHtfnO9wbs6r2xhdQ23Fm9b5uaAgMA3id3wdC
         rTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540169; x=1752144969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xbRlHjkCKfI6F0ZyZVDa30naj6O26Xxb9NXVgkrI2o=;
        b=vYbG9y7eRnnZgAG+6h4PwCx7XB/diXFplF75PjiRxEhq+16SthaILcQ4DVG8gMVs+j
         jNpByRGS1gLRGfs0V14Qzg4wHdFZMTFiru+zddz0bIZKHvCbZA5VhdNNk9kpnGAvYzzf
         b2Wul7hy643HuQsaqn2B8HFsbsilGXoC78XDbWwMUbUlbQ8lo4dblRco15D02HEDfSii
         1LvzxIXUKueD3nD1vGzK8W23gxFDQniRluA4Wv1IeAhjgVMykAH6kw6FKhg5WZmK15UE
         BAE2xuWl4iaKweOqX33XPDosASMIEGB2OUfri7lCUtRp07cwKBQTP57eQ/dsXE72k+UG
         KXBg==
X-Forwarded-Encrypted: i=1; AJvYcCWUXaljd4+i7+/zKGwJd5z6YajhQ5jVnyYJOK3IILJcm7Tjxe5exizyliasGbJ9Y6ax9fg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWqDFsY4OELokBDT9xp0yVOtxOEh1JwNudDY/KOv1U/qkE+PIW
	t31z0yUXCEmGGhLpoHL95BLClSn11AIa2RBTjDh9KREd8aoDqWy+GtevirXL0VphgWQ=
X-Gm-Gg: ASbGncvVhRb0tv76EiP1iGOyLsBpSUB83y4Z88Jfcq/33L5tNtMmAFI7wxPLgmPKgSO
	ZK1LJUUe3Ji2Vsy9J3XvmngzyaWQ0RnDP+DPWcX17mkL6Yjr9Dhaf7ph+I5k7s2Elsngp8JW4L0
	vzX878tKw/h/t6jP+xNDIOOydeL9zR8NlFATZMLibDqEg93wU4Otd9P/ACTdDLto2BOtol7DbXx
	PTN9fwt63tpQFLD3wyFJsoOnR+Du2uAmjfsVhVG4N3ahoLeqo/PCbYBnkyGrFZwanu2lZD8kpm/
	rYI54yT4QgsmEA6U1NmFIQu1Db87MkBt2tSSa9gyqomyK8NwNHMkDyPvTodKuYgrvTLx9hGZg/H
	oym4zy3UHh7Z2dVlU4UWYrA==
X-Google-Smtp-Source: AGHT+IEC8dV01TEPNItTxkxi7fjNpsKqhBhsTECgtqMBuC3s0JlSf27AYqBUKou7E9aEBPF74FuvmQ==
X-Received: by 2002:a05:600c:c085:b0:440:61eb:2ce5 with SMTP id 5b1f17b1804b1-454a370cd01mr59147005e9.17.1751540168438;
        Thu, 03 Jul 2025 03:56:08 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453a85b3016sm60231825e9.0.2025.07.03.03.56.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 05/69] accel: Keep reference to AccelOpsClass in AccelClass
Date: Thu,  3 Jul 2025 12:54:31 +0200
Message-ID: <20250703105540.67664-6-philmd@linaro.org>
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
index 6116644d1c0..37b4b21f882 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -196,8 +196,10 @@ static inline void tcg_remove_all_breakpoints(CPUState *cpu)
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


