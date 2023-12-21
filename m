Return-Path: <kvm+bounces-5050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B276081B434
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 446F2B24F0F
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E176E5AF;
	Thu, 21 Dec 2023 10:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ty3RkM+d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375166D1A5
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3368c5c077fso149431f8f.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155624; x=1703760424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G1gJobfuOXArDzvCmnHLIGQ5mswWRXVhuXYUXNww838=;
        b=ty3RkM+dtOUBCSQZGv9zIQtd20UxTuxYXlQdFBaN0PcHf9a/ptW2WOik628oAGLvwQ
         SuEa40As9TwsbmYO7V4DpiArq+86wdCLYizZZQBLybGuehUGHHlM0SqlT55gIX7JaC3m
         JC28CiwtNUFSL7BA34P2ZhWisxS+bVyyxA5XpSb0KcmN1TyAK74uyOA0YJPHQ8G/Jz2D
         Q8Iy9IeTnRP3fOZJ/l/r/cJ3X8bfQMEicdA+xLMolqOAXgMjMTlvUa62w2OdDPJ434mi
         VSjiJ1k54O0HHA4c5DqcFqYnoRVoM06n1sIeLeceFAoXXcbSsETWd9Jadcwk+YL57+Qt
         HnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155624; x=1703760424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1gJobfuOXArDzvCmnHLIGQ5mswWRXVhuXYUXNww838=;
        b=cKVvVQ9moHlTLGyZ48ks7hfLvxOBOaxirfKrf2JcWGcfa5EiNns234pGsz0GMOtHn5
         Tnt3GHo4DETy9dsSCNMRiqJrPZd0zqrQvyjbpCZMOkYCFg2AxK493d076TRq4bfmX4DC
         6ekQBCq+er5GQCNLuQvLxJ2BiB3JPxdasr8oxHt8SYB/NAfNSJh4+Lp4Pm0hZtc0ws3k
         C8mvFgt+r65jOLr/9qNjKTdgLdnohEDsdL0TDp5boCFQ0qsGZPGgizuHLAGDniA4I/Ac
         2tyMt5WJeXhB9JStIPZm6JRDPkEo0+kwq09bLOGWTIWEjIvU24UXY9fWzs6PEykGgbSf
         zsug==
X-Gm-Message-State: AOJu0YxSaxXjHs99E2kSRYBJIMA0Kuth9qwS7AkeCaRtu6BArD3nGx/j
	vGp2eSVSBuaRLmGTVANZW8ZRPg==
X-Google-Smtp-Source: AGHT+IED7W/Wstnfv6IDEwnAT68FgWsu2mPNcb9+bhjBkxHllorFtuGUm+5aJw9r5ocGmDbjgEoOxQ==
X-Received: by 2002:adf:e50e:0:b0:336:79cb:9c3e with SMTP id j14-20020adfe50e000000b0033679cb9c3emr319882wrm.98.1703155624292;
        Thu, 21 Dec 2023 02:47:04 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p7-20020adfe607000000b00336843ae919sm1571022wrm.49.2023.12.21.02.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:47:01 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 8A0115F8DC;
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
Subject: [PATCH 17/40] tests/unit: Bump test-aio-multithread test timeout to 2 minutes
Date: Thu, 21 Dec 2023 10:37:55 +0000
Message-Id: <20231221103818.1633766-18-alex.bennee@linaro.org>
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

When running the tests in slow mode on a very loaded system and with
--enable-debug, the test-aio-multithread can take longer than 1 minute.
Bump the timeout to two minutes to make sure that it also passes in
such situations.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-14-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/unit/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/unit/meson.build b/tests/unit/meson.build
index a05d4710904..0b0c7c14115 100644
--- a/tests/unit/meson.build
+++ b/tests/unit/meson.build
@@ -172,6 +172,7 @@ test_env.set('G_TEST_SRCDIR', meson.current_source_dir())
 test_env.set('G_TEST_BUILDDIR', meson.current_build_dir())
 
 slow_tests = {
+  'test-aio-multithread' : 120,
   'test-crypto-tlscredsx509': 45,
   'test-crypto-tlssession': 45
 }
-- 
2.39.2


