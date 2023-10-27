Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306057D9ED6
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjJ0R0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjJ0R0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:26:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0824ECC
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 10:26:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81e9981ff4so1630517276.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 10:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698427602; x=1699032402; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oBWOHfBvaxwXi0Jkp0rLqN6I3Y0cRSLQixXEhIf+mK4=;
        b=FZa+BiAmHls0dUtUqIvmJ0ZYRYXc7qab4t9nO51PMITs3B19HaqhRydZl0wPVfU6ZV
         gL85my24A3oZms52080EYM1Md4E+61hkW0HTu/Ke4Vm16KsjPPvgQbA5ZN/BPTRNAOp8
         Rbk2jZViPfXMTpfS1AvzcqevXRt32zJ8Oiks+MMtKvk1uCnTp1Wf7iJW71v3V0Qfl2NV
         z6jbF21rH0/TjXA6UXzEH2Jz/lgx8YoAM9yn2rRAdgp0CfsQWDZ/guhl4oXaGDO99UGN
         njr9+9bq67KxyyMZJ4YhaR07X/H7EukRCkvRQhbkYIOpuHb+sfTG8Sb2W/TX7P3/vIOo
         UUbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698427602; x=1699032402;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oBWOHfBvaxwXi0Jkp0rLqN6I3Y0cRSLQixXEhIf+mK4=;
        b=F9x9hl3mSN96k8g4yV6BKWgazl9c1zkzAUXn0XhDpA156kszPN/Jji39/SMffuQazN
         N6OmMb30DqWF1ldnJyd1oL1f3Dlrl3yuRO0amS39aiSrQBdlAvL34QAxSEIIXfWIjOlY
         NQtj13LXG9sR9/jdHtENgDUFIxNfBfwWm1tQPR0w4IATxW6kcuBrS1ekAU7KQTbrX1AI
         1TgYnuByPVX2WIXx253aErErNkm9uHWO6WgeKM2DiI1KGYchO+BlbXxTWb9/TC9Renox
         OHmcNe8Mmqxv0pgNipN/73JKNStcuDuZsAmUckD3CB0Zj6/FjH3Jyf+0yg/I03YOoks8
         BukQ==
X-Gm-Message-State: AOJu0Yz8x4CzYIx3d+2bQX6zuAS4m8DP2cx2Hm2ShwxBfn3DnqleJyAx
        p74CcrL9SRC2C6r/8Yygodbth6Ow1KGyfw==
X-Google-Smtp-Source: AGHT+IH8Hb71YTLTQSL8RziND2+AkK8OVWvdBQCZdXMO4HqSSDQIZ/yRXXJLfPMq5CT181mZ9+yBLgfUK7DhlA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:c50c:0:b0:da0:c49a:5feb with SMTP id
 v12-20020a25c50c000000b00da0c49a5febmr57688ybe.4.1698427602158; Fri, 27 Oct
 2023 10:26:42 -0700 (PDT)
Date:   Fri, 27 Oct 2023 10:26:37 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027172640.2335197-1-dmatlack@google.com>
Subject: [PATCH 0/3] KVM: Performance and correctness fixes for CLEAR_DIRTY_LOG
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series reduces the impact of CLEAR_DIRTY_LOG on guest performance
(Patch 3) and fixes 2 minor bugs found along the way (Patches 1 and 2).

We've observed that guest performance can drop while userspace is
issuing CLEAR_DIRTY_LOG ioctls and tracked down the problem to
contention on the mmu_lock in vCPU threads. CLEAR_DIRTY_LOG holds the
write-lock, so this isn't that surprising. We previously explored
converting CLEAR_DIRTY_LOG to hold the read-lock [1], but that has some
negative consequences:

 - Pretty significant code churn is required on x86 and ARM to support
   doing CLEAR under the read-lock. Things get especially hairy on x86
   when considering how to support the Shadow MMU.

 - Holding the read-lock means KVM will have to use atomic
   compare-and-exchange operations during eager splitting and clearing
   dirty bits, which can be quite slow on certain ARM platforms.

This series proposed an alternative (well, complimentary, really)
approach of simply dropping mmu_lock more frequently. I tested this
series out with one of our internal Live Migration tests where the guest
is running MySQL in a 160 vCPU VM (Intel Broadwell host) and it
eliminates the performance drops we were seeing when userspace issues
CLEAR ioctls. Furthermore I don't see any noticeable improvement when I
test with this series plus a prototype patch convert CLEAR to the read
lock on x86. i.e. It seems we can eliminate most of the lock contention
by just dropping the lock more frequently.

Cc: Vipin Sharma <vipinsh@google.com>

[1] https://lore.kernel.org/kvm/20230602160914.4011728-1-vipinsh@google.com/

David Matlack (3):
  KVM: x86/mmu: Fix off-by-1 when splitting huge pages during CLEAR
  KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit in the TDP
    MMU
  KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG

 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
 virt/kvm/kvm_main.c        | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)


base-commit: 2b3f2325e71f09098723727d665e2e8003d455dc
-- 
2.42.0.820.g83a721a137-goog

