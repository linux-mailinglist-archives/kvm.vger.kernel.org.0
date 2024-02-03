Return-Path: <kvm+bounces-7904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26AE08484AD
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 620CD1C27783
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C455EE96;
	Sat,  3 Feb 2024 09:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OtMm7tD1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC77E5C91F;
	Sat,  3 Feb 2024 09:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950834; cv=none; b=fDo+xgd9UgXGDhToWeWck2fDvRAuxVRxiiSxVRL+xFioPP2oj4ETaX+lvHR5fT+2YKWDoG070ZoqIfgQEJDwdUXALZyLgqYvVIgX3ic44v+LYD+YH/9f1iSOIQIsdnpJyZb8kPg+EriphqEMb1c2MNIrR19ps+Xe4B9T2v+jD8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950834; c=relaxed/simple;
	bh=dsIPqJPqsn+oitClY92kZLn0nh7sst/LKOjgIgrgVVw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gSXpcA78Al8inqPHIWR1OmtmJqsZ0ojH8boq6w8t3/nzGU1QunIU5VOdaOHJ6OGxo2AK3pif0E7TVrRMScdcaJtQxRgxqtxZaCRyQnGuYu6hOwTmG2VHe2hDkNABkQwQzJ9dEDdlAI3c2CudoTSTKm95dvsat620p9nSpDbLEC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OtMm7tD1; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950833; x=1738486833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dsIPqJPqsn+oitClY92kZLn0nh7sst/LKOjgIgrgVVw=;
  b=OtMm7tD18vgfuEJ7bcBko5HNjO1NGT9lx1G/IJVxZ/t9c9JDP8oAhobz
   yILgOgtymZ8mVX3IbIE8CInIHlf/JLc2v3gkdYf75ne73PF2yZt25WIG4
   GNjtV2MVElTVWleKGrM2s3PM1pqOFKuDAG9Vt7INz+xyb9yBISq0sSO6t
   UU3sKZggb/38GI992PpvJVvxdDfnSvRcVXyxGGjWuAP1UKYzV2Mc3n+x+
   sI4xBRcpIf9RJuLNkdqWmwUPUa2dVEwjiNq2RC0Prfhu0nzteFP2f9Qed
   TjkK7BJfCWJaGr/hWhckVozl1JX/qsDRdUZs/76HFM2Tx7aMPknCXcrbn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131954"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131954"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291265"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:26 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 08/26] KVM: x86: Expose TM/ACC (CPUID.0x01.edx[bit 29]) feature bit to VM
Date: Sat,  3 Feb 2024 17:11:56 +0800
Message-Id: <20240203091214.411862-9-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

The TM (Thermal Monitor, alias, TM1/ACC) feature is a dependency of
thermal interrupt processing so that it is required for the
HFI notification (a thermal interrupt) handling.

According to SDM [1], the TM feature means:
"The TM1 flag (bit 29) of the CPUID feature flags indicates the presence
of the automatic thermal monitoring facilities that modulate clock duty
cycles."

Considering that the TM feature does not provide any OS interaction
interface, but only indicates the presence of a hardware feature.

Therefore, we do not need to perform any additional software emulation
while exposing the TM feature bit.

Expose the TM feature bit to the VM to support the VM in handling the
thermal interrupt.

[1]: SDM, vol. 3B, section 15.8.4.1, Detection of Software Controlled
     Clock Modulation Extension.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1ad547651022..829bb9c6516f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -625,7 +625,7 @@ void kvm_set_cpu_caps(void)
 		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
 		0 /* Reserved, DS */ | F(ACPI) | F(MMX) |
 		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
-		0 /* HTT, TM, Reserved, PBE */
+		0 /* HTT */ | F(ACC) | 0 /* Reserved, PBE */
 	);
 
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
-- 
2.34.1


