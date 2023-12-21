Return-Path: <kvm+bounces-5030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2934B81B3CC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0F491F2550F
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F0F6F610;
	Thu, 21 Dec 2023 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gTnj2toL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F103F6E59A
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3333b46f26aso541979f8f.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155109; x=1703759909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7IelmqBfCUiQPJ1PO4YXHkz0msSivdOvYJRQon3tbw=;
        b=gTnj2toLg/aL3G9iDuk030jyASDjyk/VYdaVQPRMWWpy4T7hCZQEaorc8CgYI1Ro+I
         k0n3GnZ0t7VywXP9iX5zbaQTJyWZcvijpc2bTxbvQnjKFruzwPYTjnmzmeQIXIBKLdwd
         sMNKQkUdo59PqaJ3lqN6d/oUeEyaWw6iEax3Xz9gNKL6KI6Gj8FUO5y0xgqWdbC/k1wG
         OTWAnZ5j6MO1jsxa4y/eVn5dxcRVeItgKDmNNcQU9YHcTAoGo0YMeUlFV3k5MC+WyZpb
         vmS3yQ2v1Ai7rW3d15ochsYtVs76Pf5e8nBXxg7w2QQfAUpBkyB+z1VgDpwz9AiNYwki
         tVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155109; x=1703759909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c7IelmqBfCUiQPJ1PO4YXHkz0msSivdOvYJRQon3tbw=;
        b=ulnyds0MOSiAyUa+HxUCA65ZxhoOKzNqGA8sg/TU/Vqu3rX2bYCsFKFwOBNwfxSQdD
         aojQ9/Dwr/OoHkM9v582qSv+AxqJCotbeld79sRUOPpnnzB/c26EviGogPpM/bjskFQb
         ICDHy3y/Ll3V3xrGZErv4ZP1uJ5dPm3rH7xw73oaPqBbAWBdYXuiIELTxevchLh7e9fM
         531o71rfe1u2iLNtbuaQvP1TC6aVSKYEx2Eice3Csh/DNRlOPYqfyUS1p3IxBSOmDlEL
         3YnozCPTEvwZg2Gk9rsLHpjEzEcaaAubbsldRkcmF1NXKU+q+SSmzcVhm6Jf/trV73X1
         AL8A==
X-Gm-Message-State: AOJu0YzhWE9DDgsP76aFzFobPvUeARHKFgO8GXsV0F++SJOnVLivu/lV
	HKjS14a8tYJ4glPxwFwcXoosZA==
X-Google-Smtp-Source: AGHT+IE2SX8Gf4CKFnC2WUs5pcquLgLIHQPwc6U2p/RhTTIcQNnHMhIsqb2Kkf5Fuml6Vm8L0QiRYA==
X-Received: by 2002:a5d:44c2:0:b0:336:6bf1:9707 with SMTP id z2-20020a5d44c2000000b003366bf19707mr643477wrr.124.1703155109425;
        Thu, 21 Dec 2023 02:38:29 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id i2-20020adffc02000000b003364aa5cc13sm1744942wrr.1.2023.12.21.02.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:22 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C70F85F7D4;
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
Subject: [PATCH 09/40] qtest: bump test-hmp timeout to 4 minutes
Date: Thu, 21 Dec 2023 10:37:47 +0000
Message-Id: <20231221103818.1633766-10-alex.bennee@linaro.org>
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


