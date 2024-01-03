Return-Path: <kvm+bounces-5565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3380C823385
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AED0828668D
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9F11C6B5;
	Wed,  3 Jan 2024 17:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iMlio8Ie"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BC41C2BC
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40d41555f9dso107509285e9.2
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303548; x=1704908348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAHZvQIZNHRqbyqy5ojwPgGxK/S007kBQEH3xZgSzNs=;
        b=iMlio8IekdM3CYeTgCl4QQsdEUxarmDz3V4wa5FH7HnRqUQsY5UfoRazMvds8CXcdt
         j3DNIdtTNWHwt+06SmbqyjXtMzXtRl3ffvP+nyiHYM/wgMBRYVg4g89Xq1jgsXRl8QaT
         dy7UWJJ1j9REo8neZYcBVmd0qyWLo8ovP+9ZJqi82/SaKfTawBekFrZKKK/tWaYHDIS/
         xldTEkkA1bFC1szzgR9FsoO3UsXjPXRoayFzr1+29uIuG4bf4JGl9Td1UxBDeNvX4ZMM
         Yf3EAgfC3hzb2GH0Ltqg6+o/F7/cCYrS8TtXajHPo8bCH8V8V9FGJwCFY/ROkzOdgyxR
         HvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303548; x=1704908348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bAHZvQIZNHRqbyqy5ojwPgGxK/S007kBQEH3xZgSzNs=;
        b=L6Bh4na88kT6GsEryOMk118m4XxVamo2JKAJUg/bAFD05/I7PBYKQmLRK79rHrWmf0
         pC3ZSxFFdAri6MH/sCaATOh7L3RyYliDSwMnVW6PHfkoXpCdFXZubiMtt0w1GXDdZRI6
         eE+5wglV1kXFwBxJfo83iD7rrsIKWyrNCMjRTd2Z9IByO+ted/29yY3yTnMspGXoFWPF
         x2i0dvvoHp4AoUwzJj9Ed40y8feNcY4z3M1GkSo6waln3gX6UMd6Az9uvV+CEmOcmukx
         IY0pjb0NimTJpXN3P5wN1Qd8SZtSyBeILS+askhjag/7u1jLyrA6q0spz+ai8a2Gg5Y/
         t2rg==
X-Gm-Message-State: AOJu0YwcUeK0Ka+lNde/IACHwT3pEVOHp8GpJlwrsLwZWSziKwhW+OFX
	i/6yFbq/1MB5gKOYWMe9GNmKtddEslnVLg==
X-Google-Smtp-Source: AGHT+IH+4maMIBzTJ7N1PEvrhxWa7T7vfFwtaWKzwHjzicWz5J/l15SGoM3cw1O5Yh0uqgYYBdQYRQ==
X-Received: by 2002:a05:600c:3d8c:b0:40d:83c4:ff2a with SMTP id bi12-20020a05600c3d8c00b0040d83c4ff2amr3311366wmb.55.1704303548649;
        Wed, 03 Jan 2024 09:39:08 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id b13-20020a056000054d00b0033739c1da1dsm9906876wrf.67.2024.01.03.09.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:39:06 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id F1D055F94A;
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
Subject: [PATCH v2 18/43] tests/unit: Bump test-crypto-block test timeout to 5 minutes
Date: Wed,  3 Jan 2024 17:33:24 +0000
Message-Id: <20240103173349.398526-19-alex.bennee@linaro.org>
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

When running the tests in slow mode on a very loaded system and with
--enable-debug, the test-crypto-block can take longer than 4 minutes.
Bump the timeout to 5 minutes to make sure that it also passes in
such situations.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-15-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/unit/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/unit/meson.build b/tests/unit/meson.build
index 0b0c7c14115..a99dec43120 100644
--- a/tests/unit/meson.build
+++ b/tests/unit/meson.build
@@ -173,6 +173,7 @@ test_env.set('G_TEST_BUILDDIR', meson.current_build_dir())
 
 slow_tests = {
   'test-aio-multithread' : 120,
+  'test-crypto-block' : 300,
   'test-crypto-tlscredsx509': 45,
   'test-crypto-tlssession': 45
 }
-- 
2.39.2


