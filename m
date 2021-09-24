Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BE341757C
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345985AbhIXNYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345612AbhIXNYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:48 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EF3C061787
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:03 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id j16-20020adfa550000000b0016012acc443so7988321wrb.14
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OK6zX7a7Qmpm9rcrKEHoYPqhV/r9BP9zx58SZZJogJ0=;
        b=GNrClkroJVv0xqGduCn431JjZYAgBcefo+GE2TtYTnpcG56X7HcTUhuRaLKJwneHtE
         eSL4iKbTDAxftMm+g7YkiMcfTB5GLfW11rOgyvSI/bXARk1QentPTxUFSjZ3nZDWgtJN
         FRMfEPmokHDXnbzKTDL10PC9zZ71dVwOLJIOGRjlnKvUOmU1MzuIHy2ZeGdR7tHderJS
         nqkwYljbsEaTvhdirFplNdFPitdYKaHLa85GXk++V/vBi4FyFZlBGbMi1JehX4vJixKB
         MhVKCofHHsmuf9wwcd8UHhQPyfR32ofqDqOySXA1+3kmeeQbQAZo62i8fUQi0pYU/mTX
         vIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OK6zX7a7Qmpm9rcrKEHoYPqhV/r9BP9zx58SZZJogJ0=;
        b=BtuvP1MWC6zCXOFw6r8P75b69GgGgcViBs822BghX9LvPoxXxuSNASTqs9Oylv6mx8
         fVKmz3ZGnnmXVNvaBH0ImYB5dxfW5TIvFSNasSO1uvpV/Xtttd7S/EOT9LYRutcl/D57
         850gCXcTG9tTvi4q/hMDCk0EvAZF5PXkIImYjsf0O84pxA8+1KxIP7v5IhWtWjHUhp0A
         aHrWVM9P2Ml3AqmvKtxGUhiTS/aDYL60jq4dSY7JlltAPyG5CJXlVPuhTGdOS2MaNupL
         0z0KhiGDMsk4g9nT8aWFGJWDgGKTHLzoy/J5LnWMPS8Rhjt6fCsxR/M2tcqNSxXgIP47
         9TLg==
X-Gm-Message-State: AOAM531diFYnWapVmAyDD8oRuE2s3zwDTSrI98z5hlCqRkqlK5XHcydo
        gQPKqt89FsGk0q8ti7l9a0ZFKYNu7g==
X-Google-Smtp-Source: ABdhPJwbJMTUwuBvfVMKqt+69OKDT6aY4QYIvI5Vf0wA9E0WLxB6W8XSl5oavUA13H1PTMaEnRHHfEPidg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:22d6:: with SMTP id
 22mr2005356wmg.17.1632488041842; Fri, 24 Sep 2021 05:54:01 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:29 +0100
Message-Id: <20210924125359.2587041-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 00/30] Reduce scope of vcpu state at hyp by refactoring
 out state hyp needs
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a prolog to a series where we try to maintain virtual machine and vcpu
state for protected VMs at the hypervisor [1].

The main issue is that in KVM, the VM state (struct kvm) and the vcpu state
(struct kvm_vcpu) are created by the host and are always accessible by it. For
protected VMs (pKVM [2]), only the hypervisor should have access to their state
and not trust the host to access it. Therefore, the hypervisor should maintain
a copy of VM state for all protected VMs to use that is not accessible by the
host.

The problem with using and with maintaining a copy of the existing kvm_vcpu
struct at the hypervisor is that it's big. Depending on the configuration, it
is in the order of 10kB (ymmv) per vcpu. Whereas most of what it needs to run a
VM is the kvm_cpu_ctxt and some hyp-related registers and flags, which amount
to less than 2kB. Many of the functions use the vcpu struct when all they
access is kvm_cpu_ctxt. Other functions only need that as well as a few
hypervisor state variables. Moreover, we would like to use the existing code,
rather than write new code for protected VMs that use new or special
structures.

This patch series reduces the scope of the functions that only need
kvm_cpu_ctxt to just that. It also takes out the few elements that are relevant
to the hypervisor from kvm_vcpu_arch into a new structure, vcpu_hyp_state. This
allows the remainder of the series to reduce the scope of everything accessed
by the hypervisor, at least for protected VMs, to kvm_cpu_ctxt and
vcpu_hyp_state (and maybe vgic if supported for protected VMs).

This series uses coccinelle semantic patches [3] as much as possible when
changes are made repetitively across many files. All patches that use
coccinelle are prefixed with COCCI.

Based on Linux 5.13-rc6.

Cheers,
/fuad

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2-state-cocci-out

[2] Once complete, protected KVM adds the ability to create protected VMs.
These protected VMs are protected from the host Linux kernel (and from other
VMs), where the host does not have access to guest memory,even if compromised.
Normal (nVHE) guests can still be created and run in parallel with protected
VMs. Their functionality should not be affected.

