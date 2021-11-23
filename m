Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B061A45A70A
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 16:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbhKWQCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 11:02:08 -0500
Received: from foss.arm.com ([217.140.110.172]:55416 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234170AbhKWQCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 11:02:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E98C1FB;
        Tue, 23 Nov 2021 07:58:59 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6261A3F5A1;
        Tue, 23 Nov 2021 07:58:56 -0800 (PST)
Date:   Tue, 23 Nov 2021 16:00:48 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH v3 00/29] KVM: arm64: Make CPU ID registers writable
 by userspace
Message-ID: <YZ0QMK1QFjw/uznl@monolith.localdoman>
References: <20211117064359.2362060-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

I started reviewing the series, but I ended up being very confused, see
below.

On Tue, Nov 16, 2021 at 10:43:30PM -0800, Reiji Watanabe wrote:
> In KVM/arm64, values of ID registers for a guest are mostly same as
> its host's values except for bits for feature that KVM doesn't support
> and for opt-in features that userspace didn't configure.  Userspace
> can use KVM_SET_ONE_REG to a set ID register value, but it fails
> if userspace attempts to modify the register value.
> 
> This patch series adds support to allow userspace to modify a value of
> ID registers (as long as KVM can support features that are indicated
> in the registers) so userspace can have more control of configuring
> and unconfiguring features for guests.

What not use VCPU features? Isn't that why the field
kvm_vcpu_init->features exists in the first place? This cover letter does
nothing to explaing why any changes are needed.

Do you require finer grained control over certain feature that you cannot
get with the 32 * 7 = 224 feature flag bits from kvm_vcpu_init? Does using
the ID registers simplify certain aspects of the implementation?

Thanks,
Alex

