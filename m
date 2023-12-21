Return-Path: <kvm+bounces-5035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EE281B3D3
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 116A21F2520A
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C5B745D9;
	Thu, 21 Dec 2023 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e0vOIGWx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967D57319A
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40d3f2586d4so3407995e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155114; x=1703759914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oeKurO18PT1xLzL5iQamunNBev09YXep7NV+pG6wspo=;
        b=e0vOIGWxXRA2TFRndhHY8O/00qcee/G6hMb1eUZMhboPi8ZQWmRzOYoxBANGkBvb3d
         mMBK1M1gG7LVrNE/Sgok0G2mdL0t9ztEwcAhmLj6DLeB4n4LNy8M+igKSB65LUrb1u9s
         3KaMjYgjzxd5Ac4sH/2d97ggihf4bDgN81x5ubpzgDwXs9k843nw6lLrS7H7qODD940l
         iPQn/7YGE0YXq620EbvNukMIdGCl4UORKLJk7Rd5S2KQaxLnHbmeneWzu2sABPQXdTQn
         h43V71wmM64tWPVGzPa9UeH6mRnns8oT0X+HS7Y5KtHt+dSU4EjmM25DMuFm2d5LsVu3
         ts4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155114; x=1703759914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeKurO18PT1xLzL5iQamunNBev09YXep7NV+pG6wspo=;
        b=UATqc4s86YSRV0mgK4Y7bC/tD5A1uAeaiFbie5INRuaEsuRgmZdSkUDLoXjkZu+FQO
         XdR9+3laTWbxuheQMTYgN0r619qJDOYA18s/NEjakJupJF9XO+q6iAoNkImb5YoTF519
         rgFo82cYJcvrqcUqCMsoaj0Ur0wmz3I5m+/CGuGI2VZdVTAgjQiDhgXPAZ/mtE5Ut3e4
         AbReFoOSxlVRPObRKdWk9JI1F/oQKhqq1zNyer5mIv/pBjV9mt1UM48+jPgNXD5X0KV9
         BcXSWGdNkVmPSmtEVOPJs7HopI4uP/405hzTHGYSpxmci7XX1pwACwgY+XsUFnb9NdO0
         XNSw==
X-Gm-Message-State: AOJu0Yx1RqUlA8j29njFPDzbYIS0TN2961GlDEHFBWwrHHh1d9B3VHpc
	SV7mel5pHtJ5DXqW/FQa5OB4Hg==
X-Google-Smtp-Source: AGHT+IEDw9S3TarblsmJZYT54zqBYySCojx04X6aERE08kCaPWULIdSrrrthFqqDkUid6eRtO2RAUg==
X-Received: by 2002:a1c:7209:0:b0:40d:3823:5e0e with SMTP id n9-20020a1c7209000000b0040d38235e0emr586756wmc.140.1703155113939;
        Thu, 21 Dec 2023 02:38:33 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p2-20020a05600c1d8200b0040596352951sm11263469wms.5.2023.12.21.02.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:29 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B86145F8E1;
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
	Bin Meng <bin.meng@windriver.com>
Subject: [PATCH 19/40] tests/fp: Bump fp-test-mulAdd test timeout to 3 minutes
Date: Thu, 21 Dec 2023 10:37:57 +0000
Message-Id: <20231221103818.1633766-20-alex.bennee@linaro.org>
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


