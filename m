Return-Path: <kvm+bounces-5547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E52823350
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E1C5B23B16
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916F71CF8A;
	Wed,  3 Jan 2024 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kQhqKTsu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D02D1CAA8
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40d3352b525so116667405e9.1
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303237; x=1704908037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7IelmqBfCUiQPJ1PO4YXHkz0msSivdOvYJRQon3tbw=;
        b=kQhqKTsuxyTJ0vorc5wdhXz8ANjWrkWcA0KloBcoxwBDvSg5voRtaqT2B4e11MIswZ
         t+OHy/t+/zmt1f3kFLkcMcOzLJiL6RRteH0U4RCahqr5tnFRJfRnxRUujOvGh3t7aunT
         Fg+B1A6GJ6B2+CQx0vcwSWJWQ77YX1sIJdOXS2YILnp+I4jH9bBcnD6DzC4cmIgQgkPs
         X5ns+9g6NvQiCmB86QjjHIRg2sXIeyVc6VSL1OjI2HjeM2N09wEH16KO9TbP5T2TxARG
         /UrK+Z1+uyPKv5FP9r0TXcwB22jTZK58yff62FxDpL/BZtSQLvpTXqkdevTAHIy3qX6v
         hM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303237; x=1704908037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c7IelmqBfCUiQPJ1PO4YXHkz0msSivdOvYJRQon3tbw=;
        b=gys7X4UzyWM7wmYlqq+7sKehq2O78LPXQ8XtM90nvGg1l6mhEpYwD2unrT/hHlYPVN
         70/cJlPGHk6TYca3l0I+PRjiCzCCYrlWTq5rg0B05veSeBLPMN2DskjSNunipeW5H9hl
         K6cGoLce0sSYg/COiecEo50w3aBTgyHmpnnaAt3INIqrTRkpixTAfFVuabAFXt+duX5l
         yZ9V8fzLIeIP2aAHuu+IyEuPsXToDf+PjQ7kS91GqufqLlZ9qeLVOEiRW1O3jsOiUjF6
         0rwuPUoBdc2WxJbii2iIjZ0z4lF5UMsVuKUBfldS8Mu3Wgi5NWbuYd3eW7PGEhQ+eR8y
         ptVA==
X-Gm-Message-State: AOJu0Yx5Lh5WHpm6dgtkkaIYiiQKJifr3IeSbMv5WEP+w39OlUCFtn4u
	PByz+hpVIOYhkpGnlWfWPi1w+/2fyWRTcA==
X-Google-Smtp-Source: AGHT+IESFF9+b5o3/ublAo/jcBFbD7HOqmfsD+g0Mklv3iiREEvayIPCsKKh6n9Wfcqv3HzjL9ElUA==
X-Received: by 2002:adf:e8c2:0:b0:337:5131:4d71 with SMTP id k2-20020adfe8c2000000b0033751314d71mr1857wrn.40.1704303237615;
        Wed, 03 Jan 2024 09:33:57 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d4612000000b003367bb8898dsm31262714wrq.66.2024.01.03.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:54 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 26B495F93F;
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
Subject: [PATCH v2 09/43] qtest: bump test-hmp timeout to 4 minutes
Date: Wed,  3 Jan 2024 17:33:15 +0000
Message-Id: <20240103173349.398526-10-alex.bennee@linaro.org>
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

The hmp test takes just under 3 minutes in a --enable-debug
build. Bumping to 4 minutes will give more headroom.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20230717182859.707658-6-berrange@redhat.com>
[thuth: fix copy-n-paste error in the description]
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-6-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index 84cec0a847d..7a4160df046 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -3,7 +3,7 @@ slow_qtests = {
   'migration-test' : 480,
   'npcm7xx_pwm-test': 300,
   'qom-test' : 900,
-  'test-hmp' : 120,
+  'test-hmp' : 240,
 }
 
 qtests_generic = [
-- 
2.39.2


