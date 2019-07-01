Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED2D44864
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389773AbfFMRDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45770 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbfFMRDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so21542300wre.12;
        Thu, 13 Jun 2019 10:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=r4ArmEbPSut4DJEzdrpSUqeNJMgfplEsP5qTJCvrGG8=;
        b=JF/iFISKalk9yRG3F1O3rnEnOU+5Z6iKXZJMZ0i+cIOPyJurclDfEvj3eJqD2Fascg
         l7o15qjAaPqsTg90P8VVF4Q7yhO6/BHiV13a17ido7CSzwW4kuPRKpOLWxLe0xQKoGzo
         Q79NyRhDhEjPOLzCfJROG/t8W+fYX4RCTnz3CEZ+g0oCbJ58jchvfFshPqdhNiqe/OAw
         CgWG6U4n+zfndHbyU3/wbZ5voAs7lOKzRR7mYwAtD8dA0y6pNEQpMFE97hGEfwkis+wf
         CP/S8dUsMVSiqBrJV+iKenYJDhJ9a/q3YBx1FB07LeM2R9Xmr0y2tZhzl/fFkUTAs/Md
         HUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=r4ArmEbPSut4DJEzdrpSUqeNJMgfplEsP5qTJCvrGG8=;
        b=KmEv80evepECsRW2FOMjxxQJYBypLmHaQZ7aghvbpb4zE8EQu2wO3n6ShMhb5ERVvc
         x3vfrnSOb1Mc0g4y+Pc/1kv4L3juqxDLUT/eaXbbCQMhRTYgxf/SZmgo0GNw0i4wRJ3f
         76v9vHsHSLJ2jnazQemOMojQjXde86mgNOqJbqvQrPRjxqwF5JSIjKNgQD22sNNJFvL2
         cy8hfZYI24S4R26B37pHobsYgWpzIMbH/uph6l/JtEjOCg4NvB2kaSuccKmQ0msNsj/e
         wjfN46sd4CJRYsej61P6UQPor0uSPv7UWsq13tSxZyJlJKHPyGCRdr3nLmKaXgHPx6eB
         lG0A==
X-Gm-Message-State: APjAAAW8z4DjI6fN11U35s+xBjE4g/B0StWan59Op9rjsPAbbqfEqNYQ
        830a9er3QEUj4Pyv8vaxEPH4vQza
X-Google-Smtp-Source: APXvYqw6tyb4r4kQJnczwSSJb4JzaWc+aH3jJ1UWoHLInEvbExO73clDCCjBvQouVk0YRuxveelrmQ==
X-Received: by 2002:adf:e841:: with SMTP id d1mr61292033wrn.204.1560445411300;
        Thu, 13 Jun 2019 10:03:31 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:30 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 00/43] VMX optimizations
Date:   Thu, 13 Jun 2019 19:02:46 +0200
Message-Id: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the outcome of the review of Sean's VMX optimization series,
with some coding style improvements (at least according to me :)
and conflicts resolved between the various series that he sent.

The result on nested vmexit.flat is about a 12% improvement on
vmexit speed:

                                   before   after
    cpuid                          14886    13142
    vmcall                         14918    13189
    inl_from_pmtimer               47277    45536
    inl_from_qemu                  46747    44826
    inl_from_kernel                15218    13518
    outl_to_kernel                 15184    13436
    self_ipi_sti_nop               16458    14858
    self_ipi_sti_hlt               31876    28348
    self_ipi_tpr                   16603    15003
    self_ipi_tpr_sti_nop           16509    15048
    self_ipi_tpr_sti_hlt           32027    28386
    x2apic_self_ipi_sti_hlt        16386    14788
    x2apic_self_ipi_tpr_sti_hlt    16479    14881


Patches 1-6 were posted as "KVM: VMX: INTR, NMI and #MC cleanup".

Patches 7-13 were posted as "KVM: nVMX: Optimize VMCS data copying".

Patches 15-30 were posted as "KVM: nVMX: Optimize nested VM-Entry".

Patches 31-43 were posted as "KVM: VMX: Reduce VMWRITEs to VMCS controls".

