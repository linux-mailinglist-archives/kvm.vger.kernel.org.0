Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0167D4C83AD
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiCAGEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiCAGEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:45 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A94F60CFB
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:05 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id x6-20020a923006000000b002bea39c3974so10437938ile.12
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=90Y1OUoo/i/MDyMif1ZLYXlwvonl1/S6yae0WqARoag=;
        b=AvaQQtm3X0H0eM7RZpS3/lBPYQ8QvLsPXeJPLoDpRHymHdu5di3aSlfXPQRt3rKedx
         O/yIOwX2EQLH0durGafctq63uDNlu1FX7HIJ0UsCM5iMS1JCYGEmvOySbtNWg2e91KZ8
         /QdY56GOeoTXJg6bgf2JqpkZ0ZUhVWy9WI/h2n+fscJX5CuMXxZwB9Y0Fdhzihy5LHFo
         +MUVbeBBwv+awljQrg3hg3B/5q/CzYvRJTYG/qZbMMFUNcxP8VU3IBP8hJVxbk04nVh5
         IIqb1TS7k2iRmqO+IBR7yZCxkEkwX4tLNVs7wE3Ep2wEAkGOD9OLbkcKL2qu2dns2YrZ
         sKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=90Y1OUoo/i/MDyMif1ZLYXlwvonl1/S6yae0WqARoag=;
        b=pA23DZONwh/Ps436tMyuP49FcOZAWEPWjUCGeDYdrLjtpjDhR2dEY5ttRvu7Kh9dU6
         K+0LWXn53f4rlhRJcupOgYluW2VzxMmL1xnaIvzHLCtk3lPPzm7UVjYrmn0Z/q1K1Oar
         7vE7DFPY0rQCglLC7nrx1AGqR8KhEUteHSlTBTrlZlGsuJId7yK0OUcn/v5ZH3DscaT1
         /oIvQuUNjpSLvjlVcEcZyqocwK8afDSRGKIwbUscKcRzRQ04IdQYA7BfbqQTic9vQmMT
         xx1dHgH7tloiX+QyAD/RXAxzUDq4bu9e+vSX4W70/P3l+jh6iZeAfxU91UMisexCRYoc
         +ckA==
X-Gm-Message-State: AOAM530rjf3jC6DULSt8FLORhx2dIX72fFHWtJqxg0xtoW02AVXQpPjb
        bYAFgr+Lz8qMgrJhZLOVjx4fYf6mmp6oUXhsGZHMf84gtuL30CfBZpVDhvGnXG3xTAUXWT0gbV2
        /rUNlYiZKT1wlVlL8/S8D0u3xkHuRcY6oG68Wap8XbihtsHA50/mm4w8Scw==
X-Google-Smtp-Source: ABdhPJxD0OSSRzSKfvWQCiAaCBX/t51Aw9/i/YqMuJerQXNKMOZR/nDjx1pS8wjyW/hltqziAMLR+tO1BS8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:18c5:b0:2c2:ac0e:4eca with SMTP id
 s5-20020a056e0218c500b002c2ac0e4ecamr18052116ilu.7.1646114644355; Mon, 28 Feb
 2022 22:04:04 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:43 +0000
Message-Id: <20220301060351.442881-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 0/8] KVM: x86: VMX ctrl MSR + KVM quirk fixes
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
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
IA32_BNDCFGS" VM-{Entry,Exit} control bits are under KVM control and
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
With the hook added in Patch 2, updating
IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs is unnecessary on PMU refresh. Drop
everything related to updating these controls on PMU refresh.

[Patch 4]
KVM_CAP_DISABLE_QUIRKS2 is broken beyond repair. Create a new capability
that makes quirks discoverable and rejects invalid bits.

[Patch 5]
Add a quirk to opt out of KVM ownership of the aforementioned MSRs. It
is really userspace's responsibility to set up sane vCPU state.

[Patches 6-8]
Add test cases to verify expected behavior with the quirk enabled (KVM
control) and quirk disabled (userspace control).

Applies cleanly to kvm/queue, at the following commit:

  625e7ef7da1a ("KVM: selftests: Add test to verify KVM handling of ICR")

Tested with the included selftest on an Intel Skylake machine.

v3: http://lore.kernel.org/r/20220225200823.2522321-1-oupton@google.com

v3 -> v4:
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

Oliver Upton (8):
  KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits across MSR write
  KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL ctrl bits across MSR
    write
  KVM: nVMX: Drop nested_vmx_pmu_refresh()
  KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2
  KVM: nVMX: Add a quirk for KVM tweaks to VMX control MSRs
  selftests: KVM: Separate static alloc from KVM_GET_SUPPORTED_CPUID
    call
  selftests: KVM: Add test for PERF_GLOBAL_CTRL VMX control MSR bits
  selftests: KVM: Add test for BNDCFGS VMX control MSR bits

 Documentation/virt/kvm/api.rst                |  74 +++++
 arch/x86/include/asm/kvm_host.h               |   8 +
 arch/x86/include/uapi/asm/kvm.h               |  11 +-
 arch/x86/kvm/pmu.h                            |   5 +
 arch/x86/kvm/vmx/nested.c                     |  31 +--
 arch/x86/kvm/vmx/nested.h                     |   2 -
 arch/x86/kvm/vmx/pmu_intel.c                  |   3 -
 arch/x86/kvm/vmx/vmx.c                        |  17 +-
 arch/x86/kvm/vmx/vmx.h                        |   2 +
 arch/x86/kvm/x86.c                            |   8 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++-
 .../kvm/x86_64/vmx_control_msrs_test.c        | 257 ++++++++++++++++++
 17 files changed, 418 insertions(+), 39 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c

-- 
2.35.1.574.g5d30c73bfb-goog

