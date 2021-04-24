Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09535369E13
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbhDXAvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244174AbhDXAt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:49:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36403C06136B
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:49 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so14640521ybn.21
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ew2nV1C2QkTbVPUHEDeR3BqzkrHRV1hyqurcl8ylJqA=;
        b=Q/+euOX/jNPV0L+/HCLRbjP+tdZVMolhBrphGswflROesQAMX/mKt4/qDAZgSlzR6u
         XLqaFXtMPQG13Og4KpzQOqGfOt4eFgHbmxpoyFNhUt1FY419Q1HyUP1I6pkgZbwVGkx8
         F7+vNX8lVz0LNFeRUDsTorj5bgM9Oh0wfBbZarrYnvSr+aMFoqAy+Fv5ekwizD8Ga6mI
         0b1DxdCPi8isOCr2JUs7CGKsJlH/w2EiC9x2rwK2cZDuQROlHMP1IsNled/w5n02FID/
         SZXlLqT8xZEhSs8OgQ+OMLMqJYW9AFT2RanZRsWG4zg87Vz803KVZACsX+kabnuJFFiX
         eoNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ew2nV1C2QkTbVPUHEDeR3BqzkrHRV1hyqurcl8ylJqA=;
        b=cA4+Cjsh5mZn8D7BdB3jWi4gNzgM8lyaUhOr6EiMrMtErrKZNGpaPs5JJlOIsq42/U
         F5xMO9Mx+CyAP7KzHUlszIhQIi8EjjQAovaGfj/G4aDYdOzowGrtzJkCrx1aka77qyCn
         amOy1pbkhTBDyJBPFEe9Phq7JAXGwKEcTttJjijK/2f3Khb2TpJ0Bv4fElMGuEOdC30e
         0h0J+nEbnHFS1eueJMSFoRLU9PyUperJ9I0BmsdH+JLOcsHo2QgeezrQujDnU70xjgFp
         CBJNDDv/HQeZIEofaHAPazMi3y3VI8nsylAfdXChrj18oCY6mdGsQ4zSHeweNx2vlKWq
         uXkg==
X-Gm-Message-State: AOAM5331xCLIvl8ikfL3zVZMRF/c3RPK1rsiZt5BosszwjcFEg7fgfhP
        Jj42JO9HWM7y17fPbMnqYPbraBk1wAc=
X-Google-Smtp-Source: ABdhPJz4owlPeswNQ7Hsm2Ba7sazeB4/U3MZQetD/sxaZrXNUPfYQB6CwbIIvGWqfRuoL9tIsNKaUOIGiqY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a5b:44e:: with SMTP id s14mr9583662ybp.11.1619225268482;
 Fri, 23 Apr 2021 17:47:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:24 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-23-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 22/43] KVM: VMX: Remove direct write to vcpu->arch.cr0 during
 vCPU RESET/INIT
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

Remove a bogus write to vcpu->arch.cr0 that immediately precedes
vmx_set_cr0() during vCPU RESET/INIT.  For RESET, this is a nop since
the "old" CR0 value is meaningless.  But for INIT, if the vCPU is coming
from paging enabled mode, crushing vcpu->arch.cr0 will cause the various
is_paging() checks in vmx_set_cr0() to get false negatives.

For the exit_lmode() case, the false negative is benign as vmx_set_efer()
is called immediately after vmx_set_cr0().

For EPT without unrestricted guest, the false negative will cause KVM to
unnecessarily run with CR3 load/store exiting.  But again, this is
benign, albeit sub-optimal.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d0050c140b4d..5795de909609 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4486,7 +4486,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u64 cr0;
 
 	if (!init_event)
 		init_vmcs(vmx);
@@ -4557,9 +4556,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
-	cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
-	vmx->vcpu.arch.cr0 = cr0;
-	vmx_set_cr0(vcpu, cr0); /* enter rmode */
+	vmx_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
 	vmx_set_cr4(vcpu, 0);
 	vmx_set_efer(vcpu, 0);
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

