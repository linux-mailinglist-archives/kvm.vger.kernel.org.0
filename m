Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA26F5BBB
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 18:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjECQIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 12:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjECQIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 12:08:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDAB5598
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 09:08:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a7c58ec19so6515321276.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 09:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683130123; x=1685722123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D/GzhD/DCduvp6JChcNXJ0v97/LpisAJTKI+lJVJGfk=;
        b=YfaFbAD8Vw1BXUf9Sq2ANnubH3wUeOjR3KQ69e/KJCC9TsYugMwRz2CQvYgUdfMyZj
         k2zD1k567dS6+uXkgAhDZW2sfbq4uCAsN2LaIKNadVZveDufFFximiEmFVRC4/M0vsEI
         VZnSCU4xI5Uc4Xg22qwugM912YezY1N424qRMInuF1UcykT9FRFkMvGsQkT/cqGTV39o
         1nUl6JWRXBknktDgVErj5H42941mdgLGoa86Gp5JNKqSnjWcDcV6oRvuI6gC4Exh8m28
         3Hlb+b6iuFL+hY4s/6WaIwNRsPMLKqgWCtJPKB2yMOaJqsShmk+pxBL87yjphAFJh1bh
         43og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683130123; x=1685722123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D/GzhD/DCduvp6JChcNXJ0v97/LpisAJTKI+lJVJGfk=;
        b=apCzFgduSytjMu5TVWXrEr1eMZ5uF6KW3XrRsJAs7Cca7YDCyGL74PN5qWEbSaL9Fc
         JJ8kvbwHFfipEUWZ/V3sPB9YIS5JEqrnXF7GpO+mQ9Joa5ZXLSC73STMgkzmyVvKUjmt
         jX8AozCYjrfmIDNrr/TdqRmagrwCWf8tXlZul/mwbzR1UfoKLjHFXWdJRaJoW6jH060h
         lV2eWxl5Br8MU9TG9W6nbOWyS+lfGsJjvr4FfVz5uupE2dr59+278pd6xK8vaIdoav2v
         azKqooMATrxaDwGE7brOsjDXX2CHbO5R7qvq9/+n9At6uyY1OHnmEq2ch4yrcJsCuCjq
         QwiA==
X-Gm-Message-State: AC+VfDxrmsIxAf/5+1kSCiqUwhfKZFbQ2FgU0vagKTznI5ObPzA3iMBY
        w5F+0F1hzYngMxpDsa0jlmSMR46UP+s=
X-Google-Smtp-Source: ACHHUZ6MnRQ4VM70VGzJKrPmrNjHR+wgpUgK/FCrPhEo502lzVIcBmymGkZiX3c1etNk8K8GocuLAXWtNI0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:72c:b0:52e:e095:d840 with SMTP id
 bt12-20020a05690c072c00b0052ee095d840mr13426066ywb.0.1683130123340; Wed, 03
 May 2023 09:08:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 09:08:36 -0700
In-Reply-To: <20230503160838.3412617-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230503160838.3412617-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503160838.3412617-2-seanjc@google.com>
Subject: [PATCH v2 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
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

Explicitly check the vCPU's supported XCR0 when determining whether or not
the XFRM for ECREATE is valid.  Checking CPUID works because KVM updates
guest CPUID.0x12.1 to restrict the leaf to a subset of the guest's allowed
XCR0, but that is rather subtle and KVM should not modify guest CPUID
except for modeling true runtime behavior (allowed XFRM is most definitely
not "runtime" behavior).

Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/sgx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 0574030b071f..2261b684a7d4 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -170,12 +170,19 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
 		return 1;
 	}
 
-	/* Enforce CPUID restrictions on MISCSELECT, ATTRIBUTES and XFRM. */
+	/*
+	 * Enforce CPUID restrictions on MISCSELECT, ATTRIBUTES and XFRM.  Note
+	 * that the allowed XFRM (XFeature Request Mask) isn't strictly bound
+	 * by the supported XCR0.  FP+SSE *must* be set in XFRM, even if XSAVE
+	 * is unsupported, i.e. even if XCR0 itself is completely unsupported.
+	 */
 	if ((u32)miscselect & ~sgx_12_0->ebx ||
 	    (u32)attributes & ~sgx_12_1->eax ||
 	    (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
 	    (u32)xfrm & ~sgx_12_1->ecx ||
-	    (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
+	    (u32)(xfrm >> 32) & ~sgx_12_1->edx ||
+	    xfrm & ~(vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FPSSE) ||
+	    (xfrm & XFEATURE_MASK_FPSSE) != XFEATURE_MASK_FPSSE) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
-- 
2.40.1.495.gc816e09b53d-goog