For protected VMs, the host should not even have access to a protected guest's
state or anything that would enable it to manipulate it (e.g., vcpu register
context and el2 system registers); only hyp would have that access. If the host
could access that state, then it might be able to get around the protection
provided.  Therefore, anything that is sensitive and that would require such
access needs to happen at hyp, hence the code in nvhe running only at hyp.

For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/slides/kvmforum-2020-edited.pdf
https://www.youtube.com/watch?v=edqJSzsDRxk

[3] https://coccinelle.gitlabpages.inria.fr/website/

Fuad Tabba (30):
  KVM: arm64: placeholder to check if VM is protected
  [DONOTMERGE] Temporarily disable unused variable warning
  [DONOTMERGE] Coccinelle scripts for refactoring
  KVM: arm64: remove unused parameters and asm offsets
  KVM: arm64: add accessors for kvm_cpu_context
  KVM: arm64: COCCI: use_ctxt_access.cocci: use kvm_cpu_context
    accessors
  KVM: arm64: COCCI: add_ctxt.cocci use_ctxt.cocci: reduce scope of
    functions to kvm_cpu_ctxt
  KVM: arm64: add hypervisor state accessors
  KVM: arm64: COCCI: vcpu_hyp_accessors.cocci: use accessors for
    hypervisor state vcpu variables
  KVM: arm64: Add accessors for hypervisor state in kvm_vcpu_arch
  KVM: arm64: create and use a new vcpu_hyp_state struct
  KVM: arm64: COCCI: add_hypstate.cocci use_hypstate.cocci: Reduce scope
    of functions to hyp_state
  KVM: arm64: change function parameters to use kvm_cpu_ctxt and
    hyp_state
  KVM: arm64: reduce scope of vgic v2
  KVM: arm64: COCCI: vgic3_cpu.cocci: reduce scope of vgic v3
  KVM: arm64: reduce scope of vgic_v3 access parameters
  KVM: arm64: access __hyp_running_vcpu via accessors only
  KVM: arm64: reduce scope of __guest_exit to only depend on
    kvm_cpu_context
  KVM: arm64: change calls of get_loaded_vcpu to get_loaded_vcpu_ctxt
  KVM: arm64: add __hyp_running_ctxt and __hyp_running_hyps
  KVM: arm64: transition code to __hyp_running_ctxt and
    __hyp_running_hyps
  KVM: arm64: reduce scope of __guest_enter to depend only on
    kvm_cpu_ctxt
  KVM: arm64: COCCI: remove_unused.cocci: remove unused ctxt and
    hypstate variables
  KVM: arm64: remove unused functions
  KVM: arm64: separate kvm_run() for protected VMs
  KVM: arm64: pVM activate_traps to use vcpu_ctxt and vcpu_hyp_state
  KVM: arm64: remove unsupported pVM features
  KVM: arm64: reduce scope of pVM fixup_guest_exit to hyp_state and
    kvm_cpu_ctxt
  [DONOTMERGE] Remove Coccinelle scripts added for refactoring
  [DONOTMERGE] Re-enable warnings

 arch/arm64/include/asm/kvm_asm.h           |  33 ++-
 arch/arm64/include/asm/kvm_emulate.h       | 292 ++++++++++++++++-----
 arch/arm64/include/asm/kvm_host.h          | 110 ++++++--
 arch/arm64/include/asm/kvm_hyp.h           |  14 +-
 arch/arm64/kernel/asm-offsets.c            |   7 +-
 arch/arm64/kvm/arm.c                       |   2 +-
 arch/arm64/kvm/debug.c                     |  28 +-
 arch/arm64/kvm/fpsimd.c                    |  22 +-
 arch/arm64/kvm/guest.c                     |  30 +--
 arch/arm64/kvm/handle_exit.c               |   8 +-
 arch/arm64/kvm/hyp/aarch32.c               |  26 +-
 arch/arm64/kvm/hyp/entry.S                 |  23 +-
 arch/arm64/kvm/hyp/exception.c             | 113 ++++----
 arch/arm64/kvm/hyp/hyp-entry.S             |   8 +-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  26 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 101 ++++---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 +--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/host.S             |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           | 155 ++++++++---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c         |   4 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |  32 ++-
 arch/arm64/kvm/hyp/vgic-v3-sr.c            | 242 +++++++++++------
 arch/arm64/kvm/hyp/vhe/switch.c            |  40 +--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         |   3 +-
 arch/arm64/kvm/inject_fault.c              |  10 +-
 arch/arm64/kvm/reset.c                     |  16 +-
 arch/arm64/kvm/sys_regs.c                  |   4 +-
 29 files changed, 951 insertions(+), 459 deletions(-)


base-commit: 6d53b3be3b9be497fbe054f35154f508deac729c
-- 
2.33.0.685.g46640cef36-goog

