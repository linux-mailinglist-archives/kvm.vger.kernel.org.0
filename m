Return-Path: <kvm+bounces-50329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2109AE3FFD
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8257D189B24A
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9C32459D2;
	Mon, 23 Jun 2025 12:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pYD7fp4C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A48823C4F3
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681222; cv=none; b=OVJ2Z9lY2mUqbO6wniTnP7B2BCEuJl08woVRD+dF/o0F3Zg3+XTxcKARfkpEUZUz+l8nJm5hxE7wAkmwLBejW1OD1cJnpAQtjCK/g9czzFvUOOOxTUyXLQpJpcSZEsqZH40qkfRMZLAa6fa6Bc+TD/8V0oEanSSNVUB6yaGQKck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681222; c=relaxed/simple;
	bh=doxYbh0zt2vAz9zNhMC8uVEWe9GJwNB87TM7zeshE1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gSlUaL5KXxbCKLeL3i5FrhS7AheBX80aYTu6XcdqidNZXExjterjB8+a7jDPmXVEW2cmzaqX/YqWGt1Ak9Rfb9EGPDRUGnWSNzUHX6NUP87rfq4aWUFNHaBlLY6zN9EdLjZQ1+n6nmvl2OReO1zcm+daDBgFIhsmwr8Q9v7grms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pYD7fp4C; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-453647147c6so30958465e9.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681220; x=1751286020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CoTleeCUcvYndolgWSxVbjuEBw5fGt+mb1nmRFlbWPU=;
        b=pYD7fp4C9r6rbt6qq4l97vFgGDj9ufPuHUSR8Ng+2UVStw4tFRyPASPyBYS8R5SJ2u
         6fLUTAWO7j3w9bt1djQG2wcUb9oSTFdb1XiDQHCirLHOJtu0AJ0kl6AgXTrf+VvtvH4N
         L/kwNWcpL1VLMBGElc1WB1ZpyXInEnEFnzzHO7xUcFpAkiFOLHroJzrj7ho00LDVjHi8
         W0zxjO9t/IR58wqUF+j1ZLJmd8vqAbf+A//NaHkeYQl2tuiuRNMd96q6wpfi40r8c7ZC
         C2vNox0ddRy+1qL4zhcGr8WUcI7vELop+V7yipdxALfz8MQL8BfRAqJUtBOr1H4WyDSy
         y5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681220; x=1751286020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CoTleeCUcvYndolgWSxVbjuEBw5fGt+mb1nmRFlbWPU=;
        b=gP8MZVTpUAFxz1sEqebGMeir/bmBiYeN2V9xymTjQ7cHTW4t2OG2l44AJEkLcMTHmT
         AZJO3ncke6nPWxtT3cbOejDPA6YWk1H3IirNUqxDbyn3X0XatrgZ10rPa0bQOW7cm28v
         1e7h6FIFrm7K4uAjWvnLhazW7o1Bv08eWTGBqAf/DGjd/9miflBwqkGewObn1IwU4Eqc
         6jpfWCARN517QhRbY4FF7/e9lur3KAwNDwWJEgqCit05cFjrmvnednZ6tau3UHHvABy9
         VxxJ2xafVhsOdKwLys3Anx3wr/UjqO5ErB7Gdkxz6sV7netM7I49+31WCyvYZ2IjklS7
         RU1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWAEY5ZwLkZLXXAPvoKZECE7GN5k0LanFXJOTdKyTGe/Az9XwLBJG7f5/e+dZ2871muFo8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDsdCqn4sIuwmMmzCDo1AjxewpVXO03qnjpFhZOVkXG77/UBWN
	cqyTPEjdF2C3lpWWWsfRnUsmQ3F2u5/QdQEmA70F1YIEVbdFVzIVvCkp80n0eTLGRT8=
X-Gm-Gg: ASbGncuCSAhD7OIN1Ipas1+CKHDQ3ghNpj1Olhn8hLlaZhMrNWTgDhnYAm9weedWKzo
	rrUb1Nfab7yiVZMzwG9y7OgQ4WIrUaxHtskKWBIABz5y4+KAPB3K9E/3gEBJ/1sQOFoqXRbS3c5
	LroF8f0RbQNJRji6IFBucloHsOFez0yRTc3MXUANMFphsxKh1xlt956aLagJxNDCfvpIhUOrls7
	7KhXTivaQlngh/RhR/jXAM+zNtAzANdo+f5pg/+bPZ8fxZtJWTyxxCVwLaHbtwBDPr186Uu7Xz/
	eQgLMnu3iIYMEpCYiiEeb734ZtF+KVTMHSfPcXK351VvO+GinR5E8Isq0ui/yRhYNDTJgFYmXqx
	7WIjtDJQkHWVU/fJ1XbCxaveiHZXCLgDnrIdewl/lmT+QI28=
X-Google-Smtp-Source: AGHT+IFBHJwLkEEc6nlf5I87v2Hc8Cpzzh5zV8wh3kfSp+SDxvF8pOTvTMZ84BVKQcVmti0UNd5Jng==
X-Received: by 2002:a05:600c:a345:b0:453:58e8:a445 with SMTP id 5b1f17b1804b1-453654cb7bemr101468665e9.11.1750681219792;
        Mon, 23 Jun 2025 05:20:19 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453647071f4sm109685435e9.34.2025.06.23.05.20.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:19 -0700 (PDT)
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
Subject: [PATCH v3 18/26] hw/arm/virt: Only require TCG || QTest to use TrustZone
Date: Mon, 23 Jun 2025 14:18:37 +0200
Message-ID: <20250623121845.7214-19-philmd@linaro.org>
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

We only need TCG (or QTest) to use TrustZone, whether
KVM or HVF are used is not relevant.

Reported-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/arm/virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 99fde5836c9..b49d8579161 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2203,7 +2203,7 @@ static void machvirt_init(MachineState *machine)
         exit(1);
     }
 
-    if (vms->secure && (kvm_enabled() || hvf_enabled())) {
+    if (vms->secure && !tcg_enabled() && !qtest_enabled()) {
         error_report("mach-virt: %s does not support providing "
                      "Security extensions (TrustZone) to the guest CPU",
                      current_accel_name());
-- 
2.49.0


