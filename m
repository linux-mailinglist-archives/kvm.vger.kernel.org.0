Return-Path: <kvm+bounces-56803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0557B4356D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 950BA172696
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C344A2C0F81;
	Thu,  4 Sep 2025 08:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uZ4sadHs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3E2C11CF
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973924; cv=none; b=nvdZaSey6PygaZSnvyDYdYiZf5hlPjMiMS3W01SXlsm5MCbJuYp/LSqc6NCETBWovA/HWAM7EQ3EVY2w1sQRySqgTrx/YJnqlnq+gCsUWGcZ2sO1p+ZXBsdzbe/qLiP7thXrEwdp/D5YTSq4GwEOnQbzr02Gh55pQE6+a/Gsrkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973924; c=relaxed/simple;
	bh=LsXsjK1O8FAE242wbc0nS2I4z+31MWMil6kVUyeBEqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rd/Xwlkv19u+w8QnKWu4oZDa5fbmqM1qxYL7SSH36VHCJxYe+msKmZ+YNs/6MAMPr7RbvOXAhxnsMbrQ5GdBrc+qjh/ZUw9IAwRqR0FVFcioLYPCEFsQKLV4vokpn/4XuHsF2zUNNq7mub3HVxWhQEYarvWukR+UeE4x2J0zxug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uZ4sadHs; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb7ace3baso138913566b.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973920; x=1757578720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToC1ebEyvx+viBNvPFVlKTy11Wh6Rf+bOVhd1Ayq6zY=;
        b=uZ4sadHsj7HkkHpc3SJ3GDhlLmz2bEHGwFd8OiiE+C86Ct17GrNQbIczcSCyE8EjND
         v6YCA+N1vXmfeFbdX0pbFDgTvfDnB0/1KdgjofuKZFNqy34JWol5Lf0eqnyC+7XUBw29
         Fwng7FX86d1Qs8ptPH4xOf3qaAdEt2auHld7FpT3uIJoE+qRSxGpi8N1A6z5fI0Q51zW
         hXG0Zg2XCqTLdl52DNGnmWvodPbMxL9llg4PxB6emS9kBATzTJbX7mQivQUHLtaGtlAb
         931TuJCo3LVz8bxtMTzom5Q2ttmdRArPRhf1Fw+sg0PxtJtHK90R5sOZ4xy49U2TEwY7
         mPaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973920; x=1757578720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ToC1ebEyvx+viBNvPFVlKTy11Wh6Rf+bOVhd1Ayq6zY=;
        b=LGB172lfhJuxMNL4aHi8E7UvQCPL4CZbV+pJXLc2jJmlN+zeAgiyGIioO/a+Jxd9UQ
         9T+HQmbzGCGKObQ9I1twu1lQ7QDbUKD1J5NUjQHU1euWlZTYOlsl3vXgdBqMPrb/uLWh
         /h8W9ylrJsUOeoe/1Abli0XPoMGO7OCFEXiOAfaCMtj3xxBgbcyldQlvsYcu7HvcoVuo
         ysRlvFZDhFW2ynSHhw1UFCFHh8x2D36nMua/NJZCh1yX9DZEsvtXyUSBIxfPd5jo04+S
         0FnhTMfXTayIT4iUzfOLDaKAXXCINm47zXBrlp9Kul9F2gPKOaJP1JMqW03qOqxyodZb
         RQLA==
X-Forwarded-Encrypted: i=1; AJvYcCUUsv5p4gUaEBXUwqWiCcRib3fiphD8f65WWsPFCiHqouMZ1VyAfS/zXl6MqXrRsaS5Ybo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+I6LgVFb5RJQerrYuFhtsM65nlhqrBVcQqbib9vBM3dR5slVt
	uHV+kNuYQEk4K5LkzS1YLW1cZBBhidL6PvBec4BhRWWdXJiNT58PEq2iGKXW9i4vevw=
X-Gm-Gg: ASbGnct5mreZeKg01yq+u6j+F7BNa2XkPjEsrWtmWoRaHGQzyPS/oeCP04Bed7VNi3L
	jFOS8rcQI1vVk0aHopAkPvii6GAm6KGSuffX1hvyK/T65aUvVqYMW2SkHkaDIW3d05HRBYS4bYW
	aE3uIPcUzjVKMhZFNst93PBUTkOMGlHkiL3cPSB799NBu0N6CnPq9jexX64bZKCNmMXsume0NKb
	8lXNv3s+wHt7S/0/gyytHxt13LBHptJiNMWWb2PkyrsY3pwjiqHtn8Nfu9LhoHrAYhIfdOwQ1KK
	LwfUrfRyh4oeL0y50SE7gUbs51y1YmdjEQxUUwJpVNxqCskOiWhZgBubYCQ3mU6A3R328+w8J7e
	GO07mwa3bAyrVTVEi/Tn9/JaXQFIs6VgbhQ==
