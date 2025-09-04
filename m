Return-Path: <kvm+bounces-56782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3D5B43526
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 645315839D6
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CEC2D0C70;
	Thu,  4 Sep 2025 08:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lxBLzk47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8BE2D027F
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973514; cv=none; b=EZZdjUUwUlqenR+cf/N5q3iYHvaGu8o2b3IkcVX+/QkQyI31QEjUpCTXhVX2jbBMNaEe1/L42T2v1io+8drCEjFbvier1SoPNmzAUs4+1nGNdDtpRXvSoGF8/o5FY8GOv1XSEdaYNxxwZ9wmcDgc9IfG22+S1OAHgo/GfTKxeTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973514; c=relaxed/simple;
	bh=5Ldhe2vYcenZaokqqT6srIF8hhU3Y3BE17Mh8FsgX4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8ELFIO8yCXDTkZpHqayFgsDi+u29aIxDvokMUD2MHmF7uannWbYHvz0TRqgUm/kbjpT2HUzAolHnLjRyZ8AdKqbpmKp78iLlZWMf4uGEpl3rgcUsh0fCpMS0Vc9MUyNOnGVDOke2Mj9JWN9IAvxwWOyBljQMGSdFcCw/I3XeW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lxBLzk47; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aff0775410eso213471366b.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973511; x=1757578311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IEFayKNVFnXVPmO4dwPqIX/9FJE7mupFd4n+Gsn2REk=;
        b=lxBLzk47XKAL2myiI1b7Hl6VueKQ4GdLTMQdJWv5rR09zYS4M1guVkDssu5M0/5Itg
         2mNW3h7rrrs5XuU8l93GQTFVZ+UN9u7P9hsqaw9PuW1ucfcjMrx+Xbk+onVUfq1LhEQ2
         TqCPPdn7gEZixLM96zAJjBbUbUHEugfVhLQUylh/Rtyzab7Zb9uewNu4i/WibOUDZ89S
         6D4TrUHg01RZIGe+tBHUPm1Qw2UsXgghshzEGhdKpXdZg1pmafFUew/1BoCWfaTwF28Z
         j8MszIdt4z/EzNchcpCGlz/6H+4ttFSHz4EIHcOTo6VBUgJcSPEORWa/KABkpx8fpoNG
         6vYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973511; x=1757578311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IEFayKNVFnXVPmO4dwPqIX/9FJE7mupFd4n+Gsn2REk=;
        b=E+jitfPbKoYVffLk5/Vw3SaGej9/5IkcUyS7U3uc6ZhR+YFi0Rz8zAOuJ2C2jH8G0D
         scbhyeSymA9jMEx5lSOze9546KI+2Bt2IGEc6MbZ7oRvIVyWLVlek+lr+oS7sRSqqhyo
         ZPCHvGfDdp+GMeVOMGbFvxuCLkYiS9FFcUh5b2J4h7+Ur4Pkl/RLpcrDo/UCXOPwOHg8
         3kkise8cg+7biH2ui3PSRdokjoRqsGsOHv3t8GhO+ydB++F7xCRm6kh0hW7yallb+QJ6
         4CT3LuxEDkiElaz/LA7M6/YzQbx1H3jwL76BFITusxe/ibELTdvDMOcKKkM4sRzalBZz
         yeaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9xDVmkQz6wEpJiEPbCXUnGlwxewVsUaPD5sxYJIl7emBNTiUM/0e5ln8K/fZ+IRm0bUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV1E+3AvaQdPHssB3vq7eoVBJd2qA9aloo4hvyBY1+xm0AwwWO
	fAMzAuSUjhEZW4Rmv982/1PSK/4oib2SKQuHrErTIC4I2U8jtxS7KD4ydomubnK8v3M=
X-Gm-Gg: ASbGncvsOYHmmdRlyyAzXE/ECGbQDWF+gpqodliwDxep/NFM/4uUCzJKGJdnJmcFTlh
	ZEud+8MZlZiaDvb/DrTuvBeKA1uBAFp28DSqJpcfsUrHfJX845V34Y1f/yBH18BRYI9wIvItbaU
	1gAXMSdmwfNtxNCFoKRAZ26ZPJ68cTL5mCfIOh9e8Pu1xXYpRRIuqfKUJ13yhSpTvAGdbXFnjZk
	0ok54EF66EtszMtMe4jixnSno7Ir+ue5QYFmOMgUBAjVxYjdtRNVFyVmvLPEpZznPq5RiO/4zpn
	sSfcWqqyygGXF28UQJKtNMtGYgGBGgT3zSPe63ZBaDj+fwfJyeV/TznCdMsaL5J+zB6Braygi8z
	71iz5nvtOJnvjbhwWeUxyE/w=
