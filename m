Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577B744897
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393455AbfFMRJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:09:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55097 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389430AbfFMRDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so10983409wme.4;
        Thu, 13 Jun 2019 10:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gZcDtbd3b6Y1qrHuqb6ivHsJ9MXA/qlBvU9FIZzx3Xo=;
        b=Pcgr9QMkR+ay1R92AoMWsC9CPJHybVq4Njzcf/flFw2eFmx/GdnTVianZYBgppGoLu
         9wxyoWEToWNnuNz2AkkqmvBRIaK/g+UUmziS5+dNg5Q/sKJy88QzxKDyLyrHTOw/yXtc
         v57eeGywHnJ6QAKvTsyZfx+HjMRnBXtnXm0v2LnL1XVRnbhEVun/Jxp9DDLtEJZrg/Ut
         GCjYgZX94CeU1c00Ks7dAcPZI1G4CcQmieBUHX9g0SlXpgrMZ2CMoz8GSTBkZbqHPfCs
         bcT0qOe/faCIMP5BoohXb399ZMqXJzADUEegtSd0e9arodpD5t0EsOvk3jLZvhQs+Vw9
         u6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=gZcDtbd3b6Y1qrHuqb6ivHsJ9MXA/qlBvU9FIZzx3Xo=;
        b=pcEjNqH3SFpuVb1FsleGsoEcauFfNKn6IAeKsh3hvtAp6Gz7YbEuSCJ3feprTQ/B5Y
         0cpu1eSEWV74Gd70up57F3SaaJ2qsPBQYukX49Yc1OZbOsegh70fPrH4YCQZT2tl3g1M
         DWeMjlwrhndDOLG+dqmgiuepmvd95QJFRtVmwgCK7ciNG2G960M5sx20MOhyeWm0pN9p
         PiEs2fGb4MY/ZAIDaND0/+STrj03Vef0uKSj+t5G/BD1VlUsbf+bsurRQ4G5tdQJROib
         ikyteoHwOOWRVIM7BRT3vK1nFuKNYMO2VcYR9UbLrVT0MKJmGHFe2u5sSXufC6oh3PlN
         wCLw==
X-Gm-Message-State: APjAAAWwDPWx7cCw2HOMWOvIT8TyR9NtOR/kyBttYj2ruDTMZM8cuQx9
        YTKwAVW0Pid1iR01RZRjb9nwoB36
X-Google-Smtp-Source: APXvYqyYn798KcJzS5pAjOJEaQBBMaLDr+v/qqaRvFfEiDnNRw7fQKw1KGyO5a0jb7pE8xDISrxG5Q==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr4759583wma.114.1560445422546;
        Thu, 13 Jun 2019 10:03:42 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:41 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 11/43] KVM: nVMX: Use descriptive names for VMCS sync functions and flags
Date:   Thu, 13 Jun 2019 19:02:57 +0200
Message-Id: <1560445409-17363-12-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Nested virtualization involves copying data between many different types
of VMCSes, e.g. vmcs02, vmcs12, shadow VMCS and eVMCS.  Rename a variety
of functions and flags to document both the source and destination of
each sync.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++--------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  4 ++--
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bdaf49d9260f..fc2b8f4cf45f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1615,7 +1615,7 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 	 * evmcs->host_gdtr_base = vmcs12->host_gdtr_base;
 	 * evmcs->host_idtr_base = vmcs12->host_idtr_base;
 	 * evmcs->host_rsp = vmcs12->host_rsp;
-	 * sync_vmcs12() doesn't read these:
+	 * sync_vmcs02_to_vmcs12() doesn't read these:
 	 * evmcs->io_bitmap_a = vmcs12->io_bitmap_a;
 	 * evmcs->io_bitmap_b = vmcs12->io_bitmap_b;
 	 * evmcs->msr_bitmap = vmcs12->msr_bitmap;
@@ -1839,7 +1839,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu)
+void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -1860,7 +1860,7 @@ void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu)
 		copy_vmcs12_to_shadow(vmx);
 	}
 
