Return-Path: <kvm+bounces-67508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE33CD07063
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 547B6300D2BA
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F26030F555;
	Fri,  9 Jan 2026 03:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wzIKMCA6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C85829AB1A
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930343; cv=none; b=Mqtf+i8SuO1s/83/Og0INKd4/qyLrC7rMaCHwtmvwE19Vcp6GvVuPHWmyReSdtLUbKi1H+lk/DbHq/ad4UmkIa3VeVfjuLwamdVJEq3xnwSb8+Gp4jqo6pOF1eBlFEcL7FF2SuhAAMMvXIqVTgk2uGMlHmIJbThrwsFF92jkZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930343; c=relaxed/simple;
	bh=JNTMhgYGQgtyJNjtw8vToWb4WTH4XkkwCy6YSvLCHJI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GQ5ITMLXYFMkbHZKFKYH7lx1lNrmgWXAVFG7mAicmzOFST5o4UVSp0M9gfmwggZf3ePbkfR5vy/m4pl/YgUH2VrKeeVqKCb320POYn0MHil6dKrbhUPbrI83JvmzU5yfnVK8XcKVq7fwU9lKwwcNQaYtLIjgmgD6jitemuIyt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wzIKMCA6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c5269fcecdeso1115652a12.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930342; x=1768535142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=riEO8rGkVD0LWXz3K6AdDhJyUv23hQGge3Scgd6g82Q=;
        b=wzIKMCA610x743KzO8Hozl2IoG93V+igQBCeERb0dzVW7vxtJZBjKBYwWBegCmYP4s
         5NPYwP5JPrARfWrjIiCrxo5kGmv44PiHf+cplmp0K2IDz16plHo3L0NIWmrZG21cofdF
         fz885Fmx0R8qsddMPC1KeEHs0svlVXlJryQNqhhTeAlE5HkY5g0I7eryFnGx5DOEVhCR
         mb+3sVf9EsqTNVuZfQR/kcwXu3/F80TdHL1aJNmQub+zPqB6KCAJ3t4Yc0rcfHpBNlnr
         Q7FxwjQhJXgYjW26JA/amMUWy5gCbRFUCJKnXW1X8kIg4IvVydRCjjtF8CUhXUHxbT5C
         3S+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930342; x=1768535142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=riEO8rGkVD0LWXz3K6AdDhJyUv23hQGge3Scgd6g82Q=;
        b=tvd6khTFdKYqnyQ56yMRbFRIQRSsbvCgrKELL7UPTDuRWj7SwLsge0d/59tQXo2QsI
         XJN4gpIovnWqqDtX6G7vjkN70uQXmKUoozY/17A6hkCR7oaJ8fUDgIFtDWGRzKsZRSYR
         y0pRahXX7AWzpn4bHj/pooiQ16GadeRTa2PQjWfbEjeIME7RdWj4ccP/5MvkxKOxmUtu
         lAZ8JzIou1ddLnyoqhakO/wDGValhH8yUCdbtAwYrKP4jwYS2EeSc140hLfp5akkClf8
         Jga6Y+IbuNXdMaSCYeVSHaExITtJOpHWkStsJS8rUMQR1G11JWGw61fg4rQTDuTeL7PH
         /qFQ==
X-Gm-Message-State: AOJu0YwCQuP5uswuzPpBAG2EZRgk5054Ei8ZivrdViES4ZDCtsjsjuuS
	pP1tquczzW5UBDtOsO1U8sRa4gUN7GRLB4qtQuidvgSFXpoP87cv1QZ2jGkaUtR3JqEqTjHJuXg
	DgXbXNQ==
X-Google-Smtp-Source: AGHT+IE0rWF4oD9F9ZCOJh0KeVUbkzSQAwujDJRsVmOEh0vsbQxymaB5ScAy3POMHmzqBRcqwUw8ZJ+5w5I=
X-Received: from pgkh12.prod.google.com ([2002:a63:e14c:0:b0:c09:15e9:db3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:339b:b0:33f:4e3d:aff0
 with SMTP id adf61e73a8af0-3898f8cbb87mr8987404637.21.1767930341668; Thu, 08
 Jan 2026 19:45:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:28 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-5-seanjc@google.com>
Subject: [PATCH v4 4/8] KVM: nVMX: Switch to vmcs01 to update SVI on-demand if
 L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If APICv is activated while L2 is running and triggers an SVI update,
temporarily load vmcs01 and immediately update SVI instead of deferring
the update until the next nested VM-Exit.  This will eventually allow
killing off kvm_apic_update_hwapic_isr(), and all of nVMX's deferred
APICv updates.

Reviewed-by: Chao Gao <chao.gao@intel.com>
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
2.52.0.457.g6b5491de43-goog


