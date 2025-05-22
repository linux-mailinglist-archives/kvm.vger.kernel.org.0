Return-Path: <kvm+bounces-47334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 865AEAC019E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80F4D18823AB
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 00:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF3319597F;
	Thu, 22 May 2025 00:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRvRDNhG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E9517A306
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747875379; cv=none; b=t4WGwAgpYd7csHlEoEYCzH9dAdQbDgK7SZ03EALddPH+/wvfChAgEI4CPzdkXuAKc8A63NAuRtMel7vwuTFLDZ7iMil2mADl9L85IB735vkZbEThm3DpDAGrYos2uclz6PJIFGU+JSwbTgrtk2ONjAvqoJ4z/h5f+whcv05uIco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747875379; c=relaxed/simple;
	bh=qVt1iIPPogfcBBlIDh5BDoYfefDZoeCnXCt+00WLO7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aObkWq/68eHNJ+u1HjcyqggkIqRhjNILM84WbORcexbZYDJ3wjFyRwC2FIa+rEktcvQvkVTs0KLa5dIl1YQeZJpIygFkLeq/FclAlOY3AbTVj98f8hWnxVqoPGr+zaaUPIDZ8SUjRH/owVt7cMKlbndj6DJIBt+P4wkVPKLLKbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRvRDNhG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747875376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nr3LJuaZ3sTnYMRa12I7e2LfVKiux5OI0/JCWBFGFhM=;
	b=CRvRDNhGYJc6uWZsqKkXHWR/22/2YfMV4E861ojUr60evXPdp6TRRC1IqTSUR0erClPEEZ
	L1Gta7hRn7Fb7oXJOMssy7qu5ONsIlZY4YbRi59oJJ9SXKxAU05TzpSKHpQWudBWliMhKg
	1dZhhEkknwPFGAqjCSlgsF7cC/L+FC4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-466-pO8D-c7QPqOhPzjgjpMNpg-1; Wed,
 21 May 2025 20:56:13 -0400
X-MC-Unique: pO8D-c7QPqOhPzjgjpMNpg-1
X-Mimecast-MFC-AGG-ID: pO8D-c7QPqOhPzjgjpMNpg_1747875371
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 891CE1956089;
	Thu, 22 May 2025 00:56:11 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 63AC419560B7;
	Thu, 22 May 2025 00:56:09 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 5/5] KVM: VMX: preserve DEBUGCTLMSR_FREEZE_IN_SMM
Date: Wed, 21 May 2025 20:55:55 -0400
Message-ID: <20250522005555.55705-6-mlevitsk@redhat.com>
In-Reply-To: <20250522005555.55705-1-mlevitsk@redhat.com>
References: <20250522005555.55705-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the guest
GUEST_IA32_DEBUGCTL without the guest seeing this value.

Since the value of the host DEBUGCTL can in theory change between VM runs,
check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL with
the new value.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 6 +++++-
 arch/x86/kvm/x86.c              | 7 +++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ed568babcf..6bbde18a5783 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1674,6 +1674,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 enum kvm_x86_run_flags {
 	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
 	KVM_RUN_LOAD_GUEST_DR6		= BIT(1),
+	KVM_RUN_LOAD_DEBUGCTL		= BIT(2),
 };
 
 struct kvm_x86_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cfab76b40780..c70fe7cbede6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2196,12 +2196,13 @@ u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 
 void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val)
 {
+	val |= vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM;
 	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
 }
 
 u64 vmx_guest_debugctl_read(void)
 {
-	return vmcs_read64(GUEST_IA32_DEBUGCTL);
+	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~DEBUGCTLMSR_FREEZE_IN_SMM;
 }
 
 /*
@@ -7380,6 +7381,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
 		set_debugreg(vcpu->arch.dr6, 6);
 
+	if (run_flags & KVM_RUN_LOAD_DEBUGCTL)
+		vmx_guest_debugctl_write(vcpu, vmx_guest_debugctl_read());
+
 	/*
 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38875a38be52..3663cd6721ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10752,7 +10752,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
-	u64 run_flags;
+	u64 run_flags, debug_ctl;
 
 	bool req_immediate_exit = false;
 
@@ -11024,7 +11024,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
-	vcpu->arch.host_debugctl = get_debugctlmsr();
+	debug_ctl = get_debugctlmsr();
+	if (!vcpu->arch.guest_state_protected && (debug_ctl != vcpu->arch.host_debugctl))
+		run_flags |= KVM_RUN_LOAD_DEBUGCTL;
+	vcpu->arch.host_debugctl = debug_ctl;
 
 	guest_timing_enter_irqoff();
 
-- 
2.46.0