> 
> The patch series is for both VHE and non-VHE, except for protected VMs,
> which have a different way of configuring ID registers based on its
> different requirements [1].
> There was a patch series that tried to achieve the same thing [2].
> A few snippets of codes in this series were inspired by or came from [2].
> 
> The initial value of ID registers for a vCPU will be the host's value
> with bits cleared for unsupported features and for opt-in features that
> were not configured. So, the initial value userspace can see (via
> KVM_GET_ONE_REG) is the upper limit that can be set for the register.
> Any requests to change the value that conflicts with opt-in features'
> configuration will fail.
> 
> When a guest tries to use a CPU feature that is not exposed to the guest,
> trapping it (to emulate a real CPU's behavior) would generally be a
> desirable behavior (when it is possible with no or little side effects).
> The later patches in the series add codes for this.  Only features that
> can be trapped independently will be trapped by this series though.
> 
> This series adds kunit tests for new functions in sys_regs.c (except for
> trivial ones), and these tests are enabled with a new configuration
> option 'CONFIG_KVM_KUNIT_TEST'.
> 
> The series is based on v5.16-rc1.
> 
> v3:
>   - Remove ID register consistency checking across vCPUs [Oliver]
>   - Change KVM_CAP_ARM_ID_REG_WRITABLE to
>     KVM_CAP_ARM_ID_REG_CONFIGURABLE [Oliver]
>   - Add KUnit testing for ID register validation and trap initialization.
>   - Change read_id_reg() to take care of ID_AA64PFR0_EL1.GIC
>   - Add a helper of read_id_reg() (__read_id_reg()) and use the helper
>     instead of directly using __vcpu_sys_reg()
>   - Change not to run kvm_id_regs_consistency_check() and
>     kvm_vcpu_init_traps() for protected VMs.
>   - Update selftest to remove test cases for ID register consistency
>     checking across vCPUs and to add test cases for ID_AA64PFR0_EL1.GIC.
> 
> v2: https://lore.kernel.org/all/20211103062520.1445832-1-reijiw@google.com/
>   - Remove unnecessary line breaks. [Andrew]
>   - Use @params for comments. [Andrew]
>   - Move arm64_check_features to arch/arm64/kvm/sys_regs.c and
>     change that KVM specific feature check function.  [Andrew]
>   - Remove unnecessary raz handling from __set_id_reg. [Andrew]
>   - Remove sys_val field from the initial id_reg_info and add it
>     in the later patch. [Andrew]
>   - Call id_reg->init() from id_reg_info_init(). [Andrew]
>   - Fix cpuid_feature_cap_perfmon_field() to convert 0xf to 0x0
>     (and use it in the following patches).
>   - Change kvm_vcpu_first_run_init to set has_run_once to false
>     when kvm_id_regs_consistency_check() fails.
>   - Add a patch to introduce id_reg_info for ID_AA64MMFR0_EL1,
>     which requires special validity checking for TGran*_2 fields.
>   - Add patches to introduce id_reg_info for ID_DFR1_EL1 and
>     ID_MMFR0_EL1, which are required due to arm64_check_features
>     implementation change.
>   - Add a new argument, which is a pointer to id_reg_info, for
>     id_reg_info's validate()
> 
> v1: https://lore.kernel.org/all/20211012043535.500493-1-reijiw@google.com/
> 
> [1] https://lore.kernel.org/kvmarm/20211010145636.1950948-1-tabba@google.com/
> [2] https://lore.kernel.org/kvm/20201102033422.657391-1-liangpeng10@huawei.com/
> 
> Reiji Watanabe (29):
>   KVM: arm64: Add has_reset_once flag for vcpu
>   KVM: arm64: Save ID registers' sanitized value per vCPU
>   KVM: arm64: Introduce struct id_reg_info
>   KVM: arm64: Make ID_AA64PFR0_EL1 writable
>   KVM: arm64: Make ID_AA64PFR1_EL1 writable
>   KVM: arm64: Make ID_AA64ISAR0_EL1 writable
>   KVM: arm64: Make ID_AA64ISAR1_EL1 writable
>   KVM: arm64: Make ID_AA64MMFR0_EL1 writable
>   KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
>   KVM: arm64: Make ID_AA64DFR0_EL1 writable
>   KVM: arm64: Make ID_DFR0_EL1 writable
>   KVM: arm64: Make ID_DFR1_EL1 writable
>   KVM: arm64: Make ID_MMFR0_EL1 writable
>   KVM: arm64: Make MVFR1_EL1 writable
>   KVM: arm64: Make ID registers without id_reg_info writable
>   KVM: arm64: Add consistency checking for frac fields of ID registers
>   KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE capability
>   KVM: arm64: Add kunit test for ID register validation
>   KVM: arm64: Use vcpu->arch cptr_el2 to track value of cptr_el2 for VHE
>   KVM: arm64: Use vcpu->arch.mdcr_el2 to track value of mdcr_el2
>   KVM: arm64: Introduce framework to trap disabled features
>   KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
>   KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
>   KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
>   KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
>   KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
>   KVM: arm64: Initialize trapping of disabled CPU features for the guest
>   KVM: arm64: Add kunit test for trap initialization
>   KVM: arm64: selftests: Introduce id_reg_test
> 
>  Documentation/virt/kvm/api.rst                |    8 +
>  arch/arm64/include/asm/cpufeature.h           |    2 +-
>  arch/arm64/include/asm/kvm_arm.h              |   32 +
>  arch/arm64/include/asm/kvm_host.h             |   15 +
>  arch/arm64/include/asm/sysreg.h               |    2 +
>  arch/arm64/kvm/Kconfig                        |   11 +
>  arch/arm64/kvm/arm.c                          |   12 +-
>  arch/arm64/kvm/debug.c                        |   13 +-
>  arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
>  arch/arm64/kvm/reset.c                        |    4 +
>  arch/arm64/kvm/sys_regs.c                     | 1265 +++++++++++++++--
>  arch/arm64/kvm/sys_regs_test.c                | 1109 +++++++++++++++
>  include/uapi/linux/kvm.h                      |    1 +
>  tools/arch/arm64/include/asm/sysreg.h         |    1 +
>  tools/testing/selftests/kvm/.gitignore        |    1 +
>  tools/testing/selftests/kvm/Makefile          |    1 +
>  .../selftests/kvm/aarch64/id_reg_test.c       | 1128 +++++++++++++++
>  17 files changed, 3488 insertions(+), 131 deletions(-)
>  create mode 100644 arch/arm64/kvm/sys_regs_test.c
>  create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c
> 
> -- 
> 2.34.0.rc1.387.gb447b232ab-goog
> 
