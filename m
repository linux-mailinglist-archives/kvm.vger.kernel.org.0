Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B97369E29
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhDXAyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbhDXAxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:53:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8146FC0612EE
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e13-20020a25d30d0000b02904ec4109da25so26208339ybf.7
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=sHAT3f/Z7rzeqzw1crWe70jwssZuJ3ZwjfFXfNoL22E=;
        b=uAjiVALHwTJh6zDtWgM6ZZ6gfTE8VT2Z3/yzpWjbaXccVMu2ELKEuSKDYxBnbfqEKG
         aUpmmY3b721f/yOLcO18vtQfjUmjNHwLXEi3F1KAcSbjMd/a/cgUnnt+98/jl2gEoKM0
         01t2k8Vwp/zIQQnTIMgQNz7Re5nZCi/BmdeBxXntF4xPl5WZzxFctkPhuP2VeDYPdV3T
         W6duE03AG3gqc1yODwV1LhoredzgkaaN1mVC5tuWy4zcJ4r+IMVrbdwk9Og2m5YSJQxj
         4JAnvsUl3F/9DqUTnQDZgohvq70D9MVepoignzuybt32IPsjxraTRKxhCVYJNJTE5f5F
         Rncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=sHAT3f/Z7rzeqzw1crWe70jwssZuJ3ZwjfFXfNoL22E=;
        b=cTkY8wYj5XgW6AWr6kzxWyl0+HQABJIFxcllPO4r6/SVhyt4ernya94Wl+opoVvJCy
         qyGyt7/UaYpt+2ku0zobaGLW6Wf2CFeYbC+jiWNaxV7SBfGLcWyg85BcOnQzmzWDUHbW
         RaLdbiGqUJBRS3c3a+/Q+W3/ElEMHY/Gzbz2Mbo47Swec2t730+I1jah6zpiqaIiONoW
         73XwOe5hrLv5qoxu86jIk21pCJ/fgpxS2vceYzJmfDirpBtOwpC7QindPkQ0992TOnBx
         YBwJ+CJ9gRKHuKfjtOfqrRoeER8kwZqwGvPM5ZeRMGxEM7w1UOL9tR95+jIYDfq7d2ta
         SKkA==
X-Gm-Message-State: AOAM530Iu1u2/t7F+hnwHyGfdUx8pS5kE1RFXSHj7Rm81nrwWPkGFAO5
        cv4uMYKIAypcCMHu3vsBv7Ulci89MAI=
X-Google-Smtp-Source: ABdhPJyACzhkbHPYYanTR1KTSWvR/rHvFEzLNkK3c74rBb4WMmGKl2BBA8pZ7L1ssUCvhdjh9QwVPqlZlRM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:bd83:: with SMTP id f3mr9374328ybh.29.1619225288761;
 Fri, 23 Apr 2021 17:48:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:33 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-32-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 31/43] KVM: SVM: Stuff save->dr6 at during VMSA sync, not at RESET/INIT
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

Move code to stuff vmcb->save.dr6 to its architectural init value from
svm_vcpu_reset() into sev_es_sync_vmsa().  Except for protected guests,
a.k.a. SEV-ES guests, vmcb->save.dr6 is set during VM-Enter, i.e. the
extra write is unnecessary.  For SEV-ES, stuffing save->dr6 handles a
theoretical case where the VMSA could be encrypted before the first
KVM_RUN.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 +
 arch/x86/kvm/svm/svm.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a9d8d6aafdb8..b81ebeb4c426 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -573,6 +573,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xcr0 = svm->vcpu.arch.xcr0;
 	save->pkru = svm->vcpu.arch.pkru;
 	save->xss  = svm->vcpu.arch.ia32_xss;
+	save->dr6  = svm->vcpu.arch.dr6;
 
 	/*
 	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 558329f53709..996a6b03e338 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1207,7 +1207,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
 	svm_set_cr4(vcpu, 0);
 	svm_set_efer(vcpu, 0);
-	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

