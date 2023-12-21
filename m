Return-Path: <kvm+bounces-5021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5094181B3C3
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 828AE1C247F6
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF676979B;
	Thu, 21 Dec 2023 10:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yXAYJR9U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2C069799
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3368abe1093so261825f8f.2
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155100; x=1703759900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzxoAeOdiga+52AiTCmsWe8ywFNoeoZ5ZVuxsnjrTLU=;
        b=yXAYJR9Uuq5RwsJOvyVimbLomQmGMGxklrr2yws3pQvQ6pSWFhKeDZRKCNMEaODTKc
         yu4ogDrDyupTvjjixm/N4xnd4giY2K3o2766+pm+fnIGSnjmdNXnpZLfbBwdsnw0hILH
         T67Qin1/13QDigt15XAUXq6V1EcqduaPEiYj2AvxDpomGkB7M9RGrsHflsv365c8niBl
         po6/q0y5BsSBDAtdsMIkFLzfiDOxytzY8B7TW1wk7LjW71bFDXe2KMVwku2Qb/Q75RYJ
         aNAfiuHzq6OfPxSrdQfSmEH6R8LwBvOEMbhT3IYIe1shIUIMtu46PxaIjYjOeGS2RQdL
         IDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155100; x=1703759900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzxoAeOdiga+52AiTCmsWe8ywFNoeoZ5ZVuxsnjrTLU=;
        b=lblMIlPDfZOfompj3kmvKfAIjeh29XbMIc7i/2mAFSNTH7Q1L9FYM0exXNqvEfRr9O
         TB3mVxF3dZvulR+3L3T4WEZ/LV2FUXoB2D1m2rVwlejH7Hg3WntFW6KDMmSEkGtez3K3
         Iq/B/8B+EaOmLQLr5dqgscxmxREX9krl3K5iWZ9q+WExdRrJpE5c7yg5Tr5ClCPubCX3
         zZYxPq3gwu6KQRfJQff8jByZ93XLGvFxDHm+ZScSU3CdVyGYFgDpFUrXlAMxRqcZvast
         Jq40/AAtBBgpqoLIE9Zbpco79XoqlS14Gd99YtKDCx1nIzPaiJyvpnWdMbd/h4LF3Pym
         6vbQ==
X-Gm-Message-State: AOJu0YzGmsHhn+xcq+C/9YPhzJUb1XOEysE6yBZyb556SewanQKXL1tq
	qEEaX5gr0IwiiSm+34NuhDfJBg==
X-Google-Smtp-Source: AGHT+IGEPtr1hXboAnkM1kRksQtInSnZ2jI35ee+E47oqVqOC7jqs/eRFR/CZjbl0DDaumndGsscIA==
X-Received: by 2002:adf:e3ce:0:b0:336:751a:70cc with SMTP id k14-20020adfe3ce000000b00336751a70ccmr630653wrm.18.1703155100131;
        Thu, 21 Dec 2023 02:38:20 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id v16-20020adf8b50000000b003366f4406f6sm1699383wra.97.2023.12.21.02.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:38:19 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 25CA15F8C3;
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
	Bin Meng <bin.meng@windriver.com>
Subject: [PATCH 02/40] tests/avocado: use snapshot=on in kvm_xen_guest
Date: Thu, 21 Dec 2023 10:37:40 +0000
Message-Id: <20231221103818.1633766-3-alex.bennee@linaro.org>
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

This ensures the rootfs is never permanently changed as we don't need
persistence between tests anyway.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/avocado/kvm_xen_guest.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
index 5391283113e..f8cb458d5db 100644
--- a/tests/avocado/kvm_xen_guest.py
+++ b/tests/avocado/kvm_xen_guest.py
@@ -59,7 +59,7 @@ def common_vm_setup(self):
     def run_and_check(self):
         self.vm.add_args('-kernel', self.kernel_path,
                          '-append', self.kernel_params,
-                         '-drive',  f"file={self.rootfs},if=none,format=raw,id=drv0",
+                         '-drive',  f"file={self.rootfs},if=none,snapshot=on,format=raw,id=drv0",
                          '-device', 'xen-disk,drive=drv0,vdev=xvda',
                          '-device', 'virtio-net-pci,netdev=unet',
                          '-netdev', 'user,id=unet,hostfwd=:127.0.0.1:0-:22')
-- 
2.39.2


