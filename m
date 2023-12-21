Return-Path: <kvm+bounces-5034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A05B81B3D2
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A0F3B243FC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCAB7745D4;
	Thu, 21 Dec 2023 10:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wrgQId5g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7E473187
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40d3c4bfe45so6369975e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155114; x=1703759914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NG0GNTBkS5OA4bLgzcXFuNl7bQt30v5WL9SIW527gOo=;
        b=wrgQId5gpLXZZVr+kp6IJq28nY492udpZKIIQrtNFZDalbt0r98rVHZ5W7YqGvYY41
         Cw0BVTOnIRGQWZkLVgcssYkvadxVtBL7u8toKSqILkLc6I3Hc909n8LAhMmfpXKjyYTA
         Gb5eYG3wp3CljY+cBX9cv3po/stxJj/RCJ73Q9bjDLxlsrwxgcnjO/6OcL9trbq7ak9a
         wzVeIjuInoM28586Y3hXnJu9HWkdwVQLDFvUHSEprIlTK+onAuDsTbOjI0p9vr+gDeZR
         YNTDKyMSJmPkZf/5+Rjg7On3akqyWY30TM6Ilx5XKoJd/Rtu/+qXyVbXQFPEQ5iIt8w0
         vdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155114; x=1703759914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NG0GNTBkS5OA4bLgzcXFuNl7bQt30v5WL9SIW527gOo=;
        b=K7dd7/q/pHyWsXn2w/t8r1Otmkx15bPKsu8XBdUq21zR2rnuk/LuZdGHpjCebGrJOI
         QAG4zo+jHYY0+aRBJ6E1HTFtvdoNYDpe6bR1Sp49sshSUZBYfKpScmvUUt+XCR7gEIMO
         NKqDZOnG1v3pw6sWkfjAVSLiHLAzoL8zbp2ryfskJU5CZvuZKoEsAOFJzPCAYqcpnqPH
         LtJry6Ti5xTAqA5XCDyhBXCXJcY8gIGXTyY99PcfDNlLL6AAfC4zfGIr7gYEFDxV7G/l
         +8KFU9xqHoxjSXP0zy4kTRuVp12al6R7fliHhXnKG4ug5UAJPTwvCnTuIUxwNlbkOycy
         ucdA==
X-Gm-Message-State: AOJu0Yztzwc5qxkvPdyeZBsnfYuCjYDGWbNv2gTcrUhjyLPAQ0mQec2G
	uN2fnpgHu0ckwtyselMs+moQuw==
X-Google-Smtp-Source: AGHT+IHtw299z4GcZk4ReQAPdhRPfcJ81XOj4Zsroy61A+dimT3sxJq+bziNhd0DzLsBRbi1nCt9BQ==
X-Received: by 2002:a05:600c:4583:b0:40d:2e2a:18df with SMTP id r3-20020a05600c458300b0040d2e2a18dfmr324147wmo.213.1703155113719;
        Thu, 21 Dec 2023 02:38:33 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id r19-20020a05600c459300b0040d128e9c62sm10647702wmo.18.2023.12.21.02.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:29 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5ECEB5F8D8;
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
Subject: [PATCH 15/40] qtest: bump bios-table-test timeout to 9 minutes
Date: Thu, 21 Dec 2023 10:37:53 +0000
Message-Id: <20231221103818.1633766-16-alex.bennee@linaro.org>
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


