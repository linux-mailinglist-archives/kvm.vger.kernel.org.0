Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582DA6ED399
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjDXRfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjDXRfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:35:51 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849C77A92
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-517bad1b8c5so4865630a12.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682357743; x=1684949743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wtcxECFPPFgEziyr4OGZIMrKuDHziKC4fzh3CgqSPK0=;
        b=1pktuMgpXIv/6YJUwGUgHXW5nXchU1m+NuXfD3hgc8Icm3Os2hWMNHKgLeQ1qRmode
         oWvS+UdmFOtkDJ8KjZxdg7E7esO9WlcILxycnkku0hpxmCo0Bmo+s3IDwvsnFIIJ54Aw
         0TmZxtIqATz9Im/WMRX1bRHAdlNASqurL4fIJS+3o0gMvhhvu48fKJ+ZZnBn5Q8phBgN
         iSsJvql1lQny39+9UG52p8qW/SrHHLO7vgaIqW1mrYIxDuConXEEeeJINk6OqfPp+nek
         3GDkt1lT/5yuXY9z85WP/ehzsOR8Eg4is5GxJeGwEeHcxgy6DubqybTJcNRZYKVjtfge
         /l5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682357743; x=1684949743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wtcxECFPPFgEziyr4OGZIMrKuDHziKC4fzh3CgqSPK0=;
        b=IEnTXe8qmoHCShmYI0W6TZIY/66y5zPhvkKZJiLTPBBI6E0GU3quHusMCmiqtgfuAQ
         0q69zCamg154g+VexL72fhp9bjfR7IjruI5rIPoGDXKBBiIKwYqJtwtxrlTCTP7NUrZk
         //8CdpCT1TiqFbbtf9sPtoBDIo4pAtG/XlmXHHTt/LojV2Pm2uWEIuGlN7YUT81It1bB
         eaTnRxnA4QKMq9NVgHpmSqa3iyHapZj15Sm0n8BJSrac9NtI53SC/E2NVJXh8Yrg9w0z
         QTgUPTLCDxKr2BvZH0ogo1WSnd0UgDg+PUSyEhJgBG05DTcMLuLgpRsevB4ZB5TGLJa4
         aj3g==
X-Gm-Message-State: AAQBX9cqBLdrcXA9wa52YTiqfi3LZAxSXZCvtb1LdT5uaeVZ4iAOOEFa
        udAZyO2ENYpDPYUYBYoDMc2dhEDuwUU=
X-Google-Smtp-Source: AKy350aMIKp+eOEdI63PRpDepLsTMxKDw0/LSUJLozpkOLURgRmyO5/Q0+sj4DPvi/fKcJZT/1UEqzMMQCQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5023:0:b0:514:1418:72f0 with SMTP id
 e35-20020a635023000000b00514141872f0mr3312463pgb.0.1682357743056; Mon, 24 Apr
 2023 10:35:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Apr 2023 10:35:27 -0700
In-Reply-To: <20230424173529.2648601-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424173529.2648601-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Selftests changes for 6.4
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

KVM x86 selftests change for 6.4.  And an AMX+XCR0 bugfix that I landed here
to avoid creating a mess of unnecessary conflicts between the series to
overhaul the AMX test and the related selftests changes to verify the fix.

The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7:

  KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:18:07 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.4

for you to fetch changes up to 20aef201dafba6a1ffe9daa145c7f2c525b74aae:

  KVM: selftests: Fix spelling mistake "perrmited" -> "permitted" (2023-04-14 10:04:51 -0700)

----------------------------------------------------------------
KVM selftests, and an AMX/XCR0 bugfix, for 6.4:

 - Don't advertisze XTILE_CFG in KVM_GET_SUPPORTED_CPUID if XTILE_DATA is
   not being reported due to userspace not opting in via prctl()

 - Overhaul the AMX selftests to improve coverage and cleanup the test

 - Misc cleanups

----------------------------------------------------------------
Aaron Lewis (9):
      KVM: selftests: Assert that XTILE is XSAVE-enabled
      KVM: selftests: Assert that both XTILE{CFG,DATA} are XSAVE-enabled
      KVM: selftests: Move XSAVE and OSXSAVE CPUID checks into AMX's init_regs()
      KVM: selftests: Check that the palette table exists before using it
      KVM: selftests: Check that XTILEDATA supports XFD
      KVM: x86: Add a helper to handle filtering of unpermitted XCR0 features
      KVM: selftests: Move XGETBV and XSETBV helpers to common code
      KVM: selftests: Add all known XFEATURE masks to common code
      KVM: selftests: Add test to verify KVM's supported XCR0

Ackerley Tng (1):
      KVM: selftests: Adjust VM's initial stack address to align with SysV ABI spec

Anish Moorthy (1):
      KVM: selftests: Fix nsec to sec conversion in demand_paging_test

Colin Ian King (1):
      KVM: selftests: Fix spelling mistake "perrmited" -> "permitted"

Hao Ge (1):
      KVM: selftests: Close opened file descriptor in stable_tsc_check_supported()

Ivan Orlov (1):
      KVM: selftests: Add 'malloc' failure check in vcpu_save_state

Like Xu (2):
      KVM: selftests: Add a helper to read kvm boolean module parameters
      KVM: selftests: Report enable_pmu module value when test is skipped

Mingwei Zhang (6):
      KVM: selftests: Add a fully functional "struct xstate" for x86
      KVM: selftests: Fix an error in comment of amx_test
      KVM: selftests: Enable checking on xcomp_bv in amx_test
      KVM: selftests: Add check of CR0.TS in the #NM handler in amx_test
      KVM: selftests: Assert that XTILE_DATA is set in IA32_XFD on #NM
      KVM: selftests: Verify XTILE_DATA in XSTATE isn't affected by IA32_XFD

Sean Christopherson (2):
      KVM: x86: Filter out XTILE_CFG if XTILE_DATA isn't permitted
      KVM: selftests: Rework dynamic XFeature helper to take mask, not bit

 arch/x86/kvm/cpuid.c                               |   2 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 arch/x86/kvm/x86.h                                 |  29 +++++
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/demand_paging_test.c   |   2 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |   1 +
 .../selftests/kvm/include/x86_64/processor.h       |  83 +++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  36 ++++--
 tools/testing/selftests/kvm/x86_64/amx_test.c      | 118 ++++++++----------
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |   1 +
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c       |   8 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   1 +
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c | 132 +++++++++++++++++++++
 14 files changed, 326 insertions(+), 97 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
