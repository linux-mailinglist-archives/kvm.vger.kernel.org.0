Return-Path: <kvm+bounces-5542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02AC482334B
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9237B285D2A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2201A1CA80;
	Wed,  3 Jan 2024 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mJrnuT8k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53DA1C68A
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40d88fff7faso24863605e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303233; x=1704908033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzxoAeOdiga+52AiTCmsWe8ywFNoeoZ5ZVuxsnjrTLU=;
        b=mJrnuT8kkI3Mqqh7TGOrb8+QTRmXqdQoZnch6fQUIESDVnnLd4DQ7IqCeYJ1vAISXd
         LGSuSGi6yL94p1N61avZ3UlXD+cJsoBESUwz096wAC9n+EMpt+VYKlbRXOzYTDLRUouy
         iZHFEDeWhml7eQ6FkexbM3lFNqNqJ2kIrqDG0JfQTBzWf3/KGVztkJGP1fIz6VESgiYQ
         TE/Sj/QwXj3hkL1NvjsqMRDuwV6Iiu0EuCCuvRdWp+Irv0oq1RZUdMWtD8zI7+BS2TJr
         EketPcTQOZqdvnvhO8T3hIm8CnuLK/rojQb4JcjWLh7lYiqR1HCZdaltHdVNduJOvFm+
         P75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303233; x=1704908033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzxoAeOdiga+52AiTCmsWe8ywFNoeoZ5ZVuxsnjrTLU=;
        b=Fy6ypTka6rVp2f9bozmOUYvNwFlTXzuyUtWdH/CCLCmgaq31S/GbnCbO6hJlQ2dCgd
         jKrEtbn1WsCBYgd9jSrjuRAuWtHUjZTvPWLH77hs2v46RcT4Fwqan8jyBUTXFCn51YjG
         9ofaj9wgEeTjOk7A1XnjUcY3mGiS3Udv32Szc8bBJ4WEjAjtKJOL6mTaSJQ4P1/O52g9
         F1KcWmOXKymSYIQ0/dFwTWeMjygvcU0ot5JzpJw8guwluxMOS0QTtGvE8q9iAcoyj7Zr
         x0GUPEa2iRjz1qxTl2rkuns766ACmahEealN0ATzvzfo8xqpm+t/x1ydR75VX7LrSxCi
         dVsw==
X-Gm-Message-State: AOJu0YzcRpNC+2l5n4MfAIkVIi/Y0F1UCqPMStLSQKFW3+BNp8P9wJc1
	KGzXerEzwNiC/L1xjLMn0lwszwKYPxTeJA==
X-Google-Smtp-Source: AGHT+IGhE7/q82Jf4z4D1OPjoyeetuf4+aSfmg/R61bfYTK6tVdLZR8E2VO87yUiQHcrTBnDAn/iZg==
X-Received: by 2002:a05:600c:a0b:b0:40d:7da9:8662 with SMTP id z11-20020a05600c0a0b00b0040d7da98662mr2292525wmp.338.1704303233122;
        Wed, 03 Jan 2024 09:33:53 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id t12-20020adfe10c000000b00336f43fa654sm18186652wrz.22.2024.01.03.09.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:50 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 7EB765F92F;
	Wed,  3 Jan 2024 17:33:49 +0000 (GMT)
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
Subject: [PATCH v2 02/43] tests/avocado: use snapshot=on in kvm_xen_guest
Date: Wed,  3 Jan 2024 17:33:08 +0000
Message-Id: <20240103173349.398526-3-alex.bennee@linaro.org>
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


