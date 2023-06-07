Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB265726CB3
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 22:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbjFGUft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 16:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbjFGUfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 16:35:33 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7241BFA
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 13:35:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b0116fef51so30548625ad.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 13:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686170122; x=1688762122;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=anERRIco3r2Pzu1okFsSErGwX1u57H4zjQoU+iEzkG4=;
        b=v9vEEwAMrri+MzNgtR7kom2JjQE8LGwrhVherJ4PLHkyGznRbW9tBY07mSU7dvZzCR
         2Q4fobuI4mgLUsB2dXmumVzw6WHTrtPn6llvWR1Wzi1Tz0Q2pnjGQf0swgsaK24vm3Nt
         s1O38Nqo/1yG28o1FfOpQeDsHfets6OOQLmhx+MkMziQL/D68nrHoRKAEFWgYjd4oWYa
         ThAvUZbimDpv+/BZPybxj/+mw5N9P63fL8l6WRyoIfH4Lk4lrQiytdUabEeuHpO+iLbU
         W/J0DI/pnL7YYmConS9FaWuCMxKlTv+1hVA3LBTWre2qm/83EhUOOdmFzioq4hoOnAUh
         9+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686170122; x=1688762122;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=anERRIco3r2Pzu1okFsSErGwX1u57H4zjQoU+iEzkG4=;
        b=YIozHhDCYeFsGueyFfUzTk4stmU9qaIRtSjE48Nb54xMrXj4GmcNZWRATEPs3f4use
         I2SLZkkwWrLgyZf7XiJpOMfCRfWAuLtrPhaM/mDIDZMb20dFojVLEPl2hrVYpgs8jPVe
         GSNvkpbd/BW1JEbtpji7ZhkpQyzCLEMW2ag19pKnyt+zOwp55F3yBwQ7zG+wX+q8Yi6p
         Hv2il13UjdkHPzhr2fASzrpEppo1i7pe1nEfz1OoHMgyKaT6peU4qOByipwJrWR/2lEz
         LcKDg3S/nM7wIYd0sjNW0tc1AGxJJjR8gIl8DOeE+94bT8hcTbg7r7MlydRd9lZvOYzs
         vvpw==
X-Gm-Message-State: AC+VfDyELXFRNwK7Qu7j8aijyR4kcJpUeTypF4BJ433QQESrQ/RFBimR
        Vr4IASxzN0NzMaEIry3PNVgLD4pT374=
X-Google-Smtp-Source: ACHHUZ5ZK6Xqa68JBAcMUPiTMq8fiwzwrpi4nBTZWtdO8d3+4CXjpbW4rXaILDLepv5Ij16X/l210HWhM4o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7008:b0:1ae:5d12:743a with SMTP id
 y8-20020a170902700800b001ae5d12743amr2022899plk.4.1686170121670; Wed, 07 Jun
 2023 13:35:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 13:35:16 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607203519.1570167-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: SVM: Clean up LBRv MSRs handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>, Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eliminate dead KVM_BUG() code in SVM's LBR MSRs virtualization by
refactoring the code to completely remove any need for a KVM_BUG(), and
clean up a few others pieces of related code.

Sean Christopherson (3):
  KVM: SVM: Fix dead KVM_BUG() code in LBR MSR virtualization
  KVM: SVM: Clean up handling of LBR virtualization enabled
  KVM: SVM: Use svm_get_lbr_vmcb() helper to handle writes to DEBUGCTL

 arch/x86/kvm/svm/svm.c | 63 ++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 43 deletions(-)


base-commit: 24ff4c08e5bbdd7399d45f940f10fed030dfadda
-- 
2.41.0.162.gfafddb0af9-goog

