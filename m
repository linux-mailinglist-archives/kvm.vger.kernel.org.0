Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE14A7B6A
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 00:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347979AbiBBXEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 18:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiBBXEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 18:04:39 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94257C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 15:04:38 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id y22-20020a5ec816000000b006115762d153so564170iol.7
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 15:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rWQHlVmcBJvv5ux7vr13N+RX6OrgvoZmQqj5XIC4Irs=;
        b=cCw2NFzzD08/o0AsvU6gxLb2BYZiqKuOEHIz6bPo1n/1a2GxkymwRQ/KXsJnqGbZJe
         rUnWD1yBs6G/3WNI2tFrDIay51gpCiGpNXJQ7Wqd45ET+wQQ3c9km/2ygvGjNPrfjMxn
         OwHqKvvG2nN32jFE8i9yxgWjn9FEORAbOzdivRQ36UCH8dCHEzUwWB9YFYDB3fZrZP4/
         Pp3o3IHz2uOSM8SCcWtFG+TDJOmEtW3xERigjB/abt6R+4iVE2b/VqYYZ5Bc16sskA3r
         kAUtsa4DNjAxf0yLJZ4EdsSLCiOBmOJJCmx9+FdZBN5bUbsTnncVJUMykfZvXYc9cLvA
         oUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rWQHlVmcBJvv5ux7vr13N+RX6OrgvoZmQqj5XIC4Irs=;
        b=rVtpXeowaC3z7cs4AcfgXsXLqKnAT69JqwRDPy4RMJB8+Er7dhmWy2JTVs9LNCUFgg
         nNr7I9k8dX5gZZLO1j1le/IEEKLld2a2hpyvVf7HmeRxJGYiSRQXDCImjYUN7CamBAXR
         pLDA2q4ajcRx6EzTcN4lNqwShiSmWK4Yyk35c7BOR36AonDSrGnv8fVUWeitPzTWASWE
         ZKIGfMWjAdKQar8XiD7xdvyOt0al2JddJ6yJsVebIVwaiOPSvNm0/b5ru4Fp9PGLgG9h
         bwFisff792naTUOGLH1eE50hoVLBGYh9gZfZ8SwTewpz8EoI4Ckg5viuPTY03brysjtL
         R6Zw==
X-Gm-Message-State: AOAM532BR9bdTCTSP8vj5KsdBU5NrJ/HgJ0PqomxTLfZpcqckKIrHNry
        eRBn0JyL+zHvr2YjESfmhrXjFydpTmZn0xbz4iZTABcp1/EMqkMVQyxEVQ/ZFsHesYFaa6KP7s6
        klw0nOCk44GHQw+e2JkfFrcPtr1XjHZpVi5Ub954JX+UUBXbye5bB5Td6xg==
X-Google-Smtp-Source: ABdhPJzujQe2jnqHS2JihwT9A07nnCcSEar7PFDXaRCsnigWw1Mh/KInDsc0nGrpT+dEj5NOBwq3Y5fkFAw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:29cd:: with SMTP id p196mr16095277jap.90.1643843077879;
 Wed, 02 Feb 2022 15:04:37 -0800 (PST)
Date:   Wed,  2 Feb 2022 23:04:29 +0000
Message-Id: <20220202230433.2468479-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ultimately, it is the responsibility of userspace to configure an
appropriate MSR value for the CPUID it provides its guest. However,
there are a few bits in VMX capability MSRs where KVM intervenes. The
"load IA32_PERF_GLOBAL_CTRL", "load IA32_BNDCFGS", and "clear
IA32_BNDCFGS" bits in the VMX VM-{Entry,Exit} control capability MSRs
are updated every time userspace sets the guest's CPUID. In so doing,
there is an imposed ordering between ioctls, that userspace must set MSR
values *after* setting the guest's CPUID.

Such ordering requirements should be entirely avoided. This series stops
KVM from modifying VMX VM-{Entry,Exit} control capability MSRs when the
CPUID changes. With this series applied, MSR writes from userspace
before and after KVM_SET_CPUID2 are preserved.

This series cleanly applies to 5.17-rc2. Confirmed the bug with the
included selftest, and also verified the fix. Tested with KVM selftests
on a Skylake box.

Oliver Upton (4):
  KVM: nVMX: Don't change VM-{Entry,Exit} ctrl MSRs on PMU CPUID update
  KVM: nVMX: Don't change VM-{Entry,Exit} ctrl MSRs on MPX CPUID update
  selftests: KVM: Add test for "load IA32_PERF_GLOBAL_CTRL" invariance
  selftests: KVM: Add test case for "{load/clear} IA32_BNDCFGS"
    invariance

 arch/x86/kvm/vmx/nested.c                     |  21 ----
 arch/x86/kvm/vmx/nested.h                     |   1 -
 arch/x86/kvm/vmx/pmu_intel.c                  |   2 -
 arch/x86/kvm/vmx/vmx.c                        |  21 +---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 .../kvm/x86_64/vmx_capability_msrs_test.c     | 119 ++++++++++++++++++
 8 files changed, 124 insertions(+), 44 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c

-- 
2.35.0.rc2.247.g8bbb082509-goog

