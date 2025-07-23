Return-Path: <kvm+bounces-53278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDFE7B0F970
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7332D18850AE
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E8923E335;
	Wed, 23 Jul 2025 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Oz2/BBuh";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="/vBOYfN8"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E020823AB8F;
	Wed, 23 Jul 2025 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753292219; cv=none; b=jb2OqLHCI4FHLfQ2yzuiEH6pT5RAjV59YWXyqFkn0/eXtxMAXeMZhqtjfS4KrwtdejrRtbUfYlDfu1+N5NrZjEFUGH6Uc00fpA8PfHjX8b8FF+DHATEE/XQitQPPeCV1u28fFjYoM98CX26vQfeGQBPyW4IrNPDXLPjrQzaNI3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753292219; c=relaxed/simple;
	bh=l8ElQRAT1Hszveqk+X21k8IIcIZzDZmj+WUDZsTY2C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsZ/BkLyR/1+ZwVzSXghSGuBDA/4xHbsBzS6NIHGFCAQD0+sgSTjdxsUB3+ZDEwvKBvJ8eMhiUZPxT3i5xS2NSco1uPhq66XO/kkpErNANFhxCUEDTxnJYATm/C+OsIbiF/FBQmQ41JQve8QTwZZYDfWkX70uGMmphXkfcD8NZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Oz2/BBuh; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=/vBOYfN8; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753292215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILIDCHvFGsvZiwtpyNNKEdOsJOlcSIX04cXR7l0HOA4=;
	b=Oz2/BBuhJmgKRlQrQZWZZ7ibSmuWwaXKJYs1sq2cwzH3kOU/WoegfqHGr4OJ7mKEShLJ8e
	CdTJggS/Hk/NlUWIm/Jv5yTWDHF72ReI3Pu35pvledlrLomIQRoLV9riNHmsYsQGOQA3Dz
	V3LU0tlfLrMH4wMKZx25WhhtJ28B9V4inLmJMJ5OfwUDLi9lqfAZaivoNovjW2zUS83sKE
	Mz3Ysig9HvuNM+UphyriGmc5D6bhl6qE9wLvfs4Hm80tda/7FFIy8PRJ5IYgeATBzVJSWk
	hKkeypJRDEDpCF1OwPXXaBN+z7nodkucmoPMA7fj5rE4jo7qC7eEfwzv7Bhkaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753292215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILIDCHvFGsvZiwtpyNNKEdOsJOlcSIX04cXR7l0HOA4=;
	b=/vBOYfN83H3Fk/UG/i6tkEMBD+aB2zYaQUnGn+XwSMRr4hGVus20/cGKWOiIvFNkJcUkUt
	uLK/8LBqdycD5zBg==
To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Ogness <john.ogness@linutronix.de>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	x86-cpuid@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>
Subject: [PATCH v4 2/4] ASoC: Intel: avs: Include CPUID header at file scope
Date: Wed, 23 Jul 2025 19:36:41 +0200
Message-ID: <20250723173644.33568-3-darwi@linutronix.de>
In-Reply-To: <20250723173644.33568-1-darwi@linutronix.de>
References: <20250723173644.33568-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit

    cbe37a4d2b3c ("ASoC: Intel: avs: Configure basefw on TGL-based platforms")

includes the main CPUID header from within a C function.  This works by
luck and forbids valid refactorings inside the CPUID header.

Include the CPUID header at file scope instead.

Note, for the CPUID(0x15) leaf number, use CPUID_LEAF_TSC instead of
defining a custom local macro for it.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
---
 sound/soc/intel/avs/tgl.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/sound/soc/intel/avs/tgl.c b/sound/soc/intel/avs/tgl.c
index 9dbb3ad0954a..cf19d3a7ced2 100644
--- a/sound/soc/intel/avs/tgl.c
+++ b/sound/soc/intel/avs/tgl.c
@@ -10,8 +10,6 @@
 #include "avs.h"
 #include "messages.h"
 
-#define CPUID_TSC_LEAF 0x15
-
 static int avs_tgl_dsp_core_power(struct avs_dev *adev, u32 core_mask, bool power)
 {
 	core_mask &= AVS_MAIN_CORE_MASK;
@@ -39,22 +37,31 @@ static int avs_tgl_dsp_core_stall(struct avs_dev *adev, u32 core_mask, bool stal
 	return avs_dsp_core_stall(adev, core_mask, stall);
 }
 
+#ifdef CONFIG_X86
+#include <asm/cpuid/api.h>
+static unsigned int intel_crystal_freq_hz(void)
+{
+	return cpuid_ecx(CPUID_LEAF_TSC);
+}
+#else
+static unsigned int intel_crystal_freq_hz(void)
+{
+	return 0;
+}
+#endif /* !CONFIG_X86 */
+
 static int avs_tgl_config_basefw(struct avs_dev *adev)
 {
+	unsigned int freq = intel_crystal_freq_hz();
 	struct pci_dev *pci = adev->base.pci;
 	struct avs_bus_hwid hwid;
 	int ret;
-#ifdef CONFIG_X86
-	unsigned int ecx;
 
-#include <asm/cpuid/api.h>
-	ecx = cpuid_ecx(CPUID_TSC_LEAF);
-	if (ecx) {
-		ret = avs_ipc_set_fw_config(adev, 1, AVS_FW_CFG_XTAL_FREQ_HZ, sizeof(ecx), &ecx);
+	if (freq) {
+		ret = avs_ipc_set_fw_config(adev, 1, AVS_FW_CFG_XTAL_FREQ_HZ, sizeof(freq), &freq);
 		if (ret)
 			return AVS_IPC_RET(ret);
 	}
-#endif
 
 	hwid.device = pci->device;
 	hwid.subsystem = pci->subsystem_vendor | (pci->subsystem_device << 16);
-- 
2.50.1


