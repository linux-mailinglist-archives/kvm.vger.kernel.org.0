Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85607787D4E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 03:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbjHYBqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 21:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237857AbjHYBpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 21:45:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD4719A9
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:45:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7496b913e7so488684276.3
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692927935; x=1693532735;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7Gx8G07oVDQESvSj0fHPYOAdbAFRD7QyHdI7Awfk+Q=;
        b=0aSp4kNGD1/BX/bcgBsNHRwqRtg0WUUVF2KI4HnIt1W8kSOqTsMsunXF6sKqc1lePN
         zD5JTXnXRKrT3e4M1KGt35cYVMWj2C37LHxI8mzPFWqG0rCMp+aOIfFNUyWSlFUxc2jb
         nLYXyu+bRDKVnaLQGLdJ9yvqA0cltYcfZFB2nNwtiu0AyhrCo5BLedrqxMSheMuhK1h5
         cqmDRHLK63UeTLJywqr/KOOrEF4rL4pzAiUSkSW2rsLzr3UR4iDqWLd6XU0jQxduqBnm
         PgPSe5P2sdrVKNc6rLDEtt1fA6wmKVvmwCXJXCBNAzTDTPOuWtT1Vo9ELSi9riXORgsu
         GW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692927935; x=1693532735;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n7Gx8G07oVDQESvSj0fHPYOAdbAFRD7QyHdI7Awfk+Q=;
        b=RBe07j1Ww1OjwRlgDFkI2XX4K9bCAMQzOt/zDiNa/gnSLBDWlpqkOldroNj+js44BM
         zCswMpw+QsVZmSB9OoDWLg90qEeN1/6FUZwzdfzRVbCkkKk8EHOiLrXzytp28oj6o1Kr
         AZwe2WWDZ/0ysMG8vlYTQ3OYomq5ax2qZu5aPKOrgAitdoahBgOmm0wg2/40GQdSiTkt
         BGSPhf2Z41/YujaEdru3E6GQluV68UKf+Ae791DSyehFmhRRHg88RqhBRvEFHjl7rrXY
         UkTVBVTfClirul2OXMMfvdL7ljYJFtKhcTgGPccnHCUyGqEY7g9jQ3Omn41wgwfSzCQP
         u1gA==
X-Gm-Message-State: AOJu0YwbZRAgZKd7SsFiiRjnr2DD1ZxnTqYHCARh/5aClhAh/MB49/Tc
        wfodyb/LZnebQ0OSgec2pf36J6ckI0s=
X-Google-Smtp-Source: AGHT+IFCXCroBTtRaWtWSiSvA6Ehy34meR1vhXagG3zkvhYbnr3Cu2pBSL1uq6RbjpkAcAl4kxpPXT21/v0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:290:b0:d48:c04:f256 with SMTP id
 v16-20020a056902029000b00d480c04f256mr326480ybh.11.1692927935742; Thu, 24 Aug
 2023 18:45:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 18:45:32 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825014532.2846714-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Refresh available regs and IDT vectoring info
 before NMI handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reset the mask of available "registers" and refresh the IDT vectoring
info snapshot in vmx_vcpu_enter_exit(), before KVM potentially handles a
an NMI VM-Exit.  One of the "registers" that KVM VMX lazily loads is the
vmcs.VM_EXIT_INTR_INFO field, which is holds the vector+type on "exception
or NMI" VM-Exits, i.e. is needed to identify NMIs.  Clearing the available
registers bitmask after handling NMIs results in KVM querying info from
the last VM-Exit that read vmcs.VM_EXIT_INTR_INFO, and leads to both
missed NMIs and spurious NMIs in the host.

Opportunistically grab vmcs.IDT_VECTORING_INFO_FIELD early in the VM-Exit
path too, e.g. to guard against similar consumption of stale data.  The
field is read on every "normal" VM-Exit, and there's no point in delaying
the inevitable.

Reported-by: Like Xu <like.xu.linux@gmail.com>
Fixes: 11df586d774f ("KVM: VMX: Handle NMI VM-Exits in noinstr region")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Like, this is lightly tested, any testing you can provide would be much
appreciated.  I definitely want to get coverage for this in selftests
and/or KUT, but I'm very short on cycles right now.

 arch/x86/kvm/vmx/vmx.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e6849f780dba..d2b78ab7a9f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7222,13 +7222,20 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 				   flags);
 
 	vcpu->arch.cr2 = native_read_cr2();
+	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
+
+	vmx->idt_vectoring_info = 0;
 
 	vmx_enable_fb_clear(vmx);
 
-	if (unlikely(vmx->fail))
+	if (unlikely(vmx->fail)) {
 		vmx->exit_reason.full = 0xdead;
-	else
-		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+		goto out;
+	}
+
+	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+	if (likely(!vmx->exit_reason.failed_vmentry))
+		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
 	    is_nmi(vmx_get_intr_info(vcpu))) {
@@ -7237,6 +7244,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 		kvm_after_interrupt(vcpu);
 	}
 
+out:
 	guest_state_exit_irqoff();
 }
 
@@ -7358,8 +7366,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	loadsegment(es, __USER_DS);
 #endif
 
-	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
-
 	pt_guest_exit(vmx);
 
 	kvm_load_host_xsave_state(vcpu);
@@ -7376,17 +7382,12 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmx->nested.nested_run_pending = 0;
 	}
 
-	vmx->idt_vectoring_info = 0;
-
 	if (unlikely(vmx->fail))
 		return EXIT_FASTPATH_NONE;
 
 	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
-	if (likely(!vmx->exit_reason.failed_vmentry))
-		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
-
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
 	if (unlikely(vmx->exit_reason.failed_vmentry))

base-commit: fff2e47e6c3b8050ca26656693caa857e3a8b740
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

