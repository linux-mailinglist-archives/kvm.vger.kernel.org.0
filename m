Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF08B7270B8
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjFGVvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjFGVvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:51:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244051BFA
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:51:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5651d8acfe2so131773707b3.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686174677; x=1688766677;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HPoB19C6ibhFiFvtqKdPYRflB1cnMy01ONw01MJz9ZU=;
        b=l5bkZSntV/XsE3QFg+W6V7XRcolH1ybyXMCGM0fzLlTOBljHh1KGjUYlCbrr0L03GS
         dZf4vXCJiOaEdSK/Q6RoDe8ORZBjV2R38WnDqrvGcWd5OFfohP8To6ORdrykFYk4VM5J
         GnkhVubOp6besx2x5ODeCtMST0J+BERlioYAH2FeQ26lqd4bCdLXHCsKOGzHAXxHaQnv
         NPOWYqvPLEReoZAEGzaZpNEmNyXjYuTM45jmiNZwUyZnfCmN7mgyz61EWNSFg6E2LwjZ
         rRiSAhO97+Tzl0dvnMS0S0pHwTGjiB+QfOOEQbbodwGhBIYyYELxP9tkTNsPzFxpVhGT
         QFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686174677; x=1688766677;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HPoB19C6ibhFiFvtqKdPYRflB1cnMy01ONw01MJz9ZU=;
        b=EFPvt04NbNvCcN/mE64DCGGYEwZv/mvtzBJg+i/2JMSL+D/rQWhjLdrM3eMRUmoJ9P
         UfE1RK5Ofh9qek28NTaC9QPTQmK/Cc4poxDjpUsQO3NJRNLxqgfZNNv3MhO3GWzJdRp8
         RrVE+6ZiSwEtU79kfDr47bBmMY2BeFH21lDKpeEypkjjJJNDO4Pcv9kbPdXIOhY0MgVK
         C4FzRKh0lBpfLzigwH6IVnflIH6YFyov4O/R313gq93ZqbDdvucfdQ0XY+iUSexhcX/Q
         p7J+cQ0HSNLQXlrBTQtMpIPzs8CYzRp0E+AHA4EsoLJkGVoWB4TOwWk2bhQ4pp9Qa410
         4RnQ==
X-Gm-Message-State: AC+VfDzybw0TVcmUP1+JCyY1Uid4m62Z5TvuBvJPwmoNSkNeABAPa0IU
        J8TJZaIETC0m2j/YF2u2bzjY24QtDrA=
X-Google-Smtp-Source: ACHHUZ5gnk53tnfHK0UOyah+G8KrjK0CynNigYHOzxluz1SOc35gRBgM3nxFXELtCw8WZNaCa5zKY3oReh4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1006:b0:bac:3439:4f59 with SMTP id
 w6-20020a056902100600b00bac34394f59mr3876651ybt.2.1686174677388; Wed, 07 Jun
 2023 14:51:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:51:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607215114.1586228-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/2] runtime: x86: Require vPMU for x86/pmu tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Fix a bug in runtime.bash that makes it not play nice with testcases that have
multiple dependencies, and make x86's PMU tests depend on KVM enabling a vPMU.

Sean Christopherson (2):
  runtime: Convert "check" from string to array so that iterating works
  x86/pmu: Make PMU testcases dependent on vPMU being enabled in KVM

 scripts/runtime.bash | 1 +
 x86/unittests.cfg    | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)


base-commit: 02d8befe99f8205d4caea402d8b0800354255681
-- 
2.41.0.162.gfafddb0af9-goog

