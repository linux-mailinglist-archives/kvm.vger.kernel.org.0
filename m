Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2367D720CAF
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 02:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbjFCAwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 20:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjFCAwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 20:52:20 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A83E43
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 17:52:18 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53fa2d0c2ebso1016335a12.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 17:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685753538; x=1688345538;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oe9m8q/9Z39HfvtXGbxIcrFtaXbrUYLbQgSUVxS+WE=;
        b=D2IFseIoBlLReHmp2AP52P23Iew40HfDaL/gX2YxKZcck6U+3dd/dMK5015txQPcA/
         FszJ5ostyFPSp9qsi3uOAOsCKYccO1zhzi5ltaKmnSiOOO8BtY6RMVbNWu8jLMtA1D18
         vnu0c9A/Vn4lVxjWkFRbU9xTT71uW9/QFkincb56ySh4e8fGVwTQGTs/05VkZ314fNel
         RmdWSsdpunWjAHSMClE/0OoGmiJr5+Q6iXSMQxjSyOAHEpXYyQyh+V2oH3Km5wCUufxe
         4cchDKFXhigWZgv0fPd0q4JPfPRmIFdFZ/9CzPU5OJmEAiUJwNc3jZvcp1s+stOS7lHJ
         QYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685753538; x=1688345538;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9oe9m8q/9Z39HfvtXGbxIcrFtaXbrUYLbQgSUVxS+WE=;
        b=lVFqAVQMJtVfTUutFookkXeO67/5GvPjVc3WCBerySwoFm7zplMjTJbPp+ZIxMkgcf
         wOVm4qjH7rpwA3PFW/BcPB0LuDn2aslHs02I0qynJhcA+duzy+9kWUrG8WK/nr4ZaiQi
         nR7v3zYJPjIejJSYTQD8HFXPsXEIRLothS5zg08tZ5PU0zI2d0974Sws6Uha/lpeQi5c
         Z7wdC2YXMLlSMjVMD0ZOh6/49bhhD+tTN3WMSI+UPM6CbS+kMrva07Av+jOFJxjYU7Dl
         OAvr8vKsJ4LhM4FMaUoLI17MtYfZyJ263Uo/xIf7JaCn4cv3GGLphbsrKzNr3omcxMQS
         ARNw==
X-Gm-Message-State: AC+VfDyVL6aXzxOHwoiviGjx70KIfIsJT1lr0rR51uh96aS1mjQGqkFj
        PBZpj2H6fu3zYiH/vaQiH+DHfBKpaCA=
X-Google-Smtp-Source: ACHHUZ7+rUqzo7xqa+ki5wlAxw3Zvo+RiDUi/feJsh3LUYWCojW8lV1HTsyD47VOxyZdPkCaB++ltIlLjig=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4617:b0:256:b3d0:f2f0 with SMTP id
 w23-20020a17090a461700b00256b3d0f2f0mr339835pjg.2.1685753538386; Fri, 02 Jun
 2023 17:52:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 17:52:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603005213.1035921-2-seanjc@google.com>
Subject: KVM: x86: Fixes for 6.4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
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

Please pull a few x86 fixes for 6.4.  Nothing ridiculously urgent, but the
vNMI fix in particular would be nice to get in 6.4.

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.4

for you to fetch changes up to 47d2804bc99ca873470df17c20737b28225a320d:

  KVM: selftests: Add test for race in kvm_recalculate_apic_map() (2023-06-02 17:21:06 -0700)

----------------------------------------------------------------
KVM x86 fixes for 6.4

 - Fix a memslot lookup bug in the NX recovery thread that could
   theoretically let userspace bypass the NX hugepage mitigation

 - Fix a s/BLOCKING/PENDING bug in SVM's vNMI support

 - Account exit stats for fastpath VM-Exits that never leave the super
   tight run-loop

 - Fix an out-of-bounds bug in the optimized APIC map code, and add a
   regression test for the race.

----------------------------------------------------------------
Maciej S. Szmigiero (1):
      KVM: SVM: vNMI pending bit is V_NMI_PENDING_MASK not V_NMI_BLOCKING_MASK

Michal Luczaj (1):
      KVM: selftests: Add test for race in kvm_recalculate_apic_map()

Sean Christopherson (3):
      KVM: x86/mmu: Grab memslot for correct address space in NX recovery worker
      KVM: x86: Account fastpath-only VM-Exits in vCPU stats
      KVM: x86: Bail from kvm_recalculate_phys_map() if x2APIC ID is out-of-bounds

 arch/x86/kvm/lapic.c                               | 20 +++++-
 arch/x86/kvm/mmu/mmu.c                             |  5 +-
 arch/x86/kvm/svm/svm.c                             |  2 +-
 arch/x86/kvm/x86.c                                 |  3 +
 tools/testing/selftests/kvm/Makefile               |  1 +
 .../selftests/kvm/x86_64/recalc_apic_map_test.c    | 74 ++++++++++++++++++++++
 6 files changed, 101 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c
