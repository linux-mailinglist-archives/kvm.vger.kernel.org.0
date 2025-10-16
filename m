Return-Path: <kvm+bounces-60233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C19ABE5ADE
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 899C61A67402
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C3D2E6CA9;
	Thu, 16 Oct 2025 22:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xVMYrT61"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146CF2E36E1
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 22:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760653703; cv=none; b=Yt6Vk71LrR1de2MlA2u9c2vOcM8NRbiJdzPR3BugnQK4FO1iLTkpobcHFjACBgj4vC8+NsRiuiuueFM6JkhPeNPKvIx7kUL97zoi2RkhDZSIhqShzb//wBBSzuwL0JBYasTPVUuFcAhEdhnGhOoDS2kZsRVbKHlRbUpPaTOdMZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760653703; c=relaxed/simple;
	bh=yw51Q166Lc381x4Xu3XmbBkTFmjBPCZNcIy/n1Tj+/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PxYbh0X9ND8iiU/M4NrgWeh1vp/YWbjrRfWuj7UjaHl2K/MpdHHFsPS4xkipAgJwvv2uqRFrS/vUhcuAf/bMuuw7QFfnwR2I49ZjtYtjc9XltY7o1Or2KplUdcRb8Ntlk43QBgCRLz8InYhS+MNBiL5jiFERbp5zV0QSTB/AMkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xVMYrT61; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso1892822a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 15:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760653701; x=1761258501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=40vdtZU/KoPpmX9suWkabYPY075MZ6BH4jE7OVELxWw=;
        b=xVMYrT61KMki+UyPSXt5QJipiBrv/JTIm15TReveHXVogW21fHTrVGJI1iiXn9/a0S
         tURxpf7BXetiKtO7R6aFzYa6Gv6LRFO9+jVHX+cJobu+xUqD3rTje68cO+hZfs52b8Wb
         RWqXusV8KcAOPLH6Sb1MpTwXzAaIEwqbW52XNLwa9X7qPYE+B6uZGoQK2Pel+3en1MXA
         WJ/0Od1MAufxP9N1fNywJZkTqzG1OhNdqpoawwVbf7xSrQYIuzYqZw/TZN/Y19ApK5iO
         PxZE9qIwEXRjKp6A3k/Co1Aeg28s2wFufNyfKCsgBemIOdlNW7RVTyDlULWZbZstiLAE
         rdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760653701; x=1761258501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=40vdtZU/KoPpmX9suWkabYPY075MZ6BH4jE7OVELxWw=;
        b=P+rde97Bweg16uHvoQ8wwQG8li2ZewsP75BsxSA9BHg/PKZUVSVBVQulubo0crcLVZ
         lTZvrb6I1j/6J5WLtUN6WBkGcEmXue7Vn9a6XmoXWwbCSbrKbrJdrOcrHytqEIcVVXax
         KLUBakwWVmLo6GzTOM/VhkxQ27GPfOxnXCLAwBeywpTTrkZeiwsnF+vQFtVowJuC4IyZ
         KYIoXIgVFqoTLqZwNqPD30TmqcZPZe8m1+FED2BZ5WOb2soAPrgPpGtJFMGdaC37Ftf8
         MuTJFdxFyV2v9TX803WYSa2BlSCJSDljKUds2Qnyn7wvsiiLN7XfG2i8PIJJlWN6ky5R
         Rf8A==
X-Gm-Message-State: AOJu0Ywe1MuUPpTYkwuxvK18aYmCwyRelInYaauHxlDTRi+SRcV3nstq
	WRatpGC9T1nX1MXfRsyKTc4zD4bb6crqEKiQOdZ/oy74NBDtXwWClxM3n8EuslsqjH5tRPkeIcg
	b5/MTUg==
X-Google-Smtp-Source: AGHT+IH6Vt5HCZ4OsiTtySVHgnNCPAx3kKlqIVZQcPIWh1JDleJgFcxQ9QlzXiMEeW/9zOz/TZlBnAw47FY=
X-Received: from pjbos7.prod.google.com ([2002:a17:90b:1cc7:b0:33b:52d6:e13e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54cc:b0:33b:dbdc:65f2
 with SMTP id 98e67ed59e1d1-33bdbdc660bmr324878a91.22.1760653701294; Thu, 16
 Oct 2025 15:28:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 15:28:13 -0700
In-Reply-To: <20251016222816.141523-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016222816.141523-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016222816.141523-2-seanjc@google.com>
Subject: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Immediately synchronize the user-return MSR values after a successful
VP.ENTER to minimize the window where KVM is tracking stale values in the
"curr" field, and so that the tracked value is synchronized before IRQs
are enabled.

This is *very* technically a bug fix, as a forced shutdown/reboot will
invoke kvm_shutdown() without waiting for tasks to be frozen, and so the
on_each_cpu() calls to kvm_disable_virtualization_cpu() will call
kvm_on_user_return() from IRQ context and thus could consume a stale
values->curr if the IRQ hits while KVM is active.  That said, the real
motivation is to minimize the window where "curr" is stale, as the same
forced shutdown/reboot flaw has effectively existed for all of non-TDX
for years, as kvm_set_user_return_msr() runs with IRQs enabled.  Not to
mention that a stale MSR is the least of the kernel's concerns if a reboot
is forced while KVM is active.

Fixes: e0b4f31a3c65 ("KVM: TDX: restore user ret MSRs")
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 20 +++++++++++++-------
 arch/x86/kvm/vmx/tdx.h |  2 +-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 326db9b9c567..2f3dfe9804b5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -780,6 +780,14 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
 
 	vt->guest_state_loaded = true;
+
+	/*
+	 * Several of KVM's user-return MSRs are clobbered by the TDX-Module if
+	 * VP.ENTER succeeds, i.e. on TD-Exit.  Mark those MSRs as needing an
+	 * update to synchronize the "current" value in KVM's cache with the
+	 * value in hardware (loaded by the TDX-Module).
+	 */
+	to_tdx(vcpu)->need_user_return_msr_sync = true;
 }
 
 struct tdx_uret_msr {
@@ -807,7 +815,6 @@ static void tdx_user_return_msr_update_cache(void)
 static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vt *vt = to_vt(vcpu);
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	if (!vt->guest_state_loaded)
 		return;
@@ -815,11 +822,6 @@ static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
 	++vcpu->stat.host_state_reload;
 	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
 
-	if (tdx->guest_entered) {
-		tdx_user_return_msr_update_cache();
-		tdx->guest_entered = false;
-	}
-
 	vt->guest_state_loaded = false;
 }
 
@@ -1059,7 +1061,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 	tdx_load_host_xsave_state(vcpu);
-	tdx->guest_entered = true;
+
+	if (tdx->need_user_return_msr_sync) {
+		tdx_user_return_msr_update_cache();
+		tdx->need_user_return_msr_sync = false;
+	}
 
 	vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ca39a9391db1..9434a6371d67 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -67,7 +67,7 @@ struct vcpu_tdx {
 	u64 vp_enter_ret;
 
 	enum vcpu_tdx_state state;
-	bool guest_entered;
+	bool need_user_return_msr_sync;
 
 	u64 map_gpa_next;
 	u64 map_gpa_end;
-- 
2.51.0.858.gf9c4a03a3a-goog


