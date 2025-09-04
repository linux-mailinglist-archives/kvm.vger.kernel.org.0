Return-Path: <kvm+bounces-56777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2658B43520
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09E21179E56
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA1A2C15A8;
	Thu,  4 Sep 2025 08:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F26mfxKh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF192C1591
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973504; cv=none; b=JeSzyEe+bckApxENNvOTILG3Ld/3350izQzFRFsRt9jxowaIyU8qu/CCVEWIt1Rav1mncGIz7aYfYRmIEwDTbZtLlminVYGVnvCpyxq5wtcLF94G96PnxbztG5LSDMbDudTXg6lC7pi5VvdO9oXXNH89CB0VhselrD1CCplEwm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973504; c=relaxed/simple;
	bh=nDa/w62RhNabl54inCkIq5LPANqAfmDIeGjZ5LtWeXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4PoCy4pvglaidP43GomizeG+4tU8fZsLptFzBPUcWfV9FHt1a9FVqlQBlzomgQJgEN56CCWlXzFPWZwyNAgoXvYTvJfYNo3f4YAyKE9eQFmP7z26UWovFw2xIIEDulAGy3qFmQlbBuK/LWWLwW1sRNoh7rtUfZYnIpNPpFLiXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F26mfxKh; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b042cc3954fso129248366b.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973501; x=1757578301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3j1jG2MY/WGcH+crz7CtyaM5tw55oKFFqSyUb2OGtbM=;
        b=F26mfxKhH171TBBFBb8dgAypNcruEBG/UTOwAWm1O+8nfrefarhjYQfptc+xmFqrpB
         7ETeJje3optH5BZo9PjDbCxb51dn/nj6bxX+FTT5cdygbegQd2hIWFeXOhPAXjWApgPw
         g7KVdMCn8fRebjczO61ntPpLUVYLr7EJq7tadSovLg4r4C6iSXQlC7ZPkWc32O9Rje6D
         jlA/HTM8KuZ0cdXWErR4LapQNEJqwifdS8xXZYJjApGuinf4EYpu/J23CSz99KoK0FqO
         Ll/njlxwLCw1OJulgcwcHd5XDkJvJQszg1HJ4zaQnVemi2p8koBa9XN118k4CzEGFrPO
         ZRzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973501; x=1757578301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3j1jG2MY/WGcH+crz7CtyaM5tw55oKFFqSyUb2OGtbM=;
        b=DzFeqgxLGM9DL8UKbKxk1xusA8vrppktBhSLbqR0PL8DETYDK324U4WeIAtRnxVCnj
         WJDWpQ+JrSFqDQTVzNsqdynO/M7jIC55KGa9c6Tf1EVSmuK/i8kVW2HJ5L8XoUwG43mt
         HtG9zmJzWvrw/uecOngIg6ZzfsI6lRul3kmxAUqhsjsg/WDOXXvH30HDJohywpWKFUov
         WD4N5Q3qTRbbBOy7zF2klQHzBVh5Z8kQOVo3YMI+bDbz7SrZHF7Cj3gP6MgOq1LXPWID
         mdnJ45r3lwY6Vu25CcIb/gWNSLxHI5nRb870X5KMZ+zroM6ptmv1XM5/3ZdS1Ys6kWZ/
         4wIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6Kw8fhfCv51gdJlAnUQnfpgfs6fqrvz5Ob351EhVJFv+/EHWhthwyAbrJ3AWdJ3VOb74=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU6hhaxg8PxwsJ8bur7thRp6niszK9adWDW5ajRcCoCOckWqjA
	a10+jlAUsyhHWHCNFSaIyPbB1wauoAB/xk9yi6nJUr1Cr8ICE5xCF5IuFc7a/w/+lKA=
X-Gm-Gg: ASbGncvQVyawRsybLQpLSBzK26ippx6bZuZPFuNal7w89CB0RJx2svF1b8S9KD1/Ma6
	MN8l9MN0zV2s5hz5SbCGlkOjvwoBL6UG63S2CKq6dQrY5nI/q3f6ftVdaGwXXbSnSvrEwEWibXh
	k5+PjuM2gOUwQSmzbhezbQKXO1Yz8260eULSf7qedLNDN5exj969cb12We3JMxAwSipbX2fj35R
	vUjlEQdyO8dCAvvtxCcsiyL4d6kXU+9WtFmHWAU6MDxwsMn4fGzuY+MhDkshOJwxC3Gs8YGU9x3
	8QB1CF6tTxIVu1utr/S9p1H8CEgioeJ/OLQVERW9VTgUsLrbcJog2XzV7J9n7CHHpJFvdoZtQil
	/MDdXxAZQhvODTXvLNQpAiKJWqR0En7Yc4A==
X-Google-Smtp-Source: AGHT+IHtaOAptd/dOyrxka90iG+Ickwt+7m6mDEjwCXtB/2x+x0WNk1ZvG1BgsoUzoIQQ2o03oW8Ow==
X-Received: by 2002:a17:906:4789:b0:b04:1a1c:cb5b with SMTP id a640c23a62f3a-b041a1ccc38mr1426344866b.7.1756973501036;
        Thu, 04 Sep 2025 01:11:41 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b03ab857474sm1225662366b.89.2025.09.04.01.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 71DFF5F9F7;
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
	Gustavo Romero <gustavo.romero@linaro.org>
Subject: [PATCH v2 011/281] tests/functional: Fix reverse_debugging asset precaching
Date: Thu,  4 Sep 2025 09:06:45 +0100
Message-ID: <20250904081128.1942269-12-alex.bennee@linaro.org>
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

From: Gustavo Romero <gustavo.romero@linaro.org>

This commit fixes the asset precaching in the reverse_debugging test on
aarch64.

QemuBaseTest.main() precaches assets (kernel, rootfs, DT blobs, etc.)
that are defined in variables with the ASSET_ prefix. This works because
it ultimately calls Asset.precache_test(), which relies on introspection
to locate these variables.

If an asset variable is not named with the ASSET_ prefix, precache_test
cannot find the asset and precaching silently fails. Hence, fix the
asset precaching by fixing the asset variable name.

Signed-off-by: Gustavo Romero <gustavo.romero@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Message-ID: <20250827001008.22112-1-gustavo.romero@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 tests/functional/test_aarch64_reverse_debug.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/functional/test_aarch64_reverse_debug.py b/tests/functional/test_aarch64_reverse_debug.py
index 58d45328350..8bc91ccfde7 100755
--- a/tests/functional/test_aarch64_reverse_debug.py
+++ b/tests/functional/test_aarch64_reverse_debug.py
@@ -21,7 +21,7 @@ class ReverseDebugging_AArch64(ReverseDebugging):
 
     REG_PC = 32
 
-    KERNEL_ASSET = Asset(
+    ASSET_KERNEL = Asset(
         ('https://archives.fedoraproject.org/pub/archive/fedora/linux/'
          'releases/29/Everything/aarch64/os/images/pxeboot/vmlinuz'),
         '7e1430b81c26bdd0da025eeb8fbd77b5dc961da4364af26e771bd39f379cbbf7')
@@ -30,7 +30,7 @@ class ReverseDebugging_AArch64(ReverseDebugging):
     def test_aarch64_virt(self):
         self.set_machine('virt')
         self.cpu = 'cortex-a53'
-        kernel_path = self.KERNEL_ASSET.fetch()
+        kernel_path = self.ASSET_KERNEL.fetch()
         self.reverse_debugging(args=('-kernel', kernel_path))
 
 
-- 
2.47.2


