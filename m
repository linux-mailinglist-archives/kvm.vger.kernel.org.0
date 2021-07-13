Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2114B3C74DC
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhGMQiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbhGMQiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:04 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D34C05BD0B
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:35 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id gf3-20020a0562142503b02902b1b968a608so17722659qvb.16
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+E9aSBRBRnkdWbZXjoXlsgbyRNBB/RIBNAs/dlJauCk=;
        b=NSZq/SEFDbfPCXS71NJBAFGp8Ig+zn4LbogUdovO0aC2VBPEqD/YgmNxIzbsQxJRU9
         JqVDzETYLL2xbaTjHMcVEUKGtUE21NrFz9r4FqlCODoda+38sDeHSySrDElfOYHpAL+U
         0lcH2CitPsirGgl1hYsFeLMnxRcAugs3O28lyTLI0J1mXzg+fk2w0cGcmkId9rDJ7XjO
         uWRWQSmIljDT9iQVrv5Y4sNGok5ZlU9w+JdFyEJj1v/zlx/AEt5DzSzMUjyo9M5WiayP
         NL6pgXe8BIbT8bf2mkEQTqNrlugEBobTil/y6lCsuythfDFpU8QOhm4FqrWPsQyaK19S
         YHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+E9aSBRBRnkdWbZXjoXlsgbyRNBB/RIBNAs/dlJauCk=;
        b=g22HhecNWVuvLNWr9FDeh+GwSC3zQpYyFUP0UrRUWEQHOj6ei5/t5Ia37rZIqqu9UN
         rsSncQ6V7iE5D+CQWRcx3M590KSOM3kUMyLedTgG+E9rgJG8NRRQmDQCCcyYwoYQArp1
         N0eOq+sMCxIMe2/dIBpIKIF2cvveOlbelENVbSdxANT2UqLGAa4zYdglItbYBMQpK2Kd
         YQupK4ni4OMbYVnDwQ4b3PVSTbglUVE+L+i4HVC7WrBRL6b7pMD9DsZl9vmshum1dlkB
         3XfM+hD57QfFl8KxelIg7/9fCFijuo9hN67vWS+7P5f4smqXMTIUzqXa+/GJqA4U2lhg
         abyg==
X-Gm-Message-State: AOAM531UgAotOalNr9dAQCpN4MTFWco+raPggaoowJXbaQg/BHmIVg13
        CLpr3wlUvyd5EogOjBlB8wSa/ksaIDs=
X-Google-Smtp-Source: ABdhPJwHQZR9ZfdF+ROsFu+h74c/v2u8IVsDn5+mNncgUeyZxKK2nE85oqgLKZnLs5svw3k7Ct0j7yrpyNY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:ad4:568a:: with SMTP id bc10mr5808858qvb.20.1626194074843;
 Tue, 13 Jul 2021 09:34:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:10 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-33-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 32/46] KVM: SVM: Stuff save->dr6 at during VMSA sync, not
 at RESET/INIT
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
index 8d36f0c73071..e34ee60fc9d7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -583,6 +583,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xcr0 = svm->vcpu.arch.xcr0;
 	save->pkru = svm->vcpu.arch.pkru;
 	save->xss  = svm->vcpu.arch.ia32_xss;
+	save->dr6  = svm->vcpu.arch.dr6;
 
 	/*
 	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6eff7f1a4672..251b230b2fef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1265,7 +1265,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
 	svm_set_cr4(vcpu, 0);
 	svm_set_efer(vcpu, 0);
-	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;
 
-- 
2.32.0.93.g670b81a890-goog

