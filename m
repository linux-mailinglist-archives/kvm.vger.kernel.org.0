Return-Path: <kvm+bounces-24248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9F4952E56
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FFC61F20F66
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 12:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9308917C9AF;
	Thu, 15 Aug 2024 12:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D+CCnVQV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC5317C9B9
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 12:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723725266; cv=none; b=h1CUry8F9jJ0hKwI9ApqHuM88dU3W+Jc344mtRo2AQvCExMJPfgJFubFNA0p75pSr6NAgW0CskigCmTD0VzeWv6g7cyWg5iLUtZlztZfDpIAbZP0+TooRlRJsZQNaYHA7dIMFa65H/xai7fUUqUEXapRJpG2/3SMNNE5BkhyNPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723725266; c=relaxed/simple;
	bh=BTvU0V68JrnBD9SFtmnXCAvdby6njq93GN+eVWG61RM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q1mEefhMn0/3bkQYzt/w6SF3jAOgnzS+xVkEH9Huf+uYAwyo4NVSUMKBOCDst36Etx+eFyWsJGAcQuyrFTK5qckVvpzJ3hwKNko1foLdln8Z2g1r6Z0WRoN5OANuavmcmQCZgKAagTzVzH1sDMzBjzrKxvUsWS2dB8EZB31JZ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D+CCnVQV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723725264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hQ9h83Jg9BQD71lxH7Tpfr7UezhIycA5sCHmxT4jZac=;
	b=D+CCnVQVLJPa7biKZFpU2VvCGIyiLiq58czqsHsgdZfBW4U2jBr2rd/X0iuJudaAI17+Cn
	k1v0J8RgGdgJTjWG5+SWsr8Gcu4lDhlJi2va1SeSx0R36PdVBc817tFFzd5G1E3an1Z8Xl
	uyBUfSJGKMtwpRKuNng52H3mg18lQFU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-ilBqPnsNNMqnkiMqFmwjTA-1; Thu,
 15 Aug 2024 08:34:21 -0400
X-MC-Unique: ilBqPnsNNMqnkiMqFmwjTA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E96B91955D4C;
	Thu, 15 Aug 2024 12:34:19 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.47.238.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E73E8300019C;
	Thu, 15 Aug 2024 12:34:15 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 3/4] KVM: nVMX: relax canonical checks on some x86 registers in vmx host state
Date: Thu, 15 Aug 2024 15:33:48 +0300
Message-Id: <20240815123349.729017-4-mlevitsk@redhat.com>
In-Reply-To: <20240815123349.729017-1-mlevitsk@redhat.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Several x86's architecture registers contain a linear base, and thus must
contain a canonical address.

This includes segment and segment like bases (FS/GS base, GDT,IDT,LDT,TR),
addresses used for SYSENTER and SYSCALL instructions and probably more.

As it turns out, when x86 architecture was updated to 5 level paging /
57 bit virtual addresses, these fields were allowed to contain a full
57 bit address regardless of the state of CR4.LA57.

The main reason behind this decision is that 5 level paging, and even
paging itself can be temporarily disabled (e.g by SMM entry) leaving non
canonical values in these fields.
Another reason is that OS might prepare these fields before it switches to
5 level paging.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254d..3f18edff80ac 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2969,6 +2969,22 @@ static int nested_vmx_check_address_space_size(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static bool is_l1_noncanonical_address_static(u64 la, struct kvm_vcpu *vcpu)
+{
+	u8 max_guest_address_bits = guest_can_use(vcpu, X86_FEATURE_LA57) ? 57 : 48;
+	/*
+	 * Most x86 arch registers which contain linear addresses like
+	 * segment bases, addresses that are used in instructions (e.g SYSENTER),
+	 * have static canonicality checks,
+	 * size of whose depends only on CPU's support for 5-level
+	 * paging, rather than state of CR4.LA57.
+	 *
+	 * In other words the check only depends on the CPU model,
+	 * rather than on runtime state.
+	 */
+	return !__is_canonical_address(la, max_guest_address_bits);
+}
+
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
@@ -2979,8 +2995,8 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
-	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
+	if (CC(is_l1_noncanonical_address_static(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
+	    CC(is_l1_noncanonical_address_static(vmcs12->host_ia32_sysenter_eip, vcpu)))
 		return -EINVAL;
 
 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) &&
@@ -3014,11 +3030,11 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(vmcs12->host_ss_selector == 0 && !ia32e))
 		return -EINVAL;
 
-	if (CC(is_noncanonical_address(vmcs12->host_fs_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_gdtr_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_idtr_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)) ||
+	if (CC(is_l1_noncanonical_address_static(vmcs12->host_fs_base, vcpu)) ||
+	    CC(is_l1_noncanonical_address_static(vmcs12->host_gs_base, vcpu)) ||
+	    CC(is_l1_noncanonical_address_static(vmcs12->host_gdtr_base, vcpu)) ||
+	    CC(is_l1_noncanonical_address_static(vmcs12->host_idtr_base, vcpu)) ||
+	    CC(is_l1_noncanonical_address_static(vmcs12->host_tr_base, vcpu)) ||
 	    CC(is_noncanonical_address(vmcs12->host_rip, vcpu)))
 		return -EINVAL;
 
-- 
2.40.1


