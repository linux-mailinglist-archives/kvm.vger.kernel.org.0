Return-Path: <kvm+bounces-5552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D78E6823359
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 600C7286236
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4821D54D;
	Wed,  3 Jan 2024 17:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LViPya4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD4D1D52A
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40d5d898162so51172165e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303242; x=1704908042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NG0GNTBkS5OA4bLgzcXFuNl7bQt30v5WL9SIW527gOo=;
        b=LViPya4x848JqX5CprLMs5WY2Mu2g3wTgmCOuM7gwHi0aq2x/dWxH3pZBZThZsxOMd
         DLUKYb6JVrOOHM7TFpaEnCfGUrEQtar4byhheX2SkFhcxxaBmr4S6ZzQbw5/HrXbgqyP
         FOwawgRTv97MpeUkf2mAncSKWKBqyyg+G/HGj77lUog+8I6ErEeR+8f93NzZDOt7jIsq
         NWtjpUcG/jM8Gb7IYQdqtRoG3uxL1LuSwDwmFIo6Zwlm9myr1F4DvtnOR7oadMJzSMWs
         ZrKPM32054yYwp2w0LMcpmrFP37Wy5jK8OlefHBPSar/qGO4XzkGq0jmJSHU8B6Fp79X
         2h/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303242; x=1704908042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NG0GNTBkS5OA4bLgzcXFuNl7bQt30v5WL9SIW527gOo=;
        b=lzRNJKrPdyKkzW4ULstpydtYqqeD9te496dqsDPVdanovS6uq7XScT6ANOoQiNU0RH
         IBYMpAS+4ZfFG03A4p4TYUThAeJJvqaGMaRlznVSX/UBXqUGjpRteaKKAwC3AZGWXM2f
         +JyQl9s/XDwMaP7+dO9wdh9CQ0dlm169yVyRZzXB66r4Z4XsDuL/5ctY5E/q84vr+8vG
         GTV6T6kcShRSWgum6lSVzaSFCpHs2FRSilMXdJi8zk0Q76O9UPLW5q1qn2rNBAG8wg0v
         uqjUYl85FucheesfEw5dyiz7Bv2CGLFqeYqMSUVV9GXvv3ndzJTE4nVBuS++tPihvmkX
         mFPA==
X-Gm-Message-State: AOJu0Yz/4LFuCnihYNMd1ttDDT2B7hWo6VPZEzvW3CqhlMev35SPopQh
	xwdwy2vS0W+HU/Ic3Im2MTqAxnp7ftHQbg==
X-Google-Smtp-Source: AGHT+IEBcU3HIt2kk3f3ka5JNEGbknZiuar/K/H51Rdj+QmKRU4GX1U2mGMWQY7DZpu51o+Llv5W6Q==
X-Received: by 2002:a05:600c:524c:b0:40d:42de:46f with SMTP id fc12-20020a05600c524c00b0040d42de046fmr11584360wmb.1.1704303242245;
        Wed, 03 Jan 2024 09:34:02 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b0040d839e7bb3sm2954439wmo.19.2024.01.03.09.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:57 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id ACA435F946;
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
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 15/43] qtest: bump bios-table-test timeout to 9 minutes
Date: Wed,  3 Jan 2024 17:33:21 +0000
Message-Id: <20240103173349.398526-16-alex.bennee@linaro.org>
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

This is reliably hitting the current 2 minute timeout in GitLab CI,
and for the TCI job, it even hits a 6 minute timeout.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Message-ID: <20230717182859.707658-12-berrange@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-12-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index da53dd66c97..6e8d00d53cb 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -1,6 +1,6 @@
 slow_qtests = {
   'aspeed_smc-test': 360,
-  'bios-tables-test' : 120,
+  'bios-tables-test' : 540,
   'migration-test' : 480,
   'npcm7xx_pwm-test': 300,
   'qom-test' : 900,
-- 
2.39.2


