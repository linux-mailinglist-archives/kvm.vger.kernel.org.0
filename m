Return-Path: <kvm+bounces-50092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E26DAE1BB1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0595E189B551
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D165E29B22C;
	Fri, 20 Jun 2025 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mza8UgB9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BC028D844
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424978; cv=none; b=CPJ1uIsB+BMNH0FADTHbkXwBKkA4ehh5E/pG/IIougFbSx225qGKeDujZzLjjInECmtuRmbCNL3r1Ya6QP/cMpPQcDL17fo2NbVaQbLQZV0W964NenbdqUOVDkhoIdStAb79BBTTRZqJ8LRuG7mYLYV/aRTNgRU+YPM0JrI4cHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424978; c=relaxed/simple;
	bh=2J0ny7pzMdBIiTOpM8kF28R3bRiLrAoy3JNqdOhbdEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0j+/B/Bh2gazYHnEEm0d42kSBlUQ9KxybEQSvACIZmbRj8OGiBEvRg8UgioTKHp/gmGHRACckkw7aMmjTYJhLyfBDo3WTi/yqnkYG3e+QSw5pfw7vaOH4rqD0cpNhfBYEGNhqlLoKsoTYiLzYiW1c3PUK9TzvwvedA3TpCWuTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mza8UgB9; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4531e146a24so11638925e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424974; x=1751029774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ML487RZEtX6RDPbX3JUchrWHyom2/STG3MUfjQAASi4=;
        b=Mza8UgB9w/Xf3fncCxDobRLRsl6pgjOiMqHVh4uki1O32TphivWPgQ46GPMFDrGkqW
         Nja0D+V1uA8B8ToFxWbQq0F4JokJCgn8BGYHEL8znzicajksRou+I+XS+4seZuqwf1XZ
         a/9Sn7z7386l+xdxqlHUaubODz/US+93SimNTqdBOTjzLTvMPyV5dWOhAy9Wx/NmSP/Y
         VQDVaBhKVkGKFI3EV0+AGqquY+VMk3D8d1qZIqy+5NeLjYXQHUVm364d6lvE3KZFWKuC
         QCorOVL1pzsuXQHQPDH9fT05KeYpHL3LwjHvQ0KYUi0Z+2ki+YM3+Be3AMVlBjtG/Cdh
         BMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424974; x=1751029774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ML487RZEtX6RDPbX3JUchrWHyom2/STG3MUfjQAASi4=;
        b=v/T0PyePae38EIWTEVcFzyj8yabeDuLztSRY6hvlLMn+4D8qjLOLhd+R4b2GWzCqSo
         hjuqEZlvDwQsVJQKwmWbSY70RkBXaajDmQvXtskEPG1Ro0OkqK9exnI1sLr2OZM+iqzB
         QQjXP9HcQcWmOLrwy8q/onsirnLStnxZKmEv103aE3oUgHZZw+oM+9mT3QmuJPdXDLYX
         y0wKsjnF0O6PGjWAqXDkEkcTa6R2ixDwYsJ+fwwPk6TyUbkVLhnI4eZizHvwk5Vpo7ht
         aTuKZKnnhzVclOmeQMRdGGGykGOgLzoo2qbe8gtIZSmRQgV3Xre36aNs8iWRtf6DYb93
         sIGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY3M4N3qSNkewDT26HGcNeJ1Nkx+nQVqmgavTqY/Lst0NWXs+sLZdtLbj28dVQdekX/Cc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMmjl8k83U+klTtV+eS0oAgni7ojIEU7c1Q4aVGutlbAt+cjfC
	PF10DCgfpcFbq4+VrYxfXEAyZsZIrLDQT4RMiQGwZwCLaWXPcuOfIPyxZonw8725UE8=
X-Gm-Gg: ASbGncvo6ZNfAgNQEve8U7kAW1iERl/5maGzWqKEcmyh/SYzGHw430uzniyXMJ3hQV4
	5ILwMMFWBlLWV9esLc6xEjGsxTaN5jnfjdpUCFbwAlc8BW9O241g74L7v2Q1GcGGABYjXQxIVEM
	ovhfAaNQ2+3iGBbQHsYmztBMT3MhsLZw9lUV4ympWRQYw0QUJ19oJwf3T+0OQ62ftbIz1LPPDRz
	4ctLO/nRI6fpxnXBOr232/LiIotJMbxNLLUYGfalAUCNlwVhYoJHrlWiu+hLX6DtGfZjTufCBQk
	sxkzU2ojlErw4mLrUGxhEAX/jhvHNFbEozcYibb4QnxW/xk0w/9FVaktWkNqDnYUxK+LBfCNbre
	HQl1UBf2WXeGFKdJefqDMeTR5fac5MKEXyMbv
X-Google-Smtp-Source: AGHT+IFoaiSq8p/vZ15JMywutihLdhiyx/4+KTYgXl1gSeqr94tnRyEi672b3w+H0TV5kZSUiEuYRg==
X-Received: by 2002:a05:600c:3542:b0:451:e394:8920 with SMTP id 5b1f17b1804b1-453659edd18mr24577215e9.27.1750424974566;
        Fri, 20 Jun 2025 06:09:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45359a09ee6sm38434125e9.1.2025.06.20.06.09.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:09:34 -0700 (PDT)
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
Subject: [PATCH v2 25/26] tests/functional: Add hvf_available() helper
Date: Fri, 20 Jun 2025 15:07:08 +0200
Message-ID: <20250620130709.31073-26-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


