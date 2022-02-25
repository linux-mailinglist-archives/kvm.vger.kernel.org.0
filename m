Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D174C4F49
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbiBYUJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiBYUJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:09:06 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F861F0831
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:34 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id e23-20020a6b6917000000b006406b9433d6so4484843ioc.14
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5FAlKpsXFpkQ1GeCtCztd3AYAh0Nr6L/3UmkXev5+iY=;
        b=DO9vpk9GXUdRoQEJ+gpTuUmZ/Q0KbpfEqoKBpF1gtClV4Hk1hL3N0Fyv54nkeEbjIO
         6Qm0dt2oimL3CKNnHLOyhj6u5YSqkzDy2pbVJm4vIQbCsX/EkQ9QSXNyBKOowdcpIOWe
         mbzfrmNUlU0PZef8mSNSB9FIVPZN8olGfixWW1bjvOx8y90ei/6pz4YQUUo9ayYc6VYQ
         cBNkX25tHJECNRorIHNXCl8H57S12QSJFyO8nlTnr02ATPF6p4HUJhrHQp5o8iPNIcBa
         jXc73QV+VZJq6nCnf8Tx16dzNmtMmbHLcqYApUTtIKIUDb/iilIfzL8uf/Jr80cNpTOF
         okvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5FAlKpsXFpkQ1GeCtCztd3AYAh0Nr6L/3UmkXev5+iY=;
        b=4fYai4HH84fpAAR8FkEDld/h1J/yAwti1N8wikDzQtD2rf1+i9p7QVNXx4WK+awPHt
         msg0+Twv/r2m30r+1QLjtD8um+46yBPZVlYd38xt5dXZ8gzGAoNc47RFanYLvgiyY3Vy
         /4fqx3MF2v7xJDOas51ov13UCO+MNXNvkVc60ZQQ9pZ2vd4MQfj8c6EXdL4+i3ZlydR4
         9ACB9v83y9AojYe1+WX9IjCokdZ6AY2QVrmiHH4u80CTLFpV4HECbxQunG2rVc2K61+3
         e8DDI15CVR5gWAAwaNz4/aMGJW/YBFQJLm965S2cX4ea1zolR/fsb5k4NV8nSkJ86+p6
         sDtA==
X-Gm-Message-State: AOAM530v4EAfskyueGOhzXiGGCg3lhdPukdj3pVqw8qDA9nH/W53ccwC
        /w3Z36qB7vAAlAsAv9StWpuMfDAyWaQ9U6Fkq0qh+MpfV+3hkWFUwx4/sLOxrFIhXhEs8q6emEe
        YNskJaI7CWQfg0zlMqt/KcGHc+MUraLlQF1YTS5BXvGpDi5WlgyuHwLh4bQ==
X-Google-Smtp-Source: ABdhPJysnqWsK0PBE93+7Zo5Frl1jUyAQVl33pwrI3pTxGR4b8zslus9i+s+xm4NlNHekelpk6YOFJ0eTfY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:cdae:0:b0:2c2:c05d:ac36 with SMTP id
 g14-20020a92cdae000000b002c2c05dac36mr754681ild.196.1645819713708; Fri, 25
 Feb 2022 12:08:33 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:08:17 +0000
Message-Id: <20220225200823.2522321-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 0/6] KVM: nVMX: VMX control MSR fixes
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
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

There are a few bits in the VMX entry/exit control MSRs where KVM
intervenes. The "load IA32_PERF_GLOBAL_CTRL" and "{load,clear}
IA32_BNDCFGS" VMX entry/exit control bits are under KVM control and
conditionally exposed based on the guest CPUID. If the guest CPUID
provides a supporting vPMU or MPX, the respective VMX control bits are
enabled.

These rules have not been upheld in all cases, though. Since commit
aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime() from
kvm_update_cpuid()") KVM will only apply its updates to the MSRs
when the guest CPUID is set. Before, KVM called kvm_update_cpuid()
frequently when running a guest, which had the effect of overriding
any userspace setting of these MSRs.

If an unsuspecting VMM writes to these VMX control MSRs after the
CPUID has been set, KVM fails to configure the appropriate bits.
There does not exist any ordering requirements between setting CPUID
and writing to an MSR.

At the same time, we probably want to get KVM out of the business of
fiddling with these control MSRs. This series adds a quirk that allows
userspace to opt-out of KVM tweaks to these MSRs.

[Patch 1-2]
Fix the immediate issue by hooking writes to the VMX control MSRs. If
userspace writes to one of the affected MSRs, reapply KVMs tweaks to
these registers. Note that these patches employ the minimal change
required to fix the issue, in case they are worthy of a backport.

[Patch 3]
Add a quirk allowing sane VMMs to take full ownership of these control
MSR bits, when disabled.

[Patch 4-6]
Add tests to verify correct behavior with the quirk enabled (KVM
control) and quirk disabled (userspace control).

Applies cleanly to 5.17-rc5. Tested on a Skylake machine with the
included selftest.

v2: https://patchwork.kernel.org/project/kvm/cover/20220204204705.3538240-1-oupton@google.com/

v2 -> v3:
 - Fix changelog and blamed commit in patches 1-2 to better capture
   the history and subsequent breakage of ABI (Sean)
 - Skip consolidation of PMU/MPX control MSR updates into a single
   helper. Sean has some cleanups that are preferrable.
 - Add test cases for both MPX and PGC that assert KVM clears the
   respective bits when the feature dependencies are not present in
   guest CPUID (Paolo)

Oliver Upton (6):
  KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits across MSR write
  KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL ctrl bits across MSR
    write
  KVM: nVMX: Add a quirk for KVM tweaks to VMX control MSRs
  selftests: KVM: Separate static alloc from KVM_GET_SUPPORTED_CPUID
    call
  selftests: KVM: Add test for PERF_GLOBAL_CTRL VMX control MSR bits
  selftests: KVM: Add test for BNDCFGS VMX control MSR bits

 arch/x86/include/uapi/asm/kvm.h               |  11 +-
 arch/x86/kvm/vmx/nested.c                     |  12 +
 arch/x86/kvm/vmx/vmx.c                        |   7 +-
 arch/x86/kvm/vmx/vmx.h                        |   2 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++-
 .../kvm/x86_64/vmx_control_msrs_test.c        | 232 ++++++++++++++++++
 10 files changed, 290 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c

-- 
2.35.1.574.g5d30c73bfb-goog

