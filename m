Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB1C3FA23D
	for <lists+kvm@lfdr.de>; Sat, 28 Aug 2021 02:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhH1AhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 20:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbhH1AhP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 20:37:15 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44258C061796
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:26 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id c4-20020a0ce7c4000000b00370a5bb605eso2911168qvo.0
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 17:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=xh3b83AHgc+X5acCCZf2iVRK+ee8SLHX2uHx4t+xrBY=;
        b=FsrBDBj81I24PUYsfqY9aNe2Br6Cge4C10V9fErKyzcL9jN9JzP/kqqqUHGaBFgQcQ
         0U9g5lP31TKw2LT3YjTlFAgoG4AS3SMwwYaB+iZ9VL+rH1PuDacZvkVF5TZDPvt+SCVp
         hoVnB9YrhsLy30buyfkioR3VRr/U9QgKrM+qQnkI0aZ8yrDkdgGSixnrY69JIAMGRumH
         CIa10muamcOBBpjShGeSCvzY0V1rXxFeRJk/BexUgt5cyg06R0PXRjlCeTWZrE9Yduwb
         tvUde2o7UVIgOctvxLjj8VW7xpdvOez/m4ccG77zN+autZ2tCUck8ZbNdlcpaKwRcScv
         Xlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=xh3b83AHgc+X5acCCZf2iVRK+ee8SLHX2uHx4t+xrBY=;
        b=KjQLZ2LAPw2vD7Nm6S+QzFeH40ngqb6X+JLZf8m7fpZYrfK2R3iWpWSvQCPL9ZqXGV
         Wm/pme061oVQUDtSRgEKDZ65Cxr+iYFlzKjWt69eqTGjw677V38mr5Re8q9/fHU1jnQ8
         0ibiPPeRnr8R3MAfuCS2ffS6rpI16/avO6z14LXK24/0THRDsyVMPrCsKlAjROoZB05j
         kFtrs586DJLf4ldCIcESN5n+WCJXnQRDN/XQsYos3LlEk68bK6CdVHRJvrlCghEnI9gW
         5wXx3MZFQzlQBUE5eQU7u8HF10UIabwHtWNYIsrLN9mpxyJUs/RBwXQDGmEjq+dx9mdA
         z2Xg==
X-Gm-Message-State: AOAM532JQayoZuO295qj6DfUS+DUCYCFuQvX36fKixdziLSsrG1x/LLn
        RXXcrY+hOhYMiZhwTKROydYBtGeqgxA=
X-Google-Smtp-Source: ABdhPJzkOydjwKSx1IUjIGSvBy+QMF11RiN4xe9UgjoUhzwRgFrcyVUOeAZyVTnBYwiNIqVlWoCONvUze1Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f66c:b851:7e79:7ed4])
 (user=seanjc job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr12642407qvs.58.1630110985252; Fri, 27 Aug 2021 17:36:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Aug 2021 17:35:45 -0700
Message-Id: <20210828003558.713983-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v2 00/13] perf: KVM: Fix, optimize, and clean up callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a combination of ~2 series to fix bugs in the perf+KVM callbacks,
optimize the callbacks by employing static_call, and do a variety of
cleanup in both perf and KVM.

Patch 1 fixes a mostly-theoretical bug where perf can deref a NULL
pointer if KVM unregisters its callbacks while they're being accessed.
In practice, compilers tend to avoid problematic reloads of the pointer
and the PMI handler doesn't lose the race against module unloading,
i.e doesn't hit a use-after-free.

Patches 2 and 3 fix an Intel PT handling bug where KVM incorrectly
eats PT interrupts when PT is supposed to be owned entirely by the host.

Patches 4-7 clean up perf's callback infrastructure and switch to
static_call for arm64 and x86 (the only survivors).

Patches 8-13 clean up related KVM code and unify the arm64/x86 callbacks.

Based on "git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue", commit
680c7e3be6a3 ("KVM: x86: Exit to userspace ...").

v2 (relatively to static_call v10)
  - Split the patch into the semantic change (multiplexed ->state) and
    introduction of static_call.
  - Don't use '0' for "not a guest RIP".
  - Handle unregister path.
  - Drop changes for architectures that can be culled entirely.

v2 (relative to v1)
  - Drop per-cpu approach. [Peter]
  - Fix mostly-theoretical reload and use-after-free with READ_ONCE(),
    WRITE_ONCE(), and synchronize_rcu(). [Peter]
  - Avoid new exports like the plague. [Peter]

v1:
  - https://lkml.kernel.org/r/20210827005718.585190-1-seanjc@google.com

v10 static_call:
  - https://lkml.kernel.org/r/20210806133802.3528-2-lingshan.zhu@intel.com

Like Xu (2):
  perf/core: Rework guest callbacks to prepare for static_call support
  perf/core: Use static_call to optimize perf_guest_info_callbacks

Sean Christopherson (11):
  perf: Ensure perf_guest_cbs aren't reloaded between !NULL check and
    deref
  KVM: x86: Register perf callbacks after calling vendor's
    hardware_setup()
  KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
    guest
  perf: Stop pretending that perf can handle multiple guest callbacks
  perf: Force architectures to opt-in to guest callbacks
  KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu
    variable
  KVM: x86: More precisely identify NMI from guest when handling PMI
  KVM: Move x86's perf guest info callbacks to generic KVM
  KVM: x86: Move Intel Processor Trace interrupt handler to vmx.c
  KVM: arm64: Convert to the generic perf callbacks
  KVM: arm64: Drop perf.c and fold its tiny bits of code into arm.c /
    pmu.c

 arch/arm/kernel/perf_callchain.c   | 28 ++------------
 arch/arm64/Kconfig                 |  1 +
 arch/arm64/include/asm/kvm_host.h  | 13 ++++++-
 arch/arm64/kernel/perf_callchain.c | 28 +++++++++++---
 arch/arm64/kvm/Makefile            |  2 +-
 arch/arm64/kvm/arm.c               | 11 +++++-
 arch/arm64/kvm/perf.c              | 62 ------------------------------
 arch/arm64/kvm/pmu.c               |  8 ++++
 arch/csky/kernel/perf_callchain.c  | 10 -----
 arch/nds32/kernel/perf_event_cpu.c | 29 ++------------
 arch/riscv/kernel/perf_callchain.c | 10 -----
 arch/x86/Kconfig                   |  1 +
 arch/x86/events/core.c             | 36 ++++++++++++++---
 arch/x86/events/intel/core.c       |  7 ++--
 arch/x86/include/asm/kvm_host.h    |  8 +++-
 arch/x86/kvm/pmu.c                 |  2 +-
 arch/x86/kvm/svm/svm.c             |  2 +-
 arch/x86/kvm/vmx/vmx.c             | 25 +++++++++++-
 arch/x86/kvm/x86.c                 | 58 +++++-----------------------
 arch/x86/kvm/x86.h                 | 17 ++++++--
 arch/x86/xen/pmu.c                 | 32 +++++++--------
 include/kvm/arm_pmu.h              |  1 +
 include/linux/kvm_host.h           | 10 +++++
 include/linux/perf_event.h         | 26 ++++++++-----
 init/Kconfig                       |  3 ++
 kernel/events/core.c               | 24 ++++++------
 virt/kvm/kvm_main.c                | 40 +++++++++++++++++++
 27 files changed, 245 insertions(+), 249 deletions(-)
 delete mode 100644 arch/arm64/kvm/perf.c

-- 
2.33.0.259.gc128427fd7-goog

