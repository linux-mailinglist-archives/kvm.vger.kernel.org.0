Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C40C4DBBF1
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 01:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbiCQA57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 20:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354074AbiCQA5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 20:57:55 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F57D1A3A4
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 17:56:39 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d13-20020a170902b70d00b0015317d9f08bso1966178pls.1
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 17:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=f7NVp4rKotjqIcTFxrLFKx5kAJIcRb+37x0j8pTptqo=;
        b=h1z5DqgHKp/WZp7bzBxVpJZVKJEw/mPutBhovv7AoQN2g0WeDgqpAMBJ6YgztUYSQW
         +CnB6TjHShzhiA56pO9ZPjacbgb75Sv/ZPNn01EQIDFRzk8GXA8CqrlV8X1J6C1qmok2
         gPIzz96AebT2+AAQa17hZAOsbqilmmf41Sw3YYEBDhblHmwGTje4hwBy575B2Lth7Pfp
         mRlWVuHXH/hCQIcFj6t1pUZDFe4jFwOj4P132YKhzxsmsDMuJwv/Jo3spPKVFk3J8UV5
         WH7tvOy6t00N8jmoc6IKLWDUYE0sJ9aojVu179oS0HFtw2MdYOU6yNImn24W0YQr5kbG
         bakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=f7NVp4rKotjqIcTFxrLFKx5kAJIcRb+37x0j8pTptqo=;
        b=2THS81tmadbbxAtudzOarsnhpk4CADMEmPdCQQTaexwiCOfO3lPz4y//DrDLjXA3nG
         yk8EDDrZ5ALCImr5DfaGw7c+pJ4FLl/Y3fy3fp0wKrOByh2Axss3sFyREmrKv/RoBxE6
         mgdBs7QLyccpP704D8b778ST07vVIX9sPU1yyL/xPVs/qOFEjqM8gnHOjsLdl6G0pAVE
         8RkJ+y4o2Fw4suXEvOEwTCdNCGxv7LP/FUijYK15KusDCNQY+haphcjDJ+B7hxMyAnPR
         eaELamyGXg6mksKviyLZnoNp8bW7knRV++z9v5Ly8PPswmoexPOtYJ2EZFfNz87cowtv
         ezKg==
X-Gm-Message-State: AOAM530I2RmZyr37T09EcXU3kTmOExPQVlHztudOkmXv77Zjoh1ZRYf8
        A37tQyS1UEpSoVx/2gQ0e1ECAjlLmUH0DlKD/ilCCiz8W0QTu1t2AqJncPJ4cF9JRXHtZDmQVkC
        3bocZ6Sez0YyeInu6l5Tjt2pbBtU1v3b/J9QR0BANvWUIP3fjhsi73TPCY39chbhlt7X+QLU=
X-Google-Smtp-Source: ABdhPJwm3DMofZADMi9xGwcDOf9Zq74NL25LFZfh2hKVbdqy841M5MGduVxTgmAxzSIj+ImiNKFEMLH2qOpj21/HEg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with
 SMTP id m11-20020a17090a858b00b001c65bc8781amr220213pjn.0.1647478598524; Wed,
 16 Mar 2022 17:56:38 -0700 (PDT)
Date:   Thu, 17 Mar 2022 00:56:28 +0000
Message-Id: <20220317005630.3666572-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v1 0/2] Add arm64 vcpu exit reasons and tracepoint
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
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

This patch adds a field in arm64 arch vcpu structure to save the last exit
reason, which could be poked by the hook provided by the tracepoint.
A previous solution adding vcpu exits stats was discussed here:
https://lore.kernel.org/all/20210922010851.2312845-3-jingzhangos@google.com.
As Marc suggested, a tracepoint is preferred for those heavy arm64 vcpu exit
reason stats.

Jing Zhang (2):
  KVM: arm64: Add arch specific exit reasons
  KVM: arm64: Add debug tracepoint for vcpu exits

 arch/arm64/include/asm/kvm_emulate.h |  5 +++
 arch/arm64/include/asm/kvm_host.h    | 36 ++++++++++++++++
 arch/arm64/kvm/arm.c                 |  2 +
 arch/arm64/kvm/handle_exit.c         | 62 +++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                 |  4 ++
 arch/arm64/kvm/sys_regs.c            |  6 +++
 arch/arm64/kvm/trace_arm.h           |  8 ++++
 7 files changed, 118 insertions(+), 5 deletions(-)


base-commit: 9872e6bc08d6ef6de79717ff6bbff0f297c134ef
-- 
2.35.1.723.g4982287a31-goog

