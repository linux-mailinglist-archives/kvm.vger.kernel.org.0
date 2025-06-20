Return-Path: <kvm+bounces-50091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF66AE1BAF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B08A189F56B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4B928FFE7;
	Fri, 20 Jun 2025 13:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zBHs4xDC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F7628FAB3
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424972; cv=none; b=jWob7+9ZFc0JnJ3OvW+3w1hmKsqrPjFLjCc2riBKCmsKbAxhqapLioqhp7y/7v2ITCT5819p6ynaKRqRalAHmsC/mftMvLhK67d3I741b/lij72hQNiSVQ6weChXfraW5Oo4dsKHzJklfbwsbS74zTvvo+Dj43FWoRW+/tSSJ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424972; c=relaxed/simple;
	bh=ZoBdWZGBp/ZFSo3QeEoyQzmvIghJYfc7mB2jt3rfa/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iT2mgx9wWGll5l62ZOnuptyZCXGu92gzvrq7M4Y+aV2Pq1FILx2xukaGVq0yV2eE6dD1ohqmoGCHnqvm/NBjFzFoDBvy8N521lOuRSvC5CNBgJsS8WqEPBThUKTFghPoCS3/ROztj9iU2YGGaHo8+4oKD6+319GqiQ2I+xuhYAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zBHs4xDC; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45310223677so15227275e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424968; x=1751029768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ho90gmr9LBnf0X5r6n+/qD5b6A/rnGinNhmNB6fBLQ=;
        b=zBHs4xDCjv6J+dAqk4C7RmaaVlVVygDyqxJRB/6E5C0cUano0zFNL3aiqZrzzIJOGZ
         8d4PQRXaVa8Kvg36Wlquh3/YeKGEE0+pRVktugz2dA4t2yhyAVfaPG7I7U7XK9NgrFHd
         th0GrGdQ371+9SDruMu3Bj72ci10TO3nWvzhosyKbwxgivOnTzCXOnjqwy8kU6k4Jed5
         dYjPWGxxEI2seXu2pmK5chaV7c0JFWgzOvFsuYsUZ1KQvV8UEqnq+tME+d07O+zgmI6J
         khDBk7tgrI8bkxU0YIj/8OFlCGA0QBaxhoIpbYV+SVodBHuuI1qhD8NPXtTT2aRBzDM+
         WCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424968; x=1751029768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ho90gmr9LBnf0X5r6n+/qD5b6A/rnGinNhmNB6fBLQ=;
        b=ic2d8W2eOdOBPdr7y3AjJ8nCRsW7i+iZflFdQG2n30gOUg4j0Bx2wl2WQgbUQ7jaoH
         QDdDo4uo2s/XgDGoL3Zua5xYIrLgtHq8MQ+bw7w/NfLFkGpWWTRDkK0rmXHSUmtLhxFH
         TJULhE04eo6gA+hqHBBowk8/qpJijamDlDw+a5oP/opgxmDG9qUtFv29tRnEe9HKcWZ/
         zkeHQro96aDd1kmj5DF2NZ0Q91+hkk3GCSAi/oWyBhpqE4Wdw3H+KBlCVJSH7CP8+SQD
         bh6PWo8f9n+1HI22n2l1n9ZOLbB3Skk1VC2JIV9O4+MUhymbRZg+1EjGve0QioIzOR3B
         PY/g==
X-Forwarded-Encrypted: i=1; AJvYcCWe1cuxjqqVI7OBb87pCSag9qJMAA1cEgOh1MV8WsNNVVOBg2v6CB2O6mM3WGylqmBPffQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+ZfIQpXkwXyI13X5Fa0BSlxNuk9gc9SzHlH3ItuHIysUFx+NL
	5IQQaWQZoy1K1c6sFEYrx2d9ELEcuFzrIXuwM4bFCzhKIbRWYsg8rTp9aWpTYxDEFgw=
X-Gm-Gg: ASbGncsu2Zz8GkK0m9gUqqZj3buV9zLE6G1ho6hv5GcpeZAcNnAbdUj22Bw7YRJmik8
	2KZay5cEjdQDJ5iwIm7EyT38K/Wj8Ix1wWUguclgvQwh4ZYS8aleiSfkRS3CIRgxuViWSvdAgat
	lH6b0FeUrVGRhPGxQH62MnTF1KP6NbgU9Bn3pinpkyxEeUgde9cEBPNOjgTq/qOjiNmg8N5pS2q
	EzIja02MiAAACQzT0wH9dCNlHibdI37pIRd11eGl0G0lQPeBdy5ZW7eO2+OqSgX3Xwq/7Vhenkf
	adr47h1hvidpjeoqfodCy83aGgzBh1z4T0bC0ec+yZG7PUtOGpjEGzYoS5dZWrFl4RpeOIHo/vb
	cK3Hx7/aGeZj49PVd8y56wFihVHxtEdV8AZ9C
X-Google-Smtp-Source: AGHT+IGF8bB+qSx4ZvZXQLjUAOyAVozgjbRUMGz4uRoQ08Z1w2S6A2LTzrO9vB7Kb0AUvy301GjaBg==
X-Received: by 2002:a05:600c:4747:b0:450:d37c:9fc8 with SMTP id 5b1f17b1804b1-453659c0a51mr22550685e9.13.1750424968380;
        Fri, 20 Jun 2025 06:09:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d1190c9asm2073452f8f.93.2025.06.20.06.09.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:09:27 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 24/26] tests/functional: Require TCG to run Aarch64 imx8mp-evk test
Date: Fri, 20 Jun 2025 15:07:07 +0200
Message-ID: <20250620130709.31073-25-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The imx8mp-evk machine is only built when TCG is available.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 tests/functional/test_aarch64_imx8mp_evk.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/functional/test_aarch64_imx8mp_evk.py b/tests/functional/test_aarch64_imx8mp_evk.py
index 638bf9e1310..99ddcdef835 100755
--- a/tests/functional/test_aarch64_imx8mp_evk.py
+++ b/tests/functional/test_aarch64_imx8mp_evk.py
@@ -49,6 +49,7 @@ def setUp(self):
                      self.DTB_OFFSET, self.DTB_SIZE)
 
     def test_aarch64_imx8mp_evk_usdhc(self):
+        self.require_accelerator("tcg")
         self.set_machine('imx8mp-evk')
         self.vm.set_console(console_index=1)
         self.vm.add_args('-m', '2G',
-- 
2.49.0