-	vmx->nested.need_vmcs12_sync = false;
+	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
 static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
@@ -3042,7 +3042,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
 	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
-		vmx->nested.need_vmcs12_sync = true;
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return 1;
 }
 
@@ -3382,7 +3382,7 @@ static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
  * VM-entry controls is also updated, since this is really a guest
  * state bit.)
  */
-static void sync_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
+static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 {
 	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
 	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
@@ -3861,14 +3861,14 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
 
 	if (likely(!vmx->fail)) {
-		sync_vmcs12(vcpu, vmcs12);
+		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
 
 		if (exit_reason != -1)
 			prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
 				       exit_qualification);
 
 		/*
-		 * Must happen outside of sync_vmcs12() as it will
+		 * Must happen outside of sync_vmcs02_to_vmcs12() as it will
 		 * also be used to capture vmcs12 cache as part of
 		 * capturing nVMX state for snapshot (migration).
 		 *
@@ -3924,7 +3924,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	if ((exit_reason != -1) && (enable_shadow_vmcs || vmx->nested.hv_evmcs))
-		vmx->nested.need_vmcs12_sync = true;
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 
 	/* in case we halted in L2 */
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
@@ -4284,7 +4284,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 		/* copy to memory all shadowed fields in case
 		   they were modified */
 		copy_shadow_to_vmcs12(vmx);
-		vmx->nested.need_vmcs12_sync = false;
+		vmx->nested.need_vmcs12_to_shadow_sync = false;
 		vmx_disable_shadow_vmcs(vmx);
 	}
 	vmx->nested.posted_intr_nv = -1;
@@ -4551,7 +4551,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 			      SECONDARY_EXEC_SHADOW_VMCS);
 		vmcs_write64(VMCS_LINK_POINTER,
 			     __pa(vmx->vmcs01.shadow_vmcs));
-		vmx->nested.need_vmcs12_sync = true;
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	}
 	vmx->nested.dirty_vmcs12 = true;
 }
@@ -5303,12 +5303,12 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	 * When running L2, the authoritative vmcs12 state is in the
 	 * vmcs02. When running L1, the authoritative vmcs12 state is
 	 * in the shadow or enlightened vmcs linked to vmcs01, unless
-	 * need_vmcs12_sync is set, in which case, the authoritative
+	 * need_vmcs12_to_shadow_sync is set, in which case, the authoritative
 	 * vmcs12 state is in the vmcs12 already.
 	 */
 	if (is_guest_mode(vcpu)) {
-		sync_vmcs12(vcpu, vmcs12);
-	} else if (!vmx->nested.need_vmcs12_sync) {
+		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
+	} else if (!vmx->nested.need_vmcs12_to_shadow_sync) {
 		if (vmx->nested.hv_evmcs)
 			copy_enlightened_to_vmcs12(vmx);
 		else if (enable_shadow_vmcs)
@@ -5421,7 +5421,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		 * Sync eVMCS upon entry as we may not have
 		 * HV_X64_MSR_VP_ASSIST_PAGE set up yet.
 		 */
-		vmx->nested.need_vmcs12_sync = true;
+		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	} else {
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 29d205bb4e4f..187d39bf0bf1 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -17,7 +17,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
-void nested_sync_from_vmcs12(struct kvm_vcpu *vcpu);
+void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2b182f58c126..1a87a91e98dc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6399,8 +6399,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
 	}
 
-	if (vmx->nested.need_vmcs12_sync)
-		nested_sync_from_vmcs12(vcpu);
+	if (vmx->nested.need_vmcs12_to_shadow_sync)
+		nested_sync_vmcs12_to_shadow(vcpu);
 
 	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index decd31055da8..f4448292df0f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -113,7 +113,7 @@ struct nested_vmx {
 	 * Indicates if the shadow vmcs or enlightened vmcs must be updated
 	 * with the data held by struct vmcs12.
 	 */
-	bool need_vmcs12_sync;
+	bool need_vmcs12_to_shadow_sync;
 	bool dirty_vmcs12;
 
 	/*
-- 
1.8.3.1


