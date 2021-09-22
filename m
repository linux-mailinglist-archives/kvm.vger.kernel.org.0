Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE27414CF6
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 17:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbhIVP16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 11:27:58 -0400
Received: from foss.arm.com ([217.140.110.172]:50570 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhIVP1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 11:27:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02B10113E;
        Wed, 22 Sep 2021 08:26:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 402223F718;
        Wed, 22 Sep 2021 08:26:22 -0700 (PDT)
Message-ID: <58cfa897-7e8e-44a8-fda4-6f8ddb582644@arm.com>
Date:   Wed, 22 Sep 2021 16:27:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v8 0/8] KVM: arm64: Add idempotent controls to migrate
 guest counter
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181510.963449-1-oupton@google.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

This looks interesting, I am going to try to do my best to review the series. I
haven't followed the patches until this version, so I might be missing part of the
context when I post my comments.

Thanks,

Alex

On 9/16/21 19:15, Oliver Upton wrote:
> Currently, on KVM/arm64, we only allow a VMM to migrate the guest's
> virtual counter by-value. Saving and restoring the counter by value is
> problematic in the fact that the recorded state is not idempotent.
> Furthermore, we obfuscate from userspace the fact that the architecture
> actually provides offset-based controls.
>
> Another issue is that KVM/arm64 doesn't provide userspace with the
> controls of the physical counter-timer. This series aims to address both
> issues by adding offset-based controls for the virtual and physical
> counters.
>
> Patches 1-2 are refactor changes required to provide offset controls to
> userspace and putting in some generic plumbing to use for both physical
> and virtual offsets.
>
> Patch 3 is a minor refactor, creating a helper function to get the
> number of timer registers for a particular vCPU.
>
> Patch 4 exposes a vCPU's virtual offset through the KVM_*_ONE_REG
> ioctls. When NV support is added to KVM, CNTVOFF_EL2 will be considered
> a guest system register. So, it is safe to expose it now through that
> ioctl.
>
> Patch 5 adds a cpufeature bit to detect 'full' ECV implementations,
> providing EL2 with the ability to offset the physical counter-timer.
>
> Patch 6 exposes a vCPU's physical offset as a vCPU device attribute.
> This is deliberate, as the attribute is not architectural; KVM uses this
> attribute to track the host<->guest offset.
>
> Patch 7 is a prepatory change for the sake of physical offset emulation,
> as counter-timer traps must be configured separately for each vCPU.
>
> Patch 8 allows non-ECV hosts to support the physical offset vCPU device
> attribute, by trapping and emulating the physical counter registers.
>
> This series was tested on an Ampere Mt. Jade system (non-ECV, VHE and
> nVHE). I did not test this on the FVP, as I need to really figure out
> tooling for it on my workstation.
>
> Applies cleanly to v5.15-rc1
>
> v7: http://lore.kernel.org/r/20210816001217.3063400-1-oupton@google.com
>
> v7 -> v8:
>  - Only use ECV if !VHE
>  - Only expose CNTVOFF_EL2 register to userspace with opt-in
>  - Refer to the direct_ptimer explicitly
>
> Oliver Upton (8):
>   KVM: arm64: Refactor update_vtimer_cntvoff()
>   KVM: arm64: Separate guest/host counter offset values
>   KVM: arm64: Make a helper function to get nr of timer regs
>   KVM: arm64: Allow userspace to configure a vCPU's virtual offset
>   arm64: cpufeature: Enumerate support for FEAT_ECV >= 0x2
>   KVM: arm64: Allow userspace to configure a guest's counter-timer
>     offset
>   KVM: arm64: Configure timer traps in vcpu_load() for VHE
>   KVM: arm64: Emulate physical counter offsetting on non-ECV systems
>
>  Documentation/arm64/booting.rst         |   7 +
>  Documentation/virt/kvm/api.rst          |  23 +++
>  Documentation/virt/kvm/devices/vcpu.rst |  28 ++++
>  arch/arm64/include/asm/kvm_host.h       |   3 +
>  arch/arm64/include/asm/sysreg.h         |   5 +
>  arch/arm64/include/uapi/asm/kvm.h       |   2 +
>  arch/arm64/kernel/cpufeature.c          |  10 ++
>  arch/arm64/kvm/arch_timer.c             | 196 +++++++++++++++++++++---
>  arch/arm64/kvm/arm.c                    |   9 +-
>  arch/arm64/kvm/guest.c                  |  28 +++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  32 ++++
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  11 +-
>  arch/arm64/tools/cpucaps                |   1 +
>  include/clocksource/arm_arch_timer.h    |   1 +
>  include/kvm/arm_arch_timer.h            |  14 +-
>  include/uapi/linux/kvm.h                |   1 +
>  16 files changed, 337 insertions(+), 34 deletions(-)
>
