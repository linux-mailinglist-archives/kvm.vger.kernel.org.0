Return-Path: <kvm+bounces-65388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AD179CA99C3
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9E30D301A733
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C9C303A1C;
	Fri,  5 Dec 2025 23:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADTPRA4/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7E42FFF99
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976775; cv=none; b=PYFo1ETV5GNjAPAASRp7muDY81OHXCtrTsmZJn0KFAnskdskOlNvStJOwzuZveW7o1UFiV4t6B77asLXncn6ZHimduV2o/XZA/cTql5+BP+UN6CNpIJOZxiA4jksaU708ZQU5HA5dAd4xGejekS3K5+n2NX4iPdE58qZDtvvycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976775; c=relaxed/simple;
	bh=Y3y9z5Dem+sGP084lKmrwtv8wTb9CyaL0moHFIEpymE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ztn2037GJm2aAD9MYoezIbgtc2P+qYf/FPixpuiqOh8h6QJWQEW+XX98qPurKQoUSCvM5+ULc6cucbiTyflqaTGV7aUaHAIJ/S6xdSUzeOh1rTTWecir9jRy0GV3mHzgeK0QxaF0psVVTRlI2Nvo1q3h4khp7eWBjPYa7pCEkCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ADTPRA4/; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297e5a18652so32644455ad.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976770; x=1765581570; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zRgsu7txhPlymPyldYkGSmbzB+dNiAxZ1OO2LYHMK9o=;
        b=ADTPRA4/xH7V9qUeu+cvCU9Yl1pJSmYZqoKfG65JZcUBuQNNKAm8UopIPb6touMDSm
         P2uIBOe9cWtzLo6JtW8T5rsK7TXKCR6SINWprT6LUImShJPZ0iJxDyW4DgSssoA6Lg/w
         EOQqVHN6T9KCcDoKrUbbGIjpoUR9cKw2i8XzgjaTl2z6bogVN58NKtVnVbm+4E0uJTew
         a87gcGRt3/Yo2SWszRA/2He3sOavYNGvXcR7umi/ueV1D9z2Z7R8yM5IkPDtsQTPJCa+
         0XCtl+Hk8valmv/sBGF8OnTR/leBjjiUClVZbX+tCODHEJvHhOf3nG5gNCLuM60RDyy+
         h73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976770; x=1765581570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zRgsu7txhPlymPyldYkGSmbzB+dNiAxZ1OO2LYHMK9o=;
        b=wCibm1OkI4iiOjRk+dGkxBjCVFG3PKTrsECDyPvRXvVp7b8EwhS9kZK3q3vaahVst9
         FIipu2PocDAacXE3GgNE1VfgSogaAXbjO2WDvzVOrSmTWwfkoeGQrVhm3BqW6RUclZJh
         k9MuSqU5sj5T8BWa1T0xdAz1kbkZdoV2lsggvBILGw0Jo8BdXp4tkq5JE9WoHHNOOZCX
         FGX2DFtnwDWypvvFYQ4jVhGAO2Q4u2XM+CL+6bS3HCIkGxF56wIeQ073Zcl1tC/2sTGV
         yGvLF7zE01X9rbpyiTKscp7axSDVRS49Tzg6jDTVMHdl69jtgW2iP5hpVCCppLv1ows7
         TfrA==
X-Gm-Message-State: AOJu0Yx0wFHNFMgka3GyNmSsqumctyC1jy7tiXs3tfgX/QmMVmEBzuhL
	/ljgIU0Wdv2Wn5zGo1pMkCM8ZgQ6L6p0O4q+ORyVCQOP58pJfG2IF6QWx4pFxl2/HqapIpMSe/7
	lbaFL1Q==
X-Google-Smtp-Source: AGHT+IFTYHrkH7tC3zMkHferO+2I19/FJ006vgRJJ1FgLAVFgB7GWM6536sdWq1jx6EJRqwNjneRG2Nv/4o=
X-Received: from plld18.prod.google.com ([2002:a17:902:7292:b0:297:d4ca:8805])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b0e:b0:295:8a21:155a
 with SMTP id d9443c01a7336-29df5bb4030mr5967455ad.35.1764976770121; Fri, 05
 Dec 2025 15:19:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:10 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-8-seanjc@google.com>
Subject: [PATCH v3 07/10] KVM: nVMX: Switch to vmcs01 to refresh APICv
 controls on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If APICv is (un)inhibited while L2 is running, temporarily load vmcs01 and
immediately refresh the APICv controls in vmcs01 instead of deferring the
update until the next nested VM-Exit.  This all but eliminates potential
ordering issues due to vmcs01 not being synchronized with
kvm_lapic.apicv_active, e.g. where KVM _thinks_ it refreshed APICv, but
vmcs01 still contains stale state.

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
2.52.0.223.gf5cc29aaa4-goog


