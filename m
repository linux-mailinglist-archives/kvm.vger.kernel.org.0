Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7BA2C2E82
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 18:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390860AbgKXR1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 12:27:12 -0500
Received: from foss.arm.com ([217.140.110.172]:44898 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390725AbgKXR1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 12:27:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18C011396;
        Tue, 24 Nov 2020 09:27:11 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6253F3F71F;
        Tue, 24 Nov 2020 09:27:10 -0800 (PST)
Subject: Re: [PATCH 0/8] KVM: arm64: Disabled PMU handling
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com
References: <20201113182602.471776-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <750f5543-054a-f1aa-229f-2d41b8e233dd@arm.com>
Date:   Tue, 24 Nov 2020 17:28:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113182602.471776-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

I believe there is something missing from this series.

The original behaviour, which this series changes, was not to do register
emulation and PMU state update if the PMU wasn't ready, where vcpu->arch.pmu.ready
was set to true if the PMU was initialized properly in kvm_vcpu_first_run_init()
-> kvm_arm_pmu_v3_enable().

The series changes PMU emulation such that register emulation and pmu state update
is gated only on the VCPU feature being set. This means that now userspace can set
the VCPU feature, don't do any initialization, and run a guest which can access
PMU registers. Also kvm_pmu_update_state() will now be called before each VM
entry. I'm not exactly sure what happens if we call kvm_vgic_inject_irq() for an
irq_num = 0 and not owned by the PMU (the owner is set KVM_ARM_VCPU_PMU_V3_INIT ->
kvm_arm_pmu_v3_init()), but I don't think that's allowed.

I was also able to trigger this warning with a modified version of kvmtool:

[  118.972174] ------------[ cut here ]------------
[  118.974212] Unknown PMU version 0
[  118.977622] WARNING: CPU: 0 PID: 238 at arch/arm64/kvm/pmu-emul.c:33
kvm_pmu_event_mask.isra.0+0x6c/0x74
[  118.987271] Modules linked in:
[  118.990414] CPU: 0 PID: 238 Comm: kvm-vcpu-0 Not tainted
5.10.0-rc4-00008-gc4cd5186fc2a #37
[  118.999006] Hardware name: Globalscale Marvell ESPRESSOBin Board (DT)
[  119.005641] pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=--)
[  119.011825] pc : kvm_pmu_event_mask.isra.0+0x6c/0x74
[  119.016929] lr : kvm_pmu_event_mask.isra.0+0x6c/0x74
[  119.022034] sp : ffff80001274ba40
[  119.025438] x29: ffff80001274ba40 x28: ffff0000091c46a0
[  119.030903] x27: 0000000000000000 x26: ffff800011e16ee0
[  119.036368] x25: ffff800011e166c8 x24: ffff000006e00000
[  119.041834] x23: 0000000000000000 x22: ffff80001274bb20
[  119.047300] x21: 0000000000000000 x20: 000000000000001f
[  119.052765] x19: 0000000000000000 x18: 0000000000000030
[  119.058231] x17: 0000000000000000 x16: 0000000000000000
[  119.063697] x15: ffff0000022caf30 x14: ffffffffffffffff
[  119.069163] x13: ffff800011b72718 x12: 0000000000000456
[  119.074627] x11: 0000000000000172 x10: ffff800011bca718
[  119.080094] x9 : 00000000fffff000 x8 : ffff800011b72718
[  119.085559] x7 : ffff800011bca718 x6 : 0000000000000000
[  119.091025] x5 : 0000000000000000 x4 : ffff00003ddbe900
[  119.096491] x3 : ffff00003ddc57f0 x2 : ffff00003ddbe900
[  119.101956] x1 : 34d0d4b3321b9100 x0 : 0000000000000000
[  119.107422] Call trace:
[  119.109935]  kvm_pmu_event_mask.isra.0+0x6c/0x74
[  119.114684]  kvm_pmu_set_counter_event_type+0x2c/0x80
[  119.119882]  access_pmu_evtyper+0x128/0x180
[  119.124181]  perform_access+0x34/0xb0
[  119.127942]  kvm_handle_sys_reg+0xc8/0x160
[  119.132156]  handle_exit+0x6c/0x1f0
[  119.135738]  kvm_arch_vcpu_ioctl_run+0x1e8/0x73c
[  119.140488]  kvm_vcpu_ioctl+0x23c/0x544
[  119.144433]  __arm64_sys_ioctl+0xa8/0xf0
[  119.148464]  el0_svc_common.constprop.0+0x78/0x1a0
[  119.153390]  do_el0_svc+0x24/0x90
[  119.156796]  el0_sync_handler+0x254/0x260
[  119.160915]  el0_sync+0x174/0x180
[  119.164319] ---[ end trace c0c2e6f299d58823 ]---

