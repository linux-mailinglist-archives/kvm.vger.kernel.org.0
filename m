Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7106EFB4D
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbjDZTrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbjDZTrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061762701
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682538400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vSr52G4zlg8DfNeN6fOnKgdJw7y+ySKAE/n/2yKiqlg=;
        b=a/pvKUTeJV7v4JRC0YxwckEYbdH30/wG/IfVv5/Z8XVQ0s9XIfxgul5fIyBK8tK46GlShz
        OfS3o4VjKpXIxPkUJgtjh2ez9Q5MfpNMxApxd4vLoNpQoeDImRJJqh7Aq/rKp9dgxvVz0w
        KciF4PTMEmUEr4Kpk6wuVNNAHJKXo9s=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-St03i02lP7SypEbZyOIfUA-1; Wed, 26 Apr 2023 15:46:39 -0400
X-MC-Unique: St03i02lP7SypEbZyOIfUA-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-4302bba96e4so1826423137.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538398; x=1685130398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vSr52G4zlg8DfNeN6fOnKgdJw7y+ySKAE/n/2yKiqlg=;
        b=OSEOwzwuOv7/4PRmINPlK2mY97tts9UGe9G63RrnXMVpxc/CrAaUIW3euHilYxd5U2
         IJJhNWREX3FSJ4AsLs+nJt2zPLsjjcSWXTWGZB72NCWs4qqKJszlfPD2eEZv/WE/kUZV
         mBXgknSsNb5Y5neT++cLAbdbE5sSzNOpv1jJumqxTbVnlLAF7oN0IAvJeC3n0AOdAnIs
         8Lctqo8NibwsQ8XASIP2HSqkOyfw9VAJSeU+GCKiDLgecHKY+XzJD58B2BJTUFGMcHZ9
         a1q6d7LhOn+l/u5mAOUhUsItMISkxkIEK9PJs17fPnXlHJ+ultTAZSTYGJZY6iUYnliE
         TjdA==
X-Gm-Message-State: AAQBX9fUV7GZzQBpGrpIskdA9ygIJ+T3lx+a5dGYdnBVXGJlQvgS/btp
        /50vH6hs96vTm0OUU96FVTl9NChipgpkRZUrCg8A5Vc7H7KqCPaxXFsuo9Wco1ooPxlafMEreOE
        Hb932so2fPmwKoOJ598xBFneAHB7F
X-Received: by 2002:a05:6102:356a:b0:42f:fae5:3b98 with SMTP id bh10-20020a056102356a00b0042ffae53b98mr8964398vsb.14.1682538398268;
        Wed, 26 Apr 2023 12:46:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z/uUM8A1aq6a3CFzFBs418t4Q1bWSEphk+cg1XMVRNt4S/GZCjPVW4/1MX/0YMIGZ2ONTUk9dh9BOYt/iAPQw=
X-Received: by 2002:a05:6102:356a:b0:42f:fae5:3b98 with SMTP id
 bh10-20020a056102356a00b0042ffae53b98mr8964382vsb.14.1682538397947; Wed, 26
 Apr 2023 12:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230421104005.3017731-1-maz@kernel.org>
In-Reply-To: <20230421104005.3017731-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:46:26 +0200
Message-ID: <CABgObfY63ytE8EOxpYQ39v8ptFtJJZxeoa4jmcoFA0UQ9+jsuw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for v6.4
To:     Marc Zyngier <maz@kernel.org>
Cc:     Christoffer Dall <christoffer.dall@arm.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        Colton Lewis <coltonlewis@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 12:40=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Hi Paolo,
>
> Here's the initial set of changes for KVM/arm64. A bunch of
> infrastructure changes this time around, with two new user
> visible changes (hypercall forwarding to userspace, global counter
> offset) and a large set of locking inversion fixes.
>
> The remaining of the patches contain the NV timer emulation code, and
> a small set of less important fixes/improvements.
>
> Please pull,

Queued, thanks!  I assume I'll get -rc pull requests from you as well
over the next two months?

Paolo

