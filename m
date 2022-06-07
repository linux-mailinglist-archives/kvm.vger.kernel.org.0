Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B2A54218B
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443682AbiFHBAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574444AbiFGXZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:25:44 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13F522DFBE
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o8-20020a17090a9f8800b001dc9f554c7fso9801851pjp.4
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=nx+NHoagUTMXpTWLS6nBCzRagrM6AprX1ic8KXLR0FQ=;
        b=KtYNddCXipsCxfZPlYIrROqzMf4VfQUpQ7W4eTiQczc1T53T4h7qOXhIIs89QqOWNG
         LPjzPOO5PTOHfPz22rVbKMRnf7mGiTZwlhzfEvI6mbtzGEkgLSGkO2LEPDtBerkLBOjh
         D6/zW73UmBBCZyxNHxzie9fQQX0K35UHpIQybHBcF+0WhIlueyc6Fruq6HHXLsxfBCx9
         EvHgOUKPotMcnYQdIqVG0FBm3EvFSVpg7lOn2sAQFPzXgAtckDr8NltPQcn7LO6JVZM7
         QyYHMq5pHplrLaksdi0Wp0I8qRyKtJp8r6wWD91qOZP54TuSTe5uS4eiPZSEDNk+/o6e
         ItqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=nx+NHoagUTMXpTWLS6nBCzRagrM6AprX1ic8KXLR0FQ=;
        b=nV3td+o+5LjvzHziIMfpvb3Z9U3CqQT1hAsAQ5UN8qsMSXlW9gb+EEjcZxLiOKnoQO
         /45hGEwWZkwpzT6y27meyc5Up+55T3Jbct6pbtPmzLf7UPnLKmO2qvSlxipPRlCDuHof
         dfqUtZdj2ikBLzLI3yA75DYZWwMF90w9bb7GRs/1XllCc0s3tu5CtWyoQnQb7ayiQJPn
         Wf+r5fTLdsXy+Ze5NN9FbY4mgKks7vyR2EMdWqJU32xXo9zbV8RKM3KNjPpCJ1IYP0d6
         S3V7xYfipalEVLZ9uJLCTuhAZ0nU2sYqxUjTG9yTRBoZs1a0B6yPUvojeTsjPnRrnLU9
         y2lw==
X-Gm-Message-State: AOAM530/FIto/9fPnf0111bgQO2F3GdBFcYjllAsz6Ao+s6LqFrBQBWt
        DS9HlTjqQ2GQ6h8Bw30EiwmpgO/BSYQ=
X-Google-Smtp-Source: ABdhPJzvgfJQivUwNYRvpJCgJfIE60FoBiPf/9jOB7Bo9q3ATZQV+PwKPdSQTp+PMSSeTAfz8mfc6MiODKU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:89c2:0:b0:3fc:8bd2:aa5a with SMTP id
 v185-20020a6389c2000000b003fc8bd2aa5amr26943571pgd.362.1654637777287; Tue, 07
 Jun 2022 14:36:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:49 +0000
Message-Id: <20220607213604.3346000-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 00/15]  KVM: nVMX: VMX MSR quirk+fixes, CR4 fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Resurrecting Oliver's series to quirk nVMX's manipulation of the VMX MSRs.

KVM has a quirk where nVMX overwrites select VMX MSR bits in response to
CPUID updates.  Specifically, KVM forces CR{0,4}_FIXED1 bits and the
VM-Entry/VM-Exit control bits for BNDCFGS and PERF_GLOBAL_CTRL to align
with the guest vCPU model.  Add a quirk to (a) allow userspace to opt out
of the existing behavior and (b) make it clear the the existing behavior
should not be propagated to new features.

Patches 0-4 are tangentially related fixes for correctly handling CR4
checks on nested VMXON and VM-Enter.  They are included here because there
is a subtle dependency created by the fix in patch 02, as it changes the
resulting behavior of patch 10, "Extend VMX MSRs quirk to CR0/4 fixed1 bits".

Patch 05 fixes a bug where KVM forces incoming VMX MSR values to be a
subset of _current_ value, not of KVM's support valu.  E.g. if userspace
clears an allowed-1 bit, it can never set that bit back to the original
value.

