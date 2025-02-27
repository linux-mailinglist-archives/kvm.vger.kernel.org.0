Return-Path: <kvm+bounces-39641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2550AA48B84
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FA561890A7F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 22:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E9A281365;
	Thu, 27 Feb 2025 22:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bZBNcmXt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADC1280A3B
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 22:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695063; cv=none; b=JBJMe3g45IseI+bIw7Ao9zPVNKcb9JJFqWRaEUq3T29eOSZz18Lqe0O3vJ9EBYl0eLRGSr1wwJTK3h3GLcGDOHhov7cPqYsv++z6mVSPJy6JQSK2WXiBMovkgRMqm4ro12f80bsQQie3Vj8fX/4taORAtqQiDwt1BMMx6rj8klY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695063; c=relaxed/simple;
	bh=rM+piIbm6fPPUQU3tS/TNtc7JXxdSH4MOK9KtgfsdwA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FMrmPqWtd4OLBHIWFVltNlxTMhe68r1gXRqjoT/EkFubn3Ah/zHqvuimU0+YJ3y4T4c31nv1feLVMgbwMg6pksHmmLsVNxvvK81sPb0pciNglmjO9Ab1SN5zt78qj0d2N/z1oEepoJ5qZ5mJkiFFa+37JuPJpdmuTezCfsQHr2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bZBNcmXt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe8de1297eso3108081a91.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740695061; x=1741299861; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kC2GVKQNy/500VxIVTCNd9Tr/l/Ea5Ufkhz74/uHUys=;
        b=bZBNcmXt4lgyDUlJQMUKsMIG58AVtq7rOXftXCRqSIlBBQGm1NoFpRsSwDG08araWK
         /WdyhOIO3gUs52R1xCW5X4SBtRbcMVb1dQ8vkQEew2oA3vJ7aJUvovcbR786flB20z1I
         xxrTpZgJwBd4oEA7Or99JUsGP4vBDEnRRHg7QsZQ0ndQNzbofYH4cSqRhEMHKG23SagM
         j2qg95wgr0L2ZLcGy+tmb26tJyGsVrBA2gGLfaIqXo472ZeOKhHXMJuxDG4nD1vosz27
         xqIhiQpY57yh8uuS/FvUBA8o2JGoGfS92NLxz+DxoA07A2inPwElxw3+N1LzRJZ7xBVG
         JIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740695061; x=1741299861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kC2GVKQNy/500VxIVTCNd9Tr/l/Ea5Ufkhz74/uHUys=;
        b=dGEsEMU7bovVJUX8BFbYIEKCnkHF0CzSaTHJpzNsRbukKYtgshIops1uunUPX/QZCJ
         L2GTs6E+cDxkZ7HWhFcQck9hkvnSzUxCcVHAr1gSGfdZxk5UBXLsGW3GcISCRuwHDilk
         hPcghqcftPmGGCLrNBd/g/yre1IVHNealXFyjUPPw32+t5j3tARaYVh2BS1MH55gLaJi
         Hx8L4pDw/sNlVDNS+wYH+VD/gW7h86sNUw0dZt2nSWGeKZ0FPRysK1mZtJmaOEXBSZXv
         g0MjbPSjy03kdnbb968iDMooyUx0AXIR4cys32dakefBpH3wZ7r0zFcuF4m0JG0zq6g8
         kN+A==
X-Gm-Message-State: AOJu0YyNz0Ml35pduj4KmAo2SP7tjSDqIS7hq/zXW0lsL3l408DN7TpR
	dgSPTltL/3x3hbESJ+BPAy1Im7k66NgJf4plrnuFqKEoIXbx/yZv9G9Llqq00IR+yvGL8CeRMSA
	Efg==
X-Google-Smtp-Source: AGHT+IHvOmBlb4arTT0QJ+YI/scwXxLdSS+NaBMhoz0+AlnE6vAOu60sbh/h88+WVTh3zJ2MPG+B9L13bHQ=
X-Received: from pjbpl6.prod.google.com ([2002:a17:90b:2686:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cc6:b0:2fa:9c9:20a3
 with SMTP id 98e67ed59e1d1-2feb9ac1836mr2002841a91.0.1740695060756; Thu, 27
 Feb 2025 14:24:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 27 Feb 2025 14:24:09 -0800
In-Reply-To: <20250227222411.3490595-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227222411.3490595-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227222411.3490595-5-seanjc@google.com>
Subject: [PATCH v3 4/6] KVM: SVM: Manually context switch DEBUGCTL if LBR
 virtualization is disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"

Manually load the guest's DEBUGCTL prior to VMRUN (and restore the host's
value on #VMEXIT) if it diverges from the host's value and LBR
virtualization is disabled, as hardware only context switches DEBUGCTL if
LBR virtualization is fully enabled.  Running the guest with the host's
value has likely been mildly problematic for quite some time, e.g. it will
result in undesirable behavior if BTF diverges (with the caveat that KVM
now suppresses guest BTF due to lack of support).

But the bug became fatal with the introduction of Bus Lock Trap ("Detect"
in kernel paralance) support for AMD (commit 408eb7417a92
("x86/bus_lock: Add support for AMD")), as a bus lock in the guest will
trigger an unexpected #DB.

Note, suppressing the bus lock #DB, i.e. simply resuming the guest without
injecting a #DB, is not an option.  It wouldn't address the general issue
with DEBUGCTL, e.g. for things like BTF, and there are other guest-visible
side effects if BusLockTrap is left enabled.

If BusLockTrap is disabled, then DR6.BLD is reserved-to-1; any attempts to
clear it by software are ignored.  But if BusLockTrap is enabled, software
can clear DR6.BLD:

  Software enables bus lock trap by setting DebugCtl MSR[BLCKDB] (bit 2)
  to 1.  When bus lock trap is enabled, ... The processor indicates that
  this #DB was caused by a bus lock by clearing DR6[BLD] (bit 11).  DR6[11]
  previously had been defined to be always 1.

and clearing DR6.BLD is "sticky" in that it's not set (i.e. lowered) by
other #DBs:

  All other #DB exceptions leave DR6[BLD] unmodified

E.g. leaving BusLockTrap enable can confuse a legacy guest that writes '0'
to reset DR6.

Reported-by: rangemachine@gmail.com
Reported-by: whanos@sergal.fun
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219787
Closes: https://lore.kernel.org/all/bug-219787-28872@https.bugzilla.kernel.org%2F
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b70c754686c4..78664f9b45c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4274,6 +4274,16 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
+	/*
+	 * Hardware only context switches DEBUGCTL if LBR virtualization is
+	 * enabled.  Manually load DEBUGCTL if necessary (and restore it after
+	 * VM-Exit), as running with the host's DEBUGCTL can negatively affect
+	 * guest state and can even be fatal, e.g. due to Bus Lock Detect.
+	 */
+	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
+		update_debugctlmsr(svm->vmcb->save.dbgctl);
+
 	kvm_wait_lapic_expire(vcpu);
 
 	/*
@@ -4301,6 +4311,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
+	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
+		update_debugctlmsr(vcpu->arch.host_debugctl);
+
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
 
-- 
2.48.1.711.g2feabab25a-goog


