Return-Path: <kvm+bounces-50336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA484AE4033
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 552D13A9F16
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9589024BBE1;
	Mon, 23 Jun 2025 12:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zm31LVQP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02F72475C2
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681258; cv=none; b=Aj94ixY71BlKcb3LnqHfyWGqoTZ3ep2NZryI2oFUgJ5/YalC0JH65QF+lSMu3vqzAic0fliGarF5X9kj6PGvNaO022hkvXVHHEX4Uis2Wo0WxQCWy4jdjjaRzjz2VITKG0wa6ZBVFoV/n33qSHMgg9GdNcpwDEKqd0z7oZMpaBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681258; c=relaxed/simple;
	bh=5fgsue6rkd1evSR5rV9AvKN8yfQkhAeSrXDYO1KMjJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e36TGTp/yTnuv4hIyecKFgGqRlcggn0dY1mCasy3rdD+cItJw4/IUr2k86dcGRNPCU+H//vAbOaPMNTvKVRBTqAG3QpIS7t60iLwQ+waJfXKTlyhXJ501KTqXUb0IEQW1taudu4pYDyLLAMIXoFvS1RUtArvBm56rpOnkwv1Lcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zm31LVQP; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so47711505e9.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681255; x=1751286055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uYUPy6c9pCrsEaCpnIHygEtzD7GwjrL4VzsD7TAXMX4=;
        b=zm31LVQP6u1BFodvDxp9dyP3peXo0lWAOpblCPX0S5u4gUEf57dn6djAXFixn8T4GD
         qzUwIGoWtasKnqkvlZitWQOG/FcKb1h+4dYnExhgpE7Wo8Ltzh272QuDuzXZ3hg7N+Wq
         ufL3vTpZn2vPbjBN4ilhKtGNwAD1NniNgfOcpo0I6Z0NWjHz0R1vmQwCNAGNyKgo91DZ
         hVGvWzlgS0/UI+FoxmbpEjT4hNijZzXTkvrhx1xOsKpywnw1sV9OyiM195MxyxWOz8lg
         q4xUk9eXL6v2zrIJy2cgF69fAtBb+tlrS1igGgQRM3vIaDg7BPCEUFeaGR0q+paBJWXt
         z+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681255; x=1751286055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uYUPy6c9pCrsEaCpnIHygEtzD7GwjrL4VzsD7TAXMX4=;
        b=hNKQ9WufGfZOHQ2ls1p2QnsNLYqkI1P5LcJvpNPJeFAD4D4mPJaGWYiEmwi3QbgMfh
         VMdnsgzs3Q1d/kgSwQsnrN6ztovqxKeYsNRFwzrj39DCu3iJtttmd0mOGVbF27BIYNmT
         ZE1d0xrXr3RkDnAmcOlYiWWqQCvyXVTXAziikx0wZ/GFSL4KrYoNFBYhDsJFWzm2PBWF
         2UIrTGDKNo7PWND1wgLNiaE1p+Bdpo4LqwD1JQE7YxnW3INxVHBGIcNwuu3F5YiQNPCB
         sUITTTD917CppYkQPBFtw5EioIXurY0J6OUSZhOV93dGIo8TLB+GSElRSBy+jlh9dE5P
         Cm+g==
X-Forwarded-Encrypted: i=1; AJvYcCWVWZtr2Ro7FBJLmbHoLv7FjQBLtQxK4ojqv1dmJRyLnOgkazxFepLCBDi8CSduGVBnhdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCXyHrx9zCr9rwVxAA/GDO3IVCNmuPFMjUg1QrUaO9Jh4ZHzpH
	M/rQiIeQMZSXoawp8bulfKMNh45U5QRgqfQ8+3RAFEFTFB1+UFWB2ZgRSXoOvlt5XM4=
