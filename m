Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03DF369DF0
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244237AbhDXAsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244186AbhDXArx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:47:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC1EC06175F
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n11-20020a25808b0000b02904d9818b80e8so26105645ybk.14
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=S9LmVyYL6pKRzjL0U4nbFcV7jk04TtApkl0zLSJh5eY=;
        b=Vpz6x3d/WMuGdzpraohbyCQTi1uVwYhunPo+2aSj5UWanqRDVQrIPgbKUnMiD2hOCz
         bY733/hXMBRJuCid8pzgaqoC4inNWlfoJO08iKaGNWY9/BNNJrrymcs1T9vCmcl+TGun
         BJPhe4tSMQEtq4+TabGCNItyljf1U49IIu76UxhNEtk8ppSIARKIORJNxdNbQVFERfZE
         PTnKL2g2A1FO7GYiI33n/k6yA86qLPZL3a5Kg6In+QtEcRDcZA2Vw/I9p9FQs8/JmGEf
         8puBdq5ol2dh+WFW8mZT6gPrFZqgQrMG6J5A+PMxPtg28ur0uH+6yvm3Q+iZA16pwS0z
         5cuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=S9LmVyYL6pKRzjL0U4nbFcV7jk04TtApkl0zLSJh5eY=;
        b=JdhCHY7r82xlwHBabYKGkug9/55tCuR7c5bLF+sOmBQnY0WyZHxHY1YqYyu1m1gtEj
         KwBxzYzztrLJXQT9RSuNQtRa7f9GjSE1ohRLq7Cqew6Xk2YisLO+FEcC6CzgQLaBY0zs
         +QPg1fN7TElR34fcr1v1miFJdBndi+UgYaWIXA5O4+4RMEmEV1Tm3eM9Z4NWyUapC4FG
         BHIaJgszNRaGQkr1QkTdnTLqaTV7T/Xw+kxuag6FDme5nrJuRXrPnYntJdr0XT9nqlK3
         5sZ4LbnshIqkn+vpBlcvSciZGaDTYfsADJSO2nwZ07i2x2vEYJiliBP86XLpgkLZtYeN
         DOsA==
X-Gm-Message-State: AOAM533Ll//YHJrubE1/hRR8HRnM7pkDCYbSnkPzJxfGVkz+WeUkfMPF
        +oKjuTOwAay8kEgZcDw4hCi/mdUZ+M0=
X-Google-Smtp-Source: ABdhPJzNjugdSqn82XdJBxea+OssmMAoG3fwvDRlR+EOI2k0bGA2Fsupd6nBHuUkreyhPVBG/DoW7J0IQ3k=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:fc0a:: with SMTP id v10mr9565094ybd.71.1619225233273;
 Fri, 23 Apr 2021 17:47:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:08 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 06/43] KVM: x86: Properly reset MMU context at vCPU RESET/INIT
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

Post-process the CR0 and CR4 changes at vCPU INIT (and RESET for good
measure) to effect a MMU context reset when necessary.  Simply
re-initializing the current MMU is not sufficient as the current root
HPA may not be usable in the new context.  E.g. if TDP is disabled and
INIT arrives while the vCPU is in long mode, KVM will fail to switch to
the 32-bit pae_root and bomb on the next VM-Enter due to running with a
64-bit CR3 in 32-bit mode.

This bug was papered over in both VMX and SVM.

In VMX, the INIT issue is specific to running without unrestricted guest
since unrestricted guest is available if and only if EPT is enabled.
Commit 8668a3c468ed ("KVM: VMX: Reset mmu context when entering real
mode") resolved the issue by forcing a reset when entering emulated real
mode.

In SVM, commit ebae871a509d ("kvm: svm: reset mmu on VCPU reset") forced
a MMU reset on every INIT to workaround the flaw in common x86.  Note, at
the time the bug was fixed, the SVM problem was exacerbated by a complete
lack of a CR4 update.

The VMX and SVM fixes are not technically wrong, but lack of precision
makes it difficult to reason about why a context reset is needed.  The VMX
code in particular is nasty. The vendor resets will be reverted in future
patches, primarily to aid bisection in case there are non-INIT flows that
rely on the existing VMX logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0bc783fc6c9b..b87193190a73 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10341,7 +10341,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
 	kvm_vcpu_reset(vcpu, false);
-	kvm_init_mmu(vcpu, false);
 	vcpu_put(vcpu);
 	return 0;
 
@@ -10415,6 +10414,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
+	unsigned long old_cr0 = kvm_read_cr0(vcpu);
+	unsigned long old_cr4 = kvm_read_cr4(vcpu);
+
 	kvm_lapic_reset(vcpu, init_event);
 
 	vcpu->arch.hflags = 0;
@@ -10483,6 +10485,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.ia32_xss = 0;
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
+
+	if (kvm_cr0_mmu_role_changed(old_cr0, kvm_read_cr0(vcpu)) ||
+	    kvm_cr4_mmu_role_changed(old_cr4, kvm_read_cr4(vcpu)))
+		kvm_mmu_reset_context(vcpu);
 }
 
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
-- 
2.31.1.498.g6c1eba8ee3d-goog

