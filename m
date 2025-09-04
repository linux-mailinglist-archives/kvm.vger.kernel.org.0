Return-Path: <kvm+bounces-56773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4846B43523
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19F007C3E3C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6662C028D;
	Thu,  4 Sep 2025 08:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oxZjjMsv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A432D2C11C9
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973500; cv=none; b=uheaEistc9eh7sdmx4bcku4hlHvYsqKeg31uqKNtXn8qi3gAZiW3w7P3wlet/fFjkS6+yHtA+LfE5H/LWYdDfMbGnn1pebUFBERVYa2KUsxVTjqBzUV4zH+UUjH0ck2Sl4xY9JPKtLnyME9VsiXvmmCdop5qpwjtXnHCVLCLu30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973500; c=relaxed/simple;
	bh=Mv/obcxo/LPdGJY935SHwyuslvB6scPFuwqwwhZd+k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Za4Wtx5IaG/UIighZaUzUN6tMfdKOsjDz7iQO2cq7FjLfb+jvPJ6TLe7JwM29sj/BPeLDMYrHwgrQ4dHZBA5X3nuMKLzWwQM3m+VMTMGymz8+Zs7MrfpA1PY+zZwns+M2yUkTyJp725qStScPaqgjxTIYPWUff+fud6lJtzh+B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oxZjjMsv; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad4f0so1271164a12.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973497; x=1757578297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npkBvBgQubJv2X1tCwkde0FzzeXErtznEAkpfHdfgYk=;
        b=oxZjjMsvSmKfZnFaQxmDbG51izhHqbVYEb6uKvobFXCtn6T5XgXWguxQlOdRSeoD6x
         vQd4d+tCVaUzI3cyI5dZCzPq2B29cYSSqw0xsNpn1whyOmbPIsCYd+4yTDKzKx71xOAy
         rFWhI5LYTk53AWSGoVZoMVe86OFwrJGBKFNLaMH2cRMjvTHK35bFg44K6vI2IJ4e5Xz9
         s1zOlot7SXip5Q4+o9AUgQyGNy1YnOBJp6CRbQw/th/ejAIOmj2shhL2JJhr3zYyY8fR
         2dAUKH1mS5mGkHTRJxfxc4etklMmxYhq8DNMN9ObYdJeOqCy45LrvK8GGzwRnESIfLC/
         M2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973497; x=1757578297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=npkBvBgQubJv2X1tCwkde0FzzeXErtznEAkpfHdfgYk=;
        b=uo3artNo1H6ft9y1h+i4mZJt5YbXJ0LLOAG3IsJwkSPofJGZr2Ql6F6pU47toltFro
         uAKEGFx/XbIdyegVfZNQG0GeScZwDIzLr+QJuPCdpICvqO2rw1EYGN7l5w9mqBGAQP4b
         sgyo9N/ck/p1bXqHRb86gE9dITddSiLu6hKl0VUoi0ACy/FqcqCGJMiHLq3Dfzw+/GsF
         lNO1MjtFyhKq1kWFb1Ssg9G8m+w7HQFb2IYJKtXr8H6ISCX4t7F8WTTVEpU2gOOM69Ln
         ZZGm5z9YjnqVTT51jW379lckis25sqCN5kG5cLTfir24ZhK0xLVrbwJwsZ5OdmeIK3T1
         D2Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVV7m6DSk8f6reU6JluN8wUKsa+wQqw/jMNfSD/e6MB6bPDua3gUG5Itqz6U0IaVeoBAZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyajZca4zBEybTQvBd1RQP+7fQyQb2YS5cN+XErobd33eNxVvMR
	Z3hTpGeYOyftH3qIA71uPBMPbpaQAX5WvJ/Lixf8Q9aiHRMPU9Sb8ih+tKbYr32L5GE=
X-Gm-Gg: ASbGncuqZQiA0Wchl/1SurmAS/QBidDFTAH7U101p3+8/IIUq25LyZS6lRGdSEP35iD
	x3vpQgb3cXIrvvz+ZLtZGTm6YShcc1ctDKIsexAm9hkLFDe3nFnN3iXz1fRoSHdCupjG3JUvHGZ
	VdJaCUTSI3p3di03vtkW8xsHWS0soj+t2Qe+k4SOl6JIRFxNqEB/PYRRTmW39vfDoil5N9yYNzw
	pGisLDDEtlPolhz1DBPNKigkITwFIiwCTpvUnJCml/Ym/SRxFddvUIE0R1Huhd/U5ytQDGv7evh
	dqIXkR0dQkzFNVb3aVI8qzpzOJtugdk922M1+cGibXe+OFMsXjOHuaGzkr3X0Io31LdyEspOfK4
	5YJmvXZ0u9GrFblg7hJTSyjM=
X-Google-Smtp-Source: AGHT+IGEHcZDYSofdWUr8Bqng6QeMWXp/4Bc/tOlM+ePo4sSl/15T602ad6FUMUNNzOlh6Biq8rLZw==
X-Received: by 2002:a17:907:c1f:b0:af6:a10a:d795 with SMTP id a640c23a62f3a-b01df90c1e4mr1937783366b.55.1756973496744;
        Thu, 04 Sep 2025 01:11:36 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff9918dbd2sm1326671166b.103.2025.09.04.01.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:32 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B4E6D5F937;
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
Subject: [PATCH v2 005/281] MAINTAINERS: add a few more files to "Top Level Makefile and configure"
Date: Thu,  4 Sep 2025 09:06:39 +0100
Message-ID: <20250904081128.1942269-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

A few files in scripts, and the list of packages in pythondeps.toml, are
strictly related to the toplevel build scripts.  Add them to the
MAINTAINERS file stanza.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a07086ed762..0f3e55b51e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4392,7 +4392,6 @@ R: Philippe Mathieu-Daudé <philmd@linaro.org>
 S: Maintained
 F: meson.build
 F: meson_options.txt
-F: scripts/meson-buildoptions.*
 F: scripts/check_sparse.py
 F: scripts/symlink-install-tree.py
 
@@ -4403,6 +4402,9 @@ R: Thomas Huth <thuth@redhat.com>
 S: Maintained
 F: Makefile
 F: configure
+F: pythondeps.toml
+F: scripts/git-submodule.sh
+F: scripts/meson-buildoptions.*
 F: scripts/mtest2make.py
 F: tests/Makefile.include
 
-- 
2.47.2


