Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1581369DFA
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhDXAs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244286AbhDXAsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:48:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E323AC061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p9-20020a2574090000b02904e2cb6a90e7so26400657ybc.17
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8lM2E0jJiBC1VTmkEjEGfcPNw32U+DRkCC8iMe7vR7g=;
        b=fRnpEjwEWFFWgQyiODGaPJYvV9lGJtlFOFWquX9veLOfyDjX4Ju1bx95sXoo3aW+H8
         XUNnnwv+t993ylG6HdqfPFSpp6UekjvlRSb7nu/xuJr9D8y52SYLKUW6UnvPV2jzsEm+
         49SUHn3vdm1B1shrMRA+Ezvn6rnlysIEisI7/e9B6Rx/USc2+h9wO/ni3pN5QVeJ4Lzj
         9JFDU94eJF9lXKUH4+7bOohj73mCMkNSlk7vZSZdwtBbvK7eazc1MAZzBY+XLpXCL89D
         Bi8tgZu/dAjP3bF3plexU0WYT1zvAlFOw8nwDR0Bh83qiAM8jqG0QzuX9t3ergoWlSzu
         nw5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8lM2E0jJiBC1VTmkEjEGfcPNw32U+DRkCC8iMe7vR7g=;
        b=PjM3nTCUiovtVud5Pure1kOSHWAXW75usm7MJFARNMPy/tFyXvbMaDOfF5hFme4kRU
         47jUPpA6uV4KxpzJmugjuhnoLH09LadW3VXCd2Hi4nPIxGa6en3NJx1N3nyK3GMio824
         TdTlm5CChXJB6l4AfrCK/eHka9OWfaDuWDMmZIGzTqrNRFFpIz0UdAsNlYw8L6tsXQ36
         YEh4XMFaOxyi7Bt3HZVHpOAdfplEU6uno+93qfu4lkF+EptplLS6kXeZhPJ0KeFFi5DT
         1TFVgMdGf1ziiFycDCPxswA2EmvEYe58lb8kIRZCV4s/OLr6pfOtgMwYMGr2feA4KHbJ
         bp3A==
X-Gm-Message-State: AOAM530TpEeGi+0XIFnBSJiu5mHLOESUs46Onni446d106gSa3JmNpRs
        htni7Q3lfmXcmntfnf6ht1QDnb1cXnU=
X-Google-Smtp-Source: ABdhPJxyqz775QrFZEuQlFzBtSWNWtfMgqlruqGMlkDNvkgBDonOUZXac7QUX41PiYq4W2N34cpGnA1CFJQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:8884:: with SMTP id d4mr9544198ybl.410.1619225242226;
 Fri, 23 Apr 2021 17:47:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:12 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 10/43] KVM: VMX: Move init_vmcs() invocation to vmx_vcpu_reset()
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

Initialize constant VMCS state in vcpu_vcpu_reset() instead of in
vmx_vcpu_create(), which allows for the removal of the open coded "vCPU
load" sequence since ->vcpu_reset() is invoked while the vCPU is properly
loaded (which is the entire point of vCPU reset...).

Deferring initialization is effectively a nop as it's impossible to
safely access the VMCS between the current call site and its new home, as
both the vCPU and the pCPU are put immediately after init_vmcs(), i.e.
the VMCS isn't guaranteed to be loaded.

Note, task preemption is not a problem as vmx_sched_in() _can't_ touch
the VMCS as ->sched_in() is invoked before the vCPU, and thus VMCS, is
reloaded.  I.e. the preemption path also can't consume VMCS state.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e90952ca6087..856aa44b17d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4396,10 +4396,6 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 
 #define VMX_XSS_EXIT_BITMAP 0
 
-/*
- * Noting that the initialization of Guest-state Area of VMCS is in
- * vmx_vcpu_reset().
- */
 static void init_vmcs(struct vcpu_vmx *vmx)
 {
 	if (nested)
@@ -4498,6 +4494,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	u32 eax, dummy;
 	u64 cr0;
 
+	if (!init_event)
+		init_vmcs(vmx);
+
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
 
@@ -6905,7 +6904,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx;
-	int i, cpu, err;
+	int i, err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
@@ -6991,12 +6990,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx->msr_bitmap_mode = 0;
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
-	cpu = get_cpu();
-	vmx_vcpu_load(vcpu, cpu);
-	vcpu->cpu = cpu;
-	init_vmcs(vmx);
-	vmx_vcpu_put(vcpu);
-	put_cpu();
+
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
 		err = alloc_apic_access_page(vcpu->kvm);
 		if (err)
-- 
2.31.1.498.g6c1eba8ee3d-goog

