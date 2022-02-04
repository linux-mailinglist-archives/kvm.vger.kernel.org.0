Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2254AA156
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbiBDUrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbiBDUrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:47:11 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8995EC061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:47:10 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id 193-20020a6b01ca000000b00612778c712aso4843889iob.14
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qJ7gT2dqv98mhvmmuurthPHvUjv2UpHQ5Ydl6fvUfLY=;
        b=bbSwBFRJML0DXV8UneksOn+tuykyZi7a7/LXBiV75fMKNC639btVvS2u06zcTMbItr
         mleN1jGmVzTdAtIyq7PhZpWQiaEMpp/bvo1ujgkaH7a0AYJ6YsE7JKHb/nXDwGbx1Mw+
         am74IvApbZDCMeRxrE+foYaAF/DzcxJQVy9wIasRYy4XOTCfAjDTtmkfSwe7up5oQJSb
         y0liZ/0a9Ccz1aAYJbba6gQnO1rGR3TjVOp1t1SE9W2meXgC/tWDQx9dpQX70Rex0kDZ
         92bkvy/+4lzkt+Vb9bTeR3uOuKT1wL0FxXxr35xv6xO38H/Lvr3JCfajWc0QsnLgreu+
         yUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qJ7gT2dqv98mhvmmuurthPHvUjv2UpHQ5Ydl6fvUfLY=;
        b=KW0pwBOPeuz/FAwtVmw/bPQIICFmTqdKqBtx6RbUvGzSjkvrgDPGRbggBOAiCFH6VR
         rXKyj0tdYQCfm3QYCTIu5ki1GhjqlV2bkaIN8EF6kUklBkXMDG7239NZizr/mcIzgjOc
         xhuy0wtQXGfkcEnu4ulc2qwgdRxg1cTTiwaNas1BJ9B9eaSLHKEULW1FudUe1luddM47
         gJe3rZx3rVGb1x2j+ywrZamEIiA0hEp3onsKFn92/6JALgjWHIdtAEl1Kr/chay6nsaL
         oxm/kjhrKEyX5JZ2f2iOP7KrsmWlub1jHEUlo6W0QZuLgm/MEGTGSuF+RQG1ogcJbq7p
         cqOQ==
X-Gm-Message-State: AOAM533XQMXcwNlG6B7/uPCrI4IFETM8mW05fkeXKcsq321kD6LwZKvs
        QWCNPkjppq7Pbe7ZjRKJUuguqlRP5Pvq/Njhc023zzj6e3oCySsei4T0Fz1oSVChYUB2ldXMKI+
        KdB/q5S0sJZbCh8y1XcSx7puMnTxQZfZEjTAaESvFDa+O84ufS6tBkSSNxQ==
X-Google-Smtp-Source: ABdhPJx04C+vzkdRH3spobFM99GfLJq8qs+UdMUqPO/9UGVD+9JOemYtZe5T88kwhMzCfGSUP0cSTPcECIc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:a26:: with SMTP id
 6mr471153jao.34.1644007629922; Fri, 04 Feb 2022 12:47:09 -0800 (PST)
Date:   Fri,  4 Feb 2022 20:46:58 +0000
Message-Id: <20220204204705.3538240-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v2 0/7] VMX: nVMX: VMX control MSR fixes
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

These rules have not been upheld in all cases, though. KVM will only
apply its updates to the MSRs when the guest CPUID is set. If an
unsuspecting VMM writes to these VMX control MSRs after the CPUID has
been set, KVM fails to configure the appropriate bits. There does not
exist any ordering requirements between setting CPUID and writing to an
MSR.

[Patch 1-2]
Fix the immediate issue by hooking writes to the VMX control MSRs. If
userspace writes to one of the affected MSRs, reapply KVMs tweaks to
these registers. Note that these patches employ the minimal change
required to fix the issue, in case they are worthy of a backport.

[Patch 3-4]
Of course, it is not ideal to have KVM fiddling with the guest's MSRs in
this way. Add a quirk allowing sane VMMs to take complete ownership of
these VMX control bits.

[Patch 5-6]
Add tests to verify correct behavior for these bits with the quirk
enabled (KVM control) and quirk disabled (userspace control).

Finally, patch 7 is a nit cleanup that I noticed while doing the
renovations above.

This series applies cleanly to 5.17-rc2. Tested on a Skylake host.

Oliver Upton (7):
  KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits across MSR write
  KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL ctrl bits across MSR
    write
  KVM: nVMX: Roll all entry/exit ctl updates into a single helper
  KVM: nVMX: Add a quirk for KVM tweaks to VMX control MSRs
  selftests: KVM: Add test for PERF_GLOBAL_CTRL VMX control MSR bits
  selftests: KVM: Add test for BNDCFGS VMX control MSR bits
  KVM: VMX: Use local pointer to vcpu_vmx in vmx_vcpu_after_set_cpuid()

 arch/x86/include/uapi/asm/kvm.h               |  11 +-
 arch/x86/kvm/vmx/nested.c                     |  30 +---
 arch/x86/kvm/vmx/nested.h                     |   1 -
 arch/x86/kvm/vmx/pmu_intel.c                  |   2 -
 arch/x86/kvm/vmx/vmx.c                        |  17 +-
 arch/x86/kvm/vmx/vmx.h                        |   2 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 .../kvm/x86_64/vmx_control_msrs_test.c        | 166 ++++++++++++++++++
 10 files changed, 201 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c

-- 
2.35.0.263.gb82422642f-goog

