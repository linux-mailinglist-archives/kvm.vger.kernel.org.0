Return-Path: <kvm+bounces-67509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FA4D0706F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C04A2301D89A
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE9231B101;
	Fri,  9 Jan 2026 03:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K4/YmLM6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43530270EAB
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930345; cv=none; b=ZT4ijBZzmpePPp07WN6EguGc86MN608LYcgwWHZV4Ia27PeRiMC+Wq2NckHRstU90XPXGXHwQgx3hqeLGO+3o87VJY9AoaqnpguoInlisPyZEwcKGtiw3C1I19+IHEchkqaoOlhc705vDnQdXTWXRBNXc5gg+4v6K3+F032ewfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930345; c=relaxed/simple;
	bh=OHCeNRp1wt9IbXCaJRqofsAtvp1Jfc8eqsNolsnerWU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=erIVqpyvKrsLq4662K5myjySTrZd8hL57hBQSJ7XWwuAAjFgolvHnbE+CZRzz6itIic72nQsDeq7QQk80lZ+/4Rwk8Jl411KLZIitE042rE3f+UzIU+pehkN0Eyj/MRmLbtLGIvK1b7Ipmcz+QjYmFaoem6kldpDGvb7Pe7ax4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K4/YmLM6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so3205491a12.2
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930343; x=1768535143; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=97rvvcgreI792oaYEzu9bWB1KLSBFwBggjm3Kg+Hq/c=;
        b=K4/YmLM6ZC6n5kuC5MD95G4CkfodphF/qjthFNP6hajh0uQMQPpZDbnExocV3x9JfX
         UY/crhtqjscX7j0DNgm+8Xu+85fHQnp8mrZq3XzydyIsR/NaYABDAN09LKv7PdGMjYkH
         IBnnDGnqWvrTz/XJRU7+TGUpD4HqwbTSGB5SZDholU68WNk0/irGPvUIpfMuEUcH4TP/
         /3rmIGsSOhb1ByVqTLn92mI+nNYFzxA1pbst5F62MRUcYpbPjU4F4O5g3T3LqVB+woOX
         U+O3HT76kHQGBMfcgKZcitWp6uC9LwowfE6DriICqefsln/kgSA+ff3FrAEbB/VvpSmo
         sPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930343; x=1768535143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=97rvvcgreI792oaYEzu9bWB1KLSBFwBggjm3Kg+Hq/c=;
        b=uE0oq470NaAMNgCL3bQn2t9MwTlwQfFgnBb1aai7O1rLtwmlJ+5ztG/6RiA77ywpe9
         SM5dKdz/wR1UctbRV9St8+wd7KGxWAB1JcEIGXoxOruGIfnrlZIuxuetkvOaL8if6YYl
         KjClglQw4u5WMoKSiCzducm1x3yXL8pOducAKuczjdqsufEJHWqt8HQtO69nd4WbZc+w
         waUPhx5IfWP5Zo6DSI/MWS7yKmpFk54mVTUxFxyJt2spv9CWDPbgSAr95rGDbZcbv14o
         nJJtN7igp0IbdozReyFSiPLV/2Y8vwwKXLa8LkHtaFwyfo094sesS5Ud2FViEysM13EU
         +qcw==
X-Gm-Message-State: AOJu0YyG3Nu99Yu3pEt0KQCZ4HBUi/s5OJT56W+AN+QPUCjIPgFp/Rss
	2J8N142A2rNFEfLp1ozX3UVTjY3Mf88NPpIbJrmH/BcqIsFmhn0P2eNZ1L6bT1ICU54dNcVCxM2
	b4cig4Q==
X-Google-Smtp-Source: AGHT+IHotUYH3uDHB5Qxo6BCx8dLSPdORnpJvhVILsX7PibbCEz7iBu1MHUFsX9Ywu0PHxLG7Hpl7nTv1K4=
X-Received: from plv9.prod.google.com ([2002:a17:903:bc9:b0:29d:5afa:2d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40ca:b0:2a0:bb11:9072
 with SMTP id d9443c01a7336-2a3ee4bfe1dmr77575225ad.55.1767930343574; Thu, 08
 Jan 2026 19:45:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:29 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-6-seanjc@google.com>
Subject: [PATCH v4 5/8] KVM: nVMX: Switch to vmcs01 to refresh APICv controls
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If APICv is (un)inhibited while L2 is running, temporarily load vmcs01 and
immediately refresh the APICv controls in vmcs01 instead of deferring the
update until the next nested VM-Exit.  This all but eliminates potential
ordering issues due to vmcs01 not being synchronized with
kvm_lapic.apicv_active, e.g. where KVM _thinks_ it refreshed APICv, but
vmcs01 still contains stale state.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 -----
 arch/x86/kvm/vmx/vmx.c    | 5 +----
 arch/x86/kvm/vmx/vmx.h    | 1 -
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c2c96e4fe20e..2b0702349aa1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5155,11 +5155,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 	}
 
-	if (vmx->nested.update_vmcs01_apicv_status) {
-		vmx->nested.update_vmcs01_apicv_status = false;
-		vmx_refresh_apicv_exec_ctrl(vcpu);
-	}
-
 	if ((vm_exit_reason != -1) &&
 	    (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 74a815cddd37..90e167f296d0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4578,10 +4578,7 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (is_guest_mode(vcpu)) {
-		vmx->nested.update_vmcs01_apicv_status = true;
-		return;
-	}
+	guard(vmx_vmcs01)(vcpu);
 
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 53969e49d9d1..dfc9766a7fa3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -133,7 +133,6 @@ struct nested_vmx {
 
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
-	bool update_vmcs01_apicv_status;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
-- 
2.52.0.457.g6b5491de43-goog


