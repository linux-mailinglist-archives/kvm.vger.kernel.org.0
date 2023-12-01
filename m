Return-Path: <kvm+bounces-3127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96201800D2C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6B911C20968
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7F43D992;
	Fri,  1 Dec 2023 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DbDilatH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1B410F3
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 06:32:16 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-50bccc2e3efso2826897e87.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 06:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701441134; x=1702045934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzQsYOZx1lby/03o6yhLAnKTrunXv93oPFAjodmUZ7Q=;
        b=DbDilatHQBQcO1yJhbm354RNR5X9Y87QGZF4YZXStJ5M8CApPHf7qdIt96UO2QdcNK
         +8jOpWLIge2Zqhyr6kFALbM22SJwBEDXCD1+fZqPGH0jqPrUhr+SWkcKXqhAIwT/LiYq
         dWO7JQJyicRB+Drl9GMLaEADM4qtZCtYpuvu3hR7yXgTc+fF2pDPI4yZvpTZAtHzkFEZ
         dg2MrMus7Qe30k6EvpeHNjM96Z3C5VdPwxVNld075skzBb+T3zJkYBPksMhC0NBt0N3b
         Jm1tuNkRTwOQnVBNQYOznECfAjUO+Xm81QgG5iOE7yFtdhfMy0Jva3tUixhnXWUwauMv
         8BWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701441134; x=1702045934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lzQsYOZx1lby/03o6yhLAnKTrunXv93oPFAjodmUZ7Q=;
        b=XtttBxr2hVKFJ6oIH5U2yf0vyC9+eHcnJp/niOE8lR290vVv/2Me5/SbtyLAW+OMPe
         l1qTEzzx6Mq7guO+Id7PaIM/lXk8aklIeb9BOnz+esp5MNkWA1aHtEzeOfSF4PkxwpIc
         ODfcV2Fr2bVdOlyZPCee0cYbNlcBGRykJ5zBbWHWSAKNavz0Xjcn/0SkCrYsjr03JO8S
         q7mRF+hen5cqrBo/xY5jjjJuPkxEqvnqQIoOKQoEtvWxRjzo9qiboVhHLC7LW34Jv32n
         NFgROMduTk6PmiJ0fmwhpD1Mz6HoSpbes5+niElhHYin76dH28qLSmgKaLnXEwdod5wG
         Gu1Q==
X-Gm-Message-State: AOJu0Yx5OrsTKiDgYfp/f+D5EGtAsZBsUh5jtmwr/I86XwAnhTcBlLsl
	/GETfM7ZHPhqQ5pVm5bebSVvFg==
X-Google-Smtp-Source: AGHT+IGxNtCUIXiaeul22hFkOioPcdXpn+nN/fti0ygrW7t/+DOLxnpEWtcg8NiaYZKBjrk5iX+fQg==
X-Received: by 2002:a05:6512:1598:b0:50b:d763:fe35 with SMTP id bp24-20020a056512159800b0050bd763fe35mr1096852lfb.80.1701441134581;
        Fri, 01 Dec 2023 06:32:14 -0800 (PST)
Received: from m1x-phil.lan ([176.176.160.225])
        by smtp.gmail.com with ESMTPSA id d9-20020a056000114900b00332e8dd713fsm4350612wrx.74.2023.12.01.06.32.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 Dec 2023 06:32:14 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 2/2] target/arm/kvm: Use generic kvm_supports_guest_debug()
Date: Fri,  1 Dec 2023 15:32:01 +0100
Message-ID: <20231201143201.40182-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231201143201.40182-1-philmd@linaro.org>
References: <20231201143201.40182-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Do not open-code the generic kvm_supports_guest_debug().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/kvm64.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 3c175c93a7..031d20ad92 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -32,13 +32,8 @@
 #include "hw/acpi/acpi.h"
 #include "hw/acpi/ghes.h"
 
-static bool have_guest_debug;
-
 void kvm_arm_init_debug(KVMState *s)
 {
-    have_guest_debug = kvm_check_extension(s,
-                                           KVM_CAP_SET_GUEST_DEBUG);
-
     max_hw_wps = kvm_check_extension(s, KVM_CAP_GUEST_DEBUG_HW_WPS);
     hw_watchpoints = g_array_sized_new(true, true,
                                        sizeof(HWWatchpoint), max_hw_wps);
@@ -1141,7 +1136,7 @@ static const uint32_t brk_insn = 0xd4200000;
 
 int kvm_arch_insert_sw_breakpoint(CPUState *cs, struct kvm_sw_breakpoint *bp)
 {
-    if (have_guest_debug) {
+    if (kvm_supports_guest_debug()) {
         if (cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&bp->saved_insn, 4, 0) ||
             cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&brk_insn, 4, 1)) {
             return -EINVAL;
@@ -1157,7 +1152,7 @@ int kvm_arch_remove_sw_breakpoint(CPUState *cs, struct kvm_sw_breakpoint *bp)
 {
     static uint32_t brk;
 
-    if (have_guest_debug) {
+    if (kvm_supports_guest_debug()) {
         if (cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&brk, 4, 0) ||
             brk != brk_insn ||
             cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&bp->saved_insn, 4, 1)) {
-- 
2.41.0


