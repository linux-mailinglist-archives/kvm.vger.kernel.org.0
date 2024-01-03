Return-Path: <kvm+bounces-5566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D80EA823386
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 771DE1F21672
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974381CA85;
	Wed,  3 Jan 2024 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NosM8vEe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570C91C69E
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40d60c49ee7so57992775e9.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303550; x=1704908350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oeKurO18PT1xLzL5iQamunNBev09YXep7NV+pG6wspo=;
        b=NosM8vEe5Ejoi99S5R6P2k6pg+5cKelJajrqY0PewR38J42QJsSY+uJpBxo8/800WZ
         92OPzIjk9s88c1UrRhLm9yBcYAYePnVQDM9mUIKMjitt3BBgd042AlpK6r6OROkXYWGy
         oBX0m4EKUbSEWjBUnxDnc5sytRB/gCCmp839f0G2iYYEZd63TeSWwdMBYkLdj7AMIS5P
         3Tw2uALud+OZnudQ1TMcW+wP/3/rrN8RKkgKTLAm4F8FrEp+hv5u6H65vYytoAsyfFMj
         fa0OGMhyxGyAqcGiu3Ulim13XnYj7TKzNRYIlZg24r+JKCC76uC5JhXM05b8RIJ5e5bV
         S16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303550; x=1704908350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeKurO18PT1xLzL5iQamunNBev09YXep7NV+pG6wspo=;
        b=UWkuLwK1nW5rbh4Ri2YQh1JboXmLNot+oeVitMNSLyCFBHqroVU2x3nm3pcvFqNxFt
         V32z3hlDTI3ONHqX8yQU4ra8lc4mTVhb9ayRi9CdFDGE3O2guT6JkMLeot+x0ldBYr5o
         v5DaZsmkC6Q24yA4+lW3Rg/qtywErimSTRP8LCioK905uT7fTX33X5XQQ19bDji+lbL8
         jNP/IbSDx3TOFR6p2ckpHmYNp2Q5Uws+WZIzFrpH0O9eAs9AQC1ulhwaia3ljL9TakBM
         UyHuMS2sgGVnGYn/IQoyOJGSaTlT9m+c+2h3qx0/g/5y8j5Gx0IUBnzS/hEjxGRS9+mO
         deCw==
X-Gm-Message-State: AOJu0YwnpPndJ0qq/GJDgImJb1icz+dyBgr7T37IUSWf2DpStUCpM7OG
	4jwMDsRc12rGnsRl4pfOeRKxJvFKwDmu7Q==
X-Google-Smtp-Source: AGHT+IFr7TkHDM4WWp1TO9UpDh2cwaH7JdhPfjki/y18qhHSL+e3Ga994DayBnr9oQrGy3VPOy05Xw==
X-Received: by 2002:a05:600c:44d6:b0:40c:78c:f864 with SMTP id f22-20020a05600c44d600b0040c078cf864mr10710339wmo.16.1704303549769;
        Wed, 03 Jan 2024 09:39:09 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id fj7-20020a05600c0c8700b0040d77ebd55csm2974477wmb.13.2024.01.03.09.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:39:08 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 12EF95F94E;
	Wed,  3 Jan 2024 17:33:51 +0000 (GMT)
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
Subject: [PATCH v2 19/43] tests/fp: Bump fp-test-mulAdd test timeout to 3 minutes
Date: Wed,  3 Jan 2024 17:33:25 +0000
Message-Id: <20240103173349.398526-20-alex.bennee@linaro.org>
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

When running the tests in slow mode with --enable-debug on a very loaded
system, the  fp-test-mulAdd test can take longer than 2 minutes. Bump the
timeout to three minutes to make sure it passes in such situations, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-16-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/fp/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/fp/meson.build b/tests/fp/meson.build
index cbc17392d67..3b7fc637499 100644
--- a/tests/fp/meson.build
+++ b/tests/fp/meson.build
@@ -124,7 +124,7 @@ test('fp-test-mulAdd', fptest,
      # no fptest_rounding_args
      args: fptest_args +
            ['f16_mulAdd', 'f32_mulAdd', 'f64_mulAdd', 'f128_mulAdd'],
-     suite: ['softfloat-slow', 'softfloat-ops-slow', 'slow'], timeout: 90)
+     suite: ['softfloat-slow', 'softfloat-ops-slow', 'slow'], timeout: 180)
 
 executable(
   'fp-bench',
-- 
2.39.2


