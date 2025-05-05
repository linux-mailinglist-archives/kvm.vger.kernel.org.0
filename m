Return-Path: <kvm+bounces-45356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FDEAA8AB7
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 514A03A62D2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D4C1991CF;
	Mon,  5 May 2025 01:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MizdxLCM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2221A83F4
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409958; cv=none; b=G8aCN/p/u/CnpBw+ryx0mlZ7XB70Q/JQPIP1Na+JUglWueXTpV1XE8b5vUmmQD1CIMnm6HK2R+9bsZ/b8R/pqNCjxiRt0A2tGY8oTNXrHeoYsPbUwCGclDMtCTfNVzkUiP+Z3Auuu7PWNCT5wPKdOIJxNNAed+aB9B9KuM08Vs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409958; c=relaxed/simple;
	bh=5dU8sJ1mvPjlcT7KWlYDwmydA4O5OvIDqk1Hw4oaHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDrHZPZkXyIBXl8/lmHHrM8KJAE8vnQ60IhpSCRi87wall3mtIFX4F2058Ox8iUFWoUBCfwIBX1Z/HSuxl95Ulzp+MGsP2DhL0xiO4wUDCPfrl/UTIHlUqJLYriDUQyHe7nQUkDA/SkBmnmfx+eakuhvLxalES8FHi6t2qiLV90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MizdxLCM; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-73712952e1cso3714234b3a.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409956; x=1747014756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuLpPX6X06+NE7HHzhZQmUoQgosCpwXTe/wCgu+rNqA=;
        b=MizdxLCMpUT0JYtyTHGVkO0m1d3y7iKx9u6USBtxgLo/8DgIz7d7SXMd7ds1LGVJZ5
         FG6yeW49MGJcPOX8qX97xou9dPsYqAHoIx6NhI6jJYHaTHOB3SH178RMma7CeRrTKc9J
         oRioeXQJEk+LKhHjZzx5c1Mq49FEZY8CUl5snFXVasUmnHZqCqFsWh8pelHWs1Sjoqwe
         tk8riUeBO0HoUdJ4ZTUZ4TqnW+7zVGKnOGhTJ/V3VrsjfHaCke8eSv4W4b1btWLGHTAq
         /yVKqIQyeqg9qr/Dv77Ul3cRJbXRCggWORbB7gAO0P4k/g6HmgqmSNZ9h5U4E0H1jmDq
         IHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409956; x=1747014756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LuLpPX6X06+NE7HHzhZQmUoQgosCpwXTe/wCgu+rNqA=;
        b=h3Glzl+wU71T2GaVC7Dn3hmiMfj2LPfi2TU0uv3C9ZlJCWGLyE4FDLyxiwlZFz7oaC
         vl/ZgCev/NQCFtvDsfEPwRHNjkY2YqoBvFzhGi+BwvKKnJPYIgrPZaAyrRTFWooEPMN/
         jpm/g0Bp0nZShvNFd2jDmtuRXoDA5C6Wcp0BGUrm57G2MDt/r1CK6WUSygITh6uz9G0d
         h3fgaZbrR05+g+fU9bNJZrdo9evpO66Rg81KGVDct3rN+SuNcArUlYXuJs+wCTcroaWC
         MuE+5adI8Bmg/SziEiCLqYaF9tu3trZTxN7Kh9Hze886C9roF10lrXIAFIKAkWkste/s
         r+qw==
X-Forwarded-Encrypted: i=1; AJvYcCXXBla5jZcBFIiUUxURfHsvQBOYJXDhnZQhP4bDfJ/h9g3mBdzTVluH0OWMTAkYewQv098=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHq14G5GSClE2ZclloQHSyBT4ETyFjE4Uy/Mj9Pbjhd2M9tadj
	MqWJ0wIOFzdaOezLl9/fPeI8wO66S9SniNzWO9iAFhjc2Jzo9v5nrPu4IL53NCI=
X-Gm-Gg: ASbGncukaC8t+U/8BJzWYQQr8hLMTIaViRsQ9K5NM9RTRDS0fvZLVMEMei90/yVSqYl
	WBXKeUrlMMjpq7Bc8Abj4Sy4kb6A14PCw05ho7w4UwrpA3usDbT+CpI3FhquieKeylYvVZ6yZ0F
	X/P+3n7LbCGBTW/GbICmWNT9jgOtPZ0bph+fN8nHas90Vw0qM07WjWuy8P2fSe0pZvzZGojETvG
	g47GgmqalBSShzhLJs0WjqUcCs+Xhsf8GD2W6udQjmPa426SivyF00pCycP5bCYMt47SD/By/qx
	iJVL2FJYS9RcI2RoiR5EFvV5t8y5bsQNyKPXFv+u
X-Google-Smtp-Source: AGHT+IHzGUohRUeOSCShyTBQEz3+cx/ASVTiK/6WfrdnkCq5fA8tyIn6zcD32STw5IjqBUMIm5B39Q==
X-Received: by 2002:a05:6a20:d503:b0:1f3:41d5:65f6 with SMTP id adf61e73a8af0-20e979c90f7mr9100293637.32.1746409956419;
        Sun, 04 May 2025 18:52:36 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:36 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 09/48] target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
Date: Sun,  4 May 2025 18:51:44 -0700
Message-ID: <20250505015223.3895275-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


