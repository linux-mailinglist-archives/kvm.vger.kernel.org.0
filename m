Return-Path: <kvm+bounces-56781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B16EB4352C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D0597C40D9
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C932D060D;
	Thu,  4 Sep 2025 08:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MJBi+vki"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F361D2D027E
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973512; cv=none; b=FFwbhg5d0z7BbYgUXC6sVuswChKTwY7ty5nl9h6UDhcJ1Hkdw64Z+H35esUae65GQs74+MXMTWhAG+niSvcaMQed8ZWtqTaH/Gi5KdvS/Nn6mRi2ZaYa1lWI5RdtVM3Ewl4S+5Ww89kq45eCqF4W+o1rQxQZZFjIAXh79dB3uLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973512; c=relaxed/simple;
	bh=ahEqKxILOTV7FRYebgoUrIiscHDAM7NCLSnUKU5P1eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UPHA+8QLNY/O/d/lHIYthxPr+BxPkEP3gdA8YH8lYg7eJs1scDFXo88qzTOop3V1wKnEbxrjH8j2ru/iYhEL7/Gb1IZsYzI0H0bGqnL3etOFwiIIy8G/EDhP4HNvX6IhdB2fTRMjPA67X9EUa9Owie4K8gCYul313DQBpvvp4QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MJBi+vki; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b02c719a117so132860866b.1
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973508; x=1757578308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDNuaOsGD6r42U8ngLUfY1h4DF7myqs0cRJmalDhUb4=;
        b=MJBi+vki9lPdHI5A4x/3RtF9OyfPUXtJzihCUXO+cPyM2izzaQfRXKzIqpkjVEcn7b
         QSH9xxOdPd3rGv1tcIRwUGYDq4KGUKp0JROgQSK7BpsanpWRqWwSfTZhsGBJbccMNDhR
         /i3uGocgiP02v6pmz/VZbbYbQVN7wGSFNOUrZDs/NTuRUJ+1IftUdMwzF87c8FKhRbku
         eAvsQTvKMO+zEEsAHKfHjV2xuy8p0l8FbhLsRFnNCUPSIkC25spP5WToIndYKNK/CQlT
         CxhGoiXqYDgYzjbjfJV66VMocJHWzUN+NvKiqaMvq1pbEf8gQabT+0BwHGCZ3kkirMT1
         zkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973508; x=1757578308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cDNuaOsGD6r42U8ngLUfY1h4DF7myqs0cRJmalDhUb4=;
        b=s9UCsPUoAy0fqsQ4eg3Pcm4asim3vwtA2P9N78akQ/D+dGg3y0L4uNfIOW0BxkuZC+
         Y9vkCUl9wlZ1HJw7DXdsVCOqni6PWEub+FTsKUvQ19W916w6qKs3XO1uriBXVEhWZO/Q
         2x0pkonvkA2p4NiR6rMZnnwbZ3rH/OeK21x/KcUDDcF4SBm++WGwGuY90u5tQ6Gv53dC
         FCIGPYLxoh7cxl0agvyNJv+36vri/cHgSxc8Weo1/074dgav5gurIyZhSY1okrwtvdLC
         r4/Ee8CLE26MTrfHIVnz+T7Ld87ZEAo/Ovy/PiSb9kMRLXlAHDgXxezaHQs1PPLgqbNB
         ggEg==
X-Forwarded-Encrypted: i=1; AJvYcCU6cvULKUT3HIq4SWkKWr7BdhXxjwCAJoNbGapAMUWlZWbCiXB5F57aFx95VkeWunUQd28=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTWx6oPpV/xUnraQ3pJPg/CtwB2O+0pkYi8VgR5+Qzq99Osgwh
	vdSJ3yKb8seNge6eR2rkWDN1tnZ7XiouzB/WNKR4wTBJJvnS2O3kuaTplvFGeBKGaYc=
