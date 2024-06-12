Return-Path: <kvm+bounces-19434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 443C990508F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25AAC1C211CF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E4816EC0B;
	Wed, 12 Jun 2024 10:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bm5vK1gs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5903B16EBFA
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 10:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718188812; cv=none; b=t/q9t596jHBmffL9tTuFbZHB/ZpRwh5EbLKd22HwapyqA5CggCSLQ5Wz/b1iLnR9vZSApwnobL8t25ua4GwFotwLUFvWL17Ylk6UkMMqOjJsrHr9t0xAj0K30T36mGN0KyGzI5zxWs1zekKRF+F6u1NAVP0Kj36cyOZm2n/y9to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718188812; c=relaxed/simple;
	bh=tvEptQHY+WeN4YvID509DhHGbCd1y8DDqVwSzqixeUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GacDwBJca/hXrFNr2DU4RGnE1f4pnzo9tBwf5kNJ/kCL+t5XTMu/x5jR5FkOwBU46IhGH7ESN3AbDlCZZNz3Iu5QfAGVA0gnJtzosHYncMNrP2eUucqjjLwqD58GtqL+rnaysriTghCn93dIUvRjZrAm+clBPc0/HHLc/AXRLsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Bm5vK1gs; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-35fdf7aa8a1so347795f8f.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 03:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718188808; x=1718793608; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ACWLaJj/sO7FE/x9hMeKNNuOBgDiWPG8HyrO4oVecec=;
        b=Bm5vK1gsUstuAFdf5Gf2RYTOm3WB/OHNZMahsoSQ2mI943hL/Bz3NKQmm6PUWsktFh
         kKWIA8gU7Y1JTjNh/PBxgw9K19YAvYT+z1iT+qCS+xdmNu661niRt9TfA5FqVBAK9UKl
         8wIPpEjrH8ncFZIupUpdIM3gLx1V0/dWZT05pie0oAGRaTR4QLwFMWgIrsZ8MbA67OR6
         36N8kw3p9No8O4kK0Q5FpB/1vV2+TWyT0JvBccKYzx7i2hXU3wNhinC+N7/Q4OXqr4fD
         w8wSGMnIdWnBSACTzFIHg0b/iJTVQ/efT8qf2nVsXXCeSVYNRkhjbE//4Kxm9fdtPrOn
         fZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718188808; x=1718793608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACWLaJj/sO7FE/x9hMeKNNuOBgDiWPG8HyrO4oVecec=;
        b=hNyCdP57GrWPE+QR7grBnWu+bAIxkM/G155rlbARP5MJCB5oJ1EinkyR1+t4JdWaf3
         DkyVfPqyy/46mVRguH6a8cECWXjrY5vYCvFDMJDrAkH0NSMhwc63buNvcwcH7iI2EqNB
         mDDoo355TX83EpPnh2ZAfUPUptw4IHJZNU2k6NWiMdpQ/iAfvq8EgKVk4YMXew65Jy8l
         kQnc9jcgH6zck4v9/QjgD9yTb+7n3jXwZuFkGczqmlNhs5HFpsxSjwlPpzOSY5aDg3fa
         C5uIDmioTY6UlqJ4Un4RWotf8xMwtZdxC05guWuHLqEe1+OqIC455Hm3KX4/5HeigXJ/
         JdmQ==
X-Gm-Message-State: AOJu0YzCs69mQ2YcrkL2lbMpWa05x+s5HRKMyX2x+qwumjvNliqo/WkC
	iRlfk5fDAgY0llrkRjQiruWR/qXgFN/+OX2vrOq1nyesrmEm/okecXSA1aXTRn4=
X-Google-Smtp-Source: AGHT+IFajuOTDnrq2pHCCq72kII5joVpB6r6hgB9X0A1ac5/NT6lJbaYlvsP7mzlklqXw70Hx30DVg==
X-Received: by 2002:a5d:47a9:0:b0:35f:1f49:f784 with SMTP id ffacd0b85a97d-35fdf779c98mr953464f8f.12.1718188807568;
        Wed, 12 Jun 2024 03:40:07 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f1aa8d4f3sm10874877f8f.99.2024.06.12.03.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 03:40:06 -0700 (PDT)
Date: Wed, 12 Jun 2024 11:40:23 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
Message-ID: <20240612104023.GB4602@myrica>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-3-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/N5098jZq9Eqa4T2"
Content-Disposition: inline
In-Reply-To: <20240605093006.145492-3-steven.price@arm.com>


--/N5098jZq9Eqa4T2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2024 at 10:29:54AM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Detect that the VM is a realm guest by the presence of the RSI
> interface.
> 
> If in a realm then all memory needs to be marked as RIPAS RAM initially,
> the loader may or may not have done this for us. To be sure iterate over
> all RAM and mark it as such. Any failure is fatal as that implies the
> RAM regions passed to Linux are incorrect - which would mean failing
> later when attempting to access non-existent RAM.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Co-developed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

> +static bool rsi_version_matches(void)
> +{
> +	unsigned long ver_lower, ver_higher;
> +	unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> +						&ver_lower,
> +						&ver_higher);

There is a regression on QEMU TCG (in emulation mode, not running under KVM):

  qemu-system-aarch64 -M virt -cpu max -kernel Image -nographic

