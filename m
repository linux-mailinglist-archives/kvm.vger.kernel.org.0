Return-Path: <kvm+bounces-33266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A03859E88DC
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B54C282BE8
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0281494C3;
	Mon,  9 Dec 2024 01:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VdtqVcge"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BED43AA1;
	Mon,  9 Dec 2024 01:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706362; cv=none; b=HvPhAF4KVEHlqriZbR2IZyDGrLzeGrCX3ntnfkXMBRAoroSBY+8AMfevxNqweoYQQ5GdmQifs1OgkGDECl8uwKsu2TnCmj9mY5AQOc6btEG+gGAX64Ta/L7yQMKZm+cXptUKKsP43Hmx3bL4re+z6wSyKwrUN/0He7rpitoDH7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706362; c=relaxed/simple;
	bh=xYhA4mgob3IQEvEqO27HMKWKtzLvD8mIEtVJoT7Hy+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hT2ieYXSXs83mVd4xDpxdvhfawvo9XlUIllGTiHlOfN3lJ9Ff1+r27Kv6WFGLXRPXx9UKxCtqydv/2cFEIJNqN3PgblK6vPZgeZl5zT3+V6hYoVqYxQ0MYMROHJbIbzkgJPleJNeIUOP+gNzB67ZndnHp6DVxwjbN6DT1cRoSUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VdtqVcge; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706361; x=1765242361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xYhA4mgob3IQEvEqO27HMKWKtzLvD8mIEtVJoT7Hy+8=;
  b=VdtqVcgeIgHLAv2/OqBjJosBSWDCyszgooXOUsAaeBmUEViAl9cnEf+R
   t954WQHIUredZWSTytW9AQ3DnDjDZR0j331MUUtB6xJwPedbvAH+SxtTo
   UuqzRqjApdrv3hiX/VK5bcNFDo+yb3PqXTXDHg3BHx8l8oxmZ/Z1N6WSG
   pEdkjWqRP0l9FT3DEhlxsbN1+RHy3H8mm5Thh45YzaET5/rUF5ccyldGm
   WuefNxTC98yn+OVI2pAdSNV2ZwLLFv+TTYzn1F/fiBSgaxc+OVvIWGmJU
   mYRu2qYNzHieoNm2nWdK40+9HHb0DAk8HLQEJTCG8T+hiMwCqKPLlmsrD
   g==;
X-CSE-ConnectionGUID: UM9DflriQvifnPZ6qD7DSQ==
X-CSE-MsgGUID: 67r2sF63TCe9rvZpFsh6mQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833708"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833708"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:00 -0800
X-CSE-ConnectionGUID: q+Uu4BABQH24yqVKOM5Ldw==
X-CSE-MsgGUID: Y0sLWAdDQw2ULs+iEXZxlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402481"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:56 -0800
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
Subject: [PATCH 07/16] KVM: TDX: Wait lapic expire when timer IRQ was injected
Date: Mon,  9 Dec 2024 09:07:21 +0800
Message-ID: <20241209010734.3543481-8-binbin.wu@linux.intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Call kvm_wait_lapic_expire() when POSTED_INTR_ON is set and the vector
for LVTT is set in PIR before TD entry.

KVM always assumes a timer IRQ was injected if APIC state is protected.
For TDX guest, APIC state is protected and KVM injects timer IRQ via posted
interrupt.  To avoid unnecessary wait calls, only call kvm_wait_lapic_expire()
when a timer IRQ was injected, i.e., POSTED_INTR_ON is set and the vector for
LVTT is set in PIR.

Add a helper to test PIR.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts breakout:
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
index 0896e0e825ed..dcbe25695d85 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -974,9 +974,14 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	trace_kvm_entry(vcpu, force_immediate_exit);
 
-	if (pi_test_on(&tdx->pi_desc))
+	if (pi_test_on(&tdx->pi_desc)) {
 		apic->send_IPI_self(POSTED_INTR_VECTOR);
 
+		if(pi_test_pir(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTT) &
+			       APIC_VECTOR_MASK, &tdx->pi_desc))
+			kvm_wait_lapic_expire(vcpu);
+	}
+
 	tdx_vcpu_enter_exit(vcpu);
 
 	if (tdx->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
-- 
2.46.0


