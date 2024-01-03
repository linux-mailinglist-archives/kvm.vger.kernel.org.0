Return-Path: <kvm+bounces-5538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11CDE823347
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2883F1C23AB1
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B67F1C2B2;
	Wed,  3 Jan 2024 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qX1tkok3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA01C683
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40d88fff7faso24863265e9.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303230; x=1704908030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RdsiaowAjsV2VhJV7X+uJO6SS3PjKGOvNs318qpxEnc=;
        b=qX1tkok3vgn86PQmQrxENNozVJcbJAb3BiCFCYVMuIMzzueCIQbbiZc14cCnFOMMJp
         EMcxXzTGK/J19wGNc95b+t/20aIy75gGOc2r4d+5q7mwGr2Ms37+KUKjs+urB/Z0hGRj
         hxela+4+U+A2Gybw09VwXbyldbKNIBDSu7666iSbcilA10/1lo/2PtSwJoWuqxX3/jfm
         yxE6fEmtVvfYRup0lYl9E8AHCX1h98P/zuJ9GaVmIBmqlNZNjdFY1+mn79ZXavspYznH
         o5FFFZIZdW7YrfbcXYMdWfY3ho4dLuzPbTO5Kpy58AL0Fh0DdwtGVs1IEBCiizOtsP2Z
         15/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303230; x=1704908030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdsiaowAjsV2VhJV7X+uJO6SS3PjKGOvNs318qpxEnc=;
        b=lrqun1jxb0WW06cgdAX9LynHlpjz0hydXyabTvfEHTx9uCZSzHAeD1Hk8baKhDmLPI
         +U2O+aPxEmlE8vLEbkv7YZPW4zZO78/jVxxx06JshiE7ZSylL67lTdEjyN6NVnXmQ2Dn
         LVuGuoLgpLL3R0VW3TCFPdICSdn9/MqsIpjKJW9C3hu6BGiN3gZnfWhcbMKNw+VCIJW7
         WOXOM34sxFJYXws/N4bJyXYfGRTx3w8V+jFpMpVigmWQZP5JKZNGbDPlEio7XZhFWP+A
         jXbGdKs8UfLCvCs+EK6+5XUKxEe4zp+GabHChKVbsmgkyiBv2HS18pL7Q2xVbARtk+Ke
         MDmg==
X-Gm-Message-State: AOJu0YxlJFB2bwoUWpxRXPYILhDaOlh5CfXDnEthUEyr1ZHqUfmIVkUz
	be/sUG6uB+wz/AkkN418XsGNQ7hB5suo8A==
X-Google-Smtp-Source: AGHT+IGeFbtzVvu3T8oVc1zHjuCDZo+RPaHsfV4kjVznDt57AzNWaYV+gZhSH5pdHVRgX2Ots1y9PA==
X-Received: by 2002:a05:600c:491e:b0:40d:5c56:5545 with SMTP id f30-20020a05600c491e00b0040d5c565545mr3022779wmp.298.1704303230107;
        Wed, 03 Jan 2024 09:33:50 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id s7-20020a05600c45c700b0040d8d11bf63sm2903966wmo.41.2024.01.03.09.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:49 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 6A5105F92D;
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
Subject: [PATCH v2 01/43] tests/avocado: Add a test for a little-endian microblaze machine
Date: Wed,  3 Jan 2024 17:33:07 +0000
Message-Id: <20240103173349.398526-2-alex.bennee@linaro.org>
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

We've already got a test for a big endian microblaze machine, but so
far we lack one for a little endian machine. Now that the QEMU advent
calendar featured such an image, we can test the little endian mode,
too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215161851.71508-1-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/avocado/machine_microblaze.py | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tests/avocado/machine_microblaze.py b/tests/avocado/machine_microblaze.py
index 8d0efff30d2..807709cd11e 100644
--- a/tests/avocado/machine_microblaze.py
+++ b/tests/avocado/machine_microblaze.py
@@ -5,6 +5,8 @@
 # This work is licensed under the terms of the GNU GPL, version 2 or
 # later. See the COPYING file in the top-level directory.
 
+import time
+from avocado_qemu import exec_command, exec_command_and_wait_for_pattern
 from avocado_qemu import QemuSystemTest
 from avocado_qemu import wait_for_console_pattern
 from avocado.utils import archive
@@ -33,3 +35,27 @@ def test_microblaze_s3adsp1800(self):
         # The kernel sometimes gets stuck after the "This architecture ..."
         # message, that's why we don't test for a later string here. This
         # needs some investigation by a microblaze wizard one day...
+
+    def test_microblazeel_s3adsp1800(self):
+        """
+        :avocado: tags=arch:microblazeel
+        :avocado: tags=machine:petalogix-s3adsp1800
+        """
+
+        self.require_netdev('user')
+        tar_url = ('http://www.qemu-advent-calendar.org/2023/download/'
+                   'day13.tar.gz')
+        tar_hash = '6623d5fff5f84cfa8f34e286f32eff6a26546f44'
+        file_path = self.fetch_asset(tar_url, asset_hash=tar_hash)
+        archive.extract(file_path, self.workdir)
+        self.vm.set_console()
+        self.vm.add_args('-kernel', self.workdir + '/day13/xmaton.bin')
+        self.vm.add_args('-nic', 'user,tftp=' + self.workdir + '/day13/')
+        self.vm.launch()
+        wait_for_console_pattern(self, 'QEMU Advent Calendar 2023')
+        time.sleep(0.1)
+        exec_command(self, 'root')
+        time.sleep(0.1)
+        exec_command_and_wait_for_pattern(self,
+                'tftp -g -r xmaton.png 10.0.2.2 ; md5sum xmaton.png',
+                '821cd3cab8efd16ad6ee5acc3642a8ea')
-- 
2.39.2


