Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A8A369E2B
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244303AbhDXAyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244406AbhDXAxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:53:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBDBC0612F0
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u7-20020a259b470000b02904dca50820c2so26388954ybo.11
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BdoSnjJxYw1zfGUU/Z7GRrV8PpQo7mVoIG98cidoNPE=;
        b=ZXyR7PW511+wiI+r2z9sDLy0bn0R5t8+YYcLnYmh7WaFjgQWhFS6rovcK5dI6JHnlf
         KI+2ZzBslvkOwq2PEeWwR9ep+zwT7rrBaLcQkBX/RbCQxCxGjt7ypzGich2z8BnjhR4s
         qISIoA1jRnc5m3+Wk56tidUt6Zvx4lRgcTUDITmRZtq2YTrj+l4As3q4u4RtfEQ7SoT7
         8/Xyso6YE9kY7cN+qAtFpwWyWusn8447Xu0ZG8v99Xn2XUxUBz9nVtdjEURfL7YbeTsa
         9byiJ2akf/jQbdqZvhAgyf2enceQnK8WKNOs+E69qt6hTgsUJ4scu6PlzJXpcKyTmULh
         fCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BdoSnjJxYw1zfGUU/Z7GRrV8PpQo7mVoIG98cidoNPE=;
        b=pW8X3Dbm00fTl1vjGXpS9BB4m4NbrCaIGlwBL4J5EmrmL9OPdSe2dqRNkhOvBKNQn7
         Z3wKg3xaI2Mpz8gzJpzrrse2+eYKyGyUC1MTPE6+8HWdkwHP+t2JU3lO4KsQgC/w5zMR
         dqA30F8VfshJE0OxukI94VfCDMQuVPNroJnV7Rxc+BamvLrUcbsEEswjoKMeIKuMWcp4
         jUR9TeNj2OxD4RSx7QUOAzclUOtk8ReSsbdrPT1AporsJcIo2+M6UmbhecGEM4OWreNF
         Fcy86yEhRz+7nDUMmEyF52JYqSjy/8LMGjjW26+9D7P+HgKIzRGiTY2NQZDXiFUiJnKq
         M0GA==
X-Gm-Message-State: AOAM533jmbxT99KhwniD4tn+/JzpPCb/0WIT7IFCAlnf5u//ch3B/c10
        VyZ1IrLwTyYuoe3CDqa0/zrmNL5CZUs=
X-Google-Smtp-Source: ABdhPJwzgFMPHtpsTuP1bO+XVQ19S4WjrI+kU3mdBgFcxF60m+DI+8eH/lVH69xsBoUWa1oj0/dKVi9rINA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:9a01:: with SMTP id x1mr9232033ybn.269.1619225291193;
 Fri, 23 Apr 2021 17:48:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:34 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-33-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 32/43] KVM: VMX: Skip pointless MSR bitmap update when setting EFER
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

Split setup_msrs() into vmx_setup_uret_msrs() and an open coded refresh
of the MSR bitmap, and skip the latter when refreshing the user return
MSRs during an EFER load.  Only the x2APIC MSRs are dynamically exposed
and hidden, and those are not affected by a change in EFER.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 594975dc3f94..bdfb3def8526 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1767,11 +1767,12 @@ static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
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
 	vmx->guest_uret_msrs_loaded = false;
 	vmx->nr_active_uret_msrs = 0;
@@ -1793,9 +1794,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
 
 	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL);
-
-	if (cpu_has_vmx_msr_bitmap())
-		vmx_update_msr_bitmap(&vmx->vcpu);
 }
 
 static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
@@ -2982,7 +2980,7 @@ int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 		msr->data = efer & ~EFER_LME;
 	}
-	setup_msrs(vmx);
+	vmx_setup_uret_msrs(vmx);
 	return 0;
 }
 
@@ -4572,7 +4570,10 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (kvm_mpx_supported())
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
-	setup_msrs(vmx);
+	vmx_setup_uret_msrs(vmx);
+
+	if (cpu_has_vmx_msr_bitmap())
+		vmx_update_msr_bitmap(&vmx->vcpu);
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

