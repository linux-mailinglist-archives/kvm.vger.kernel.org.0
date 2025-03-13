Return-Path: <kvm+bounces-40981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21778A6013B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03C6B19C138F
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 19:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535F31F3B92;
	Thu, 13 Mar 2025 19:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DRzPNAe1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215F619005D;
	Thu, 13 Mar 2025 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741894232; cv=none; b=G2prOf5w0mz4EqJLkKfUvWeOSQKht6tAivunjkgiqW81567nOEOfpJ831jhtgkYkuL3/M8771Q84nksFUgP09dcawJBTZFvlb4zXO0c4ZVDBfEokoHz0sTAMkOXmJURhdnPiDGhqlAa3OVW1rBbKSp93hMg0RYsmY7hMxm9XH3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741894232; c=relaxed/simple;
	bh=N5Oxz1gvys/HGlscRpkT4sgkdpKYAMquiyHmxv5/Wjs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dhVt3+XBWkdt0hOtSvhG3bxomUjVdGOsO8zveJPa7IHiBrXSpCrS43crbb3kWvGCVogTRnrOoPSPicZJx7mhDE59y9kbhQzSc1O+zPLpvd0x1l+08jalIaSLe7uXErRnoAP96OKOsAT3rCBbjYrvQCiJ3A7qKrWW7qEqERu2kYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DRzPNAe1; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741894230; x=1773430230;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=N5Oxz1gvys/HGlscRpkT4sgkdpKYAMquiyHmxv5/Wjs=;
  b=DRzPNAe13E1hGEIciH/TxMAeAXnMFBhSlEr62Wg+BfnECeNjBiEmzx8N
   8vdreuoBVUWOsAUxBaIIeNPjDp+6Y6C9y6IYV31hVTeTOghO6mouIdB+E
   F/GtMxs5T8TaYrlaphVkIEBHOGaasMJABd9mtt3exERHczpJOchIGmk5t
   O+Ouj3QUjJ9auth6Da2bP4AUo12qzEKH/qEpGycmq3ri/PM4/4N63R5yo
   KERTxpDbsttjcudLrLZ81eL51UI10Bj438FtYHG84tDYSu7Gk8EAAQkGE
   cVwD4qsUt87E/UlWzsRjA9/MTtBuOu6LoKhQY5ughWOkhpgmCAlhjk4mH
   w==;
X-CSE-ConnectionGUID: F516d4IkS+WKuusstZgT8g==
X-CSE-MsgGUID: C8AUlJzwSsGDjs+ExCEGMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="43237115"
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="43237115"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:30:29 -0700
X-CSE-ConnectionGUID: mFkpxdivS6urpwhADcA/hQ==
X-CSE-MsgGUID: 3LMCxcmrS12V3FuzAuVPNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="151988215"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.108.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 12:30:28 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 13 Mar 2025 13:30:01 -0600
Subject: [PATCH 1/4] KVM: TDX: Move apicv_pre_state_restore to
 posted_intr.c
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-vverma7-cleanup_x86_ops-v1-1-0346c8211a0c@intel.com>
References: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
In-Reply-To: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2963;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=N5Oxz1gvys/HGlscRpkT4sgkdpKYAMquiyHmxv5/Wjs=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOmXjYIVl1WXefe2zXziFfhU/vfKTVOOros9mn1G6tmXg
 PJ/LBlSHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZgIxzxGhjU977IX3wp5xHrt
 gkam/MYXczYVPnxnpv7i3aWVTPETHtQwMrQkX9gx4/3iqHx9m5w1179t+9EyXcx2btCTVOGVMb1
 ql9kB
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In preparation for a cleanup of the x86_ops struct for TDX, which turns
several of the ops definitions to macros, move the
vt_apicv_pre_state_restore() helper into posted_intr.c.

Based on a patch by Sean Christopherson <seanjc@google.com>

Link: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/
Cc: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/kvm/vmx/posted_intr.h |  1 +
 arch/x86/kvm/vmx/main.c        | 10 +---------
 arch/x86/kvm/vmx/posted_intr.c |  8 ++++++++
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 68605ca7ef68..9d0677a2ba0e 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -11,6 +11,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
 void __init pi_init_cpu(int cpu);
+void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 320c96e1e80a..9d201ddb794a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -315,14 +315,6 @@ static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	return vmx_set_virtual_apic_mode(vcpu);
 }
 
-static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
-{
-	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
-
-	pi_clear_on(pi);
-	memset(pi->pir, 0, sizeof(pi->pir));
-}
-
 static void vt_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 	if (is_td_vcpu(vcpu))
@@ -983,7 +975,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vt_load_eoi_exitmap,
-	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
+	.apicv_pre_state_restore = pi_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
 	.hwapic_isr_update = vt_hwapic_isr_update,
 	.sync_pir_to_irr = vt_sync_pir_to_irr,
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index f2ca37b3f606..a140af060bb8 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -241,6 +241,14 @@ void __init pi_init_cpu(int cpu)
 	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
 
+void pi_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
+{
+	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
+
+	pi_clear_on(pi);
+	memset(pi->pir, 0, sizeof(pi->pir));
+}
+
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);

-- 
2.48.1


