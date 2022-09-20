Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B155BF115
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiITXbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiITXbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:31:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28C14D81C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id p4-20020a17090a348400b00202c6d79591so2027728pjb.0
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=yLvwOWuXtYmkq2gfHjtQ1MhX2AnqJW1myBmVRg299oc=;
        b=pq7XJBM0vZ9KBqZnYoj2EMzf3D9IQDFghpRQZgnIbzKHdFWniBp/yKBOkw5BFcrgEG
         XmMR0TP7OiMzg0S/Bl1P16+d+VyB/TQfTxI8IOQiMHCw9M7Jta1HLVQNbpyZ1x9ON4PF
         TNyu5PyT1XzbZA9e/iPzPUXLdkZRsdWc4UVDdvx6YfGw8Pu6kvlrPpTkSr8iGQ15P1DP
         jrdVZOkcm8/P3ClTHMk4+Me4qwUYHIvAn/bUhM3SpvIyqef5WLyOKiOjNm72fwLLlb+f
         qSQBuJ4nh6g1593Cnnro7xFEq1Oy8hJtD2nS+MJkYwqJkf/bZSxq9DOlA8R8e9p3xfyG
         j8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yLvwOWuXtYmkq2gfHjtQ1MhX2AnqJW1myBmVRg299oc=;
        b=T5tfcdRGLpqrdm1lJQpHSZXjY5xMKCzeSgR8QVswKbm6+eeIQ2iSJxm3L6aXtg9aGv
         5I5uvP/e3fC5rDP4+kT1XQC7+DWJzGC8shlOd0V+b/j6tmzSJI8Wz7d6DWcoeSk/qxnO
         efoy0D+QEW+SVZV5ykqaqlYo2pZteA8XEYYMuT0vRLU5czlZg5CZLOpSOsg5AhGbVgzh
         2S1M62JcILndJiKQs5zbU8/oMIBN0/DDhoZrxdLD4BWKinWx3+/iD8yGG6rftjsU+PFO
         QbWaOtAJYGbo31+1OrLt2CcaKWSNrLOPAKgGaxPT6Wqmr6fmYcxWlV6vI1AfKPqUCOES
         hMKg==
X-Gm-Message-State: ACrzQf09OOIliE7fgz05LJR/iPY4UOTCI8gXvDFiSmZoyr/E8nTxzokA
        O0sDWBkoAims7VFTVX3ULOc3HUECxzI=
X-Google-Smtp-Source: AMsMyM4v+iUjgkKBatNGzl5ZdWlqUnuoLW9A6Q+ClVGzUcSTXacOuBjve8AEVYyvMQuC9dbVqnkg8JXNvyw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1942:b0:202:cf66:f37f with SMTP id
 nk2-20020a17090b194200b00202cf66f37fmr6235484pjb.15.1663716697425; Tue, 20
 Sep 2022 16:31:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:06 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-1-seanjc@google.com>
Subject: [PATCH v3 00/28] KVM: x86: AVIC and local APIC fixes+cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

TL;DR: KVM's AVIC and optimized APIC map code doesn't correctly handle
various edge cases that are architecturally legal(ish), but are unlikely
to occur in most real world scenarios.

I have tested this heavily with KUT, but I haven't booted Windows and
don't have access to x2AVIC, so additional testing would be much
appreciated.

v3:
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

Sean Christopherson (27):
  KVM: x86: Blindly get current x2APIC reg value on "nodecode write"
    traps
  KVM: x86: Purge "highest ISR" cache when updating APICv state
  KVM: SVM: Flush the "current" TLB when activating AVIC
  KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid
    target
  KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is due to
    32-bit ID
  KVM: x86: Move APIC access page helper to common x86 code
  KVM: x86: Inhibit APIC memslot if x2APIC and AVIC are enabled
  KVM: SVM: Don't put/load AVIC when setting virtual APIC mode
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

Suravee Suthikulpanit (1):
  KVM: SVM: Fix x2APIC Logical ID calculation for
    avic_kick_target_vcpus_fast

 Documentation/virt/kvm/x86/errata.rst |  11 +
 arch/x86/include/asm/kvm_host.h       |  51 +++-
 arch/x86/kvm/lapic.c                  | 224 +++++++++++++---
 arch/x86/kvm/lapic.h                  |   2 +
 arch/x86/kvm/svm/avic.c               | 363 ++++++++++++--------------
 arch/x86/kvm/svm/svm.c                |   4 +-
 arch/x86/kvm/svm/svm.h                |  11 +-
 arch/x86/kvm/vmx/vmx.c                |  36 +--
 arch/x86/kvm/x86.c                    |   7 +
 9 files changed, 426 insertions(+), 283 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.3.968.ga6b4b080e4-goog

