Return-Path: <kvm+bounces-45327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C89AA8417
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB0CB18937B2
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43A11C84AE;
	Sun,  4 May 2025 05:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zqXb3cr9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDB71BE23F
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336592; cv=none; b=WxNDu4YWzsooiKPbhEs+if1cj5J+4RM6qdWHYIVjP/Btd07JahOZtMwz4quYF50B0OhoVOPdmG2nDmT7offgpbmKEh7w+NmjCOWJlV+Pw5CjyFheQAA35TX9X3cUyjnlWFHakCJVwx1mzfCCdoALVRpSDngARX0zMZO2L0+jn3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336592; c=relaxed/simple;
	bh=3RsKZ1Pgza19E1HBaBnLbv5wQ1rc1mFEhHbZHJJ5Hmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3WVmWnBJES7wqb/2jCek+M+jmT6yg4dqX3W/aIi9B7+Up5zY6HWHBy46+aAT7c5XpdGIefEqcMv/5VM6uB3sKg61Jd41fR/48uxMUHnDCyccoUfP3wgrSP5GMlldZT2tllancbK5cwthnHUdYW9tnMw+ZwUpVeIwBc4hCbvoF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zqXb3cr9; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22c33e4fdb8so34678295ad.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336590; x=1746941390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=zqXb3cr9s/FnXZcb0Fk7yDlpPbfV28krvNqyzjvDZocq+HCzQ7+slEtQ391KR4CNP1
         TNoacFST3OGRcYcnQCxwQWUkTNyM1clFXCiQCAaiDjz6ymOEki/cQsZJ9zbMrVlb7Muw
         ZKgZqxRnz3Mjq+UI637iut0lDDI7Km9g8Qa8jJsTE4oDeSzWH/4vvKmDR3V/zzeg4DYJ
         USrQRfXSlBM+mFSEZVWMWmEh8E/Z89LJXi5KXBYiUdbAxdPD2CiGqMOrIvAfMHeqzMA1
         5a6JkkSvj7b/I+3pjOFY6Ge7zuozm9CidXqC94wVGs2beoiMKWET39BQ+ldo4RhzAbey
         F7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336590; x=1746941390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=r/GmjmVDQDIvVis40iulNReBs1OSU0qae/J2AP/VNTMmDy+lWB8HFjG7XCC67WeL7X
         xy0beQz7+Qa/FR+qYn+u4+D5HNiKmuz9Pf8f3LT7gV/CfTAo7ss7smVRqowScLfpQ27a
         OGex4/qcTh1QpNQtIz6TnsrOfZCZMl3XrwIu/d++IIe9XSG7/MbUYMwrH7kBab7P/Ftr
         bx6m1bWx21pJuRATEyKNYsewL2LKlCHiaXAgEp0tF51Uv/grm45xzokuQ0PLYOVkYo6M
         W6dhDFa05Dr55sFayEik5tvUHTkf44IrZRSfoM7LPdtpFla/qm3wDOFZzvXqWfSU1Ub/
         fmRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuQG09iKkvgaijHmiKmv2zmAM0FNSszihIEoTg4jRJYLgvTGuL/hya0RJaDybqs3CEBWg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzit6fvOhxXzS6nT/VGxwZUodM6qiBFG3MQtukYSr3pv5hooATD
	Jmvayi/HZ1La4DqUH0eFUKsLrvjus/C3HiI0AcDM/HP4QIc8pHfPyAw1OwlEt5w=
X-Gm-Gg: ASbGncsK9u6CDaqwC1cn/RzZ9E8gbT3LrliRwqo1gNdFgKoqgJp52qAEI6PsVl7gCph
	2BttE/MJnmQEZiCEkls2bRLIPr1jxTHC3H6eOreaYKwbsgvcmz21+Ya827Z/ur2vPIGx8b99AN8
	rg5/xh7PxHaaDITLzJ1fE3e+N7YGZcL3degpDU0nPhLZrSXDMVtkzcp45tdtXigBNNHAOAwtxhc
	WXgY4w5YobelYqHqJCH6EtQwAtn97H2VaOQ2nnq8L1FxJiSy/IAnA427EpWhv8zGe4/Z+QYigzU
	bb/KrDVq6AlMIW1GyiiQYwZIeo1LRMOhiCkPv9HU
X-Google-Smtp-Source: AGHT+IGp1Z+ingLQ/zaY5mlWqvBGcOfRi5+H8f3dhypRIFBlvK+ozmXQgUbNrGD1UrydKARVERewBA==
X-Received: by 2002:a17:902:ce89:b0:223:4bd6:3863 with SMTP id d9443c01a7336-22e1e8d5f5bmr45403065ad.10.1746336589950;
        Sat, 03 May 2025 22:29:49 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:49 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 34/40] target/arm/meson: accelerator files are not needed in user mode
Date: Sat,  3 May 2025 22:29:08 -0700
Message-ID: <20250504052914.3525365-35-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 151184da71c..29a36fb3c5e 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -5,9 +5,6 @@ arm_ss.add(files(
 ))
 arm_ss.add(zlib)
 
-arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
-arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
-
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c'))
@@ -18,6 +15,8 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
-- 
2.47.2


