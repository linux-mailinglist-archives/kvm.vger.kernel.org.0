Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84317576861
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiGOUn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiGOUnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:11 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF04688F35
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:51 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z9-20020a170903018900b0016c39b2c1ffso2602812plg.12
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xiXVTedovEVTg1a0+OnWCXfjoyyzpAtm00ekYgyg/co=;
        b=OFQTDyaPadd9CGudqxFz2kGdseTvNJRBvYizWrKqT9X8al24aAFWzv9iL3YUbMg+bP
         m4EJ4SbtahSknNatzQbFJBIEfU/0kDX9v/HJP3JNmbXBFjcXZPsFr2VmWyC4F2ZZkcm7
         TuA0EJPycpfQEjKfUsEn0uu+Gyp19DQGNBP6e5a8gfZO2FfCEn8//ABuuQ381DpiIYwM
         mgo9f9MpzpyZ9pp6TgHncaWVfas5Aq5G5NzSwpIJUWr1uCQlqw0jfAohncD+MO3/EmZd
         sJL+TITJGviOelh1sgt8P+nOdsbtBtDsei4oHn/PR5fjf47QCleIy6f9B67unR+mdvA0
         iqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xiXVTedovEVTg1a0+OnWCXfjoyyzpAtm00ekYgyg/co=;
        b=VlplG7vsqtHk0HmDMEbQEOwc+3kSXIeJCIQ2okOkGnZFA4FUUYR4GUEFflkqJMq6T+
         pJ+XirjY9YjjT54rgVTOLPZf/j+xkZMDCoh6TduPU4izDhr6j1PoXmUHrXkbq4vsIf2s
         wZ3mx3DIJWTwWuSASk/m2Rj/abM70Lkn2Zwyi362PEwmNNGnVXYobGfpnPwhegZvW9Q2
         JcA0MRgiPID6v4cZMRuxRL8vHjO3kYr1aoeMX6Ooqay+DnpfIGSAE3ouf86wPqq/8MzO
         J3fa93Wy35U7hQosUr2iIVUa1cpmp4Fv/icxpl/K1HHgDAGKGTGA8SlWnyTOomUGS6GY
         aY7g==
X-Gm-Message-State: AJIora+hD+lTUlAAOggDSgzDOCNWitTtk7LL7pOuLkYnfx5Og9CKxIZv
        G4lb/AIDo6zXpQ2KIl9K0JaOU5bs0u8=
X-Google-Smtp-Source: AGRyM1vFWEei43v7ognriCeTb7CW8ZgMb93Qrex4AiX8uFD2eOrV/wtb4KAyRuoEVicSwdcZ1bWpqr63z9M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac2:b0:16c:6a1:692c with SMTP id
 q2-20020a170902dac200b0016c06a1692cmr14849931plx.19.1657917771068; Fri, 15
 Jul 2022 13:42:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:12 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 10/24] KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Treat #PFs that occur during emulation of ENCLS as, wait for it, emulated
page faults.  Practically speaking, this is a glorified nop as the
exception is never of the nested flavor, and it's extremely unlikely the
guest is relying on the side effect of an implicit INVLPG on the faulting
address.

Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/sgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index aba8cebdc587..8f95c7c01433 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -129,7 +129,7 @@ static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
 		ex.address = gva;
 		ex.error_code_valid = true;
 		ex.nested_page_fault = false;
-		kvm_inject_page_fault(vcpu, &ex);
+		kvm_inject_emulated_page_fault(vcpu, &ex);
 	} else {
 		kvm_inject_gp(vcpu, 0);
 	}
-- 
2.37.0.170.g444d1eabd0-goog

