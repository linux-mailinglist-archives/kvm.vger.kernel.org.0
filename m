Return-Path: <kvm+bounces-5024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7865481B3C6
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC991C24AE6
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BBC46BB4A;
	Thu, 21 Dec 2023 10:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LluEzNwE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21926ABAE
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40d05ebe642so10299145e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155103; x=1703759903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cgT7e6lhcwn0WzM/v6sP8+3M2uDQNBjem+V+EXl+Sc=;
        b=LluEzNwEJUdAYm2LLkyh53dCOa0rbkle0vRKlKA4Z2kpr3a+GaEbrd+TSLZuSSn2GL
         1pM0krbeD3nOHCGj26Ed/G4+ra+BrsYCFnjvLFA9wp14kd/TfGomL5J0fu2V97VByJFB
         dto316luoSFf2jwh5IzKf6ujzqaTnErF/y3j732paQGZHfqBglVWQYj9bdWCYO/Wxy93
         QjGmvCRTsJqurLpRPXO6jYRFB9m1H3AdNJJBDjvd+1JMf7uIPeCM8UhfIwxPlfJwdRp3
         +Jj0BLUiv0feJmqfyhZI7V61Wt3EMEffBDqW1EvmXkV1CHqy/Ga2nbdWPbFoiLSG3I2G
         voyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155103; x=1703759903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1cgT7e6lhcwn0WzM/v6sP8+3M2uDQNBjem+V+EXl+Sc=;
        b=cqdIKDT27e0eO4qpr3dVFa8xl3k20KJoLWNV0BqfbFxFeISBNqJ+sWuJvt+cxBnBQ9
         sLtEEbDj7rcHzoPPPADJ23U85lMW/RN+56TtedrY5IrYy7uUw3iu3Divy7anFj9e5b5L
         3kiO4OVZVgRjk/Zik9GJBNpp8x9O8QUVma8Y6CSycgu96+LJIIPxEZZC7MWSlKSLwfGk
         miEj28w7QR30FLqBnHNE5F5ZQOk7eRPtV7F0hpqPjGlo3tuNMS+iI7uXU5Cj8y7LvN/9
         W4bsoc+U0TsoXyvi5FAH3cPTN2GshUjRyXkL/TMTJr14K/AsjdL+QwAWCIbNuAF5YM8V
         nLaA==
X-Gm-Message-State: AOJu0YyZl8AleN2GmDhJDnSeWBvuxOX8t9vNTEz2xhgoyyDUMVsiBsTS
	Z4nQ7tcLZ8XBEz/zge6mk9khtw==
X-Google-Smtp-Source: AGHT+IHt6DJEYKfpQux8XnX/Pae/m4+RIj/y0UWX6dLA6GOiTEpo8qd26PDVFX83nnqjF6bFCABiTA==
X-Received: by 2002:a05:600c:a3a0:b0:40d:2dd9:dac5 with SMTP id hn32-20020a05600ca3a000b0040d2dd9dac5mr323472wmb.97.1703155103125;
        Thu, 21 Dec 2023 02:38:23 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id fj8-20020a05600c0c8800b004094e565e71sm2824144wmb.23.2023.12.21.02.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:22 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 6C97E5F8CA;
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
Subject: [PATCH 05/40] qtest: bump min meson timeout to 60 seconds
Date: Thu, 21 Dec 2023 10:37:43 +0000
Message-Id: <20231221103818.1633766-6-alex.bennee@linaro.org>
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

Even some of the relatively fast qtests can sometimes hit the 30 second
timeout in GitLab CI under high parallelism/load conditions. Bump the
min to 60 seconds to give a higher margin for reliability.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Message-ID: <20230717182859.707658-2-berrange@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-2-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index 47dabf91d04..366872ed57b 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -1,12 +1,7 @@
 slow_qtests = {
-  'ahci-test' : 60,
   'bios-tables-test' : 120,
-  'boot-serial-test' : 60,
   'migration-test' : 150,
   'npcm7xx_pwm-test': 150,
-  'prom-env-test' : 60,
-  'pxe-test' : 60,
-  'qos-test' : 60,
   'qom-test' : 300,
   'test-hmp' : 120,
 }
@@ -383,8 +378,8 @@ foreach dir : target_dirs
          env: qtest_env,
          args: ['--tap', '-k'],
          protocol: 'tap',
-         timeout: slow_qtests.get(test, 30),
-         priority: slow_qtests.get(test, 30),
+         timeout: slow_qtests.get(test, 60),
+         priority: slow_qtests.get(test, 60),
          suite: ['qtest', 'qtest-' + target_base])
   endforeach
 endforeach
-- 
2.39.2


