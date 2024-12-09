Return-Path: <kvm+bounces-33265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8C29E88E2
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B9D1165719
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E1F144D1A;
	Mon,  9 Dec 2024 01:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J14JwhyU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2056513F43B;
	Mon,  9 Dec 2024 01:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706358; cv=none; b=ZpwgUa2Wy/g8ohJzYmtXCGCka3iKqz398T86X15Na/JRChJUIxlglnuDcUwDhcnchFeKtNlOhevvV8A0HFb9Kwv0cCOqS9oJGLISDAgZFF6X+BnO2cW3PKSPW3C42Btc+W1GuLbjWMLePulfDdLOLKnHAEJvRRksHmKAIVmAL3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706358; c=relaxed/simple;
	bh=0S99R8cedl1y1ryY3lUb9j7T7KqVxPo1UATlSCqn9Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHgKauVoyTY8/b8U4YnvZWJQN2mb26LU7TWVoXCRGYNcEGD05GzEulOp8OhipSrW8gjPHqKHZ5qyuTwdcuBMm7ExE63CuTi3VhioD995zpMda1atMx2j5MMTp0qApaQq2LnAW2LJDYSK3IjxHFJ93rb0ySKQcwJ0LJvqVZ8oRtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J14JwhyU; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706357; x=1765242357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0S99R8cedl1y1ryY3lUb9j7T7KqVxPo1UATlSCqn9Us=;
  b=J14JwhyUFH8AGprmpyGhs1Uvm0NCRWndxtIpj1aRHYX4PCSCDsoOmtGB
   Jj1Raiq8sAGoHHeuEClDjGUUBMmVAn5scMgxw/H2tD5aTMy+CRJVpGLiv
   0qF+GMM3E31dL5jKjJhap9fH7wXv1dlgKTXKLAzw/m7Rj+4FEF8xq19V8
   7lRqrCsOC/+p8C3funcwOJ3TADJoTLx+EtLze6J7kCEQoVpbLJQqo9taD
   sDNV6LAeiHg+Vl39uCqIhPS9sG7qfILUlCXA5+dqLwEj5fGeIHVMTGsPo
   lY4zW245XrwRZGmvHDiOKi80i9d6RAmtCOFVRx+BSfhXuLaA3hUDj4AAf
   A==;
X-CSE-ConnectionGUID: KK1XtFDVRgazA6J3xBL8og==
X-CSE-MsgGUID: wpzGT+orSYeob+tiJzt1pQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833703"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833703"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:57 -0800
X-CSE-ConnectionGUID: vKXkh+dGTaSTvfhRqCavrQ==
X-CSE-MsgGUID: 0TNLGMz5SuaIHxdqmFVLaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402471"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:53 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 06/16] KVM: x86: Assume timer IRQ was injected if APIC state is protected
Date: Mon,  9 Dec 2024 09:07:20 +0800
Message-ID: <20241209010734.3543481-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

If APIC state is protected, i.e. the vCPU is a TDX guest, assume a timer
IRQ was injected when deciding whether or not to busy wait in the "timer
advanced" path.  The "real" vIRR is not readable/writable, so trying to
query for a pending timer IRQ will return garbage.

Note, TDX can scour the PIR if it wants to be more precise and skip the
"wait" call entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts breakout:
- Renamed from "KVM: x86: Assume timer IRQ was injected if APIC state is proteced"
  to "KVM: x86: Assume timer IRQ was injected if APIC state is protected", i.e.,
  fix the typo 'proteced'.
---
 arch/x86/kvm/lapic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 684777c2f0a4..474e0a7c1069 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1789,8 +1789,17 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	u32 reg;
 
+	/*
+	 * Assume a timer IRQ was "injected" if the APIC is protected.  KVM's
+	 * copy of the vIRR is bogus, it's the responsibility of the caller to
+	 * precisely check whether or not a timer IRQ is pending.
+	 */
+	if (apic->guest_apic_protected)
+		return true;
+
+	reg  = kvm_lapic_get_reg(apic, APIC_LVTT);
 	if (kvm_apic_hw_enabled(apic)) {
 		int vec = reg & APIC_VECTOR_MASK;
 		void *bitmap = apic->regs + APIC_ISR;
-- 
2.46.0


