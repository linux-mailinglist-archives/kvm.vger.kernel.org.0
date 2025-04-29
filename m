Return-Path: <kvm+bounces-44674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1D0AA0188
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C29103A6C66
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A4B274FC9;
	Tue, 29 Apr 2025 05:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NuccI4gv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1CE2749E2
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902826; cv=none; b=ETkYJuuOElQcVFJu0Vb/c4yWi8btGoSAGlAB9y8kbq8V+tUzC79mpNGcUCOVVHQPcn3OKjamGGpK6YqGS81mG+v0QFi4YfxbHo7xoxNMlYu3weKad2uPs7psU5N86cw1YFze5792AVsLuJDAq/rs9rXNmvpmm/FlwaLeLWUhE68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902826; c=relaxed/simple;
	bh=sRWSdv9s3idaKklu1uKEmIrHgriWsjWEsXVjpaVK7BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klX+gilsDkNqFSOO6dhAJZc3C/DJRztWgeJR0MOgMTNUCbNULQxtdTZ4tdVcL40rG5/eXNxEAa3E5+jCYizzHPbFQikOY5G74JkQA9giDTRWV0GHKg8kwhGwX3CFqaaSgaBEv8LfRYh8vCC7jXbNCnRkoXU6xnPTF3YN3yq++YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NuccI4gv; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2295d78b45cso79681595ad.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902824; x=1746507624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGLga5UEOZhK97fJQViOQTJRGL03WkVBEBC/7bd6T1M=;
        b=NuccI4gvD6hOvGVbjqYq/FCXX0Jf2pnknggjTfcXaObLUopqpvUi+OMy4Vr/lxXQeE
         RdZqDpUc+v7gndHvQ387GpaoOiTE/kfIeKlO5zZ9TP+2EGf/ZYGhpc13UCVYdsypp/vr
         zWC8ivZz/DmDHtUsCNwxwlYZFUv6W4oS/dgltNDLKWfwPSQP80H5IftStihj8eDQe51c
         D0trd7vJoHXc0WpztEEWsUd9+v7Kuej2efFrNli+qcP1AKWhR6gdAE5cX14POCeQGZXw
         B3ACE+mfEehH5f69lDV2ToN2ATXKqlcKVuJtTa9rTpjbJdfazUYUjwlh9CNyDWW4CDzQ
         0Rag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902824; x=1746507624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGLga5UEOZhK97fJQViOQTJRGL03WkVBEBC/7bd6T1M=;
        b=VOy3EVpPkNagl/xjoIp2IeklhWFUy+PiR8aIfyprZ3XeLza5SYx7EF6uFhJ8QHZS47
         FgssW24aSSd3W8LZ1wvGoLDTqNKDu27eZuawNFVXcM8YTit6uCt73TrG5ucjU9nyoYJs
         Fg+oe7+tg61L/TZx3Vyz3fzdWoQXMr1pwn6rL2xM/zlYx1dCDUu/fFga8hL5G3iocKRU
         /YIvyPU1hRB292vBPS4k3EExYLn9hj1FxaaaO9Hje5L4e9yutSwl6pP+FZDyZU/KeStO
         1zc1f6FYlvGdGJ4XdqWp3rcqJfC9UvIUfh1509VX5VYT+ztFQncOQWGv1R+v35qLIFSG
         e77w==
X-Forwarded-Encrypted: i=1; AJvYcCUdnPiOf0SjCaxMa1sZBMVCdW7JqgFJn09x6z55FBg1DoiOZlFc7nNX0pdZJWGG6Aufqnw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyuktm/CItlQQpv29ypi7C7gVox43Z6sglkVepLA+sMjowIdWFH
	zycyH+G79R35iihJvjk0WmZvSPxOP5RV5w4UKDyOGIZ6FGNOa/erIJqhx+YnsfqXTYAkbZ4Brqn
	1
X-Gm-Gg: ASbGncsrMtwpYq1MpD/FsUyWCFLRlYQBuePAVQyDAKKmfjAS3luXITXqK5I6DAB8uJm
	IEMDFAPjikKabufZA1XPO9Nd8CE3FATnTuz3Tv9GJLm5VhtSuvtdOny07Anpdv4aiLEBcgE8mHP
	PYZNe3hjGDz/mSMeRLophz8hpYz8ROjGvTHGjOb9QoLMT6ltaVDA9JoVYYV+KKi8BK/HuZaDNPA
	3D5Kz6o3QUV944mPfXwU/4Fg1WOwAIxDrBl+0KHYZOAauOcbVxGQoYYtdoObdxrEywTOJnFeOEI
	gORIW5m2J6Rl8rQLc4t9O3zCtw12bVVzASRVXtHf
X-Google-Smtp-Source: AGHT+IFyx8N8uA4PzRLCM0NcJk2OWep5SdanjS9wPYwbq+EMM4JH4KwnmPdpBJL4WqQPXBMcgSf+qg==
X-Received: by 2002:a17:902:e5cd:b0:21f:71b4:d2aa with SMTP id d9443c01a7336-22dc69f83d4mr156777235ad.5.1745902824466;
        Mon, 28 Apr 2025 22:00:24 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:23 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 09/13] target/arm/cpu: get endianness from cpu state
Date: Mon, 28 Apr 2025 22:00:06 -0700
Message-ID: <20250429050010.971128-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove TARGET_BIG_ENDIAN dependency.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index e7a15ade8b4..85e886944f6 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -67,6 +67,15 @@ static void arm_cpu_set_pc(CPUState *cs, vaddr value)
     }
 }
 
+static bool arm_cpu_is_big_endian(CPUState *cs)
+{
+    ARMCPU *cpu = ARM_CPU(cs);
+    CPUARMState *env = &cpu->env;
+
+    cpu_synchronize_state(cs);
+    return arm_cpu_data_is_big_endian(env);
+}
+
 static vaddr arm_cpu_get_pc(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1130,15 +1139,6 @@ static void arm_cpu_kvm_set_irq(void *opaque, int irq, int level)
 #endif
 }
 
-static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
-{
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
-
-    cpu_synchronize_state(cs);
-    return arm_cpu_data_is_big_endian(env);
-}
-
 #ifdef CONFIG_TCG
 bool arm_cpu_exec_halt(CPUState *cs)
 {
@@ -1203,7 +1203,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 
     info->endian = BFD_ENDIAN_LITTLE;
     if (bswap_code(sctlr_b)) {
-        info->endian = TARGET_BIG_ENDIAN ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
+        info->endian = arm_cpu_is_big_endian(cpu) ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
     }
     info->flags &= ~INSN_ARM_BE32;
 #ifndef CONFIG_USER_ONLY
@@ -2681,7 +2681,7 @@ static const struct SysemuCPUOps arm_sysemu_ops = {
     .asidx_from_attrs = arm_asidx_from_attrs,
     .write_elf32_note = arm_cpu_write_elf32_note,
     .write_elf64_note = arm_cpu_write_elf64_note,
-    .virtio_is_big_endian = arm_cpu_virtio_is_big_endian,
+    .virtio_is_big_endian = arm_cpu_is_big_endian,
     .legacy_vmsd = &vmstate_arm_cpu,
 };
 #endif
-- 
2.47.2


