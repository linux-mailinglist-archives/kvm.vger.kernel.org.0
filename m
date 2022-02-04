Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEBB4AA15E
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbiBDUrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbiBDUrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:47:17 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80265C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:47:17 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id p65-20020a6bbf44000000b00604c0757591so4854267iof.6
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rsswlX+UvlYccSGce2sEL3Rhnd+1PR9SHvxy/DfsgGo=;
        b=RI9RDa0cfMdk1v41yqxVJaH5iac9PnS/y2Z1FFUA64f9pGmvV30BNJ6jEPAX9tFdcM
         vmELrgqcHIpsK/vPW89oZNhzfmrpYUlKOp9N3DkzfGwxviQW1HgRYUGjBuyvWhvSKhtB
         AutccaCh0Jge+Ld4TWgw44WjZubawPG9Kkti00dOw9TppzsFKVp5S5oeBYWHovJeMmn0
         txmyLbgaTQ8T6U2Yr5yAA5ZEe3HUBBEm1JWmH/VXtwWFXU8uaa3oGjvEaw5yuMpzsq16
         dN8nue46WVgNxtVI+gfbDGDCB3zXeimRurKMSAGlKcQxmOcmnzmiyo41dTRCFPCKjgce
         bfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rsswlX+UvlYccSGce2sEL3Rhnd+1PR9SHvxy/DfsgGo=;
        b=qdbAIlNeC6xRKBj180HWSKXnYVE8jjj0Yf4Y4MP+RwZ3lEa6suI6zDEwCEOBb1ieiH
         R/Fk6SiuSFerk0ZozVj7hKz3aRzu5Zk7vi3vD5ZET1LIbMqbvgSBbQxk8xsSWJtYrPmK
         V0LATW54vXLvUcE27Oey3YjGTcvqbvsED9zLFruwr3kKwQJw+03kLk5LK7vO6Sf1njgM
         AcywSXDfLEyepGHLtdFVzXr5HeLUGje1/lJjR4ia6TmaiJQWALDjhTiixWf5rFAoi7aY
         wgO0P68cmZtkaOCSGGUpl0otySSGLLP24dEcj9Z3B0J1TW5wWB4xx+RBZI1l1RDZFeM9
         p+6w==
X-Gm-Message-State: AOAM532D69A77OgoK0s6YPQ+zroacV7Dcf3VNNIKbRhFpOnCM3pv1v5P
        HKNq84GsRHlJct9qWFawcRJGRGG0mQCdAxTIRwDAvLVyw0w2aZ+JuBnlhU8c3peXx2Gssaec1XR
        J0O6QsC6eF9eTkp/cZ1x3sVYa9UD4AwKWuPquC/0FHzdRrXMywjODAUcvUQ==
X-Google-Smtp-Source: ABdhPJzY892ZLEETUy9a2omGBdoFS5FIxhQimmV1c/ntaOpKAs+9OWqng8Jkw+oisJtczcrCZSBjtyj6egs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1aa2:: with SMTP id
 l2mr468664ilv.111.1644007636881; Fri, 04 Feb 2022 12:47:16 -0800 (PST)
Date:   Fri,  4 Feb 2022 20:47:05 +0000
In-Reply-To: <20220204204705.3538240-1-oupton@google.com>
Message-Id: <20220204204705.3538240-8-oupton@google.com>
Mime-Version: 1.0
References: <20220204204705.3538240-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v2 7/7] KVM: VMX: Use local pointer to vcpu_vmx in vmx_vcpu_after_set_cpuid()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a local that contains a pointer to vcpu_vmx already. Just use
that instead to get at the structure directly instead of doing pointer
arithmetic.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 60b1b76782e1..11b6332769c5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7338,11 +7338,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 						vmx_secondary_exec_control(vmx));
 
 	if (nested_vmx_allowed(vcpu))
-		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=
+		vmx->msr_ia32_feature_control_valid_bits |=
 			FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 	else
-		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits &=
+		vmx->msr_ia32_feature_control_valid_bits &=
 			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
 
-- 
2.35.0.263.gb82422642f-goog

