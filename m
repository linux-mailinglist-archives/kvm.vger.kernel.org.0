Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33BF3C74E0
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbhGMQiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbhGMQiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC810C05BD16
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v184-20020a257ac10000b02904f84a5c5297so27714517ybc.16
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DVgV3Z0gTUR2hqJGMpL7GHNs1vys1N7z/dx+tpFDkkY=;
        b=MV+hTug3uDCJg7x2mewre9wftE2qM/EJg+HNfWN3QWW8wkxZA8FqkQlKHiKzWzT6QW
         DusnjIkp+Z0QCAYPSFqUcx4ZthkukkquAkmjRfW0cmKYss2Hefi+oVF997m/wBO9BKFJ
         dg73PY4slMYmpTDILMBRDmNJlDZlGN4r/L3RQ2Np8azj+Yscl/d2WcA22KS3Z1WZ6nQM
         lYYqNBHYIC0MAVfFgb3VtinXu5nkc/ot8UQb1W99LwKwLCNJRosPDihZmGBnNFrL2+lP
         7GxcQy5V4dfT37shpjn48rRBI1lJwFtXVsL73zaEdBCIgj/7x3wzZnxoVFtIXr1r+b1p
         BXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DVgV3Z0gTUR2hqJGMpL7GHNs1vys1N7z/dx+tpFDkkY=;
        b=gH7HfE7ZInVanaD9Jo9vHN8xWnN7Cd3zt3gk4PgnO5GZdKl0z9/Ck3De37QC0mmQf5
         yptZXCoZhy1v7yE5yIuVj4BUoptZFEV653VCC6H7n8v5ToFIX2GqxySTd337CPj4fDbh
         CRxu3uBJtt42io8ZxMlCuj885w8gsgHv5Hl/QQ7aAI/aN50SKYHXj4CE2Htbmn5TouEr
         rF3XfVniFZGoJtyIYyhDsLQ6Y7kTnAXzAjrrpdbJsWI/M1hVonfavl/tFe6rWp8m0QMy
         +V8S6hMJP1RKC51V/9flqVJymGE2hSS3NJn1r64/Ss0GXZuzJxw38Sq95wPbT3iBp/lN
         t+qA==
X-Gm-Message-State: AOAM531OGRDzabOkGwNzmiinrPgG/L4nCJBSGmesMTRDRlNNH3tSf6e2
        nAq+2y39Sj8VaDqyRQ+A4ZIhbh6OZMM=
X-Google-Smtp-Source: ABdhPJzo3ORPeHMNrW4B0mGf0M1Vko//pVeo1rshL1l6wodETc6qDNpBe0/HK36lH5icnSNe6kohGUvu570=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:c503:: with SMTP id v3mr6721332ybe.192.1626194076960;
 Tue, 13 Jul 2021 09:34:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:11 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-34-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 33/46] KVM: VMX: Skip pointless MSR bitmap update when
 setting EFER
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

Split setup_msrs() into vmx_setup_uret_msrs() and an open coded refresh
of the MSR bitmap, and skip the latter when refreshing the user return
MSRs during an EFER load.  Only the x2APIC MSRs are dynamically exposed
and hidden, and those are not affected by a change in EFER.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a1e5706fd27b..d7a4db15a169 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1647,11 +1647,12 @@ static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
 }
 
 /*
- * Set up the vmcs to automatically save and restore system
- * msrs.  Don't touch the 64-bit msrs if the guest is in legacy
- * mode, as fiddling with msrs is very expensive.
+ * Configuring user return MSRs to automatically save, load, and restore MSRs
+ * that need to be shoved into hardware when running the guest.  Note, omitting
+ * an MSR here does _NOT_ mean it's not emulated, only that it will not be
+ * loaded into hardware when running the guest.
  */
-static void setup_msrs(struct vcpu_vmx *vmx)
+static void vmx_setup_uret_msrs(struct vcpu_vmx *vmx)
 {
 #ifdef CONFIG_X86_64
 	bool load_syscall_msrs;
@@ -1681,9 +1682,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	 */
 	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL, boot_cpu_has(X86_FEATURE_RTM));
 
-	if (cpu_has_vmx_msr_bitmap())
-		vmx_update_msr_bitmap(&vmx->vcpu);
-
 	/*
 	 * The set of MSRs to load may have changed, reload MSRs before the
 	 * next VM-Enter.
@@ -2874,7 +2872,7 @@ int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 		msr->data = efer & ~EFER_LME;
 	}
-	setup_msrs(vmx);
+	vmx_setup_uret_msrs(vmx);
 	return 0;
 }
 
@@ -4469,7 +4467,10 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (kvm_mpx_supported())
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
-	setup_msrs(vmx);
+	vmx_setup_uret_msrs(vmx);
+
+	if (cpu_has_vmx_msr_bitmap())
+		vmx_update_msr_bitmap(&vmx->vcpu);
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
-- 
2.32.0.93.g670b81a890-goog

