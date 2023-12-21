Return-Path: <kvm+bounces-5036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C6B881B3D7
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:40:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E83C9280EAF
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4CF745E4;
	Thu, 21 Dec 2023 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AR0J/qnw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81067319F
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40d05ebe642so10300275e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155114; x=1703759914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRw1//+81PB5ZNvZJSTSQFwoG2tqKVRM/U60AtyQst4=;
        b=AR0J/qnwXGAIokZAdD3A2GLtqjlPDnEwFs/LEvCXchjaqKr38oGMoGh6HFYb0t0wQ0
         x9hxqWs1SQxhJUpaO1q2rWRxq5y9VQ9xnky1vz51Mcy/9/604fuaMynN7dZaLfmifS7R
         WxewEZfrQYupZvrxXgo5v+QQwaFett9zjLXQCyVzaQzqL06N+A7DhyflxfCrgkRzlVlp
         ZET8unoii7+kzp99s91DgNxhKoNI+09z4Bu+DfilgpzYC1CWdtemElO9fkuBdWAW/9cA
         1pNtwDgrp8dzzHQMfHU/L3v1N8y/MM4gxZ98RQEqDoNwV+f+qk+w8JaUPCuvaJgHldmZ
         Ym9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155114; x=1703759914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wRw1//+81PB5ZNvZJSTSQFwoG2tqKVRM/U60AtyQst4=;
        b=FDAHy9vP0EU8xg2UFbZ/VMyH/z1TDf30uxkKgiLm3ULltiW43BC4VarsweTzGZVETa
         ztbIWQMIPQBBmgjskNni1E91XMCvkcKhPjBiY72G8FO9AG6jJe5hIkBs/+HcW+us8Diu
         Qa4XUuv6nHWD99cj2hZj3tKouJX5CkoJiABKIMvFJIO5dn5Pvct8HKMMSUcsJlR0Pduq
         sSZbGB0+hbgbxx0qyNyaWFKMc4qzNdtNyQRE+Y041zrb/O/tmEDeKtpLD4EmgRfSlPSa
         Il5S0shY1CQWtrY7FcyJSn9Jv8sJs2LxfT+gy+Ty2gQGbiliJwH9tYuqnB4ci/D0T9Nr
         z9Og==
X-Gm-Message-State: AOJu0YzcI9/T5m+vmwjanYbOguemwMuRJGBwlxu1YsXGCwEbcZu8G16A
	DeNETN90pfbCEb1iQB0vrDBaSw==
X-Google-Smtp-Source: AGHT+IFUDT42ZfgxAq6eYw2wg67I2vRT0RkhbKrIwr7L+Dl+ovwJ7TZlueXf4epnlhr2FkleOOHAug==
X-Received: by 2002:a05:600c:474d:b0:40c:262f:3c14 with SMTP id w13-20020a05600c474d00b0040c262f3c14mr317513wmo.109.1703155114132;
        Thu, 21 Dec 2023 02:38:34 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id k13-20020a05600c1c8d00b0040d3dc52665sm1814454wms.21.2023.12.21.02.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:29 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 175685F8AF;
	Thu, 21 Dec 2023 10:38:20 +0000 (GMT)
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
Subject: [PATCH 12/40] qtest: bump boot-serial-test timeout to 3 minutes
Date: Thu, 21 Dec 2023 10:37:50 +0000
Message-Id: <20231221103818.1633766-13-alex.bennee@linaro.org>
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

The boot-serial-test takes about 1 + 1/2 minutes in a --enable-debug
build. Bumping to 3 minutes will give more headroom.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20230717182859.707658-9-berrange@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-9-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index c7944e8dbe9..dc1e6da5c7b 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -6,6 +6,7 @@ slow_qtests = {
   'test-hmp' : 240,
   'pxe-test': 600,
   'prom-env-test': 360,
+  'boot-serial-test': 180,
 }
 
 qtests_generic = [
-- 
2.39.2


