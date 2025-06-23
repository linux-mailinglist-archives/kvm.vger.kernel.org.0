Return-Path: <kvm+bounces-50312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E42B0AE3F95
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0F377A54EA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC66F2459D2;
	Mon, 23 Jun 2025 12:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LafLG/S+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2071723D2BF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681136; cv=none; b=MmMQEFgyKqUdAvCLXOLYVphBg1oJyZSCvWVFJnVhLljDBgLjVf04ivT/B+Jg6vmLot64qWyMoW0bZFKbxRiLwey3kVq3/JVsCUB+/sGM55AUj1H9lUogzBfw9FM6InggGBYDg93ViNra5CvUtmaVZ9hA0kqR89kVZqbeCrdkXUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681136; c=relaxed/simple;
	bh=FTwSWjOPlPh4iaJMiPsYNpGtLFmbjl7PADR7lJI3274=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VPc6KpMb3Uzdypn4EntvGO6D/id2oZW5lpAxM+ESrMl5klOz8Hb8N1M6cUPAdfRXLqqLFffFUcpGnQRPLoI9PvNV5qQxhNlDlgmj3OvCutyLVqTa2QMMHB1IdnnmHTJXjg27/N3qT/GpVhMMO7+JRW99Mfw7dyQcw1Kb4Xxs2ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LafLG/S+; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-450ce671a08so26533075e9.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681133; x=1751285933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBZvBlUJJ4ZZzRhwp1RRYC3txHSba+iTcUIOSqbdq4E=;
        b=LafLG/S+9jRmdrJwDG0cSFr9ZRJE9c3WTyf0w50e8SGKJWqTFaecPWrS2JTWLFcqWF
         7Z59bsz0Vx8lTmA+OLYBp8sBVmUK6Dqob216XJwBrtFx5eH6chjsedZ75GSFiTz0QvrY
         WS3Ry+QtC3oXkLTfFo9xmGONdpgS8SHG3q7GuUBH845f2MPjvEHk89YZSHngAmZoJFjy
         A7QuGhJT29feuG/Hh50bI09VhSg7bcGBMA9/Fq37fX/3lfC1I/RMrRYzTbrqxHP3KRVK
         PY+YaYcn19Ota/Nhy6gStJOapLHPR3zNUoRbZYzkJ1iVqknudAe7N0wdmuBuEt9MaJT0
         Fjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681133; x=1751285933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBZvBlUJJ4ZZzRhwp1RRYC3txHSba+iTcUIOSqbdq4E=;
        b=ZVe/VDLxwpC2YGsDkshsS6xJrjYV5le0w1mmX44QDUHHuYvuxvZdP4KjaANOvfgU7u
         Uc8JMpiJO2O04lXSl/Bh5dYzCwayqk1+NtL62tHQlDU5UJq9F3YVisUg0VHIJaUoPMFh
         ddECfiBbvEJdvlZElwD+W5gEb4bRrpOsaoFYloNGREOs6rcssZr1QEMVelaFJvjffsnQ
         ucn/pjmffJ9/PJTnvX6Rog+8RnKbo49evr3WZPFJtlW75k54ZE8HgxDkc8hO2nnNvZSY
         uyyPOBG32QIJD7krVF+TsNM0b30T2J471kSbFsOYaxVq9UVSWs6n0nO8SjfBR6YhFGqh
         Rcnw==
X-Forwarded-Encrypted: i=1; AJvYcCWeOHYKTbch4RHPkGl51yD2h0iUO8PBtW1/L4g72w2Kaoph++HR39ISzXFmvglJavEzmNU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsA8EbTWA/1t9l8MxFhSrZ0Vqie4K3HtGf8GWvnE7qRmAGGBHp
	iGfL+5D3EEG3gpHSoWVDMJzd9K1b2bUXeLyA0SP3VC+0ETkaMY1k3H8q5pUSjhbtKSk=
X-Gm-Gg: ASbGncssKPQSp3GVIKBGgnIQx8r2y7nZ+dLYVILKddKKF+C9lR30BnEEln8Zu2kWVg9
	aM3MhRx5F2bIfCD1n9gef7tMYXp+JUbEKIO6DEg6zhzmc+fLwDeg5YP39E9aRydqxiMgNfU+hsS
	/OpslfARolCsMZJt+1MajDcnewfqkXaN3FDuD0LSvZ73vCv+38/FBqQGxbtThbmcAPCJrq4u4gW
	aMinEs7qgW6WG7o8Tnr7la47Z9nmkoN/ftN4uIV0pCgokV17+ICqICrVtyiHTN5OIOLRAceauHJ
	uXxeLKo/Gn2lUsB+9IwuZ39eBooEeoDHDVEtZZC3kGMdYfGqvvgRX0rQCyfglBnznNHY8WdPGE1
	ONcok1NySb98yVNic5bhulys+VD3jGvjCVHRI
X-Google-Smtp-Source: AGHT+IFC7OEULrZU5qbGkE5mHTI4DDkyLTxB305hu8Ey7qsg+WC3Ig6FIv2n+cvmO2DD/y8MEEbwgA==
X-Received: by 2002:a05:600c:458b:b0:43d:db5:7af8 with SMTP id 5b1f17b1804b1-453655c6142mr118583055e9.21.1750681133114;
        Mon, 23 Jun 2025 05:18:53 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45377aebaddsm15398735e9.1.2025.06.23.05.18.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:18:52 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 01/26] target/arm: Remove arm_handle_psci_call() stub
Date: Mon, 23 Jun 2025 14:18:20 +0200
Message-ID: <20250623121845.7214-2-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 0c1aaa66c24 ("target/arm: wrap psci call with
tcg_enabled") the arm_handle_psci_call() call is elided
when TCG is disabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/internals.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/target/arm/internals.h b/target/arm/internals.h
index 3360de9150f..5ed25d33208 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -650,16 +650,12 @@ static inline bool arm_is_psci_call(ARMCPU *cpu, int excp_type)
 {
     return false;
 }
-static inline void arm_handle_psci_call(ARMCPU *cpu)
-{
-    g_assert_not_reached();
-}
 #else
 /* Return true if the r0/x0 value indicates that this SMC/HVC is a PSCI call. */
 bool arm_is_psci_call(ARMCPU *cpu, int excp_type);
+#endif
 /* Actually handle a PSCI call */
 void arm_handle_psci_call(ARMCPU *cpu);
-#endif
 
 /**
  * arm_clear_exclusive: clear the exclusive monitor
-- 
2.49.0


