Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428D2767A53
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbjG2AyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbjG2Axa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:53:30 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC6949EA
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbbc4ae328so20294965ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591922; x=1691196722;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIsPLR75IfB3JQf8Z+33pDlT1yw0PZd301tVrP5gvCM=;
        b=7KdGmMY5gKQGXEht2MsoPWA9VQxDB6g9aeZPGnmi8UB6DI3xtFVBM18gkZXW/z2TdV
         exnwvwBF7mluV4f39UE9b1r9i0aY4XbPDNhz5KPdG9yWBra6DITJTWp6HlZrSYtq1dxm
         mhKQysvgDZRdO8j+0kRrEbHrjxNj8y7kLNPI5UCtQS+poddT1ka1hPZY+OzgLEN1N2dx
         mZjzyx8/YekRbA4omz2PWpqFavfTZpv6wAT31EfvVbJoJNjhoV2BqJhmAxMjZ+N9P5Lr
         bRbWsQk61VBfePCSa8u1k2d19uDvEwGMiACuIzmWjddSPjKy+9vIQzCZIzgv43AmEKLA
         9QBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591922; x=1691196722;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lIsPLR75IfB3JQf8Z+33pDlT1yw0PZd301tVrP5gvCM=;
        b=Xhw4pe6GuyelQi0JZQiIfEwk5te0ySbeppS5eu7SxxXW60nmp0m27y5Uizu+gfRh8i
         upORcVKf8bHeDLD3pMrpVl2+5nr3N732OpBigAEf4x5ESQLEIs7+DuFZZwePbkP+TrRm
         Bvo1trN9QSJeNFS0rZx9vzY3sAemyFWuJTV4k0iw4nGW//x+LryDqZsnwB8WKZEwlt9c
         TxvYRwHNbXxDD5kkCCEMoyrpfZnMHnhwJjJ0vITCn8Nj53h+IS03fC6iUQUZ+F4NfVC8
         Or1OrpRPDTJs6xktBbMgRy9rgDpOfBR6JCbshI0qmRioC7WF3dlnGkzz7i+Rcx6wkjm9
         5p8Q==
X-Gm-Message-State: ABy/qLaugHDPZ/J9mGLP678gILy1DdMWbYfHPci7eQNKnNx/kW7FBKsF
        EUYfzIx6Z1J4spvgHKOSW9KXfvW6Ito=
X-Google-Smtp-Source: APBJJlEIGuf+haG75LZZltT1PSibJXhfNYwW3//NWO3PB616EzVgSvfA/VC0dlZt1FVbZU1DVrYdouho+YY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e80a:b0:1b8:5541:9d4d with SMTP id
 u10-20020a170902e80a00b001b855419d4dmr13713plg.6.1690591922733; Fri, 28 Jul
 2023 17:52:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:51:55 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729005200.1057358-1-seanjc@google.com>
Subject: [PATCH v2 0/5] KVM: x86/mmu: Don't synthesize triple fault on bad root
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RISK_FREE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the handling of !visible guest root gfns to wait until the guest
actually tries to access memory before synthesizing a fault.  KVM currently
just immediately synthesizes triple fault, which causes problems for nVMX
and nSVM as immediately injecting a fault causes KVM to try and forward the
fault to L1 (as a VM-Exit) before completing nested VM-Enter, e.g. if L1
runs L2 with a "bad" nested TDP root.

To get around the conundrum of not wanting to shadow garbage, load a dummy
root, backed by the zero page, into CR3/EPTP/nCR3, and then inject an
appropriate page fault when the guest (likely) hits a !PRESENT fault.

Note, KVM's behavior is still not strictly correct with respect to x86
architecture, the primary goal is purely to prevent triggering KVM's WARN
at will.  No real world guest intentionally loads CR3 (or EPTP or nCR3)
with a GPA that points at MMIO and expects it to work (and KVM has a long
and storied history of punting on emulated MMIO corner cases).

I didn't Cc any of this for stable because syzkaller is really the only
thing that I expect to care, and the whole dummy root thing isn't exactly
risk free.  If someone _really_ wants to squash the WARN in LTS kernels,
the way to do that would be to exempt triple fault shutdown VM-Exits from
the sanity checks in nVMX and nSVM, i.e. sweep the problem under the rug.

I have a KUT test for this that'll I'll post next week (I said that about
v1 and then forgot).

v2: 
 - Finish writing the changelog for patch 3. [Yu]
 - Use KVM_REQ_MMU_FREE_OBSOLETE_ROOTS instead of directly unloading
   all roots. [Yu]

v1: https://lore.kernel.org/all/20230722012350.2371049-1-seanjc@google.com

Sean Christopherson (5):
  KVM: x86/mmu: Add helper to convert root hpa to shadow page
  KVM: x86/mmu: Harden new PGD against roots without shadow pages
  KVM: x86/mmu: Harden TDP MMU iteration against root w/o shadow page
  KVM: x86/mmu: Disallow guest from using !visible slots for page tables
  KVM: x86/mmu: Use dummy root, backed by zero page, for !visible guest
    roots

 arch/x86/kvm/mmu/mmu.c          | 94 ++++++++++++++++++---------------
 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++
 arch/x86/kvm/mmu/paging_tmpl.h  | 18 ++++++-
 arch/x86/kvm/mmu/spte.h         | 12 +++++
 arch/x86/kvm/mmu/tdp_iter.c     | 11 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 6 files changed, 98 insertions(+), 49 deletions(-)


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

