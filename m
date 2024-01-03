Return-Path: <kvm+bounces-5583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 883C08233CA
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C653B20B30
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B840A1C694;
	Wed,  3 Jan 2024 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xdOrVO33"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576C31C29F
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3374eb61cbcso674716f8f.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704304146; x=1704908946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G1gJobfuOXArDzvCmnHLIGQ5mswWRXVhuXYUXNww838=;
        b=xdOrVO33BxFDXPdzgtlcudwPaTEe0VIN+qyJlVSvhqOG1hP24yfVmYarDF6rQbluMX
         cM3pJdWVNgz5I7GATzbMo6Ucsa+6EbUgfKR7Msa0ltP4gNdn4OtrEC5Ylz5Ohm/V2Htn
         G9AIFThJO5KizHxQ5hnMdWv0WTKbLN7hc/Q+7WtfomCtLWuGZ+Qiq6ZAH5pJv4pUOjli
         5oYmYSd1jh9RSUCago2+AISRzfsZsp2V8B8RFENdZG4oYtYPZmTIkPtmlNDvWQZ4NqiO
         3o8/AuaI42DX3Swv9uXcxzj3MrgA4a1MVddja/LnPoK81WVIctrEqsYPl4jiMMilke06
         YIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704304146; x=1704908946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1gJobfuOXArDzvCmnHLIGQ5mswWRXVhuXYUXNww838=;
        b=YAVRnhWHvXmoqZT9UOcB4SbLQn9OsirbS3bWtOzYGsmGoyYz0Egph7ohHbEPANontq
         w34dx60uwPUH6b3tBAoJcAiCB+e0RAvbOy5XnzDnWAAT0B8y9ZKRzUdFRnTM++wtgTjR
         615ubSVjjdXS1f/lwGZsMvdrPpB6R14/9G7Y82+4ch6mG8wOSrGchxGYjwCaT2VQqcYJ
         QWZlXmAkN56QBi2i3GHTb2CrKxkvDpDUmxt7+DdPag3Pcr0w792t3XBesWzMLXgYPuAX
         u4hJIdDIJbes6XJXrzrEU7gBpKM1PVG15C6PdTnBLEISZzkKUiIxhcZ4X3RnizHYX1EU
         yBQw==
X-Gm-Message-State: AOJu0YypCbAl08+It7Qenq3h1G7FCyZxpJe1URZcmUKSe6hy6Au9dIpW
	Md0hAbfzrDO4KZBUq6gXAEms7KIAwe7Zfg==
X-Google-Smtp-Source: AGHT+IGBTYNZSeJJFlrDUsZAC7ZX18VaF73k3nmFtB4HTAJAnT+qiuiHp3e6xy5HCWK1xoAdWaJkyA==
X-Received: by 2002:a05:600c:538c:b0:40d:7b73:68bb with SMTP id hg12-20020a05600c538c00b0040d7b7368bbmr4470553wmb.131.1704304146689;
        Wed, 03 Jan 2024 09:49:06 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id c18-20020a5d4152000000b0033609b71825sm31007316wrq.35.2024.01.03.09.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:49:05 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id D9EC15F949;
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
Subject: [PATCH v2 17/43] tests/unit: Bump test-aio-multithread test timeout to 2 minutes
Date: Wed,  3 Jan 2024 17:33:23 +0000
Message-Id: <20240103173349.398526-18-alex.bennee@linaro.org>
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


