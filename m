Return-Path: <kvm+bounces-56780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73838B43524
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A177D583F15
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79ACF2D028A;
	Thu,  4 Sep 2025 08:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QOmrJsiS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78882C1780
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973511; cv=none; b=VqPfOTtcp2zug8r1hRsQNswqaBF9ydTpJDHsdunSOhXWpQt9JoixaCRKXyDZGnOOcxFvJUx/xcw6AH9i13IPqwMO9Lfg+LekI5oDoKeXFkUtllxHKr0CB/VX25tx5UVqdqBFk7cYqTN0sHqmtnpdogJBFVc1vo/VFSDZ2Z2caf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973511; c=relaxed/simple;
	bh=SWpLLEKeZUUpUvhAxiBTlBToXP1NiBAaLW6nsRhuo7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=feSOZCX8sFYxdlWcjX7LcUZfDR9gAjk1bl+p8xi0/hRMDoe0609XHCz4p/fS0LT5jwFyg07XGhNUglcGQpDGZ2IvOXum10H+Zix2TLgmGGE042xaOmJJeLIa2K7taZzINWUSkWGrXszBibBqSL+iZnIuGKSfluAhZ1oA4ymp+EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QOmrJsiS; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afebb6d4093so142481566b.1
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973508; x=1757578308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=omV0Vr4nYXMtMeXSQYoBuMjm05IYf3r1DGykbz6eHk0=;
        b=QOmrJsiSEWrDm3pTfA9podIRTVITAS5skdygJZXNKMXXBtYRVV/W3wyicEZt8ckYMD
         Gj9WRDHDLeDAE4m6OPl4Y714QaY7oR27isXpK2R6E4vP2Jj9vj5XZU9JgFNfdtAcov6q
         rLnw4T8/hVQz1q1c+SQt2GYm8EhsH+Oz5Nld8lPEpDbTdx7WNO1kVVOyYXvlHTi+j7oC
         OLpiVkUgdpa2PlBxf3ULsFPjYDlAGCi3hxVyqH0qjCEj8/HdMTmvHPm6U9VLXHunwkAJ
         0xG7TOEstOVWKqAVum0tf1B1phV9WetqK3Q36+ITgypeSl3CXrhdKzfzCpMoVssNm9z9
         ngFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973508; x=1757578308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=omV0Vr4nYXMtMeXSQYoBuMjm05IYf3r1DGykbz6eHk0=;
        b=kMcWr2GbPJbN38pcvRc4QqYeCF1XfCpWhYMH7oxcGgdMbYku/w3cecsU9WiUh0LxoF
         GbNDu95mxnrPZM/bYl5O/ixfbCJafJw+4hTp7f1fAiuVszMZh3eS7YXDwa3iFX6t619r
         Oo76guKNFW5mzmSumkmE4f6K2+VFnUVjtobFgwlwEigk3L+Y7V+J0+ys9rdN6lBGM6HK
         u9QasiqR9VhZyeusmtjpaHjFLjg7J+qikQ5W1k7DJII+CHOCrJRh3CUvNvZrYWnKQKN+
         sXTIIZ//YrZCzZc2FmkiP2TsC5NIkTk4akDaev5oAfTc6NQlfOA/klHLyezMLJbVYWtK
         zzpg==
X-Forwarded-Encrypted: i=1; AJvYcCXsi4o5dvkg+iJ0RCvnBb9hYo0KcoaUl508BQNVdMXjE9dAbELXOJ1wvxAWajD3RD7fU64=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvrmNtaABuyrNeFXHuIVqa7x8YbTIrXZjBIuDsvh4H2ahOpldw
	AubAHi/cIsoahD7K0fLVwNagn/9TBo3Aixg1maKiVIvXFZV1lZQ10bD1ptmH9l6xA7M=
