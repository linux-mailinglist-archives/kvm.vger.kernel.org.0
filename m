Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042BA6C4DCC
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 15:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjCVOdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 10:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjCVOdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 10:33:35 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C8A19F18
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 07:33:05 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p9-20020a170902e74900b001a1c7b2e7afso6091498plf.0
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 07:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679495583;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yd5LHdKukK1pcNHstBXl6O3ULCGvo/RjlcU+fY8u3H8=;
        b=EBUDuw5g01iFFCH1b88omE6dWIzcJJaRfXTxbZIzAYFmfNFThgOnrnl1Ubx3pgcNqq
         8aZTv1erC/2+bXzaU26BCN4c+CX0AW5rRhKpZK23CUHzjjWb05rQzH1RYk95pfu9smIi
         +7x+nkalSgZbPi00VPojdUmeut+2QiltxKWsPIHXr7Cs6orE3wW+oACzqYL0CQQLeF9y
         SZm4gtjx4XB68qrTj4oSQ8DNVobr49+EtDWSTaPVwhfQFSghQD19aZA4AX74Uf7UTW/G
         R/JIaxWnQY5y4OTvKR3p+U7IjbXRdQsyII7PH0KWeH4xKvOnrGhCtvR7xeMBFypyWT9V
         4axA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679495583;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yd5LHdKukK1pcNHstBXl6O3ULCGvo/RjlcU+fY8u3H8=;
        b=f2N6NCc7pmo8wNBfvOXlzys5xabIa1bCKVa6euVroEW+BAuoICHvppAqCvP99QNzVW
         YKlfOaQ1l2EJkqUpwGjCLvM1SMtLoTcNBAZe4xhDetP1lyV9i6H/JStPd6VFnDbQIlJo
         cWLUT3LaWI6eiy5nUGcNhtL41/4tStBFNHFzs5neV+q17WcpME3no02Mt8xCmazy9GRY
         MyA0NWgY3GmquxeE/bpzm1Q2llv7D5LF+iTZmHs2KnkY7Fdse1W/C/7sq+urdhhMLYIv
         FVgDFLdy/8vGSQY21uJBlnKpwxUufff5MB6h/h/Dq/2/rxdVMggP2zVjI/a0RMRbTKQj
         3bwA==
X-Gm-Message-State: AO0yUKWOlMC2Cc3KGo+ivbQhibCAqaKWjURmeWAVTf7/z+l1agfBfS2U
        CeIA4oL1gXYyKA0pD1xZ+EDb7EedH3k=
X-Google-Smtp-Source: AK7set/87QKITS8Y40wmXcpxGb+AX3dxnR9ULgLmuU7FyTi0h6U+3cH9nyOZXj02GHsJD7Hgr/t2MiiSq/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:244f:b0:623:7446:7075 with SMTP id
 d15-20020a056a00244f00b0062374467075mr1858312pfj.2.1679495583072; Wed, 22 Mar
 2023 07:33:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 22 Mar 2023 07:32:58 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230322143300.2209476-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Fix RM exception injection bugs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix two bugs introduced by a semi-recent fix for AMD's Page Real Mode.

Patch 1 was tested against the syzkaller testcase that exposed the bug[*].

Patch 2 was testing by enabling the VMware backdoor in L1 to turn on #GP
interception, hacking L0 KVM to passthrough MSR_IA32_VMX_BASIC to L1
and then writing the MSR from L2 while in Real Mode, thus forcing L0 KVM
to emulate the WRMSR from L2 and synthesiz a #GP VM-Exit into L1.
Confirmed that bad behavior in L1 with an assertion:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcac3efcde41..ef3bb5ab9654 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5178,6 +5178,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
        vect_info = vmx->idt_vectoring_info;
        intr_info = vmx_get_intr_info(vcpu);
 
+       WARN_ONCE((intr_info & INTR_INFO_DELIVER_CODE_MASK) && !is_protmode(vcpu),
+                 "Exception VM-Exit shouldn't report error code when CPU is in Real Mode");
+
        /*
         * Machine checks are handled by handle_exception_irqoff(), or by
         * vmx_vcpu_run() if a #MC occurs on VM-Entry.  NMIs are handled by

[*] https://lkml.kernel.org/r/ZBNrWZQhMX8AHzWM%40google.com

Sean Christopherson (2):
  KVM: x86: Clear "has_error_code", not "error_code", for RM exception
    injection
  KVM: nVMX: Do not report error code when synthesizing VM-Exit from
    Real Mode

 arch/x86/kvm/vmx/nested.c |  7 ++++++-
 arch/x86/kvm/x86.c        | 11 +++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)


base-commit: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
-- 
2.40.0.rc2.332.ga46443480c-goog

