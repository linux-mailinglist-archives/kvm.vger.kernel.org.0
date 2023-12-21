Return-Path: <kvm+bounces-5028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BA181B3CA
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57E8C1F22014
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5306F6EB44;
	Thu, 21 Dec 2023 10:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="thrfJOsV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F636DCEE
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40c3ca9472dso6872255e9.2
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155107; x=1703759907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQu3dEC4bAAkAiF4vI+JksTKEdmVPQCRZYwFmghpZj8=;
        b=thrfJOsV0h15/vTSkw4jeNWdcD2BgbRuEMKfyUUDj0jXPSP2ADp6eGYOfMMX1HBv37
         qa8AzJFh2MdYcEOD04T7ZepREYc1HegbpJF3qu35jIX2mAXshkdLD2cUlYNE8ILuj4fo
         RAgu4SRqjmqtiQiBfIxXjST1RJq/w/TPDKmGK6XUoqK14durolHdOITXINDkyX+Q/0PH
         T1uSOrGNGJZvcTRPqlW6IusbnkMW22+NlYId/OJYkh46r+zw4g43AZDBzaVfnXGZdwNx
         tceDSoOKiGriFwMGRdINbyggsp1h4Q4KB3A7lYspZfEuC6PzrXHc5pNPgbqKd/hmY6g9
         gT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155107; x=1703759907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQu3dEC4bAAkAiF4vI+JksTKEdmVPQCRZYwFmghpZj8=;
        b=MdsNJmn6gBwqb4K4gyGyit8wYVxdmn3JxhplyJsEqfEuH8VOBPDFJaiqrVV+LpP1lh
         fmtk7VHB0jyFoZQ64h2SBGpBRwYUdWlE0X2Nnoanj43uGmqGXaI0miV+Hi+++1E5fhHr
         OdkAnsvIR80nEahWvc13FR6zQXNWlVYg36OCuE1wymG02RPediSgwFQGKSjLJYw99PMh
         0PQ/wUg1qpHSdAFjHjsNExKv7T2HH/Zui+oMQktRZTAxNzJ2jjZDYvedarjs8Ch5dASc
         +3xELseywoeYfyxwA+PQYGfSdcPXOJqyPzJl0nTfPMpROri/ajnqPT9vZVFP5H3thfQm
         Wtig==
X-Gm-Message-State: AOJu0YzL7C8DXL3j1fUxWKsTGUQ9+PQnRtjFM8ExtznMXIFg02pnAQHJ
	Iuw4kEizXWBA/vMR17XAz1VfUA==
X-Google-Smtp-Source: AGHT+IEbyF9eovfKrh2dj9dnvf7GLL78Pjx/5IVXUDpMh5s/NoIcigeib1Kvd7LWnnmBJdJ9FPHlCA==
X-Received: by 2002:a05:600c:154f:b0:40c:6a86:659f with SMTP id f15-20020a05600c154f00b0040c6a86659fmr457661wmg.224.1703155107396;
        Thu, 21 Dec 2023 02:38:27 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id fa18-20020a05600c519200b0040c4afa027csm2760102wmb.13.2023.12.21.02.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:22 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id DE2DB5F8D1;
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
Subject: [PATCH 10/40] qtest: bump pxe-test timeout to 10 minutes
Date: Thu, 21 Dec 2023 10:37:48 +0000
Message-Id: <20231221103818.1633766-11-alex.bennee@linaro.org>
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

The pxe-test uses the boot_sector_test() function, and that already
uses a timeout of 600 seconds. So adjust the timeout on the meson
side accordingly.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
[thuth: Bump timeout to 600s and adjust commit description]
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-7-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index 7a4160df046..ec93d5a384f 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -4,6 +4,7 @@ slow_qtests = {
   'npcm7xx_pwm-test': 300,
   'qom-test' : 900,
   'test-hmp' : 240,
+  'pxe-test': 600,
 }
 
 qtests_generic = [
-- 
2.39.2


