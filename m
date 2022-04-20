Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09262507DC5
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 02:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346443AbiDTAvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 20:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbiDTAvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 20:51:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5F637029
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 17:49:02 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d11-20020a17090a628b00b001ca8fc92b9eso200942pjj.9
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 17:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=si1mIXlogaU9T3xsthY8di9h1Rs/7dtaVqn3A1tWu90=;
        b=Uu+dKIfAoGroMRhgbAqAAfipW1FVvOTUFPRX7fVSmyPlc6nSJewgJBYZbN+wI8KDzX
         mNuoO0hUE/MuAOVdfAb6nUdUXSyJTrhqGpRvs6lneMEE5AjyKqK64dZ8v6E0yQ0asOrq
         1EH/8Z5E78M9/SLJqjPJ0vHGSG+6+HPmit84+eERebEA3scDUohQG/5qJzFKTxwBUw8W
         IIqPk4a9GAa1CTl3FZzejs3VQ2DxSTCvabmyOcqQs+XprSeKdVE9wYUUsK89k63U3WDv
         RNvEzAGfyw4riycociSyqzZmpRq+ZPD07OGMijHY1XcqTKaC+PcvfGbwxTRUFgYPXAJf
         ioBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=si1mIXlogaU9T3xsthY8di9h1Rs/7dtaVqn3A1tWu90=;
        b=UYIDF5K/T95y0GI/QzL3339J7Yy1VgaYTfOVCWXrxqpdrOAkqAsbhJ/B1x/IslZKID
         neYduf0u83UPJHyJ5Dqss52/ujWuhT6H6wV9cTV2EFZFiJ+zkNjEXnJgSCeL9d/wHEo0
         n8FkG4X43ejgLSOKyQr/+tGpMpgHMbTttQGgYAi1F5jvAviUW9txrcEsGWZdK9uNACfR
         QTKX1igliNcIv2t6/EfPXEjxH462UYz9g5ajVzLVue66pVuG8r6tqkCYlXXWyZgh+hT3
         NLCfj3xWkrA8ecUQfrZVwn8GeizhwS+mzAtV0uOUHaAe3obXhYNkiWFiON90kSDjluWn
         GHJw==
X-Gm-Message-State: AOAM531TghX/GGfLzcPOMPxuSUGTWYxqHEoJ5B4Q3DZao/ZZl7R4m+sm
        mqDXamnO6BOrqo7XS9aQulz21gHkQ1M=
X-Google-Smtp-Source: ABdhPJzYzKx5GRdinxbZw0kqfsUMOXj1zo5E5vnuyMN+V18dh/iddFwLkKjZeudEtsGN8aj/LRA86g4L8WI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7c01:b0:156:17a5:a68 with SMTP id
 x1-20020a1709027c0100b0015617a50a68mr17803797pll.166.1650415741405; Tue, 19
 Apr 2022 17:49:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 20 Apr 2022 00:48:57 +0000
Message-Id: <20220420004859.3298837-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 0/2] KVM: Fix mmu_notifier vs. pfncache race
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Fix a race between mmu_notifier invalidation and pfncache refresh, and
then fix another race of sorts within pfncache that exists because of the
hacky approach pfncache currently employs to try and handle races with
mmu_notifiers.

Both issues were found by inspection and not proven on hardware.

Sean Christopherson (2):
  KVM: Fix race between mmu_notifier invalidation and pfncache refresh
  KVM: Do not speculatively mark pfn cache valid to "fix" race

 virt/kvm/kvm_main.c |  9 ++++++
 virt/kvm/pfncache.c | 79 +++++++++++++++++++++++++++++----------------
 2 files changed, 61 insertions(+), 27 deletions(-)


base-commit: 150866cd0ec871c765181d145aa0912628289c8a
-- 
2.36.0.rc0.470.gd361397f0d-goog