X-Google-Smtp-Source: AGHT+IHlrSAwTwlNPjt0KEhJGII6rpJIpVADSO6/94IfYv3scTnJu8lfG5J1x+SaVAePVJ42+HN21Q==
X-Received: by 2002:a17:907:1ca8:b0:aff:321:c31d with SMTP id a640c23a62f3a-b01d8a277c5mr1841124666b.7.1756973920286;
        Thu, 04 Sep 2025 01:18:40 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b02a090339esm1254356466b.37.2025.09.04.01.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:18:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 595EA5FA5C;
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
Subject: [PATCH v2 018/281] tests/functional: Move alpha tests into architecture specific folder
Date: Thu,  4 Sep 2025 09:06:52 +0100
Message-ID: <20250904081128.1942269-19-alex.bennee@linaro.org>
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

The tests/functional folder has become quite crowded already, some
restructuring would be helpful here. Thus move the alpha tests into
a target-specific subfolder.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20250819112403.432587-7-thuth@redhat.com>
---
 MAINTAINERS                                            |  3 ++-
 tests/functional/alpha/meson.build                     | 10 ++++++++++
 .../{test_alpha_clipper.py => alpha/test_clipper.py}   |  0
 .../test_migration.py}                                 |  0
 .../{test_alpha_replay.py => alpha/test_replay.py}     |  0
 tests/functional/meson.build                           | 10 +---------
 6 files changed, 13 insertions(+), 10 deletions(-)
 create mode 100644 tests/functional/alpha/meson.build
 rename tests/functional/{test_alpha_clipper.py => alpha/test_clipper.py} (100%)
 rename tests/functional/{test_alpha_migration.py => alpha/test_migration.py} (100%)
 rename tests/functional/{test_alpha_replay.py => alpha/test_replay.py} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index a2a5ccea7b6..8115aae6183 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -189,6 +189,7 @@ M: Richard Henderson <richard.henderson@linaro.org>
 S: Maintained
 F: target/alpha/
 F: tests/tcg/alpha/
+F: tests/functional/alpha/
 F: disas/alpha.c
 
 ARM TCG CPUs
@@ -656,7 +657,7 @@ S: Maintained
 F: hw/alpha/
 F: hw/isa/smc37c669-superio.c
 F: tests/tcg/alpha/system/
-F: tests/functional/test_alpha_clipper.py
+F: tests/functional/alpha/test_clipper.py
 
 ARM Machines
 ------------
diff --git a/tests/functional/alpha/meson.build b/tests/functional/alpha/meson.build
new file mode 100644
index 00000000000..26a5b3f2e4b
--- /dev/null
+++ b/tests/functional/alpha/meson.build
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+tests_alpha_system_quick = [
+  'migration',
+]
+
+tests_alpha_system_thorough = [
+  'clipper',
+  'replay',
+]
diff --git a/tests/functional/test_alpha_clipper.py b/tests/functional/alpha/test_clipper.py
similarity index 100%
rename from tests/functional/test_alpha_clipper.py
rename to tests/functional/alpha/test_clipper.py
diff --git a/tests/functional/test_alpha_migration.py b/tests/functional/alpha/test_migration.py
similarity index 100%
rename from tests/functional/test_alpha_migration.py
rename to tests/functional/alpha/test_migration.py
diff --git a/tests/functional/test_alpha_replay.py b/tests/functional/alpha/test_replay.py
similarity index 100%
rename from tests/functional/test_alpha_replay.py
rename to tests/functional/alpha/test_replay.py
diff --git a/tests/functional/meson.build b/tests/functional/meson.build
index 9cb6325360f..a7f8c88a078 100644
--- a/tests/functional/meson.build
+++ b/tests/functional/meson.build
@@ -10,6 +10,7 @@ if get_option('tcg_interpreter')
 endif
 
 subdir('aarch64')
+subdir('alpha')
 
 test_arm_timeouts = {
   'arm_aspeed_palmetto' : 120,
@@ -96,15 +97,6 @@ tests_generic_linuxuser = [
 tests_generic_bsduser = [
 ]
 
-tests_alpha_system_quick = [
-  'alpha_migration',
-]
-
-tests_alpha_system_thorough = [
-  'alpha_clipper',
-  'alpha_replay',
-]
-
 tests_arm_system_quick = [
   'arm_migration',
 ]
-- 
2.47.2


