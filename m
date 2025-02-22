Return-Path: <kvm+bounces-38944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF7FA404EB
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:49:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4865419E2607
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91CF11E7C1E;
	Sat, 22 Feb 2025 01:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNdeNPFZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582EE2036F3;
	Sat, 22 Feb 2025 01:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188804; cv=none; b=Gg34JnJH8SS1AP5F3I/ADFoCKmtHjhw+NwP0O9vXiLHiiXd9yNQjq/6aoClHZnzqCTLLUfRvfybxlR7ZAZe2I6k8kNt7S2V6n0GdEIvcT0//oYQXa1S4PDcAA9x2I64WApO9oKoJp/IE4hlxF0ar7l5mb2NV2/y/Z4m4dD+zt5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188804; c=relaxed/simple;
	bh=IoChqoRbkhhbm52AA1Itc9dMNqQ27Otzr6/pxIk+Sqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUXEYp2c/VZBiKz5/TswA/33bHT/YJh/cHmlfK/UAiQ0g/4QJkfA3q96J9+sKgoKHDYbLkEGwTOQOau2d9Ei9q57WXQBl3KS0xwd1uGDgBSohYL11GYTHoYhra5skCjZZQ2ureUAWYLzgEUDFNhcXZCNnIkd/o4LkUgELJuoQ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNdeNPFZ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188803; x=1771724803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IoChqoRbkhhbm52AA1Itc9dMNqQ27Otzr6/pxIk+Sqg=;
  b=GNdeNPFZju3WqAvxPoU7shhxltQy0ussDw2hpWqx/gAKENdma3xNOLLo
   MxTEqZ0LpluEfyyeWzRi6+6KJmIhmVJj+WB2bH8VqWj4K3ww9NrFsj3BA
   zW+KCrnlq7IQ5n0QjSRnh5png0ir8CYQA8aFJk4phbCrCcNhro/dLOuN7
   rwlt4zcB8x0GHMmOMN3d/9pByzDXD70Kr44jxmZ3MwyGR2yzM6xRCaoq4
   Fy2rsF0bqyIeINonDat6wFYRZAfRtVfXbBfaxVt0TYkAn3uIjS46ZOL0G
   Lr8LVOh3Og7lCp2ai7ZftX+ir1VXTz06TV6g4HDow63KE08z5CsNtrBT1
   Q==;
X-CSE-ConnectionGUID: QyXNwxPcSQOoVYhKDJnwyQ==
X-CSE-MsgGUID: vpVlphKSS/qVlDsw/KInCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449032"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449032"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:43 -0800
X-CSE-ConnectionGUID: qmewUR7tSxK2pknQNfBMVw==
X-CSE-MsgGUID: YBgcaI4SRZGvlpOY9SiTZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621663"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:40 -0800
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
Subject: [PATCH v3 06/16] KVM: TDX: Wait lapic expire when timer IRQ was injected
Date: Sat, 22 Feb 2025 09:47:47 +0800
Message-ID: <20250222014757.897978-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
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
TDX interrupts v3:
- No change.

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
index e8d14b22b144..160c3e6d83c7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -957,9 +957,14 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
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