Patch 06, "Keep KVM updates to BNDCFGS ctrl bits across MSR write", fixes
a related bug where KVM's original quirky behavior kept the VMX MSRs
up-to-date (almost) all the time.

This series is technically based on my selftests overhaul[*], but practically
speaking that only affects the selftests.  The KVM should apply cleanly on
kvm/queue, 55371f1d0c01 ("KVM: x86/pmu: Update global ...")

I have a KUT test for patch 3 (VMXON fixes) that I'l post separately (yet
more cleanup involved, ugh).  I spot tested patch 2 by fudging PKU in guest
CPUID, but I'm not planning on submitting an official test anywhere (though
it could be done without too much pain in selftests).

v5:
 - Rebase (see above).
 - Fix "CR4 valid for nVMX" bugs.
 - Modify PERF_GLOBAL_CTRL bits iff the MSR exists.
 - Fix a bug where KVM doesn't allow userspace to restore VMX MSRs to
   _KVM's_ allowed values.
 - Fix the UMIP emulation goof.
 - Extend the quirk to CR0/4_FIXED1 MSRs.
 - Add a helper to identify if the vCPU has a vPMU.
 - Rewrote the selftests to more exhaustively test combos, and to test
   the aforementioned bugs fixed in v5.

v4:
 - https://lore.kernel.org/all/20220301060351.442881-1-oupton@google.com
 - Rebased to kvm/queue. Avoids conflicts with new CAPs and commit
   0bcd556e15f9 ("KVM: nVMX: Refactor PMU refresh to avoid referencing
   kvm_x86_ops.pmu_ops") on kvm/queue.
 - Grabbed KVM_CAP_DISABLE_QUIRKS2 patch, since this series also
   introduces a quirk.
 - Fix typo in KVM_CAP_DISABLE_QUIRKS2 documentation (Sean)
 - Eliminated the need to refresh 'load IA32_PGC' bits from PMU refresh.
 - Use consistent formatting to make test cases more easily readable
   (David Dunn)
 - Use correct 'Fixes: ' tag and correct a typo in Patch 2 changelog.

Oliver Upton (4):
  KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits across MSR write
  KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL ctrl bits across MSR
    write
  KVM: nVMX: Drop nested_vmx_pmu_refresh()
  KVM: nVMX: Add a quirk for KVM tweaks to VMX MSRs

Sean Christopherson (11):
  KVM: x86: Split kvm_is_valid_cr4() and export only the non-vendor bits
  KVM: nVMX: Account for KVM reserved CR4 bits in consistency checks
  KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4
  KVM: nVMX: Rename handle_vm{on,off}() to handle_vmx{on,off}()
  KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value
  KVM: VMX: Add helper to check if the guest PMU has PERF_GLOBAL_CTRL
  KVM: nVMX: Set UMIP bit CR4_FIXED1 MSR when emulating UMIP
  KVM: nVMX: Extend VMX MSRs quirk to CR0/4 fixed1 bits
  KVM: selftests: Add test to verify KVM's VMX MSRs quirk for controls
  KVM: selftests: Extend VMX MSRs test to cover CR4_FIXED1 (and its
    quirks)
  KVM: selftests: Verify VMX MSRs can be restored to KVM-supported
    values

 Documentation/virt/kvm/api.rst                |  29 ++
 arch/x86/include/asm/kvm_host.h               |   3 +-
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/svm/nested.c                     |   3 +-
 arch/x86/kvm/vmx/nested.c                     | 199 ++++++------
 arch/x86/kvm/vmx/nested.h                     |   5 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |   7 +-
 arch/x86/kvm/vmx/vmx.c                        |  23 +-
 arch/x86/kvm/vmx/vmx.h                        |  14 +
 arch/x86/kvm/x86.c                            |  12 +-
 arch/x86/kvm/x86.h                            |   2 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   8 +
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 287 ++++++++++++++++++
 16 files changed, 493 insertions(+), 104 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c


base-commit: 081ad4bbae8d503c79fae45f463766d28b2f3241
-- 
2.36.1.255.ge46751e96f-goog

