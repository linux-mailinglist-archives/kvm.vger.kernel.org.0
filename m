Return-Path: <kvm+bounces-56778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7ACB43528
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02EC9686EFD
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC592C324F;
	Thu,  4 Sep 2025 08:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xg0C6YbC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39972C1585
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973506; cv=none; b=Nr2RzjBUh6zbrd82UYkuVoaMOBejG3rtd9pGNR59Vu8jCCxVAGBpwbvKjgHX/oHjv6OhkMAIty5M66zjIvnX4y4Ja8wIQW2lftkfTl5IYNidXKBt/c03OTXnwhw5tluEeQl34f4sB3Xuqx0Di3uwMWodhfm/Da47jqsZ8vDldHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973506; c=relaxed/simple;
	bh=ZHzuEjS+tIsAD+34TyxBcrkEz+QsALk9vHVGZLvzMEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ix1zp0BAbKcBWDSMCFFXYqyzCfimVZNPq8jsVkXvObLqL1ofnmd4N+2zcIuKX1DPuamyfLH+7VgPZfNAiJjjzG/vA673MDwFnSezZhKpC+hAbMtB/KkE+v5tydo2H2KjOjq0VJhN4IxX9ayfy8k1LD09hUIn2R5tnpFqXePUoig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xg0C6YbC; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb7ace3baso137843566b.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973503; x=1757578303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KFEhhh8NSACPPy03lAUeW1WvXOIqiNIP9Gmw/5CKVpI=;
        b=Xg0C6YbCM/g3C+uGG2+rZ738ALD7tQ/zAt1ue75wJQrKUW1qXYQlLM2Aat/i/BhA1T
         23hkrQDh/qWSyCEW2RVmO2pyaEyEAOF60+JprZra4TFxiA1dkOBTXeaFmdMcj6FME7MJ
         a9yDFHyUL6EJADWlTYAePuGyDTf8WagCq5OrO4mfsBsLigTdNDj63e+QUd3Ez47KKkiM
         kiWvPg3hKC+HnPCKxt70JOTRH+ZGIdsv87ukgxU19+vfjNRGRL7uqSPBVfo1NTd2p55k
         tUQskR5wFjSlmjMYk2jgRkNzbpsx3PLz1cEH0PU1ubLTlu4cPwRMHJlqgj7QvFbkVe1J
         7hpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973503; x=1757578303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KFEhhh8NSACPPy03lAUeW1WvXOIqiNIP9Gmw/5CKVpI=;
        b=Taq8QDRzgaNiiwl6PAP6I/XE6XLeoT1npbGCWhtLjwMfx8pMGNG/9us3LNrWSCMUhP
         fzhRhVS/Os+jLZO6wnj01Ztl3uH7234HYHDVFPun7PDuYLM8w9YqTkGLB5XSquY/zHvL
         OtcllqvBrN/w4/qAeobYIeCwbk0adnmev5m8WvsnYDB/M2zJNY7iRd8HjuuvOBdoV2Zh
         YhzTSsphf40VXMDv4IswERKK5RAo7YO5mKSHRZ4UmCOKVCbCkC6895LCxtEI22etZdAP
         80w7lmMONFUGahadL34/NTd6ZfI80rWdHBJgKf54rCIVpHYMNrqmrBG0XmtNbHzfo0Du
         kY1A==
X-Forwarded-Encrypted: i=1; AJvYcCVfJDdiA4AGjW6VeJOoTCVhjbKPU4PyhZnnQenOh5K+pE5y6UvSQTwVgdaC14/dqhaY7hQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKsUH5omHszJ05MVGsFZFDGVdIWq448hl9au5OJY/b9RpuffHz
	K7a9bNTHmUDCP716NIDmlg00vbj85/9pNDobcapxFkb6P8bQEWTKp31hi4w5MuDfnFw=
X-Gm-Gg: ASbGnctXBLW25l/jfvP2eYf7m8KFEKUkb+TZnRuViYlWuVUbmniztPE7WxyUzY5RDN6
	FbopQJ9Z4/5LGW1Ofd2zmqMIcSs4l3w49LPrFYiGug89UzCluRWEjWjjlt5BGBzVT692IwVlMD9
	6kiaMXE463TZ2qjnEJymJYmfNBv5i8B8hYEXjD70LYHuCiV7d0fUiDihiv17d9FHc3SYtxfOFNE
	U1BQerB/G9/ltrUZ0wD9WoVu8gD8AlCCiNzROHz9yBRqCRKnAdz0M4zQ+WfkAzTt7kv03lBFBvH
	6JOkAC8CbcYIWwNdCwtjfgu3syKTWQ5LK3/ElItZDrys0+kVxaCQqCyiZKebaNA3vulYKPgOzk7
	xml9P6mLBo0WLNjXu4IpMLjAJMYyTEdwLzQ==
