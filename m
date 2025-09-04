Return-Path: <kvm+bounces-56783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A606BB43529
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E33D57A1EC6
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31382D1F61;
	Thu,  4 Sep 2025 08:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Oh4FVseq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92D32D063D
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973516; cv=none; b=s2YW9j/TeJ4wQtY/oo9HHi+xg+1nHF9qLhBLYlql6fRhJ1F3OTGBctPimLdg9yDbJua6NRAQrm165ZRCtFfpFUJZftsmndY5RlUhyr+0T+kfbcAyJXxqHLhmJCcaM0voY8dGi7qwb7J1yQQnjTg58i2jXFvIhvgWPI8JMA+iq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973516; c=relaxed/simple;
	bh=v3TMa813Yj8uUnsyCi4vONQeljxDx+5CJiqhJz1wkiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ou56hXHopgAiw1pgBMpheV7tgmaR7Y0KpJJZHbjJyCvfbzTb5KcfzarQtvsdEtxpe0SkhVZK8fwfhqLW5X98yMwpSS4SYmdszdhzadZrP8EM2GeCD1vnIWvQIDrlXVAJ+DlA82nsswE8FL0nPKnZYeHL7xq7dIQgw/WkBrNmA50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Oh4FVseq; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afeec747e60so137366566b.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973513; x=1757578313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qtgYk8tL09X7evEehKpRVdQ+nFs0oLJoTM08eLIHHIc=;
        b=Oh4FVseqhFDnvE0IIxjFIJ63lzJ9XNPuOlJ+/y0Oli+uFvk6BKIpiHi5RUMNOMjOAR
         Zt2h8sw9krbpwPo++8DlOHrcGIt6u7lk9jwfmHpuXQDLeYloWGUi2YY/oBZTHn+uThQf
         ioEk5761m3tGWCIOgwRyPJC8HsAepf8iR5ecH4kw98fpXSMCzONMoCkBs2r+klWKf7rH
         Ot+DMFb9RgAnm8LlJugEGk7zxkLZ0Ly9FD1WB0OOCEO5GpDQEq1i1uREdFd22XtSUX2j
         3QC+rExUvIKtCnQ7VO45DfzebZvfnrF7uo+8ifuj6b5w/elsYQXM9nWHCIy8sYa0CWaM
         MyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973513; x=1757578313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qtgYk8tL09X7evEehKpRVdQ+nFs0oLJoTM08eLIHHIc=;
        b=c+fRjvr9pDu44sfIZF/+pEOCEqDLF2+WtolpuLcHHKKUQdUis8jkReAxw8ENHfm/Gm
         IjfpFk6QxdlTHRG69qtESpoHfR2QpQ6uImDPCODRHxnCXDObihn/2qyVh0CNG0YseC7w
         N6a+ChJ/L1VgTS9GzFvxpq46fu7/ehZ5oxEUkfpKoWiox9F8/xUQsEU/3BfVYEy+/pDN
         c9REJuGplKDfjM1An7+D+Fk6bbZAumzQnkoq6nI/f7TvPuCrbnWI0pWiCTIo2nOLvkdA
         9FCLksaLl9FdbF5c7ThZsQRse9rKtlje0Ek0lZAYiFZV6dzitSLxtciM7HsEVNch7wPA
         FjSw==
X-Forwarded-Encrypted: i=1; AJvYcCVbE//YsNZxYlVvDaPDYfC/6tk330GN0WA1ULCiEO8PwjSlQE8YYYMmfTMDJ3BHd0oAG7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtyqKqW5vtb6U/JAKmevNRu26qVEW4RkA3Exe2EpBuCDY/AAKx
	JW7j/6p3Ikok7JCfZcCbHeft8xh0ZDR324mITOQd0HfYWfmcjnVV0Ld7s/lU4J/sgi4=
X-Gm-Gg: ASbGncv0VudQrN35cskgAsAY1d8LgIAiozxonPzF13gMo6XBUSoLbYIfQa5QdSp6/ld
	o2j+Zt3UcHSPUYfymPjt1DxdV2L10yH4le0CeR50Q2mmaLid4ObKTApInTJeAfIpUHEzj50IlCy
	ZOhsW3Nat+NYvs2BvDl+Ey21+dfNbk2MbiGTLYE1ZxXYYzbM265C33XBHeQ0mItb/12AOVHDydm
	8/Gb2fI/m83zCfmDGFwX1qzx9EXqDmZgUthhcJgrQTlCx2vvWA/rMTJv4JycJ/fWU3MUOeE2gUS
	5z+2u77WTYcDjE/LBisfdjZ/ubKpMjfYdfWHNHWCQdG1WSmexS0mzpQN3c1fODWSQRe2WNFQUi/
	BAP2hSiF5Y50iiCVVy4ce956F5AScDcz9HFLfxUY9BjBH
