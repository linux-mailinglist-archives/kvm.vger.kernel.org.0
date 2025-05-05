Return-Path: <kvm+bounces-45381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C177EAA8ADD
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D4053B40F3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA9A31F09B4;
	Mon,  5 May 2025 01:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v5WZgfpG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4151EB1BE
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409982; cv=none; b=XTRJeVntDjMu/OETIBVKfmwpvTUoce5E1hw9zxDlT4OiSGpFiq/8y1SFDg8KBx3wgP3gqkpwUFC6E1TgTd7X6zY9bo0Npwq3DUjEqqLQhAm1C6MfD4ukDfagnFhj0qIr7yc+QxEmj75FdgKHFISh9fouG0aFd4pmxel02tsK8g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409982; c=relaxed/simple;
	bh=3RsKZ1Pgza19E1HBaBnLbv5wQ1rc1mFEhHbZHJJ5Hmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIcrLC4tAm+RiCjp0kTnmRPsje4iXfT4D2TN+Omdj8Tk/aksfhTBw7IpB5xNmVbTb06ZYLy1YC3KZ6LDfH++UadHwDOpQ7bd2RQap4XDxq4rrLLJJPOzD3JpQCNzqKPqMsQuYrcERyxDYQ4N9DcQEgyz0LyC76SommcP0ubDrCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v5WZgfpG; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso3909628b3a.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409980; x=1747014780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=v5WZgfpG+pmQ4Z4MDplBSzZU97aRoWXwX8CJAebitHrn3WxDqsPd1EvtWuMoc+g24i
         uGq2vI+/8OH5FkCGREKxKV7gYqXfpkEuVzXTo+lyJz0XDBUZ0tuQ7Yl1HXk9vUDVuVSC
         YmAUJTZlKiAKqn2XTarPZO4vst3bkWrtyPJDwuYDLrj/ay7pf/VX0Bob50tfAA54TVK+
         mgVGCYXpl2o6CQPGIX43Fu3F782/vrLRUnD/L0MqpgdRgyjjxN4LKqpQ4U9f8RuC0eUN
         ah7oKjQub89ZSwKWweBTBSLiHLYASGQwuxlV9z0qjt1blRjYK235FNvBuct4U4zwrxvV
         yu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409980; x=1747014780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=wopx9iqh5+CXTDGfH3mcEZfTgbPO9dormtA+tqs/3DNdDHPJgTgKfhzBL9NiV7H+zs
         rmhV3Otwt9kqrnPE9pA9KZG1bqwlIqsq6q1Qqjl6WHlmBr/UHFycLwOTPIntUeCr+N9h
         azSQDJRZuFD43++v96GJPHyeoyuD+RK5Y/eMXMQU8WWVpDAhwD2dmdCPjszAdfKRHMC3
         EIaI6SdKvjUgkOY21OtkISKWqgQ8YcMcElcUllmxwMNe2bEYFG34QsM9LX4bsXl/fjoF
         F/tAaS8peYrlZkteQXMaLIWS/Li8Es+SUnjNGpfwra//OaB8nKIB9KbTiv9D09jA/ZPk
         J2Vg==
X-Forwarded-Encrypted: i=1; AJvYcCUDiYZP1kxsAJIUy6mfh2WPL+bw7uOOgB9Vus0qi+3o/mLCHZ5QEEaUA/IKwzKCzXyC3Qs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzekivTUz2t2FTp0FV/hek8FShtmrBS4OnASYQLgZ1vzVs59B6i
	HgfT8Lym8Nn3pe3hHQdFCHsmSS1mYDnxzJlGXD6RKfd/nyplP5fWhMcqEN166qM=
X-Gm-Gg: ASbGncvdeE3nOOkc9mgSZpfCzkY1QMvGtXIb0+++nfcgUMWrjeTIJUtGxb4/gCRO4/O
	Ar5jF7Vdz6/y/xgwTVFBcONBazFr5zqnC53G9lJWNxrkXiRX7AZ7Dh2dqpkBFDUYoHAvYzfo7ii
	Bw8lOoA7F3MChuiXLMw6Nb4Pl1Bb0vBDhogJQfNKreFY2HWe5KaECeHpBgTsHUmSwJeYOMm1wvn
	B/N9gfve8nFPSYKqZ0f8/SHcaMnSQOp2x7ib5O+rNAyNM9rBQkQTBhs+EJa//kuEai5TsUynaa+
	/Bx2xdIcU29SQR9FTKOpUz4xD8LJaDUnr2GDQVEW1e4lvAB7FAU=
X-Google-Smtp-Source: AGHT+IFgLeVwvQpFcZ2xjxjTrl7k3WOiNHp3SqAmhA94n1nQpI7p9dI1Ond7jrjd4FwoecItT43iAQ==
X-Received: by 2002:a05:6a21:6711:b0:203:9660:9e4a with SMTP id adf61e73a8af0-20ce04e6871mr18561298637.41.1746409980047;
        Sun, 04 May 2025 18:53:00 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:59 -0700 (PDT)
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
Subject: [PATCH v5 34/48] target/arm/meson: accelerator files are not needed in user mode
Date: Sun,  4 May 2025 18:52:09 -0700
Message-ID: <20250505015223.3895275-35-pierrick.bouvier@linaro.org>
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


