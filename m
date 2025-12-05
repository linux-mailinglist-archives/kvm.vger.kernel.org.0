Return-Path: <kvm+bounces-65386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CBBCA99A8
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BC07B303979F
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30663019CB;
	Fri,  5 Dec 2025 23:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gE/QjKne"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB0A27CB35
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976772; cv=none; b=hqwJLIdahC7wDz9BOCyuTIQp56SkyKvNONY5JZny6JYGktvhyJbCAMjrYBLZh0EHEB0nemU4ukE71wsqzmmkb9MI5Jx4RIYhdESSAh82DZs2kwHvNt1ptTrFov6W2lWX+rFlRFOO+W0+AAC2gnUsWaFVMMe7xgwbLUbsVSr6UcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976772; c=relaxed/simple;
	bh=Iz/PdNNvwiToa3bILkudY0rFq88iIR9xc2DDP4kGkh8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V4OngUJohVWCDGBBqmmIFN/FquUCYOrtYfI8AvLKKGSocUWkNSYjFL/7KWTSnbJGTHVJj15KY/yL6yaeZadIC6YC/7t/YK/QVX4GFvKbnzFTkJUa6VfcHYhiDCXf2/CElCZgiPZjAASNlkzCZEAIly4O6jpxi8r8NEObf879UPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gE/QjKne; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9ef46df43so2820659b3a.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976766; x=1765581566; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uei+FBCp6XSbN3s6wo1y2mN6ct0eKDDXjuxrLY/MXh4=;
        b=gE/QjKneIbRRLyCDWr1jewAjR3v0jgFyPultOww+DNkb7JHyCGhqT6L0XiHi64AO8e
         LOSfC0Oez+p6i/xUMOPDcj4s1zOTQf44Pl7oZuI78jQ7r4ymaCOyJMTiaOv9eNelo8ik
         8ym3/jR/zRc3/2tC2V13s0ckUcDxtGrr/rkys6z/0Vrfbq17lWlqwaU4pQZ82wgpk5GR
         TL5VcIwujuXw2xTz/J97lS0XC6TmijWRwSpFSLXf7KcuasbzbQs3DcU/NrwVQ8bu5icx
         F5IO11Whe2CkgQGOY5z+Kjz5HWjDYuA6T48SoSAc0x1F46yrHhDpfLAZtmNc+YKnHPkD
         dRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976766; x=1765581566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uei+FBCp6XSbN3s6wo1y2mN6ct0eKDDXjuxrLY/MXh4=;
        b=PO7Es/rEhsJ/fZUoVqQla7QPbyNrHa0gGXJ26f0cRiMkY/KNbGDPotAct5gxtdM2NF
         yHJWA/aphBX5AbDlq6VtFeCOomqjITGvnfHlHQJlXgClgdO6Cz5vhrCifZahSq94Xgi2
         TdNN49ZT/0ZdrCI2hhMRsnF8SCnKpzecFgS9440LIn2Dxib2va6C7ufAIpatdrxVpCNe
         H8yorimrPTTycypeqf5XgU/a/SjVo1oBo+//8U0TcZTG5wMkJ3jh7r2TZOppdlh3uFRg
         8zBRkf6jxzACXEZd7c1f6ZGSgQ96XNk1a4AoS8kCiDpMAVgQXi44fzLVahw7oy+AG4JV
         VsyA==
X-Gm-Message-State: AOJu0YzyGQ0iV9EFakWAvuJ+eOm+RA513R0+A7vtOtlVkLoE8TG/6XWv
	CT7O3p3rEzw1u9EbcNdKXoqvVRiFFDMaTmh5YyM3jAHB0gW+M7hNtQpT/B783TEnwKQDhVrw6k7
	eLdYcdg==
X-Google-Smtp-Source: AGHT+IHvwjR/m6NdvCSTi9F88Nx4U6tu2ksUiv6cW14/aypzQz62E6H2QrvIw9QHUoJfvHKc1gUxiy78M6M=
X-Received: from pfbfa36.prod.google.com ([2002:a05:6a00:2d24:b0:7dd:8bba:63a2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1ace:b0:7b6:ebcb:51eb
 with SMTP id d2e1a72fcca58-7e8c02094c9mr708360b3a.17.1764976766283; Fri, 05
 Dec 2025 15:19:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:08 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-6-seanjc@google.com>
Subject: [PATCH v3 05/10] KVM: nVMX: Switch to vmcs01 to update TPR threshold
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If KVM updates L1's TPR Threshold while L2 is active, temporarily load
vmcs01 and immediately update TPR_THRESHOLD instead of deferring the
update until the next nested VM-Exit.  Deferring the TPR Threshold update
is relatively straightforward, but for several APICv related updates,
deferring updates creates ordering and state consistency problems, e.g.
KVM at-large thinks APICv is enabled, but vmcs01 is still running with
stale (and effectively unknown) state.

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
2.52.0.223.gf5cc29aaa4-goog


