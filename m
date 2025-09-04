Return-Path: <kvm+bounces-56772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DCCB43522
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2125C7C45F0
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454932C11E2;
	Thu,  4 Sep 2025 08:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mClMqv2P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E962C11C6
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973499; cv=none; b=ChPdPLFraHI+smcIUGdfU3fwOCMDBFFEsZ8u+ylqVDooXgKZEUX0GtmkaO9eSqlwR1AwoQIzSBN+nXonvqfdfAE463TkfpGzmYOvzPdQLnD3StvqXqf5lBtFVtsCXDsC2YWIXtmrykH9yVwSSWiZrSFawkXBbI5dLusab9VtRPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973499; c=relaxed/simple;
	bh=zu1LXP6rhyiOpL2wPJe0GxiX4pJVRDMff1/5Xg3DoWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SraQGtGPwYbQD66DnZb+6u8alkSve+JnASW8tHoRd41eDe40ifxKDgytyJWETCUko67usP0awgY5DaWjNr+0cRTShY0GdF7APrZDzKv9u/Glp68mRSbdY+mwJbl3v7uzI9D+eoFQgvXSSkLD2A9V8XikSQZCeGM+JkkLbmS/NJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mClMqv2P; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b042cc3954fso129232466b.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973496; x=1757578296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XYe2srEOzuPavOLB2dyXu3UjjKzRy0khJhV96Tf8OLU=;
        b=mClMqv2PFsQ+zDAyqIk6Uwf1SXeX22y1/P4TGubYw34tljclmfRZgHtOCuMv7qsdPA
         4XCja1c5m2D4q+gvHBSs+zFE5hqUTxV8kjvQcvjcN5RVu4kWIud5P27nG8BlaaQfM7f3
         sGxkKLgLzNUa3d33qBkGK8nBwFY9nt2AnB4u4NpppfYVT9Ek371lSKG9HabdOOJKPAXx
         LzOwpq3bxXLLLNki/KVa11F5BNkFDM6v5dOvGH/FmKq0aSp0lJ9FmD1mTWojwRnG0liH
         cX85yUeUE/8QVdQSA1gzbhogkFMPGiVFk7RWt+kEMyaOwAcij1JU0VbE5J7faiz1GDDu
         jT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973496; x=1757578296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XYe2srEOzuPavOLB2dyXu3UjjKzRy0khJhV96Tf8OLU=;
        b=JFAz1IFwKxn7HGXUckDGjnNF94Jt6XTyfhuyrBSZUj/it/NH36d2a2MgMQIyW/NKWt
         79p6a+G4DWpI/e+80EwNFpX+y/Edy9EytLiGx5uYvF3VD+GvanmPEqEOmw68ksx7gFjF
         EQI1gFvjmVtRuMofCI1DdHvMSv/8+2Z/Txkt0oXmaUn27uFmbZxH32jqBluX56ycqxy2
         nzTskNll7vt9rEoELRAWDed7eSKADCuEAN5ZVCKyZtMcdTYO2EFn2CZDLEAY35U28GDd
         w2fZFp93C86ML0xmrEG14K+69pxYfWDvNnsIiHlgviR4lsREsk5KszwMXVltD27x/4IT
         jvvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUM4Niij0w4IY22MxG6veVyUlK0pilggrfBXqVxFAAD4THJILSASnVAael7JTfye5qxRUk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi+suCPePKsRVVkT5UXrvt/XzbEl+qVPPAIlBt3AmPo1ORFtBG
	NJMkczDXrCWNPqeQjgAX4uNcnpuBsgASUYaV6DzxxmAQ5/pTgoO2ZjO11OxCNJN5cZI=
X-Gm-Gg: ASbGncvAahurC0WkNF3dQnvCisV8kEKb0ftNv33Xi00u8jhle9syH2VBV3sEPbAsr08
	rvXyLDoljtk0whZeqwKF4w/Do2TkfvLQLQJEaxo+f9JXo3ZqOMojMMkVZTbiu0EVC/ARS80LnLX
	ftWYdfAgvh1ga7Qj4iWsq80gYLhFCZckhB8WyRrGHUS+mh0l3/2ml19UJtaiA6W4U4h5w5GnrFI
	GYS11Ls8RV1lufykragMX/s+xiGjKm4kgnYtcz5Y20Xc884iiKUhHKLDHp4a4ds/huypCTt9YO0
	3G/RnYT+3jUL4YtNuaP8md3L+FtM2fAxe8X5mBLaNIdz4ed1A/ISD0KrEfA6VbFBCbC1mG5mm//
	O6Hj5rAvz0ncY/q6bXaoJep0zgksfHLt0gQ==
X-Google-Smtp-Source: AGHT+IFuFf8b0FN8m1f6QwjfoO5kUp2eWUieR36l5Mw4cqCx0SRMNKUchjBVGkuWlbdtmtCQOxC3yA==
X-Received: by 2002:a17:906:7953:b0:b04:813e:491 with SMTP id a640c23a62f3a-b04813e1a1amr139361166b.12.1756973495989;
        Thu, 04 Sep 2025 01:11:35 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0471c7a163sm248962666b.47.2025.09.04.01.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:32 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 807A05F92E;
	Thu, 04 Sep 2025 09:11:28 +0100 (BST)
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
	John Levon <john.levon@nutanix.com>
Subject: [PATCH v2 003/281] scripts/minikconf.py: s/Error/KconfigParserError
Date: Thu,  4 Sep 2025 09:06:37 +0100
Message-ID: <20250904081128.1942269-4-alex.bennee@linaro.org>
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

From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

Error is not defined in this script, raise KconfigParserError instead.

Fixes: 82f5181777ebe04b550fd94a1d04c49dd3f012dc ("kconfig: introduce kconfig files")
Signed-off-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Link: https://lore.kernel.org/r/20250820-scripts-minikconf-fixes-v1-2-252041a9125e@linaro.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 scripts/minikconf.py | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/minikconf.py b/scripts/minikconf.py
index 2a4694fb6a3..4de5aeed11a 100644
--- a/scripts/minikconf.py
+++ b/scripts/minikconf.py
@@ -363,7 +363,9 @@ def parse_file(self, fp):
 
     def do_assignment(self, var, val):
         if not var.startswith("CONFIG_"):
-            raise Error('assigned variable should start with CONFIG_')
+            raise KconfigParserError(
+                self, "assigned variable should start with CONFIG_"
+            )
         var = self.data.do_var(var[7:])
         self.data.do_assignment(var, val)
 
-- 
2.47.2


