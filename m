Return-Path: <kvm+bounces-30360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C4F9B983D
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F17D11F217E0
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C66D81D016A;
	Fri,  1 Nov 2024 19:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KU3G66rB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CFE1CF7BC
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730488498; cv=none; b=M8293PwAS6+L+TBtniAfrS+z5MkmJtoVAGUBM4I2dR1+R512xNPkZXSC+lAdg2PcP2V32lRIl6pmo4ifrkkzkxCgDNsBYpfc+lTI6A/nEIQ1h991k4EotrCZkIVr0GjXzZEe5CUV3pfTx/5njDSHsxDuWQmNBW2eNhVnYn2ZbZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730488498; c=relaxed/simple;
	bh=3THyAOFYqGiZ3re11pAzXOzUv5U2Kh6KiITyIgCJ00s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ON6CAiE1x6cYXQC2XKcK5beuexgphgyqLxQmJhpWvJ3PI81FpQh5j0VxY20h4IhfGGndn5P1pvMtF60eV9CjqrYRrHiDGp57TjWHalZECL5FV3cj2rqZKzj+3tJsmlPnk+3aEqtZQU4YFCGGpQc7/1+PN1UNkE3UjqhxYI13wfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KU3G66rB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20e67b82aa3so20934165ad.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730488497; x=1731093297; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Bty8Xxmjy9aCwGBD+Q77bQvQCPqX0/VPBlC1IcBrLWY=;
        b=KU3G66rB+VR9FlcNZPXrJyW7UatY6PQwCm6jN2mbZv3x32fEKCBCU5n1Whsso0D4ac
         oI4TfaLIs2quzReBMtsX0+9GntEzK5DWQ1HZr29PT63piwfv2pMKwVUfS7Jl2SxZAU0d
         Y1C1PvU4Qi2/dSHjPGYA25xluQx7rEWezTpcJLcPhDUJZOIXOrrmE2tIsv3ijb3GAbZx
         6YpL8N5P+dYSy+jqPavNaTJHfl1lUD/ydAmr1jdYtB014wYcozgQBFyDfo1MUVSuFYn4
         kHqSJFynoWqeymufDXa24UyiV7100AHccnY2KrD+u487o9D0SZIS7bpHeatRIW7ody5+
         datA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730488497; x=1731093297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bty8Xxmjy9aCwGBD+Q77bQvQCPqX0/VPBlC1IcBrLWY=;
        b=s5Y24n97QePTY44OxuXluSgvxaRM3VLSOS+E/QvyL0hQp7UVJG0eJAqJin8uQtqGSZ
         f1/RCWLLavuJstzpP9hZBjJURHehdMeLi77FbhQaHjpqVylxNoXwI1J+UVj3UfHRG5Gb
         xiNjSWwKw3yfgw54eAAmxe8FSeOa7Dy+ovqVAPyv+0DAqDheI3r8EBKwXmiTqdH1DMYX
         Ix1vfCyL13fGDRxUYC41XUkavfieW6qQY3c7UD48kn76b8w4MIZ6U+RkqY4UrEkuecY2
         DiKBqvnPt0jdk4gqSNj7uR+Ss1maA3sfDCAB/SKE+TdHR7HqrFZqnV+Xyki5nj5zsa8j
         9dEQ==
X-Gm-Message-State: AOJu0Ywxd0OSbVgPMdkCRxhOQ91rrP/grV0YU3Dt0zITRhj9CdK/qs7R
	0tFd/OFCKKv5HhFUxjjG8tOwTxXcOGZDZtqj1wO0/26zGIDrNJvFEYH6VUmsVJEgKeR//2pfayI
	C+g==
X-Google-Smtp-Source: AGHT+IFk3TV3aGBmDsau6FclKYwuGA5/t2XABMgaAJqdgPRwBHX0/QyxzgqbmL+hpK/UfwTGUXOB8E7yWFk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:e745:b0:20c:9821:69a7 with SMTP id
 d9443c01a7336-210f763beb7mr1927395ad.6.1730488496835; Fri, 01 Nov 2024
 12:14:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 12:14:45 -0700
In-Reply-To: <20241101191447.1807602-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101191447.1807602-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101191447.1807602-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: nVMX: Drop manual vmcs01.GUEST_INTERRUPT_STATUS.RVI
 check at VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the manual check for a pending IRQ in vmcs01's RVI field during
nested VM-Enter, as the recently added call to kvm_apic_has_interrupt()
when checking for pending events after successful VM-Enter is a superset
of the RVI check (IRQs that are pending in RVI are also pending in L1's
IRR).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 781da9fe979f..4d20ab647876 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3467,14 +3467,6 @@ static int nested_vmx_check_permission(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static u8 vmx_has_apicv_interrupt(struct kvm_vcpu *vcpu)
-{
-	u8 rvi = vmx_get_rvi();
-	u8 vppr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_PROCPRI);
-
-	return ((rvi & 0xf0) > (vppr & 0xf0));
-}
-
 static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				   struct vmcs12 *vmcs12);
 
@@ -3515,8 +3507,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
-	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
-		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
 
 	if (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
-- 
2.47.0.163.g1226f6d8fa-goog


