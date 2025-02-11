Return-Path: <kvm+bounces-37792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C9CA301D9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:58:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07FF0188B6DC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9507C1E0DAF;
	Tue, 11 Feb 2025 02:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JTts41xh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FB11D63D0;
	Tue, 11 Feb 2025 02:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242635; cv=none; b=miov9uOY4m0JPM1woeAL2zFD3gBViXty2COwjfO/dGy3WoogWYBd9M5HK+dkBWqCUg/bB8hU0hJT9fC+5mGPeBT/bee0MZ5ET4oTYhB2rzsEPJYaRJmgKEGYvVPtocY/UKxu1BIU0fCBgmqsxAAKAZGB9ZK/nm3WiC4lYSXaiSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242635; c=relaxed/simple;
	bh=7uJtIsaHEA4t3pXYfv19w5trWujfTGOQ0bfUWFTIlks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVvS0L6oReEZds7APROLr1TSc50AeytaMnwvha4q3FHHhdCG2fXsRE1dZA6keomZNFmajigYlKGqxwoG19U02DNYbQxNxdqT3bgYJKv5SyG1zGeJAD81HLIvtGi0Qai6Cs11T7tD2Cmf/hXByRT85DcwEFB5I7AXv/CjJowoeJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JTts41xh; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242634; x=1770778634;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7uJtIsaHEA4t3pXYfv19w5trWujfTGOQ0bfUWFTIlks=;
  b=JTts41xhBoMMBuekd3Roq22PAtdKoGy6UmoJULCK8fLk1ry4lSyiAXTH
   W6FCDNPd2Gj0geFrIfYrJsFZdT3VqO1TZEU6uybGXJPWoBXgg0TzYKWS3
   AZ7NHliDDFZGuU7CgXD0fGKkVJGcpONvOHQYeqskPpybSfXDfuib+Jwi3
   TBtnSqyqv7n4KfFKUEew4jo0ULqM5yLzRkiRUSSSXTPaqBcuqsKjQ/ptr
   +hCwXzbqCO9EW+VYUlYbTTmXqfVeA5LyeLyP13uzkXNlEvrvhlW3dfOXu
   bGSdEuPPsYd1SQ4waXNuQyRQ4VNFzbK7LRFG7n+WRxoTH/SB0R7X4MScs
   w==;
X-CSE-ConnectionGUID: 83z9bnHVQ4SA5x+KWODLpA==
X-CSE-MsgGUID: UL8uXZ6YTjG4yXKphCfVvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612451"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612451"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:13 -0800
X-CSE-ConnectionGUID: ziBBvD0WR1KVbJiO9r7Nxg==
X-CSE-MsgGUID: 2hj3Fk/USRukJrqIl2aBRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355324"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:08 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 06/17] KVM: TDX: Wait lapic expire when timer IRQ was injected
Date: Tue, 11 Feb 2025 10:58:17 +0800
Message-ID: <20250211025828.3072076-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Call kvm_wait_lapic_expire() when POSTED_INTR_ON is set and the vector
for LVTT is set in PIR before TD entry.

KVM always assumes a timer IRQ was injected if APIC state is protected.
For TDX guest, APIC state is protected and KVM injects timer IRQ via posted
interrupt.  To avoid unnecessary wait calls, only call
kvm_wait_lapic_expire() when a timer IRQ was injected, i.e., POSTED_INTR_ON
is set and the vector for LVTT is set in PIR.

Add a helper to test PIR.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v2:
- Rebased due to moving pi_desc to vcpu_vt.

TDX interrupts v1:
- Split out from patch "KVM: TDX: Implement interrupt injection". (Chao)
- Check PIR against LVTT vector.
---
 arch/x86/include/asm/posted_intr.h | 5 +++++
 arch/x86/kvm/vmx/tdx.c             | 7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index de788b400fba..bb107ebbe713 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -81,6 +81,11 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
 	return test_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
 }
 
+static inline bool pi_test_pir(int vector, struct pi_desc *pi_desc)
+{
+	return test_bit(vector, (unsigned long *)pi_desc->pir);
+}
+
 /* Non-atomic helpers */
 static inline void __pi_set_sn(struct pi_desc *pi_desc)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d289040172bc..4b8e28bde021 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -955,9 +955,14 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	trace_kvm_entry(vcpu, force_immediate_exit);
 
-	if (pi_test_on(&vt->pi_desc))
+	if (pi_test_on(&vt->pi_desc)) {
 		apic->send_IPI_self(POSTED_INTR_VECTOR);
 
+		if (pi_test_pir(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTT) &
+			       APIC_VECTOR_MASK, &vt->pi_desc))
+			kvm_wait_lapic_expire(vcpu);
+	}
+
 	tdx_vcpu_enter_exit(vcpu);
 
 	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
-- 
2.46.0


