Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CC63C74CE
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbhGMQhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhGMQhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ACBC0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g3-20020a256b030000b0290551bbd99700so27770161ybc.6
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xdAkcygaPEcpp4CNM8O/R9k6BDNdm0ATuqQsXeEt38E=;
        b=BxOhaKklb4xqr+QX8WDrqI3aFBnGaDnXY21Deh5ubB3ZAKGYD37cbdfvfm36hH93kR
         lQDSbXnaqpxUuUwXhZXMbzXgDOEOhHdcAAFtwn8I3qw9bNAYyvbz69+Ba7NW+v2ja7tl
         7EHvZBIwvviPZWxRdpdUwWh6VjSlBL0yudtDitGZJOkVNBOzwzMNThiydO54XUsAV88I
         jTqwamhMr90yjJkWgYh9q8RuUGrONnxkLjB1Mw6wYc6WjRrDx2IwWAcWwOgkdCKk42Yd
         OVLrzGRm3pp7LPzExfemC9WHeslyX9ujzoKgNdAWJogTE2juRQ+Zb1sjhFkdh+vfvB2E
         YUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xdAkcygaPEcpp4CNM8O/R9k6BDNdm0ATuqQsXeEt38E=;
        b=URoPbJbsgm7buYEilmy5FIG7xcSbv0n9f6j9w6/CD17+1H7piJUAIkiHH8zmDgL1SJ
         0vsSrqnZmhLLE7/n6cRBWOIRUNY2Ga3tJkN594KRhd9fm5HYnviXnbC8KqG8w0KBYpTd
         KZoQVmpPtdOHneCWBx+CXwKorwtHxnf0yjQ1sGWdpxTvlT8ipylZNYT3D+KE6BFbH7WX
         VEyZ3IA5Vr6WYI7iGnb8lNsmw2jRGz9pgg2DnaT6YKMVHkdPHxsHE9aZ6gQH+sTbGS1x
         1ZIWR1KuLJUfcEw+v0z4/pn9iEbwCAGg082idWeZ6ULPSOE/vOt0sM+68R7mQq8JkBW/
         y/vQ==
X-Gm-Message-State: AOAM5306nPIXV6unOfKHwOQzfkvqoqV8Otxs8TOdF+aPZ1tVga5Ll7nd
        6KWNm8BsaDgq0BYw9YMdF5cJnammrAA=
X-Google-Smtp-Source: ABdhPJyWC6nAKsLCUaj4djllb/OFERwatUMnjg5LpWOKBrpAkn05V353L2nG5W05C3HlAoSn9h9MIXjbBEU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:d310:: with SMTP id e16mr7596128ybf.63.1626194059316;
 Tue, 13 Jul 2021 09:34:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:02 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-25-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 24/46] KVM: nVMX: Do not clear CR3 load/store exiting bits
 if L1 wants 'em
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
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
index db70fe463aa1..58c6d7b98624 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2994,10 +2994,14 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
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
@@ -3024,18 +3028,42 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
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
2.32.0.93.g670b81a890-goog

