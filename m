Return-Path: <kvm+bounces-5032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 826A081B3CE
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DF70282009
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B3F73190;
	Thu, 21 Dec 2023 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m2Oj/rCd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A0F6EB75
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40c41b43e1eso7594165e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155111; x=1703759911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqrDXpkh9FjMlfAgHrjndIlqPg75eovfRGnZr9OF3KY=;
        b=m2Oj/rCdjFlzRDHpWsiIslVEoEcG9y39AXxCDXVmFIKXepdW22+n0tE6KSIRdbbEWO
         pktgmWQnn5t1nes+vf+sy0nCOgStmPrUgg0v+rrv8c/Ec793trxOZtstteGLHSK5oZKo
         kCEZ1d0gD3cbSNhvnOpjcYFNanPPzZCRsJD2glDtjPS+3QyPvPvclKqqVjDn0YiTBdk8
         Mb2cLd0Pc16n70AGH7NzpvsBUcHYMzlPZVnwyOZVyE1XM5BDWHfLpxCmePqk1rvzukSz
         isAHFaLdKfSHnLVwRR5C5fMrPrDCMEHmPP19f4fPsdgJ+76rIveSoICuXkC+ZwPWJDoa
         iWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155111; x=1703759911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqrDXpkh9FjMlfAgHrjndIlqPg75eovfRGnZr9OF3KY=;
        b=WpgDe5zK/g8yCLVOiS+d9zOER2bLgoLCg6GgswKFjVTEh3akE/M1Oz3J0Q5SOzqes4
         GIiSOreBXkOnJtHlScPIMrUlQMH/smkixDYHmqs2vGg1y4vUFBTbswgiVHBZE4ANx7xn
         UNiT7wwiCUjcGXwaKULiN5saIU4tqf6xqhk/PzYaTvMRMv4UEUfZDCJbEZ4PcpnDB/jy
         IqkVvfdm7n19u3YDgTquFP/WsmMmuvr+IekZjRxE6Yr15OwpL+B0AdjqYhNKxxtBr8ct
         GfZB7ZYAsxfXv1RDVjaceL6iDKKLsfh7Bius4AaMBclgVHsOTJXI+he5nLZpuIjZ45wP
         NJ+A==
X-Gm-Message-State: AOJu0Yw2z4V8HbGfVXyoebpjR9dnHaRFw2EP0gy0uYdY1pl3fIEHA9UF
	PkSAGRl/rzevWm/Rf+nusLkNzA==
X-Google-Smtp-Source: AGHT+IHbKond3XGMBOiEWjhJNY5ms+cvVejnRJSFH4DyRoMTJUtk09qi4u0EKL7LktfxjVkDvxDH4Q==
X-Received: by 2002:a05:600c:b8e:b0:40b:36e9:bf4b with SMTP id fl14-20020a05600c0b8e00b0040b36e9bf4bmr591312wmb.41.1703155111042;
        Thu, 21 Dec 2023 02:38:31 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id bi18-20020a05600c3d9200b0040d378623b1sm2793725wmb.22.2023.12.21.02.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:29 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 46A945F8C3;
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
Subject: [PATCH 14/40] qtest: bump aspeed_smc-test timeout to 6 minutes
Date: Thu, 21 Dec 2023 10:37:52 +0000
Message-Id: <20231221103818.1633766-15-alex.bennee@linaro.org>
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

On a loaded system with --enable-debug, this test can take longer than
5 minutes. Raising the timeout to 6 minutes gives greater headroom for
such situations.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
[thuth: Increase the timeout to 6 minutes for very loaded systems]
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-11-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index b02ca540cff..da53dd66c97 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -1,4 +1,5 @@
 slow_qtests = {
+  'aspeed_smc-test': 360,
   'bios-tables-test' : 120,
   'migration-test' : 480,
   'npcm7xx_pwm-test': 300,
-- 
2.39.2


