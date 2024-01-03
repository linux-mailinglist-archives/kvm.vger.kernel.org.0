Return-Path: <kvm+bounces-5550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C161823353
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F93CB23D33
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445A21D532;
	Wed,  3 Jan 2024 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PS+SnRHm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C9F1CF95
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40d87ecf579so29155695e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303240; x=1704908040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRw1//+81PB5ZNvZJSTSQFwoG2tqKVRM/U60AtyQst4=;
        b=PS+SnRHmk0AbRBxgpVsMVXr2/esrOEf+LErtAhcJvT/BQ9E77NL9jCpgR+cETlOQCX
         VBNQvK14m9R9b/Z0UxVFDz45CFTmQJPeKrf1GyWE1T3t7ZkDIU9KfNKlo3rWbNwhMp0D
         J5D1xM/OlhaDVi1Xr8xqanaANiMiYSNA2+f7U1xPPbGlDj8v8R2P7WSyH80tMgmYYzWX
         OuvNeZ90ZW9O5uz5AibxX9k2O3HS+QZfj2zeaPJAVLqkhkAqQdxlfefO2aaE6KjGTuZk
         C8NY+AWXgCR7Uc6tyENFSAsn5MfFOIbfoaIn87otR4kDrqThyhkQVOBcCjLLHpK1viSJ
         e22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303240; x=1704908040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wRw1//+81PB5ZNvZJSTSQFwoG2tqKVRM/U60AtyQst4=;
        b=uqpF8Z4nJmNF/0v2oB3KAdauKm4+KyzQnL7OfxkTzROT7lLntxCM2IHvFtmMkHY7la
         BjyyVwqTG/K7RSGlitv3WMggfI+S9ckjVvYdV7J1LuQ71UQAASH8o25K+yrwFKZ+wIbU
         t5Fn6qoXejGGDpRdQN9Pg/U0ohtsQIuHtAEELtRjRattmhzTephfq+OOANIs4EFddUOj
         zoe1oJ9ys9bZ2s/wQcZtJS9F0WLsRhvG/qmJK+SnuKT8XaANmHQIF7du8/gOBxQXwSUN
         wB8cWNw9P+2pHlT3v3nRz4DMZvjLkRl5SsqIJB62NeDd3nqnfu8VNwnPusccryO8WFgv
         AFgg==
X-Gm-Message-State: AOJu0YwjMUs0AfU29aFeVZzgkoCxMH+oZGVc/F74SGv83ToGYo/UjaU4
	bqlO/T9qzf/wTXERdI8unG+Si0xpuTJxvA==
X-Google-Smtp-Source: AGHT+IGRb1EG4rLPK4TuLkqwgONu+gLuVa4+cTzeg08wRExh/Gqtzz92MgVmvdmmy9ZrPufi06pGTw==
X-Received: by 2002:a05:600c:354e:b0:40d:4d95:f82f with SMTP id i14-20020a05600c354e00b0040d4d95f82fmr6578918wmq.68.1704303240439;
        Wed, 03 Jan 2024 09:34:00 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id c1-20020a05600c0a4100b0040d81c3343bsm2942425wmq.42.2024.01.03.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:56 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 6B1A25F942;
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
Subject: [PATCH v2 12/43] qtest: bump boot-serial-test timeout to 3 minutes
Date: Wed,  3 Jan 2024 17:33:18 +0000
Message-Id: <20240103173349.398526-13-alex.bennee@linaro.org>
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

The boot-serial-test takes about 1 + 1/2 minutes in a --enable-debug
build. Bumping to 3 minutes will give more headroom.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20230717182859.707658-9-berrange@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-9-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index c7944e8dbe9..dc1e6da5c7b 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -6,6 +6,7 @@ slow_qtests = {
   'test-hmp' : 240,
   'pxe-test': 600,
   'prom-env-test': 360,
+  'boot-serial-test': 180,
 }
 
 qtests_generic = [
-- 
2.39.2


