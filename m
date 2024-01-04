Return-Path: <kvm+bounces-5685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D9D8249EF
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:01:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE8A92846CB
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 21:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9B32D606;
	Thu,  4 Jan 2024 21:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cfy6tm61"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89ED02C842
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 21:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704402005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YPVgRV/8ao3J2YIK03QpOJTZI+xUh5KxC9+6PtmG1vk=;
	b=cfy6tm618KUh0xe0A4XQmVBXDs5fHk26hi8EI7E9RDYKWwj6jLX+W+mxJ6PIaajI/FeEJ8
	PcuT5hNJ1brld43C4Ib4uIk6lwGk4NuKjPje561gioX52rXCLwZJ6uXVZsGnc0KNTSFAE7
	U3bR4ir7MkzA7RmhvBZfoUd7LREtN5E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-aDmS3lvqNvSbq7FZuw-cTg-1; Thu, 04 Jan 2024 16:00:00 -0500
X-MC-Unique: aDmS3lvqNvSbq7FZuw-cTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66FE78B27A4;
	Thu,  4 Jan 2024 21:00:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4584D1121306;
	Thu,  4 Jan 2024 21:00:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: ajones@ventanamicro.com,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 2/4] MIPS: introduce Kconfig for MIPS VZ
Date: Thu,  4 Jan 2024 15:59:57 -0500
Message-Id: <20240104205959.4128825-3-pbonzini@redhat.com>
In-Reply-To: <20240104205959.4128825-1-pbonzini@redhat.com>
References: <20240104205959.4128825-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Since MIPS/KVM only supports hardware virtualization using MIPS VZ,
do not enable KVM blindly.  Use a new Kconfig symbol CPU_SUPPORTS_VZ
and do not enable it for R2 processors.

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/mips/Kconfig     | 9 +++++++++
 arch/mips/kvm/Kconfig | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 797ae590ebdb..3eb3239013d9 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1250,6 +1250,7 @@ config CPU_LOONGSON64
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_HUGEPAGES
 	select CPU_SUPPORTS_MSA
+	select CPU_SUPPORTS_VZ
 	select CPU_DIEI_BROKEN if !LOONGSON3_ENHANCEMENT
 	select CPU_MIPSR2_IRQ_VI
 	select DMA_NONCOHERENT
@@ -1389,6 +1390,7 @@ config CPU_MIPS32_R5
 	select CPU_SUPPORTS_32BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
+	select CPU_SUPPORTS_VZ
 	select HAVE_KVM
 	select MIPS_O32_FP64_SUPPORT
 	help
@@ -1405,6 +1407,7 @@ config CPU_MIPS32_R6
 	select CPU_SUPPORTS_32BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
+	select CPU_SUPPORTS_VZ
 	select HAVE_KVM
 	select MIPS_O32_FP64_SUPPORT
 	help
@@ -1459,6 +1462,7 @@ config CPU_MIPS64_R5
 	select CPU_SUPPORTS_HUGEPAGES
 	select CPU_SUPPORTS_MSA
 	select MIPS_O32_FP64_SUPPORT if 32BIT || MIPS32_O32
+	select CPU_SUPPORTS_VZ
 	select HAVE_KVM
 	help
 	  Choose this option to build a kernel for release 5 or later of the
@@ -1477,6 +1481,7 @@ config CPU_MIPS64_R6
 	select CPU_SUPPORTS_HUGEPAGES
 	select CPU_SUPPORTS_MSA
 	select MIPS_O32_FP64_SUPPORT if 32BIT || MIPS32_O32
+	select CPU_SUPPORTS_VZ
 	select HAVE_KVM
 	help
 	  Choose this option to build a kernel for release 6 or later of the
@@ -1492,6 +1497,7 @@ config CPU_P5600
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_MSA
 	select CPU_SUPPORTS_CPUFREQ
+	select CPU_SUPPORTS_VZ
 	select CPU_MIPSR2_IRQ_VI
 	select CPU_MIPSR2_IRQ_EI
 	select HAVE_KVM
@@ -1614,6 +1620,7 @@ config CPU_CAVIUM_OCTEON
 	select USB_EHCI_BIG_ENDIAN_MMIO if CPU_BIG_ENDIAN
 	select USB_OHCI_BIG_ENDIAN_MMIO if CPU_BIG_ENDIAN
 	select MIPS_L1_CACHE_SHIFT_7
+	select CPU_SUPPORTS_VZ
 	select HAVE_KVM
 	help
 	  The Cavium Octeon processor is a highly integrated chip containing
@@ -1969,6 +1976,8 @@ config CPU_SUPPORTS_ADDRWINCFG
 config CPU_SUPPORTS_HUGEPAGES
 	bool
 	depends on !(32BIT && (PHYS_ADDR_T_64BIT || EVA))
+config CPU_SUPPORTS_VZ
+	bool
 config MIPS_PGD_C0_CONTEXT
 	bool
 	depends on 64BIT
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 2eb119e78b6e..1156112ffa13 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -17,7 +17,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
+	depends on CPU_SUPPORTS_VZ
 	depends on MIPS_FP_SUPPORT
 	select EXPORT_UASM
 	select PREEMPT_NOTIFIERS
-- 
2.39.1