I removed all KVM_ARM_VCPU_PMU_V3_CTRL ioctl calls from kvmtool's pmu emulation,
and I started the pmu test from kvm-unit-tests:

$ ./lkvm-pmu run -c1 -m64 -f arm/pmu.flat --pmu -p cycle-counter

The reason for the warning is that the correct value for kvm->arch.pmuver is set
in kvm_arm_pmu_v3_set_attr(), which is not called anymore.

This diff seems to solve the issue:

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 643cf819f3c0..150b9cb0f741 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -825,9 +825,12 @@ bool kvm_arm_support_pmu_v3(void)
 
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
-       if (!vcpu->arch.pmu.created)
+       if (!kvm_vcpu_has_pmu(vcpu))
                return 0;
 
+       if (!vcpu->arch.pmu.created)
+               return -ENOEXEC;
+
        /*
         * A valid interrupt configuration for the PMU is either to have a
         * properly configured interrupt number and using an in-kernel

If you agree with the fix, I can send a proper patch. vcpu->arch.pmu.created is
set in kvm_arm_pmu_v3_init(), which checks if the interrupt ID has been set. I
chose to return -ENOEXEC  because that's what KVM_RUN returns if the vcpu isn't
initialized in kvm_arch_vcpu_ioctl_run().

Thanks,

Alex

On 11/13/20 6:25 PM, Marc Zyngier wrote:
> It recently dawned on me that the way we handle PMU traps when the PMU
> is disabled is plain wrong. We consider that handling the registers as
> RAZ/WI is a fine thing to do, while the ARMv8 ARM is pretty clear that
> that's not OK and that such registers should UNDEF when FEAT_PMUv3
> doesn't exist. I went all the way back to the first public version of
> the spec, and it turns out we were *always* wrong.
>
> It probably comes from the fact that we used not to trap the ID
> registers, and thus were unable to advertise the lack of PMU, but
> that's hardly an excuse. So let's fix the damned thing.
>
> This series adds an extra check in the helpers that check for the
> validity of the PMU access (most of the registers have to checked
> against some enable flags and/or the accessing exception level), and
> rids us of the RAZ/WI behaviour.
>
> This enables us to make additional cleanups, to the point where we can
> remove the PMU "ready" state that always had very bizarre semantics.
> All in all, a negative diffstat, and spec compliant behaviours. What's
> not to like?
>
> I've run a few guests with and without PMUs as well as KUT, and
> nothing caught fire. The patches are on top of kvmarm/queue.
>
> Marc Zyngier (8):
>   KVM: arm64: Add kvm_vcpu_has_pmu() helper
>   KVM: arm64: Set ID_AA64DFR0_EL1.PMUVer to 0 when no PMU support
>   KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at reset time
>   KVM: arm64: Inject UNDEF on PMU access when no PMU configured
>   KVM: arm64: Remove PMU RAZ/WI handling
>   KVM: arm64: Remove dead PMU sysreg decoding code
>   KVM: arm64: Gate kvm_pmu_update_state() on the PMU feature
>   KVM: arm64: Get rid of the PMU ready state
>
>  arch/arm64/include/asm/kvm_host.h |  3 ++
>  arch/arm64/kvm/pmu-emul.c         | 11 +++----
>  arch/arm64/kvm/reset.c            |  4 +++
>  arch/arm64/kvm/sys_regs.c         | 51 ++++++++-----------------------
>  include/kvm/arm_pmu.h             |  3 --
>  5 files changed, 24 insertions(+), 48 deletions(-)
>