X-Google-Smtp-Source: AGHT+IGYskyBYR3n5Q9uI+8AP0+1GXixN328LvmrggmBgoiP7mVHjL06ko8pn8Trl6ZXEys7FI6f0Q==
X-Received: by 2002:a17:907:daa:b0:b04:8420:b6ef with SMTP id a640c23a62f3a-b048420c5b0mr91846366b.61.1756973513129;
        Thu, 04 Sep 2025 01:11:53 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b017e4b9ed7sm1280476466b.90.2025.09.04.01.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:49 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 02D196000B;
	Thu, 04 Sep 2025 09:11:32 +0100 (BST)
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
Subject: [PATCH v2 031/281] tests/functional: Move s390x tests into target-specific folders
Date: Thu,  4 Sep 2025 09:07:05 +0100
Message-ID: <20250904081128.1942269-32-alex.bennee@linaro.org>
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
s390x tests into a target-specific subfolder.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20250819112403.432587-20-thuth@redhat.com>
---
 MAINTAINERS                                         |  6 +++---
 tests/functional/meson.build                        | 13 +------------
 tests/functional/s390x/meson.build                  | 13 +++++++++++++
 .../test_ccw_virtio.py}                             |  0
 .../test_pxelinux.py}                               |  0
 .../{test_s390x_replay.py => s390x/test_replay.py}  |  0
 .../test_topology.py}                               |  0
 .../{test_s390x_tuxrun.py => s390x/test_tuxrun.py}  |  0
 8 files changed, 17 insertions(+), 15 deletions(-)
 create mode 100644 tests/functional/s390x/meson.build
 rename tests/functional/{test_s390x_ccw_virtio.py => s390x/test_ccw_virtio.py} (100%)
 rename tests/functional/{test_s390x_pxelinux.py => s390x/test_pxelinux.py} (100%)
 rename tests/functional/{test_s390x_replay.py => s390x/test_replay.py} (100%)
 rename tests/functional/{test_s390x_topology.py => s390x/test_topology.py} (100%)
 rename tests/functional/{test_s390x_tuxrun.py => s390x/test_tuxrun.py} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index c6410a5f5fd..4a55a20f6a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1797,7 +1797,7 @@ S: Supported
 F: hw/s390x/
 F: include/hw/s390x/
 F: configs/devices/s390x-softmmu/default.mak
-F: tests/functional/test_s390x_*
+F: tests/functional/s390x
 T: git https://github.com/borntraeger/qemu.git s390-next
 L: qemu-s390x@nongnu.org
 
@@ -1811,7 +1811,7 @@ F: hw/s390x/ipl.*
 F: pc-bios/s390-ccw/
 F: pc-bios/s390-ccw.img
 F: docs/devel/s390-dasd-ipl.rst
-F: tests/functional/test_s390x_pxelinux.py
+F: tests/functional/s390x/test_pxelinux.py
 T: git https://github.com/borntraeger/qemu.git s390-next
 L: qemu-s390x@nongnu.org
 
@@ -1865,7 +1865,7 @@ F: hw/s390x/cpu-topology.c
 F: target/s390x/kvm/stsi-topology.c
 F: docs/devel/s390-cpu-topology.rst
 F: docs/system/s390x/cpu-topology.rst
-F: tests/functional/test_s390x_topology.py
+F: tests/functional/s390x/test_topology.py
 
 X86 Machines
 ------------
diff --git a/tests/functional/meson.build b/tests/functional/meson.build
index 7e7a6aa0c93..abaa4e00fca 100644
--- a/tests/functional/meson.build
+++ b/tests/functional/meson.build
@@ -29,10 +29,7 @@ subdir('ppc64')
 subdir('riscv32')
 subdir('riscv64')
 subdir('rx')
-
-test_s390x_timeouts = {
-  's390x_ccw_virtio' : 420,
-}
+subdir('s390x')
 
 test_sh4_timeouts = {
   'sh4_tuxrun' : 240,
@@ -59,14 +56,6 @@ tests_generic_linuxuser = [
 tests_generic_bsduser = [
 ]
 
-tests_s390x_system_thorough = [
-  's390x_ccw_virtio',
-  's390x_pxelinux',
-  's390x_replay',
-  's390x_topology',
-  's390x_tuxrun',
-]
-
 tests_sh4_system_thorough = [
   'sh4_r2d',
   'sh4_tuxrun',
diff --git a/tests/functional/s390x/meson.build b/tests/functional/s390x/meson.build
new file mode 100644
index 00000000000..030b116039c
--- /dev/null
+++ b/tests/functional/s390x/meson.build
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+test_s390x_timeouts = {
+  'ccw_virtio' : 420,
+}
+
+tests_s390x_system_thorough = [
+  'ccw_virtio',
+  'pxelinux',
+  'replay',
+  'topology',
+  'tuxrun',
+]
diff --git a/tests/functional/test_s390x_ccw_virtio.py b/tests/functional/s390x/test_ccw_virtio.py
similarity index 100%
rename from tests/functional/test_s390x_ccw_virtio.py
rename to tests/functional/s390x/test_ccw_virtio.py
diff --git a/tests/functional/test_s390x_pxelinux.py b/tests/functional/s390x/test_pxelinux.py
similarity index 100%
rename from tests/functional/test_s390x_pxelinux.py
rename to tests/functional/s390x/test_pxelinux.py
diff --git a/tests/functional/test_s390x_replay.py b/tests/functional/s390x/test_replay.py
similarity index 100%
rename from tests/functional/test_s390x_replay.py
rename to tests/functional/s390x/test_replay.py
diff --git a/tests/functional/test_s390x_topology.py b/tests/functional/s390x/test_topology.py
similarity index 100%
rename from tests/functional/test_s390x_topology.py
rename to tests/functional/s390x/test_topology.py
diff --git a/tests/functional/test_s390x_tuxrun.py b/tests/functional/s390x/test_tuxrun.py
similarity index 100%
rename from tests/functional/test_s390x_tuxrun.py
rename to tests/functional/s390x/test_tuxrun.py
-- 
2.47.2