This doesn't implement EL3 or EL2, so SMC is UNDEFINED (DDI0487J.a R_HMXQS),
and we end up with an undef instruction exception. So this patch would
also break hardware that only implements EL1 (I don't know if it exists).

The easiest fix is to detect the SMC conduit through the PSCI node in DT.
SMCCC helpers already do this, but we can't use them this early in the
boot. I tested adding an early probe to the PSCI driver to check this, see
attached patches.

Note that we do need to test the conduit after finding a PSCI node,
because even though it doesn't implement EL2 in this configuration, QEMU
still accepts PSCI HVCs in order to support SMP.

Thanks,
Jean


--/N5098jZq9Eqa4T2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-firmware-psci-Add-psci_early_test_conduit.patch"

From 788bfd45e7ce521666a19dba99277106e4d33c80 Mon Sep 17 00:00:00 2001
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
Date: Tue, 11 Jun 2024 19:15:30 +0100
Subject: [PATCH 1/2] firmware/psci: Add psci_early_test_conduit()

Add a function to test early if PSCI is present and what conduit it
uses. Because the PSCI conduit corresponds to the SMCCC one, this will
let the kernel know whether it can use SMC instructions to discuss with
the Realm Management Monitor (RMM), early enough to enable RAM and
serial access when running in a Realm.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/linux/psci.h         |  5 +++++
 drivers/firmware/psci/psci.c | 25 +++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/psci.h b/include/linux/psci.h
index 4ca0060a3fc4..a1fc1703ba20 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -45,8 +45,13 @@ struct psci_0_1_function_ids get_psci_0_1_function_ids(void);
 
 #if defined(CONFIG_ARM_PSCI_FW)
 int __init psci_dt_init(void);
+bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit);
 #else
 static inline int psci_dt_init(void) { return 0; }
+static inline bool psci_early_test_conduit(enum arm_smccc_conduit conduit)
+{
+	return false;
+}
 #endif
 
 #if defined(CONFIG_ARM_PSCI_FW) && defined(CONFIG_ACPI)
diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index d9629ff87861..a40dcaf17822 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/linkage.h>
 #include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <linux/pm.h>
 #include <linux/printk.h>
 #include <linux/psci.h>
@@ -767,6 +768,30 @@ int __init psci_dt_init(void)
 	return ret;
 }
 
+/*
+ * Test early if PSCI is supported, and if its conduit matches @conduit
+ */
+bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit)
+{
+	int len;
+	int psci_node;
+	const char *method;
+	unsigned long dt_root;
+
+	/* DT hasn't been unflattened yet, we have to work with the flat blob */
+	dt_root = of_get_flat_dt_root();
+	psci_node = of_get_flat_dt_subnode_by_name(dt_root, "psci");
+	if (psci_node <= 0)
+		return false;
+
+	method = of_get_flat_dt_prop(psci_node, "method", &len);
+	if (!method)
+		return false;
+
+	return  (conduit == SMCCC_CONDUIT_SMC && strncmp(method, "smc", len) == 0) ||
+		(conduit == SMCCC_CONDUIT_HVC && strncmp(method, "hvc", len) == 0);
+}
+
 #ifdef CONFIG_ACPI
 /*
  * We use PSCI 0.2+ when ACPI is deployed on ARM64 and it's
-- 
2.45.2


--/N5098jZq9Eqa4T2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-squash-arm64-Detect-if-in-a-realm-and-set-RIPAS-RAM.patch"

From fcb16e1eb494d2ce21792495955d6d3f26c319c9 Mon Sep 17 00:00:00 2001
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
Date: Wed, 12 Jun 2024 09:08:17 +0100
Subject: [PATCH 2/2] squash! arm64: Detect if in a realm and set RIPAS RAM

Before issuing an SMC, detect whether SMCCC is available through this
conduit. On platforms that do not implement EL3 nor EL2, the SMC
instruction is UNDEFINED. SMCCC advises probing the SMCCC availability
by first looking for a PSCI node in DT (or in ACPI, but we expect a
realm to boot with DT at the moment). Since RMM requires using the SMC
conduit for both PSCI and RSI, we rely on the PSCI method property to
ensure SMC is available.  We could also check that the SMCCC version is
at least 1.2 as required by RMM, but no platform requires this extra
step at the moment, and we can't use the SMCCC helpers this early in
boot.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kernel/rsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 898952d135b0..21fc261a1d26 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -7,6 +7,7 @@
 #include <linux/memblock.h>
 #include <linux/swiotlb.h>
 #include <linux/cc_platform.h>
+#include <linux/psci.h>
 
 #include <asm/rsi.h>
 
@@ -82,6 +83,12 @@ void __init arm64_rsi_setup_memory(void)
 
 void __init arm64_rsi_init(void)
 {
+	/*
+	 * If PSCI isn't using SMC, RMM isn't present. Don't try to execute an
+	 * SMC as it could be UNDEFINED.
+	 */
+	if (!psci_early_test_conduit(SMCCC_CONDUIT_SMC))
+		return;
 	if (!rsi_version_matches())
 		return;
 	if (rsi_get_realm_config(&config))
-- 
2.45.2


--/N5098jZq9Eqa4T2--

