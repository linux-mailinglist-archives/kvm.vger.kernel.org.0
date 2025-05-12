Return-Path: <kvm+bounces-46208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2225AB4212
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EB1C1B608DE
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3990B2BDC01;
	Mon, 12 May 2025 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ex1meVaw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28862BD5B1
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073120; cv=none; b=AvpCiQGcrwNONQ0hXPYyTjqI3HL+zJtTvQlgzP4YWM1OOtBN8CE+2fmTtF4UNWszRgsecy9fmckqnHFA3d7rVQKniAd1iMpnrcUHEbM4R5lwQ8+6sbHSbCABbw7QYRGCEGqeLKG63s0qGOT0ARfRhrhXbmcW279LTW0xJ1V+6+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073120; c=relaxed/simple;
	bh=4NYCYp+xf2PMVcYpepsrSbNYaV6+ss95GuggBiUIxVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ltorlnr8RDxMKQNIF3w13khDsQwYmiRw7/4vwo3ZmMGcnmTErsG8gIjOK4bcuqNfp+B5ceftPAXYFN4e6i9WBWoVoUGQVV1FWKnlrG/o0tBBNJNN1oIeOv1ABkHwt2Y5n4PsqeJdkK0qu3bxbzBnDwFIKq4//yhFQsTf8pPtK7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ex1meVaw; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22e661313a3so42933465ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073118; x=1747677918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgtD9a+F/fV1o8g6sPaSIZoYXGKqR0qNW17PKpxFW74=;
        b=ex1meVawgseYbEAYI70Ap+HTxD0nNO4Nyar+6PgYygbjtKM9Cb5ZrgGBwUG+8wQ34R
         csy/f4p0Xd9zdCe+WeX4xSM7NeD9IblBV+CRToQ/sV2YKUwdsnjeFYvsA4g4lhGZGw7W
         5PGbjEhkpdt3mnz9xpIk2DU9FgATGYfG0J7BvRg9YMHb2PHTIZ4DUKQCNZfheSFbhgRQ
         3CwhFaX+zxQlO2FKLv447Ss8Wy9nji70aEFy3t4PwvlGtwpFUuF6u8XgpeSdCTw8xRLs
         2pyKuJpZM/E1R8MhM2TmftUqoH8Kvaly+1a7h9sra+hbNbt2ahIGWoKxnJ9pwkaSaKrS
         E4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073118; x=1747677918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgtD9a+F/fV1o8g6sPaSIZoYXGKqR0qNW17PKpxFW74=;
        b=TNSFhwWOnJ1ys1Qh1oznHslMTVue03uW+k29LqpT1pTo97UentLYBwDc6UNLTBv/21
         WRK3euK8qnB8oaCQvUkm7fI5ebzHTRs/12Ip60ILxrYbK9qofgYWr01HWKUJ714Ol87M
         XuKLF6y4YdtwEK26ouqU5xinKggtwfNuy9uM77Xcl1MQIJfVh2a5RylJclKpHLtuNY5P
         DLXyVs6nsOJI0VoVinnpmpWgyuayyp+yxMPuItqtlMNSu2EqlxH60i00N2z8YBUirKQJ
         mGJP1k4biRxFhdg4xB9P3CbT6uV5vGrFGK1VN5+PUEhVKMiMfVoE5o+7aqPKsHoSvGZb
         ndNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyiI/2jOcFleOOmjtI5RVzMdyzurFchOqoP/KDuPUdaHU+/i31BVkJhDrlzBjUhkWs7sQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjgR7M/e3vHETalFwXuqY/s7iOIwazt3e4AXLwLCG0T3SXgmM1
	BMeNTPkhTRo7b64moRhvLP+WOoAKRnKh5lXITTzS6ZTPAp32yuIysDo0wVED3s4=
X-Gm-Gg: ASbGnct7Krnwl47A1qFib/SK478oKocSm2u2qvgqdedd/cd4Fm24gMTHn0DJCph0yuI
	kkQT5ziqrPD18Bvbf3DW8ZP3qH0nlefBcOavPjmQqa+h21vKGJsZ5ZvcX0uyVfwf6lOaU1Q9dGI
	OTdm0U37XixUA7SYp45Pe9eZKWpQyrJUiU4c9IvEEKlIo8aMnzqyMnmZpyKVwqnFvZ6jPv2bJBs
	LJs9oZ6+bXrCnccUCBnX+OEL+02IjQRA5yHo/82PByIMlycF8x4lyxu4Zz/3zx7FwGEtidU4tiu
	8qTbJvFYpKoTmMcSaNAVkqRDuLJq0ivU9qZS0wP9qc30557i4dU=
X-Google-Smtp-Source: AGHT+IGFDRnIr5Z4IqZt9DDblisny1WwCZnifEmguV1wibcZJg9l4HCbr3eQigE/HjWaaYhhQjCACw==
X-Received: by 2002:a17:902:ce83:b0:22e:7e19:565e with SMTP id d9443c01a7336-22fc8affe99mr158659855ad.3.1747073117982;
        Mon, 12 May 2025 11:05:17 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:17 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 07/48] target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
Date: Mon, 12 May 2025 11:04:21 -0700
Message-ID: <20250512180502.2395029-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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


