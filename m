Return-Path: <kvm+bounces-67506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CA92ED0705A
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C85933017E73
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D3F2EA159;
	Fri,  9 Jan 2026 03:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="azFhIlUD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE922DB79A
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930340; cv=none; b=IPEmgZh/K/KEQoTDjVaQT2lqi8hwzcHmJlPiFKoyYVVCu8eA+2YLMq/yrhnGamYXbSj0HALVw2707g+6MFyGjv8QeHFHTdCBj++1ouHZ1ez9Y2n1siojPhC1NAy/dFQ507atLNP80E/xQRAJVVzPCGPygxVQpggJXilwEH9Ajgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930340; c=relaxed/simple;
	bh=orWaPkiAuW5dWdX6xCjlTadYJ3ABx54C6lKaFm93YOI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ACbZC3FuK+a73zEOzrkZlL7TXqXVnzN4fopU/7AfknPGNnhuUE5+ByVc3QxxrqzOvcawmrsziE7d5nkw4iMiBERivcVPtJyBIIZjwgBvFf9R/P6INTSvTauWLbTVodj0xfu5jvxjRSCRccFblP1i7LtCTQ6RAJc50LTH0glKJSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=azFhIlUD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c5539b9adb8so376661a12.2
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930338; x=1768535138; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NikTKJr2vdZDsmzh4h4fhl6av/cM1UMaxZuL4gTL4pg=;
        b=azFhIlUDLrRcRPimszwVs5/AmDCOfJOitIbXwrHhXzfsdRfnBQfdOUKcOkBjeYz9Wc
         VTQLNPdHCjt9G43PBVe4GV4GYzcEwp0/IxkzfLwoHYE8wFIYROp3DqXYYqChU27QC1sj
         xw100e3d/Fncgs7k68Is1XFrvkeqkj4GR1xauYeyR41HsGZFJkN9UoalpoJoh8LBkkWG
         vDkkpWmF71dR4oDr1m4leSaaPif0UEkkouose7Ue/UHxdraGhjTRS+Lkq7DRa9aU0psA
         HwZ3HZ3fp4YvaDh3Mfy1/yv/nlwcc5qyPbVM4iC9G62OWvApVqZcuG2VEo/emF/kDhL6
         O3vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930338; x=1768535138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NikTKJr2vdZDsmzh4h4fhl6av/cM1UMaxZuL4gTL4pg=;
        b=HXVoITTuyXzdw99yDe2NNIXrPpbZQlH0pNbKhHvGNzBjyUoN1bDJGKxBHpa0cG67yF
         CNRXwMdoKziAjxF7hIh+iDXZtgV8MoqJfCZAuf8aQPvdZKeddGk4FrhYk2eFYFVl0jpg
         559knc4KfeVMFfIVSglx8caISoIBpeobQ+AOcvhsY73CQB2eTetv17zwm88IJ9U5R0XG
         i/xLF9yPyRvRkXXFVAgn6IvZ0ipeto1jx3o6zmT6SQdwVYKQ8yk3IO94k8pfSCkYt+SY
         01PABBGXw5EXpmYgUcyuFwQzyxH3Bk6JjBdqq1YFfSaM9/sI67+lWDxHGEkgtuJo6uxS
         xyGw==
X-Gm-Message-State: AOJu0YwtdQ3nYh96qJqGfVF1OjktJNZavdWsUWVhyn7HzTTx8gthkpMN
	I1KNVzNLgyeb8NNi1bdUdJciHxu5aXgp64yrJbf5MdKEzuN7wbTCpbWX7KkX/U6FsP4YSFrR0OE
	vO9gc0Q==
X-Google-Smtp-Source: AGHT+IFQrJmdgyIMjO3aabN+GefhkhIHSPxGlLvPD9SKtJfdIwMArFhB//EsefNEDdNzyQmaMbWvHQOv21c=
X-Received: from pjbch23.prod.google.com ([2002:a17:90a:f417:b0:34c:d9a0:3bf6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:218c:b0:364:1318:caaf
 with SMTP id adf61e73a8af0-3898fa38c61mr7540200637.58.1767930337960; Thu, 08
 Jan 2026 19:45:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:26 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-3-seanjc@google.com>
Subject: [PATCH v4 2/8] KVM: nVMX: Switch to vmcs01 to update PML controls
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If KVM toggles "CPU dirty logging", a.k.a. Page-Modification Logging (PML),
while L2 is active, temporarily load vmcs01 and immediately update the
relevant controls instead of deferring the update until the next nested
VM-Exit.  For PML, deferring the update is relatively straightforward, but
for several APICv related updates, deferring updates creates ordering and
state consistency problems, e.g. KVM at-large thinks APICv is enabled, but
vmcs01 is still running with stale (and effectively unknown) state.

Convert PML first precisely because it's the simplest case to handle: if
something is broken with the vmcs01 <=> vmcs02 dance, then hopefully bugs
will bisect here.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  5 -----
 arch/x86/kvm/vmx/vmx.c    | 40 +++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h    |  1 -
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6137e5307d0f..920a925bb46f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5152,11 +5152,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_set_virtual_apic_mode(vcpu);
 	}
 
-	if (vmx->nested.update_vmcs01_cpu_dirty_logging) {
-		vmx->nested.update_vmcs01_cpu_dirty_logging = false;
-		vmx_update_cpu_dirty_logging(vcpu);
-	}
-
 	nested_put_vmcs12_pages(vcpu);
 
 	if (vmx->nested.reload_vmcs01_apic_access_page) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b96f7aea20b..1420665fbb66 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1594,6 +1594,41 @@ void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 	vmx_prepare_switch_to_host(to_vmx(vcpu));
 }
 
+static void vmx_switch_loaded_vmcs(struct kvm_vcpu *vcpu,
+				   struct loaded_vmcs *vmcs)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int cpu;
+
+	cpu = get_cpu();
+	vmx->loaded_vmcs = vmcs;
+	vmx_vcpu_load_vmcs(vcpu, cpu);
+	put_cpu();
+}
+
+static void vmx_load_vmcs01(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!is_guest_mode(vcpu)) {
+		WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01);
+		return;
+	}
+
+	WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->nested.vmcs02);
+	vmx_switch_loaded_vmcs(vcpu, &vmx->vmcs01);
+}
+
+static void vmx_put_vmcs01(struct kvm_vcpu *vcpu)
+{
+	if (!is_guest_mode(vcpu))
+		return;
+
+	vmx_switch_loaded_vmcs(vcpu, &to_vmx(vcpu)->nested.vmcs02);
+}
+DEFINE_GUARD(vmx_vmcs01, struct kvm_vcpu *,
+	     vmx_load_vmcs01(_T), vmx_put_vmcs01(_T))
+
 bool vmx_emulation_required(struct kvm_vcpu *vcpu)
 {
 	return emulate_invalid_guest_state && !vmx_guest_state_valid(vcpu);
@@ -8267,10 +8302,7 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(!enable_pml))
 		return;
 
-	if (is_guest_mode(vcpu)) {
-		vmx->nested.update_vmcs01_cpu_dirty_logging = true;
-		return;
-	}
+	guard(vmx_vmcs01)(vcpu);
 
 	/*
 	 * Note, nr_memslots_dirty_logging can be changed concurrent with this
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bc3ed3145d7e..b44eda6225f4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -133,7 +133,6 @@ struct nested_vmx {
 
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
-	bool update_vmcs01_cpu_dirty_logging;
 	bool update_vmcs01_apicv_status;
 	bool update_vmcs01_hwapic_isr;
 
-- 
2.52.0.457.g6b5491de43-goog


