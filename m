Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4989465F8B9
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbjAFBNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbjAFBNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:15 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789A372D01
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:14 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v13-20020a25ab8d000000b007b54623bf71so449356ybi.2
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exXmbXtQOvjtL6oDSNpvthzMuaVH9c6hK6Io7Q3H2PQ=;
        b=Gd2Hc3yAemxhyPG2YJom6CSzPSNwdfYGbmw+Li60o3dSnVKYx0XiVKd0icK+AHEuIk
         cr5aDPLRFr/2CT8g2JuA15L4l7Yr9Gv+v4vZE6abq951XP07mH9FmjQbtRMeGxHWqvA1
         6+okIXdOG0GcP9+YnE6ajjTn+vj+n3TIqQsyXKSyK3fVAN1scHB4o95WZ7LLHrHJWChj
         mEF6ZpF8Noq7jcrGsh7Tig0G45woaqJy6021lf/DM3NZxjaWBpvN9MYJxWV6PInswNb4
         P5I7cDsWcUr4lBnWnASkz0clzoO1ftn9eCbP+0lbwF3aW8mGbteLdVvaygR51AERV6qs
         dstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exXmbXtQOvjtL6oDSNpvthzMuaVH9c6hK6Io7Q3H2PQ=;
        b=lafQnow6u4xp+tVUMwYv4sA+cIogaZCEcOYGADoxc3aFi2ft/YYzNy6lWz/CMO5Zny
         9ZSXxDGOPY74AvOXVOHK1VkB+G/1/gly62YIwBWg9Pa4oDXxudGDx7WPONH4vSZVe/Vv
         2N6jAHU9Ag5IvxHaaYdstis2b6wiGJtjPAK2u1y1ftmFmAbryrZdgBeK/vg5x0e4mzfL
         sJVfbhu8vRyy5RfI9AEL8dRjTdYfI3UiUfkaKg4DESpV30mBb4eiEAa8YUCvcgGHABxy
         20QjwOVopr7sLYaAWz1kTTAxe4WBKiyLtVP6O9J3usX1hJIaHnv9JuSYUC366uKZmHly
         m3QQ==
X-Gm-Message-State: AFqh2koIHal8SoJyIo2oxq3nNVKFhlM+/fV0AGlAWFW0PbcgR8Y0soSG
        hKjQ7nsxRaWW5DnqRso2uvqMFitQlUM=
X-Google-Smtp-Source: AMrXdXtta04aQhy7QBNY7oPlWzJPsXfi2+xs0akHqXF92W/veVVbnwfRL4McCB4DkElSKPuingj0Yr4c+L8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2e47:0:b0:722:fd7a:94c4 with SMTP id
 b7-20020a252e47000000b00722fd7a94c4mr3420610ybn.607.1672967593768; Thu, 05
 Jan 2023 17:13:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-1-seanjc@google.com>
Subject: [PATCH v5 00/33] KVM: x86: AVIC and local APIC fixes+cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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

Paolo,

This is a wholesale (and hopefully a drop-in) replacement for the patches
in `kvm-lapic-fix-and-cleanup`.  The changes for " KVM: x86: Inhibit APIC
memslot if x2APIC and AVIC are enabled" in v5 are relatively minor, but it
led to multiple conflicts in later patches, i.e. a patch-to-be-squashed
wasn't going to work.  Let me know if you've already done a lot of
massaging on your side, shouldn't be too difficult to generate patches to
go on top.

The first half or so patches fix semi-urgent, real-world relevant APICv
and AVIC bugs.

The second half fixes a variety of AVIC and optimized APIC map bugs
where KVM doesn't play nice with various edge cases that are
architecturally legal(ish), but are unlikely to occur in most real world
scenarios

v5:
  - Fix even more bugs! [Greg]
  - Collect reviews. [Maxim]
  - Don't use an inhibit flag for hybrid AVIC. [Maxim]
  - Fix an LDR cluster calc goof in the AVIC code. [Maxim]
  - Drop a redundant "ldr == 0" check. [Maxim]
  - Add helpers for logical vs. physical optimized map calcs. [Maxim]

v4:
  - https://lore.kernel.org/all/20221001005915.2041642-1-seanjc@google.com
  - Fix more bugs! [Alejandro]
  - Delete APIC memslot to inhibit xAVIC acceleration when x2APIC is
    enabled on AMD/SVM instead of using a "partial" inihbit. [Maxim]

v3:
  - https://lore.kernel.org/all/20220920233134.940511-1-seanjc@google.com
  - Collect reviews. [Paolo]
  - Drop "partial" x2APIC inhibit and instead delete the memslot.
    [Maxim, Suravee]
  - Skip logical mode updates for x2APIC, which just reuses the
    phys_map with some clever logic. [Suravee]
  - Add a fix for "nodecode write" traps. [Alejandro]