X-Gm-Gg: ASbGncvd+hm1v84RIHVOUHG3i1aOA1SGd1/loE0oMFLVSLfeY56KgDZI9luDT0vIqij
	Ti0JbNBdv3DO1AohtotpnyVKw2SVAnPifAb/QtNZB774ekNBBzGQpRszLG/LYQmFJH8eUX/NkFP
	215ojooWnH17yzvAbl6FlZmEbmFDcQUbHnbyeQbAdYaNT0yRwR0pHARsREBUMtZBCyOI5De0LQl
	fyhesDY5uKj14aTAQLrpJZZHNLt0DLDu3W+m3UMNfFe2C4Wd9E7yUYCIImUsmuNn1nXkkY95MRk
	4xSjbaO/Ka4Cree95hxn2XKKnYQ+g/SpGBA8yO86K0NU1zIcqZAlwPwf7S7BFCBJskBzXIyAG7W
	m++0Maj3X/qyShrMkIhunEsQ=
X-Google-Smtp-Source: AGHT+IFABY+GNZll4Er2gNXt3l+Crhs6fVMAbrNAexTY49T7TJMEwSOPjIndEkqPytMN7BQSr89N5A==
X-Received: by 2002:a17:907:3cd2:b0:afe:9777:ed0e with SMTP id a640c23a62f3a-b01af2e15camr1761502866b.0.1756973508120;
        Thu, 04 Sep 2025 01:11:48 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b046f888b95sm275965566b.34.2025.09.04.01.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:43 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B85DB5FAA7;
	Thu, 04 Sep 2025 09:11:30 +0100 (BST)
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
Subject: [PATCH v2 021/281] tests/functional: Move hppa tests into architecture specific folder
Date: Thu,  4 Sep 2025 09:06:55 +0100
Message-ID: <20250904081128.1942269-22-alex.bennee@linaro.org>
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
avr tests into a target-specific subfolder.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20250819112403.432587-10-thuth@redhat.com>
---
 MAINTAINERS                                                  | 2 +-
 tests/functional/hppa/meson.build                            | 5 +++++
 .../{test_hppa_seabios.py => hppa/test_seabios.py}           | 0
 tests/functional/meson.build                                 | 5 +----
 4 files changed, 7 insertions(+), 5 deletions(-)
 create mode 100644 tests/functional/hppa/meson.build
 rename tests/functional/{test_hppa_seabios.py => hppa/test_seabios.py} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index d01afcbea6d..2e1754912f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1273,7 +1273,7 @@ F: include/hw/pci-host/astro.h
 F: include/hw/pci-host/dino.h
 F: pc-bios/hppa-firmware.img
 F: roms/seabios-hppa/
-F: tests/functional/test_hppa_seabios.py
+F: tests/functional/hppa/test_seabios.py
 
 LoongArch Machines
 ------------------
diff --git a/tests/functional/hppa/meson.build b/tests/functional/hppa/meson.build
new file mode 100644
index 00000000000..a3348370884
--- /dev/null
+++ b/tests/functional/hppa/meson.build
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+tests_hppa_system_quick = [
+  'seabios',
+]
diff --git a/tests/functional/test_hppa_seabios.py b/tests/functional/hppa/test_seabios.py
similarity index 100%
rename from tests/functional/test_hppa_seabios.py
rename to tests/functional/hppa/test_seabios.py
diff --git a/tests/functional/meson.build b/tests/functional/meson.build
index 81eaa9c218c..8f85c13d3d1 100644
--- a/tests/functional/meson.build
+++ b/tests/functional/meson.build
@@ -13,6 +13,7 @@ subdir('aarch64')
 subdir('alpha')
 subdir('arm')
 subdir('avr')
+subdir('hppa')
 
 test_mips_timeouts = {
   'mips_malta' : 480,
@@ -78,10 +79,6 @@ tests_generic_linuxuser = [
 tests_generic_bsduser = [
 ]
 
-tests_hppa_system_quick = [
-  'hppa_seabios',
-]
-
 tests_i386_system_quick = [
   'i386_migration',
 ]
-- 
2.47.2


