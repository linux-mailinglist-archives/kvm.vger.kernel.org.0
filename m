Return-Path: <kvm+bounces-5544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCDF82334D
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:34:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DD0E2860E6
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993731CA9D;
	Wed,  3 Jan 2024 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m1NNKV/Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0581C6B7
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40d87ecf579so29155075e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303234; x=1704908034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cgT7e6lhcwn0WzM/v6sP8+3M2uDQNBjem+V+EXl+Sc=;
        b=m1NNKV/YkrcRIq14lL3fKw8daAQREQgl1ZESMkgm726XxE828+SZF17I7zXPRz+OxB
         O8uDKZZZuF6GBgHCKT/tbzxTY7yiNvErW9WtvTpJelv7M1Zm3t9PIwAIMn1320yuJbWz
         Acuf5rFYq6yKLwc45in4YydU3qQDx1s1L/ZcTxKX+meZcWKVBBL73yWEZsHeIBKvCZQ8
         3lnTDIHEUtGZXSLxtNNTYcrOKgTyHukDnc622hoa1R/EcuPYlMAb9Kzw0tndHAEtKmCm
         0xjNlL1x6b/aUBh+z3Kz719vfdOJpAGKHegwdnuQvxvxhH8rwObf+ugtsCgG80v8F1EI
         fS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303234; x=1704908034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1cgT7e6lhcwn0WzM/v6sP8+3M2uDQNBjem+V+EXl+Sc=;
        b=rFDy6kMW+loNFKLwT1Taw9vigatcrXUz2W8t+LkzBZxKnGrZy8IIM04/ycS9wsCvPw
         /aWEtJ8duyKhyipQ5m2nYXb/HP4MWitPpMakDIO3CQZB0FDblVYVuXZVZdzy6vDuVKCr
         35irsbGfmyC93OtuGdhi7km/cj6ULLJtT+8jEt4wzRhaaeFAAJXUUnoNkTVTgA40fTOD
         Y4lsNJHa6nLkjOc66/hUbbUIy/GAdFCwJ+APbjanhXHlXyhgexVN5MVEMmSjfYrA8Sm6
         oo76T/JyhGu0mM3lg8SLdF/Z3Z2FvCrzgSvFEMNKAjdUrkuba1djIC7moO8z3RCWjsCn
         ZxwQ==
X-Gm-Message-State: AOJu0YycNs2xqtTEn+1ZUo4kSkI+5SLCPK0X+gc06UmKP/rfOfPIUkx6
	nG/gx6uGhaJnfCmxd1Zjgyqo1N3emCDgnA==
X-Google-Smtp-Source: AGHT+IGkwXIQRawekDSFyRyWEKfYmmSXmGibqTrySkN7welWZBSJP4sDdxZro5vRiKtYsxi4fgV1RA==
X-Received: by 2002:a7b:cb8d:0:b0:40d:8501:276e with SMTP id m13-20020a7bcb8d000000b0040d8501276emr2069593wmi.130.1704303234402;
        Wed, 03 Jan 2024 09:33:54 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id g18-20020a05600c311200b0040d85a1fad9sm2964211wmo.46.2024.01.03.09.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:53 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C17AE5F936;
	Wed,  3 Jan 2024 17:33:49 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Bin Meng <bin.meng@windriver.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Brian Cain <bcain@quicinc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Beraldo Leal <bleal@redhat.com>,
	Paul Durrant <paul@xen.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-arm@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	John Snow <jsnow@redhat.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 05/43] qtest: bump min meson timeout to 60 seconds
Date: Wed,  3 Jan 2024 17:33:11 +0000
Message-Id: <20240103173349.398526-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103173349.398526-1-alex.bennee@linaro.org>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
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