X-Google-Smtp-Source: AGHT+IFlmoTtWtJZg3Geb0kfl+Z+ucuFEHRktCaxjXa7c0bTRextSI2xhSOy4rmatDTUkMpDVjITog==
X-Received: by 2002:a17:907:3e8f:b0:b04:6c19:ed8d with SMTP id a640c23a62f3a-b046c19eea9mr457804566b.26.1756973503102;
        Thu, 04 Sep 2025 01:11:43 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc4e50fbsm13438274a12.38.2025.09.04.01.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id F0D1B5FA1B;
	Thu, 04 Sep 2025 09:11:29 +0100 (BST)
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
Subject: [PATCH v2 015/281] tests/functional/meson.build: Split timeout settings by target
Date: Thu,  4 Sep 2025 09:06:49 +0100
Message-ID: <20250904081128.1942269-16-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Huth <thuth@redhat.com>

We are going to move these settings into target-specific subfolders.
As a first step, split the big test_timeouts array up into individual
ones.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20250819112403.432587-4-thuth@redhat.com>
---
 tests/functional/meson.build | 50 +++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/tests/functional/meson.build b/tests/functional/meson.build
index 38ae0d6cd3b..356aad12dee 100644
--- a/tests/functional/meson.build
+++ b/tests/functional/meson.build
@@ -10,7 +10,7 @@ if get_option('tcg_interpreter')
 endif
 
 # Timeouts for individual tests that can be slow e.g. with debugging enabled
-test_timeouts = {
+test_aarch64_timeouts = {
   'aarch64_aspeed_ast2700' : 600,
   'aarch64_aspeed_ast2700fc' : 600,
   'aarch64_device_passthrough' : 720,
@@ -25,7 +25,9 @@ test_timeouts = {
   'aarch64_tuxrun' : 240,
   'aarch64_virt' : 360,
   'aarch64_virt_gpu' : 480,
-  'acpi_bits' : 420,
+}
+
+test_arm_timeouts = {
   'arm_aspeed_palmetto' : 120,
   'arm_aspeed_romulus' : 120,
   'arm_aspeed_witherspoon' : 120,
@@ -44,24 +46,55 @@ test_timeouts = {
   'arm_replay' : 240,
   'arm_tuxrun' : 240,
   'arm_sx1' : 360,
-  'intel_iommu': 300,
+}
+
+test_mips_timeouts = {
   'mips_malta' : 480,
+}
+
+test_mipsel_timeouts = {
   'mipsel_malta' : 420,
   'mipsel_replay' : 480,
+}
+
+test_mips64_timeouts = {
   'mips64_malta' : 240,
+}
+
+test_mips64el_timeouts = {
   'mips64el_malta' : 420,
   'mips64el_replay' : 180,
-  'netdev_ethtool' : 180,
+}
+
+test_ppc_timeouts = {
   'ppc_40p' : 240,
+}
+
+test_ppc64_timeouts = {
   'ppc64_hv' : 1000,
   'ppc64_powernv' : 480,
   'ppc64_pseries' : 480,
   'ppc64_replay' : 210,
   'ppc64_tuxrun' : 420,
   'ppc64_mac99' : 120,
+}
+
+test_riscv64_timeouts = {
   'riscv64_tuxrun' : 120,
+}
+
+test_s390x_timeouts = {
   's390x_ccw_virtio' : 420,
+}
+
+test_sh4_timeouts = {
   'sh4_tuxrun' : 240,
+}
+
+test_x86_64_timeouts = {
+  'acpi_bits' : 420,
+  'intel_iommu': 300,
+  'netdev_ethtool' : 180,
   'virtio_balloon': 120,
   'x86_64_kvm_xen' : 180,
   'x86_64_replay' : 480,
@@ -404,6 +437,11 @@ foreach speed : ['quick', 'thorough']
                                build_by_default: false,
                                env: test_precache_env)
       precache_all += precache
+      if is_variable('test_' + target_base + '_timeouts')
+        time_out = get_variable('test_' + target_base + '_timeouts').get(test, 90)
+      else
+        time_out = 90
+      endif
 
       # Ideally we would add 'precache' to 'depends' here, such that
       # 'build_by_default: false' lets the pre-caching automatically
@@ -419,8 +457,8 @@ foreach speed : ['quick', 'thorough']
            env: test_env,
            args: [testpath],
            protocol: 'tap',
-           timeout: test_timeouts.get(test, 90),
-           priority: test_timeouts.get(test, 90),
+           timeout: time_out,
+           priority: time_out,
            suite: suites)
     endforeach
   endforeach
-- 
2.47.2


