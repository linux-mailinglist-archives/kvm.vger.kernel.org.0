Return-Path: <kvm+bounces-61600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25389C2297A
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 23:45:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A00741A62513
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 22:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA420340A5A;
	Thu, 30 Oct 2025 22:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w2CQc3uT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF9F33E350
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761864177; cv=none; b=qaiZabOO8zbKH9mX9K0dZevFz33Qq1hHZkOHzQz2M5y5hMO/3ZdPumGYy+aO15t1XkH9ffcPYh1PLDF0ndz/de48FHnXdU5cFG6NUOsXJyu7d5dmTYG5UxgUdwZFQMjz8CrTNyz8KL5zDMBzYezEryddAYT0uAV0UGe6B7P4sBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761864177; c=relaxed/simple;
	bh=MchINskavBlkrWKmsZW/V/NyWaLoR3Fo1XQuVOdWnzU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T6pw/Bvh1nmOc0dtl6uTUHkkChjIWZi4ZBv2RbA6mOBncmcWGlqmE/ym3SN0H3iHGefzka0/q0+ruX9vcfDHOtExNk1l0xGJDtZjk+prYV2aqtWqvkjqNmckk5hAAQZ3Bfpm2cahmmSFKbioR2lDpWyKexAgwRWPVJSXEmN5djQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w2CQc3uT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3407734d98bso719170a91.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761864175; x=1762468975; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RzJXvA2qL3oBmeCAhgbR20GHWytyM2jCig5eMpHPXQk=;
        b=w2CQc3uTqtONunN+PyPkmQVUtI4sYB0GQvZuT5HOPb8mKxngdl/Vtu3uazHidjJ0eR
         2jsMsdcHEJqe1JiDbvXiY1+yi47xpqPAA+SC0DQCBFI2FGcJETZNSzfvfXDymP4iMitP
         aIHqyRt9qI9JOaC0qu1cabzTBxWQPSU32Ao9ah5iQ8nSxZ9EB0vqUDart3uozN+47deD
         6hQu2MX2GFNWNWTWI57R5LZ0VF3Gc5bQHvO8rhGbfcKfIhU+IwJOEHasFEwK1ayH74Of
         MJN4WmUpmFH2RhpxO0BY3zzLujhVJMFQkoitpLSiCDhg3pdgxOU2a30j/MVcH22TnQ6M
         Awfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761864175; x=1762468975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RzJXvA2qL3oBmeCAhgbR20GHWytyM2jCig5eMpHPXQk=;
        b=uZi4Rm6cST47MPDu5J7AhtR4cLCHR9hF/hmkMSrU4DXtotaBUHMeIC7uIZmautwt7/
         J8c4FRFg4UO4cD1BABte69btWxN6JJ3DM4MFFRsotvduXxVtAoMkmPZSqC//vS+cElLw
         XBwPdLXcTyQapFJYF5dBGRLjXJtnypwByL8GNE2J6QLj412r2EG+H7KQw7ch+D0iYkZi
         6PZFyOr5u0yrA8RY1WMGLYl0UA1MbPyAUCZJroSAeT9ASiZdRliDBUDPZdbSPmTQsDoz
         5GC2jFgT5VyAXp/cQS0+pxImpWmy2fvcqp6bkuasGzSZMHqYui9QkJ+fqNM0dSIr69pt
         Li5Q==
X-Gm-Message-State: AOJu0Ywo/sd7glyNnfxsrBXT9LfBCb1bBLQJ/46pk+wpEGpiazaJFfbJ
	pM0SLmHi6MniFhfBVz6jeM5DetqBMYEV4lLVx1v0sNSWyvnfwYdqITh7xTmlEE/3CUpTqsKQdVl
	1yO4X+w==
X-Google-Smtp-Source: AGHT+IGTW7/+BlUHW51xmkfkplp3sSIcQ+cUhORPp1pYopyj5vl7hP44CWO33PujFVasNhIynwLieXXQRjA=
X-Received: from pjbms9.prod.google.com ([2002:a17:90b:2349:b0:33d:69cf:1f82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f87:b0:33e:30e8:81cb
 with SMTP id 98e67ed59e1d1-34082fd8a5emr1932559a91.13.1761864174630; Thu, 30
 Oct 2025 15:42:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 15:42:44 -0700
In-Reply-To: <20251030224246.3456492-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030224246.3456492-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030224246.3456492-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of the fastpath
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="UTF-8"

Handle Machine Checks (#MC) that happen on VM-Enter (VMX or TDX) outside
of KVM's fastpath so that as much host state as possible is re-loaded
before invoking the kernel's #MC handler.  The only requirement is that
KVM invokes the #MC handler before enabling IRQs (and even that could
_probably_ be related to handling #MCs before enabling preemption).

Waiting to handle #MCs until "more" host state is loaded hardens KVM
against flaws in the #MC handler, which has historically been quite
brittle. E.g. prior to commit 5567d11c21a1 ("x86/mce: Send #MC singal from
task work"), the #MC code could trigger a schedule() with IRQs and
preemption disabled.  That led to a KVM hack-a-fix in commit 1811d979c716
("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/main.c | 13 ++++++++++++-
 arch/x86/kvm/vmx/tdx.c  |  3 ---
 arch/x86/kvm/vmx/vmx.c  |  3 ---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0eb2773b2ae2..1beaec5b9727 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -608,6 +608,17 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
+		kvm_machine_check();
+
+	if (is_td_vcpu(vcpu))
+		return;
+
+	return vmx_handle_exit_irqoff(vcpu);
+}
+
 static void vt_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 {
 	if (is_td_vcpu(vcpu))
@@ -969,7 +980,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.load_mmu_pgd = vt_op(load_mmu_pgd),
 
 	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
+	.handle_exit_irqoff = vt_op(handle_exit_irqoff),
 
 	.update_cpu_dirty_logging = vt_op(update_cpu_dirty_logging),
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 326db9b9c567..a2f6ba3268d1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1069,9 +1069,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
 		return EXIT_FASTPATH_NONE;
 
-	if (unlikely(vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
-		kvm_machine_check();
-
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
 	if (unlikely(tdx_failed_vmentry(vcpu)))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1021d3b65ea0..123dae8cf46b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7527,9 +7527,6 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (unlikely(vmx->fail))
 		return EXIT_FASTPATH_NONE;
 
-	if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
-		kvm_machine_check();
-
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
 	if (unlikely(vmx_get_exit_reason(vcpu).failed_vmentry))
-- 
2.51.1.930.gacf6e81ea2-goog


