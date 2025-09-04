Return-Path: <kvm+bounces-56799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56652B43568
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:18:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B01E188317D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47952C08D7;
	Thu,  4 Sep 2025 08:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jCbHlKDf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10992741D1
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973920; cv=none; b=pUCPfwmxqeSPfOp/h06N2aHM+Ozref+iSDFC5YisXZ3vHeQhssLbWUXno+/ZMPNaZGhLF40IP1V+azaBO5ML8zg7LR4/yk0sCo7sO8qgtE2OQbaHBkTkzmGDvTEhS46mEDSTMIXeaGGE0qoOf3SEH7VIK5phcNiaLrPz9qXsZhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973920; c=relaxed/simple;
	bh=k2l2BOo6xzc2Mt0D1Ef+i1c/GXZQh1VlvyCUVY9nmo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PSJXkNBhu6qKFTsyCcUhXNWR5kxcrBWJ8+JGEGo2KStCwQHW/8N7GH0ONeHo27tSpjS9l+k8JHhyVvbuDE47hAGXRmUVio+f6908BqF+uzO6zqTMiP2sBFmWRQahhwzR6v+OEi1FpHA2pGe8INqXK7XYL8cyDg902yI5UlMXm9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jCbHlKDf; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b046f6fb2a9so112230866b.2
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973916; x=1757578716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ompVlJELO9ntgp7NqWovDalEEm5jaDFBaNVePh2Fg+k=;
        b=jCbHlKDf7vaSk8IBmGhkj6j2NW7ES+cDVQICkUB2XxSLigJK6jWDfZWV5+MHWN24ZG
         xphRotS6jCbAgOU6t0jvw5fcUlpYhSOy63ySFlTSBx8Qhii9V0fp5LBYSD7fXYdjpYOe
         IUCnY//Zk1BViWqnI4YIpOH2iwNU0gSw0GIZQr7eO7QcGTI79Z0D2geI95N1+707ueSr
         qxDAHEMUexAOzb6rhvpCQG5KA/6+z7420RIdCAOxmeLPwY6VrdHPEWeanigupGsz33xX
         Vr359NIIqHQRsH8CNl+LcrHL20MyFzqAG/q2FUHigjtrml4LowhXdtx/c1UyZPzRlNUC
         gywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973916; x=1757578716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ompVlJELO9ntgp7NqWovDalEEm5jaDFBaNVePh2Fg+k=;
        b=ad+uo3mk7OvTTAnwmsFAlWv1V1P5DyluBCriODrpSIRwRpRsWpvfBv9mk6h2sqCdYv
         2QaTbdIsxdleAFsUNR8eXNe1Whs/wG98tV8kINRo2fERcQ31P+7aqLui8A/Q/woDFVSK
         lmszfFoI1QrFao+gJ7xu260cAKKnbmBbSeo8TfZhwt44W42Hq1Y9eWyq0wfhPMYX36di
         2GzOlC1byZsf1Azum/JewOFSVVLa+IZOBbzl4L5dKGnny8coPPGiZjttXn63gAMHMUA/
         DbSZq5UkkXLBMPC4WsknyjyFYwOUbk5mNktSKOe57Lfh5u55AYOzUx7D3a3zINx1F+Fr
         AImg==
X-Forwarded-Encrypted: i=1; AJvYcCVewojw6aDu0sPfKFKsEsMx//uko/zUhLnufTO1trzffLwEe10U3L4eszc+KmXYqLLV7sY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr6nd7lR4UNTC2kPKHtYYl2Gx4wW4Ij++568pvHsrKPNaZy1vW
	+MXi+DOxiGJkkfTVI0E4pGOWicBM6yBgn3WlSZJG5q7YBIA7D7FZVQYjVmyrT2xTfdM=
X-Gm-Gg: ASbGncsjk9AcVtuJbMzSgzUwz9nQfOX5GkzR3WX+ibqX6SrA7NcWHbr8YbkM/wCnVT7
	vrEyAjVEz3/Lk1VjQjJe+PRz+DhA6NlSrF9ADxk3QW+m3ZccgIyCFnXKKYO5tahUpGIckTPhR4p
	ygxqpQuvqVsW1aKpk4pnC2bKM1Y45opHSI3QuYO1lteSn0t7kR0gCuuNKeuZE0vL89TfBEy5yJH
	QUdIeONPjlkhHs/lrO6bHBsd0PAzK5HFWs5p+Lr5v1T0mS2Tve3f88mf7J2jYVE8fJD2ti0hQZb
	u7ooZwSdpZsyTPRVOBWU3rZ0B0ETUGrzsuLUjC2Ibb7UbCLZgCEqY51HNgTi57s52zj/OrRv0wh
	uOHfh/h4lLvV8dg0WL2VY5s8DTs7are+k8g==
X-Google-Smtp-Source: AGHT+IFXKnqgaKsY2aRYlcO4LSLsCuART/SZSEUFpFcB1viH9haZ5yBXysPjsYR6aV+gJtHba4UXNg==
X-Received: by 2002:a17:907:e916:b0:afe:ae6c:411c with SMTP id a640c23a62f3a-b01f2113c64mr1656930766b.64.1756973915989;
        Thu, 04 Sep 2025 01:18:35 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff138a8c1dsm1395320766b.99.2025.09.04.01.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:18:34 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 58E905F9D0;
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
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH v2 010/281] tests/functional/test_aarch64_virt_gpu: Skip test if EGL won't initialize
Date: Thu,  4 Sep 2025 09:06:44 +0100
Message-ID: <20250904081128.1942269-11-alex.bennee@linaro.org>
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

From: Peter Maydell <peter.maydell@linaro.org>

If you are using the Nvidia drivers and have installed new versions
of those packages but have not yet rebooted the host kernel,
attempting to use the egl-headless display will cause QEMU to fail to
start with

$ qemu-system-aarch64 -M virt -display egl-headless
qemu-system-aarch64: egl: eglInitialize failed: EGL_NOT_INITIALIZED
qemu-system-aarch64: egl: render node init failed

together with this complaint in the host kernel dmesg:

[7874777.555649] NVRM: API mismatch: the client has the version 535.247.01, but
                 NVRM: this kernel module has the version 535.230.02.  Please
                 NVRM: make sure that this kernel module and all NVIDIA driver
                 NVRM: components have the same version.

This isn't a problem with QEMU itself, so reporting this as a test
failure is misleading.  Instead skip the tests, as we already do for
various other kinds of "host system can't actually run the EGL
display" situation.

Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
Message-ID: <20250826123455.2856988-1-peter.maydell@linaro.org>
Reviewed-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Acked-by: Alex Bennée <alex.bennee@linaro.org>
Acked-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 tests/functional/test_aarch64_virt_gpu.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/functional/test_aarch64_virt_gpu.py b/tests/functional/test_aarch64_virt_gpu.py
index 38447278579..4e50887c3e9 100755
--- a/tests/functional/test_aarch64_virt_gpu.py
+++ b/tests/functional/test_aarch64_virt_gpu.py
@@ -76,6 +76,8 @@ def _launch_virt_gpu(self, gpu_device):
                 self.skipTest("egl-headless support is not available")
             elif "'type' does not accept value 'dbus'" in excp.output:
                 self.skipTest("dbus display support is not available")
+            elif "eglInitialize failed: EGL_NOT_INITIALIZED" in excp.output:
+                self.skipTest("EGL failed to initialize on this host")
             else:
                 self.log.info("unhandled launch failure: %s", excp.output)
                 raise excp
-- 
2.47.2


