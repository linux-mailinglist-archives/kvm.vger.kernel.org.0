Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B973B0B59
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFVRZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 13:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhFVRZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 13:25:04 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6B0C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:22:48 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id r15-20020a0562140c4fb0290262f40bf4bcso18241294qvj.11
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=ENrInjqfBgGswxYmQAYCwFI8IQ/aaKE4ZAV8dzRip1g=;
        b=np4ZqLtwF7u+QAnrxEOF1NWIc3J6Kh/WhZPFkgj8BCi4BuzZL4t+3CfIPKXvDUX5iz
         2iBSc04cBpmxSwdW3irsx41325u7MkZQ5+dlJRFr2hrhxRYn0ipaW+eF5xhU+ZWTdqck
         33sfKgl3dIDw4lGaHKf6BdPU4dB+iGy8ZHQTb0wbE4irZpfxuEIr2oeosrI0yzEoGUwy
         MepDvBSM+dA2UC04sFzwwq7Tnr6FxTmTQdDKdcvaDkJZLGQnBGLrAYPiEpnOx+JXlGTP
         HHmwxzDrvmBDvWjiBVsbSe8tofAiJVhtqsK8vvSVX3JSDi22uMTg/U/cXDsdqeBwJdkO
         7t2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=ENrInjqfBgGswxYmQAYCwFI8IQ/aaKE4ZAV8dzRip1g=;
        b=gVtrvCAzReRu/uQPcHNfyjNcuEaYNrjhdYhi0bbeOAOFVCtSWAQJKBAkuawnKErXQy
         SBNXlmu2PvL2Fc9tCJp+/KdF/G+6gVg34KYimS5mcKSoUnXraRuaDdLmZgNVj6zGu2Xn
         FlLpzLgiVj+fJs3Xqe0344VdL9X/lO++cpfcDEoqTt6tyDCdHGKrO+l0diWeEF3/PP4i
         4qDHfo6una4tcOlLoNrgaIsKwKMmIt+JmVbwUHhtUTn/XLtRXqEhcWe/iSwCHTNTTBEv
         lfW9WoHoALLRP/z8wMvdwKDoXya4skmnqxexIq0mMuC2FhJI4iR3WvKf7AVgMp+T+fRB
         XR1Q==
X-Gm-Message-State: AOAM531/+uBt2lyq+2VJRbcMsstdfres2ocGvAFfscyDXUtWL5EKBT7J
        S217rAGEe4c8nGLxDOKn92dUrV3qp3s=
X-Google-Smtp-Source: ABdhPJzh2TG/Fvp81ZJNv0tzkTiSRn791SPJNeuwFH7m5wQ9IOyCdICuM/1VKbvQ52dORRbywXXo2xX6IVc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a0c:a362:: with SMTP id u89mr9499408qvu.50.1624382567896;
 Tue, 22 Jun 2021 10:22:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:22:44 -0700
Message-Id: <20210622172244.3561540-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH] KVM: nVMX: Handle split-lock #AC exceptions that happen in L2
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mark #ACs that won't be reinjected to the guest as wanted by L0 so that
KVM handles split-lock #AC from L2 instead of forwarding the exception to
L1.  Split-lock #AC isn't yet virtualized, i.e. L1 will treat it like a
regular #AC and do the wrong thing, e.g. reinject it into L2.

Fixes: e6f8b6c12f03 ("KVM: VMX: Extend VMXs #AC interceptor to handle split lock #AC in guest")
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 arch/x86/kvm/vmx/vmcs.h   | 5 +++++
 arch/x86/kvm/vmx/vmx.c    | 4 ++--
 arch/x86/kvm/vmx/vmx.h    | 1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 183fd9d62fc5..fa3f50f0a3fa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5833,6 +5833,9 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 		else if (is_breakpoint(intr_info) &&
 			 vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
 			return true;
+		else if (is_alignment_check(intr_info) &&
+			 !vmx_guest_inject_ac(vcpu))
+			return true;
 		return false;
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
 		return true;
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index de3b04d4b587..4b9957e2bf5b 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -117,6 +117,11 @@ static inline bool is_gp_fault(u32 intr_info)
 	return is_exception_n(intr_info, GP_VECTOR);
 }
 
+static inline bool is_alignment_check(u32 intr_info)
+{
+	return is_exception_n(intr_info, AC_VECTOR);
+}
+
 static inline bool is_machine_check(u32 intr_info)
 {
 	return is_exception_n(intr_info, MC_VECTOR);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ab6f682645d7..46d9ce39249d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4743,7 +4743,7 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
  *  - Guest has #AC detection enabled in CR0
  *  - Guest EFLAGS has AC bit set
  */
-static inline bool guest_inject_ac(struct kvm_vcpu *vcpu)
+bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu)
 {
 	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
 		return true;
@@ -4851,7 +4851,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.exception = ex_no;
 		break;
 	case AC_VECTOR:
-		if (guest_inject_ac(vcpu)) {
+		if (vmx_guest_inject_ac(vcpu)) {
 			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
 			return 1;
 		}
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 5740f8e2aa23..3979a947933a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -376,6 +376,7 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 
+bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
-- 
2.32.0.288.g62a8d224e6-goog

