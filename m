Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD4459F1AA
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiHXDDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiHXDC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:02:56 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE9580024
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:41 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g9-20020a056a00078900b005366c5fa183so3504307pfu.12
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=r91HPYYSFxJTMnEEF3lOsKE2BxxHHOfpoW4lW10n2hI=;
        b=YLFmtV1Aa9GbipE/ETNTMxuY9ueT/8rwnpjs+PH17Oo9mXeApnc9/gr6d4sO4DqrVF
         eRkeSv8ZT19EZ84Km8xgl6Hx7l81c0W0/v5Dunm+WonMgpQAbcf/5BIlNqDJWM2SMsJN
         GNDTGORZJAdq3jxwAOXMBBTA+t6oYnLvEuwdSEzWqh7V9jArwaqlIT0wj8NbQgtRjtqM
         H907sRUgrJwnKFUuLLl4m63Rh8M2gTMZ8CB9Gdj4zgDQAAbA5gd/CV5Vao8X0TjTuZ6O
         Ldf68WV047iZrpE+lV+g0qO4peeI2lCjjKBgO3zqQNMJFKc+JcIAkALGSlykdWhgU3C4
         snqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=r91HPYYSFxJTMnEEF3lOsKE2BxxHHOfpoW4lW10n2hI=;
        b=3rlS0VRvWUXaZXFa7fDQ9pcxiu63WmxtMC00cTr+3lsKU2526guKCUXX6WFUl/FSWk
         8ljwunuJ0WzeAsu5QT5vX5iDIZA3WLlGBrnfCopGETO09xvStaXzw4PKJPK7LZNdS/Ny
         B/7ZAFFKQuZ0wTW7ebkRLkGdXeLsFKmyGPFOG9qkPW1kzWGrfc+ma6+YW2tCxryE/hQ0
         hbpvBTiWQjPUWy30EAvek8YydaYT3JAp1sOhCUcH493dAKFy/L8jDQJ9RBqFssKWGm3s
         6m7iHhPGeo+Qj0vceuhT3G2BZLhoY3FEO+BLh0jdCCbH5ptOTQObplpD0Z/axmLcV/yk
         Olbg==
X-Gm-Message-State: ACgBeo1fcBiTkta/2V6l4FXLbumnBsKDrwZSvxtshAzypmT4W5Z8P948
        7yj1DwPrt+zpTvQqfk2fN1NWH5VqMHc=
X-Google-Smtp-Source: AA6agR4Z4J5nWYOpFczf3c/pjLjed/4kSGGe0KAychpW+Qr+UZ+TfTCwsu25A4sCxRr99CeYwlVoImgz4wk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2c5:b0:172:d1f2:401d with SMTP id
 s5-20020a17090302c500b00172d1f2401dmr17622925plk.56.1661310100972; Tue, 23
 Aug 2022 20:01:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:02 +0000
Message-Id: <20220824030138.3524159-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 00/36] KVM: x86: eVMCS rework
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
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

This is what I ended up with as a way to dig ourselves out of the eVMCS
conundrum.  Not well tested, though KUT and selftests pass.  The enforcement
added by "KVM: nVMX: Enforce unsupported eVMCS in VMX MSRs for host accesses"
is not tested at all (and lacks a changelog).

I don't care if we add a new capability or extend the existing one, my goal
was purely to frame in the KVM internals and show _a_ way to let userspace
opt-in.  I do think we need something that isn't CPUID-based though.

Everything from patch 22 onwards should be unchanged from your v5.

Jim Mattson (1):
  KVM: x86: VMX: Replace some Intel model numbers with mnemonics

Sean Christopherson (10):
  KVM: x86: Check for existing Hyper-V vCPU in kvm_hv_vcpu_init()
  KVM: x86: Report error when setting CPUID if Hyper-V allocation fails
  KVM: nVMX: Treat eVMCS as enabled for guest iff Hyper-V is also
    enabled
  KVM: nVMX: Use CC() macro to handle eVMCS unsupported controls checks
  KVM: nVMX: Enforce unsupported eVMCS in VMX MSRs for host accesses
  KVM: nVMX: WARN once and fail VM-Enter if eVMCS sees VMFUNC[63:32] !=
    0
  KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to
    vmcs02
  KVM: nVMX: Always emulate PERF_GLOBAL_CTRL VM-Entry/VM-Exit controls
  KVM: VMX: Don't toggle VM_ENTRY_IA32E_MODE for 32-bit kernels/KVM
  KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not
    setup

Vitaly Kuznetsov (25):
  x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
  x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
  KVM: x86: Zero out entire Hyper-V CPUID cache before processing
    entries
  KVM: nVMX: Refactor unsupported eVMCS controls logic to use 2-d array
  KVM: VMX: Define VMCS-to-EVMCS conversion for the new fields
  KVM: nVMX: Support several new fields in eVMCSv1
  KVM: x86: hyper-v: Cache HYPERV_CPUID_NESTED_FEATURES CPUID leaf
  KVM: selftests: Add ENCLS_EXITING_BITMAP{,HIGH} VMCS fields
  KVM: selftests: Switch to updated eVMCSv1 definition
  KVM: nVMX: Support PERF_GLOBAL_CTRL with enlightened VMCS
  KVM: nVMX: Support TSC scaling with enlightened VMCS
  KVM: selftests: Enable TSC scaling in evmcs selftest
  KVM: VMX: Get rid of eVMCS specific VMX controls sanitization
  KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
  KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in
    setup_vmcs_config()
  KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING
    in setup_vmcs_config()
  KVM: VMX: Extend VMX controls macro shenanigans
  KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of
    setup_vmcs_config()
  KVM: VMX: Add missing VMEXIT controls to vmcs_config
  KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
  KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of
    setup_vmcs_config()
  KVM: nVMX: Always set required-1 bits of pinbased_ctls to
    PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
  KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
  KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
  KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up
    nested MSR

 arch/x86/include/asm/hyperv-tlfs.h            |  22 +-
 arch/x86/include/asm/kvm_host.h               |   6 +-
 arch/x86/kvm/cpuid.c                          |  18 +-
 arch/x86/kvm/hyperv.c                         |  70 +++--
 arch/x86/kvm/hyperv.h                         |   6 +-
 arch/x86/kvm/vmx/capabilities.h               |  14 +-
 arch/x86/kvm/vmx/evmcs.c                      | 249 +++++++++++-----
 arch/x86/kvm/vmx/evmcs.h                      |  30 +-
 arch/x86/kvm/vmx/nested.c                     | 109 ++++---
 arch/x86/kvm/vmx/nested.h                     |   2 +-
 arch/x86/kvm/vmx/vmx.c                        | 265 ++++++++----------
 arch/x86/kvm/vmx/vmx.h                        | 174 ++++++++++--
 arch/x86/kvm/x86.c                            |   8 +-
 include/uapi/linux/kvm.h                      |   1 +
 .../selftests/kvm/include/x86_64/evmcs.h      |  45 ++-
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  31 +-
 17 files changed, 695 insertions(+), 357 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.1.595.g718a3a8f04-goog

