Return-Path: <kvm+bounces-50333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF5AAE3FAE
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B01477A872E
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C22D247281;
	Mon, 23 Jun 2025 12:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m0BXxNt1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2966242D97
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681243; cv=none; b=C+xsn+uG+lA5P46E9Qavel0L7YSg7dj60f7xWoahkF/AHCcjEH1ANuDcTXdO1RRHzTjLYq5shI9rLcey3B8RLRJCZQoJxmeDl8EN9Qe/a0r3XPWBgOy7dU9fqAlo6rMVfEj/qbAcMhvZxU5XGeKTyym2KMDY08BUjckF26lD+ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681243; c=relaxed/simple;
	bh=wFGVYk9hCFdiLB9APrF/fWfFoJa+dJ445YCpZGa29fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iWDYJGo5QCD+vzbM6eYt1zo2lxjaShE0chxax4SManSFlt3qzE25ZcuiHViKCHHBKKlvcD8me6tYeDUuOd38hoLOJn8YfluX56Y6MVOltQXBsgcGDNwKP6no567oas7MLfh+pQ3KT5FvPj1yU2g2LNzd0FLl41bzH3Nab28btWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m0BXxNt1; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a4fea34e07so2015135f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681240; x=1751286040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtQNZzACUXAAbylIZWuCAJaOBU6QlQnouJAN5jXvi6I=;
        b=m0BXxNt1a3eUqkBiNwzhnBhIdGDLJbOIUHxujZ2pQeOzU6BALE6hn/0wbVP0YEVLI0
         77GOlXNjoPNBXIAvapcHExEAzgfeOADrieO9GfK/N4XUF1XOq+HaxuEHMg2w/WURxWZB
         LTp9WV4gp67dbU6tUONtH47yJCPj2JLJBQEngidIn7oVm2b9kiuL6w2AnSGgamYowGOj
         T5g9m43ft8bu4IthgCJJQQGhjIRn+eKFPoloHCmrYK+lsGuQH8eL28GRNXy8tDwFCzMi
         /Fu+Rysu5WLwHctlaEpoc5hVsAWTNhHACfj7hdx3jzf4D308IHcMYwpSo6HzlmRNEynB
         BXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681240; x=1751286040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xtQNZzACUXAAbylIZWuCAJaOBU6QlQnouJAN5jXvi6I=;
        b=XTXT5q1fgefw1GOy6Hm+dtMCs+sk9aiUdyw8adjlfl93AiO1Y/9FBurT/tQEN7EVAp
         ima8LucmKsvNcZdjTi4rUwYktbCH1Omvk8RkQrXz7SezTMnu2dOA293GzDK2/Rh9bK7+
         4sj8v9AUfKBeuVcS32dtEQpZNG4OmYQCKty7X4VBPgEx+6RjtSpgM6HbQrIm6qeRGfq6
         uWobwK8CpFMDx2ylkARMkhj/b3armrEpR33scOugbiyWixkJtLQTpVN6cUXRFrB4MCOZ
         ZRDh8ME8eiswbt8Au4ZgFZrr33Qp1EV2tOdbeyiD3gyWMxjgOAkbwanmCtutwFA2Qc7N
         ZvCA==
X-Forwarded-Encrypted: i=1; AJvYcCUGBQDqQQf6mcc1ebZ/WNDxvOatNYDxMEfa9tGaJezyFSt2vMmN1+LFLNLRthAQzAFfc8s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU3Kqxt34N7cF2Waf1mKdepczQCEHbqGgy1Axln1U3M4krOKOc
	JA9YW0smTIb8Kx2Eg/kT9UmFgkuOAgR5JhKpTXWa5kr+eZk2cbnAk9S8ddzJHbSidhY=
X-Gm-Gg: ASbGncss2JJNdiLXdE3+2uiSX8h9+8mVCDO4KcBSsc538HBCyBL8ooCjUG/n8IT/Kso
	3lytk0CVM0aQUr2Jt7ZhIAnhNg1NAApKMKVyzR1SXqqIer3yRUglMNQ4uBPZmJadSaoxyjoQJnT
	9TGbEpDzUpXcjmWMplTV9Wy7/niLQpqshya++9Zeu3AY+xj2zqrkpZE+tSqAg/GlVnnkJVCUoXP
	pQVWVUTXnv4DCVjl56RhZLG13CIHdJWU3FAQhulMSwpJrS1yh0BjOQQtP21EqZ3gvj9sjHeumJk
	6Mh+RL/nXDdY/hTNnbUwsEl+CRUO+AJkMur7EGdH02Vgs+B3NaQX/FtrB2EDw8yF30mytxlzlI7
	IuuJ76IXD6fy6vMp3XVb+TdouKiga/GAJgv58
