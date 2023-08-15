Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA3577D444
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbjHOUhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbjHOUhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4007C269E
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:04 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68843280241so1977998b3a.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131823; x=1692736623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=194Q9JKRkX0kn5HS7G+Yhmq9XbiwQ8AINE2AwfpTISk=;
        b=UcjAxrAD0iT9xyNSSRKw6S6Mnh+F9jsWWrhMuioT2vmmxmn8yfZR5CzeYjfZ7qbGk1
         aAX8OdtgJ8Q9vokeo3rgEmW+jMQZvpoa2tNiXA6Ol2FEahLf2fpPDxKwHXfzbZrVKf2R
         f5GfJJevtQw3EiWD6D3UY/FVmDNzE0zmxwOLDrYVoJzYDSP22gi1K2GuYGhu0eunYGYI
         G54NHubi6Tk/NDwt+DzuhIqPNUjYIeafzun97fCvpJfq5ng7SOL2/RIHw9xbYW1nN5G5
         afQVSljfzOQ5VFRdxqn0MM+BXMv5sQd6VC9NjXq5vbbfs2btQYY1tkk7DNpqtQEuQiVJ
         Psbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131823; x=1692736623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=194Q9JKRkX0kn5HS7G+Yhmq9XbiwQ8AINE2AwfpTISk=;
        b=UuU+hYPRLFD2SsjOi++JE//Nk8fLb57QhGjCv/dXLYEa+/c3s0j3JJ/fvZx8iNKOuU
         r5W0q7oONv5kHsThIw8gMNFNi7MQjIl8a63ygd7VpzqJDvnE4oYJq56mjv6xYDu8kOmU
         rlQjMKTonpw+4jhbUbk5AYWvSeQzvD3EapQb9GACsNsmymHprv/I/AGqZw/xk8JTIIC0
         q2yhVx8sIhPJuAGtqPxomeOrh4gRWKTIeHQVyClJq6V3zajZA13D3gc/PtS9Ir9JGD3W
         xHemUoJ/pmhrz/Bgo0e62TzxM0VtX8c1p+PJ1diNrAxoItKe8mdGlA9kkfDiLnoB9qfq
         n4lw==
X-Gm-Message-State: AOJu0YzvlSMd26UU1UXxkHyE44DUPUwTVVUhE9OR1gt/32DkDqy4Y9tr
        Xu7XySgPttKW4ALQs/5wD6vaEF4AYHA=
X-Google-Smtp-Source: AGHT+IHQKU3jEXExnIEFi74xujdPT3vtmMe3RhUwRMHGoznyBB7vqMTLiRTpubj1+/t4vfHF5k4NsahV0AY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a0f:b0:687:4554:5642 with SMTP id
 g15-20020a056a001a0f00b0068745545642mr5954001pfv.0.1692131823190; Tue, 15 Aug
 2023 13:37:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:42 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-5-seanjc@google.com>
Subject: [PATCH v3 04/15] KVM: VMX: Check KVM CPU caps, not just VMX MSR
 support, for XSAVE enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check KVM CPU capabilities instead of raw VMX support for XSAVES when
determining whether or not XSAVER can/should be exposed to the guest.
Practically speaking, it's nonsensical/impossible for a CPU to support
"enable XSAVES" without XSAVES being supported natively.  The real
motivation for checking kvm_cpu_cap_has() is to allow using the governed
feature's standard check-and-set logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1bf85bd53416..78f292b7e2c5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7745,7 +7745,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
 	 * set if and only if XSAVE is supported.
 	 */
-	vcpu->arch.xsaves_enabled = cpu_has_vmx_xsaves() &&
+	vcpu->arch.xsaves_enabled = kvm_cpu_cap_has(X86_FEATURE_XSAVES) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
 				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
-- 
2.41.0.694.ge786442a9b-goog

