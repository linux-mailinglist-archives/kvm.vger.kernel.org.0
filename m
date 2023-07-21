Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F04E75D7B6
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjGUXAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGUXAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:00:11 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E8B3A8C
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b9de7951easo14333875ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689980410; x=1690585210;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRpmM2jj/hlD9zn4KXUWJJ0DXD5l3XPrTy7EQ8BSFM0=;
        b=R4cXu6oJUn5piVAk+Ojaz/Iff4NUz3w3kQypdkTlKTEAmzcUbg1ZSq/gbQiqbLMj2z
         yAATYAtjfQ/eH+vbOR01gexXmEaJnId0LkV8KJtQiTcL3rc1PGOGRFOZ+VfIvZJS2O2y
         v8eafe6JZ/Sm2Rh4U5uG6KbKCZgRMs5ml3zRO3wMtofE3549n4MWdhshri6tKCVbI3oZ
         MQYpmkcZS4AtA4qcE4XxD/xSoVoEoqopTPrlSF/jvesACRdiK31lE3H3YITFcrTXyOHZ
         Jvz+1WXhkXSmIW2zQF0KByfrQhDd9ij9hULCbB2UfoekPs2iooLM6IMFNJcQ1ceoco4R
         O2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689980410; x=1690585210;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dRpmM2jj/hlD9zn4KXUWJJ0DXD5l3XPrTy7EQ8BSFM0=;
        b=N65NMQ7mjAS+Xm9eHQnAanwKN0dPljYZG/a9gqRcTDGChqqGNL6B95BqDj2g9W26UW
         Yt7FPc6cpLB+5xiPA3muG7VfgK5c73zZ0AZ1IvYdNnfU05QQe3ZVTA10B0NMeobgC1ru
         Ch3wnyC/3DuHqH8snGpPlULfNM5YaF5xl6GGEYfeJfbP7nntQew+tD469q7xbhdVL46+
         uM0Ju/zAN2/XNpMCotvCMVZpyMp6PcNY5Of2ZdLziCizv2qrSTbb4p4td0kK+xbJA2KW
         S8SCx/gWPXqwjxG9b640EAOSIZwo5EP0tD1qUWfn1pVTv5Yp0G8lzF/b3Cmf2MF4ELHh
         cXVQ==
X-Gm-Message-State: ABy/qLbLsR6s95xLNhD6UAI6X2Gii9RY1VtBIJ2MNuUTt2UAi1BhLKQ4
        fe+3kz+oJlvVtksL5EfTnUWurxuv9Ss=
X-Google-Smtp-Source: APBJJlGh5bZf5WqK6t5lO8L4JKMy25XH31t2i60fPlyMSg5DS2TejZYnahjUpeYy7Mt2nMCplUVTk4oiiFQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c9:b0:1b9:df8f:888c with SMTP id
 e9-20020a17090301c900b001b9df8f888cmr11726plh.8.1689980410094; Fri, 21 Jul
 2023 16:00:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 15:59:57 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721230006.2337941-1-seanjc@google.com>
Subject: [PATCH v2 0/9] KVM: x86/mmu: Clean up MMU_DEBUG and BUG/WARN usage
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series consist of three loosely related miniseries:

 1. Remove the noisy prints buried behind MMU_DEBUG, and replace MMU_DEBUG
    with a KVM_PROVE_MMU Kconfig.

 2. Use WARN_ON_ONCE() for all runtime WARNs, i.e. avoid spamming the
    kernel log if something goes awry in the MMU.

 3. Demote BUG() usage in the shadow MMU to KVM_BUG_ON() when the kernel
    is built with CONFIG_BUG_ON_DATA_CORRUPTION=n.


v2:
 - Collect a review. [Mingwei]
 - Call out the more obvious path to FNAME(walk_addr_generic) in patch 6. [David]
 - Use BUILD_BUG_ON_INVALID() for the stub. [David]

v1: https://lore.kernel.org/all/20230511235917.639770-1-seanjc@google.com

Mingwei Zhang (1):
  KVM: x86/mmu: Plumb "struct kvm" all the way to pte_list_remove()

Sean Christopherson (8):
  KVM: x86/mmu: Delete rmap_printk() and all its usage
  KVM: x86/mmu: Delete the "dbg" module param
  KVM: x86/mmu: Rename MMU_WARN_ON() to KVM_MMU_WARN_ON()
  KVM: x86/mmu: Convert "runtime" WARN_ON() assertions to WARN_ON_ONCE()
  KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode without PAE
    enabled
  KVM: x86/mmu: Replace MMU_DEBUG with proper KVM_PROVE_MMU Kconfig
  KVM: x86/mmu: Use BUILD_BUG_ON_INVALID() for KVM_MMU_WARN_ON() stub
  KVM: x86/mmu: BUG() in rmap helpers iff
    CONFIG_BUG_ON_DATA_CORRUPTION=y

 arch/x86/kvm/Kconfig            |  13 ++++
 arch/x86/kvm/mmu/mmu.c          | 127 ++++++++++++++------------------
 arch/x86/kvm/mmu/mmu_internal.h |  12 +--
 arch/x86/kvm/mmu/page_track.c   |  16 ++--
 arch/x86/kvm/mmu/paging_tmpl.h  |  16 +++-
 arch/x86/kvm/mmu/spte.c         |   4 +-
 arch/x86/kvm/mmu/spte.h         |   8 +-
 arch/x86/kvm/mmu/tdp_iter.c     |   4 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  28 +++----
 include/linux/kvm_host.h        |  19 +++++
 10 files changed, 134 insertions(+), 113 deletions(-)


base-commit: 294ebdda1560d3eb515da88b805ba7f88eb28d21
-- 
2.41.0.487.g6d72f3e995-goog