X-Gm-Gg: ASbGncuaWJPNsmjUxdQp4wLrp1EpUKAsoO9bI4l3jlQfLs2hnJrdNs04WbISo0Qpqht
	0tludQfH0zKt5O9s+1U1glOzZpR30Jj84a+2lwRJtv5yDNCLftVfJCRUkbb0o2yPSbyzJhVuu4p
	aYY1+G9zrcetQvIWtZwrK1TcySh+SRFAK1FVZLCec9GH7agqrj1N81GuAhNXMCHCkKgrvE7YffF
	1qvfFbhQd/luKPXqoIX4yeTeoLXvLREvk8NAXG9BEYMRcpcbmm8TW9ZKe1ku1d60ewPGTvlZjD0
	m2X2QlL3X0sXPIncxw3/7EhB4IYy8wkzQgBAzfQlk6Csq1LWZ0Xy+9QwNsGpAfZVESa58ToF8W7
	QXN87Qkmccx7fm6qU4fictJ2v+2ROLvIVmjGw4JSJoLis
X-Google-Smtp-Source: AGHT+IEuGPLBjng4TGodrmsMkqQv/1x2d0i2N2XuU6rOMtEyrvdgiQZZOH9o9y1LB92mX/fQfkpwaw==
X-Received: by 2002:a17:906:9f92:b0:afe:a615:39ef with SMTP id a640c23a62f3a-b01d8a2667emr1911016566b.9.1756973507309;
        Thu, 04 Sep 2025 01:11:47 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0416e878a2sm1085838766b.95.2025.09.04.01.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:43 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 19D475FAD0;
	Thu, 04 Sep 2025 09:11:31 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-arm@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	Helge Deller <deller@gmx.de>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-rust@nongnu.org,
	Bibo Mao <maobibo@loongson.cn>,
	qemu-riscv@nongnu.org,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-ppc@nongnu.org,
	Stafford Horne <shorne@gmail.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	devel@lists.libvirt.org,
	Mads Ynddal <mads@ynddal.dk>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-block@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Kostiantyn Kostiuk <kkostiuk@redhat.com>,
	Kyle Evans <kevans@freebsd.org>,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	John Snow <jsnow@redhat.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yonggang Luo <luoyonggang@gmail.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Michael Roth <michael.roth@amd.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	John Levon <john.levon@nutanix.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 024/281] tests/functional: Move m68k tests into architecture specific folder
Date: Thu,  4 Sep 2025 09:06:58 +0100
Message-ID: <20250904081128.1942269-25-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Huth <thuth@redhat.com>

The tests/functional folder has become quite crowded, thus move the
m68k tests into a target-specific subfolder.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20250819112403.432587-13-thuth@redhat.com>
---
 MAINTAINERS                                              | 8 ++++----
 tests/functional/m68k/meson.build                        | 9 +++++++++
 .../{test_m68k_mcf5208evb.py => m68k/test_mcf5208evb.py} | 0
 .../{test_m68k_nextcube.py => m68k/test_nextcube.py}     | 0
 .../functional/{test_m68k_q800.py => m68k/test_q800.py}  | 0
 .../{test_m68k_replay.py => m68k/test_replay.py}         | 0
 .../{test_m68k_tuxrun.py => m68k/test_tuxrun.py}         | 0
 tests/functional/meson.build                             | 9 +--------
 8 files changed, 14 insertions(+), 12 deletions(-)
 create mode 100644 tests/functional/m68k/meson.build
 rename tests/functional/{test_m68k_mcf5208evb.py => m68k/test_mcf5208evb.py} (100%)
 rename tests/functional/{test_m68k_nextcube.py => m68k/test_nextcube.py} (100%)
 rename tests/functional/{test_m68k_q800.py => m68k/test_q800.py} (100%)
 rename tests/functional/{test_m68k_replay.py => m68k/test_replay.py} (100%)
 rename tests/functional/{test_m68k_tuxrun.py => m68k/test_tuxrun.py} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 716127e831d..e188de813fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1312,7 +1312,7 @@ F: hw/m68k/mcf_intc.c
 F: hw/char/mcf_uart.c
 F: hw/net/mcf_fec.c
 F: include/hw/m68k/mcf*.h
