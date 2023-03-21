Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D246C3D5B
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 23:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjCUWBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 18:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCUWBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 18:01:06 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A2B231CD
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k17-20020a170902d59100b0019abcf45d75so9315518plh.8
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679436041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=g5IUgDmGKg6jS9TeGySBz+vT2au0VaL5ai4ERvav8Fo=;
        b=IPQCsgpH532ux37jGtK+gee01/TmGVQihY3q1GSL5SbWGpDOmVHoKwjo9gY1VnBvV7
         iQvqVl9VlJ9vSNl5eVAmVDd7inExLA22z9oDXKCLG2DFexsbV7JhWWOqLXEKnVvofSNO
         02oLDJtx5gKZtP/TbiWLFuQI++cTODWPWXUpLRfymbIl6Y0lJZOe+QA5Vlz7+mKA60We
         266VMnURrV3+LDfx+ovmWN++5M3RvB3G6JUk3BUX+gKMWINAundUZC3cd02gKOwgpJUQ
         KATJb9cZratcUCkP83G9ozJQKZSkwe5NIyvlkwV4qv0/2vgW9fH+5F+PVl1KjMo9lSmO
         IZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g5IUgDmGKg6jS9TeGySBz+vT2au0VaL5ai4ERvav8Fo=;
        b=33exkk5BQmkO+Ap2ETTMpowplZ8hTdhIDoLhcbgsEDwsoA5hKOBpY1Og3zN5XYQgBr
         FQ71tbcUzJWR9OTK/qA76PRi/WmD6TXOPT5/rc7JBO4D5drG15R22ZWWSW0ZxFxeU38r
         rZaMF2pIyk5rrOtl8zPJ1WcSD+Qks0wf0YJhgz6w9zT9qo0+CbMfxo5VWkiN6auPZDXx
         C0Hg/ctozEthJOsgUmIIJtnGJ9qCnpixxIv7o7FpN3aHgLmNi6qaoJ8K5hGvhNxJZf3p
         o79xVtzmBB8xCZaAD1cnA4exvDwZGCE7WL87vMn0y3stHPdTEeE4gdIE0n68u1Yj0e64
         AMTw==
X-Gm-Message-State: AO0yUKXfx1/P6GsvmQMgbZ0wOGEciWhGZTkdb0GPnuXqOTFWFAgT0+X0
        58NcwHVI4HrVorat9kS+ddpfDM1SBrI=
X-Google-Smtp-Source: AK7set94oJIsgHXZKQz4WZIR+szyagQWRPAqHsFOSA0C2T8jc9ZnEEapzRbWt3iH34aCX5qQOhAxHeyeZQ8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4349:0:b0:502:fd12:83ce with SMTP id
 k9-20020a654349000000b00502fd1283cemr154916pgq.5.1679436040780; Tue, 21 Mar
 2023 15:00:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 15:00:18 -0700
In-Reply-To: <20230321220021.2119033-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230321220021.2119033-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321220021.2119033-11-seanjc@google.com>
Subject: [PATCH v4 10/13] KVM: x86/mmu: Bypass __handle_changed_spte() when
 aging TDP MMU SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
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

From: Vipin Sharma <vipinsh@google.com>

Drop everything except the "tdp_mmu_spte_changed" tracepoint part of
__handle_changed_spte() when aging SPTEs in the TDP MMU, as clearing the
accessed status doesn't affect the SPTE's shadow-present status, whether
or not the SPTE is a leaf, or change the PFN.  I.e. none of the functional
updates handled by __handle_changed_spte() are relevant.

Losing __handle_changed_spte()'s sanity checks does mean that a bug could
theoretical go unnoticed, but that scenario is extremely unlikely, e.g.
would effectively require a misconfigured MMU or a locking bug elsewhere.

Link: https://lore.kernel.org/all/Y9HcHRBShQgjxsQb@google.com
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 29bb97ff266e..cdfb67ef5800 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1275,8 +1275,8 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 							iter->level);
 	}
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, false);
+	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
+				       iter->old_spte, new_spte);
 	return true;
 }
 
-- 
2.40.0.rc2.332.ga46443480c-goog

