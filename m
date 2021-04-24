Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3836369DE7
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbhDXArl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbhDXArj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:47:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26A3C06174A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i201-20020a25d1d20000b02904ed4c01f82bso4014567ybg.20
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=epO6YEjwPO7QvUZu1XjHJGHm/chhZ9vPzJZSjn+LdVQ=;
        b=Tr2JjEM2Z8EFMp2QqY7Ia4LWdIsFe8CfSzgCQBotrRYxUjUOfv3kno15ySfXPpF97F
         hA6+XYtKqwQeG/1BlcGuH3SqCbIoVIx/w9iHSPyGa54YcosUMdbQgPSEbNnEtDX+c/6P
         toi8DrmACb1ovdLxLoCPhRbelKvY98gVd8uwQksHFfQ6RFiLjGvzmfEc4a9zickmmlSJ
         56iOB6eEbpxmxjsto9Oa3J0pnu22eE+BtE5pkOAgjD/+afdUDMIYYI9dTDL9hwKWLwWL
         3kyDbS32878uGNR4nsNm4mCVB0xFZlo1Iv3YCivxICUc5cn+8Y3E03SjyejyjT6rdkM5
         2LIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=epO6YEjwPO7QvUZu1XjHJGHm/chhZ9vPzJZSjn+LdVQ=;
        b=IVyBxybEwZGvVEUKgjzD35ivphGgSQ5Yv6PFGdIIZ/nGdimaNovntmsJAOaKM+upeq
         s6dMiSLfQTSMRiRr0+CGmlb65WDAST3E6urPHHKGno5qbR2FEyg0fyKlgG64gmT4L8ks
         +vyHHv+pQlEA2Tb7uBhLH/Bl/P0zW+Z87EMXgfDGHy4DDpdgQ6GC+PMvi+5MRHlB0ioE
         Lqre+hjpRzNreZCKLes48a75Kw7LvQALG5WdtiR2n5/clKSCVuIDK6nBLXJxAe5PvnDe
         xZxkEszL7AIq5h0ZHIUxUntxPSRNEBt6454WIcBij4xwkqtAC9Eei2KO9sjHBhhMfxr2
         Zk3g==
X-Gm-Message-State: AOAM5326edNre4P8MvONYdmNm+fs+rS0ajAxrLpZwlOU8BQat/3zs/fw
        MGl87MQYOCgd8wLvsm1hk9N1LacEZ40=
X-Google-Smtp-Source: ABdhPJyHDv4TFtRLwgA2AznsyHqtwsOPDYdqD3GLsEF+WrE8neqR8RqrQMD/8Q0QG43zXVUI4G2rKz7UZYU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:af4d:: with SMTP id c13mr9660381ybj.324.1619225220177;
 Fri, 23 Apr 2021 17:47:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:02 -0700
Message-Id: <20210424004645.3950558-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 00/43] KVM: x86: vCPU RESET/INIT fixes and consolidation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the record, I went into this thinking it was going to be a simple code
shuffle between {svm,vmx}_vcpu_reset() and kvm_vcpu_reset().  The actual
goal is to consolidate the RESET/INIT code, both to deduplicate code and
to try to avoid divergent behavior/bugs, e.g. SVM only recently started
updating vcpu->arch.cr4 on INIT.

The TL;DR of why it takes 40+ patches to get there is that the RESET/INIT
flows have multiple latent bugs and hidden dependencies, but "work"
because they're rarely touched, are mostly fixed flows in both KVM and the
guest, and because guests don't sanity check state after INIT.

While several of the patches have Fixes tags, I am absolutely terrified of
backporting most of them due to the likelihood of breaking a different
version of KVM.  And, for the most part the bugs are benign in the sense
no guest has actually encountered any of these bugs.  For that reason, I
intentionally omitted stable@ entirely.  The only patches I would consider
even remotely safe for backporting are the first two patches in the series.


Sean Christopherson (43):
  KVM: nVMX: Set LDTR to its architecturally defined value on nested
    VM-Exit
  KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
  KVM: SVM: Require exact CPUID.0x1 match when stuffing EDX at INIT
  KVM: SVM: Fall back to KVM's hardcoded value for EDX at RESET/INIT
  KVM: x86: Split out CR0/CR4 MMU role change detectors to separate
    helpers
  KVM: x86: Properly reset MMU context at vCPU RESET/INIT
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
  KVM: VMX: Process CR0.PG side effects after setting CR0 assets
  KVM: VMX: Skip emulation required checks during pmode/rmode
    transitions
  KVM: nVMX: Don't evaluate "emulation required" on VM-Exit
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
  KVM: VMX: Drop VMWRITEs to zero fields at vCPU RESET
  KVM: x86: Drop pointless @reset_roots from kvm_init_mmu()

 arch/x86/include/asm/kvm_host.h |   5 -
 arch/x86/kvm/i8254.c            |   3 +-
 arch/x86/kvm/lapic.c            |  26 +--
 arch/x86/kvm/mmu.h              |   2 +-
 arch/x86/kvm/mmu/mmu.c          |  13 +-
 arch/x86/kvm/svm/nested.c       |   2 +-
 arch/x86/kvm/svm/sev.c          |   1 +
 arch/x86/kvm/svm/svm.c          |  33 +---
 arch/x86/kvm/vmx/nested.c       |  26 ++-
 arch/x86/kvm/vmx/vmx.c          | 271 +++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h          |   5 +-
 arch/x86/kvm/x86.c              |  51 +++++-
 12 files changed, 189 insertions(+), 249 deletions(-)

-- 
2.31.1.498.g6c1eba8ee3d-goog