>        M.
>
> The following changes since commit 197b6b60ae7bc51dd0814953c562833143b292=
aa:
>
>   Linux 6.3-rc4 (2023-03-26 14:40:20 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-6.4
>
> for you to fetch changes up to 36fe1b29b3cae48f781011abd5a0b9e938f5b35f:
>
>   Merge branch kvm-arm64/spec-ptw into kvmarm-master/next (2023-04-21 09:=
44:58 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 updates for 6.4
>
> - Numerous fixes for the pathological lock inversion issue that
>   plagued KVM/arm64 since... forever.
>
> - New framework allowing SMCCC-compliant hypercalls to be forwarded
>   to userspace, hopefully paving the way for some more features
>   being moved to VMMs rather than be implemented in the kernel.
>
> - Large rework of the timer code to allow a VM-wide offset to be
>   applied to both virtual and physical counters as well as a
>   per-timer, per-vcpu offset that complements the global one.
>   This last part allows the NV timer code to be implemented on
>   top.
>
> - A small set of fixes to make sure that we don't change anything
>   affecting the EL1&0 translation regime just after having having
>   taken an exception to EL2 until we have executed a DSB. This
>   ensures that speculative walks started in EL1&0 have completed.
>
> - The usual selftest fixes and improvements.
>
> ----------------------------------------------------------------
> Colin Ian King (1):
>       KVM: selftests: Fix spelling mistake "KVM_HYPERCAL_EXIT_SMC" -> "KV=
M_HYPERCALL_EXIT_SMC"
>
> Marc Zyngier (33):
>       KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for fract=
ional ns
>       arm64: Add CNTPOFF_EL2 register definition
>       arm64: Add HAS_ECV_CNTPOFF capability
>       KVM: arm64: timers: Use CNTPOFF_EL2 to offset the physical timer
>       KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
>       KVM: arm64: Expose {un,}lock_all_vcpus() to the rest of KVM
>       KVM: arm64: timers: Allow userspace to set the global counter offse=
t
>       KVM: arm64: timers: Allow save/restoring of the physical timer
>       KVM: arm64: timers: Rationalise per-vcpu timer init
>       KVM: arm64: timers: Abstract per-timer IRQ access
>       KVM: arm64: timers: Move the timer IRQs into arch_timer_vm_data
>       KVM: arm64: Elide kern_hyp_va() in VHE-specific parts of the hyperv=
isor
>       KVM: arm64: timers: Fast-track CNTPCT_EL0 trap handling
>       KVM: arm64: timers: Abstract the number of valid timers per vcpu
>       KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
>       KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
>       KVM: arm64: nv: timers: Support hyp timer emulation
>       KVM: arm64: selftests: Add physical timer registers to the sysreg l=
ist
>       KVM: arm64: selftests: Deal with spurious timer interrupts
>       KVM: arm64: selftests: Augment existing timer test to handle variab=
le offset
>       KVM: arm64: Expose SMC/HVC width to userspace
>       KVM: arm64: nvhe: Synchronise with page table walker on vcpu run
>       KVM: arm64: Handle 32bit CNTPCTSS traps
>       KVM: arm64: nvhe: Synchronise with page table walker on TLBI
>       KVM: arm64: pkvm: Document the side effects of kvm_flush_dcache_to_=
poc()
>       KVM: arm64: vhe: Synchronise with page table walker on MMU update
>       KVM: arm64: vhe: Drop extra isb() on guest exit
>       Merge branch kvm-arm64/lock-inversion into kvmarm-master/next
>       Merge branch kvm-arm64/timer-vm-offsets into kvmarm-master/next
>       Merge branch kvm-arm64/selftest/lpa into kvmarm-master/next
>       Merge branch kvm-arm64/selftest/misc-6.4 into kvmarm-master/next
>       Merge branch kvm-arm64/smccc-filtering into kvmarm-master/next
>       Merge branch kvm-arm64/spec-ptw into kvmarm-master/next
>
> Mark Brown (1):
>       KVM: selftests: Comment newly defined aarch64 ID registers
>
> Oliver Upton (20):
>       KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
>       KVM: arm64: Avoid lock inversion when setting the VM register width
>       KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
>       KVM: arm64: Use config_lock to protect vgic state
>       KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
>       KVM: arm64: Add a helper to check if a VM has ran once
>       KVM: arm64: Add vm fd device attribute accessors
>       KVM: arm64: Rename SMC/HVC call handler to reflect reality
>       KVM: arm64: Start handling SMCs from EL1
>       KVM: arm64: Refactor hvc filtering to support different actions
>       KVM: arm64: Use a maple tree to represent the SMCCC filter
>       KVM: arm64: Add support for KVM_EXIT_HYPERCALL
>       KVM: arm64: Introduce support for userspace SMCCC filtering
>       KVM: arm64: Return NOT_SUPPORTED to guest for unknown PSCI version
>       KVM: arm64: Let errors from SMCCC emulation to reach userspace
>       KVM: selftests: Add a helper for SMCCC calls with SMC instruction
>       KVM: selftests: Add test for SMCCC filter
>       KVM: arm64: Prevent userspace from handling SMC64 arch range
>       KVM: arm64: Test that SMC64 arch calls are reserved
>       KVM: arm64: vgic: Don't acquire its_lock before config_lock
>
> Reiji Watanabe (2):
>       KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init(=
)
>       KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE() to update mp_s=
tate
>
> Ryan Roberts (3):
>       KVM: selftests: Fixup config fragment for access_tracking_perf_test
>       KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48
>       KVM: selftests: arm64: Fix ttbr0_el1 encoding for PA bits > 48
>
>  Documentation/virt/kvm/api.rst                     |  71 ++-
>  Documentation/virt/kvm/devices/vm.rst              |  79 +++
>  arch/arm64/include/asm/kvm_host.h                  |  25 +-
>  arch/arm64/include/asm/kvm_mmu.h                   |   4 +
>  arch/arm64/include/asm/sysreg.h                    |   3 +
>  arch/arm64/include/uapi/asm/kvm.h                  |  36 ++
>  arch/arm64/kernel/cpufeature.c                     |  11 +
>  arch/arm64/kvm/arch_timer.c                        | 550 +++++++++++++++=
+-----
>  arch/arm64/kvm/arm.c                               | 147 +++++-
>  arch/arm64/kvm/guest.c                             |  31 +-
>  arch/arm64/kvm/handle_exit.c                       |  36 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  53 ++
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   2 -
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   7 +
>  arch/arm64/kvm/hyp/nvhe/switch.c                   |  18 +
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c                 |  18 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c                      |  38 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                    |   7 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  12 +
>  arch/arm64/kvm/hypercalls.c                        | 189 ++++++-
>  arch/arm64/kvm/pmu-emul.c                          |  25 +-
>  arch/arm64/kvm/psci.c                              |  37 +-
>  arch/arm64/kvm/reset.c                             |  15 +-
>  arch/arm64/kvm/sys_regs.c                          |  10 +
>  arch/arm64/kvm/trace_arm.h                         |   6 +-
>  arch/arm64/kvm/vgic/vgic-debug.c                   |   8 +-
>  arch/arm64/kvm/vgic/vgic-init.c                    |  36 +-
>  arch/arm64/kvm/vgic/vgic-its.c                     |  33 +-
>  arch/arm64/kvm/vgic/vgic-kvm-device.c              |  85 ++--
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   4 +-
>  arch/arm64/kvm/vgic/vgic-mmio.c                    |  12 +-
>  arch/arm64/kvm/vgic/vgic-v4.c                      |  11 +-
>  arch/arm64/kvm/vgic/vgic.c                         |  27 +-
>  arch/arm64/kvm/vgic/vgic.h                         |   3 -
>  arch/arm64/tools/cpucaps                           |   1 +
>  arch/arm64/tools/sysreg                            |   4 +
>  arch/x86/include/asm/kvm_host.h                    |   7 +
>  arch/x86/include/uapi/asm/kvm.h                    |   3 +
>  arch/x86/kvm/x86.c                                 |   6 +-
>  include/clocksource/arm_arch_timer.h               |   1 +
>  include/kvm/arm_arch_timer.h                       |  34 +-
>  include/kvm/arm_hypercalls.h                       |   6 +-
>  include/kvm/arm_vgic.h                             |   1 +
>  include/uapi/linux/kvm.h                           |  12 +-
>  tools/testing/selftests/kvm/Makefile               |   1 +
>  tools/testing/selftests/kvm/aarch64/arch_timer.c   |  56 ++-
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c |  15 +-
>  tools/testing/selftests/kvm/aarch64/smccc_filter.c | 268 ++++++++++
>  tools/testing/selftests/kvm/config                 |   1 +
>  .../selftests/kvm/include/aarch64/processor.h      |  13 +
>  .../testing/selftests/kvm/lib/aarch64/processor.c  |  91 ++--
>  51 files changed, 1759 insertions(+), 410 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/smccc_filter.c
>

