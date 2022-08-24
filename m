Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09C459F20E
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiHXDbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiHXDbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:31:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E351683048
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:31:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id o12-20020a170902d4cc00b0016e81c62cc8so10209033plg.13
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=8csu3CnKhbEs6Rc2o35KyWXX/h9ze9GUtfv0VR2tlfk=;
        b=miuX7jBFU/oCEUHgHQuycGX9dMPreQn027qut3yvNU5ZgenW+OmPRxtR4HZlBjOhcg
         POhM4rytcBwcaTU3faOywuzVhkT31be4949ibbCDgYN/mZ3u7lPzNtKCmuiF74a6pSGt
         K0MUxdplq7oPEoFQafJsw8K+tGjIQl+mamx/RBYQXdpCnitvswuu6JdHVOMSRCLt2AfM
         hnJg2Fxe8sb3RX0PmwmMhmR7/p5UEzLVAjWtviWVKuoCcvRwwUmOC4UDZN6AIVjZTmml
         YPKdULKVF+6KJ0xVxzAqW1qEwmdHOYD42dV24ze6TYs6LG57SqSLaQe9sttYP/YqHhhP
         65jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=8csu3CnKhbEs6Rc2o35KyWXX/h9ze9GUtfv0VR2tlfk=;
        b=7ZLV/e3EtvLiokSLDvL+oNG1ebTKwHgvJwKrjkP6CRcECxAl5l32teAsNUJ8MeqrNx
         lPlXphOPxaTPG36NxpsoFUIYvp7TFbWIohvkOAXg0va4ZClGJNzPOW1yaX3HNVGnLiRB
         KEvVKLVNXJqJQsfjMPa9IIGV/Uriz8vuxkJWWQP4EPHNchRWPphu4W84uOD8Yw8tgKLA
         dFV1Ryb7FcuLai91cWxrZ6qx/Gd4YuCvBIqYhOjzzrGsjM/8u3Bfn+2J7U9x9h9w1TxZ
         gXmebafoXo+Qdj/nPnUWPy2SkaswpKvTednki8/oyicqHzFy2iNxwfFDL6ERcldxfnIQ
         /qeA==
X-Gm-Message-State: ACgBeo1WCydaIYe8QPtjSTikNUC1D+SUSdILy22Zc/lNs0qadbdx8hVt
        vJ1lmI1szmcTkxQFFD3rIk205GjPdA8=
X-Google-Smtp-Source: AA6agR4kVHAY+Am1kSmdEMreZvp9bp5EQs25Woq2sCdu7BvQj0Sy3+WtYhhjdZaliLvjM7+Ca6VOt2cZzk0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:918:b0:1fa:ad32:57f3 with SMTP id
 bo24-20020a17090b091800b001faad3257f3mr6501379pjb.28.1661311865482; Tue, 23
 Aug 2022 20:31:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:30:57 +0000
In-Reply-To: <20220824033057.3576315-1-seanjc@google.com>
Message-Id: <20220824033057.3576315-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220824033057.3576315-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 3/3] KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leonardo Bras <leobras@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject #UD when emulating XSETBV if CR4.OSXSAVE is not set.  This also
covers the "XSAVE not supported" check, as setting CR4.OSXSAVE=1 #GPs if
XSAVE is not supported (and userspace gets to keep the pieces if it
forces incoherent vCPU state).

Add a comment to kvm_emulate_xsetbv() to call out that the CPU checks
CR4.OSXSAVE before checking for intercepts.  AMD'S APM implies that #UD
has priority (says that intercepts are checked before #GP exceptions),
while Intel's SDM says nothing about interception priority.  However,
testing on hardware shows that both AMD and Intel CPUs prioritize the #UD
over interception.

Fixes: 02d4160fbd76 ("x86: KVM: add xsetbv to the emulator")
Cc: stable@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 3 +++
 arch/x86/kvm/x86.c     | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f092c54d1a2f..8ce5ae61fc41 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4132,6 +4132,9 @@ static int em_xsetbv(struct x86_emulate_ctxt *ctxt)
 {
 	u32 eax, ecx, edx;
 
+	if (!(ctxt->ops->get_cr(ctxt, 4) & X86_CR4_OSXSAVE))
+		return emulate_ud(ctxt);
+
 	eax = reg_read(ctxt, VCPU_REGS_RAX);
 	edx = reg_read(ctxt, VCPU_REGS_RDX);
 	ecx = reg_read(ctxt, VCPU_REGS_RCX);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 97ab53046052..356d0475ab6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1065,6 +1065,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
+	/* Note, #UD due to CR4.OSXSAVE=0 has priority over the intercept. */
 	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
 	    __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
 		kvm_inject_gp(vcpu, 0);
-- 
2.37.1.595.g718a3a8f04-goog

