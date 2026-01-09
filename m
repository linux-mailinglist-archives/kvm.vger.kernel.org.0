Return-Path: <kvm+bounces-67507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BB362D07060
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 091FE30617D3
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939E92FE048;
	Fri,  9 Jan 2026 03:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9W5jnfE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6074D2E1730
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930341; cv=none; b=dk83OAuvrKFpIbRuCJkwOg7GHmsHZyFkMg4YyiwAjGv1lZ2WaNVkxv5AB08e0DkO76r0YbjU/d6O95MY3+DkzsGYsFLUuz0yXSoPHJC0b3RJlzlktFikjuKDb/qZ57bvPnasxfJ7ZswhfyWdr1IJU2xHHIMg8F5TNrejN2VwOHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930341; c=relaxed/simple;
	bh=ZT0U0x+9g09xqjPT/0E35x3IQPyKy+0Y8xFgFIMYoxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o08bp1z632s47o/QZMiv+r3uulhtzz0Ky+ekLxakduT2fdXsbik38l7DIr0KGlGiLVR/nGGvlGJxJNV6AQOTU4wWJEjt+Kw7/b3N8oKwMkvc41yDhlixoxEA3hQABFGSaPpW/IbY2NJbbRB+GyIC/ji2gCKXN2kC5DBmfPR/XMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9W5jnfE; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c52743b781eso1143919a12.2
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930340; x=1768535140; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tw76Itas1ms0nm/HkT0Q/pAxr8UdkEkAfo1cZSDlWBs=;
        b=w9W5jnfE+T415AKFUGHcuKSAeTkvlo0+LAFr14Y99zvK3R1x6zcrdPoPbzDEocSTaI
         tHd5K8hPynUiUqBU6xbv5ogviVB5npm3EQM0e/C/LHGf51oMLA0oNN5RescOC4batHqf
         P5kr04tPYDsI0OpBV+RdURKSY7JX4kx3hmfomj1z60bTV6oflki7bMi4AyWTuHYKrc3A
         rWdpseGIYCOc8CCH3cjffJrzqPkPg9lVwpjTxEJfHOS33XM20nQpNPNZ7DfDyX0TLgHz
         4u2R9xH4UNAwBrJAJ2e7dCImU0gI35JahLa2dqiEbpcBciPsHLuJcVQCK8lKM5t1Jm1c
         bhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930340; x=1768535140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tw76Itas1ms0nm/HkT0Q/pAxr8UdkEkAfo1cZSDlWBs=;
        b=wdQQTf7C5YPNbNbK9UzQ+3QVsy9VnjAp9go3ZPDvZBjLox7Jnv3WH+G5dqMKJBeSu9
         F2XLtoN0VfamFUEjWgk5MoOWq7h3qrovgOpBfHYn7btKAyVmS7ZYCeumZVceDtTKsEWg
         kGV9AGGpM73kBEAcbkG4bEfqtwb29WhQhEHdreeTi4R0cV1hvFX2TnrT2yYd2rDLAqrR
         szS+bDtsWDyMgcpThQhn6ZLpTd0XuTgMr5VxLzTXjsPm1lPpOpDVp46LaI2HmBOCvYn9
         sImZL4qe0mXF6Gvrj96ip8A3u5ipzB2/+1o/UfXIUj3nVHt/4eO/a7u6I+PBqQ1LEw7B
         opTg==
X-Gm-Message-State: AOJu0Yzgq/hB0Ss4ihZWMKR/fIV8WzY97RofB1lmgUIBThDgtt9h5fHH
	VjOmKsx8UxXCch183HObImNPQydWreFoNZlyjS164Wo8vUjkRMYXKte2YKVY7X3/NdaMWn0fD1v
	ZfNMF9g==
X-Google-Smtp-Source: AGHT+IH/lW5NmDB9qcwr9rHXLQVjyDc1n512c0xaZbcjMwhrpfdV6CUAlAwGHdo+o0oKSpFcJVKDWx1AYVI=
X-Received: from pjbgb18.prod.google.com ([2002:a17:90b:612:b0:343:af64:f654])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f9c:b0:364:134a:2bc1
 with SMTP id adf61e73a8af0-3898f8cb991mr7774812637.18.1767930339801; Thu, 08
 Jan 2026 19:45:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:27 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-4-seanjc@google.com>
Subject: [PATCH v4 3/8] KVM: nVMX: Switch to vmcs01 to update TPR threshold
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If KVM updates L1's TPR Threshold while L2 is active, temporarily load
vmcs01 and immediately update TPR_THRESHOLD instead of deferring the
update until the next nested VM-Exit.  Deferring the TPR Threshold update
is relatively straightforward, but for several APICv related updates,
deferring updates creates ordering and state consistency problems, e.g.
KVM at-large thinks APICv is enabled, but vmcs01 is still running with
stale (and effectively unknown) state.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ----
 arch/x86/kvm/vmx/vmx.c    | 7 +++----
 arch/x86/kvm/vmx/vmx.h    | 3 ---
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 920a925bb46f..8efab1cf833f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2402,7 +2402,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	exec_control &= ~CPU_BASED_TPR_SHADOW;
 	exec_control |= vmcs12->cpu_based_vm_exec_control;
 
-	vmx->nested.l1_tpr_threshold = -1;
 	if (exec_control & CPU_BASED_TPR_SHADOW)
 		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
 #ifdef CONFIG_X86_64
@@ -5144,9 +5143,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	if (kvm_caps.has_tsc_control)
 		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 
-	if (vmx->nested.l1_tpr_threshold != -1)
-		vmcs_write32(TPR_THRESHOLD, vmx->nested.l1_tpr_threshold);
-
 	if (vmx->nested.change_vmcs01_virtual_apic_mode) {
 		vmx->nested.change_vmcs01_virtual_apic_mode = false;
 		vmx_set_virtual_apic_mode(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1420665fbb66..3ee86665d8de 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6827,11 +6827,10 @@ void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 		nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
 		return;
 
+	guard(vmx_vmcs01)(vcpu);
+
 	tpr_threshold = (irr == -1 || tpr < irr) ? 0 : irr;
-	if (is_guest_mode(vcpu))
-		to_vmx(vcpu)->nested.l1_tpr_threshold = tpr_threshold;
-	else
-		vmcs_write32(TPR_THRESHOLD, tpr_threshold);
+	vmcs_write32(TPR_THRESHOLD, tpr_threshold);
 }
 
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b44eda6225f4..36f48c4b39c0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -184,9 +184,6 @@ struct nested_vmx {
 	u64 pre_vmenter_ssp;
 	u64 pre_vmenter_ssp_tbl;
 
-	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
-	int l1_tpr_threshold;
-
 	u16 vpid02;
 	u16 last_vpid;
 
-- 
2.52.0.457.g6b5491de43-goog


