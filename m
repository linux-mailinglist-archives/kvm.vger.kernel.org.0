Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB325F17B2
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 02:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiJAA7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 20:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiJAA7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 20:59:19 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C35E1AF90F
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:18 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id w2-20020a63c102000000b004460a972e2eso360950pgf.20
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=IEw5G2qujD55HD5h3EfWDl1MiMOqerRDvpnM2nMplCk=;
        b=Dvnz3JFshZOJwIy0b3mP7xKoNcbiZ6YVV7fsAoGTG8SRozCeT4+refwkv+0yEy0Qp0
         hkY64m55xf/J/x5gvPEzfwqu1RbBSZLvrVaak4xx9YAb8Zwyvzd06JJPULdkIiYTLmb3
         HH/CZf9bFEm5yio8GKOX1KZzFDJTMlXJkrEE7J0kQxBNcen16Z1NQ8RncP4LCx0YX+PH
         ED2bTM/OH22qzCgDVhy5Wvb6mXOOcnVjPUS4QlYWg5cnuBCRupsTWOl8D/TV/9ZRmF7b
         IOxAkJuHR0VMTzy63RBZI3Q0r+Bu2SrCwSFbPxeqFlTvgCOOD7yeCHzpoB6nHutGy5AW
         zGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IEw5G2qujD55HD5h3EfWDl1MiMOqerRDvpnM2nMplCk=;
        b=6hfkFSDTbPa6UdhpAEwhHXJbJgHowO2jBsmV4zUXLy04JUYdrKVHwAO9VaVCktJ2NT
         v7umR4m/IkVhS+qHbbPoXhYfbNEbOatTTdYUBNQw79qv7ck0vB2vZPjQiPUcHwjBSJng
         M5UjMUSLBucTwbXfNMXeJr12EV3RtOsbj0Z4qlH33wMqeKnN1leXjCRpcoeXF99XOThh
         BKylh7PLqCrZts6iID+0IlpjeRpA6aB3ajwi7buyPT6ABmIXkic2sAU6zs1/RK4egywf
         JayfJqQM7bN6yY63q6V5GSPNl95x3O7xWiGIrEcZycDfALT2BnDthlJR7ydfkAcVWvS3
         MMCA==
X-Gm-Message-State: ACrzQf3fYiMaiEZevdTxrYSlJq2JcW5GRO/JEaj7Sy7QZluTLLgvmnVR
        M2sOOd6NDqm00AXopDC81gIRoVyxhQM=
X-Google-Smtp-Source: AMsMyM6lA2JugpVraqP648gHmu+caNa9YJFeb6DBggUxovRA5KE9641omOj6s/0e3p5p9E3Jc3LUMlog0nI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:230a:b0:17d:707a:360e with SMTP id
 d10-20020a170903230a00b0017d707a360emr1518920plh.118.1664585957876; Fri, 30
 Sep 2022 17:59:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-1-seanjc@google.com>
Subject: [PATCH v4 00/32] KVM: x86: AVIC and local APIC fixes+cleanups
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

The first half or so patches fix semi-urgent, real-world relevant APICv
and AVIC bugs.

The second half fixes a variety of AVIC and optimized APIC map bugs
where KVM doesn't play nice with various edge cases that are
architecturally legal(ish), but are unlikely to occur in most real world
scenarios

I have tested this heavily with KUT, but I haven't booted Windows and
don't have access to x2AVIC, so as usual, additional testing would be
much appreciated.

v4:
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

Sean Christopherson (31):
  KVM: x86: Blindly get current x2APIC reg value on "nodecode write"
    traps
  KVM: x86: Purge "highest ISR" cache when updating APICv state
  KVM: SVM: Flush the "current" TLB when activating AVIC
  KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid
    target
  KVM: x86: Don't inhibit APICv/AVIC on xAPIC ID "change" if APIC is
    disabled
  KVM: x86: Track xAPIC ID only on userspace SET, _after_ vAPIC is
    updated
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

Suravee Suthikulpanit (1):
  KVM: SVM: Fix x2APIC Logical ID calculation for
    avic_kick_target_vcpus_fast

 Documentation/virt/kvm/x86/errata.rst |  11 +
 arch/x86/include/asm/kvm-x86-ops.h    |   1 -
 arch/x86/include/asm/kvm_host.h       |  55 +++-
 arch/x86/kvm/lapic.c                  | 238 +++++++++++++---
 arch/x86/kvm/lapic.h                  |   2 +
 arch/x86/kvm/svm/avic.c               | 375 ++++++++++++--------------
 arch/x86/kvm/svm/nested.c             |   2 +-
 arch/x86/kvm/svm/svm.c                |   6 +-
 arch/x86/kvm/svm/svm.h                |  28 +-
 arch/x86/kvm/vmx/vmx.c                |  58 +---
 arch/x86/kvm/x86.c                    |  23 +-
 11 files changed, 477 insertions(+), 322 deletions(-)


base-commit: c59fb127583869350256656b7ed848c398bef879
-- 
2.38.0.rc1.362.ged0d419d3c-goog