X-Google-Smtp-Source: AGHT+IFGA6yysX5rYii0EXHOc7wdrviuB8wTGOuSTKIEOmP0UAztX9Mp/wwZz0qOsZ6RV/4aH8D/dw==
X-Received: by 2002:a17:907:7241:b0:b04:38f2:9060 with SMTP id a640c23a62f3a-b0438f29593mr1159240066b.18.1756973510632;
        Thu, 04 Sep 2025 01:11:50 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0426516668sm972126766b.46.2025.09.04.01.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:49 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2137060046;
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
Subject: [PATCH v2 032/281] tests/functional: Move sh4/sh4eb tests into target-specific folders
Date: Thu,  4 Sep 2025 09:07:06 +0100
Message-ID: <20250904081128.1942269-33-alex.bennee@linaro.org>
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
sh4 tests into a target-specific subfolder.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20250819112403.432587-21-thuth@redhat.com>
---
 MAINTAINERS                                       |  4 ++--
 tests/functional/meson.build                      | 15 ++-------------
 tests/functional/sh4/meson.build                  | 10 ++++++++++
 .../{test_sh4_r2d.py => sh4/test_r2d.py}          |  0
 .../{test_sh4_tuxrun.py => sh4/test_tuxrun.py}    |  0
 tests/functional/sh4eb/meson.build                |  5 +++++
 .../{test_sh4eb_r2d.py => sh4eb/test_r2d.py}      |  0
 7 files changed, 19 insertions(+), 15 deletions(-)
 create mode 100644 tests/functional/sh4/meson.build
 rename tests/functional/{test_sh4_r2d.py => sh4/test_r2d.py} (100%)
 rename tests/functional/{test_sh4_tuxrun.py => sh4/test_tuxrun.py} (100%)
 create mode 100644 tests/functional/sh4eb/meson.build
 rename tests/functional/{test_sh4eb_r2d.py => sh4eb/test_r2d.py} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4a55a20f6a5..eddec0058e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1736,8 +1736,8 @@ F: hw/pci-host/sh_pci.c
 F: hw/timer/sh_timer.c
 F: include/hw/sh4/sh_intc.h
 F: include/hw/timer/tmu012.h
-F: tests/functional/test_sh4*_r2d.py
-F: tests/functional/test_sh4_tuxrun.py
+F: tests/functional/sh4*/test_r2d.py
+F: tests/functional/sh4/test_tuxrun.py
 
 SPARC Machines
 --------------
diff --git a/tests/functional/meson.build b/tests/functional/meson.build
index abaa4e00fca..ce713509e32 100644
--- a/tests/functional/meson.build
+++ b/tests/functional/meson.build
@@ -30,10 +30,8 @@ subdir('riscv32')
 subdir('riscv64')
 subdir('rx')
 subdir('s390x')
-
-test_sh4_timeouts = {
-  'sh4_tuxrun' : 240,
-}
+subdir('sh4')
+subdir('sh4eb')
 
 test_x86_64_timeouts = {
   'acpi_bits' : 420,
@@ -56,15 +54,6 @@ tests_generic_linuxuser = [
 tests_generic_bsduser = [
 ]
 
-tests_sh4_system_thorough = [
-  'sh4_r2d',
-  'sh4_tuxrun',
-]
-
-tests_sh4eb_system_thorough = [
-  'sh4eb_r2d',
-]
-
 tests_sparc_system_quick = [
   'sparc_migration',
 ]
diff --git a/tests/functional/sh4/meson.build b/tests/functional/sh4/meson.build
new file mode 100644
index 00000000000..56f824e1e71
--- /dev/null
+++ b/tests/functional/sh4/meson.build
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+test_sh4_timeouts = {
+  'tuxrun' : 240,
+}
+
+tests_sh4_system_thorough = [
+  'r2d',
+  'tuxrun',
+]
diff --git a/tests/functional/test_sh4_r2d.py b/tests/functional/sh4/test_r2d.py
similarity index 100%
rename from tests/functional/test_sh4_r2d.py
rename to tests/functional/sh4/test_r2d.py
diff --git a/tests/functional/test_sh4_tuxrun.py b/tests/functional/sh4/test_tuxrun.py
similarity index 100%
rename from tests/functional/test_sh4_tuxrun.py
rename to tests/functional/sh4/test_tuxrun.py
diff --git a/tests/functional/sh4eb/meson.build b/tests/functional/sh4eb/meson.build
new file mode 100644
index 00000000000..25e9a6e4041
--- /dev/null
+++ b/tests/functional/sh4eb/meson.build
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+tests_sh4eb_system_thorough = [
+  'r2d',
+]
diff --git a/tests/functional/test_sh4eb_r2d.py b/tests/functional/sh4eb/test_r2d.py
similarity index 100%
rename from tests/functional/test_sh4eb_r2d.py
rename to tests/functional/sh4eb/test_r2d.py
-- 
2.47.2


