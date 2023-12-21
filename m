Return-Path: <kvm+bounces-5029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFDA181B3CB
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C10E285271
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A9F6EB4D;
	Thu, 21 Dec 2023 10:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="azZLV9me"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334F76DD1B
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40d3352b525so6433645e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155107; x=1703759907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CaH8a0Z2sktOk6HhcvLcaTrwfzviKqp7ItoU8rNpnow=;
        b=azZLV9meJGVToWnhRhWa7DqGyzRmy4+HxYqeg7qnZyWrAn2X20oPqj9ZDwkVX05V2v
         hiFAGGqp5tlcjpD2ZNgMTOiKFksR5P4ZjHq+s8FaXcqK44pKBJvizgAUUxUUtyscuP3k
         mrEp78t8FSdMe/TgvRkNBt8yyuMB4mzpFxN4Uga5GK+HpfU6T3rA8pfibaZyqvmRzOM6
         ADBFIYzDiHyHog3mEyX/4812acNTznd30Uq9b8bUzJQlaEZOxORk9GT+GVevAtxqMm22
         2ECSaWiH9jWFsUiW+59Vq4XRGwo/HXimSVvOCjjdj48iew1dbJPs860yn8REEiCI61a5
         Wieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155107; x=1703759907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CaH8a0Z2sktOk6HhcvLcaTrwfzviKqp7ItoU8rNpnow=;
        b=GYHoJAb6BBGPCa/6AUm70CoQZndMjBEelCkzlPUxSKo+HOFja3m5g05YHZf5nVct4Q
         Op4EuuDbikOMQi4UHKilAFpVlePEfKHOnDGzRqZSiZQarY7nyIsJRqFevop0w0zgn2yl
         dOhX25++3tH4pYULS3iMzt3/5iZ5jKnYwFtRb9XBQAhykHUlMMW7TtP52NxhcfmKLyTz
         3O+z+pOnVuB7kUXX+OrtkXwQ7Hg227YVBe2clUZ1aaq3Zpsu9gIBcyxdT1IxvHsNxkgf
         qKhd4zF38iFg3Fx8Gxg5kaVe+5m+cpeQV6wM8MqMKgcDgj/QwadDc8A/Hmi7bq0gLj/h
         t9kw==
X-Gm-Message-State: AOJu0YyIyIsQDK/2mjvPh7rr6qzi1LQZ9cJUdAatxZdH0qAzIMfmpN4t
	3gAY67JycPp15FaF0Pg3Hv+08w==
X-Google-Smtp-Source: AGHT+IH9UYY7nDpturwPwVgfN1wQh5wud+cCc1FCBGp1qeGHyRPqqOwQjcUbg93xcGLmfOziL5lR5Q==
X-Received: by 2002:a05:600c:1911:b0:40c:30e8:fc5f with SMTP id j17-20020a05600c191100b0040c30e8fc5fmr601578wmq.90.1703155107622;
        Thu, 21 Dec 2023 02:38:27 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b003366da509ecsm1712592wrq.85.2023.12.21.02.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:22 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B0D745F8CF;
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
Subject: [PATCH 08/40] qtest: bump npcm7xx_pwn-test timeout to 5 minutes
Date: Thu, 21 Dec 2023 10:37:46 +0000
Message-Id: <20231221103818.1633766-9-alex.bennee@linaro.org>
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

The npcm7xx_pwn-test takes 3 & 1/2 minutes in a --enable-debug build.
Bumping to 5 minutes will give more headroom.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20230717182859.707658-5-berrange@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-5-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index 000ac54b7d6..84cec0a847d 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -1,7 +1,7 @@
 slow_qtests = {
   'bios-tables-test' : 120,
   'migration-test' : 480,
-  'npcm7xx_pwm-test': 150,
+  'npcm7xx_pwm-test': 300,
   'qom-test' : 900,
   'test-hmp' : 120,
 }
-- 
2.39.2


