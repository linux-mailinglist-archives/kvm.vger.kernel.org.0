Return-Path: <kvm+bounces-41364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 978A0A66A9A
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9B6A3B8F7F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A99AD1E1E03;
	Tue, 18 Mar 2025 06:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E+RilioM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1B51DD0C7;
	Tue, 18 Mar 2025 06:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742279753; cv=none; b=sdwyhS6I++al97CXVwOiCO1CNfxiA4BReL6RYyAnlM2IHfwNxMaj7AWd8KYgkTzqUKafGuJXL+sXS85tfZvfNVanUE5Zko7G67jPKBg/4mBYzkTq3VjD2SzxbGY8FL9TuVciSr1ZU0pbu/nDJDGFXIeSx6m0N63oen/wrxeX9xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742279753; c=relaxed/simple;
	bh=JZYQOEQqpTlADIyWTJL4Z9vOxfym9eQpA/0UopUeMLI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sgWEfKM7/jSbMQudcAXOlm8WbG2iuG2+wbdZWNa/l+qLZhjOzZHTDulBHlfx1ibKWDUvTWKyiZdyalfCHXfAG3YqsjnILnGcmSQoRncH6Rdf+r8+uCiWmAOXfAD4V1Kz2TNM8nc0I+H+LAtav2f4puNuJv6VHovBzCvnVggECcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E+RilioM; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742279752; x=1773815752;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=JZYQOEQqpTlADIyWTJL4Z9vOxfym9eQpA/0UopUeMLI=;
  b=E+RilioMA4397IUDeQBqQo31J5bN9jAVccoZlRKP/rep4JyCdhp1kD3Q
   5LJ/SkLgdTTjYMBNMrSapOO0SwpF4Njva2cnalJYBAr8u+zCznLLBuu4u
   Nv5XUy7XyozLCaWTJgQt1kHJD1NLXQDhk85N51u0732U3L8fKYOuTmuTA
   12InIeF54Fl6G5waAjes9HTVLr80eOvTfZ191N9r//3YPBCPSuXwq5AJ7
   QqO11fMBz5Hwwtk2i3OoxPeqiLpfyzLB9z5ZvRy9D0z9Si8m3BbckZwnh
   mfZ2sa1odBPRRanOeULcq6p/AX7RnTE0/9k9hG9vZ42JlJvlj/k2HDVBV
   w==;
X-CSE-ConnectionGUID: VGCN1VUTRpqH3tHXAX7slw==
X-CSE-MsgGUID: 0rRpZ67+SmCW0YVfIG6vXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="53613413"
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="53613413"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:50 -0700
X-CSE-ConnectionGUID: KUbsjudYSC+sUEBNIPK5uw==
X-CSE-MsgGUID: Ln26XAQsTuGN/xcfwx5KDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="153147537"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.109.119])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:48 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 18 Mar 2025 00:35:07 -0600
Subject: [PATCH v2 2/4] KVM: VMX: Move apicv_pre_state_restore to
 posted_intr.c
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250318-vverma7-cleanup_x86_ops-v2-2-701e82d6b779@intel.com>
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
In-Reply-To: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Binbin Wu <binbin.wu@linxu.intel.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3015;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=JZYQOEQqpTlADIyWTJL4Z9vOxfym9eQpA/0UopUeMLI=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOk3RZyTk16t3SRa+nH+7LYjSgz/zKvtkuSTWLbmbDr0T
 kaf6/T6jlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzkw2aGf0arbq5XnLrYTdBG
 xy5+WYrruqyTNtxdv9p3qr9Nj3y3UoThf8TKs54OHo+MtF6Kxgtp57+34ShKPn2mwy3/ZI/BneR
 9DAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In preparation for a cleanup of the x86_ops struct for TDX, which turns
several of the ops definitions to macros, move the
vt_apicv_pre_state_restore() helper into posted_intr.c.

Based on a patch by Sean Christopherson <seanjc@google.com>

Link: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/
Cc: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linxu.intel.com>
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


