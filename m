Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECB7576A8F
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiGOXVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiGOXVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:21:11 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D66692857
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:21:10 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id bd7-20020a656e07000000b00412a946da8eso3399242pgb.20
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=3P3Bs+udSQsz1sUF6b+IjzihKr791n8qO5rKr7yYqSE=;
        b=VAVneBoVZS7wuVCC3aUBkJFUZzF0WCarFPBNN4kA6OH/iochWiQiaPSvniKfnAf+YG
         dZtuls0lliPtyKtiiA4cwGjh2ERAZqLms+8VAt5QR0ieI7qPZB2JPcJQ0jjrmCN+HBxa
         4jRzzEv5cIjBSbHZKlIfwG3XxeI0Rx2YYAu1Lc97xnzed66QaB1GOI9o49Jnt53NuAu6
         mN6+1aK+S/J+Vwr3SzuvCdiL7AodCdLjjYqKg6WogcxbQ+gXqXPGXDnZNSpGcUl7iay3
         gPGwEnOVaXesnGLeoT49N3DuNWJOYuGkeS7F/HVJzZth9+lQEbCFlUM0jPpcmsZmj5P8
         V0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=3P3Bs+udSQsz1sUF6b+IjzihKr791n8qO5rKr7yYqSE=;
        b=V9ZOSOffa940MmBlSB541+7hO+69ZOprW80B0k6WEcf/7K8n4EjLaZaUzmAM+3zuP4
         WB98WNcmmoz3z+oxvIgLL5YAR1M9+aP2QePAUaBbOBLQctY4HLZUXtKnqxi8qr0qH2l7
         YdtsuKnHaq7hLE3S5qDBDAF4b0spGlc23vT2ewPOA1lZBGXAQyWT/6NPMVWgcr7bPbTX
         wRqTtkiE8Mur0IonaRoz1a7/pHoE52QPdrLHAoDEZCiN7B/KvihSsw9ULvDFVon14BJp
         MLRWNUjqj0Lcdc7aIoelQjtGEqrYLBxiEEifP0KwURGeQDZuJQV8GQ6J9Rb381wcQSxY
         lMCw==
X-Gm-Message-State: AJIora8qw3GVnxiKoqtV5u49aKXBRJ9RoiO0xraRhUhvfzOSAGzTBO4C
        1ks6NhxTk3i+mWJy6gNSBmb/ZCs/ghE=
X-Google-Smtp-Source: AGRyM1upZZkkOKDTARRJzNwIaT/POrzwuzwSs1Kl9kDJrRql3nC8/r1FEQQqKVfyugyXaZvb4zbRhDESNrw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:760f:b0:16c:ae59:c9b2 with SMTP id
 k15-20020a170902760f00b0016cae59c9b2mr10707642pll.0.1657927270100; Fri, 15
 Jul 2022 16:21:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 23:21:03 +0000
Message-Id: <20220715232107.3775620-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 0/4] Huge page related cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
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

Simplify (hopefully it's simpler) zapping collapsible SPTEs by first
simplifying retrieving the host mapping level.  KVM currently requires
memory be backed by a refcounted struct page in order to be mapped as
a huge page.  This requires KVM to acquire the pfn that corresponds to
the gfn/hva before checking whether or not the gfn/hva can be mapped
huge.

Dropping that requirement allow the "zap collapsible" path to detect
that a shadow page can be zapped without having to first bottom out on
leaf entries.  This could theoretically be a minor performance win,
e.g. then KVM doesn't need to walk all not-present leaf SPTEs to find
out that a shadow page has no children.  In basic testing I didn't see
any meaningful difference (the actual zapping dominates).

There are also potential use cases for allow any mappings to be huge,
e.g. GPU buffers (IIUC).  Dropping the struct page requirement makes
KVM play nice with those.

This is most definitely post-5.20 material.

Sean Christopherson (4):
  KVM: x86/mmu: Don't require refcounted "struct page" to create huge
    SPTEs
  KVM: x86/mmu: Document the "rules" for using host_pfn_mapping_level()
  KVM: x86/mmu: Don't bottom out on leafs when zapping collapsible SPTEs
  KVM: selftests: Add an option to run vCPUs while disabling dirty
    logging

 arch/x86/kvm/mmu/mmu.c                        | 65 ++++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h               |  2 +-
 arch/x86/kvm/mmu/tdp_iter.c                   |  9 ---
 arch/x86/kvm/mmu/tdp_iter.h                   |  1 -
 arch/x86/kvm/mmu/tdp_mmu.c                    | 61 ++++++++---------
 .../selftests/kvm/dirty_log_perf_test.c       | 30 ++++++++-
 6 files changed, 94 insertions(+), 74 deletions(-)


base-commit: 8031d87aa9953ddeb047a5356ebd0b240c30f233
-- 
2.37.0.170.g444d1eabd0-goog

