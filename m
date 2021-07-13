Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39D43C7499
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhGMQg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhGMQgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BB2C0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a4-20020a25f5040000b029054df41d5cceso27748755ybe.18
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=eCce4R3xq3isKOouF5FTNEunRJdZmdeo4W5/csS7Oys=;
        b=WW7f7RhIOPkS4TYxNubIzf63Dv/yms2kaYN5+Rxv5Q9YroM0R2ch1JNCqJSPPwyUlo
         KAF82pu3Bp4g/Pn+xuTKeUAwB/TO69M6o1eZRkVdgC1tee/P/80S/uaAp7ti/HK3esQk
         Q0ute6Gan86natVKaRfSeabXGhIzjPsBIB/HhoYgyxThITgbW2GiDLBWHLW8iIwxtJNt
         vochZXnSRORkeDzrndGVSRqhSDgvh8hxbxWMzFFi/rSojFqOf7TCcj+bXcv3KCd5+lEm
         8V/XzYdyWhy/C8ZT/zuzaVoIWT8zpBN0LW61lb5Tz/vRzpRc6UN871GxHFqxOTrEkUZC
         5izQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=eCce4R3xq3isKOouF5FTNEunRJdZmdeo4W5/csS7Oys=;
        b=YNWwiWjTBtj6jppYP1EJ70ECzE4IFNdL7facOQfYgkz/M0ARxUexr9Hrchtpln2LU7
         XSwsPLA/CldJYD7DKKIKXVK709Q/Jl+fgHdC9fKgpRcZ+4bld4TnVLrVHFyqSD7CYbqS
         1u6xPE3xzlLO/nwHAw747g0H8ieUij0+JnRNQuapLoc30mvEqO5hlXp+ElQVpuIjoP66
         C+oiHJJzornwmSX4t9K0mQzXP3y+jVYI/rAyOD41Pj9fKCka3K50lIlAZi9P0hL1a/3W
         do4R71TX3ilg6HzzGe7Drv5OH/ohtOfHj9apSd+KWX8oYcL26qQWDw6j/ghIrJp04rl3
         Po9A==
X-Gm-Message-State: AOAM530QhTYpXKz/Yqoo5KtE1ONid0Kw5d1ykJVio8/kvimk/AaJikYe
        d8pC+HrIQmoaggHgD9lMv0mngovL/eA=
X-Google-Smtp-Source: ABdhPJx9JGW3qNNkd9oyzMw9G4hOv/gl13Yd2iL9EaRCo7CMB+rG3efy24zY7EhlUxx50+F6I7t4jPBb7to=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:8743:: with SMTP id e3mr6953766ybn.125.1626194014534;
 Tue, 13 Jul 2021 09:33:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:38 -0700
Message-Id: <20210713163324.627647-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 00/46] KVM: x86: vCPU RESET/INIT fixes and consolidation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The end goal of this series is to consolidate the RESET/INIT code, both to
deduplicate code and to try to avoid divergent behavior/bugs, e.g. SVM only
recently started updating vcpu->arch.cr4 on INIT.

The TL;DR of why it takes 40+ patches to get there is that the RESET/INIT
flows have multiple latent bugs and hidden dependencies, but "work"
because they're rarely touched, are mostly fixed flows in both KVM and the
guest, and because guests don't sanity check state after INIT.

While several of the patches have Fixes tags, I am absolutely terrified of
backporting most of them due to the likelihood of breaking a different
version of KVM.  And, for the most part the bugs are benign in the sense
no guest has actually encountered any of these bugs.  For that reason, I
intentionally omitted stable@ entirely.  The only patches I would consider
even remotely safe for backporting are the first four patches in the series.

v2:
  - Collect Reviews. [Reiji]
  - Fix an apic->base_address initialization goof. [Reiji]
  - Add patch to flush TLB on INIT. [Reiji]
  - Add patch to preserved CR0.CD/NW on INIT. [Reiji]
  - Add patch to emulate #INIT after shutdown on SVM. [Reiji]
  - Add patch to consolidate arch.hflags code. [Reiji]
  - Drop patch to omit VMWRITE zeroing. [Paolo, Jim]
  - Drop several MMU patches (moved to other series).

v1: https://lkml.kernel.org/r/20210424004645.3950558-1-seanjc@google.com

