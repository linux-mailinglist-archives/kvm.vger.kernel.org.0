Return-Path: <kvm+bounces-45494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB478AAB027
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 053F87BB36C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04EE3E8D9C;
	Mon,  5 May 2025 23:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ILQ4R+t7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFCA28B404
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487232; cv=none; b=o0DH4vTORfK4UU7kkZxLRGR8HHrjQle9CA02e8T9/pyKTyRkr2tofM2lGFqVv3HwP2dDTQZc8yPsTEwu/TTkNaBCmlcY5sjJ1tOiM+ugO8qxX0QJ2s8D5+Its88hid7rEg8p1KJ+I8u2ip6/Vb34tYcaMUJYRMU6k6uBQkLH/tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487232; c=relaxed/simple;
	bh=5dU8sJ1mvPjlcT7KWlYDwmydA4O5OvIDqk1Hw4oaHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZV8wiGdV5eKC+ZfyYCGHSpwcPFSkRp/QMiX/eqbsWUr1rmacJl/GTWG5AYS6whv4QrmmSQNwv1SnKcl/Q/deerVq1Uko8Y4p4k4/WasyqbH8CbFK2WaeT60TLasros91XEnXIega7/vtC+SYFDVklx/P3rf8NVyrVSigVNtCW3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ILQ4R+t7; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22e033a3a07so51990245ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487228; x=1747092028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuLpPX6X06+NE7HHzhZQmUoQgosCpwXTe/wCgu+rNqA=;
        b=ILQ4R+t7Se/aqvaG+PgBkFFUL1r9dugbcenPo5SnIXG/A5Qsa5gHXVoynIWsw5dRWn
         h0WvRItOr9TISQeVPM/PuUEAy/beeycMphzc7HC7Y8dm2Olz7S91+bDYUoltAMZG3tpP
         v4PociKONtqmcWABDc/oMet2X9e8xSz0UBunh4+w30U+q1ebQgMK9sMI3IYxFYLKXUFu
         hlzfxXOYpT74NZzlPE99ZGhs06zTY5FNAuwQCYC9EcxoYvDSDCX4flWNXGZFWJcR6twa
         ms++a0PHSDqRGHqXkJD4kaRicoJKAOqSEAxblggE55I+e9HncpOehq7bUFKOB9vIhOJ5
         AeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487228; x=1747092028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LuLpPX6X06+NE7HHzhZQmUoQgosCpwXTe/wCgu+rNqA=;
        b=f/Kt4qkzD3l8key86ZnHUG5lyG2pKfjY8ELt9R3cvQIhvnnYmViaMbzm8kvjCpocVU
         cCgbF1ML9tEioCglV7Sg0DU8aka8dBWT+i6YfrAu7PqKz/kMOPniXWN873GoUWYd46YG
         0WYkr7vche4wBv10wfEXsTdl1L9a9EqXopa/xZohBZ6Ju0iP47uEFAMl8Ur2dZSyiGnD
         VxOVatMsnOEoHHjAW8GbIoNFF4ghDFtkmiPQZ6hwDbXofSPDRsE+CzeXFLYwPDL45LPY
         kG6is56xHSye7By9C1R/0C6UrmPYSpDxngN2dWc7mcIkyX1RbgeCXbun3YvnjMOT6vDu
         3rUw==
X-Forwarded-Encrypted: i=1; AJvYcCWJNL8jBECMIb2xw1ewtMRe69fJQFAI/9QlTRZU4rAElCAxWen5i8i2PSLB5WBLnfVos0w=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb4lDUcSubwyhZ46IgrN1ah06zyZevZCRqul397/AlNTFaa/gf
	AWpMYEAkkXi7WfYLRAH0NhmaPUDha5/Tzb26l3xyGWRSMZ0emv/DC2UcUHRLO2A=
X-Gm-Gg: ASbGncvA/6L88HdtNjEntEwAwZuB7kHgIDHzUnYQGNu3aVVOvA9bSrBFKdhnmPoTMgw
	f+gqghSyGoqv48GeVDbc2B2m8xmnKMmn2WGipw31JbNMF50rXS+MvnYCqzjMrOr+hESLiYuYM30
	7PBmxdpp8OHXH7ycbXhcGZzLzRqS7MA4Fb5FqyItyzdrYbgONXvM/mH/8bZyKGjokE2vhVFx70P
	9N4EggeayaWGZpOgam+TRq20RzLjtVA73UTohl2PKelhqwoPjXliXgqyuUg2p2wXu26lfYpptrO
	VNd0Uo7fAFTg2/7NhwyzBx2+NAX+8U3wkreEzMoG
X-Google-Smtp-Source: AGHT+IGSY/R02CKSQdqXb3iHAsgo600GkoW68E32m5EK8V2wo1QEuGkpp1ZSH6DODuTARwW1aFA+vg==
X-Received: by 2002:a17:903:2f4c:b0:223:5e76:637a with SMTP id d9443c01a7336-22e3620b14cmr11382035ad.23.1746487228533;
        Mon, 05 May 2025 16:20:28 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:28 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 09/50] target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
Date: Mon,  5 May 2025 16:19:34 -0700
Message-ID: <20250505232015.130990-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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
index 07f279fec8c..37b11e8866f 100644
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
@@ -1172,7 +1173,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 
     info->endian = BFD_ENDIAN_LITTLE;
     if (bswap_code(sctlr_b)) {
-        info->endian = TARGET_BIG_ENDIAN ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
+        info->endian = target_big_endian() ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
     }
     info->flags &= ~INSN_ARM_BE32;
 #ifndef CONFIG_USER_ONLY
-- 
2.47.2


