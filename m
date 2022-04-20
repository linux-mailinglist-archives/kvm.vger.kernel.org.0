Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5847F507E46
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 03:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358771AbiDTBkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 21:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358764AbiDTBkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 21:40:20 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F313467B
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:37:36 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id t12-20020a170902a5cc00b001590717a080so139079plq.10
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7XDJ2YAUSUHcgoV3YPLSl5Gau4y2D+i+qP4k1W8uuo0=;
        b=Kzq671IMXGcPz9IKQMcDM3US3HjfGCUincXTuSeb8zoQ5g9zspDa+oftBodD+68BA0
         ASknvWT3y3/2tm1pFvOJJf03UDGsxHlo9HiJfajn1z86XFO8VOYNgeJSfcldOjJttKL6
         u4iQvkpiuIkouUmlKxAkJZjsKSp4mgT8LCkPtIuNgcc2wJgdk6U7HVc6zawUrxFqpmSh
         cJMdz7quOHZhIjj/TZfU2uKppIHeoeY4vyOXo7g77A40z8OFTcPn3la8QqxicZn1Y0I2
         coWmIbo0WusRrVIVoc6e2zWzddbvtftv+F4nVGPrWzvz4itxs6rqqz4CFy1AZrhnF+s1
         VKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7XDJ2YAUSUHcgoV3YPLSl5Gau4y2D+i+qP4k1W8uuo0=;
        b=6dS/LZAfPMqF2mdsM+WG4LIfSC2JaGipRMjUFyGt7Oidj00E1Vk0j6wbWaZv9r4Tcm
         yAsDTqw7dk70usmV3WOg+unPJVSEWHd+WARA9KA8eI2aFMfWc0OegcughUcdsQSk4fGC
         FInechJHwTyluIWqR4DbNZiyoIjb8/2su7UR8YG9c+WiKLStaSTuzjNQ4/kQciPXW/Lc
         qKqwoFNoKuWpypvvegZRdyECSnW9joACkYWO7c0d7MXe03pbaIGiMDBw/vaoJBs5+sve
         gBHeje60CmgjFBqCL2nf1zNQdSI718nGwISOslHMvlboCYq2EuHEqSi/THGLQgp5E4co
         +2Yw==
X-Gm-Message-State: AOAM531e/UO1FqDQA/PhrWEVihpIrb641Sbm0YTEZrn1DyMVBF+IZW6Y
        S5nRseW5JAHmVzAm+NH6z8uKhWNTMjY=
X-Google-Smtp-Source: ABdhPJxuyNZSwYUgGu63fLJ8gbeXdplf35syAz3Hcvk6YC/6aaKdyYPIGOcMr0sABs2XFp+PY2pmPdIXT+g=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP id
 k5-20020a17090a910500b001d29e987e1emr198610pjo.0.1650418655862; Tue, 19 Apr
 2022 18:37:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 20 Apr 2022 01:37:29 +0000
In-Reply-To: <20220420013732.3308816-1-seanjc@google.com>
Message-Id: <20220420013732.3308816-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220420013732.3308816-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v2 1/4] KVM: x86: Tag APICv DISABLE inhibit, not ABSENT, if
 APICv is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>
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

Set the DISABLE inhibit, not the ABSENT inhibit, if APICv is disabled via
module param.  A recent refactoring to add a wrapper for setting/clearing
inhibits unintentionally changed the flag, probably due to a copy+paste
goof.

Fixes: 4f4c4a3ee53c ("KVM: x86: Trace all APICv inhibit changes and capture overall status")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..753296902535 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9159,7 +9159,7 @@ static void kvm_apicv_init(struct kvm *kvm)
 
 	if (!enable_apicv)
 		set_or_clear_apicv_inhibit(inhibits,
-					   APICV_INHIBIT_REASON_ABSENT, true);
+					   APICV_INHIBIT_REASON_DISABLE, true);
 }
 
 static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
-- 
2.36.0.rc0.470.gd361397f0d-goog

