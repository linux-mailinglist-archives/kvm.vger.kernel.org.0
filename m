Return-Path: <kvm+bounces-65387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 034F4CA99BD
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 46EF23021DF3
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6BD30276D;
	Fri,  5 Dec 2025 23:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0uCEu18Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39082FFDE6
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976774; cv=none; b=Cqdsz1ua6kwAK5qY/Jgipg+eNhn9qphuDvNtEQtO49Nh1wLQb+LR8kImJVojjKI7fxjDBxAvWnu1IiXyE1zfRom7EyAgcXvtTeGT8xl3L4n5UFPRCHd3byvyVTTATwrExonM3B5tSmF9AgxdnMKPw5ZYOe8rfEgZ33tW/tmUFZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976774; c=relaxed/simple;
	bh=F9ad1wjbwQOARvbkDcajWfewiLy5rWUDB66kZlDmZ60=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eETZdOp0Z4YlwqysP1u0COIF2Eo9W7ynMVVYG8ykW/SmJjZiVNAavgvMBrtFwgYJLpn+/1WgrZ+f/TRI7hQ/riB573zEZp/kXbEFuM3p43ukdbufG9Zr8Ai0ynTI7Bqd5Ymw3SX/Etf5hvO2IXqowCwwJsl2ulUtXnil4TzX7qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0uCEu18Y; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436e9e3569so4520524a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976768; x=1765581568; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=r75KP3MfE3xvB8M90mZtNcH7CuSSTaOPShGdGL5u5R8=;
        b=0uCEu18YIJe417Jps0aU4Xep7Jcz/n77HR2rItyibhuSDSjmHqvTM2/x2AzPgbPSsx
         DcBGyBJXxGAAJ2Yfig0f9bLvMVSLvGH6GfpqoO9wPS6Da8YEI+C1U20p3TZIkCed80dO
         qlsc91qa/Lq+TZd9eCo6O3WhSOns//GD9k7HhsL+Sefc5RMP5WvskEpUj+4CMbt0iLvJ
         zR/uIIfEJmaRTTHPbfTHvxmHDveC6Z2TmEh+sH6rxqEanEcgt9zGEA7jJcx6XaF/E2kd
         hfT2aYDy+Cc4EONSNPJhMV0j3nKEJmwKwjWTsqSngpW++zEv5GD2Q1hPtQkhUb5j1H2B
         aMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976768; x=1765581568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r75KP3MfE3xvB8M90mZtNcH7CuSSTaOPShGdGL5u5R8=;
        b=Yd1Dgt3Z9rGXlZhrNpi82SBuZYVVUIg8e+J4sFVnpml2Mlb1tSDQxwKcM+a1ajaC2L
         UBzn+0Q0Po/GGp+lij+Sb1k8CV37PJWtejoocIoCykwBz1swszUbgb6P56uedrtW9/Jk
         GpHh6e1CTZ72gWL0um/WEHgVgmN11WsfQ9cvNvwBLrwuX+1TXsTqqYYfMGYT4b8vIng1
         RX3Mki8I0Aeqp9AcZ5zh2qBj1UZBJu14sPVd4pyx3R1rbV0x0PM7BeRap5V69hlIz0oW
         53pFkXKhevW62bC7dJXE/qIB4SPF2XQTBJdjJWcGocYP3Ode6HfKY+sLHPmDw+2wl6Cw
         RqLQ==
X-Gm-Message-State: AOJu0YxqkX1H+2tk+07jkext49D6Z8MkWOn7rmfkPUXtTnO4s1bVd1Iq
	c+ZDXCgaymNsz7keC3RC+Sb/TpSg93ps6/5k5ryNXbfBZ7DBGXbIPXBU/hyinn3EkWJILyGxIST
	Gy22SiA==
X-Google-Smtp-Source: AGHT+IFIPU3ezuGe142lObXM6m/a25sKwMQh+YMXUKaG0a4fm8UgxypvPkcF9Z9j64FfB0DY5nuDnt5zf3k=
X-Received: from pjbmv10.prod.google.com ([2002:a17:90b:198a:b0:349:2946:c225])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a08:b0:339:d1f0:c740
 with SMTP id 98e67ed59e1d1-349a24e48a9mr522061a91.1.1764976768536; Fri, 05
 Dec 2025 15:19:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:09 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-7-seanjc@google.com>
Subject: [PATCH v3 06/10] KVM: nVMX: Switch to vmcs01 to update SVI on-demand
 if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If APICv is activated while L2 is running and triggers an SVI update,
temporarily load vmcs01 and immediately update SVI instead of deferring
the update until the next nested VM-Exit.  This will eventually allow
killing off kvm_apic_update_hwapic_isr(), and all of nVMX's deferred
APICv updates.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  5 -----
 arch/x86/kvm/vmx/vmx.c    | 19 +++++++------------
 arch/x86/kvm/vmx/vmx.h    |  1 -
 3 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8efab1cf833f..c2c96e4fe20e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5160,11 +5160,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_refresh_apicv_exec_ctrl(vcpu);
 	}
 
-	if (vmx->nested.update_vmcs01_hwapic_isr) {
-		vmx->nested.update_vmcs01_hwapic_isr = false;
-		kvm_apic_update_hwapic_isr(vcpu);
-	}
-
 	if ((vm_exit_reason != -1) &&
 	    (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ee86665d8de..74a815cddd37 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6963,21 +6963,16 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 	u16 status;
 	u8 old;
 
-	/*
-	 * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
-	 * is only relevant for if and only if Virtual Interrupt Delivery is
-	 * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
-	 * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
-	 * VM-Exit, otherwise L1 with run with a stale SVI.
-	 */
-	if (is_guest_mode(vcpu)) {
-		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
-		return;
-	}
-
 	if (max_isr == -1)
 		max_isr = 0;
 
+	/*
+	 * Always update SVI in vmcs01, as SVI is only relevant for L2 if and
+	 * only if Virtual Interrupt Delivery is enabled in vmcs12, and if VID
+	 * is enabled then L2 EOIs affect L2's vAPIC, not L1's vAPIC.
+	 */
+	guard(vmx_vmcs01)(vcpu);
+
 	status = vmcs_read16(GUEST_INTR_STATUS);
 	old = status >> 8;
 	if (max_isr != old) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 36f48c4b39c0..53969e49d9d1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -134,7 +134,6 @@ struct nested_vmx {
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
 	bool update_vmcs01_apicv_status;
-	bool update_vmcs01_hwapic_isr;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
-- 
2.52.0.223.gf5cc29aaa4-goog


