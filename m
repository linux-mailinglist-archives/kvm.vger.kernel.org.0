Return-Path: <kvm+bounces-65385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A67C9CA99D8
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3E24320EBD4
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F493016EE;
	Fri,  5 Dec 2025 23:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Z8DcuV7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB09229B36
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976770; cv=none; b=DbhswN6WzmHtoZAdJTIpHK9syFiL4X0JFUcP/X3Ko2Ko+pGJiRgSmmXofspl4O2ReJvR8A528BgzLCQmIPhVLo5uMmMk6eJ17p4vypbc9ApemyZPw+gplADS+exwVS7l+/ipyPtvd0FDiBOfBwTYkoU8m7tBQRDIy+g2/TGUfRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976770; c=relaxed/simple;
	bh=JZFCAVE8KHQyo10EbULFfjgFlLhIrbp0ClGa9OqgEO0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fu8OpSWv/a9d56SJjBDmXLjDwFpa5KR7hqde14DHHF1hpByl5nMXlHjCO/iP/X0O1YFV8QpwnSJB3suPivCEvr28ecDepVovA5qksERuiev1P0IXxmWyy3H0IX31rvjL1ECI4FUsf/thFEGj8Gjdd2wnN38fzmjpqDWDv6pEE1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Z8DcuV7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343daf0f38aso2997824a91.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976764; x=1765581564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Mvq9EwNuVt/uRDW4qk+DItZf7McZ3rUgRJ5xdyR4olA=;
        b=4Z8DcuV7M/pXTI9xnqEcXVojGpPfDfXdlQ0LJl7YgmqodRB5vv1/MDnUOwAfGqu/VP
         Su7wRrvEJBAP9xXT5iK9ChmfUMkD5bXh22e8D1JeQpgBrpqO4f2DtHg+vsxZNI9BCb5n
         w9cHUZZPKHr6FIGVOgPn4bhEizRBjkwcOwntY59WWNB1nnVfiMvw2l3GbGMcgUWEBaAf
         c3c+ocPl701ieur1Sjksn9a56Qdhw96u0qUs4OYnjctOJ/gVd4UyTJdWEOVEesVAG3Vj
         I8lvaRnqxyaVwe1ZxVCzQpJ6xDHSE51tgRO6u111ktnaQARRCLkx+nYXhwJgePqSEBEd
         YvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976764; x=1765581564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mvq9EwNuVt/uRDW4qk+DItZf7McZ3rUgRJ5xdyR4olA=;
        b=HSiwQUHQdRNTieYSwwFAt3ArzLzHKHNiGw40tjxx+mwVrRPqZaIgPHuYTqeg3EatzZ
         TWHVcykobW7vmesvFnxekqynX/lICXGButENGrZX/DBLmB9ZKuyzPiq9NKcYLjTQoZZ/
         DiUBg6/yocJpcbJM0tWZtaJcvMLJsax+ga8BzVNV3J/ifohaGmVoUH2iIHco4rM8WRAd
         SUS/Hn8wz9T9VWRJ4JrrJEwD7YgjWjJNfydhEUlkosBz56InSR3ne66FtjCTkv8SfPiv
         PB2UoCY+O9NW/deC7nO6SLFKQ7hl1uIqYCUUX97SyBYKH/I/FE6T4sZKiIYQOcB2X66D
         A/XA==
X-Gm-Message-State: AOJu0YzDuN0L5fqmVIVwu13trrKNAgSHovIVHEaPRycDqOG8/GiPhZl9
	HJqixxbyasq4DZGr47Mexvism1LKxQH6FF/UkvWdb4Nkp2OXHpSeN8MMYN5fUQFu2vE+Wj5Rz1m
	PCBp/WA==
X-Google-Smtp-Source: AGHT+IGaqtsQIlRIt8dhC6XhjoLt1eLpPH33jgp2ob6v9qBUcmBPpf0biCLwuxLzldqH2TDHNchN+IL7vp8=
X-Received: from pgbee7.prod.google.com ([2002:a05:6a02:4587:b0:bc0:d9a9:8a8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1584:b0:361:2c56:fca8
 with SMTP id adf61e73a8af0-36618164900mr850783637.50.1764976764391; Fri, 05
 Dec 2025 15:19:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:07 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-5-seanjc@google.com>
Subject: [PATCH v3 04/10] KVM: nVMX: Switch to vmcs01 to update PML controls
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
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
2.52.0.223.gf5cc29aaa4-goog