X-Gm-Gg: ASbGncusWxYJlE3P21jG0J2/A4MLkRyYUa9vTgpzyT6Q8MlZBTsScKPsRbvvbNNBRFl
	FukH33mUaKkfg2i1ISzlMsCOwrfcgVQJH/WmiE2qOe7fa1e0LAA7fpMhDengE1hZ/7xp1p60IGk
	LWZb3jeTk21k5Z4lc+/BlW505QyeL1DIHHN8na49C5/Bu5gxgTFfHQp0QeDHVaULBeeynT0H3bk
	1EYEIlKaLDYcc97ro/xRxyJVxuI2doSQiO3me4yl9wbCoCI2Tz1Zz6V/Rha6LrgIlu3T+NTRILz
	ebht7DtKHWtr0ECrMUG/WCWCZ5WMayXruEDJoUZECifj0a4KdkO2CErzdliAXXhzep434tujVOX
	bO8hmyIaceqvGUxdrLt0xa1EhukyC1GCQlr0fYbhz/jAn85w=
X-Google-Smtp-Source: AGHT+IGT6YWtiD9z6rC4lmVWjBSvzyqzKhJAfYphN1oZr29sjiHZbaoLUEt5rTgirbEWO1WecJkvgA==
X-Received: by 2002:a05:600c:4512:b0:453:5c30:a1d0 with SMTP id 5b1f17b1804b1-4536e0da765mr56200145e9.21.1750681255141;
        Mon, 23 Jun 2025 05:20:55 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e2036094sm2263838f8f.99.2025.06.23.05.20.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:54 -0700 (PDT)
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
Subject: [PATCH v3 25/26] tests/functional: Add hvf_available() helper
Date: Mon, 23 Jun 2025 14:18:44 +0200
Message-ID: <20250623121845.7214-26-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 python/qemu/utils/__init__.py          | 2 +-
 python/qemu/utils/accel.py             | 8 ++++++++
 tests/functional/qemu_test/testcase.py | 6 ++++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/python/qemu/utils/__init__.py b/python/qemu/utils/__init__.py
index 017cfdcda75..d2fe5db223c 100644
--- a/python/qemu/utils/__init__.py
+++ b/python/qemu/utils/__init__.py
@@ -23,7 +23,7 @@
 from typing import Optional
 
 # pylint: disable=import-error
-from .accel import kvm_available, list_accel, tcg_available
+from .accel import hvf_available, kvm_available, list_accel, tcg_available
 
 
 __all__ = (
diff --git a/python/qemu/utils/accel.py b/python/qemu/utils/accel.py
index 386ff640ca8..376d1e30005 100644
--- a/python/qemu/utils/accel.py
+++ b/python/qemu/utils/accel.py
@@ -82,3 +82,11 @@ def tcg_available(qemu_bin: str) -> bool:
     @param qemu_bin (str): path to the QEMU binary
     """
     return 'tcg' in list_accel(qemu_bin)
+
+def hvf_available(qemu_bin: str) -> bool:
+    """
+    Check if HVF is available.
+
+    @param qemu_bin (str): path to the QEMU binary
+    """
+    return 'hvf' in list_accel(qemu_bin)
diff --git a/tests/functional/qemu_test/testcase.py b/tests/functional/qemu_test/testcase.py
index 50c401b8c3c..2082c6fce43 100644
--- a/tests/functional/qemu_test/testcase.py
+++ b/tests/functional/qemu_test/testcase.py
@@ -23,7 +23,7 @@
 import uuid
 
 from qemu.machine import QEMUMachine
-from qemu.utils import kvm_available, tcg_available
+from qemu.utils import hvf_available, kvm_available, tcg_available
 
 from .archive import archive_extract
 from .asset import Asset
@@ -317,7 +317,9 @@ def require_accelerator(self, accelerator):
         :type accelerator: str
         """
         checker = {'tcg': tcg_available,
-                   'kvm': kvm_available}.get(accelerator)
+                   'kvm': kvm_available,
+                   'hvf': hvf_available,
+                  }.get(accelerator)
         if checker is None:
             self.skipTest("Don't know how to check for the presence "
                           "of accelerator %s" % accelerator)
-- 
2.49.0