X-Google-Smtp-Source: AGHT+IGloUAr04yva76gXPckxz6WSYPWq4wDXpDI9HHEpLc89a3rsZ2d9KIpm2RuC3BaoxLIlkYNIg==
X-Received: by 2002:a05:6000:230e:b0:3a4:ef48:23db with SMTP id ffacd0b85a97d-3a6d12f9af7mr10894746f8f.59.1750681239899;
        Mon, 23 Jun 2025 05:20:39 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f104f6sm9656927f8f.12.2025.06.23.05.20.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:39 -0700 (PDT)
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
Subject: [PATCH v3 22/26] tests/functional: Set sbsa-ref machine type in each test function
Date: Mon, 23 Jun 2025 14:18:41 +0200
Message-ID: <20250623121845.7214-23-philmd@linaro.org>
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

fetch_firmware() is only about fetching firmware.
Set the machine type and its default console in
test_sbsaref_edk2_firmware().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Leif Lindholm <leif.lindholm@oss.qualcomm.com>
---
 tests/functional/test_aarch64_sbsaref.py         | 5 +++--
 tests/functional/test_aarch64_sbsaref_alpine.py  | 3 ++-
 tests/functional/test_aarch64_sbsaref_freebsd.py | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/tests/functional/test_aarch64_sbsaref.py b/tests/functional/test_aarch64_sbsaref.py
index e6a55aecfac..d3402f5080a 100755
--- a/tests/functional/test_aarch64_sbsaref.py
+++ b/tests/functional/test_aarch64_sbsaref.py
@@ -40,8 +40,6 @@ def fetch_firmware(test):
         with open(path, "ab+") as fd:
             fd.truncate(256 << 20)  # Expand volumes to 256MiB
 
-    test.set_machine('sbsa-ref')
-    test.vm.set_console()
     test.vm.add_args(
         "-drive", f"if=pflash,file={fs0_path},format=raw",
         "-drive", f"if=pflash,file={fs1_path},format=raw",
@@ -68,8 +66,11 @@ class Aarch64SbsarefMachine(QemuSystemTest):
 
     def test_sbsaref_edk2_firmware(self):
 
+        self.set_machine('sbsa-ref')
+
         fetch_firmware(self)
 
+        self.vm.set_console()
         self.vm.add_args('-cpu', 'cortex-a57')
         self.vm.launch()
 
diff --git a/tests/functional/test_aarch64_sbsaref_alpine.py b/tests/functional/test_aarch64_sbsaref_alpine.py
index 6108ec65a54..87769993831 100755
--- a/tests/functional/test_aarch64_sbsaref_alpine.py
+++ b/tests/functional/test_aarch64_sbsaref_alpine.py
@@ -26,8 +26,9 @@ class Aarch64SbsarefAlpine(QemuSystemTest):
     # We only boot a whole OS for the current top level CPU and GIC
     # Other test profiles should use more minimal boots
     def boot_alpine_linux(self, cpu=None):
-        fetch_firmware(self)
+        self.set_machine('sbsa-ref')
 
+        fetch_firmware(self)
         iso_path = self.ASSET_ALPINE_ISO.fetch()
 
         self.vm.set_console()
diff --git a/tests/functional/test_aarch64_sbsaref_freebsd.py b/tests/functional/test_aarch64_sbsaref_freebsd.py
index 26dfc5878bb..3cddc082f3b 100755
--- a/tests/functional/test_aarch64_sbsaref_freebsd.py
+++ b/tests/functional/test_aarch64_sbsaref_freebsd.py
@@ -26,8 +26,9 @@ class Aarch64SbsarefFreeBSD(QemuSystemTest):
     # We only boot a whole OS for the current top level CPU and GIC
     # Other test profiles should use more minimal boots
     def boot_freebsd14(self, cpu=None):
-        fetch_firmware(self)
+        self.set_machine('sbsa-ref')
 
+        fetch_firmware(self)
         img_path = self.ASSET_FREEBSD_ISO.fetch()
 
         self.vm.set_console()
-- 
2.49.0


