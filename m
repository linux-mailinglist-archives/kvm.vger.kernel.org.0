Return-Path: <kvm+bounces-45774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C1C5AAEF6B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CED2E7BDF32
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862CB2918D9;
	Wed,  7 May 2025 23:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xvi9+9oV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42061291898
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661372; cv=none; b=KV+paX10DpB/M0sCrsX/ISxCL9enOgMkwvQmZlXZdXYp4T6keCgg7MZZ16co4S11betJF6uxIAduCs+B8J0DaipwPTQaDCeqZNVb8e6f0I8HAsm4GEH93zO+ghkMQqkXggIvQ0LKy/i0xDbWUf+yEys2Mr+BViHgDHFYcNt1SMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661372; c=relaxed/simple;
	bh=4NYCYp+xf2PMVcYpepsrSbNYaV6+ss95GuggBiUIxVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oB6YIXdmn8cspUDoc6N/567UIgEGiNAYUuQLwcZw1MBm+eRsKP8L+DzKkwBRYx5gOmRipRS0xvyWzqjoej/KfvZw64cGnmsg12wrZcxVKGnGSevmdfiB2Wv4sIzooeiz3e6C/l5M1wdE61FTlQCcVsTcsIOHmbEjGN+4YBG6i+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xvi9+9oV; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3081f72c271so473859a91.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661370; x=1747266170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgtD9a+F/fV1o8g6sPaSIZoYXGKqR0qNW17PKpxFW74=;
        b=Xvi9+9oVZvhwXURnE0Wf7IIFiy31B8N166dzA32JJQJWa+mrSqulTcOjF9MJcdHoF5
         02ohTRBo4fSFTHD+Biy+Dpt6w1vurRitIdPV0dKZ0XJw/RUqmcbi+xWhMVnO1IM6YIlr
         emfcCMIy+kv4Bx5u86DjyRj88RSO1YT7XBacaXFYUgY8EHaNDlgIxt6ObiRw4VyG+58D
         5tm5754oXwI83Tx+55pskesy2F+A1eDNhKTWXxVBZYSl2gefJ7avnWbGt8Pmp07XNZEk
         T5sEP/Y9u5I40ur8sZPzK3GbX/gTaRfnXp2V7Qmh2d+M0X0Fi+1vHTCgeL/fqHyz4PzT
         oh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661370; x=1747266170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgtD9a+F/fV1o8g6sPaSIZoYXGKqR0qNW17PKpxFW74=;
        b=U5Xmdc4dmd/87mcayjfzfnnr+XtSVKFfwKwA/scZ5vHIB+ka9V+P9ojgVmmLMCh2Aq
         orWFSXOzl9lUhNtYiZxKEDlp+xHfcDHz/iPi2PkDPdMPosgudaJloBXVITI+gihjFdN4
         nanMJFXvPWNh+3bp0N3ozsjtyxliKjby5Pj9ubRuQeHK8LjmQciqOJggIt9Q3bfJ94v9
         A3c1PK90Pwi1wdliOhkFEiZZo9H4+d01tfbqI17yB3IW0U1x1AsfovIoMIf6kc+Z3McT
         ueROVj3kDkC/T5NjC5/x0NVNtR32alEV0VyD+J1DRTZ4PYX1YtYZwXna5qP6pD9AJwFG
         b3+g==
X-Forwarded-Encrypted: i=1; AJvYcCWBX1rtTtexEZ9PCjVyYZwhDV9skTTySek3RzFhNmKyRcUlwqeV9puXkOk68fHhRy0W//I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4hgkfh1brJM/jgF3H3pzgf8y4KyUgQWGpus2p9s0Tuu8bOWq6
	rQBVp6ryfeb423oLhXTmA9BaLPukHlZn/SY0nBuLItvbuKOuxuwnz/Oy4bWdHG4=
X-Gm-Gg: ASbGncvnVbLzasCJWnZt9YOUyYZ3peU/7wB59iLKrRuoc/j4iXAjysfWgAu913CoS5h
	xuY918Y0VIVVsskHImj4l4wOzjBQQM1ZReiiyZt5lH4EWHr+IdoZJ/BMibE9JRgSsB5PSKbdn83
	JFy2d6vS82dxbIg4ooeRZVd9cgE9Qk6R532S5qSGYt8JOeSO/Kom7DKmROVxfnME/BziFU2Hy0w
	+BjaPn1kQlLLU4G4UXnCXDMEEhkI04qt7fxFGBDSxCeJzT8jp4+GWEM7OKMzCDUYQ//hx1jupbL
	yLeEjqChvvQCNcMN4PMU0p9GkC0gSMdocXOzMco7
X-Google-Smtp-Source: AGHT+IFpfXF464QoGLu/+GuZuBU0TJX3a3vlbSAcU4c68XYKCA5Jxjh3FLDVc+LLIUs1T7RyGLYtfw==
X-Received: by 2002:a17:90b:5105:b0:301:1bce:c26f with SMTP id 98e67ed59e1d1-30aac183ba0mr7012520a91.3.1746661370425;
        Wed, 07 May 2025 16:42:50 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:50 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 08/49] target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
Date: Wed,  7 May 2025 16:41:59 -0700
Message-ID: <20250507234241.957746-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Anton Johansson <anjo@rev.ng>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index d062829ec14..b0eb02c88ba 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -23,6 +23,7 @@
 #include "qemu/timer.h"
 #include "qemu/log.h"
 #include "exec/page-vary.h"
+#include "exec/tswap.h"
 #include "target/arm/idau.h"
 #include "qemu/module.h"
 #include "qapi/error.h"
@@ -1171,7 +1172,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 
     info->endian = BFD_ENDIAN_LITTLE;
     if (bswap_code(sctlr_b)) {
-        info->endian = TARGET_BIG_ENDIAN ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
+        info->endian = target_big_endian() ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
     }
     info->flags &= ~INSN_ARM_BE32;
 #ifndef CONFIG_USER_ONLY
-- 
2.47.2