v2:
  - https://lore.kernel.org/all/20220903002254.2411750-1-seanjc@google.com
  - Collect reviews. [Li, Maxim]
  - Disable only MMIO access when x2APIC is enabled (instead of disabling
    all of AVIC). [Maxim]
  - Inhibit AVIC when logical IDs are aliased. [Maxim]
  - Tweak name of set_virtual_apic_mode() hook. [Maxim]
  - Straight up revert logical ID fastpath mess. [Maxim]
  - Reword changelog about skipping vCPU during logical setup. [Maxim]
  - Fix LDR updates on AVIC. [Maxim?]
  - Fix a nasty ISR caching bug.
  - Flush TLB when activating AVIC.

v1: https://lore.kernel.org/all/20220831003506.4117148-1-seanjc@google.com

Greg Edwards (1):
  KVM: x86: Allow APICv APIC ID inhibit to be cleared

Sean Christopherson (31):
  KVM: x86: Blindly get current x2APIC reg value on "nodecode write"
    traps
  KVM: x86: Purge "highest ISR" cache when updating APICv state
  KVM: SVM: Flush the "current" TLB when activating AVIC
  KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid
    target
  KVM: x86: Don't inhibit APICv/AVIC on xAPIC ID "change" if APIC is
    disabled
  KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is due to
    32-bit ID
  KVM: SVM: Don't put/load AVIC when setting virtual APIC mode
  KVM: x86: Handle APICv updates for APIC "mode" changes via request
  KVM: x86: Move APIC access page helper to common x86 code
  KVM: x86: Inhibit APIC memslot if x2APIC and AVIC are enabled
  KVM: SVM: Replace "avic_mode" enum with "x2avic_enabled" boolean
  KVM: SVM: Compute dest based on sender's x2APIC status for AVIC kick
  Revert "KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when
    possible"
  KVM: SVM: Document that vCPU ID == APIC ID in AVIC kick fastpatch
  KVM: SVM: Add helper to perform final AVIC "kick" of single vCPU
  KVM: x86: Explicitly skip optimized logical map setup if vCPU's LDR==0
  KVM: x86: Explicitly track all possibilities for APIC map's logical
    modes
  KVM: x86: Skip redundant x2APIC logical mode optimized cluster setup
  KVM: x86: Disable APIC logical map if logical ID covers multiple MDAs
  KVM: x86: Disable APIC logical map if vCPUs are aliased in logical
    mode
  KVM: x86: Honor architectural behavior for aliased 8-bit APIC IDs
  KVM: x86: Inhibit APICv/AVIC if the optimized physical map is disabled
  KVM: SVM: Inhibit AVIC if vCPUs are aliased in logical mode
  KVM: SVM: Always update local APIC on writes to logical dest register
  KVM: SVM: Update svm->ldr_reg cache even if LDR is "bad"
  KVM: SVM: Require logical ID to be power-of-2 for AVIC entry
  KVM: SVM: Handle multiple logical targets in AVIC kick fastpath
  KVM: SVM: Ignore writes to Remote Read Data on AVIC write traps
  Revert "KVM: SVM: Do not throw warning when calling avic_vcpu_load on
    a running vcpu"
  KVM: x86: Track required APICv inhibits with variable, not callback
  KVM: x86: Add helpers to recalc physical vs. logical optimized APIC
    maps

Suravee Suthikulpanit (1):
  KVM: SVM: Fix x2APIC Logical ID calculation for
    avic_kick_target_vcpus_fast

 Documentation/virt/kvm/x86/errata.rst |  11 +
 arch/x86/include/asm/kvm-x86-ops.h    |   1 -
 arch/x86/include/asm/kvm_host.h       |  52 +++-
 arch/x86/kvm/lapic.c                  | 319 +++++++++++++++++-----
 arch/x86/kvm/lapic.h                  |   2 +
 arch/x86/kvm/svm/avic.c               | 372 ++++++++++++--------------
 arch/x86/kvm/svm/nested.c             |   2 +-
 arch/x86/kvm/svm/svm.c                |   8 +-
 arch/x86/kvm/svm/svm.h                |  27 +-
 arch/x86/kvm/vmx/vmx.c                |  58 +---
 arch/x86/kvm/x86.c                    |  29 +-
 11 files changed, 524 insertions(+), 357 deletions(-)


base-commit: c04ec04c0d15a51aa33660be175ed978beb8de0c
-- 
2.39.0.314.g84b9a713c41-goog

