Return-Path: <kvm+bounces-72897-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IKlLLHDCqWkhEQEAu9opvQ
	(envelope-from <kvm+bounces-72897-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:50:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 155A921684F
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:50:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 14CE731C38DD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041833EDACA;
	Thu,  5 Mar 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfMHoeUQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9293E715F;
	Thu,  5 Mar 2026 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732680; cv=none; b=mUZ9x7NuUFVil6bW5EUvMvjRB47MRepoLy7Om0Byn/Fe79nvrqECOH4cvsvtSeVhLZ8jcH+AyjZQZeuQ5CODRTOaDiaA+HSyjgifJ7ciIh1qADnLsGkDFkq0fenzFVFKHhnXUnwOURehmZlKUNDr4wx3Sj5/0YsvBSHE6bW5bhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732680; c=relaxed/simple;
	bh=6fASWB4q17PZAgMEt8O+x+XB/ZHizq2q9RpwGbdu54k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByuoDp9PZeUFM1Mnq7aSpwRDC2N3Cq2xwcChOfuCCVFoUFN66b43rJBDXAczHwJrfJfNaJnMbrQ/03YTZb5xI8EE3phhVqJo4JYfR9c/oXB4gQqTzQ9urzeqLu8USw4+fkeydp57xJGJGG8tDNgFNAOrsrmlfqTamJrTV5bVg+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfMHoeUQ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732677; x=1804268677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6fASWB4q17PZAgMEt8O+x+XB/ZHizq2q9RpwGbdu54k=;
  b=dfMHoeUQJS62NHRZUQaRsyzvheJV2QRqnRWfD8TcBswmLnhW/K2xi3Gh
   dWfhTcWkuGrotZGjWbM5HGzUwNP+EYlDNNfqiS2v/bs7Sjqd80EO6Jl7L
   XT2YnxaSzHI3WDyleiRHRxMcHe3QCRlSdWQZ3wGmbMvo6yEuWDVbrRtA1
   gz2Xry7yjDdF6O2rvHdDFHyikD/hXqnV3g/F80ZrJ10LvQjvIVtYAghii
   VqVOg0pTzLalgkqaHqWLN0TLe1tOg0chQ5sXF4Hnq48eikvBWOte136CM
   vpC6ysOIeih9n3DauWFf/boR1cS3hPKAT3/FfDT+ULbTtwt0wCLZAO/RH
   Q==;
X-CSE-ConnectionGUID: Pd2JdE5URNynOIkNSP/kMA==
X-CSE-MsgGUID: C2XXJ/w3RWie29t9wnWZbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431561"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431561"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:35 -0800
X-CSE-ConnectionGUID: uh6MmmQjT3y+CySPVFFI4A==
X-CSE-MsgGUID: 6T6ter9lTo6ib57WiuNP9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447861"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:35 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/36] KVM: VMX: Update APIC timer virtualization on apicv changed
Date: Thu,  5 Mar 2026 09:43:47 -0800
Message-ID: <f5765a3d9abcd0f23abb7edd96d8db388cb85b0a.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 155A921684F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72897-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

VMX APIC timer virtualization requires the virtual-interrupt delivery.
It's part of KVM apicv, and when apicv state is changed, the
refresh_apicv_exec_ctrl() callback is invoked.  Export a lapic function to
update which timer to use for APIC timer emulation and make the VMX backend
call it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
--
Changes v1 -> v2:
- Use EXPORT_SYMBOL_FOR_KVM_INTERNAL() instead of EXPORT_SYMBOL_GPL().
- Add in-kernel apic check.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c   | 9 +++++++++
 arch/x86/kvm/lapic.h   | 1 +
 arch/x86/kvm/vmx/vmx.c | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index abbd51c4da7f..a3c1a81e63e2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1946,6 +1946,15 @@ static void apic_update_apic_virt_timer(struct kvm_lapic *apic)
 		apic_cancel_apic_virt_timer(apic);
 }
 
+void kvm_update_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	apic_update_apic_virt_timer(vcpu->arch.apic);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_update_apic_virt_timer);
+
 static void apic_update_lvtt(struct kvm_lapic *apic)
 {
 	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2f510503f5b3..0571b7438328 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -259,6 +259,7 @@ void kvm_lapic_switch_to_apic_virt_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+void kvm_update_apic_virt_timer(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_lapic_apic_virt_timer_in_use(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b70641bfecab..5d36f2b632e9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4591,6 +4591,8 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 						 kvm_vcpu_apicv_active(vcpu));
 
 	vmx_update_msr_bitmap_x2apic(vcpu);
+
+	kvm_update_apic_virt_timer(vcpu);
 }
 
 static u32 vmx_exec_control(struct vcpu_vmx *vmx)
-- 
2.45.2


