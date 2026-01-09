Return-Path: <kvm+bounces-67511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C32A3D0707B
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D96453021A52
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D5B32F741;
	Fri,  9 Jan 2026 03:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vBm+ai4n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF115322DD0
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930349; cv=none; b=fEcyR/ELcj/IFoX75KGZnPjM5xqyI9McYaG5gAWBzaFWBPace4scO5moSwbKr62JBV2Fa/qEga6ohyDvTzvirKZw6mUNsGbzDonWSl2hu3b2muouG8e/Y8xAN/O+agbN4MnsBXqXtSt0axTGPPW7fhVG/zjLRhffsAHaB0gjW+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930349; c=relaxed/simple;
	bh=JXh0ie+obtWocTYMsoUxD71I9Ghckom7SaJFDbVOF8c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FSKjkcXMuQkZz87Ty+wYzQaRdzz67L6Jjcz4DA+Qb4gnGjIU1B1AKs6A5Q7gUl9tPq550MVekcZvxKwv7ynnOlmt4HchaTgANtUUyHBY0lpg/8AW0MyrWQXRAnHYDzhW5wNZ+W9znYWUiOIOmtEa8yPHsyjzwPQc9PWJPKiw8UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vBm+ai4n; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0fe4ade9eso40099575ad.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930347; x=1768535147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BAkYuiqwP0nictwbePl0dBrZdxmnnDy80TEFALD0j3o=;
        b=vBm+ai4nRmS9Wq3AQJs3/E27OWNHW/2LUz7nJVGr/z8wQIVlpq3+qK5J2OM+dtv6go
         TVyQ1r52ewt+7P3JVD/P/273kKfowExsLqJ7XBlH/1otZTIhHCKqf9q7x04s/4VTCcG6
         g84wIi+wMDhsA459ZP+9TimnffU45Tt4fCu2X8n/tQjNx3emcGzIhmMsclKPhnV+aT2Z
         CqQkdH2AScGIH0hiPpxhN25on3j+199leBhEKG2/NrRMKJdtkYg+N9/SJUsC0aYNF/NM
         xk19QvibGqnX61sMqcwTeYbkgSJ0RODtw08HtdLEcBBeXZwbSNHxgJW+zfWgdfAk0/Ma
         NG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930347; x=1768535147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BAkYuiqwP0nictwbePl0dBrZdxmnnDy80TEFALD0j3o=;
        b=wPzz4zmj1tlMFLnl9VeBqX+66PsKEzIkXAcMynJh5RTC4Vq/n9bp4dMYJs2pzEh4NB
         RsD4JN0rHpqtdKmg8P5rgRZjaO9xq9SN3EyczTn+SwFRDuopj0juWGpLBKvrHFwCYDeW
         1IBhWPV7sYhyHxLCP4if/DGBK5wMysNy2myIhHLpcFJjs2NnlE44LF0MCi/uqFZwO74L
         w8536nAQINFkbb2wutYB7scFyA06Hf03DvvM0mPZXp6NyFTdBmQHCnovlQXAvnLoVToM
         7X20/hv/iA76FMaNhPL+9bU+L7ARakgIv9FYy0gWrxZlKcrXwvtSruq2IDDR9DLNoQcO
         ezyw==
X-Gm-Message-State: AOJu0YxiHkFyTxcuKsXnFviji9tnBXbhVEFT1vLaaQ5Rtlorioz6SG/L
	Jno6la1OSvUi18ptN/dpdl5gsVklBypMS2Fp/CYTp4g8o5TZj0Vo5OW9/3/tMesQ/+dM41eHMbf
	TVME3kA==
X-Google-Smtp-Source: AGHT+IH+44EtSFhcUAG8z3rdDTxFhPX9bO2zMP3KOY2VBO2VeBgYp28++elygt9mi7qCit9q8JNn5XCb1YM=
X-Received: from pleq17.prod.google.com ([2002:a17:902:f351:b0:29f:25b4:4dc4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a83:b0:2a0:d629:9032
 with SMTP id d9443c01a7336-2a3ee40eea0mr83243145ad.3.1767930347215; Thu, 08
 Jan 2026 19:45:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:31 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-8-seanjc@google.com>
Subject: [PATCH v4 7/8] KVM: nVMX: Switch to vmcs01 to set virtual APICv mode
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If L1's virtual APIC mode changes while L2 is active, e.g. because L1
doesn't intercept writes to the APIC_BASE MSR and L2 changes the mode,
temporarily load vmcs01 and do all of the necessary actions instead of
deferring the update until the next nested VM-Exit.

This will help in fixing yet more issues related to updates while L2 is
active, e.g. KVM neglects to update vmcs02 MSR intercepts if vmcs01's MSR
intercepts are modified while L2 is active.  Not updating x2APIC MSRs is
benign because vmcs01's settings are not factored into vmcs02's bitmap, but
deferring the x2APIC MSR updates would create a weird, inconsistent state.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  5 -----
 arch/x86/kvm/vmx/vmx.c    | 17 +++++++++++------
 arch/x86/kvm/vmx/vmx.h    |  2 --
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8196a1ac22e1..b99e3c80d43e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5143,11 +5143,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	if (kvm_caps.has_tsc_control)
 		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 
-	if (vmx->nested.change_vmcs01_virtual_apic_mode) {
-		vmx->nested.change_vmcs01_virtual_apic_mode = false;
-		vmx_set_virtual_apic_mode(vcpu);
-	}
-
 	nested_put_vmcs12_pages(vcpu);
 
 	if ((vm_exit_reason != -1) &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index af8ec72e8ebf..54701bb815eb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6842,11 +6842,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	    !cpu_has_vmx_virtualize_x2apic_mode())
 		return;
 
-	/* Postpone execution until vmcs01 is the current VMCS. */
-	if (is_guest_mode(vcpu)) {
-		vmx->nested.change_vmcs01_virtual_apic_mode = true;
-		return;
-	}
+	guard(vmx_vmcs01)(vcpu);
 
 	sec_exec_control = secondary_exec_controls_get(vmx);
 	sec_exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
@@ -6869,8 +6865,17 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 			 * only do so if its physical address has changed, but
 			 * the guest may have inserted a non-APIC mapping into
 			 * the TLB while the APIC access page was disabled.
+			 *
+			 * If L2 is active, immediately flush L1's TLB instead
+			 * of requesting a flush of the current TLB, because
+			 * the current TLB context is L2's.
 			 */
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+			if (!is_guest_mode(vcpu))
+				kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+			else if (!enable_ept)
+				vpid_sync_context(vmx->vpid);
+			else if (VALID_PAGE(vcpu->arch.root_mmu.root.hpa))
+				vmx_flush_tlb_ept_root(vcpu->arch.root_mmu.root.hpa);
 		}
 		break;
 	case LAPIC_MODE_X2APIC:
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 078bc6fef7e6..a926ce43ad40 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -131,8 +131,6 @@ struct nested_vmx {
 	 */
 	bool vmcs02_initialized;
 
-	bool change_vmcs01_virtual_apic_mode;
-
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
 	 * use it. However, VMX features available to L1 will be limited based
-- 
2.52.0.457.g6b5491de43-goog


