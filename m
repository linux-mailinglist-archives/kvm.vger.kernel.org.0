Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3348369E28
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhDXAy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244338AbhDXAxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:53:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310F7C0612EA
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l6-20020a5b05860000b02904e88b568042so26335196ybp.6
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dsiMBchNTtndnmQlk4F63qszrVBMRXg4RloYviM4gF4=;
        b=DLHJVAghmlCF6JmDRY3qJZSPKKBmK7vBFJ9tA2azFp9TZbNze8G6Dk+Et/qgGC5OPh
         DJUS44SdtB817l7bOzG0U6SKVW7HuaG1CrykmapcI0bmvwsKnIeu92on9mT+vHZ+OpZ5
         HLmFQGihRTiuKUveO2bSSkIUxvfVkbym6Mecyb3VZjRcQlK49lX+8QdpkmDb5HIp4Sda
         qSij8iYdhJ5QpSU61zus5WOKpUrPJ1vv5dwmnUb4jqDi0Bna+gIAbnh12ac3jz0RdyD9
         8AbAAZld7/AdGjOhjV9dJk2IaV72uTLa1jgdy0ZcQAbEssuNLl29zZVFG0uDjRsbGC1j
         hAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dsiMBchNTtndnmQlk4F63qszrVBMRXg4RloYviM4gF4=;
        b=rrVFZ9zs+HF9DkHYb0tswrtCWfEADdTeCrjQMUzKnO/W9QkMDsMvE73B9NHriU2Sf6
         +66N2I0mrPec3fm9B3PAUavZHpHNgy/M6PRti4pvTvi/6RkHmOBQE227uO7a4mV8RI+J
         WALnOcl0xc0RAPf2lF8GVSK8n7/dKPaJuKhm3V24afmR/5kIqq0/PpSCqlcs0uE2N1o0
         8MCqIkrWHQ+XY49YVDPD8npFSxxas1c1790XYPB00/D9EfR/txN0LaMnDKsjULaEP0Re
         /hdblnfdZ+T4sa6gSVUpuvR1lbcZmbF1s1m6xNV6wU+Mcgl6ZXNx0mWoUK+hZ0LrUvrF
         iMEQ==
X-Gm-Message-State: AOAM533QHSumf5YpVkWbMt6ncIAI39vjw2x4ZhGFAinbM7js+EnLzCAs
        0Oi+Qm4593yiPYD6Ej2iGSRRZyuIO3Y=
X-Google-Smtp-Source: ABdhPJzHd1onR0oqXPgHGSf07Ej3AmYGAmthNY/gfjWbuNGb2R8GtbRaqSXyt8YUb+K2T5W3zOT9ewLF2cE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:1905:: with SMTP id 5mr9570731ybz.302.1619225286449;
 Fri, 23 Apr 2021 17:48:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:32 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-31-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 30/43] KVM: SVM: Drop redundant writes to vmcb->save.cr4 at RESET/INIT
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

Drop direct writes to vmcb->save.cr4 during vCPU RESET/INIT, as the
values being written are fully redundant with respect to
svm_set_cr4(vcpu, 0) a few lines earlier.  Note, svm_set_cr4() also
correctly forces X86_CR4_PAE when NPT is disabled.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 88d34fa93d8b..558329f53709 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1211,8 +1211,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;
 
-	save->cr4 = X86_CR4_PAE;
-
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
@@ -1222,7 +1220,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = vcpu->arch.pat;
 		save->cr3 = 0;
-		save->cr4 = 0;
 	}
 	svm->current_vmcb->asid_generation = 0;
 	svm->asid = 0;
-- 
2.31.1.498.g6c1eba8ee3d-goog

