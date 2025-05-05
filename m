Return-Path: <kvm+bounces-45533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A39AAB5C5
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E97B94E5152
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABBD4A6538;
	Tue,  6 May 2025 00:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Th28+57p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BAF3B0A26
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487231; cv=none; b=JUEwJdyIXN6D5m4PtJgct2t3nczrIHO8LJ95rjjrlzee3Kv317BjONDlyW3SsJ+MgqJsd8ur2W+1sHW//CWhJIIFtn21JTCGNvNrMV0w0zV3LZ6vUh6yQNwxyAYgjfXDOPQRX8NjL1QPMro/rfm0wj1q5a61xxlO9s+eXlpHrf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487231; c=relaxed/simple;
	bh=BNFujmsKrmM2bZBmRA8jtPvMWhPu772BZRFsylHF7nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDot4W9mW/hOPAkZFvfDMVdZJP56S49pQGwhKILGV0g52KMBhkX1E2p1S5phtKus32gH+dw3hSIFTsXEU+qhNn9vLwVrMeaRMhAuYbDzXcPj5BxhvmZ5wzydXIDkA8YwL2IDC3oRdwyiWA4v9Cwc9p918ljpJwYw15rzNqVTBIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Th28+57p; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-227c7e57da2so45974075ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487229; x=1747092029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+98FJCPUkZxLytRMJNRmc7jhTB2VJSy0tbuhiYCP08=;
        b=Th28+57p4wKrMzdObBtW5ssrBBkqf1txCw+8qsly7DEwu9IuyV09H0BWZ2Zx0dFcK0
         w3yNV2d7nVvw50cCzoNdlbJWXLslfSAOW5q3XbYBXF+7TQUtjgI9hBG7EFAn6jBbgoN5
         Mtgzzl27yRwce5rS8NUfZy37CzSzR1XFgInac4DAIPHUcIh+WtnZlc98EoqNYhlaWOmc
         TBXylBwBnlKGb3voWubAYxV8Gjvfjjc+z2h5NVzp4uYwCme+nUA0zMpfFuUSCn+PX4wW
         /ysFn34UMJ2hBZL5zr2AaoBXOt4x4mxyznPGAwq/Snx0LIDz8Z25/qELHzCT8mxdUwjy
         bAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487229; x=1747092029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+98FJCPUkZxLytRMJNRmc7jhTB2VJSy0tbuhiYCP08=;
        b=jHKhbMo1t5KQnQ36aiuwJ1u2efCRI8hf+o3B4ktSfR/PkcieInQ3/yYSqZIkQuxM/W
         kH+V0erYyb0Kz8AtBRF2OciINiLefTtc9s3TOYnQfDvra8egDnns5On+k2+ScbzIe3zp
         cyNd3t/EgQm849J5uHmfgIHkYj3LYvWFOUUeO/bsW7q746C4cYxCW9xWECScEKlsQM4e
         vSjbp+Vjrh/eB6oQeakETnnI9i9DFc3rnrk8G5Ax+9YTy5hYQnV2HbwoA1dbUQ6qc8sz
         c8Df2Sh3VNPuwcwuC2p8AbXUT0lBYUCXOZ48ZCOWswWCUmSr6UUsY6QsrN/7dRbx+3Ly
         I1Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVY1rlOZ5Fyz3mHqKPNAdR6E9r0Teu0tlAW293vLSI5S6qPAFEyFOnXAfzjNVh09W1FELU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSwZPPR9DAFb2eEmt/UHjfzIKGIng/UEFMsP+dPWhINOVqIGCw
	OZBDHBkJA+i3PpS1L3cmzAGrS6cBAG5fFOtux9ouGmYfcAWg1Vuqucm/daaBg5c=
X-Gm-Gg: ASbGncvnz9mUJGbz6RLwxmQgLcIrmKPHEObww0X242PYCl/mgbx6y1kdOtu6YSz5LI1
	4v3Bq6jkWq/KCrgbuHPnUuxtChvpSrJH8nH75rfrqhqT0n0VeBw6XLwMjjkL3cboQP9o7W1JO/y
	uCrOGJtbWlJ0xT3Dr7wYChkYLTitvlSlqRyTnEgor/lwGtoP8P4gCwvCM6vALfvn8v+Bvvz04k2
	rx7ZC9Q416IE3MlJ0m1h8eTsnWbwiVRtHWsmDlxb4yOFdMPAdpIk+LIaWapQjcewHg6SmbO5PBn
	nQhVTYVv3JYU5RUoIGaLRH7whezN8PgI7y+MZYwV
X-Google-Smtp-Source: AGHT+IGafCDnzbl4XsOgKn16x55qDqZR3cRsQY1YC271VQ2ahGmfB+GhbWbfsVVZQQMU78koO3U2SA==
X-Received: by 2002:a17:902:ea0b:b0:216:6283:5a8c with SMTP id d9443c01a7336-22e32f08e17mr13948765ad.39.1746487229414;
        Mon, 05 May 2025 16:20:29 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:29 -0700 (PDT)
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
Subject: [PATCH v6 10/50] target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state common
Date: Mon,  5 May 2025 16:19:35 -0700
Message-ID: <20250505232015.130990-11-pierrick.bouvier@linaro.org>
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

Call is guarded by is_a64(env), so it's safe to expose without needing
to assert anything.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 37b11e8866f..00ae2778058 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1183,8 +1183,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 #endif
 }
 
-#ifdef TARGET_AARCH64
-
 static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1342,15 +1340,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
-#else
-
-static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
-{
-    g_assert_not_reached();
-}
-
-#endif
-
 static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-- 
2.47.2


