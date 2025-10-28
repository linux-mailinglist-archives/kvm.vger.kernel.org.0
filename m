Return-Path: <kvm+bounces-61271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 622C9C130CE
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 07:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A75521A663E7
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 06:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EE829BDA0;
	Tue, 28 Oct 2025 06:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MH9QRqll"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B1222339;
	Tue, 28 Oct 2025 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761631306; cv=none; b=oCzm/jv3tQW4wcA2PXfy57qKb9rScMIFGNkIsTejcV+tBHfuAF3SF9+Y0ZoiFFQOCgxTkPFZidl5YSEkYtT4chWhdn0wCmwpqzjTuTbindJy9iqf4Qg1n81Hd8hCwZlPgdglYH0cVNvDjtAIc9iZwI/S08/DRoO4llDE1E3aD9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761631306; c=relaxed/simple;
	bh=o/MtvnoZFtcEhS+9uTxnucBzOOd7NnBtyKSzDQPcmCY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k4tN0pl6sbpgxphJ4OW43uVa2uN74XN17JUZabLuqV9wVGwTzqIzIg+jdaua9PINLFWSyjZw12ZdpEBM1oy/J31/OTFWsnJ+AVXcubz6X06DGEZMXXkpXD82mkHHPcamltUvd16gNgmQeMXFKYHZHGTmTac4vBSBmW5NXSyXEjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MH9QRqll; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761631305; x=1793167305;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o/MtvnoZFtcEhS+9uTxnucBzOOd7NnBtyKSzDQPcmCY=;
  b=MH9QRqllmmh/TmusTd2RAHtHxIuCvyS7Pl13z0hBki2Hh1Fjm5lxT/yU
   dyNiGGaB3VgdmoJX3KVPzRvwtOrCrcG3ObwQ09HS/6SC3sIY10PZEmIne
   KpH8KeYwEMZK+f45b1p5EbKFqypfdu3cBFGbYALV4n4Thvksx3OtOk/s0
   aGvPo+46zoFntUjttYt0gqOuFlArTu71qVamMHBujSeT10BNo7OUqROgb
   efe9WOjtE1Sz0TLxVzYo8QoXSW8jrn7H/OrSXk1v3Z1PfkCBVPYzqjDMQ
   /XnjInp0Q7PhqPVcux92rUKNe67g1XHqEKq20kHI1fPljboUpgu2sYXIM
   w==;
X-CSE-ConnectionGUID: Pt3gaPIsR0yvEtxUayYwtg==
X-CSE-MsgGUID: j64LI0z5RnecR5sKx4euaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74397445"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="74397445"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 23:01:44 -0700
X-CSE-ConnectionGUID: vsoPQOoFRw+VMm9FRVsW4A==
X-CSE-MsgGUID: A2QLi0tkT9ijc6FbIDtLEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="185146997"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 23:01:44 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] KVM: x86: Call out MSR_IA32_S_CET is not handled by XSAVES
Date: Mon, 27 Oct 2025 23:01:41 -0700
Message-ID: <20251028060142.29830-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update the comment above is_xstate_managed_msr() to note that
MSR_IA32_S_CET isn't saved/restored by XSAVES/XRSTORS.

MSR_IA32_S_CET isn't part of CET_U/S state as the SDM states:
  The register state used by Control-Flow Enforcement Technology (CET)
  comprises the two 64-bit MSRs (IA32_U_CET and IA32_PL3_SSP) that manage
  CET when CPL = 3 (CET_U state); and the three 64-bit MSRs
  (IA32_PL0_SSP–IA32_PL2_SSP) that manage CET when CPL < 3 (CET_S state).

Fixes: e44eb58334bb ("KVM: x86: Load guest FPU state when access XSAVE-managed MSRs")
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
I didn't check the SDM when Xin asked [1] why MSR_IA32_S_CET isn't
xstate-managed. It looks like my reply (and my sample code) misled
everyone into thinking MSR_IA32_S_CET was part of the CET_S state.
I realized this issue when reviewing the QEMU patch [2].

[1]: https://lore.kernel.org/kvm/aKvP2AHKYeQCPm0x@intel.com/
[2]: https://lore.kernel.org/kvm/20251024065632.1448606-12-zhao1.liu@intel.com/
---
 arch/x86/kvm/x86.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cfed304035f..c7592ac8f443 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3877,15 +3877,13 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 
 /*
  * Returns true if the MSR in question is managed via XSTATE, i.e. is context
- * switched with the rest of guest FPU state.  Note!  S_CET is _not_ context
- * switched via XSTATE even though it _is_ saved/restored via XSAVES/XRSTORS.
- * Because S_CET is loaded on VM-Enter and VM-Exit via dedicated VMCS fields,
- * the value saved/restored via XSTATE is always the host's value.  That detail
- * is _extremely_ important, as the guest's S_CET must _never_ be resident in
- * hardware while executing in the host.  Loading guest values for U_CET and
- * PL[0-3]_SSP while executing in the kernel is safe, as U_CET is specific to
- * userspace, and PL[0-3]_SSP are only consumed when transitioning to lower
- * privilege levels, i.e. are effectively only consumed by userspace as well.
+ * switched with the rest of guest FPU state.
+ *
+ * Note, S_CET is _not_ saved/restored via XSAVES/XRSTORS. Also note, loading
+ * guest values for U_CET and PL[0-3]_SSP while executing in the kernel is
+ * safe, as U_CET is specific to userspace, and PL[0-3]_SSP are only consumed
+ * when transitioning to lower privilege levels, i.e. are effectively only
+ * consumed by userspace as well.
  */
 static bool is_xstate_managed_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-- 
2.47.3


