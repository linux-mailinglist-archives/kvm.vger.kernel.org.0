Return-Path: <kvm+bounces-5026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9954281B3C8
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5597F282E35
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F396DCF5;
	Thu, 21 Dec 2023 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z43tWNBx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD8C6BB24
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40c3ca9472dso6871735e9.2
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155105; x=1703759905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+Zw2YkajEPYChe7VczIaT3yCibcEp4TlrDptH8Gvrw=;
        b=z43tWNBxrtnMno8W3QWNCHHWtOhE1coS2Wit4wDlRWXzcjFeQzJdPpBMsH8wqQmWOf
         dycG0otYlzge6xH5AhpqCZfObVdSm1jE9TtXEWVS9b82n20FALNxb9vYPkEYLSDhtQnk
         NUSq7XyJ2SQdQXLsMP2udNk2XpBAtJTUvew5GWQSeySnydsDyGaJojGodYyvbOluMINe
         dhmlq+febgyWWhlUHINwPUuhnFEo8GJkeDiE44+3w2Ums1BDkhvD/Y1LLj2lIBxNqFdE
         c18Xm+5rdsDwYdlq8jITpCLezFuqCwVZwKNAQIjIiVAC1bZ3P2gclwsq0yP5dLGidi3u
         0vHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155105; x=1703759905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W+Zw2YkajEPYChe7VczIaT3yCibcEp4TlrDptH8Gvrw=;
        b=VlJxzI+tQRMKOCPvI7++A56KlMDCxasrGM50LNnViPwJY0PsUXG5uXkrjkAzk3IYkm
         yyu3WEN6wsKVAqaHtaxTdc44fRzyzisxrrYEKQMM4bFN63lfvJ3XZ76rmnRUsmYqAPs4
         2B/QI4XSGGiRXASGxQVMTVQKhlLcM96A/HWl1kx6B6V+Y10A2oNTiDqDMhDffi9Brwr2
         zeumg79/CJ/G7JTtxrB0yAaaEfqdaPN4EvhigA+GL0oGTG1mbezT7zIwEdSFy+ZDWzVJ
         T7wNreIjbqTArJvItjFyuBbmgyc0ZAPCsM4x2TLdjA6Eot6hEz20NYJOszMD9ABZgyJB
         YWCg==
X-Gm-Message-State: AOJu0YyN3jynHHVx/m3ufuRJ8hRk3C4UtqzsKJyOIkbNXaXVnh2nIXrO
	mIS2SPS7zt+rGsJVqarVwXK4pg==
X-Google-Smtp-Source: AGHT+IHEemnxDaCmAIZT4QWVJgpaGR0bY8/ZS9ytXYTgtiLLrMK5C6h0ngFirdX2Hv8S2N/SuvErxg==
X-Received: by 2002:a7b:cb85:0:b0:40c:f28:4548 with SMTP id m5-20020a7bcb85000000b0040c0f284548mr465271wmi.271.1703155104924;
        Thu, 21 Dec 2023 02:38:24 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c510b00b0040b43da0bbasm2807635wms.30.2023.12.21.02.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:22 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 83CF25F8CC;
	Thu, 21 Dec 2023 10:38:19 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cleber Rosa <crosa@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-s390x@nongnu.org,
	David Woodhouse <dwmw2@infradead.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Thomas Huth <thuth@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Richard Henderson <richard.henderson@linaro.org>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Bin Meng <bin.meng@windriver.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH 06/40] qtest: bump migration-test timeout to 8 minutes
Date: Thu, 21 Dec 2023 10:37:44 +0000
Message-Id: <20231221103818.1633766-7-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231221103818.1633766-1-alex.bennee@linaro.org>
References: <20231221103818.1633766-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel P. Berrangé <berrange@redhat.com>

The migration test should take between 1 min 30 and 2 mins on reasonably
modern hardware. The test is not especially compute bound, rather its
running time is dominated by the guest RAM size relative to the
bandwidth cap, which forces each iteration to take at least 30 seconds.
None the less under high load conditions with multiple QEMU processes
spawned and competing with other parallel tests, the worst case running
time might be somewhat extended. Bumping the timeout to 8 minutes gives
us good headroom, while still catching stuck tests relatively quickly.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Message-ID: <20230717182859.707658-3-berrange@redhat.com>
[thuth: Bump timeout to 8 minutes to make it work on very loaded systems, too]
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-3-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index 366872ed57b..f184d051cfe 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -1,6 +1,6 @@
 slow_qtests = {
   'bios-tables-test' : 120,
-  'migration-test' : 150,
+  'migration-test' : 480,
   'npcm7xx_pwm-test': 150,
   'qom-test' : 300,
   'test-hmp' : 120,
-- 
2.39.2


