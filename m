Return-Path: <kvm+bounces-47618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 599BEAC2C29
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04E639E64C6
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA814217F36;
	Fri, 23 May 2025 23:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="goMCujzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43DC1C5F27
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043034; cv=none; b=X5AOVoTNkRSTvALmZyDy3+7J1NiXZAI2v4iwKPcrnQZq0PfvL0KYmqsHVFxzN2bytmmiTesgJ6tD8cux5TtywmGMiNFiaAjYur8mfmZeqvvhpBXtKjT2QUcW5ELXowiKR5K6Vw+eK3BdjN91+jKuUj6L7pUHSZ8Mvn35uRD+Gx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043034; c=relaxed/simple;
	bh=Eovj7enExFrmaorTy2c5lDeHTWqV0yrpjy/ZyeHJEdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qJx9yOOKZvJBhXQ9w53bE3m+ohoIcuy1C/76D6YDMgm07eLDNndqxRe9ITI0bYNGyqks0dhdwWiyU+zIN/RbjZkkjsLwNXpk4lDumKGDKR5028hDTRMy5Hnyt4ICk8xEMOtTi6JCBgchgo3CMBU5SnUKxysgrnTzT9VAFupcSso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=goMCujzJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31107a2d3a6so421831a91.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748043032; x=1748647832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YFWKU8DuoaX/PtHBZncZN7QPtCf4ybBqbYBaO92KsDo=;
        b=goMCujzJfM6g+fLJ/mDuhhvDWreQVISOjLRFlVkAXlnOY1VlaNg8Y8hwKe9XFI6wSq
         xAYd0Z2uYF3ovHErta5M85JV6/971ESyMfLtqDPxHyUzObbD3Hv1dFapzkPzOAgPnywu
         a2HBTVNauC5mHppzYo1uvWqp9r+WyAAaBfSetCM/KMFliBQI7O8JJs3mFVL5+GcSMwYb
         cidBf+StApJPVw50jZkIiHkfL572Q+ZW/YlPUSJSWiwK/wW4ch8yW0WHdfP+r01aUGWe
         1YJLcIhiYzbjtWc1ygl8lH0WyMCA/gD/devFlLYUwzk+3+h+nnHnoYCiGhj+nh5IGFij
         s34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748043032; x=1748647832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YFWKU8DuoaX/PtHBZncZN7QPtCf4ybBqbYBaO92KsDo=;
        b=WzXADyCs2RK4dWM/vsIuu18STMauLBtiid7Obh/7zKw8WWTcwLDoz6s4T1iNBGRA5F
         up4lZV2O45h1ZyUGTwba0V1oo/skMfzv0D/TFocUDr9CqE9uAIRzbRalouZ1HqK8Q7/q
         KPAszGx6RcNrSwG/21Wrvh7SNwbQ6QhPnaHuH32qXUNpaL+hkBtVVzcbczrGVFIk0Rwn
         mocOZZJ5diym7zX5vOKTgVtq92IyIOWpzgHtYTAuhF2b0JxplwaxgIUaZjx2DBEihNbp
         BUYldQDjR+5pI+WrUO89WgJMd5ADvEIYAAEEf70PvTlCZPnpAWCoJVeDZDfIKYkCYGF7
         w5ow==
X-Forwarded-Encrypted: i=1; AJvYcCXRkGvLGTHSDCOCj1s8FoMdzxSb/hiYduFDwPZPgTl/lXYJ8nHbftGq2Dqcrl3VbMEMBus=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH+/V+Qz7uStLd1CSB1loqBGZL8u79MXahurK8a2n34lrtLK97
	KmXLRcQKyt1qy3nULMNYQ/AnvW1hzKNE/RlAbd/BSrtw8v8yZj9p2DUuiMnRD3XhT2/aM8AFxAf
	sEgdUdBtUUfgbww==
X-Google-Smtp-Source: AGHT+IF+Z0hjn4awYmjtqXM8PTU+zKEw/zW2vAqo1DMf4XAX0mM00O2TDL3VOErIAo2Iej/NT4RW7Id+e2wDFA==
X-Received: from pjbsd11.prod.google.com ([2002:a17:90b:514b:b0:30a:2095:204b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ec6:b0:30a:4700:ca91 with SMTP id 98e67ed59e1d1-3110f31c2ebmr1243143a91.1.1748043031826;
 Fri, 23 May 2025 16:30:31 -0700 (PDT)
Date: Fri, 23 May 2025 23:29:46 +0000
In-Reply-To: <20250523233018.1702151-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523233018.1702151-2-dmatlack@google.com>
Subject: [RFC PATCH 01/33] selftests: Create tools/testing/selftests/vfio
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
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
index 3c6f9e70ace0..ff17343c7fa3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25493,6 +25493,7 @@ F:	drivers/vfio/
 F:	include/linux/vfio.h
 F:	include/linux/vfio_pci_core.h
 F:	include/uapi/linux/vfio.h
+F:	tools/testing/selftests/vfio/
 
 VFIO FSL-MC DRIVER
 L:	kvm@vger.kernel.org
@@ -25565,6 +25566,12 @@ L:	virtualization@lists.linux.dev
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
index 80fb84fa3cfc..7681ebb6bd02 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -120,6 +120,7 @@ TARGETS += uevent
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
2.49.0.1151.ga128411c76-goog


