Return-Path: <kvm+bounces-50206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3551AE260A
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 424431896A02
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FB6243956;
	Fri, 20 Jun 2025 23:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZTm+7vo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462A32417C3
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 23:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750461666; cv=none; b=TOMP8XSk905skfc8jIWQkz6srR8S2v1bgVe2NRmE3LcJtqJPfVGapIlFHLLnmnp1OlGkC68PPDE+oPdo/UCGh1/wt5bzO/hhAYmy1VLKSdOw9ZO3dI2trV1uo3VShimdCMXqed72r8pbCJKUZN4If80H0JJpGRcdQLyP0QkkPrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750461666; c=relaxed/simple;
	bh=cfbcYQT/0EULNPGHPrgqVQx8XCxpvqx3I53+Aox0UdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZEdV2Iup6DQvyp9asJaorxJ7URd/vV02HrfsxLd4ooaD6e5jVB91juCUcefVhWj+KPpniOaxg4MNdm7tewOO3BoumAzQ9ch/gv0pTj6FqLAGgfK+qyLt0JLeLFCLYtODYMVWXepVN06TVbL9id2u/oudDl9uG9oHoodZN6v6ciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZTm+7vo; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748d96b974cso1961958b3a.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 16:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750461664; x=1751066464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=APzdfr9A/hBMbv017gVqLgGBcbquIdHEboqu0JTdsJY=;
        b=FZTm+7voSXZpLkmB+5KdlIgyAWfNmOng1UHRyN6V8vycQah6G3YEpexX5wrGwq2vdD
         HAGJDEwY2XFI6icNE6zS9ZlMxLuSCr8r8Y0QF53wO3u61xM6p6aPS/OxHMEMoJG0FGBi
         RkKyQiSM8juiv8RPQJ76IfB89duEpIWBrSEcyR+ot463GZbsy/WM8LC7my8Boz9MGqha
         2KlJbJeKrPRxUHNSSz7O1F+GIiguoBY17KKcMSDpRxzXXK9uYuhjLHuFueewWxETP/Gi
         7+Au1qRnnK0SMG4UzclY0j3yH34C4d6XsL8WkyvJuTsiNfJ5yyYAkFuAOjVDTYw0jpoL
         cQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750461664; x=1751066464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=APzdfr9A/hBMbv017gVqLgGBcbquIdHEboqu0JTdsJY=;
        b=uGo1fZIBETQKeTiBHBJLR95DugzZijWaMBMhIMpcVlbOfQufDk9FrMb4yEIapzrmJn
         C1JhWLsmJEfFbWxx+FyKgFmLQQs/HYQcLYjlDQJ64vAAjc0O7ybJ8GzB5GWqK7j2BkCB
         JTuGDobocUGBvo4dfang4Iqt7HQG601+5Y9hHllusthCmErNFPbvscDGSf+sqNNkLiHK
         lOkLOUpeRTmd3Z7ZFZvNuJY+6l3MngQ9j1zEwMfW05ftGoEVAwnjPquOG5vZgjD3Itc6
         3GnaA0MHF+cvAhTEJTmRTMWUT1og/5TTxJKJsreMxn7wImUNY2g7QRkma+0fE1Ozz849
         zerA==
X-Forwarded-Encrypted: i=1; AJvYcCUVT3FU2L+UsJug40b+0yKCjCdDCirO8SLu7MswwN1kDYg4JxlZJZSQ0xTr+rHJU+ZkIkc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yznf5oH5/NrhC6jYgMI3yFLQ3tVzTIs6Ya28GBqspjl/FkWXWZQ
	CQZWUTLWfathCwJHZZ81A7rP7T3kfu7j5EsC3znV8vKBNAEEb4u0tx+j731JoOmhRMSI+escELx
	kdTHCN/gV9frQkg==
X-Google-Smtp-Source: AGHT+IFgW5K83UIJEpwFN6RFNHRki1SO8HNtAgwjEFZw5Kh/hAeMfrNShDYFKP3Z/3/2Q+Anjx+OcmKywoGJsQ==
X-Received: from pfme9.prod.google.com ([2002:aa7:98c9:0:b0:742:a99a:ec52])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3cd4:b0:748:e38d:fecc with SMTP id d2e1a72fcca58-7490d71c76amr5373142b3a.22.1750461664562;
 Fri, 20 Jun 2025 16:21:04 -0700 (PDT)
Date: Fri, 20 Jun 2025 23:19:59 +0000
In-Reply-To: <20250620232031.2705638-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com>
X-Mailer: git-send-email 2.50.0.rc2.701.gf1e915cc24-goog
Message-ID: <20250620232031.2705638-2-dmatlack@google.com>
Subject: [PATCH 01/33] selftests: Create tools/testing/selftests/vfio
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Bibo Mao <maobibo@loongson.cn>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Wei Yang <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Create the directory tools/testing/selftests/vfio with a stub Makefile
and hook it up to the top-level selftests Makefile.

This directory will be used in subsequent commits to host selftests for
the VFIO subsystem.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                             | 7 +++++++
 tools/testing/selftests/Makefile        | 1 +
 tools/testing/selftests/vfio/.gitignore | 7 +++++++
 tools/testing/selftests/vfio/Makefile   | 2 ++
 4 files changed, 17 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/.gitignore
 create mode 100644 tools/testing/selftests/vfio/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index f2668b81115c..79a096dc259d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25900,6 +25900,7 @@ F:	drivers/vfio/
 F:	include/linux/vfio.h
 F:	include/linux/vfio_pci_core.h
 F:	include/uapi/linux/vfio.h
+F:	tools/testing/selftests/vfio/
 
 VFIO FSL-MC DRIVER
 L:	kvm@vger.kernel.org
@@ -25972,6 +25973,12 @@ L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/vfio/pci/virtio
 
+VFIO SELFTESTS
+R:	David Matlack <dmatlack@google.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	tools/testing/selftests/vfio/
+
 VGA_SWITCHEROO
 R:	Lukas Wunner <lukas@wunner.de>
 S:	Maintained
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 339b31e6a6b5..ad6312cd2338 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -123,6 +123,7 @@ TARGETS += uevent
 TARGETS += user_events
 TARGETS += vDSO
 TARGETS += mm
+TARGETS += vfio
 TARGETS += x86
 TARGETS += x86/bugs
 TARGETS += zram
diff --git a/tools/testing/selftests/vfio/.gitignore b/tools/testing/selftests/vfio/.gitignore
new file mode 100644
index 000000000000..6d9381d60172
--- /dev/null
+++ b/tools/testing/selftests/vfio/.gitignore
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+*
+!/**/
+!*.c
+!*.h
+!*.S
+!*.sh
diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
new file mode 100644
index 000000000000..2bba39aff5d9
--- /dev/null
+++ b/tools/testing/selftests/vfio/Makefile
@@ -0,0 +1,2 @@
+CFLAGS = $(KHDR_INCLUDES)
+include ../lib.mk
-- 
2.50.0.rc2.701.gf1e915cc24-goog


