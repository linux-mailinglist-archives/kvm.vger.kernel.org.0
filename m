Return-Path: <kvm+bounces-45384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E55C2AA8AE0
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A29D1678AF
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0D81F4CAF;
	Mon,  5 May 2025 01:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GMrVA540"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C28A1F236C
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409984; cv=none; b=qxL4bfzqxoeXr7ZiAsNRK+ehwfLiTamOQVarBvqqjLPruGSwQUbJN34+9GAqoRT0Noa1aI9ErUF4Zkd+wyefXd9ectmdM1q58BgHUt2ot9yKg+LT4Ww6z+FLZDphQ6/YT3weHmS/XwshkEdMpCk1CBpdDYt1Gb8g3y8wqrXJPtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409984; c=relaxed/simple;
	bh=DL8s2PBLHUk7nnU51Iqv6TagZNVpZyAU1f2RZEfhC9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1r8fK6pjXrkr3KuUoJ9Al4EWG/WuAPLZXvJyAIGfaxyJgCU8z+lCNVdlVqSKBTUxBvXfroZfu2N3CbeqkvFHVxd/KwCl90ThtUuxwdflGvWl3wAdthTPY4KPVFHfHokyZcLGh0dxVuUMX8FwfhvxCYwZiyBo8Id0o3cmWgW/7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GMrVA540; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b0b2ce7cc81so3533830a12.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409983; x=1747014783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iyeC1dYqzIyRbq0U6QJpnfGNVlqEyh7oNHL1QwbMptA=;
        b=GMrVA540fzRYymNsPMq1rZAHuA+9u1hqE+m7QnJYhwTs5bVEE1G4qqwpJneS7sX+mj
         cQtoAdj15xFvy93NeTtLcyo57oAXAeW7qJLYmfC+bx/bEu4Lc9zh5qrYxx6SzdT1RDPE
         ZVSDOLlgKNV8X73O9qTJsEgJxpzGmd9PgiRvw+6q8d3uZ6h9LFHJpngoQmCQUzQyExg4
         pmvnfh1RJg4HqlQQDh66ZUwTYLG0C6FcdY5wfonBhWQk/boSFi1179tow0tvP1Zmrhe7
         vsUaKo8cBG7rMgotz1tIINhuy7Hmf6F77n5+YJ2i0zn5RfjIvJeoNmEDgItstDCiyoLQ
         xSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409983; x=1747014783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iyeC1dYqzIyRbq0U6QJpnfGNVlqEyh7oNHL1QwbMptA=;
        b=EQzr82YTeToZH/uU3k0fF/GQfvfI4N0WXFRXUjy8CF8EEuKdkGTrKSFPwwzApZNYGo
         4zT/E7ZrkmpQpfWNy/LcPbewEx2APAuieoGS7ekkW7itWzB8K7a6ZWNw5XSslQL6seIM
         yjBAJ441YaMOOpig+QK6kzPeSJMeCTaVbhA+hmXa8XnGm1hanE1FF+XLGBIgduzdkPrk
         bLhk+xW3bYBHj/FrZSwrGljckV5l+KvoJPQyg8l8ztmprwHIVnEbsP1gZIZ39uhnHTLE
         aNfYUEnBoy2GkFTcZ6aC3e0nQ3oqwuCLv+ipoAMvSW6P66G89DwHacOmIN2bTOC8GGDJ
         BkUA==
X-Forwarded-Encrypted: i=1; AJvYcCV/iQwNRp1CgqU2npZA1IB0S1YWyGFvemMXipNFC0fdQp1nn7uiEd7SR7p0LpUgCzkKxAs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnxAgfzkFiApp68o9ponlgX9yIae+QX4E4kz+WvFFYk/j0U6WF
	ClUYhXHOmO8eGTIiSafhFT3CypwnOLlKD6FfL2pjDzE67j7laxdmgaizdB2u1oo=
X-Gm-Gg: ASbGncu70cpYvOoQWs5+DVoOfZPNwtsXKry+kM0kas4p+mk9Bx/xsEkypvf3c8r26SJ
	FWPUtq9QDiRyn6zPL2aqiVVWTVTgQ3ZQiH28fBaSpRBOc5RGLt+AeSzWC1od1YNQF+RWBd31xD0
	NwJBNkzeN6aRuIb4WtqQhah/6RR4vduv2NSHG4nMfCk3JR+s4Rv3h9E3iKyLM0KL+v3U19wSHQI
	t2YBDwdZYySdKNiT4G71a9bGNhaTvjEcFcV4983ajf6glSIpUEb3tyl4ExNPgJkFLaI6KOg/LxY
	MOsV4kZmSZWgevJqFB8pSijHUbdMMyQ2hoe3fJje
X-Google-Smtp-Source: AGHT+IEGCmE06PM830ZmSDQRZ5/eVfg6TQfwRHwBXfC+nvoumfTt9BR5P8zxI964fF7NFvhtkt5Slw==
X-Received: by 2002:a05:6a20:c995:b0:1f5:8153:9407 with SMTP id adf61e73a8af0-20e96ae202cmr7538720637.20.1746409982788;
        Sun, 04 May 2025 18:53:02 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:53:02 -0700 (PDT)
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
Subject: [PATCH v5 37/48] target/arm/machine: remove TARGET_AARCH64 from migration state
Date: Sun,  4 May 2025 18:52:12 -0700
Message-ID: <20250505015223.3895275-38-pierrick.bouvier@linaro.org>
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

This exposes two new subsections for arm: vmstate_sve and vmstate_za.
Those sections have a ".needed" callback, which already allow to skip
them when not needed.

vmstate_sve .needed is checking cpu_isar_feature(aa64_sve, cpu).
vmstate_za .needed is checking ZA flag in cpu->env.svcr.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/machine.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/arm/machine.c b/target/arm/machine.c
index f7956898fa1..868246a98c0 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -241,7 +241,6 @@ static const VMStateDescription vmstate_iwmmxt = {
     }
 };
 
-#ifdef TARGET_AARCH64
 /* The expression ARM_MAX_VQ - 2 is 0 for pure AArch32 build,
  * and ARMPredicateReg is actively empty.  This triggers errors
  * in the expansion of the VMSTATE macros.
@@ -321,7 +320,6 @@ static const VMStateDescription vmstate_za = {
         VMSTATE_END_OF_LIST()
     }
 };
-#endif /* AARCH64 */
 
 static bool serror_needed(void *opaque)
 {
@@ -1102,10 +1100,8 @@ const VMStateDescription vmstate_arm_cpu = {
         &vmstate_pmsav7,
         &vmstate_pmsav8,
         &vmstate_m_security,
-#ifdef TARGET_AARCH64
         &vmstate_sve,
         &vmstate_za,
-#endif
         &vmstate_serror,
         &vmstate_irq_line_state,
         &vmstate_wfxt_timer,
-- 
2.47.2


