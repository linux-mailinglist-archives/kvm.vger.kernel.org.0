Return-Path: <kvm+bounces-65390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE88CA99E1
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7694431CFEE8
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74645302167;
	Fri,  5 Dec 2025 23:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="puAV1KyX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E013E2D8391
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976777; cv=none; b=L+nz/WDTvVqeo+gsp3NLQaa9gJ4JjZFSOxAJTB1b97jTC888uaGdpgGfO4QU52cgrrarGYoDiuCevN67XGRIcyHYg0seuRWJT6pmAWtjzXNl0WagNh8Wx4ntoJlDOH2IuVDHOSCOG2/8vYBjAQV6Dxyjeply1W2COo50CEJIb/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976777; c=relaxed/simple;
	bh=nyBOMcsqOad7IoLOo0q40mFK6aPw3NvQd2nvH1ocBgQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fLmWz9fTRXDWwY6gzC8uiAkn8eAhA719htUBK/kOwcEurbhwFA9D0FalhPMf5iVDa14TMB1JaQf1P6k4NozzEPA1dasj4ZRDNrRIAmKbmbO2N+YKKKRGBsdu7lF50EV3ACdSFhOcmKaiFqL4M8SG+Hz3Qhkj3vSTJv0K79j3ntA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=puAV1KyX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-349aadb8ab9so34275a91.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976774; x=1765581574; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IsexBN3HLqIzHAM1sNf2bQBLDWiAlBctQuC9XLUheco=;
        b=puAV1KyXlshPVQIIEhd543D5HpWnCzsGuKgXTa6dIJMC5vF62Etto68ZY8HMMkoLxK
         Kf7BCDK8cS0chXEi7YKaZgsluetwERqSlvcOiXxNbdKgu0heivAQn2xuAsV1hEY0eaP+
         j11Lkpg+I5UfLI6T27fkYgvaVjYYsWRbolPlOP118tgXfPCWSJriicYR085xBUhwje92
         xTTv5HQ34jr9+HB3DXa4ajLhuUgtCDIVmUYUOzz9heNLJv0ysQ0EISPuUcE3h2DSAODr
         oalOaSEccBZCK6Rjvmc6Plbw1/NfofAyKoWKsdGbyOn9k1YcJAIAzBcMPasGdj3ZSj17
         rV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976774; x=1765581574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IsexBN3HLqIzHAM1sNf2bQBLDWiAlBctQuC9XLUheco=;
        b=f4JwQBdiRvomp9LwjHefePqb8jWcVRkCQag2eDpa5sgo5S8CzTxPqUd16ELPT3DsVP
         VEMrWhj4csPGI/28UvAlDJuayVSSSGJhemJJOxfqIpogYSWNfPRRoGNQhvSZKS6Lf+tb
         2wz/Zusdhj9I1srgQqocWw0iMV3Mw9z/4LCLM4rtPOHJCT3QHH9hhnwPkpUzlpn4SUE3
         TGJd5uffCl4dZ1ayJYi/+55t2avRLIawwNbwWRa5fYRNpj7/PtaIMdVxnqHXaKmA+GE+
         jFs8nt0rv/49GWc5Y7vZfe8eNDr6YWR7kbtU02zedTwyvm0tKxRGGcuEr43FNLSiUL5H
         +6MQ==
X-Gm-Message-State: AOJu0YxcRTWiFsQPvJ6cTEaQzeQ6TNVJwvXxyjfihzcUf9kBRdSfNRzH
	WsJsxGK2M/5WJpBK1OZGtV5ITxqaYJ4/h04wKEhZ3GOKKo27b4cYDVGG1sqge3nezSw3wKWM1jv
	NwtnSuw==
X-Google-Smtp-Source: AGHT+IF9TcyPCg1udOgDVkvfEtBjujDFLUwg7kUIcspQ/gscSHWTd+z00f00CIgGLLi0UWiscML0Yh1hEnY=
X-Received: from pjbfw22.prod.google.com ([2002:a17:90b:1296:b0:340:b14b:de78])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2886:b0:339:a243:e96d
 with SMTP id 98e67ed59e1d1-349a2610ecfmr427297a91.36.1764976773801; Fri, 05
 Dec 2025 15:19:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:12 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-10-seanjc@google.com>
Subject: [PATCH v3 09/10] KVM: nVMX: Switch to vmcs01 to set virtual APICv
 mode on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
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
index af8ec72e8ebf..ef8d29c677b9 100644
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
+				vpid_sync_context(to_vmx(vcpu)->vpid);
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
2.52.0.223.gf5cc29aaa4-goog


