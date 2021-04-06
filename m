Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806C1355A22
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 19:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346852AbhDFRSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 13:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346831AbhDFRS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 13:18:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782C9C061760
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 10:18:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y13so20911641ybk.20
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 10:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yLZTnU9cqw3ugS9i8+TrsosQylEqmKTBM3OlilpSf6c=;
        b=YpSwZEHHLLTtgR0FpOxpJHDZCHkZZJk6RhRcM4ILFt4NJbSeU/D7axZjywHZdKU/1j
         eKTNEJDXBtAjZxvHTLlyR17DOkGLsy0YjP7+zLpv8p477LH2H/2uJu+uT37YMdeT3dAV
         jO2gFCWeKBJE3d4org+LzU1BOrU/xVzXoUyf3ltVmj97YLxz79rTM3KhCWR2bU0IamQ2
         38eLP3q4NxfN+bc1zS7FLdcVHGa7ttAAj1gPwWMpwTfTpYXrfKjOK4yBzYMKi7/53p/G
         QVZvo0XWXm37r9UPSVOw97zkOfN6KFnlWv8QHLIxMoS24LtxwTElOLaDxdMqODYoyfZ6
         r8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yLZTnU9cqw3ugS9i8+TrsosQylEqmKTBM3OlilpSf6c=;
        b=chqrN3iO+fmx73AjQydlfBDBdvSejVfJYsFgY39icuSuDcxPJEuhwvQc+vz+GblbUZ
         B0kZIqhcNC2c36+pwtUmDRr8Uq2kNrzGos8VgzsigGCJaE3cRml77VapN9ofHsOboIRT
         WJ6//y0vmdbtip8MIMFErTfbFrAiXez++2RcwV6tX+sxgPuHH6+tOIPcEsli6Ty+QocO
         a+FfG4n8m6zxux0QLaqgfBodzBxhc6EmhAAmKaTfeDoTWnmAxk5J92FJEhx+r4OEm9IQ
         4GQ4WD+gVSLCWsJH+49KXFgy0Ug3tasT4G1U95OUfVWH7mizlkPhJ+6TJ/hgirw9cnSx
         k/4w==
X-Gm-Message-State: AOAM532CNrINqUQlyH0zf3Ku/qpk4gW4IO/jnE+O1vLUs3FbtgG1PLCv
        p6YUPF+XsUI8os2n/GX4A3tlcCPpJSA=
X-Google-Smtp-Source: ABdhPJwwcyHR7qEPnOuE7Zl/tt5TJGgkBdhlyoSHJHFOCKlxMpzYCqrxpb677LKQjmza7uUavefRH57VMeY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:e782:: with SMTP id e124mr45913646ybh.262.1617729498766;
 Tue, 06 Apr 2021 10:18:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 10:18:09 -0700
In-Reply-To: <20210406171811.4043363-1-seanjc@google.com>
Message-Id: <20210406171811.4043363-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210406171811.4043363-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 2/4] KVM: SVM: Drop vcpu_svm.vmcb_pa
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove vmcb_pa from vcpu_svm and simply read current_vmcb->pa directly in
the one path where it is consumed.  Unlike svm->vmcb, use of the current
vmcb's address is very limited, as evidenced by the fact that its use
can be trimmed to a single dereference.

Opportunistically add a comment about using vmcb01 for VMLOAD/VMSAVE, at
first glance using vmcb01 instead of vmcb_pa looks wrong.

No functional change intended.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 +++++++++---
 arch/x86/kvm/svm/svm.h |  1 -
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 89619cc52cf4..f62c56adf7c9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1310,7 +1310,6 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 {
 	svm->current_vmcb = target_vmcb;
 	svm->vmcb = target_vmcb->ptr;
-	svm->vmcb_pa = target_vmcb->pa;
 }
 
 static int svm_create_vcpu(struct kvm_vcpu *vcpu)
@@ -3704,6 +3703,7 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long vmcb_pa = svm->current_vmcb->pa;
 
 	/*
 	 * VMENTER enables interrupts (host state), but the kernel state is
@@ -3726,12 +3726,18 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	lockdep_hardirqs_on(CALLER_ADDR0);
 
 	if (sev_es_guest(vcpu->kvm)) {
-		__svm_sev_es_vcpu_run(svm->vmcb_pa);
+		__svm_sev_es_vcpu_run(vmcb_pa);
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
+		/*
+		 * Use a single vmcb (vmcb01 because it's always valid) for
+		 * context switching guest state via VMLOAD/VMSAVE, that way
+		 * the state doesn't need to be copied between vmcb01 and
+		 * vmcb02 when switching vmcbs for nested virtualization.
+		 */
 		vmload(svm->vmcb01.pa);
-		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&vcpu->arch.regs);
+		__svm_vcpu_run(vmcb_pa, (unsigned long *)&vcpu->arch.regs);
 		vmsave(svm->vmcb01.pa);
 
 		vmload(__sme_page_pa(sd->save_area));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 02f8ece8c741..2173fe985104 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -112,7 +112,6 @@ struct svm_nested_state {
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
-	unsigned long vmcb_pa;
 	struct kvm_vmcb_info vmcb01;
 	struct kvm_vmcb_info *current_vmcb;
 	struct svm_cpu_data *svm_data;
-- 
2.31.0.208.g409f899ff0-goog