-F: tests/functional/test_m68k_mcf5208evb.py
+F: tests/functional/m68k/test_mcf5208evb.py
 
 NeXTcube
 M: Thomas Huth <huth@tuxfamily.org>
@@ -1320,7 +1320,7 @@ S: Odd Fixes
 F: hw/m68k/next-*.c
 F: hw/display/next-fb.c
 F: include/hw/m68k/next-cube.h
-F: tests/functional/test_m68k_nextcube.py
+F: tests/functional/m68k/test_nextcube.py
 
 q800
 M: Laurent Vivier <laurent@vivier.eu>
@@ -1346,7 +1346,7 @@ F: include/hw/m68k/q800-glue.h
 F: include/hw/misc/djmemc.h
 F: include/hw/misc/iosb.h
 F: include/hw/audio/asc.h
-F: tests/functional/test_m68k_q800.py
+F: tests/functional/m68k/test_q800.py
 
 virt
 M: Laurent Vivier <laurent@vivier.eu>
@@ -1361,7 +1361,7 @@ F: include/hw/intc/goldfish_pic.h
 F: include/hw/intc/m68k_irqc.h
 F: include/hw/misc/virt_ctrl.h
 F: docs/specs/virt-ctlr.rst
-F: tests/functional/test_m68k_tuxrun.py
+F: tests/functional/m68k/test_tuxrun.py
 
 MicroBlaze Machines
 -------------------
diff --git a/tests/functional/m68k/meson.build b/tests/functional/m68k/meson.build
new file mode 100644
index 00000000000..e29044a6d73
--- /dev/null
+++ b/tests/functional/m68k/meson.build
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+tests_m68k_system_thorough = [
+  'mcf5208evb',
+  'nextcube',
+  'replay',
+  'q800',
+  'tuxrun',
+]
diff --git a/tests/functional/test_m68k_mcf5208evb.py b/tests/functional/m68k/test_mcf5208evb.py
similarity index 100%
rename from tests/functional/test_m68k_mcf5208evb.py
rename to tests/functional/m68k/test_mcf5208evb.py
diff --git a/tests/functional/test_m68k_nextcube.py b/tests/functional/m68k/test_nextcube.py
similarity index 100%
rename from tests/functional/test_m68k_nextcube.py
rename to tests/functional/m68k/test_nextcube.py
diff --git a/tests/functional/test_m68k_q800.py b/tests/functional/m68k/test_q800.py
similarity index 100%
rename from tests/functional/test_m68k_q800.py
rename to tests/functional/m68k/test_q800.py
diff --git a/tests/functional/test_m68k_replay.py b/tests/functional/m68k/test_replay.py
similarity index 100%
rename from tests/functional/test_m68k_replay.py
rename to tests/functional/m68k/test_replay.py
diff --git a/tests/functional/test_m68k_tuxrun.py b/tests/functional/m68k/test_tuxrun.py
similarity index 100%
rename from tests/functional/test_m68k_tuxrun.py
rename to tests/functional/m68k/test_tuxrun.py
diff --git a/tests/functional/meson.build b/tests/functional/meson.build
index e2e66dcf523..d32dd4a371f 100644
--- a/tests/functional/meson.build
+++ b/tests/functional/meson.build
@@ -16,6 +16,7 @@ subdir('avr')
 subdir('hppa')
 subdir('i386')
 subdir('loongarch64')
+subdir('m68k')
 
 test_mips_timeouts = {
   'mips_malta' : 480,
@@ -81,14 +82,6 @@ tests_generic_linuxuser = [
 tests_generic_bsduser = [
 ]
 
-tests_m68k_system_thorough = [
-  'm68k_mcf5208evb',
-  'm68k_nextcube',
-  'm68k_replay',
-  'm68k_q800',
-  'm68k_tuxrun',
-]
-
 tests_microblaze_system_thorough = [
   'microblaze_replay',
   'microblaze_s3adsp1800'
-- 
2.47.2


