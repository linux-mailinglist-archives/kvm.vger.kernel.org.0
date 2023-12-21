Return-Path: <kvm+bounces-5031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5852481B3CD
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:39:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB7341F2573B
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048717318D;
	Thu, 21 Dec 2023 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SsfQL57O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E8E6EB76
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3368ac0f74dso272741f8f.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155111; x=1703759911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G7uxGZGov81O+5jLuoaBr/C5I/uZZh1/zGx1+p9cIt8=;
        b=SsfQL57OFX00h8olxukPgPtJdaRzzYzY8ZcPf8JmSX299mEFfxz+iRE4W15tGlrIIe
         wPFnqJHxyenW2Oc6GmnY1Z8OWh8+ds8tjjcE76AAz7Jzg2eK0Xom9/cXCuq4KztM+M6e
         xxRhmfLA8Vf10SgDdqRCy3Z5YfhpjclNx7JbPtBY/pfuGgBa0gCjrlhp1CHoMukQVC8H
         3V08vnPqFOzlhLLcWeaLLlTxcsvbeqKw8D8sqbSTZiUwItiZ/1HvHqYDCz35JoTf+j2o
         h/TtZtFM6z03EuUycor+/7OcEo+HjXVUbhHcglwGJVvgGiqi0kM8sOnTF61YgAOQZdee
         zTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155111; x=1703759911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7uxGZGov81O+5jLuoaBr/C5I/uZZh1/zGx1+p9cIt8=;
        b=szU9uOk1TEgmUDYtr57kjN7V5ldgVzYJqAjsZyQhE45WempQBQ1dPWc6tGQPkG4NvW
         J0ZuuGDvtXMW5VQQ08G3KwSwjJ1ZOPAn3lEbtiycKxicZnsxMAnDyPy9eqE4jEmSxtCQ
         M1UaGTiv2OrtNBJtfYhE4r3IpDkZ81JXaHnMmECJucy1Dbs45ze53zgLDIcj8ITfZnpT
         8sEk8i6Wi+v0QVCK3Sv+PIH7//V7l8r+pqLNA8N6xB6lcMFvCbGtm23Hjw0J6PTbOoC8
         uvtPWiYPDczMEFTnJeLRvp/tSyfiKYCvc9FTu2Tb1vRnxScchziAbHasI8v1Nx9CBW/1
         O4vA==
X-Gm-Message-State: AOJu0Yw5u6P5bdo0qNpqhEVKbX9c9iP+rWkYvsVOUzVKQpB0Kt8MJQtW
	CVsgE/CdOwxELg0zTgUXUwjKoA==
X-Google-Smtp-Source: AGHT+IHDkK7DDkGONkWeeg1etyQrE038hwJH58HJmds12JAmwy22MbScTVnibljXYstd5tpPwiyrKA==
X-Received: by 2002:a5d:5385:0:b0:336:6f89:9eca with SMTP id d5-20020a5d5385000000b003366f899ecamr616253wrv.66.1703155111228;
        Thu, 21 Dec 2023 02:38:31 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id w9-20020a5d6809000000b00336768f52fesm1722017wru.63.2023.12.21.02.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:29 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2CE1E5F8D6;
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
Subject: [PATCH 13/40] qtest: bump qos-test timeout to 2 minutes
Date: Thu, 21 Dec 2023 10:37:51 +0000
Message-Id: <20231221103818.1633766-14-alex.bennee@linaro.org>
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

The qos-test takes just under 1 minute in a --enable-debug
build. Bumping to 2 minutes will give more headroom.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20230717182859.707658-10-berrange@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-10-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index dc1e6da5c7b..b02ca540cff 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -7,6 +7,7 @@ slow_qtests = {
   'pxe-test': 600,
   'prom-env-test': 360,
   'boot-serial-test': 180,
+  'qos-test': 120,
 }
 
 qtests_generic = [
-- 
2.39.2


