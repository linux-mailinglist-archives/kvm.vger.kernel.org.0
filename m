Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BAE369E1A
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244427AbhDXAxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244453AbhDXAvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:51:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9189CC061373
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o187-20020a2528c40000b02904e567b4bf7eso26379801ybo.10
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SHBCMVMQ7FRSJddaHHw6x+5pUMPyIiVnrugYIOD42MA=;
        b=K0J9aSp6q96WN80rLA6BoEuEJYxtMQ8pd8iGLxs8Gr6drsu1Dq4gujhBRutXdcf1Nh
         DvR9rhloXJ2QlSEliiOhZIePybPVLVhP+K0eXGOJMuvS9+LhJnzlLHdgtXjQ0qIOnLfo
         HgjRG/0NGbKvb3bkpn2u7Dz9nC7dyYvXXcsuVoDTKx8/GSyzRKQ+O559upr7n48pRK8h
         RqK4K61sgn2Y7My7Ab3m0cUaQBgrJ/apiGYseof8kscSvVnpA19XdUbW3TYS4Ysm1DNQ
         UxKz5BvsVHfvSB/H+Qqdo9Ip7d5GBv2OxTE8vr2mizTH11y8OMR+XwGdDXImPaNO0HlB
         EgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SHBCMVMQ7FRSJddaHHw6x+5pUMPyIiVnrugYIOD42MA=;
        b=Z2VVNs4D/JFWh9wUEjHfAguCcHmMuqh5nImLa1sZHYOmuvUgCbDHLmzctuqfpj5eme
         jsIoVQhaPlB5idIO5RULFD0ww91SK5bUIRPdBEdoGwa6xRgITpB1U7WJk8+2X3UgNSP8
         e+xWxI6FGbrXHRDqTaO45T4ClW1aZztCHUgQBb0K18Eo0hU6UJrC5Cy3SCD0uWrKUfFL
         MzZm7kOhHXW6N9RLrRmnosV66/CO/dnHgSW2cBmvvDa/0ySarfS71Fgo4Vbagw+Wcwue
         eWCD0CLUOvD/Lpasnlmtbih6RYyR8UVaodjbWQVlHTnLgMvT9rYKwl5TZ/gHhEh47Jyt
         LSFg==
X-Gm-Message-State: AOAM533mKMdOgeNRsitRhGjSZOfpFtAAlyqKLiuMoAKhuFOl4BHo4ncG
        iE4mF0dDjPf8Bh3yBmXoAoN3Gth67sE=
X-Google-Smtp-Source: ABdhPJweOFyWksKQg+6Diok/CUE1OzHlc60esHdxSIqqD+wEGQjBoNcll8hIkwPWtWR5aa/thYsEnhuW/34=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a5b:489:: with SMTP id n9mr9165164ybp.45.1619225272854;
 Fri, 23 Apr 2021 17:47:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:26 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-25-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 24/43] KVM: nVMX: Do not clear CR3 load/store exiting bits if
 L1 wants 'em
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keep CR3 load/store exiting enable as needed when running L2 in order to
honor L1's desires.  This fixes a largely theoretical bug where L1 could
intercept CR3 but not CR0.PG and end up not getting the desired CR3 exits
when L2 enables paging.  In other words, the existing !is_paging() check
inadvertantly handles the normal case for L2 where vmx_set_cr0() is
called during VM-Enter, which is guaranteed to run with paging enabled,
and thus will never clear the bits.

Removing the !is_paging() check will also allow future consolidation and
cleanup of the related code.  From a performance perspective, this is
all a nop, as the VMCS controls shadow will optimize away the VMWRITE
when the controls are in the desired state.

Add a comment explaining why CR3 is intercepted, with a big disclaimer
about not querying the old CR3.  Because vmx_set_cr0() is used for flows
that are not directly tied to MOV CR3, e.g. vCPU RESET/INIT and nested
VM-Enter, it's possible that is_paging() is not synchronized with CR3
load/store exiting.  This is actually guaranteed in the current code, as
KVM starts with CR3 interception disabled.  Obviously that can be fixed,
but there's no good reason to play whack-a-mole, and it tends to end
poorly, e.g. descriptor table exiting for UMIP emulation attempted to be
precise in the past and ended up botching the interception toggling.

Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and vmcs12")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 46 +++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9322cd55390..e42ae77e4b82 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3102,10 +3102,14 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 }
 
+#define CR3_EXITING_BITS (CPU_BASED_CR3_LOAD_EXITING | \
+			  CPU_BASED_CR3_STORE_EXITING)
+
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long hw_cr0;
+	u32 tmp;
 
 	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
 	if (is_unrestricted_guest(vcpu))
@@ -3132,18 +3136,42 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 #endif
 
 	if (enable_ept && !is_unrestricted_guest(vcpu)) {
+		/*
+		 * Ensure KVM has an up-to-date snapshot of the guest's CR3.  If
+		 * the below code _enables_ CR3 exiting, vmx_cache_reg() will
+		 * (correctly) stop reading vmcs.GUEST_CR3 because it thinks
+		 * KVM's CR3 is installed.
+		 */
 		if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
 			vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
+
+		/*
+		 * When running with EPT but not unrestricted guest, KVM must
+		 * intercept CR3 accesses when paging is _disabled_.  This is
+		 * necessary because restricted guests can't actually run with
+		 * paging disabled, and so KVM stuffs its own CR3 in order to
+		 * run the guest when identity mapped page tables.
+		 *
+		 * Do _NOT_ check the old CR0.PG, e.g. to optimize away the
+		 * update, it may be stale with respect to CR3 interception,
+		 * e.g. after nested VM-Enter.
+		 *
+		 * Lastly, honor L1's desires, i.e. intercept CR3 loads and/or
+		 * stores to forward them to L1, even if KVM does not need to
+		 * intercept them to preserve its identity mapped page tables.
+		 */
 		if (!(cr0 & X86_CR0_PG)) {
-			/* From paging/starting to nonpaging */
-			exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
-						  CPU_BASED_CR3_STORE_EXITING);
-			vcpu->arch.cr0 = cr0;
-			vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
-		} else if (!is_paging(vcpu)) {
-			/* From nonpaging to paging */
-			exec_controls_clearbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
-						    CPU_BASED_CR3_STORE_EXITING);
+			exec_controls_setbit(vmx, CR3_EXITING_BITS);
+		} else if (!is_guest_mode(vcpu)) {
+			exec_controls_clearbit(vmx, CR3_EXITING_BITS);
+		} else {
+			tmp = exec_controls_get(vmx);
+			tmp &= ~CR3_EXITING_BITS;
+			tmp |= get_vmcs12(vcpu)->cpu_based_vm_exec_control & CR3_EXITING_BITS;
+			exec_controls_set(vmx, tmp);
+		}
+
+		if (!is_paging(vcpu) != !(cr0 & X86_CR0_PG)) {
 			vcpu->arch.cr0 = cr0;
 			vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 		}
-- 
2.31.1.498.g6c1eba8ee3d-goog

