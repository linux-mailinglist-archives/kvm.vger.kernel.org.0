Return-Path: <kvm+bounces-5553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B86A382335A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 759471F24E5D
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2E61D552;
	Wed,  3 Jan 2024 17:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P1WyARUb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141901D52E
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40d87df95ddso27816205e9.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303242; x=1704908042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7XkKmTa2rk3nK9lrhGULgV33LxXcjUpugmHNR7vUhY=;
        b=P1WyARUbAjWfGedwOXdGTmZX8FAwT+V7ZIaFO1HC/CLy13KIBM+HCNhXQktMyb/31w
         j6NgePLnr0FkXZW1FmC2nHc1g7SAYy6SbtSJhYP7UBw+CpWz2/zhh5NsZA4xMmPnIs/S
         4x0H+3EGZcJU0Mgx98oK6p5mBBFJ7PSbgXwW50VLdqnSdYRaVJEUt00bjDPhvKTvjQrp
         ihrXDl2XTxHsgNkTVMGvGizzUrWf0xATUxpBs88Da7y7fiKUE7nkqoVVxS0s3OOW58A/
         DBYQsjp8lT8//qOVMPvbdkfe7+7dkENgxbtAk+tRA+TQGVQzMrR1tT+PxJWrp3M84anh
         Heow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303242; x=1704908042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7XkKmTa2rk3nK9lrhGULgV33LxXcjUpugmHNR7vUhY=;
        b=Ay4YQLrDvkxKrwRDNDWixLH0+rk4YpypS29dXu3GSOii0+dNE5eEnC36EyjDl+X5sV
         qBskeAfdMobWjVJbj0Us9r2Q0dkf3w4aFTOpiAk6IyqpmQ1SlWdN88KROpIisIn/S94w
         yo75lmdVNatg93fId/ny8dm0jh+PQD1T/mBIl5IPlIF41wqYh7q9xgZR0FkEA0shBfBh
         xITQtq/nZK2Jx32qPu+JOXqGfwTfq8XdH6XTqsy2DjW7BjKg8gQF3DzGZXeDR+xzVsaZ
         70YkoE/6ZwEfnhV6i4NPrsEA7n03cBP4wMMjSWldUbzWlltKGQcRK+sEAKrMo8U5d4Cu
         NaMA==
X-Gm-Message-State: AOJu0YxBZVST+VBo49KvJh/WKA2d2ow35uXx4/Rd9kH/mKZrM72rIIUs
	VuX1egM0g7Rg7BzXbvoU9kzWeZtxJ01j2Q==
X-Google-Smtp-Source: AGHT+IF/L2p0zQ5EsxWm/ZeewITkxLw43+Hum/+1n38RYmruA0nJMBDcBTcvxGZi4eR6abvI1/ZlBA==
X-Received: by 2002:a05:600c:154f:b0:40d:5f55:663 with SMTP id f15-20020a05600c154f00b0040d5f550663mr3068051wmg.94.1704303242496;
        Wed, 03 Jan 2024 09:34:02 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id q17-20020adff951000000b0033718210dd3sm14497665wrr.103.2024.01.03.09.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:57 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C30C35F948;
	Wed,  3 Jan 2024 17:33:50 +0000 (GMT)
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
	Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH v2 16/43] tests/qtest: Bump the device-introspect-test timeout to 12 minutes
Date: Wed,  3 Jan 2024 17:33:22 +0000
Message-Id: <20240103173349.398526-17-alex.bennee@linaro.org>
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

From: Thomas Huth <thuth@redhat.com>

When running the test in slow mode on a very loaded system with the
arm/aarch64 target and with --enable-debug, it can take longer than
10 minutes to finish the introspection test. Bump the timeout to twelve
minutes to make sure that it also finishes in such situations.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-13-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index 6e8d00d53cb..16916ae857b 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -1,6 +1,7 @@
 slow_qtests = {
   'aspeed_smc-test': 360,
   'bios-tables-test' : 540,
+  'device-introspect-test' : 720,
   'migration-test' : 480,
   'npcm7xx_pwm-test': 300,
   'qom-test' : 900,
-- 
2.39.2


