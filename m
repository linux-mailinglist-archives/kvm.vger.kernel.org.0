Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9B93CDC57
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 17:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbhGSOwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 10:52:08 -0400
Received: from foss.arm.com ([217.140.110.172]:33380 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245468AbhGSOry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 10:47:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 151981FB;
        Mon, 19 Jul 2021 08:28:21 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91F053F66F;
        Mon, 19 Jul 2021 08:28:18 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>, maz@kernel.org
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, james.morse@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org,
        lorenzo.pieralisi@arm.com, salil.mehta@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com
References: <20210608154805.216869-1-jean-philippe@linaro.org>
Message-ID: <c29ff5c8-9c94-6a6c-6142-3bed440676bf@arm.com>
Date:   Mon, 19 Jul 2021 16:29:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210608154805.216869-1-jean-philippe@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean-Philippe,

I'm not really familiar with this part of KVM, and I'm still trying to get my head
around how this works, so please bare with me if I ask silly questions.

This is how I understand this will work:

1. VMM opts in to forward HVC calls not handled by KVM.

2. VMM opts in to forward PSCI calls, other than
PSCI_1_0_FN_PSCI_FEATURES(ARM_SMCCC_VERSION_FUNC_ID).

3. Guest emulates PSCI calls (and all the other HVC calls).

    3.a For CPU_SUSPEND coming from VCPU A, userspace does a
KVM_SET_MP_STATE(KVM_MP_STATE_HALTED) ioctl on the VCPU fd which sets the request
KVM_REQ_SUSPEND.

    3.b The next time the VCPU is run, KVM blocks the VCPU as a result of the
request. kvm_vcpu_block() does a schedule() in a loop until it decides that the
CPU must unblock.

    3.c The VCPU will run as normal after kvm_vcpu_block() returns.

Please correct me if I got something wrong.

I have a few general questions. It doesn't mean there's something wrong with your
approach, I'm just trying to understand it better.

1. Why forwarding PSCI calls to userspace depend on enabling forwarding for other
HVC calls? As I understand from the patches, those handle distinct function IDs.

2. HVC call forwarding to userspace also forwards PSCI functions which are defined
in ARM DEN 0022D, but not (yet) implemented by KVM. What happens if KVM's PSCI
implementation gets support for one of those functions? How does userspace know
that now it also needs to enable PSCI call forwarding to be able to handle that
function?

It looks to me like the boundary between the functions that are forwarded when HVC
call forwarding is enabled and the functions that are forwarded when PSCI call
forwarding is enabled is based on what Linux v5.13 handles. Have you considered
choosing this boundary based on something less arbitrary, like the function types
specified in ARM DEN 0028C, table 2-1?

In my opinion, setting the MP state to HALTED looks like a sensible approach to
implementing PSCI_SUSPEND. I'll take a closer look at the patches after I get a
better understanding about what is going on.

On 6/8/21 4:48 PM, Jean-Philippe Brucker wrote:
> Allow userspace to request handling PSCI calls from guests. Our goal is
> to enable a vCPU hot-add solution for Arm where the VMM presents
> possible resources to the guest at boot, and controls which vCPUs can be
> brought up by allowing or denying PSCI CPU_ON calls. Passing HVC and
> PSCI to userspace has been discussed on the list in the context of vCPU
> hot-add [1,2] but it can also be useful for implementing other SMCCC and
> vendor hypercalls [3,4,5].
>
> Patches 1-3 allow userspace to request WFI to be executed in KVM. That

I don't understand this. KVM, in kvm_vcpu_block(), does not execute an WFI.
PSCI_SUSPEND is documented as being indistinguishable from an WFI from the guest's
point of view, but it's implementation is not architecturally defined.

Thanks,

Alex

> way the VMM can easily implement the PSCI CPU_SUSPEND function, which is
> mandatory from PSCI v0.2 onwards (even if it doesn't have a more useful
> implementation than WFI, natively available to the guest).
>
> Patch 4 lets userspace request any HVC that isn't handled by KVM, and
> patch 5 lets userspace request PSCI calls, disabling in-kernel PSCI
> handling.
>
> I'm focusing on the PSCI bits, but a complete prototype of vCPU hot-add
> for arm64 on Linux and QEMU, most of it from Salil and James, is
> available at [6].
>
> [1] https://lore.kernel.org/kvmarm/82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com/
> [2] https://lore.kernel.org/linux-arm-kernel/20200625133757.22332-1-salil.mehta@huawei.com/
>     (Followed by KVM forum and Linaro Open discussions)
> [3] https://lore.kernel.org/linux-arm-kernel/f56cf420-affc-35f0-2355-801a924b8a35@arm.com/
> [4] https://lore.kernel.org/kvm/bf7e83f1-c58e-8d65-edd0-d08f27b8b766@arm.com/
> [5] https://lore.kernel.org/kvm/1569338454-26202-2-git-send-email-guoheyi@huawei.com/
> [6] https://jpbrucker.net/git/linux/log/?h=cpuhp/devel
>     https://jpbrucker.net/git/qemu/log/?h=cpuhp/devel    
>
> Jean-Philippe Brucker (5):
>   KVM: arm64: Replace power_off with mp_state in struct kvm_vcpu_arch
>   KVM: arm64: Move WFI execution to check_vcpu_requests()
>   KVM: arm64: Allow userspace to request WFI
>   KVM: arm64: Pass hypercalls to userspace
>   KVM: arm64: Pass PSCI calls to userspace
>
>  Documentation/virt/kvm/api.rst      | 46 +++++++++++++++----
>  Documentation/virt/kvm/arm/psci.rst |  1 +
>  arch/arm64/include/asm/kvm_host.h   | 10 +++-
>  include/kvm/arm_hypercalls.h        |  1 +
>  include/kvm/arm_psci.h              |  4 ++
>  include/uapi/linux/kvm.h            |  3 ++
>  arch/arm64/kvm/arm.c                | 71 +++++++++++++++++++++--------
>  arch/arm64/kvm/handle_exit.c        |  3 +-
>  arch/arm64/kvm/hypercalls.c         | 28 +++++++++++-
>  arch/arm64/kvm/psci.c               | 69 ++++++++++++++--------------
>  10 files changed, 170 insertions(+), 66 deletions(-)
>