Paolo Bonzini (5):
  kvm: nVMX: small cleanup in handle_exception
  KVM: nVMX: Rename prepare_vmcs02_*_full to prepare_vmcs02_*_rare
  KVM: VMX: simplify vmx_prepare_switch_to_{guest,host}
  KVM: x86: introduce is_pae_paging
  KVM: nVMX: shadow pin based execution controls

Sean Christopherson (38):
  KVM: VMX: Fix handling of #MC that occurs during VM-Entry
  KVM: VMX: Read cached VM-Exit reason to detect external interrupt
  KVM: VMX: Store the host kernel's IDT base in a global variable
  KVM: x86: Move kvm_{before,after}_interrupt() calls to vendor code
  KVM: VMX: Handle NMIs, #MCs and async #PFs in common irqs-disabled fn
  KVM: nVMX: Intercept VMWRITEs to read-only shadow VMCS fields
  KVM: nVMX: Intercept VMWRITEs to GUEST_{CS,SS}_AR_BYTES
  KVM: nVMX: Track vmcs12 offsets for shadowed VMCS fields
  KVM: nVMX: Lift sync_vmcs12() out of prepare_vmcs12()
  KVM: nVMX: Use descriptive names for VMCS sync functions and flags
  KVM: nVMX: Add helpers to identify shadowed VMCS fields
  KVM: nVMX: Sync rarely accessed guest fields only when needed
  KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value
  KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
  KVM: nVMX: Write ENCLS-exiting bitmap once per vmcs02
  KVM: nVMX: Don't rewrite GUEST_PML_INDEX during nested VM-Entry
  KVM: nVMX: Don't "put" vCPU or host state when switching VMCS
  KVM: nVMX: Don't reread VMCS-agnostic state when switching VMCS
  KVM: nVMX: Don't dump VMCS if virtual APIC page can't be mapped
  KVM: nVMX: Don't speculatively write virtual-APIC page address
  KVM: nVMX: Don't speculatively write APIC-access page address
  KVM: nVMX: Update vmcs12 for MSR_IA32_CR_PAT when it's written
  KVM: nVMX: Update vmcs12 for SYSENTER MSRs when they're written
  KVM: nVMX: Update vmcs12 for MSR_IA32_DEBUGCTLMSR when it's written
  KVM: nVMX: Don't update GUEST_BNDCFGS if it's clean in HV eVMCS
  KVM: nVMX: Copy PDPTRs to/from vmcs12 only when necessary
  KVM: nVMX: Use adjusted pin controls for vmcs02
  KVM: VMX: Add builder macros for shadowing controls
  KVM: VMX: Shadow VMCS pin controls
  KVM: VMX: Shadow VMCS primary execution controls
  KVM: VMX: Shadow VMCS secondary execution controls
  KVM: nVMX: Shadow VMCS controls on a per-VMCS basis
  KVM: nVMX: Don't reset VMCS controls shadow on VMCS switch
  KVM: VMX: Explicitly initialize controls shadow at VMCS allocation
  KVM: nVMX: Preserve last USE_MSR_BITMAPS when preparing vmcs02
  KVM: nVMX: Preset *DT exiting in vmcs02 when emulating UMIP
  KVM: VMX: Drop hv_timer_armed from 'struct loaded_vmcs'
  KVM: VMX: Leave preemption timer running when it's disabled

 arch/x86/include/asm/kvm_host.h       |   2 +-
 arch/x86/kvm/svm.c                    |   6 +-
 arch/x86/kvm/vmx/nested.c             | 591 +++++++++++++++++++++-------------
 arch/x86/kvm/vmx/nested.h             |   2 +-
 arch/x86/kvm/vmx/vmcs.h               |  17 +-
 arch/x86/kvm/vmx/vmcs12.h             |  57 ++--
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  79 ++---
 arch/x86/kvm/vmx/vmx.c                | 408 ++++++++++++-----------
 arch/x86/kvm/vmx/vmx.h                | 122 +++----
 arch/x86/kvm/x86.c                    |  12 +-
 arch/x86/kvm/x86.h                    |   5 +
 11 files changed, 733 insertions(+), 568 deletions(-)

-- 
1.8.3.1