Sean Christopherson (46):
  KVM: x86: Flush the guest's TLB on INIT
  KVM: nVMX: Set LDTR to its architecturally defined value on nested
    VM-Exit
  KVM: SVM: Zero out GDTR.base and IDTR.base on INIT
  KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
  KVM: SVM: Require exact CPUID.0x1 match when stuffing EDX at INIT
  KVM: SVM: Fall back to KVM's hardcoded value for EDX at RESET/INIT
  KVM: VMX: Remove explicit MMU reset in enter_rmode()
  KVM: SVM: Drop explicit MMU reset at RESET/INIT
  KVM: SVM: Drop a redundant init_vmcb() from svm_create_vcpu()
  KVM: VMX: Move init_vmcs() invocation to vmx_vcpu_reset()
  KVM: x86: WARN if the APIC map is dirty without an in-kernel local
    APIC
  KVM: x86: Remove defunct BSP "update" in local APIC reset
  KVM: x86: Migrate the PIT only if vcpu0 is migrated, not any BSP
  KVM: x86: Don't force set BSP bit when local APIC is managed by
    userspace
  KVM: x86: Set BSP bit in reset BSP vCPU's APIC base by default
  KVM: VMX: Stuff vcpu->arch.apic_base directly at vCPU RESET
  KVM: x86: Open code necessary bits of kvm_lapic_set_base() at vCPU
    RESET
  KVM: x86: Consolidate APIC base RESET initialization code
  KVM: x86: Move EDX initialization at vCPU RESET to common code
  KVM: SVM: Don't bother writing vmcb->save.rip at vCPU RESET/INIT
  KVM: VMX: Invert handling of CR0.WP for EPT without unrestricted guest
  KVM: VMX: Remove direct write to vcpu->arch.cr0 during vCPU RESET/INIT
  KVM: VMX: Fold ept_update_paging_mode_cr0() back into vmx_set_cr0()
  KVM: nVMX: Do not clear CR3 load/store exiting bits if L1 wants 'em
  KVM: VMX: Pull GUEST_CR3 from the VMCS iff CR3 load exiting is
    disabled
  KVM: x86/mmu: Skip the permission_fault() check on MMIO if CR0.PG=0
  KVM: VMX: Process CR0.PG side effects after setting CR0 assets
  KVM: VMX: Skip emulation required checks during pmode/rmode
    transitions
  KVM: nVMX: Don't evaluate "emulation required" on nested VM-Exit
  KVM: SVM: Tweak order of cr0/cr4/efer writes at RESET/INIT
  KVM: SVM: Drop redundant writes to vmcb->save.cr4 at RESET/INIT
  KVM: SVM: Stuff save->dr6 at during VMSA sync, not at RESET/INIT
  KVM: VMX: Skip pointless MSR bitmap update when setting EFER
  KVM: VMX: Refresh list of user return MSRs after setting guest CPUID
  KVM: VMX: Don't _explicitly_ reconfigure user return MSRs on vCPU INIT
  KVM: x86: Move setting of sregs during vCPU RESET/INIT to common x86
  KVM: VMX: Remove obsolete MSR bitmap refresh at vCPU RESET/INIT
  KVM: nVMX: Remove obsolete MSR bitmap refresh at nested transitions
  KVM: VMX: Don't redo x2APIC MSR bitmaps when userspace filter is
    changed
  KVM: VMX: Remove unnecessary initialization of msr_bitmap_mode
  KVM: VMX: Smush x2APIC MSR bitmap adjustments into single function
  KVM: VMX: Remove redundant write to set vCPU as active at RESET/INIT
  KVM: VMX: Move RESET-only VMWRITE sequences to init_vmcs()
  KVM: SVM: Emulate #INIT in response to triple fault shutdown
  KVM: SVM: Drop redundant clearing of vcpu->arch.hflags at INIT/RESET
  KVM: x86: Preserve guest's CR0.CD/NW on INIT

 arch/x86/include/asm/kvm_host.h |   5 -
 arch/x86/kvm/i8254.c            |   3 +-
 arch/x86/kvm/lapic.c            |  26 +--
 arch/x86/kvm/svm/sev.c          |   1 +
 arch/x86/kvm/svm/svm.c          |  48 ++----
 arch/x86/kvm/vmx/nested.c       |  24 ++-
 arch/x86/kvm/vmx/vmx.c          | 270 +++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.h          |   5 +-
 arch/x86/kvm/x86.c              |  52 +++++-
 9 files changed, 211 insertions(+), 223 deletions(-)

-- 
2.32.0.93.g670b81a890-goog

