Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2FE49F015
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345244AbiA1AyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344954AbiA1Axx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:53 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE73C061751
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:41 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso2373813pgv.14
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1vh1VvZNhhnSubMCarnsOOQ5sYO+DptkQEoJu+SV9JY=;
        b=Kr+fuAc5ZPitCBM3g3XiW8CsMou2XI88siFZXSY12stQOkRkSiv37ClwtffG0QeePP
         +WpTTNt4HAzZ6sFLTbyEln7C+a6mMQKabtVoarqk48EDEWwWikx8Xu62FmczNgyYQTj4
         VZGQJHnWadtfHRj+elbAze5Npy0Mb4a2gVH4RVtk4VPYyL6q3eDRlKVasu6DImWGxBwa
         bHIRl+Knx3XkHvey+nWhLbAjCrcOu3iTm/Ludl8fmxU5VrjqCjnzTPfgFdk+4xZS1vsu
         876zdw4Xw1ooQKps6dgf5iU+8Nhr0zAcPFyBnWmU8+rxdg4SnFlrTkiwOfz/JVahoKbY
         EYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1vh1VvZNhhnSubMCarnsOOQ5sYO+DptkQEoJu+SV9JY=;
        b=KNYGJ5uiGVHnHJS22wOTEVgqCGH5OKbrUyiVsDigqio8KZKEIY6kDIUQN9lE3E1+oP
         Uh94l4grZ0GzjqHrlrzn0cJAgnLVl4OH8HAHXOKTtChfH50ajXfEkl6TOqneMLYc9zgL
         gmM2oyfjIy1YSyANi/5gA9MQRnCvWWA9nA2xe9TxVtBVgaPWvJt9Z0BbYBr3diSxlujO
         8mfYv9xgESYnA3d/CwcrrHyGLdV+3TbCyHSnoTlis9GS4694ouCRa82lw7FkgvMJ7lxF
         kXPiHhY6bXRW+Jag7YTiptSmaP83oTA8agOK6wshK/gaWQ7fwdNLr8D0jEhQv1Ifv5bJ
         e31Q==
X-Gm-Message-State: AOAM533VrYDJivldqHb1+LeXsX2Cmf1dl95LWgTlH3DNHYSKkclQEI4q
        tzy6iu04+30OuWoboVMP0PKqXsczKhc=
X-Google-Smtp-Source: ABdhPJwTMAcCNpEASRZ8M0zDEAr02qtTm+qXF8X/FzAwXCV1T4TqMnuylsdUjEg3UkvfWRQpF1ZoxxFTso4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d48e:: with SMTP id
 c14mr5713568plg.79.1643331220698; Thu, 27 Jan 2022 16:53:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:02 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 16/22] KVM: SVM: Rename svm_flush_tlb() to svm_flush_tlb_current()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename svm_flush_tlb() to svm_flush_tlb_current() so that at least one of
the flushing operations in svm_x86_ops can be filled via kvm-x86-ops.h,
and to document the scope of the flush (specifically that it doesn't
flush "all").

Opportunistically make svm_tlb_flush_current(), was svm_flush_tlb(),
static.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 +++++++-----
 arch/x86/kvm/svm/svm.h |  1 -
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fda09a6ea3ba..5382710ba106 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -265,6 +265,8 @@ u32 svm_msrpm_offset(u32 msr)
 
 #define MAX_INST_SIZE 15
 
+static void svm_flush_tlb_current(struct kvm_vcpu *vcpu);
+
 static int get_npt_level(void)
 {
 #ifdef CONFIG_X86_64
@@ -1654,7 +1656,7 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long old_cr4 = vcpu->arch.cr4;
 
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
-		svm_flush_tlb(vcpu);
+		svm_flush_tlb_current(vcpu);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
@@ -3489,7 +3491,7 @@ static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 	return 0;
 }
 
-void svm_flush_tlb(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -4512,10 +4514,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_rflags = svm_set_rflags,
 	.get_if_flag = svm_get_if_flag,
 
-	.flush_tlb_all = svm_flush_tlb,
-	.flush_tlb_current = svm_flush_tlb,
+	.flush_tlb_all = svm_flush_tlb_current,
+	.flush_tlb_current = svm_flush_tlb_current,
 	.flush_tlb_gva = svm_flush_tlb_gva,
-	.flush_tlb_guest = svm_flush_tlb,
+	.flush_tlb_guest = svm_flush_tlb_current,
 
 	.vcpu_pre_run = svm_vcpu_pre_run,
 	.vcpu_run = svm_vcpu_run,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index baa5435f1bde..16ad5fa128f4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -480,7 +480,6 @@ void svm_vcpu_free_msrpm(u32 *msrpm);
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
-void svm_flush_tlb(struct kvm_vcpu *vcpu);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
-- 
2.35.0.rc0.227.g00780c9af4-goog

