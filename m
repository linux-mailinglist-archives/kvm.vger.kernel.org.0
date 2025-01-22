Return-Path: <kvm+bounces-36274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F66A1964B
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57B31188CAC9
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D73214A89;
	Wed, 22 Jan 2025 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="H04jQa8v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF8D1D5CDB;
	Wed, 22 Jan 2025 16:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737562597; cv=none; b=UTcrtSp4+XSLdBTzE+wGeGaDNuP1WYflKsQUBeCPf0mhcuZbxplUWcLxqe7m3k9XO6RiLi2xzwzonKKL5LIv+x4gu2iY0tSkkkE4vAWLI13mnyusuaABOh2bxkdBbeGRHPNf/Iv+sXMZiD89bgtfgWzC2v84ct5WVLK5Er9YSx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737562597; c=relaxed/simple;
	bh=hy7ACFyILKs372+JRAI6mpEOB7+Zdpe2MMRmf2nAXHs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FnHf2LDBiZ9eidXtFmATldguTc4pOzUNEGw6O/uSZxI5y1PBT+E+yY5H80NjCmFpNsR1kUQ72CUIt6d1qX7bjvwKj51p6AJEVYEU+K9a3GTuJX+pVdZai/ZZ6X/Ac3hxHCPR1Ftl0CLJ+YkTvLY+iCYC0qubnqor2/kMU65j4GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=H04jQa8v; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737562595; x=1769098595;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DFsS+dzG26iQ0/ZNg9zzRJWPrnH33C3X2TUiOuZqNoc=;
  b=H04jQa8vfzMdaRCaLSdx5VW1DgI4YwZySUnUkXO+jyyI6HT2GRVFeH13
   3r7gqtK7dl2E/H5FS6jb71c4UTO448xzLDfWaRmVM2psDcXtclm80bHDr
   kwnqKMCZkE953VQGGaMKLafZMqA+mxJAFg3FWSFlsBf9TigvwisW9JvdC
   c=;
X-IronPort-AV: E=Sophos;i="6.13,225,1732579200"; 
   d="scan'208";a="166155374"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 16:16:32 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:10540]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.3.224:2525] with esmtp (Farcaster)
 id 8cfacc6e-cd11-4b38-bbe6-d8af71282fef; Wed, 22 Jan 2025 16:16:31 +0000 (UTC)
X-Farcaster-Flow-ID: 8cfacc6e-cd11-4b38-bbe6-d8af71282fef
Received: from EX19D007EUA003.ant.amazon.com (10.252.50.8) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Wed, 22 Jan 2025 16:16:31 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUA003.ant.amazon.com (10.252.50.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Wed, 22 Jan 2025 16:16:30 +0000
Received: from email-imr-corp-prod-pdx-1box-2b-8c2c6aed.us-west-2.amazon.com
 (10.43.8.6) by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Wed, 22 Jan 2025 16:16:30 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com (dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com [10.13.244.152])
	by email-imr-corp-prod-pdx-1box-2b-8c2c6aed.us-west-2.amazon.com (Postfix) with ESMTPS id 26EA4A0535;
	Wed, 22 Jan 2025 16:16:28 +0000 (UTC)
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <kvm@vger.kernel.org>
CC: Fred Griffoul <fgriffo@amazon.co.uk>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
	"Paul Durrant" <paul@xen.org>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
Date: Wed, 22 Jan 2025 16:16:11 +0000
Message-ID: <20250122161612.20981-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Previous commit ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before
updating vcpu->arch.cpuid_entries") implemented CPUID data mangling in
KVM_SET_CPUID2 support before verifying that no changes occur on running
vCPUs. However, it overlooked the CPUID leaves that are modified by
KVM's Xen emulation.

Fix this by calling a Xen update function when mangling CPUID data.

Fixes: ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries")
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/cpuid.c | 1 +
 arch/x86/kvm/xen.c   | 5 +++++
 arch/x86/kvm/xen.h   | 5 +++++
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index edef30359c19..432d8e9e1bab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -212,6 +212,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	 */
 	kvm_update_cpuid_runtime(vcpu);
 	kvm_apply_cpuid_pv_features_quirk(vcpu);
+	kvm_xen_update_cpuid_runtime(vcpu);
 
 	if (nent != vcpu->arch.cpuid_nent)
 		return -EINVAL;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..219f9a9a92be 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -2270,6 +2270,11 @@ void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
 		entry->eax = vcpu->arch.hw_tsc_khz;
 }
 
+void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+{
+	kvm_xen_update_tsc_info(vcpu);
+}
+
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	mutex_init(&kvm->arch.xen.xen_lock);
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f5841d9000ae..d3182b0ab7e3 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -36,6 +36,7 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue);
 void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
+void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 
 static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
 {
@@ -160,6 +161,10 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
 static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
 {
 }
+
+static inline void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+{
+}
 #endif
 
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
-- 
2.40.1


